Return-Path: <linux-kernel-owner+w=401wt.eu-S1757189AbZBWSea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189AbZBWSea (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 13:34:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbZBWSeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 13:34:21 -0500
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:47614 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753757AbZBWSeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 13:34:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvAEAG56oklMQWXi/2dsb2JhbACBbpMzs0KNEoQPBg
Date: Mon, 23 Feb 2009 13:34:14 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Rusty Russell <rusty@rustcorp.com.au>, "H. Peter Anvin" <hpa@zytor.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 4/6] ftrace, x86: make kernel text writable only for
	conversions
Message-ID: <20090223183414.GA3962@Krystal>
References: <20090223023332.GA5430@Krystal> <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com> <20090223045357.GA9158@Krystal> <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal> <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com> <20090223173108.GB1441@Krystal> <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0902231236340.18221@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:28:01 up 2 days, 10:02,  6 users,  load average: 0.77, 0.51,
	0.55
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> 
> On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
> > > 
> > > Hmm, lets see. I simply set a bit in the PTE mappings. There's not many, 
> > > since a lot are 2M pages, for x86_64. Call stop_machine, and now I can 
> > > modify 1 or 20,000 locations. Set the PTE bit back. Note, the changing of 
> > > the bits are only done when CONFIG_DEBUG_RODATA is set.
> > > 
> > > text_poke requires allocating a page. Map the page into memory. Set up a 
> > > break point.
> > 
> > text_poke does not _require_ a break point. text_poke can work with
> > stop_machine.
> 
> It can? Doesn't text_poke require allocating pages? The code called by 
> stop_machine is all atomic. vmap does not give an option to allocate with 
> GFP_ATOMIC.
> 
> 
> > There are two different problems here :
> 
> I agree that they are two different problems. The reason I relate them is 
> because text_poke can not be called from a stop_machine call.
> 
> > 
> > - How you deal with concurrency
> >   - you use stop machine
> >   - I use breakpoints
> > - How you deal with RO page mappings
> >   - you change the kernel page flags
> >   - i use text_poke
> > 
> > Please don't mix those separate concerns.
> 
> So you have two different concerns. One is that I use stop_machine, 
> instead of break points, the other is that I modify all kernel text to
> make the change.
> 
> Lets look at them separately.
> 
> The stop_machine vs. break points.
> 
> breakpoints is a cool trick, but is not implemented on all the archs that 
> dynamic ftrace is.
> 
> break points are performed on a running system. This may be lower in 
> latency tracing when the tracer is started, but can create a large number 
> of variables that can not all be understood.
> 
> stop_machine is quite simple. No need to take traps, no need to handle 
> what to do when another process runs the code being changed.
> 
> When making the hooks, stop_machine can add a bit of a interrupt latency. 
> But this is only when the hooks are added or removed. Why is this such a 
> big deal?

On a live system, adding interrupt latency even when tracing is not
active yet _is_ a big deal.

> It is much easier to add the hooks with tracing disabled (via 
> a simple toggle bit). Then start and stop your tracing by using the toggle 
> bit. After you are all done, then remove the hooks. Or just keep them 
> on since they are low overhead anyway (only a few hooks right?)
> 
> 
> CONFIG_DEBUG_RODATA (only an x86 issue at the moment)
> 
> text_poke vs changing all pages:
> 
> You said this is a separate issue than stop_machine. But that is not the 
> case. text_poke can not be done in an atomic section. This removes it from 
> being used by stop_machine.
> 

Hrm, I wonder if we could create a variant of vmap_ram that would be
atomic ? That would clearly fix our problems.

> As you said, text_poke only handles the RO/RW issue, not the modifying of 
> code on the fly. Thus, keeping stop_machine around, we must also not use 
> text_poke.

Not if we modify vmap_ram...

> 
> I guess this takes the text_poke vs changing all pages out of the 
> question. While stop_machine is still being used, we can not use 
> text_poke (without rewriting it).

Where is the problem ? Let's improve it if needed.

> 
> Also when we want to trace all functions, is it really necessary to vmap
> each one at a time? Andi suggested that we could optimise by mapping 
> larger pages, and finding the ones that share the page. This too would 
> require a rewrite of text_poke.
> 

This is an optimization, we should see the performance penality first
before we start optimizing things too early.

Mathieu

> 
> 
> > > > 
> > > > If, in the end, your argument is "the function tracer works as-is now,
> > > > and I have no time to change it given it represents too much work" or "I
> > > > don't care about your use-cases", I'm OK with that. But please then don't
> > > > argue that it's because it's the best technical solution when it isn't.
> > > 
> > > No, I have yet to hear a valuable argument against stop_machine. You are 
> > > pushing the burden of proof on me, when we have something that does work, 
> > > on several archs. You want me to redesign the system to be x86 only, and 
> > > then say, hey, my original code works better.
> > > 
> > 
> > stop_machine involves high interrupt latency. This is the argument I've
> > been repeating for 1-2 emails already. And I have to disagree with you :
> > we can do this code generically given the right abstractions
> > (BREAKPOINT_INSN* macros I proposed earlier). Is having something that
> > "works" your only argument to stop improving it ?
> 
> The high interrupt latency only happens at the time we need to hook the 
> functions. This does not mean it is the time to start the tracing. That 
> can be done separately.
> 
> Your only concern is the stop_machine latency? Then you might as well also 
> prevent modules, since that uses stop machine too. Again, this happens 
> only when the tracer hooks are added or removed. This is done at a time 
> the sys-admin will activate it. It is not a random latency that is 
> occurred by some timer or other asynchronous event.
> 
> > 
> > > I do not see text_poke being theoretically better. The only reason you 
> > > given me to use it is because you dislike stop_machine.
> > > 
> > 
> > There is absolutely no link between stop_machine and text_poke. I argue
> > against stop_machine saying that the breakpoint approach is less
> > intrusive because it does not involve disabling interrupts for so long,
> > and I argue against modifying the kernel page flags because that
> > modifies the access rights of the core kernel and modules to RO
> > mappings, which is IMO a side-effect that we should eliminate _if we
> > can_. Please keep those two concerns separate.
> 
> text_poke can not be executed from stop_machine. There's the link. The two 
> concerns are not separate.
> 
> Your concern with stop_machine is that it will cause an interrupt latency 
> when the sysadmin enables or disables the functions. There exists other 
> interrupt latencies that can be worst that are asynchronous. Run hackbench 
> with the irqs off tracer and see for yourself.
> 
> -- Steve
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
