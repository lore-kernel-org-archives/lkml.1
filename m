Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYBDBaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYBDBaX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 20:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754228AbYBDBaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 20:30:08 -0500
Received: from rex.snapgear.com ([203.143.235.140]:49075 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754099AbYBDBaF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 20:30:05 -0500
Message-ID: <47A66A96.6000301@snapgear.com>
Date: Mon, 04 Feb 2008 11:29:58 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: rth@twiddle.net, rmk@arm.linux.org.uk, bryan.wu@analog.com,
       dhowells@redhat.com, gerg@uclinux.org, lethal@linux-sh.org,
       wli@holomorphy.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [RFC][PATCH 2/2] xtime_lock vs update_process_times
References: <20080128103953.326762000@chello.nl> <20080128104056.184943000@chello.nl>
In-Reply-To: <20080128104056.184943000@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Peter Zijlstra wrote:
> move update_process_times() out from under xtime_lock.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  arch/alpha/kernel/time.c              |   15 ++++++++-------
>  arch/arm/common/time-acorn.c          |    2 --
>  arch/arm/mach-at91/at91sam926x_time.c |    3 ---
>  arch/arm/plat-iop/time.c              |    4 ----
>  arch/arm/plat-s3c24xx/time.c          |    2 --
>  arch/blackfin/kernel/time.c           |    8 +++++---
>  arch/frv/kernel/time.c                |    6 ++++--
>  arch/m68knommu/kernel/time.c          |   12 +++++++-----
>  arch/sh/kernel/time.c                 |   19 +++++++++++++++----
>  arch/sh/kernel/timers/timer-cmt.c     |    9 ---------
>  arch/sh/kernel/timers/timer-mtu2.c    |    2 --
>  arch/sh64/kernel/time.c               |   31 +++++++++++++++++--------------
>  arch/sparc/kernel/pcic.c              |    2 +-
>  arch/sparc/kernel/time.c              |    7 +++----
>  14 files changed, 60 insertions(+), 62 deletions(-)

Tested the m68knommu change. Works fine. So for that part:

Acked-by: Greg Ungerer <gerg@uclinux.org>

Regards
Greg




> Index: linux-2.6/arch/alpha/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/alpha/kernel/time.c
> +++ linux-2.6/arch/alpha/kernel/time.c
> @@ -119,13 +119,8 @@ irqreturn_t timer_interrupt(int irq, voi
>  	state.partial_tick = delta & ((1UL << FIX_SHIFT) - 1); 
>  	nticks = delta >> FIX_SHIFT;
>  
> -	while (nticks > 0) {
> -		do_timer(1);
> -#ifndef CONFIG_SMP
> -		update_process_times(user_mode(get_irq_regs()));
> -#endif
> -		nticks--;
> -	}
> +	if (nticks)
> +		do_timer(nticks);
>  
>  	/*
>  	 * If we have an externally synchronized Linux clock, then update
> @@ -141,6 +136,12 @@ irqreturn_t timer_interrupt(int irq, voi
>  	}
>  
>  	write_sequnlock(&xtime_lock);
> +
> +#ifndef CONFIG_SMP
> +	while (nticks--)
> +		update_process_times(user_mode(get_irq_regs()));
> +#endif
> +
>  	return IRQ_HANDLED;
>  }
>  
> Index: linux-2.6/arch/arm/common/time-acorn.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/common/time-acorn.c
> +++ linux-2.6/arch/arm/common/time-acorn.c
> @@ -69,9 +69,7 @@ void __init ioctime_init(void)
>  static irqreturn_t
>  ioc_timer_interrupt(int irq, void *dev_id)
>  {
> -	write_seqlock(&xtime_lock);
>  	timer_tick();
> -	write_sequnlock(&xtime_lock);
>  	return IRQ_HANDLED;
>  }
>  
> Index: linux-2.6/arch/arm/mach-at91/at91sam926x_time.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-at91/at91sam926x_time.c
> +++ linux-2.6/arch/arm/mach-at91/at91sam926x_time.c
> @@ -49,8 +49,6 @@ static irqreturn_t at91sam926x_timer_int
>  	volatile long nr_ticks;
>  
>  	if (at91_sys_read(AT91_PIT_SR) & AT91_PIT_PITS) {	/* This is a shared interrupt */
> -		write_seqlock(&xtime_lock);
> -
>  		/* Get number to ticks performed before interrupt and clear PIT interrupt */
>  		nr_ticks = PIT_PICNT(at91_sys_read(AT91_PIT_PIVR));
>  		do {
> @@ -58,7 +56,6 @@ static irqreturn_t at91sam926x_timer_int
>  			nr_ticks--;
>  		} while (nr_ticks);
>  
> -		write_sequnlock(&xtime_lock);
>  		return IRQ_HANDLED;
>  	} else
>  		return IRQ_NONE;		/* not handled */
> Index: linux-2.6/arch/arm/plat-iop/time.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/plat-iop/time.c
> +++ linux-2.6/arch/arm/plat-iop/time.c
> @@ -57,8 +57,6 @@ unsigned long iop_gettimeoffset(void)
>  static irqreturn_t
>  iop_timer_interrupt(int irq, void *dev_id)
>  {
> -	write_seqlock(&xtime_lock);
> -
>  	write_tisr(1);
>  
>  	while ((signed long)(next_jiffy_time - read_tcr1())
> @@ -67,8 +65,6 @@ iop_timer_interrupt(int irq, void *dev_i
>  		next_jiffy_time -= ticks_per_jiffy;
>  	}
>  
> -	write_sequnlock(&xtime_lock);
> -
>  	return IRQ_HANDLED;
>  }
>  
> Index: linux-2.6/arch/arm/plat-s3c24xx/time.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/plat-s3c24xx/time.c
> +++ linux-2.6/arch/arm/plat-s3c24xx/time.c
> @@ -130,9 +130,7 @@ static unsigned long s3c2410_gettimeoffs
>  static irqreturn_t
>  s3c2410_timer_interrupt(int irq, void *dev_id)
>  {
> -	write_seqlock(&xtime_lock);
>  	timer_tick();
> -	write_sequnlock(&xtime_lock);
>  	return IRQ_HANDLED;
>  }
>  
> Index: linux-2.6/arch/blackfin/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/blackfin/kernel/time.c
> +++ linux-2.6/arch/blackfin/kernel/time.c
> @@ -137,9 +137,6 @@ irqreturn_t timer_interrupt(int irq, voi
>  
>  	do_timer(1);
>  
> -#ifndef CONFIG_SMP
> -	update_process_times(user_mode(get_irq_regs()));
> -#endif
>  	profile_tick(CPU_PROFILING);
>  
>  	/*
> @@ -161,6 +158,11 @@ irqreturn_t timer_interrupt(int irq, voi
>  			last_rtc_update = xtime.tv_sec - 600;
>  	}
>  	write_sequnlock(&xtime_lock);
> +
> +#ifndef CONFIG_SMP
> +	update_process_times(user_mode(get_irq_regs()));
> +#endif
> +
>  	return IRQ_HANDLED;
>  }
>  
> Index: linux-2.6/arch/frv/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/frv/kernel/time.c
> +++ linux-2.6/arch/frv/kernel/time.c
> @@ -63,6 +63,7 @@ static irqreturn_t timer_interrupt(int i
>  	/* last time the cmos clock got updated */
>  	static long last_rtc_update = 0;
>  
> +	profile_tick(CPU_PROFILING);
>  	/*
>  	 * Here we are in the timer irq handler. We just have irqs locally
>  	 * disabled but we don't know if the timer_bh is running on the other
> @@ -73,8 +74,6 @@ static irqreturn_t timer_interrupt(int i
>  	write_seqlock(&xtime_lock);
>  
>  	do_timer(1);
> -	update_process_times(user_mode(get_irq_regs()));
> -	profile_tick(CPU_PROFILING);
>  
>  	/*
>  	 * If we have an externally synchronized Linux clock, then update
> @@ -99,6 +98,9 @@ static irqreturn_t timer_interrupt(int i
>  #endif /* CONFIG_HEARTBEAT */
>  
>  	write_sequnlock(&xtime_lock);
> +
> +	update_process_times(user_mode(get_irq_regs()));
> +
>  	return IRQ_HANDLED;
>  }
>  
> Index: linux-2.6/arch/m68knommu/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/m68knommu/kernel/time.c
> +++ linux-2.6/arch/m68knommu/kernel/time.c
> @@ -43,14 +43,12 @@ irqreturn_t arch_timer_interrupt(int irq
>  	/* last time the cmos clock got updated */
>  	static long last_rtc_update=0;
>  
> +	if (current->pid)
> +		profile_tick(CPU_PROFILING);
> +
>  	write_seqlock(&xtime_lock);
>  
>  	do_timer(1);
> -#ifndef CONFIG_SMP
> -	update_process_times(user_mode(get_irq_regs()));
> -#endif
> -	if (current->pid)
> -		profile_tick(CPU_PROFILING);
>  
>  	/*
>  	 * If we have an externally synchronized Linux clock, then update
> @@ -91,6 +89,10 @@ irqreturn_t arch_timer_interrupt(int irq
>  #endif /* CONFIG_HEARTBEAT */
>  
>  	write_sequnlock(&xtime_lock);
> +
> +#ifndef CONFIG_SMP
> +	update_process_times(user_mode(get_irq_regs()));
> +#endif
>  	return(IRQ_HANDLED);
>  }
>  
> Index: linux-2.6/arch/sh/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/sh/kernel/time.c
> +++ linux-2.6/arch/sh/kernel/time.c
> @@ -120,10 +120,6 @@ static long last_rtc_update;
>   */
>  void handle_timer_tick(void)
>  {
> -	do_timer(1);
> -#ifndef CONFIG_SMP
> -	update_process_times(user_mode(get_irq_regs()));
> -#endif
>  	if (current->pid)
>  		profile_tick(CPU_PROFILING);
>  
> @@ -133,6 +129,16 @@ void handle_timer_tick(void)
>  #endif
>  
>  	/*
> +	 * Here we are in the timer irq handler. We just have irqs locally
> +	 * disabled but we don't know if the timer_bh is running on the other
> +	 * CPU. We need to avoid to SMP race with it. NOTE: we don' t need
> +	 * the irq version of write_lock because as just said we have irq
> +	 * locally disabled. -arca
> +	 */
> +	write_seqlock(&xtime_lock);
> +	do_timer(1);
> +
> +	/*
>  	 * If we have an externally synchronized Linux clock, then update
>  	 * RTC clock accordingly every ~11 minutes. Set_rtc_mmss() has to be
>  	 * called as close as possible to 500 ms before the new second starts.
> @@ -147,6 +153,11 @@ void handle_timer_tick(void)
>  			/* do it again in 60s */
>  			last_rtc_update = xtime.tv_sec - 600;
>  	}
> +	write_sequnlock(&xtime_lock);
> +
> +#ifndef CONFIG_SMP
> +	update_process_times(user_mode(get_irq_regs()));
> +#endif
>  }
>  #endif /* !CONFIG_GENERIC_CLOCKEVENTS */
>  
> Index: linux-2.6/arch/sh/kernel/timers/timer-cmt.c
> ===================================================================
> --- linux-2.6.orig/arch/sh/kernel/timers/timer-cmt.c
> +++ linux-2.6/arch/sh/kernel/timers/timer-cmt.c
> @@ -98,16 +98,7 @@ static irqreturn_t cmt_timer_interrupt(i
>  	timer_status &= ~0x80;
>  	ctrl_outw(timer_status, CMT_CMCSR_0);
>  
> -	/*
> -	 * Here we are in the timer irq handler. We just have irqs locally
> -	 * disabled but we don't know if the timer_bh is running on the other
> -	 * CPU. We need to avoid to SMP race with it. NOTE: we don' t need
> -	 * the irq version of write_lock because as just said we have irq
> -	 * locally disabled. -arca
> -	 */
> -	write_seqlock(&xtime_lock);
>  	handle_timer_tick();
> -	write_sequnlock(&xtime_lock);
>  
>  	return IRQ_HANDLED;
>  }
> Index: linux-2.6/arch/sh/kernel/timers/timer-mtu2.c
> ===================================================================
> --- linux-2.6.orig/arch/sh/kernel/timers/timer-mtu2.c
> +++ linux-2.6/arch/sh/kernel/timers/timer-mtu2.c
> @@ -100,9 +100,7 @@ static irqreturn_t mtu2_timer_interrupt(
>  	ctrl_outb(timer_status, MTU2_TSR_1);
>  
>  	/* Do timer tick */
> -	write_seqlock(&xtime_lock);
>  	handle_timer_tick();
> -	write_sequnlock(&xtime_lock);
>  
>  	return IRQ_HANDLED;
>  }
> Index: linux-2.6/arch/sh64/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/sh64/kernel/time.c
> +++ linux-2.6/arch/sh64/kernel/time.c
> @@ -285,15 +285,22 @@ static long last_rtc_update = 0;
>  static inline void do_timer_interrupt(void)
>  {
>  	unsigned long long current_ctc;
> +
> +	if (current->pid)
> +		profile_tick(CPU_PROFILING);
> +
> +	/*
> +	 * Here we are in the timer irq handler. We just have irqs locally
> +	 * disabled but we don't know if the timer_bh is running on the other
> +	 * CPU. We need to avoid to SMP race with it. NOTE: we don' t need
> +	 * the irq version of write_lock because as just said we have irq
> +	 * locally disabled. -arca
> +	 */
> +	write_lock(&xtime_lock);
>  	asm ("getcon cr62, %0" : "=r" (current_ctc));
>  	ctc_last_interrupt = (unsigned long) current_ctc;
>  
>  	do_timer(1);
> -#ifndef CONFIG_SMP
> -	update_process_times(user_mode(get_irq_regs()));
> -#endif
> -	if (current->pid)
> -		profile_tick(CPU_PROFILING);
>  
>  #ifdef CONFIG_HEARTBEAT
>  	{
> @@ -317,6 +324,11 @@ static inline void do_timer_interrupt(vo
>  		else
>  			last_rtc_update = xtime.tv_sec - 600; /* do it again in 60 s */
>  	}
> +	write_unlock(&xtime_lock);
> +
> +#ifndef CONFIG_SMP
> +	update_process_times(user_mode(get_irq_regs()));
> +#endif
>  }
>  
>  /*
> @@ -333,16 +345,7 @@ static irqreturn_t timer_interrupt(int i
>  	timer_status &= ~0x100;
>  	ctrl_outw(timer_status, TMU0_TCR);
>  
> -	/*
> -	 * Here we are in the timer irq handler. We just have irqs locally
> -	 * disabled but we don't know if the timer_bh is running on the other
> -	 * CPU. We need to avoid to SMP race with it. NOTE: we don' t need
> -	 * the irq version of write_lock because as just said we have irq
> -	 * locally disabled. -arca
> -	 */
> -	write_lock(&xtime_lock);
>  	do_timer_interrupt();
> -	write_unlock(&xtime_lock);
>  
>  	return IRQ_HANDLED;
>  }
> Index: linux-2.6/arch/sparc/kernel/pcic.c
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/pcic.c
> +++ linux-2.6/arch/sparc/kernel/pcic.c
> @@ -713,10 +713,10 @@ static irqreturn_t pcic_timer_handler (i
>  	write_seqlock(&xtime_lock);	/* Dummy, to show that we remember */
>  	pcic_clear_clock_irq();
>  	do_timer(1);
> +	write_sequnlock(&xtime_lock);
>  #ifndef CONFIG_SMP
>  	update_process_times(user_mode(get_irq_regs()));
>  #endif
> -	write_sequnlock(&xtime_lock);
>  	return IRQ_HANDLED;
>  }
>  
> Index: linux-2.6/arch/sparc/kernel/time.c
> ===================================================================
> --- linux-2.6.orig/arch/sparc/kernel/time.c
> +++ linux-2.6/arch/sparc/kernel/time.c
> @@ -128,10 +128,6 @@ irqreturn_t timer_interrupt(int irq, voi
>  	clear_clock_irq();
>  
>  	do_timer(1);
> -#ifndef CONFIG_SMP
> -	update_process_times(user_mode(get_irq_regs()));
> -#endif
> -
>  
>  	/* Determine when to update the Mostek clock. */
>  	if (ntp_synced() &&
> @@ -145,6 +141,9 @@ irqreturn_t timer_interrupt(int irq, voi
>  	}
>  	write_sequnlock(&xtime_lock);
>  
> +#ifndef CONFIG_SMP
> +	update_process_times(user_mode(get_irq_regs()));
> +#endif
>  	return IRQ_HANDLED;
>  }
>  
> 
> --
> 
> 

-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
