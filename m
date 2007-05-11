Return-Path: <linux-kernel-owner+w=401wt.eu-S933609AbXEKSMd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933609AbXEKSMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 14:12:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759596AbXEKSM1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 14:12:27 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:53834 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754173AbXEKSM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 14:12:26 -0400
Date: Fri, 11 May 2007 14:02:07 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@muc.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, systemtap@sources.redhat.com,
       prasanna@in.ibm.com, ananth@in.ibm.com, anil.s.keshavamurthy@intel.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       hch@infradead.org
Subject: Re: [patch 05/10] Linux Kernel Markers - i386 optimized version
Message-ID: <20070511180207.GA25516@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020916.508519573@polymtl.ca> <20070510090656.GA57297@muc.de> <20070510155501.GI22424@Krystal> <20070510172843.7aa72237@the-village.bc.nu> <20070510165918.GK22424@Krystal> <20070511060444.GA35262@muc.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070511060444.GA35262@muc.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 13:18:11 up 98 days,  7:25,  5 users,  load average: 2.28, 2.24, 2.30
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@muc.de) wrote:
> On Thu, May 10, 2007 at 12:59:18PM -0400, Mathieu Desnoyers wrote:
> > * Alan Cox (alan@lxorguk.ukuu.org.uk) wrote:
> > > > * First issue : Impact on the system. If we try to make this system
> > > >   scale, we will create very long irq disable sections. The expected
> > > >   duration is the worse case IPI latency plus the time it takes to CPU A
> > > >   to change the variable. We therefore directly grow the worse case
> > > >   system's interrupt latency.
> > > 
> > > Not a huge problem. It doesn't scale in really horrible ways and the IPI
> > > latency on a PIV or later is actually very good. Also the impact is less
> > > than you might think as on huge huge boxes you want multiple copies of
> > > the kernel text pages to reduce NUMA traffic, so you only have to sync
> > > the group of processors involved 
> 
> I agree with Alan and disagree with you on the impact on the system.
> 

I just want to make sure I understand your disagreement. You do not seem
to provide any counter-argument to the following technical fact : the
proposed algorithm will increase the worse-case interrupt latency of the
kernel.

The IPI might be fast, but I have seen interrupts being disabled for
quite a long time in some kernel code paths. Having interrupts disabled
on _each cpu_ while running an IPI handler waiting to be synchronized
with other CPUs has this side-effect. Therefore, if I understand well,
you object that the worse-case interrupt latency in the Linux kernel is
not important. Since I have some difficulty agreeing with your
objection, I'll leave the debate about the importance of such
side-effects to others, since it is mostly a political issue.

Or maybe am I not understanding you correctly ?


> > > 
> > > > * Second issue : irq disabling does not protect us from NMI and traps.
> > > >   We cannot use this algorithm to mark these code segments.
> > > 
> > > If you synchronize all the other processors and disable local interrupts
> > > then the only traps you have to worry about are those you cause, and the
> > > only person taking the trap will be you so you're ok.
> > > 
> > > NMI is hard but NMI is a special case not worth solving IMHO.
> > > 
> > 
> > Not caring about NMIs may have more impact than one could expect. You
> > have to be aware that (at least) the following code is executed in NMI
> > context. Trying to patch any of these functions could result in a dying
> > CPU :
> 
> There is a function to disable the nmi watchdog temporarily now
> 

As you pointed out below, NMI is only one example of interrupt sources
that cannot be protected by irq disable, such as MCE and SMIs. See below
for the rest of the discussion about this point.

> 
> > In entry.S, there is also a call to local_irq_enable(), which falls into
> > lockdep code.
> 
> ??
> 

arch/i386/kernel/entry.S :
iret_exc:
        TRACE_IRQS_ON
        ENABLE_INTERRUPTS(CLBR_NONE)
        pushl $0                        # no error code
        pushl $do_iret_error
        jmp error_code

include/asm-i386/irqflags.h
# define TRACE_IRQS_ON                          \
        pushl %eax;                             \
        pushl %ecx;                             \
        pushl %edx;                             \
        call trace_hardirqs_on;                 \
        popl %edx;                              \
        popl %ecx;                              \
        popl %eax;

Which falls into the lockdep.c code.

> > 
> > Tracing those core kernel functions is a fundamental need of crash
> > tracing. So, in my point of view, it is not "just" about tracing NMIs,
> > but it's about tracing code that can be touched by NMIs.
> 
> You only need to handle the erratas during the modification, not during
> the whole lifetime of the marker. 
> 

I agree with you, but you need to make the modification of every callees
of functions such as printk() safe in order to be able to trace them
later.

> The only frequent NMIs are watchdog and oprofile which both can
> be stopped. Other NMIs are very infrequent.

If we race with an "infrequent" NMI with this algorithm, it will result
in a unspecified trap, most likely a GPF. So having a solution that is
correct most of the time is not an option here. It will not just cause a
glitch, but bring the whole system down.

> 
> BTW if you worry about NMI you would need to worry about machine
> check and SMI too.
> 

Absolutely. I use NMIs as an example of these conditions, but MCE and
SMI also present the same issue.

So we get another example (I am sure we could easily find more) :

arch/i386/kernel/cpu/mcheck/p4.c:intel_machine_check
  printk (and everything that printk calls)
    vprintk
      printk_clock
        sched_clock
      release_console_sem
        call_console_drivers
          .. therefore serial port code..
        wake_up_klogd
          wake_up_interruptible
            try_to_wake_up

So.. just the fact that the MCE uses printk involves scheduler code
execution. If you plan not to support NMI, MCE or SMI, you have to
forbid instrumentation of any of those code paths.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
