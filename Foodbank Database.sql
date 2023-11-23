-- A foodbank wants to keep better track of their food inventory and donations.
-- The database will help them to avoid food waste and ask for donations before they run out of food.

CREATE DATABASE foodbank;

USE foodbank;

-- Creating and populating tables

CREATE TABLE inventory (
	food_id INTEGER PRIMARY KEY,
	item_name VARCHAR(50) NOT NULL,
    category VARCHAR(50),
    allergens VARCHAR(50),
    price FLOAT(2)
    );

INSERT INTO inventory (food_id, item_name, category, allergens, price)
VALUES 
(110, 'Baked Beans', 'Tinned Vegetables', 'none', 0.30),
(111, 'Sweetcorn', 'Tinned Vegetables', 'none', 0.50),
(112, 'Wholemeal Bread', 'Baked Goods', 'wheat', 1.00),
(113, 'Chocolate Cereal', 'Dried Goods', 'milk', 2.50),
(114, 'Apples (Pack of 6)', 'Fresh Fruit', 'none', 1.50),
(115, 'Tuna Fish', 'Tinned Meat and Fish', 'fish', 0.98),
(116, 'Red Lentils', 'Dried Goods', 'none', 1.30),
(117, 'Diced Tomatoes', 'Tinned Vegetables', 'none', 0.22),
(118, 'Satsumas', 'Fresh Fruit', 'none', 1.18),
(119, 'Spam', 'Tinned Meat and Fish', 'meat', 1.04);

-- SELECT * FROM inventory;

CREATE TABLE stock (
	food_id INTEGER PRIMARY KEY,
	quantity INTEGER,
    donation_needed VARCHAR(5),
    FOREIGN KEY (food_id) REFERENCES inventory(food_id)
    );
    
INSERT INTO stock (food_id, quantity, donation_needed)
VALUES 
(110, 230, 'no'),
(111, 60, 'no'),
(112, 15, 'yes'),
(113, 2, 'yes'),
(114, 52, 'no'),
(115, 106, 'no'),
(116, 81, 'no'),
(117, 65, 'no'),
(118, 10, 'yes'),
(119, 72, 'no');

-- SELECT * FROM stock;

CREATE TABLE expiry (
	food_id INTEGER PRIMARY KEY,
    expiry_date VARCHAR(8) NOT NULL,
    expiry_type VARCHAR(12),
    FOREIGN KEY (food_id) REFERENCES inventory(food_id)
);

INSERT INTO expiry (food_id, expiry_date, expiry_type)
VALUES
(110, '02/08/25', 'Best Before'),
(111, '17/05/24', 'Best Before'),
(112, '04/10/23', 'Use By'),
(113, '15/12/23', 'Best Before'),
(114, '24/10/23', 'Best Before'),
(115, '11/11/24', 'Use By'),
(116, '09/03/25', 'Best Before'),
(117, '28/08/25', 'Best Before'),
(118, '10/10/23', 'Best Before'),
(119, '08/06/25', 'Best Before');

-- SELECT * FROM expiry;
    
CREATE TABLE donors (
	donor_id INTEGER PRIMARY KEY,
	donor_name VARCHAR(50),
    email VARCHAR(50) UNIQUE
	);
    
INSERT INTO donors (donor_id, donor_name, email)
VALUES 
(2234, 'Sarah Pickle', 'pickles@gmail.com'),
(2235, 'Rob Turner', 'rob456@hotmail.co.uk'),
(2236, 'Helen Alex', 'alexfarm@yahoo.com'),
(2237, 'Simon Pimm', 'spcontact@gmail.com'),
(2238, 'Ruth Kim', 'kimruth@yahoo.co.uk'),
(2239, 'Patrick Scholes', 'scholes@hotmail.com'),
(2240, 'Celia Nestle', 'celiasseas@gmail.com'),
(2241, 'Willow Wood', 'wearewillow@gmail.com'),
(2242, 'Paul Dickens', 'paulsparty@hotmail.co.uk'),
(2243, 'Mary Madison', 'm.madison@yahoo.com');

-- SELECT * FROM donors;

CREATE TABLE donations (
	donation_id INTEGER PRIMARY KEY,
	donor_id INTEGER,
    food_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    FOREIGN KEY (donor_id) REFERENCES donors(donor_id),
    FOREIGN KEY (food_id) REFERENCES inventory(food_id)
    );
  
INSERT INTO donations (donation_id, donor_id, food_id, quantity)
VALUES 
(1001, 2234, 116, 5),
(1002, 2235, 119, 19),  
(1003, 2236, 114, 23),  
(1004, 2237, 111, 4),   
(1005, 2238, 117, 2),   
(1006, 2239, 112, 12),  
(1007, 2240, 113, 7),   
(1008, 2241, 115, 30),  
(1009, 2242, 118, 21),  
(1010, 2243, 110, 40);

-- SELECT * FROM donations;

-- Using the database in various scenarios the foodbank encounters.

-- Cost of living has increased the price of apples. 
-- Update the price and check it's worked.

UPDATE inventory
SET price = 1.52
WHERE food_id = '114';

