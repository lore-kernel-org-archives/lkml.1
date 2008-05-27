Return-Path: <linux-kernel-owner+w=401wt.eu-S1759549AbYE0UVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759549AbYE0UVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758467AbYE0UUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:20:12 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63947 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758331AbYE0UUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:20:10 -0400
Date: Tue, 27 May 2008 21:19:51 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 8/8] x86: I/O APIC: Timer through 8259A second-chance
Message-ID: <Pine.LNX.4.55.0805271950010.18833@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Some systems incorrectly report the ExtINTA pin of the I/O APIC as the
genuine target of the timer interrupt.  Here is a change that copies timer
pin information found to the other pin if one has been found only.  This
way both a direct and a through-8259A route is tested with the pin letting
these problematic systems work well enough.  If no timer pin information
has been found for the I/O APIC, then local APIC variations are tried
only, similarly to what is done without the change (except without the
misleading messages).

 Obviously if we try the first-chance path without being told by the BIOS 
to do so, we should not complain either, so do not print the message in 
this case.

 The 64-bit variation should be updated with a call to
replace_pin_at_irq() which can be done with the upcoming merge.  Since
add_pin_to_irq() is now always called in the first-chance path, the
condition to require it in the second-chance path no longer happens.  

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
Ingo,

 Despite looking quite innocent, this is the most intrusive modification
in the series.  I tested this change (on top of all the other 14 ones)  
with as many variations of interrupt wiring configuration as I could
imagine and simulate with my system.  Of course my machine is perfectly
unbroken, :) so chances are more exotic convolutions may have escaped my
attention.  Also I tested the 32-bit variation only.  So again, I
recommend a good amount of testing in the field before this patch is
propagated upstream.

  Maciej

patch-2.6.26-rc1-20080505-timer-pins-2
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-25 22:24:53.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-27 19:42:31.000000000 +0000
@@ -2122,6 +2122,7 @@ static inline void __init unlock_ExtINT_
 static inline void __init check_timer(void)
 {
 	int apic1, pin1, apic2, pin2;
+	int no_pin1 = 0;
 	int vector;
 	unsigned int ver;
 	unsigned long flags;
@@ -2159,10 +2160,30 @@ static inline void __init check_timer(vo
 	printk(KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		vector, apic1, pin1, apic2, pin2);
 
+	/*
+	 * Some BIOS writers are clueless and report the ExtINTA
+	 * I/O APIC input from the cascaded 8259A as the timer
+	 * interrupt input.  So just in case, if only one pin
+	 * was found above, try it both directly and through the
+	 * 8259A.  --macro
+	 */
+	if (pin1 == -1) {
+		pin1 = pin2;
+		apic1 = apic2;
+		no_pin1 = 1;
+	} else if (pin2 == -1) {
+		pin2 = pin1;
+		apic2 = apic1;
+	}
+
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
+		if (no_pin1) {
+			add_pin_to_irq(0, apic1, pin1);
+			setup_timer_IRQ0_pin(apic1, pin1, vector);
+		}
 		unmask_IO_APIC_irq(0);
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
@@ -2174,26 +2195,23 @@ static inline void __init check_timer(vo
 			goto out;
 		}
 		clear_IO_APIC_pin(apic1, pin1);
-		printk(KERN_ERR "..MP-BIOS bug: 8254 timer not connected to "
-				"IO-APIC\n");
-	}
+		if (!no_pin1)
+			printk(KERN_ERR "..MP-BIOS bug: "
+			       "8254 timer not connected to IO-APIC\n");
 
-	printk(KERN_INFO "...trying to set up timer (IRQ0) through the 8259A ... ");
-	if (pin2 != -1) {
+		printk(KERN_INFO "...trying to set up timer (IRQ0) "
+		       "through the 8259A ... ");
 		printk("\n..... (found pin %d) ...", pin2);
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
+		replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
 		setup_timer_IRQ0_pin(apic2, pin2, vector);
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			printk("works.\n");
 			timer_through_8259 = 1;
-			if (pin1 != -1)
-				replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
-			else
-				add_pin_to_irq(0, apic2, pin2);
 			if (nmi_watchdog == NMI_IO_APIC) {
 				disable_8259A_irq(0);
 				setup_nmi();
@@ -2206,8 +2224,8 @@ static inline void __init check_timer(vo
 		 */
 		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
+		printk(" failed.\n");
 	}
-	printk(" failed.\n");
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-25 22:26:43.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-27 19:44:19.000000000 +0000
@@ -1638,6 +1638,7 @@ static inline void __init check_timer(vo
 	struct irq_cfg *cfg = irq_cfg + 0;
 	int apic1, pin1, apic2, pin2;
 	unsigned long flags;
+	int no_pin1 = 0;
 
 	local_irq_save(flags);
 
@@ -1662,10 +1663,30 @@ static inline void __init check_timer(vo
 	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		cfg->vector, apic1, pin1, apic2, pin2);
 
+	/*
+	 * Some BIOS writers are clueless and report the ExtINTA
+	 * I/O APIC input from the cascaded 8259A as the timer
+	 * interrupt input.  So just in case, if only one pin
+	 * was found above, try it both directly and through the
+	 * 8259A.  --macro
+	 */
+	if (pin1 == -1) {
+		pin1 = pin2;
+		apic1 = apic2;
+		no_pin1 = 1;
+	} else if (pin2 == -1) {
+		pin2 = pin1;
+		apic2 = apic1;
+	}
+
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
 		 */
+		if (no_pin1) {
+			add_pin_to_irq(0, apic1, pin1);
+			setup_timer_IRQ0_pin(apic1, pin1, vector);
+		}
 		unmask_IO_APIC_irq(0);
 		if (!no_timer_check && timer_irq_works()) {
 			nmi_watchdog_default();
@@ -1678,18 +1699,19 @@ static inline void __init check_timer(vo
 			goto out;
 		}
 		clear_IO_APIC_pin(apic1, pin1);
-		apic_printk(APIC_QUIET,KERN_ERR "..MP-BIOS bug: 8254 timer not "
-				"connected to IO-APIC\n");
-	}
-
-	apic_printk(APIC_VERBOSE,KERN_INFO "...trying to set up timer (IRQ0) "
-				"through the 8259A ... ");
-	if (pin2 != -1) {
+		if (!no_pin1)
+			apic_printk(APIC_QUIET,KERN_ERR "..MP-BIOS bug: "
+				    "8254 timer not connected to IO-APIC\n");
+
+		apic_printk(APIC_VERBOSE,KERN_INFO
+			"...trying to set up timer (IRQ0) "
+			"through the 8259A ... ");
 		apic_printk(APIC_VERBOSE,"\n..... (found apic %d pin %d) ...",
 			apic2, pin2);
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
+		/* replace_pin_at_irq(0, apic1, pin1, apic2, pin2); */
 		setup_timer_IRQ0_pin(apic2, pin2, cfg->vector);
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
@@ -1709,8 +1731,8 @@ static inline void __init check_timer(vo
 		 */
 		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
+		apic_printk(APIC_VERBOSE," failed.\n");
 	}
-	apic_printk(APIC_VERBOSE," failed.\n");
 
 	if (nmi_watchdog == NMI_IO_APIC) {
 		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
