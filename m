Return-Path: <linux-kernel-owner+w=401wt.eu-S935348AbXLRHKW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935348AbXLRHKW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 02:10:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbXLRHKF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 02:10:05 -0500
Received: from mail.queued.net ([207.210.101.209]:1962 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbXLRHKC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 02:10:02 -0500
Date: Tue, 18 Dec 2007 02:10:01 -0500
From: Andres Salomon <dilinger@queued.net>
To: cbou@mail.ru
Cc: cbouatmailru@gmail.com, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071218021001.46783004@ephemeral>
In-Reply-To: <20071217112416.GA25948@localhost.localdomain>
References: <20071216212443.4a1fff3d@ephemeral>
	<1197858984.3798.201.camel@shinybook.infradead.org>
	<20071217055123.GA2274@zarina>
	<20071217024139.2f81e36d@ephemeral>
	<20071217112416.GA25948@localhost.localdomain>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 14:24:16 +0300
Anton Vorontsov <cbou@mail.ru> wrote:

> On Mon, Dec 17, 2007 at 02:41:39AM -0500, Andres Salomon wrote:
> [...]
> > > > On Sun, 2007-12-16 at 21:24 -0500, Andres Salomon wrote:
> > > > > This API has the power_supply drivers device their own device_attribute
> > > > > list; I find this to be a lot more flexible and cleaner.  
> > > 
> > > I don't see how this is more flexible and cleaner. See below.
> > > 
> > > > > For example,
> > > > > rather than having a function with a huge switch statement (as olpc_battery
> > > > > currently has), we have separate callback functions.
> > > 
> > > Is this an improvement? Look into ds2760_battery.c. I scared to
> > > imagine what it will look like after conversion.
> > 
[...]
> 
> I see your point now. Basically, now I'm encourage to think just one
> more time: is there third (better) option in addition to current and
> this? I still hope there is some not obvious, but elegant solution.
> If there isn't, I'm ready to surrender and will help with everything
> I can.
> 

Hm.  It occurs to me that there's nothing keeping us from having a
single callback for the driver properties.  Keeping the other patches
the same, do you prefer the following approach versus what was originally
in patch#3?




diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index af7a231..1c63dcb 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -50,50 +50,71 @@
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
+
+enum olpc_props {
+	/* should retain the same order as olpc_bat_props */
+	OLPC_PROP_STATUS = 0,
+	OLPC_PROP_PRESENT,
+	OLPC_PROP_HEALTH,
+	OLPC_PROP_TECHNOLOGY,
+	OLPC_PROP_VOLTAGE_AVG,
+	OLPC_PROP_CURRENT_AVG,
+	OLPC_PROP_CAPACITY,
+	OLPC_PROP_TEMP,
+	OLPC_PROP_TEMP_AMBIENT,
+	OLPC_PROP_MANUFACTURER,
+}
+
+static int olpc_bat_get_property(struct device *dev,
+		struct device_attribute *attr, char *buf);
+
+static struct device_attribute olpc_bat_props[] = {
+	POWER_SUPPLY_STATUS(olpc_bat_get_property),
+	POWER_SUPPLY_PRESENT(olpc_bat_get_property),
+	POWER_SUPPLY_HEALTH(olpc_bat_get_property),
+	POWER_SUPPLY_TECHNOLOGY(olpc_bat_get_property),
+	POWER_SUPPLY_VOLT_AVG(olpc_bat_get_property),
+	POWER_SUPPLY_CURR_AVG(olpc_bat_get_property),
+	POWER_SUPPLY_CAPACITY(olpc_bat_get_property),
+	POWER_SUPPLY_TEMP(olpc_bat_get_property),
+	POWER_SUPPLY_TEMP_AMB(olpc_bat_get_property),
+	POWER_SUPPLY_MFR(olpc_bat_get_property),
+	POWER_SUPPLY_END
+};
+
+static int olpc_bat_get_property(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
 	int ret = 0;
 	int16_t ec_word;
 	uint8_t ec_byte;
+	ptrdiff_t prop = attr - olpc_bat_props;
 
 	ret = olpc_ec_cmd(EC_BAT_STATUS, NULL, 0, &ec_byte, 1);
 	if (ret)
@@ -105,37 +126,38 @@ static int olpc_bat_get_property(struct power_supply *psy,
 	   It doesn't matter though -- the EC will return the last-known
 	   information, and it's as if we just ran that _little_ bit faster
 	   and managed to read it out before the battery went away. */
-	if (!(ec_byte & BAT_STAT_PRESENT) && psp != POWER_SUPPLY_PROP_PRESENT)
+	if (!(ec_byte & BAT_STAT_PRESENT) && prop != OLPC_PROP_PRESENT)
 		return -ENODEV;
 
-	switch (psp) {
-	case POWER_SUPPLY_PROP_STATUS:
+	switch (prop) {
+	case OLPC_PROP_STATUS:
 		if (olpc_platform_info.ecver > 0x44) {
 			if (ec_byte & BAT_STAT_CHARGING)
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
+				ret = POWER_SUPPLY_STATUS_CHARGING;
 			else if (ec_byte & BAT_STAT_DISCHARGING)
-				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+				ret = POWER_SUPPLY_STATUS_DISCHARGING;
 			else if (ec_byte & BAT_STAT_FULL)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
+				ret = POWER_SUPPLY_STATUS_FULL;
 			else /* er,... */
-				val->intval = POWER_SUPPLY_STATUS_NOT_CHARGING;
+				ret = POWER_SUPPLY_STATUS_NOT_CHARGING;
 		} else {
 			/* Older EC didn't report charge/discharge bits */
 			if (!(ec_byte & BAT_STAT_AC)) /* No AC means discharging */
-				val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
+				ret = POWER_SUPPLY_STATUS_DISCHARGING;
 			else if (ec_byte & BAT_STAT_FULL)
-				val->intval = POWER_SUPPLY_STATUS_FULL;
+				ret = POWER_SUPPLY_STATUS_FULL;
 			else /* Not _necessarily_ true but EC doesn't tell all yet */
-				val->intval = POWER_SUPPLY_STATUS_CHARGING;
-			break;
+				ret = POWER_SUPPLY_STATUS_CHARGING;
 		}
-	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = !!(ec_byte & BAT_STAT_PRESENT);
+		ret = power_supply_status_str(ret, buf);
+		break;
+	case OLPC_PROP_PRESENT:
+		ret = sprintf(buf, "%d\n", !!(ec_byte & BAT_STAT_PRESENT));
 		break;
 
-	case POWER_SUPPLY_PROP_HEALTH:
+	case OLPC_PROP_HEALTH:
 		if (ec_byte & BAT_STAT_DESTROY)
-			val->intval = POWER_SUPPLY_HEALTH_DEAD;
+			ret = POWER_SUPPLY_HEALTH_DEAD;
 		else {
 			ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
 			if (ret)
@@ -143,22 +165,22 @@ static int olpc_bat_get_property(struct power_supply *psy,
 
 			switch (ec_byte) {
 			case 0:
-				val->intval = POWER_SUPPLY_HEALTH_GOOD;
+				ret = POWER_SUPPLY_HEALTH_GOOD;
 				break;
 
 			case BAT_ERR_OVERTEMP:
-				val->intval = POWER_SUPPLY_HEALTH_OVERHEAT;
+				ret = POWER_SUPPLY_HEALTH_OVERHEAT;
 				break;
 
 			case BAT_ERR_OVERVOLTAGE:
-				val->intval = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
+				ret = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 				break;
 
 			case BAT_ERR_INFOFAIL:
 			case BAT_ERR_OUT_OF_CONTROL:
 			case BAT_ERR_ID_FAIL:
 			case BAT_ERR_ACR_FAIL:
-				val->intval = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
+				ret = POWER_SUPPLY_HEALTH_UNSPEC_FAILURE;
 				break;
 
 			default:
@@ -166,9 +188,10 @@ static int olpc_bat_get_property(struct power_supply *psy,
 				return -EIO;
 			}
 		}
+		ret = power_supply_health_str(ret, buf);
 		break;
 
-	case POWER_SUPPLY_PROP_MANUFACTURER:
+	case OLPC_PROP_MANUFACTURER:
 		ec_byte = BAT_ADDR_MFR_TYPE;
 		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
 		if (ret)
@@ -176,17 +199,17 @@ static int olpc_bat_get_property(struct power_supply *psy,
 
 		switch (ec_byte >> 4) {
 		case 1:
-			val->strval = "Gold Peak";
+			strcpy(buf, "Gold Peak\n");
 			break;
 		case 2:
-			val->strval = "BYD";
+			strcpy(buf, "BYD\n");
 			break;
 		default:
-			val->strval = "Unknown";
+			strcpy(buf, "Unknown\n");
 			break;
 		}
 		break;
-	case POWER_SUPPLY_PROP_TECHNOLOGY:
+	case OLPC_PROP_TECHNOLOGY:
 		ec_byte = BAT_ADDR_MFR_TYPE;
 		ret = olpc_ec_cmd(EC_BAT_EEPROM, &ec_byte, 1, &ec_byte, 1);
 		if (ret)
@@ -194,52 +217,53 @@ static int olpc_bat_get_property(struct power_supply *psy,
 
 		switch (ec_byte & 0xf) {
 		case 1:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_NiMH;
+			ret = POWER_SUPPLY_TECHNOLOGY_NiMH;
 			break;
 		case 2:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_LiFe;
+			ret = POWER_SUPPLY_TECHNOLOGY_LiFe;
 			break;
 		default:
-			val->intval = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
+			ret = POWER_SUPPLY_TECHNOLOGY_UNKNOWN;
 			break;
 		}
+		ret = power_supply_technology_str(ret, buf);
 		break;
-	case POWER_SUPPLY_PROP_VOLTAGE_AVG:
+	case OLPC_PROP_VOLTAGE_AVG:
 		ret = olpc_ec_cmd(EC_BAT_VOLTAGE, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
 		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 9760L / 32;
+		ret = sprintf(buf, "%d\n", ec_word * 9760L / 32);
 		break;
-	case POWER_SUPPLY_PROP_CURRENT_AVG:
+	case OLPC_PROP_CURRENT_AVG:
 		ret = olpc_ec_cmd(EC_BAT_CURRENT, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
 		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 15625L / 120;
+		ret = sprintf(buf, "%d\n", ec_word * 15625L / 120);
 		break;
-	case POWER_SUPPLY_PROP_CAPACITY:
+	case OLPC_PROP_CAPACITY:
 		ret = olpc_ec_cmd(EC_BAT_SOC, NULL, 0, &ec_byte, 1);
 		if (ret)
 			return ret;
-		val->intval = ec_byte;
+		sprintf(buf, "%d\n", ec_byte);
 		break;
-	case POWER_SUPPLY_PROP_TEMP:
+	case OLPC_PROP_TEMP:
 		ret = olpc_ec_cmd(EC_BAT_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+		ret = sprintf(buf, "%d\n", ec_word * 100 / 256);
 		break;
-	case POWER_SUPPLY_PROP_TEMP_AMBIENT:
+	case OLPC_PROP_TEMP_AMBIENT:
 		ret = olpc_ec_cmd(EC_AMB_TEMP, NULL, 0, (void *)&ec_word, 2);
 		if (ret)
 			return ret;
 
 		ec_word = be16_to_cpu(ec_word);
-		val->intval = ec_word * 100 / 256;
+		ret = sprintf(buf, "%d\n", ec_word * 100 / 256);
 		break;
 	default:
 		ret = -EINVAL;
@@ -249,19 +273,6 @@ static int olpc_bat_get_property(struct power_supply *psy,
 	return ret;
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
-};
-
 /*********************************************************************
  *		Initialisation
  *********************************************************************/
@@ -269,9 +280,7 @@ static enum power_supply_property olpc_bat_props[] = {
 static struct platform_device *bat_pdev;
 
 static struct power_supply olpc_bat = {
-	.properties = olpc_bat_props,
-	.num_properties = ARRAY_SIZE(olpc_bat_props),
-	.get_property = olpc_bat_get_property,
+	.props = (struct device_attribute **) &olpc_bat_props,
 	.use_for_apm = 1,
 };
 



