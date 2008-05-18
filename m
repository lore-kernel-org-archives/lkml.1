Return-Path: <linux-kernel-owner+w=401wt.eu-S1753690AbYERDgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690AbYERDgq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 23:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750994AbYERDgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 23:36:36 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:64960 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751378AbYERDge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 23:36:34 -0400
Date: Sun, 18 May 2008 04:35:54 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] I/O APIC: Timer through 8259A revamp
Message-ID: <Pine.LNX.4.55.0805180237350.10067@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 There is some seemingly unnecessary cruft accumulated in the 8254 timer 
setup path for the I/O APIC.  Some attempts have been made to cater for 
broken BIOSes reporting the ExtINTA I/O APIC pin cascaded from the master 
8259A as the native timer interrupt input, which interfere with the setup 
sequence in a non-obvious way and require a pair of additional kernel 
command-line parameters.

 I think this is unnecessary.  All the bits are already in place.  With
the removal of AEOI bits for non-i82489DX systems the whole setup can be 
simplified.  Here is a set of changes that reuse the existing code for 
potentially broken systems.  The observation is broken systems do not have 
a notion of ExtINTA pins, so only one pin/apic pair will be determined as 
useful for the timer interrupt.  Therefore it should be safe to select 
this single pin/apic to test both directly and through the 8259A.

 This change implements this approach by copying timer pin information
found to the other pin if one has been found only.  This way both tests
are always performed.  The timer input of the 8259A is carefully unmasked
if needed only and masked again if found unneeded.  This is because some
systems seem sensitive for the master 8259A interrupt being active even if
all the APIC inputs this line is wired to are masked.

 The "disable_8254_timer" and "enable_8254_timer" kernel parameters are 
removed as no longer needed.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 It works for my system, but it definitely requires much, much more
testing.  The patch depends on patch-2.6.26-rc1-20080505-timer_ack-1 sent
earlier.

 Of course these "if (pin? != -1)" statements are useless (though
harmless) now, but I think that change deserves a separate patch not to
obfuscate changes to code which is obscure enough already.

  Maciej

patch-2.6.26-rc1-20080505-timer-8259-0
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
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-16 20:08:32.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-18 00:24:24.000000000 +0000
@@ -58,7 +58,7 @@ static struct { int pin, apic; } ioapic_
 static DEFINE_SPINLOCK(ioapic_lock);
 static DEFINE_SPINLOCK(vector_lock);
 
-int timer_over_8254 __initdata = 1;
+int timer_through_8259 __initdata;
 
 /*
  *	Is the SiS APIC rmw bug present ?
@@ -2129,6 +2129,7 @@ static inline void __init unlock_ExtINT_
 static inline void __init check_timer(void)
 {
 	int apic1, pin1, apic2, pin2;
+	int pin2_fixup = 0;
 	int vector;
 	unsigned int ver;
 	unsigned long flags;
@@ -2157,8 +2158,6 @@ static inline void __init check_timer(vo
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
 	timer_ack = (nmi_watchdog == NMI_IO_APIC && !APIC_INTEGRATED(ver));
-	if (timer_over_8254 > 0)
-		enable_8259A_irq(0);
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -2168,6 +2167,22 @@ static inline void __init check_timer(vo
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
+		pin2_fixup = 1;
+	} else if (pin2 == -1) {
+		pin2 = pin1;
+		apic2 = apic1;
+	}
+
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
@@ -2175,7 +2190,6 @@ static inline void __init check_timer(vo
 		unmask_IO_APIC_irq(0);
 		if (timer_irq_works()) {
 			if (nmi_watchdog == NMI_IO_APIC) {
-				disable_8259A_irq(0);
 				setup_nmi();
 				enable_8259A_irq(0);
 			}
@@ -2195,20 +2209,25 @@ static inline void __init check_timer(vo
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		setup_ExtINT_IRQ0_pin(apic2, pin2, vector);
+		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			printk("works.\n");
-			if (pin1 != -1)
+			timer_through_8259 = 1;
+			if (pin2 != pin1 || apic2 != apic1)
 				replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
-			else
+			else if (pin2_fixup)
 				add_pin_to_irq(0, apic2, pin2);
 			if (nmi_watchdog == NMI_IO_APIC) {
+				disable_8259A_irq(0);
 				setup_nmi();
+				enable_8259A_irq(0);
 			}
 			goto out;
 		}
 		/*
 		 * Cleanup, just in case ...
 		 */
+		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
 	}
 	printk(" failed.\n");
