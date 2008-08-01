Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbYHAQAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbYHAQAg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:00:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYHAQA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:00:28 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:59707 "EHLO
	VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208AbYHAQA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:00:27 -0400
X-BigFish: VPS-17(zz1432R98dR936eQ1805M655Ozz10d3izzz32i6bh8ah87il43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4XJ4A-03-OD4-01
Date: Fri, 1 Aug 2008 10:00:26 -0600
From: Jordan Crouse <jordan.crouse@amd.com>
To: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>
CC: Andres Salomon <dilinger@debian.org>, linux-geode@bombadil.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: MFGPT driver inhibits boot on some boards
Message-ID: <20080801160026.GB19184@cosmic.amd.com>
References: <48916864.901@LiPPERTEmbedded.de> <20080731143635.GA12585@cosmic.amd.com> <48932ACD.3080805@LiPPERTEmbedded.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <48932ACD.3080805@LiPPERTEmbedded.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 01 Aug 2008 16:00:07.0783 (UTC) FILETIME=[AB5D9770:01C8F3EF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/08 17:25 +0200, Jens Rottmann wrote:
> mfgpt: check IRQ before using MFGPT as clocksource
> 
> Adds a simple IRQ autodetection to the AMD Geode MFGPT driver, and more
> importantly, adds some checks, if IRQs can actually be received on the
> chosen line.  This fixes cases where MFGPT is selected as clocksource
> though not producing any ticks, so the kernel simply starves during
> boot.
> 
> Signed-off-by: Jens Rottmann <JRottmann@LiPPERTEmbedded.de>

One comment below - otherwise, I reviewed it and it looks good, but 
I haven't tried it.

Jordan

> ---
> 
> --- linux-2.6.26/include/asm-x86/geode.h
> +++ mfgpt-irq-fix/include/asm-x86/geode.h
> @@ -50,6 +50,7 @@
>  #define MSR_PIC_YSEL_HIGH	0x51400021
>  #define MSR_PIC_ZSEL_LOW	0x51400022
>  #define MSR_PIC_ZSEL_HIGH	0x51400023
> +#define MSR_PIC_IRQM_LPC	0x51400025
>  
>  #define MSR_MFGPT_IRQ		0x51400028
>  #define MSR_MFGPT_NR		0x51400029
> @@ -237,7 +238,7 @@
>  }
>  
>  extern int geode_mfgpt_toggle_event(int timer, int cmp, int event, int enable);
> -extern int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable);
> +extern int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable);
>  extern int geode_mfgpt_alloc_timer(int timer, int domain);
>  
>  #define geode_mfgpt_setup_irq(t, c, i) geode_mfgpt_set_irq((t), (c), (i), 1)
> --- linux-2.6.26/arch/x86/kernel/mfgpt_32.c
> +++ mfgpt-irq-fix/arch/x86/kernel/mfgpt_32.c
> @@ -33,6 +33,8 @@
>  #include <linux/module.h>
>  #include <asm/geode.h>
>  
> +#define MFGPT_DEFAULT_IRQ	7
> +
>  static struct mfgpt_timer_t {
>  	unsigned int avail:1;
>  } mfgpt_timers[MFGPT_MAX_TIMERS];
> @@ -157,29 +159,41 @@
>  }
>  EXPORT_SYMBOL_GPL(geode_mfgpt_toggle_event);
>  
> -int geode_mfgpt_set_irq(int timer, int cmp, int irq, int enable)
> +int geode_mfgpt_set_irq(int timer, int cmp, int *irq, int enable)
>  {
> -	u32 val, dummy;
> -	int offset;
> +	u32 zsel, lpc, dummy;
> +	int shift;
>  
>  	if (timer < 0 || timer >= MFGPT_MAX_TIMERS)
>  		return -EIO;
>  
> -	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
> +	/* IRQ already set to 2 means VSA is using the timer's Siamese twin */

Please make this more descriptive - something like this:
/* If the IRQ is set to 2, then VSA is using the other timer in the pair */ 

Siamese twin might be confusing.

> +	shift = ((cmp == MFGPT_CMP1 ? 0 : 4) + timer % 4) * 4;
> +	rdmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
> +	if (((zsel >> shift) & 0xF) == 2)
>  		return -EIO;

> -	rdmsr(MSR_PIC_ZSEL_LOW, val, dummy);
> -
> -	offset = (timer % 4) * 4;
> +	/* Choose IRQ: if none supplied, keep IRQ already set or use default */
> +	if (!*irq)
> +		*irq = (zsel >> shift) & 0xF;
> +	if (!*irq)
> +		*irq = MFGPT_DEFAULT_IRQ;

> -	val &= ~((0xF << offset) | (0xF << (offset + 16)));
> +	/* Can't use IRQ if it's 0 (=disabled), 2, or routed to LPC */
> +	if (*irq < 1 || *irq == 2 || *irq > 15)
> +		return -EIO;
> +	rdmsr(MSR_PIC_IRQM_LPC, lpc, dummy);
> +	if (lpc & (1 << *irq))
> +		return -EIO;

> +	/* All chosen and checked - go for it */
> +	if (geode_mfgpt_toggle_event(timer, cmp, MFGPT_EVENT_IRQ, enable))
> +		return -EIO;
>  	if (enable) {
> -		val |= (irq & 0x0F) << (offset);
> -		val |= (irq & 0x0F) << (offset + 16);
> +		zsel = (zsel & ~(0xF << shift)) | (*irq << shift);
> +		wrmsr(MSR_PIC_ZSEL_LOW, zsel, dummy);
>  	}
>  
> -	wrmsr(MSR_PIC_ZSEL_LOW, val, dummy);
>  	return 0;
>  }
>  
> @@ -242,7 +256,7 @@
>  static unsigned int mfgpt_tick_mode = CLOCK_EVT_MODE_SHUTDOWN;
>  static u16 mfgpt_event_clock;
>  
> -static int irq = 7;
> +static int irq;
>  static int __init mfgpt_setup(char *str)
>  {
>  	get_option(&str, &irq);
> @@ -346,7 +360,7 @@ int __init mfgpt_timer_setup(void)
>  	mfgpt_event_clock = timer;
>  
>  	/* Set up the IRQ on the MFGPT side */
> -	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, irq)) {
> +	if (geode_mfgpt_setup_irq(mfgpt_event_clock, MFGPT_CMP2, &irq)) {
>  		printk(KERN_ERR "mfgpt-timer:  Could not set up IRQ %d\n", irq);
>  		return -EIO;
>  	}
> @@ -374,13 +388,14 @@ int __init mfgpt_timer_setup(void)
>  			&mfgpt_clockevent);
>  
>  	printk(KERN_INFO
> -	       "mfgpt-timer:  registering the MFGPT timer as a clock event.\n");
> +	       "mfgpt-timer:  Registering MFGPT timer %d as a clock event, using IRQ %d\n",
> +	       timer, irq);
>  	clockevents_register_device(&mfgpt_clockevent);
>  
>  	return 0;
>  
>  err:
> -	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, irq);
> +	geode_mfgpt_release_irq(mfgpt_event_clock, MFGPT_CMP2, &irq);
>  	printk(KERN_ERR
>  	       "mfgpt-timer:  Unable to set up the MFGPT clock source\n");
>  	return -EIO;
> _
> 
> 

