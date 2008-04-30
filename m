Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbYD3U1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbYD3U1o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932891AbYD3U1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:27:07 -0400
Received: from mail.queued.net ([207.210.101.209]:4994 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932880AbYD3U1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:27:06 -0400
Date: Wed, 30 Apr 2008 16:30:19 -0400
From: Andres Salomon <dilinger@queued.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: cbou@mail.ru, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH 3/4] power_supply: cleanup of the OLPC battery driver
Message-ID: <20080430163019.7d702ffc@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Move portions of the massive switch statement into functions.  The
layout of this thing has already caused one bug (a break in the wrong
place), it needed to shrink.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/olpc_battery.c |  191 ++++++++++++++++++++++++++----------------
 1 files changed, 118 insertions(+), 73 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index e5ecf27..cb45a67 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -86,6 +86,117 @@ static struct power_supply olpc_ac = {
 
 static char bat_serial[17]; /* Ick */
 
+static int olpc_bat_get_status(union power_supply_propval *val, uint8_t ec_byte)
+{
+	if (olpc_platform_info.ecver > 0x44) {
+		if (ec_byte & BAT_STAT_CHARGING)
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+		else if (ec_byte & BAT_STAT_DISCHARGING)
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (ec_byte & BAT_STAT_FULL)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else /* er,... */
+			val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	} else {
+		/* Older EC didn't report charge/discharge bits */
+		if (!(ec_byte & BAT_STAT_AC)) /* No AC means discharging */
+			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (ec_byte & BAT_STAT_FULL)
+			val->intval = POWER_SUPPLY_STATUS_FULL;
+		else /* Not _necessarily_ true but EC doesn't tell all yet */
+			val->intval = POWER_SUPPLY_STATUS_CHARGING;
+	}
+
+	return 0;
+}
+
+static int olpc_bat_get_health(union power_supply_propval *val)
+{
+	uint8_t ec_byte;
+	int ret;
+
+	ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	switch (ec_byte) {
+	case 0:
+		val->intval = POWER_SUPPLY_HEALTH_GOOD;
+		break;
+
+	case BAT_ERR_OVERTEMP:
+		val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+		break;
+
+	case BAT_ERR_OVERVOLTAGE:
+		val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
+		break;
+
+	case BAT_ERR_INFOFAIL:
+	case BAT_ERR_OUT_OF_CONTROL:
+	case BAT_ERR_ID_FAIL:
+	case BAT_ERR_ACR_FAIL:
+		val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+		break;
+
+	default:
+		/* Eep. We don't know this failure code */
+		ret = -EIO;
+	}
+
+	return ret;
+}
+
+static int olpc_bat_get_mfr(union power_supply_propval *val)
+{
+	uint8_t ec_byte;
+	int ret;
+
+	ec_byte = BAT_ADDR_MFR_TYPE;
+	ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	switch (ec_byte >> 4) {
+	case 1:
+		val->strval = "Gold Peak";
+		break;
+	case 2:
+		val->strval = "BYD";
+		break;
+	default:
+		val->strval = "Unknown";
+		break;
+	}
+
+	return ret;
+}
+
+static int olpc_bat_get_tech(union power_supply_propval *val)
+{
+	uint8_t ec_byte;
+	int ret;
+
+	ec_byte = BAT_ADDR_MFR_TYPE;
+	ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	switch (ec_byte & 0xf) {
+	case 1:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_NiMH;
+		break;
+	case 2:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_LiFe;
+		break;
+	default:
+		val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
+		break;
+	}
+
+	return ret;
+}
+
 /*********************************************************************
  *		Battery properties
  *********************************************************************/
@@ -113,25 +224,10 @@ static int olpc_bat_get_property(struct power_supply *psy,
 
 	switch (psp) {
 	case POWER_SUPPLY_PROP_STATUS:
-		if (olpc_platform_info.ecver > 0x44) {
-			if (ec_byte & BAT_STAT_CHARGING)
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
-			else if (ec_byte & BAT_STAT_DISCHARGING)
-				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
-			else if (ec_byte & BAT_STAT_FULL)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
-			else /* er,... */
-				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
-		} else {
-			/* Older EC didn't report charge/discharge bits */
-			if (!(ec_byte & BAT_STAT_AC)) /* No AC means discharging */
-				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
-			else if (ec_byte & BAT_STAT_FULL)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
-			else /* Not _necessarily_ true but EC doesn't tell all yet */
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
-			break;
-		}
+		ret = olpc_bat_get_status(val, ec_byte);
+		if (ret)
+			return ret;
+		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = !!(ec_byte & BAT_STAT_PRESENT);
 		break;
@@ -140,72 +236,21 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ec_byte & BAT_STAT_DESTROY)
 			val->intval = POWER_SUPPLY_HEALTH_DEAD;
 		else {
-			ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
+			ret = olpc_bat_get_health(val);
 			if (ret)
 				return ret;
-
-			switch (ec_byte) {
-			case 0:
-				val->intval = POWER_SUPPLY_HEALTH_GOOD;
-				break;
-
-			case BAT_ERR_OVERTEMP:
-				val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
-				break;
-
-			case BAT_ERR_OVERVOLTAGE:
-				val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
-				break;
-
-			case BAT_ERR_INFOFAIL:
-			case BAT_ERR_OUT_OF_CONTROL:
-			case BAT_ERR_ID_FAIL:
-			case BAT_ERR_ACR_FAIL:
-				val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
-				break;
-
-			default:
-				/* Eep. We don't know this failure code */
-				return -EIO;
-			}
 		}
 		break;
 
 	case POWER_SUPPLY_PROP_MANUFACTURER:
-		ec_byte = BAT_ADDR_MFR_TYPE;
-		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+		ret = olpc_bat_get_mfr(val);
 		if (ret)
 			return ret;
-
-		switch (ec_byte >> 4) {
-		case 1:
-			val->strval = "Gold Peak";
-			break;
-		case 2:
-			val->strval = "BYD";
-			break;
-		default:
-			val->strval = "Unknown";
-			break;
-		}
 		break;
 	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		ec_byte = BAT_ADDR_MFR_TYPE;
-		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+		ret = olpc_bat_get_tech(val);
 		if (ret)
 			return ret;
-
-		switch (ec_byte & 0xf) {
-		case 1:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_NiMH;
-			break;
-		case 2:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_LiFe;
-			break;
-		default:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-			break;
-		}
 		break;
 	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
 		ret = olpc_ec_cmd(EC_BAT_VOLTAGE, NULL, 0, (void *)&ec_word, 2);
-- 
1.5.5

