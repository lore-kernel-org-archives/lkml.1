Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbYGNSIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbYGNSIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 14:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYGNSIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 14:08:44 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64013 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751036AbYGNSIo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 14:08:44 -0400
Date: Mon, 14 Jul 2008 19:08:13 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86: I/O APIC: Always report how the timer has been set up
Message-ID: <Pine.LNX.4.55.0807141845120.17431@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Following recent (and less so) issues with the 8254 timer when routed
through the I/O or local APIC, always report which configurations have
been tried and which one has been set up eventually.  This is so that logs
posted by people for some other reason can be used as a cross-reference
when investigating any possible future problems.

 The change unifies messages printed on 32-bit and 64-bit platforms and
adds trailing newlines (removes leading ones), so that proper log level
annotation can be used and any possible interspersed output will not cause
a mess.

 I have chosen to use apic_printk(APIC_QUIET, ...) rather than printk(...)
so that the distinction of these messages is maintained making possible
future decisions about changes in this area easier.  A change posted
separately making apic_verbosity unsigned removes any extra code that
would otherwise be generated as a result of this design decision.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-next-2.6.26-rc9-20080711-ioapic-print-timer-2
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c	2008-07-11 17:48:30.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c	2008-07-14 16:59:41.000000000 +0000
@@ -2184,8 +2184,9 @@ static inline void __init check_timer(vo
 	pin2  = ioapic_i8259.pin;
 	apic2 = ioapic_i8259.apic;
 
-	printk(KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
-		vector, apic1, pin1, apic2, pin2);
+	apic_printk(APIC_QUIET, KERN_INFO "..TIMER: vector=0x%02X "
+		    "apic1=%d pin1=%d apic2=%d pin2=%d\n",
+		    vector, apic1, pin1, apic2, pin2);
 
 	if (mask_ioapic_irq_2)
 		mask_IO_APIC_irq(2);
@@ -2226,12 +2227,13 @@ static inline void __init check_timer(vo
 		}
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
-			printk(KERN_ERR "..MP-BIOS bug: "
-			       "8254 timer not connected to IO-APIC\n");
+			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
+				    "8254 timer not connected to IO-APIC\n");
 
