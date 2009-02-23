Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZBWQsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZBWQsq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 11:48:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753745AbZBWQsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 11:48:37 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40130 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753289AbZBWQsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 11:48:36 -0500
Date: Mon, 23 Feb 2009 11:48:32 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
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
In-Reply-To: <20090223161312.GA30279@Krystal>
Message-ID: <alpine.DEB.2.00.0902231125520.18221@gandalf.stny.rr.com>
References: <20090220011316.379904625@goodmis.org> <20090220011521.003556651@goodmis.org> <87y6vyuzsn.fsf@basil.nowhere.org> <alpine.DEB.2.00.0902221741040.18221@gandalf.stny.rr.com> <20090223023332.GA5430@Krystal> <alpine.DEB.2.00.0902222317510.18221@gandalf.stny.rr.com>
 <20090223045357.GA9158@Krystal> <alpine.DEB.2.00.0902230928000.18221@gandalf.stny.rr.com> <20090223154258.GB28727@Krystal> <alpine.DEB.2.00.0902231044050.18221@gandalf.stny.rr.com> <20090223161312.GA30279@Krystal>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 23 Feb 2009, Mathieu Desnoyers wrote:
> It can, by using your function tracer. It has a mode where it can
> enable/disable a filter in a callback connected on tracepoints. This
> filter is then used to enable detailed function tracing for a short time
> window. Also, you could think of tracing every function calls with
> LTTng's flight recorder mode, which only spins in memory overwriting the
> oldest information. That would provide snapshots on demand of the last
> functions called.
> 
> > Now, yes, if you only select a few functions, there's no noticeable 
> > overhead. And yes then you would need to do the stop_machine anyway, and 
> > there will be a small window where the kernel text will be writable. 
> > Tracing only a small set of functions (say a few 100) is not much of an 
> > overhead, and I could see that being done on a production system.
> > 
> 
> This is what LTTng can do today. But that involves the function tracer
> stop_machine() call, which I dislike.

What's wrong with stop_machine?  Specifically, what do you dislike about 
it?

> 
> > > 
> > > I agree that the racy time window is not that large and is not really a
> > > security concern, but it's still just annoying.
> > 
> > Annoying? how so?
> > 
> > Again, the stop_machine part has nothing to do with DEBUG_RODATA, it is 
> > about the safest and easiest way to modify kernel text.
> > 
> 
> We are running in circles here because there is no real argument
> brought.
> 
> 1 - You claim that changing the kernel's mapping, which has been
> pointed out as an intrusive kernel modification, is faster than using a
> text-poke-like approach. Please provide numbers to support such claims.

Hmm, lets see. I simply set a bit in the PTE mappings. There's not many, 
since a lot are 2M pages, for x86_64. Call stop_machine, and now I can 
modify 1 or 20,000 locations. Set the PTE bit back. Note, the changing of 
the bits are only done when CONFIG_DEBUG_RODATA is set.

text_poke requires allocating a page. Map the page into memory. Set up a 
break point. Knowing what to do when that break point is hit by another 
process. Modify the one location. Unmap the page. Free the page. Remove 
the breakpoint.

Yes, this may be faster if I only modify one location. I would be hard 
pressed that this is faster when I modify a few hundred locations. 
The stop_machine method does it all at once. Not one at a time.


> 
> 2 - You claim that using stop_machine is simpler and therefore safer
> than using a breakpoint-based approach. I start having some doubts about
> simplicity when you start talking about the workarounds you have to do
> for NMIs,

I agree, the NMI work around was tricky, but the final solution (which
we tested vigorously) works well. My claim that it is simpler is not about 
the small steps, but rather the number of variables we need to deal with.
Stop machine shuts down all the CPUs and executes my code on one CPU. 
Interrupts are disabled on all CPUs, and we only need to worry about the 
NMI. Which we now do.

Your solution is about mapping another page on a running system, where
anything can happen. The number of variables that can go wrong is much 
greater simply by the fact that you have no idea as to what is running at 
the same time as you perform your modifications.

With stop_machine, the number of variables is much less, because I know 
everything that is happening when I do the modification. I do not need to 
worry about some strange driver doing some kind of tricks because it 
simply is not running.

> but more importantly, you seem to recognise that the latency
> it induces would be inadequate for production systems.

Wrong. I recognise the latency of tracing all functions on a production 
system. Heck, we trace spin_lock, rcu_read_lock, mutex_lock, and all that 
jazz. Just slowing those functions down a bit will have a noticeable 
impact. I've found that adding those functions to set_ftrace_notrace drops 
the function tracer penalty, significantly.


> Therefore it's
> unusable in some LTTng use-cases just because of that. If you expect the
> function tracer to become used more widely in LTTng, these concerns
> should be addressed.

If you only want to trace a few hundred functions, then the overhead with
it on should not be significant. Depending on which functions you trace. 
As mentioned above, tracing only spin_lock can slow the system down.

Set up the functions you want to trace, enable them. You can have the
ring buffer disabled (echo 0 > /debug/tracing/tracing_on) and just turn on 
the ring buffer for your snapshot, and turn it off when you are done. When 
all tracing is done, then disable the function tracing.


> 
> If, in the end, your argument is "the function tracer works as-is now,
> and I have no time to change it given it represents too much work" or "I
> don't care about your use-cases", I'm OK with that. But please then don't
> argue that it's because it's the best technical solution when it isn't.

No, I have yet to hear a valuable argument against stop_machine. You are 
pushing the burden of proof on me, when we have something that does work, 
on several archs. You want me to redesign the system to be x86 only, and 
then say, hey, my original code works better.

I do not see text_poke being theoretically better. The only reason you 
given me to use it is because you dislike stop_machine.

-- Steve



