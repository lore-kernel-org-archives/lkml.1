Return-Path: <linux-kernel-owner+w=401wt.eu-S1752831AbYJTLxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831AbYJTLxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 07:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751857AbYJTLxj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 07:53:39 -0400
Received: from mercuryimc.plus.com ([80.229.200.144]:38777 "EHLO
	mimc.mimc.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751830AbYJTLxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 07:53:38 -0400
Message-ID: <48FC6F80.7030401@mimc.co.uk>
Date: Mon, 20 Oct 2008 12:46:08 +0100
From: Mark Jackson <mpfj@mimc.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: dbrownell@users.sourceforge.net
CC: lkml <linux-kernel@vger.kernel.org>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com, spi-devel-general@lists.sourceforge.net
Subject: [PATCH v3] Add Dallas DS1390 RTC chip
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v3 of this patch with some code tidying as per previous comments.
Also only a single tx/rx buffer is used.

This patch adds support for the Dallas DS1390 SPI RTC chip.

Signed-off-by: Mark Jackson <mpfj@mimc.co.uk>
---

 drivers/rtc/Kconfig      |   14 +++
 drivers/rtc/Makefile     |    1 +
 drivers/rtc/rtc-ds1390.c |  256 ++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 271 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 9a9755c..7ec6abb 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -292,6 +292,20 @@ config RTC_DRV_DS1305
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1305.
 
+config RTC_DRV_DS1390
+	tristate "Dallas/Maxim DS1390"
+	help
+	  If you say yes here you get support for the DS1390 and probably
+	  other chips connected with SPI.
+
+	  The first seven registers on these chips hold an RTC, and other
+	  registers may add features such as NVRAM, a trickle charger for
+	  the RTC/NVRAM backup power, and alarms.  This driver may not
+	  expose all those available chip features.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-ds1390.
+
 config RTC_DRV_MAX6902
 	tristate "Maxim MAX6902"
 	help
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index 18622ef..6306900 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -27,6 +27,7 @@ obj-$(CONFIG_RTC_DRV_DS1302)	+= rtc-ds1302.o
 obj-$(CONFIG_RTC_DRV_DS1305)	+= rtc-ds1305.o
 obj-$(CONFIG_RTC_DRV_DS1307)	+= rtc-ds1307.o
 obj-$(CONFIG_RTC_DRV_DS1374)	+= rtc-ds1374.o
+obj-$(CONFIG_RTC_DRV_DS1390)	+= rtc-ds1390.o
 obj-$(CONFIG_RTC_DRV_DS1511)	+= rtc-ds1511.o
 obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
 obj-$(CONFIG_RTC_DRV_DS1672)	+= rtc-ds1672.o
diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
new file mode 100644
index 0000000..30f2fd8
--- /dev/null
+++ b/drivers/rtc/rtc-ds1390.c
@@ -0,0 +1,256 @@
+/* drivers/rtc/rtc-ds1390.c
+ *
+ * Copyright (C) 2008 Mercury IMC Ltd
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * Driver for DS1390 SPI RTC
+ *
+ * Changelog:
+ *
+ * 04-Apr-2008: Mark Jackson <mpfj@mimc.co.uk>
+ *		- Initial version based on rtc-max6902
+ *		- No alarm support though !!
+ */
+
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/spi/spi.h>
+#include <linux/bcd.h>
+
+#define DS1390_REG_100THS		0x00
+#define DS1390_REG_SECONDS		0x01
+#define DS1390_REG_MINUTES		0x02
+#define DS1390_REG_HOURS		0x03
+#define DS1390_REG_DAY			0x04
+#define DS1390_REG_DATE			0x05
+#define DS1390_REG_MONTH_CENT		0x06
+#define DS1390_REG_YEAR			0x07
+
+#define DS1390_REG_ALARM_100THS		0x08
+#define DS1390_REG_ALARM_SECONDS	0x09
+#define DS1390_REG_ALARM_MINUTES	0x0A
+#define DS1390_REG_ALARM_HOURS		0x0B
+#define DS1390_REG_ALARM_DAY_DATE	0x0C
+
+#define DS1390_REG_CONTROL		0x0D
+#define DS1390_REG_STATUS		0x0E
+#define DS1390_REG_TRICKLE		0x0F
+
+struct ds1390 {
+	struct rtc_device *rtc;
+	u8 txrx_buf[9];	/* cmd + 8 registers */
+};
+
+static void ds1390_set_reg(struct device *dev, unsigned char address,
+				unsigned char data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	unsigned char buf[2];
+
+	/* MSB must be '1' to write */
+	buf[0] = address | 0x80;
+	buf[1] = data;
+
+	spi_write(spi, buf, 2);
+}
+
+static int ds1390_get_reg(struct device *dev, unsigned char address,
+				unsigned char *data)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct ds1390 *chip = dev_get_drvdata(dev);
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int status;
+
+	if (!data)
+		return -EINVAL;
+
+	/* Build our spi message */
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+	xfer.len = 2;
+	/* Can tx_buf and rx_buf be equal? Yes... */
+	xfer.tx_buf = chip->txrx_buf;
+	xfer.rx_buf = chip->txrx_buf;
+
+	/* Clear MSB to indicate read */
+	chip->txrx_buf[0] = address & 0x7f;
+
+	spi_message_add_tail(&xfer, &message);
+
+	/* do the i/o */
+	status = spi_sync(spi, &message);
+	if (status != 0)
+		return status;
+
+	*data = chip->txrx_buf[1];
+
+	return message.status;
+}
+
+static int ds1390_get_datetime(struct device *dev, struct rtc_time *dt)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct ds1390 *chip = dev_get_drvdata(dev);
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int status;
+
+	/* build the message */
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+	xfer.len = 1 + 7;	/* read command + 7 registers */
+	xfer.tx_buf = chip->txrx_buf;
+	xfer.rx_buf = chip->txrx_buf;
+	chip->txrx_buf[0] = DS1390_REG_SECONDS;
+	spi_message_add_tail(&xfer, &message);
+
+	/* do the i/o */
+	status = spi_sync(spi, &message);
+	if (status != 0)
+		return status;
+
+	/* The chip sends data in this order:
+	 * Seconds, Minutes, Hours, Day, Date, Month / Century, Year */
+	dt->tm_sec	= bcd2bin(chip->txrx_buf[1]);
+	dt->tm_min	= bcd2bin(chip->txrx_buf[2]);
+	dt->tm_hour	= bcd2bin(chip->txrx_buf[3]);
+	dt->tm_wday	= bcd2bin(chip->txrx_buf[4]);
+	dt->tm_mday	= bcd2bin(chip->txrx_buf[5]);
+	/* mask off century bit */
+	dt->tm_mon	= bcd2bin(chip->txrx_buf[6] & 0x7f) - 1;
+	/* adjust for century bit */
+	dt->tm_year = bcd2bin(chip->txrx_buf[7]) + ((chip->txrx_buf[6] & 0x80) ? 100 : 0);
+
+	return 0;
+}
+
+static int ds1390_set_datetime(struct device *dev, struct rtc_time *dt)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	struct ds1390 *chip = dev_get_drvdata(dev);
+	struct spi_message message;
+	struct spi_transfer xfer;
+	int status;
+
+	/* build the message */
+	spi_message_init(&message);
+	memset(&xfer, 0, sizeof(xfer));
+	xfer.len = 1 + 8;	/* write command + 8 registers */
+	xfer.tx_buf = chip->txrx_buf;
+	xfer.rx_buf = chip->txrx_buf;
+	chip->txrx_buf[0] = DS1390_REG_SECONDS | 0x80;
+	chip->txrx_buf[1] = bin2bcd(dt->tm_sec);
+	chip->txrx_buf[2] = bin2bcd(dt->tm_min);
+	chip->txrx_buf[3] = bin2bcd(dt->tm_hour);
+	chip->txrx_buf[4] = bin2bcd(dt->tm_wday);
+	chip->txrx_buf[5] = bin2bcd(dt->tm_mday);
+	chip->txrx_buf[6] = bin2bcd(dt->tm_mon + 1) |
+				((dt->tm_year > 99) ? 0x80 : 0x00);
+	chip->txrx_buf[7] = bin2bcd(dt->tm_year % 100);
+	spi_message_add_tail(&xfer, &message);
+
+	/* do the i/o */
+	status = spi_sync(spi, &message);
+	if (status == 0)
+		return message.status;
+
+	return 0;
+}
+
+static int ds1390_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return ds1390_get_datetime(dev, tm);
+}
+
+static int ds1390_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return ds1390_set_datetime(dev, tm);
+}
+
+static const struct rtc_class_ops ds1390_rtc_ops = {
+	.read_time	= ds1390_read_time,
+	.set_time	= ds1390_set_time,
+};
+
+static int __devinit ds1390_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	unsigned char tmp;
+	struct ds1390 *chip;
+	int res;
+
+	printk(KERN_DEBUG "DS1390 SPI RTC driver\n");
+
+	rtc = rtc_device_register("ds1390",
+				&spi->dev, &ds1390_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		printk(KERN_ALERT "RTC : unable to register device\n");
+		return PTR_ERR(rtc);
+	}
+
+	spi->mode = SPI_MODE_3;
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	chip = kzalloc(sizeof *chip, GFP_KERNEL);
+	if (!chip) {
+		printk(KERN_ALERT "RTC : unable to allocate device memory\n");
+		rtc_device_unregister(rtc);
+		return -ENOMEM;
+	}
+	chip->rtc = rtc;
+	dev_set_drvdata(&spi->dev, chip);
+
+	res = ds1390_get_reg(&spi->dev, DS1390_REG_SECONDS, &tmp);
+	if (res) {
+		printk(KERN_ALERT "RTC : unable to read device\n");
+		rtc_device_unregister(rtc);
+		return res;
+	}
+
+	return 0;
+}
+
+static int __devexit ds1390_remove(struct spi_device *spi)
+{
+	struct ds1390 *chip = platform_get_drvdata(spi);
+	struct rtc_device *rtc = chip->rtc;
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+
+	kfree(chip);
+
+	return 0;
+}
+
+static struct spi_driver ds1390_driver = {
+	.driver = {
+		.name	= "rtc-ds1390",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= ds1390_probe,
+	.remove = __devexit_p(ds1390_remove),
+};
+
+static __init int ds1390_init(void)
+{
+	return spi_register_driver(&ds1390_driver);
+}
+module_init(ds1390_init);
+
+static __exit void ds1390_exit(void)
+{
+	spi_unregister_driver(&ds1390_driver);
+}
+module_exit(ds1390_exit);
+
+MODULE_DESCRIPTION("DS1390 SPI RTC driver");
+MODULE_AUTHOR("Mark Jackson <mpfj@mimc.co.uk>");
+MODULE_LICENSE("GPL");
