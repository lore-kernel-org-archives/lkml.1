Return-Path: <linux-kernel-owner+w=401wt.eu-S1759712AbZD2BpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712AbZD2BpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZD2BpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:45:06 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52657 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbZD2BpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:45:04 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, mingo@elte.hu, mingo@redhat.com,
       tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org, lcm@us.ibm.com
Subject: Re: [PATCH 3/3] [BUGFIX] x86/x86_64: fix IRQ migration triggered active device IRQ interrruption
References: <20090408210745.GE11159@us.ibm.com>
	<86802c440904081503k545bf7b4n3d44aa3c9d101e0d@mail.gmail.com>
	<20090408230820.GA14412@us.ibm.com>
	<86802c440904102346lfbc85f2w4508bded0572ec58@mail.gmail.com>
	<20090413193717.GB8393@us.ibm.com> <m1bpr0e2au.fsf@fess.ebiederm.org>
	<20090428000536.GA7347@us.ibm.com> <m1bpqhjco7.fsf@fess.ebiederm.org>
	<20090429004451.GA7329@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 28 Apr 2009 18:44:56 -0700
In-Reply-To: <20090429004451.GA7329@us.ibm.com> (Gary Hade's message of "Tue\, 28 Apr 2009 17\:44\:51 -0700")
Message-ID: <m1eivc9qsn.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu, yhlu.kernel@gmail.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Exit with error (see exim mainlog)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> On Tue, Apr 28, 2009 at 03:27:36AM -0700, Eric W. Biederman wrote:
>> Gary Hade <garyhade@us.ibm.com> writes:
>> 
>> > The I/O redirection table register write with the remote
>> > IRR set issue has reproduced on every IBM System x server
>> > I have tried including the x460, x3850, x3550 M2, and x3950 M2.
>> > Nobody has responded to my request to test for the presence
>> > of this issue on non-IBM systems but I think it is pretty safe
>> > to assume that the problem is not IBM specific.
>> 
>> There is no question.  The problem can be verified from a simple
>> code inspection.  It results from the brokenness of the current
>> fixup_irqs.
>> 
>> Your suggested change at the very least is likely to result in
>> dropped irqs at runtime.
>
> Which of the two patches (2/3 or 3/3) could cause the dropped IRQs
> and exactly how can this happen?  If you are possibly referring to
> the concerns about IRQs being migrated in process context during CPU
> offlining, that design pre-dates my patches.

I am referring to some of the side effects of a cpu being migrated in
process context during CPU offlining.  That code has been
fundamentally broken since it was merged in 2005.  Various changes
have changed the odds of how likely it is to fail, and how likely
people are to encounter problems.

The practice of masking an irq while it is actively being used and
we don't have that irq software pending means we will drop that
irq at some point, and that is what the code in irq_64.c:fixup_irqs
does today.

>From what I can tell your patches simply apply more code dubious
code to the fixup_irqs path.

>>                           Something some drivers do not
>> tolerate well.
>> 
>> > After incorporating the fix that avoids writes to the 
>> > the I/O redirection table registers while the remote IRR
>> > bit is set, I have _not_ observed any other issues that 
>> > might be related to the ioapic fragility that you mentioned.
>> > This of course does not prove that you are wrong and that
>> > there is not a need for the changes you are suggesting.
>> > However, until someone has the bandwidth to tackle the difficult
>> > changes that you suggest, I propose that we continue to repair
>> > problems that are found in the current implementation with fixes
>> > such as those that I provided.
>> 
>> The changes I suggest are not difficult.
>> 
>> How is APIC routing setup on your hardware?
>> "Setting APIC routing to flat"  Is what my laptop reports.
>
> Oh, thats easy.  On the IBM x3550 M2 where I have confirmed that
> both bugs exist and where I did the below described testing of
> your patch, the APIC routing is shown as physical flat:
>   "Setting APIC routing to physical flat"
>
>> 
>> My apologies for asking it badly last time.
>
> No problem!  Badly probably depends on the audience and
> I'm probably not a particularily good one. :)
>
>> For understanding what
>> you are testing that is a critical piece of information.
>> 
>> Below is my draft patch that stops cpu shutdown when irqs can not be
>> migrated off.  The code to do that is trivial, and is guaranteed
>> to fix all of your lost irq problems.
>
> This didn't help.  Using 2.6.30-rc3 plus your patch both bugs
> are unfortunately still present.

You could offline the cpus?  I know when I tested it on my
laptop I could not offline the cpus.

If you can offline cpus because your irqs have IRQ_MOVE_PCNT
set, then you must have an iommu and the work that needs to
be done to get things stable on your system is different.

> With respect to the race fixed by patch 2/3 that occurs when
> the device is not very active I have found that a printk in
> __assign_irq_vector() showing -EBUSY returns is a reliable
> indicator of when things go bad and the CPU handling the IRQ
> is offlined without the affinity being migrated to an online CPU.
> The following was logged during the failure. 
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY
>   __assign_irq_vector: XXX irq=16 returning -EBUSY

I have not been looking closely at your reported bugs.  So
far everything seems to be related to the totally broken moving
irqs in process context code in fixup_irqs, and making the
races smaller does not interest me when it looks like we can
make the races go away.

> I am not sure if I totally understand what your new
> cleanup_pending_irqs() is doing but I *think* it is
> only broadcasting an IPI when the same IRQ is being
> handled on the IRQ move destination CPU.  

My new cleanup_pending_irqs() as written still has a number of bugs,
it is more of a placeholder than solid tested code at the moment.

cleanup_pending_irqs() is supposed to happen after a synchronous
irq migration (so no irqs should be hitting the cpu) and
as such it should be possible to cleanup any irq pending state
on the current cpu, and if an irq is pending to simply redirect
it to some other cpu that still has the irq active.

cleanup_pending_irqs() currently does not have the code to ack the
irqs that are pending in the irr, which could have a correctness
consequence with the hardware.  Beyond that it is just a matter of
reflecting the irq to a different cpu (so we don't miss one).

> If this understanding
> is correct, I don't think it covers the case where the device
> is generating IRQs at such an extremely slow rate that
> absolutely none are received between the time that the
> move_in_progress flag was set to 1 and the IRQ move
> destination CPU is offlined.  I actually played around with
> broadcasting an IPI every time the move_in_progress flag
> was set to 1 which repaired the problem but did not feel
> like a good solution especially after I discovered that there
> was no need to even set move_in_progress to 1 if all CPUs in
> the old domain were going to be offline when the cleanup code
> was run  i.e. cleanup code does nothing when it eventually runs.

That case should be handled simply by denying cpu down event.
And that code was working when I tested it on my laptop.

I am wondering how you managed to get the cpu to go down.

> I then incorporated my fix (patch 2/3) for the above issue
> plus a printk in __target_IO_APIC_irq() to display values
> written to the I/O redirection table register for the IRQ
> of interest and tried again.  With a low incoming IRQ rate
> the above problem no longer reproduced but after increasing
> the incoming IRQ rate I started seeing an increasing number
> of writes to the I/O redirection table register while the
> remote IRR bit was set (see below) before IRQs from the
> device were no longer being seen by the kernel.
>
>> 
>> Beyond that everything I am proposing is very localized.
>> 
>> You have proposed making interrupts behave like they can be migrated
>> in process context when in fact extensive testing over the years have
>> shown in the general case interrupts can only be migrated from the irq
>> handler, from a location where the irqs are naturally disabled.
>
> To be clear, IRQs were already being migrated in process
> context during CPU offlining before I even looked at the code.
> This was not my doing.  I believe it has been this way for
> quite some time. 

Yep.  It doesn't mean it has ever been correct, and I am trying
to development in ways so that we only take down a cpu when it
is possible to migrate all of it's irqs in process context.

>> I propose detecting thpe cases that we know are safe to migrate in
>> process context, aka logical deliver with less than 8 cpus aka "flat"
>> routing mode and modifying the code so that those work in process
>> context and simply deny cpu hotplug in all of the rest of the cases.
>
> Humm, are you suggesting that CPU offlining/onlining would not
> be possible at all on systems with >8 logical CPUs (i.e. most
> of our systems) or would this just force users to separately
> migrate IRQ affinities away from a CPU (e.g. by shutting down
> the irqbalance daemon and writing to /proc/irq/<irq>/smp_affinity)
> before attempting to offline it?

A separate migration, for those hard to handle irqs.

The newest systems have iommus that irqs go through or are using MSIs
for the important irqs, and as such can be migrated in process
context.  So this is not a restriction for future systems.

Eric
