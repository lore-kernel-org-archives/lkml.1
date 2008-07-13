Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYGMCbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYGMCbo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 22:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752524AbYGMCbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 22:31:37 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63078 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752507AbYGMCbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 22:31:36 -0400
Date: Sun, 13 Jul 2008 03:29:42 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garrett <mjg59@srcf.ucam.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: I/O APIC: Remove an IRQ2-mask hack
Message-ID: <Pine.LNX.4.55.0807130309340.6739@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Now that IRQ2 is never made available to the I/O APIC, there is no need
to special-case it and mask as a workaround for broken systems.  Actually, 
because of the former, mask_IO_APIC_irq(2) is a no-op already.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>
---

 This patch functionally depends on patch-2.6.26-rc1-20080505-ioapic-noirq2-1.

patch-next-2.6.26-rc9-20080711-acpi-nomaskirq2-6
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/acpi/boot.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/acpi/boot.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/acpi/boot.c	2008-07-13 01:24:07.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/acpi/boot.c	2008-07-13 02:16:20.000000000 +0000
@@ -1430,7 +1430,6 @@ static int __init dmi_ignore_irq0_timer_
 {
 	pr_notice("%s detected: Ignoring BIOS IRQ0 pin2 override\n", d->ident);
 	acpi_skip_timer_override = 1;
-	force_mask_ioapic_irq_2();
 	return 0;
 }
 
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c	2008-07-13 01:24:07.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c	2008-07-11 16:53:43.000000000 +0000
@@ -59,13 +59,6 @@ static struct { int pin, apic; } ioapic_
 static DEFINE_SPINLOCK(ioapic_lock);
 static DEFINE_SPINLOCK(vector_lock);
 
-static bool mask_ioapic_irq_2 __initdata;
-
-void __init force_mask_ioapic_irq_2(void)
-{
-	mask_ioapic_irq_2 = true;
-}
-
 int timer_through_8259 __initdata;
 
 /*
@@ -2179,9 +2172,6 @@ static inline void __init check_timer(vo
 	printk(KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		vector, apic1, pin1, apic2, pin2);
 
-	if (mask_ioapic_irq_2)
-		mask_IO_APIC_irq(2);
-
 	/*
 	 * Some BIOS writers are clueless and report the ExtINTA
 	 * I/O APIC input from the cascaded 8259A as the timer
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c	2008-07-13 01:24:07.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c	2008-07-11 16:53:43.000000000 +0000
@@ -94,13 +94,6 @@ static int no_timer_check;
 
 static int disable_timer_pin_1 __initdata;
 
-static bool mask_ioapic_irq_2 __initdata;
-
-void __init force_mask_ioapic_irq_2(void)
-{
-	mask_ioapic_irq_2 = true;
-}
-
 int timer_through_8259 __initdata;
 
 /* Where if anywhere is the i8259 connect in external int mode */
@@ -1705,9 +1698,6 @@ static inline void __init check_timer(vo
 	apic_printk(APIC_VERBOSE,KERN_INFO "..TIMER: vector=0x%02X apic1=%d pin1=%d apic2=%d pin2=%d\n",
 		cfg->vector, apic1, pin1, apic2, pin2);
 
-	if (mask_ioapic_irq_2)
-		mask_IO_APIC_irq(2);
-
 	/*
 	 * Some BIOS writers are clueless and report the ExtINTA
 	 * I/O APIC input from the cascaded 8259A as the timer
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/genapic_32.h linux-next-2.6.26-rc9-20080711/include/asm-x86/genapic_32.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/genapic_32.h	2008-07-13 02:12:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/genapic_32.h	2008-07-11 16:53:43.000000000 +0000
@@ -119,10 +119,5 @@ enum uv_system_type {UV_NONE, UV_LEGACY_
 #define is_uv_system()			0
 #define uv_wakeup_secondary(a, b)	1
 
-#ifdef CONFIG_X86_IO_APIC
-extern void force_mask_ioapic_irq_2(void);
-#else
-static inline void force_mask_ioapic_irq_2(void) { }
-#endif
 
 #endif
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/genapic_64.h linux-next-2.6.26-rc9-20080711/include/asm-x86/genapic_64.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/genapic_64.h	2008-07-13 02:12:51.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/genapic_64.h	2008-07-11 16:53:43.000000000 +0000
@@ -46,10 +46,4 @@ extern int uv_wakeup_secondary(int phys_
 
 extern void setup_apic_routing(void);
 
-#ifdef CONFIG_X86_IO_APIC
-extern void force_mask_ioapic_irq_2(void);
-#else
-static inline void force_mask_ioapic_irq_2(void) { }
-#endif
-
 #endif
