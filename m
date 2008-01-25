Return-Path: <linux-kernel-owner+w=401wt.eu-S1758415AbYAYIGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758415AbYAYIGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 03:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763988AbYAYH7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:59:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764049AbYAYH7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:59:41 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Dave Young <hidave.darkstar@gmail.com>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 189/196] power supply : use class iteration api
Date: Thu, 24 Jan 2008 23:33:38 -0800
Message-Id: <1201246425-5058-110-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Young <hidave.darkstar@gmail.com>

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/power/apm_power.c         |  116 +++++++++++++++++++++---------------
 drivers/power/power_supply_core.c |   74 ++++++++++++-----------
 2 files changed, 107 insertions(+), 83 deletions(-)

diff --git a/drivers/power/apm_power.c b/drivers/power/apm_power.c
index bbf3ee1..7e29b90 100644
--- a/drivers/power/apm_power.c
+++ b/drivers/power/apm_power.c
@@ -13,6 +13,7 @@
 #include <linux/power_supply.h>
 #include <linux/apm-emulation.h>
 
+static DEFINE_MUTEX(apm_mutex);
 #define PSY_PROP(psy, prop, val) psy->get_property(psy, \
 			 POWER_SUPPLY_PROP_##prop, val)
 
@@ -23,67 +24,86 @@
 
 static struct power_supply *main_battery;
 
