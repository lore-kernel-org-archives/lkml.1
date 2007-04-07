Return-Path: <linux-kernel-owner+w=401wt.eu-S965524AbXDGJ7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965524AbXDGJ7Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 05:59:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965691AbXDGJ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 05:59:24 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:47785 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965524AbXDGJ7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 05:59:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] high-res timers: resume fix
Date: Sat, 7 Apr 2007 12:02:41 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Soeren Sonnenburg <kernel@nn7.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070407081244.GA28284@elte.hu> <20070407094924.GA21237@elte.hu>
In-Reply-To: <20070407094924.GA21237@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704071202.41981.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 7 April 2007 11:49, Ingo Molnar wrote:
> 
> find updated patch below - only the patch description changed: i removed 
> the 'UP' thing (patch has relevance on SMP too), and added Thomas' ack.
> 
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
>  2 files changed, 15 insertions(+)
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
> -

Hm, I'm probably missing something obvious, but where is it going to be called
from?

Rafael
