Return-Path: <linux-kernel-owner+w=401wt.eu-S1757491AbYAFMaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491AbYAFMaf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 07:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbYAFMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 07:30:28 -0500
Received: from fk-out-0910.google.com ([209.85.128.186]:29577 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbYAFMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 07:30:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=BVZdpZx/eP6KUjMA3nD50uUqkVtU81hDJZjj0V//kv2UhMV8rhWnxV7kIjPLnsV0aykp/MVFRUczB9ObLRo1TGa27jYoXwoofZ8gDHtEnbwFK0xpdTqr1zud2Ss19CVcmdlVyNwWsISCwlMiFcgep6+QirSEE2Nli40T5OmXgCs=
Date: Sun, 6 Jan 2008 15:30:16 +0300
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: cbouatmailru@gmail.com, linux-kernel@vger.kernel.org, cbou@mail.ru,
       dwmw2@infradead.org
Subject: [PATCH 3/3]
Message-ID: <20080106123016.GA13324@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support using VOLTAGE_* properties for apm calculations. It's pretty
dummy, but useful for batteries for which we can only get voltages.

diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index bbf3ee1..526c96e 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -13,6 +13,12 @@
 #include <linux/power_supply.h>
 #include <linux/apm-emulation.h>
 
+typedef enum {
+	SOURCE_ENERGY,
+	SOURCE_CHARGE,
+	SOURCE_VOLTAGE,
+} apm_source;
+
 #define PSY_PROP(psy, prop, val) psy->get_property(psy, \
 			 POWER_SUPPLY_PROP_##prop, val)
 
@@ -87,7 +93,7 @@ static void find_main_battery(void)
 	}
 }
 
-static int calculate_time(int status, int using_charge)
+static int calculate_time(int status, apm_source source)
 {
 	union power_supply_propval full;
 	union power_supply_propval empty;
@@ -106,20 +112,34 @@ static int calculate_time(int status, int using_charge)
 			return -1;
 	}
 
-	if (using_charge) {
+	switch (source) {
+	case SOURCE_CHARGE:
 		full_prop = POWER_SUPPLY_PROP_CHARGE_FULL;
 		full_design_prop = POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN;
 		empty_prop = POWER_SUPPLY_PROP_CHARGE_EMPTY;
 		empty_design_prop = POWER_SUPPLY_PROP_CHARGE_EMPTY;
 		cur_avg_prop = POWER_SUPPLY_PROP_CHARGE_AVG;
 		cur_now_prop = POWER_SUPPLY_PROP_CHARGE_NOW;
-	} else {
+		break;
+	case SOURCE_ENERGY:
 		full_prop = POWER_SUPPLY_PROP_ENERGY_FULL;
 		full_design_prop = POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN;
 		empty_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY;
 		empty_design_prop = POWER_SUPPLY_PROP_CHARGE_EMPTY;
 		cur_avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
 		cur_now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
+		break;
+	case SOURCE_VOLTAGE:
+		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
+		full_design_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN;
+		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;
+		empty_design_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN;
+		cur_avg_prop = POWER_SUPPLY_PROP_VOLTAGE_AVG;
+		cur_now_prop = POWER_SUPPLY_PROP_VOLTAGE_NOW;
+		break;
+	default:
+		printk(KERN_ERR "Unsupported source: %d\n", source);
+		return -1;
 	}
 
 	if (_MPSY_PROP(full_prop, &full)) {
@@ -146,7 +166,7 @@ static int calculate_time(int status, int using_charge)
 		return -((cur.intval - empty.intval) * 60L) / I.intval;
 }
 
-static int calculate_capacity(int using_charge)
+static int calculate_capacity(apm_source source)
 {
 	enum power_supply_property full_prop, empty_prop;
 	enum power_supply_property full_design_prop, empty_design_prop;
@@ -154,20 +174,33 @@ static int calculate_capacity(int using_charge)
 	union power_supply_propval empty, full, cur;
 	int ret;
 
-	if (using_charge) {
+	switch (source) {
+	case SOURCE_CHARGE:
 		full_prop = POWER_SUPPLY_PROP_CHARGE_FULL;
 		empty_prop = POWER_SUPPLY_PROP_CHARGE_EMPTY;
 		full_design_prop = POWER_SUPPLY_PROP_CHARGE_FULL_DESIGN;
 		empty_design_prop = POWER_SUPPLY_PROP_CHARGE_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_CHARGE_NOW;
 		avg_prop = POWER_SUPPLY_PROP_CHARGE_AVG;
-	} else {
+		break;
+	case SOURCE_ENERGY:
 		full_prop = POWER_SUPPLY_PROP_ENERGY_FULL;
 		empty_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY;
 		full_design_prop = POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN;
 		empty_design_prop = POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN;
 		now_prop = POWER_SUPPLY_PROP_ENERGY_NOW;
 		avg_prop = POWER_SUPPLY_PROP_ENERGY_AVG;
+	case SOURCE_VOLTAGE:
+		full_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX;
+		empty_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN;
+		full_design_prop = POWER_SUPPLY_PROP_VOLTAGE_MAX_DESIGN;
+		empty_design_prop = POWER_SUPPLY_PROP_VOLTAGE_MIN_DESIGN;
+		now_prop = POWER_SUPPLY_PROP_VOLTAGE_NOW;
+		avg_prop = POWER_SUPPLY_PROP_VOLTAGE_AVG;
+		break;
+	default:
+		printk(KERN_ERR "Unsupported source: %d\n", source);
+		return -1;
 	}
 
 	if (_MPSY_PROP(full_prop, &full)) {
@@ -234,10 +267,12 @@ static void apm_battery_apm_get_power_status(struct apm_power_info *info)
 		info->battery_life = capacity.intval;
 	} else {
 		/* try calculate using energy */
-		info->battery_life = calculate_capacity(0);
+		info->battery_life = calculate_capacity(SOURCE_ENERGY);
 		/* if failed try calculate using charge instead */
 		if (info->battery_life == -1)
-			info->battery_life = calculate_capacity(1);
+			info->battery_life = calculate_capacity(SOURCE_CHARGE);
+		if (info->battery_life == -1)
+			info->battery_life = calculate_capacity(SOURCE_VOLTAGE);
 	}
 
 	/* charging status */
@@ -263,18 +298,22 @@ static void apm_battery_apm_get_power_status(struct apm_power_info *info)
 				!MPSY_PROP(TIME_TO_FULL_NOW, &time_to_full)) {
 			info->time = time_to_full.intval / 60;
 		} else {
-			info->time = calculate_time(status.intval, 0);
+			info->time = calculate_time(status.intval, SOURCE_ENERGY);
 			if (info->time == -1)
-				info->time = calculate_time(status.intval, 1);
+				info->time = calculate_time(status.intval, SOURCE_CHARGE);
+			if (info->time == -1)
+				info->time = calculate_time(status.intval, SOURCE_VOLTAGE);
 		}
 	} else {
 		if (!MPSY_PROP(TIME_TO_EMPTY_AVG, &time_to_empty) ||
 			      !MPSY_PROP(TIME_TO_EMPTY_NOW, &time_to_empty)) {
 			info->time = time_to_empty.intval / 60;
 		} else {
-			info->time = calculate_time(status.intval, 0);
+			info->time = calculate_time(status.intval, SOURCE_ENERGY);
+			if (info->time == -1)
+				info->time = calculate_time(status.intval, SOURCE_CHARGE);
 			if (info->time == -1)
-				info->time = calculate_time(status.intval, 1);
+				info->time = calculate_time(status.intval, SOURCE_VOLTAGE);
 		}
 	}
 
-- 
With best wishes
Dmitry

