Return-Path: <linux-kernel-owner+w=401wt.eu-S1754259AbYGWAoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259AbYGWAoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYGWAoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:44:04 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:63495 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751323AbYGWAoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:44:02 -0400
Date: Wed, 23 Jul 2008 01:43:11 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Chuck Ebbert <cebbert@redhat.com>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86: PIC, L-APIC and I/O APIC debug information
Message-ID: <Pine.LNX.4.55.0807230125020.31850@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Dump all the PIC, local APIC and I/O APIC information at the
fs_initcall() level, which is after ACPI (if used) has initialised PCI
information, making the point of invocation consistent across MP-table and
ACPI platforms.  Remove explicit calls to print_IO_APIC() from elsewhere.  
Make the interface of all the functions involved consistent between 32-bit
and 64-bit versions and make them all static.

 Note that like print_IO_APIC() all these only output anything if 
"apic=debug" has been passed to the kernel through the command line.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-next-2.6.26-rc9-20080711-ioapic-debug-3
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_32.c	2008-07-11 15:56:32.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_32.c	2008-07-23 00:18:42.000000000 +0000
@@ -1352,7 +1352,8 @@ static void __init setup_timer_IRQ0_pin(
 	ioapic_write_entry(apic, pin, entry);
 }
 
-void __init print_IO_APIC(void)
+
+static void __init print_IO_APIC(void)
 {
 	int apic, i;
 	union IO_APIC_reg_00 reg_00;
@@ -1467,9 +1468,7 @@ void __init print_IO_APIC(void)
 	return;
 }
 
-#if 0
-
-static void print_APIC_bitfield(int base)
+static void __init print_APIC_bitfield(int base)
 {
 	unsigned int v;
 	int i, j;
@@ -1490,7 +1489,7 @@ static void print_APIC_bitfield(int base
 	}
 }
 
-void /*__init*/ print_local_APIC(void *dummy)
+static void __init print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
 
@@ -1574,12 +1573,12 @@ void /*__init*/ print_local_APIC(void *d
 	printk("\n");
 }
 
-void print_all_local_APICs(void)
+static void __init print_all_local_APICs(void)
 {
 	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
-void /*__init*/ print_PIC(void)
+static void __init print_PIC(void)
 {
 	unsigned int v;
 	unsigned long flags;
@@ -1611,7 +1610,17 @@ void /*__init*/ print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-#endif  /*  0  */
+static int __init print_all_ICs(void)
+{
+	print_PIC();
+	print_all_local_APICs();
+	print_IO_APIC();
+
+	return 0;
+}
+
+fs_initcall(print_all_ICs);
+
 
 static void __init enable_IO_APIC(void)
 {
@@ -2324,8 +2333,6 @@ void __init setup_IO_APIC(void)
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
-	if (!acpi_ioapic)
-		print_IO_APIC();
 }
 
 /*
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/kernel/io_apic_64.c	2008-07-13 01:24:07.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/kernel/io_apic_64.c	2008-07-23 00:19:10.000000000 +0000
@@ -86,8 +86,6 @@ int first_system_vector = 0xfe;
 
 char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
 
-#define __apicdebuginit  __init
-
 int sis_apic_bug; /* not actually supported, dummy for compile */
 
 static int no_timer_check;
@@ -971,7 +969,8 @@ static void __init setup_timer_IRQ0_pin(
 	ioapic_write_entry(apic, pin, entry);
 }
 
-void __apicdebuginit print_IO_APIC(void)
+
+static void __init print_IO_APIC(void)
 {
 	int apic, i;
 	union IO_APIC_reg_00 reg_00;
@@ -1065,9 +1064,7 @@ void __apicdebuginit print_IO_APIC(void)
 	return;
 }
 
-#if 0
-
-static __apicdebuginit void print_APIC_bitfield (int base)
+static void __init print_APIC_bitfield(int base)
 {
 	unsigned int v;
 	int i, j;
@@ -1088,7 +1085,7 @@ static __apicdebuginit void print_APIC_b
 	}
 }
 
-void __apicdebuginit print_local_APIC(void * dummy)
+static void __init print_local_APIC(void *dummy)
 {
 	unsigned int v, ver, maxlvt;
 
@@ -1165,12 +1162,12 @@ void __apicdebuginit print_local_APIC(vo
 	printk("\n");
 }
 
-void print_all_local_APICs (void)
+static void __init print_all_local_APICs(void)
 {
 	on_each_cpu(print_local_APIC, NULL, 1);
 }
 
-void __apicdebuginit print_PIC(void)
+static void __init print_PIC(void)
 {
 	unsigned int v;
 	unsigned long flags;
@@ -1202,7 +1199,17 @@ void __apicdebuginit print_PIC(void)
 	printk(KERN_DEBUG "... PIC ELCR: %04x\n", v);
 }
 
-#endif  /*  0  */
+static int __init print_all_ICs(void)
+{
+	print_PIC();
+	print_all_local_APICs();
+	print_IO_APIC();
+
+	return 0;
+}
+
+fs_initcall(print_all_ICs);
+
 
 void __init enable_IO_APIC(void)
 {
@@ -1848,8 +1855,6 @@ void __init setup_IO_APIC(void)
 	setup_IO_APIC_irqs();
 	init_IO_APIC_traps();
 	check_timer();
-	if (!acpi_ioapic)
-		print_IO_APIC();
 }
 
 struct sysfs_ioapic_data {
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/arch/x86/pci/acpi.c linux-next-2.6.26-rc9-20080711/arch/x86/pci/acpi.c
--- linux-next-2.6.26-rc9-20080711.macro/arch/x86/pci/acpi.c	2008-07-23 00:12:21.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/arch/x86/pci/acpi.c	2008-07-15 23:10:13.000000000 +0000
@@ -250,10 +250,5 @@ int __init pci_acpi_init(void)
 			acpi_pci_irq_enable(dev);
 	}
 
-#ifdef CONFIG_X86_IO_APIC
-	if (acpi_ioapic)
-		print_IO_APIC();
-#endif
-
 	return 0;
 }
diff -up --recursive --new-file linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/hw_irq.h linux-next-2.6.26-rc9-20080711/include/asm-x86/hw_irq.h
--- linux-next-2.6.26-rc9-20080711.macro/include/asm-x86/hw_irq.h	2008-07-23 00:12:21.000000000 +0000
+++ linux-next-2.6.26-rc9-20080711/include/asm-x86/hw_irq.h	2008-07-15 23:26:41.000000000 +0000
@@ -64,7 +64,6 @@ extern unsigned long io_apic_irqs;
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
 extern void disable_IO_APIC(void);
-extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
 extern void setup_ioapic_dest(void);
 
