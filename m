Return-Path: <linux-kernel-owner+w=401wt.eu-S1756769AbXKNNLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769AbXKNNLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 08:11:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbXKNNL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 08:11:28 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:59173 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752264AbXKNNL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 08:11:27 -0500
Date: Wed, 14 Nov 2007 05:09:09 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@osdl.org, Robert Richter <robert.richter@amd.com>, gregkh@suse.de,
       linux-kernel@vger.kernel.org, William Cohen <wcohen@redhat.com>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Message-ID: <20071114130909.GB6557@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20071113175545.GD4319@frankl.hpl.hp.com> <4739EE13.2090006@redhat.com> <20071113211345.GB5747@frankl.hpl.hp.com> <20071113212902.GA17593@one.firstfloor.org> <20071113214628.GE5747@frankl.hpl.hp.com> <20071113215056.GB17593@one.firstfloor.org> <20071113222234.GH5747@frankl.hpl.hp.com> <20071113222534.GC17145@one.firstfloor.org> <20071113225848.GK5747@frankl.hpl.hp.com> <20071114020702.GB20365@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114020702.GB20365@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi,

On Wed, Nov 14, 2007 at 03:07:02AM +0100, Andi Kleen wrote:
> 
> [dropped all these bouncing email lists. Adding closed lists to public
> cc lists is just a bad idea]
> 

Just want to make sure perfmon2 users participate in this discussion.

