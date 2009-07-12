Return-Path: <linux-kernel-owner+w=401wt.eu-S1754743AbZGLS3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbZGLS3g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:29:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755158AbZGLS3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:29:05 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:46914 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbZGLS3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:29:04 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 06/15] power: bq27200: rename structure to something smaller
Date: Sun, 12 Jul 2009 21:09:28 +0300
Message-Id: <1247422177-7329-6-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-5-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
 <1247422177-7329-2-git-send-email-me@felipebalbi.com>
 <1247422177-7329-3-git-send-email-me@felipebalbi.com>
 <1247422177-7329-4-git-send-email-me@felipebalbi.com>
 <1247422177-7329-5-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

the previous name was quite big, rename to something smaller.

Trivial patch.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   91 +++++++++++++++++++--------------------
 1 files changed, 45 insertions(+), 46 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index deef1b5..44375d6 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -32,7 +32,7 @@
 #define BQ27200_REG_AI			0x14
 #define BQ27200_REG_FLAGS		0x0A
 
-struct bq27200_device_info {
+struct bq27200 {
 	struct power_supply	bat;
 	struct i2c_client	*client;
 
@@ -42,8 +42,7 @@ struct bq27200_device_info {
 	int			temp_C;
 };
 
-#define to_bq27200_device_info(x) container_of((x), \
-				struct bq27200_device_info, bat);
+#define to_bq27200(x) container_of((x), struct bq27200, bat);
 
 static enum power_supply_property bq27200_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
@@ -57,28 +56,27 @@ static enum power_supply_property bq27200_props[] = {
  * Common code for BQ27200 devices
  */
 
-static inline int bq27200_read(struct bq27200_device_info *di, u8 reg)
+static inline int bq27200_read(struct bq27200 *bq, u8 reg)
 {
-	return i2c_smbus_read_word_data(di->client, reg);
+	return i2c_smbus_read_word_data(bq->client, reg);
 }
 
-static inline int bq27200_write(struct bq27200_device_info *di,
-		u8 reg, u8 data)
+static inline int bq27200_write(struct bq27200 *bq, u8 reg, u8 data)
 {
-	return i2c_smbus_write_word_data(di->client, reg, data);
+	return i2c_smbus_write_word_data(bq->client, reg, data);
 }
 
 /*
  * Return the battery temperature in Celsius degrees
  * Or < 0 if something fails.
  */
-static int bq27200_temperature(struct bq27200_device_info *di)
+static int bq27200_temperature(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(di, BQ27200_REG_TEMP);
+	ret = bq27200_read(bq, BQ27200_REG_TEMP);
 	if (ret < 0) {
-		dev_err(&di->client->dev, "error reading temperature\n");
+		dev_err(&bq->client->dev, "error reading temperature\n");
 		return ret;
 	}
 
@@ -89,13 +87,13 @@ static int bq27200_temperature(struct bq27200_device_info *di)
  * Return the battery Voltage in milivolts
  * Or < 0 if something fails.
  */
-static int bq27200_voltage(struct bq27200_device_info *di)
+static int bq27200_voltage(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(di, BQ27200_REG_VOLT);
+	ret = bq27200_read(bq, BQ27200_REG_VOLT);
 	if (ret < 0)
-		dev_err(&di->client->dev, "error reading voltage\n");
+		dev_err(&bq->client->dev, "error reading voltage\n");
 
 	return ret;
 }
@@ -105,13 +103,13 @@ static int bq27200_voltage(struct bq27200_device_info *di)
  * Note that current can be negative signed as well
  * Or 0 if something fails.
  */
-static int bq27200_current(struct bq27200_device_info *di)
+static int bq27200_current(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(di, BQ27200_REG_AI);
+	ret = bq27200_read(bq, BQ27200_REG_AI);
 	if (ret < 0) {
-		dev_err(&di->client->dev, "error reading current\n");
+		dev_err(&bq->client->dev, "error reading current\n");
 		return 0;
 	}
 
@@ -122,13 +120,13 @@ static int bq27200_current(struct bq27200_device_info *di)
  * Return the battery Relative State-of-Charge
  * Or < 0 if something fails.
  */
-static int bq27200_rsoc(struct bq27200_device_info *di)
+static int bq27200_rsoc(struct bq27200 *bq)
 {
 	int ret;
 
-	ret = bq27200_read(di, BQ27200_REG_RSOC);
+	ret = bq27200_read(bq, BQ27200_REG_RSOC);
 	if (ret < 0) {
-		dev_err(&di->client->dev, "error reading relative State-of-Charge\n");
+		dev_err(&bq->client->dev, "error reading relative State-of-Charge\n");
 		return ret;
 	}
 
@@ -136,26 +134,28 @@ static int bq27200_rsoc(struct bq27200_device_info *di)
 }
 
 static int bq27200_get_property(struct power_supply *psy,
-					enum power_supply_property psp,
-					union power_supply_propval *val)
+		enum power_supply_property psp, union power_supply_propval *val)
 {
-	struct bq27200_device_info *di = to_bq27200_device_info(psy);
+	struct bq27200 *bq = to_bq27200(psy);
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = bq27200_voltage(di);
+		val->intval = bq27200_voltage(bq);
+		if (val->intval < 0)
+			return val->intval;
+
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
-			val->intval = val->intval <= 0 ? 0 : 1;
+			val->intval = !!val->intval;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = bq27200_current(di);
+		val->intval = bq27200_current(bq);
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = bq27200_rsoc(di);
+		val->intval = bq27200_rsoc(bq);
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = bq27200_temperature(di);
+		val->intval = bq27200_temperature(bq);
 		break;
 	default:
 		return -EINVAL;
@@ -165,30 +165,29 @@ static int bq27200_get_property(struct power_supply *psy,
 }
 
 static int bq27200_battery_probe(struct i2c_client *client,
-				 const struct i2c_device_id *id)
+		const struct i2c_device_id *id)
 {
-	struct bq27200_device_info *di;
+	struct bq27200 *bq;
 	int retval = 0;
 
-	di = kzalloc(sizeof(*di), GFP_KERNEL);
-	if (!di) {
+	bq = kzalloc(sizeof(*bq), GFP_KERNEL);
+	if (!bq) {
 		dev_err(&client->dev, "failed to allocate device info data\n");
 		retval = -ENOMEM;
 		goto batt_failed_1;
 	}
 
-	i2c_set_clientdata(client, di);
-	di->client = client;
-	di->bat.name = client->name;
-	di->client = client;
+	i2c_set_clientdata(client, bq);
+	bq->client = client;
+	bq->bat.name = client->name;
+	bq->client = client;
 
-	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
-	di->bat.properties = bq27200_props;
-	di->bat.num_properties = ARRAY_SIZE(bq27200_props);
-	di->bat.get_property = bq27200_get_property;
-	di->bat.external_power_changed = NULL;
+	bq->bat.type = POWER_SUPPLY_TYPE_BATTERY;
+	bq->bat.properties = bq27200_props;
+	bq->bat.num_properties = ARRAY_SIZE(bq27200_props);
+	bq->bat.get_property = bq27200_get_property;
 
-	retval = power_supply_register(&client->dev, &di->bat);
+	retval = power_supply_register(&client->dev, &bq->bat);
 	if (retval) {
 		dev_err(&client->dev, "failed to register battery\n");
 		goto batt_failed_2;
@@ -197,7 +196,7 @@ static int bq27200_battery_probe(struct i2c_client *client,
 	return 0;
 
 batt_failed_2:
-	kfree(di);
+	kfree(bq);
 
 batt_failed_1:
 	return retval;
@@ -205,10 +204,10 @@ batt_failed_1:
 
 static int bq27200_battery_remove(struct i2c_client *client)
 {
-	struct bq27200_device_info *di = i2c_get_clientdata(client);
+	struct bq27200 *bq = i2c_get_clientdata(client);
 
-	power_supply_unregister(&di->bat);
-	kfree(di);
+	power_supply_unregister(&bq->bat);
+	kfree(bq);
 
 	return 0;
 }
-- 
1.6.1.3

