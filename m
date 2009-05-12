Return-Path: <linux-kernel-owner+w=401wt.eu-S1758253AbZELHU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758253AbZELHU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 03:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755643AbZELHUP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 03:20:15 -0400
Received: from cathcart.site5.com ([74.54.107.137]:54046 "EHLO
	cathcart.site5.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755029AbZELHUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 03:20:13 -0400
From: Mike Rapoport <mike@compulab.co.il>
To: cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, Mike Rapoport <mike@compulab.co.il>
Subject: [PATCH] da9030_battery: fix race between event handler and monitor
Date: Tue, 12 May 2009 10:20:09 +0300
Message-Id: <1242112809-10021-1-git-send-email-mike@compulab.co.il>
X-Mailer: git-send-email 1.6.0.6
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cathcart.site5.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Rapoport <mike@compulab.co.il>
---
 drivers/power/da9030_battery.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/power/da9030_battery.c b/drivers/power/da9030_battery.c
index 1662bb0..3364198 100644
--- a/drivers/power/da9030_battery.c
+++ b/drivers/power/da9030_battery.c
@@ -22,8 +22,6 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 
-#define DA9030_STATUS_CHDET	(1 << 3)
-
 #define DA9030_FAULT_LOG		0x0a
 #define DA9030_FAULT_LOG_OVER_TEMP	(1 << 7)
 #define DA9030_FAULT_LOG_VBAT_OVER	(1 << 4)
@@ -244,6 +242,8 @@ static void da9030_set_charge(struct da9030_charger *charger, int on)
 	}
 
 	da903x_write(charger->master, DA9030_CHARGE_CONTROL, val);
+
+	power_supply_changed(&charger->psy);
 }
 
 static void da9030_charger_check_state(struct da9030_charger *charger)
@@ -258,6 +258,12 @@ static void da9030_charger_check_state(struct da9030_charger *charger)
 			da9030_set_charge(charger, 1);
 		}
 	} else {
+		/* Charger has been pulled out */
+		if (!charger->chdet) {
+			da9030_set_charge(charger, 0);
+			return;
+		}
+
 		if (charger->adc.vbat_res >=
 		    charger->thresholds.vbat_charge_stop) {
 			da9030_set_charge(charger, 0);
@@ -395,13 +401,11 @@ static int da9030_battery_event(struct notifier_block *nb, unsigned long event,
 {
 	struct da9030_charger *charger =
 		container_of(nb, struct da9030_charger, nb);
-	int status;
 
 	switch (event) {
 	case DA9030_EVENT_CHDET:
-		status = da903x_query_status(charger->master,
-					     DA9030_STATUS_CHDET);
-		da9030_set_charge(charger, status);
+		cancel_delayed_work_sync(&charger->work);
+		schedule_work(&charger->work.work);
 		break;
 	case DA9030_EVENT_VBATMON:
 		da9030_battery_vbat_event(charger);
@@ -565,7 +569,8 @@ static int da9030_battery_remove(struct platform_device *dev)
 	da903x_unregister_notifier(charger->master, &charger->nb,
 				   DA9030_EVENT_CHDET | DA9030_EVENT_VBATMON |
 				   DA9030_EVENT_CHIOVER | DA9030_EVENT_TBAT);
-	cancel_delayed_work(&charger->work);
+	cancel_delayed_work_sync(&charger->work);
+	da9030_set_charge(charger, 0);
 	power_supply_unregister(&charger->psy);
 
 	kfree(charger);
-- 
1.6.0.6

