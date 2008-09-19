Return-Path: <linux-kernel-owner+w=401wt.eu-S1754510AbYISKjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510AbYISKjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753236AbYISKie
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:38:34 -0400
Received: from smtp.nokia.com ([192.100.122.230]:23466 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYISKic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:38:32 -0400
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 3/5] watchdog: cleanup a bit omap_wdt.c
Date: Fri, 19 Sep 2008 13:32:37 +0300
Message-Id: <1221820359-8943-4-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.0.1.308.gede4c
In-Reply-To: <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 19 Sep 2008 10:32:44.0670 (UTC) FILETIME=[0D6629E0:01C91A43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial cleanup patch.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
---
 drivers/watchdog/omap_wdt.c |  133 +++++++++++++++++++++++++-----------------
 1 files changed, 79 insertions(+), 54 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 4efb87b..b670ad5 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -71,11 +71,14 @@ struct omap_wdt_dev {
 static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 {
 	void __iomem    *base = wdev->base;
+
 	/* wait for posted write to complete */
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
+
 	wdt_trgr_pattern = ~wdt_trgr_pattern;
 	__raw_writel(wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
+
 	/* wait for posted write to complete */
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
@@ -84,12 +87,13 @@ static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 
 static void omap_wdt_enable(struct omap_wdt_dev *wdev)
 {
-	void __iomem *base;
-	base = wdev->base;
+	void __iomem *base = wdev->base;
+
 	/* Sequence to enable the watchdog */
 	__raw_writel(0xBBBB, base + OMAP_WATCHDOG_SPR);
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
+
 	__raw_writel(0x4444, base + OMAP_WATCHDOG_SPR);
 	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
@@ -97,12 +101,13 @@ static void omap_wdt_enable(struct omap_wdt_dev *wdev)
 
 static void omap_wdt_disable(struct omap_wdt_dev *wdev)
 {
-	void __iomem *base;
-	base = wdev->base;
+	void __iomem *base = wdev->base;
+
 	/* sequence required to disable watchdog */
 	__raw_writel(0xAAAA, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
+
 	__raw_writel(0x5555, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
@@ -120,12 +125,12 @@ static void omap_wdt_adjust_timeout(unsigned new_timeout)
 static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 {
 	u32 pre_margin = GET_WLDR_VAL(timer_margin);
-	void __iomem *base;
-	base = wdev->base;
+	void __iomem *base = wdev->base;
 
 	/* just count up at 32 KHz */
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
+
 	__raw_writel(pre_margin, base + OMAP_WATCHDOG_LDR);
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
@@ -134,13 +139,11 @@ static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 /*
  *	Allow only one task to hold it open
  */
-
 static int omap_wdt_open(struct inode *inode, struct file *file)
 {
-	struct omap_wdt_dev *wdev;
-	void __iomem *base;
-	wdev = platform_get_drvdata(omap_wdt_dev);
-	base = wdev->base;
+	struct omap_wdt_dev *wdev = platform_get_drvdata(omap_wdt_dev);
+	void __iomem *base = wdev->base;
+
 	if (test_and_set_bit(1, (unsigned long *)&(wdev->omap_wdt_users)))
 		return -EBUSY;
 
@@ -155,6 +158,7 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	/* initialize prescaler */
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
+
 	__raw_writel((1 << 5) | (PTV << 2), base + OMAP_WATCHDOG_CNTRL);
 	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
@@ -163,13 +167,14 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 
 	omap_wdt_set_timeout(wdev);
 	omap_wdt_enable(wdev);
+
 	return nonseekable_open(inode, file);
 }
 
 static int omap_wdt_release(struct inode *inode, struct file *file)
 {
-	struct omap_wdt_dev *wdev;
-	wdev = file->private_data;
+	struct omap_wdt_dev *wdev = file->private_data;
+
 	/*
 	 *      Shut off the timer unless NOWAYOUT is defined.
 	 */
@@ -188,14 +193,15 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 	printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
 #endif
 	wdev->omap_wdt_users = 0;
+
 	return 0;
 }
 
 static ssize_t omap_wdt_write(struct file *file, const char __user *data,
 		size_t len, loff_t *ppos)
 {
-	struct omap_wdt_dev *wdev;
-	wdev = file->private_data;
+	struct omap_wdt_dev *wdev = file->private_data;
+
 	/* Refresh LOAD_TIME. */
 	if (len) {
 		spin_lock(&wdt_lock);
@@ -215,6 +221,7 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 		.options = WDIOF_SETTIMEOUT,
 		.firmware_version = 0,
 	};
+
 	wdev = file->private_data;
 
 	switch (cmd) {
@@ -251,6 +258,7 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 	default:
 		return -ENOTTY;
 	}
+
 	return 0;
 }
 
@@ -262,31 +270,37 @@ static const struct file_operations omap_wdt_fops = {
 	.release = omap_wdt_release,
 };
 
-
 static int __init omap_wdt_probe(struct platform_device *pdev)
 {
 	struct resource *res, *mem;
-	int ret;
 	struct omap_wdt_dev *wdev;
+	int ret;
 
 	/* reserve static register mappings */
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res)
-		return -ENOENT;
+	if (!res) {
+		ret = -ENOENT;
+		goto err_get_resource;
+	}
 
-	if (omap_wdt_dev)
-		return -EBUSY;
+	if (omap_wdt_dev) {
+		ret - EBUSY;
+		goto err_busy;
+	}
 
 	mem = request_mem_region(res->start, res->end - res->start + 1,
 				 pdev->name);
-	if (mem == NULL)
-		return -EBUSY;
+	if (!mem) {
+		ret = -EBUSY;
+		goto err_busy;
+	}
 
 	wdev = kzalloc(sizeof(struct omap_wdt_dev), GFP_KERNEL);
 	if (!wdev) {
 		ret = -ENOMEM;
-		goto fail;
+		goto err_kzalloc;
 	}
+
 	wdev->omap_wdt_users = 0;
 	wdev->mem = mem;
 
@@ -295,7 +309,7 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 		if (IS_ERR(wdev->armwdt_ck)) {
 			ret = PTR_ERR(wdev->armwdt_ck);
 			wdev->armwdt_ck = NULL;
-			goto fail;
+			goto err_clk;
 		}
 	}
 
@@ -304,13 +318,13 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 		if (IS_ERR(wdev->mpu_wdt_ick)) {
 			ret = PTR_ERR(wdev->mpu_wdt_ick);
 			wdev->mpu_wdt_ick = NULL;
-			goto fail;
+			goto err_clk;
 		}
 		wdev->mpu_wdt_fck = clk_get(&pdev->dev, "mpu_wdt_fck");
 		if (IS_ERR(wdev->mpu_wdt_fck)) {
 			ret = PTR_ERR(wdev->mpu_wdt_fck);
 			wdev->mpu_wdt_fck = NULL;
-			goto fail;
+			goto err_clk;
 		}
 	}
 
@@ -319,19 +333,19 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 		if (IS_ERR(wdev->mpu_wdt_ick)) {
 			ret = PTR_ERR(wdev->mpu_wdt_ick);
 			wdev->mpu_wdt_ick = NULL;
-			goto fail;
+			goto err_clk;
 		}
 		wdev->mpu_wdt_fck = clk_get(&pdev->dev, "wdt2_fck");
 		if (IS_ERR(wdev->mpu_wdt_fck)) {
 			ret = PTR_ERR(wdev->mpu_wdt_fck);
 			wdev->mpu_wdt_fck = NULL;
-			goto fail;
+			goto err_clk;
 		}
 	}
 	wdev->base = ioremap(res->start, res->end - res->start + 1);
 	if (!wdev->base) {
 		ret = -ENOMEM;
-		goto fail;
+		goto err_ioremap;
 	}
 
 	platform_set_drvdata(pdev, wdev);
@@ -346,7 +360,7 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 
 	ret = misc_register(&(wdev->omap_wdt_miscdev));
 	if (ret)
-		goto fail;
+		goto err_misc;
 
 	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial timeout %d sec\n",
 		__raw_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
@@ -359,28 +373,34 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 
 	return 0;
 
-fail:
-	if (wdev) {
-		platform_set_drvdata(pdev, NULL);
-		if (wdev->armwdt_ck)
-			clk_put(wdev->armwdt_ck);
-		if (wdev->mpu_wdt_ick)
-			clk_put(wdev->mpu_wdt_ick);
-		if (wdev->mpu_wdt_fck)
-			clk_put(wdev->mpu_wdt_fck);
-		iounmap(wdev->base);
-		kfree(wdev);
-	}
-	if (mem) {
-		release_mem_region(res->start, res->end - res->start + 1);
-	}
+err_misc:
+	platform_set_drvdata(pdev, NULL);
+	iounmap(wdev->base);
+
+err_ioremap:
+	wdev->base = NULL;
+
+err_clk:
+	if (wdev->armwdt_ck)
+		clk_put(wdev->armwdt_ck);
+	if (wdev->mpu_wdt_ick)
+		clk_put(wdev->mpu_wdt_ick);
+	if (wdev->mpu_wdt_fck)
+		clk_put(wdev->mpu_wdt_fck);
+	kfree(wdev);
+
+err_kzalloc:
+	release_mem_region(res->start, res->end - res->start + 1);
+
+err_busy:
+err_get_resource:
+
 	return ret;
 }
 
 static void omap_wdt_shutdown(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev;
-	wdev = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 
 	if (wdev->omap_wdt_users)
 		omap_wdt_disable(wdev);
@@ -388,8 +408,7 @@ static void omap_wdt_shutdown(struct platform_device *pdev)
 
 static int omap_wdt_remove(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev;
-	wdev = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 	struct resource *res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	if (!res)
@@ -398,14 +417,17 @@ static int omap_wdt_remove(struct platform_device *pdev)
 	misc_deregister(&(wdev->omap_wdt_miscdev));
 	release_mem_region(res->start, res->end - res->start + 1);
 	platform_set_drvdata(pdev, NULL);
+
 	if (wdev->armwdt_ck) {
 		clk_put(wdev->armwdt_ck);
 		wdev->armwdt_ck = NULL;
 	}
+
 	if (wdev->mpu_wdt_ick) {
 		clk_put(wdev->mpu_wdt_ick);
 		wdev->mpu_wdt_ick = NULL;
 	}
+
 	if (wdev->mpu_wdt_fck) {
 		clk_put(wdev->mpu_wdt_fck);
 		wdev->mpu_wdt_fck = NULL;
@@ -414,6 +436,7 @@ static int omap_wdt_remove(struct platform_device *pdev)
 
 	kfree(wdev);
 	omap_wdt_dev = NULL;
+
 	return 0;
 }
 
@@ -427,21 +450,23 @@ static int omap_wdt_remove(struct platform_device *pdev)
 
 static int omap_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 {
-	struct omap_wdt_dev *wdev;
-	wdev = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+
 	if (wdev->omap_wdt_users)
 		omap_wdt_disable(wdev);
+
 	return 0;
 }
 
 static int omap_wdt_resume(struct platform_device *pdev)
 {
-	struct omap_wdt_dev *wdev;
-	wdev = platform_get_drvdata(pdev);
+	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
+
 	if (wdev->omap_wdt_users) {
 		omap_wdt_enable(wdev);
 		omap_wdt_ping(wdev);
 	}
+
 	return 0;
 }
 
-- 
1.6.0.1.308.gede4c

