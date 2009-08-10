Return-Path: <linux-kernel-owner+w=401wt.eu-S932348AbZHJR1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348AbZHJR1B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 13:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932242AbZHJR1B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 13:27:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52904 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932220AbZHJR07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 13:26:59 -0400
Date: Mon, 10 Aug 2009 18:26:38 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Wim Van Sebroeck <wim@iguana.be>,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH RT 8/6] [ARM, WATCHDOG] davinci: include mach/timex.h
	in davinci_wdt.c
Message-ID: <20090810172637.GC27147@n2100.arm.linux.org.uk>
References: <20090807203939.GA19374@pengutronix.de> <1249810600-21946-1-git-send-email-u.kleine-koenig@pengutronix.de> <1249810600-21946-2-git-send-email-u.kleine-koenig@pengutronix.de> <20090809094306.GA26591@n2100.arm.linux.org.uk> <87iqgvk43c.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqgvk43c.fsf@deeprootsystems.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 09:48:07AM -0700, Kevin Hilman wrote:
> diff --git a/drivers/watchdog/davinci_wdt.c b/drivers/watchdog/davinci_wdt.c
> index 83e22e7..5ed89e4 100644
> --- a/drivers/watchdog/davinci_wdt.c
> +++ b/drivers/watchdog/davinci_wdt.c
> @@ -25,6 +25,7 @@
>  #include <linux/uaccess.h>
>  #include <linux/io.h>
>  #include <linux/device.h>
> +#include <linux/clk.h>
>  
>  #define MODULE_NAME "DAVINCI-WDT: "
>  
> @@ -69,6 +70,7 @@ static unsigned long wdt_status;
>  
>  static struct resource	*wdt_mem;
>  static void __iomem	*wdt_base;
> +struct clk              *wdt_clk;

Why the random spacing?

>  
>  static void wdt_service(void)
>  {
> @@ -86,6 +88,10 @@ static void wdt_enable(void)
>  {
>  	u32 tgcr;
>  	u32 timer_margin;
> +	u32 wdt_freq;
> +
> +	BUG_ON(!wdt_clk);

BUG_ON here is not required (and wrong).

> +	wdt_freq = clk_get_rate(wdt_clk);
>  
>  	spin_lock(&io_lock);
>  
> @@ -99,9 +105,9 @@ static void wdt_enable(void)
>  	iowrite32(0, wdt_base + TIM12);
>  	iowrite32(0, wdt_base + TIM34);
>  	/* set timeout period */
> -	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) & 0xffffffff);
> +	timer_margin = (((u64)heartbeat * wdt_freq) & 0xffffffff);
>  	iowrite32(timer_margin, wdt_base + PRD12);
> -	timer_margin = (((u64)heartbeat * CLOCK_TICK_RATE) >> 32);
> +	timer_margin = (((u64)heartbeat * wdt_freq) >> 32);
>  	iowrite32(timer_margin, wdt_base + PRD34);
>  	/* enable run continuously */
>  	iowrite32(ENAMODE12_PERIODIC, wdt_base + TCR);
> @@ -199,6 +205,11 @@ static int __devinit davinci_wdt_probe(struct platform_device *pdev)
>  	struct resource *res;
>  	struct device *dev = &pdev->dev;
>  
> +	wdt_clk = clk_get(dev, NULL);
> +	if (WARN_ON(!wdt_clk))
> +		return -ENODEV;

	if (WARN_ON(IS_ERR(wdt_clk)))
		return PTR_ERR(wdt_clk);

> +	clk_enable(wdt_clk);
> +
>  	if (heartbeat < 1 || heartbeat > MAX_HEARTBEAT)
>  		heartbeat = DEFAULT_HEARTBEAT;
>  
> @@ -245,6 +256,12 @@ static int __devexit davinci_wdt_remove(struct platform_device *pdev)
>  		kfree(wdt_mem);
>  		wdt_mem = NULL;
>  	}
> +
> +	if (wdt_clk) {

NULL check is not required.

> +		clk_disable(wdt_clk);
> +		clk_put(wdt_clk);
> +	}
> +
>  	return 0;
>  }
>  
> -- 
> 1.6.3.3
> 
