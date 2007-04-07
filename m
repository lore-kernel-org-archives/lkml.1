Return-Path: <linux-kernel-owner+w=401wt.eu-S965746AbXDGKvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965746AbXDGKvO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 06:51:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965757AbXDGKvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 06:51:14 -0400
Received: from nn7.de ([85.214.94.156]:43039 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965746AbXDGKvN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 06:51:13 -0400
Subject: Re: [patch, take #3] high-res timers: resume fix
From: Soeren Sonnenburg <kernel@nn7.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: "Rafael J\. Wysocki" <rjw@sisk.pl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20070407100500.GA24122@elte.hu>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org>
	 <20070407081244.GA28284@elte.hu> <20070407094924.GA21237@elte.hu>
	 <200704071202.41981.rjw@sisk.pl>  <20070407100500.GA24122@elte.hu>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Apr 2007 12:45:23 +0200
Message-Id: <1175942723.8905.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 12:05 +0200, Ingo Molnar wrote:
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > Hm, I'm probably missing something obvious, but where is it going to 
> > be called from?
> 
> doh! :) Find new patch below :-/ Soeren, please test this one.

OK, I did about 5 suspend/resume cycles with

CONFIG_HPET_TIMER=y
CONFIG_HPET_EMULATE_RTC=y
CONFIG_HPET=y
CONFIG_HPET_MMAP=y

and no oops / no problem ...

So I guess the fix take #3 is good :-)

One not directly related to this patch (but probably all the timer
stuff) I noticed with -rc6 is that it takes 10 seconds to suspend (it
was ~2 seconds before)

Soeren

> 	Ingo
> 
> ---------------------------->
> Subject: [patch] high-res timers: resume fix
> From: Ingo Molnar <mingo@elte.hu>
> 
> Soeren Sonnenburg reported that upon resume he is getting
> this backtrace:
> 
>  [<c0119637>] smp_apic_timer_interrupt+0x57/0x90
>  [<c0142d30>] retrigger_next_event+0x0/0xb0
>  [<c0104d30>] apic_timer_interrupt+0x28/0x30
>  [<c0142d30>] retrigger_next_event+0x0/0xb0
>  [<c0140068>] __kfifo_put+0x8/0x90
>  [<c0130fe5>] on_each_cpu+0x35/0x60
>  [<c0143538>] clock_was_set+0x18/0x20
>  [<c0135cdc>] timekeeping_resume+0x7c/0xa0
>  [<c02aabe1>] __sysdev_resume+0x11/0x80
>  [<c02ab0c7>] sysdev_resume+0x47/0x80
>  [<c02b0b05>] device_power_up+0x5/0x10
> 
> it turns out that on resume we mistakenly re-enable interrupts.
> Do the timer retrigger only on the current CPU.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> Acked-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/hrtimer.h |    3 +++
>  kernel/hrtimer.c        |   12 ++++++++++++
>  kernel/timer.c          |    2 +-
>  3 files changed, 16 insertions(+), 1 deletion(-)
> 
> Index: linux/include/linux/hrtimer.h
> ===================================================================
> --- linux.orig/include/linux/hrtimer.h
> +++ linux/include/linux/hrtimer.h
> @@ -206,6 +206,7 @@ struct hrtimer_cpu_base {
>  struct clock_event_device;
>  
>  extern void clock_was_set(void);
> +extern void hres_timers_resume(void);
>  extern void hrtimer_interrupt(struct clock_event_device *dev);
>  
>  /*
> @@ -236,6 +237,8 @@ static inline ktime_t hrtimer_cb_get_tim
>   */
>  static inline void clock_was_set(void) { }
>  
> +static inline void hres_timers_resume(void) { }
> +
>  /*
>   * In non high resolution mode the time reference is taken from
>   * the base softirq time variable.
> Index: linux/kernel/hrtimer.c
> ===================================================================
> --- linux.orig/kernel/hrtimer.c
> +++ linux/kernel/hrtimer.c
> @@ -459,6 +459,18 @@ void clock_was_set(void)
>  }
>  
>  /*
> + * During resume we might have to reprogram the high resolution timer
> + * interrupt (on the local CPU):
> + */
> +void hres_timers_resume(void)
> +{
> +	WARN_ON_ONCE(num_online_cpus() > 1);
> +
> +	/* Retrigger the CPU local events: */
> +	retrigger_next_event(NULL);
> +}
> +
> +/*
>   * Check, whether the timer is on the callback pending list
>   */
>  static inline int hrtimer_cb_pending(const struct hrtimer *timer)
> Index: linux/kernel/timer.c
> ===================================================================
> --- linux.orig/kernel/timer.c
> +++ linux/kernel/timer.c
> @@ -1016,7 +1016,7 @@ static int timekeeping_resume(struct sys
>  	clockevents_notify(CLOCK_EVT_NOTIFY_RESUME, NULL);
>  
>  	/* Resume hrtimers */
> -	clock_was_set();
> +	hres_timers_resume();
>  
>  	return 0;
>  }
> 
-- 
Sometimes, there's a moment as you're waking, when you become aware of
the real world around you, but you're still dreaming.
