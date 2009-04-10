Return-Path: <linux-kernel-owner+w=401wt.eu-S1761976AbZDJWC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761976AbZDJWC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 18:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756132AbZDJWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 18:02:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:35584 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbZDJWCR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 18:02:17 -0400
To: Gary Hade <garyhade@us.ibm.com>
Cc: mingo@elte.hu, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       x86@kernel.org, linux-kernel@vger.kernel.org, lcm@us.ibm.com
References: <20090408210735.GD11159@us.ibm.com>
	<m1r601fg9l.fsf@fess.ebiederm.org> <20090410200919.GA7242@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 10 Apr 2009 15:02:07 -0700
In-Reply-To: <20090410200919.GA7242@us.ibm.com> (Gary Hade's message of "Fri\, 10 Apr 2009 13\:09\:19 -0700")
Message-ID: <m1tz4wcgm8.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: garyhade@us.ibm.com, lcm@us.ibm.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Gary Hade <garyhade@us.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH 2/3] [BUGFIX] x86/x86_64: fix CPU offlining triggered inactive device IRQ interrruption
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade <garyhade@us.ibm.com> writes:

> On Thu, Apr 09, 2009 at 06:29:10PM -0700, Eric W. Biederman wrote:
>> Gary Hade <garyhade@us.ibm.com> writes:
>> 
>> > Impact: Eliminates a race that can leave the system in an
>> >         unusable state
>> >
>> > During rapid offlining of multiple CPUs there is a chance
>> > that an IRQ affinity move destination CPU will be offlined
>> > before the IRQ affinity move initiated during the offlining
>> > of a previous CPU completes.  This can happen when the device
>> > is not very active and thus fails to generate the IRQ that is
>> > needed to complete the IRQ affinity move before the move
>> > destination CPU is offlined.  When this happens there is an
>> > -EBUSY return from __assign_irq_vector() during the offlining
>> > of the IRQ move destination CPU which prevents initiation of
>> > a new IRQ affinity move operation to an online CPU.  This
>> > leaves the IRQ affinity set to an offlined CPU.
>> >
>> > I have been able to reproduce the problem on some of our
>> > systems using the following script.  When the system is idle
>> > the problem often reproduces during the first CPU offlining
>> > sequence.
>> 
>> You appear to be focusing on the IBM x460 and x3835.
>
> True.  I have also observed IRQ interruptions on an IBM x3950 M2
> which I believe, but am not certain, were due to the other
> "I/O redirection table register write with Remote IRR bit set"
> caused problem.
>
> I intend to do more testing on the x3950 M2 and other
> IBM System x servers but I unfortunately do not currently
> have access to any Intel based non-IBM MP servers.  I was
> hoping that my testing request might at least get some
> others interested in running the simple test script on their
> systems and reporting their results.  Have you perhaps tried
> the test on any of the Intel based MP systems that you have
> access to?
>
>> Can you describe
>> what kind of interrupt setup you are running.
>
> Being somewhat of a ioapic neophyte I am not exactly sure
> what you are asking for here.  This is ioapic information
> logged during boot if that helps at all.
> x3850:
>     ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
>     IOAPIC[0]: apic_id 15, version 0, address 0xfec00000, GSI 0-35
>     ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[36])
>     IOAPIC[1]: apic_id 14, version 0, address 0xfec01000, GSI 36-71
> x460:
>     ACPI: IOAPIC (id[0x0f] address[0xfec00000] gsi_base[0])
>     IOAPIC[0]: apic_id 15, version 17, address 0xfec00000, GSI 0-35
>     ACPI: IOAPIC (id[0x0e] address[0xfec01000] gsi_base[36])
>     IOAPIC[1]: apic_id 14, version 17, address 0xfec01000, GSI 36-71
>     ACPI: IOAPIC (id[0x0d] address[0xfec02000] gsi_base[72])
>     IOAPIC[2]: apic_id 13, version 17, address 0xfec02000, GSI 72-107
>     ACPI: IOAPIC (id[0x0c] address[0xfec03000] gsi_base[108])
>     IOAPIC[3]: apic_id 12, version 17, address 0xfec03000, GSI 108-143

Sorry.  My real question is which mode you are running the ioapics in.


>> You may be the first person to actually hit the problems with cpu offlining
>> and irq migration that have theoretically been present for a long.
>
> Your "Safely cleanup an irq after moving it" changes have been
> present in mainline for quite some time so I have been thinking
> about this as well.
>
> I can certainly understand why it may not be very likely
> for users to see the "I/O redirection table register write
> with Remote IRR bit set" caused problem.  It has actually
> been fairly difficult to reproduce.  I very much doubt that
> there are many users out there that would be continuously offlining
> and onlining all the offlineable CPUs from a script or program on
> a heavily loaded system.  IMO, this would _not_ be a very common
> useage scenario.  The test script that I provided usually performs
> many CPU offline/online iterations before the problem is triggered.
> A much more likely useage scenario, for which there is already code
> in ack_apic_level() to avoid the problem, would be IRQ affinity
> adjustments requested from user level (e.g. by the irqbalance daemon)
> on a very active system.
>
> It is less clear to me why users have not been reporting the
> idle system race but I suspect that
>   - script or program driven offlining of multiple CPUs
>     may not be very common
>   - the actual affinity on an idle system is usually set to
>     cpu0 which is always online
>
> I am glad you are looking at this since I know it involves code
> that you should be quite familiar with.  Thanks!

The class of irq and the mode in which we run it make a bit difference.

MSIs and machines with iommus that remap irqs we should be able to
migrate irqs safely at any time.

Also lowest priority delivery mode when all cpus are setup on the same
vector to receive an irq.  Changing it's affinity should be safe.
This works for up to 8 cpus.  And I expect is the common case.

The rest of the case when we change the vector number short of turning
off the devices generating the interrupts (and thus stopping them at
the source) I do not know of a safe way to disable interrupts.

The only reason I did not make the irq migration at cpu shutdown time
depend on CONFIG_BROKEN was that it is by the suspend code on laptops.

Alternatively if you have ioapics that support having their irqs
acknowledged with a register I like ia64 has.  I think there are some
additional options.

So depending on what hardware you have it might be possible to implement
this safely.

It looks like some additional bugs have slipped in since last I looked.

set_irq_affinity does this:
ifdef CONFIG_GENERIC_PENDING_IRQ
	if (desc->status & IRQ_MOVE_PCNTXT || desc->status & IRQ_DISABLED) {
		cpumask_copy(desc->affinity, cpumask);
		desc->chip->set_affinity(irq, cpumask);
	} else {
		desc->status |= IRQ_MOVE_PENDING;
		cpumask_copy(desc->pending_mask, cpumask);
	}
#else

That IRQ_DISABLED case is a software state and as such it has nothing to
do with how safe it is to move an irq in process context.

Do any of your device drivers call irq_disable?

Eric
