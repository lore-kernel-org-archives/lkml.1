Return-Path: <linux-kernel-owner+w=401wt.eu-S1759572AbZBES1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572AbZBES1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 13:27:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752698AbZBES1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 13:27:41 -0500
Received: from el-out-1112.google.com ([209.85.162.180]:32804 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbZBES1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 13:27:41 -0500
To: felipe.balbi@nokia.com
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "wim\@iguana.be" <wim@iguana.be>
Subject: Re: [PATCH] watchdog: davinci: convert to ioremap() + io[read|write]
References: <1233854782-3642-1-git-send-email-khilman@deeprootsystems.com>
	<20090205173810.GE10567@scadufax.research.nokia.com>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Thu, 05 Feb 2009 10:27:35 -0800
In-Reply-To: <20090205173810.GE10567@scadufax.research.nokia.com> (Felipe Balbi's message of "Thu\, 5 Feb 2009 19\:38\:10 +0200")
Message-ID: <87myd04u3s.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Balbi <felipe.balbi@nokia.com> writes:

> On Thu, Feb 05, 2009 at 06:26:22PM +0100, Kevin Hilman wrote:
>> +       wdt_base = ioremap(res->start, res->end);
>
> second argument should be size right ??
>
> ioremap(res->start, res->end - res->start + 1);
>
> in fact you have a size variable in this driver used for
> request_mem_region() just be sure the value is still valid and use it
> ;-)
>
>> +       if (!wdt_base) {
>> +               printk(KERN_ERR MODULE_NAME "failed to map memory region\n");
>
> you have a dev pointer in platform_device would be cool
> to use dev_err() here

OK, below is updated version.

Kevin

--------------------------------------------------------------------------

commit ac1e6e73c1d7e08a64eb6d2053280be48438223d
Author: Kevin Hilman <khilman@deeprootsystems.com>
Date:   Thu Jan 29 14:14:30 2009 -0800

    watchdog: davinci: convert to ioremap() + io[read|write]
    
    Remove davinci platform-specific IO accessor macros in favor
    of standard ioremap + io[read|write]* functions.
    
    Also, convert printk(KERN_ERR ....) into dev_err(...)
    
    Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 2e13602..c51d0b0 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -24,7 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/uaccess.h>
 #include <linux/io.h>
-#include <mach/hardware.h>
+#include <linux/device.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
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
@@ -197,17 +197,16 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 {
 	int ret = 0, size;
 	struct resource *res;
+	struct device *dev = &pdev->dev;
 
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
-	printk(KERN_INFO MODULE_NAME
-		"DaVinci Watchdog Timer: heartbeat %d sec\n", heartbeat);
+	dev_info(dev, "heartbeat %d sec\n", heartbeat);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
-		printk(KERN_INFO MODULE_NAME
-			"failed to get memory region resource\n");
+		dev_err(dev, "failed to get memory region resource\n");
 		return -ENOENT;
 	}
 
@@ -215,20 +214,26 @@ static int davinci_wdt_probe(struct platform_device *pdev)
 	wdt_mem = request_mem_region(res->start, size, pdev->name);
 
 	if (wdt_mem == NULL) {
-		printk(KERN_INFO MODULE_NAME "failed to get memory region\n");
+		dev_err(dev, "failed to get memory region\n");
 		return -ENOENT;
 	}
-	wdt_base = (void __iomem *)(res->start);
+
+	wdt_base = ioremap(res->start, size);
+	if (!wdt_base) {
+		dev_err(dev, "failed to map memory region\n");
+		return -ENOMEM;
+	}
 
 	ret = misc_register(&davinci_wdt_miscdev);
 	if (ret < 0) {
-		printk(KERN_ERR MODULE_NAME "cannot register misc device\n");
+		dev_err(dev, "cannot register misc device\n");
 		release_resource(wdt_mem);
 		kfree(wdt_mem);
 	} else {
 		set_bit(WDT_DEVICE_INITED, &wdt_status);
 	}
 
+	iounmap(wdt_base);
 	return ret;
 }
 
