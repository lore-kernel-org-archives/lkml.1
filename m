Return-Path: <linux-kernel-owner+w=401wt.eu-S1756909AbYGJLwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756909AbYGJLwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 07:52:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYGJLwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 07:52:15 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:10677 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbYGJLwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 07:52:13 -0400
X-BigFish: VPS-62(z3745Vz1454M1b0bM1432R98dR7efV1805M3117Kzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0K3SGYK-01-FMC-01
Date: Thu, 10 Jul 2008 13:51:02 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: linux-next: Tree for July 8: nx6325-related commits
Message-ID: <20080710115102.GB2301@alberich.amd.com>
References: <20080708192251.3275d283.sfr@canb.auug.org.au> <200807090048.48589.rjw@sisk.pl> <Pine.LNX.4.55.0807091429220.5665@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.55.0807091429220.5665@cliff.in.clinika.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 10 Jul 2008 11:51:06.0875 (UTC) FILETIME=[3CCD74B0:01C8E283]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 09, 2008 at 03:17:58PM +0100, Maciej W. Rozycki wrote:
> On Wed, 9 Jul 2008, Rafael J. Wysocki wrote:
> 
> > Commits 0b3d81ad4f765513347a04434efc15cbdc4e1c54
> > ("x86, ioapic, acpi: add a knob to disable IRQ 0 through I/O APIC") and
> > e38502eb8aa82314d5ab0eba45f50e6790dadd88
> > ("x86, ioapic, acpi quirk: disable IRQ 0 through I/O APIC for some HP systems")
> > don't work on x86_64, because acpi_dmi_table[] depends on __i386__.
> > 
> > Moreover, if you make them work (by removing that dependency), they hang my
> > nx6325 solid early during boot.
> 
>  I have build an x86-64 cross-compiler now and can test 64-bit kernels.  
> I have tested the patches you have requested to be reverted in a 64-bit
> configuration now and discovered the following problems elsewhere:
> 
> 1. Unlike the 32-bit one, the 64-bit variation of the LVT0 setup code for
>    the "8259A Virtual Wire" through the local APIC timer configuration 
>    does not fully configure the relevant irq_chip structure.  Instead it 
>    relies on the preceding I/O APIC code to have set it up, which does not 
>    happen if the I/O APIC variants have not been tried.  I think this is 
>    the reason of your hang.

FYI, I looked further into the missing interrupt problem (testing on
64-bit, with Rafael's patch version and "Virtual Wire Mode" for the
timer IRQ).
Just before the weird behaviour I have two log entries:

 APIC error on CPU1: 00(40)
 APIC error on CPU0: 00(40)

AFAIK 0x40 is "Illegal Register Address" error:

"Illegal Register Address (IRA)Bit 7.  The IRA bit when set to 1
indicates that an access to an unimplemented register location within
the local APIC register range (APIC Base Address + 4 Kbytes) was
attempted."

I've tried to track down who is responsible for that access. But I
didn't find the offender yet. Maybe it's Linux or some SMM stuff?
Don't know.

Right after those messages no interrupts from PIT/PIC (which should be
"virtual wired" to LVT0 of CPU0) are received anymore. I dumped PIC
and local APIC settings but I did not find any suspicious things here.

> 2. As mentioned in the other mail, there is no such entity as ISA IRQ2.  
>    The ACPI spec does not make it explicitly clear, but does not preclude 
>    it either -- all it says is ISA legacy interrupts are identity mapped 
>    by default (subject to overrides), but it does not state whether IRQ2 
>    exists or not.  As a result if there is no IRQ0 override, then IRQ2 is 
>    normally initialised as an ISA interrupt, which implies an
>    edge-triggered line, which is unmasked by default as this is what we do
>    for edge-triggered I/O APIC interrupts so as not to miss an edge.
> 
>    To the best of my knowledge it is useless, as IRQ2 has not been in use 
>    since the PC/AT as back then it was taken by the 8259A cascade 
>    interrupt to the slave, with the line posiotion in the slot rerouted to 
>    newly-created IRQ9.  No device could thus make use of this line with
>    the pair of 8259A chips.  Now in theory INTIN2 of the I/O APIC may be
>    usable, but the interrupt of the device wired to it would not be
>    available in the PIC mode at all, so I seriously doubt if anybody 
>    decided to reuse it for a regular device (anybody please feel free to 
>    prove me otherwise).
> 
>    However there are two common uses of INTIN2.  One is for IRQ0, with an 
>    ACPI interrupt override (or its equivalent in the MP table).  But in 
>    this case IRQ2 is gone entirely with INTIN0 left vacant.  The other one 
>    is for an 8959A ExtINTA cascade.  In this case IRQ0 goes to INTIN0 and 
>    if ACPI is used INTIN2 is assumed to be IRQ2 (there is no override and
>    ACPI has no way to report ExtINTA interrupts).  This is where a problem
>    happens.
> 
>    The problem is INTIN2 is configured as a native APIC interrupt, with a 
>    vector assigned and the mask cleared.  And the line may indeed get 
>    active and inject interrupts if the master 8959A has its timer 
>    interrupt enabled (it might happen for other interrupts too, but they 
>    are normally masked in the process of rerouting them to the I/O APIC).  
>    There are two cases where it will happen:
> 
>    * When the I/O APIC NMI watchdog is enabled.  This is actually a
>      misnomer as the watchdog pulses are delivered through the 8259A to 
>      the LINT0 inputs of all the local APICs in the system.  The 
>      implication is the output of the master 8259A goes high and low 
>      repeatedly, signalling interrupts to INTIN2 which is enabled too!
> 
>      [The origin of the name is I think for a brief period during the
>      development we had a capability in our code to configure the watchdog 
>      to use an I/O APIC input; that would be INTIN2 in this scenario.]
> 
>    * When the native route of IRQ0 via INTIN0 fails for whatever reason -- 
>      as it happens with the system considered here.  In this scenario the
>      timer pulse is delivered through the 8259A to LINT0 input of the
>      local APIC of the bootstrap processor, quite similarly to how is done
>      for the watchdog described above.  The result is, again, INTIN2
>      receives these pulses too.  Rafael's system used to escape this 
>      scenario, because an incorrect IRQ0 override would occupy INTIN2 and 
>      prevent it from being unmasked.
> 
>    My conclusion is IRQ2 should be excluded from configuration in all the 
>    cases and the current exception for ACPI systems should be lifted.  The 
>    reason being the exception not only being useless, but harmful as well.

Before I reread all the above -- here are just some early comments
regarding the IRQ0 override:

* HPET timer 0 in legacy mode should be connected to INTIN2.

* To configure this at least some chipsets are able to "swap" INTIN0
  and INTIN2:

  Say default is IRQ0 -> INTIN0 and output of PIC -> INTIN2. Doing
  "some chipset magic" it is possible to swap it such that IRQ0 ->
  INTIN2 and output of PIC -> INTIN0.

  I might be wrong but maybe that "feature" was invented for HPET
  usage in legacy mode -- to deliver timer interrupts to INTIN2.
  IMHO for this scenario the IRQ0/INTIN2 override exists.

To complete the confusion, the nx6325 box that I am testing on
advertises an IRQ0/INTIN2 override but INTIN0/INTIN2 are _not_
swapped ... That's the point where I think the BIOS of the box is
totally broken or I just missed some real important bit. ;-(


Regards,

Andreas


