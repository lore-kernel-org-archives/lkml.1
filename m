Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968493Ab0B0PGk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 10:06:40 -0500
Received: from mail-ew0-f220.google.com ([209.85.219.220]:55764 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968483Ab0B0PGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 10:06:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IrPRGzkGzOMC14X02Dr2vNmPjliDlh1v4ii2lrN74rFCW6DEYssb4T7dIHwKFdf56V
         SwvP+GmUmIClMgGyuMWmB/KiVJ/hIIbk9GA0pIPmF5O52LYiVGhGBMenb4JqqO30MeWn
         rTkDf7y6HdtzM3Me2rOFpynEn5FhK9CaoGAss=
From: Grazvydas Ignotas <notasas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Anton Vorontsov <cbouatmailru@gmail.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>,
       Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 1/2] power_supply: bq27x00: add status and time properties
Date: Sat, 27 Feb 2010 17:06:09 +0200
Message-Id: <1267283169-19154-1-git-send-email-notasas@gmail.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BQ27x00 series of chips can report time-to-empty and
time-to-full, so let's add corresponding properties.
Also report charge status based on status flag register.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/power/bq27x00_battery.c |   81 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 79 insertions(+), 2 deletions(-)

diff --git a/drivers/power/bq27x00_battery.c b/drivers/power/bq27x00_battery.c
index 1526d02..5d940fa 100644
--- a/drivers/power/bq27x00_battery.c
+++ b/drivers/power/bq27x00_battery.c
@@ -32,10 +32,16 @@
 #define BQ27x00_REG_VOLT		0x08
 #define BQ27x00_REG_AI			0x14
 #define BQ27x00_REG_FLAGS		0x0A
+#define BQ27x00_REG_TTE			0x16
+#define BQ27x00_REG_TTF			0x18
+#define BQ27x00_REG_TTECP		0x26
 
 #define BQ27000_REG_RSOC		0x0B /* Relative State-of-Charge */
+#define BQ27000_FLAG_CHGS		BIT(7)
 
 #define BQ27500_REG_SOC			0x2c
+#define BQ27500_FLAG_DSC		BIT(0)
+#define BQ27500_FLAG_FC			BIT(9)
 
 /* If the system has several batteries we need a different name for each
  * of them...
@@ -62,11 +68,15 @@ struct bq27x00_device_info {
 };
 
 static enum power_supply_property bq27x00_battery_props[] = {
+	POWER_SUPPLY_PROP_STATUS,
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_VOLTAGE_NOW,
 	POWER_SUPPLY_PROP_CURRENT_NOW,
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_TEMP,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
+	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
+	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 };
 
 /*
@@ -144,7 +154,7 @@ static int bq27x00_battery_current(struct bq27x00_device_info *di)
 			dev_err(di->dev, "error reading flags\n");
 			return 0;
 		}
-		if ((flags & (1 << 7)) != 0) {
+		if (flags & BQ27000_FLAG_CHGS) {
 			dev_dbg(di->dev, "negative current!\n");
 			return -curr;
 		}
@@ -174,6 +184,60 @@ static int bq27x00_battery_rsoc(struct bq27x00_device_info *di)
 	return rsoc;
 }
 
+static int bq27x00_battery_status(struct bq27x00_device_info *di,
+				  union power_supply_propval *val)
+{
+	int flags = 0;
+	int status;
+	int ret;
+
+	ret = bq27x00_read(BQ27x00_REG_FLAGS, &flags, 0, di);
+	if (ret < 0) {
+		dev_err(di->dev, "error reading flags\n");
+		return ret;
+	}
+
+	if (di->chip == BQ27500) {
+		if (flags & BQ27500_FLAG_FC)
+			status = POWER_SUPPLY_STATUS_FULL;
+		else if (flags & BQ27500_FLAG_DSC)
+			status = POWER_SUPPLY_STATUS_DISCHARGING;
+		else
+			status = POWER_SUPPLY_STATUS_CHARGING;
+	} else {
+		if (flags & BQ27000_FLAG_CHGS)
+			status = POWER_SUPPLY_STATUS_CHARGING;
+		else
+			status = POWER_SUPPLY_STATUS_DISCHARGING;
+	}
+
+	val->intval = status;
+	return 0;
+}
+
+/*
+ * Read a time register.
+ * Return < 0 if something fails.
+ */
+static int bq27x00_battery_time(struct bq27x00_device_info *di, int reg,
+				union power_supply_propval *val)
+{
+	int tval = 0;
+	int ret;
+
+	ret = bq27x00_read(reg, &tval, 0, di);
+	if (ret) {
+		dev_err(di->dev, "error reading register %02x\n", reg);
+		return ret;
+	}
+
+	if (tval == 65535)
+		return -ENODATA;
+
+	val->intval = tval * 60;
+	return 0;
+}
+
 #define to_bq27x00_device_info(x) container_of((x), \
 				struct bq27x00_device_info, bat);
 
@@ -181,9 +245,13 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 					enum power_supply_property psp,
 					union power_supply_propval *val)
 {
+	int ret = 0;
 	struct bq27x00_device_info *di = to_bq27x00_device_info(psy);
 
 	switch (psp) {
+	case POWER_SUPPLY_PROP_STATUS:
+		ret = bq27x00_battery_status(di, val);
+		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_NOW:
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = bq27x00_battery_voltage(di);
@@ -199,11 +267,20 @@ static int bq27x00_battery_get_property(struct power_supply *psy,
 	case POWER_SUPPLY_PROP_TEMP:
 		val->intval = bq27x00_battery_temperature(di);
 		break;
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW:
+		ret = bq27x00_battery_time(di, BQ27x00_REG_TTE, val);
+		break;
+	case POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG:
+		ret = bq27x00_battery_time(di, BQ27x00_REG_TTECP, val);
+		break;
+	case POWER_SUPPLY_PROP_TIME_TO_FULL_NOW:
+		ret = bq27x00_battery_time(di, BQ27x00_REG_TTF, val);
+		break;
 	default:
 		return -EINVAL;
 	}
 
-	return 0;
+	return ret;
 }
 
 static void bq27x00_powersupply_init(struct bq27x00_device_info *di)
-- 
1.6.3.3

