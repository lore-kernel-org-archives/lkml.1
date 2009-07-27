Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbZG0NrC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbZG0NrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:47:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755230AbZG0Nq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:46:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59153 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754801AbZG0Nqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:46:32 -0400
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Anton Vorontsov <cbouatmailru@gmail.com>
Subject: [PATCH 15/22] power_supply: Add driver for the PMU on WM831x PMICs
Date: Mon, 27 Jul 2009 14:46:05 +0100
Message-Id: <1248702372-29534-15-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <20090727134527.GA12849@rakim.wolfsonmicro.main>
References: <20090727134527.GA12849@rakim.wolfsonmicro.main>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The WM831x PMICs provide power path management from three sources:
a wall supply, USB and a battery with integrated charger. They also
provide an additional backup supply with integrated for maintaining
always on functionality such as the RTC and monitoring of power
switches.

After some initial configuration at startup the device operates
autonomously, the driver simply provides reporting of the current
state.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/power/Kconfig          |    7 +
 drivers/power/Makefile         |    1 +
 drivers/power/wm831x_power.c   |  779 ++++++++++++++++++++++++++++++++++++++++
 include/linux/mfd/wm831x/pmu.h |  189 ++++++++++
 4 files changed, 976 insertions(+), 0 deletions(-)
 create mode 100644 drivers/power/wm831x_power.c
 create mode 100644 include/linux/mfd/wm831x/pmu.h

diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
index bdbc4f7..343194c 100644
--- a/drivers/power/Kconfig
+++ b/drivers/power/Kconfig
@@ -29,6 +29,13 @@ config APM_POWER
 	  Say Y here to enable support APM status emulation using
 	  battery class devices.
 
+config WM831X_POWER
+        tristate "WM831X PMU support"
+        depends on MFD_WM831X
+        help
+          Say Y here to enable support for the power management unit
+	  provided by Wolfson Microelectronics WM831x PMICs.
+
 config WM8350_POWER
         tristate "WM8350 PMU support"
         depends on MFD_WM8350
diff --git a/drivers/power/Makefile b/drivers/power/Makefile
index 380d17c..b96f29d 100644
--- a/drivers/power/Makefile
+++ b/drivers/power/Makefile
@@ -16,6 +16,7 @@ obj-$(CONFIG_POWER_SUPPLY)	+= power_supply.o
 
 obj-$(CONFIG_PDA_POWER)		+= pda_power.o
 obj-$(CONFIG_APM_POWER)		+= apm_power.o
+obj-$(CONFIG_WM831X_POWER)	+= wm831x_power.o
 obj-$(CONFIG_WM8350_POWER)	+= wm8350_power.o
 
 obj-$(CONFIG_BATTERY_DS2760)	+= ds2760_battery.o
