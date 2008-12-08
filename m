Return-Path: <linux-kernel-owner+w=401wt.eu-S1753022AbYLHWE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYLHWE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 17:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752607AbYLHWEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 17:04:45 -0500
Received: from ozlabs.org ([203.10.76.45]:55664 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752462AbYLHWEn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 17:04:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18749.39345.732524.905159@cargo.ozlabs.ibm.com>
Date: Tue, 9 Dec 2008 09:03:29 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch] Performance Counters for Linux, v2
In-Reply-To: <20081208113318.GA14723@elte.hu>
References: <20081208012211.GA23106@elte.hu>
	<18748.37739.383961.318233@drongo.ozlabs.ibm.com>
	<20081208113318.GA14723@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> If you want a _guarantee_ that multiple counters can count at once you 
> can still do it: for example by using the separate, orthogonal 
> reservation mechanism we had in -v1 already.

Is that this?

" - There's a /sys based reservation facility that allows the allocation
   of a certain number of hw counters for guaranteed sysadmin access."

Sounds like I can't do that as an ordinary user, even on my own
processes...

I don't want the whole PMU all the time, I just want it while my
monitored process is running, and only on the CPU where it is
running.

> Also, you dont _have to_ overcommit counters.
> 
> Your whole statistical argument that group readout is a must-have for 
> precision is fundamentally flawed as well: counters _themselves_, as used 
> by most applications, by their nature, are a statistical sample to begin 
> with. There's way too many hardware events to track each of them 
> unintrusively - so this type of instrumentation is _all_ sampling based, 
> and fundamentally so. (with a few narrow exceptions such as single-event 
> interrupts for certain rare event types)

No - at least on the machines I'm familiar with, I can count every
single cache miss and hit at every level of the memory hierarchy,
every single TLB miss, every load and store instruction, etc. etc.

I want to be able to work out things like cache hit rates, just as one
example.  To do that I need two numbers that are directly comparable
because they relate to the same set of instructions.  If I have a
count of L1 Dcache hits for one set of instructions and a count of L1
Dcache misses over some different stretch of instructions, the ratio
of them doesn't mean anything.

Your argument about "it's all statistical" is bogus because even if
the things we are measuring are statistical, that's still no excuse
for being sloppy about how we make our estimates.  And not being able
to have synchronized counters is just sloppy.  The users want it, the
hardware provides it, so that makes it a must-have as far as I am
concerned.

> This means that the only correct technical/mathematical argument is to 
> talk about "levels of noise" and how they compare and correlate - and 
> i've seen no actual measurements or estimations pro or contra. Group 
> readout of counters can reduce noise for sure, but it is wrong for you to 
> try to turn this into some sort of all-or-nothing property. Other sources 
> of noise tend to be of much higher of magnitude.

What can you back that assertion up with?

> You need really stable workloads to see such low noise levels that group 
> readout of counters starts to matter - and the thing is that often such 
> 'stable' workloads are rather boringly artificial, because in real life 
> there's no such thing as a stable workload.

More unsupported assertions, that sound wrong to me...

> Finally, the basic API to user-space is not the way to impose rigid "I 
> own the whole PMU" notion that you are pushing. That notion can be 
> achieved in different, system administration means - and a perf-counter 
> reservation facility was included in the v1 patchset.

Only for root, which isn't good enough.

What I was proposing was NOT a rigid notion - you don't have to own
the whole PMU if you are happy to use the events that the kernel knows
about.  If you do want the whole PMU, you can have it while the
process you're monitoring is running, and the kernel will
context-switch it between you and other users, who can also have the
whole PMU when their processes are running.

> Note that you are doing something that is a kernel design no-no: you are 
> trying to design a "guarantee" for hardware constraints by complicating 
> it into the userpace ABI - and that is a fundamentally losing 
> proposition.

Perhaps you have misunderstood my proposal.  A counter-set doesn't
have to be the whole PMU, and you can have multiple counter-sets
active at the same time as long as they fit.  You can even have
multiple "whole PMU" counter-sets and the kernel will multiplex them
onto the real PMU.

> It's a tail-wags-the-dog design situation that we are routinely resisting 
> in the upstream kernel: you are putting hardware constraints ahead of 
> usability, you are putting hardware constraints ahead of sane interface 
> design - and such an approach is wrong and shortsighted on every level.

Well, I'll ignore the patronizing tone (but please try to avoid it in
future).

The PRIMARY reason for wanting counter-sets is because THAT IS WHAT
THE USERS WANT.  A "usable" and "sane" interface design that doesn't
do what users want is useless.

Anyway, my proposal is just as "usable" as yours, since users still
have perf_counter_open, exactly as in your proposal.  Users with
simpler requirements can do things exactly the same way as with your
proposal.

> It's also shortsighted because it's a red herring: there's nothing that 
> forbids the counter scheduler from listening to the hw constraints, for 
> CPUs where there's a lot of counter constraints.

Handling the counter constraints is indeed a matter of implementation,
and as I noted previously, your current proposed implementation
doesn't handle them.

