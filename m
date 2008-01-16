Return-Path: <linux-kernel-owner+w=401wt.eu-S1754863AbYAPO4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbYAPO4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 09:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYAPO4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 09:56:09 -0500
Received: from tomts10.bellnexxia.net ([209.226.175.54]:32948 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279AbYAPO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 09:56:07 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aj0KAM+pjUdMROHU/2dsb2JhbACBWJAQnDA
Date: Wed, 16 Jan 2008 09:56:04 -0500
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
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
Message-ID: <20080116145604.GB31329@Krystal>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:48:24 up 73 days, 19:53,  4 users,  load average: 0.46, 0.45,
	0.50
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> [ CC'd Daniel Walker, since he had problems with this code ]
> 
> On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> >
> > I agree with you that I don't see how the compiler could reorder this.
> > So we forget about compiler barriers. Also, the clock source used is a
> > synchronized clock source (get_cycles_sync on x86_64), so it should make
> > sure the TSC is read at the right moment.
> >
> > However, what happens if the clock source is, say, the jiffies ?
> >
> > Is this case, we have :
> >
> > static cycle_t jiffies_read(void)
> > {
> >         return (cycle_t) jiffies;
> > }
> >
> > Which is nothing more than a memory read of
> >
> > extern unsigned long volatile __jiffy_data jiffies;
> 
> Yep, and that's not my concern.
> 

Hrm, I will reply to the rest of this email in a separate mail, but
there is another concern, simpler than memory ordering, that just hit
me :

If we have CPU A calling clocksource_accumulate while CPU B is calling
get_monotonic_cycles, but events happens in the following order (because
of preemption or interrupts). Here, to make things worse, we would be on
x86 where cycle_t is not an atomic write (64 bits) :


CPU A                  CPU B

clocksource read
update cycle_mono (1st 32 bits)
                       read cycle_mono
                       read cycle_last
                       clocksource read
                       read cycle_mono
                       read cycle_last
update cycle_mono (2nd 32 bits)
update cycle_last
update cycle_acc

Therefore, we have :
- an inconsistant cycle_monotonic value
- inconsistant cycle_monotonic and cycle_last values.

Or is there something I have missed ?

If you really want an seqlock free algorithm (I _do_ want this for
tracing!) :) maybe going in the RCU direction could help (I refer to my
RCU-based 32-to-64 bits lockless timestamp counter extension, which
could be turned into the clocksource updater).

Mathieu

> >
> > I think it is wrong to assume that reads from clock->cycle_raw and from
> > jiffies will be ordered correctly in SMP. I am tempted to think that
> > ordering memory writes to clock->cycle_raw vs jiffies is also needed in this
> > case (where clock->cycle_raw is updated, or where jiffies is updated).
> >
> > We can fall in the same kind of issue if we read the HPET, which is
> > memory I/O based. It does not seems correct to assume that MMIO vs
> > normal memory reads are ordered. (pointing back to this article :
> > http://lwn.net/Articles/198988/)
> 
> That and the dread memory barrier thread that my head is still spinning
> on.
> 
> Ok, lets take a close look at the code in question. I may be wrong, and if
> so, great, we can fix it.
> 
> We have this in get_monotonic_cycles:
> 
> {
> 	cycle_t cycle_now, cycle_delta, cycle_monotonic, cycle_last;
> 	do {
> 		cycle_monotonic = clock->cycle_monotonic;
> 		cycle_last = clock->cycle_last;
> 		cycle_now = clocksource_read(clock);
> 		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> 	} while (cycle_monotonic != clock->cycle_monotonic ||
> 		 cycle_last != clock->cycle_last);
> 	return cycle_monotonic + cycle_delta;
> }
> 
> and this in clocksource.h
> 
> static inline void clocksource_accumulate(struct clocksource *cs, cycle_t now)
> {
> 	cycle_t offset = (now - cs->cycle_last) & cs->mask;
> 	cs->cycle_last = now;
> 	cs->cycle_accumulated += offset;
> 	cs->cycle_monotonic += offset;
> }
> 
> now is usually just a clocksource_read() passed in.
> 
> The goal is to have clock_monotonic always return something that is
> greater than what was read the last time.
> 
> Let's make a few assumptions now (for others to shoot them down). One
> thing is that we don't need to worry too much about MMIO, because we are
> doing a read. This means we need the data right now to contiune. So the
> read being a function call should keep gcc from moving stuff around, and
> since we are doing an IO read, the order of events should be pretty much
> synchronized. in
> 
>     1. load cycle_last and cycle_monotonic (we don't care which order)*
>     2. read clock source
>     3. calculate delta and while() compare (order doesn't matter)
> 
> * we might care (see below)
> 
> If the above is incorrect, then we need to fix get_monotonic_cycles.
> 
> in clocksource_accumulate, we have:
> 
>   offset = ((now = cs->read()) - cycle_last) & cs->mask;
>   cycle_last = now;
>   cycle_accumulate += offset;
>   cycle_monotonic += offset;
> 
> The order of events here are. Using the same reasoning as above, the read
> must be first and completed because for gcc it's a function, and for IO,
> it needs to return data.
> 
>   1. cs->read
>   2. update cycle_last, cycle_accumulate, cycle_monotonic.
> 
> Can we assume, if the above for get_monotonic_cycles is correct, that
> since we read and compare cycle_last and cycle_monotonic, that neither of
> them have changed over the read? So we have a snapshot of the
> clocksource_accumulate.
> 
> So the worst thing that I can think of, is that cycle_monotonic is update
> *before* cycle_last:
> 
>    cycle_monotonic += offest;
>      <get_monotonic_cycles run on other CPU>
>    cycle_last = now;
> 
> 
> cycle_last = 5
> cycle_monotonic = 0
> 
> 
>     CPU 0                         CPU 1
>   ----------                  -------------
>  cs->read() = 10
>  offset = 10 - 5 = 5
>  cycle_monotonic = 5
>                             cycle_monotonic = 5
>                             cycle_last = 5
>                             cs->read() = 11
>                             delta = 11 - 5 = 6
>                             cycle_monotonic and cycle_last still same
>                             return 5 + 6 = 11
> 
>   cycle_last = 10
> 
>                             cycle_monotonic = 5
>                             cycle_last = 10
>                             cs->read() = 12
>                             delta = 12 - 10 = 2
>                             cycle_monotonic and cycle_last still same
>                             return 5 + 2 = 7
> 
>                            **** ERROR *****
> 
> So, we *do* need memory barriers.  Looks like cycle_last and
> cycle_monotonic need to be synchronized.
> 
> OK, will this do?
> 
> cycle_t notrace get_monotonic_cycles(void)
> {
>         cycle_t cycle_now, cycle_delta, cycle_monotonic, cycle_last;
>         do {
>                 cycle_monotonic = clock->cycle_monotonic;
> 		smp_rmb();
>                 cycle_last = clock->cycle_last;
>                 cycle_now = clocksource_read(clock);
>                 cycle_delta = (cycle_now - cycle_last) & clock->mask;
>         } while (cycle_monotonic != clock->cycle_monotonic ||
>                  cycle_last != clock->cycle_last);
>         return cycle_monotonic + cycle_delta;
> }
> 
> and this in clocksource.h
> 
> static inline void clocksource_accumulate(struct clocksource *cs, cycle_t now)
> {
>         cycle_t offset = (now - cs->cycle_last) & cs->mask;
>         cs->cycle_last = now;
> 	smp_wmb();
>         cs->cycle_accumulated += offset;
>         cs->cycle_monotonic += offset;
> }
> 
> We may still get to a situation where cycle_monotonic is of the old value
> and cycle_last is of the new value. That would give us a smaller delta
> than we want.
> 
> Lets look at this, with a slightly different situation.
> 
> cycle_last = 5
> cycle_monotonic = 0
> 
> 
>     CPU 0                         CPU 1
>   ----------                  -------------
>  cs->read() = 10
>  offset = 10 - 5 = 5
>  cycle_last = 10
>  cycle_monotonic = 5
> 
>                             cycle_monotonic = 5
>                             cycle_last = 10
>                             cs->read() = 12
>                             delta = 12 - 10 = 2
>                             cycle_monotonic and cycle_last still same
>                             return 5 + 2 = 7
> 
> 
>  cs->read() = 13
>  offset = 13 - 10 = 2
>  cycle_last = 13
> 
>                             cycle_monotonic = 5
>                             cycle_last = 13
>                             cs->read() = 14
>                             delta = 14 - 13 = 1
>                             cycle_monotonic and cycle_last still same
>                             return 5 + 1 = 6
> 
>                         **** ERROR ****
> 
> Crap, looks like we do need a stronger locking here :-(
> 
> Hmm, I might as well just use seq_locks, and make sure that tracing
> does not hit them.
> 
> Thanks!
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
