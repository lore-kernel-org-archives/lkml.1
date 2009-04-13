Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZDMVJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZDMVJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 17:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbZDMVJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 17:09:20 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40561 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZDMVJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 17:09:20 -0400
Date: Mon, 13 Apr 2009 14:09:13 -0700
From: Gary Hade <garyhade@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Gary Hade <garyhade@us.ibm.com>, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered
	inactive device IRQ interrruption
Message-ID: <20090413210913.GC8393@us.ibm.com>
References: <20090408210735.GD11159@us.ibm.com> <m1ljq5r7lw.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljq5r7lw.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 12:32:11PM -0700, Eric W. Biederman wrote:
> Gary Hade <garyhade@us.ibm.com> writes:
> 
> > Impact: Eliminates a race that can leave the system in an
> >         unusable state
> >
> > During rapid offlining of multiple CPUs there is a chance
> > that an IRQ affinity move destination CPU will be offlined
> > before the IRQ affinity move initiated during the offlining
> > of a previous CPU completes.  This can happen when the device
> > is not very active and thus fails to generate the IRQ that is
> > needed to complete the IRQ affinity move before the move
> > destination CPU is offlined.  When this happens there is an
> > -EBUSY return from __assign_irq_vector() during the offlining
> > of the IRQ move destination CPU which prevents initiation of
> > a new IRQ affinity move operation to an online CPU.  This
> > leaves the IRQ affinity set to an offlined CPU.
> >
> > I have been able to reproduce the problem on some of our
> > systems using the following script.  When the system is idle
> > the problem often reproduces during the first CPU offlining
> > sequence.
> 
> Ok.  I have had a chance to think through what you your patches
> are doing and it is assuming the broken logic in cpu_down is correct
> and patching over some but not all of the problems.
> 
> First the problem is not migrating irqs when IRR is set.

When the device is very active, a printk in __target_IO_APIC_irq()
immediately prior to
    io_apic_modify(apic, 0x10 + pin*2, reg);
intermittently displays 'reg' values indicating that the
Remote IRR bit is set.

With PATCH 3/3 the same printk displays no 'reg' values
indicating that the Remote IRR bit is set _and_ the IRQ
interruption problem disappears.

This is what led me to very strongly believe that the
problem was caused by writing the I/O redirection table
register while the Remote IRR bit was set.

> The general
> problem is that the state machines in most ioapics are fragile and
> can get confused if you reprogram them at any point when an irq can
> come in.

IRQs are masked [from fixup_irqs() when offlining a CPU, from
ack_apic_level() when not offlining a CPU] during the reprogramming.
Does this not help avoid the issue?  Sorry if this is a nieve
question.

>  In the middle of an interrupt handler is the one time we
> know interrupts can not come in.
> 
> To really fix this problem we need to do two things.
> 1) Tack when irqs that can not be migrated from process context are
>    on a cpu, and deny cpu hot-unplug.
> 2) Modify every interrupt that can be safely migrated in interrupt context
>    to migrate irqs in interrupt context so no one encounters this problem
>    in practice.
> 
> We can update MSIs and do a pci read to know when the update has made it
> to a device.  Multi MSI is a disaster but I won't go there.
> 
> In lowest priority delivery mode when the irq is not changing domain but
> just changing the set of possible cpus the interrupt can be delivered to.
> 
> And then of course all of the fun iommus that remap irqs.

Sounds non-trivial.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc

