Return-Path: <linux-kernel-owner+w=401wt.eu-S1755654AbZGLSau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654AbZGLSau (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:30:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755335AbZGLS3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:29:42 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:47002 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbZGLS3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:29:41 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 04/15] power: bq27200: simplify read by using smbus
Date: Sun, 12 Jul 2009 21:09:26 +0300
Message-Id: <1247422177-7329-4-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-3-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the chip supports smbus protocol, so let's use it and simply
register read/write.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |  135 ++++++++-------------------------------
 1 files changed, 28 insertions(+), 107 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index 3eb0f5a..eddb731 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -32,22 +32,14 @@
 #define BQ27200_REG_AI			0x14
 #define BQ27200_REG_FLAGS		0x0A
 
-struct bq27200_device_info;
-struct bq27200_access_methods {
-	int (*read)(u8 reg, int *rt_value, int b_single,
-		struct bq27200_device_info *di);
-};
-
 struct bq27200_device_info {
-	struct device		*dev;
+	struct power_supply	bat;
+	struct i2c_client	*client;
+
+	int			charge_rsoc;
 	int			voltage_uV;
 	int			current_uA;
 	int			temp_C;
-	int			charge_rsoc;
-	struct bq27200_access_methods	*bus;
-	struct power_supply	bat;
-
-	struct i2c_client	*client;
 };
 
 #define to_bq27200_device_info(x) container_of((x), \
