Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYAOWBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYAOWBo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:01:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYAOWBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:01:35 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:41315 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYAOWBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:01:34 -0500
Date: Tue, 15 Jan 2008 17:01:30 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <20080115214636.GD17439@Krystal>
Message-ID: <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org>
 <20080115214636.GD17439@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
> >
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  include/linux/clocksource.h |    3 ++
> >  kernel/time/timekeeping.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 51 insertions(+)
> >
> > Index: linux-compile-i386.git/kernel/time/timekeeping.c
> > ===================================================================
> > --- linux-compile-i386.git.orig/kernel/time/timekeeping.c	2008-01-09 14:27:26.000000000 -0500
> > +++ linux-compile-i386.git/kernel/time/timekeeping.c	2008-01-09 14:34:40.000000000 -0500
> > @@ -103,6 +103,54 @@ static inline void __get_realtime_clock_
> >  	timespec_add_ns(ts, nsecs);
> >  }
> >
> > +cycle_t notrace get_monotonic_cycles(void)
> > +{
> > +	cycle_t cycle_now, cycle_delta, cycle_raw, cycle_last;
> > +
> > +	do {
> > +		/*
> > +		 * cycle_raw and cycle_last can change on
> > +		 * another CPU and we need the delta calculation
> > +		 * of cycle_now and cycle_last happen atomic, as well
> > +		 * as the adding to cycle_raw. We don't need to grab
> > +		 * any locks, we just keep trying until get all the
> > +		 * calculations together in one state.
> > +		 *
> > +		 * In fact, we __cant__ grab any locks. This
> > +		 * function is called from the latency_tracer which can
> > +		 * be called anywhere. To grab any locks (including
> > +		 * seq_locks) we risk putting ourselves into a deadlock.
> > +		 */
>
> I wonder what makes the compiler read the clock->cycle_raw and
> clock->cycle_last variables twice ? I guess some memory barriers could
> be welcome here ?

We need both cycle_raw and cycle_last to be the same from the time we read
the clock source to the time we calculate cycle_delta. If either one
changes then delta is bogus.

Also, it just occurred to me that this is an old patch. I thought I
renamed cycle_raw to cycle_monotonic. But I must have lost that patch :-/

>
> > +		cycle_raw = clock->cycle_raw;
> > +		cycle_last = clock->cycle_last;
> > +
> > +		/* read clocksource: */
> > +		cycle_now = clocksource_read(clock);
> > +
> > +		/* calculate the delta since the last update_wall_time: */
> > +		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> > +
> > +	} while (cycle_raw != clock->cycle_raw ||
> > +		 cycle_last != clock->cycle_last);
> > +
> > +	return cycle_raw + cycle_delta;
> > +}

-- Steve

