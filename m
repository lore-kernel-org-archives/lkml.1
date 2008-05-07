Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYEGAom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYEGAom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 20:44:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755827AbYEGAnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 20:43:12 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62970 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756273AbYEGAnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 20:43:09 -0400
Date: Wed, 7 May 2008 01:40:41 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>, Jean Delvare <khali@linux-fr.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
cc: rtc-linux@googlegroups.com, i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 4/4] RTC: SMBus support for the M41T80, etc. driver
Message-ID: <Pine.LNX.4.55.0805070102460.16173@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The BCM1250A SOC which is used on the SWARM board utilising an M41T81
chip only supports pure I2C in the raw bit-banged mode.  Nobody sane
really wants to use it unless absolutely necessary and the M41T80, etc.  
chips work just fine with an SMBus controller which is what the standard
mode of operation of the BCM1250A.  The only drawback of byte accesses
with the M41T80 is the chip only latches clock data registers for the
duration of an I2C transaction which works fine with a block transfers,
but not byte-wise accesses.

 The driver currently requires an I2C controller providing both SMBus and
pure I2C access.  This is a set of changes to make it work with either,
with a preference to pure I2C.  The problem of unlatched clock data if
SMBus transactions are used is resolved in the standard way.

 Whether a choice between SMBus and pure I2C access is possible is 
obviously device dependent.  If the code proved useful for other I2C 
devices, then it could be moved to a more generic place.  It is a code
simplification regardless -- similar I2C packet definitions are not 
scattered throughout the driver anymore.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Please note I have no means to test these changes with a pure I2C 
controller -- anybody interested, please help.

  Maciej

patch-2.6.26-rc1-20080505-m41t80-smbus-12
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-06 18:15:42.000000000 +0000
@@ -6,6 +6,7 @@
  * Based on m41t00.c by Mark A. Greer <mgreer@mvista.com>
  *
  * 2006 (c) mycable GmbH
+ * Copyright (c) 2008  Maciej W. Rozycki
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -13,36 +14,39 @@
  *
  */
 
-#include <linux/module.h>
+#include <linux/bcd.h>
+#include <linux/i2c.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/rtc.h>
 #include <linux/slab.h>
 #include <linux/string.h>
-#include <linux/i2c.h>
-#include <linux/rtc.h>
-#include <linux/bcd.h>
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
-#include <linux/miscdevice.h>
-#include <linux/watchdog.h>
-#include <linux/reboot.h>
 #include <linux/fs.h>
 #include <linux/ioctl.h>
+#include <linux/miscdevice.h>
+#include <linux/reboot.h>
+#include <linux/watchdog.h>
 #endif
 
-#define M41T80_REG_SSEC	0
-#define M41T80_REG_SEC	1
-#define M41T80_REG_MIN	2
-#define M41T80_REG_HOUR	3
-#define M41T80_REG_WDAY	4
-#define M41T80_REG_DAY	5
-#define M41T80_REG_MON	6
-#define M41T80_REG_YEAR	7
+#define M41T80_REG_SSEC		0
+#define M41T80_REG_SEC		1
+#define M41T80_REG_MIN		2
+#define M41T80_REG_HOUR		3
+#define M41T80_REG_WDAY		4
+#define M41T80_REG_DAY		5
+#define M41T80_REG_MON		6
+#define M41T80_REG_YEAR		7
+#define M41T80_REG_CONTROL	8
+#define M41T80_REG_WATCHDOG	9
 #define M41T80_REG_ALARM_MON	0xa
 #define M41T80_REG_ALARM_DAY	0xb
 #define M41T80_REG_ALARM_HOUR	0xc
 #define M41T80_REG_ALARM_MIN	0xd
 #define M41T80_REG_ALARM_SEC	0xe
 #define M41T80_REG_FLAGS	0xf
-#define M41T80_REG_SQW	0x13
+#define M41T80_REG_SQW		0x13
 
 #define M41T80_DATETIME_REG_SIZE	(M41T80_REG_YEAR + 1)
 #define M41T80_ALARM_REG_SIZE	\
@@ -58,7 +62,7 @@
 #define M41T80_FEATURE_HT	(1 << 0)
 #define M41T80_FEATURE_BL	(1 << 1)
 
