Return-Path: <linux-kernel-owner+w=401wt.eu-S935256AbXLQC3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935256AbXLQC3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756720AbXLQC31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:29:27 -0500
Received: from mail.queued.net ([207.210.101.209]:4533 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbXLQC31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:29:27 -0500
Date: Sun, 16 Dec 2007 21:29:24 -0500
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
       cbou@mail.ru
Subject: [PATCH 3/5] power: convert olpc_battery to new API
Message-ID: <20071216212924.68e76899@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/olpc_battery.c |  413 +++++++++++++++++++++++++----------------
 1 files changed, 252 insertions(+), 161 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index af7a231..419aca2 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -50,216 +50,309 @@
  *		Power
  *********************************************************************/
 
-static int olpc_ac_get_prop(struct power_supply *psy,
-			    enum power_supply_property psp,
-			    union power_supply_propval *val)
+static ssize_t olpc_ac_is_online(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
-	int ret = 0;
+	int ret;
 	uint8_t status;
 
-	switch (psp) {
-	case POWER_SUPPLY_PROP_ONLINE:
-		ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &status, 1);
-		if (ret)
-			return ret;
-
-		val->intval = !!(status & BAT_STAT_AC);
-		break;
-	default:
-		ret = -EINVAL;
-		break;
-	}
+	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &status, 1);
+	if (!ret)
+		sprintf(buf, "%d\n", !!(status & BAT_STAT_AC));
 	return ret;
 }
 
