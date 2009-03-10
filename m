Return-Path: <linux-kernel-owner+w=401wt.eu-S1756957AbZCJQG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957AbZCJQG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZCJQFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:05:20 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18907 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756732AbZCJQFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:05:18 -0400
From: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk,
       Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
Subject: [PATCH 1/6] Remove armwdt_ck field from omap_wdt_dev structure.
Date: Tue, 10 Mar 2009 18:03:51 +0200
Message-Id: <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1236701036-19942-1-git-send-email-ext-atal.shargorodsky@nokia.com>
References: <>
 <1236701036-19942-1-git-send-email-ext-atal.shargorodsky@nokia.com>
X-OriginalArrivalTime: 10 Mar 2009 16:04:33.0406 (UTC) FILETIME=[E6FB31E0:01C9A199]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need to hold three clocks, when for each paricular platform only
two are used - finctional and interface.

Signed-off-by: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
---
 drivers/watchdog/omap_wdt.c |   51 ++++++++++++------------------------------
 1 files changed, 15 insertions(+), 36 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index b04f650..5b72c7c 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -60,7 +60,6 @@ struct omap_wdt_dev {
 	void __iomem    *base;          /* physical */
 	struct device   *dev;
 	int             omap_wdt_users;
-	struct clk      *armwdt_ck;
 	struct clk      *mpu_wdt_ick;
 	struct clk      *mpu_wdt_fck;
 	struct resource *mem;
@@ -146,13 +145,10 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	if (test_and_set_bit(1, (unsigned long *)&(wdev->omap_wdt_users)))
 		return -EBUSY;
 
-	if (cpu_is_omap16xx())
-		clk_enable(wdev->armwdt_ck);	/* Enable the clock */
-
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+	if (cpu_is_omap24xx() || cpu_is_omap34xx())
 		clk_enable(wdev->mpu_wdt_ick);    /* Enable the interface clock */
-		clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
-	}
+
+	clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
 
 	/* initialize prescaler */
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
@@ -181,13 +177,10 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 
 	omap_wdt_disable(wdev);
 
-	if (cpu_is_omap16xx())
-		clk_disable(wdev->armwdt_ck);	/* Disable the clock */
-
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+	if (cpu_is_omap24xx() || cpu_is_omap34xx())
 		clk_disable(wdev->mpu_wdt_ick);	/* Disable the clock */
-		clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
-	}
+
+	clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
 #else
 	printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
 #endif
@@ -304,10 +297,10 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 	wdev->mem = mem;
 
 	if (cpu_is_omap16xx()) {
-		wdev->armwdt_ck = clk_get(&pdev->dev, "armwdt_ck");
-		if (IS_ERR(wdev->armwdt_ck)) {
-			ret = PTR_ERR(wdev->armwdt_ck);
-			wdev->armwdt_ck = NULL;
+		wdev->mpu_wdt_fck = clk_get(&pdev->dev, "armwdt_ck");
+		if (IS_ERR(wdev->mpu_wdt_fck)) {
+			ret = PTR_ERR(wdev->mpu_wdt_fck);
+			wdev->mpu_wdt_fck = NULL;
 			goto err_clk;
 		}
 	}
@@ -351,13 +344,10 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, wdev);
 
 	/* enable clocks for register access */
-	if (cpu_is_omap16xx())
-		clk_enable(wdev->armwdt_ck);	/* Enable the clock */
-
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+	if (cpu_is_omap24xx() || cpu_is_omap34xx())
 		clk_enable(wdev->mpu_wdt_ick);    /* Enable the interface clock */
-		clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
-	}
+
+	clk_enable(wdev->mpu_wdt_fck);    /* Enable the functional clock */
 
 	omap_wdt_disable(wdev);
 	omap_wdt_adjust_timeout(timer_margin);
@@ -379,13 +369,9 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 	__raw_writel(0x01, wdev->base + OMAP_WATCHDOG_SYS_CONFIG);
 
 	/* disable clocks since we don't need them now */
-	if (cpu_is_omap16xx())
-		clk_disable(wdev->armwdt_ck);	/* Disable the clock */
-
-	if (cpu_is_omap24xx() || cpu_is_omap34xx()) {
+	if (cpu_is_omap24xx() || cpu_is_omap34xx())
 		clk_disable(wdev->mpu_wdt_ick);	/* Disable the clock */
-		clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
-	}
+	clk_disable(wdev->mpu_wdt_fck);	/* Disable the clock */
 
 	omap_wdt_dev = pdev;
 
@@ -399,8 +385,6 @@ err_ioremap:
 	wdev->base = NULL;
 
 err_clk:
-	if (wdev->armwdt_ck)
-		clk_put(wdev->armwdt_ck);
 	if (wdev->mpu_wdt_ick)
 		clk_put(wdev->mpu_wdt_ick);
 	if (wdev->mpu_wdt_fck)
@@ -436,11 +420,6 @@ static int omap_wdt_remove(struct platform_device *pdev)
 	release_mem_region(res->start, res->end - res->start + 1);
 	platform_set_drvdata(pdev, NULL);
 
-	if (wdev->armwdt_ck) {
-		clk_put(wdev->armwdt_ck);
-		wdev->armwdt_ck = NULL;
-	}
-
 	if (wdev->mpu_wdt_ick) {
 		clk_put(wdev->mpu_wdt_ick);
 		wdev->mpu_wdt_ick = NULL;
-- 
1.5.4.3

