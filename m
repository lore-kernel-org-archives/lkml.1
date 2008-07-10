Return-Path: <linux-kernel-owner+w=401wt.eu-S1761800AbYGJSqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761800AbYGJSqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 14:46:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758680AbYGJSlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 14:41:55 -0400
Received: from mga14.intel.com ([143.182.124.37]:45689 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754590AbYGJSlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 14:41:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,339,1212390000"; 
   d="scan'208";a="11424653"
Message-Id: <20080710182239.348607000@linux-os.sc.intel.com>
References: <20080710181634.764954000@linux-os.sc.intel.com>
User-Agent: quilt/0.46-1
Date: Thu, 10 Jul 2008 11:16:58 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de,
       akpm@linux-foundation.org, arjan@linux.intel.com, andi@firstfloor.org,
       ebiederm@xmission.com, jbarnes@virtuousgeek.org, steiner@sgi.com
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 24/26] x64, x2apic/intr-remap: add x2apic support, including enabling interrupt-remapping
Content-Disposition: inline; filename=enable_x2apic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x2apic support.  Interrupt-remapping must be enabled before enabling x2apic,
this is needed to ensure that IO interrupts continue to work properly after the
cpu mode is changed to x2apic(which uses 32bit extended physical/cluster
apic id).

On systems where apicid's are > 255, BIOS can handover the control to OS in
x2apic mode. Or if the OS handover was in legacy xapic mode, check
if it is capable of x2apic mode. And if we succeed in enabling
Interrupt-remapping, then we can enable x2apic mode in the CPU.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tree-x86/arch/x86/kernel/apic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/apic_64.c	2008-07-10 09:52:31.000000000 -0700
+++ tree-x86/arch/x86/kernel/apic_64.c	2008-07-10 09:52:36.000000000 -0700
@@ -27,6 +27,7 @@
 #include <linux/clockchips.h>
 #include <linux/acpi_pmtmr.h>
 #include <linux/module.h>
+#include <linux/dmar.h>
 
 #include <asm/atomic.h>
 #include <asm/smp.h>
@@ -39,6 +40,7 @@
 #include <asm/proto.h>
 #include <asm/timex.h>
 #include <asm/apic.h>
+#include <asm/i8259.h>
 
 #include <mach_ipi.h>
 #include <mach_apic.h>
@@ -46,8 +48,12 @@
 static int disable_apic_timer __cpuinitdata;
 static int apic_calibrate_pmtmr __initdata;
 int disable_apic;
+int disable_x2apic;
 int x2apic;
 
+/* x2apic enabled before OS handover */
+int x2apic_preenabled;
+
 /* Local APIC timer works in C2 */
 int local_apic_timer_c2_ok;
 EXPORT_SYMBOL_GPL(local_apic_timer_c2_ok);
@@ -896,6 +902,125 @@
 	apic_pm_activate();
 }
 
