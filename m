Return-Path: <linux-kernel-owner+w=401wt.eu-S1752702AbZFWDqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbZFWDqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbZFWDqP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:46:15 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:53168 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757354AbZFWDqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:46:14 -0400
Date: Mon, 22 Jun 2009 23:46:07 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: [PATCH 3/5] power_supply: add a TRICKLE_CHARGING status, and add it
 to the olpc driver
Message-ID: <20090622234607.11f61bec@mycelium.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The hardware has an extra bit that specifies that the battery is trickle
charging, so when determining if the battery is present/charging the TRICKLE
bit needs to be checked as well.  Because battery diagnostics might want to
know whether trickle charging is happening or not, and also because trickle
charging falls somewhere between charging and not charging (read: Richard got
mad at me when I tried to set CHARGING when in trickle charge.  He gets so
angry sometimes), we add a new TRICKLE status to sysfs.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/power/olpc_battery.c       |   13 ++++++++++---
 drivers/power/power_supply_sysfs.c |    3 ++-
 include/linux/power_supply.h       |    1 +
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index f8d2d6b..3ecf484 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -35,6 +35,7 @@
 #define BAT_STAT_AC		0x10
 #define BAT_STAT_CHARGING	0x20
 #define BAT_STAT_DISCHARGING	0x40
+#define BAT_STAT_TRICKLE	0x80
 
 #define BAT_ERR_INFOFAIL	0x02
 #define BAT_ERR_OVERVOLTAGE	0x04
@@ -89,7 +90,12 @@ static char bat_serial[17]; /* Ick */
 static int olpc_bat_get_status(union power_supply_propval *val, uint8_t ec_byte)
 {
 	if (olpc_platform_info.ecver > 0x44) {
-		if (ec_byte & BAT_STAT_CHARGING)
+		if (ec_byte & BAT_STAT_TRICKLE)
+			/* Note that the order here is important; the EC sets
+			 * both the CHARGING and TRICKLE bits at the same time
+			 * to support older kernels. */
+			val->intval = POWER_SUPPLY_STATUS_TRICKLE_CHARGING;
+		else if (ec_byte & BAT_STAT_CHARGING)
 			val->intval = POWER_SUPPLY_STATUS_CHARGING;
 		else if (ec_byte & BAT_STAT_DISCHARGING)
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
@@ -219,7 +225,8 @@ static int olpc_bat_get_property(struct power_supply *psy,
 	   It doesn't matter though -- the EC will return the last-known
 	   information, and it's as if we just ran that _little_ bit faster
 	   and managed to read it out before the battery went away. */
-	if (!(ec_byte & BAT_STAT_PRESENT) && psp != POWER_SUPPLY_PROP_PRESENT)
+	if (!(ec_byte & (BAT_STAT_PRESENT|BAT_STAT_TRICKLE)) &&
+			psp != POWER_SUPPLY_PROP_PRESENT)
 		return -ENODEV;
 
 	switch (psp) {
@@ -229,7 +236,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 			return ret;
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = !!(ec_byte & BAT_STAT_PRESENT);
+		val->intval = !!(ec_byte & (BAT_STAT_PRESENT|BAT_STAT_TRICKLE));
 		break;
 
 	case POWER_SUPPLY_PROP_HEALTH:
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index add5f39..eb1affc 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -41,7 +41,8 @@ static ssize_t power_supply_show_property(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf) {
 	static char *status_text[] = {
-		"Unknown", "Charging", "Discharging", "Not charging", "Full"
+		"Unknown", "Charging", "Charging (trickle)", "Discharging", "Not charging",
+		"Full",
 	};
 	static char *health_text[] = {
 		"Unknown", "Good", "Overheat", "Dead", "Over voltage",
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 1e45cbc..50ee079 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -33,6 +33,7 @@
 enum {
 	POWER_SUPPLY_STATUS_UNKNOWN = 0,
 	POWER_SUPPLY_STATUS_CHARGING,
+	POWER_SUPPLY_STATUS_TRICKLE_CHARGING,
 	POWER_SUPPLY_STATUS_DISCHARGING,
 	POWER_SUPPLY_STATUS_NOT_CHARGING,
 	POWER_SUPPLY_STATUS_FULL,
-- 
1.5.6.5

