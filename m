Return-Path: <linux-kernel-owner+w=401wt.eu-S1758489AbXFSP66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758489AbXFSP66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 11:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755927AbXFSP6w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 11:58:52 -0400
Received: from mba.ocn.ne.jp ([122.1.175.29]:52315 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674AbXFSP6u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 11:58:50 -0400
Date: Wed, 20 Jun 2007 00:59:26 +0900 (JST)
Message-Id: <20070620.005926.52130307.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, ab@mycable.de,
       mgreer@mvista.com, khali@linux-fr.org, david-b@pacbell.net
Subject: [PATCH 1/2] rtc: add rtc-m41txx driver
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a new-style i2c driver for ST M41TXX RTC chip, derived from
works by Alexander Bigga <ab@mycable.de> who wrote the original
rtc-m41txx.c based on drivers/i2c/chips/m41t00.c driver.

This driver supports M41T80, M41T81 and M41ST85.  The old m41t00
driver supports M41T00, M41T81 and M41T85(M41ST85).  While the M41T00
chip is now supported by rtc-ds1307 driver, this driver does not
include support for the chip.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Signed-off-by: Alexander Bigga <ab@mycable.de>
---
 drivers/rtc/Kconfig      |   11 ++
 drivers/rtc/Makefile     |    1 +
 drivers/rtc/rtc-m41txx.c |  362 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/m41txx.h   |   40 +++++
 4 files changed, 414 insertions(+), 0 deletions(-)

diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index 4e4c10a..c52f3ff 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -282,6 +282,17 @@ config RTC_DRV_DS1742
 	  This driver can also be built as a module. If so, the module
 	  will be called rtc-ds1742.
 
+config RTC_DRV_M41TXX
+	tristate "ST M41Txx series RTC"
+	depends on RTC_CLASS && I2C
+	help
+	  If you say Y here you will get support for the
+	  ST M41TXX RTC chips series. Currently following chips are
+	  supported: M41T80, M41T81 and M41ST85
+
+	  This driver can also be built as a module. If so, the module
+	  will be called rtc-m41txx.
+
 config RTC_DRV_M48T86
 	tristate "ST M48T86/Dallas DS12887"
 	depends on RTC_CLASS
diff --git a/drivers/rtc/Makefile b/drivers/rtc/Makefile
index a1afbc2..5ef1123 100644
--- a/drivers/rtc/Makefile
+++ b/drivers/rtc/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_RTC_DRV_PCF8583)	+= rtc-pcf8583.o
 obj-$(CONFIG_RTC_DRV_RS5C372)	+= rtc-rs5c372.o
 obj-$(CONFIG_RTC_DRV_S3C)	+= rtc-s3c.o
 obj-$(CONFIG_RTC_DRV_RS5C348)	+= rtc-rs5c348.o
+obj-$(CONFIG_RTC_DRV_M41TXX)	+= rtc-m41txx.o
 obj-$(CONFIG_RTC_DRV_M48T86)	+= rtc-m48t86.o
 obj-$(CONFIG_RTC_DRV_DS1553)	+= rtc-ds1553.o
 obj-$(CONFIG_RTC_DRV_RS5C313)	+= rtc-rs5c313.o
