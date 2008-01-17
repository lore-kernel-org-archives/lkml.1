Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbYAQC2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbYAQC2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 21:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbYAQC2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 21:28:20 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58507 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353AbYAQC2T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 21:28:19 -0500
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
From: john stultz <johnstul@us.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
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
In-Reply-To: <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
References: <20080109232914.676624725@goodmis.org>
	 <20080109233044.777564395@goodmis.org>  <20080115214636.GD17439@Krystal>
	 <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com>
	 <20080115220824.GB22242@Krystal>
	 <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com>
	 <20080116031730.GA2164@Krystal>
	 <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com>
	 <20080116145604.GB31329@Krystal>
	 <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
	 <1200523867.6127.5.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0801161827450.17781@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 18:28:09 -0800
Message-Id: <1200536889.6127.52.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-01-16 at 18:33 -0500, Steven Rostedt wrote:
> Thanks John for doing this!
> 
> (comments imbedded)
> 
> On Wed, 16 Jan 2008, john stultz wrote:
> > +	int num = !cs->base_num;
> > +	cycle_t offset = (now - cs->base[!num].cycle_base_last);
> > +	offset &= cs->mask;
> > +	cs->base[num].cycle_base = cs->base[!num].cycle_base + offset;
> > +	cs->base[num].cycle_base_last = now;
> 
> I would think that we would need some sort of barrier here. Otherwise,
> base_num could be updated before all the cycle_base. I'd expect a smp_wmb
> is needed.

Hopefully addressed in the current version.


> > Index: monotonic-cleanup/kernel/time/timekeeping.c
> > ===================================================================
> > --- monotonic-cleanup.orig/kernel/time/timekeeping.c	2008-01-16 12:21:46.000000000 -0800
> > +++ monotonic-cleanup/kernel/time/timekeeping.c	2008-01-16 14:15:31.000000000 -0800
> > @@ -71,10 +71,12 @@
> >   */
> >  static inline s64 __get_nsec_offset(void)
> >  {
> > -	cycle_t cycle_delta;
> > +	cycle_t now, cycle_delta;
> >  	s64 ns_offset;
> >
> > -	cycle_delta = clocksource_get_cycles(clock, clocksource_read(clock));
> > +	now = clocksource_read(clock);
> > +	cycle_delta = (now - clock->cycle_last) & clock->mask;
> > +	cycle_delta += clock->cycle_accumulated;
> 
> Is the above just to decouple the two methods?

Yep. clocksource_get_cycles() ended up not being as useful as an helper
function (I was hoping the arch vsyscall implementations could use it,
but they've done too much optimization - although that may reflect a
need up the chain to the clocksource structure).

thanks
-john


