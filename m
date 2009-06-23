Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZFWDqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZFWDqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 23:46:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752958AbZFWDqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 23:46:06 -0400
Received: from bhuna.collabora.co.uk ([93.93.131.97]:53164 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986AbZFWDqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 23:46:05 -0400
Date: Mon, 22 Jun 2009 23:45:59 -0400
From: Andres Salomon <dilinger@collabora.co.uk>
To: cbou@mail.ru
Cc: dwmw2@infradead.org, linux-kernel@vger.kernel.org, richard@laptop.org,
       Andrew Morton <akpm@linux-foundation.org>, Paul Fox <pgf@laptop.org>,
       dsaxena@laptop.org
Subject: [PATCH 2/5] power_supply: add an ERROR property that displays raw
 errors and use for OLPC
Message-ID: <20090622234559.6ca17ab8@mycelium.queued.net>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Grab the error code from EC_BAT_ERRCODE and let the user see it (rather
than attempting to decode it as we do with PROP_HEALTH).

Signed-off-by: Andres Salomon <dilinger@collabora.co.uk>
---
 drivers/power/olpc_battery.c       |    8 ++++++++
 drivers/power/power_supply_sysfs.c |    1 +
 include/linux/power_supply.h       |    1 +
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index 8f41733..f8d2d6b 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -242,6 +242,13 @@ static int olpc_bat_get_property(struct power_supply *psy,
 		}
 		break;
 
+	case POWER_SUPPLY_PROP_ERROR:
+		ret = olpc_ec_cmd(EC_BAT_ERRCODE, NULL, 0, &ec_byte, 1);
+		if (ret)
+			return ret;
+		val->intval = ec_byte;
+		break;
+
 	case POWER_SUPPLY_PROP_MANUFACTURER:
 		ret = olpc_bat_get_mfr(val);
 		if (ret)
@@ -319,6 +326,7 @@ static enum power_supply_property olpc_bat_props[] = {
 	POWER_SUPPLY_PROP_CAPACITY,
 	POWER_SUPPLY_PROP_TEMP,
 	POWER_SUPPLY_PROP_TEMP_AMBIENT,
+	POWER_SUPPLY_PROP_ERROR,
 	POWER_SUPPLY_PROP_MANUFACTURER,
 	POWER_SUPPLY_PROP_SERIAL_NUMBER,
 	POWER_SUPPLY_PROP_CHARGE_COUNTER,
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index da73591..add5f39 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -115,6 +115,7 @@ static struct device_attribute power_supply_attrs[] = {
 	POWER_SUPPLY_ATTR(time_to_empty_avg),
 	POWER_SUPPLY_ATTR(time_to_full_now),
 	POWER_SUPPLY_ATTR(time_to_full_avg),
+	POWER_SUPPLY_ATTR(error),
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_ATTR(model_name),
 	POWER_SUPPLY_ATTR(manufacturer),
diff --git a/include/linux/power_supply.h b/include/linux/power_supply.h
index 594c494..1e45cbc 100644
--- a/include/linux/power_supply.h
+++ b/include/linux/power_supply.h
@@ -95,6 +95,7 @@ enum power_supply_property {
 	POWER_SUPPLY_PROP_TIME_TO_EMPTY_AVG,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_NOW,
 	POWER_SUPPLY_PROP_TIME_TO_FULL_AVG,
+	POWER_SUPPLY_PROP_ERROR,
 	/* Properties of type `const char *' */
 	POWER_SUPPLY_PROP_MODEL_NAME,
 	POWER_SUPPLY_PROP_MANUFACTURER,
-- 
1.5.6.5

