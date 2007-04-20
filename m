Return-Path: <linux-kernel-owner+w=401wt.eu-S1767062AbXDTMCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767062AbXDTMCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 08:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767064AbXDTMCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 08:02:10 -0400
Received: from mx1-2.mail.ru ([194.67.23.121]:7804 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1767062AbXDTMCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 08:02:09 -0400
Date: Fri, 20 Apr 2007 15:59:21 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org
Subject: [PATCH 5/7] APM emulation driver for class batteries
Message-ID: <20070420115921.GE21752@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It's still tristate, but now on module removal it will set
apm get status function to NULL, to not cause oops if two APM
modules loaded/unloaded in special order.

Fixing APM API itself is another story.

Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/battery/Kconfig     |    7 ++
 drivers/battery/Makefile    |    1 +
 drivers/battery/apm_power.c |  228 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 236 insertions(+), 0 deletions(-)
 create mode 100644 drivers/battery/apm_power.c

diff --git a/drivers/battery/Kconfig b/drivers/battery/Kconfig
index 0c14ae0..5e2dac8 100644
--- a/drivers/battery/Kconfig
+++ b/drivers/battery/Kconfig
@@ -15,4 +15,11 @@ config BATTERY_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
 
+config APM_POWER
+	tristate "APM emulation"
+	depends on BATTERY && APM_EMULATION
+	help
+	  Say Y here to enable support APM status emulation using
+	  battery class devices.
+
 endmenu
diff --git a/drivers/battery/Makefile b/drivers/battery/Makefile
index 9902513..cea5807 100644
--- a/drivers/battery/Makefile
+++ b/drivers/battery/Makefile
@@ -1,2 +1,3 @@
 obj-$(CONFIG_BATTERY)              += battery.o
 obj-$(CONFIG_BATTERY_DS2760)       += ds2760_battery.o
+obj-$(CONFIG_APM_POWER)            += apm_power.o
diff --git a/drivers/battery/apm_power.c b/drivers/battery/apm_power.c
new file mode 100644
index 0000000..e3bb4bd
--- /dev/null
+++ b/drivers/battery/apm_power.c
@@ -0,0 +1,228 @@
+/*
+ * Copyright (c) 2007 Anton Vorontsov <cbou@mail.ru>
+ * Copyright (c) 2007 Eugeny Boger <eugenyboger@dgap.mipt.ru>
+ *
+ * Author: Eugeny Boger <eugenyboger@dgap.mipt.ru>
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ */
+
+#include <linux/module.h>
+#include <linux/battery.h>
+#include <linux/apm-emulation.h>
+
+#ifdef current
+#undef current /* it expands to get_current() */
+#endif
+
+#define BATTERY_PROP(bat, prop) ({                                 \
+	void *value = bat->get_property(bat, BATTERY_PROP_##prop); \
+	value ? *(int*)value : 0;                                  \
+})
+
+#define MBATTERY_PROP(prop) main_battery->get_property(main_battery, \
+                                            BATTERY_PROP_##prop)
+
+static struct battery *main_battery;
+
+static void find_main_battery(void)
+{
+	struct device *dev;
+	struct battery *bat, *batm;
+	int max_charge = 0;
+
+	main_battery = NULL;
+	batm = NULL;
+	list_for_each_entry(dev, &battery_class->devices, node) {
+		bat = dev_get_drvdata(dev);
+		/* If none of battery devices cantains 'main_battery' flag,
+		   choice one with maximum design charge */
+		if (BATTERY_PROP(bat, CHARGE_FULL_DESIGN) > max_charge) {
+			batm = bat;
+			max_charge = BATTERY_PROP(bat, CHARGE_FULL_DESIGN);
+		}
+
+		if (bat->main_battery)
+			main_battery = bat;
+	}
+	if (!main_battery)
+		main_battery = batm;
+
+	return;
+}
+
+static int calculate_time(int status)
+{
+	int *charge_full;
+	int *charge_empty;
+	int *charge;
+	int *current;
+
+	charge_full = MBATTERY_PROP(CHARGE_FULL);
+	/* if battery can't report this property, use design value */
+	if (!charge_full)
+		charge_full = MBATTERY_PROP(CHARGE_FULL_DESIGN);
+
+	charge_empty = MBATTERY_PROP(CHARGE_EMPTY);
+	/* if battery can't report this property, use design value */
+	if (!charge_empty)
+		charge_empty = MBATTERY_PROP(CHARGE_EMPTY_DESIGN);
+
+	charge = MBATTERY_PROP(CHARGE_AVG);
+	/* if battery can't report average value, use momentary */
+	if (!charge)
+		charge = MBATTERY_PROP(CHARGE_NOW);
+
+	current = MBATTERY_PROP(CURRENT_AVG);
+	/* if battery can't report average value, use momentary */
+	if (!current)
+		current = MBATTERY_PROP(CURRENT_NOW);
+
+	/* no luck */
+	if (!current || !charge || !charge_empty)
+		return -1;
+
+	if (status == BATTERY_STATUS_CHARGING)
+		return ((*charge - *charge_full) * 60L) / *current;
+	else
+		return -((*charge - *charge_empty) * 60L) / *current;
+}
+
+/* TODO: teach this function to calculate battery life using energy */
+static int calculate_capacity(void)
+{
+	int ret;
+	int *charge_empty;
+	int *charge_full;
+	int *charge;
+
+	charge_full = MBATTERY_PROP(CHARGE_FULL);
+	/* if battery can't report this property, use design value */
+	if (!charge_full)
+		charge_full = MBATTERY_PROP(CHARGE_FULL_DESIGN);
+
+	charge_empty = MBATTERY_PROP(CHARGE_EMPTY);
+	/* if battery can't report this property, use design value */
+	if (!charge_empty)
+		charge_empty = MBATTERY_PROP(CHARGE_EMPTY_DESIGN);
+
+	charge = MBATTERY_PROP(CHARGE_AVG);
+	/* if battery can't report average value, use momentary */
+	if (!charge)
+		charge = MBATTERY_PROP(CHARGE_NOW);
+
+	/* no luck */
+	if (!charge_full || !charge_empty || !charge)
+		return -1;
+
+	if (*charge_full - *charge_empty)
+		ret =  ((*charge - *charge_empty) * 100L) /
+		       (*charge_full - *charge_empty);
+	else
+		return -1;
+
+	if (ret > 100)
+		return 100;
+	else if (ret < 0)
+		return 0;
+	else
+		return ret;
+}
+
+static void apm_battery_apm_get_power_status(struct apm_power_info *info)
+{
+	int status;
+	int *capacity;
+	int *time_to_full;
+	int *time_to_empty;
+
+	down(&battery_class->sem);
+	find_main_battery();
+	if (!main_battery) {
+		up(&battery_class->sem);
+		return;
+	}
+
+	/* status */
+
+	if (MBATTERY_PROP(STATUS))
+		status = *(int *)MBATTERY_PROP(STATUS);
+	else
+		status = BATTERY_STATUS_UNKNOWN;
+
+	/* ac line status */
+
+	if ((status == BATTERY_STATUS_CHARGING) ||
+	    (status == BATTERY_STATUS_NOT_CHARGING) ||
+	    (status == BATTERY_STATUS_FULL))
+		info->ac_line_status = APM_AC_ONLINE;
+	else
+		info->ac_line_status = APM_AC_OFFLINE;
+
+	/* battery life (i.e. capacity, in percents) */
+
+	capacity = MBATTERY_PROP(CAPACITY);
+	if (capacity)
+		info->battery_life = *capacity;
+	else
+		info->battery_life = calculate_capacity();
+
+	/* charging status */
+
+	if (status == BATTERY_STATUS_CHARGING)
+		info->battery_status = APM_BATTERY_STATUS_CHARGING;
+	else {
+		if (info->battery_life > 50)
+			info->battery_status = APM_BATTERY_STATUS_HIGH;
+		else if (info->battery_life > 5)
+			info->battery_status = APM_BATTERY_STATUS_LOW;
+		else
+			info->battery_status = APM_BATTERY_STATUS_CRITICAL;
+	}
+	info->battery_flag = info->battery_status;
+
+	/* time */
+
+	info->units = APM_UNITS_MINS;
+
+	time_to_empty = MBATTERY_PROP(TIME_TO_EMPTY_AVG);
+	if (!time_to_empty)
+		time_to_empty = MBATTERY_PROP(TIME_TO_EMPTY_NOW);
+
+	time_to_full = MBATTERY_PROP(TIME_TO_FULL_AVG);
+	if (!time_to_full)
+		time_to_full = MBATTERY_PROP(TIME_TO_FULL_NOW);
+
+	if (status == BATTERY_STATUS_CHARGING && time_to_full)
+		info->time = *time_to_full / 60;
+	else if (status != BATTERY_STATUS_CHARGING && time_to_empty)
+		info->time = *time_to_empty / 60;
+	else
+		info->time = calculate_time(status);
+
+	up(&battery_class->sem);
+	return;
+}
+
+static int __init apm_battery_init(void)
+{
+	printk(KERN_INFO "APM Battery Driver\n");
+
+	apm_get_power_status = apm_battery_apm_get_power_status;
+	return 0;
+}
+
+static void __exit apm_battery_exit(void)
+{
+	apm_get_power_status = NULL;
+	return;
+}
+
+module_init(apm_battery_init);
+module_exit(apm_battery_exit);
+
+MODULE_AUTHOR("Eugeny Boger <eugenyboger@dgap.mipt.ru>");
+MODULE_DESCRIPTION("APM emulation driver for battery monitoring class");
+MODULE_LICENSE("GPL");
-- 
1.5.1.1-dirty
