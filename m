Return-Path: <linux-kernel-owner+w=401wt.eu-S1753975AbXFNQIF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975AbXFNQIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 12:08:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbXFNQH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 12:07:56 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:48233 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751870AbXFNQHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 12:07:55 -0400
Date: Thu, 14 Jun 2007 12:02:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Adrian Bunk <bunk@stusta.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/9] Conditional Calls - Architecture Independent Code
Message-ID: <20070614160241.GA21119@Krystal>
References: <20070530140025.917261793@polymtl.ca> <20070530140227.070136408@polymtl.ca> <20070604190102.GY5500@stusta.de> <20070613155724.GA8703@Krystal> <20070613215104.GK3588@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070613215104.GK3588@stusta.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:27:21 up 17 days, 5 min,  3 users,  load average: 0.94, 0.67, 0.62
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Adrian Bunk (bunk@stusta.de) wrote:
> On Wed, Jun 13, 2007 at 11:57:24AM -0400, Mathieu Desnoyers wrote:
> > Hi Adrian,
> 
> Hi Mathieu,
> 
> >...
> > > 2. What is the real-life performance improvement?
> > > That micro benchmarks comparing cache hits with cache misses give great 
> > > looking numbers is obvious.
> > > But what will be the performance improvement in real workloads after the
> > > functions you plan to make conditional according to question 1 have been 
> > > made conditional?
> > 
> > Hrm, I am trying to get interesting numbers out of lmbench: I just ran a
> > test on a kernel sprinkled with about 50 markers at important sites
> > (LTTng markers: system call entry/exit, traps, interrupt handlers, ...).
> > The markers are compiled-in, but in "disabled state". Since the markers
> > re-use the cond_call infrastructure, each marker has its own cond_call.
> >...
> > The results are that we really cannot tell that one is faster/slower
> > than the other; the standard deviation is much higher than the
> > difference between the two situations.
> > 
> > Note that lmbench is a workload that will not trigger much L1 cache
> > stress, since it repeats the same tests many times. Do you have any
> > suggestion of a test that would be more representative of a real
> > diversified (in term of in-kernel locality of reference) workload ?
> 
> Please correct me if I'm wrong, but I think 50 markers couldn't ever 
> result in a visible change:
> 

Well, we must take into account where these markers are added and how
often the marked code is run. Since I mark very highly used code paths
(interrupt handlers, page faults, lockdep code) and also plan to mark
other code paths like the VM subsystem, adding cycles to these code
paths seems like a no-go solution for standard distribution kernels.

> You need a change that is big enough that it has a measurable influence 
> on the cache hit ratio.
> 
> I don't think you could get any measurable influence unless you get into 
> areas where > 10% of all code are conditional. And that's a percentage 
> I wouldn't consider being realistically.
> 

I just constructed a simple workload that exacerbates the improvement
brought by the optimized conditional calls:

- I instrument kernel/irq/hanle.c:handle_IRQ_event() by disabling
  interrupts, getting 2 cycle counter counts and incrementing the number
  of events logged by 1 and then reenabling interrupts.
- I create a small userspace program that writes to 1MB memory buffers
  in a loop, simulating a memory bound user-space workload.
- I get the avg. number of cycles spent per IRQ between the cycle
  counter reads.
- I put 4 markers in kernel/irq/hanle.c:handle_IRQ_event() between the
  cycles counter reads.
- I get the avg number of cycles with immediate value based markers and
  with static variable based markers, under an idle system and while
  running my user-space program causing memory pressure. Markers are in
  their disabled state.

These tests are conducted on a 3Ghz Pentium 4.

Results : (units are in cycles/interrupt)

Test                          | Idle system | With memory pressure
---------------------------------------------------------------------
Markers compiled out          | 100.47      | 100.27
Immediate value-based markers | 100.22      | 100.16
Static variable-based markers | 100.71      | 105.84

It shows that adding 4 markers does not add a visible impact to this
code path, but that using static variable-based markers adds 5 cycles.
Typical interrupt handler duration, taken from a LTTng trace, are in the
13k cycles range, so we guess 5 cycles does not add much externally
visible impact to this code path. However, if we plan to use markers to
instrument the VM subsystem, lockdep or, like dtrace, every function
entry/exit, it could be worthwhile to have an unmeasurable effect on
performances.

> And one big disadvantage of your implementation is the dependency on 
> MODULES. If you build all driver statically into the kernel, switching 
> from CONFIG_MODULES=y to CONFIG_MODULES=n already gives you for free a 
> functionally equivalent kernel that is smaller by at about 8% (depending 
> on the .config).
> 

Yes, you are right. I have put my code in module.c only because I need
to take a lock on module_mutex which is statically declared in module.c.
If declaring this lock globally could be considered as an elegant
solution, then I'll be more than happy to put my code in my own new
kernel/condcall.c file. I would remove the dependency on CONFIG_MODULES.
Does it make sense ?

> My impression is that your patches would add an infrastructure for a 
> nice sounding idea that will never have any real life effect.
> 

People can get really picky when they have to decide wether or not they
compile-in a profiling or tracing infrastructure in a distribution
kernel.  If the impact is detectable when they are not doing any tracing
nor profiling, their reflex will be to compile it out so they can have
the "maximum performance". This is why I am going through the trouble of
making the markers impact as small as possible.

Mathieu


> > Thanks,
> > 
> > Mathieu
> 
> cu
> Adrian
> 
> -- 
> 
>        "Is there not promise of rain?" Ling Tan asked suddenly out
>         of the darkness. There had been need of rain for many days.
>        "Only a promise," Lao Er said.
>                                        Pearl S. Buck - Dragon Seed
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
