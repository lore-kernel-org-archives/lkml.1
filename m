Return-Path: <linux-kernel-owner+w=401wt.eu-S1756753AbYLFAFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753AbYLFAFq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 19:05:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755239AbYLFAFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 19:05:36 -0500
Received: from ozlabs.org ([203.10.76.45]:39874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755165AbYLFAFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 19:05:35 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18745.49593.567217.277510@cargo.ozlabs.ibm.com>
Date: Sat, 6 Dec 2008 11:05:13 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Stephane Eranian <eranian@googlemail.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Veen <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [patch 0/3] [Announcement] Performance Counters for Linux
In-Reply-To: <20081205120734.GA26244@elte.hu>
References: <20081204225345.654705757@linutronix.de>
	<18744.29747.728320.652642@cargo.ozlabs.ibm.com>
	<20081205063131.GB12785@elte.hu>
	<18744.56857.259756.129894@cargo.ozlabs.ibm.com>
	<20081205080813.GA2030@elte.hu>
	<18744.61429.548462.667020@cargo.ozlabs.ibm.com>
	<20081205120734.GA26244@elte.hu>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> A stream of read()s possibly slightly being off is an order of magnitude 
> smaller of an effect to precision. Look at the numbers: on the testbox i 
> have a read() syscall takes 0.2 microseconds, while a context-switch 
> takes 2 microseconds on the local CPU and about 5-10 microseconds 
> cross-CPU (or more, if the cache pattern is unlucky/unaffine). That's 
> 10-25-50 times more expensive. You can do 9-24-49 reads and still be 
> cheaper. Compound syscalls are almost never worth the complexity.

If we're on an SMP system and the monitored task is currently running,
then it's not just the read syscall, there's also the IPI, which will
add considerably to the cost.  So it's likely to be a thousand or more
cycles between the two counter reads, which is IMHO unacceptable.

Anyway, that's not my major problem with the API, just one of its
little annoyances...

> So as a scheduler person i cannot really take the perfmon "ptrace 
> approach" seriously, and i explained that in great detail already. It 
> clearly came from HPC workload quarters where tasks are persistent 
> entities running alone on a single CPU that just use up CPU time there 
> and dont interact with each other too much. That's a good and important 
> profiling target for sure - but by no means the only workload target to 
> design a core kernel facility for. It's an absolutely horrible approach 
> for a number of more common workloads for sure.

I never defended the use of ptrace, and it isn't IMO an essential part
of the perfmon API, just an aspect of its current implementation.

> > And I think that is the fundamental flaw.  On the machines I am 
> > familiar with, the performance counters as not separate things that can 
> > individually and independently be assigned to count one thing or 
> > another.
> 
> Today we've implemented virtual counter scheduling in our to-be-v2 code:
> 
>    3 files changed, 36 insertions(+), 1 deletion(-)
> 
> hello.c gives:
> 
>  counter[0 cycles              ]:  10121258163 , delta:    844256826 events
>  counter[1 instructions        ]:   4160893621 , delta:    347054666 events
>  counter[2 cache-refs          ]:         2297 , delta:          179 events
>  counter[3 cache-misses        ]:            3 , delta:            0 events
>  counter[4 branch-instructions ]:    799422166 , delta:     66551572 events
>  counter[5 branch-misses       ]:         7286 , delta:          775 events

And this tells me what?  I can't relate any of these measurements to
any others, because I don't know how many cycles or instructions or
milliseconds each of these counts relates to, and I don't know which
counts were taken at the same time as which other counts.

Your abstraction hides all the details of what is being counted with
which counter over what period of time, and that is absolutely crucial
information for any serious analysis of the numbers.

> All we need to get that array of information from 6 sw counters is a 
> _single_ hardware counter. I'm not sure where you read "you must map sw 
> counters to hw counters directly" or "hw counters must be independent of 
> each other" into our design - it's not part of it, emphatically.

I'm not sure those quoted statements are exactly what I said, but
whatever.

Your API has as its central abstraction the "counter".  I am saying
that that is the wrong abstraction.  The abstraction really needs to
be a set of counters that are all active over precisely the same
interval, so that their values can be meaningfully compared and
related to each other.

> And i dont see your (fully correct!) statement above about counter 
> constraints to be in any sort of conflict with what we are doing.
> 
> Intel hardware is just as constrained as powerpc hardware: there are 
> counter inter-dependencies and many CPUs have just two performance 
> counters. We very much took this into account while designing this code.

Well, here's my reasoning.

* Your perf_counter_open call takes the event type but doesn't have
  any way to select a particular hardware counter (deliberately, since
  your API is trying to present some common-denominator abstraction of
  the individual counters).

* On powerpc, the event selector value to count a particular event is
  different for each counter, and may even depend on what's being
  counted on other counters.

* That means that we can't meaningfully pass raw (negative) event
  selector values, since what any particular value means depends on
  which hardware counter we get to use, and we don't know that (and in
  fact it may change from time to time).

* In other words, the kernel will have to know the mapping from
  abstract event types to event selector values for each counter for
  each supported CPU type.

Now, the tables in perfmon's user-land libpfm that describe the
mapping from abstract events to event-selector values and the
constraints on what events can be counted together come to nearly
29,000 lines of code just for the IBM 64-bit powerpc processors.

Your API condemns us to adding all that bloat to the kernel, plus the
code to use those tables.

Furthermore, since your generic code doesn't know anything about the
constraints and thinks it can just add any counter to any task at any
time (subject only to a maximum number of counters in use), we'll
potentially have to work out event selector values at latency-critical
times such as context switches and interrupts.

> [ Obviously, you _can_ do higher quality profiling if you have more 
>   hardware resources that help it. Nothing will change that fact. ]
> 
> > Rather, what the hardware provides is ONE performance monitor unit, 
> > which the OS can context-switch between tasks.  The performance monitor 
> > unit has several counters that can be assigned (within limits) to count 
> > various aspects of the performance of the code being executed.  That is 
> > why, for instance, if you ask for the counters to be frozen when one of 
> > them overflows, they all get frozen at that point.
> 
> i dont see this as an issue at all - it's a feature of powerpc over x86 
> that the core perfcounter code can support just fine. The overflow IRQ 
> handler is arch specific. The overflow IRQ handler, if it triggers, 
> updates the sw counters, creates any event records if needed, wakes up 
> the monitor task if needed, and continues the task and performance 
> measurement without having scheduled out. Demultiplexing of hw counters 
> is arch-specific.

The ability to create event records in a ring buffer is certainly
nice.  I have no problem with that part of your proposal, particularly
if we can optionally record things like a timestamp, task registers,
stacktrace, etc. at the same time, as you have suggested.

My point is that the monitoring task wants to be able to control which
things get measured simultaneously.  The kernel shouldn't be deciding
how the set of software counters gets multiplexed onto the hardware
counters - the monitoring task needs to be able to control that in
order to get meaningful results.

There are three other problems that I see with your API (these are
probably fixable):

1. I don't see any way to control whether I'm counting events in user
   mode, kernel mode, hypervisor mode, or some combination.  That is
   needed for some types of performance analysis.

2. If I'm counting events for all tasks, I want to be able to exclude
   the idle task, optionally.  I don't see a way to do that.

3. If I have a counter in PERF_RECORD_IRQ mode, I have no way to read
   its actual value, which I would want to do (for instance, when some
   other counter overflows, or when the task exits).

Paul.
