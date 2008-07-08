Return-Path: <linux-kernel-owner+w=401wt.eu-S1755333AbYGHP0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333AbYGHP0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 11:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbYGHPZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 11:25:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40317 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbYGHPZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 11:25:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] acpi: Disable IRQ 0 through I/O APIC for some HP systems
Date: Tue, 8 Jul 2008 17:27:39 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>, Ingo Molnar <mingo@elte.hu>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.55.0807010055070.30785@cliff.in.clinika.pl> <20080708112402.GA2301@alberich.amd.com>
In-Reply-To: <20080708112402.GA2301@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807081727.40605.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 8 of July 2008, Andreas Herrmann wrote:
> On Tue, Jul 01, 2008 at 01:12:06AM +0100, Maciej W. Rozycki wrote:
> > From: Matthew Garrett <mjg59@srcf.ucam.org>
> > 
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
> 
> Why would we trust that BIOS information if the broken BIOS does
> weird things if INT2 of IO APIC is _not_ masked?
> 
> IMHO on those HP systems we should skip the (bogus?) timer override,
> leave IRQ0 -> IOAPIC/INT0 and mask IOAPIC/INT2. Or at least we should
> test that configuration.
> 
> I admit that I have lost track of who has provided which patches,
> which patch does exactly what ((IO|L)A)PIC configuration, and who has
> tested what combinations, and what the results were.
> 
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
> 
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
> (B) ??? who tested this, Rafael

Yes, I tested this.

> -- The stability issues, did they happen with a kernel based on that solution?

Yes, they did.

> (C) ... is my preferred solution. I tested it and I've not seen problems
>     with it (so far) -- maybe it's naive but I think it's the most
>     obvious solution (*)

FWIW, it's my preferred one too.  So far, I haven't seen any problems with this
approach (ie. "acpi_skip_timer_override" plus masking IOAPIC/INT2 in
check_timer()), even with the C1E aware idle routine.

Thanks,
Rafael
