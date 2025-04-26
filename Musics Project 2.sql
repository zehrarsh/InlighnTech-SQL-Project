use musics;
select * from employee; 
-- Q1(Easy)
SELECT 
    RTRIM(LTRIM(CONCAT(COALESCE(first_name, ''),
                            ' ',
                            COALESCE(last_name, '')))) AS 'Name of Senior Most Employee ',
    title AS TITLE
FROM
    employee
WHERE
    levels = 'L7';
-- Q2 (Easy)
SELECT 
    billing_country AS 'Country Name',
    COUNT(*) AS 'Number of Invoice'
FROM
    invoice
GROUP BY billing_country
ORDER BY 'Number of invoices' DESC
LIMIT 3;
-- Q3(Easy)
SELECT 
    *
FROM
    invoice
ORDER BY total DESC
LIMIT 3;
-- Q4(Easy)
SELECT 
    billing_city AS 'City',
    COUNT(total) AS 'Number of invoices totals in that city'
FROM
    invoice
GROUP BY billing_city
ORDER BY COUNT(total) DESC
LIMIT 1;
-- Q5(Easy)
SELECT 
    invoice.customer_id AS 'Customer ID',
    COUNT(invoice.invoice_id) AS 'Number of invoice Ids',
    SUM(invoice_line.unit_price) AS 'Money Spent'
FROM
    invoice,
    invoice_line
WHERE
    invoice.invoice_id = invoice_line.invoice_id
GROUP BY invoice.customer_id
ORDER BY SUM(invoice_line.unit_price) DESC
LIMIT 3;
-- Q1(Moderate)
SELECT 
    customer.first_name AS 'First Name of the Customer',
    customer.last_name AS 'Last Name of the customer',
    customer.email AS 'Email of the customer'
FROM
    customer
        LEFT JOIN
    invoice ON customer.customer_id = invoice.customer_id
        LEFT JOIN
    invoice_line ON invoice.invoice_id = invoice_line.invoice_id
        LEFT JOIN
    track ON invoice_line.track_id = track.track_id
        LEFT JOIN
    genre ON track.genre_id = genre.genre_id
WHERE
    genre.name = 'Rock'
GROUP BY customer.first_name , customer.last_name , customer.email
ORDER BY customer.email ASC;
-- Q2(Moderate)
SELECT 
    artist.name AS 'Artist Name',
    COUNT(track.track_id) AS 'Total Track count of Rock Bands'
FROM
    track
        LEFT JOIN
    album ON track.album_id = album.album_id
        LEFT JOIN
    artist ON album.artist_id = artist.artist_id
WHERE
    track.genre_id = 1
GROUP BY artist.name
ORDER BY COUNT(track.track_id) DESC
LIMIT 10;
-- Q3(Moderate)
SELECT 
    name AS 'Track Names',
    milliseconds AS 'Spng Length in Milliseconds'
FROM
    track
WHERE
    milliseconds > 190200
ORDER BY milliseconds DESC;
-- Q1(Advanced)
SELECT 
    CONCAT(customer.first_name,
            ' ',
            customer.last_name) AS Name,
    artist.name AS 'Artist Name',
    SUM(track.unit_price) AS 'Total Spent'
FROM
    customer
        LEFT JOIN
    invoice ON customer.customer_id = invoice.customer_id
        LEFT JOIN
    invoice_line ON invoice.invoice_id = invoice_line.invoice_id
        LEFT JOIN
    track ON invoice_line.track_id = track.track_id
        LEFT JOIN
    album ON track.album_id = album.album_id
        LEFT JOIN
    artist ON album.artist_id = artist.artist_id
GROUP BY CONCAT(customer.first_name,
        ' ',
        customer.last_name) , artist.name;
-- Q2(Advanced
select *from genre;
WITH CountryGenreSpending AS (
    SELECT
        invoice.billing_country AS Country,
        genre.name AS Genre,
        SUM(track.unit_price) AS TotalSpent,
        ROW_NUMBER() OVER (
            PARTITION BY invoice.billing_country
            ORDER BY SUM(track.unit_price) DESC
        ) AS GenreRank
    FROM customer
    JOIN invoice ON customer.customer_id = invoice.customer_id
    JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id
    JOIN track ON invoice_line.track_id = track.track_id
    JOIN genre ON track.genre_id = genre.genre_id
    GROUP BY invoice.billing_country, genre.name
)
SELECT
    Country,
    Genre AS "Top Genre",
    TotalSpent AS "Total Spent"
FROM CountryGenreSpending
WHERE GenreRank = 1
ORDER BY Country;
-- Q3(advanced)
select distinct invoice.billing_country as "Country", 
first_value (concat(customer.first_name, " ", customer.last_name)) over(partition by invoice.billing_country) as "Customer Name", 
sum(track.unit_price) as " Total Spent" from customer
 inner join invoice on customer.customer_id=invoice.customer_id 
 left join invoice_line on invoice.invoice_id=invoice_line.invoice_id
 left join track on invoice_line.track_id=track.track_id 
 group by customer.first_name, customer.last_name, invoice.billing_country;