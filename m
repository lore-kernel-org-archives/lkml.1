Return-Path: <linux-kernel-owner+w=401wt.eu-S932826AbYD3U06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826AbYD3U06 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761380AbYD3U0q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:26:46 -0400
Received: from mail.queued.net ([207.210.101.209]:4984 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760723AbYD3U0p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:26:45 -0400
Date: Wed, 30 Apr 2008 16:30:02 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: [PATCH 1/4] power_supply: Support serial number and ACR in
 olpc_battery
Message-ID: <20080430163002.3c768ae0@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Woodhouse <dwmw2@infradead.org>

This adds serial number and accumulated current support to the OLPC
battery driver.

Signed-off-by: David Woodhouse <dwmw2@infradead.org>
Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/olpc_battery.c       |   23 ++++++++++++++++++++++-
 drivers/power/power_supply_sysfs.c |    1 +
 include/linux/power_supply.h       |    1 +
 3 files changed, 24 insertions(+), 1 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index ab1e828..9d9dd09 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -19,7 +19,7 @@
 
 #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
 #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
-#define EC_BAT_ACR	0x12
+#define EC_BAT_ACR	0x12	/* int16_t,	*416.667,    µAh  */
 #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   °C  */
 #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   °C  */
 #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
@@ -84,6 +84,8 @@ static struct power_supply olpc_ac = {
 	.get_property = olpc_ac_get_prop,
 };
 
+static char bat_serial[17]; /* Ick */
+
 /*********************************************************************
  *		Battery properties
  *********************************************************************/
@@ -94,6 +96,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 	int ret = 0;
 	int16_t ec_word;
 	uint8_t ec_byte;
+	uint64_t ser_buf;
 
 	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
 	if (ret)
@@ -241,6 +244,22 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		ec_word = be16_to_cpu(ec_word);
 		val->intval = ec_word * 100 / 256;
 		break;
+	case POWER_SUPPLY_PROP_ACCUM_CURRENT:
+		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
+		if (ret)
+			return ret;
+
+		ec_word = be16_to_cpu(ec_word);
+		val->intval = ec_word;
+		break;
+	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
+		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
+		if (ret)
+			return ret;
+
+		sprintf(bat_serial, "%016llx", (long long)be64_to_cpu(ser_buf));
+		val->strval = bat_serial;
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -259,7 +278,9 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
+	POWER_SUPPLY_PROP_ACCUM_CURRENT,
 	POWER_SUPPLY_PROP_MANUFACTURER,
+	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 };
 
 /*********************************************************************
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index c444d6b..756d4e1 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -112,6 +112,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_empty_avg),
 	POWER_SUPPLY_ATTR(time_to_full_now),
 	POWER_SUPPLY_ATTR(time_to_full_avg),
+	POWER_SUPPLY_ATTR(accum_current),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 68ed19c..a699ad2 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -91,6 +91,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
+	POWER_SUPPLY_PROP_ACCUM_CURRENT,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
-- 
1.5.5

