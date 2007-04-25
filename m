Return-Path: <linux-kernel-owner+w=401wt.eu-S1031147AbXDYPy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031147AbXDYPy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 11:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031143AbXDYPyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 11:54:09 -0400
Received: from mx6.mail.ru ([194.67.23.26]:3730 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031140AbXDYPxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 11:53:54 -0400
Date: Wed, 25 Apr 2007 19:51:04 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: [PATCH 4/7] APM emulation driver for class batteries
Message-ID: <20070425155104.GD4117@zarina>
References: <20070425154820.GA27300@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070425154820.GA27300@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/battery/Kconfig     |    7 ++
 drivers/battery/Makefile    |    2 +
 drivers/battery/apm_power.c |  228 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 237 insertions(+), 0 deletions(-)
 create mode 100644 drivers/battery/apm_power.c

diff --git a/drivers/battery/Kconfig b/drivers/battery/Kconfig
index a66294d..7e7f9cd 100644
--- a/drivers/battery/Kconfig
+++ b/drivers/battery/Kconfig
@@ -9,4 +9,11 @@ config BATTERY
 	  monitoring by userspace via sysfs (if available) and/or APM
 	  kernel interface (if selected below).
 
+config APM_POWER
+	tristate "APM emulation for class batteries"
+	depends on BATTERY && APM_EMULATION
+	help
+	  Say Y here to enable support APM status emulation using
+	  battery class devices.
+
 endmenu
diff --git a/drivers/battery/Makefile b/drivers/battery/Makefile
index 1af291b..8c0d648 100644
--- a/drivers/battery/Makefile
+++ b/drivers/battery/Makefile
@@ -7,3 +7,5 @@ endif
 ifeq ($(CONFIG_LEDS_TRIGGERS),y)
 obj-$(CONFIG_BATTERY)              += battery_leds.o
 endif
+
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

