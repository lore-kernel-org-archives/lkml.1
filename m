Return-Path: <linux-kernel-owner+w=401wt.eu-S1767178AbXDEVZa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767178AbXDEVZa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 17:25:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767323AbXDEVZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 17:25:30 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:58850 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767178AbXDEVZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 17:25:28 -0400
Subject: Re: [PATCH] timekeeping: drop irq-context clocksource polling
From: john stultz <johnstul@us.ibm.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu
In-Reply-To: <20070405210316.785839431@mvista.com>
References: <20070405210316.785839431@mvista.com>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 14:25:19 -0700
Message-Id: <1175808319.28526.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 14:03 -0700, Daniel Walker wrote:
> Before this change the timekeeping code would poll the clocksource
> list every interrupt. This changes that so the clocksource list is
> only checked when there has been and update, and no longer checks
> in interrupt context.
> 
> This also has a few small space and line cleanups.
> 
> Boot tested on i386, compile tested on x86_64 .. However, I couldn't
> find a !GENERIC_TIME that compiled without this change so it's untested..
> 
> Signed-Off-By: Daniel Walker <dwalker@mvista.com>

Err.. I think you need to be holding a write on the xtime_lock (as is
done before calling update_wall_time()) when changing the clocksource.

-john



> ---
>  include/linux/timekeeping.h |   10 ++++++++++
>  kernel/time/clocksource.c   |    7 +++++++
>  kernel/time/timekeeping.c   |   17 ++++++++---------
>  3 files changed, 25 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6.20/include/linux/timekeeping.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6.20/include/linux/timekeeping.h
> @@ -0,0 +1,10 @@
> +#ifndef _LINUX_TIMEKEEPING_H
> +#define _LINUX_TIMEKEEPING_H
> +
> +#ifdef CONFIG_GENERIC_TIME
> +extern void timekeeping_change_clocksource(void);
> +#else
> +static inline void timekeeping_change_clocksource(void) { }
> +#endif
> +
> +#endif
> Index: linux-2.6.20/kernel/time/clocksource.c
> ===================================================================
> --- linux-2.6.20.orig/kernel/time/clocksource.c
> +++ linux-2.6.20/kernel/time/clocksource.c
> @@ -30,6 +30,7 @@
>  #include <linux/module.h>
>  #include <linux/sched.h> /* for spin_unlock_irq() using preempt_count() m68k */
>  #include <linux/tick.h>
> +#include <linux/timekeeping.h>
> 
>  /* XXX - Would like a better way for initializing curr_clocksource */
>  extern struct clocksource clocksource_jiffies;
> @@ -279,6 +280,8 @@ int clocksource_register(struct clocksou
> 
>  	clocksource_check_watchdog(c);
> 
> +	timekeeping_change_clocksource();
> +
>  	return 0;
>  }
>  EXPORT_SYMBOL(clocksource_register);
> @@ -297,6 +300,8 @@ void clocksource_change_rating(struct cl
>  	clocksource_enqueue(cs);
>  	next_clocksource = select_clocksource();
>  	spin_unlock_irqrestore(&clocksource_lock, flags);
> +
> +	timekeeping_change_clocksource();
>  }
> 
>  #ifdef CONFIG_SYSFS
> @@ -374,6 +379,8 @@ static ssize_t sysfs_override_clocksourc
> 
>  	spin_unlock_irq(&clocksource_lock);
> 
> +	timekeeping_change_clocksource();
> +
>  	return ret;
>  }
> 
> Index: linux-2.6.20/kernel/time/timekeeping.c
> ===================================================================
> --- linux-2.6.20.orig/kernel/time/timekeeping.c
> +++ linux-2.6.20/kernel/time/timekeeping.c
> @@ -18,7 +18,7 @@
>  #include <linux/jiffies.h>
>  #include <linux/time.h>
>  #include <linux/tick.h>
> -
> +#include <linux/timekeeping.h>
> 
>  /*
>   * This read-write spinlock protects us from races in SMP while
> @@ -42,10 +42,8 @@ struct timespec wall_to_monotonic __attr
> 
>  EXPORT_SYMBOL(xtime);
> 
> -
>  static struct clocksource *clock; /* pointer to current clocksource */
> 
> -
>  #ifdef CONFIG_GENERIC_TIME
>  /**
>   * __get_nsec_offset - Returns nanoseconds since last call to periodic_hook
> @@ -168,9 +166,10 @@ EXPORT_SYMBOL(do_settimeofday);
>   *
>   * Accumulates current time interval and initializes new clocksource
>   */
> -static void change_clocksource(void)
> +void timekeeping_change_clocksource(void)
>  {
>  	struct clocksource *new;
> +	unsigned long flags;
>  	cycle_t now;
>  	u64 nsec;
> 
> @@ -179,8 +178,10 @@ static void change_clocksource(void)
>  	if (clock == new)
>  		return;
> 
> +	write_seqlock_irqsave(&xtime_lock, flags);
> +
>  	now = clocksource_read(new);
> -	nsec =  __get_nsec_offset();
> +	nsec = __get_nsec_offset();
>  	timespec_add_ns(&xtime, nsec);
> 
>  	clock = new;
> @@ -192,11 +193,11 @@ static void change_clocksource(void)
> 
>  	tick_clock_notify();
> 
> +	write_sequnlock_irqrestore(&xtime_lock, flags);
> +
>  	printk(KERN_INFO "Time: %s clocksource has been installed.\n",
>  	       clock->name);
>  }
> -#else
> -static inline void change_clocksource(void) { }
>  #endif
> 
>  /**
> @@ -470,7 +471,5 @@ void update_wall_time(void)
>  	xtime.tv_nsec = (s64)clock->xtime_nsec >> clock->shift;
>  	clock->xtime_nsec -= (s64)xtime.tv_nsec << clock->shift;
> 
> -	/* check to see if there is a new clocksource to use */
> -	change_clocksource();
>  	update_vsyscall(&xtime, clock);
>  }
> -- 
> 

