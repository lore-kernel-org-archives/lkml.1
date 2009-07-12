Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZGLS2u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZGLS2u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:28:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754597AbZGLS2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:28:43 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:46852 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584AbZGLS2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:28:42 -0400
X-Greylist: delayed 1127 seconds by postgrey-1.27 at vger.kernel.org; Sun, 12 Jul 2009 14:28:42 EDT
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 01/15] power: bq27x00: rename to bq27200.c
Date: Sun, 12 Jul 2009 21:09:23 +0300
Message-Id: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That driver only really works for the i2c-based device
bq27200, so rename the file and all defines.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/Kconfig                              |    2 +-
 drivers/power/Makefile                             |    2 +-
 .../power/{bq27x00_battery.c => bq27200_battery.c} |   99 ++++++++++----------
 3 files changed, 52 insertions(+), 51 deletions(-)
 rename drivers/power/{bq27x00_battery.c => bq27200_battery.c} (73%)

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 7eda348..6e087a4 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -69,7 +69,7 @@ config BATTERY_WM97XX
 	help
 	  Say Y to enable support for battery measured by WM97xx aux port.
 
-config BATTERY_BQ27x00
+config BATTERY_BQ27200
 	tristate "BQ27200 battery driver"
 	depends on I2C
 	help
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index daf3179..5288595 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -23,7 +23,7 @@ obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
 obj-$(CONFIG_BATTERY_OLPC)	+= olpc_battery.o
 obj-$(CONFIG_BATTERY_TOSA)	+= tosa_battery.o
 obj-$(CONFIG_BATTERY_WM97XX)	+= wm97xx_battery.o
-obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
+obj-$(CONFIG_BATTERY_BQ27200)	+= bq27200_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27200_battery.c
similarity index 73%
rename from drivers/power/bq27x00_battery.c
rename to drivers/power/bq27200_battery.c
index 62bb981..f31f167 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -1,5 +1,5 @@
 /*
- * BQ27x00 battery driver
+ * BQ27200 battery driver
  *
  * Copyright (C) 2008 Rodolfo Giometti <giometti@linux.it>
  * Copyright (C) 2008 Eurotech S.p.A. <info@eurotech.it>
@@ -28,11 +28,11 @@
 
 #define DRIVER_VERSION			"1.0.0"
 
-#define BQ27x00_REG_TEMP		0x06
-#define BQ27x00_REG_VOLT		0x08
-#define BQ27x00_REG_RSOC		0x0B /* Relative State-of-Charge */
-#define BQ27x00_REG_AI			0x14
-#define BQ27x00_REG_FLAGS		0x0A
+#define BQ27200_REG_TEMP		0x06
+#define BQ27200_REG_VOLT		0x08
+#define BQ27200_REG_RSOC		0x0B /* Relative State-of-Charge */
+#define BQ27200_REG_AI			0x14
+#define BQ27200_REG_FLAGS		0x0A
 
 /* If the system has several batteries we need a different name for each
  * of them...
@@ -40,26 +40,26 @@
 static DEFINE_IDR(battery_id);
 static DEFINE_MUTEX(battery_mutex);
 
-struct bq27x00_device_info;
-struct bq27x00_access_methods {
+struct bq27200_device_info;
+struct bq27200_access_methods {
 	int (*read)(u8 reg, int *rt_value, int b_single,
-		struct bq27x00_device_info *di);
+		struct bq27200_device_info *di);
 };
 
-struct bq27x00_device_info {
+struct bq27200_device_info {
 	struct device 		*dev;
 	int			id;
 	int			voltage_uV;
 	int			current_uA;
 	int			temp_C;
 	int			charge_rsoc;
-	struct bq27x00_access_methods	*bus;
+	struct bq27200_access_methods	*bus;
 	struct power_supply	bat;
 
 	struct i2c_client	*client;
 };
 
-static enum power_supply_property bq27x00_battery_props[] = {
+static enum power_supply_property bq27200_props[] = {
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
@@ -68,11 +68,11 @@ static enum power_supply_property bq27x00_battery_props[] = {
 };
 
 /*
- * Common code for BQ27x00 devices
+ * Common code for BQ27200 devices
  */
 
