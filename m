Return-Path: <linux-kernel-owner+w=401wt.eu-S1758017AbZFWDqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758017AbZFWDqs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:46:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757495AbZFWDq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:46:26 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:53173 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbZFWDqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:46:25 -0400
Date: Mon, 22 Jun 2009 23:46:19 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: [PATCH 4/5] Revert "power: remove POWER_SUPPLY_PROP_CAPACITY_LEVEL"
Message-ID: <20090622234619.1463fd85@mycelium.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This reverts commit 8efe444038a205e79b38b7ad03878824901849a8.

Richard@laptop.org was apparently using CAPACITY_LEVEL for debugging
battery/EC problems, and was upset that it was removed.  This readds it.

Conflicts:

	Documentation/power_supply_class.txt

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 Documentation/power/power_supply_class.txt |    2 ++
 drivers/power/olpc_battery.c               |    9 +++++++++
 drivers/power/power_supply_sysfs.c         |    6 ++++++
 include/linux/power_supply.h               |   10 ++++++++++
 4 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index c6cd495..709d955 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -108,6 +108,8 @@ relative, time-based measurements.
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
 
 CAPACITY - capacity in percents.
+CAPACITY_LEVEL - capacity level. This corresponds to
+POWER_SUPPLY_CAPACITY_LEVEL_*.
 
 TEMP - temperature of the power supply.
 TEMP_AMBIENT - ambient temperature.
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 3ecf484..b6b680a 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -286,6 +286,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 			return ret;
 		val->intval = ec_byte;
 		break;
+	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
+		if (ec_byte & BAT_STAT_FULL)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
+		else if (ec_byte & BAT_STAT_LOW)
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_LOW;
+		else
+			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
+		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
@@ -331,6 +339,7 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_AVG,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
 	POWER_SUPPLY_PROP_CAPACITY,
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_ERROR,
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index eb1affc..fef37b2 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -52,6 +52,9 @@ static ssize_t power_supply_show_property(struct device *dev,
 		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd",
 		"LiMn"
 	};
+	static char *capacity_level_text[] = {
+		"Unknown", "Critical", "Low", "Normal", "High", "Full"
+	};
 	ssize_t ret;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	const ptrdiff_t off = attr - power_supply_attrs;
@@ -72,6 +75,9 @@ static ssize_t power_supply_show_property(struct device *dev,
 		return sprintf(buf, "%s\n", health_text[value.intval]);
 	else if (off == POWER_SUPPLY_PROP_TECHNOLOGY)
 		return sprintf(buf, "%s\n", technology_text[value.intval]);
+	else if (off == POWER_SUPPLY_PROP_CAPACITY_LEVEL)
+		return sprintf(buf, "%s\n",
+			       capacity_level_text[value.intval]);
 	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
 		return sprintf(buf, "%s\n", value.strval);
 
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 50ee079..25bd9f5 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -59,6 +59,15 @@ enum {
 	POWER_SUPPLY_TECHNOLOGY_LiMn,
 };
 
+enum {
+	POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN = 0,
+	POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL,
+	POWER_SUPPLY_CAPACITY_LEVEL_LOW,
+	POWER_SUPPLY_CAPACITY_LEVEL_NORMAL,
+	POWER_SUPPLY_CAPACITY_LEVEL_HIGH,
+	POWER_SUPPLY_CAPACITY_LEVEL_FULL,
+};
+
 enum power_supply_property {
 	/* Properties of type `int' */
 	POWER_SUPPLY_PROP_STATUS = 0,
@@ -90,6 +99,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_ENERGY_NOW,
 	POWER_SUPPLY_PROP_ENERGY_AVG,
 	POWER_SUPPLY_PROP_CAPACITY, /* in percents! */
+	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
-- 
1.5.6.5