-static enum power_supply_property olpc_ac_props[] = {
-	POWER_SUPPLY_PROP_ONLINE,
+static struct device_attribute olpc_ac_props[] = {
+	POWER_SUPPLY_ONLINE(olpc_ac_is_online),
+	POWER_SUPPLY_END
 };
 
 static struct power_supply olpc_ac = {
 	.name = "olpc-ac",
 	.type = POWER_SUPPLY_TYPE_MAINS,
-	.properties = olpc_ac_props,
-	.num_properties = ARRAY_SIZE(olpc_ac_props),
-	.get_property = olpc_ac_get_prop,
+	.props = (struct device_attribute **) &olpc_ac_props,
 };
 
 /*********************************************************************
  *		Battery properties
  *********************************************************************/
-static int olpc_bat_get_property(struct power_supply *psy,
-				 enum power_supply_property psp,
-				 union power_supply_propval *val)
+static ssize_t olpc_bat_get_status(uint8_t *status)
 {
-	int ret = 0;
-	int16_t ec_word;
-	uint8_t ec_byte;
+	int ret;
 
-	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
+	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, status, 1);
 	if (ret)
 		return ret;
 
+	if (!(*status & BAT_STAT_PRESENT))
+		ret = -ENODEV;
+
 	/* Theoretically there's a race here -- the battery could be
 	   removed immediately after we check whether it's present, and
 	   then we query for some other property of the now-absent battery.
 	   It doesn't matter though -- the EC will return the last-known
 	   information, and it's as if we just ran that _little_ bit faster
 	   and managed to read it out before the battery went away. */
-	if (!(ec_byte & BAT_STAT_PRESENT) && psp != POWER_SUPPLY_PROP_PRESENT)
-		return -ENODEV;
-
-	switch (psp) {
-	case POWER_SUPPLY_PROP_STATUS:
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
-	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = !!(ec_byte & BAT_STAT_PRESENT);
-		break;
 
-	case POWER_SUPPLY_PROP_HEALTH:
-		if (ec_byte & BAT_STAT_DESTROY)
-			val->intval = POWER_SUPPLY_HEALTH_DEAD;
-		else {
-			ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
-			if (ret)
-				return ret;
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
-		}
-		break;
+	return ret;
+}
 
-	case POWER_SUPPLY_PROP_MANUFACTURER:
-		ec_byte = BAT_ADDR_MFR_TYPE;
-		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+static ssize_t olpc_bat_status(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	ssize_t ret;
+	uint8_t ec_byte;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	if (olpc_platform_info.ecver > 0x44) {
+		if (ec_byte & BAT_STAT_CHARGING)
+			ret = POWER_SUPPLY_STATUS_CHARGING;
+		else if (ec_byte & BAT_STAT_DISCHARGING)
+			ret = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (ec_byte & BAT_STAT_FULL)
+			ret = POWER_SUPPLY_STATUS_FULL;
+		else /* er,... */
+			ret = POWER_SUPPLY_STATUS_NOT_CHARGING;
+	} else {
+		/* Older EC didn't report charge/discharge bits */
+		if (!(ec_byte & BAT_STAT_AC)) /* No AC means discharging */
+			ret = POWER_SUPPLY_STATUS_DISCHARGING;
+		else if (ec_byte & BAT_STAT_FULL)
+			ret = POWER_SUPPLY_STATUS_FULL;
+		else /* Not _necessarily_ true but EC doesn't tell all yet */
+			ret = POWER_SUPPLY_STATUS_CHARGING;
+	}
+
+	return power_supply_status_str(ret, buf);
+}
+
+static ssize_t olpc_bat_present(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	ssize_t ret;
+	uint8_t ec_byte;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret && ret != -ENODEV)
+		return ret;
+
+	return sprintf(buf, "%d\n", !!(ec_byte & BAT_STAT_PRESENT));
+}
+
+static ssize_t olpc_bat_health(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	ssize_t ret;
+	uint8_t ec_byte;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	if (ec_byte & BAT_STAT_DESTROY)
+		ret = POWER_SUPPLY_HEALTH_DEAD;
+	else {
+		ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
 		if (ret)
 			return ret;
 
-		switch (ec_byte >> 4) {
-		case 1:
-			val->strval = "Gold Peak";
+		switch (ec_byte) {
+		case 0:
+			ret = POWER_SUPPLY_HEALTH_GOOD;
 			break;
-		case 2:
-			val->strval = "BYD";
-			break;
-		default:
-			val->strval = "Unknown";
+
+		case BAT_ERR_OVERTEMP:
+			ret = POWER_SUPPLY_HEALTH_OVERHEAT;
 			break;
-		}
-		break;
-	case POWER_SUPPLY_PROP_TECHNOLOGY:
-		ec_byte = BAT_ADDR_MFR_TYPE;
-		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
-		if (ret)
-			return ret;
 
-		switch (ec_byte & 0xf) {
-		case 1:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_NiMH;
+		case BAT_ERR_OVERVOLTAGE:
+			ret = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 			break;
-		case 2:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_LiFe;
+
+		case BAT_ERR_INFOFAIL:
+		case BAT_ERR_OUT_OF_CONTROL:
+		case BAT_ERR_ID_FAIL:
+		case BAT_ERR_ACR_FAIL:
+			ret = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
 			break;
+
 		default:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
-			break;
+			/* Eep. We don't know this failure code */
+			return -EIO;
 		}
-		break;
-	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
-		ret = olpc_ec_cmd(EC_BAT_VOLTAGE, NULL, 0, (void *)&ec_word, 2);
-		if (ret)
-			return ret;
+	}
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 9760L / 32;
-		break;
-	case POWER_SUPPLY_PROP_CURRENT_AVG:
-		ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *)&ec_word, 2);
-		if (ret)
-			return ret;
+	return power_supply_health_str(ret, buf);
+}
+
+static ssize_t olpc_bat_manufacturer(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t ec_byte;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	ec_byte = BAT_ADDR_MFR_TYPE;
+	ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+	if (ret)
+		return ret;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 15625L / 120;
+	switch (ec_byte >> 4) {
+	case 1:
+		strcpy(buf, "Gold Peak");
 		break;
-	case POWER_SUPPLY_PROP_CAPACITY:
-		ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
-		if (ret)
-			return ret;
-		val->intval = ec_byte;
+	case 2:
+		strcpy(buf, "BYD");
 		break;
-	case POWER_SUPPLY_PROP_TEMP:
-		ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *)&ec_word, 2);
-		if (ret)
-			return ret;
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+	default:
+		strcpy(buf, "Unknown");
 		break;
