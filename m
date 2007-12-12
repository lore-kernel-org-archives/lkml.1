Return-Path: <linux-kernel-owner+w=401wt.eu-S1760371AbXLLTYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760371AbXLLTYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 14:24:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756975AbXLLTYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 14:24:04 -0500
Received: from mail.queued.net ([207.210.101.209]:1049 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbXLLTYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 14:24:03 -0500
X-Greylist: delayed 663 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Dec 2007 14:24:03 EST
Date: Wed, 12 Dec 2007 14:12:56 -0500
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
       cbou@mail.ru
Subject: [PATCH 1/2] power: remove POWER_SUPPLY_PROP_CAPACITY_LEVEL
Message-ID: <20071212141256.6c290271@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The CAPACITY_LEVEL stuff defines various levels of charge; however, what
is the difference between them?  What differentiates between HIGH and NORMAL,
LOW and CRITICAL, etc?

As it appears that these are fairly arbitrary, we end up making such policy
decisions in the kernel (or in hardware).  This is the sort of decision that
should be made in userspace, not in the kernel.

If the hardware does not support _CAPACITY and it cannot be easily calculated,
then perhaps the driver should register a custom CAPACITY_LEVEL attribute;
however, userspace should not become accustomed to looking for such a thing,
and we should certainly not encourage drivers to provide CAPACITY_LEVEL
stubs.

The following removes support for POWER_SUPPLY_PROP_CAPACITY_LEVEL.  The
OLPC battery driver is the only driver making use of this, so it's
removed from there as well.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 Documentation/power_supply_class.txt |    2 --
 drivers/power/olpc_battery.c         |    9 ---------
 drivers/power/power_supply_sysfs.c   |    6 ------
 include/linux/power_supply.h         |   10 ----------
 4 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/Documentation/power_supply_class.txt b/Documentation/power_supply_class.txt
index 9758cf4..a032c31 100644
--- a/Documentation/power_supply_class.txt
+++ b/Documentation/power_supply_class.txt
@@ -100,8 +100,6 @@ age)". I.e. these attributes represents real thresholds, not design values.
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
 
 CAPACITY - capacity in percents.
-CAPACITY_LEVEL - capacity level. This corresponds to
-POWER_SUPPLY_CAPACITY_LEVEL_*.
 
 TEMP - temperature of the power supply.
 TEMP_AMBIENT - ambient temperature.
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index c998e68..af7a231 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -226,14 +226,6 @@ static int olpc_bat_get_property(struct power_supply *psy,
 			return ret;
 		val->intval = ec_byte;
 		break;
-	case POWER_SUPPLY_PROP_CAPACITY_LEVEL:
-		if (ec_byte & BAT_STAT_FULL)
-			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_FULL;
-		else if (ec_byte & BAT_STAT_LOW)
-			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_LOW;
-		else
-			val->intval = POWER_SUPPLY_CAPACITY_LEVEL_NORMAL;
-		break;
 	case POWER_SUPPLY_PROP_TEMP:
 		ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
@@ -265,7 +257,6 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_VOLTAGE_AVG,
 	POWER_SUPPLY_PROP_CURRENT_AVG,
 	POWER_SUPPLY_PROP_CAPACITY,
-	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_MANUFACTURER,
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 249f61b..0331e82 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -48,9 +48,6 @@ static ssize_t power_supply_show_property(struct device *dev,
 	static char *technology_text[] = {
 		"Unknown", "NiMH", "Li-ion", "Li-poly", "LiFe", "NiCd"
 	};
-	static char *capacity_level_text[] = {
-		"Unknown", "Critical", "Low", "Normal", "High", "Full"
-	};
 	ssize_t ret;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	const ptrdiff_t off = attr - power_supply_attrs;
@@ -71,9 +68,6 @@ static ssize_t power_supply_show_property(struct device *dev,
 		return sprintf(buf, "%s\n", health_text[value.intval]);
 	else if (off == POWER_SUPPLY_PROP_TECHNOLOGY)
 		return sprintf(buf, "%s\n", technology_text[value.intval]);
-	else if (off == POWER_SUPPLY_PROP_CAPACITY_LEVEL)
-		return sprintf(buf, "%s\n",
-			       capacity_level_text[value.intval]);
 	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
 		return sprintf(buf, "%s\n", value.strval);
 
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 606c095..358b38d 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -56,15 +56,6 @@ enum {
 	POWER_SUPPLY_TECHNOLOGY_NiCd,
 };
 
-enum {
-	POWER_SUPPLY_CAPACITY_LEVEL_UNKNOWN = 0,
-	POWER_SUPPLY_CAPACITY_LEVEL_CRITICAL,
-	POWER_SUPPLY_CAPACITY_LEVEL_LOW,
-	POWER_SUPPLY_CAPACITY_LEVEL_NORMAL,
-	POWER_SUPPLY_CAPACITY_LEVEL_HIGH,
-	POWER_SUPPLY_CAPACITY_LEVEL_FULL,
-};
-
 enum power_supply_property {
 	/* Properties of type `int' */
 	POWER_SUPPLY_PROP_STATUS = 0,
@@ -91,7 +82,6 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_ENERGY_NOW,
 	POWER_SUPPLY_PROP_ENERGY_AVG,
 	POWER_SUPPLY_PROP_CAPACITY, /* in percents! */
-	POWER_SUPPLY_PROP_CAPACITY_LEVEL,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_NOW,
-- 
1.5.3.5