@@ -65,15 +57,15 @@ static enum power_supply_property bq27200_props[] = {
  * Common code for BQ27200 devices
  */
 
-static int bq27200_read(u8 reg, int *rt_value, int b_single,
-			struct bq27200_device_info *di)
+static inline int bq27200_read(struct bq27200_device_info *di, u8 reg)
 {
-	int ret;
-
-	ret = di->bus->read(reg, rt_value, b_single, di);
-	*rt_value = be16_to_cpu(*rt_value);
+	return i2c_smbus_read_word_data(di->client, reg);
+}
 
-	return ret;
+static inline int bq27200_write(struct bq27200_device_info *di,
+		u8 reg, u8 data)
+{
+	return i2c_smbus_write_word_data(di->client, reg, data);
 }
 
 /*
@@ -83,15 +75,14 @@ static int bq27200_read(u8 reg, int *rt_value, int b_single,
 static int bq27200_temperature(struct bq27200_device_info *di)
 {
 	int ret;
-	int temp = 0;
 
-	ret = bq27200_read(BQ27200_REG_TEMP, &temp, 0, di);
-	if (ret) {
-		dev_err(di->dev, "error reading temperature\n");
+	ret = bq27200_read(di, BQ27200_REG_TEMP);
+	if (ret < 0) {
+		dev_err(&di->client->dev, "error reading temperature\n");
 		return ret;
 	}
 
-	return (temp >> 2) - 273;
+	return (ret >> 2) - 273;
 }
 
 /*
@@ -101,15 +92,12 @@ static int bq27200_temperature(struct bq27200_device_info *di)
 static int bq27200_voltage(struct bq27200_device_info *di)
 {
 	int ret;
-	int volt = 0;
 
-	ret = bq27200_read(BQ27200_REG_VOLT, &volt, 0, di);
-	if (ret) {
-		dev_err(di->dev, "error reading voltage\n");
-		return ret;
-	}
+	ret = bq27200_read(di, BQ27200_REG_VOLT);
+	if (ret < 0)
+		dev_err(&di->client->dev, "error reading voltage\n");
 
-	return volt;
+	return ret;
 }
 
 /*
@@ -120,25 +108,14 @@ static int bq27200_voltage(struct bq27200_device_info *di)
 static int bq27200_current(struct bq27200_device_info *di)
 {
 	int ret;
-	int curr = 0;
-	int flags = 0;
 
-	ret = bq27200_read(BQ27200_REG_AI, &curr, 0, di);
-	if (ret) {
-		dev_err(di->dev, "error reading current\n");
-		return 0;
-	}
-	ret = bq27200_read(BQ27200_REG_FLAGS, &flags, 0, di);
+	ret = bq27200_read(di, BQ27200_REG_AI);
 	if (ret < 0) {
-		dev_err(di->dev, "error reading flags\n");
+		dev_err(&di->client->dev, "error reading current\n");
 		return 0;
 	}
-	if ((flags & (1 << 7)) != 0) {
-		dev_dbg(di->dev, "negative current!\n");
-		return -curr;
-	}
 
-	return curr;
+	return ret;
 }
 
 /*
@@ -148,15 +125,14 @@ static int bq27200_current(struct bq27200_device_info *di)
 static int bq27200_rsoc(struct bq27200_device_info *di)
 {
 	int ret;
-	int rsoc = 0;
 
-	ret = bq27200_read(BQ27200_REG_RSOC, &rsoc, 1, di);
-	if (ret) {
-		dev_err(di->dev, "error reading relative State-of-Charge\n");
+	ret = bq27200_read(di, BQ27200_REG_RSOC);
+	if (ret < 0) {
+		dev_err(&di->client->dev, "error reading relative State-of-Charge\n");
 		return ret;
 	}
 
-	return rsoc >> 8;
+	return ret >> 8;
 }
 
 static int bq27200_get_property(struct power_supply *psy,
@@ -197,51 +173,10 @@ static void bq27200_powersupply_init(struct bq27200_device_info *di)
 	di->bat.external_power_changed = NULL;
 }
 
-static int _bq27200_read(u8 reg, int *rt_value, int b_single,
-			struct bq27200_device_info *di)
-{
-	struct i2c_client *client = di->client;
-	struct i2c_msg msg[1];
-	unsigned char data[2];
-	int err;
-
-	if (!client->adapter)
-		return -ENODEV;
-
-	msg->addr = client->addr;
-	msg->flags = 0;
-	msg->len = 1;
-	msg->buf = data;
-
-	data[0] = reg;
-	err = i2c_transfer(client->adapter, msg, 1);
-
-	if (err >= 0) {
-		if (!b_single)
-			msg->len = 2;
-		else
-			msg->len = 1;
-
-		msg->flags = I2C_M_RD;
-		err = i2c_transfer(client->adapter, msg, 1);
-		if (err >= 0) {
-			if (!b_single)
-				*rt_value = get_unaligned_be16(data);
-			else
-				*rt_value = data[0];
-
-			return 0;
-		}
-	}
-
-	return err;
-}
-
 static int bq27200_battery_probe(struct i2c_client *client,
 				 const struct i2c_device_id *id)
 {
 	struct bq27200_device_info *di;
-	struct bq27200_access_methods *bus;
 	int retval = 0;
 
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
@@ -251,19 +186,9 @@ static int bq27200_battery_probe(struct i2c_client *client,
 		goto batt_failed_1;
 	}
 
-	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
-	if (!bus) {
-		dev_err(&client->dev, "failed to allocate access method "
-					"data\n");
-		retval = -ENOMEM;
-		goto batt_failed_2;
-	}
-
 	i2c_set_clientdata(client, di);
-	di->dev = &client->dev;
+	di->client = client;
 	di->bat.name = client->name;
-	bus->read = _bq27200_read;
-	di->bus = bus;
 	di->client = client;
 
 	bq27200_powersupply_init(di);
@@ -271,14 +196,11 @@ static int bq27200_battery_probe(struct i2c_client *client,
 	retval = power_supply_register(&client->dev, &di->bat);
 	if (retval) {
 		dev_err(&client->dev, "failed to register battery\n");
-		goto batt_failed_3;
+		goto batt_failed_2;
 	}
 
 	return 0;
 
-batt_failed_3:
-	kfree(bus);
-
 batt_failed_2:
 	kfree(di);
 
@@ -291,7 +213,6 @@ static int bq27200_battery_remove(struct i2c_client *client)
 	struct bq27200_device_info *di = i2c_get_clientdata(client);
 
 	power_supply_unregister(&di->bat);
-	kfree(di->bat.name);
 	kfree(di);
 
 	return 0;
-- 
1.6.1.3

