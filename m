Return-Path: <linux-kernel-owner+w=401wt.eu-S1755491AbXL3Dsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491AbXL3Dsv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 22:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbXL3Dsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 22:48:43 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:56070 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbXL3Dsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 22:48:42 -0500
Date: Sat, 29 Dec 2007 19:52:20 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: clear IO_APIC before enabing apic error vector. v2
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <200712291952.20455.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

please check if you can replace the one in the x86-mm

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-x86.git;a=commitdiff;h=ffcbdc220a1520d006a837f33589c7c19ffbeb76

the updated one avoid one link warning.

YH

[PATCH] x86_64: clear IO_APIC before enabing apic error vector. v2

some apic id lifting system: 4 socket quad core, 8 socket quad core will do apic id lifting for BSP.

but io-apic regs for ExtINT still use 0 as dest.

so when we enable apic error vector in BSP, we will get one APIC error.

CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 512K (64 bytes/line)
CPU 0/4 -> Node 0
CPU: Physical Processor ID: 1
CPU: Processor Core ID: 0
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
enabled ExtINT on CPU#0
ESR value after enabling vector: 00000000, after 0000000c
APIC error on CPU0: 0c(08)
ENABLING IO-APIC IRQs
Synchronizing Arb IDs.

So move enable_IO_APIC from setup_IO_APIC into setup_local_APIC and call it
before enabling apic error vector.

this is the updated verison that take enable_IO_APIC as extra call for
setup_local_APIC to avoid linking warning.

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

Index: linux-2.6/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic_64.c
+++ linux-2.6/arch/x86/kernel/apic_64.c
@@ -418,7 +418,7 @@ void __init init_bsp_APIC(void)
 	apic_write(APIC_LVT1, value);
 }
 
-void __cpuinit setup_local_APIC (void)
+void __cpuinit setup_local_APIC (void (*extra_call)(void))
 {
 	unsigned int value, maxlvt;
 	int i, j;
@@ -517,6 +517,13 @@ void __cpuinit setup_local_APIC (void)
 		value = APIC_DM_NMI | APIC_LVT_MASKED;
 	apic_write(APIC_LVT1, value);
 
+	/*
+	 * Now enable IO-APICs, actually call clear_IO_APIC
+	 * We need clear_IO_APIC before enabling vector on BP
+	 */
+	if (extra_call)
+		(*extra_call)();
+
 	{
 		unsigned oldvalue;
 		maxlvt = get_maxlvt();
@@ -1198,6 +1205,8 @@ int disable_apic;
  */
 int __init APIC_init_uniprocessor (void)
 {
+	void (*extra_call)(void) = NULL;
+
 	if (disable_apic) {
 		printk(KERN_INFO "Apic disabled\n");
 		return -1;
@@ -1213,7 +1222,10 @@ int __init APIC_init_uniprocessor (void)
 	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_id);
 	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_id));
 
-	setup_local_APIC();
+	if (!skip_ioapic_setup && nr_ioapics)
+		extra_call = enable_IO_APIC;
+
+	setup_local_APIC(extra_call);
 
 	if (smp_found_config && !skip_ioapic_setup && nr_ioapics)
 		setup_IO_APIC();
Index: linux-2.6/arch/x86/kernel/io_apic_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic_64.c
+++ linux-2.6/arch/x86/kernel/io_apic_64.c
@@ -1171,7 +1171,7 @@ void __apicdebuginit print_PIC(void)
 
 #endif  /*  0  */
 
-static void __init enable_IO_APIC(void)
+void __init enable_IO_APIC(void)
 {
 	union IO_APIC_reg_01 reg_01;
 	int i8259_apic, i8259_pin;
@@ -1790,7 +1790,10 @@ __setup("no_timer_check", notimercheck);
 
 void __init setup_IO_APIC(void)
 {
-	enable_IO_APIC();
+
+	/*
+	 * calling enable_IO_APIC() is moved to setup_local_APIC for BP
+	 */
 
 	if (acpi_ioapic)
 		io_apic_irqs = ~0;	/* all IRQs go through IOAPIC */
Index: linux-2.6/include/asm-x86/hw_irq_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/hw_irq_64.h
+++ linux-2.6/include/asm-x86/hw_irq_64.h
@@ -135,6 +135,7 @@ extern void init_8259A(int aeoi);
 extern void send_IPI_self(int vector);
 extern void init_VISWS_APIC_irqs(void);
 extern void setup_IO_APIC(void);
+extern void enable_IO_APIC(void);
 extern void disable_IO_APIC(void);
 extern void print_IO_APIC(void);
 extern int IO_APIC_get_PCI_irq_vector(int bus, int slot, int fn);
Index: linux-2.6/arch/x86/kernel/smpboot_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot_64.c
+++ linux-2.6/arch/x86/kernel/smpboot_64.c
@@ -211,7 +211,7 @@ void __cpuinit smp_callin(void)
 	 */
 
 	Dprintk("CALLIN, before setup_local_APIC().\n");
-	setup_local_APIC();
+	setup_local_APIC(NULL);
 
 	/*
 	 * Get our bogomips.
@@ -879,6 +879,8 @@ static void __init smp_cpu_index_default
  */
 void __init smp_prepare_cpus(unsigned int max_cpus)
 {
+	void (*extra_call)(void) = NULL;
+
 	nmi_watchdog_default();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
@@ -896,7 +898,10 @@ void __init smp_prepare_cpus(unsigned in
 	/*
 	 * Switch from PIC to APIC mode.
 	 */
-	setup_local_APIC();
+        if (!skip_ioapic_setup && nr_ioapics)
+                extra_call = enable_IO_APIC;
+
+	setup_local_APIC(extra_call);
 
 	if (GET_APIC_ID(apic_read(APIC_ID)) != boot_cpu_id) {
 		panic("Boot APIC ID in local APIC unexpected (%d vs %d)",
Index: linux-2.6/include/asm-x86/apic_64.h
===================================================================
--- linux-2.6.orig/include/asm-x86/apic_64.h
+++ linux-2.6/include/asm-x86/apic_64.h
@@ -74,7 +74,7 @@ extern int verify_local_APIC (void);
 extern void cache_APIC_registers (void);
 extern void sync_Arb_IDs (void);
 extern void init_bsp_APIC (void);
-extern void setup_local_APIC (void);
+extern void setup_local_APIC (void (*extra_call)(void));
 extern void init_apic_mappings (void);
 extern void smp_local_timer_interrupt (void);
 extern void setup_boot_APIC_clock (void);
