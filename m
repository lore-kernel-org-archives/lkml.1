Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbYEOJxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbYEOJxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 05:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753912AbYEOJxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 05:53:16 -0400
Received: from adnil.foobar.fi ([81.17.206.99]:50907 "EHLO ikijono.foobar.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757063AbYEOJxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 05:53:11 -0400
Message-ID: <482C0801.7030007@bluegiga.com>
Date: Thu, 15 May 2008 12:53:05 +0300
From: "Kim B. Heino" <Kim.Heino@bluegiga.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20080501)
MIME-Version: 1.0
To: rtc-linux@googlegroups.com, a.zummo@towertech.it
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] add support for ST M41T94 SPI RTC (patch rev. 2)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds kernel driver for M41T94 RTC chip connected via SPI.
I've tested it on two different AT91-based hardwares.

This is second revision of the patch: support for century bit added,
some comments made by Alessandro Zummo fixed.

Signed-off-by: Kim B. Heino <Kim.Heino@bluegiga.com>


diff -urN orig/drivers/rtc/Kconfig linux-2.6.25/drivers/rtc/Kconfig
--- orig/drivers/rtc/Kconfig	2008-04-17 05:49:44.000000000 +0300
+++ linux-2.6.25/drivers/rtc/Kconfig	2008-05-14 16:58:58.000000000 +0300
@@ -266,6 +266,15 @@
 
 if SPI_MASTER
 
+config RTC_DRV_M41T94
+	tristate "ST M41T94"
+	help
+	  If you say yes here you will get support for the
+	  ST M41T94 SPI RTC chip.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-m41t94.
+
 config RTC_DRV_MAX6902
 	tristate "Maxim MAX6902"
 	help
diff -urN orig/drivers/rtc/Makefile linux-2.6.25/drivers/rtc/Makefile
--- orig/drivers/rtc/Makefile	2008-04-17 05:49:44.000000000 +0300
+++ linux-2.6.25/drivers/rtc/Makefile	2008-05-14 16:58:58.000000000 +0300
@@ -33,6 +33,7 @@
 obj-$(CONFIG_RTC_DRV_EP93XX)	+= rtc-ep93xx.o
 obj-$(CONFIG_RTC_DRV_ISL1208)	+= rtc-isl1208.o
 obj-$(CONFIG_RTC_DRV_M41T80)	+= rtc-m41t80.o
+obj-$(CONFIG_RTC_DRV_M41T94)	+= rtc-m41t94.o
 obj-$(CONFIG_RTC_DRV_M48T59)	+= rtc-m48t59.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_DRV_MAX6900)	+= rtc-max6900.o
