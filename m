Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbYGKSiI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbYGKSiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 14:38:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbYGKShp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 14:37:45 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64599 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754126AbYGKSho (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 14:37:44 -0400
Date: Fri, 11 Jul 2008 19:35:17 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] x86: L-APIC: Always fully configure IRQ0
Message-ID: <Pine.LNX.4.55.0807111920090.31940@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Unlike the 32-bit one, the 64-bit variation of the LVT0 setup code for 
the "8259A Virtual Wire" through the local APIC timer configuration does 
not fully configure the relevant irq_chip structure.  Instead it relies on 
the preceding I/O APIC code to have set it up, which does not happen if 
the I/O APIC variants have not been tried.

 The patch includes corresponding changes to the 32-bit variation too
which make them both the same, barring a small syntactic difference
involving sequence of functions in the source.  That should work as an aid
with the upcoming merge.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
---

 Note this is against linux-next.  Applies on top of 
patch-next-2.6.26-rc9-20080711-timer-lapic-edge-7.

patch-next-2.6.26-rc9-20080711-timer-lapic-init-0
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c	2008-07-11 17:51:05.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c	2008-07-11 17:48:30.000000000 +0000
@@ -2027,7 +2027,7 @@ static inline void init_IO_APIC_traps(vo
  * The local APIC irq-chip implementation:
  */
 
-static void ack_apic(unsigned int irq)
+static void ack_lapic_irq(unsigned int irq)
 {
 	ack_APIC_irq();
 }
@@ -2052,9 +2052,17 @@ static struct irq_chip lapic_chip __read
 	.name		= "local-APIC",
 	.mask		= mask_lapic_irq,
 	.unmask		= unmask_lapic_irq,
-	.ack		= ack_apic,
+	.ack		= ack_lapic_irq,
 };
 
+static void lapic_register_intr(int irq, int vector)
+{
+	irq_desc[irq].status &= ~IRQ_LEVEL;
+	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
+				      "edge");
+	set_intr_gate(vector, interrupt[irq]);
+}
+
 static void __init setup_nmi(void)
 {
 	/*
@@ -2257,8 +2265,7 @@ static inline void __init check_timer(vo
 
 	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
-	set_irq_chip_and_handler_name(0, &lapic_chip, handle_edge_irq,
-				      "edge");
+	lapic_register_intr(0, vector);
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c	2008-07-11 17:10:33.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c	2008-07-11 17:48:30.000000000 +0000
@@ -1561,7 +1561,7 @@ static inline void init_IO_APIC_traps(vo
 	}
 }
 
-static void enable_lapic_irq (unsigned int irq)
+static void unmask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
@@ -1569,7 +1569,7 @@ static void enable_lapic_irq (unsigned i
 	apic_write(APIC_LVT0, v & ~APIC_LVT_MASKED);
 }
 
-static void disable_lapic_irq (unsigned int irq)
+static void mask_lapic_irq(unsigned int irq)
 {
 	unsigned long v;
 
@@ -1582,19 +1582,20 @@ static void ack_lapic_irq (unsigned int 
 	ack_APIC_irq();
 }
 
-static void end_lapic_irq (unsigned int i) { /* nothing */ }
-
-static struct hw_interrupt_type lapic_irq_type __read_mostly = {
-	.name = "local-APIC",
-	.typename = "local-APIC-edge",
-	.startup = NULL, /* startup_irq() not used for IRQ0 */
-	.shutdown = NULL, /* shutdown_irq() not used for IRQ0 */
-	.enable = enable_lapic_irq,
-	.disable = disable_lapic_irq,
-	.ack = ack_lapic_irq,
-	.end = end_lapic_irq,
+static struct irq_chip lapic_chip __read_mostly = {
+	.name		= "local-APIC",
+	.mask		= mask_lapic_irq,
+	.unmask		= unmask_lapic_irq,
+	.ack		= ack_lapic_irq,
 };
 
+static void lapic_register_intr(int irq)
+{
+	irq_desc[irq].status &= ~IRQ_LEVEL;
+	set_irq_chip_and_handler_name(irq, &lapic_chip, handle_edge_irq,
+				      "edge");
+}
+
 static void __init setup_nmi(void)
 {
 	/*
@@ -1784,7 +1785,7 @@ static inline void __init check_timer(vo
 
 	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
-	irq_desc[0].chip = &lapic_irq_type;
+	lapic_register_intr(0);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
