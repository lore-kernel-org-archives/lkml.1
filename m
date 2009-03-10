Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZCJQH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZCJQH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 12:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756771AbZCJQF2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 12:05:28 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18933 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789AbZCJQF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 12:05:26 -0400
From: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux@arm.linux.org.uk,
       Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
Subject: [PATCH 6/6] Changing NOWAYOUT behavior does not require kernel reconfiguration.
Date: Tue, 10 Mar 2009 18:03:56 +0200
Message-Id: <8978e7baa400a1c447914b83e17ced5313dce734.1236609434.git.ext-atal.shargorodsky@nokia.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <6bfd4bd0c37668c409e3c2154ba2ab22c8a42800.1236609434.git.ext-atal.shargorodsky@nokia.com>
References: <>
 <1236701036-19942-1-git-send-email-ext-atal.shargorodsky@nokia.com>
 <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
 <0fe7f2934f8416e9b5f05e2f18766362560116ee.1236609434.git.ext-atal.shargorodsky@nokia.com>
 <7992fd993e5b420f9c2aac55f6e674169b36c666.1236609434.git.ext-atal.shargorodsky@nokia.com>
 <0db69821a1be58e0b8889609ff2b2ee272aa3286.1236609434.git.ext-atal.shargorodsky@nokia.com>
 <6bfd4bd0c37668c409e3c2154ba2ab22c8a42800.1236609434.git.ext-atal.shargorodsky@nokia.com>
In-Reply-To: <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
References: <cbbca1e42421e2ada459f0c0881f087977e34eed.1236609434.git.ext-atal.shargorodsky@nokia.com>
X-OriginalArrivalTime: 10 Mar 2009 16:04:40.0984 (UTC) FILETIME=[EB7F8180:01C9A199]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By introducing additional module parameter we make the
CONFIG_WATCHDOG_NOWAYOUT to be a mere default module behavior,
which can be overriden by providing nowayout=[01] parameter at load time.

Signed-off-by: Atal Shargorodsky <ext-atal.shargorodsky@nokia.com>
---
 drivers/watchdog/omap_wdt.c |   48 +++++++++++++++++++++++-------------------
 1 files changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index 6f6a524..6e9617c 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -53,6 +53,13 @@ static unsigned timer_margin;
 module_param(timer_margin, uint, 0);
 MODULE_PARM_DESC(timer_margin, "initial watchdog timeout (in seconds)");
 
+static int nowayout = WATCHDOG_NOWAYOUT;
+module_param(nowayout, int, 0);
+MODULE_PARM_DESC(nowayout,
+	"Watchdog cannot be stopped once started (default="
+		__MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
+
+
 static unsigned int wdt_trgr_pattern = 0x1234;
 static spinlock_t wdt_lock;
 
@@ -188,22 +195,20 @@ static int omap_wdt_release(struct inode *inode, struct file *file)
 {
 	struct omap_wdt_dev *wdev = file->private_data;
 
-	/*
-	 *      Shut off the timer unless NOWAYOUT is defined.
-	 */
-#ifndef CONFIG_WATCHDOG_NOWAYOUT
-
 	omap_wdt_ick_enable(wdev->mpu_wdt_ick, 1);
-	omap_wdt_disable(wdev);
-	omap_wdt_ick_enable(wdev->mpu_wdt_ick, 0);
+	if (nowayout) {
+		/* Give the user application some time to recover 
+		* in case of crash. 
+		* */
+		omap_wdt_ping(wdev);
+		printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
+	} else {
+		omap_wdt_disable(wdev);
 
-	clk_disable(wdev->mpu_wdt_fck);
-	wdev->omap_wdt_state &= ~(1 << OMAP_WDT_STATE_ACTIVATED_BIT);
-#else
-	/* Give the user application some time to recover in case of crash. */
-	omap_wdt_ping(wdev);
-	printk(KERN_CRIT "omap_wdt: Unexpected close, not stopping!\n");
-#endif
+		clk_disable(wdev->mpu_wdt_fck);
+		wdev->omap_wdt_state &= ~(1 << OMAP_WDT_STATE_ACTIVATED_BIT);
+	}
+	omap_wdt_ick_enable(wdev->mpu_wdt_ick, 0);
 	wdev->omap_wdt_state &= ~(1 << OMAP_WDT_STATE_OPENED_BIT);
 
 	return 0;
@@ -385,9 +390,10 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_misc;
 
-	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial timeout %d sec\n",
+	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial "
+		"timeout %d sec, nowayout is %s\n",
 		__raw_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
-		timer_margin);
+		timer_margin, (nowayout ? "on" : "off"));
 
 	/* autogate OCP interface clock */
 	__raw_writel(0x01, wdev->base + OMAP_WATCHDOG_SYS_CONFIG);
@@ -467,12 +473,6 @@ static int omap_wdt_remove(struct platform_device *pdev)
 
 #ifdef	CONFIG_PM
 
-/* REVISIT ... not clear this is the best way to handle system suspend; and
- * it's very inappropriate for selective device suspend (e.g. suspending this
- * through sysfs rather than by stopping the watchdog daemon).  Also, this
- * may not play well enough with NOWAYOUT...
- */
-
 static int omap_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 {
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
@@ -481,6 +481,8 @@ static int omap_wdt_suspend(struct platform_device *pdev, pm_message_t state)
 		omap_wdt_ick_enable(wdev->mpu_wdt_ick, 1);
 		omap_wdt_disable(wdev);
 		omap_wdt_ick_enable(wdev->mpu_wdt_ick, 0);
+		clk_disable(wdev->mpu_wdt_fck);
+printk (KERN_EMERG "omap_wdt: suspend \n");
 	}
 
 	return 0;
@@ -491,10 +493,12 @@ static int omap_wdt_resume(struct platform_device *pdev)
 	struct omap_wdt_dev *wdev = platform_get_drvdata(pdev);
 
 	if (wdev->omap_wdt_state & (1<<OMAP_WDT_STATE_ACTIVATED_BIT)) {
+		clk_enable(wdev->mpu_wdt_fck);
 		omap_wdt_ick_enable(wdev->mpu_wdt_ick, 1);
 		omap_wdt_enable(wdev);
 		omap_wdt_ping(wdev);
 		omap_wdt_ick_enable(wdev->mpu_wdt_ick, 0);
+printk (KERN_EMERG "omap_wdt: resume\n");
 	}
 
 	return 0;
-- 
1.5.4.3