diff -urN orig/drivers/rtc/rtc-m41t94.c linux-2.6.25/drivers/rtc/rtc-m41t94.c
--- orig/drivers/rtc/rtc-m41t94.c	1970-01-01 02:00:00.000000000 +0200
+++ linux-2.6.25/drivers/rtc/rtc-m41t94.c	2008-05-14 16:59:09.000000000 +0300
@@ -0,0 +1,188 @@
+/*
+ * Driver for ST M41T94 SPI RTC
+ *
+ * Copyright (C) 2008 Kim B. Heino
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/rtc.h>
+#include <linux/spi/spi.h>
+#include <linux/bcd.h>
+
+#define M41T94_REG_SECONDS	0x01
+#define M41T94_REG_MINUTES	0x02
+#define M41T94_REG_HOURS	0x03
+#define M41T94_REG_WDAY		0x04
+#define M41T94_REG_DAY		0x05
+#define M41T94_REG_MONTH	0x06
+#define M41T94_REG_YEAR		0x07
+#define M41T94_REG_HT		0x0c
+
+#define M41T94_BIT_HALT		0x40
+#define M41T94_BIT_STOP		0x80
+#define M41T94_BIT_CB		0x40
+#define M41T94_BIT_CEB		0x80
+
+struct m41t94 {
+	struct rtc_device *rtc;
+};
+
+static int m41t94_set_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 buf[8]; /* write cmd + 7 registers */
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		"write", tm->tm_sec, tm->tm_min,
+		tm->tm_hour, tm->tm_mday,
+		tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	buf[0] = 0x80 | M41T94_REG_SECONDS; /* write time + date */
+	buf[M41T94_REG_SECONDS] = BIN2BCD(tm->tm_sec);
+	buf[M41T94_REG_MINUTES] = BIN2BCD(tm->tm_min);
+	buf[M41T94_REG_HOURS]   = BIN2BCD(tm->tm_hour);
+	buf[M41T94_REG_WDAY]    = BIN2BCD(tm->tm_wday + 1);
+	buf[M41T94_REG_DAY]     = BIN2BCD(tm->tm_mday);
+	buf[M41T94_REG_MONTH]   = BIN2BCD(tm->tm_mon + 1);
+
+	buf[M41T94_REG_HOURS] |= M41T94_BIT_CEB;
+	if (tm->tm_year >= 100)
+		buf[M41T94_REG_HOURS] |= M41T94_BIT_CB;
+	buf[M41T94_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+
+	return spi_write(spi, buf, 8);
+}
+
+static int m41t94_read_time(struct device *dev, struct rtc_time *tm)
+{
+	struct spi_device *spi = to_spi_device(dev);
+	u8 buf[2];
+	int ret, hour;
+
+	/* clear halt update bit */
+	ret = spi_w8r8(spi, M41T94_REG_HT);
+	if (ret < 0)
+		return ret;
+	if (ret & M41T94_BIT_HALT) {
+		buf[0] = 0x80 | M41T94_REG_HT;
+		buf[1] = ret & ~M41T94_BIT_HALT;
+		spi_write(spi, buf, 2);
+	}
+
+	/* clear stop bit */
+	ret = spi_w8r8(spi, M41T94_REG_SECONDS);
+	if (ret < 0)
+		return ret;
+	if (ret & M41T94_BIT_STOP) {
+		buf[0] = 0x80 | M41T94_REG_SECONDS;
+		buf[1] = ret & ~M41T94_BIT_STOP;
+		spi_write(spi, buf, 2);
+	}
+
+	tm->tm_sec  = BCD2BIN(spi_w8r8(spi, M41T94_REG_SECONDS));
+	tm->tm_min  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MINUTES));
+	hour = spi_w8r8(spi, M41T94_REG_HOURS);
+	tm->tm_hour = BCD2BIN(hour & 0x3f);
+	tm->tm_wday = BCD2BIN(spi_w8r8(spi, M41T94_REG_WDAY)) - 1;
+	tm->tm_mday = BCD2BIN(spi_w8r8(spi, M41T94_REG_DAY));
+	tm->tm_mon  = BCD2BIN(spi_w8r8(spi, M41T94_REG_MONTH)) - 1;
+	tm->tm_year = BCD2BIN(spi_w8r8(spi, M41T94_REG_YEAR));
+	if ((hour & M41T94_BIT_CB) || !(hour & M41T94_BIT_CEB))
+		tm->tm_year += 100;
+
+	dev_dbg(dev, "%s secs=%d, mins=%d, "
+		"hours=%d, mday=%d, mon=%d, year=%d, wday=%d\n",
+		"read", tm->tm_sec, tm->tm_min,
+		tm->tm_hour, tm->tm_mday,
+		tm->tm_mon, tm->tm_year, tm->tm_wday);
+
+	/* initial clock setting can be undefined */
+	return rtc_valid_tm(tm);
+}
+
+static const struct rtc_class_ops m41t94_rtc_ops = {
+	.read_time	= m41t94_read_time,
+	.set_time	= m41t94_set_time,
+};
+
+static struct spi_driver m41t94_driver;
+
+static int __devinit m41t94_probe(struct spi_device *spi)
+{
+	struct rtc_device *rtc;
+	struct m41t94 *m41t94;
+	int res;
+
+	m41t94 = kzalloc(sizeof(struct m41t94), GFP_KERNEL);
+	if (!m41t94)
+		return -ENOMEM;
+	dev_set_drvdata(&spi->dev, m41t94);
+
+	spi->bits_per_word = 8;
+	spi_setup(spi);
+
+	res = spi_w8r8(spi, M41T94_REG_SECONDS);
+	if (res < 0) {
+		dev_err(&spi->dev, "not found.\n");
+		kfree(m41t94);
+		return res;
+	}
+
+	rtc = rtc_device_register(m41t94_driver.driver.name,
+		&spi->dev, &m41t94_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		kfree(m41t94);
+		return PTR_ERR(rtc);
+	}
+
+	m41t94->rtc = rtc;
+
+	return 0;
+}
+
+static int __devexit m41t94_remove(struct spi_device *spi)
+{
+	struct m41t94 *m41t94 = platform_get_drvdata(spi);
+	struct rtc_device *rtc = m41t94->rtc;
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+	kfree(m41t94);
+
+	return 0;
+}
+
+static struct spi_driver m41t94_driver = {
+	.driver = {
+		.name	= "rtc-m41t94",
+		.bus	= &spi_bus_type,
+		.owner	= THIS_MODULE,
+	},
+	.probe	= m41t94_probe,
+	.remove = __devexit_p(m41t94_remove),
+};
+
+static __init int m41t94_init(void)
+{
+	return spi_register_driver(&m41t94_driver);
+}
+
+module_init(m41t94_init);
+
+static __exit void m41t94_exit(void)
+{
+	spi_unregister_driver(&m41t94_driver);
+}
+
+module_exit(m41t94_exit);
+
+MODULE_AUTHOR("Kim B. Heino <Kim.Heino@bluegiga.com>");
+MODULE_DESCRIPTION("Driver for ST M41T94 SPI RTC");
+MODULE_LICENSE("GPL");
