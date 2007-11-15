Return-Path: <linux-kernel-owner+w=401wt.eu-S1760130AbXKOAKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760130AbXKOAKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753631AbXKOAKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:10:08 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:58571 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513AbXKOAKF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:10:05 -0500
Date: Wed, 14 Nov 2007 16:07:49 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, William Cohen <wcohen@redhat.com>,
       perfmon2-devel@lists.sourceforge.net
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071115000749.GA8165@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com> <20071114020702.GB20365@one.firstfloor.org> <20071114130909.GB6557@frankl.hpl.hp.com> <20071114142411.GD17145@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114142411.GD17145@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Nov 14, 2007 at 03:24:11PM +0100, Andi Kleen wrote:
> On Wed, Nov 14, 2007 at 05:09:09AM -0800, Stephane Eranian wrote:
> > 
> > Partially true. The file descriptor becomes really useful when you sample.
> > You leverage the file descriptor to receive notifications of counter overflows
> > and full sampling buffer. You extract notification messages via read() and you can
> > use SIGIO, select/poll.
> 
> Hmm, ok for the event notification we would need a nice interface. Still
> have my doubts a file descriptor is the best way to do this though.
> 

Why do you think the existing interfaces are not a good fit for this?
Is this just because of your problem with file descriptors?

>From my experience read(), select(), and SIGIO are fine. I know many tools use that.

As for the file descriptor, you would need to replace that with another identifier of
some sort. As I pointed out in another message on this thread, you don't want to use
a pid-based identifier. This is not usable when you monitor other threads and you
want to read out the results after their death.


> > Are you suggesting something like: pfm_write_pmcs(fd, 0, 0x1234)?
> 
> See my example below.
> > 
> > That would be quite expensive when you have lots of registers to setup: one
> > syscall per register. The perfmon syscalls to read/write registers accept vector
> > of arguments to amortize the cost of the syscall over multiple registers
> > (similar to poll(2)).
> 
> 
> First system calls are not that slow on Linux. Measure it.
> 
If people do not like vector arguments, then I think I can live with N system calls
to program N registers. Now you have two choices for passing the arguments:

	- a pointer to a struct
		struct pfarg_pmc {
			uint64_t reg_value;
			uint16_t reg_num;
		} pmc0;
		pmc0.reg_value = 0; pmc0.reg_value = 0x1234;
		pfm_write_pmcs(fd, &pmc0);

	- explicitly passing every field:
		pfm_write_pmcs(fd, 0x0, 0x1234);

Given that event set and multiplexing would not be in initially, we would want
to allow for them to be added later without having to create yet another
system call, right?

Of course the same approach would work for the data registers at least for counting.

> > With many tools, registers are not just setup once. During certain measurements,
> > data registers may be read multiple times. When you sample or multiplex at
> 
> I think you optimize the wrong thing here.
> 
> There are basically two cases I see:
> 
> -  Global measurement of lots of things:

I am not sure I understand what you mean by 'lots of things'?
Are you still talking per-thread and self-monitoring?


> Things are slow anyways with large context switch overheads. The 
> overheads are large anyways. Doing one or more system calls probably
> does not matter much. Most important is a clean interface.
> 
> - Exact measurement of the current process. For that you need very
> low latencies. Any system call is too slow. That is why CPUs have
> instructions like RDPMC that allow to read those registers with
> minimal latency in user space. Interface should support those.
> 

I don't have a problem with that. And in fact, I already support that
at least on Itanium. I had that in there for X86 but I dropped it after
you said that you would enable cr4.pce globally. I don't have a problem
adding it back for self-monitoring sessions.


> Also for this case programming time does not matter too much. You
> just program once and then do RDPMC before code to measure and then
> afterwards and take the difference. The actual counter setup is out 
> of the latency critical path.
> 
Agreed.