-#define DRV_VERSION "0.05"
+#define DRV_VERSION "0.06"
 
 static const struct i2c_device_id m41t80_id[] = {
 	{ "m41t80", 0 },
@@ -78,31 +82,108 @@ struct m41t80_data {
 	struct rtc_device *rtc;
 };
 
-static int m41t80_get_datetime(struct i2c_client *client,
-			       struct rtc_time *tm)
+
+static int m41t80_i2c_transfer(struct i2c_client *client, int write,
+			       u8 reg, u8 num, u8 *buf)
 {
-	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
 	struct i2c_msg msgs[] = {
 		{
 			.addr	= client->addr,
 			.flags	= 0,
 			.len	= 1,
-			.buf	= dt_addr,
+			.buf	= &reg,
 		},
 		{
 			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
-			.buf	= buf + M41T80_REG_SEC,
+			.flags	= write ? 0 : I2C_M_RD,
+			.len	= num,
+			.buf	= buf,
 		},
 	};
 
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
+	return i2c_transfer(client->adapter, msgs, 2);
+}
+
+static int m41t80_read_byte_data(struct i2c_client *client, u8 reg)
+{
+	int rc;
+	u8 val;
+
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
+		rc = m41t80_i2c_transfer(client, 0, reg, 1, &val);
+		if (rc < 0)
+			return rc;
+		else
+			return val;
+	} else
+		return i2c_smbus_read_byte_data(client, reg);
+}
+
+static int m41t80_write_byte_data(struct i2c_client *client, u8 reg, u8 val)
+{
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return m41t80_i2c_transfer(client, 1, reg, 1, &val);
+	else
+		return i2c_smbus_write_byte_data(client, reg, val);
+}
+
+static int m41t80_transfer(struct i2c_client *client, int write,
+			   u8 reg, u8 num, u8 *buf)
+{
+	int i, rc;
+
+	if (i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
+		return m41t80_i2c_transfer(client, write, reg, num, buf);
+	else if (write) {
+		for (i = 0; i < num; i++) {
+			rc = i2c_smbus_write_byte_data(client, reg + i,
+						       buf[i]);
+			if (rc < 0)
+				return rc;
+		}
+		return 0;
+	} else {
+		for (i = 0; i < num; i++) {
+			rc = i2c_smbus_read_byte_data(client, reg + i);
+			if (rc < 0)
+				return rc;
+			buf[i] = rc;
+		}
+		return 0;
 	}
+}
+
+static int m41t80_get_datetime(struct i2c_client *client, struct rtc_time *tm)
+{
+	u8 buf[M41T80_DATETIME_REG_SIZE];
+	int loops = 2;
+	int sec0, sec1;
+
+	/*
+	 * Time registers are latched by this chip if an I2C block
+	 * transfer is used, but with SMBus-style byte accesses
+	 * this is not the case, so check seconds for a wraparound.
+	 */
+	do {
+		if (m41t80_transfer(client, 0, M41T80_REG_SEC,
+				    M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+				    buf + M41T80_REG_SEC)) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
+		sec0 = buf[M41T80_REG_SEC];
+
+		sec1 = m41t80_read_byte_data(client, M41T80_REG_SEC);
+		if (sec1 < 0) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
 
-	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
+		sec0 = BCD2BIN(sec0 & 0x7f);
+		sec1 = BCD2BIN(sec1 & 0x7f);
+	} while (sec1 < sec0 && --loops);
+
+	tm->tm_sec = sec1;
 	tm->tm_min = BCD2BIN(buf[M41T80_REG_MIN] & 0x7f);
 	tm->tm_hour = BCD2BIN(buf[M41T80_REG_HOUR] & 0x3f);
 	tm->tm_mday = BCD2BIN(buf[M41T80_REG_DAY] & 0x3f);
@@ -117,39 +198,16 @@ static int m41t80_get_datetime(struct i2
 /* Sets the given date and time to the real time clock. */
 static int m41t80_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
-	u8 wbuf[1 + M41T80_DATETIME_REG_SIZE];
-	u8 *buf = &wbuf[1];
-	u8 dt_addr[1] = { M41T80_REG_SEC };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
-			.buf	= buf + M41T80_REG_SEC,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_DATETIME_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
+	u8 buf[M41T80_DATETIME_REG_SIZE];
 
 	/* Read current reg values into buf[1..7] */
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_SEC,
+			    M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+			    buf + M41T80_REG_SEC)) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
 
-	wbuf[0] = 0; /* offset into rtc's regs */
 	/* Merge time-data and register flags into buf[0..7] */
 	buf[M41T80_REG_SSEC] = 0;
 	buf[M41T80_REG_SEC] =
@@ -167,7 +225,8 @@ static int m41t80_set_datetime(struct i2
 	/* assume 20YY not 19YY */
 	buf[M41T80_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_transfer(client, 1, M41T80_REG_SSEC,
+			    M41T80_DATETIME_REG_SIZE, buf)) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
@@ -182,7 +241,7 @@ static int m41t80_rtc_proc(struct device
 	u8 reg;
 
 	if (clientdata->features & M41T80_FEATURE_BL) {
-		reg = i2c_smbus_read_byte_data(client, M41T80_REG_FLAGS);
+		reg = m41t80_read_byte_data(client, M41T80_REG_FLAGS);
 		seq_printf(seq, "battery\t\t: %s\n",
 			   (reg & M41T80_FLAGS_BATT_LOW) ? "exhausted" : "ok");
 	}
@@ -217,7 +276,7 @@ m41t80_rtc_ioctl(struct device *dev, uns
 		return -ENOIOCTLCMD;
 	}
 
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
+	rc = m41t80_read_byte_data(client, M41T80_REG_ALARM_MON);
 	if (rc < 0)
 		goto err;
 	switch (cmd) {
@@ -228,7 +287,7 @@ m41t80_rtc_ioctl(struct device *dev, uns
 		rc |= M41T80_ALMON_AFE;
 		break;
 	}
-	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON, rc) < 0)
+	if (m41t80_write_byte_data(client, M41T80_REG_ALARM_MON, rc) < 0)
 		goto err;
 	return 0;
 err:
@@ -241,34 +300,11 @@ err:
 static int m41t80_rtc_set_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	u8 wbuf[1 + M41T80_ALARM_REG_SIZE];
-	u8 *buf = &wbuf[1];
+	u8 buf[M41T80_ALARM_REG_SIZE];
 	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
-	struct i2c_msg msgs_in[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE,
-			.buf	= buf,
-		},
-	};
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1 + M41T80_ALARM_REG_SIZE,
-			.buf	= wbuf,
-		 },
-	};
 