-		printk(KERN_INFO "...trying to set up timer (IRQ0) "
-		       "through the 8259A ... ");
-		printk("\n..... (found pin %d) ...", pin2);
+		apic_printk(APIC_QUIET, KERN_INFO "...trying to set up timer "
+			    "(IRQ0) through the 8259A ...\n");
+		apic_printk(APIC_QUIET, KERN_INFO
+			    "..... (found apic %d pin %d) ...\n", apic2, pin2);
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
@@ -2240,7 +2242,7 @@ static inline void __init check_timer(vo
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
-			printk("works.\n");
+			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
 				disable_8259A_irq(0);
@@ -2254,30 +2256,33 @@ static inline void __init check_timer(vo
 		 */
 		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
-		printk(" failed.\n");
+		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
 
 	if (nmi_watchdog == NMI_IO_APIC) {
-		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
+		apic_printk(APIC_QUIET, KERN_WARNING "timer doesn't work "
+			    "through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
 	timer_ack = 0;
 
-	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
+	apic_printk(APIC_QUIET, KERN_INFO
+		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
 	lapic_register_intr(0, vector);
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
 	if (timer_irq_works()) {
-		printk(" works.\n");
+		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
 	disable_8259A_irq(0);
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
-	printk(" failed.\n");
+	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
-	printk(KERN_INFO "...trying to set up timer as ExtINT IRQ...");
+	apic_printk(APIC_QUIET, KERN_INFO
+		    "...trying to set up timer as ExtINT IRQ...\n");
 
 	init_8259A(0);
 	make_8259A_irq(0);
@@ -2286,12 +2291,12 @@ static inline void __init check_timer(vo
 	unlock_ExtINT_logic();
 
 	if (timer_irq_works()) {
-		printk(" works.\n");
+		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
-	printk(" failed :(.\n");
+	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
 	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
-		"report.  Then try booting with the 'noapic' option");
+		"report.  Then try booting with the 'noapic' option.\n");
 out:
 	local_irq_restore(flags);
 }
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c	2008-07-11 17:48:30.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c	2008-07-14 16:59:41.000000000 +0000
@@ -1703,8 +1703,9 @@ static inline void __init check_timer(vo
 	pin2  = ioapic_i8259.pin;
 	apic2 = ioapic_i8259.apic;
 
-	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
-		cfg->vector, apic1, pin1, apic2, pin2);
+	apic_printk(APIC_QUIET, KERN_INFO "..TIMER: vector=0x%02X "
+		    "apic1=%d pin1=%d apic2=%d pin2=%d\n",
+		    cfg->vector, apic1, pin1, apic2, pin2);
 
 	if (mask_ioapic_irq_2)
 		mask_IO_APIC_irq(2);
@@ -1745,14 +1746,13 @@ static inline void __init check_timer(vo
 		}
 		clear_IO_APIC_pin(apic1, pin1);
 		if (!no_pin1)
-			apic_printk(APIC_QUIET,KERN_ERR "..MP-BIOS bug: "
+			apic_printk(APIC_QUIET, KERN_ERR "..MP-BIOS bug: "
 				    "8254 timer not connected to IO-APIC\n");
 
-		apic_printk(APIC_VERBOSE,KERN_INFO
-			"...trying to set up timer (IRQ0) "
-			"through the 8259A ... ");
-		apic_printk(APIC_VERBOSE,"\n..... (found apic %d pin %d) ...",
-			apic2, pin2);
+		apic_printk(APIC_QUIET, KERN_INFO "...trying to set up timer "
+			    "(IRQ0) through the 8259A ...\n");
+		apic_printk(APIC_QUIET, KERN_INFO
+			    "..... (found apic %d pin %d) ...\n", apic2, pin2);
 		/*
 		 * legacy devices should be connected to IO APIC #0
 		 */
@@ -1761,7 +1761,7 @@ static inline void __init check_timer(vo
 		unmask_IO_APIC_irq(0);
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
-			apic_printk(APIC_VERBOSE," works.\n");
+			apic_printk(APIC_QUIET, KERN_INFO "....... works.\n");
 			timer_through_8259 = 1;
 			if (nmi_watchdog == NMI_IO_APIC) {
 				disable_8259A_irq(0);
@@ -1775,29 +1775,32 @@ static inline void __init check_timer(vo
 		 */
 		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
-		apic_printk(APIC_VERBOSE," failed.\n");
+		apic_printk(APIC_QUIET, KERN_INFO "....... failed.\n");
 	}
 
 	if (nmi_watchdog == NMI_IO_APIC) {
-		printk(KERN_WARNING "timer doesn't work through the IO-APIC - disabling NMI Watchdog!\n");
+		apic_printk(APIC_QUIET, KERN_WARNING "timer doesn't work "
+			    "through the IO-APIC - disabling NMI Watchdog!\n");
 		nmi_watchdog = NMI_NONE;
 	}
 
-	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
+	apic_printk(APIC_QUIET, KERN_INFO
+		    "...trying to set up timer as Virtual Wire IRQ...\n");
 
 	lapic_register_intr(0);
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
 
 	if (timer_irq_works()) {
-		apic_printk(APIC_VERBOSE," works.\n");
+		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
 	disable_8259A_irq(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
-	apic_printk(APIC_VERBOSE," failed.\n");
+	apic_printk(APIC_QUIET, KERN_INFO "..... failed.\n");
 
-	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as ExtINT IRQ...");
+	apic_printk(APIC_QUIET, KERN_INFO
+		    "...trying to set up timer as ExtINT IRQ...\n");
 
 	init_8259A(0);
 	make_8259A_irq(0);
@@ -1806,11 +1809,12 @@ static inline void __init check_timer(vo
 	unlock_ExtINT_logic();
 
 	if (timer_irq_works()) {
-		apic_printk(APIC_VERBOSE," works.\n");
+		apic_printk(APIC_QUIET, KERN_INFO "..... works.\n");
 		goto out;
 	}
-	apic_printk(APIC_VERBOSE," failed :(.\n");
-	panic("IO-APIC + timer doesn't work! Try using the 'noapic' kernel parameter\n");
+	apic_printk(APIC_QUIET, KERN_INFO "..... failed :(.\n");
+	panic("IO-APIC + timer doesn't work!  Boot with apic=debug and send a "
+		"report.  Then try booting with the 'noapic' option.\n");
 out:
 	local_irq_restore(flags);
 }
