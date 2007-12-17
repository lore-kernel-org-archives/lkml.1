Return-Path: <linux-kernel-owner+w=401wt.eu-S934041AbXLQCZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934041AbXLQCZd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 21:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934318AbXLQCYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 21:24:54 -0500
Received: from mail.queued.net ([207.210.101.209]:2438 "EHLO mail.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933873AbXLQCYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 21:24:53 -0500
Date: Sun, 16 Dec 2007 21:24:51 -0500
From: Andres Salomon <dilinger@queued.net>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, akpm@linux-foundation.org,
       cbou@mail.ru
Subject: [PATCH 2/5] power: convert pda_power to the new API
Message-ID: <20071216212451.0623bfc6@ephemeral>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andres Salomon <dilinger@debian.org>
---
 drivers/power/pda_power.c |   40 ++++++++++++++++------------------------
 1 files changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index c058f28..4012a2f 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -33,27 +33,23 @@ static struct resource *ac_irq, *usb_irq;
 static struct timer_list charger_timer;
 static struct timer_list supply_timer;
 
-static int pda_power_get_property(struct power_supply *psy,
-				  enum power_supply_property psp,
-				  union power_supply_propval *val)
+static ssize_t pda_power_online(struct device *dev,
+		struct device_attribute *attr, char *buf)
 {
-	switch (psp) {
-	case POWER_SUPPLY_PROP_ONLINE:
-		if (psy->type == POWER_SUPPLY_TYPE_MAINS)
-			val->intval = pdata->is_ac_online ?
-				      pdata->is_ac_online() : 0;
-		else
-			val->intval = pdata->is_usb_online ?
-				      pdata->is_usb_online() : 0;
-		break;
-	default:
-		return -EINVAL;
-	}
-	return 0;
+	struct power_supply *psy = dev_get_drvdata(dev);
+	int ret;
+
+	if (psy->type == POWER_SUPPLY_TYPE_MAINS)
+		ret = pdata->is_ac_online ? pdata->is_ac_online() : 0;
+	else
+		ret = pdata->is_usb_online ? pdata->is_usb_online() : 0;
+
+	return sprintf(buf, "%d\n", !!ret);
 }
 
-static enum power_supply_property pda_power_props[] = {
-	POWER_SUPPLY_PROP_ONLINE,
+static struct device_attribute pda_power_props[] = {
+	POWER_SUPPLY_ONLINE(pda_power_online),
+	POWER_SUPPLY_END
 };
 
 static char *pda_power_supplied_to[] = {
@@ -67,18 +63,14 @@ static struct power_supply pda_power_supplies[] = {
 		.type = POWER_SUPPLY_TYPE_MAINS,
 		.supplied_to = pda_power_supplied_to,
 		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
-		.properties = pda_power_props,
-		.num_properties = ARRAY_SIZE(pda_power_props),
-		.get_property = pda_power_get_property,
+		.props = (struct device_attribute **) &pda_power_props,
 	},
 	{
 		.name = "usb",
 		.type = POWER_SUPPLY_TYPE_USB,
 		.supplied_to = pda_power_supplied_to,
 		.num_supplicants = ARRAY_SIZE(pda_power_supplied_to),
-		.properties = pda_power_props,
-		.num_properties = ARRAY_SIZE(pda_power_props),
-		.get_property = pda_power_get_property,
+		.props = (struct device_attribute **) &pda_power_props,
 	},
 };
 
-- 
1.5.3.5