-static int bq27x00_read(u8 reg, int *rt_value, int b_single,
-			struct bq27x00_device_info *di)
+static int bq27200_read(u8 reg, int *rt_value, int b_single,
+			struct bq27200_device_info *di)
 {
 	int ret;
 
@@ -86,12 +86,12 @@ static int bq27x00_read(u8 reg, int *rt_value, int b_single,
  * Return the battery temperature in Celsius degrees
  * Or < 0 if something fails.
  */
-static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
+static int bq27200_temperature(struct bq27200_device_info *di)
 {
 	int ret;
 	int temp = 0;
 
-	ret = bq27x00_read(BQ27x00_REG_TEMP, &temp, 0, di);
+	ret = bq27200_read(BQ27200_REG_TEMP, &temp, 0, di);
 	if (ret) {
 		dev_err(di->dev, "error reading temperature\n");
 		return ret;
@@ -104,12 +104,12 @@ static int bq27x00_battery_temperature(struct bq27x00_device_info *di)
  * Return the battery Voltage in milivolts
  * Or < 0 if something fails.
  */
-static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
+static int bq27200_voltage(struct bq27200_device_info *di)
 {
 	int ret;
 	int volt = 0;
 
-	ret = bq27x00_read(BQ27x00_REG_VOLT, &volt, 0, di);
+	ret = bq27200_read(BQ27200_REG_VOLT, &volt, 0, di);
 	if (ret) {
 		dev_err(di->dev, "error reading voltage\n");
 		return ret;
@@ -123,18 +123,18 @@ static int bq27x00_battery_voltage(struct bq27x00_device_info *di)
  * Note that current can be negative signed as well
  * Or 0 if something fails.
  */
-static int bq27x00_battery_current(struct bq27x00_device_info *di)
+static int bq27200_current(struct bq27200_device_info *di)
 {
 	int ret;
 	int curr = 0;
 	int flags = 0;
 
-	ret = bq27x00_read(BQ27x00_REG_AI, &curr, 0, di);
+	ret = bq27200_read(BQ27200_REG_AI, &curr, 0, di);
 	if (ret) {
 		dev_err(di->dev, "error reading current\n");
 		return 0;
 	}
-	ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
+	ret = bq27200_read(BQ27200_REG_FLAGS, &flags, 0, di);
 	if (ret < 0) {
 		dev_err(di->dev, "error reading flags\n");
 		return 0;
@@ -150,12 +150,12 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
  * Return the battery Relative State-of-Charge
  * Or < 0 if something fails.
  */
-static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
+static int bq27200_rsoc(struct bq27200_device_info *di)
 {
 	int ret;
 	int rsoc = 0;
 
-	ret = bq27x00_read(BQ27x00_REG_RSOC, &rsoc, 1, di);
+	ret = bq27200_read(BQ27200_REG_RSOC, &rsoc, 1, di);
 	if (ret) {
 		dev_err(di->dev, "error reading relative State-of-Charge\n");
 		return ret;
@@ -164,30 +164,30 @@ static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
 	return rsoc >> 8;
 }
 
-#define to_bq27x00_device_info(x) container_of((x), \
-				struct bq27x00_device_info, bat);
+#define to_bq27200_device_info(x) container_of((x), \
+				struct bq27200_device_info, bat);
 
-static int bq27x00_battery_get_property(struct power_supply *psy,
+static int bq27200_get_property(struct power_supply *psy,
 					enum power_supply_property psp,
 					union power_supply_propval *val)
 {
-	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
+	struct bq27200_device_info *di = to_bq27200_device_info(psy);
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = bq27x00_battery_voltage(di);
+		val->intval = bq27200_voltage(di);
 		if (psp == POWER_SUPPLY_PROP_PRESENT)
 			val->intval = val->intval <= 0 ? 0 : 1;
 		break;
 	case POWER_SUPPLY_PROP_CURRENT_NOW:
-		val->intval = bq27x00_battery_current(di);
+		val->intval = bq27200_current(di);
 		break;
 	case POWER_SUPPLY_PROP_CAPACITY:
-		val->intval = bq27x00_battery_rsoc(di);
+		val->intval = bq27200_rsoc(di);
 		break;
 	case POWER_SUPPLY_PROP_TEMP:
-		val->intval = bq27x00_battery_temperature(di);
+		val->intval = bq27200_temperature(di);
 		break;
 	default:
 		return -EINVAL;
@@ -196,12 +196,12 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	return 0;
 }
 
-static void bq27x00_powersupply_init(struct bq27x00_device_info *di)
+static void bq27200_powersupply_init(struct bq27200_device_info *di)
 {
 	di->bat.type = POWER_SUPPLY_TYPE_BATTERY;
-	di->bat.properties = bq27x00_battery_props;
-	di->bat.num_properties = ARRAY_SIZE(bq27x00_battery_props);
-	di->bat.get_property = bq27x00_battery_get_property;
+	di->bat.properties = bq27200_props;
+	di->bat.num_properties = ARRAY_SIZE(bq27200_props);
+	di->bat.get_property = bq27200_get_property;
 	di->bat.external_power_changed = NULL;
 }
 
@@ -209,8 +209,8 @@ static void bq27x00_powersupply_init(struct bq27x00_device_info *di)
  * BQ27200 specific code
  */
 
-static int bq27200_read(u8 reg, int *rt_value, int b_single,
-			struct bq27x00_device_info *di)
+static int _bq27200_read(u8 reg, int *rt_value, int b_single,
+			struct bq27200_device_info *di)
 {
 	struct i2c_client *client = di->client;
 	struct i2c_msg msg[1];
@@ -252,8 +252,8 @@ static int bq27200_battery_probe(struct i2c_client *client,
 				 const struct i2c_device_id *id)
 {
 	char *name;
-	struct bq27x00_device_info *di;
-	struct bq27x00_access_methods *bus;
+	struct bq27200_device_info *di;
+	struct bq27200_access_methods *bus;
 	int num;
 	int retval = 0;
 
@@ -293,11 +293,11 @@ static int bq27200_battery_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, di);
 	di->dev = &client->dev;
 	di->bat.name = name;
-	bus->read = &bq27200_read;
+	bus->read = &_bq27200_read;
 	di->bus = bus;
 	di->client = client;
 
-	bq27x00_powersupply_init(di);
+	bq27200_powersupply_init(di);
 
 	retval = power_supply_register(&client->dev, &di->bat);
 	if (retval) {
@@ -325,7 +325,7 @@ batt_failed_1:
 
 static int bq27200_battery_remove(struct i2c_client *client)
 {
-	struct bq27x00_device_info *di = i2c_get_clientdata(client);
+	struct bq27200_device_info *di = i2c_get_clientdata(client);
 
 	power_supply_unregister(&di->bat);
 
@@ -351,14 +351,14 @@ static const struct i2c_device_id bq27200_id[] = {
 
 static struct i2c_driver bq27200_battery_driver = {
 	.driver = {
-		.name = "bq27200-battery",
+		.name = "bq27200",
 	},
 	.probe = bq27200_battery_probe,
 	.remove = bq27200_battery_remove,
 	.id_table = bq27200_id,
 };
 
-static int __init bq27x00_battery_init(void)
+static int __init bq27200_init(void)
 {
 	int ret;
 
@@ -368,14 +368,15 @@ static int __init bq27x00_battery_init(void)
 
 	return ret;
 }
-module_init(bq27x00_battery_init);
+module_init(bq27200_init);
 
-static void __exit bq27x00_battery_exit(void)
+static void __exit bq27200_exit(void)
 {
 	i2c_del_driver(&bq27200_battery_driver);
 }
-module_exit(bq27x00_battery_exit);
+module_exit(bq27200_exit);
 
 MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
-MODULE_DESCRIPTION("BQ27x00 battery monitor driver");
+MODULE_DESCRIPTION("BQ27200 battery monitor driver");
 MODULE_LICENSE("GPL");
+
-- 
1.6.1.3

