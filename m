Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbYJNIR0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbYJNIR0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 04:17:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYJNIRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 04:17:13 -0400
Received: from mx0.towertech.it ([213.215.222.73]:51183 "HELO mx0.towertech.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752706AbYJNIRK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 04:17:10 -0400
Date: Tue, 14 Oct 2008 10:17:03 +0200
From: Alessandro Zummo <alessandro.zummo@towertech.it>
To: Mark Jackson <mpfj@mimc.co.uk>
Cc: <rtc-linux@googlegroups.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add Dallas DS1390 RTC chip
Message-ID: <20081014101703.1ded0259@i1501.lan.towertech.it>
In-Reply-To: <48F452BE.2030901@mimc.co.uk>
References: <48F452BE.2030901@mimc.co.uk>
Organization: Tower Technologies
X-Mailer: Sylpheed
X-This-Is-A-Real-Message: Yes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Oct 2008 09:05:18 +0100
Mark Jackson <mpfj@mimc.co.uk> wrote:

 Hi Mark,

   a few notes below:

> +#include <linux/module.h>
> +#include <linux/version.h>
> +
> +#include <linux/kernel.h>
> +#include <linux/platform_device.h>
> +#include <linux/init.h>
> +#include <linux/rtc.h>
> +#include <linux/spi/spi.h>
> +#include <linux/bcd.h>
> +#include <linux/delay.h>

 Please check that you require all of those includes.


> +struct ds1390
> +{
> +	struct rtc_device *rtc;
> +	u8 buf[9];	/* cmd + 8 registers */
> +	u8 tx_buf[2];
> +	u8 rx_buf[2];
> +};
> +
> +static void ds1390_set_reg(struct device *dev, unsigned char address,
> +				unsigned char data)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	unsigned char buf[2];
> +
> +	/* MSB must be '1' to write */
> +	buf[0] = address | 0x80;
> +	buf[1] = data;
> +
> +	spi_write(spi, buf, 2);
> +}
> +
> +static int ds1390_get_reg(struct device *dev, unsigned char address,
> +				unsigned char *data)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct ds1390 *chip = dev_get_drvdata(dev);
> +	struct spi_message message;
> +	struct spi_transfer xfer;
> +	int status;
> +
> +	if (!data)
> +		return -EINVAL;
> +
> +	/* Build our spi message */
> +	spi_message_init(&message);
> +	memset(&xfer, 0, sizeof(xfer));
> +	xfer.len = 2;
> +	/* Can tx_buf and rx_buf be equal? The doc in spi.h is not sure... */
> +	xfer.tx_buf = chip->tx_buf;
> +	xfer.rx_buf = chip->rx_buf;

 you use the same buffer a few functions below. either
 one way or the other. please investigate with the spi subsystem maintainer.


> +
> +	/* Clear MSB to indicate read */
> +	chip->tx_buf[0] = address & 0x7f;
> +
> +	spi_message_add_tail(&xfer, &message);
> +
> +	/* do the i/o */
> +	status = spi_sync(spi, &message);
> +	if (status == 0)
> +	{
> +		status = message.status;
> +	}
> +	else
> +	{
> +		return status;
> +	}

 should be cleaner in this way:

 if (status != 0)
	return status;

 *data = chip->rx_buf[1];

 return message.status;


> +static int ds1390_get_datetime(struct device *dev, struct rtc_time *dt)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct ds1390 *chip = dev_get_drvdata(dev);
> +	struct spi_message message;
> +	struct spi_transfer xfer;
> +	int status;
> +
> +	/* build the message */
> +	spi_message_init(&message);
> +	memset(&xfer, 0, sizeof(xfer));
> +	xfer.len = 1 + 7;	/* read command + 7 registers */
> +	xfer.tx_buf = chip->buf;
> +	xfer.rx_buf = chip->buf;

 the buffer mentioned above.


