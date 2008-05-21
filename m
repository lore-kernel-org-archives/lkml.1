Return-Path: <linux-kernel-owner+w=401wt.eu-S937243AbYEUVK4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937243AbYEUVK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:10:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936359AbYEUVJg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:09:36 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63914 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937232AbYEUVJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:09:34 -0400
Date: Wed, 21 May 2008 22:09:19 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] x86: I/O APIC: Remove parameters to fiddle with the
 8259A
Message-ID: <Pine.LNX.4.55.0805212034240.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Remove the "disable_8254_timer" and "enable_8254_timer" kernel
parameters.  Now that AEOI acknowledgements are no longer needed for
correct timer operation, the 8259A can be kept disabled unconditionally 
unless interrupts, either timer or watchdog ones, are actually passed 
through it.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-8254-2
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/early-quirks.c linux-2.6.26-rc1-20080505/arch/x86/kernel/early-quirks.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/early-quirks.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/early-quirks.c	2008-05-17 23:33:42.000000000 +0000
@@ -98,17 +98,6 @@ static void __init nvidia_bugs(int num, 
 
 }
 
-static void __init ati_bugs(int num, int slot, int func)
-{
-#ifdef CONFIG_X86_IO_APIC
-	if (timer_over_8254 == 1) {
-		timer_over_8254 = 0;
-		printk(KERN_INFO
-		"ATI board detected. Disabling timer routing over 8254.\n");
-	}
-#endif
-}
-
 #define QFLAG_APPLY_ONCE 	0x1
 #define QFLAG_APPLIED		0x2
 #define QFLAG_DONE		(QFLAG_APPLY_ONCE|QFLAG_APPLIED)
@@ -126,8 +115,6 @@ static struct chipset early_qrk[] __init
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, nvidia_bugs },
 	{ PCI_VENDOR_ID_VIA, PCI_ANY_ID,
 	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, via_bugs },
-	{ PCI_VENDOR_ID_ATI, PCI_ANY_ID,
-	  PCI_CLASS_BRIDGE_PCI, PCI_ANY_ID, QFLAG_APPLY_ONCE, ati_bugs },
 	{ PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_K8_NB,
 	  PCI_CLASS_BRIDGE_HOST, PCI_ANY_ID, 0, fix_hypertransport_config },
 	{}
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-21 18:50:07.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-21 18:51:28.000000000 +0000
@@ -58,7 +58,6 @@ static struct { int pin, apic; } ioapic_
 static DEFINE_SPINLOCK(ioapic_lock);
 static DEFINE_SPINLOCK(vector_lock);
 
-int timer_over_8254 __initdata = 1;
 
 /*
  *	Is the SiS APIC rmw bug present ?
@@ -2157,8 +2156,6 @@ static inline void __init check_timer(vo
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
 	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
-	if (timer_over_8254 > 0)
-		enable_8259A_irq(0);
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -2175,7 +2172,6 @@ static inline void __init check_timer(vo
 		unmask_IO_APIC_irq(0);
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
-				disable_8259A_irq(0);
 				setup_nmi();
 				enable_8259A_irq(0);
 			}
@@ -2195,6 +2191,7 @@ static inline void __init check_timer(vo
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		setup_ExtINT_IRQ0_pin(apic2, pin2, vector);
+		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			printk("works.\n");
 			if (pin1 != -1)
@@ -2209,6 +2206,7 @@ static inline void __init check_timer(vo
 		/*
 		 * Cleanup, just in case ...
 		 */
+		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
 	}
 	printk(" failed.\n");
@@ -2221,7 +2219,6 @@ static inline void __init check_timer(vo
 
 	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
-	disable_8259A_irq(0);
 	set_irq_chip_and_handler_name(0, &lapic_chip, handle_fasteoi_irq,
 				      "fasteoi");
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
@@ -2292,20 +2289,6 @@ void __init setup_IO_APIC(void)
 		print_IO_APIC();
 }
 
-static int __init setup_disable_8254_timer(char *s)
-{
-	timer_over_8254 = -1;
-	return 1;
-}
-static int __init setup_enable_8254_timer(char *s)
-{
-	timer_over_8254 = 2;
-	return 1;
-}
-
-__setup("disable_8254_timer", setup_disable_8254_timer);
-__setup("enable_8254_timer", setup_enable_8254_timer);
-
 /*
  *	Called after all the initialization is done. If we didnt find any
  *	APIC bugs then we can allow the modify fast path
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-17 03:43:40.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
@@ -90,7 +90,6 @@ static int no_timer_check;
 
 static int disable_timer_pin_1 __initdata;
 
-int timer_over_8254 __initdata = 1;
 
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
@@ -430,20 +429,6 @@ static int __init disable_timer_pin_setu
 }
 __setup("disable_timer_pin_1", disable_timer_pin_setup);
 
-static int __init setup_disable_8254_timer(char *s)
-{
-	timer_over_8254 = -1;
-	return 1;
-}
-static int __init setup_enable_8254_timer(char *s)
-{
-	timer_over_8254 = 2;
-	return 1;
-}
-
-__setup("disable_8254_timer", setup_disable_8254_timer);
-__setup("enable_8254_timer", setup_enable_8254_timer);
-
 
 /*
  * Find the IRQ entry number of a certain pin.
@@ -1674,8 +1659,6 @@ static inline void __init check_timer(vo
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
-	if (timer_over_8254 > 0)
-		enable_8259A_irq(0);
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -1693,7 +1676,6 @@ static inline void __init check_timer(vo
 		if (!no_timer_check && timer_irq_works()) {
 			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
-				disable_8259A_irq(0);
 				setup_nmi();
 				enable_8259A_irq(0);
 			}
@@ -1715,6 +1697,7 @@ static inline void __init check_timer(vo
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		setup_ExtINT_IRQ0_pin(apic2, pin2, cfg->vector);
+		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
 			nmi_watchdog_default();
@@ -1726,6 +1709,7 @@ static inline void __init check_timer(vo
 		/*
 		 * Cleanup, just in case ...
 		 */
+		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
 	}
 	apic_printk(APIC_VERBOSE," failed.\n");
@@ -1737,7 +1721,6 @@ static inline void __init check_timer(vo
 
 	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
-	disable_8259A_irq(0);
 	irq_desc[0].chip = &lapic_irq_type;
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/include/asm-x86/apic.h linux-2.6.26-rc1-20080505/include/asm-x86/apic.h
--- linux-2.6.26-rc1-20080505.macro/include/asm-x86/apic.h	2008-05-05 02:55:57.000000000 +0000
+++ linux-2.6.26-rc1-20080505/include/asm-x86/apic.h	2008-05-21 07:00:45.000000000 +0000
@@ -36,7 +36,6 @@ extern void generic_apic_probe(void);
 #ifdef CONFIG_X86_LOCAL_APIC
 
 extern int apic_verbosity;
-extern int timer_over_8254;
 extern int local_apic_timer_c2_ok;
 extern int local_apic_timer_disabled;
 
