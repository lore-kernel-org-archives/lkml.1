Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbZHJQsM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbZHJQsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 12:48:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932211AbZHJQsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 12:48:12 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:2602 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbZHJQsK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 12:48:10 -0400
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Wim Van Sebroeck <wim@iguana.be>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH RT 8/6] [ARM, WATCHDOG] davinci: include mach/timex.h in davinci_wdt.c
References: <20090807203939.GA19374@pengutronix.de>
	<1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<1249810600-21946-2-git-send-email-u.kleine-koenig@pengutronix.de>
	<20090809094306.GA26591@n2100.arm.linux.org.uk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 10 Aug 2009 09:48:07 -0700
In-Reply-To: <20090809094306.GA26591@n2100.arm.linux.org.uk> (Russell King's message of "Sun\, 9 Aug 2009 10\:43\:06 +0100")
Message-ID: <87iqgvk43c.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Sun, Aug 09, 2009 at 11:36:39AM +0200, Uwe Kleine-König wrote:
>> This fixes a a build failure for 2.6.31-rc4-rt1 (ARCH=arm,
>> davinci_all_defconfig):
>> 
>> 	drivers/watchdog/davinci_wdt.c: In function 'wdt_enable':
>> 	drivers/watchdog/davinci_wdt.c:102: error: 'CLOCK_TICK_RATE' undeclared (first use in this function)
>> 	drivers/watchdog/davinci_wdt.c:102: error: (Each undeclared identifier is reported only once
>> 	drivers/watchdog/davinci_wdt.c:102: error: for each function it appears in.)
>
> It should not be using CLOCK_TICK_RATE - there was a move to clean
> up the use of that symbol and restrict it just to the i8253 PIT.
> Please create something else like DAVINCI_TICK_RATE instead.

Actually, I have an alternate fix for this which I was planning to
submit for 2.6.32.  This one drops CLOCK_TICK_RATE and uses the clock
framework to get the right tick frequency.

Here it is.

Kevin

>From 6eea62609126739ce03e447c5fca49269ad5d12a Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Tue, 10 Feb 2009 20:30:37 -0800
Subject: [PATCH] watchdog: davinci: use clock framework for timer frequency

Remove use of CLOCK_TICK_RATE in favor of using clock framework
for getting timer frequency.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/watchdog/davinci_wdt.c |   21 +++++++++++++++++++--
 1 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 83e22e7..5ed89e4 100644
--- a/drivers/watchdog/davinci_wdt.c
+++ b/drivers/watchdog/davinci_wdt.c
@@ -25,6 +25,7 @@
 #include <linux/uaccess.h>
 #include <linux/io.h>
 #include <linux/device.h>
+#include <linux/clk.h>
 
 #define MODULE_NAME "DAVINCI-WDT: "
 
@@ -69,6 +70,7 @@ static unsigned long wdt_status;
 
 static struct resource	*wdt_mem;
 static void __iomem	*wdt_base;
+struct clk              *wdt_clk;
 
 static void wdt_service(void)
 {
@@ -86,6 +88,10 @@ static void wdt_enable(void)
 {
 	u32 tgcr;
 	u32 timer_margin;
+	u32 wdt_freq;
+
+	BUG_ON(!wdt_clk);
+	wdt_freq = clk_get_rate(wdt_clk);
 
 	spin_lock(&io_lock);
 
@@ -99,9 +105,9 @@ static void wdt_enable(void)
 	iowrite32(0, wdt_base + TIM12);
 	iowrite32(0, wdt_base + TIM34);
 	/* set timeout period */
-	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
+	timer_margin = (((u64)heartbeat * wdt_freq) & 0xffffffff);
 	iowrite32(timer_margin, wdt_base + PRD12);
-	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
+	timer_margin = (((u64)heartbeat * wdt_freq) >> 32);
 	iowrite32(timer_margin, wdt_base + PRD34);
 	/* enable run continuously */
 	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
@@ -199,6 +205,11 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct device *dev = &pdev->dev;
 
+	wdt_clk = clk_get(dev, NULL);
+	if (WARN_ON(!wdt_clk))
+		return -ENODEV;
+	clk_enable(wdt_clk);
+
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
@@ -245,6 +256,12 @@ static int __devexit davinci_wdt_remove(struct platform_device *pdev)
 		kfree(wdt_mem);
 		wdt_mem = NULL;
 	}
+
+	if (wdt_clk) {
+		clk_disable(wdt_clk);
+		clk_put(wdt_clk);
+	}
+
 	return 0;
 }
 
-- 
1.6.3.3

