Return-Path: <linux-kernel-owner+w=401wt.eu-S935816AbZFOV6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935816AbZFOV6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 17:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934880AbZFOV6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 17:58:44 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:55890 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934688AbZFOV6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 17:58:43 -0400
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>
	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>
	<4A36B3EC.7010004@goop.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Mon, 15 Jun 2009 14:58:38 -0700
In-Reply-To: <4A36B3EC.7010004@goop.org> (Jeremy Fitzhardinge's message of "Mon\, 15 Jun 2009 13\:49\:48 -0700")
Message-ID: <m1fxe117n5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: jeremy@goop.org, xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, tglx@linutronix.de, mingo@redhat.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jeremy Fitzhardinge <jeremy@goop.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's no local APIC
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge <jeremy@goop.org> writes:

> On 06/15/09 03:47, Eric W. Biederman wrote:
>> For code reuse and maintainability that is a horrible separation of
>> responsibility.  Things looks similar to the existing cases until you
>> get up close and you discover all of the fundamental assumptions are
>> different so none of the existing code actually works unmodified.
>>    
>
> The I/O APIC code is used exactly as normal, routing from device->pin->vector;
> the whole interrupt emission path is unchanged.

But the algorithms that set it up are now useless.  Which implies most of the
current control logic is now useless.

> The local APIC code doesn't get used at all, because we have a different
> interrupt catcher operating at the irq_chip level.

Sure.  Which pretty much implies that all of io_apic.c and the setting up
of the interrupt controllers has to be replaced as well.

> In terms of system architecture its a reasonable place to make the split; the
> local APICs and I/O APICs are distinct entities which communicate via fairly
> well-defined path.  Xen puts the hypervisor/control domain split at the same
> place.  This is mainly because Xen itself cares about managing CPUs (and
> memory), but doesn't really care about the rest of the system hardware much - it
> leaves that up to the control domain.

Xen doesn't want to deal so it leaves the rest for us.  Making it so neither
kernel has full control of the irqs.  Neither has enough control to flexibly
set things up.

>> The only clean way I can see to handle this is to make xen dom0 it's own
>> weird separate subarch that does all of the table parsing of the
>> firmware tables in completely separate code.  Then once we have something
>> that works factoring out the commonalities into a helper library for
>> better long term maintenance.
>>    
> That seems like overkill.  We can get things working under Xen with 3 changes:

All of the subtle assumptions sound like the come out differently.  Which means
you can very easily start down the road of just reusing small bits and then
you find so many assumptions are different you have to scrap/replace or gunk
up with if (xen) tests.

>   1. make sure I/O APICs are discovered via ACPI properly (or MPTABLE
>      if ACPI isn't present)
>   2. get Xen to allocate a vector and bind that vector to an event channel

The x86 code doesn't allocate vectors.  It allocates a vector that is valid
on a single cpu, or a vector that is valid on all cpus.  Vectors are managed
as a per cpu resource and that is ultimately required to scale the number
of interrupts supported.

If Xen does not manage vectors as a per cpu resource.  That fundamentally
breaks one of the assumptions in the code.

>   3. make sure I/O APIC register writes get to the appropriate I/O APIC
>      in hardware (the normal pin->vector routing)
>
> These points already have fairly well-defined interfaces; there are no subtle
> interactions with the core of the APIC code.
>
> This patch achieves the first of these, in a fairly minimal way.  I'm still
> investigating better ways of achieving 2 & 3.

As I understand Xen so far I still disagree.

>> As it stands right now what Xen wants and what we need to do for normal
>> hardware are radically different, to the point of painful.  Things like
>> irq migration, and cpu hotplug require completely different algorithms.
>>    
>
> The control domain, being a virtual machine, has no access or visibility of
> physical CPUs in the system; all its CPUs are virtual (this is why a "local
> APIC" doesn't make much sense for it, since they're an inherent property of a
> physical CPU, and are not virtualized).
>
> The hypervisor is responsible for all management of physical CPUs, and is
> therefore responsible for physical-CPU things like hotplug and interrupt
> migration.  The kernel doesn't need new algorithms to handle these because it
> simply doesn't know or care about them.

So Xen calls the linux kernel when it wants to migrate an irq from one cpu
to another?

If Xen is calling us back when it wants to migrate an irq from one cpu to another
that implies we need knowledge of irqs.

> As far as the kernel is concerned, the interrupts look like events on event
> channels, like IPIs, timers, etc, and can be handled accordingly.  The irq_chip
> machinery is already in place for them.

If the kernel is responsible for programming the ioapics it definitely cares
about migration, and cpu hotplug.  All of those require reprogramming the
ioapics.

>> I think Xen dom0 has picked the wrong abstraction for this one.  There
>> seems to be no gain and a lot of pain asking the slave kernel to
>> program the ioapics for it, when Xen presents a wildly different
>> abstraction at the cpu level.
>>    
>
> Well, the bulk of the code is already present.  We avoid the local APIC part of
> the kernel completely, by installing a new irq_chip to handle incoming
> interrupts and deliver them into the core interrupt handling accordingly.  The
> control domain patches simply add the ability to bind a hardware-originated
> interrupt to an event channel to be delivered via this mechanism.
>
> And, as Xen contains no device drivers or real hardware knowledge of busses,
> interrupt routing, etc, it falls to the control domain to work out those
> aspects.  The I/O APIC side of the setup is the same as it would be in the
> native case (program a vector corresponding to a pin on an I/O APIC).

There is a lot more going on than that.  You need to know logical vs physical.
How many bits of cpu id you have.  

Which mode you program the ioapics in logical vs physical (and the variants)
of those is directly tied with how many cpus you have, and how that box
is arranged.

>> If what xen was provided looked like an ioapic semantically I would
>> suggest setting cpu_has_apic in a different fashion.
>
> cpu_has_apic has the specific meaning of "this CPU has a local APIC".  It
> doesn't say anything about the presence or absence of I/O APICs; conflating the
> two notions doesn't seem like a good idea.  I'm clearing cpu_has_apic to
> indicate this specific fact: the CPU has no usable local APIC, and there's no
> point pretending it does - but that doesn't mean the I/O APICs aren't
> functional.

If you don't have a local apic you can't receive apic messages.

The Xen ``whacky apic'' model is different.  

>>    We already have two local apic variants after all so a 3rd should not be too nasty.
>>    
> We currently avoid any need to have, or pretend to have, a local APIC by taking
> control of the interrupt delivery subsystem at the irq_chip level.  I don't
> think there's much to be gained by adding a Xen-specific lapic abstraction for
> this case.

To work with Xen dom0 we need to double the number of ioapic routing models.  This
is code that is tricky enough we are still struggling to get clean and sane without
Xen complications that violate some of the most basic assumptions in the code.

>> Except the Xen appears to have totally moved the responsibility around
>> in ways that over constrain the problem by taking, making the
>> existing code useless.
>>    
> I don't think that's true at at all.  The split is along hardware lines, and so
> puts the same constraints on kernel development that the hardware does.

The split is right in the middle of the irq handling.  It is happening in the middle
of deep architecture code.  So far voyager sounds easier to fit into the current
model then Xen.

>> Please put the Xen dom0 insanity somewhere off in a corner where the rest
>> of x86 can ignore it.
>>    
>
> Yep, trying to.

Then please don't hack up the normal x86 irq handling code.

Eric
