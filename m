Return-Path: <linux-kernel-owner+w=401wt.eu-S1759797AbZBER0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759797AbZBER0m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 12:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753962AbZBER03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 12:26:29 -0500
Received: from rn-out-0910.google.com ([64.233.170.187]:16022 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933AbZBER02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 12:26:28 -0500
From: Kevin Hilman <khilman@deeprootsystems.com>
To: linux-kernel@vger.kernel.org
Cc: wim@iguana.be, Kevin Hilman <khilman@deeprootsystems.com>
Subject: [PATCH] watchdog: davinci: convert to ioremap() + io[read|write]
Date: Thu,  5 Feb 2009 09:26:22 -0800
Message-Id: <1233854782-3642-1-git-send-email-khilman@deeprootsystems.com>
X-Mailer: git-send-email 1.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove davinci platform-specific IO accessor macros in favor
of standard ioremap + io[read|write]* functions.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/watchdog/davinci_wdt.c |   32 +++++++++++++++++++-------------
 1 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 2e13602..a9e5812 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -75,9 +75,9 @@ static void wdt_service(void)
 	spin_lock(&io_lock);
 
 	/* put watchdog in service state */
-	davinci_writel(WDKEY_SEQ0, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ0, wdt_base + WDTCR);
 	/* put watchdog in active state */
-	davinci_writel(WDKEY_SEQ1, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ1, wdt_base + WDTCR);
 
 	spin_unlock(&io_lock);
 }
@@ -90,29 +90,29 @@ static void wdt_enable(void)
 	spin_lock(&io_lock);
 
 	/* disable, internal clock source */
-	davinci_writel(0, wdt_base + TCR);
+	iowrite32(0, wdt_base + TCR);
 	/* reset timer, set mode to 64-bit watchdog, and unreset */
-	davinci_writel(0, wdt_base + TGCR);
+	iowrite32(0, wdt_base + TGCR);
 	tgcr = TIMMODE_64BIT_WDOG | TIM12RS_UNRESET | TIM34RS_UNRESET;
-	davinci_writel(tgcr, wdt_base + TGCR);
+	iowrite32(tgcr, wdt_base + TGCR);
 	/* clear counter regs */
-	davinci_writel(0, wdt_base + TIM12);
-	davinci_writel(0, wdt_base + TIM34);
+	iowrite32(0, wdt_base + TIM12);
+	iowrite32(0, wdt_base + TIM34);
 	/* set timeout period */
 	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
-	davinci_writel(timer_margin, wdt_base + PRD12);
+	iowrite32(timer_margin, wdt_base + PRD12);
 	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
-	davinci_writel(timer_margin, wdt_base + PRD34);
+	iowrite32(timer_margin, wdt_base + PRD34);
 	/* enable run continuously */
-	davinci_writel(ENAMODE12_PERIODIC, wdt_base + TCR);
+	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
 	/* Once the WDT is in pre-active state write to
 	 * TIM12, TIM34, PRD12, PRD34, TCR, TGCR, WDTCR are
 	 * write protected (except for the WDKEY field)
 	 */
 	/* put watchdog in pre-active state */
-	davinci_writel(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ0 | WDEN, wdt_base + WDTCR);
 	/* put watchdog in active state */
-	davinci_writel(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
+	iowrite32(WDKEY_SEQ1 | WDEN, wdt_base + WDTCR);
 
 	spin_unlock(&io_lock);
 }
@@ -218,7 +218,12 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
 		return -ENOENT;
 	}
-	wdt_base = (void __iomem *)(res->start);
+
+	wdt_base = ioremap(res->start, res->end);
+	if (!wdt_base) {
+		printk(KERN_ERR MODULE_NAME "failed to map memory region\n");
+		return -ENOMEM;
+	}
 
 	ret = misc_register(&davinci_wdt_miscdev);
 	if (ret < 0) {
@@ -229,6 +234,7 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 		set_bit(WDT_DEVICE_INITED, &wdt_status);
 	}
 
+	iounmap(wdt_base);
 	return ret;
 }
 
-- 
1.6.1