> 
> > It depends on what you are doing. Here, this was not really necessary. It was
> > meant to show how you can program the data registers as well. Perfmon2 provides
> > default values for all data registers. For counters, the value is guaranteed to
> > be zero.
> > 
> > But it is important to note that not all data registers are counters. That is the
> > case of Itanium 2, some are just buffers. On AMD Barcelona IBS several are buffers as
> > well, and some may need to be initialized to non zero value, i.e., the IBS sampling
> > period.
> 
> Setting period should be a separate call. Mixing the two together into one
>  does not look like a nice interface.
> 
Periods are setup by data register. Given that there is already a call to program
the data register why add another one? You don't need to treat the sampling period
differently from the register value. This just a value that will cause the register
to overflow after an explicit number of occurrences.


> > With event-based sampling,  the period is expressed as the number of occurrences
> > of an event. For instance, you can say: " take a sample every 2000 L2 cache misses".
> > The way you express this with perfmon2 is that you program a counter to measure
> > L2 cache misses, and then you initialize the corresponding data register (counter)
> > to overflow after 2000 occurrences. Given that the interface guarantees all counters
> > are 64-bit regardless of the hardware, you simply have to program the counter to -2000.
> > Thus you see that you need a call to actual program the data registers.
> 
> I didn't object to providing the initial value -- my example had that.

Should you support a kernel level sampling buffer (like Oprofile) you'd also want
to specify the reset value on overflow. And you would not necessarily want it to
be identical to the initial value (period). So you'd to have a way to specify that
one as well.

> Just having a separate concept of data registers seems too complicated to me.

I am not against providing a flat namespace. But I think it is nice to separate config
from data. 

> You should just pass event types and values and the kernel gives you
> a register number.

Absolutely not, you don't want to the kernel to know about events. This has to
remain at the user level. The event -> register problem is best solved in a user
library (such as libpfm). You don't want to bloat the kernel with event tables.
Many PMU models have over 200 events. And there is worse, in many PMU models,
you have tons of constraints as to each counter can measure, it can become very complicated,
e.g., Itanium and Power and Pentium 4 are good examples. It is difficult to get right, vendors
are constantly correcting their spec so maintenance is a pain.

The kernel interface must just deal with PMU registers and not events.


> 
> 
> > Perfmon2 decouples the two operations. In fact, no PMU hardware is actually touched
> > before you attach to either a CPU or a thread. This way, you can prepare your measurement
> > and then attach-and-go. Thus is is possible to create batches of ready-to-go sessions.
> > That is useful, for instance, when you are trying to measure across fork, pthread_create
> > which you can catch on-the-fly.
> > 
> > Take the per-thread example, you can setup your session before you fork/exec the program
> > you want to measure.
> 
> And?  You didn't say what the advantage of that is? 
> 
You pass to the kernel all the register values (config, data), you setup the kernel sampling
buffer and the mapping of it. Then it is just ma tter of attaching + start. The value of this
is that it lets you create a pool of ready-to-go sessions and when you are monitoring across
fork/pthread_create, each time you receive a notification from ptrace, you simply have to
attach, start and go, i..e, you minimize the overhead on the application you are measuring.

> All the approaches add context switch latencies. It is not clear that the separate
> session setup helps it all that much.
> 
This is a different issue. Sure the more PMU register you use the more expensive the
context switch gets. Yet the current perfmon2 implementation tries to mitigate this by
using lazy restore scheme, similar to the one used for FP registers.,

> > 
> > Note also that perfmon2 supports attaching to an already running thread. So there is
> > more than "GLOBAL CONTEXT" versus "MY CONTEXT".
> 
> What is the use case of this? Do users use that? 
> 
I think this is even the first approach when you get code to measure. You want to try
and characterize the workload without having to instrument and recompile. Furthermore, their
are certain workloads which are very long to restart and that cannot be stopped and restarted
easily, yet you may want to attach for several seconds. You may also want to use this approach
to avoid monitoring the initialization phase of an application. Sometimes you may not even
all have the sources to be able to instrument (e.g. 3rd party libraries).


> > 
> > 
> > > > 	/* activate monitoring */
> > > > 	pfm_start(ctx_fd, NULL);
> > > 
> > > Why can't that be done by the call setting up the register?
> > > 
> > 
> > Good question. If you do what say, you assume that the start/stop bit lives in the
> > config (or data) registers of the PMU. This is not true on all hardware. On Itanium
> > for instance, the start/stop bit is part of the Processor Status Register (psr).
> > That is not a PMU register.
> 
> 
> Well the system call layer can manage that transparently with a little software state
> (counter). No need to expose it.
> 
Are you suggesting virtual PMU registers that map to other resources, e.g., Itanium's PSR?

