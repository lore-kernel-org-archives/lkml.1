Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbYKVRjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbYKVRjV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 12:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759274AbYKVRgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 12:36:17 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:58473 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759327AbYKVRgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 12:36:15 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH 18/32] section errors in smc911x/smc91x
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1L3wP0-0006Xh-KY@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Sat, 22 Nov 2008 17:36:14 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


a) ->probe() can be __devinit; no need to put it into .text
b) calling __init stuff from it, OTOH, is wrong
c) ->remove() is __devexit fodder

Acked-by: rmk+kernel@arm.linux.org.uk
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/net/smc911x.c |   10 +++++-----
 drivers/net/smc91x.c  |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/smc911x.c b/drivers/net/smc911x.c
--- a/drivers/net/smc911x.c
+++ b/drivers/net/smc911x.c
@@ -1735,7 +1735,7 @@ static const struct ethtool_ops smc911x_ethtool_ops = {
  * This routine has a simple purpose -- make the SMC chip generate an
  * interrupt, so an auto-detect routine can detect it, and find the IRQ,
  */
-static int __init smc911x_findirq(struct net_device *dev)
+static int __devinit smc911x_findirq(struct net_device *dev)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	int timeout = 20;
@@ -1799,7 +1799,7 @@ static int __init smc911x_findirq(struct net_device *dev)
  * o  actually GRAB the irq.
  * o  GRAB the region
  */
-static int __init smc911x_probe(struct net_device *dev)
+static int __devinit smc911x_probe(struct net_device *dev)
 {
 	struct smc911x_local *lp = netdev_priv(dev);
 	int i, retval;
@@ -2048,7 +2048,7 @@ err_out:
  *	 0 --> there is a device
  *	 anything else, error
  */
-static int smc911x_drv_probe(struct platform_device *pdev)
+static int __devinit smc911x_drv_probe(struct platform_device *pdev)
 {
 #ifdef SMC_DYNAMIC_BUS_CONFIG
 	struct smc911x_platdata *pd = pdev->dev.platform_data;
@@ -2124,7 +2124,7 @@ out:
 	return ret;
 }
 
-static int smc911x_drv_remove(struct platform_device *pdev)
+static int __devexit smc911x_drv_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct smc911x_local *lp = netdev_priv(ndev);
@@ -2195,7 +2195,7 @@ static int smc911x_drv_resume(struct platform_device *dev)
 
 static struct platform_driver smc911x_driver = {
 	.probe		 = smc911x_drv_probe,
-	.remove	 = smc911x_drv_remove,
+	.remove	 = __devexit_p(smc911x_drv_remove),
 	.suspend	 = smc911x_drv_suspend,
 	.resume	 = smc911x_drv_resume,
 	.driver	 = {
diff --git a/drivers/net/smc91x.c b/drivers/net/smc91x.c
--- a/drivers/net/smc91x.c
+++ b/drivers/net/smc91x.c
@@ -1696,7 +1696,7 @@ static const struct ethtool_ops smc_ethtool_ops = {
  * I just deleted auto_irq.c, since it was never built...
  *   --jgarzik
  */
-static int __init smc_findirq(struct smc_local *lp)
+static int __devinit smc_findirq(struct smc_local *lp)
 {
 	void __iomem *ioaddr = lp->base;
 	int timeout = 20;
@@ -1770,7 +1770,7 @@ static int __init smc_findirq(struct smc_local *lp)
  * o  actually GRAB the irq.
  * o  GRAB the region
  */
-static int __init smc_probe(struct net_device *dev, void __iomem *ioaddr,
+static int __devinit smc_probe(struct net_device *dev, void __iomem *ioaddr,
 			    unsigned long irq_flags)
 {
 	struct smc_local *lp = netdev_priv(dev);
@@ -2126,7 +2126,7 @@ static void smc_release_datacs(struct platform_device *pdev, struct net_device *
  *	0 --> there is a device
  *	anything else, error
  */
-static int smc_drv_probe(struct platform_device *pdev)
+static int __devinit smc_drv_probe(struct platform_device *pdev)
 {
 	struct smc91x_platdata *pd = pdev->dev.platform_data;
 	struct smc_local *lp;
@@ -2240,7 +2240,7 @@ static int smc_drv_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int smc_drv_remove(struct platform_device *pdev)
+static int __devexit smc_drv_remove(struct platform_device *pdev)
 {
 	struct net_device *ndev = platform_get_drvdata(pdev);
 	struct smc_local *lp = netdev_priv(ndev);
@@ -2305,7 +2305,7 @@ static int smc_drv_resume(struct platform_device *dev)
 
 static struct platform_driver smc_driver = {
 	.probe		= smc_drv_probe,
-	.remove		= smc_drv_remove,
+	.remove		= __devexit_p(smc_drv_remove),
 	.suspend	= smc_drv_suspend,
 	.resume		= smc_drv_resume,
 	.driver		= {
