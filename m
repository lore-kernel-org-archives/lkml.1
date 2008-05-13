Return-Path: <linux-kernel-owner+w=401wt.eu-S1757273AbYEMDat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273AbYEMDat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758447AbYEMD3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:29:32 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62379 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758419AbYEMD3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:29:30 -0400
Date: Tue, 13 May 2008 04:27:30 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>
cc: rtc-linux@googlegroups.com, i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] RTC: SMBus support for the M41T80, etc. driver (#2)
Message-ID: <Pine.LNX.4.55.0805130254420.535@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The BCM1250A SOC which is used on the SWARM board utilising an M41T81
chip only supports pure I2C in the raw bit-banged mode.  Nobody sane
really wants to use it unless absolutely necessary and the M41T80, etc.  
chips work just fine with an SMBus adapter which is what the standard mode
of operation of the BCM1250A.  The only drawback of byte accesses with the
M41T80 is the chip only latches clock data registers for the duration of
an I2C transaction which works fine with a block transfers, but not
byte-wise accesses.

 The driver currently requires an I2C adapter providing both SMBus and raw
I2C access.  This is a set of changes to make it work with any SMBus
adapter providing at least read byte and write byte protocols.  
Additionally, if a given SMBus adapter supports I2C block read and/or
write protocols (a common extension beyond the SMBus spec), they are used
as well.  The problem of unlatched clock data if SMBus byte transactions
are used is resolved in the standard way.  For raw I2C controllers this
functionality is provided by the I2C core as SMBus emulation in a
transparent way.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-m41t80-smbus-17
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c
--- linux-2.6.26-rc1-20080505.macro/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/drivers/rtc/rtc-m41t80.c	2008-05-05 02:55:40.000000000 +0000
@@ -6,6 +6,7 @@
  * Based on m41t00.c by Mark A. Greer <mgreer@mvista.com>
  *
  * 2006 (c) mycable GmbH
+ * Copyright (c) 2008  Maciej W. Rozycki
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -36,6 +37,8 @@
 #define M41T80_REG_DAY	5
 #define M41T80_REG_MON	6
 #define M41T80_REG_YEAR	7
+#define M41T80_REG_CONTROL	8
+#define M41T80_REG_WATCHDOG	9
 #define M41T80_REG_ALARM_MON	0xa
 #define M41T80_REG_ALARM_DAY	0xb
 #define M41T80_REG_ALARM_HOUR	0xc
@@ -58,7 +61,7 @@
 #define M41T80_FEATURE_HT	(1 << 0)
 #define M41T80_FEATURE_BL	(1 << 1)
 
-#define DRV_VERSION "0.05"
+#define DRV_VERSION "0.06"
 
 static const struct i2c_device_id m41t80_id[] = {
 	{ "m41t80", 0 },
@@ -78,31 +81,83 @@ struct m41t80_data {
 	struct rtc_device *rtc;
 };
 
-static int m41t80_get_datetime(struct i2c_client *client,
-			       struct rtc_time *tm)
+
+static int m41t80_write_block_data(struct i2c_client *client,
+				   u8 reg, u8 num, u8 *buf)
 {
-	u8 buf[M41T80_DATETIME_REG_SIZE], dt_addr[1] = { M41T80_REG_SEC };
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
-			.len	= M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
-			.buf	= buf + M41T80_REG_SEC,
-		},
-	};
+	int i, rc;
 
-	if (i2c_transfer(client->adapter, msgs, 2) < 0) {
-		dev_err(&client->dev, "read error\n");
-		return -EIO;
+	if (i2c_check_functionality(client->adapter,
+				    I2C_FUNC_SMBUS_WRITE_I2C_BLOCK)) {
+		i = i2c_smbus_write_i2c_block_data(client, reg, num, buf);
+	} else {
+		for (i = 0; i < num; i++) {
+			rc = i2c_smbus_write_byte_data(client, reg + i,
+						       buf[i]);
+			if (rc < 0) {
+				i = rc;
+				goto out;
+			}
+		}
+	}
+out:
+	return i;
+}
+
+static int m41t80_read_block_data(struct i2c_client *client,
+				  u8 reg, u8 num, u8 *buf)
+{
+	int i, rc;
+
+	if (i2c_check_functionality(client->adapter,
+				    I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
+		i = i2c_smbus_read_i2c_block_data(client, reg, num, buf);
+	} else {
+		for (i = 0; i < num; i++) {
+			rc = i2c_smbus_read_byte_data(client, reg + i);
+			if (rc < 0) {
+				i = rc;
+				goto out;
+			}
+			buf[i] = rc;
+		}
 	}
+out:
+	return i;
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
+		if (m41t80_read_block_data(client, M41T80_REG_SEC,
+					   M41T80_DATETIME_REG_SIZE -
+					   M41T80_REG_SEC,
+					   buf + M41T80_REG_SEC) < 0) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
+		sec0 = buf[M41T80_REG_SEC];
 
-	tm->tm_sec = BCD2BIN(buf[M41T80_REG_SEC] & 0x7f);
+		sec1 = i2c_smbus_read_byte_data(client, M41T80_REG_SEC);
+		if (sec1 < 0) {
+			dev_err(&client->dev, "read error\n");
+			return -EIO;
+		}
+
+		sec0 = BCD2BIN(sec0 & 0x7f);
+		sec1 = BCD2BIN(sec1 & 0x7f);
+	} while (sec1 < sec0 && --loops);
+
+	tm->tm_sec = sec1;
 	tm->tm_min = BCD2BIN(buf[M41T80_REG_MIN] & 0x7f);
 	tm->tm_hour = BCD2BIN(buf[M41T80_REG_HOUR] & 0x3f);
 	tm->tm_mday = BCD2BIN(buf[M41T80_REG_DAY] & 0x3f);
@@ -117,39 +172,16 @@ static int m41t80_get_datetime(struct i2
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
+	if (m41t80_read_block_data(client, M41T80_REG_SEC,
+				   M41T80_DATETIME_REG_SIZE - M41T80_REG_SEC,
+				   buf + M41T80_REG_SEC) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
 
-	wbuf[0] = 0; /* offset into rtc's regs */
 	/* Merge time-data and register flags into buf[0..7] */
 	buf[M41T80_REG_SSEC] = 0;
 	buf[M41T80_REG_SEC] =
@@ -167,7 +199,8 @@ static int m41t80_set_datetime(struct i2
 	/* assume 20YY not 19YY */
 	buf[M41T80_REG_YEAR] = BIN2BCD(tm->tm_year % 100);
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_write_block_data(client, M41T80_REG_SSEC,
+				    M41T80_DATETIME_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
@@ -241,34 +274,11 @@ err:
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
+	if (m41t80_read_block_data(client, M41T80_REG_ALARM_MON,
+				   M41T80_ALARM_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -278,7 +288,6 @@ static int m41t80_rtc_set_alarm(struct d
 	reg[M41T80_REG_ALARM_MIN] = 0;
 	reg[M41T80_REG_ALARM_SEC] = 0;
 
-	wbuf[0] = M41T80_REG_ALARM_MON; /* offset into rtc's regs */
 	reg[M41T80_REG_ALARM_SEC] |= t->time.tm_sec >= 0 ?
 		BIN2BCD(t->time.tm_sec) : 0x80;
 	reg[M41T80_REG_ALARM_MIN] |= t->time.tm_min >= 0 ?
@@ -292,7 +301,8 @@ static int m41t80_rtc_set_alarm(struct d
 	else
 		reg[M41T80_REG_ALARM_DAY] |= 0x40;
 
-	if (i2c_transfer(client->adapter, msgs, 1) != 1) {
+	if (m41t80_write_block_data(client, M41T80_REG_ALARM_MON,
+				    M41T80_ALARM_REG_SIZE, buf) < 0) {
 		dev_err(&client->dev, "write error\n");
 		return -EIO;
 	}
@@ -312,24 +322,10 @@ static int m41t80_rtc_read_alarm(struct 
 {
 	struct i2c_client *client = to_i2c_client(dev);
 	u8 buf[M41T80_ALARM_REG_SIZE + 1]; /* all alarm regs and flags */
-	u8 dt_addr[1] = { M41T80_REG_ALARM_MON };
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
+	if (m41t80_read_block_data(client, M41T80_REG_ALARM_MON,
+				   M41T80_ALARM_REG_SIZE + 1, buf) < 0) {
 		dev_err(&client->dev, "read error\n");
 		return -EIO;
 	}
@@ -488,26 +484,16 @@ static int boot_flag;
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
+	i2c_smbus_write_byte_data(save_client, M41T80_REG_WATCHDOG, wdt);
 }
 
 /**
@@ -517,36 +503,8 @@ static void wdt_ping(void)
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
+	i2c_smbus_read_byte_data(save_client, M41T80_REG_WATCHDOG);
+	i2c_smbus_write_byte_data(save_client, M41T80_REG_WATCHDOG, 0);
 }
 
 /**
@@ -737,8 +695,8 @@ static int m41t80_probe(struct i2c_clien
 	struct rtc_time tm;
 	struct m41t80_data *clientdata = NULL;
 
-	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C
-				     | I2C_FUNC_SMBUS_BYTE_DATA)) {
+	if (!i2c_check_functionality(client->adapter,
+				     I2C_FUNC_SMBUS_BYTE_DATA)) {
 		rc = -ENODEV;
 		goto exit;
 	}