+void check_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+
+	if (msr & X2APIC_ENABLE) {
+		printk("x2apic enabled by BIOS, switching to x2apic ops\n");
+		x2apic_preenabled = x2apic = 1;
+		apic_ops = &x2apic_ops;
+	}
+}
+
+void enable_x2apic(void)
+{
+	int msr, msr2;
+
+	rdmsr(MSR_IA32_APICBASE, msr, msr2);
+	if (!(msr & X2APIC_ENABLE)) {
+		printk("Enabling x2apic\n");
+		wrmsr(MSR_IA32_APICBASE, msr | X2APIC_ENABLE, 0);
+	}
+}
+
+void enable_IR_x2apic(void)
+{
+#ifdef CONFIG_INTR_REMAP
+	int ret;
+	unsigned long flags;
+
+	if (!cpu_has_x2apic)
+		return;
+
+	if (!x2apic_preenabled && disable_x2apic) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of nox2apic\n");
+		return;
+	}
+
+	if (x2apic_preenabled && disable_x2apic)
+		panic("Bios already enabled x2apic, can't enforce nox2apic");
+
+	if (!x2apic_preenabled && skip_ioapic_setup) {
+		printk(KERN_INFO
+		       "Skipped enabling x2apic and Interrupt-remapping "
+		       "because of skipping io-apic setup\n");
+		return;
+	}
+
+	ret = dmar_table_init();
+	if (ret) {
+		printk(KERN_INFO
+		       "dmar_table_init() failed with %d:\n", ret);
+
+		if (x2apic_preenabled)
+			panic("x2apic enabled by bios. But IR enabling failed");
+		else
+			printk(KERN_INFO
+			       "Not enabling x2apic,Intr-remapping\n");
+		return;
+	}
+
+	local_irq_save(flags);
+	mask_8259A();
+	save_mask_IO_APIC_setup();
+
+	ret = enable_intr_remapping(1);
+
+	if (ret && x2apic_preenabled) {
+		local_irq_restore(flags);
+		panic("x2apic enabled by bios. But IR enabling failed");
+	}
+
+	if (ret)
+		goto end;
+
+	if (!x2apic) {
+		x2apic = 1;
+		apic_ops = &x2apic_ops;
+		enable_x2apic();
+	}
+end:
+	if (ret)
+		/*
+		 * IR enabling failed
+		 */
+		restore_IO_APIC_setup();
+	else
+		reinit_intr_remapped_IO_APIC(x2apic_preenabled);
+
+	unmask_8259A();
+	local_irq_restore(flags);
+
+	if (!ret) {
+		if (!x2apic_preenabled)
+			printk(KERN_INFO
+			       "Enabled x2apic and interrupt-remapping\n");
+		else
+			printk(KERN_INFO
+			       "Enabled Interrupt-remapping\n");
+	} else
+		printk(KERN_ERR
+		       "Failed to enable Interrupt-remapping and x2apic\n");
+#else
+	if (!cpu_has_x2apic)
+		return;
+
+	if (x2apic_preenabled)
+		panic("x2apic enabled prior OS handover,"
+		      " enable CONFIG_INTR_REMAP");
+
+	printk(KERN_INFO "Enable CONFIG_INTR_REMAP for enabling intr-remapping "
+	       " and x2apic\n");
+#endif
+
+	return;
+}
+
 /*
  * Detect and enable local APICs on non-SMP boards.
  * Original code written by Keir Fraser.
@@ -943,6 +1068,11 @@
  */
 void __init init_apic_mappings(void)
 {
+	if (x2apic) {
+		boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
+		return;
+	}
+
 	/*
 	 * If no local APIC can be found then set up a fake all
 	 * zeroes page to simulate the local APIC and another
@@ -981,6 +1111,9 @@
 		return -1;
 	}
 
+	enable_IR_x2apic();
+	setup_apic_routing();
+
 	verify_local_APIC();
 
 	connect_bsp_APIC();
@@ -1238,10 +1371,14 @@
 	maxlvt = lapic_get_maxlvt();
 
 	local_irq_save(flags);
-	rdmsr(MSR_IA32_APICBASE, l, h);
-	l &= ~MSR_IA32_APICBASE_BASE;
-	l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
-	wrmsr(MSR_IA32_APICBASE, l, h);
+	if (!x2apic) {
+		rdmsr(MSR_IA32_APICBASE, l, h);
+		l &= ~MSR_IA32_APICBASE_BASE;
+		l |= MSR_IA32_APICBASE_ENABLE | mp_lapic_addr;
+		wrmsr(MSR_IA32_APICBASE, l, h);
+	} else
+		enable_x2apic();
+
 	apic_write(APIC_LVTERR, ERROR_APIC_VECTOR | APIC_LVT_MASKED);
 	apic_write(APIC_ID, apic_pm_state.apic_id);
 	apic_write(APIC_DFR, apic_pm_state.apic_dfr);
@@ -1381,6 +1518,15 @@
 	return (clusters > 2);
 }
 
+static __init int setup_nox2apic(char *str)
+{
+	disable_x2apic = 1;
+	clear_cpu_cap(&boot_cpu_data, X86_FEATURE_X2APIC);
+	return 0;
+}
+early_param("nox2apic", setup_nox2apic);
+
+
 /*
  * APIC command line parameters
  */
Index: tree-x86/arch/x86/kernel/genapic_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:27.000000000 -0700
+++ tree-x86/arch/x86/kernel/genapic_64.c	2008-07-10 09:52:36.000000000 -0700
@@ -16,6 +16,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/hardirq.h>
+#include <linux/dmar.h>
 
 #include <asm/smp.h>
 #include <asm/ipi.h>
Index: tree-x86/arch/x86/kernel/setup.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/setup.c	2008-07-10 09:51:44.000000000 -0700
+++ tree-x86/arch/x86/kernel/setup.c	2008-07-10 09:52:36.000000000 -0700
@@ -729,6 +729,8 @@
 	num_physpages = max_pfn;
 
 	check_efer();
+ 	if (cpu_has_x2apic)
+ 		check_x2apic();
 
 	/* How many end-of-memory variables you have, grandma! */
 	/* need this before calling reserve_initrd */
Index: tree-x86/arch/x86/kernel/smpboot.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/smpboot.c	2008-07-10 09:52:14.000000000 -0700
+++ tree-x86/arch/x86/kernel/smpboot.c	2008-07-10 09:52:36.000000000 -0700
@@ -1145,6 +1145,11 @@
 	current_thread_info()->cpu = 0;  /* needed? */
 	set_cpu_sibling_map(0);
 
+#ifdef CONFIG_X86_64
+	enable_IR_x2apic();
+	setup_apic_routing();
+#endif
+
 	if (smp_sanity_check(max_cpus) < 0) {
 		printk(KERN_INFO "SMP disabled\n");
 		disable_smp();
Index: tree-x86/arch/x86/kernel/acpi/boot.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/acpi/boot.c	2008-07-10 09:51:44.000000000 -0700
+++ tree-x86/arch/x86/kernel/acpi/boot.c	2008-07-10 09:52:36.000000000 -0700
@@ -1347,7 +1347,9 @@
 				acpi_ioapic = 1;
 
 				smp_found_config = 1;
+#ifdef CONFIG_X86_32
 				setup_apic_routing();
+#endif
 			}
 		}
 		if (error == -EINVAL) {
Index: tree-x86/arch/x86/kernel/cpu/common_64.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/cpu/common_64.c	2008-07-10 09:51:44.000000000 -0700
+++ tree-x86/arch/x86/kernel/cpu/common_64.c	2008-07-10 09:52:36.000000000 -0700
@@ -603,6 +603,8 @@
 	barrier();
 
 	check_efer();
+	if (cpu != 0 && x2apic)
+		enable_x2apic();
 
 	/*
 	 * set up and load the per-CPU TSS
Index: tree-x86/arch/x86/kernel/mpparse.c
===================================================================
--- tree-x86.orig/arch/x86/kernel/mpparse.c	2008-07-10 09:51:44.000000000 -0700
+++ tree-x86/arch/x86/kernel/mpparse.c	2008-07-10 09:52:36.000000000 -0700
@@ -545,7 +545,9 @@
        generic_bigsmp_probe();
 #endif
 
+#ifdef CONFIG_X86_32
 	setup_apic_routing();
+#endif
 	if (!num_processors)
 		printk(KERN_ERR "MPTABLE: no processors registered!\n");
 	return num_processors;
Index: tree-x86/Documentation/kernel-parameters.txt
===================================================================
--- tree-x86.orig/Documentation/kernel-parameters.txt	2008-07-10 09:51:44.000000000 -0700
+++ tree-x86/Documentation/kernel-parameters.txt	2008-07-10 09:52:36.000000000 -0700
@@ -1377,6 +1377,8 @@
 
 	nolapic_timer	[X86-32,APIC] Do not use the local APIC timer.
 
+	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
+
 	noltlbs		[PPC] Do not use large page/tlb entries for kernel
 			lowmem mapping on PPC40x.
 
Index: tree-x86/include/asm-x86/apic.h
===================================================================
--- tree-x86.orig/include/asm-x86/apic.h	2008-07-10 09:52:31.000000000 -0700
+++ tree-x86/include/asm-x86/apic.h	2008-07-10 09:52:36.000000000 -0700
@@ -100,6 +100,11 @@
 extern u32 safe_apic_wait_icr_idle(void);
 extern void apic_icr_write(u32 low, u32 id);
 #else
+extern int x2apic, x2apic_preenabled;
+extern void check_x2apic(void);
+extern void enable_x2apic(void);
+extern void enable_IR_x2apic(void);
+extern void x2apic_icr_write(u32 low, u32 id);
 
 struct apic_ops {
 	u32 (*read)(u32 reg);

-- 

