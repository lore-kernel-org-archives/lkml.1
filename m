Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbZDALrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbZDALrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 07:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754871AbZDALqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 07:46:49 -0400
Received: from e28smtp07.in.ibm.com ([59.145.155.7]:56215 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935AbZDALqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 07:46:48 -0400
Date: Wed, 1 Apr 2009 17:16:41 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
Cc: a.p.zijlstra@chello.nl, ego@in.ibm.com, tglx@linutronix.de, mingo@elte.hu,
       andi@firstfloor.org, venkatesh.pallipadi@intel.com,
       vatsa@linux.vnet.ibm.com, arjan@infradead.org,
       svaidy@linux.vnet.ibm.com, Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [v4 RFC PATCH 4/4] timers: logic to move non pinned timers
Message-ID: <20090401114641.GF22478@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090401113128.GA22478@linux.vnet.ibm.com> <20090401113738.GE22478@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090401113738.GE22478@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Arun R Bharadwaj <arun@linux.vnet.ibm.com> [2009-04-01 17:07:38]:

--------snip--------------
> Index: linux.trees.git/include/linux/hrtimer.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/hrtimer.h
> +++ linux.trees.git/include/linux/hrtimer.h
> @@ -22,7 +22,6 @@
>  #include <linux/wait.h>
>  #include <linux/percpu.h>
> 
> -
>  struct hrtimer_clock_base;
>  struct hrtimer_cpu_base;
> 
> @@ -376,6 +375,24 @@ extern ktime_t hrtimer_get_remaining(con
>  extern int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp);
> 
>  extern ktime_t hrtimer_get_next_event(void);
> +extern ktime_t hrtimer_get_next_event_on(int cpu);
> +
> +#define TICK_PERIOD_IN_NS	NSEC_PER_SEC / HZ
> +/*
> + * Helper function to check before migrating a hrtimer if it expires
> + * before the next timer interrupt on the target cpu.
> + */
> +static inline int check_hrtimer_latency(struct hrtimer *timer, int cpu)
> +{
> +	unsigned long next_hrtimeout, next_jiffies;
> +	next_jiffies = get_next_timer_interrupt_on(jiffies, cpu);
> +	next_jiffies = next_jiffies * TICK_PERIOD_IN_NS;
> +	next_hrtimeout = hrtimer_get_expires_ns(timer);
> +
> +	if (next_hrtimeout > next_jiffies)
> +		return 1;
> +	return 0;
> +}
>

This function can be greatly simplified.
Here i am getting the next timer interrupt on target_cpu.
The target_cpu is the idle load balancer.
So we can check if the hrtimer expiry is before the next tick
on the ilb or not.
By doing this we can eliminate a lot of extra code, which would
otherwise be needed in the form of helper functions for
get_next_timer_interrupt_on().

After simplification the code would simply look like
static inline int check_hrtimer_latency(struct hrtimer *timer, int cpu)
{
        unsigned long next_hrtimeout, next_jiffies;
        next_jiffies = (jiffies + 1) * TICK_PERIOD_IN_NS;
        next_hrtimeout = hrtimer_get_expires_ns(timer);

        if(.....)
}

--arun

>  /*
>   * A timer is active, when it is enqueued into the rbtree or the callback
> Index: linux.trees.git/include/linux/timer.h
> ===================================================================
> --- linux.trees.git.orig/include/linux/timer.h
> +++ linux.trees.git/include/linux/timer.h
> @@ -184,7 +184,7 @@ extern unsigned long next_timer_interrup
>   * jiffie.
>   */
>  extern unsigned long get_next_timer_interrupt(unsigned long now);
> -
> +extern unsigned long get_next_timer_interrupt_on(unsigned long now, int cpu);
>  /*
>   * Timer-statistics info:
>   */