SELECT food_id, item_name, price
FROM inventory
WHERE item_name = 'Apples (Pack of 6)';

-- Helen Alex (donor) thinks she provided the wrong email and wants to correct it.
-- Find Helen's information and update her email.

SELECT donor_name, donor_id, email
FROM donors
WHERE donor_name = 'Helen Alex';

UPDATE donors
SET email = 'alexfarmhelen@yahoo.com'
WHERE donor_id = 2236;

-- Mary Madison (donor) could not fulfill her donation so it must be removed from the database.
-- She does not remember her donor ID, so first we must retrieve it and then delete her donation.
-- Stock does not need to be updated, as the donation was never received so this column was not yet updated.

SELECT donor_name, donor_id
FROM donors
WHERE donor_name = 'Mary Madison';

DELETE FROM donations
WHERE donor_id = 2243;

-- Let's check it has been deleted
-- SELECT donor_id
-- FROM donations
-- WHERE donor_id = 2243

-- A brand new donor came to drop off food for the first time.

-- Log her information

INSERT INTO donors (donor_id, donor_name, email)
VALUES 
(2244, 'Vicky Sloane', 'v.sloane1989@yahoo.com');

-- Now log her donation

INSERT INTO donations (donation_id, donor_id, food_id, quantity)
VALUES 
(1011, 2243, 110, 45);

-- Let's check it's added
-- SELECT * FROM donors;
-- SELECT * FROM donations;

-- A new brand new food item has been purchased with fundraising money. It needs to be added to the inventory.

INSERT INTO inventory (food_id, item_name, category, allergens, price)
VALUES 
(120, 'Strawberry Yoghurt Pot', 'Fresh Dairy', 'dairy', 1.35);

-- Now add to stock and update quantity.

INSERT INTO stock (food_id, quantity, donation_needed)
VALUES 
(120, 70, 'no');

-- Log expiry as well. 

INSERT INTO expiry (food_id, expiry_date, expiry_type)
VALUES
(120, '10/10/23', 'Use By');

-- Checking results
-- SELECT * FROM inventory;
-- SELECT * FROM stock;
-- SELECT * FROM expiry;

-- The food bank wants to say thank you to donors who have donated a lot of food.
-- Which donors have donated more than 20 items in total?

SELECT donor_name, email, SUM(donations.quantity) AS total_items_donated -- Adding together donations in case multiple made. Renaming for user-friendly heading.
FROM donors
INNER JOIN donations ON donors.donor_id = donations.donor_id -- We need donor info and their donations
GROUP BY donors.donor_name, donors.email
HAVING total_items_donated > 20
ORDER BY total_items_donated DESC; -- We want to see most donations first

-- The foodbank wants to encourage people to donate more. They want to emphasise donations don't have to be expensive.
-- What is the cheapest item in the inventory that people could donate more of?

SELECT item_name, price
FROM inventory
WHERE price = (SELECT MIN(price) FROM inventory);

-- The foodbank needs to make sure they're distributing food before it expires.
-- Find the expiration for food names and sort by the ones expiring first.

SELECT inventory.item_name, expiry_date -- Volunteers need name and date to sort food
FROM inventory
INNER JOIN expiry ON inventory.food_id = expiry.food_id
ORDER BY STR_TO_DATE(expiry_date, '%d/%m/%y') ASC; -- Converting date string to date for SQL to sort correctly, but keeping format for user.

-- Some of the donated sweetcorn tins are leaking and paritally open. 
-- Find out who donated sweetcorn so that an e-mail can be sent out, encouraging donors to take extra care in future.

SELECT donors.donor_name, donors.email, donations.quantity, inventory.item_name
FROM donors
INNER JOIN donations ON donors.donor_ID = donations.donor_ID -- First joining to match donor name to donation
LEFT JOIN inventory ON donations.food_ID = inventory.food_id -- Now matching donation to food names
WHERE inventory.item_name = 'Sweetcorn'
ORDER BY donor_name ASC; -- Alphabetical sort

-- The food bank wants to publish how much all of the donations they received would have cost in the shops.
-- Calculate this amount.

SELECT CAST(SUM(donations.quantity * inventory.price) AS FLOAT(2)) AS total_food_cost -- Calculating and formatting price
FROM donations
INNER JOIN inventory ON donations.food_id = inventory.food_id -- Joining as price is in inventory and donations as quantity

-- The foodbank wants to be able to update their need donation column when stock falls below 30.
-- This will help them to avoid running out of food and ask for donations.
-- Create a procedure to make it easy to review this on a daily basis.

DELIMITER //
CREATE PROCEDURE low_stock_check()
BEGIN
	UPDATE stock -- This section changes the column if stock is less than 30
    SET donation_needed = 'yes'
    WHERE quantity < 30;
    
    SELECT inventory.item_name, quantity, donation_needed -- This section displays the data so volunteers can check it easily
    FROM stock
    INNER JOIN inventory ON stock.food_id = inventory.food_id;
END;
//
DELIMITER ;

-- Let's use the procedure and have a look at which items are running low.

CALL low_stock_check();

-- The foodbank now knows what food it needs to ask for from donors.