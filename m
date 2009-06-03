Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbZFCHEU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbZFCHEU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 03:04:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbZFCHEG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 03:04:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:54288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZFCHEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 03:04:05 -0400
Subject: Re: [PATCH] sched: sched_clock() clocksource handling.
From: Peter Zijlstra <peterz@infradead.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Daniel Walker <dwalker@fifo99.com>,
       Linus Walleij <linus.ml.walleij@gmail.com>,
       Andrew Victor <linux@maxim.org.za>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Stultz <johnstul@linux.vnet.ibm.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1243981485.3501.92.camel@localhost>
References: <20090602071718.GA17710@linux-sh.org>
	 <1243981485.3501.92.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 03 Jun 2009 09:03:49 +0200
Message-Id: <1244012629.13761.1074.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-02 at 15:24 -0700, john stultz wrote:

> >  /*
> >   * Scheduler clock - returns current time in nanosec units.
> > @@ -38,8 +40,15 @@
> >   */
> >  unsigned long long __attribute__((weak)) sched_clock(void)
> >  {
> > -	return (unsigned long long)(jiffies - INITIAL_JIFFIES)
> > -					* (NSEC_PER_SEC / HZ);
> > +	unsigned long long time;
> > +	struct clocksource *clock;
> > +
> > +	rcu_read_lock();
> > +	clock = rcu_dereference(sched_clocksource);
> > +	time = cyc2ns(clock, clocksource_read(clock));
> > +	rcu_read_unlock();
> > +
> > +	return time;
> >  }
> 
> So in the above, cyc2ns could overflow prior to a u64 wrap. 
> 
> 
> cyc2ns does the following:
> 	(cycles * cs->mult) >> cs->shift;
> 
> The (cycles*cs->mult) bit may overflow for large cycle values, and its
> likely that could be fairly quickly, as ideally we have a large shift
> value to keep the precision high so mult will also be large.
> 
> I just went through some of the math here with Jon Hunter in this
> thread: http://lkml.org/lkml/2009/5/15/466
> 
> None the less, either sched_clock will have to handle overflows or we'll
> need to do something like the timekeeping code where there's an periodic
> accumulation step that keeps the unaccumulated cycles small.
> 
> That said, the x86 sched_clock() uses cycles_2_ns() which is similar
> (but with a smaller scale value). So its likely it would also overflow
> prior to the u64 boundary as well.
> 
> 
> > diff --git a/kernel/time/jiffies.c b/kernel/time/jiffies.c
> > index c3f6c30..727d881 100644
> > --- a/kernel/time/jiffies.c
> > +++ b/kernel/time/jiffies.c
> > @@ -52,7 +52,7 @@
> > 
> >  static cycle_t jiffies_read(struct clocksource *cs)
> >  {
> > -	return (cycle_t) jiffies;
> > +	return (cycle_t) (jiffies - INITIAL_JIFFIES);
> >  }
> 
> Also, on 32bit systems this will may overflow ~monthly. However, this
> isn't different then the existing sched_clock() implementation, so
> either its been already handled and sched_clock is more robust then I
> thought or there's a bug there.

I suspect you just found two bugs.. I thought to remember the jiffies
based sched clock used to use jiffies_64, but I might be mistaken.

As to the x86 sched_clock wrapping before 64bits, how soon would that
be? The scheduler code really assumes it wraps on 64bit and I expect it
to do something mighty odd when it wraps sooner (although I'd have to
audit the code to see exactly what).

Aah, I think the filtering in kernel/sched_clock.c fixes it up. The wrap
will be visible as a large backward motion which will be discarded.
