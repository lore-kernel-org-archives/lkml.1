Return-Path: <linux-kernel-owner+w=401wt.eu-S1753251AbYIYRkM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbYIYRkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:40:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbYIYRj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:39:59 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60340 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbYIYRj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:39:59 -0400
Date: Thu, 25 Sep 2008 13:39:55 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@mbligh.org>,
       Martin Bligh <mbligh@google.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809251010291.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809251332540.29802@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> 
 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>  <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> 
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>  <1222339303.16700.197.camel@lappy.programming.kicks-ass.net>  <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809251120420.27300@gandalf.stny.rr.com> <alpine.LFD.1.10.0809251010291.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 25 Sep 2008, Linus Torvalds wrote:

> 
> 
> On Thu, 25 Sep 2008, Steven Rostedt wrote:
> > 
> > If we do not normalize, then we must come up yet another generic way to read 
> > the CPU clock for all archs. And then we also need to come up with another 
> > generic way to normalize it later for output.
> 
> Why would any of this be "generic"?

generic as in, could be implement in architecture dependent ways but with
a "generic" interface. IOW, I don't want the trace to be dependent on
any arch. ftrace already runs on x86, ppc, sparc64, mips, arm, sh, and 
more.

> 
> Quite the reverse. It should be as trace-buffer specific as possible, so 
> that we do *not* share any code or any constraints with other people.
> 
> Just do rdtsc at first, and make it depend on x86. If the thing is made 
> simple enough, it will be a couple of lines of code for architectures to 
> read their own timestamp counters.

I could do a HAVE_RING_BUFFER_TIMESTAMP config option for archs that 
implement it, and just use something dumb for those that don't. For now
I'll keep to sched_clock, just because it makes it easy for me. But with
the wrappers, it should be easy to change later.

> 
> And since the normalization is then no longer in the critical part, _that_ 
> can be architecture-independent, but obviously still trace-specific. You 
> need to know the frequency, and that involves having frequency events in 
> the trace if it changes, but if you don't see any frequency events you 
> just take "current frequency".

The one thing that seemed to me most apparent from talking to people
at LPC, is that they want a simple ring buffer API. If every tracer that
uses this must come up with its own time keeping management, I don't think
this will be used at all (except by those that are maintaining tracers
now).

> 
> And doing it at trace parse time, we can some day enable a boot trace that 
> actually WORKS. Have you looked at the timestamp events we get from 
> "sched_clock()" in early bootup? They show up in the kernel logs when you 
> have CONFIG_PRINTK_TIME. And they are totally and utterly broken and 
> _useless_ for the early stages right now. And they shouldn't have to be 
> that way.
> 
> Yeah, we'll never be able to trace stuff that happens really early 
> (tracing will obviously always need kernel page tables and some really 
> basic stuf working), but we should be able to trace through things like 
> TSC calibration for boot time analysis. It wasn't that long ago that we 
> had the whole discussion about TSC calibration taking 200ms. Or the early 
> ACPI code. And get meaningful data.

My logdev code has a define option to use bootmem for its buffers, and it 
also uses an atomic counter to try to keep things in order. Heck, at early 
boot, the events happen in order anyway, since it is still a single CPU 
system.

-- Steve

