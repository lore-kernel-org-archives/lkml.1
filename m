Return-Path: <linux-kernel-owner+w=401wt.eu-S934361AbZKXW5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934361AbZKXW5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 17:57:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934333AbZKXW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 17:57:44 -0500
Received: from mail-px0-f180.google.com ([209.85.216.180]:59542 "EHLO
	mail-px0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934281AbZKXW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 17:57:43 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Nicolas Pitre <nico@fluxnic.net>, "David S. Miller" <davem@davemloft.net>,
       netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] NET: smc91x: convert to dev_pm_ops
Date: Tue, 24 Nov 2009 14:57:47 -0800
Message-Id: <1259103467-31016-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert smc91x driver from legacy PM hooks over to using dev_pm_ops.

Tested on OMAP3 platform.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/net/smc91x.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
index 05c91ee..8e4c455 100644
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -2365,9 +2365,10 @@ static int __devexit smc_drv_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int smc_drv_suspend(struct platform_device *dev, pm_message_t state)
+static int smc_drv_suspend(struct device *dev)
 {
-	struct net_device *ndev = platform_get_drvdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct net_device *ndev = platform_get_drvdata(pdev);
 
 	if (ndev) {
 		if (netif_running(ndev)) {
@@ -2379,9 +2380,10 @@ static int smc_drv_suspend(struct platform_device *dev, pm_message_t state)
 	return 0;
 }
 
-static int smc_drv_resume(struct platform_device *dev)
+static int smc_drv_resume(struct device *dev)
 {
-	struct net_device *ndev = platform_get_drvdata(dev);
+	struct platform_device *pdev = to_platform_device(dev);
+	struct net_device *ndev = platform_get_drvdata(pdev);
 
 	if (ndev) {
 		struct smc_local *lp = netdev_priv(ndev);
@@ -2397,14 +2399,18 @@ static int smc_drv_resume(struct platform_device *dev)
 	return 0;
 }
 
+static struct dev_pm_ops smc_drv_pm_ops = {
+	.suspend	= smc_drv_suspend,
+	.resume		= smc_drv_resume,
+};
+
 static struct platform_driver smc_driver = {
 	.probe		= smc_drv_probe,
 	.remove		= __devexit_p(smc_drv_remove),
-	.suspend	= smc_drv_suspend,
-	.resume		= smc_drv_resume,
 	.driver		= {
 		.name	= CARDNAME,
 		.owner	= THIS_MODULE,
+		.pm	= &smc_drv_pm_ops,
 	},
 };
 
-- 
1.6.5.1