@@ -2220,7 +2239,6 @@ static inline void __init check_timer(vo
 
 	printk(KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
-	disable_8259A_irq(0);
 	set_irq_chip_and_handler_name(0, &lapic_chip, handle_fasteoi_irq,
 				      "fasteoi");
 	apic_write_around(APIC_LVT0, APIC_DM_FIXED | vector);	/* Fixed mode */
@@ -2230,6 +2248,7 @@ static inline void __init check_timer(vo
 		printk(" works.\n");
 		goto out;
 	}
+	disable_8259A_irq(0);
 	apic_write_around(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | vector);
 	printk(" failed.\n");
 
@@ -2292,20 +2311,6 @@ void __init setup_IO_APIC(void)
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
@@ -90,7 +90,7 @@ static int no_timer_check;
 
 static int disable_timer_pin_1 __initdata;
 
-int timer_over_8254 __initdata = 1;
+int timer_through_8259 __initdata;
 
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
@@ -430,20 +430,6 @@ static int __init disable_timer_pin_setu
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
@@ -1674,8 +1660,6 @@ static inline void __init check_timer(vo
 	 */
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_EXTINT);
 	init_8259A(1);
-	if (timer_over_8254 > 0)
-		enable_8259A_irq(0);
 
 	pin1  = find_isa_irq_pin(0, mp_INT);
 	apic1 = find_isa_irq_apic(0, mp_INT);
@@ -1685,6 +1669,21 @@ static inline void __init check_timer(vo
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
+	} else if (pin2 == -1) {
+		pin2 = pin1;
+		apic2 = apic1;
+	}
+
 	if (pin1 != -1) {
 		/*
 		 * Ok, does IRQ0 through the IOAPIC work?
@@ -1693,7 +1692,6 @@ static inline void __init check_timer(vo
 		if (!no_timer_check && timer_irq_works()) {
 			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
-				disable_8259A_irq(0);
 				setup_nmi();
 				enable_8259A_irq(0);
 			}
@@ -1715,17 +1713,22 @@ static inline void __init check_timer(vo
 		 * legacy devices should be connected to IO APIC #0
 		 */
 		setup_ExtINT_IRQ0_pin(apic2, pin2, cfg->vector);
+		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
+			timer_through_8259 = 1;
 			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
+				disable_8259A_irq(0);
 				setup_nmi();
+				enable_8259A_irq(0);
 			}
 			goto out;
 		}
 		/*
 		 * Cleanup, just in case ...
 		 */
+		disable_8259A_irq(0);
 		clear_IO_APIC_pin(apic2, pin2);
 	}
 	apic_printk(APIC_VERBOSE," failed.\n");
@@ -1737,7 +1740,6 @@ static inline void __init check_timer(vo
 
 	apic_printk(APIC_VERBOSE, KERN_INFO "...trying to set up timer as Virtual Wire IRQ...");
 
-	disable_8259A_irq(0);
 	irq_desc[0].chip = &lapic_irq_type;
 	apic_write(APIC_LVT0, APIC_DM_FIXED | cfg->vector);	/* Fixed mode */
 	enable_8259A_irq(0);
@@ -1746,6 +1748,7 @@ static inline void __init check_timer(vo
 		apic_printk(APIC_VERBOSE," works.\n");
 		goto out;
 	}
+	disable_8259A_irq(0);
 	apic_write(APIC_LVT0, APIC_LVT_MASKED | APIC_DM_FIXED | cfg->vector);
 	apic_printk(APIC_VERBOSE," failed.\n");
 
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_32.c	2008-05-16 20:11:41.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_32.c	2008-05-18 02:06:46.000000000 +0000
@@ -24,6 +24,8 @@
 #include <linux/kdebug.h>
 #include <linux/slab.h>
 
+#include <asm/apic.h>
+#include <asm/i8259.h>
 #include <asm/smp.h>
 #include <asm/nmi.h>
 #include <asm/timer.h>
@@ -131,6 +133,8 @@ int __init check_nmi_watchdog(void)
 	kfree(prev_nmi_count);
 	return 0;
 error:
+	if (nmi_watchdog == NMI_IO_APIC && !timer_through_8259)
+		disable_8259A_irq(0);
 	timer_ack = 0;
 
 	return -1;
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_64.c	2008-05-05 02:55:24.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_64.c	2008-05-18 00:15:51.000000000 +0000
@@ -21,6 +21,8 @@
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
 
+#include <asm/apic.h>
+#include <asm/i8259.h>
 #include <asm/smp.h>
 #include <asm/nmi.h>
 #include <asm/proto.h>
@@ -90,7 +92,7 @@ int __init check_nmi_watchdog(void)
 
 	prev_nmi_count = kmalloc(NR_CPUS * sizeof(int), GFP_KERNEL);
 	if (!prev_nmi_count)
-		return -1;
+		goto error;
 
 	printk(KERN_INFO "Testing NMI watchdog ... ");
 
@@ -121,7 +123,7 @@ int __init check_nmi_watchdog(void)
 	if (!atomic_read(&nmi_active)) {
 		kfree(prev_nmi_count);
 		atomic_set(&nmi_active, -1);
-		return -1;
+		goto error;
 	}
 	printk("OK.\n");
 
@@ -132,6 +134,11 @@ int __init check_nmi_watchdog(void)
 
 	kfree(prev_nmi_count);
 	return 0;
+error:
+	if (nmi_watchdog == NMI_IO_APIC && !timer_through_8259)
+		disable_8259A_irq(0);
+
+	return -1;
 }
 
 static int __init setup_nmi_watchdog(char *str)
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/include/asm-x86/apic.h linux-2.6.26-rc1-20080505/include/asm-x86/apic.h
--- linux-2.6.26-rc1-20080505.macro/include/asm-x86/apic.h	2008-05-05 02:55:57.000000000 +0000
+++ linux-2.6.26-rc1-20080505/include/asm-x86/apic.h	2008-05-18 00:16:42.000000000 +0000
@@ -36,7 +36,7 @@ extern void generic_apic_probe(void);
 #ifdef CONFIG_X86_LOCAL_APIC
 
 extern int apic_verbosity;
-extern int timer_over_8254;
+extern int timer_through_8259;
 extern int local_apic_timer_c2_ok;
 extern int local_apic_timer_disabled;
 