> > int
> > main(int argc, char **argv)
> > {
> > 	int ctx_fd;
> > 	pfarg_pmd_t pd[1];
> > 	pfarg_pmc_t pc[1];
> > 	pfarg_ctx_t ctx;
> > 	pfarg_load_t load_args;
> > 
> > 	memset(&ctx, 0, sizeof(ctx));
> > 	memset(pc, 0, sizeof(pc));
> > 	memset(pd, 0, sizeof(pd));
> > 
> > 	/* create session (context) and get file descriptor back (identifier) */
> > 	ctx_fd = pfm_create_context(&ctx, NULL, NULL, 0);
> 
> There's nothing in your example that makes the file descriptor needed.
> 

Partially true. The file descriptor becomes really useful when you sample.
You leverage the file descriptor to receive notifications of counter overflows
and full sampling buffer. You extract notification messages via read() and you can
use SIGIO, select/poll.

The example shows how you can leverage existing mechanisms to destroy the session, i.e.,
free the associated kernel resources. For that, you use close() instead of adding yet
another syscall. It also provides a resource limitation mechanisms to control consumption
of kernel memory, i.e., you can only create as many sessions as you can have open files.

> > 
> > 	/* setup one config register (PMC0) */
> > 	pc[0].reg_num   = 0
> > 	pc[0].reg_value = 0x1234;
> 
> That would be nicer if it was just two arguments.
> 
Are you suggesting something like: pfm_write_pmcs(fd, 0, 0x1234)?

That would be quite expensive when you have lots of registers to setup: one
syscall per register. The perfmon syscalls to read/write registers accept vector
of arguments to amortize the cost of the syscall over multiple registers
(similar to poll(2)).

With many tools, registers are not just setup once. During certain measurements,
data registers may be read multiple times. When you sample or multiplex at
the user level, you do need to reprogram the PMU state and that is on the critical
path.

You do not want a call that programs the entire PMU state all at once either. Many times,
you only want to modify a small subset. Having the full state does also cause some portability
problems.


> > 
> > 	/* setup one data register (PMD0) */
> > 	pd[0].reg_num = 0;
> > 	pd[0].reg_value = 0;
> 
> Why do you need to set the data register? Wouldn't it make
> more sense to let the kernel handle that and just return one.
> 
It depends on what you are doing. Here, this was not really necessary. It was
meant to show how you can program the data registers as well. Perfmon2 provides
default values for all data registers. For counters, the value is guaranteed to
be zero.

But it is important to note that not all data registers are counters. That is the
case of Itanium 2, some are just buffers. On AMD Barcelona IBS several are buffers as
well, and some may need to be initialized to non zero value, i.e., the IBS sampling
period.

With event-based sampling,  the period is expressed as the number of occurrences
of an event. For instance, you can say: " take a sample every 2000 L2 cache misses".
The way you express this with perfmon2 is that you program a counter to measure
L2 cache misses, and then you initialize the corresponding data register (counter)
to overflow after 2000 occurrences. Given that the interface guarantees all counters
are 64-bit regardless of the hardware, you simply have to program the counter to -2000.
Thus you see that you need a call to actual program the data registers.

> > 
> > 	/* program the registers */
> > 	pfm_write_pmcs(ctx_fd, pc, 1);
> > 	pfm_write_pmds(ctx_fd, pd, 1);
> > 
> > 	/* attach the context to self */
> > 	load_args.load_pid = getpid();
> > 	pfm_load_context(ctx_fd, &load_args);
> 
> My replacement would be to just add a flags argument to write_pmcs 
> with one flag bit meaning "GLOBAL CONTEXT" versus "MY CONTEXT"
> > 

You are mixing PMU programming with the type of measurement you want to do.

Perfmon2 decouples the two operations. In fact, no PMU hardware is actually touched
before you attach to either a CPU or a thread. This way, you can prepare your measurement
and then attach-and-go. Thus is is possible to create batches of ready-to-go sessions.
That is useful, for instance, when you are trying to measure across fork, pthread_create
which you can catch on-the-fly.

Take the per-thread example, you can setup your session before you fork/exec the program
you want to measure.

Note also that perfmon2 supports attaching to an already running thread. So there is
more than "GLOBAL CONTEXT" versus "MY CONTEXT".


> > 	/* activate monitoring */
> > 	pfm_start(ctx_fd, NULL);
> 
> Why can't that be done by the call setting up the register?
> 

Good question. If you do what say, you assume that the start/stop bit lives in the
config (or data) registers of the PMU. This is not true on all hardware. On Itanium
for instance, the start/stop bit is part of the Processor Status Register (psr).
That is not a PMU register.

On X86, you set the enable bit the PERFEVTSEL, but nothing really happens until you issue
pfm_start(), i.e., the PERFEVTSEL registers are not touched until then.

> Or if someone needs to do it for a specific region they can read
> the register before and then afterwards.
> 
> > 
> > 	/*
> > 	 * run code to measure
> > 	 */
> > 
> > 	/* stop monitoring */
> > 	pfm_stop(ctx_fd);
> > 
> > 	/* read data register */
> > 	pfm_read_pmds(ctx_fd, pd, 1);
> 
> On x86 i think it would be much simpler to just let the set/alloc
> register call return a number and then use RDPMC directly. That would
> be actually faster and be much simpler too.
> 
One approach does not prevent the other. Assuming you allow cr4.pce, then nothing prevents
a self-monitoring thread from reading the counters directly. You'll just get the
lower 32-bit of it. So if you read frequently enough, you should not have a problem.

But keep in mind that we do want a uniform interface across all hardware and all type
of sessions (self-monitoring, CPU-wide, monitoring of another thread). You don't want
an interface that says on x86 you have to use rdpmc, on Itanium pfm_read_pmds() and so
on. You want an interface that guarantees that with pfm_read_pmds() you'll be able to
read on any hardware platforms, then on some you may be able to use a more efficient
method, e.g., rdpmc on X86.

Reducing performance monitoring to self-monitoring is not what we want. In fact, there
are only a few domains where you can actually do this and HPC is one of them. But in 
many other situations, you cannot and don't want to have to instrument applications
or libraries to collect performance data. It is quite handy to be able to do:
	$ pfmon /bin/ls
or
	$ pfmon --attach-task=`pidof sshd` -timeout=10s


Also note that there is no guarantee that RDPMC allows you to access all data registers
on a PMU. For instance, on AMD Barcelona, it seems you cannot read the IBS register using
RDPMC.


> I suppose most architectures have similar facilities, if not a call could be 
> added for them but it's not really essential. The call might be also needed
> for event multiplexing, but frankly I would just leave that out for now.
> 
Itanium does allow user level read of data registers. It also allows start/stop.
Perfmon2 allows this only for self-monitoring per-thread sessions.

I think restricting per-thread mode to only self-monitoring is just too limiting
even for a start.


> e.g. here is one use case I would personally see as useful. We need
> a replacement for simple cycle counting since RDTSC doesn't do that anymore
> on modern x86 CPUs.  It could be something like:
> 
You can do exactly this with the perfmon2 interface as it exists today.
Your example is perfectly fine, your interface works in your case.

But you are driving the design of the interface from your very specific need
and you are ignoring all the other usage models. This has been a problem with so
many other interfaces and that explains the current situation. You have to
take a broader view, look at what the hardware (across the board) provides and
build from there. We do not need yet another interface to support one tool or one
type of measurement, we need a true programming interface with a uniform set
of calls. So sure, several calls may look overkill for basic measurements, but
they become necessary with others.

> 	/* 0 is the initial value */
> 
> 	/* could be either library or syscall */
> 	event = get_event(COUNTER_CYCLES); 
> 	if (event < 0) 
> 		/* CPU has no cycle counter */
> 
> 	reg = setup_perfctr(event, 0 /* value */, LOCAL_EVENT); /* syscall */
> 
> 	rdpmc(reg, start);
> 	.... some code to run ...
> 	rdpmc(reg, end);
> 
> 	free_perfctr(reg);	/* syscall */
> 
-- 
-Stephane
