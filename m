Return-Path: <linux-kernel-owner+w=401wt.eu-S1422898AbXBAOKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422898AbXBAOKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422900AbXBAOKm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:10:42 -0500
Received: from mba.ocn.ne.jp ([210.190.142.172]:60315 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422898AbXBAOKl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:10:41 -0500
Date: Thu, 01 Feb 2007 23:10:38 +0900 (JST)
Message-Id: <20070201.231038.25910521.anemo@mba.ocn.ne.jp>
To: a.zummo@towertech.it
Cc: rtc-linux@googlegroups.com, linux-kernel@vger.kernel.org,
       jean-baptiste.maneyrol@teamlog.com
Subject: [PATCH] rtc-pcf8563: detect polarity of century bit automatically
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 3.3 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The usage of the century bit was inverted on 2.6.19 following to
PCF8563's description, but it was not match to usage suggested by
RTC8564's datasheet.  Anyway what MO_C=1 means can vary on each
platform.  This patch is to detect its polarity in get_datetime
routine.  The default value of c_polarity is 0 (MO_C=1 means 19xx) so
that this patch does not change current behavior even if get_datetime
was not called before set_datetime.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
diff --git a/drivers/rtc/rtc-pcf8563.c b/drivers/rtc/rtc-pcf8563.c
index 4b72b8e..0100719 100644
--- a/drivers/rtc/rtc-pcf8563.c
+++ b/drivers/rtc/rtc-pcf8563.c
@@ -53,6 +53,25 @@ I2C_CLIENT_INSMOD;
 #define PCF8563_SC_LV		0x80 /* low voltage */
 #define PCF8563_MO_C		0x80 /* century */
 
+struct pcf8563 {
+	struct i2c_client client;
+	/*
+	 * The meaning of MO_C bit varies by the chip type.
+	 * From PCF8563 datasheet: this bit is toggled when the years
+	 * register overflows from 99 to 00
+	 *   0 indicates the century is 20xx
+	 *   1 indicates the century is 19xx
+	 * From RTC8564 datasheet: this bit indicates change of
+	 * century. When the year digit data overflows from 99 to 00,
+	 * this bit is set. By presetting it to 0 while still in the
+	 * 20th century, it will be set in year 2000, ...
+	 * There seems no reliable way to know how the system use this
+	 * bit.  So let's do it heuristically, assuming we are live in
+	 * 1970...2069.
+	 */
+	int c_polarity;	/* 0: MO_C=1 means 19xx, otherwise MO_C=1 means 20xx */
+};
+
 static int pcf8563_probe(struct i2c_adapter *adapter, int address, int kind);
 static int pcf8563_detach(struct i2c_client *client);
 
@@ -62,6 +81,7 @@ static int pcf8563_detach(struct i2c_cli
  */
 static int pcf8563_get_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
+	struct pcf8563 *pcf8563 = container_of(client, struct pcf8563, client);
 	unsigned char buf[13] = { PCF8563_REG_ST1 };
 
 	struct i2c_msg msgs[] = {
@@ -94,8 +114,12 @@ static int pcf8563_get_datetime(struct i
 	tm->tm_mday = BCD2BIN(buf[PCF8563_REG_DM] & 0x3F);
 	tm->tm_wday = buf[PCF8563_REG_DW] & 0x07;
 	tm->tm_mon = BCD2BIN(buf[PCF8563_REG_MO] & 0x1F) - 1; /* rtc mn 1-12 */
-	tm->tm_year = BCD2BIN(buf[PCF8563_REG_YR])
-		+ (buf[PCF8563_REG_MO] & PCF8563_MO_C ? 0 : 100);
+	tm->tm_year = BCD2BIN(buf[PCF8563_REG_YR]);
+	if (tm->tm_year < 70)
+		tm->tm_year += 100;	/* assume we are in 1970...2069 */
+	/* detect the polarity heuristically. see note above. */
+	pcf8563->c_polarity = (buf[PCF8563_REG_MO] & PCF8563_MO_C) ?
+		(tm->tm_year >= 100) : (tm->tm_year < 100);
 
 	dev_dbg(&client->dev, "%s: tm is secs=%d, mins=%d, hours=%d, "
 		"mday=%d, mon=%d, year=%d, wday=%d\n",
@@ -114,6 +138,7 @@ static int pcf8563_get_datetime(struct i
 
 static int pcf8563_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
+	struct pcf8563 *pcf8563 = container_of(client, struct pcf8563, client);
 	int i, err;
 	unsigned char buf[9];
 
@@ -135,7 +160,7 @@ static int pcf8563_set_datetime(struct i
 
 	/* year and century */
 	buf[PCF8563_REG_YR] = BIN2BCD(tm->tm_year % 100);
-	if (tm->tm_year < 100)
+	if (pcf8563->c_polarity ? (tm->tm_year >= 100) : (tm->tm_year < 100))
 		buf[PCF8563_REG_MO] |= PCF8563_MO_C;
 
 	buf[PCF8563_REG_DW] = tm->tm_wday & 0x07;
@@ -248,6 +273,7 @@ static struct i2c_driver pcf8563_driver
 
 static int pcf8563_probe(struct i2c_adapter *adapter, int address, int kind)
 {
+	struct pcf8563 *pcf8563;
 	struct i2c_client *client;
 	struct rtc_device *rtc;
 
@@ -260,11 +286,12 @@ static int pcf8563_probe(struct i2c_adap
 		goto exit;
 	}
 
-	if (!(client = kzalloc(sizeof(struct i2c_client), GFP_KERNEL))) {
+	if (!(pcf8563 = kzalloc(sizeof(struct pcf8563), GFP_KERNEL))) {
 		err = -ENOMEM;
 		goto exit;
 	}
 
+	client = &pcf8563->client;
 	client->addr = address;
 	client->driver = &pcf8563_driver;
 	client->adapter	= adapter;
@@ -301,7 +328,7 @@ exit_detach:
 	i2c_detach_client(client);
 
 exit_kfree:
-	kfree(client);
+	kfree(pcf8563);
 
 exit:
 	return err;
