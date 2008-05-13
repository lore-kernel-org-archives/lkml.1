Return-Path: <linux-kernel-owner+w=401wt.eu-S1757505AbYEMBmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505AbYEMBmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 21:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756769AbYEMBmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 21:42:25 -0400
Received: from mail.queued.net ([207.210.101.209]:2981 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756767AbYEMBmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 21:42:24 -0400
Date: Mon, 12 May 2008 21:46:29 -0400
From: Andres Salomon <dilinger@queued.net>
To: richard@laptop.org
Cc: avorontsov@ru.mvista.com, Andrew Morton <akpm@linux-foundation.org>,
       cbou@mail.ru, linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: [PATCH] power_supply: add CHARGE_COUNTER property and olpc_battery
 support for it
Message-ID: <20080512214629.443a5999@ephemeral>
In-Reply-To: <4823663B.6060409@laptop.org>
References: <20080508003454.722ba511@ephemeral>
	<20080508105145.GA32017@polina.dev.rtsoft.ru>
	<20080508130102.3218f1e9@ephemeral>
	<20080508171320.GA8226@polina.dev.rtsoft.ru>
	<48234C25.4040807@laptop.org>
	<20080508193614.GA31188@polina.dev.rtsoft.ru>
	<4823663B.6060409@laptop.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 May 2008 16:44:43 -0400
"Richard A. Smith" <richard@laptop.org> wrote:

> Anton Vorontsov wrote:
> 
> > Cool, I believe this is exactly same thing as we have on DS2760. ACR
> > counts up and down. For example, if there was a current of 10 uA for
> > 30 minutes, ACR will show 5 uAh. Additional 30 minutes with current
> > -10 uA will result in 0 uAh in ACR... Right?
> 
> Yes. Exactly correct.
> 
> >> The units for the ACR register in the DS2765 are:
> > 
> > Do you have any specs for the ds2765? I'd like to see one, if
> > it isn't restricted matter. google:ds2765 pdf wasn't helpful...
> > 
> 
> Ooop.  Sorry my typo.  DS2756.
> 
> http://wiki.laptop.org/images/e/e9/DS2756.pdf
> or
> http://www.maxim-ic.com/quick_view2.cfm/qv_pk/5104
> 

Wow, having the data sheet makes things so much clearer. :)


[...]
> 
> >> That would be SOC% *  
> >> battery capacity.  The EC uses the relative motion of the ACR to
> >> update the SOC%.
> > 
> > Since you don't seem to use ACR as CHARGE_NOW, I think maybe we
> > indeed should implement PROP_ACR or better PROP_CHARGE_COUNTER?
> > With units of uAh... would that work?
> 
> That would work fine.
> 

Alright folks, how does this look?




From: Andres Salomon <dilinger@debian.org>

This adds PROP_CHARGE_COUNTER to the power supply class (documenting it
as well).  The OLPC battery driver uses this for spitting out its ACR
values (in uAh).  We have some rounding errors (the data sheet claims
416.7, the math actually works out to 416.666667, so we're forced to
choose between overflows or precision loss.  I chose precision loss,
and stuck w/ data sheet values), but I don't think anyone will care
that much.

Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 Documentation/power/power_supply_class.txt |    4 ++++
 drivers/power/olpc_battery.c               |   11 ++++++++++-
 drivers/power/power_supply_sysfs.c         |    1 +
 include/linux/power_supply.h               |    1 +
 4 files changed, 16 insertions(+), 1 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index a8686e5..c6cd495 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -101,6 +101,10 @@ of charge when battery became full/empty". It also could mean "value of
 charge when battery considered full/empty at given conditions (temperature,
 age)". I.e. these attributes represents real thresholds, not design values.
 
+CHARGE_COUNTER - the current charge counter (in µAh).  This could easily
+be negative; there is no empty or full value.  It is only useful for
+relative, time-based measurements.
+
 ENERGY_FULL, ENERGY_EMPTY - same as above but for energy.
 
 CAPACITY - capacity in percents.
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index e3f6ec8..a928165 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -19,7 +19,7 @@
 
 #define EC_BAT_VOLTAGE	0x10	/* uint16_t,	*9.76/32,    mV   */
 #define EC_BAT_CURRENT	0x11	/* int16_t,	*15.625/120, mA   */
-#define EC_BAT_ACR	0x12
+#define EC_BAT_ACR	0x12	/* int16_t,	*416.7,      µAh  */
 #define EC_BAT_TEMP	0x13	/* uint16_t,	*100/256,   °C  */
 #define EC_AMB_TEMP	0x14	/* uint16_t,	*100/256,   °C  */
 #define EC_BAT_STATUS	0x15	/* uint8_t,	bitmask */
@@ -289,6 +289,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		ec_word = be16_to_cpu(ec_word);
 		val->intval = ec_word * 100 / 256;
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_COUNTER:
+		ret = olpc_ec_cmd(EC_BAT_ACR, NULL, 0, (void *)&ec_word, 2);
+		if (ret)
+			return ret;
+
+		ec_word = be16_to_cpu(ec_word);
+		val->intval = ec_word * 4167 / 10;
+		break;
 	case POWER_SUPPLY_PROP_SERIAL_NUMBER:
 		ret = olpc_ec_cmd(EC_BAT_SERIAL, NULL, 0, (void *)&ser_buf, 8);
 		if (ret)
@@ -317,6 +325,7 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
 };
 
 /* EEPROM reading goes completely around the power_supply API, sadly */
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index c444d6b..82e1246 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -99,6 +99,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(charge_empty),
 	POWER_SUPPLY_ATTR(charge_now),
 	POWER_SUPPLY_ATTR(charge_avg),
+	POWER_SUPPLY_ATTR(charge_counter),
 	POWER_SUPPLY_ATTR(energy_full_design),
 	POWER_SUPPLY_ATTR(energy_empty_design),
 	POWER_SUPPLY_ATTR(energy_full),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 68ed19c..ea96ead 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -78,6 +78,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_CHARGE_EMPTY,
 	POWER_SUPPLY_PROP_CHARGE_NOW,
 	POWER_SUPPLY_PROP_CHARGE_AVG,
+	POWER_SUPPLY_PROP_CHARGE_COUNTER,
 	POWER_SUPPLY_PROP_ENERGY_FULL_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_EMPTY_DESIGN,
 	POWER_SUPPLY_PROP_ENERGY_FULL,
-- 
1.5.5.1

