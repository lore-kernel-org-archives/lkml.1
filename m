Return-Path: <linux-kernel-owner+w=401wt.eu-S1756025AbZGLScU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756025AbZGLScU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 14:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755755AbZGLSb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 14:31:27 -0400
Received: from ns1.siteground211.com ([209.62.36.12]:47239 "EHLO
	serv01.siteground211.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755924AbZGLSb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 14:31:26 -0400
From: Felipe Balbi <me@felipebalbi.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <me@felipebalbi.com>
Subject: [rfc/patch 02/15] power: bq27200: this is an i2c device
Date: Sun, 12 Jul 2009 21:09:24 +0300
Message-Id: <1247422177-7329-2-git-send-email-me@felipebalbi.com>
X-Mailer: git-send-email 1.6.4.rc0.17.gd9eb0
In-Reply-To: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
References: <1247422177-7329-1-git-send-email-me@felipebalbi.com>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - serv01.siteground211.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - felipebalbi.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... with hardcoded device address so i2c subsystem won't
talk to more than one of those.

Signed-off-by: Felipe Balbi <me@felipebalbi.com>
---
 drivers/power/bq27200_battery.c |   55 +++++---------------------------------
 1 files changed, 8 insertions(+), 47 deletions(-)

diff --git a/drivers/power/bq27200_battery.c b/drivers/power/bq27200_battery.c
index f31f167..1978cd9 100644
--- a/drivers/power/bq27200_battery.c
+++ b/drivers/power/bq27200_battery.c
@@ -22,9 +22,7 @@
 #include <linux/delay.h>
 #include <linux/platform_device.h>
 #include <linux/power_supply.h>
-#include <linux/idr.h>
 #include <linux/i2c.h>
-#include <asm/unaligned.h>
 
 #define DRIVER_VERSION			"1.0.0"
 
@@ -34,12 +32,6 @@
 #define BQ27200_REG_AI			0x14
 #define BQ27200_REG_FLAGS		0x0A
 
-/* If the system has several batteries we need a different name for each
- * of them...
- */
-static DEFINE_IDR(battery_id);
-static DEFINE_MUTEX(battery_mutex);
-
 struct bq27200_device_info;
 struct bq27200_access_methods {
 	int (*read)(u8 reg, int *rt_value, int b_single,
@@ -48,7 +40,6 @@ struct bq27200_access_methods {
 
 struct bq27200_device_info {
 	struct device 		*dev;
-	int			id;
 	int			voltage_uV;
 	int			current_uA;
 	int			temp_C;
@@ -251,48 +242,28 @@ static int _bq27200_read(u8 reg, int *rt_value, int b_single,
 static int bq27200_battery_probe(struct i2c_client *client,
 				 const struct i2c_device_id *id)
 {
-	char *name;
 	struct bq27200_device_info *di;
 	struct bq27200_access_methods *bus;
-	int num;
 	int retval = 0;
 
-	/* Get new ID for the new battery device */
-	retval = idr_pre_get(&battery_id, GFP_KERNEL);
-	if (retval == 0)
-		return -ENOMEM;
-	mutex_lock(&battery_mutex);
-	retval = idr_get_new(&battery_id, client, &num);
-	mutex_unlock(&battery_mutex);
-	if (retval < 0)
-		return retval;
-
-	name = kasprintf(GFP_KERNEL, "bq27200-%d", num);
-	if (!name) {
-		dev_err(&client->dev, "failed to allocate device name\n");
-		retval = -ENOMEM;
-		goto batt_failed_1;
-	}
-
 	di = kzalloc(sizeof(*di), GFP_KERNEL);
 	if (!di) {
 		dev_err(&client->dev, "failed to allocate device info data\n");
 		retval = -ENOMEM;
-		goto batt_failed_2;
+		goto batt_failed_1;
 	}
-	di->id = num;
 
 	bus = kzalloc(sizeof(*bus), GFP_KERNEL);
 	if (!bus) {
 		dev_err(&client->dev, "failed to allocate access method "
 					"data\n");
 		retval = -ENOMEM;
-		goto batt_failed_3;
+		goto batt_failed_2;
 	}
 
 	i2c_set_clientdata(client, di);
 	di->dev = &client->dev;
-	di->bat.name = name;
+	di->bat.name = client->name;
 	bus->read = &_bq27200_read;
 	di->bus = bus;
 	di->client = client;
@@ -302,24 +273,20 @@ static int bq27200_battery_probe(struct i2c_client *client,
 	retval = power_supply_register(&client->dev, &di->bat);
 	if (retval) {
 		dev_err(&client->dev, "failed to register battery\n");
-		goto batt_failed_4;
+		goto batt_failed_3;
 	}
 
 	dev_info(&client->dev, "support ver. %s enabled\n", DRIVER_VERSION);
 
 	return 0;
 
-batt_failed_4:
-	kfree(bus);
 batt_failed_3:
-	kfree(di);
+	kfree(bus);
+
 batt_failed_2:
-	kfree(name);
-batt_failed_1:
-	mutex_lock(&battery_mutex);
-	idr_remove(&battery_id, num);
-	mutex_unlock(&battery_mutex);
+	kfree(di);
 
+batt_failed_1:
 	return retval;
 }
 
@@ -328,13 +295,7 @@ static int bq27200_battery_remove(struct i2c_client *client)
 	struct bq27200_device_info *di = i2c_get_clientdata(client);
 
 	power_supply_unregister(&di->bat);
-
 	kfree(di->bat.name);
-
-	mutex_lock(&battery_mutex);
-	idr_remove(&battery_id, di->id);
-	mutex_unlock(&battery_mutex);
-
 	kfree(di);
 
 	return 0;
-- 
1.6.1.3

