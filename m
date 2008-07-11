Return-Path: <linux-kernel-owner+w=401wt.eu-S1757008AbYGKSic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008AbYGKSic (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754542AbYGKShq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:37:46 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64601 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754309AbYGKSho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:37:44 -0400
Date: Fri, 11 Jul 2008 19:35:23 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] x86: I/O APIC: Never configure IRQ2
Message-ID: <Pine.LNX.4.55.0807111926310.31940@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 There is no such entity as ISA IRQ2.  The ACPI spec does not make it
explicitly clear, but does not preclude it either -- all it says is ISA
legacy interrupts are identity mapped by default (subject to overrides),
but it does not state whether IRQ2 exists or not.  As a result if there is
no IRQ0 override, then IRQ2 is normally initialised as an ISA interrupt,
which implies an edge-triggered line, which is unmasked by default as this
is what we do for edge-triggered I/O APIC interrupts so as not to miss an
edge.

 To the best of my knowledge it is useless, as IRQ2 has not been in use
since the PC/AT as back then it was taken by the 8259A cascade interrupt
to the slave, with the line position in the slot rerouted to newly-created
IRQ9.  No device could thus make use of this line with the pair of 8259A
chips.  Now in theory INTIN2 of the I/O APIC may be usable, but the
interrupt of the device wired to it would not be available in the PIC mode
at all, so I seriously doubt if anybody decided to reuse it for a regular
device.

 However there are two common uses of INTIN2.  One is for IRQ0, with an
ACPI interrupt override (or its equivalent in the MP table).  But in this
case IRQ2 is gone entirely with INTIN0 left vacant.  The other one is for
an 8959A ExtINTA cascade.  In this case IRQ0 goes to INTIN0 and if ACPI is
used INTIN2 is assumed to be IRQ2 (there is no override and ACPI has no
way to report ExtINTA interrupts).  This is where a problem happens.

 The problem is INTIN2 is configured as a native APIC interrupt, with a
vector assigned and the mask cleared.  And the line may indeed get active
and inject interrupts if the master 8959A has its timer interrupt enabled
(it might happen for other interrupts too, but they are normally masked in
the process of rerouting them to the I/O APIC).  There are two cases where
it will happen:

* When the I/O APIC NMI watchdog is enabled.  This is actually a misnomer
  as the watchdog pulses are delivered through the 8259A to the LINT0
  inputs of all the local APICs in the system.  The implication is the
  output of the master 8259A goes high and low repeatedly, signalling
  interrupts to INTIN2 which is enabled too!

  [The origin of the name is I think for a brief period during the
  development we had a capability in our code to configure the watchdog to
  use an I/O APIC input; that would be INTIN2 in this scenario.]

* When the native route of IRQ0 via INTIN0 fails for whatever reason -- as
  it happens with the system considered here.  In this scenario the timer
  pulse is delivered through the 8259A to LINT0 input of the local APIC of
  the bootstrap processor, quite similarly to how is done for the watchdog
  described above.  The result is, again, INTIN2 receives these pulses 
  too.  Rafael's system used to escape this scenario, because an incorrect
  IRQ0 override would occupy INTIN2 and prevent it from being unmasked.

 My conclusion is IRQ2 should be excluded from configuration in all the
cases and the current exception for ACPI systems should be lifted.  The
reason being the exception not only being useless, but harmful as well.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
---
patch-2.6.26-rc1-20080505-ioapic-noirq2-1
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-27 19:42:31.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-07-09 18:38:58.000000000 +0000
@@ -2268,11 +2268,21 @@ out:
 }
 
 /*
- *
- * IRQ's that are handled by the PIC in the MPS IOAPIC case.
- * - IRQ2 is the cascade IRQ, and cannot be a io-apic IRQ.
- *   Linux doesn't really care, as it's not actually used
- *   for any interrupt handling anyway.
+ * Traditionally ISA IRQ2 is the cascade IRQ, and is not available
+ * to devices.  However there may be an I/O APIC pin available for
+ * this interrupt regardless.  The pin may be left unconnected, but
+ * typically it will be reused as an ExtINT cascade interrupt for
+ * the master 8259A.  In the MPS case such a pin will normally be
+ * reported as an ExtINT interrupt in the MP table.  With ACPI
+ * there is no provision for ExtINT interrupts, and in the absence
+ * of an override it would be treated as an ordinary ISA I/O APIC
+ * interrupt, that is edge-triggered and unmasked by default.  We
+ * used to do this, but it caused problems on some systems because
+ * of the NMI watchdog and sometimes IRQ0 of the 8254 timer using
+ * the same ExtINT cascade interrupt to drive the local APIC of the
+ * bootstrap processor.  Therefore we refrain from routing IRQ2 to
+ * the I/O APIC in all cases now.  No actual device should request
+ * it anyway.  --macro
  */
 #define PIC_IRQS	(1 << PIC_CASCADE_IR)
 
@@ -2286,10 +2296,7 @@ void __init setup_IO_APIC(void)
 
 	enable_IO_APIC();
 
-	if (acpi_ioapic)
-		io_apic_irqs = ~0;	/* all IRQs go through IOAPIC */
-	else
-		io_apic_irqs = ~PIC_IRQS;
+	io_apic_irqs = ~PIC_IRQS;
 
 	printk("ENABLING IO-APIC IRQs\n");
 
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-06-18 03:24:54.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-07-09 18:45:16.000000000 +0000
@@ -1779,11 +1779,21 @@ static int __init notimercheck(char *s)
 __setup("no_timer_check", notimercheck);
 
 /*
- *
- * IRQs that are handled by the PIC in the MPS IOAPIC case.
- * - IRQ2 is the cascade IRQ, and cannot be a io-apic IRQ.
- *   Linux doesn't really care, as it's not actually used
- *   for any interrupt handling anyway.
+ * Traditionally ISA IRQ2 is the cascade IRQ, and is not available
+ * to devices.  However there may be an I/O APIC pin available for
+ * this interrupt regardless.  The pin may be left unconnected, but
+ * typically it will be reused as an ExtINT cascade interrupt for
+ * the master 8259A.  In the MPS case such a pin will normally be
+ * reported as an ExtINT interrupt in the MP table.  With ACPI
+ * there is no provision for ExtINT interrupts, and in the absence
+ * of an override it would be treated as an ordinary ISA I/O APIC
+ * interrupt, that is edge-triggered and unmasked by default.  We
+ * used to do this, but it caused problems on some systems because
+ * of the NMI watchdog and sometimes IRQ0 of the 8254 timer using
+ * the same ExtINT cascade interrupt to drive the local APIC of the
+ * bootstrap processor.  Therefore we refrain from routing IRQ2 to
+ * the I/O APIC in all cases now.  No actual device should request
+ * it anyway.  --macro
  */
 #define PIC_IRQS	(1<<2)
 
@@ -1794,10 +1804,7 @@ void __init setup_IO_APIC(void)
 	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
 	 */
 
-	if (acpi_ioapic)
-		io_apic_irqs = ~0;	/* all IRQs go through IOAPIC */
-	else
-		io_apic_irqs = ~PIC_IRQS;
+	io_apic_irqs = ~PIC_IRQS;
 
 	apic_printk(APIC_VERBOSE, "ENABLING IO-APIC IRQs\n");
 