> Being per object is a very fundamental property of Linux, and you have to 
> understand and respect that down to your bone if you want to design new 
> syscall ABIs for Linux.

It's the choice of a single counter as being your "object" that I
object to. :)

>  - It makes counter scheduling very dynamic. Instead of exposing
>    user-space to a static "counter allocation" (with all the insane ABI
>    and kernel internal complications this brings), perf-counters
>    subsystem does not expose user-space to such scheduling details
>    _at all_.

Which is not necessarily a good thing.  Fundamentally, if you are
trying to measure something, and you get a number, you need to know
what exactly got measured.

For example, suppose I am trying to count TLB misses during the
execution of a program.  If my TLB miss counter keeps getting bumped
off because the kernel is scheduling my counter along with a dozen
other counters, then I *at least* want to know about it, and
preferably control it.  Otherwise I'll be getting results that vary by
an order of magnitude with no way to tell why.

> All in one, using the 1:1 fd:counter design is a powerful, modern Linux 
> abstraction to its core. It's much easier to think about for application 
> developers as well, so we'll see a much sharper adoption rate. 

For simple things, yes it is simpler.  But it can't do the more
complex things in any sort of clean or sane way.

> Also, i noticed that your claims about our code tend to be rather 
> abstract

... because the design of your code is wrong at an abstract level ...

> and are often dwelling on issues that IMO have no big practical 
> relevance - so may i suggest the following approach instead to break the 
> (mutual!) cycle of miscommunication: if you think an issue is important, 
> could you please point out the problem in practical terms what you think 
> would not be possible with our scheme? We tend to prioritize items by 
> practical value.
> 
> Things like: "kerneltop would not be as accurate with: ..., to the level 
> of adding 5% of extra noise.". Would that work for you?

OK, here's an example.  I have an application whose execution has
several different phases, and I want to measure the L1 Icache hit rate
and the L1 Dcache hit rate as a function of time and make a graph.  So
I need counters for L1 Icache accesses, L1 Icache misses, L1 Dcache
accesses, and L1 Dcache misses.  I want to sample at 1ms intervals.
The CPU I'm running on has two counters.

With your current proposal, I don't see any way to make sure that the
counter scheduler counts L1 Dcache accesses and L1 Dcache misses at
the same time, then schedules L1 Icache accesses and L1 Icache
misses.  I could end up with L1 Dcache accesses and L1 Icache
accesses, then L1 Dcache misses and L1 Icache misses - and get a
nonsensical situation like the misses being greater than the accesses.

> This needless vectoring and the exposing of contexts would kill many good 
> properties of the new subsystem, without any tangible benefits - see 
> above.

No.  Where did you get contexts from?  I didn't write anything about
contexts.  Please read what I wrote.

> This is really scheduling school 101: a hardware context allocation is 
> the _last_ thing we want to expose to user-space in this particular case. 

Please drop the patronizing tone, again.

What user-space applications want to be able to do is this:

* Ensure that a set of counters are all counting at the same time.

* Know when counters get scheduled on and off the process so that the
  results can be interpreted properly.  Either that or be able to
  control the scheduling.

* Sophisticated applications want to be able to do things with the PMU
  that the kernel doesn't necessarily understand.

> This is a fundamental property of hardware resource scheduling. We _dont_ 
> want to tie the hands of the kernel by putting resource scheduling into 
> user-space!

You'd rather provide useless numbers to userspace? :)

> Your arguments remind me a bit of the "user-space threads have to be 
> scheduled in user-space!" N:M threading design discussions we had years 
> ago. IBM folks were pushing NGPT very strongly back then and claimed that 
> it's the right design for high-performance threading, etc. etc.

Your arguments remind me of a filesystem that a colleague of mine once
designed that only had files, but no directories (you could have "/"
characters in the filenames, though).  This whole discussion is a bit
like you arguing that directories are an unnecessary complication that
only messes up the interface and adds extra system calls.

> You can already allocate "exclusive" counters in a guaranteed way via our 
> code, here and today.

But then I don't get context-switching between processes.

> There's constrained PMCs on x86 too, as you mention. Instead of repeating 
> the answer that i gave before (that this is easy and natural), how about 
> this approach: if we added real, working support for constrained PMCs on 
> x86, that will then address this point of yours rather forcefully, 
> correct?

It still means we end up having to add something approaching 29,000
lines of code and 320kB to the kernel, just for the IBM 64-bit PowerPC
processors.  (I don't guarantee that code is optimal, but that is some
indication of the complexity required.)

I am perfectly happy to add code for the kernel to know about the most
commonly-used, simple events on those processors.  But I surely don't
want to have to teach the kernel about every last event and every last
capability of those machines' PMUs.

For example, there is a facility on POWER6 where certain instructions
can be selected (based on (instruction_word & mask) == value) and
marked, and then there are events that allow you to measure how long
marked instructions take in various stages of execution.  How would I
make such a feature available for applications to use, within your
framework?

Paul.
