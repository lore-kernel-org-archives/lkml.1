Return-Path: <linux-kernel-owner+w=401wt.eu-S1751852AbZHES3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbZHES3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 14:29:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751803AbZHES3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 14:29:52 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:38143 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798AbZHES3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 14:29:51 -0400
From: Daniel Mack <daniel@caiaq.de>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, Daniel Mack <daniel@caiaq.de>,
       Ian Molton <spyro@f2s.com>, Anton Vorontsov <cbou@mail.ru>,
       Matt Reimer <mreimer@vpop.net>
Subject: [PATCH 2/5] pda-power: switch to new dev_pm_ops
Date: Wed,  5 Aug 2009 20:29:28 +0200
Message-Id: <1249496971-9019-2-git-send-email-daniel@caiaq.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
References: <1249496971-9019-1-git-send-email-daniel@caiaq.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Mack <daniel@caiaq.de>
Cc: Ian Molton <spyro@f2s.com>
Cc: Anton Vorontsov <cbou@mail.ru>
Cc: Matt Reimer <mreimer@vpop.net>
---
 drivers/power/pda_power.c |   27 ++++++++++++++++++---------
 1 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
index a232de6..34af275 100644
--- a/drivers/power/pda_power.c
+++ b/drivers/power/pda_power.c
@@ -402,9 +402,9 @@ static int pda_power_remove(struct platform_device *pdev)
 static int ac_wakeup_enabled;
 static int usb_wakeup_enabled;
 
-static int pda_power_suspend(struct platform_device *pdev, pm_message_t state)
+static int pda_power_suspend(struct device *dev)
 {
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		if (ac_irq)
 			ac_wakeup_enabled = !enable_irq_wake(ac_irq->start);
 		if (usb_irq)
@@ -414,9 +414,9 @@ static int pda_power_suspend(struct platform_device *pdev, pm_message_t state)
 	return 0;
 }
 
-static int pda_power_resume(struct platform_device *pdev)
+static int pda_power_resume(struct device *dev)
 {
-	if (device_may_wakeup(&pdev->dev)) {
+	if (device_may_wakeup(dev)) {
 		if (usb_irq && usb_wakeup_enabled)
 			disable_irq_wake(usb_irq->start);
 		if (ac_irq && ac_wakeup_enabled)
@@ -425,21 +425,30 @@ static int pda_power_resume(struct platform_device *pdev)
 
 	return 0;
 }
+
+static struct dev_pm_ops pda_power_pm_ops = {
+	.suspend	= pda_power_suspend,
+	.freeze		= pda_power_freeze,
+	.resume		= pda_power_resume,
+	.thaw		= pda_power_resume,
+};
+
+#define PDA_POWER_PM_OPS (&pda_power_pm_ops)
+
 #else
-#define pda_power_suspend NULL
-#define pda_power_resume NULL
+#define PDA_POWER_PM_OPS NULL
 #endif /* CONFIG_PM */
 
 MODULE_ALIAS("platform:pda-power");
 
 static struct platform_driver pda_power_pdrv = {
 	.driver = {
-		.name = "pda-power",
+		.name	= "pda-power",
+		.owner	= THIS_MODULE,
+		.pm	= PDA_POWER_PM_OPS,
 	},
 	.probe = pda_power_probe,
 	.remove = pda_power_remove,
-	.suspend = pda_power_suspend,
-	.resume = pda_power_resume,
 };
 
 static int __init pda_power_init(void)
-- 
1.6.3.3

