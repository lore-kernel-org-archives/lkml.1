Return-Path: <linux-kernel-owner+w=401wt.eu-S1756220AbXFJKN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220AbXFJKN0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 06:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXFJKNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 06:13:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:34557 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753107AbXFJKNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 06:13:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch-mm 06/23] clockevents: Fix resume logic
Date: Sun, 10 Jun 2007 12:19:02 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@suse.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Chris Wright <chrisw@sous-sol.org>
References: <20070610092437.118387863@inhelltoy.tec.linutronix.de> <20070610092446.588014600@inhelltoy.tec.linutronix.de>
In-Reply-To: <20070610092446.588014600@inhelltoy.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706101219.03914.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 June 2007 11:44, Thomas Gleixner wrote:
> We need to make sure, that the clockevent devices are resumed, before
> the tick is resumed. The current resume logic does not guarantee this.
> 
> Add CLOCK_EVT_MODE_RESUME and call the set mode functions of the clock
> event devices before resuming the tick / oneshot functionality.
> 
> Fixup the existing users.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> ---
>  arch/arm/mach-davinci/time.c      |    2 +
>  arch/arm/mach-imx/time.c          |    1 
>  arch/arm/mach-ixp4xx/common.c     |    2 +
>  arch/arm/mach-omap1/time.c        |    1 
>  arch/arm/plat-omap/timer32k.c     |    2 +
>  arch/i386/kernel/apic.c           |    3 +
>  arch/i386/kernel/hpet.c           |   71 ++------------------------------------
>  arch/i386/kernel/i8253.c          |   26 ++++++-------
>  arch/i386/kernel/vmiclock.c       |    1 
>  arch/i386/xen/time.c              |    1 
>  arch/sh/kernel/timers/timer-tmu.c |    1 
>  arch/sparc64/kernel/time.c        |    1 
>  include/linux/clockchips.h        |    1 
>  kernel/time/tick-broadcast.c      |    4 +-
>  kernel/time/tick-common.c         |   16 +++++---
>  15 files changed, 46 insertions(+), 87 deletions(-)
> 
> Index: linux-2.6.22-rc4-mm/arch/i386/kernel/apic.c
> ===================================================================
> --- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/apic.c	2007-06-10 10:44:37.000000000 +0200
> +++ linux-2.6.22-rc4-mm/arch/i386/kernel/apic.c	2007-06-10 10:44:38.000000000 +0200
> @@ -263,6 +263,9 @@ static void lapic_timer_setup(enum clock
>  		v |= (APIC_LVT_MASKED | LOCAL_TIMER_VECTOR);
>  		apic_write_around(APIC_LVTT, v);
>  		break;
> +	case CLOCK_EVT_MODE_RESUME:
> +		/* Nothing to do here */
> +		break;
>  	}
>  
>  	local_irq_restore(flags);
> Index: linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c
> ===================================================================
> --- linux-2.6.22-rc4-mm.orig/arch/i386/kernel/hpet.c	2007-06-10 10:44:37.000000000 +0200
> +++ linux-2.6.22-rc4-mm/arch/i386/kernel/hpet.c	2007-06-10 10:44:38.000000000 +0200
> @@ -187,6 +187,10 @@ static void hpet_set_mode(enum clock_eve
>  		cfg &= ~HPET_TN_ENABLE;
>  		hpet_writel(cfg, HPET_T0_CFG);
>  		break;
> +
> +	case CLOCK_EVT_MODE_RESUME:
> +		hpet_enable_int();
> +		break;
>  	}
>  }
>  
> @@ -217,6 +221,7 @@ static struct clocksource clocksource_hp
>  	.mask		= HPET_MASK,
>  	.shift		= HPET_SHIFT,
>  	.flags		= CLOCK_SOURCE_IS_CONTINUOUS,
> +	.resume		= hpet_start_counter,
>  };
>  
>  /*
> @@ -313,7 +318,6 @@ int __init hpet_enable(void)
>  
>  	clocksource_register(&clocksource_hpet);
>  
> -
>  	if (id & HPET_ID_LEGSUP) {
>  		hpet_enable_int();
>  		hpet_reserve_platform_timers(id);
> @@ -546,68 +550,3 @@ irqreturn_t hpet_rtc_interrupt(int irq, 
>  	return IRQ_HANDLED;
>  }
>  #endif
> -
> -
> -/*
> - * Suspend/resume part
> - */
> -
> -#ifdef CONFIG_PM
> -
> -static int hpet_suspend(struct sys_device *sys_device, pm_message_t state)
> -{
> -	unsigned long cfg = hpet_readl(HPET_CFG);
> -
> -	cfg &= ~(HPET_CFG_ENABLE|HPET_CFG_LEGACY);
> -	hpet_writel(cfg, HPET_CFG);
> -
> -	return 0;
> -}

Hmm, I haven't found anything to replace the above in the patch.  Is that
intentional, or is it there, but I haven't noticed?

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
