Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbYJUWjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbYJUWjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYJUWi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:38:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42487 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbYJUWi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:38:57 -0400
Date: Tue, 21 Oct 2008 15:37:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mark Jackson <mpfj@mimc.co.uk>
Cc: dbrownell@users.sourceforge.net, linux-kernel@vger.kernel.org,
       alessandro.zummo@towertech.it, rtc-linux@googlegroups.com,
       spi-devel-general@lists.sourceforge.net
Subject: Re: [PATCH v4] Add Dallas DS1390/93/94 RTC chips
Message-Id: <20081021153752.7d79cba2.akpm@linux-foundation.org>
In-Reply-To: <48FDBFF9.2020901@mimc.co.uk>
References: <48FDBFF9.2020901@mimc.co.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2008 12:41:45 +0100
Mark Jackson <mpfj@mimc.co.uk> wrote:

> v4 of this patch with some code tidying as per previous comments.
> Also only a single tx/rx buffer is used.
> Now uses spi_write_then_read()
> Comments changed to include extra chips in the family
> 
> This patch adds support for the Dallas DS1390/93/94 SPI RTC chip.
> 

A neat-looking driver.  Some nitlets:

> +
> +#define DS1390_REG_ALARM_100THS		0x08
> +#define DS1390_REG_ALARM_SECONDS	0x09
> +#define DS1390_REG_ALARM_MINUTES	0x0A
> +#define DS1390_REG_ALARM_HOURS		0x0B
> +#define DS1390_REG_ALARM_DAY_DATE	0x0C
> +
> +#define DS1390_REG_CONTROL		0x0D
> +#define DS1390_REG_STATUS		0x0E
> +#define DS1390_REG_TRICKLE		0x0F
> +
> +struct ds1390 {
> +	struct rtc_device *rtc;
> +	u8 txrx_buf[9];	/* cmd + 8 registers */
> +};
> +
> +static void ds1390_set_reg(struct device *dev, unsigned char address,
> +				unsigned char data)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct ds1390 *chip = dev_get_drvdata(dev);
> +
> +	/* Set MSB to indicate write */
> +	chip->txrx_buf[0] = address | 0x80;
> +	chip->txrx_buf[1] = data;
> +
> +	/* do the i/o */
> +	spi_write_then_read(spi, chip->txrx_buf, 2, NULL, 0);
> +}
> +
> +static int ds1390_get_reg(struct device *dev, unsigned char address,
> +				unsigned char *data)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct ds1390 *chip = dev_get_drvdata(dev);
> +	int status;
> +
> +	if (!data)
> +		return -EINVAL;

This function only has one caller and that caller doesn't pass NULL, so
this test is unneeded.

