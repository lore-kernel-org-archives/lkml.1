Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0CEWVG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 17:21:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:41052 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337Ab0CEWVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 17:21:03 -0500
Subject: Re: HW perf. events arch implementation
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1EE1A83F-EB50-40F3-A6A0-5D8DE0B38446@orcon.net.nz>
References: <1EE1A83F-EB50-40F3-A6A0-5D8DE0B38446@orcon.net.nz>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 05 Mar 2010 23:20:57 +0100
Message-ID: <1267827657.4997.51.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-24 at 14:35 +1300, Michael Cree wrote:
> I am trying to implement arch specific code on the Alpha for hardware  
> performance events (yeah, I'm probably a little bit loopy and unsound  
> of mind pursuing this on an end-of-line platform, but it's a way in to  
> learn a little bit of kernel programming and it scratches an itch).
> 
> I have taken a look at the code in the x86, sparc and ppc  
> implementations and tried to drum up an Alpha implementation for the  
> EV67/7/79 cpus, but it ain't working and is producing obviously  
> erroneous counts.  Part of the problem is that I don't understand  
> under what conditions, and with what assumptions, the performance  
> event subsystem is calling into the architecture specific code.  Is  
> there any documentation available that describes the architecture  
> specific interface?
> 
> The Alpha CPUs of interest have two 20-bit performance monitoring  
> counters that can count cycles, instructions, Bcache misses and Mbox  
> replays (but not all combinations of those).  For round numbers  
> consider a 1GHz CPU, with a theoretical maximal sustained throughput  
> of four instructions per cycle, then a single performance counter  
> could potentially generate 4000 interrupts per second to signal  
> counter overflow when counting instructions.
> 
> The x86, sparc and PPC implementations seem to me to assume that calls  
> to read back the counters occur more frequently than performance  
> counter overflow interrupts, and that the highest bit of the counter  
> can safely be used to detect overflow.  (Am I correct?)  That is  
> likely not to be true of the Alpha because of the small width of the  
> counter.  Is there someone who would be happy to give me, a kernel  
> newbie who probably doesn't even make the grade of neophyte, a bit of  
> direction on this?

Right, so the architecture interface is 2 fold, a struct pmu, and a
bunch of weak hw_perf_*() functions.

I'm trying to move away from the hw_perf*() functions, but for now
they're there and are useful for a number of things.

We have:

  hw_perf_event_init();
  hw_perf_disable();
  hw_perf_enable();
  hw_perf_group_sched_in();

hw_perf_event_init() is called when we are creating a counter of type
PERF_TYPE_RAW, PERF_TYPE_HARDWARE or PERF_TYPE_HW_CACHE, it will return
a struct pmu for that event.

hw_perf_disable()/hw_perf_enable() are like
local_irq_disable()/local_irq_enable() but for the Performance Monitor
Interrupt (PMI), which might be a NMI, so we need to disable it in some
arch specific way -- these basically freeze/unfreeze the PMU.

hw_perf_group_sched_in() is a bit of a nightmare and a source of bugs
and I really should get around to killing it off, but this is used
optimize multiple pmu->enable() calls.

Then we have struct pmu, it has the following members:

  enable()
  disable()
  start()
  stop()
  read()
  unthrottle()


->enable() will try to program the event onto the hardware and return 0
on success, if however it cannot, due to there not being a suitable
counter available, it shall return an error.

->disable() will remove the event from the hardware and release all
resources that were acquired by ->enable().

->start() will undo ->stop().

->stop() will stop the counter but not release any resources that might
have been acquired by ->enable().

->read() will read the hardware counter and fold the delta into
event->count.

->unthrottle(), when present, will undo whatever is done to stop the PMI
from triggering after perf_event_overflow() returns !0. That is, we have
sysctl_perf_event_sample_rate and we try to ensure the PMI doesn't
exceed that, if it does perf_event_overflow() will return !0 and the
arch code is supposed to inhibit it from firing again until
->unthrottle() is called. This avoid users from accidentally
live-locking the system by requesting a PMI on every completed
instruction ;-)

[ ->start/->stop are a way to reprogram the hardware without releasing
  constraint reservations, this is useful when you change the 


As to your counter width, if you have a special overflow bit in a
separate register then you can possibly use that, but otherwise you need
it to keep your count straight. The PMI will happen _after_ the
overflow, at which point you need to fold back the counter delta into
your event->count, if it just overflowed that's bound to be a very small
delta -- I guess you can always add the max value on PMI, but it might
racy, esp. in the presence of ->read() calls.

Also, if you have multiple registers sharing a PMI you need to be able
to tell which register overflowed and caused the PMI.

> Also, the Alpha CPUs have an interesting mode whereby one programmes  
> up one counter with a specified (or random) value that specifies a  
> future instruction to profile.  The CPU runs for that number of  
> instructions/cycles, then a short monitoring window (of a few cycles)  
> is opened about the profiled instruction and when completed an  
> interrupt is generated.  One can then read back a whole lot of  
> information about the pipeline at the time of the profiled  
> instruction.  This can be used for statistical sampling.  Does the  
> performance events subsystem support monitoring with such a mode?

That sounds like AMD IBS, which I've been told is based on the Alpha
PMU. We currently do no have AMD IBS supported.

AMD has two IBS counters, one does instructions and one does fetches, I
think Robert was going to support these by modeling them as fixed
purpose counters and provide the extra information through
PERF_SAMPLE_RAW until we can come up with a saner model.

A potential saner model is adding non sampling counters into its group
which are used to represent these other aspects of the unit.