-static void find_main_battery(void)
-{
-	struct device *dev;
-	struct power_supply *bat = NULL;
-	struct power_supply *max_charge_bat = NULL;
-	struct power_supply *max_energy_bat = NULL;
+struct find_bat_param {
+	struct power_supply *main;
+	struct power_supply *bat;
+	struct power_supply *max_charge_bat;
+	struct power_supply *max_energy_bat;
 	union power_supply_propval full;
-	int max_charge = 0;
-	int max_energy = 0;
+	int max_charge;
+	int max_energy;
+};
 
-	main_battery = NULL;
+static int __find_main_battery(struct device *dev, void *data)
+{
+	struct find_bat_param *bp = (struct find_bat_param *)data;
 
-	list_for_each_entry(dev, &power_supply_class->devices, node) {
-		bat = dev_get_drvdata(dev);
+	bp->bat = dev_get_drvdata(dev);
 
-		if (bat->use_for_apm) {
-			/* nice, we explicitly asked to report this battery. */
-			main_battery = bat;
-			return;
-		}
+	if (bp->bat->use_for_apm) {
+		/* nice, we explicitly asked to report this battery. */
+		bp->main = bp->bat;
+		return 1;
+	}
 
-		if (!PSY_PROP(bat, CHARGE_FULL_DESIGN, &full) ||
-				!PSY_PROP(bat, CHARGE_FULL, &full)) {
-			if (full.intval > max_charge) {
-				max_charge_bat = bat;
-				max_charge = full.intval;
-			}
-		} else if (!PSY_PROP(bat, ENERGY_FULL_DESIGN, &full) ||
-				!PSY_PROP(bat, ENERGY_FULL, &full)) {
-			if (full.intval > max_energy) {
-				max_energy_bat = bat;
-				max_energy = full.intval;
-			}
+	if (!PSY_PROP(bp->bat, CHARGE_FULL_DESIGN, &bp->full) ||
+			!PSY_PROP(bp->bat, CHARGE_FULL, &bp->full)) {
+		if (bp->full.intval > bp->max_charge) {
+			bp->max_charge_bat = bp->bat;
+			bp->max_charge = bp->full.intval;
+		}
+	} else if (!PSY_PROP(bp->bat, ENERGY_FULL_DESIGN, &bp->full) ||
+			!PSY_PROP(bp->bat, ENERGY_FULL, &bp->full)) {
+		if (bp->full.intval > bp->max_energy) {
+			bp->max_energy_bat = bp->bat;
+			bp->max_energy = bp->full.intval;
 		}
 	}
+	return 0;
+}
+
+static void find_main_battery(void)
+{
+	struct find_bat_param bp;
+	int error;
+
+	memset(&bp, 0, sizeof(struct find_bat_param));
+	main_battery = NULL;
+	bp.main = main_battery;
+
+	error = class_for_each_device(power_supply_class, &bp,
+				      __find_main_battery);
+	if (error) {
+		main_battery = bp.main;
+		return;
+	}
 
-	if ((max_energy_bat && max_charge_bat) &&
-			(max_energy_bat != max_charge_bat)) {
+	if ((bp.max_energy_bat && bp.max_charge_bat) &&
+			(bp.max_energy_bat != bp.max_charge_bat)) {
 		/* try guess battery with more capacity */
-		if (!PSY_PROP(max_charge_bat, VOLTAGE_MAX_DESIGN, &full)) {
-			if (max_energy > max_charge * full.intval)
-				main_battery = max_energy_bat;
+		if (!PSY_PROP(bp.max_charge_bat, VOLTAGE_MAX_DESIGN,
+			      &bp.full)) {
+			if (bp.max_energy > bp.max_charge * bp.full.intval)
+				main_battery = bp.max_energy_bat;
 			else
-				main_battery = max_charge_bat;
-		} else if (!PSY_PROP(max_energy_bat, VOLTAGE_MAX_DESIGN,
-								  &full)) {
-			if (max_charge > max_energy / full.intval)
-				main_battery = max_charge_bat;
+				main_battery = bp.max_charge_bat;
+		} else if (!PSY_PROP(bp.max_energy_bat, VOLTAGE_MAX_DESIGN,
+								  &bp.full)) {
+			if (bp.max_charge > bp.max_energy / bp.full.intval)
+				main_battery = bp.max_charge_bat;
 			else
-				main_battery = max_energy_bat;
+				main_battery = bp.max_energy_bat;
 		} else {
 			/* give up, choice any */
-			main_battery = max_energy_bat;
+			main_battery = bp.max_energy_bat;
 		}
-	} else if (max_charge_bat) {
-		main_battery = max_charge_bat;
-	} else if (max_energy_bat) {
-		main_battery = max_energy_bat;
+	} else if (bp.max_charge_bat) {
+		main_battery = bp.max_charge_bat;
+	} else if (bp.max_energy_bat) {
+		main_battery = bp.max_energy_bat;
 	} else {
 		/* give up, try the last if any */
-		main_battery = bat;
+		main_battery = bp.bat;
 	}
 }
 
@@ -207,10 +227,10 @@ static void apm_battery_apm_get_power_status(struct apm_power_info *info)
 	union power_supply_propval status;
 	union power_supply_propval capacity, time_to_full, time_to_empty;
 
-	down(&power_supply_class->sem);
+	mutex_lock(&apm_mutex);
 	find_main_battery();
 	if (!main_battery) {
-		up(&power_supply_class->sem);
+		mutex_unlock(&apm_mutex);
 		return;
 	}
 
@@ -278,7 +298,7 @@ static void apm_battery_apm_get_power_status(struct apm_power_info *info)
 		}
 	}
 
-	up(&power_supply_class->sem);
+	mutex_unlock(&apm_mutex);
 }
 
 static int __init apm_battery_init(void)
diff --git a/drivers/power/power_supply_core.c b/drivers/power/power_supply_core.c
index a63b75c..03d6a38 100644
--- a/drivers/power/power_supply_core.c
+++ b/drivers/power/power_supply_core.c
@@ -20,28 +20,29 @@
 
 struct class *power_supply_class;
 
+static int __power_supply_changed_work(struct device *dev, void *data)
+{
+	struct power_supply *psy = (struct power_supply *)data;
+	struct power_supply *pst = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < psy->num_supplicants; i++)
+		if (!strcmp(psy->supplied_to[i], pst->name)) {
+			if (pst->external_power_changed)
+				pst->external_power_changed(pst);
+		}
+	return 0;
+}
+
 static void power_supply_changed_work(struct work_struct *work)
 {
 	struct power_supply *psy = container_of(work, struct power_supply,
 						changed_work);
-	int i;
 
 	dev_dbg(psy->dev, "%s\n", __FUNCTION__);
 
-	for (i = 0; i < psy->num_supplicants; i++) {
-		struct device *dev;
-
-		down(&power_supply_class->sem);
-		list_for_each_entry(dev, &power_supply_class->devices, node) {
-			struct power_supply *pst = dev_get_drvdata(dev);
-
-			if (!strcmp(psy->supplied_to[i], pst->name)) {
-				if (pst->external_power_changed)
-					pst->external_power_changed(pst);
-			}
-		}
-		up(&power_supply_class->sem);
-	}
+	class_for_each_device(power_supply_class, psy,
+			      __power_supply_changed_work);
 
 	power_supply_update_leds(psy);
 
@@ -55,32 +56,35 @@ void power_supply_changed(struct power_supply *psy)
 	schedule_work(&psy->changed_work);
 }
 
-int power_supply_am_i_supplied(struct power_supply *psy)
+static int __power_supply_am_i_supplied(struct device *dev, void *data)
 {
 	union power_supply_propval ret = {0,};
-	struct device *dev;
-
-	down(&power_supply_class->sem);
-	list_for_each_entry(dev, &power_supply_class->devices, node) {
-		struct power_supply *epsy = dev_get_drvdata(dev);
-		int i;
-
-		for (i = 0; i < epsy->num_supplicants; i++) {
-			if (!strcmp(epsy->supplied_to[i], psy->name)) {
-				if (epsy->get_property(epsy,
-					  POWER_SUPPLY_PROP_ONLINE, &ret))
-					continue;
-				if (ret.intval)
-					goto out;
-			}
+	struct power_supply *psy = (struct power_supply *)data;
+	struct power_supply *epsy = dev_get_drvdata(dev);
+	int i;
+
+	for (i = 0; i < epsy->num_supplicants; i++) {
+		if (!strcmp(epsy->supplied_to[i], psy->name)) {
+			if (epsy->get_property(epsy,
+				  POWER_SUPPLY_PROP_ONLINE, &ret))
+				continue;
+			if (ret.intval)
+				return ret.intval;
 		}
 	}
-out:
-	up(&power_supply_class->sem);
+	return 0;
+}
+
+int power_supply_am_i_supplied(struct power_supply *psy)
+{
+	int error;
+
+	error = class_for_each_device(power_supply_class, psy,
+				      __power_supply_am_i_supplied);
 
-	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, ret.intval);
+	dev_dbg(psy->dev, "%s %d\n", __FUNCTION__, error);
 
-	return ret.intval;
+	return error;
 }
 
 int power_supply_register(struct device *parent, struct power_supply *psy)
-- 
1.5.3.8

