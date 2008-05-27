Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYE0UUn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYE0UUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:20:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759432AbYE0UTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:19:55 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63933 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758697AbYE0UTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:19:54 -0400
Date: Tue, 27 May 2008 21:19:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] x86: I/O APIC: Rename setup_ExtINT_IRQ0_pin()
Message-ID: <Pine.LNX.4.55.0805271935240.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Rename setup_ExtINT_IRQ0_pin() to setup_timer_IRQ0_pin() to better 
reflect the upcoming role of a function setting up a (semi-)arbitrary I/O 
APIC pin appropriately for the 8254 timer.  By "appropriate" the following 
settings are meant: edge-triggered, active-high, all the other settings 
per-architecture.  Adjust comments to reflect code appropriately.  No 
functional changes.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-extint-rename-0
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-25 21:52:46.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-25 22:02:20.000000000 +0000
@@ -1302,9 +1302,10 @@ static void __init setup_IO_APIC_irqs(vo
 }
 
 /*
- * Set up the 8259A-master output pin:
+ * Set up the timer pin, possibly with the 8259A-master behind.
  */
-static void __init setup_ExtINT_IRQ0_pin(unsigned int apic, unsigned int pin, int vector)
+static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
+					int vector)
 {
 	struct IO_APIC_route_entry entry;
 
@@ -1324,7 +1325,7 @@ static void __init setup_ExtINT_IRQ0_pin
 
 	/*
 	 * The timer IRQ doesn't have to know that behind the
-	 * scene we have a 8259A-master in AEOI mode ...
+	 * scene we may have a 8259A-master in AEOI mode ...
 	 */
 	ioapic_register_intr(0, vector, IOAPIC_EDGE);
 
@@ -2183,7 +2184,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		setup_ExtINT_IRQ0_pin(apic2, pin2, vector);
+		setup_timer_IRQ0_pin(apic2, pin2, vector);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			printk("works.\n");
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-25 21:52:46.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-25 22:03:58.000000000 +0000
@@ -897,10 +897,10 @@ static void __init setup_IO_APIC_irqs(vo
 }
 
 /*
- * Set up the 8259A-master output pin as broadcast to all
- * CPUs.
+ * Set up the timer pin, possibly with the 8259A-master behind.
  */
-static void __init setup_ExtINT_IRQ0_pin(unsigned int apic, unsigned int pin, int vector)
+static void __init setup_timer_IRQ0_pin(unsigned int apic, unsigned int pin,
+					int vector)
 {
 	struct IO_APIC_route_entry entry;
 
@@ -920,7 +920,7 @@ static void __init setup_ExtINT_IRQ0_pin
 
 	/*
 	 * The timer IRQ doesn't have to know that behind the
-	 * scene we have a 8259A-master in AEOI mode ...
+	 * scene we may have a 8259A-master in AEOI mode ...
 	 */
 	set_irq_chip_and_handler_name(0, &ioapic_chip, handle_edge_irq, "edge");
 
@@ -1690,7 +1690,7 @@ static inline void __init check_timer(vo
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
-		setup_ExtINT_IRQ0_pin(apic2, pin2, cfg->vector);
+		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
