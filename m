Return-Path: <linux-kernel-owner+w=401wt.eu-S1764252AbZFOUuK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764252AbZFOUuK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 16:50:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754424AbZFOUt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 16:49:59 -0400
Received: from claw.goop.org ([74.207.240.146]:40375 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534AbZFOUt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 16:49:58 -0400
Message-ID: <4A36B3EC.7010004@goop.org>
Date: Mon, 15 Jun 2009 13:49:48 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: [PATCH RFC] x86/acpi: don't ignore I/O APICs just because there's
 no local APIC
References: <4A329CF8.4050502@goop.org> <m1d499yyug.fsf@fess.ebiederm.org>	<4A35ACB3.9040501@goop.org> <m1k53dbwo2.fsf@fess.ebiederm.org>
In-Reply-To: <m1k53dbwo2.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/09 03:47, Eric W. Biederman wrote:
> For code reuse and maintainability that is a horrible separation of
> responsibility.  Things looks similar to the existing cases until you
> get up close and you discover all of the fundamental assumptions are
> different so none of the existing code actually works unmodified.
>    

The I/O APIC code is used exactly as normal, routing from 
device->pin->vector; the whole interrupt emission path is unchanged.

The local APIC code doesn't get used at all, because we have a different 
interrupt catcher operating at the irq_chip level.

In terms of system architecture its a reasonable place to make the 
split; the local APICs and I/O APICs are distinct entities which 
communicate via fairly well-defined path.  Xen puts the 
hypervisor/control domain split at the same place.  This is mainly 
because Xen itself cares about managing CPUs (and memory), but doesn't 
really care about the rest of the system hardware much - it leaves that 
up to the control domain.

> The only clean way I can see to handle this is to make xen dom0 it's own
> weird separate subarch that does all of the table parsing of the
> firmware tables in completely separate code.  Then once we have something
> that works factoring out the commonalities into a helper library for
> better long term maintenance.
>    
That seems like overkill.  We can get things working under Xen with 3 
changes:

   1. make sure I/O APICs are discovered via ACPI properly (or MPTABLE
      if ACPI isn't present)
   2. get Xen to allocate a vector and bind that vector to an event channel
   3. make sure I/O APIC register writes get to the appropriate I/O APIC
      in hardware (the normal pin->vector routing)

These points already have fairly well-defined interfaces; there are no 
subtle interactions with the core of the APIC code.

This patch achieves the first of these, in a fairly minimal way.  I'm 
still investigating better ways of achieving 2 & 3.

> As it stands right now what Xen wants and what we need to do for normal
> hardware are radically different, to the point of painful.  Things like
> irq migration, and cpu hotplug require completely different algorithms.
>    

The control domain, being a virtual machine, has no access or visibility 
of physical CPUs in the system; all its CPUs are virtual (this is why a 
"local APIC" doesn't make much sense for it, since they're an inherent 
property of a physical CPU, and are not virtualized).

The hypervisor is responsible for all management of physical CPUs, and 
is therefore responsible for physical-CPU things like hotplug and 
interrupt migration.  The kernel doesn't need new algorithms to handle 
these because it simply doesn't know or care about them.

As far as the kernel is concerned, the interrupts look like events on 
event channels, like IPIs, timers, etc, and can be handled accordingly.  
The irq_chip machinery is already in place for them.

> I think Xen dom0 has picked the wrong abstraction for this one.  There
> seems to be no gain and a lot of pain asking the slave kernel to
> program the ioapics for it, when Xen presents a wildly different
> abstraction at the cpu level.
>    

Well, the bulk of the code is already present.  We avoid the local APIC 
part of the kernel completely, by installing a new irq_chip to handle 
incoming interrupts and deliver them into the core interrupt handling 
accordingly.  The control domain patches simply add the ability to bind 
a hardware-originated interrupt to an event channel to be delivered via 
this mechanism.

And, as Xen contains no device drivers or real hardware knowledge of 
busses, interrupt routing, etc, it falls to the control domain to work 
out those aspects.  The I/O APIC side of the setup is the same as it 
would be in the native case (program a vector corresponding to a pin on 
an I/O APIC).

> If what xen was provided looked like an ioapic semantically I would
> suggest setting cpu_has_apic in a different fashion.

cpu_has_apic has the specific meaning of "this CPU has a local APIC".  
It doesn't say anything about the presence or absence of I/O APICs; 
conflating the two notions doesn't seem like a good idea.  I'm clearing 
cpu_has_apic to indicate this specific fact: the CPU has no usable local 
APIC, and there's no point pretending it does - but that doesn't mean 
the I/O APICs aren't functional.

>    We already have two local apic variants after all so a 3rd should not be too nasty.
>    
We currently avoid any need to have, or pretend to have, a local APIC by 
taking control of the interrupt delivery subsystem at the irq_chip 
level.  I don't think there's much to be gained by adding a Xen-specific 
lapic abstraction for this case.

> Except the Xen appears to have totally moved the responsibility around
> in ways that over constrain the problem by taking, making the
> existing code useless.
>    
I don't think that's true at at all.  The split is along hardware lines, 
and so puts the same constraints on kernel development that the hardware 
does.

> Please put the Xen dom0 insanity somewhere off in a corner where the rest
> of x86 can ignore it.
>    

Yep, trying to.

     J