-	if (i2c_transfer(client->adapter, msgs_in, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE, buf)) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -278,7 +314,6 @@ static int m41t80_rtc_set_alarm(struct d
 	reg[M41T80_REG_ALARM_MIN] = 0;
 	reg[M41T80_REG_ALARM_SEC] = 0;
 
-	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
 	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
 		BIN2BCD(t->time.tm_sec) : 0x80;
 	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
@@ -292,15 +327,16 @@ static int m41t80_rtc_set_alarm(struct d
 	else
 		reg[M41T80_REG_ALARM_DAY] |= 0x40;
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_transfer(client, 1, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE, buf)) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
 
 	if (t->enabled) {
 		reg[M41T80_REG_ALARM_MON] |= M41T80_ALMON_AFE;
-		if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
-					      reg[M41T80_REG_ALARM_MON]) < 0) {
+		if (m41t80_write_byte_data(client, M41T80_REG_ALARM_MON,
+					   reg[M41T80_REG_ALARM_MON]) < 0) {
 			dev_err(&client->dev, "write error\n");
 			return -EIO;
 		}
@@ -311,25 +347,11 @@ static int m41t80_rtc_set_alarm(struct d
 static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
+	u8 buf[M41T80_ALARM_REG_SIZE + 1];	/* all alarm regs and flags */
 	u8 *reg = buf - M41T80_REG_ALARM_MON;
-	struct i2c_msg msgs[] = {
-		{
-			.addr	= client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= dt_addr,
-		},
-		{
-			.addr	= client->addr,
-			.flags	= I2C_M_RD,
-			.len	= M41T80_ALARM_REG_SIZE + 1,
-			.buf	= buf,
-		},
-	};
 
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
+	if (m41t80_transfer(client, 0, M41T80_REG_ALARM_MON,
+			    M41T80_ALARM_REG_SIZE + 1, buf)) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -373,7 +395,7 @@ static ssize_t m41t80_sysfs_show_flags(s
 	struct i2c_client *client = to_i2c_client(dev);
 	int val;
 
-	val = i2c_smbus_read_byte_data(client, M41T80_REG_FLAGS);
+	val = m41t80_read_byte_data(client, M41T80_REG_FLAGS);
 	if (val < 0)
 		return -EIO;
 	return sprintf(buf, "%#x\n", val);
@@ -386,7 +408,7 @@ static ssize_t m41t80_sysfs_show_sqwfreq
 	struct i2c_client *client = to_i2c_client(dev);
 	int val;
 
-	val = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
+	val = m41t80_read_byte_data(client, M41T80_REG_SQW);
 	if (val < 0)
 		return -EIO;
 	val = (val >> 4) & 0xf;
@@ -421,19 +443,19 @@ static ssize_t m41t80_sysfs_set_sqwfreq(
 			return -EINVAL;
 	}
 	/* disable SQW, set SQW frequency & re-enable */
-	almon = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_MON);
+	almon = m41t80_read_byte_data(client, M41T80_REG_ALARM_MON);
 	if (almon < 0)
 		return -EIO;
-	sqw = i2c_smbus_read_byte_data(client, M41T80_REG_SQW);
+	sqw = m41t80_read_byte_data(client, M41T80_REG_SQW);
 	if (sqw < 0)
 		return -EIO;
 	sqw = (sqw & 0x0f) | (val << 4);
-	if (i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
-				      almon & ~M41T80_ALMON_SQWE) < 0 ||
-	    i2c_smbus_write_byte_data(client, M41T80_REG_SQW, sqw) < 0)
+	if (m41t80_write_byte_data(client, M41T80_REG_ALARM_MON,
+				   almon & ~M41T80_ALMON_SQWE) < 0 ||
+	    m41t80_write_byte_data(client, M41T80_REG_SQW, sqw) < 0)
 		return -EIO;
-	if (val && i2c_smbus_write_byte_data(client, M41T80_REG_ALARM_MON,
-					     almon | M41T80_ALMON_SQWE) < 0)
+	if (val && m41t80_write_byte_data(client, M41T80_REG_ALARM_MON,
+					  almon | M41T80_ALMON_SQWE) < 0)
 		return -EIO;
 	return count;
 }