> 
> I disagree. Using RDPMC is essential for at least some of the things I would like
> to do with perfmon2. If the interface does not provide it it is useless to me at least.
> System calls are far too slow for cycle measurements. 
> 
> And when RDPMC is already supported it should be as widely used as possible.
> 
I am perfectly fine with RDPMC for self-monitoring and simple counting. I need to check and
see if this could work for self-sampling. But I also want to provide an interface
that would work for: non self-monitoring, self-monitoring, architecture without RDPMC equivalent.
This is important for people who want to write portable tools. The syscall would
return the full 64-bit value of the counter without the sign-extension.

> > 
> > Reducing performance monitoring to self-monitoring is not what we want. In fact, there
> > are only a few domains where you can actually do this and HPC is one of them. But in 
> > many other situations, you cannot and don't want to have to instrument applications
> > or libraries to collect performance data. It is quite handy to be able to do:
> > 	$ pfmon /bin/ls
> > or
> > 	$ pfmon --attach-task=`pidof sshd` -timeout=10s
> 
> I think only supporting global and self monitoring as first step is totally fine.
I asssume by 'global' you mean system-wide, i.e., measuring all threads running on
a cpu.

> All the bells'n'whistles can be added later if users really want them.
> 
They do because it provides such a simplicity of use. On production systems, it is not
uncommon to not even have compilers installed yet you may want to diagnose performance
problems by simply running a performance tool for a while.

> > 
> > Also note that there is no guarantee that RDPMC allows you to access all data registers
> > on a PMU. For instance, on AMD Barcelona, it seems you cannot read the IBS register using
> > RDPMC.
> 
> Sure at some point a system call for the more complex cases (also like multiplexing) would
> be needed. But I don't think we need it as first step. The goal would be to define a 
> simple subset that is actually mergeable.
> 
> > But you are driving the design of the interface from your very specific need
> > and you are ignoring all the other usage models. This has been a problem with so
> 
> I asked your noisy user base to specify more concrete use cases, but so far
> they have not provided anything except rather vacuous complaints. Short of that I'll stick 
> with what I know currently.
> 
I think they will respond but Phil is busy at Supercomputing  right now. They'll be able
to provide lots of use cases based on their experience with the popular PAPI toolkit.

> > many other interfaces and that explains the current situation. You have to
> > take a broader view, look at what the hardware (across the board) provides and
> > build from there. We do not need yet another interface to support one tool or one
> 
> 
> Well your "broad view" resulted in a incredible mess of interface moloch to be honest.

That is your opinion. I am not trying to say perfmon2 is perfect and I don't want to make changes.
I have proved in the past and still today that I am willing to make changes. See my comments about
pfm_write_pmcs() above.

But what I also know now is that people have managed to port this interface on all major hardware
platforms from X86, Itanium, Cray, Power*, Cell and derivative such Sony Playstation 3. They were
able to do so while providing access to all the advanced features (PEBS, IBS, DEAR, IPEAR, opcode
matchers, range restriction) and not just counters. They have never had to make changes to the
user level API to make their hardware work.

I just trying to say that you need to consider the arguments of people who have been involved with
performance monitoring and development of monitoring tools for a long time and on different architectures.
What you want to do with it is perfectly fine but it only represents a tiny fraction of what you can do
with the hardware and of what many people already want todo today. I would not want to have one interface
to do self-monitoring very well, then another one to do sampling, and another one for multiplexing.

> I really think we need a fresh start examining many of the underlying assumptions.
> 
I am happy to go over every design choices with you and others.

> Regarding itanium: I suppose it could provide a RDPMC replacement using your 
> fast priviledged vsyscalls.
> 

We don't need that. Itanium allows reading of PMD registers directly from user space with
a single instruction once we clear the protection mechanism similar to cr4.pce. And this 
is already done for self-monitoring per-thread sessions today.

-- 
-Stephane
