Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbYLHLeF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbYLHLeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:34:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYLHLdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:33:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:47157 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbYLHLdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:33:49 -0500
Date: Mon, 8 Dec 2008 12:33:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
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
Message-ID: <20081208113318.GA14723@elte.hu>
References: <20081208012211.GA23106@elte.hu> <18748.37739.383961.318233@drongo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18748.37739.383961.318233@drongo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Mackerras <paulus@samba.org> wrote:

> Ingo Molnar writes:
> 
> > There's a new "counter group record" facility that is a straightforward 
> > extension of the existing "irq record" notification type. This record 
> > type can be set on a 'master' counter, and if the master counter triggers 
> > an IRQ or an NMI, all the 'secondary' counters are read out atomically 
> > and are put into the counter-group record. The result can then be read() 
> > out by userspace via a single system call. (Based on extensive feedback 
> > from Paul Mackerras and David Miller, thanks guys!)
> > 
> > The other big change is the support of virtual task counters via counter 
> > scheduling: a task can specify more counters than there are on the CPU, 
> > the kernel will then schedule the counters periodically to spread out hw 
> > resources.
> 
> Still not good enough, I'm sorry.
> 
> * I have no guarantee that the secondary counters were all counting
>   at the same time(s) as the master counter, so the numbers are
>   virtually useless.

If you want a _guarantee_ that multiple counters can count at once you 
can still do it: for example by using the separate, orthogonal 
reservation mechanism we had in -v1 already.

Also, you dont _have to_ overcommit counters.

Your whole statistical argument that group readout is a must-have for 
precision is fundamentally flawed as well: counters _themselves_, as used 
by most applications, by their nature, are a statistical sample to begin 
with. There's way too many hardware events to track each of them 
unintrusively - so this type of instrumentation is _all_ sampling based, 
and fundamentally so. (with a few narrow exceptions such as single-event 
interrupts for certain rare event types)

This means that the only correct technical/mathematical argument is to 
talk about "levels of noise" and how they compare and correlate - and 
i've seen no actual measurements or estimations pro or contra. Group 
readout of counters can reduce noise for sure, but it is wrong for you to 
try to turn this into some sort of all-or-nothing property. Other sources 
of noise tend to be of much higher of magnitude.

You need really stable workloads to see such low noise levels that group 
readout of counters starts to matter - and the thing is that often such 
'stable' workloads are rather boringly artificial, because in real life 
there's no such thing as a stable workload.

Finally, the basic API to user-space is not the way to impose rigid "I 
own the whole PMU" notion that you are pushing. That notion can be 
achieved in different, system administration means - and a perf-counter 
reservation facility was included in the v1 patchset.

Note that you are doing something that is a kernel design no-no: you are 
trying to design a "guarantee" for hardware constraints by complicating 
it into the userpace ABI - and that is a fundamentally losing 
proposition.

It's a tail-wags-the-dog design situation that we are routinely resisting 
in the upstream kernel: you are putting hardware constraints ahead of 
usability, you are putting hardware constraints ahead of sane interface 
design - and such an approach is wrong and shortsighted on every level.

It's also shortsighted because it's a red herring: there's nothing that 
forbids the counter scheduler from listening to the hw constraints, for 
CPUs where there's a lot of counter constraints.

> * I might legitimately want to be notified based on any of the
>   "secondary" counters reaching particular values.  The "master" vs. 
>   "secondary" distinction is an artificial one that is going to make 
>   certain reasonable use-cases impossible.

the secondary counters can cause records too - independently of the 
master counter. This is because the objects (and fds) are separate so 
there's no restriction at all on the secondary counters. This is a lot 
less natural to do if you have a "vector of counters" abstraction.

> These things are both symptoms of the fact that you still have the 
> abstraction at the wrong level.  The basic abstraction really needs to 
> be a counter-set, not an individual counter.

Being per object is a very fundamental property of Linux, and you have to 
understand and respect that down to your bone if you want to design new 
syscall ABIs for Linux.

The "perfmon v3 light" system calls, all five of them, are a classic 
loundry list of what _not_ to do in new Linux APIs: they are too 
specific, too complex and way too limited on every level.

