Return-Path: <linux-kernel-owner+w=401wt.eu-S932203AbXDKX4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932203AbXDKX4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 19:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXDKX4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 19:56:31 -0400
Received: from mail.z-net.ru ([89.113.80.10]:1647 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932203AbXDKX4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 19:56:30 -0400
Date: Thu, 12 Apr 2007 03:26:44 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org, dwmw2@infradead.org
Subject: [PATCH 7/7] [RFC] APM emulation driver for class batteries
Message-ID: <20070411232644.GG20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It finds battery with "main_battery" flag set (or with max_capacity if no
batteries marked as main), and converts battery values to APM form.

---
 drivers/battery/Kconfig     |    7 +++
 drivers/battery/Makefile    |    1 +
 drivers/battery/apm_power.c |  121 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 129 insertions(+), 0 deletions(-)
 create mode 100644 drivers/battery/apm_power.c

diff --git a/drivers/battery/Kconfig b/drivers/battery/Kconfig
index 0c14ae0..bbf8283 100644
--- a/drivers/battery/Kconfig
+++ b/drivers/battery/Kconfig
@@ -15,4 +15,11 @@ config BATTERY_DS2760
 	help
 	  Say Y here to enable support for batteries with ds2760 chip.
 
+config APM_POWER
+	tristate "APM emulation"
+	depends on BATTERY && APM
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
index 0000000..5e741c1
--- /dev/null
+++ b/drivers/battery/apm_power.c
@@ -0,0 +1,121 @@
+/*
+ * Copyright (c) 2007 Eugeny Boger
+ *
+ * Use consistent with the GNU GPL is permitted,
+ * provided that this copyright notice is
+ * preserved in its entirety in all copies and derived works.
+ */
+
+#include <linux/module.h>
+#include <linux/battery.h>
+#include <linux/apm-emulation.h>
+#include <linux/list.h>
+
+#define BATTERY_PROPERTY(property) (main_battery->get_##property ? \
+			main_battery->get_##property(main_battery) : 0)
+
+static struct battery *main_battery;
+
+static void (*old_apm_get_power_status)(struct apm_power_info*);
+
+static void apm_battery_find_main_battery(void)
+{
+	struct device *dev;
+	struct battery *bat, *batm;
+	int max_capacity = 0;
+
+	main_battery = NULL;
+	batm = NULL;
+	list_for_each_entry(dev, &battery_class->devices, node) {
+		bat = dev_get_drvdata(dev);
+		/* If none of battery devices cantains 'main_battery' flag,
+		   choice one with max capacity */
+		if (bat->get_max_capacity)
+			if (bat->get_max_capacity(bat) > max_capacity) {
+				batm = bat;
+				max_capacity = bat->get_max_capacity(bat);
+			}
+
+		if (bat->main_battery)
+			main_battery = bat;
+	}
+	if (!main_battery)
+		main_battery = batm;
+}
+
+static void apm_battery_apm_get_power_status(struct apm_power_info *info)
+{
+	int bat_current;
+
+	down(&battery_class->sem);
+	apm_battery_find_main_battery();
+	if (!main_battery) {
+		up(&battery_class->sem);
+		return;
+	}
+
+	if (BATTERY_PROPERTY(status) == BATTERY_STATUS_FULL)
+		info->battery_life = 100;
+	else
+		if (BATTERY_PROPERTY(max_capacity) -
+		                                BATTERY_PROPERTY(min_capacity))
+			info->battery_life = ((BATTERY_PROPERTY(capacity) -
+			             BATTERY_PROPERTY(min_capacity)) * 100) /
+			             (BATTERY_PROPERTY(max_capacity) -
+			              BATTERY_PROPERTY(min_capacity));
+		else
+			info->battery_life = -1;
+	if ((BATTERY_PROPERTY(status) == BATTERY_STATUS_CHARGING)
+	    || (BATTERY_PROPERTY(status) == BATTERY_STATUS_NOT_CHARGING)
+	    || (BATTERY_PROPERTY(status) == BATTERY_STATUS_FULL))
+		info->ac_line_status = APM_AC_ONLINE;
+	else
+		info->ac_line_status = APM_AC_OFFLINE;
+
+	if (BATTERY_PROPERTY(status) == BATTERY_STATUS_CHARGING)
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
+	bat_current = BATTERY_PROPERTY(current);
+	if (bat_current)
+		info->time = ((BATTERY_PROPERTY(capacity) - 
+		              BATTERY_PROPERTY(min_capacity)) * 60) /
+		             bat_current;
+	else
+		info->time = -1;
+
+	info->units = APM_UNITS_MINS;
+
+	up(&battery_class->sem);
+	return;
+}
+
+static int __init apm_battery_init(void)
+{
+	printk(KERN_INFO "APM Battery Driver\n");
+
+	old_apm_get_power_status = apm_get_power_status;
+	apm_get_power_status = apm_battery_apm_get_power_status;
+	return 0;
+}
+
+static void __exit apm_battery_exit(void)
+{
+	apm_get_power_status = old_apm_get_power_status;
+	return;
+}
+
+module_init(apm_battery_init);
+module_exit(apm_battery_exit);
+
+MODULE_AUTHOR("Eugeny Boger");
+MODULE_DESCRIPTION("APM emulation driver for battery monitoring class");
+MODULE_LICENSE("GPL");
-- 
1.5.0.5-dirty
