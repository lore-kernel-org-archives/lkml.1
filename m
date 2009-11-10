Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbZKJCi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbZKJCi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbZKJCi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:38:26 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:60929 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbZKJCiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=cyeaW5iLOT/7TVZNrOH2EEyqgOCI20VZTxfPXzKhrk/lFwH7wGlqgJVhanK+dKqNi0
         PN/MTk5V4vScxfeqK4+eZll/QaZKyJCINh2pPDpd/JztlPmfF4o+k3Tm9kpmkSNDBPy4
         rXd5I8vrFLkMs9Fc7teC9sw0KEcueFGQ96hdg=
From: Paul Fertser <fercerpav@gmail.com>
To: Anton Vorontsov <cbou@mail.ru>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, zaurus-devel@www.linuxtogo.org,
       Paul Fertser <fercerpav@gmail.com>
Subject: [RFC PATCH 1/2] power: implement platform battery driver
Date: Tue, 10 Nov 2009 05:37:52 +0300
Message-Id: <1257820673-30801-2-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1257820673-30801-1-git-send-email-fercerpav@gmail.com>
References: <1257820673-30801-1-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This driver can be used for dumb batteries when all knowledge about
their state belongs to the platform that does necessary ADC readings,
conversions, guessimations etc.

Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/power/Kconfig            |    6 ++
 drivers/power/Makefile           |    1 +
 drivers/power/platform_battery.c |  119 ++++++++++++++++++++++++++++++++++++++
 include/linux/platform_battery.h |   12 ++++
 4 files changed, 138 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/platform_battery.c
 create mode 100644 include/linux/platform_battery.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index bdbc4f7..5382c10 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -103,4 +103,10 @@ config CHARGER_PCF50633
 	help
 	 Say Y to include support for NXP PCF50633 Main Battery Charger.
 
+config BATTERY_PLATFORM
+	tristate "Platform battery driver"
+	help
+	  Say Y here to include support for battery driver that gets all
+	  information from platform functions.
+
 endif # POWER_SUPPLY
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 380d17c..b962d1a 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -28,3 +28,4 @@ obj-$(CONFIG_BATTERY_BQ27x00)	+= bq27x00_battery.o
 obj-$(CONFIG_BATTERY_DA9030)	+= da9030_battery.o
 obj-$(CONFIG_BATTERY_MAX17040)	+= max17040_battery.o
 obj-$(CONFIG_CHARGER_PCF50633)	+= pcf50633-charger.o
+obj-$(CONFIG_BATTERY_PLATFORM)	+= platform_battery.o
diff --git a/drivers/power/platform_battery.c b/drivers/power/platform_battery.c
new file mode 100644
index 0000000..99e155a
--- /dev/null
+++ b/drivers/power/platform_battery.c
@@ -0,0 +1,119 @@
+/*
+ * Driver for platform battery
+ *
+ * Copyright (c) Paul Fertser <fercerpav@gmail.com>
+ * Inspired by Balaji Rao <balajirrao@openmoko.org>
+ *
+ * This driver can be used for dumb batteries when all knowledge about
+ * their state belongs to the platform that does necessary ADC readings,
+ * conversions, guessimations etc.
+ *
+ * Use consistent with the GNU GPL is permitted, provided that this
+ * copyright notice is preserved in its entirety in all copies and derived
+ * works.
+ */
+
+#include <linux/module.h>
+#include <linux/param.h>
+#include <linux/delay.h>
+#include <linux/workqueue.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+#include <linux/platform_battery.h>
+
+struct platform_battery {
+	struct power_supply psy;
+	struct platform_bat_platform_data *pdata;
+};
+
+static int platform_bat_get_property(struct power_supply *psy,
+				       enum power_supply_property psp,
+				       union power_supply_propval *val)
+{
+	struct platform_battery *bat =
+				container_of(psy, struct platform_battery, psy);
+	size_t i;
+	int present = 1;
+
+	if (bat->pdata->is_present)
+		present = bat->pdata->is_present();
+
+	if (psp != POWER_SUPPLY_PROP_PRESENT && !present)
+		return -ENODEV;
+
+	for (i = 0; i < psy->num_properties; i++)
+		if (psy->properties[i] == psp) {
+			val->intval = bat->pdata->get_property[i]();
+			return 0;
+		}
+
+	return -EINVAL;
+}
+
+static void platform_bat_ext_changed(struct power_supply *psy)
+{
+	struct platform_battery *bat =
+				container_of(psy, struct platform_battery, psy);
+	power_supply_changed(&bat->psy);
+}
+
+static int platform_battery_probe(struct platform_device *pdev)
+{
+	struct platform_battery *platform_bat;
+	struct platform_bat_platform_data *pdata =
+		(struct platform_bat_platform_data *)pdev->dev.platform_data;
+
+	platform_bat = kzalloc(sizeof(*platform_bat), GFP_KERNEL);
+	if (!platform_bat)
+		return -ENOMEM;
+
+	if (pdata->name)
+		platform_bat->psy.name = pdata->name;
+	else
+		platform_bat->psy.name = dev_name(&pdev->dev);
+	platform_bat->psy.type = POWER_SUPPLY_TYPE_BATTERY;
+	platform_bat->psy.properties = pdata->properties;
+	platform_bat->psy.num_properties = pdata->num_properties;
+	platform_bat->psy.get_property = platform_bat_get_property;
+	platform_bat->psy.external_power_changed = platform_bat_ext_changed;
+
+	platform_bat->pdata = pdata;
+	platform_set_drvdata(pdev, platform_bat);
+	power_supply_register(&pdev->dev, &platform_bat->psy);
+
+	return 0;
+}
+
+static int platform_battery_remove(struct platform_device *pdev)
+{
+	struct platform_battery *bat = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&bat->psy);
+	kfree(bat);
+
+	return 0;
+}
+
+static struct platform_driver platform_battery_driver = {
+	.driver = {
+		.name = "platform_battery",
+	},
+	.probe	  = platform_battery_probe,
+	.remove   = platform_battery_remove,
+};
+
+static int __init platform_battery_init(void)
+{
+	return platform_driver_register(&platform_battery_driver);
+}
+module_init(platform_battery_init);
+
+static void __exit platform_battery_exit(void)
+{
+	platform_driver_unregister(&platform_battery_driver);
+}
+module_exit(platform_battery_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Paul Fertser <fercerpav@gmail.com>");
+MODULE_DESCRIPTION("platform battery driver");
diff --git a/include/linux/platform_battery.h b/include/linux/platform_battery.h
new file mode 100644
index 0000000..00f7651
--- /dev/null
+++ b/include/linux/platform_battery.h
@@ -0,0 +1,12 @@
+#ifndef __PLATFORM_BATTERY_H__
+#define __PLATFORM_BATTERY_H__
+
+struct platform_bat_platform_data {
+	const char *name;
+	int (**get_property)(void);
+	int (*is_present)(void);
+	enum power_supply_property *properties;
+	size_t num_properties;
+};
+
+#endif
-- 
1.6.4.4

