Return-Path: <linux-kernel-owner+w=401wt.eu-S1754183AbYAQCgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754183AbYAQCgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750941AbYAQCgD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:36:03 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:51675 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbYAQCgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:36:00 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAOBNjkdMROHU/2dsb2JhbACBWKxe
Date: Wed, 16 Jan 2008 21:35:57 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: john stultz <johnstul@us.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080117023557.GC2322@Krystal>
References: <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com> <1200523867.6127.5.camel@localhost.localdomain> <20080116233927.GB23895@Krystal> <1200536409.6127.47.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1200536409.6127.47.camel@localhost.localdomain>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:23:29 up 74 days,  7:28,  5 users,  load average: 0.20, 0.42,
	0.52
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* john stultz (johnstul@us.ibm.com) wrote:
> On Wed, 2008-01-16 at 18:39 -0500, Mathieu Desnoyers wrote:
> > I would disable preemption in clocksource_get_basecycles. We would not
> > want to be scheduled out while we hold a pointer to the old array
> > element.
> > 
> > > +	int num = cs->base_num;
> > 
> > Since you deal with base_num in a shared manner (not per cpu), you will
> > need a smp_read_barrier_depend() here after the cs->base_num read.
> > 
> > You should think about reading the cs->base_num first, and _after_ that
> > read the real clocksource. Here, the clocksource value is passed as
> > parameter. It means that the read clocksource may have been read in the
> > previous RCU window.
> 
> Here's an updated version of the patch w/ the suggested memory barrier
> changes and favored (1-x) inversion change. ;)  Let me know if you see
> any other holes, or have any other suggestions or ideas.
> 
> Still un-tested (my test box will free up soon, I promise!), but builds.
> 
> Signed-off-by: John Stultz <johstul@us.ibm.com>
> 
> Index: monotonic-cleanup/include/linux/clocksource.h
> ===================================================================
> --- monotonic-cleanup.orig/include/linux/clocksource.h	2008-01-16 12:22:04.000000000 -0800
> +++ monotonic-cleanup/include/linux/clocksource.h	2008-01-16 18:12:53.000000000 -0800
> @@ -87,9 +87,17 @@
>  	 * more than one cache line.
>  	 */
>  	struct {
> -		cycle_t cycle_last, cycle_accumulated, cycle_raw;
> -	} ____cacheline_aligned_in_smp;
> +		cycle_t cycle_last, cycle_accumulated;
>  
> +		/* base structure provides lock-free read
> +		 * access to a virtualized 64bit counter
> +		 * Uses RCU-like update.
> +		 */
> +		struct {
> +			cycle_t cycle_base_last, cycle_base;
> +		} base[2];
> +		int base_num;
> +	} ____cacheline_aligned_in_smp;
>  	u64 xtime_nsec;
>  	s64 error;
>  
> @@ -175,19 +183,29 @@
>  }
>  
>  /**
> - * clocksource_get_cycles: - Access the clocksource's accumulated cycle value
> + * clocksource_get_basecycles: - get the clocksource's accumulated cycle value
>   * @cs:		pointer to clocksource being read
>   * @now:	current cycle value
>   *
>   * Uses the clocksource to return the current cycle_t value.
>   * NOTE!!!: This is different from clocksource_read, because it
> - * returns the accumulated cycle value! Must hold xtime lock!
> + * returns a 64bit wide accumulated value.
>   */
>  static inline cycle_t
> -clocksource_get_cycles(struct clocksource *cs, cycle_t now)
> +clocksource_get_basecycles(struct clocksource *cs)
>  {
> -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> -	offset += cs->cycle_accumulated;
> +	int num;
> +	cycle_t now, offset;
> +
> +	preempt_disable();
> +	num = cs->base_num;
> +	smp_read_barrier_depends();
> +	now = clocksource_read(cs);
> +	offset = (now - cs->base[num].cycle_base_last);
> +	offset &= cs->mask;
> +	offset += cs->base[num].cycle_base;
> +	preempt_enable();
> +
>  	return offset;
>  }
>  
> @@ -197,14 +215,26 @@
>   * @now:	current cycle value
>   *
>   * Used to avoids clocksource hardware overflow by periodically
> - * accumulating the current cycle delta. Must hold xtime write lock!
> + * accumulating the current cycle delta. Uses RCU-like update, but
> + * ***still requires the xtime_lock is held for writing!***
>   */
>  static inline void clocksource_accumulate(struct clocksource *cs, cycle_t now)
>  {
> -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> +	/* First update the monotonic base portion.
> +	 * The dual array update method allows for lock-free reading.
> +	 */
> +	int num = 1 - cs->base_num;

(nitpick)
right here, you could probably express 1-num with cs->base_num, since we
are the only ones supposed to touch it.

> +	cycle_t offset = (now - cs->base[1-num].cycle_base_last);
> +	offset &= cs->mask;

here too.

> +	cs->base[num].cycle_base = cs->base[1-num].cycle_base + offset;
> +	cs->base[num].cycle_base_last = now;
> +	wmb();

As I just emailed : smp_smb() *should* be enough. I don't see which
architecture could reorder writes wrt local interrupts ? (please tell me
if I am grossly mistaken)

Mathieu

> +	cs->base_num = num;
> +
> +	/* Now update the cycle_accumulated portion */
> +	offset = (now - cs->cycle_last) & cs->mask;
>  	cs->cycle_last = now;
>  	cs->cycle_accumulated += offset;
> -	cs->cycle_raw += offset;
>  }
>  
>  /**
> Index: monotonic-cleanup/kernel/time/timekeeping.c
> ===================================================================
> --- monotonic-cleanup.orig/kernel/time/timekeeping.c	2008-01-16 12:21:46.000000000 -0800
> +++ monotonic-cleanup/kernel/time/timekeeping.c	2008-01-16 17:51:50.000000000 -0800
> @@ -71,10 +71,12 @@
>   */
>  static inline s64 __get_nsec_offset(void)
>  {
> -	cycle_t cycle_delta;
> +	cycle_t now, cycle_delta;
>  	s64 ns_offset;
>  
> -	cycle_delta = clocksource_get_cycles(clock, clocksource_read(clock));
> +	now = clocksource_read(clock);
> +	cycle_delta = (now - clock->cycle_last) & clock->mask;
> +	cycle_delta += clock->cycle_accumulated;
>  	ns_offset = cyc2ns(clock, cycle_delta);
>  
>  	return ns_offset;
> @@ -105,35 +107,7 @@
>  
>  cycle_t notrace get_monotonic_cycles(void)
>  {
> -	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
> -
> -	do {
> -		/*
> -		 * cycle_raw and cycle_last can change on
> -		 * another CPU and we need the delta calculation
> -		 * of cycle_now and cycle_last happen atomic, as well
> -		 * as the adding to cycle_raw. We don't need to grab
> -		 * any locks, we just keep trying until get all the
> -		 * calculations together in one state.
> -		 *
> -		 * In fact, we __cant__ grab any locks. This
> -		 * function is called from the latency_tracer which can
> -		 * be called anywhere. To grab any locks (including
> -		 * seq_locks) we risk putting ourselves into a deadlock.
> -		 */
> -		cycle_raw = clock->cycle_raw;
> -		cycle_last = clock->cycle_last;
> -
> -		/* read clocksource: */
> -		cycle_now = clocksource_read(clock);
> -
> -		/* calculate the delta since the last update_wall_time: */
> -		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> -
> -	} while (cycle_raw != clock->cycle_raw ||
> -		 cycle_last != clock->cycle_last);
> -
> -	return cycle_raw + cycle_delta;
> +	return clocksource_get_basecycles(clock);
>  }
>  
>  unsigned long notrace cycles_to_usecs(cycle_t cycles)
> 
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
