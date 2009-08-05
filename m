Return-Path: <linux-kernel-owner+w=401wt.eu-S1751883AbZHES3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751883AbZHES3z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751864AbZHES3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:29:54 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38163 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbZHES3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:29:53 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>,
       Matt Reimer <mreimer@vpop.net>, Anton Vorontsov <cbou@mail.ru>
Subject: [PATCH 3/5] ds2760: switch to new dev_pm_ops
Date: Wed,  5 Aug 2009 20:29:29 +0200
Message-Id: <1249496971-9019-3-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249496971-9019-2-git-send-email-daniel@caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
 <1249496971-9019-2-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Szabolcs Gyurko <szabolcs.gyurko@tlt.hu>
Cc: Matt Reimer <mreimer@vpop.net>
Cc: Anton Vorontsov <cbou@mail.ru>
---
 drivers/power/ds2760_battery.c |   27 ++++++++++++++++-----------
 1 files changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/power/ds2760_battery.c b/drivers/power/ds2760_battery.c
index ca43b1c..3c9d8cd 100644
--- a/drivers/power/ds2760_battery.c
+++ b/drivers/power/ds2760_battery.c
@@ -557,19 +557,18 @@ static int ds2760_battery_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_PM
 
-static int ds2760_battery_suspend(struct platform_device *pdev,
-				  pm_message_t state)
+static int ds2760_battery_suspend(struct device *dev)
 {
-	struct ds2760_device_info *di = platform_get_drvdata(pdev);
+	struct ds2760_device_info *di = dev_get_drvdata(dev);
 
 	di->charge_status = POWER_SUPPLY_STATUS_UNKNOWN;
 
 	return 0;
 }
 
-static int ds2760_battery_resume(struct platform_device *pdev)
+static int ds2760_battery_resume(struct device *dev)
 {
-	struct ds2760_device_info *di = platform_get_drvdata(pdev);
+	struct ds2760_device_info *di = dev_get_drvdata(dev);
 
 	di->charge_status = POWER_SUPPLY_STATUS_UNKNOWN;
 	power_supply_changed(&di->bat);
@@ -580,23 +579,29 @@ static int ds2760_battery_resume(struct platform_device *pdev)
 	return 0;
 }
 
-#else
+static struct dev_pm_ops ds2760_battery_pm_ops = {
+	.suspend        = ds2760_battery_suspend,
+	.freeze		= ds2760_battery_suspend,
+	.resume         = ds2760_battery_resume,
+	.thaw		= ds2760_battery_resume,
+};
 
-#define ds2760_battery_suspend NULL
-#define ds2760_battery_resume NULL
+#define DS2760_PM_OPS (&ds2760_battery_pm_ops)
 
+#else
+#define DS2760_PM_OPS NULL
 #endif /* CONFIG_PM */
 
 MODULE_ALIAS("platform:ds2760-battery");
 
 static struct platform_driver ds2760_battery_driver = {
 	.driver = {
-		.name = "ds2760-battery",
+		.owner	= THIS_MODULE,
+		.name	= "ds2760-battery",
+		.pm	= DS2760_PM_OPS,
 	},
 	.probe	  = ds2760_battery_probe,
 	.remove   = ds2760_battery_remove,
-	.suspend  = ds2760_battery_suspend,
-	.resume	  = ds2760_battery_resume,
 };
 
 static int __init ds2760_battery_init(void)
-- 
1.6.3.3

