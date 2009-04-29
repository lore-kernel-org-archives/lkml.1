Return-Path: <linux-kernel-owner+w=401wt.eu-S1758395AbZD2ApP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758395AbZD2ApP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 20:45:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZD2Ao7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 20:44:59 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:47558 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755493AbZD2Ao5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 20:44:57 -0400
Date: Tue, 28 Apr 2009 17:44:51 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered
	active device IRQ interrruption
Message-ID: <20090429004451.GA7329@us.ibm.com>
References: <20090408210745.GE11159@us.ibm.com> <86802c440904081503k545bf7b4n3d44aa3c9d101e0d@mail.gmail.com> <20090408230820.GA14412@us.ibm.com> <86802c440904102346lfbc85f2w4508bded0572ec58@mail.gmail.com> <20090413193717.GB8393@us.ibm.com> <m1bpr0e2au.fsf@fess.ebiederm.org> <20090428000536.GA7347@us.ibm.com> <m1bpqhjco7.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1bpqhjco7.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 03:27:36AM -0700, Eric W. Biederman wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
> 
> > The I/O redirection table register write with the remote
> > IRR set issue has reproduced on every IBM System x server
> > I have tried including the x460, x3850, x3550 M2, and x3950 M2.
> > Nobody has responded to my request to test for the presence
> > of this issue on non-IBM systems but I think it is pretty safe
> > to assume that the problem is not IBM specific.
> 
> There is no question.  The problem can be verified from a simple
> code inspection.  It results from the brokenness of the current
> fixup_irqs.
> 
> Your suggested change at the very least is likely to result in
> dropped irqs at runtime.

Which of the two patches (2/3 or 3/3) could cause the dropped IRQs
and exactly how can this happen?  If you are possibly referring to
the concerns about IRQs being migrated in process context during CPU
offlining, that design pre-dates my patches.

>                           Something some drivers do not
> tolerate well.
> 
> > After incorporating the fix that avoids writes to the 
> > the I/O redirection table registers while the remote IRR
> > bit is set, I have _not_ observed any other issues that 
> > might be related to the ioapic fragility that you mentioned.
> > This of course does not prove that you are wrong and that
> > there is not a need for the changes you are suggesting.
> > However, until someone has the bandwidth to tackle the difficult
> > changes that you suggest, I propose that we continue to repair
> > problems that are found in the current implementation with fixes
> > such as those that I provided.
> 
> The changes I suggest are not difficult.
> 
> How is APIC routing setup on your hardware?
> "Setting APIC routing to flat"  Is what my laptop reports.

Oh, thats easy.  On the IBM x3550 M2 where I have confirmed that
both bugs exist and where I did the below described testing of
your patch, the APIC routing is shown as physical flat:
  "Setting APIC routing to physical flat"

> 
> My apologies for asking it badly last time.

No problem!  Badly probably depends on the audience and
I'm probably not a particularily good one. :)

> For understanding what
> you are testing that is a critical piece of information.
> 
> Below is my draft patch that stops cpu shutdown when irqs can not be
> migrated off.  The code to do that is trivial, and is guaranteed
> to fix all of your lost irq problems.

This didn't help.  Using 2.6.30-rc3 plus your patch both bugs
are unfortunately still present.

With respect to the race fixed by patch 2/3 that occurs when
the device is not very active I have found that a printk in
__assign_irq_vector() showing -EBUSY returns is a reliable
indicator of when things go bad and the CPU handling the IRQ
is offlined without the affinity being migrated to an online CPU.
The following was logged during the failure. 
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY
  __assign_irq_vector: XXX irq=16 returning -EBUSY

I am not sure if I totally understand what your new
cleanup_pending_irqs() is doing but I *think* it is
only broadcasting an IPI when the same IRQ is being
handled on the IRQ move destination CPU.  If this understanding
is correct, I don't think it covers the case where the device
is generating IRQs at such an extremely slow rate that
absolutely none are received between the time that the
move_in_progress flag was set to 1 and the IRQ move
destination CPU is offlined.  I actually played around with
broadcasting an IPI every time the move_in_progress flag
was set to 1 which repaired the problem but did not feel
like a good solution especially after I discovered that there
was no need to even set move_in_progress to 1 if all CPUs in
the old domain were going to be offline when the cleanup code
was run  i.e. cleanup code does nothing when it eventually runs.

