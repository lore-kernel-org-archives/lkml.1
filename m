Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbYAPBjU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbYAPBjU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 20:39:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755162AbYAPBjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 20:39:04 -0500
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:50217 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754289AbYAPBjD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 20:39:03 -0500
Date: Tue, 15 Jan 2008 20:38:43 -0500 (EST)
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
In-Reply-To: <20080115220824.GB22242@Krystal>
Message-ID: <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org> <20080109233044.777564395@goodmis.org>
 <20080115214636.GD17439@Krystal> <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
 <20080115220824.GB22242@Krystal>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 15 Jan 2008, Mathieu Desnoyers wrote:
>
> Ok, but what actually insures that the clock->cycle_* reads won't be
> reordered across the clocksource_read() ?

<looks at code>

Hmm, interesting.I didn't notice that clocksource_read() is a static
inline.  I was thinking that since it was passing a pointer to a function,
gcc could not assume that it could move that code across it. But now
looking to see that clocksource_read is simply a static inline that does:

  cs->read();

But still, can gcc assume that it can push loads of unknown origin
variables across function calls? So something like:

static int *glob;

void foo(void) {
	int x;

	x = *glob;

	bar();

	if (x != *glob)
		/* ... */
}

I can't see how any compiler could honestly move the loading of the first
x after the calling of bar(). With glob pointing to some unknown
variable, that may be perfectly fine for bar to modify.


> > >
> > > > +		cycle_raw = clock->cycle_raw;
> > > > +		cycle_last = clock->cycle_last;
> > > > +
> > > > +		/* read clocksource: */
> > > > +		cycle_now = clocksource_read(clock);

So the question here is,can cycle_raw and cycle_last be loaded from
the unknown source that clock points to after the call to
clocksource_read()?

 I'm thinking not.

> > > > +
> > > > +		/* calculate the delta since the last update_wall_time: */
> > > > +		cycle_delta = (cycle_now - cycle_last) & clock->mask;
> > > > +
> > > > +	} while (cycle_raw != clock->cycle_raw ||
> > > > +		 cycle_last != clock->cycle_last);
> > > > +
> > > > +	return cycle_raw + cycle_delta;
> > > > +}


-- Steve

