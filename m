Return-Path: <linux-kernel-owner+w=401wt.eu-S1758322AbZF3GQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758322AbZF3GQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 02:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZF3GQT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 02:16:19 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:47293 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbZF3GQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 02:16:19 -0400
Date: Tue, 30 Jun 2009 02:16:17 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: [PATCH 4/5] power_supply: ensure that the TRICKLE bit is checked in
 olpc_battery
Message-ID: <20090630021617.78748e27@mycelium.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are times when the battery is present but trickle charging, and the EC
sets only the TRICKLE bit.. So we must check for the bit when we're checking
the charging/present status.

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/power/olpc_battery.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index c955a86..af17051 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -35,6 +35,7 @@
 #define BAT_STAT_AC		0x10
 #define BAT_STAT_CHARGING	0x20
 #define BAT_STAT_DISCHARGING	0x40
+#define BAT_STAT_TRICKLE	0x80
 
 #define BAT_ERR_INFOFAIL	0x02
 #define BAT_ERR_OVERVOLTAGE	0x04
@@ -89,7 +90,7 @@ static char bat_serial[17]; /* Ick */
 static int olpc_bat_get_status(union power_supply_propval *val, uint8_t ec_byte)
 {
 	if (olpc_platform_info.ecver > 0x44) {
-		if (ec_byte & BAT_STAT_CHARGING)
+		if (ec_byte & (BAT_STAT_CHARGING|BAT_STAT_TRICKLE))
 			val->intval = POWER_SUPPLY_STATUS_CHARGING;
 		else if (ec_byte & BAT_STAT_DISCHARGING)
 			val->intval = POWER_SUPPLY_STATUS_DISCHARGING;
@@ -219,7 +220,8 @@ static int olpc_bat_get_property(struct power_supply *psy,
 	   It doesn't matter though -- the EC will return the last-known
 	   information, and it's as if we just ran that _little_ bit faster
 	   and managed to read it out before the battery went away. */
-	if (!(ec_byte & BAT_STAT_PRESENT) && psp != POWER_SUPPLY_PROP_PRESENT)
+	if (!(ec_byte & (BAT_STAT_PRESENT|BAT_STAT_TRICKLE)) &&
+			psp != POWER_SUPPLY_PROP_PRESENT)
 		return -ENODEV;
 
 	switch (psp) {
@@ -229,7 +231,7 @@ static int olpc_bat_get_property(struct power_supply *psy,
 			return ret;
 		break;
 	case POWER_SUPPLY_PROP_PRESENT:
-		val->intval = !!(ec_byte & BAT_STAT_PRESENT);
+		val->intval = !!(ec_byte & (BAT_STAT_PRESENT|BAT_STAT_TRICKLE));
 		break;
 
 	case POWER_SUPPLY_PROP_HEALTH:
-- 
1.5.6.5