I then incorporated my fix (patch 2/3) for the above issue
plus a printk in __target_IO_APIC_irq() to display values
written to the I/O redirection table register for the IRQ
of interest and tried again.  With a low incoming IRQ rate
the above problem no longer reproduced but after increasing
the incoming IRQ rate I started seeing an increasing number
of writes to the I/O redirection table register while the
remote IRR bit was set (see below) before IRQs from the
device were no longer being seen by the kernel.

> 
> Beyond that everything I am proposing is very localized.
> 
> You have proposed making interrupts behave like they can be migrated
> in process context when in fact extensive testing over the years have
> shown in the general case interrupts can only be migrated from the irq
> handler, from a location where the irqs are naturally disabled.

To be clear, IRQs were already being migrated in process
context during CPU offlining before I even looked at the code.
This was not my doing.  I believe it has been this way for
quite some time. 

> 
> I propose detecting the cases that we know are safe to migrate in
> process context, aka logical deliver with less than 8 cpus aka "flat"
> routing mode and modifying the code so that those work in process
> context and simply deny cpu hotplug in all of the rest of the cases.

Humm, are you suggesting that CPU offlining/onlining would not
be possible at all on systems with >8 logical CPUs (i.e. most
of our systems) or would this just force users to separately
migrate IRQ affinities away from a CPU (e.g. by shutting down
the irqbalance daemon and writing to /proc/irq/<irq>/smp_affinity)
before attempting to offline it?

Thanks,
Gary

--
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

ioc0: LSISAS1ities={Initiatorities={Initiator}IC_irq: XXX irqPIC_irq: XXX irq=y with reg=0xa0fy with reg=0xa061:00.0: setting01:00.0: setting  64
melm3b55:~ # m__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a072
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a082
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0aa
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ca
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ea
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a043
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a063
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a073
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a093
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0db
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0eb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a054
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a064
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a084
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ac
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0dc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ec
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ec
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ec
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ec
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a045
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a055
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a065
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a065
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a065
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e065
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a075
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e085
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e08d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a095
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09d
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ad
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0b5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0b5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bd
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cd
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0dd
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0dd
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0dd
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0dd
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e5
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a046
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a056
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a066
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a076
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e07e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a086
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a086
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a086
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a086
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a096
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09e
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ae
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ae
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ae
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ae
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0be
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ce
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0d6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0de
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e6
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a047
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a057
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a057
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a057
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a057
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a067
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a077
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e07f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a087
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a097
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09f
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0af
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bf
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cf
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cf
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cf
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cf
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0df
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e7
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a048
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a050
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a050
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a050
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a050
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a058
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a060
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a068
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a070
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a078
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a078
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a078
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a078
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a088
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a090
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a098
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0a0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0a8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e0
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e8
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a041
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a049
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a049
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a049
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a049
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a051
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a059
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a061
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a069
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a071
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e071
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a071
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a071
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a079
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a081
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a089
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a072
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a072
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a072
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a072
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a082
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a092
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09a
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0aa
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ba
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ca
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0da
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e2
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ea
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ea
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ea
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ea
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a043
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a053
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e05b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a063
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e063
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e063
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a063
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a073
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a083
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a093
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09b
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0ab
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0b3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0bb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0c3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0cb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0d3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0db
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0db
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0db
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0db
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0e3
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0eb
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a044
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e04c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a054
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e054
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a054
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a054
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a05c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a064
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a06c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a074
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a07c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a084
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a08c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a094
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a09c
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0a4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1a0a4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0a4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0ac
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0b4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0bc
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
__target_IO_APIC_irq: XXX irq=16 io_apic_modify with reg=0x1e0c4
