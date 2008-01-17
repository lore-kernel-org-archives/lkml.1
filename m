Return-Path: <linux-kernel-owner+w=401wt.eu-S1755281AbYAQAd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281AbYAQAd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYAQAdh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:33:37 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:56748 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbYAQAdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:33:35 -0500
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
From: john stultz <johnstul@us.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
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
In-Reply-To: <20080116233927.GB23895@Krystal>
References: <20080109233044.777564395@goodmis.org>
	 <20080115214636.GD17439@Krystal>
	 <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
	 <20080115220824.GB22242@Krystal>
	 <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
	 <20080116031730.GA2164@Krystal>
	 <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
	 <20080116145604.GB31329@Krystal>
	 <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
	 <1200523867.6127.5.camel@localhost.localdomain>
	 <20080116233927.GB23895@Krystal>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 16:33:23 -0800
Message-Id: <1200530004.6127.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-16 at 18:39 -0500, Mathieu Desnoyers wrote:
> * john stultz (johnstul@us.ibm.com) wrote:
> > 
> > On Wed, 2008-01-16 at 14:36 -0800, john stultz wrote:
> > > On Jan 16, 2008 6:56 AM, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > > If you really want an seqlock free algorithm (I _do_ want this for
> > > > tracing!) :) maybe going in the RCU direction could help (I refer to my
> > > > RCU-based 32-to-64 bits lockless timestamp counter extension, which
> > > > could be turned into the clocksource updater).
> > > 
> > > Yea. After our earlier discussion and talking w/ Steven, I'm taking a
> > > swing at this now.  The lock-free method still doesn't apply to the
> > > update_wall_time function, but does work fine for the monotonic cycle
> > > uses.  I'll send a patch for review as soon as I get things building.
> > 
> > So here's my first attempt at adding Mathieu's lock-free method to
> > Steven's get_monotonic_cycles() interface. 
> > 
> > Completely un-tested, but it builds, so I figured I'd send it out for
> > review.
> > 
> > I'm not super sure the update or the read doesn't need something
> > additional to force a memory access, but as I didn't see anything 
> > special in Mathieu's implementation, I'm going to guess this is ok.
> > 
> > Mathieu, Let me know if this isn't what you're suggesting.
> > 
> > Signed-off-by: John Stultz <johnstul@us.ibm.com>
> > 
> > Index: monotonic-cleanup/include/linux/clocksource.h
> > ===================================================================
> > --- monotonic-cleanup.orig/include/linux/clocksource.h	2008-01-16 12:22:04.000000000 -0800
> > +++ monotonic-cleanup/include/linux/clocksource.h	2008-01-16 14:41:31.000000000 -0800
> > @@ -87,9 +87,17 @@
> >  	 * more than one cache line.
> >  	 */
> >  	struct {
> > -		cycle_t cycle_last, cycle_accumulated, cycle_raw;
> > -	} ____cacheline_aligned_in_smp;
> 
> Shouldn't the cycle_last and cycle_accumulated by in the array too ?

No, we're leaving cycle_last and cycle_accumulated alone. They're
relating to the update_wall_time conversion of cycles to xtime. 

