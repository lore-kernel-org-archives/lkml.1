Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbYAOVqs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbYAOVqs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 16:46:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755371AbYAOVqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 16:46:40 -0500
Received: from tomts25.bellnexxia.net ([209.226.175.188]:46614 "EHLO
	tomts25-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751700AbYAOVqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 16:46:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HACy4jEdMROHU/2dsb2JhbACBWKoo
Date: Tue, 15 Jan 2008 16:46:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080115214636.GD17439@Krystal>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080109233044.777564395@goodmis.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 16:36:41 up 73 days,  2:42,  5 users,  load average: 1.25, 1.08,
	1.24
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> The latency tracer needs a way to get an accurate time
> without grabbing any locks. Locks themselves might call
> the latency tracer and cause at best a slow down.
> 
> This patch adds get_monotonic_cycles that returns cycles
> from a reliable clock source in a monotonic fashion.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  include/linux/clocksource.h |    3 ++
>  kernel/time/timekeeping.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+)
> 
> Index: linux-compile-i386.git/kernel/time/timekeeping.c
> ===================================================================
> --- linux-compile-i386.git.orig/kernel/time/timekeeping.c	2008-01-09 14:27:26.000000000 -0500
> +++ linux-compile-i386.git/kernel/time/timekeeping.c	2008-01-09 14:34:40.000000000 -0500
> @@ -103,6 +103,54 @@ static inline void __get_realtime_clock_
>  	timespec_add_ns(ts, nsecs);
>  }
>  
> +cycle_t notrace get_monotonic_cycles(void)
> +{
> +	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
> +
> +	do {
> +		/*
> +		 * cycle_raw and cycle_last can change on
> +		 * another CPU and we need the delta calculation
> +		 * of cycle_now and cycle_last happen atomic, as well
> +		 * as the adding to cycle_raw. We don't need to grab
> +		 * any locks, we just keep trying until get all the
> +		 * calculations together in one state.
> +		 *
> +		 * In fact, we __cant__ grab any locks. This
> +		 * function is called from the latency_tracer which can
> +		 * be called anywhere. To grab any locks (including
> +		 * seq_locks) we risk putting ourselves into a deadlock.
> +		 */

I wonder what makes the compiler read the clock->cycle_raw and
clock->cycle_last variables twice ? I guess some memory barriers could
be welcome here ?

> +		cycle_raw = clock->cycle_raw;
> +		cycle_last = clock->cycle_last;
> +
> +		/* read clocksource: */
> +		cycle_now = clocksource_read(clock);
> +
> +		/* calculate the delta since the last update_wall_time: */
> +		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> +
> +	} while (cycle_raw != clock->cycle_raw ||
> +		 cycle_last != clock->cycle_last);
> +
> +	return cycle_raw + cycle_delta;
> +}
> +
> +unsigned long notrace cycles_to_usecs(cycle_t cycles)
> +{
> +	u64 ret = cyc2ns(clock, cycles);
> +
> +	ret += NSEC_PER_USEC/2; /* For rounding in do_div() */
> +	do_div(ret, NSEC_PER_USEC);
> +
> +	return ret;
> +}
> +
> +cycle_t notrace usecs_to_cycles(unsigned long usecs)
> +{
> +	return ns2cyc(clock, (u64)usecs * 1000);
> +}
> +
>  /**
>   * getnstimeofday - Returns the time of day in a timespec
>   * @ts:		pointer to the timespec to be set
> Index: linux-compile-i386.git/include/linux/clocksource.h
> ===================================================================
> --- linux-compile-i386.git.orig/include/linux/clocksource.h	2008-01-09 14:27:51.000000000 -0500
> +++ linux-compile-i386.git/include/linux/clocksource.h	2008-01-09 14:29:44.000000000 -0500
> @@ -273,6 +273,9 @@ extern int clocksource_register(struct c
>  extern struct clocksource* clocksource_get_next(void);
>  extern void clocksource_change_rating(struct clocksource *cs, int rating);
>  extern void clocksource_resume(void);
> +extern cycle_t get_monotonic_cycles(void);
> +extern unsigned long cycles_to_usecs(cycle_t cycles);
> +extern cycle_t usecs_to_cycles(unsigned long usecs);
>  
>  /* used to initialize clock */
>  extern struct clocksource clocksource_jiffies;
> 
> -- 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
