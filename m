Return-Path: <linux-kernel-owner+w=401wt.eu-S1759480AbXKNOY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759480AbXKNOY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 09:24:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755803AbXKNOYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 09:24:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54340 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbXKNOYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 09:24:18 -0500
Date: Wed, 14 Nov 2007 15:24:11 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Stephane Eranian <eranian@hpl.hp.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
       Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, William Cohen <wcohen@redhat.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114142411.GD17145@one.firstfloor.org>
References: <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com> <20071114020702.GB20365@one.firstfloor.org> <20071114130909.GB6557@frankl.hpl.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114130909.GB6557@frankl.hpl.hp.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 05:09:09AM -0800, Stephane Eranian wrote:
> 
> Partially true. The file descriptor becomes really useful when you sample.
> You leverage the file descriptor to receive notifications of counter overflows
> and full sampling buffer. You extract notification messages via read() and you can
> use SIGIO, select/poll.

Hmm, ok for the event notification we would need a nice interface. Still
have my doubts a file descriptor is the best way to do this though.

> Are you suggesting something like: pfm_write_pmcs(fd, 0, 0x1234)?

See my example below.
> 
> That would be quite expensive when you have lots of registers to setup: one
> syscall per register. The perfmon syscalls to read/write registers accept vector
> of arguments to amortize the cost of the syscall over multiple registers
> (similar to poll(2)).


First system calls are not that slow on Linux. Measure it.


> 
> With many tools, registers are not just setup once. During certain measurements,
> data registers may be read multiple times. When you sample or multiplex at

I think you optimize the wrong thing here.

There are basically two cases I see:

-  Global measurement of lots of things:
Things are slow anyways with large context switch overheads. The 
overheads are large anyways. Doing one or more system calls probably
does not matter much. Most important is a clean interface.

- Exact measurement of the current process. For that you need very
low latencies. Any system call is too slow. That is why CPUs have
instructions like RDPMC that allow to read those registers with
minimal latency in user space. Interface should support those.

Also for this case programming time does not matter too much. You
just program once and then do RDPMC before code to measure and then
afterwards and take the difference. The actual counter setup is out 
of the latency critical path.


> It depends on what you are doing. Here, this was not really necessary. It was
> meant to show how you can program the data registers as well. Perfmon2 provides
> default values for all data registers. For counters, the value is guaranteed to
> be zero.
> 
> But it is important to note that not all data registers are counters. That is the
> case of Itanium 2, some are just buffers. On AMD Barcelona IBS several are buffers as
> well, and some may need to be initialized to non zero value, i.e., the IBS sampling
> period.

Setting period should be a separate call. Mixing the two together into one
 does not look like a nice interface.

> 
> With event-based sampling,  the period is expressed as the number of occurrences
> of an event. For instance, you can say: " take a sample every 2000 L2 cache misses".
> The way you express this with perfmon2 is that you program a counter to measure
> L2 cache misses, and then you initialize the corresponding data register (counter)
> to overflow after 2000 occurrences. Given that the interface guarantees all counters
> are 64-bit regardless of the hardware, you simply have to program the counter to -2000.
> Thus you see that you need a call to actual program the data registers.

I didn't object to providing the initial value -- my example had that.
Just having a separate concept of data registers seems too complicated to me.
You should just pass event types and values and the kernel gives you
a register number.


> Perfmon2 decouples the two operations. In fact, no PMU hardware is actually touched
> before you attach to either a CPU or a thread. This way, you can prepare your measurement
> and then attach-and-go. Thus is is possible to create batches of ready-to-go sessions.
> That is useful, for instance, when you are trying to measure across fork, pthread_create
> which you can catch on-the-fly.
> 
> Take the per-thread example, you can setup your session before you fork/exec the program
> you want to measure.

And?  You didn't say what the advantage of that is? 

All the approaches add context switch latencies. It is not clear that the separate
session setup helps it all that much.

> 
> Note also that perfmon2 supports attaching to an already running thread. So there is
> more than "GLOBAL CONTEXT" versus "MY CONTEXT".

What is the use case of this? Do users use that? 

> 
> 
> > > 	/* activate monitoring */
> > > 	pfm_start(ctx_fd, NULL);
> > 
> > Why can't that be done by the call setting up the register?
> > 
> 
> Good question. If you do what say, you assume that the start/stop bit lives in the
> config (or data) registers of the PMU. This is not true on all hardware. On Itanium
> for instance, the start/stop bit is part of the Processor Status Register (psr).
> That is not a PMU register.


Well the system call layer can manage that transparently with a little software state
(counter). No need to expose it.

> One approach does not prevent the other. Assuming you allow cr4.pce, then nothing prevents
> a self-monitoring thread from reading the counters directly. You'll just get the
> lower 32-bit of it. So if you read frequently enough, you should not have a problem.

Hmm? RDPMC is 64bit.
> 
> But keep in mind that we do want a uniform interface across all hardware and all type
> of sessions (self-monitoring, CPU-wide, monitoring of another thread). You don't want
> an interface that says on x86 you have to use rdpmc, on Itanium pfm_read_pmds() and so

I disagree. Using RDPMC is essential for at least some of the things I would like
to do with perfmon2. If the interface does not provide it it is useless to me at least.
System calls are far too slow for cycle measurements. 

And when RDPMC is already supported it should be as widely used as possible.

Regarding the portable code problem: of course you would have some header in user space
that hides the details in a hopefully portable macro.

> on. You want an interface that guarantees that with pfm_read_pmds() you'll be able to
> read on any hardware platforms, then on some you may be able to use a more efficient
> method, e.g., rdpmc on X86.
> 
> Reducing performance monitoring to self-monitoring is not what we want. In fact, there
> are only a few domains where you can actually do this and HPC is one of them. But in 
> many other situations, you cannot and don't want to have to instrument applications
> or libraries to collect performance data. It is quite handy to be able to do:
> 	$ pfmon /bin/ls
> or
> 	$ pfmon --attach-task=`pidof sshd` -timeout=10s

I think only supporting global and self monitoring as first step is totally fine.
All the bells'n'whistles can be added later if users really want them.

> 
> 
> Also note that there is no guarantee that RDPMC allows you to access all data registers
> on a PMU. For instance, on AMD Barcelona, it seems you cannot read the IBS register using
> RDPMC.

Sure at some point a system call for the more complex cases (also like multiplexing) would
be needed. But I don't think we need it as first step. The goal would be to define a 
simple subset that is actually mergeable.

> But you are driving the design of the interface from your very specific need
> and you are ignoring all the other usage models. This has been a problem with so

I asked your noisy user base to specify more concrete use cases, but so far
they have not provided anything except rather vacuous complaints. Short of that I'll stick 
with what I know currently.

> many other interfaces and that explains the current situation. You have to
> take a broader view, look at what the hardware (across the board) provides and
> build from there. We do not need yet another interface to support one tool or one


Well your "broad view" resulted in a incredible mess of interface moloch to be honest.
I really think we need a fresh start examining many of the underlying assumptions.

Regarding itanium: I suppose it could provide a RDPMC replacement using your 
fast priviledged vsyscalls.

-Andi

