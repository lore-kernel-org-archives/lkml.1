Return-Path: <linux-kernel-owner+w=401wt.eu-S1756685AbYKKPIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685AbYKKPIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 10:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755923AbYKKPIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 10:08:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36073 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755868AbYKKPIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 10:08:07 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>,
       Samuel Ortiz <sameo@openedhand.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] power_supply: Add support for WM8350 PMU
Date: Tue, 11 Nov 2008 15:08:03 +0000
Message-Id: <1226416083-12875-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for the PMU provided by the WM8350 which
implements battery, line and USB supplies including a battery charger.
The hardware functions largely autonomously, with minimal software
control required to initiate fast charging.

Support for configuration of the USB supply is not yet implemented.
This means that the hardware will remain in the mode configured at
startup, by default limiting the current drawn from USB to 100mA.

This driver was originally written by Liam Girdwood with subsequent
updates for submission by Mark Brown.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---

Modified to:
 - Notify core of status changes in the battery charger.
 - Remove the WM8350-specific supply state sysfs file.

following feedback from Andrew.

 drivers/power/Kconfig             |    7 +
 drivers/power/Makefile            |    1 +
 drivers/power/wm8350_power.c      |  515 +++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/core.h   |   26 ++
 include/linux/mfd/wm8350/supply.h |   23 ++-
 5 files changed, 571 insertions(+), 1 deletions(-)
 create mode 100644 drivers/power/wm8350_power.c

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index 8e0c2b4..52f8676 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -29,6 +29,13 @@ config APM_POWER
 	  Say Y here to enable support APM status emulation using
 	  battery class devices.
 
+config WM8350_POWER
+        tristate "WM8350 PMU support"
+        depends on MFD_WM8350
+        help
+          Say Y here to enable support for the power management unit
+	  provided by the Wolfson Microelectronics WM8350 PMIC.
+
 config BATTERY_DS2760
 	tristate "DS2760 battery driver (HP iPAQ & others)"
 	select W1
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index e8f1ece..e6f6865 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 
 obj-$(CONFIG_PDA_POWER)		+= pda_power.o
 obj-$(CONFIG_APM_POWER)		+= apm_power.o
+obj-$(CONFIG_WM8350_POWER)	+= wm8350_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
 obj-$(CONFIG_BATTERY_PMU)	+= pmu_battery.o
diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
new file mode 100644
index 0000000..9c0a847
--- /dev/null
+++ b/drivers/power/wm8350_power.c
@@ -0,0 +1,515 @@
+/*
+ * Battery driver for wm8350 PMIC
+ *
+ * Copyright 2007, 2008 Wolfson Microelectronics PLC.
+ *
+ * Based on OLPC Battery Driver
+ *
+ * Copyright 2006  David Woodhouse <dwmw2@infradead.org>
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
+#include <linux/mfd/wm8350/supply.h>
+#include <linux/mfd/wm8350/core.h>
+#include <linux/mfd/wm8350/comparator.h>
+
+static int wm8350_read_battery_uvolts(struct wm8350 *wm8350)
+{
+	return wm8350_read_auxadc(wm8350, WM8350_AUXADC_BATT, 0, 0)
+		* WM8350_AUX_COEFF;
+}
+
+static int wm8350_read_line_uvolts(struct wm8350 *wm8350)
+{
+	return wm8350_read_auxadc(wm8350, WM8350_AUXADC_LINE, 0, 0)
+		* WM8350_AUX_COEFF;
+}
+
+static int wm8350_read_usb_uvolts(struct wm8350 *wm8350)
+{
+	return wm8350_read_auxadc(wm8350, WM8350_AUXADC_USB, 0, 0)
+		* WM8350_AUX_COEFF;
+}
+
+#define WM8350_BATT_SUPPLY	1
+#define WM8350_USB_SUPPLY	2
+#define WM8350_LINE_SUPPLY	4
+
+static inline int wm8350_charge_time_min(struct wm8350 *wm8350, int min)
+{
+	if (wm8350->rev < WM8350_REV_G)
+		return (((min - 30) / 15) & 0xf) << 8;
+	else
+		return (((min - 30) / 30) & 0xf) << 8;
+}
+
+static int wm8350_get_supplies(struct wm8350 *wm8350)
+{
+	u16 sm, ov, co, chrg;
+	int supplies = 0;
+
+	sm = wm8350_reg_read(wm8350, WM8350_STATE_MACHINE_STATUS);
+	ov = wm8350_reg_read(wm8350, WM8350_MISC_OVERRIDES);
+	co = wm8350_reg_read(wm8350, WM8350_COMPARATOR_OVERRIDES);
+	chrg = wm8350_reg_read(wm8350, WM8350_BATTERY_CHARGER_CONTROL_2);
+
+	/* USB_SM */
+	sm = (sm & WM8350_USB_SM_MASK) >> WM8350_USB_SM_SHIFT;
+
+	/* CHG_ISEL */
+	chrg &= WM8350_CHG_ISEL_MASK;
+
+	/* If the USB state machine is active then we're using that with or
+	 * without battery, otherwise check for wall supply */
+	if (((sm == WM8350_USB_SM_100_SLV) ||
+	     (sm == WM8350_USB_SM_500_SLV) ||
+	     (sm == WM8350_USB_SM_STDBY_SLV))
+	    && !(ov & WM8350_USB_LIMIT_OVRDE))
+		supplies = WM8350_USB_SUPPLY;
+	else if (((sm == WM8350_USB_SM_100_SLV) ||
+		  (sm == WM8350_USB_SM_500_SLV) ||
+		  (sm == WM8350_USB_SM_STDBY_SLV))
+		 && (ov & WM8350_USB_LIMIT_OVRDE) && (chrg == 0))
+		supplies = WM8350_USB_SUPPLY | WM8350_BATT_SUPPLY;
+	else if (co & WM8350_WALL_FB_OVRDE)
+		supplies = WM8350_LINE_SUPPLY;
+	else
+		supplies = WM8350_BATT_SUPPLY;
+
+	return supplies;
+}
+
+static int wm8350_charger_config(struct wm8350 *wm8350,
+				 struct wm8350_charger_policy *policy)
+{
+	u16 reg, eoc_mA, fast_limit_mA;
+
+	if (!policy) {
+		dev_warn(wm8350->dev,
+			 "No charger policy, charger not configured.\n");
+		return -EINVAL;
+	}
+
+	/* make sure USB fast charge current is not > 500mA */
+	if (policy->fast_limit_USB_mA > 500) {
+		dev_err(wm8350->dev, "USB fast charge > 500mA\n");
+		return -EINVAL;
+	}
+
+	eoc_mA = WM8350_CHG_EOC_mA(policy->eoc_mA);
+
+	wm8350_reg_unlock(wm8350);
+
+	reg = wm8350_reg_read(wm8350, WM8350_BATTERY_CHARGER_CONTROL_1)
+		& WM8350_CHG_ENA_R168;
+	wm8350_reg_write(wm8350, WM8350_BATTERY_CHARGER_CONTROL_1,
+			 reg | eoc_mA | policy->trickle_start_mV |
+			 WM8350_CHG_TRICKLE_TEMP_CHOKE |
+			 WM8350_CHG_TRICKLE_USB_CHOKE |
+			 WM8350_CHG_FAST_USB_THROTTLE);
+
+	if (wm8350_get_supplies(wm8350) & WM8350_USB_SUPPLY) {
+		fast_limit_mA =
+			WM8350_CHG_FAST_LIMIT_mA(policy->fast_limit_USB_mA);
+		wm8350_reg_write(wm8350, WM8350_BATTERY_CHARGER_CONTROL_2,
+			    policy->charge_mV | policy->trickle_charge_USB_mA |
+			    fast_limit_mA | wm8350_charge_time_min(wm8350,
+						policy->charge_timeout));
+
+	} else {
+		fast_limit_mA =
+			WM8350_CHG_FAST_LIMIT_mA(policy->fast_limit_mA);
+		wm8350_reg_write(wm8350, WM8350_BATTERY_CHARGER_CONTROL_2,
+			    policy->charge_mV | policy->trickle_charge_mA |
+			    fast_limit_mA | wm8350_charge_time_min(wm8350,
+						policy->charge_timeout));
+	}
+
+	wm8350_reg_lock(wm8350);
+	return 0;
+}
+
+static int wm8350_batt_status(struct wm8350 *wm8350)
+{
+	u16 state;
+
+	state = wm8350_reg_read(wm8350, WM8350_BATTERY_CHARGER_CONTROL_2);
+	state &= WM8350_CHG_STS_MASK;
+
+	switch (state) {
+	case WM8350_CHG_STS_OFF:
+		return POWER_SUPPLY_STATUS_DISCHARGING;
+
+	case WM8350_CHG_STS_TRICKLE:
+	case WM8350_CHG_STS_FAST:
+		return POWER_SUPPLY_STATUS_CHARGING;
+
+	default:
+		return POWER_SUPPLY_STATUS_UNKNOWN;
+	}
+}
+
+static ssize_t charger_state_show(struct device *dev,
+				 struct device_attribute *attr, char *buf)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(dev);
+	char *charge;
+	int state;
+
+	state = wm8350_reg_read(wm8350, WM8350_BATTERY_CHARGER_CONTROL_2) &
+	    WM8350_CHG_STS_MASK;
+	switch (state) {
+	case WM8350_CHG_STS_OFF:
+		charge = "Charger Off";
+		break;
+	case WM8350_CHG_STS_TRICKLE:
+		charge = "Trickle Charging";
+		break;
+	case WM8350_CHG_STS_FAST:
+		charge = "Fast Charging";
+		break;
+	default:
+		return 0;
+	}
+
+	return sprintf(buf, "%s\n", charge);
+}
+
+static DEVICE_ATTR(charger_state, 0444, charger_state_show, NULL);
+
+static void wm8350_charger_handler(struct wm8350 *wm8350, int irq, void *data)
+{
+	struct wm8350_power *power = &wm8350->power;
+	struct wm8350_charger_policy *policy = power->policy;
+
+	switch (irq) {
+	case WM8350_IRQ_CHG_BAT_HOT:
+		dev_err(wm8350->dev, "battery too hot\n");
+		break;
+	case WM8350_IRQ_CHG_BAT_COLD:
+		dev_err(wm8350->dev, "battery too cold\n");
+		break;
+	case WM8350_IRQ_CHG_BAT_FAIL:
+		dev_err(wm8350->dev, "battery failed\n");
+		break;
+	case WM8350_IRQ_CHG_TO:
+		dev_err(wm8350->dev, "charger timeout\n");
+		break;
+	case WM8350_IRQ_CHG_END:
+		power_supply_changed(&power->battery);
+		break;
+	case WM8350_IRQ_CHG_START:
+		power_supply_changed(&power->battery);
+		break;
+
+	case WM8350_IRQ_CHG_FAST_RDY:
+		dev_dbg(wm8350->dev, "fast charger ready\n");
+		wm8350_charger_config(wm8350, policy);
+		wm8350_reg_unlock(wm8350);
+		wm8350_set_bits(wm8350, WM8350_BATTERY_CHARGER_CONTROL_1,
+				WM8350_CHG_FAST);
+		wm8350_reg_lock(wm8350);
+		break;
+
+	case WM8350_IRQ_CHG_VBATT_LT_3P9:
+		dev_warn(wm8350->dev, "battery < 3.9V\n");
+		break;
+	case WM8350_IRQ_CHG_VBATT_LT_3P1:
+		dev_warn(wm8350->dev, "battery < 3.1V\n");
+		break;
+	case WM8350_IRQ_CHG_VBATT_LT_2P85:
+		dev_warn(wm8350->dev, "battery < 2.85V\n");
+		break;
+
+		/* Supply change.  We will overnotify but it should do
+		 * no harm. */
+	case WM8350_IRQ_EXT_USB_FB:
+	case WM8350_IRQ_EXT_WALL_FB:
+		wm8350_charger_config(wm8350, policy);
+	case WM8350_IRQ_EXT_BAT_FB:   /* Fall through */
+		power_supply_changed(&power->battery);
+		power_supply_changed(&power->usb);
+		power_supply_changed(&power->ac);
+		break;
+
+	default:
+		dev_err(wm8350->dev, "Unknown interrupt %d\n", irq);
+	}
+}
+
+/*********************************************************************
+ *		AC Power
+ *********************************************************************/
+static int wm8350_ac_get_prop(struct power_supply *psy,
+			      enum power_supply_property psp,
+			      union power_supply_propval *val)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(psy->dev->parent);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = !!(wm8350_get_supplies(wm8350) &
+				 WM8350_LINE_SUPPLY);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = wm8350_read_line_uvolts(wm8350);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static enum power_supply_property wm8350_ac_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+};
+
+/*********************************************************************
+ *		USB Power
+ *********************************************************************/
+static int wm8350_usb_get_prop(struct power_supply *psy,
+			       enum power_supply_property psp,
+			       union power_supply_propval *val)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(psy->dev->parent);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = !!(wm8350_get_supplies(wm8350) &
+				 WM8350_USB_SUPPLY);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = wm8350_read_usb_uvolts(wm8350);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+	return ret;
+}
+
+static enum power_supply_property wm8350_usb_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+};
+
+/*********************************************************************
+ *		Battery properties
+ *********************************************************************/
+
+static int wm8350_bat_get_property(struct power_supply *psy,
+				   enum power_supply_property psp,
+				   union power_supply_propval *val)
+{
+	struct wm8350 *wm8350 = dev_get_drvdata(psy->dev->parent);
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		val->intval = wm8350_batt_status(wm8350);
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		val->intval = !!(wm8350_get_supplies(wm8350) &
+				 WM8350_BATT_SUPPLY);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		val->intval = wm8350_read_battery_uvolts(wm8350);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property wm8350_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+};
+
+/*********************************************************************
+ *		Initialisation
+ *********************************************************************/
+
+static void wm8350_init_charger(struct wm8350 *wm8350)
+{
+	/* register our interest in charger events */
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_TO,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_TO);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_END,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_END);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_START,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_START);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_FAST_RDY);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
+	wm8350_register_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
+
+	/* and supply change events */
+	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_USB_FB,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
+	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_WALL_FB,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
+	wm8350_register_irq(wm8350, WM8350_IRQ_EXT_BAT_FB,
+			    wm8350_charger_handler, NULL);
+	wm8350_unmask_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
+}
+
+static void free_charger_irq(struct wm8350 *wm8350)
+{
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_HOT);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_COLD);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_BAT_FAIL);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_TO);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_TO);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_END);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_END);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_START);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_START);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P9);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_3P1);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
+	wm8350_free_irq(wm8350, WM8350_IRQ_CHG_VBATT_LT_2P85);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_USB_FB);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_WALL_FB);
+	wm8350_mask_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
+	wm8350_free_irq(wm8350, WM8350_IRQ_EXT_BAT_FB);
+}
+
+static __devinit int wm8350_power_probe(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+	struct wm8350_power *power = &wm8350->power;
+	struct wm8350_charger_policy *policy = power->policy;
+	struct power_supply *usb = &power->usb;
+	struct power_supply *battery = &power->battery;
+	struct power_supply *ac = &power->ac;
+	int ret;
+
+	ac->name = "wm8350-ac";
+	ac->type = POWER_SUPPLY_TYPE_MAINS;
+	ac->properties = wm8350_ac_props;
+	ac->num_properties = ARRAY_SIZE(wm8350_ac_props);
+	ac->get_property = wm8350_ac_get_prop;
+	ret = power_supply_register(&pdev->dev, ac);
+	if (ret)
+		return ret;
+
+	battery->name = "wm8350-battery";
+	battery->properties = wm8350_bat_props;
+	battery->num_properties = ARRAY_SIZE(wm8350_bat_props);
+	battery->get_property = wm8350_bat_get_property;
+	battery->use_for_apm = 1;
+	ret = power_supply_register(&pdev->dev, battery);
+	if (ret)
+		goto battery_failed;
+
+	usb->name = "wm8350-usb",
+	usb->type = POWER_SUPPLY_TYPE_USB;
+	usb->properties = wm8350_usb_props;
+	usb->num_properties = ARRAY_SIZE(wm8350_usb_props);
+	usb->get_property = wm8350_usb_get_prop;
+	ret = power_supply_register(&pdev->dev, usb);
+	if (ret)
+		goto usb_failed;
+
+	ret = device_create_file(&pdev->dev, &dev_attr_charger_state);
+	if (ret < 0)
+		dev_warn(wm8350->dev, "failed to add charge sysfs: %d\n", ret);
+	ret = 0;
+
+	wm8350_init_charger(wm8350);
+	if (wm8350_charger_config(wm8350, policy) == 0) {
+		wm8350_reg_unlock(wm8350);
+		wm8350_set_bits(wm8350, WM8350_POWER_MGMT_5, WM8350_CHG_ENA);
+		wm8350_reg_lock(wm8350);
+	}
+
+	return ret;
+
+usb_failed:
+	power_supply_unregister(battery);
+battery_failed:
+	power_supply_unregister(ac);
+
+	return ret;
+}
+
+static __devexit int wm8350_power_remove(struct platform_device *pdev)
+{
+	struct wm8350 *wm8350 = platform_get_drvdata(pdev);
+	struct wm8350_power *power = &wm8350->power;
+
+	free_charger_irq(wm8350);
+	device_remove_file(&pdev->dev, &dev_attr_charger_state);
+	power_supply_unregister(&power->battery);
+	power_supply_unregister(&power->ac);
+	power_supply_unregister(&power->usb);
+	return 0;
+}
+
+static struct platform_driver wm8350_power_driver = {
+	.probe = wm8350_power_probe,
+	.remove = __devexit_p(wm8350_power_remove),
+	.driver = {
+		.name = "wm8350-power",
+	},
+};
+
+static int __init wm8350_power_init(void)
+{
+	return platform_driver_register(&wm8350_power_driver);
+}
+module_init(wm8350_power_init);
+
+static void __exit wm8350_power_exit(void)
+{
+	platform_driver_unregister(&wm8350_power_driver);
+}
+module_exit(wm8350_power_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Power supply driver for WM8350");
+MODULE_ALIAS("platform:wm8350-power");
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index cc19005..d2614df 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -57,6 +57,9 @@
 #define WM8350_OVER_CURRENT_INT_STATUS_MASK     0x25
 #define WM8350_GPIO_INT_STATUS_MASK             0x26
 #define WM8350_COMPARATOR_INT_STATUS_MASK       0x27
+#define WM8350_MISC_OVERRIDES			0xE3
+#define WM8350_COMPARATOR_OVERRIDES		0xE7
+#define WM8350_STATE_MACHINE_STATUS		0xE9
 
 #define WM8350_MAX_REGISTER                     0xFF
 
@@ -523,6 +526,29 @@
 #define WM8350_DC2_STS                          0x0002
 #define WM8350_DC1_STS                          0x0001
 
+/*
+ * R227 (0xE3) - Misc Overrides
+ */
+#define WM8350_USB_LIMIT_OVRDE			0x0400
+
+/*
+ * R227 (0xE7) - Comparator Overrides
+ */
+#define WM8350_USB_FB_OVRDE			0x8000
+#define WM8350_WALL_FB_OVRDE			0x4000
+#define WM8350_BATT_FB_OVRDE			0x2000
+
+
+/*
+ * R233 (0xE9) - State Machinine Status
+ */
+#define WM8350_USB_SM_MASK			0x0700
+#define WM8350_USB_SM_SHIFT			8
+
+#define WM8350_USB_SM_100_SLV   1
+#define WM8350_USB_SM_500_SLV   5
+#define WM8350_USB_SM_STDBY_SLV 7
+
 /* WM8350 wake up conditions */
 #define WM8350_IRQ_WKUP_OFF_STATE		43
 #define WM8350_IRQ_WKUP_HIB_STATE		44
diff --git a/include/linux/mfd/wm8350/supply.h b/include/linux/mfd/wm8350/supply.h
index 1c8f3cd..7972151 100644
--- a/include/linux/mfd/wm8350/supply.h
+++ b/include/linux/mfd/wm8350/supply.h
@@ -13,7 +13,8 @@
 #ifndef __LINUX_MFD_WM8350_SUPPLY_H_
 #define __LINUX_MFD_WM8350_SUPPLY_H_
 
-#include <linux/platform_device.h>
+#include <linux/mutex.h>
+#include <linux/power_supply.h>
 
 /*
  * Charger registers
@@ -104,8 +105,28 @@
 #define WM8350_IRQ_EXT_WALL_FB			37
 #define WM8350_IRQ_EXT_BAT_FB			38
 
+/*
+ * Policy to control charger state machine.
+ */
+struct wm8350_charger_policy {
+
+	/* charger state machine policy  - set in machine driver */
+	int eoc_mA;		/* end of charge current (mA)  */
+	int charge_mV;		/* charge voltage */
+	int fast_limit_mA;	/* fast charge current limit */
+	int fast_limit_USB_mA;	/* USB fast charge current limit */
+	int charge_timeout;	/* charge timeout (mins) */
+	int trickle_start_mV;	/* trickle charge starts at mV */
+	int trickle_charge_mA;	/* trickle charge current */
+	int trickle_charge_USB_mA;	/* USB trickle charge current */
+};
+
 struct wm8350_power {
 	struct platform_device *pdev;
+	struct power_supply battery;
+	struct power_supply usb;
+	struct power_supply ac;
+	struct wm8350_charger_policy *policy;
 };
 
 #endif
-- 
1.5.6.5

