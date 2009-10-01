Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbZJAOlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbZJAOlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 10:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932734AbZJAOlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 10:41:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34130 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932709AbZJAOlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 10:41:18 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: [PATCH 3/4] power_supply: Factor out WM831x backup battery charger
Date: Thu,  1 Oct 2009 15:41:06 +0100
Message-Id: <1254408067-15908-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.4.3
In-Reply-To: <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1254408067-15908-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1254408067-15908-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The backup battery on WM831x is a separate IP block to the main PMU and
is largely unrelated to the main supply functionality. Factor it out into
a separate driver in order to reflect this and better support future
hardware versions.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/mfd/wm831x-core.c     |    9 ++
 drivers/power/Kconfig         |    7 ++
 drivers/power/Makefile        |    1 +
 drivers/power/wm831x_backup.c |  233 +++++++++++++++++++++++++++++++++++++++++
 drivers/power/wm831x_power.c  |  144 +-------------------------
 5 files changed, 253 insertions(+), 141 deletions(-)
 create mode 100644 drivers/power/wm831x_backup.c

diff --git a/drivers/mfd/wm831x-core.c b/drivers/mfd/wm831x-core.c
index fa651e5..45d6770 100644
--- a/drivers/mfd/wm831x-core.c
+++ b/drivers/mfd/wm831x-core.c
@@ -794,6 +794,9 @@ static struct resource wm831x_wdt_resources[] = {
 
 static struct mfd_cell wm8310_devs[] = {
 	{
+		.name = "wm831x-backup",
+	},
+	{
 		.name = "wm831x-buckv",
 		.id = 1,
 		.num_resources = ARRAY_SIZE(wm831x_dcdc1_resources),
@@ -947,6 +950,9 @@ static struct mfd_cell wm8310_devs[] = {
 
 static struct mfd_cell wm8311_devs[] = {
 	{
+		.name = "wm831x-backup",
+	},
+	{
 		.name = "wm831x-buckv",
 		.id = 1,
 		.num_resources = ARRAY_SIZE(wm831x_dcdc1_resources),
@@ -1081,6 +1087,9 @@ static struct mfd_cell wm8311_devs[] = {
 
 static struct mfd_cell wm8312_devs[] = {
 	{
+		.name = "wm831x-backup",
+	},
+	{
 		.name = "wm831x-buckv",
 		.id = 1,
 		.num_resources = ARRAY_SIZE(wm831x_dcdc1_resources),
diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index cea6cef..783e9b7 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -29,6 +29,13 @@ config APM_POWER
 	  Say Y here to enable support APM status emulation using
 	  battery class devices.
 
+config WM831X_BACKUP
+	tristate "WM831X backup battery charger support"
+	depends on MFD_WM831X
+	help
+	  Say Y here to enable support for the backup battery charger
+	  in the Wolfson Microelectronics WM831x PMICs.
+
 config WM831X_POWER
 	tristate "WM831X PMU support"
 	depends on MFD_WM831X
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index b96f29d..d1406b9 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 
 obj-$(CONFIG_PDA_POWER)		+= pda_power.o
 obj-$(CONFIG_APM_POWER)		+= apm_power.o
+obj-$(CONFIG_WM831X_BACKUP)	+= wm831x_backup.o
 obj-$(CONFIG_WM831X_POWER)	+= wm831x_power.o
 obj-$(CONFIG_WM8350_POWER)	+= wm8350_power.o
 
diff --git a/drivers/power/wm831x_backup.c b/drivers/power/wm831x_backup.c
new file mode 100644
index 0000000..f181076
--- /dev/null
+++ b/drivers/power/wm831x_backup.c
@@ -0,0 +1,233 @@
+/*
+ * Backup battery driver for Wolfson Microelectronics wm831x PMICs
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/platform_device.h>
+#include <linux/power_supply.h>
+
+#include <linux/mfd/wm831x/core.h>
+#include <linux/mfd/wm831x/auxadc.h>
+#include <linux/mfd/wm831x/pmu.h>
+#include <linux/mfd/wm831x/pdata.h>
+
+struct wm831x_backup {
+	struct wm831x *wm831x;
+	struct power_supply backup;
+};
+
+static int wm831x_backup_read_voltage(struct wm831x *wm831x,
+				     enum wm831x_auxadc src,
+				     union power_supply_propval *val)
+{
+	int ret;
+
+	ret = wm831x_auxadc_read_uv(wm831x, src);
+	if (ret >= 0)
+		val->intval = ret;
+
+	return ret;
+}
+
+/*********************************************************************
+ *		Backup supply properties
+ *********************************************************************/
+
+static void wm831x_config_backup(struct wm831x *wm831x)
+{
+	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_backup_pdata *pdata;
+	int ret, reg;
+
+	if (!wm831x_pdata || !wm831x_pdata->backup) {
+		dev_warn(wm831x->dev,
+			 "No backup battery charger configuration\n");
+		return;
+	}
+
+	pdata = wm831x_pdata->backup;
+
+	reg = 0;
+
+	if (pdata->charger_enable)
+		reg |= WM831X_BKUP_CHG_ENA | WM831X_BKUP_BATT_DET_ENA;
+	if (pdata->no_constant_voltage)
+		reg |= WM831X_BKUP_CHG_MODE;
+
+	switch (pdata->vlim) {
+	case 2500:
+		break;
+	case 3100:
+		reg |= WM831X_BKUP_CHG_VLIM;
+		break;
+	default:
+		dev_err(wm831x->dev, "Invalid backup voltage limit %dmV\n",
+			pdata->vlim);
+	}
+
+	switch (pdata->ilim) {
+	case 100:
+		break;
+	case 200:
+		reg |= 1;
+		break;
+	case 300:
+		reg |= 2;
+		break;
+	case 400:
+		reg |= 3;
+		break;
+	default:
+		dev_err(wm831x->dev, "Invalid backup current limit %duA\n",
+			pdata->ilim);
+	}
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret != 0) {
+		dev_err(wm831x->dev, "Failed to unlock registers: %d\n", ret);
+		return;
+	}
+
+	ret = wm831x_set_bits(wm831x, WM831X_BACKUP_CHARGER_CONTROL,
+			      WM831X_BKUP_CHG_ENA_MASK |
+			      WM831X_BKUP_CHG_MODE_MASK |
+			      WM831X_BKUP_BATT_DET_ENA_MASK |
+			      WM831X_BKUP_CHG_VLIM_MASK |
+			      WM831X_BKUP_CHG_ILIM_MASK,
+			      reg);
+	if (ret != 0)
+		dev_err(wm831x->dev,
+			"Failed to set backup charger config: %d\n", ret);
+
+	wm831x_reg_lock(wm831x);
+}
+
+static int wm831x_backup_get_prop(struct power_supply *psy,
+				  enum power_supply_property psp,
+				  union power_supply_propval *val)
+{
+	struct wm831x_backup *devdata = dev_get_drvdata(psy->dev->parent);
+	struct wm831x *wm831x = devdata->wm831x;
+	int ret = 0;
+
+	ret = wm831x_reg_read(wm831x, WM831X_BACKUP_CHARGER_CONTROL);
+	if (ret < 0)
+		return ret;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		if (ret & WM831X_BKUP_CHG_STS)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		break;
+
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = wm831x_backup_read_voltage(wm831x, WM831X_AUX_BKUP_BATT,
+						val);
+		break;
+
+	case POWER_SUPPLY_PROP_PRESENT:
+		if (ret & WM831X_BKUP_CHG_STS)
+			val->intval = 1;
+		else
+			val->intval = 0;
+		break;
+
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property wm831x_backup_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_PRESENT,
+};
+
+/*********************************************************************
+ *		Initialisation
+ *********************************************************************/
+
+static __devinit int wm831x_backup_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_backup *devdata;
+	struct power_supply *backup;
+	int ret, irq, i;
+
+	devdata = kzalloc(sizeof(struct wm831x_backup), GFP_KERNEL);
+	if (devdata == NULL)
+		return -ENOMEM;
+
+	devdata->wm831x = wm831x;
+	platform_set_drvdata(pdev, devdata);
+
+	backup = &devdata->backup;
+
+	/* We ignore configuration failures since we can still read
+	 * back the status without enabling the charger (which may
+	 * already be enabled anyway).
+	 */
+	wm831x_config_backup(wm831x);
+
+	backup->name = "wm831x-backup";
+	backup->type = POWER_SUPPLY_TYPE_BATTERY;
+	backup->properties = wm831x_backup_props;
+	backup->num_properties = ARRAY_SIZE(wm831x_backup_props);
+	backup->get_property = wm831x_backup_get_prop;
+	ret = power_supply_register(&pdev->dev, backup);
+	if (ret)
+		goto err_kmalloc;
+
+	return ret;
+
+err_kmalloc:
+	kfree(devdata);
+	return ret;
+}
+
+static __devexit int wm831x_backup_remove(struct platform_device *pdev)
+{
+	struct wm831x_backup *devdata = platform_get_drvdata(pdev);
+
+	power_supply_unregister(&devdata->backup);
+	kfree(devdata);
+
+	return 0;
+}
+
+static struct platform_driver wm831x_backup_driver = {
+	.probe = wm831x_backup_probe,
+	.remove = __devexit_p(wm831x_backup_remove),
+	.driver = {
+		.name = "wm831x-backup",
+	},
+};
+
+static int __init wm831x_backup_init(void)
+{
+	return platform_driver_register(&wm831x_backup_driver);
+}
+module_init(wm831x_backup_init);
+
+static void __exit wm831x_backup_exit(void)
+{
+	platform_driver_unregister(&wm831x_backup_driver);
+}
+module_exit(wm831x_backup_exit);
+
+MODULE_DESCRIPTION("Backup battery charger driver for WM831x PMICs");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-backup");
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
index 2a4c8b0..f85e80b 100644
--- a/drivers/power/wm831x_power.c
+++ b/drivers/power/wm831x_power.c
@@ -21,7 +21,6 @@
 struct wm831x_power {
 	struct wm831x *wm831x;
 	struct power_supply wall;
-	struct power_supply backup;
 	struct power_supply usb;
 	struct power_supply battery;
 };
@@ -454,125 +453,6 @@ static irqreturn_t wm831x_bat_irq(int irq, void *data)
 
 
 /*********************************************************************
- *		Backup supply properties
- *********************************************************************/
-
-static void wm831x_config_backup(struct wm831x *wm831x)
-{
-	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
-	struct wm831x_backup_pdata *pdata;
-	int ret, reg;
-
-	if (!wm831x_pdata || !wm831x_pdata->backup) {
-		dev_warn(wm831x->dev,
-			 "No backup battery charger configuration\n");
-		return;
-	}
-
-	pdata = wm831x_pdata->backup;
-
-	reg = 0;
-
-	if (pdata->charger_enable)
-		reg |= WM831X_BKUP_CHG_ENA | WM831X_BKUP_BATT_DET_ENA;
-	if (pdata->no_constant_voltage)
-		reg |= WM831X_BKUP_CHG_MODE;
-
-	switch (pdata->vlim) {
-	case 2500:
-		break;
-	case 3100:
-		reg |= WM831X_BKUP_CHG_VLIM;
-		break;
-	default:
-		dev_err(wm831x->dev, "Invalid backup voltage limit %dmV\n",
-			pdata->vlim);
-	}
-
-	switch (pdata->ilim) {
-	case 100:
-		break;
-	case 200:
-		reg |= 1;
-		break;
-	case 300:
-		reg |= 2;
-		break;
-	case 400:
-		reg |= 3;
-		break;
-	default:
-		dev_err(wm831x->dev, "Invalid backup current limit %duA\n",
-			pdata->ilim);
-	}
-
-	ret = wm831x_reg_unlock(wm831x);
-	if (ret != 0) {
-		dev_err(wm831x->dev, "Failed to unlock registers: %d\n", ret);
-		return;
-	}
-
-	ret = wm831x_set_bits(wm831x, WM831X_BACKUP_CHARGER_CONTROL,
-			      WM831X_BKUP_CHG_ENA_MASK |
-			      WM831X_BKUP_CHG_MODE_MASK |
-			      WM831X_BKUP_BATT_DET_ENA_MASK |
-			      WM831X_BKUP_CHG_VLIM_MASK |
-			      WM831X_BKUP_CHG_ILIM_MASK,
-			      reg);
-	if (ret != 0)
-		dev_err(wm831x->dev,
-			"Failed to set backup charger config: %d\n", ret);
-
-	wm831x_reg_lock(wm831x);
-}
-
-static int wm831x_backup_get_prop(struct power_supply *psy,
-				  enum power_supply_property psp,
-				  union power_supply_propval *val)
-{
-	struct wm831x_power *wm831x_power = dev_get_drvdata(psy->dev->parent);
-	struct wm831x *wm831x = wm831x_power->wm831x;
-	int ret = 0;
-
-	ret = wm831x_reg_read(wm831x, WM831X_BACKUP_CHARGER_CONTROL);
-	if (ret < 0)
-		return ret;
-
-	switch (psp) {
-	case POWER_SUPPLY_PROP_STATUS:
-		if (ret & WM831X_BKUP_CHG_STS)
-			val->intval = POWER_SUPPLY_STATUS_CHARGING;
-		else
-			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-		break;
-
-	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
-		ret = wm831x_power_read_voltage(wm831x, WM831X_AUX_BKUP_BATT,
-						val);
-		break;
-
-	case POWER_SUPPLY_PROP_PRESENT:
-		if (ret & WM831X_BKUP_CHG_STS)
-			val->intval = 1;
-		else
-			val->intval = 0;
-		break;
-
-	default:
-		ret = -EINVAL;
-		break;
-	}
-
-	return ret;
-}
-
-static enum power_supply_property wm831x_backup_props[] = {
-	POWER_SUPPLY_PROP_STATUS,
-	POWER_SUPPLY_PROP_VOLTAGE_NOW,
-	POWER_SUPPLY_PROP_PRESENT,
-};
-
-/*********************************************************************
  *		Initialisation
  *********************************************************************/
 
@@ -595,10 +475,7 @@ static irqreturn_t wm831x_pwr_src_irq(int irq, void *data)
 
 	dev_dbg(wm831x->dev, "Power source changed\n");
 
-	/* Just notify for everything - little harm in overnotifying.
-	 * The backup battery is not a power source while the system
-	 * is running so skip that.
-	 */
+	/* Just notify for everything - little harm in overnotifying. */
 	power_supply_changed(&wm831x_power->battery);
 	power_supply_changed(&wm831x_power->usb);
 	power_supply_changed(&wm831x_power->wall);
@@ -613,7 +490,6 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	struct power_supply *usb;
 	struct power_supply *battery;
 	struct power_supply *wall;
-	struct power_supply *backup;
 	int ret, irq, i;
 
 	power = kzalloc(sizeof(struct wm831x_power), GFP_KERNEL);
@@ -626,13 +502,11 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	usb = &power->usb;
 	battery = &power->battery;
 	wall = &power->wall;
-	backup = &power->backup;
 
 	/* We ignore configuration failures since we can still read back
-	 * the status without enabling either of the chargers.
+	 * the status without enabling the charger.
 	 */
 	wm831x_config_battery(wm831x);
-	wm831x_config_backup(wm831x);
 
 	wall->name = "wm831x-wall";
 	wall->type = POWER_SUPPLY_TYPE_MAINS;
@@ -661,15 +535,6 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_battery;
 
-	backup->name = "wm831x-backup";
-	backup->type = POWER_SUPPLY_TYPE_BATTERY;
-	backup->properties = wm831x_backup_props;
-	backup->num_properties = ARRAY_SIZE(wm831x_backup_props);
-	backup->get_property = wm831x_backup_get_prop;
-	ret = power_supply_register(&pdev->dev, backup);
-	if (ret)
-		goto err_usb;
-
 	irq = platform_get_irq_byname(pdev, "SYSLO");
 	ret = wm831x_request_irq(wm831x, irq, wm831x_syslo_irq,
 				 IRQF_TRIGGER_RISING, "SYSLO",
@@ -677,7 +542,7 @@ static __devinit int wm831x_power_probe(struct platform_device *pdev)
 	if (ret != 0) {
 		dev_err(&pdev->dev, "Failed to request SYSLO IRQ %d: %d\n",
 			irq, ret);
-		goto err_backup;
+		goto err_usb;
 	}
 
 	irq = platform_get_irq_byname(pdev, "PWR SRC");
@@ -716,8 +581,6 @@ err_bat_irq:
 err_syslo:
 	irq = platform_get_irq_byname(pdev, "SYSLO");
 	wm831x_free_irq(wm831x, irq, power);
-err_backup:
-	power_supply_unregister(backup);
 err_usb:
 	power_supply_unregister(usb);
 err_battery:
@@ -746,7 +609,6 @@ static __devexit int wm831x_power_remove(struct platform_device *pdev)
 	irq = platform_get_irq_byname(pdev, "SYSLO");
 	wm831x_free_irq(wm831x, irq, wm831x_power);
 
-	power_supply_unregister(&wm831x_power->backup);
 	power_supply_unregister(&wm831x_power->battery);
 	power_supply_unregister(&wm831x_power->wall);
 	power_supply_unregister(&wm831x_power->usb);
-- 
1.6.4.3

