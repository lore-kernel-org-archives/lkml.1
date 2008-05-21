Return-Path: <linux-kernel-owner+w=401wt.eu-S937804AbYEUVNo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937804AbYEUVNo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 17:13:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937289AbYEUVKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 17:10:43 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63946 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756464AbYEUVKj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 17:10:39 -0400
Date: Wed, 21 May 2008 22:10:22 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] x86: I/O APIC: Clean up the 8259A on a NMI watchdog
 failure
Message-ID: <Pine.LNX.4.55.0805212036170.4894@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 There is no point in keeping the 8259A enabled if the I/O APIC NMI 
watchdog has failed and the 8259A is not used to pass through regular 
timer interrupts.  This fixes problems with some systems where some logic 
gets confused.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-timer-8259-6
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_32.c	2008-05-21 18:52:36.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_32.c	2008-05-21 18:52:36.000000000 +0000
@@ -58,6 +58,7 @@ static struct { int pin, apic; } ioapic_
 static DEFINE_SPINLOCK(ioapic_lock);
 static DEFINE_SPINLOCK(vector_lock);
 
+int timer_through_8259 __initdata;
 
 /*
  *	Is the SiS APIC rmw bug present ?
@@ -2194,6 +2195,7 @@ static inline void __init check_timer(vo
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			printk("works.\n");
+			timer_through_8259 = 1;
 			if (pin1 != -1)
 				replace_pin_at_irq(0, apic1, pin1, apic2, pin2);
 			else
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/io_apic_64.c	2008-05-18 00:24:43.000000000 +0000
@@ -90,6 +90,7 @@ static int no_timer_check;
 
 static int disable_timer_pin_1 __initdata;
 
+int timer_through_8259 __initdata;
 
 /* Where if anywhere is the i8259 connect in external int mode */
 static struct { int pin, apic; } ioapic_i8259 = { -1, -1 };
@@ -1700,6 +1701,7 @@ static inline void __init check_timer(vo
 		enable_8259A_irq(0);
 		if (timer_irq_works()) {
 			apic_printk(APIC_VERBOSE," works.\n");
+			timer_through_8259 = 1;
 			nmi_watchdog_default();
 			if (nmi_watchdog == NMI_IO_APIC) {
 				disable_8259A_irq(0);
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_32.c linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_32.c
--- linux-2.6.26-rc1-20080505.macro/arch/x86/kernel/nmi_32.c	2008-05-16 20:11:41.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_32.c	2008-05-21 07:06:45.000000000 +0000
@@ -24,6 +24,8 @@
 #include <linux/kdebug.h>
 #include <linux/slab.h>
 
+#include <asm/i8259.h>
+#include <asm/io_apic.h>
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
+++ linux-2.6.26-rc1-20080505/arch/x86/kernel/nmi_64.c	2008-05-21 07:07:26.000000000 +0000
@@ -21,6 +21,8 @@
 #include <linux/cpumask.h>
 #include <linux/kdebug.h>
 
+#include <asm/i8259.h>
+#include <asm/io_apic.h>
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
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/include/asm-x86/io_apic.h linux-2.6.26-rc1-20080505/include/asm-x86/io_apic.h
--- linux-2.6.26-rc1-20080505.macro/include/asm-x86/io_apic.h	2008-05-05 02:55:57.000000000 +0000
+++ linux-2.6.26-rc1-20080505/include/asm-x86/io_apic.h	2008-05-21 07:04:37.000000000 +0000
@@ -137,6 +137,9 @@ extern int sis_apic_bug;
 /* 1 if "noapic" boot option passed */
 extern int skip_ioapic_setup;
 
+/* 1 if the timer IRQ uses the '8259A Virtual Wire' mode */
+extern int timer_through_8259;
+
 static inline void disable_ioapic_setup(void)
 {
 	skip_ioapic_setup = 1;
@@ -162,6 +165,7 @@ extern void ioapic_init_mappings(void);
 
 #else  /* !CONFIG_X86_IO_APIC */
 #define io_apic_assign_pci_irqs 0
+static const int timer_through_8259 = 0;
 #endif
 
 #endif
