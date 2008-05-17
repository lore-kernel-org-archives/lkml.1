Return-Path: <linux-kernel-owner+w=401wt.eu-S1752023AbYEQEIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbYEQEIP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 00:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbYEQEH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 00:07:59 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62091 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750781AbYEQEH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 00:07:58 -0400
Date: Sat, 17 May 2008 05:07:42 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] I/O APIC: AEOI timer acknowledgement clean-ups
Message-ID: <Pine.LNX.4.55.0805170427440.4049@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 The code that used to be in do_slow_gettimeoffset() that relied on the
IRR bit of the master 8259A PIC for IRQ0 to check the state of the output
timer 0 of the PIT is no longer there.  As a result, there is no need to
use the POLL command to acknowledge the timer interrupt in the "8259A
Virtual Wire", except for the NMI watchdog when the i82489DX APIC is used
(this is because this particular APIC treats NMIs as level-triggered and
keeping the input asserted would keep motherboard NMI sources held off for
too long).  Remove the unneeded bits and adjust comments accordingly.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It seems to work for me with the NMI watchdog routed through the I/O 
APIC.  The next step should move the bits from timer_interrupt() to 
nmi_watchdog_tick() where they now belong, but let's check nothing breaks 
for people first.

  Maciej

patch-2.6.26-rc1-20080505-timer_ack-1
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-16 20:08:32.000000000 +0000
@@ -2146,19 +2146,17 @@ static inline void __init check_timer(vo
 	set_intr_gate(vector, interrupt[0]);
 
 	/*
-	 * Subtle, code in do_timer_interrupt() expects an AEOI
-	 * mode for the 8259A whenever interrupts are routed
-	 * through I/O APICs.  Also IRQ0 has to be enabled in
-	 * the 8259A which implies the virtual wire has to be
-	 * disabled in the local APIC.  Finally timer interrupts
-	 * need to be acknowledged manually in the 8259A for
-	 * timer_interrupt() and for the i82489DX when using
-	 * the NMI watchdog.
+	 * As IRQ0 is to be enabled in the 8259A, the virtual
+	 * wire has to be disabled in the local APIC.  Also
+	 * timer interrupts need to be acknowledged manually in
+	 * the 8259A for the i82489DX when using the NMI
+	 * watchdog as that APIC treats NMIs as level-triggered.
+	 * The AEOI mode will finish them in the 8259A
+	 * automatically.
 	 */
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
-	timer_ack = !cpu_has_tsc;
-	timer_ack |= (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
+	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
 	if (timer_over_8254 > 0)
 		enable_8259A_irq(0);
 
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-17 03:43:40.000000000 +0000
@@ -1669,11 +1669,8 @@ static inline void __init check_timer(vo
 	assign_irq_vector(0, TARGET_CPUS);
 
 	/*
-	 * Subtle, code in do_timer_interrupt() expects an AEOI
-	 * mode for the 8259A whenever interrupts are routed
-	 * through I/O APICs.  Also IRQ0 has to be enabled in
-	 * the 8259A which implies the virtual wire has to be
-	 * disabled in the local APIC.
+	 * As IRQ0 is to be enabled in the 8259A, the virtual
+	 * wire has to be disabled in the local APIC.
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_32.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_32.c	2008-05-16 20:11:41.000000000 +0000
@@ -131,7 +131,7 @@ int __init check_nmi_watchdog(void)
 	kfree(prev_nmi_count);
 	return 0;
 error:
-	timer_ack = !cpu_has_tsc;
+	timer_ack = 0;
 
 	return -1;
 }
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/time_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/time_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/time_32.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/time_32.c	2008-05-16 20:03:36.000000000 +0000
@@ -84,8 +84,7 @@ irqreturn_t timer_interrupt(int irq, voi
 	if (timer_ack) {
 		/*
 		 * Subtle, when I/O APICs are used we have to ack timer IRQ
-		 * manually to reset the IRR bit for do_slow_gettimeoffset().
-		 * This will also deassert NMI lines for the watchdog if run
+		 * manually to deassert NMI lines for the watchdog if run
 		 * on an 82489DX-based system.
 		 */
 		spin_lock(&i8259A_lock);
