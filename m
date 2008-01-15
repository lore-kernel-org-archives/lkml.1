Return-Path: <linux-kernel-owner+w=401wt.eu-S1758577AbYAOWIl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758577AbYAOWIl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:08:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751839AbYAOWIb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:08:31 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:57466 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756641AbYAOWIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:08:30 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAFO9jEdMROHU/2dsb2JhbACBWKot
Date: Tue, 15 Jan 2008 17:08:24 -0500
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
Message-ID: <20080115220824.GB22242@Krystal>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:07:01 up 73 days,  3:12,  6 users,  load average: 0.42, 0.51,
	0.63
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> 
> On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> > >
> > > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > > ---
> > >  include/linux/clocksource.h |    3 ++
> > >  kernel/time/timekeeping.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 51 insertions(+)
> > >
> > > Index: linux-compile-i386.git/kernel/time/timekeeping.c
> > > ===================================================================
> > > --- linux-compile-i386.git.orig/kernel/time/timekeeping.c	2008-01-09 14:27:26.000000000 -0500
> > > +++ linux-compile-i386.git/kernel/time/timekeeping.c	2008-01-09 14:34:40.000000000 -0500
> > > @@ -103,6 +103,54 @@ static inline void __get_realtime_clock_
> > >  	timespec_add_ns(ts, nsecs);
> > >  }
> > >
> > > +cycle_t notrace get_monotonic_cycles(void)
> > > +{
> > > +	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
> > > +
> > > +	do {
> > > +		/*
> > > +		 * cycle_raw and cycle_last can change on
> > > +		 * another CPU and we need the delta calculation
> > > +		 * of cycle_now and cycle_last happen atomic, as well
> > > +		 * as the adding to cycle_raw. We don't need to grab
> > > +		 * any locks, we just keep trying until get all the
> > > +		 * calculations together in one state.
> > > +		 *
> > > +		 * In fact, we __cant__ grab any locks. This
> > > +		 * function is called from the latency_tracer which can
> > > +		 * be called anywhere. To grab any locks (including
> > > +		 * seq_locks) we risk putting ourselves into a deadlock.
> > > +		 */
> >
> > I wonder what makes the compiler read the clock->cycle_raw and
> > clock->cycle_last variables twice ? I guess some memory barriers could
> > be welcome here ?
> 
> We need both cycle_raw and cycle_last to be the same from the time we read
> the clock source to the time we calculate cycle_delta. If either one
> changes then delta is bogus.
> 

Ok, but what actually insures that the clock->cycle_* reads won't be
reordered across the clocksource_read() ?


> Also, it just occurred to me that this is an old patch. I thought I
> renamed cycle_raw to cycle_monotonic. But I must have lost that patch :-/
> 
> >
> > > +		cycle_raw = clock->cycle_raw;
> > > +		cycle_last = clock->cycle_last;
> > > +
> > > +		/* read clocksource: */
> > > +		cycle_now = clocksource_read(clock);
> > > +
> > > +		/* calculate the delta since the last update_wall_time: */
> > > +		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> > > +
> > > +	} while (cycle_raw != clock->cycle_raw ||
> > > +		 cycle_last != clock->cycle_last);
> > > +
> > > +	return cycle_raw + cycle_delta;
> > > +}
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