diff --git a/drivers/power/wm831x_power.c b/drivers/power/wm831x_power.c
new file mode 100644
index 0000000..2a4c8b0
--- /dev/null
+++ b/drivers/power/wm831x_power.c
@@ -0,0 +1,779 @@
+/*
+ * PMU driver for Wolfson Microelectronics wm831x PMICs
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
+struct wm831x_power {
+	struct wm831x *wm831x;
+	struct power_supply wall;
+	struct power_supply backup;
+	struct power_supply usb;
+	struct power_supply battery;
+};
+
+static int wm831x_power_check_online(struct wm831x *wm831x, int supply,
+				     union power_supply_propval *val)
+{
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_SYSTEM_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & supply)
+		val->intval = 1;
+	else
+		val->intval = 0;
+
+	return 0;
+}
+
+static int wm831x_power_read_voltage(struct wm831x *wm831x,
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
+ *		WALL Power
+ *********************************************************************/
+static int wm831x_wall_get_prop(struct power_supply *psy,
+				enum power_supply_property psp,
+				union power_supply_propval *val)
+{
+	struct wm831x_power *wm831x_power = dev_get_drvdata(psy->dev->parent);
+	struct wm831x *wm831x = wm831x_power->wm831x;
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = wm831x_power_check_online(wm831x, WM831X_PWR_WALL, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = wm831x_power_read_voltage(wm831x, WM831X_AUX_WALL, val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property wm831x_wall_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+};
+
+/*********************************************************************
+ *		USB Power
+ *********************************************************************/
+static int wm831x_usb_get_prop(struct power_supply *psy,
+			       enum power_supply_property psp,
+			       union power_supply_propval *val)
+{
+	struct wm831x_power *wm831x_power = dev_get_drvdata(psy->dev->parent);
+	struct wm831x *wm831x = wm831x_power->wm831x;
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = wm831x_power_check_online(wm831x, WM831X_PWR_USB, val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = wm831x_power_read_voltage(wm831x, WM831X_AUX_USB, val);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property wm831x_usb_props[] = {
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+};
+
+/*********************************************************************
+ *		Battery properties
+ *********************************************************************/
+
+struct chg_map {
+	int val;
+	int reg_val;
+};
+
+static struct chg_map trickle_ilims[] = {
+	{  50, 0 << WM831X_CHG_TRKL_ILIM_SHIFT },
+	{ 100, 1 << WM831X_CHG_TRKL_ILIM_SHIFT },
+	{ 150, 2 << WM831X_CHG_TRKL_ILIM_SHIFT },
+	{ 200, 3 << WM831X_CHG_TRKL_ILIM_SHIFT },
+};
+
+static struct chg_map vsels[] = {
+	{ 4050, 0 << WM831X_CHG_VSEL_SHIFT },
+	{ 4100, 1 << WM831X_CHG_VSEL_SHIFT },
+	{ 4150, 2 << WM831X_CHG_VSEL_SHIFT },
+	{ 4200, 3 << WM831X_CHG_VSEL_SHIFT },
+};
+
+static struct chg_map fast_ilims[] = {
+	{    0,  0 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{   50,  1 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  100,  2 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  150,  3 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  200,  4 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  250,  5 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  300,  6 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  350,  7 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  400,  8 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  450,  9 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  500, 10 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  600, 11 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  700, 12 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  800, 13 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{  900, 14 << WM831X_CHG_FAST_ILIM_SHIFT },
+	{ 1000, 15 << WM831X_CHG_FAST_ILIM_SHIFT },
+};
+
+static struct chg_map eoc_iterms[] = {
+	{ 20, 0 << WM831X_CHG_ITERM_SHIFT },
+	{ 30, 1 << WM831X_CHG_ITERM_SHIFT },
+	{ 40, 2 << WM831X_CHG_ITERM_SHIFT },
+	{ 50, 3 << WM831X_CHG_ITERM_SHIFT },
+	{ 60, 4 << WM831X_CHG_ITERM_SHIFT },
+	{ 70, 5 << WM831X_CHG_ITERM_SHIFT },
+	{ 80, 6 << WM831X_CHG_ITERM_SHIFT },
+	{ 90, 7 << WM831X_CHG_ITERM_SHIFT },
+};
+
+static struct chg_map chg_times[] = {
+	{  60,  0 << WM831X_CHG_TIME_SHIFT },
+	{  90,  1 << WM831X_CHG_TIME_SHIFT },
+	{ 120,  2 << WM831X_CHG_TIME_SHIFT },
+	{ 150,  3 << WM831X_CHG_TIME_SHIFT },
+	{ 180,  4 << WM831X_CHG_TIME_SHIFT },
+	{ 210,  5 << WM831X_CHG_TIME_SHIFT },
+	{ 240,  6 << WM831X_CHG_TIME_SHIFT },
+	{ 270,  7 << WM831X_CHG_TIME_SHIFT },
+	{ 300,  8 << WM831X_CHG_TIME_SHIFT },
+	{ 330,  9 << WM831X_CHG_TIME_SHIFT },
+	{ 360, 10 << WM831X_CHG_TIME_SHIFT },
+	{ 390, 11 << WM831X_CHG_TIME_SHIFT },
+	{ 420, 12 << WM831X_CHG_TIME_SHIFT },
+	{ 450, 13 << WM831X_CHG_TIME_SHIFT },
+	{ 480, 14 << WM831X_CHG_TIME_SHIFT },
+	{ 510, 15 << WM831X_CHG_TIME_SHIFT },
+};
+
+static void wm831x_battey_apply_config(struct wm831x *wm831x,
+				       struct chg_map *map, int count, int val,
+				       int *reg, const char *name,
+				       const char *units)
+{
+	int i;
+
+	for (i = 0; i < count; i++)
+		if (val == map[i].val)
+			break;
+	if (i == count) {
+		dev_err(wm831x->dev, "Invalid %s %d%s\n",
+			name, val, units);
+	} else {
+		*reg |= map[i].reg_val;
+		dev_dbg(wm831x->dev, "Set %s of %d%s\n", name, val, units);
+	}
+}
+
+static void wm831x_config_battery(struct wm831x *wm831x)
+{
+	struct wm831x_pdata *wm831x_pdata = wm831x->dev->platform_data;
+	struct wm831x_battery_pdata *pdata;
+	int ret, reg1, reg2;
+
+	if (!wm831x_pdata || !wm831x_pdata->battery) {
+		dev_warn(wm831x->dev,
+			 "No battery charger configuration\n");
+		return;
+	}
+
+	pdata = wm831x_pdata->battery;
+
+	reg1 = 0;
+	reg2 = 0;
+
+	if (!pdata->enable) {
+		dev_info(wm831x->dev, "Battery charger disabled\n");
+		return;
+	}
+
+	reg1 |= WM831X_CHG_ENA;
+	if (pdata->off_mask)
+		reg2 |= WM831X_CHG_OFF_MSK;
+	if (pdata->fast_enable)
+		reg1 |= WM831X_CHG_FAST;
+
+	wm831x_battey_apply_config(wm831x, trickle_ilims,
+				   ARRAY_SIZE(trickle_ilims),
+				   pdata->trickle_ilim, &reg2,
+				   "trickle charge current limit", "mA");
+
+	wm831x_battey_apply_config(wm831x, vsels, ARRAY_SIZE(vsels),
+				   pdata->vsel, &reg2,
+				   "target voltage", "mV");
+
+	wm831x_battey_apply_config(wm831x, fast_ilims, ARRAY_SIZE(fast_ilims),
+				   pdata->fast_ilim, &reg2,
+				   "fast charge current limit", "mA");
+
+	wm831x_battey_apply_config(wm831x, eoc_iterms, ARRAY_SIZE(eoc_iterms),
+				   pdata->eoc_iterm, &reg1,
+				   "end of charge current threshold", "mA");
+
+	wm831x_battey_apply_config(wm831x, chg_times, ARRAY_SIZE(chg_times),
+				   pdata->timeout, &reg2,
+				   "charger timeout", "min");
+
+	ret = wm831x_reg_unlock(wm831x);
+	if (ret != 0) {
+		dev_err(wm831x->dev, "Failed to unlock registers: %d\n", ret);
+		return;
+	}
+
+	ret = wm831x_set_bits(wm831x, WM831X_CHARGER_CONTROL_1,
+			      WM831X_CHG_ENA_MASK |
+			      WM831X_CHG_FAST_MASK |
+			      WM831X_CHG_ITERM_MASK |
+			      WM831X_CHG_ITERM_MASK,
+			      reg1);
+	if (ret != 0)
+		dev_err(wm831x->dev, "Failed to set charger control 1: %d\n",
+			ret);
+
+	ret = wm831x_set_bits(wm831x, WM831X_CHARGER_CONTROL_2,
+			      WM831X_CHG_OFF_MSK |
+			      WM831X_CHG_TIME_MASK |
+			      WM831X_CHG_FAST_ILIM_MASK |
+			      WM831X_CHG_TRKL_ILIM_MASK |
+			      WM831X_CHG_VSEL_MASK,
+			      reg2);
+	if (ret != 0)
+		dev_err(wm831x->dev, "Failed to set charger control 2: %d\n",
+			ret);
+
+	wm831x_reg_lock(wm831x);
+}
+
+static int wm831x_bat_check_status(struct wm831x *wm831x, int *status)
+{
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_SYSTEM_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & WM831X_PWR_SRC_BATT) {
+		*status = POWER_SUPPLY_STATUS_DISCHARGING;
+		return 0;
+	}
+
+	ret = wm831x_reg_read(wm831x, WM831X_CHARGER_STATUS);
+	if (ret < 0)
+		return ret;
+
+	switch (ret & WM831X_CHG_STATE_MASK) {
+	case WM831X_CHG_STATE_OFF:
+		*status = POWER_SUPPLY_STATUS_NOT_CHARGING;
+		break;
+	case WM831X_CHG_STATE_TRICKLE:
+	case WM831X_CHG_STATE_FAST:
+		*status = POWER_SUPPLY_STATUS_CHARGING;
+		break;
+
+	default:
+		*status = POWER_SUPPLY_STATUS_UNKNOWN;
+		break;
+	}
+
+	return 0;
+}
+
+static int wm831x_bat_check_type(struct wm831x *wm831x, int *type)
+{
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_CHARGER_STATUS);
+	if (ret < 0)
+		return ret;
+
+	switch (ret & WM831X_CHG_STATE_MASK) {
+	case WM831X_CHG_STATE_TRICKLE:
+	case WM831X_CHG_STATE_TRICKLE_OT:
+		*type = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+		break;
+	case WM831X_CHG_STATE_FAST:
+	case WM831X_CHG_STATE_FAST_OT:
+		*type = POWER_SUPPLY_CHARGE_TYPE_FAST;
+		break;
+	default:
+		*type = POWER_SUPPLY_CHARGE_TYPE_NONE;
+		break;
+	}
+
+	return 0;
+}
+
+static int wm831x_bat_check_health(struct wm831x *wm831x, int *health)
+{
+	int ret;
+
+	ret = wm831x_reg_read(wm831x, WM831X_CHARGER_STATUS);
+	if (ret < 0)
+		return ret;
+
+	if (ret & WM831X_BATT_HOT_STS) {
+		*health = POWER_SUPPLY_HEALTH_OVERHEAT;
+		return 0;
+	}
+
+	if (ret & WM831X_BATT_COLD_STS) {
+		*health = POWER_SUPPLY_HEALTH_COLD;
+		return 0;
+	}
+
+	if (ret & WM831X_BATT_OV_STS) {
+		*health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
+		return 0;
+	}
+
+	switch (ret & WM831X_CHG_STATE_MASK) {
+	case WM831X_CHG_STATE_TRICKLE_OT:
+	case WM831X_CHG_STATE_FAST_OT:
+		*health = POWER_SUPPLY_HEALTH_OVERHEAT;
+		break;
+	case WM831X_CHG_STATE_DEFECTIVE:
+		*health = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		break;
+	default:
+		*health = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+	}
+
+	return 0;
+}
+
+static int wm831x_bat_get_prop(struct power_supply *psy,
+			       enum power_supply_property psp,
+			       union power_supply_propval *val)
+{
+	struct wm831x_power *wm831x_power = dev_get_drvdata(psy->dev->parent);
+	struct wm831x *wm831x = wm831x_power->wm831x;
+	int ret = 0;
+
+	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = wm831x_bat_check_status(wm831x, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_ONLINE:
+		ret = wm831x_power_check_online(wm831x, WM831X_PWR_SRC_BATT,
+						val);
+		break;
+	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
+		ret = wm831x_power_read_voltage(wm831x, WM831X_AUX_BATT, val);
+		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		ret = wm831x_bat_check_health(wm831x, &val->intval);
+		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		ret = wm831x_bat_check_type(wm831x, &val->intval);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static enum power_supply_property wm831x_bat_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_ONLINE,
+	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_HEALTH,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
+};
+
+static const char *wm831x_bat_irqs[] = {
+	"BATT HOT",
+	"BATT COLD",
+	"BATT FAIL",
+	"OV",
+	"END",
+	"TO",
+	"MODE",
+	"START",
+};
+
+static irqreturn_t wm831x_bat_irq(int irq, void *data)
+{
+	struct wm831x_power *wm831x_power = data;
+	struct wm831x *wm831x = wm831x_power->wm831x;
+
+	dev_dbg(wm831x->dev, "Battery status changed: %d\n", irq);
+
+	/* The battery charger is autonomous so we don't need to do
+	 * anything except kick user space */
+	power_supply_changed(&wm831x_power->battery);
+
+	return IRQ_HANDLED;
+}
+
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
+	struct wm831x_power *wm831x_power = dev_get_drvdata(psy->dev->parent);
+	struct wm831x *wm831x = wm831x_power->wm831x;
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
+		ret = wm831x_power_read_voltage(wm831x, WM831X_AUX_BKUP_BATT,
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
+static irqreturn_t wm831x_syslo_irq(int irq, void *data)
+{
+	struct wm831x_power *wm831x_power = data;
+	struct wm831x *wm831x = wm831x_power->wm831x;
+
+	/* Not much we can actually *do* but tell people for
+	 * posterity, we're probably about to run out of power. */
+	dev_crit(wm831x->dev, "SYSVDD under voltage\n");
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t wm831x_pwr_src_irq(int irq, void *data)
+{
+	struct wm831x_power *wm831x_power = data;
+	struct wm831x *wm831x = wm831x_power->wm831x;
+
+	dev_dbg(wm831x->dev, "Power source changed\n");
+
+	/* Just notify for everything - little harm in overnotifying.
+	 * The backup battery is not a power source while the system
+	 * is running so skip that.
+	 */
+	power_supply_changed(&wm831x_power->battery);
+	power_supply_changed(&wm831x_power->usb);
+	power_supply_changed(&wm831x_power->wall);
+
+	return IRQ_HANDLED;
+}
+
+static __devinit int wm831x_power_probe(struct platform_device *pdev)
+{
+	struct wm831x *wm831x = dev_get_drvdata(pdev->dev.parent);
+	struct wm831x_power *power;
+	struct power_supply *usb;
+	struct power_supply *battery;
+	struct power_supply *wall;
+	struct power_supply *backup;
+	int ret, irq, i;
+
+	power = kzalloc(sizeof(struct wm831x_power), GFP_KERNEL);
+	if (power == NULL)
+		return -ENOMEM;
+
+	power->wm831x = wm831x;
+	platform_set_drvdata(pdev, power);
+
+	usb = &power->usb;
+	battery = &power->battery;
+	wall = &power->wall;
+	backup = &power->backup;
+
+	/* We ignore configuration failures since we can still read back
+	 * the status without enabling either of the chargers.
+	 */
+	wm831x_config_battery(wm831x);
+	wm831x_config_backup(wm831x);
+
+	wall->name = "wm831x-wall";
+	wall->type = POWER_SUPPLY_TYPE_MAINS;
+	wall->properties = wm831x_wall_props;
+	wall->num_properties = ARRAY_SIZE(wm831x_wall_props);
+	wall->get_property = wm831x_wall_get_prop;
+	ret = power_supply_register(&pdev->dev, wall);
+	if (ret)
+		goto err_kmalloc;
+
+	battery->name = "wm831x-battery";
+	battery->properties = wm831x_bat_props;
+	battery->num_properties = ARRAY_SIZE(wm831x_bat_props);
+	battery->get_property = wm831x_bat_get_prop;
+	battery->use_for_apm = 1;
+	ret = power_supply_register(&pdev->dev, battery);
+	if (ret)
+		goto err_wall;
+
+	usb->name = "wm831x-usb",
+	usb->type = POWER_SUPPLY_TYPE_USB;
+	usb->properties = wm831x_usb_props;
+	usb->num_properties = ARRAY_SIZE(wm831x_usb_props);
+	usb->get_property = wm831x_usb_get_prop;
+	ret = power_supply_register(&pdev->dev, usb);
+	if (ret)
+		goto err_battery;
+
+	backup->name = "wm831x-backup";
+	backup->type = POWER_SUPPLY_TYPE_BATTERY;
+	backup->properties = wm831x_backup_props;
+	backup->num_properties = ARRAY_SIZE(wm831x_backup_props);
+	backup->get_property = wm831x_backup_get_prop;
+	ret = power_supply_register(&pdev->dev, backup);
+	if (ret)
+		goto err_usb;
+
+	irq = platform_get_irq_byname(pdev, "SYSLO");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_syslo_irq,
+				 IRQF_TRIGGER_RISING, "SYSLO",
+				 power);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request SYSLO IRQ %d: %d\n",
+			irq, ret);
+		goto err_backup;
+	}
+
+	irq = platform_get_irq_byname(pdev, "PWR SRC");
+	ret = wm831x_request_irq(wm831x, irq, wm831x_pwr_src_irq,
+				 IRQF_TRIGGER_RISING, "Power source",
+				 power);
+	if (ret != 0) {
+		dev_err(&pdev->dev, "Failed to request PWR SRC IRQ %d: %d\n",
+			irq, ret);
+		goto err_syslo;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
+		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
+		ret = wm831x_request_irq(wm831x, irq, wm831x_bat_irq,
+					 IRQF_TRIGGER_RISING,
+					 wm831x_bat_irqs[i],
+					 power);
+		if (ret != 0) {
+			dev_err(&pdev->dev,
+				"Failed to request %s IRQ %d: %d\n",
+				wm831x_bat_irqs[i], irq, ret);
+			goto err_bat_irq;
+		}
+	}
+
+	return ret;
+
+err_bat_irq:
+	for (; i >= 0; i--) {
+		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
+		wm831x_free_irq(wm831x, irq, power);
+	}
+	irq = platform_get_irq_byname(pdev, "PWR SRC");
+	wm831x_free_irq(wm831x, irq, power);
+err_syslo:
+	irq = platform_get_irq_byname(pdev, "SYSLO");
+	wm831x_free_irq(wm831x, irq, power);
+err_backup:
+	power_supply_unregister(backup);
+err_usb:
+	power_supply_unregister(usb);
+err_battery:
+	power_supply_unregister(battery);
+err_wall:
+	power_supply_unregister(wall);
+err_kmalloc:
+	kfree(power);
+	return ret;
+}
+
+static __devexit int wm831x_power_remove(struct platform_device *pdev)
+{
+	struct wm831x_power *wm831x_power = platform_get_drvdata(pdev);
+	struct wm831x *wm831x = wm831x_power->wm831x;
+	int irq, i;
+
+	for (i = 0; i < ARRAY_SIZE(wm831x_bat_irqs); i++) {
+		irq = platform_get_irq_byname(pdev, wm831x_bat_irqs[i]);
+		wm831x_free_irq(wm831x, irq, wm831x_power);
+	}
+
+	irq = platform_get_irq_byname(pdev, "PWR SRC");
+	wm831x_free_irq(wm831x, irq, wm831x_power);
+
+	irq = platform_get_irq_byname(pdev, "SYSLO");
+	wm831x_free_irq(wm831x, irq, wm831x_power);
+
+	power_supply_unregister(&wm831x_power->backup);
+	power_supply_unregister(&wm831x_power->battery);
+	power_supply_unregister(&wm831x_power->wall);
+	power_supply_unregister(&wm831x_power->usb);
+	return 0;
+}
+
+static struct platform_driver wm831x_power_driver = {
+	.probe = wm831x_power_probe,
+	.remove = __devexit_p(wm831x_power_remove),
+	.driver = {
+		.name = "wm831x-power",
+	},
+};
+
+static int __init wm831x_power_init(void)
+{
+	return platform_driver_register(&wm831x_power_driver);
+}
+module_init(wm831x_power_init);
+
+static void __exit wm831x_power_exit(void)
+{
+	platform_driver_unregister(&wm831x_power_driver);
+}
+module_exit(wm831x_power_exit);
+
+MODULE_DESCRIPTION("Power supply driver for WM831x PMICs");
+MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");
+MODULE_LICENSE("GPL");
+MODULE_ALIAS("platform:wm831x-power");
diff --git a/include/linux/mfd/wm831x/pmu.h b/include/linux/mfd/wm831x/pmu.h
new file mode 100644
index 0000000..b18cbb0
--- /dev/null
+++ b/include/linux/mfd/wm831x/pmu.h
@@ -0,0 +1,189 @@
+/*
+ * include/linux/mfd/wm831x/pmu.h -- PMU for WM831x
+ *
+ * Copyright 2009 Wolfson Microelectronics PLC.
+ *
+ * Author: Mark Brown <broonie@opensource.wolfsonmicro.com>
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ *
+ */
+
+#ifndef __MFD_WM831X_PMU_H__
+#define __MFD_WM831X_PMU_H__
+
+/*
+ * R16387 (0x4003) - Power State
+ */
+#define WM831X_CHIP_ON                          0x8000  /* CHIP_ON */
+#define WM831X_CHIP_ON_MASK                     0x8000  /* CHIP_ON */
+#define WM831X_CHIP_ON_SHIFT                        15  /* CHIP_ON */
+#define WM831X_CHIP_ON_WIDTH                         1  /* CHIP_ON */
+#define WM831X_CHIP_SLP                         0x4000  /* CHIP_SLP */
+#define WM831X_CHIP_SLP_MASK                    0x4000  /* CHIP_SLP */
+#define WM831X_CHIP_SLP_SHIFT                       14  /* CHIP_SLP */
+#define WM831X_CHIP_SLP_WIDTH                        1  /* CHIP_SLP */
+#define WM831X_REF_LP                           0x1000  /* REF_LP */
+#define WM831X_REF_LP_MASK                      0x1000  /* REF_LP */
+#define WM831X_REF_LP_SHIFT                         12  /* REF_LP */
+#define WM831X_REF_LP_WIDTH                          1  /* REF_LP */
+#define WM831X_PWRSTATE_DLY_MASK                0x0C00  /* PWRSTATE_DLY - [11:10] */
+#define WM831X_PWRSTATE_DLY_SHIFT                   10  /* PWRSTATE_DLY - [11:10] */
+#define WM831X_PWRSTATE_DLY_WIDTH                    2  /* PWRSTATE_DLY - [11:10] */
+#define WM831X_SWRST_DLY                        0x0200  /* SWRST_DLY */
+#define WM831X_SWRST_DLY_MASK                   0x0200  /* SWRST_DLY */
+#define WM831X_SWRST_DLY_SHIFT                       9  /* SWRST_DLY */
+#define WM831X_SWRST_DLY_WIDTH                       1  /* SWRST_DLY */
+#define WM831X_USB100MA_STARTUP_MASK            0x0030  /* USB100MA_STARTUP - [5:4] */
+#define WM831X_USB100MA_STARTUP_SHIFT                4  /* USB100MA_STARTUP - [5:4] */
+#define WM831X_USB100MA_STARTUP_WIDTH                2  /* USB100MA_STARTUP - [5:4] */
+#define WM831X_USB_CURR_STS                     0x0008  /* USB_CURR_STS */
+#define WM831X_USB_CURR_STS_MASK                0x0008  /* USB_CURR_STS */
+#define WM831X_USB_CURR_STS_SHIFT                    3  /* USB_CURR_STS */
+#define WM831X_USB_CURR_STS_WIDTH                    1  /* USB_CURR_STS */
+#define WM831X_USB_ILIM_MASK                    0x0007  /* USB_ILIM - [2:0] */
+#define WM831X_USB_ILIM_SHIFT                        0  /* USB_ILIM - [2:0] */
+#define WM831X_USB_ILIM_WIDTH                        3  /* USB_ILIM - [2:0] */
+
+/*
+ * R16397 (0x400D) - System Status
+ */
+#define WM831X_THW_STS                          0x8000  /* THW_STS */
+#define WM831X_THW_STS_MASK                     0x8000  /* THW_STS */
+#define WM831X_THW_STS_SHIFT                        15  /* THW_STS */
+#define WM831X_THW_STS_WIDTH                         1  /* THW_STS */
+#define WM831X_PWR_SRC_BATT                     0x0400  /* PWR_SRC_BATT */
+#define WM831X_PWR_SRC_BATT_MASK                0x0400  /* PWR_SRC_BATT */
+#define WM831X_PWR_SRC_BATT_SHIFT                   10  /* PWR_SRC_BATT */
+#define WM831X_PWR_SRC_BATT_WIDTH                    1  /* PWR_SRC_BATT */
+#define WM831X_PWR_WALL                         0x0200  /* PWR_WALL */
+#define WM831X_PWR_WALL_MASK                    0x0200  /* PWR_WALL */
+#define WM831X_PWR_WALL_SHIFT                        9  /* PWR_WALL */
+#define WM831X_PWR_WALL_WIDTH                        1  /* PWR_WALL */
+#define WM831X_PWR_USB                          0x0100  /* PWR_USB */
+#define WM831X_PWR_USB_MASK                     0x0100  /* PWR_USB */
+#define WM831X_PWR_USB_SHIFT                         8  /* PWR_USB */
+#define WM831X_PWR_USB_WIDTH                         1  /* PWR_USB */
+#define WM831X_MAIN_STATE_MASK                  0x001F  /* MAIN_STATE - [4:0] */
+#define WM831X_MAIN_STATE_SHIFT                      0  /* MAIN_STATE - [4:0] */
+#define WM831X_MAIN_STATE_WIDTH                      5  /* MAIN_STATE - [4:0] */
+
+/*
+ * R16456 (0x4048) - Charger Control 1
+ */
+#define WM831X_CHG_ENA                          0x8000  /* CHG_ENA */
+#define WM831X_CHG_ENA_MASK                     0x8000  /* CHG_ENA */
+#define WM831X_CHG_ENA_SHIFT                        15  /* CHG_ENA */
+#define WM831X_CHG_ENA_WIDTH                         1  /* CHG_ENA */
+#define WM831X_CHG_FRC                          0x4000  /* CHG_FRC */
+#define WM831X_CHG_FRC_MASK                     0x4000  /* CHG_FRC */
+#define WM831X_CHG_FRC_SHIFT                        14  /* CHG_FRC */
+#define WM831X_CHG_FRC_WIDTH                         1  /* CHG_FRC */
+#define WM831X_CHG_ITERM_MASK                   0x1C00  /* CHG_ITERM - [12:10] */
+#define WM831X_CHG_ITERM_SHIFT                      10  /* CHG_ITERM - [12:10] */
+#define WM831X_CHG_ITERM_WIDTH                       3  /* CHG_ITERM - [12:10] */
+#define WM831X_CHG_FAST                         0x0020  /* CHG_FAST */
+#define WM831X_CHG_FAST_MASK                    0x0020  /* CHG_FAST */
+#define WM831X_CHG_FAST_SHIFT                        5  /* CHG_FAST */
+#define WM831X_CHG_FAST_WIDTH                        1  /* CHG_FAST */
+#define WM831X_CHG_IMON_ENA                     0x0002  /* CHG_IMON_ENA */
+#define WM831X_CHG_IMON_ENA_MASK                0x0002  /* CHG_IMON_ENA */
+#define WM831X_CHG_IMON_ENA_SHIFT                    1  /* CHG_IMON_ENA */
+#define WM831X_CHG_IMON_ENA_WIDTH                    1  /* CHG_IMON_ENA */
+#define WM831X_CHG_CHIP_TEMP_MON                0x0001  /* CHG_CHIP_TEMP_MON */
+#define WM831X_CHG_CHIP_TEMP_MON_MASK           0x0001  /* CHG_CHIP_TEMP_MON */
+#define WM831X_CHG_CHIP_TEMP_MON_SHIFT               0  /* CHG_CHIP_TEMP_MON */
+#define WM831X_CHG_CHIP_TEMP_MON_WIDTH               1  /* CHG_CHIP_TEMP_MON */
+
+/*
+ * R16457 (0x4049) - Charger Control 2
+ */
+#define WM831X_CHG_OFF_MSK                      0x4000  /* CHG_OFF_MSK */
+#define WM831X_CHG_OFF_MSK_MASK                 0x4000  /* CHG_OFF_MSK */
+#define WM831X_CHG_OFF_MSK_SHIFT                    14  /* CHG_OFF_MSK */
+#define WM831X_CHG_OFF_MSK_WIDTH                     1  /* CHG_OFF_MSK */
+#define WM831X_CHG_TIME_MASK                    0x0F00  /* CHG_TIME - [11:8] */
+#define WM831X_CHG_TIME_SHIFT                        8  /* CHG_TIME - [11:8] */
+#define WM831X_CHG_TIME_WIDTH                        4  /* CHG_TIME - [11:8] */
+#define WM831X_CHG_TRKL_ILIM_MASK               0x00C0  /* CHG_TRKL_ILIM - [7:6] */
+#define WM831X_CHG_TRKL_ILIM_SHIFT                   6  /* CHG_TRKL_ILIM - [7:6] */
+#define WM831X_CHG_TRKL_ILIM_WIDTH                   2  /* CHG_TRKL_ILIM - [7:6] */
+#define WM831X_CHG_VSEL_MASK                    0x0030  /* CHG_VSEL - [5:4] */
+#define WM831X_CHG_VSEL_SHIFT                        4  /* CHG_VSEL - [5:4] */
+#define WM831X_CHG_VSEL_WIDTH                        2  /* CHG_VSEL - [5:4] */
+#define WM831X_CHG_FAST_ILIM_MASK               0x000F  /* CHG_FAST_ILIM - [3:0] */
+#define WM831X_CHG_FAST_ILIM_SHIFT                   0  /* CHG_FAST_ILIM - [3:0] */
+#define WM831X_CHG_FAST_ILIM_WIDTH                   4  /* CHG_FAST_ILIM - [3:0] */
+
+/*
+ * R16458 (0x404A) - Charger Status
+ */
+#define WM831X_BATT_OV_STS                      0x8000  /* BATT_OV_STS */
+#define WM831X_BATT_OV_STS_MASK                 0x8000  /* BATT_OV_STS */
+#define WM831X_BATT_OV_STS_SHIFT                    15  /* BATT_OV_STS */
+#define WM831X_BATT_OV_STS_WIDTH                     1  /* BATT_OV_STS */
+#define WM831X_CHG_STATE_MASK                   0x7000  /* CHG_STATE - [14:12] */
+#define WM831X_CHG_STATE_SHIFT                      12  /* CHG_STATE - [14:12] */
+#define WM831X_CHG_STATE_WIDTH                       3  /* CHG_STATE - [14:12] */
+#define WM831X_BATT_HOT_STS                     0x0800  /* BATT_HOT_STS */
+#define WM831X_BATT_HOT_STS_MASK                0x0800  /* BATT_HOT_STS */
+#define WM831X_BATT_HOT_STS_SHIFT                   11  /* BATT_HOT_STS */
+#define WM831X_BATT_HOT_STS_WIDTH                    1  /* BATT_HOT_STS */
+#define WM831X_BATT_COLD_STS                    0x0400  /* BATT_COLD_STS */
+#define WM831X_BATT_COLD_STS_MASK               0x0400  /* BATT_COLD_STS */
+#define WM831X_BATT_COLD_STS_SHIFT                  10  /* BATT_COLD_STS */
+#define WM831X_BATT_COLD_STS_WIDTH                   1  /* BATT_COLD_STS */
+#define WM831X_CHG_TOPOFF                       0x0200  /* CHG_TOPOFF */
+#define WM831X_CHG_TOPOFF_MASK                  0x0200  /* CHG_TOPOFF */
+#define WM831X_CHG_TOPOFF_SHIFT                      9  /* CHG_TOPOFF */
+#define WM831X_CHG_TOPOFF_WIDTH                      1  /* CHG_TOPOFF */
+#define WM831X_CHG_ACTIVE                       0x0100  /* CHG_ACTIVE */
+#define WM831X_CHG_ACTIVE_MASK                  0x0100  /* CHG_ACTIVE */
+#define WM831X_CHG_ACTIVE_SHIFT                      8  /* CHG_ACTIVE */
+#define WM831X_CHG_ACTIVE_WIDTH                      1  /* CHG_ACTIVE */
+#define WM831X_CHG_TIME_ELAPSED_MASK            0x00FF  /* CHG_TIME_ELAPSED - [7:0] */
+#define WM831X_CHG_TIME_ELAPSED_SHIFT                0  /* CHG_TIME_ELAPSED - [7:0] */
+#define WM831X_CHG_TIME_ELAPSED_WIDTH                8  /* CHG_TIME_ELAPSED - [7:0] */
+
+#define WM831X_CHG_STATE_OFF         (0 << WM831X_CHG_STATE_SHIFT)
+#define WM831X_CHG_STATE_TRICKLE     (1 << WM831X_CHG_STATE_SHIFT)
+#define WM831X_CHG_STATE_FAST        (2 << WM831X_CHG_STATE_SHIFT)
+#define WM831X_CHG_STATE_TRICKLE_OT  (3 << WM831X_CHG_STATE_SHIFT)
+#define WM831X_CHG_STATE_FAST_OT     (4 << WM831X_CHG_STATE_SHIFT)
+#define WM831X_CHG_STATE_DEFECTIVE   (5 << WM831X_CHG_STATE_SHIFT)
+
+/*
+ * R16459 (0x404B) - Backup Charger Control
+ */
+#define WM831X_BKUP_CHG_ENA                     0x8000  /* BKUP_CHG_ENA */
+#define WM831X_BKUP_CHG_ENA_MASK                0x8000  /* BKUP_CHG_ENA */
+#define WM831X_BKUP_CHG_ENA_SHIFT                   15  /* BKUP_CHG_ENA */
+#define WM831X_BKUP_CHG_ENA_WIDTH                    1  /* BKUP_CHG_ENA */
+#define WM831X_BKUP_CHG_STS                     0x4000  /* BKUP_CHG_STS */
+#define WM831X_BKUP_CHG_STS_MASK                0x4000  /* BKUP_CHG_STS */
+#define WM831X_BKUP_CHG_STS_SHIFT                   14  /* BKUP_CHG_STS */
+#define WM831X_BKUP_CHG_STS_WIDTH                    1  /* BKUP_CHG_STS */
+#define WM831X_BKUP_CHG_MODE                    0x1000  /* BKUP_CHG_MODE */
+#define WM831X_BKUP_CHG_MODE_MASK               0x1000  /* BKUP_CHG_MODE */
+#define WM831X_BKUP_CHG_MODE_SHIFT                  12  /* BKUP_CHG_MODE */
+#define WM831X_BKUP_CHG_MODE_WIDTH                   1  /* BKUP_CHG_MODE */
+#define WM831X_BKUP_BATT_DET_ENA                0x0800  /* BKUP_BATT_DET_ENA */
+#define WM831X_BKUP_BATT_DET_ENA_MASK           0x0800  /* BKUP_BATT_DET_ENA */
+#define WM831X_BKUP_BATT_DET_ENA_SHIFT              11  /* BKUP_BATT_DET_ENA */
+#define WM831X_BKUP_BATT_DET_ENA_WIDTH               1  /* BKUP_BATT_DET_ENA */
+#define WM831X_BKUP_BATT_STS                    0x0400  /* BKUP_BATT_STS */
+#define WM831X_BKUP_BATT_STS_MASK               0x0400  /* BKUP_BATT_STS */
+#define WM831X_BKUP_BATT_STS_SHIFT                  10  /* BKUP_BATT_STS */
+#define WM831X_BKUP_BATT_STS_WIDTH                   1  /* BKUP_BATT_STS */
+#define WM831X_BKUP_CHG_VLIM                    0x0010  /* BKUP_CHG_VLIM */
+#define WM831X_BKUP_CHG_VLIM_MASK               0x0010  /* BKUP_CHG_VLIM */
+#define WM831X_BKUP_CHG_VLIM_SHIFT                   4  /* BKUP_CHG_VLIM */
+#define WM831X_BKUP_CHG_VLIM_WIDTH                   1  /* BKUP_CHG_VLIM */
+#define WM831X_BKUP_CHG_ILIM_MASK               0x0003  /* BKUP_CHG_ILIM - [1:0] */
+#define WM831X_BKUP_CHG_ILIM_SHIFT                   0  /* BKUP_CHG_ILIM - [1:0] */
+#define WM831X_BKUP_CHG_ILIM_WIDTH                   2  /* BKUP_CHG_ILIM - [1:0] */
+
+#endif
-- 
1.6.3.3