-	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
-		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
-		if (ret)
-			return ret;
+	}
+
+	return ret;
+}
+
+static ssize_t olpc_bat_technology(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t ec_byte;
 
-		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	ec_byte = BAT_ADDR_MFR_TYPE;
+	ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	switch (ec_byte & 0xf) {
+	case 1:
+		ret = POWER_SUPPLY_TECHNOLOGY_NiMH;
+		break;
+	case 2:
+		ret = POWER_SUPPLY_TECHNOLOGY_LiFe;
 		break;
 	default:
-		ret = -EINVAL;
+		ret = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
 		break;
 	}
 
-	return ret;
+	return power_supply_technology_str(ret, buf);
+}
+
+static ssize_t olpc_bat_voltage_avg(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t ec_byte;
+	uint16_t ec_word;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	ret = olpc_ec_cmd(EC_BAT_VOLTAGE, NULL, 0, (void *) &ec_word, 2);
+	if (ret)
+		return ret;
+
+	ec_word = be16_to_cpu(ec_word);
+	return sprintf(buf, "%d\n", ec_word * 9760L / 32);
+}
+
+static ssize_t olpc_bat_current_avg(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t ec_byte;
+	uint16_t ec_word;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *) &ec_word, 2);
+	if (ret)
+		return ret;
+
+	ec_word = be16_to_cpu(ec_word);
+	return sprintf(buf, "%d\n", ec_word * 15625L / 120);
+}
+
+static ssize_t olpc_bat_capacity(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t ec_byte;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
+	if (ret)
+		return ret;
+
+	return sprintf(buf, "%d\n", ec_byte);
+}
+
+static ssize_t olpc_bat_temp(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t ec_byte;
+	uint16_t ec_word;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *) &ec_word, 2);
+	if (ret)
+		return ret;
+
+	ec_word = be16_to_cpu(ec_word);
+	return sprintf(buf, "%d\n", ec_word * 100 / 256);
+}
+
+static ssize_t olpc_bat_temp_ambient(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	int ret;
+	uint8_t ec_byte;
+	uint16_t ec_word;
+
+	ret = olpc_bat_get_status(&ec_byte);
+	if (ret)
+		return ret;
+
+	ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
+	if (ret)
+		return ret;
+
+	ec_word = be16_to_cpu(ec_word);
+	return sprintf(buf, "%d\n", ec_word * 100 / 256);
 }
 
-static enum power_supply_property olpc_bat_props[] = {
-	POWER_SUPPLY_PROP_STATUS,
-	POWER_SUPPLY_PROP_PRESENT,
-	POWER_SUPPLY_PROP_HEALTH,
-	POWER_SUPPLY_PROP_TECHNOLOGY,
-	POWER_SUPPLY_PROP_VOLTAGE_AVG,
-	POWER_SUPPLY_PROP_CURRENT_AVG,
-	POWER_SUPPLY_PROP_CAPACITY,
-	POWER_SUPPLY_PROP_TEMP,
-	POWER_SUPPLY_PROP_TEMP_AMBIENT,
-	POWER_SUPPLY_PROP_MANUFACTURER,
+static struct device_attribute olpc_bat_props[] = {
+	POWER_SUPPLY_STATUS(olpc_bat_status),
+	POWER_SUPPLY_PRESENT(olpc_bat_present),
+	POWER_SUPPLY_HEALTH(olpc_bat_health),
+	POWER_SUPPLY_TECHNOLOGY(olpc_bat_technology),
+	POWER_SUPPLY_VOLT_AVG(olpc_bat_voltage_avg),
+	POWER_SUPPLY_CURR_AVG(olpc_bat_current_avg),
+	POWER_SUPPLY_CAPACITY(olpc_bat_capacity),
+	POWER_SUPPLY_TEMP(olpc_bat_temp),
+	POWER_SUPPLY_TEMP_AMB(olpc_bat_temp_ambient),
+	POWER_SUPPLY_MFR(olpc_bat_manufacturer),
+	POWER_SUPPLY_END
 };
 
 /*********************************************************************
@@ -269,9 +362,7 @@ static enum power_supply_property olpc_bat_props[] = {
 static struct platform_device *bat_pdev;
 
 static struct power_supply olpc_bat = {
-	.properties = olpc_bat_props,
-	.num_properties = ARRAY_SIZE(olpc_bat_props),
-	.get_property = olpc_bat_get_property,
+	.props = (struct device_attribute **) &olpc_bat_props,
 	.use_for_apm = 1,
 };
 
-- 
1.5.3.5

