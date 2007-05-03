Return-Path: <linux-kernel-owner+w=401wt.eu-S1767437AbXECVgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767437AbXECVgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 17:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767430AbXECVgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 17:36:38 -0400
Received: from mail.z-net.ru ([89.113.80.10]:4221 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767437AbXECVg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 17:36:28 -0400
Date: Fri, 4 May 2007 01:32:56 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org,
       David Woodhouse <dwmw2@infradead.org>
Subject: [PATCH 7/8] Apple PMU driver
Message-ID: <20070503213256.GG20067@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/Kconfig       |    7 ++
 drivers/power/Makefile      |    1 +
 drivers/power/pmu_battery.c |  215 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 223 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/pmu_battery.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 9214562..051724f 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -35,4 +35,11 @@ config BATTERY_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
 
+config BATTERY_PMU
+	tristate "Apple PMU battery"
+	depends on ADB_PMU
+	help
+	  Say Y here to expose battery information on Apple machines
+	  through the generic battery class.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 492df05..0ebdc6d 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -18,3 +18,4 @@ obj-$(CONFIG_PDA_POWER)            += pda_power.o
 obj-$(CONFIG_APM_POWER)            += apm_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)       += ds2760_battery.o
+obj-$(CONFIG_BATTERY_PMU)          += pmu_battery.o
diff --git a/drivers/power/pmu_battery.c b/drivers/power/pmu_battery.c
new file mode 100644
index 0000000..d52e302
--- /dev/null
+++ b/drivers/power/pmu_battery.c
@@ -0,0 +1,215 @@
+/*
+ * Battery class driver for Apple PMU
+ *
+ *	Copyright © 2006  David Woodhouse <dwmw2@infradead.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/err.h>
+#include <linux/power_supply.h>
+#include <linux/adb.h>
+#include <linux/pmu.h>
+
+static struct pmu_battery_dev {
+	struct power_supply bat;
+	struct pmu_battery_info *pbi;
+	char name[16];
+	int propval;
+} *pbats[PMU_MAX_BATTERIES];
+
+#define to_pmu_battery_dev(x) container_of(x, struct pmu_battery_dev, bat)
+
+/*********************************************************************
+ *		Power
+ *********************************************************************/
+
+static int pmu_get_ac_prop(struct power_supply *psy,
+                           enum power_supply_property psp,
+                           union power_supply_propval *val)
+{
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = (!!(pmu_power_flags & PMU_PWR_AC_PRESENT)) ||
+		              (pmu_battery_count == 0);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static enum power_supply_property pmu_ac_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+};
+
+static struct power_supply pmu_ac = {
+	.name = "pmu-ac",
+	.type = POWER_SUPPLY_TYPE_AC,
+	.properties = pmu_ac_props,
+	.num_properties = ARRAY_SIZE(pmu_ac_props),
+	.get_property = pmu_get_ac_prop,
+};
+
+/*********************************************************************
+ *		Battery properties
+ *********************************************************************/
+
+static char *pmu_batt_types[] = {
+	"Smart", "Comet", "Hooper", "Unknown"
+};
+
+static char *pmu_bat_get_model_name(struct pmu_battery_info *pbi)
+{
+	switch (pbi->flags & PMU_BATT_TYPE_MASK) {
+	case PMU_BATT_TYPE_SMART:
+		return pmu_batt_types[0];
+	case PMU_BATT_TYPE_COMET:
+		return pmu_batt_types[1];
+	case PMU_BATT_TYPE_HOOPER:
+		return pmu_batt_types[2];
+	default: break;
+	}
+	return pmu_batt_types[3];
+}
+
+static int pmu_bat_get_property(struct power_supply *psy,
+                                enum power_supply_property psp,
+                                union power_supply_propval *val)
+{
+	struct pmu_battery_dev *pbat = to_pmu_battery_dev(psy);
+	struct pmu_battery_info *pbi = pbat->pbi;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		if (pbi->flags & PMU_BATT_CHARGING)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		break;
+	case POWER_SUPPLY_PROP_PRESENT:
+		val->intval = !!(pbi->flags & PMU_BATT_PRESENT);
+		break;
+	case POWER_SUPPLY_PROP_MODEL_NAME:
+		val->strval = pmu_bat_get_model_name(pbi);
+		break;
+	case POWER_SUPPLY_PROP_ENERGY_AVG:
+		val->intval = pbi->charge     * 1000; /* mWh -> µWh */
+		break;
+	case POWER_SUPPLY_PROP_ENERGY_FULL:
+		val->intval = pbi->max_charge * 1000; /* mWh -> µWh */
+		break;
+	case POWER_SUPPLY_PROP_CURRENT_AVG:
+		val->intval = pbi->amperage   * 1000; /* mA -> µA */
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+		val->intval = pbi->voltage    * 1000; /* mV -> µV */
+		break;
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
+		val->intval = pbi->time_remaining;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static enum power_supply_property pmu_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_PRESENT,
+	POWER_SUPPLY_PROP_MODEL_NAME,
+	POWER_SUPPLY_PROP_ENERGY_AVG,
+	POWER_SUPPLY_PROP_ENERGY_FULL,
+	POWER_SUPPLY_PROP_CURRENT_AVG,
+	POWER_SUPPLY_PROP_VOLTAGE_AVG,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
+};
+
+/*********************************************************************
+ *		Initialisation
+ *********************************************************************/
+
+static struct platform_device *bat_pdev;
+
+static int __init pmu_bat_init(void)
+{
+	int ret;
+	int i;
+
+	bat_pdev = platform_device_register_simple("pmu-battery",
+	                                           0, NULL, 0);
+	if (IS_ERR(bat_pdev)) {
+		ret = PTR_ERR(bat_pdev);
+		goto pdev_register_failed;
+	}
+
+	ret = power_supply_register(&bat_pdev->dev, &pmu_ac);
+	if (ret)
+		goto ac_register_failed;
+
+	for (i = 0; i < pmu_battery_count; i++) {
+		struct pmu_battery_dev *pbat = kzalloc(sizeof(*pbat),
+		                                       GFP_KERNEL);
+		if (!pbat)
+			break;
+
+		sprintf(pbat->name, "PMU battery %d", i);
+		pbat->bat.name = pbat->name;
+		pbat->bat.properties = pmu_bat_props;
+		pbat->bat.num_properties = ARRAY_SIZE(pmu_bat_props);
+		pbat->bat.get_property = pmu_bat_get_property;
+		pbat->pbi = &pmu_batteries[i];
+
+		ret = power_supply_register(&bat_pdev->dev, &pbat->bat);
+		if (ret) {
+			kfree(pbat);
+			goto battery_register_failed;
+		}
+		pbats[i] = pbat;
+	}
+
+	goto success;
+
+battery_register_failed:
+	while (i--) {
+		if (!pbats[i])
+			continue;
+		power_supply_unregister(&pbats[i]->bat);
+		kfree(pbats[i]);
+	}
+	power_supply_unregister(&pmu_ac);
+ac_register_failed:
+	platform_device_unregister(bat_pdev);
+pdev_register_failed:
+success:
+	return ret;
+}
+
+static void __exit pmu_bat_exit(void)
+{
+	int i;
+
+	for (i = 0; i < PMU_MAX_BATTERIES; i++) {
+		if (!pbats[i])
+			continue;
+		power_supply_unregister(&pbats[i]->bat);
+		kfree(pbats[i]);
+	}
+	power_supply_unregister(&pmu_ac);
+	platform_device_unregister(bat_pdev);
+
+	return;
+}
+
+module_init(pmu_bat_init);
+module_exit(pmu_bat_exit);
+
+MODULE_AUTHOR("David Woodhouse <dwmw2@infradead.org>");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("PMU battery driver");
-- 
1.5.1.1-dirty

