Return-Path: <linux-kernel-owner+w=401wt.eu-S1763417AbYALJsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763417AbYALJsp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jan 2008 04:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756203AbYALJsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jan 2008 04:48:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.154]:10593 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761766AbYALJsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jan 2008 04:48:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=JNMhlblY+IsT4zNjzY8JbqDlMYRvB33m4+/zNRno1xVlIPamC4wTgcFt5RwbaAwM8hmduR5M+FEVMkiKC0CvHf8G/obRGIo6+QlvTOdGXPBSTPBAa8Gz0YeTpFNd0r1xsuNoxBJLCkIayqvEAKRvI6Klt0VXCXSsWteeqJit+Ys=
Date: Sat, 12 Jan 2008 17:51:57 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: cbou@mail.ru, dwmw2@infradead.org
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 3/7] power supply : use class iteration api
Message-ID: <20080112095157.GC2893@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to use the class iteration api.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
 drivers/power/apm_power.c         |  116 ++++++++++++++++++++++----------------
 drivers/power/power_supply_core.c |   72 ++++++++++++-----------
 2 files changed, 106 insertions(+), 82 deletions(-)

diff -upr linux/drivers/power/apm_power.c linux.new/drivers/power/apm_power.c
--- linux/drivers/power/apm_power.c	2008-01-11 18:06:38.000000000 +0800
+++ linux.new/drivers/power/apm_power.c	2008-01-11 18:06:38.000000000 +0800
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
 
@@ -207,10 +227,10 @@ static void apm_battery_apm_get_power_st
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
 
@@ -278,7 +298,7 @@ static void apm_battery_apm_get_power_st
 		}
 	}
 
-	up(&power_supply_class->sem);
+	mutex_unlock(&apm_mutex);
 }
 
 static int __init apm_battery_init(void)
diff -upr linux/drivers/power/power_supply_core.c linux.new/drivers/power/power_supply_core.c
--- linux/drivers/power/power_supply_core.c	2008-01-11 18:06:38.000000000 +0800
+++ linux.new/drivers/power/power_supply_core.c	2008-01-11 18:06:38.000000000 +0800
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
 
@@ -55,32 +56,35 @@ void power_supply_changed(struct power_s
 	schedule_work(&psy->changed_work);
 }
 
-int power_supply_am_i_supplied(struct power_supply *psy)
+static int __power_supply_am_i_supplied(struct device *dev, void *data)
 {
 	union power_supply_propval ret = {0,};
-	struct device *dev;
+	struct power_supply *psy = (struct power_supply *)data;
+	struct power_supply *epsy = dev_get_drvdata(dev);
+	int i;
 
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
