Return-Path: <linux-kernel-owner+w=401wt.eu-S1753860AbZHJVEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860AbZHJVEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 17:04:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753830AbZHJVEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 17:04:35 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:58956 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbZHJVEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 17:04:34 -0400
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
	<87iqgvk43c.fsf@deeprootsystems.com>
	<20090810172637.GC27147@n2100.arm.linux.org.uk>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 10 Aug 2009 14:04:31 -0700
Message-ID: <87zla7fkio.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux <linux@arm.linux.org.uk> writes:

> On Mon, Aug 10, 2009 at 09:48:07AM -0700, Kevin Hilman wrote:
>> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
>> index 83e22e7..5ed89e4 100644
>> --- a/drivers/watchdog/davinci_wdt.c
>> +++ b/drivers/watchdog/davinci_wdt.c
>> @@ -25,6 +25,7 @@
>>  #include <linux/uaccess.h>
>>  #include <linux/io.h>
>>  #include <linux/device.h>
>> +#include <linux/clk.h>
>>  
>>  #define MODULE_NAME "DAVINCI-WDT: "
>>  
>> @@ -69,6 +70,7 @@ static unsigned long wdt_status;
>>  
>>  static struct resource	*wdt_mem;
>>  static void __iomem	*wdt_base;
>> +struct clk              *wdt_clk;
>
> Why the random spacing?

oops, not tabified.

>>  
>>  static void wdt_service(void)
>>  {
>> @@ -86,6 +88,10 @@ static void wdt_enable(void)
>>  {
>>  	u32 tgcr;
>>  	u32 timer_margin;
>> +	u32 wdt_freq;
>> +
>> +	BUG_ON(!wdt_clk);
>
> BUG_ON here is not required (and wrong).

removed.

>> +	wdt_freq = clk_get_rate(wdt_clk);
>>  
>>  	spin_lock(&io_lock);
>>  
>> @@ -99,9 +105,9 @@ static void wdt_enable(void)
>>  	iowrite32(0, wdt_base + TIM12);
>>  	iowrite32(0, wdt_base + TIM34);
>>  	/* set timeout period */
>> -	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
>> +	timer_margin = (((u64)heartbeat * wdt_freq) & 0xffffffff);
>>  	iowrite32(timer_margin, wdt_base + PRD12);
>> -	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
>> +	timer_margin = (((u64)heartbeat * wdt_freq) >> 32);
>>  	iowrite32(timer_margin, wdt_base + PRD34);
>>  	/* enable run continuously */
>>  	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
>> @@ -199,6 +205,11 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
>>  	struct resource *res;
>>  	struct device *dev = &pdev->dev;
>>  
>> +	wdt_clk = clk_get(dev, NULL);
>> +	if (WARN_ON(!wdt_clk))
>> +		return -ENODEV;
>
> 	if (WARN_ON(IS_ERR(wdt_clk)))
> 		return PTR_ERR(wdt_clk);

fixed.

>> +	clk_enable(wdt_clk);
>> +
>>  	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
>>  		heartbeat = DEFAULT_HEARTBEAT;
>>  
>> @@ -245,6 +256,12 @@ static int __devexit davinci_wdt_remove(struct platform_device *pdev)
>>  		kfree(wdt_mem);
>>  		wdt_mem = NULL;
>>  	}
>> +
>> +	if (wdt_clk) {
>
> NULL check is not required.

removed.

>> +		clk_disable(wdt_clk);
>> +		clk_put(wdt_clk);
>> +	}
>> +
>>  	return 0;
>>  }
>>  
>> -- 


Updated version:

>From c7b99413b5323a5f7faa00e86d623b0711fcd0d0 Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@deeprootsystems.com>
Date: Tue, 10 Feb 2009 20:30:37 -0800
Subject: [PATCH] watchdog: davinci: use clock framework for timer frequency

Remove use of CLOCK_TICK_RATE in favor of using clock framework
for getting timer frequency.

Signed-off-by: Kevin Hilman <khilman@deeprootsystems.com>
---
 drivers/watchdog/davinci_wdt.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
index 83e22e7..43c42f5 100644
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
+struct clk		*wdt_clk;
 
 static void wdt_service(void)
 {
@@ -86,6 +88,9 @@ static void wdt_enable(void)
 {
 	u32 tgcr;
 	u32 timer_margin;
+	u32 wdt_freq;
+
+	wdt_freq = clk_get_rate(wdt_clk);
 
 	spin_lock(&io_lock);
 
@@ -99,9 +104,9 @@ static void wdt_enable(void)
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
@@ -199,6 +204,12 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
 	struct resource *res;
 	struct device *dev = &pdev->dev;
 
+	wdt_clk = clk_get(dev, NULL);
+	if (WARN_ON(IS_ERR(wdt_clk)))
+		return PTR_ERR(wdt_clk);
+
+	clk_enable(wdt_clk);
+
 	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
 		heartbeat = DEFAULT_HEARTBEAT;
 
@@ -245,6 +256,10 @@ static int __devexit davinci_wdt_remove(struct platform_device *pdev)
 		kfree(wdt_mem);
 		wdt_mem = NULL;
 	}
+
+	clk_disable(wdt_clk);
+	clk_put(wdt_clk);
+
 	return 0;
 }
 
-- 
1.6.3.3