> +	/* Clear MSB to indicate read */
> +	chip->txrx_buf[0] = address & 0x7f;
> +	/* do the i/o */
> +	status = spi_write_then_read(spi, chip->txrx_buf, 1, chip->txrx_buf, 1);
> +	if (status != 0)
> +		return status;
> +
> +	*data = chip->txrx_buf[1];
> +
> +	return 0;
> +}
> +
> +static int ds1390_get_datetime(struct device *dev, struct rtc_time *dt)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct ds1390 *chip = dev_get_drvdata(dev);
> +	int status;
> +
> +	/* build the message */
> +	chip->txrx_buf[0] = DS1390_REG_SECONDS;
> +
> +	/* do the i/o */
> +	status = spi_write_then_read(spi, chip->txrx_buf, 1, chip->txrx_buf, 8);
> +	if (status != 0)
> +		return status;
> +
> +	/* The chip sends data in this order:
> +	 * Seconds, Minutes, Hours, Day, Date, Month / Century, Year */
> +	dt->tm_sec	= bcd2bin(chip->txrx_buf[0]);
> +	dt->tm_min	= bcd2bin(chip->txrx_buf[1]);
> +	dt->tm_hour	= bcd2bin(chip->txrx_buf[2]);
> +	dt->tm_wday	= bcd2bin(chip->txrx_buf[3]);
> +	dt->tm_mday	= bcd2bin(chip->txrx_buf[4]);
> +	/* mask off century bit */
> +	dt->tm_mon	= bcd2bin(chip->txrx_buf[5] & 0x7f) - 1;
> +	/* adjust for century bit */
> +	dt->tm_year = bcd2bin(chip->txrx_buf[6]) + ((chip->txrx_buf[5] & 0x80) ? 100 : 0);
> +
> +	return rtc_valid_tm(dt);
> +}
> +
> +static int ds1390_set_datetime(struct device *dev, struct rtc_time *dt)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct ds1390 *chip = dev_get_drvdata(dev);
> +
> +	/* build the message */
> +	chip->txrx_buf[0] = DS1390_REG_SECONDS | 0x80;
> +	chip->txrx_buf[1] = bin2bcd(dt->tm_sec);
> +	chip->txrx_buf[2] = bin2bcd(dt->tm_min);
> +	chip->txrx_buf[3] = bin2bcd(dt->tm_hour);
> +	chip->txrx_buf[4] = bin2bcd(dt->tm_wday);
> +	chip->txrx_buf[5] = bin2bcd(dt->tm_mday);
> +	chip->txrx_buf[6] = bin2bcd(dt->tm_mon + 1) |
> +				((dt->tm_year > 99) ? 0x80 : 0x00);
> +	chip->txrx_buf[7] = bin2bcd(dt->tm_year % 100);
> +
> +	/* do the i/o */
> +	return spi_write_then_read(spi, chip->txrx_buf, 8, NULL, 0);
> +}
> +
> +static int ds1390_read_time(struct device *dev, struct rtc_time *tm)
> +{
> +	return ds1390_get_datetime(dev, tm);
> +}
> +
> +static int ds1390_set_time(struct device *dev, struct rtc_time *tm)
> +{
> +	return ds1390_set_datetime(dev, tm);
> +}
> +
> +static const struct rtc_class_ops ds1390_rtc_ops = {
> +	.read_time	= ds1390_read_time,
> +	.set_time	= ds1390_set_time,
> +};
> +
> +static int __devinit ds1390_probe(struct spi_device *spi)
> +{
> +	struct rtc_device *rtc;
> +	unsigned char tmp;
> +	struct ds1390 *chip;
> +	int res;
> +
> +	printk(KERN_DEBUG "DS1390 SPI RTC driver\n");

Should be KERN_INFO I guess.

> +	rtc = rtc_device_register("ds1390",
> +				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(rtc)) {
> +		printk(KERN_ALERT "RTC : unable to register device\n");
> +		return PTR_ERR(rtc);
> +	}
> +
> +	spi->mode = SPI_MODE_3;
> +	spi->bits_per_word = 8;
> +	spi_setup(spi);
> +
> +	chip = kzalloc(sizeof *chip, GFP_KERNEL);
> +	if (!chip) {
> +		printk(KERN_ALERT "RTC : unable to allocate device memory\n");
> +		rtc_device_unregister(rtc);
> +		return -ENOMEM;
> +	}
> +	chip->rtc = rtc;
> +	dev_set_drvdata(&spi->dev, chip);
> +
> +	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
> +	if (res) {
> +		printk(KERN_ALERT "RTC : unable to read device\n");

- Perhaps the "RTC" should identify which driver is doing the
  shouting.  We have a huge number of "rtc" drivers, so this message
  will be rather ambiguous.

- Colons are not preceded by spaces in written English.

> +		rtc_device_unregister(rtc);
> +		return res;
> +	}
> +
> +	return 0;
> +}
> +
> +static int __devexit ds1390_remove(struct spi_device *spi)
> +{
> +	struct ds1390 *chip = platform_get_drvdata(spi);
> +	struct rtc_device *rtc = chip->rtc;
> +
> +	if (rtc)
> +		rtc_device_unregister(rtc);
> +
> +	kfree(chip);
> +
> +	return 0;
> +}
> +
> +static struct spi_driver ds1390_driver = {
> +	.driver = {
> +		.name	= "rtc-ds1390",
> +		.owner	= THIS_MODULE,
> +	},
> +	.probe	= ds1390_probe,
> +	.remove = __devexit_p(ds1390_remove),
> +};
> +
> +static __init int ds1390_init(void)
> +{
> +	return spi_register_driver(&ds1390_driver);
> +}
> +module_init(ds1390_init);
> +
> +static __exit void ds1390_exit(void)
> +{
> +	spi_unregister_driver(&ds1390_driver);
> +}
> +module_exit(ds1390_exit);
> +
> +MODULE_DESCRIPTION("DS1390/93/94 SPI RTC driver");
> +MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
> +MODULE_LICENSE("GPL");

