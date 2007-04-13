Return-Path: <linux-kernel-owner+w=401wt.eu-S1753999AbXDMNyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999AbXDMNyT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 09:54:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754001AbXDMNyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 09:54:19 -0400
Received: from mail.z-net.ru ([89.113.80.10]:1395 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999AbXDMNyS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 09:54:18 -0400
Date: Fri, 13 Apr 2007 17:50:43 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: linux-kernel@vger.kernel.org
Cc: kernel-discuss@handhelds.org
Subject: Re: [PATCH 7/7] [RFC] APM emulation driver for class batteries
Message-ID: <20070413135005.GE20618@zarina>
Reply-To: cbou@mail.ru
References: <20070411232644.GG20095@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070411232644.GG20095@zarina>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 03:26:44AM +0400, Anton Vorontsov wrote:
> It finds battery with "main_battery" flag set (or with max_capacity if no
> batteries marked as main), and converts battery values to APM form.

Changes:

- follows battery class changes

- minor cleanups


Subject: [PATCH] [take2] APM emulation driver for class batteries


Signed-off-by: Anton Vorontsov <cbou@mail.ru>
---
 drivers/battery/Kconfig     |    7 +++
 drivers/battery/Makefile    |    1 +
 drivers/battery/apm_power.c |  122 +++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 130 insertions(+), 0 deletions(-)
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
index 0000000..367a17d
--- /dev/null
+++ b/drivers/battery/apm_power.c
@@ -0,0 +1,122 @@
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
+
+#define BATTERY_PROP(bat, prop) ({                                 \
+	void *value = bat->get_property(bat, BATTERY_PROP_##prop); \
+	value ? *(int*)value : 0;                                  \
+})
+
+#define MBATTERY_PROP(prop) BATTERY_PROP(main_battery, prop)
+
+static struct battery *main_battery;
+
+static void (*old_apm_get_power_status)(struct apm_power_info*);
+
+static void apm_battery_find_main_battery(void)
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
+		   choice one with max CHARGE */
+		if (BATTERY_PROP(bat, MAX_CHARGE) > max_charge) {
+			batm = bat;
+			max_charge = BATTERY_PROP(bat, MAX_CHARGE);
+		}
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
+	if (MBATTERY_PROP(STATUS) == BATTERY_STATUS_FULL)
+		info->battery_life = 100;
+	else if (MBATTERY_PROP(MAX_CHARGE) - MBATTERY_PROP(MIN_CHARGE))
+		info->battery_life = ((MBATTERY_PROP(CHARGE) -
+		                       MBATTERY_PROP(MIN_CHARGE)) * 100) /
+		                     (MBATTERY_PROP(MAX_CHARGE) -
+		                      MBATTERY_PROP(MIN_CHARGE));
+	else
+		info->battery_life = -1;
+
+	if ((MBATTERY_PROP(STATUS) == BATTERY_STATUS_CHARGING) ||
+	    (MBATTERY_PROP(STATUS) == BATTERY_STATUS_NOT_CHARGING) ||
+	    (MBATTERY_PROP(STATUS) == BATTERY_STATUS_FULL))
+		info->ac_line_status = APM_AC_ONLINE;
+	else
+		info->ac_line_status = APM_AC_OFFLINE;
+
+	if (MBATTERY_PROP(STATUS) == BATTERY_STATUS_CHARGING)
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
+	bat_current = MBATTERY_PROP(CURRENT);
+	if (bat_current)
+		info->time = ((MBATTERY_PROP(CHARGE) -
+		              MBATTERY_PROP(MIN_CHARGE)) * 60) /
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