> +	chip->buf[0] = DS1390_REG_SECONDS;
> +	spi_message_add_tail(&xfer, &message);
> +
> +	/* do the i/o */
> +	status = spi_sync(spi, &message);
> +	if (status == 0)
> +	{
> +		status = message.status;
> +	}
> +	else
> +	{
> +		return status;
> +	}

 ditto.

> +	/* The chip sends data in this order:
> +	 * Seconds, Minutes, Hours, Day, Date, Month / Century, Year */
> +	dt->tm_sec	= BCD2BIN(chip->buf[1]);
> +	dt->tm_min	= BCD2BIN(chip->buf[2]);
> +	dt->tm_hour	= BCD2BIN(chip->buf[3]);
> +	dt->tm_wday	= BCD2BIN(chip->buf[4]);
> +	dt->tm_mday	= BCD2BIN(chip->buf[5]);
> +	/* mask off century bit */
> +	dt->tm_mon	= BCD2BIN(chip->buf[6] & 0x7f) - 1;
> +	/* adjust for century bit */
> +	dt->tm_year = BCD2BIN(chip->buf[7]) + ((chip->buf[6] & 0x80) ? 100 : 0);
> +
> +	return 0;
> +}
> +
> +static int ds1390_set_datetime(struct device *dev, struct rtc_time *dt)
> +{
> +	struct spi_device *spi = to_spi_device(dev);
> +	struct ds1390 *chip = dev_get_drvdata(dev);
> +	struct spi_message message;
> +	struct spi_transfer xfer;
> +	int status;
> +
> +	/* build the message */
> +	spi_message_init(&message);
> +	memset(&xfer, 0, sizeof(xfer));
> +	xfer.len = 1 + 8;	/* write command + 8 registers */
> +	xfer.tx_buf = chip->buf;
> +	xfer.rx_buf = chip->buf;
> +	chip->buf[0] = DS1390_REG_SECONDS | 0x80;
> +	chip->buf[1] = BIN2BCD(dt->tm_sec);
> +	chip->buf[2] = BIN2BCD(dt->tm_min);
> +	chip->buf[3] = BIN2BCD(dt->tm_hour);
> +	chip->buf[4] = BIN2BCD(dt->tm_wday);
> +	chip->buf[5] = BIN2BCD(dt->tm_mday);
> +	chip->buf[6] = BIN2BCD(dt->tm_mon + 1) | ((dt->tm_year > 99) ? 0x80 : 0x00);
> +	chip->buf[7] = BIN2BCD(dt->tm_year % 100);
> +	spi_message_add_tail(&xfer, &message);
> +
> +	/* do the i/o */
> +	status = spi_sync(spi, &message);
> +	if (status == 0)
> +	{
> +		status = message.status;
> +	}
> +	else
> +	{
> +		return status;
> +	}

 if status == 0, status is not used anymore, so you can
 just return if != 0;

> +	return 0;
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
> +	printk("DS1390 SPI RTC driver\n");
> +
> +	rtc = rtc_device_register("ds1390",
> +				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
> +	if (IS_ERR(rtc))
> +	{
> +		printk("RTC : unable to register device\n");
> +		return PTR_ERR(rtc);
> +	}
> +
> +	spi->mode = SPI_MODE_3;
> +	spi->bits_per_word = 8;
> +	spi_setup(spi);
> +
> +	chip = kzalloc(sizeof *chip, GFP_KERNEL);
> +	if (!chip) {
> +		printk("RTC : unable to allocate device memory\n");
> +		rtc_device_unregister(rtc);
> +		return -ENOMEM;
> +	}
> +	chip->rtc = rtc;
> +	dev_set_drvdata(&spi->dev, chip);
> +
> +	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
> +	if (res) {
> +		printk("RTC : unable to read device\n");
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
> +		.bus	= &spi_bus_type,
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
> +MODULE_DESCRIPTION ("DS1390 SPI RTC driver");
> +MODULE_AUTHOR ("Mark Jackson");

 you email here please.

> +MODULE_LICENSE ("GPL");


-- 

 Best regards,

 Alessandro Zummo,
  Tower Technologies - Torino, Italy

  http://www.towertech.it

