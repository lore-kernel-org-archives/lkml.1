Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYGHOvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYGHOvh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 10:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753452AbYGHOv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 10:51:28 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64953 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751580AbYGHOv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 10:51:27 -0400
Date: Tue, 8 Jul 2008 15:39:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
cc: Ingo Molnar <mingo@elte.hu>, Matthew Garrett <mjg59@srcf.ucam.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP
 systems
In-Reply-To: <20080708112402.GA2301@alberich.amd.com>
Message-ID: <Pine.LNX.4.55.0807081317200.26935@cliff.in.clinika.pl>
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl>
 <20080708112402.GA2301@alberich.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2008, Andreas Herrmann wrote:

> >  Some HP laptops have a problem with their DSDT reporting as
> > HP/SB400/10000, which includes some code which overrides all temperature
> > trip points to 16C if the INTIN2 input of the I/O APIC is enabled.  This
> > input is incorrectly designated the ISA IRQ 0 via an interrupt source
> > override even though it is wired to the output of the master 8259A and
> > INTIN0 is not connected at all.  So far two models have been identified, 
> > namely nx6125 and nx6325.
> 
> Out of sheer curiosity. What makes you think that IRQ0 is not
> connected to INT0 of IO APIC? The IRQ0 pin2 override?

 The test I prepared a couple of weeks ago which Rafael ran for me.  The 
test forcibly rerouted IRQ0 to INTIN0, but the timer did not work with 
that setup.

> Why would we trust that BIOS information if the broken BIOS does
> weird things if INT2 of IO APIC is _not_ masked?

 This is why I prepared the workaround to ignore BIOS IRQ0 configuration 
triggered by DMI matching proposed by Matthew.

> IMHO on those HP systems we should skip the (bogus?) timer override,
> leave IRQ0 -> IOAPIC/INT0 and mask IOAPIC/INT2. Or at least we should
> test that configuration.

 Unfortunately it did not work for Rafael's box and diagnostic messages 
have been quiesced in the 64-bit variation of code so bootstrap logs 
archived throughout the Internet could not be used as a reference.

> I admit that I have lost track of who has provided which patches,
> which patch does exactly what ((IO|L)A)PIC configuration, and who has
> tested what combinations, and what the results were.

 I can be blamed for the vast majority.  If you are unsure what does what,
then feel free to ask me.

> So I've just done the following (based on x86/master as of yesterday):
> 
> Booting an HP nx6325
> 
> (1)  with "acpi_skip_timer_override" to avoid configuration
>      of IOAPIC/INT2 and to avoid masking of IOAPIC/INT0.
> 
>   plus
> 
> (2) adding (hardcoded in check_timer()) some code to explicitly mask
>     IOAPIC/INT2 to quiesce the fan (work around the DSDT issue).

 Now that you mentioned (2) a sudden insight made me realise in the
absence of an overlapping override we register ISA IRQ2 as an
edge-triggered I/O APIC interrupt, which means its input will be
implicitly unmasked.  But despite the ACPI spec does not make it
explicitly clear, there is no such thing as ISA IRQ2 -- what used to be
IRQ2 up to PC/XT got remapped to IRQ9 when the IR2 line of the 8259A was
reused as a cascade to the slave and no device since has ever been able to
make use of IRQ2.  Therefore I think we should actually not register this
IRQ2 thingy at all under any circumstances.  I'll send a patch.

> With that setup my test box boots w/o problems (no fan noise, no
> throttling, no stablity problems so far). Here the relevant dmesg
> parts:
> 
> Command line: root=/dev/sda2 video=radeonfb:noaccel debug apic=debug acpi_skip_timer_override
>   ...
> IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 
>   ...
> ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> ACPI: BIOS IRQ0 pin2 override ignored.
>   ...
> using C1E aware idle routine
>   ...
> init IO_APIC IRQs
> IOAPIC[0]: Set routing entry (2-0 -> 0x30 -> IRQ 0 Mode:0 Active:0)
> IOAPIC[0]: Set routing entry (2-1 -> 0x31 -> IRQ 1 Mode:0 Active:0)
> IOAPIC[0]: Set routing entry (2-2 -> 0x32 -> IRQ 2 Mode:0 Active:0)
>   ...
> IO-APIC (apicid-pin) 2-16, 2-17, 2-18, 2-19, 2-20 not connected.
> IOAPIC[0]: Set routing entry (2-21 -> 0x49 -> IRQ 21 Mode:1 Active:1)
> IO-APIC (apicid-pin) 2-22, 2-23 not connected.
> ..TIMER: vector=0x30 apic1=0 pin1=0 apic2=-1 pin2=-1
> CPU0: AMD Turion(tm) 64 X2 Mobile Technology TL-60 stepping 02
> Using local APIC timer interrupts.
>   ...
> IO APIC #2......
>   ...
> NR Dst Mask Trig IRR Pol Stat Dmod Deli Vect:   
> 00 003 0    0    0   0   0    1    1    30
> 01 003 0    0    0   0   0    1    1    31
> 02 003 1    0    0   0   0    1    1    32
> 
> 
> I think we have 3 alternatives to setup timer interrupt on those machines
> 
> (A) Setup timer as Virtual Wire IRQ.
>     (that's the way the old code used to configure it, e.g. in 2.6.25)
> (B) The current approach to setup timer as ExtINT.
> (C) Use IOAPIC/INT0.
> 
> Shouldn't be that hard to find the best solution here:
> 
> (A) proved to work (and even "accidentially" masked IOAPIC/INT2 which
>     avoided the DSDT problem)
> 
> (B) ??? who tested this, Rafael -- The stability issues, did they happen
>     with a kernel based on that solution?
> 
> (C) ... is my preferred solution. I tested it and I've not seen problems
>     with it (so far) -- maybe it's naive but I think it's the most
>     obvious solution (*)

 I am assuming by "Virtual Wire IRQ" you mean a setup we are referring to
as "8259A Virtual Wire" (without this additional qualifier the term is 
synonymous to ExtINTA).

 Given (C) did not work a workaround has been prepared to implement (A).  
As it does DMI ID matching and "knows" for this system (C) would not work 
I decided there is no point in trying such a configuration.

 Now you say your machine actually supports (C), which makes me wonder why 
Rafael's does not, hmm...

> (*) BTW, default for SB400 is to route IRQ0 to IOAPIC/INT0 and output
>     of PIC to IOAPIC/INT2. On my test box this wasn't configured

 Well, this is a piece of information I could not know.  Documentation for 
the SB400 is not publicly available.  I asked whether anybody could answer 
how this piece of circuitry has been designed in the chip and you are the 
first to provide some kind of an answer.

>     differently. Thus I don't understand why the BIOS provided an
>     IRQ0/INT2 override at all.

 One or more of the following:

1. Because the 8254 is not in fact routed to INTIN0 (as seen with the
   test).

2. Because almost everything else requires such an override and it was 
   left in place in the code base by mistake/misunderstanding/etc.

 OK, to recap: given what you have written, I think we should refrain from
registering IRQ2 as suggested above and then it will be safe to ignore the
interrupt override for the two systems affected based on a DMI quirk,
which means INTIN0 will be tried first, which may or may not work.  Of
course if it does not, then we have to quiesce the warning about the BIOS
having provided us with incorrect interrupt routing information, because
we ignored what it told us. ;)

  Maciej