Per object and per fd abstractions are a _very strong_ conceptual 
property of Linux. Look at what they bring in the performance counters 
case:

 - All the VFS syscalls work naturally: sys_read(), sys_close(),
   sys_dup(), you name it.

 - It makes all counters poll()able. Any subset of them, and at any time,
   independently of any context descriptor. Look at kerneltop.c: it has a
   USE_POLLING switch to switch to a poll() loop, and it just works the 
   way you'd expect it to work.
 
 - We can share fds between monitor threads and you can do a thread pool
   that works down new events - without forcing any counter scheduling in
   the monitored task.

 - It makes the same task monitorable by multiple monitors, trivially
   so. There's no forced context notion that privatizes the PMU - with 
   some 'virtual context' extra dimension slapped on top of it.

 - Doing a proper per object abstraction simplifies event and error
   handling significantly: instead of having to work down a vector of 
   counters and demultiplexing events and matching them up to individual 
   counters, the demultiplexing is done by the _kernel_.

 - It makes counter scheduling very dynamic. Instead of exposing
   user-space to a static "counter allocation" (with all the insane ABI
   and kernel internal complications this brings), perf-counters
   subsystem does not expose user-space to such scheduling details
   _at all_.

 - Difference in complexity. The "v3 light" version of perfmon (which 
   does not even schedule any PMU contexts), contains these core kernel 
   files:

         19 files changed, 4424 insertions(+)

   Our code has this core kernel impact:

         10 files changed, 1191 insertions(+)

   And in some areas it's already more capable than "perfmon v3".
   The difference is very obvious.

All in one, using the 1:1 fd:counter design is a powerful, modern Linux 
abstraction to its core. It's much easier to think about for application 
developers as well, so we'll see a much sharper adoption rate. 

Also, i noticed that your claims about our code tend to be rather 
abstract and are often dwelling on issues that IMO have no big practical 
relevance - so may i suggest the following approach instead to break the 
(mutual!) cycle of miscommunication: if you think an issue is important, 
could you please point out the problem in practical terms what you think 
would not be possible with our scheme? We tend to prioritize items by 
practical value.

Things like: "kerneltop would not be as accurate with: ..., to the level 
of adding 5% of extra noise.". Would that work for you?

> I think your patch can be extended to do counter-sets without 
> complicating the interface too much.  We could have:
> 
> struct event_spec {
> 	u32 hw_event_type;
> 	u32 hw_event_period;
> 	u64 hw_raw_ctrl;
> };

This needless vectoring and the exposing of contexts would kill many good 
properties of the new subsystem, without any tangible benefits - see 
above.

This is really scheduling school 101: a hardware context allocation is 
the _last_ thing we want to expose to user-space in this particular case. 
This is a fundamental property of hardware resource scheduling. We _dont_ 
want to tie the hands of the kernel by putting resource scheduling into 
user-space!

Your arguments remind me a bit of the "user-space threads have to be 
scheduled in user-space!" N:M threading design discussions we had years 
ago. IBM folks were pushing NGPT very strongly back then and claimed that 
it's the right design for high-performance threading, etc. etc.

In reality, doing user-space scheduling for cheap-to-context-switch 
hardware resources was a fundamentally wrong proposition back then too, 
and it is still the wrong concept today as well.

> int perf_counterset_open(u32 n_counters,
>     			 struct event_spec *counters,
> 			 u32 record_type,
> 			 pid_t pid,
> 			 int cpu);
> 
> and then you could have perf_counter_open as a simple wrapper around 
> perf_counterset_open.
> 
> With an approach like this we can also provide an "exclusive" mode for 
> the PMU [...]

You can already allocate "exclusive" counters in a guaranteed way via our 
code, here and today.

> [...] (e.g. with a flag bit in record_type or n_counters), which means 
> that the counter-set occupies the whole PMU.  That will give a way for 
> userspace to specify all the details of how the PMU is to be 
> programmed, which in turn means that the kernel doesn't need to know 
> all the arcane details of every event on every processor; it just needs 
> to know the common events.
> 
> I notice the implementation also still assumes it can add any counter 
> at any time subject only to a limit on the number of counters in use. 
> That will have to be fixed before it is usable on powerpc (and 
> apparently on some x86 processors too).

There's constrained PMCs on x86 too, as you mention. Instead of repeating 
the answer that i gave before (that this is easy and natural), how about 
this approach: if we added real, working support for constrained PMCs on 
x86, that will then address this point of yours rather forcefully, 
correct?

	Ingo