diff --git a/drivers/rtc/rtc-m41txx.c b/drivers/rtc/rtc-m41txx.c
new file mode 100644
index 0000000..7f05252
--- /dev/null
+++ b/drivers/rtc/rtc-m41txx.c
@@ -0,0 +1,362 @@
+/*
+ * I2C client/driver for the ST M41TXX family of i2c rtc chips.
+ *
+ * Author: Alexander Bigga <ab@mycable.de>
+ *
+ * Based on m41t00.c by Mark A. Greer <mgreer@mvista.com>
+ *
+ * 2006 (c) mycable GmbH
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/i2c.h>
+#include <linux/rtc.h>
+#include <linux/bcd.h>
+#include <linux/m41txx.h>
+
+#define M41TXX_REG_SSEC	0
+#define M41TXX_REG_SEC	1
+#define M41TXX_REG_MIN	2
+#define M41TXX_REG_HOUR	3
+#define M41TXX_REG_WDAY	4
+#define M41TXX_REG_DAY	5
+#define M41TXX_REG_MON	6
+#define M41TXX_REG_YEAR	7
+#define M41TXX_REG_ALARM_MON	0xa
+#define M41TXX_REG_ALARM_HOUR	0xc
+#define M41TXX_REG_FLAGS	0xf
+#define M41TXX_REG_SQW	0x13
+
+#define M41TXX_SEC_ST		(1 << 7)	/* ST: Stop Bit */
+#define M41TXX_ALHOUR_HT	(1 << 6)	/* HT: Halt Update Bit */
+#define M41TXX_FLAGS_BATT_LOW	(1 << 4)	/* BL: Battery Low Bit */
+
+#define M41TXX_FEATURE_HT	(1 << 0)
+#define M41TXX_FEATURE_BL	(1 << 1)
+
+#define DRV_VERSION "0.04"
+
+struct m41txx_chip_info {
+	const char *name;
+	u8 features;
+};
+
+static const struct m41txx_chip_info m41txx_chip_info_tbl[] = {
+	{ /* M41T80 */
+		.name		= "m41t80",
+		.features	= 0,
+	},
+	{ /* M41T81 */
+		.name		= "m41t81",
+		.features	= M41TXX_FEATURE_HT,
+	},
+	{ /* M41ST84/85/87/94 */
+		.name		= "m41t85",
+		.features	= M41TXX_FEATURE_HT | M41TXX_FEATURE_BL,
+	},
+};
+
+struct m41txx_data {
+	const struct m41txx_chip_info *chip;
+	struct rtc_device *rtc;
+};
+
+static int m41txx_get_datetime(struct i2c_client *client,
+			       struct rtc_time *tm)
+{
+	u8 buf[M41TXX_REG_YEAR + 1], dt_addr[1] = { M41TXX_REG_SEC };
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= dt_addr,
+		},
+		{
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= M41TXX_REG_YEAR + 1 - M41TXX_REG_SEC,
+			.buf	= buf + M41TXX_REG_SEC,
+		},
+	};
+
+	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
+		dev_err(&client->dev, "read error\n");
+		return -EIO;
+	}
+
+	tm->tm_sec = BCD2BIN(buf[M41TXX_REG_SEC] & 0x7f);
+	tm->tm_min = BCD2BIN(buf[M41TXX_REG_MIN] & 0x7f);
+	tm->tm_hour = BCD2BIN(buf[M41TXX_REG_HOUR] & 0x3f);
+	tm->tm_mday = BCD2BIN(buf[M41TXX_REG_DAY] & 0x3f);
+	tm->tm_wday = buf[M41TXX_REG_WDAY] & 0x07;
+	tm->tm_mon = BCD2BIN(buf[M41TXX_REG_MON] & 0x1f) - 1;
+
+	/* assume 20YY not 19YY, and ignore the Century Bit */
+	tm->tm_year = BCD2BIN(buf[M41TXX_REG_YEAR]) + 100;
+	return 0;
+}
+
+/* Sets the given date and time to the real time clock. */
+static int m41txx_set_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	unsigned char wbuf[1 + M41TXX_REG_YEAR + 1];
+	unsigned char *buf = &wbuf[1];
+	unsigned char dt_addr[1] = { M41TXX_REG_SEC };
+	struct i2c_msg msgs_in[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1,
+			.buf	= dt_addr,
+		},
+		{
+			.addr	= client->addr,
+			.flags	= I2C_M_RD,
+			.len	= M41TXX_REG_YEAR + 1 - M41TXX_REG_SEC,
+			.buf	= buf + M41TXX_REG_SEC,
+		},
+	};
+	struct i2c_msg msgs[] = {
+		{
+			.addr	= client->addr,
+			.flags	= 0,
+			.len	= 1 + M41TXX_REG_YEAR + 1,
+			.buf	= wbuf,
+		 },
+	};
+
+	/* Read current reg values into buf[1..7] */
+	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+		dev_err(&client->dev, "read error\n");
+		return -EIO;
+	}
+
+	wbuf[0] = 0; /* offset into rtc's regs */
+	/* Merge time-data and register flags into buf[0..7] */
+	buf[M41TXX_REG_SSEC] = 0;
+	buf[M41TXX_REG_SEC] =
+		BIN2BCD(tm->tm_sec) | (buf[M41TXX_REG_SEC] & ~0x7f);
+	buf[M41TXX_REG_MIN] =
+		BIN2BCD(tm->tm_min) | (buf[M41TXX_REG_MIN] & ~0x7f);
+	buf[M41TXX_REG_HOUR] =
+		BIN2BCD(tm->tm_hour) | (buf[M41TXX_REG_HOUR] & ~0x3f) ;
+	buf[M41TXX_REG_WDAY] =
+		(tm->tm_wday & 0x07) | (buf[M41TXX_REG_WDAY] & ~0x07);
+	buf[M41TXX_REG_DAY] =
+		BIN2BCD(tm->tm_mday) | (buf[M41TXX_REG_DAY] & ~0x3f);
+	buf[M41TXX_REG_MON] =
+		BIN2BCD(tm->tm_mon + 1) | (buf[M41TXX_REG_MON] & ~0x1f);
+	/* assume 20YY not 19YY */
+	buf[M41TXX_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
+
+	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+		dev_err(&client->dev, "write error\n");
+		return -EIO;
+	}
+	return 0;
+}
+
+#if defined(CONFIG_RTC_INTF_PROC) || defined(CONFIG_RTC_INTF_PROC_MODULE)
+static int m41txx_rtc_proc(struct device *dev, struct seq_file *seq)
+{
+	struct i2c_client *client = to_i2c_client(dev);
+	struct m41txx_data *clientdata = i2c_get_clientdata(client);
+	unsigned char reg;
+
+	if (clientdata->chip->features & M41TXX_FEATURE_BL) {
+		reg = i2c_smbus_read_byte_data(client, M41TXX_REG_FLAGS);
+		seq_printf(seq, "battery\t\t: %s\n",
+			   (reg & M41TXX_FLAGS_BATT_LOW) ? "exhausted" : "ok");
+	}
+	return 0;
+}
+#else
+#define m41txx_rtc_proc NULL
+#endif
+
+static int m41txx_rtc_read_time(struct device *dev, struct rtc_time *tm)
+{
+	return m41txx_get_datetime(to_i2c_client(dev), tm);
+}
+
+static int m41txx_rtc_set_time(struct device *dev, struct rtc_time *tm)
+{
+	return m41txx_set_datetime(to_i2c_client(dev), tm);
+}
+
+static struct rtc_class_ops m41txx_rtc_ops = {
+	.read_time = m41txx_rtc_read_time,
+	.set_time = m41txx_rtc_set_time,
+	.proc = m41txx_rtc_proc,
+};
+
+/*
+ *****************************************************************************
+ *
+ *	Driver Interface
+ *
+ *****************************************************************************
+ */
+static int m41txx_probe(struct i2c_client *client)
+{
+	int i, rc = 0;
+	struct rtc_device *rtc = NULL;
+	struct rtc_time tm;
+	struct m41txx_platform_data *pdata = client->dev.platform_data;
+	const static struct m41txx_chip_info *chip;
+	struct m41txx_data *clientdata = NULL;
+
+	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
+				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
+		rc = -ENODEV;
+		goto exit;
+	}
+
+	dev_info(&client->dev,
+		 "chip found, driver version " DRV_VERSION "\n");
+
+	chip = NULL;
+	for (i = 0; i < ARRAY_SIZE(m41txx_chip_info_tbl); i++) {
+		if (!strcmp(m41txx_chip_info_tbl[i].name, client->name)) {
+			chip = &m41txx_chip_info_tbl[i];
+			break;
+		}
+	}
+	if (!chip) {
+		dev_err(&client->dev, "%s is not supported\n", client->name);
+		rc = -ENODEV;
+		goto exit;
+	}
+
+	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
+	if (!clientdata) {
+		rc = -ENOMEM;
+		goto exit;
+	}
+
+	rtc = rtc_device_register(client->name, &client->dev,
+				  &m41txx_rtc_ops, THIS_MODULE);
+	if (IS_ERR(rtc)) {
+		rc = PTR_ERR(rtc);
+		rtc = NULL;
+		goto exit;
+	}
+
+	clientdata->rtc = rtc;
+	clientdata->chip = chip;
+	i2c_set_clientdata(client, clientdata);
+
+	/* If asked, disable SQW, set SQW frequency & re-enable */
+	if (pdata && pdata->sqw_freq) {
+		rc = i2c_smbus_read_byte_data(client, M41TXX_REG_ALARM_MON);
+		if (rc < 0)
+			goto sqw_err;
+		if (i2c_smbus_write_byte_data(client, M41TXX_REG_ALARM_MON,
+					      rc & ~0x40) < 0 ||
+		    i2c_smbus_write_byte_data(client, M41TXX_REG_SQW,
+					      pdata->sqw_freq) < 0 ||
+		    i2c_smbus_write_byte_data(client, M41TXX_REG_ALARM_MON,
+					      rc | 0x40) < 0)
+			goto sqw_err;
+	}
+
+	/* Make sure HT (Halt Update) bit is cleared */
+	rc = i2c_smbus_read_byte_data(client, M41TXX_REG_ALARM_HOUR);
+	if (rc < 0)
+		goto ht_err;
+
+	if (rc & M41TXX_ALHOUR_HT) {
+		if (chip->features & M41TXX_FEATURE_HT) {
+			m41txx_get_datetime(client, &tm);
+			dev_info(&client->dev, "HT bit was set!\n");
+			dev_info(&client->dev,
+				 "Power Down at "
+				 "%04i-%02i-%02i %02i:%02i:%02i\n",
+				 tm.tm_year + 1900,
+				 tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
+				 tm.tm_min, tm.tm_sec);
+		}
+		if (i2c_smbus_write_byte_data(client,
+					      M41TXX_REG_ALARM_HOUR,
+					      rc & ~M41TXX_ALHOUR_HT) < 0)
+			goto ht_err;
+	}
+
+	/* Make sure ST (stop) bit is cleared */
+	rc = i2c_smbus_read_byte_data(client, M41TXX_REG_SEC);
+	if (rc < 0)
+		goto st_err;
+
+	if (rc & M41TXX_SEC_ST) {
+		if (i2c_smbus_write_byte_data(client, M41TXX_REG_SEC,
+					      rc & ~M41TXX_SEC_ST) < 0)
+			goto st_err;
+	}
+
+	return 0;
+
+st_err:
+	rc = -EIO;
+	dev_err(&client->dev, "Can't clear ST bit\n");
+	goto exit;
+ht_err:
+	rc = -EIO;
+	dev_err(&client->dev, "Can't clear HT bit\n");
+	goto exit;
+sqw_err:
+	rc = -EIO;
+	dev_err(&client->dev, "Can't set SQW Frequency\n");
+
+exit:
+	if (rtc)
+		rtc_device_unregister(rtc);
+	kfree(clientdata);
+	return rc;
+}
+
+static int m41txx_remove(struct i2c_client *client)
+{
+	struct m41txx_data *clientdata = i2c_get_clientdata(client);
+	struct rtc_device *rtc = clientdata->rtc;
+
+	if (rtc)
+		rtc_device_unregister(rtc);
+	kfree(clientdata);
+
+	return 0;
+}
+
+static struct i2c_driver m41txx_driver = {
+	.driver = {
+		.name = M41TXX_DRV_NAME,
+	},
+	.probe = m41txx_probe,
+	.remove = m41txx_remove,
+};
+
+static int __init m41txx_rtc_init(void)
+{
+	return i2c_add_driver(&m41txx_driver);
+}
+
+static void __exit m41txx_rtc_exit(void)
+{
+	i2c_del_driver(&m41txx_driver);
+}
+
+MODULE_AUTHOR("Alexander Bigga <ab@mycable.de>");
+MODULE_DESCRIPTION("ST Microelectronics M41TXX RTC I2C Client Driver");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
+
+module_init(m41txx_rtc_init);
+module_exit(m41txx_rtc_exit);
diff --git a/include/linux/m41txx.h b/include/linux/m41txx.h
new file mode 100644
index 0000000..c67c97d
--- /dev/null
+++ b/include/linux/m41txx.h
@@ -0,0 +1,40 @@
+/*
+ * Definitions for the ST M41TXX family of i2c rtc chips.
+ *
+ * Based on m41t00.h by Mark A. Greer <mgreer@mvista.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#ifndef _M41TXX_H
+#define _M41TXX_H
+
+#define	M41TXX_DRV_NAME		"m41txx"
+#define	M41TXX_I2C_ADDR		0x68
+
+struct m41txx_platform_data {
+	u8	sqw_freq;
+};
+
+/* SQW output disabled, this is default value by power on */
+#define M41TXX_SQW_DISABLE	(0)
+
+#define M41TXX_SQW_32KHZ	(1<<4)		/* 32.768 KHz */
+#define M41TXX_SQW_8KHZ		(2<<4)		/* 8.192 KHz */
+#define M41TXX_SQW_4KHZ		(3<<4)		/* 4.096 KHz */
+#define M41TXX_SQW_2KHZ		(4<<4)		/* 2.048 KHz */
+#define M41TXX_SQW_1KHZ		(5<<4)		/* 1.024 KHz */
+#define M41TXX_SQW_512HZ	(6<<4)		/* 512 Hz */
+#define M41TXX_SQW_256HZ	(7<<4)		/* 256 Hz */
+#define M41TXX_SQW_128HZ	(8<<4)		/* 128 Hz */
+#define M41TXX_SQW_64HZ		(9<<4)		/* 64 Hz */
+#define M41TXX_SQW_32HZ		(10<<4)		/* 32 Hz */
+#define M41TXX_SQW_16HZ		(11<<4)		/* 16 Hz */
+#define M41TXX_SQW_8HZ		(12<<4)		/* 8 Hz */
+#define M41TXX_SQW_4HZ		(13<<4)		/* 4 Hz */
+#define M41TXX_SQW_2HZ		(14<<4)		/* 2 Hz */
+#define M41TXX_SQW_1HZ		(15<<4)		/* 1 Hz */
+
+#endif /* _M41TXX_H */
