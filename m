Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbZGBNpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbZGBNpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 09:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753127AbZGBNpb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 09:45:31 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:53100 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbZGBNpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 09:45:30 -0400
Date: Thu, 2 Jul 2009 09:45:18 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: avorontsov@ru.mvista.com
Cc: cbou@mail.ru, dwmw2@infradead.org, linux-kernel@vger.kernel.org,
       richard@laptop.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Fox <pgf@laptop.org>, dsaxena@laptop.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 5/5] power_supply: add a charge_type status to the api,
  and use it for olpc driver
Message-ID: <20090702094518.3d44eca3@mycelium.queued.net>
In-Reply-To: <20090630231450.GD12076@oksana.dev.rtsoft.ru>
References: <20090630021730.44f86185@mycelium.queued.net>
	<20090630231450.GD12076@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 03:14:50 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Tue, Jun 30, 2009 at 02:17:30AM -0400, Andres Salomon wrote:
> > 
> > This adds a new sysfs file called 'charge_type' which displays the
> > type of charging (n/a, trickle charge, slow charge, or fast
> > charging).  This allows things like battery diagnostics to
> > determine what the battery/EC is doing without resorting to
> > changing the 'status' sysfs output.
> > 
> > Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
> > ---
> 
> The patch didn't apply cleanly (not sure why, maybe because
> of my "cosmetic" changes in the previous patches? hm.)
> 
> Can you please add "Unknown" state before "N/A", and
> per Mark's comments also remove "Slow" charge type, and
> resend the patch against battery-2.6.git tree?
> 
> Mark, since you seem to be interested in this addition, it
> would be great to see your ack/nak status on an updated
> patch, so we'll be sure that this is suitable for WM8350.
> 
> Thanks!
> 

An updated patch (against battery-2.6 master) is below.




This adds a new sysfs file called 'charge_type' which displays the type of
charging (unknown, n/a, trickle charge, or fast charging).  This allows
things like battery diagnostics to determine what the battery/EC is doing
without resorting to changing the 'status' sysfs output.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 Documentation/power/power_supply_class.txt |    5 +++++
 drivers/power/olpc_battery.c               |    9 +++++++++
 drivers/power/power_supply_sysfs.c         |    6 ++++++
 include/linux/power_supply.h               |    8 ++++++++
 4 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/Documentation/power/power_supply_class.txt b/Documentation/power/power_supply_class.txt
index 709d955..9f16c51 100644
--- a/Documentation/power/power_supply_class.txt
+++ b/Documentation/power/power_supply_class.txt
@@ -76,6 +76,11 @@ STATUS - this attribute represents operating status (charging, full,
 discharging (i.e. powering a load), etc.). This corresponds to
 BATTERY_STATUS_* values, as defined in battery.h.
 
+CHARGE_TYPE - batteries can typically charge at different rates.
+This defines trickle and fast charges.  For batteries that
+are already charged or discharging, 'n/a' can be displayed (or
+'unknown', if the status is not known).
+
 HEALTH - represents health of the battery, values corresponds to
 POWER_SUPPLY_HEALTH_*, defined in battery.h.
 
diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 602bbd0..8fefe5a 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -233,6 +233,14 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		if (ret)
 			return ret;
 		break;
+	case POWER_SUPPLY_PROP_CHARGE_TYPE:
+		if (ec_byte & BAT_STAT_TRICKLE)
+			val->intval = POWER_SUPPLY_CHARGE_TYPE_TRICKLE;
+		else if (ec_byte & BAT_STAT_CHARGING)
+			val->intval = POWER_SUPPLY_CHARGE_TYPE_FAST;
+		else
+			val->intval = POWER_SUPPLY_CHARGE_TYPE_NONE;
+		break;
 	case POWER_SUPPLY_PROP_PRESENT:
 		val->intval = !!(ec_byte & (BAT_STAT_PRESENT |
 					    BAT_STAT_TRICKLE));
@@ -325,6 +333,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 
 static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_STATUS,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_TECHNOLOGY,
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 9deabbd..0814439 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -43,6 +43,9 @@ static ssize_t power_supply_show_property(struct device *dev,
 	static char *status_text[] = {
 		"Unknown", "Charging", "Discharging", "Not charging", "Full"
 	};
+	static char *charge_type[] = {
+		"Unknown", "N/A", "Trickle", "Fast"
+	};
 	static char *health_text[] = {
 		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
 		"Unspecified failure", "Cold",
@@ -70,6 +73,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 
 	if (off == POWER_SUPPLY_PROP_STATUS)
 		return sprintf(buf, "%s\n", status_text[value.intval]);
+	else if (off == POWER_SUPPLY_PROP_CHARGE_TYPE)
+		return sprintf(buf, "%s\n", charge_type[value.intval]);
 	else if (off == POWER_SUPPLY_PROP_HEALTH)
 		return sprintf(buf, "%s\n", health_text[value.intval]);
 	else if (off == POWER_SUPPLY_PROP_TECHNOLOGY)
@@ -86,6 +91,7 @@ static ssize_t power_supply_show_property(struct device *dev,
 static struct device_attribute power_supply_attrs[] = {
 	/* Properties of type `int' */
 	POWER_SUPPLY_ATTR(status),
+	POWER_SUPPLY_ATTR(charge_type),
 	POWER_SUPPLY_ATTR(health),
 	POWER_SUPPLY_ATTR(present),
 	POWER_SUPPLY_ATTR(online),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 0ab6aa1..4c7c6fc 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -39,6 +39,13 @@ enum {
 };
 
 enum {
+	POWER_SUPPLY_CHARGE_TYPE_UNKNOWN = 0,
+	POWER_SUPPLY_CHARGE_TYPE_NONE,
+	POWER_SUPPLY_CHARGE_TYPE_TRICKLE,
+	POWER_SUPPLY_CHARGE_TYPE_FAST,
+};
+
+enum {
 	POWER_SUPPLY_HEALTH_UNKNOWN = 0,
 	POWER_SUPPLY_HEALTH_GOOD,
 	POWER_SUPPLY_HEALTH_OVERHEAT,
@@ -70,6 +77,7 @@ enum {
 enum power_supply_property {
 	/* Properties of type `int' */
 	POWER_SUPPLY_PROP_STATUS = 0,
+	POWER_SUPPLY_PROP_CHARGE_TYPE,
 	POWER_SUPPLY_PROP_HEALTH,
 	POWER_SUPPLY_PROP_PRESENT,
 	POWER_SUPPLY_PROP_ONLINE,
-- 
1.5.6.5

