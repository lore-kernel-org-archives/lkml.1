Return-Path: <linux-kernel-owner+w=401wt.eu-S1755584AbYKTPXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbYKTPXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 10:23:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbYKTPXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 10:23:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41456 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754924AbYKTPXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 10:23:43 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Samuel Ortiz <sameo@openedhand.com>, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 2/2] power_supply: Add battery health reporting for WM8350
Date: Thu, 20 Nov 2008 15:23:41 +0000
Message-Id: <1227194621-16442-2-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1227194621-16442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20081120152044.GA15434@rakim.wolfsonmicro.main>
 <1227194621-16442-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement support for reporting battery health in the WM8350 battery
interface. Since we are now able to report this via the classs remove
the diagnostics from the interrupt handler.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm8350-regmap.c     |    2 +-
 drivers/power/wm8350_power.c    |   33 +++++++++++++++++++++++++--------
 include/linux/mfd/wm8350/core.h |    7 +++++++
 3 files changed, 33 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/wm8350-regmap.c b/drivers/mfd/wm8350-regmap.c
index aaf394a..b43d64c 100644
--- a/drivers/mfd/wm8350-regmap.c
+++ b/drivers/mfd/wm8350-regmap.c
@@ -1314,7 +1314,7 @@ const struct wm8350_reg_access wm8350_reg_io_map[] = {
 	{ 0xFFFF, 0xFFFF, 0xFFFF }, /* R223 */
 	{ 0x0000, 0x0000, 0x0000 }, /* R224 */
 	{ 0x8F3F, 0x0000, 0xFFFF }, /* R225 - DCDC/LDO status */
-	{ 0x0000, 0x0000, 0x0000 }, /* R226 */
+	{ 0x0000, 0x0000, 0xFFFF }, /* R226 - Charger status */
 	{ 0x0000, 0x0000, 0xFFFF }, /* R227 */
 	{ 0x0000, 0x0000, 0x0000 }, /* R228 */
 	{ 0x0000, 0x0000, 0x0000 }, /* R229 */
diff --git a/drivers/power/wm8350_power.c b/drivers/power/wm8350_power.c
index 74e7593..1b16bf3 100644
--- a/drivers/power/wm8350_power.c
+++ b/drivers/power/wm8350_power.c
@@ -190,22 +190,18 @@ static void wm8350_charger_handler(struct wm8350 *wm8350, int irq, void *data)
 	struct wm8350_charger_policy *policy = power->policy;
 
 	switch (irq) {
-	case WM8350_IRQ_CHG_BAT_HOT:
-		dev_err(wm8350->dev, "battery too hot\n");
-		break;
-	case WM8350_IRQ_CHG_BAT_COLD:
-		dev_err(wm8350->dev, "battery too cold\n");
-		break;
 	case WM8350_IRQ_CHG_BAT_FAIL:
 		dev_err(wm8350->dev, "battery failed\n");
 		break;
 	case WM8350_IRQ_CHG_TO:
 		dev_err(wm8350->dev, "charger timeout\n");
-		break;
-	case WM8350_IRQ_CHG_END:
 		power_supply_changed(&power->battery);
 		break;
+
+	case WM8350_IRQ_CHG_BAT_HOT:
+	case WM8350_IRQ_CHG_BAT_COLD:
 	case WM8350_IRQ_CHG_START:
+	case WM8350_IRQ_CHG_END:
 		power_supply_changed(&power->battery);
 		break;
 
@@ -308,6 +304,23 @@ static enum power_supply_property wm8350_usb_props[] = {
  *		Battery properties
  *********************************************************************/
 
+static int wm8350_bat_check_health(struct wm8350 *wm8350)
+{
+	u16 reg;
+
+	if (wm8350_read_battery_uvolts(wm8350) < 2850000)
+		return POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+
+	reg = wm8350_reg_read(wm8350, WM8350_CHARGER_OVERRIDES);
+	if (reg & WM8350_CHG_BATT_HOT_OVRDE)
+		return POWER_SUPPLY_HEALTH_OVERHEAT;
+
+	if (reg & WM8350_CHG_BATT_COLD_OVRDE)
+		return POWER_SUPPLY_HEALTH_COLD;
+
+	return POWER_SUPPLY_HEALTH_GOOD;
+}
+
 static int wm8350_bat_get_property(struct power_supply *psy,
 				   enum power_supply_property psp,
 				   union power_supply_propval *val)
@@ -326,6 +339,9 @@ static int wm8350_bat_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 		val->intval = wm8350_read_battery_uvolts(wm8350);
 		break;
+	case POWER_SUPPLY_PROP_HEALTH:
+		val->intval = wm8350_bat_check_health(wm8350);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -338,6 +354,7 @@ static enum power_supply_property wm8350_bat_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_ONLINE,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
+	POWER_SUPPLY_PROP_HEALTH,
 };
 
 /*********************************************************************
diff --git a/include/linux/mfd/wm8350/core.h b/include/linux/mfd/wm8350/core.h
index 0d37572..baf5530 100644
--- a/include/linux/mfd/wm8350/core.h
+++ b/include/linux/mfd/wm8350/core.h
@@ -58,6 +58,7 @@
 #define WM8350_OVER_CURRENT_INT_STATUS_MASK     0x25
 #define WM8350_GPIO_INT_STATUS_MASK             0x26
 #define WM8350_COMPARATOR_INT_STATUS_MASK       0x27
+#define WM8350_CHARGER_OVERRIDES		0xE2
 #define WM8350_MISC_OVERRIDES			0xE3
 #define WM8350_COMPARATOR_OVERRIDES		0xE7
 #define WM8350_STATE_MACHINE_STATUS		0xE9
@@ -533,6 +534,12 @@
 #define WM8350_DC1_STS                          0x0001
 
 /*
+ * R226 (0xE2) - Charger status
+ */
+#define WM8350_CHG_BATT_HOT_OVRDE		0x8000
+#define WM8350_CHG_BATT_COLD_OVRDE		0x4000
+
+/*
  * R227 (0xE3) - Misc Overrides
  */
 #define WM8350_USB_LIMIT_OVRDE			0x0400
-- 
1.5.6.5

