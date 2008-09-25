Return-Path: <linux-kernel-owner+w=401wt.eu-S1751395AbYIYXAR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751395AbYIYXAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 19:00:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752922AbYIYXAC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 19:00:02 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:34763 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752794AbYIYXAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 19:00:01 -0400
Date: Thu, 25 Sep 2008 18:59:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Martin Bligh <mbligh@google.com>,
       Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <48DC1338.6050107@goop.org>
Message-ID: <alpine.DEB.1.10.0809251848170.32742@gandalf.stny.rr.com>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu> <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org> <48DBFC7D.4050208@goop.org>
 <alpine.LFD.1.10.0809251448340.3265@nehalem.linux-foundation.org> <48DC1338.6050107@goop.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Jeremy Fitzhardinge wrote:

> Linus Torvalds wrote:
> > The reason I say "and no" is that it's not technically really possible to 
> > atomically give the exact TSC at which the frequency change took place. We 
> > just don't have the information, and I doubt we will ever have it.
> >   
> 
> Well, you don't need the tsc at the precise moment of the frequency
> change.  You just need to emit the current tsc+frequency+wallclock time
> before you emit any more delta records after the frequency change.  You
> can't fetch all those values instantaneously, but you can get close.

Even in my last version I added a "TIME_STAMP" type that can be used in 
the future to add some kind of synchronization into the trace, that reads
GTOD or whatnot.

But as you can see, I've been trying to implement these various ideas, 
since the devil is in the details and the code is the details.

How do you get this GTOD read in the ring buffer? If the ring buffer does
it without any knowledge from the tracer, it may be doing it a 
inappropriate times. This would also imply that the GTOD infrastructure 
itself is reentrent safe.  Imagine tracing the GTOD code when the buffer 
decides it is about time to add the GTOD timestamp into the buffer. Can 
the GTOD handle this recursion. If the GTOD has spinlocks, probably not.

Perhaps we can add a ring_buffer_write_safe() method that would prevent 
the trace from doing these. Or we can add a way for the tracer to trigger 
a time event (ring_buffer_tick());


> asm/x86/kernel/pvclock.c does the tsc to ns conversion with just adds
> and multiplies, but unfortunately it can't be expressed in C because it
> uses the extra precision the x86 gives for multiplies.

If we do end up making a new clock API, I imagine that each arch will 
define their own.

-- Steve

