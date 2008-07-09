Return-Path: <linux-kernel-owner+w=401wt.eu-S1754709AbYGIOTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709AbYGIOTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751196AbYGIOTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:19:35 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61208 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752115AbYGIOTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:19:33 -0400
Date: Wed, 9 Jul 2008 15:17:58 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: linux-next: Tree for July 8: nx6325-related commits
In-Reply-To: <200807090048.48589.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.55.0807091429220.5665@cliff.in.clinika.pl>
References: <20080708192251.3275d283.sfr@canb.auug.org.au> <200807090048.48589.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jul 2008, Rafael J. Wysocki wrote:

> Commits 0b3d81ad4f765513347a04434efc15cbdc4e1c54
> ("x86, ioapic, acpi: add a knob to disable IRQ 0 through I/O APIC") and
> e38502eb8aa82314d5ab0eba45f50e6790dadd88
> ("x86, ioapic, acpi quirk: disable IRQ 0 through I/O APIC for some HP systems")
> don't work on x86_64, because acpi_dmi_table[] depends on __i386__.
> 
> Moreover, if you make them work (by removing that dependency), they hang my
> nx6325 solid early during boot.

 I have build an x86-64 cross-compiler now and can test 64-bit kernels.  
I have tested the patches you have requested to be reverted in a 64-bit
configuration now and discovered the following problems elsewhere:

1. Unlike the 32-bit one, the 64-bit variation of the LVT0 setup code for
   the "8259A Virtual Wire" through the local APIC timer configuration 
   does not fully configure the relevant irq_chip structure.  Instead it 
   relies on the preceding I/O APIC code to have set it up, which does not 
   happen if the I/O APIC variants have not been tried.  I think this is 
   the reason of your hang.

2. As mentioned in the other mail, there is no such entity as ISA IRQ2.  
   The ACPI spec does not make it explicitly clear, but does not preclude 
   it either -- all it says is ISA legacy interrupts are identity mapped 
   by default (subject to overrides), but it does not state whether IRQ2 
   exists or not.  As a result if there is no IRQ0 override, then IRQ2 is 
   normally initialised as an ISA interrupt, which implies an
   edge-triggered line, which is unmasked by default as this is what we do
   for edge-triggered I/O APIC interrupts so as not to miss an edge.

   To the best of my knowledge it is useless, as IRQ2 has not been in use 
   since the PC/AT as back then it was taken by the 8259A cascade 
   interrupt to the slave, with the line posiotion in the slot rerouted to 
   newly-created IRQ9.  No device could thus make use of this line with
   the pair of 8259A chips.  Now in theory INTIN2 of the I/O APIC may be
   usable, but the interrupt of the device wired to it would not be
   available in the PIC mode at all, so I seriously doubt if anybody 
   decided to reuse it for a regular device (anybody please feel free to 
   prove me otherwise).

   However there are two common uses of INTIN2.  One is for IRQ0, with an 
   ACPI interrupt override (or its equivalent in the MP table).  But in 
   this case IRQ2 is gone entirely with INTIN0 left vacant.  The other one 
   is for an 8959A ExtINTA cascade.  In this case IRQ0 goes to INTIN0 and 
   if ACPI is used INTIN2 is assumed to be IRQ2 (there is no override and
   ACPI has no way to report ExtINTA interrupts).  This is where a problem
   happens.

   The problem is INTIN2 is configured as a native APIC interrupt, with a 
   vector assigned and the mask cleared.  And the line may indeed get 
   active and inject interrupts if the master 8959A has its timer 
   interrupt enabled (it might happen for other interrupts too, but they 
   are normally masked in the process of rerouting them to the I/O APIC).  
   There are two cases where it will happen:

   * When the I/O APIC NMI watchdog is enabled.  This is actually a
     misnomer as the watchdog pulses are delivered through the 8259A to 
     the LINT0 inputs of all the local APICs in the system.  The 
     implication is the output of the master 8259A goes high and low 
     repeatedly, signalling interrupts to INTIN2 which is enabled too!

     [The origin of the name is I think for a brief period during the
     development we had a capability in our code to configure the watchdog 
     to use an I/O APIC input; that would be INTIN2 in this scenario.]

   * When the native route of IRQ0 via INTIN0 fails for whatever reason -- 
     as it happens with the system considered here.  In this scenario the
     timer pulse is delivered through the 8259A to LINT0 input of the
     local APIC of the bootstrap processor, quite similarly to how is done
     for the watchdog described above.  The result is, again, INTIN2
     receives these pulses too.  Rafael's system used to escape this 
     scenario, because an incorrect IRQ0 override would occupy INTIN2 and 
     prevent it from being unmasked.

   My conclusion is IRQ2 should be excluded from configuration in all the 
   cases and the current exception for ACPI systems should be lifted.  The 
   reason being the exception not only being useless, but harmful as well.

 I have patches ready to address both issues, but I will test them against
linux-next yet, to avoid any dissynchronisation that may happen similar to
some recent experiences.  I shall post the patches later today.  At that
point 0b3d81ad4f765513347a04434efc15cbdc4e1c54 and
e38502eb8aa82314d5ab0eba45f50e6790dadd88 should be safe to bring back.

  Maciej