> > +		cycle_t cycle_last, cycle_accumulated;
> >  
> > +		/* base structure provides lock-free read
> > +		 * access to a virtualized 64bit counter
> > +		 * Uses RCU-like update.
> > +		 */
> > +		struct {
> 
> We had cycle_raw before, why do we need the following two ?
>
> > +			cycle_t cycle_base_last, cycle_base;
> 
> I'm not quite sure why you need both cycle_base_last and cycle_base...

So on my first shot at this, I tried to layer the concepts. Using the
lock-free method to create a abstracted 64bit counter, as provided by
get_monotonic_cycles(). Then I tried to use that abstraction directly in
the update_wall_time() code, reading the abstracted 64bit counter and
using it to update time.

However, then we start keeping cycle_last in 64bit cycles, rather then
an actual counter read. This then caused changes to be needed in the
arch vsyscall implementations, and that started to get ugly, as we had
to also re-implement the abstracted 64bit counter w/ the lock free
method as well. 

So I just backed off and tried to make it simple: We have two sets of
data that counts cycles from the clocksource. One for timekeeping and
one for get_monotoinc_cycles(). It is a little redundant, but I don't
think you can escape that (the layering method above also has
redundancy, but its just hidden until you implement the vsyscall gtod
methods).


> I think I'll need a bit of an explanation of what you are trying to
> achieve here to see what to expect from the clock source. Are you trying
> to deal with non-synchronized TSCs across CPUs in a way that will
> generate a monotonic (sometimes stalling) clock ?

No no no.. I'm not touching the non-synced TSC issue. I'm just trying to
take clocksource counters, which may be of different bit-widths (ACPI PM
is 24bits, for instance), and create lock-free method to translate that
into a virtual 64bit wide counter (using an accumulation bucket,
basically).

> What I am trying to say is : I know you are trying to make a virtual
> clock source where time cannot go backward, but what are your
> assumptions about the "real" clock source ?

The assumptions of the real clocksource is the same we keep in the
timekeeping core. It counts forward, at a constant rate and only wraps
after the mask value has been reached. 

> Is the intent to deal with an HPET suddenly reset to 0 or something
> like this ?

Well, dealing with clocksources wrapping short of 64bits.

> Basically, I wonder why you have to calculate the current cycle count
> from the previous update_wall_time event. Is is because you need to be
> consistent when a clocksource change occurs ?

Actually, we try to do it from the last clocksource_accumulate() call
(which is called from update_wall_time).


> > +		} base[2];
> > +		int base_num;
> > +	} ____cacheline_aligned_in_smp;
> >  	u64 xtime_nsec;
> >  	s64 error;
> >  
> > @@ -175,19 +183,21 @@
> >  }
> >  
> >  /**
> > - * clocksource_get_cycles: - Access the clocksource's accumulated cycle value
> > + * clocksource_get_basecycles: - get the clocksource's accumulated cycle value
> >   * @cs:		pointer to clocksource being read
> >   * @now:	current cycle value
> >   *
> >   * Uses the clocksource to return the current cycle_t value.
> >   * NOTE!!!: This is different from clocksource_read, because it
> > - * returns the accumulated cycle value! Must hold xtime lock!
> > + * returns a 64bit wide accumulated value.
> >   */
> >  static inline cycle_t
> > -clocksource_get_cycles(struct clocksource *cs, cycle_t now)
> > +clocksource_get_basecycles(struct clocksource *cs, cycle_t now)
> >  {
> > -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> > -	offset += cs->cycle_accumulated;
> 
> I would disable preemption in clocksource_get_basecycles. We would not
> want to be scheduled out while we hold a pointer to the old array
> element.

Ok. This is the part I wasn't so sure about. But yes, that sounds
reasonable. 


> > +	int num = cs->base_num;
> 
> Since you deal with base_num in a shared manner (not per cpu), you will
> need a smp_read_barrier_depend() here after the cs->base_num read.

Ah, thanks. I'll add that in.

> You should think about reading the cs->base_num first, and _after_ that
> read the real clocksource. Here, the clocksource value is passed as
> parameter. It means that the read clocksource may have been read in the
> previous RCU window.

Hmm. Ok, still need to wrap my head around that one, but I think it
makes sense.


> > +	cycle_t offset = (now - cs->base[num].cycle_base_last);
> > +	offset &= cs->mask;
> > +	offset += cs->base[num].cycle_base;
> >  	return offset;
> >  }
> >  
> > @@ -197,14 +207,25 @@
> >   * @now:	current cycle value
> >   *
> >   * Used to avoids clocksource hardware overflow by periodically
> > - * accumulating the current cycle delta. Must hold xtime write lock!
> > + * accumulating the current cycle delta. Uses RCU-like update, but
> > + * ***still requires the xtime_lock is held for writing!***
> >   */
> >  static inline void clocksource_accumulate(struct clocksource *cs, cycle_t now)
> >  {
> 
> Why do we still require xtime_lock here ? Can you tell exactly which
> contexts this function will be called from (periodical timer interrupt?)
> I guess it is called from one and only one CPU periodically.

Well, the main reason we need the xtime_lock, is because the xtime_lock
still protects the cycle_last and cycle_accumulated values (which are
not lock-free). This is part of the redundancy issue above. We're
updating similar structures, that store different data from the same
source. One of the two can be handled lock-free, the other cannot.

In addition however, doing the update under the lock makes sure we don't
do the update in parallel (serializes writers, basically) if
clocksource_accumulate is called on different cpus (it shouldn't happen
right now, but in the past it has been possible).


> > -	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> > +	/* First update the monotonic base portion.
> > +	 * The dual array update method allows for lock-free reading.
> > +	 */
> > +	int num = !cs->base_num;
> > +	cycle_t offset = (now - cs->base[!num].cycle_base_last);
> 
> !0 is not necessarily 1. This is why I use cpu_synth->index ? 0 : 1 in
> my code. The two previous lines seems buggy. (I did the same mistake in
> my first implementation) ;)

Heh. My first thought to this was just disbelief("WHAAAH? NOOOO!"). But
Steven made clear the logical issue on irc. Thanks for pointing it out.
I've been using that assumption (as well as the !! trick) for so long it
will be a hard habit to break. :)

I'll add in Steven's method to the code.

> > +	offset &= cs->mask;
> > +	cs->base[num].cycle_base = cs->base[!num].cycle_base + offset;
> 
> Here too.
> 
> > +	cs->base[num].cycle_base_last = now;
> 
> Since you deal with shared data (in my algo, I use per-cpu data), you
> have to add a wmb() before the base_num value update. Only then will you
> ensure that other CPUs will see consistent values.

Ok. Thanks I was worried about that as well.


Thanks so much for the review! I'll go through and make the update
changes you suggested. Do let me know if my explanations above to your
questions make sense.

thanks
-john


