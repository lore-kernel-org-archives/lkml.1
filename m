Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYIYQn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYIYQn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbYIYQnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:43:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753140AbYIYQnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:43:16 -0400
Date: Thu, 25 Sep 2008 09:40:42 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Martin Bligh <mbligh@mbligh.org>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080925153635.GA12840@elte.hu>
Message-ID: <alpine.LFD.1.10.0809250924460.3265@nehalem.linux-foundation.org>
References: <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com> <1222339303.16700.197.camel@lappy.programming.kicks-ass.net> <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com> <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org> <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com> <20080925153635.GA12840@elte.hu>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Ingo Molnar wrote:
>
> ... which is exactly what sched_clock() does, combined with a 
> multiplication. (which is about as expensive as normal linear 
> arithmetics on most CPUs - i.e. in the 1 cycle range)

First off, that's simply not true.

Yes, it happens to be true on modern x86-64 CPU's. But in very few other 
places. Doing even just 64-bit multiples is _expensive_. It's not even 
_near_ single-cycle.

But more importantly:

> Normalizing has the advantage that we dont have to worry about it ever 
> again. Not about a changing scale due to cpufreq, slowing down or 
> speeding up TSCs due to C2/C3. We have so much TSC breakage all across 
> the spectrum that post-processing it is a nightmare in practice.

Total and utter bullshit, all of it.

Have you forgotten all the oopses due to divide-by-zero because 
sched_clock() was called early? All that early code that we might well 
want to trace through?

Not only that, but have you forgotten about FTRACE and -pg? Which means 
that every single C function calls into tracing code, and that can 
basically only be disabled on a per-file basis? 

As for C2/C3 - that's just an argument for *not* doing anything at trace 
time. What do you think happens when you try to trace through those 
things? You're much better off trying to sort out the problems later, when 
you don't hold critical locks and are possibly deep down in some buggy 
ACPI code, and you're trying to trace it exactly _because_ it is buggy.

The thing is, the trace timestamp generation should be at least capable of 
being just a couple of versions of assembly language. If you cannot write 
it in asm, you lose. You cannot (and MUST NOT) use things like a 
virtualized TSC by mistake. If the CPU doesn't natively support 'rdtsc' in 
hardware on x86, for example, you have to have another function altogether 
for the trace timestamp.

And no way in hell do we want to call complex indirection chains that take 
us all over the map and have fragile dependencies that we have already hit 
several times wrt things like cpufreq.

WE ARE MUCH BETTER OFF WITH EVEN _INCORRECT_ TIME THAN WE ARE WITH FRAGILE 
TRACE INFRASTUCTURE.

> Plus we want sched_clock() to be fast anyway.

Yeah. And we want system calls to be _really_ fast, because they are even 
more critical than the scheduler. So maybe we can use a "gettime()" system 
call.

IOW, your argument is a non-argument. No way in HELL do we want to mix up 
sched_clock() in tracing. Quite the reverse. We want to have the ability 
to trace _into_ sched_clock() and never even have to think about it!

TSC is not pefect, but (a) it's getting better (as you yourself point 
out), and in fact most other architectures already have the better 
version. And (b) it's the kind of simplicity that we absolutely want.

Do you realize, for example, that a lot of architectures really only have 
a 32-bit TSC, and they have to emulate a 64-bit one (in addition to 
conveting it to nanoseconds using divides) for the sched_clock()? They'd 
almost certainly be much better off able to just use their native one 
directly.

Yeah, it would probably cause some code duplication, but the low-leel 
trace infrastructure really is special. It can't afford to call other 
subsystems helper functions, because people want to trace _those_.

				Linus
