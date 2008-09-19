Return-Path: <linux-kernel-owner+w=401wt.eu-S1754839AbYISKiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839AbYISKiw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 06:38:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751410AbYISKiZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 06:38:25 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42431 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbYISKiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 06:38:23 -0400
From: Felipe Balbi <felipe.balbi@nokia.com>
To: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Wim Van Sebroeck <wim@iguana.be>,
       Andrew Morton <akpm@linux-foundation.org>,
       "George G. Davis" <gdavis@mvista.com>,
       Felipe Balbi <felipe.balbi@nokia.com>
Subject: [PATCH 2/5] watchdog: another ioremap() fix
Date: Fri, 19 Sep 2008 13:32:36 +0300
Message-Id: <1221820359-8943-3-git-send-email-felipe.balbi@nokia.com>
X-Mailer: git-send-email 1.6.0.1.308.gede4c
In-Reply-To: <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
References: <1221820359-8943-1-git-send-email-felipe.balbi@nokia.com>
 <1221820359-8943-2-git-send-email-felipe.balbi@nokia.com>
X-OriginalArrivalTime: 19 Sep 2008 10:32:44.0639 (UTC) FILETIME=[0D616EF0:01C91A43]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

convert to use ioremap() and __raw_{read/write} friends.

Signed-off-by: Felipe Balbi <felipe.balbi@nokia.com>
Signed-off-by: George G. Davis <gdavis@mvista.com>
Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
---
 drivers/watchdog/omap_wdt.c |   50 +++++++++++++++++++++++++------------------
 1 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/drivers/watchdog/omap_wdt.c b/drivers/watchdog/omap_wdt.c
index e55f2cc..4efb87b 100644
--- a/drivers/watchdog/omap_wdt.c
+++ b/drivers/watchdog/omap_wdt.c
@@ -72,12 +72,12 @@ static void omap_wdt_ping(struct omap_wdt_dev *wdev)
 {
 	void __iomem    *base = wdev->base;
 	/* wait for posted write to complete */
-	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
+	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 	wdt_trgr_pattern = ~wdt_trgr_pattern;
-	omap_writel(wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
+	__raw_writel(wdt_trgr_pattern, (base + OMAP_WATCHDOG_TGR));
 	/* wait for posted write to complete */
-	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
+	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x08)
 		cpu_relax();
 	/* reloaded WCRR from WLDR */
 }
@@ -87,11 +87,11 @@ static void omap_wdt_enable(struct omap_wdt_dev *wdev)
 	void __iomem *base;
 	base = wdev->base;
 	/* Sequence to enable the watchdog */
-	omap_writel(0xBBBB, base + OMAP_WATCHDOG_SPR);
-	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
+	__raw_writel(0xBBBB, base + OMAP_WATCHDOG_SPR);
+	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
-	omap_writel(0x4444, base + OMAP_WATCHDOG_SPR);
-	while ((omap_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
+	__raw_writel(0x4444, base + OMAP_WATCHDOG_SPR);
+	while ((__raw_readl(base + OMAP_WATCHDOG_WPS)) & 0x10)
 		cpu_relax();
 }
 
@@ -100,11 +100,11 @@ static void omap_wdt_disable(struct omap_wdt_dev *wdev)
 	void __iomem *base;
 	base = wdev->base;
 	/* sequence required to disable watchdog */
-	omap_writel(0xAAAA, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
-	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
+	__raw_writel(0xAAAA, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
+	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
-	omap_writel(0x5555, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
-	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
+	__raw_writel(0x5555, base + OMAP_WATCHDOG_SPR);	/* TIMER_MODE */
+	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x10)
 		cpu_relax();
 }
 
@@ -124,10 +124,10 @@ static void omap_wdt_set_timeout(struct omap_wdt_dev *wdev)
 	base = wdev->base;
 
 	/* just count up at 32 KHz */
-	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
+	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
-	omap_writel(pre_margin, base + OMAP_WATCHDOG_LDR);
-	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
+	__raw_writel(pre_margin, base + OMAP_WATCHDOG_LDR);
+	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x04)
 		cpu_relax();
 }
 
@@ -153,10 +153,10 @@ static int omap_wdt_open(struct inode *inode, struct file *file)
 	}
 
 	/* initialize prescaler */
-	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
+	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
-	omap_writel((1 << 5) | (PTV << 2), base + OMAP_WATCHDOG_CNTRL);
-	while (omap_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
+	__raw_writel((1 << 5) | (PTV << 2), base + OMAP_WATCHDOG_CNTRL);
+	while (__raw_readl(base + OMAP_WATCHDOG_WPS) & 0x01)
 		cpu_relax();
 
 	file->private_data = (void *) wdev;
@@ -225,7 +225,7 @@ static long omap_wdt_ioctl(struct file *file, unsigned int cmd,
 		return put_user(0, (int __user *)arg);
 	case WDIOC_GETBOOTSTATUS:
 		if (cpu_is_omap16xx())
-			return put_user(omap_readw(ARM_SYSST),
+			return put_user(__raw_readw(ARM_SYSST),
 					(int __user *)arg);
 		if (cpu_is_omap24xx())
 			return put_user(omap_prcm_get_reset_sources(),
@@ -328,7 +328,12 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 			goto fail;
 		}
 	}
-	wdev->base = (void __iomem *) (mem->start);
+	wdev->base = ioremap(res->start, res->end - res->start + 1);
+	if (!wdev->base) {
+		ret = -ENOMEM;
+		goto fail;
+	}
+
 	platform_set_drvdata(pdev, wdev);
 
 	omap_wdt_disable(wdev);
@@ -344,11 +349,11 @@ static int __init omap_wdt_probe(struct platform_device *pdev)
 		goto fail;
 
 	pr_info("OMAP Watchdog Timer Rev 0x%02x: initial timeout %d sec\n",
-		omap_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
+		__raw_readl(wdev->base + OMAP_WATCHDOG_REV) & 0xFF,
 		timer_margin);
 
 	/* autogate OCP interface clock */
-	omap_writel(0x01, wdev->base + OMAP_WATCHDOG_SYS_CONFIG);
+	__raw_writel(0x01, wdev->base + OMAP_WATCHDOG_SYS_CONFIG);
 
 	omap_wdt_dev = pdev;
 
@@ -363,6 +368,7 @@ fail:
 			clk_put(wdev->mpu_wdt_ick);
 		if (wdev->mpu_wdt_fck)
 			clk_put(wdev->mpu_wdt_fck);
+		iounmap(wdev->base);
 		kfree(wdev);
 	}
 	if (mem) {
@@ -404,6 +410,8 @@ static int omap_wdt_remove(struct platform_device *pdev)
 		clk_put(wdev->mpu_wdt_fck);
 		wdev->mpu_wdt_fck = NULL;
 	}
+	iounmap(wdev->base);
+
 	kfree(wdev);
 	omap_wdt_dev = NULL;
 	return 0;
-- 
1.6.0.1.308.gede4c

