Return-Path: <linux-kernel-owner+w=401wt.eu-S1754562AbYAQDA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbYAQDA0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:00:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751701AbYAQDAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:00:13 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:48547 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751471AbYAQDAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:00:11 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAH5TjkdMROHU/2dsb2JhbACBWKxy
Date: Wed, 16 Jan 2008 21:50:04 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
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
Message-ID: <20080117025004.GE2322@Krystal>
References: <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com> <1200523867.6127.5.camel@localhost.localdomain> <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com> <1200536889.6127.52.camel@localhost.localdomain> <20080117024000.GD2322@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080117024000.GD2322@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:41:24 up 74 days,  7:46,  5 users,  load average: 0.27, 1.12,
	0.98
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> * john stultz (johnstul@us.ibm.com) wrote:
> > 
> > On Wed, 2008-01-16 at 18:33 -0500, Steven Rostedt wrote:
> > > Thanks John for doing this!
> > > 
> > > (comments imbedded)
> > > 
> > > On Wed, 16 Jan 2008, john stultz wrote:
> > > > +	int num = !cs->base_num;
> > > > +	cycle_t offset = (now - cs->base[!num].cycle_base_last);
> > > > +	offset &= cs->mask;
> > > > +	cs->base[num].cycle_base = cs->base[!num].cycle_base + offset;
> > > > +	cs->base[num].cycle_base_last = now;
> > > 
> > > I would think that we would need some sort of barrier here. Otherwise,
> > > base_num could be updated before all the cycle_base. I'd expect a smp_wmb
> > > is needed.
> > 
> > Hopefully addressed in the current version.
> > 
> > 
> > > > Index: monotonic-cleanup/kernel/time/timekeeping.c
> > > > ===================================================================
> > > > --- monotonic-cleanup.orig/kernel/time/timekeeping.c	2008-01-16 12:21:46.000000000 -0800
> > > > +++ monotonic-cleanup/kernel/time/timekeeping.c	2008-01-16 14:15:31.000000000 -0800
> > > > @@ -71,10 +71,12 @@
> > > >   */
> > > >  static inline s64 __get_nsec_offset(void)
> > > >  {
> > > > -	cycle_t cycle_delta;
> > > > +	cycle_t now, cycle_delta;
> > > >  	s64 ns_offset;
> > > >
> > > > -	cycle_delta = clocksource_get_cycles(clock, clocksource_read(clock));
> > > > +	now = clocksource_read(clock);
> > > > +	cycle_delta = (now - clock->cycle_last) & clock->mask;
> > > > +	cycle_delta += clock->cycle_accumulated;
> > > 
> > > Is the above just to decouple the two methods?
> > 
> > Yep. clocksource_get_cycles() ended up not being as useful as an helper
> > function (I was hoping the arch vsyscall implementations could use it,
> > but they've done too much optimization - although that may reflect a
> > need up the chain to the clocksource structure).
> > 
> 
> The problem with vsyscall is that we will have a hard time disabling
> preemption :( Therefore, insuring that the read of the data is done in a
> timely manner is hard to do.
> 

Sorry for self-reply, but I thought, in the past, of a way to make this
possible.

It would imply the creation of a new vsyscall : vgetschedperiod

It would read a counter that would increment each time the thread is
scheduled out (or in). It would be a per thread counter (not a per cpu
counter) so we can deal appropriately with a stopped thread that would
happen to come back running a loooong time afterward (if we do per-cpu
counters, we could get the same 32 bits counter value falsely if it is
shared with other thread activity).

Then, the clocksource read code would look like :

int period;

do {
  period = vgetschedperiod();

  perform the clocksource read..

} while (period != vgetschedperiod());

Therefore, we would be sure that we have not been scheduled out while
reading the value. I think this new vsyscall could be useful for others.
Actually, it would make implementation of RCU in user-space possible (as
long as the read-side can retry the read operation).

Mathieu

> 
> > thanks
> > -john
> > 
> > 
> 
> -- 
> Mathieu Desnoyers
> Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
> OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