@@ -488,26 +510,16 @@ static int boot_flag;
  */
 static void wdt_ping(void)
 {
-	unsigned char i2c_data[2];
-	struct i2c_msg msgs1[1] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 2,
-			.buf	= i2c_data,
-		},
-	};
-	i2c_data[0] = 0x09;		/* watchdog register */
+	u8 wdt = 0x80;				/* WDS = 1 (0x80)  */
 
 	if (wdt_margin > 31)
-		i2c_data[1] = (wdt_margin & 0xFC) | 0x83; /* resolution = 4s */
+		/* mulitplier = WD_TIMO / 4, resolution = 4s (0x3)  */
+		wdt |= (wdt_margin & 0xfc) | 0x3;
 	else
-		/*
-		 * WDS = 1 (0x80), mulitplier = WD_TIMO, resolution = 1s (0x02)
-		 */
-		i2c_data[1] = wdt_margin<<2 | 0x82;
+		/* mulitplier = WD_TIMO, resolution = 1s (0x2)  */
+		wdt |= wdt_margin << 2 | 0x2;
 
-	i2c_transfer(save_client->adapter, msgs1, 1);
+	m41t80_write_byte_data(save_client, M41T80_REG_WATCHDOG, wdt);
 }
 
 /**
@@ -517,36 +529,8 @@ static void wdt_ping(void)
  */
 static void wdt_disable(void)
 {
-	unsigned char i2c_data[2], i2c_buf[0x10];
-	struct i2c_msg msgs0[2] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 1,
-			.buf	= i2c_data,
-		},
-		{
-			.addr	= save_client->addr,
-			.flags	= I2C_M_RD,
-			.len	= 1,
-			.buf	= i2c_buf,
-		},
-	};
-	struct i2c_msg msgs1[1] = {
-		{
-			.addr	= save_client->addr,
-			.flags	= 0,
-			.len	= 2,
-			.buf	= i2c_data,
-		},
-	};
-
-	i2c_data[0] = 0x09;
-	i2c_transfer(save_client->adapter, msgs0, 2);
-
-	i2c_data[0] = 0x09;
-	i2c_data[1] = 0x00;
-	i2c_transfer(save_client->adapter, msgs1, 1);
+	m41t80_read_byte_data(save_client, M41T80_REG_WATCHDOG);
+	m41t80_write_byte_data(save_client, M41T80_REG_WATCHDOG, 0);
 }
 
 /**
@@ -629,14 +613,12 @@ static int wdt_ioctl(struct inode *inode
 			return -EFAULT;
 
 		if (rv & WDIOS_DISABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: disable watchdog\n");
+			pr_info("rtc-m41t80: disable watchdog\n");
 			wdt_disable();
 		}
 
 		if (rv & WDIOS_ENABLECARD) {
-			printk(KERN_INFO
-			       "rtc-m41t80: enable watchdog\n");
+			pr_info("rtc-m41t80: enable watchdog\n");
 			wdt_ping();
 		}
 
@@ -732,19 +714,28 @@ static struct notifier_block wdt_notifie
 static int m41t80_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
 {
-	int rc = 0;
 	struct rtc_device *rtc = NULL;
 	struct rtc_time tm;
 	struct m41t80_data *clientdata = NULL;
+	int rc = 0;
+	int reg;
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
-				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
+	if ((i2c_get_functionality(client->adapter) &
+	     (I2C_FUNC_I2C | I2C_FUNC_SMBUS_BYTE_DATA)) == 0) {
 		rc = -ENODEV;
 		goto exit;
 	}
 
+	/* Trivially check it's there; keep the result for the HT check.  */
+	reg = m41t80_read_byte_data(client, M41T80_REG_ALARM_HOUR);
+	if (reg < 0) {
+		rc = -ENXIO;
+		goto exit;
+	}
+
 	dev_info(&client->dev,
-		 "chip found, driver version " DRV_VERSION "\n");
+		 "%s chip found, driver version " DRV_VERSION "\n",
+		 client->name);
 
 	clientdata = kzalloc(sizeof(*clientdata), GFP_KERNEL);
 	if (!clientdata) {
@@ -765,11 +756,7 @@ static int m41t80_probe(struct i2c_clien
 	i2c_set_clientdata(client, clientdata);
 
 	/* Make sure HT (Halt Update) bit is cleared */
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_ALARM_HOUR);
-	if (rc < 0)
-		goto ht_err;
-
-	if (rc & M41T80_ALHOUR_HT) {
+	if (reg & M41T80_ALHOUR_HT) {
 		if (clientdata->features & M41T80_FEATURE_HT) {
 			m41t80_get_datetime(client, &tm);
 			dev_info(&client->dev, "HT bit was set!\n");
@@ -780,20 +767,19 @@ static int m41t80_probe(struct i2c_clien
 				 tm.tm_mon + 1, tm.tm_mday, tm.tm_hour,
 				 tm.tm_min, tm.tm_sec);
 		}
-		if (i2c_smbus_write_byte_data(client,
-					      M41T80_REG_ALARM_HOUR,
-					      rc & ~M41T80_ALHOUR_HT) < 0)
+		if (m41t80_write_byte_data(client, M41T80_REG_ALARM_HOUR,
+					   reg & ~M41T80_ALHOUR_HT) < 0)
 			goto ht_err;
 	}
 
 	/* Make sure ST (stop) bit is cleared */
-	rc = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
-	if (rc < 0)
+	reg = m41t80_read_byte_data(client, M41T80_REG_SEC);
+	if (reg < 0)
 		goto st_err;
 
-	if (rc & M41T80_SEC_ST) {
-		if (i2c_smbus_write_byte_data(client, M41T80_REG_SEC,
-					      rc & ~M41T80_SEC_ST) < 0)
+	if (reg & M41T80_SEC_ST) {
+		if (m41t80_write_byte_data(client, M41T80_REG_SEC,
+					   reg & ~M41T80_SEC_ST) < 0)
 			goto st_err;
 	}
 
@@ -803,6 +789,7 @@ static int m41t80_probe(struct i2c_clien
 
 #ifdef CONFIG_RTC_DRV_M41T80_WDT
 	if (clientdata->features & M41T80_FEATURE_HT) {
+		save_client = client;
 		rc = misc_register(&wdt_dev);
 		if (rc)
 			goto exit;
@@ -811,7 +798,6 @@ static int m41t80_probe(struct i2c_clien
 			misc_deregister(&wdt_dev);
 			goto exit;
 		}
-		save_client = client;
 	}
 #endif
 	return 0;
