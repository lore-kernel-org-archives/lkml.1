Return-Path: <linux-kernel-owner+w=401wt.eu-S1755583AbZGOQU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755583AbZGOQU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 12:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZGOQU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 12:20:57 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:43749 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611AbZGOQU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 12:20:57 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 1/4] ds2760: delay power supply registration
Date: Wed, 15 Jul 2009 18:20:38 +0200
Message-Id: <1247674841-9909-1-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a race condition I recently introduced with the PMOD feature
addition (cef437e3: "w1: ds2760_battery: add support for sleep mode
feature").

Postpone the call to power_supply_register() to fix it.

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/ds2760_battery.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index 520b5c4..cf07c43 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -381,12 +381,6 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 
 	di->charge_status = POWER_SUPPLY_STATUS_UNKNOWN;
 
-	retval = power_supply_register(&pdev->dev, &di->bat);
-	if (retval) {
-		dev_err(di->dev, "failed to register battery\n");
-		goto batt_failed;
-	}
-
 	/* enable sleep mode feature */
 	ds2760_battery_read_status(di);
 	status = di->raw[DS2760_STATUS_REG];
@@ -397,6 +391,12 @@ static int ds2760_battery_probe(struct platform_device *pdev)
 
 	ds2760_battery_write_status(di, status);
 
+	retval = power_supply_register(&pdev->dev, &di->bat);
+	if (retval) {
+		dev_err(di->dev, "failed to register battery\n");
+		goto batt_failed;
+	}
+
 	INIT_DELAYED_WORK(&di->monitor_work, ds2760_battery_work);
 	di->monitor_wqueue = create_singlethread_workqueue(dev_name(&pdev->dev));
 	if (!di->monitor_wqueue) {
-- 
1.6.3.1

