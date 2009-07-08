Return-Path: <linux-kernel-owner+w=401wt.eu-S1759006AbZGHWcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759006AbZGHWcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 18:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757674AbZGHWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 18:31:47 -0400
Received: from one.firstfloor.org ([213.235.205.2]:47048 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758239AbZGHWbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 18:31:42 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <200907091231.681564770@firstfloor.org>
In-Reply-To: <200907091231.681564770@firstfloor.org>
To: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [PATCH] [3/8] x86: mce: Remove old i386 machine check code
Message-Id: <20090708223140.0F4711D035D@basil.firstfloor.org>
Date: Thu,  9 Jul 2009 00:31:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As announced in feature-remove-schedule.txt remove CONFIG_X86_OLD_MCE

This patch only removes code.

The ancient machine check code for very old systems that are not supported
by CONFIG_X86_NEW_MCE is still kept.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/feature-removal-schedule.txt |   10 -
 arch/x86/Kconfig                           |   35 ------
 arch/x86/include/asm/mce.h                 |   11 -
 arch/x86/kernel/cpu/mcheck/Makefile        |    2 
 arch/x86/kernel/cpu/mcheck/k7.c            |  116 --------------------
 arch/x86/kernel/cpu/mcheck/mce.c           |   47 --------
 arch/x86/kernel/cpu/mcheck/non-fatal.c     |   94 ----------------
 arch/x86/kernel/cpu/mcheck/p4.c            |  163 -----------------------------
 arch/x86/kernel/cpu/mcheck/p6.c            |  127 ----------------------
 9 files changed, 2 insertions(+), 603 deletions(-)

Index: linux/arch/x86/Kconfig
===================================================================
--- linux.orig/arch/x86/Kconfig
+++ linux/arch/x86/Kconfig
@@ -784,21 +784,10 @@ config X86_MCE
 	  The action the kernel takes depends on the severity of the problem,
 	  ranging from warning messages to halting the machine.
 
-config X86_OLD_MCE
-	depends on X86_32 && X86_MCE
-	bool "Use legacy machine check code (will go away)"
-	default n
-	select X86_ANCIENT_MCE
-	---help---
-	  Use the old i386 machine check code. This is merely intended for
-	  testing in a transition period. Try this if you run into any machine
-	  check related software problems, but report the problem to
-	  linux-kernel.  When in doubt say no.
-
 config X86_NEW_MCE
 	depends on X86_MCE
 	bool
-	default y if (!X86_OLD_MCE && X86_32) || X86_64
+	default y
 
 config X86_MCE_INTEL
 	def_bool y
@@ -838,29 +827,9 @@ config X86_MCE_INJECT
 	  If you don't know what a machine check is and you don't do kernel
 	  QA it is safe to say n.
 
-config X86_MCE_NONFATAL
-	tristate "Check for non-fatal errors on AMD Athlon/Duron / Intel Pentium 4"
-	depends on X86_OLD_MCE
-	---help---
-	  Enabling this feature starts a timer that triggers every 5 seconds which
-	  will look at the machine check registers to see if anything happened.
-	  Non-fatal problems automatically get corrected (but still logged).
-	  Disable this if you don't want to see these messages.
-	  Seeing the messages this option prints out may be indicative of dying
-	  or out-of-spec (ie, overclocked) hardware.
-	  This option only does something on certain CPUs.
-	  (AMD Athlon/Duron and Intel Pentium 4)
-
-config X86_MCE_P4THERMAL
-	bool "check for P4 thermal throttling interrupt."
-	depends on X86_OLD_MCE && X86_MCE && (X86_UP_APIC || SMP)
-	---help---
-	  Enabling this feature will cause a message to be printed when the P4
-	  enters thermal throttling.
-
 config X86_THERMAL_VECTOR
 	def_bool y
-	depends on X86_MCE_P4THERMAL || X86_MCE_INTEL
+	depends on X86_MCE_INTEL
 
 config VM86
 	bool "Enable VM86 support" if EMBEDDED
Index: linux/arch/x86/kernel/cpu/mcheck/Makefile
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/Makefile
+++ linux/arch/x86/kernel/cpu/mcheck/Makefile
@@ -1,11 +1,9 @@
 obj-y				=  mce.o
 
 obj-$(CONFIG_X86_NEW_MCE)	+= mce-severity.o
-obj-$(CONFIG_X86_OLD_MCE)	+= k7.o p4.o p6.o
 obj-$(CONFIG_X86_ANCIENT_MCE)	+= winchip.o p5.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_X86_MCE_AMD)	+= mce_amd.o
-obj-$(CONFIG_X86_MCE_NONFATAL)	+= non-fatal.o
 obj-$(CONFIG_X86_MCE_THRESHOLD) += threshold.o
 obj-$(CONFIG_X86_MCE_INJECT)	+= mce-inject.o
 
Index: linux/arch/x86/kernel/cpu/mcheck/mce.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce.c
+++ linux/arch/x86/kernel/cpu/mcheck/mce.c
@@ -58,8 +58,6 @@ void (*machine_check_vector)(struct pt_r
 
 int mce_disabled __read_mostly;
 
-#ifdef CONFIG_X86_NEW_MCE
-
 #define MISC_MCELOG_MINOR	227
 
 #define SPINUNIT 100	/* 100ns */
@@ -1993,51 +1991,6 @@ static __init int mce_init_device(void)
 
 device_initcall(mce_init_device);
 
-#else /* CONFIG_X86_OLD_MCE: */
-
-int nr_mce_banks;
-EXPORT_SYMBOL_GPL(nr_mce_banks);	/* non-fatal.o */
-
-/* This has to be run for each processor */
-void mcheck_init(struct cpuinfo_x86 *c)
-{
-	if (mce_disabled)
-		return;
-
-	switch (c->x86_vendor) {
-	case X86_VENDOR_AMD:
-		amd_mcheck_init(c);
-		break;
-
-	case X86_VENDOR_INTEL:
-		if (c->x86 == 5)
-			intel_p5_mcheck_init(c);
-		if (c->x86 == 6)
-			intel_p6_mcheck_init(c);
-		if (c->x86 == 15)
-			intel_p4_mcheck_init(c);
-		break;
-
-	case X86_VENDOR_CENTAUR:
-		if (c->x86 == 5)
-			winchip_mcheck_init(c);
-		break;
-
-	default:
-		break;
-	}
-	printk(KERN_INFO "mce: CPU supports %d MCE banks\n", nr_mce_banks);
-}
-
-static int __init mcheck_enable(char *str)
-{
-	mce_p5_enabled = 1;
-	return 1;
-}
-__setup("mce", mcheck_enable);
-
-#endif /* CONFIG_X86_OLD_MCE */
-
 /*
  * Old style boot options parsing. Only for compatibility.
  */
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h
+++ linux/arch/x86/include/asm/mce.h
@@ -115,13 +115,6 @@ void mcheck_init(struct cpuinfo_x86 *c);
 static inline void mcheck_init(struct cpuinfo_x86 *c) {}
 #endif
 
-#ifdef CONFIG_X86_OLD_MCE
-extern int nr_mce_banks;
-void amd_mcheck_init(struct cpuinfo_x86 *c);
-void intel_p4_mcheck_init(struct cpuinfo_x86 *c);
-void intel_p6_mcheck_init(struct cpuinfo_x86 *c);
-#endif
-
 #ifdef CONFIG_X86_ANCIENT_MCE
 void intel_p5_mcheck_init(struct cpuinfo_x86 *c);
 void winchip_mcheck_init(struct cpuinfo_x86 *c);
@@ -208,11 +201,7 @@ extern void (*threshold_cpu_callback)(un
 
 void intel_init_thermal(struct cpuinfo_x86 *c);
 
-#ifdef CONFIG_X86_NEW_MCE
 void mce_log_therm_throt_event(__u64 status);
-#else
-static inline void mce_log_therm_throt_event(__u64 status) {}
-#endif
 
 #endif /* __KERNEL__ */
 #endif /* _ASM_X86_MCE_H */
Index: linux/arch/x86/kernel/cpu/mcheck/k7.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/k7.c
+++ /dev/null
@@ -1,116 +0,0 @@
-/*
- * Athlon specific Machine Check Exception Reporting
- * (C) Copyright 2002 Dave Jones <davej@redhat.com>
- */
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/processor.h>
-#include <asm/system.h>
-#include <asm/mce.h>
-#include <asm/msr.h>
-
-/* Machine Check Handler For AMD Athlon/Duron: */
-static void k7_machine_check(struct pt_regs *regs, long error_code)
-{
-	u32 alow, ahigh, high, low;
-	u32 mcgstl, mcgsth;
-	int recover = 1;
-	int i;
-
-	rdmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
-	if (mcgstl & (1<<0))	/* Recoverable ? */
-		recover = 0;
-
-	printk(KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
-		smp_processor_id(), mcgsth, mcgstl);
-
-	for (i = 1; i < nr_mce_banks; i++) {
-		rdmsr(MSR_IA32_MC0_STATUS+i*4, low, high);
-		if (high & (1<<31)) {
-			char misc[20];
-			char addr[24];
-
-			misc[0] = '\0';
-			addr[0] = '\0';
-
-			if (high & (1<<29))
-				recover |= 1;
-			if (high & (1<<25))
-				recover |= 2;
-			high &= ~(1<<31);
-
-			if (high & (1<<27)) {
-				rdmsr(MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				snprintf(misc, 20, "[%08x%08x]", ahigh, alow);
-			}
-			if (high & (1<<26)) {
-				rdmsr(MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				snprintf(addr, 24, " at %08x%08x", ahigh, alow);
-			}
-
-			printk(KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
-				smp_processor_id(), i, high, low, misc, addr);
-
-			/* Clear it: */
-			wrmsr(MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
-			/* Serialize: */
-			wmb();
-			add_taint(TAINT_MACHINE_CHECK);
-		}
-	}
-
-	if (recover & 2)
-		panic("CPU context corrupt");
-	if (recover & 1)
-		panic("Unable to continue");
-
-	printk(KERN_EMERG "Attempting to continue.\n");
-
-	mcgstl &= ~(1<<2);
-	wrmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
-}
-
-
-/* AMD K7 machine check is Intel like: */
-void amd_mcheck_init(struct cpuinfo_x86 *c)
-{
-	u32 l, h;
-	int i;
-
-	if (!cpu_has(c, X86_FEATURE_MCE))
-		return;
-
-	machine_check_vector = k7_machine_check;
-	/* Make sure the vector pointer is visible before we enable MCEs: */
-	wmb();
-
-	printk(KERN_INFO "Intel machine check architecture supported.\n");
-
-	rdmsr(MSR_IA32_MCG_CAP, l, h);
-	if (l & (1<<8))	/* Control register present ? */
-		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
-	nr_mce_banks = l & 0xff;
-
-	/*
-	 * Clear status for MC index 0 separately, we don't touch CTL,
-	 * as some K7 Athlons cause spurious MCEs when its enabled:
-	 */
-	if (boot_cpu_data.x86 == 6) {
-		wrmsr(MSR_IA32_MC0_STATUS, 0x0, 0x0);
-		i = 1;
-	} else
-		i = 0;
-
-	for (; i < nr_mce_banks; i++) {
-		wrmsr(MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
-		wrmsr(MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
-	}
-
-	set_in_cr4(X86_CR4_MCE);
-	printk(KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
-		smp_processor_id());
-}
Index: linux/arch/x86/kernel/cpu/mcheck/p4.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/p4.c
+++ /dev/null
@@ -1,163 +0,0 @@
-/*
- * P4 specific Machine Check Exception Reporting
- */
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/processor.h>
-#include <asm/mce.h>
-#include <asm/msr.h>
-
-/* as supported by the P4/Xeon family */
-struct intel_mce_extended_msrs {
-	u32 eax;
-	u32 ebx;
-	u32 ecx;
-	u32 edx;
-	u32 esi;
-	u32 edi;
-	u32 ebp;
-	u32 esp;
-	u32 eflags;
-	u32 eip;
-	/* u32 *reserved[]; */
-};
-
-static int mce_num_extended_msrs;
-
-/* P4/Xeon Extended MCE MSR retrieval, return 0 if unsupported */
-static void intel_get_extended_msrs(struct intel_mce_extended_msrs *r)
-{
-	u32 h;
-
-	rdmsr(MSR_IA32_MCG_EAX, r->eax, h);
-	rdmsr(MSR_IA32_MCG_EBX, r->ebx, h);
-	rdmsr(MSR_IA32_MCG_ECX, r->ecx, h);
-	rdmsr(MSR_IA32_MCG_EDX, r->edx, h);
-	rdmsr(MSR_IA32_MCG_ESI, r->esi, h);
-	rdmsr(MSR_IA32_MCG_EDI, r->edi, h);
-	rdmsr(MSR_IA32_MCG_EBP, r->ebp, h);
-	rdmsr(MSR_IA32_MCG_ESP, r->esp, h);
-	rdmsr(MSR_IA32_MCG_EFLAGS, r->eflags, h);
-	rdmsr(MSR_IA32_MCG_EIP, r->eip, h);
-}
-
-static void intel_machine_check(struct pt_regs *regs, long error_code)
-{
-	u32 alow, ahigh, high, low;
-	u32 mcgstl, mcgsth;
-	int recover = 1;
-	int i;
-
-	rdmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
-	if (mcgstl & (1<<0))	/* Recoverable ? */
-		recover = 0;
-
-	printk(KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
-		smp_processor_id(), mcgsth, mcgstl);
-
-	if (mce_num_extended_msrs > 0) {
-		struct intel_mce_extended_msrs dbg;
-
-		intel_get_extended_msrs(&dbg);
-
-		printk(KERN_DEBUG "CPU %d: EIP: %08x EFLAGS: %08x\n"
-			"\teax: %08x ebx: %08x ecx: %08x edx: %08x\n"
-			"\tesi: %08x edi: %08x ebp: %08x esp: %08x\n",
-			smp_processor_id(), dbg.eip, dbg.eflags,
-			dbg.eax, dbg.ebx, dbg.ecx, dbg.edx,
-			dbg.esi, dbg.edi, dbg.ebp, dbg.esp);
-	}
-
-	for (i = 0; i < nr_mce_banks; i++) {
-		rdmsr(MSR_IA32_MC0_STATUS+i*4, low, high);
-		if (high & (1<<31)) {
-			char misc[20];
-			char addr[24];
-
-			misc[0] = addr[0] = '\0';
-			if (high & (1<<29))
-				recover |= 1;
-			if (high & (1<<25))
-				recover |= 2;
-			high &= ~(1<<31);
-			if (high & (1<<27)) {
-				rdmsr(MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				snprintf(misc, 20, "[%08x%08x]", ahigh, alow);
-			}
-			if (high & (1<<26)) {
-				rdmsr(MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				snprintf(addr, 24, " at %08x%08x", ahigh, alow);
-			}
-			printk(KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
-				smp_processor_id(), i, high, low, misc, addr);
-		}
-	}
-
-	if (recover & 2)
-		panic("CPU context corrupt");
-	if (recover & 1)
-		panic("Unable to continue");
-
-	printk(KERN_EMERG "Attempting to continue.\n");
-
-	/*
-	 * Do not clear the MSR_IA32_MCi_STATUS if the error is not
-	 * recoverable/continuable.This will allow BIOS to look at the MSRs
-	 * for errors if the OS could not log the error.
-	 */
-	for (i = 0; i < nr_mce_banks; i++) {
-		u32 msr;
-		msr = MSR_IA32_MC0_STATUS+i*4;
-		rdmsr(msr, low, high);
-		if (high&(1<<31)) {
-			/* Clear it */
-			wrmsr(msr, 0UL, 0UL);
-			/* Serialize */
-			wmb();
-			add_taint(TAINT_MACHINE_CHECK);
-		}
-	}
-	mcgstl &= ~(1<<2);
-	wrmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
-}
-
-void intel_p4_mcheck_init(struct cpuinfo_x86 *c)
-{
-	u32 l, h;
-	int i;
-
-	machine_check_vector = intel_machine_check;
-	wmb();
-
-	printk(KERN_INFO "Intel machine check architecture supported.\n");
-	rdmsr(MSR_IA32_MCG_CAP, l, h);
-	if (l & (1<<8))	/* Control register present ? */
-		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
-	nr_mce_banks = l & 0xff;
-
-	for (i = 0; i < nr_mce_banks; i++) {
-		wrmsr(MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
-		wrmsr(MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
-	}
-
-	set_in_cr4(X86_CR4_MCE);
-	printk(KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
-		smp_processor_id());
-
-	/* Check for P4/Xeon extended MCE MSRs */
-	rdmsr(MSR_IA32_MCG_CAP, l, h);
-	if (l & (1<<9))	{/* MCG_EXT_P */
-		mce_num_extended_msrs = (l >> 16) & 0xff;
-		printk(KERN_INFO "CPU%d: Intel P4/Xeon Extended MCE MSRs (%d)"
-				" available\n",
-			smp_processor_id(), mce_num_extended_msrs);
-
-#ifdef CONFIG_X86_MCE_P4THERMAL
-		/* Check for P4/Xeon Thermal monitor */
-		intel_init_thermal(c);
-#endif
-	}
-}
Index: linux/arch/x86/kernel/cpu/mcheck/p6.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/p6.c
+++ /dev/null
@@ -1,127 +0,0 @@
-/*
- * P6 specific Machine Check Exception Reporting
- * (C) Copyright 2002 Alan Cox <alan@lxorguk.ukuu.org.uk>
- */
-#include <linux/interrupt.h>
-#include <linux/kernel.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/processor.h>
-#include <asm/system.h>
-#include <asm/mce.h>
-#include <asm/msr.h>
-
-/* Machine Check Handler For PII/PIII */
-static void intel_machine_check(struct pt_regs *regs, long error_code)
-{
-	u32 alow, ahigh, high, low;
-	u32 mcgstl, mcgsth;
-	int recover = 1;
-	int i;
-
-	rdmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
-	if (mcgstl & (1<<0))	/* Recoverable ? */
-		recover = 0;
-
-	printk(KERN_EMERG "CPU %d: Machine Check Exception: %08x%08x\n",
-		smp_processor_id(), mcgsth, mcgstl);
-
-	for (i = 0; i < nr_mce_banks; i++) {
-		rdmsr(MSR_IA32_MC0_STATUS+i*4, low, high);
-		if (high & (1<<31)) {
-			char misc[20];
-			char addr[24];
-
-			misc[0] = '\0';
-			addr[0] = '\0';
-
-			if (high & (1<<29))
-				recover |= 1;
-			if (high & (1<<25))
-				recover |= 2;
-			high &= ~(1<<31);
-
-			if (high & (1<<27)) {
-				rdmsr(MSR_IA32_MC0_MISC+i*4, alow, ahigh);
-				snprintf(misc, 20, "[%08x%08x]", ahigh, alow);
-			}
-			if (high & (1<<26)) {
-				rdmsr(MSR_IA32_MC0_ADDR+i*4, alow, ahigh);
-				snprintf(addr, 24, " at %08x%08x", ahigh, alow);
-			}
-
-			printk(KERN_EMERG "CPU %d: Bank %d: %08x%08x%s%s\n",
-				smp_processor_id(), i, high, low, misc, addr);
-		}
-	}
-
-	if (recover & 2)
-		panic("CPU context corrupt");
-	if (recover & 1)
-		panic("Unable to continue");
-
-	printk(KERN_EMERG "Attempting to continue.\n");
-	/*
-	 * Do not clear the MSR_IA32_MCi_STATUS if the error is not
-	 * recoverable/continuable.This will allow BIOS to look at the MSRs
-	 * for errors if the OS could not log the error:
-	 */
-	for (i = 0; i < nr_mce_banks; i++) {
-		unsigned int msr;
-
-		msr = MSR_IA32_MC0_STATUS+i*4;
-		rdmsr(msr, low, high);
-		if (high & (1<<31)) {
-			/* Clear it: */
-			wrmsr(msr, 0UL, 0UL);
-			/* Serialize: */
-			wmb();
-			add_taint(TAINT_MACHINE_CHECK);
-		}
-	}
-	mcgstl &= ~(1<<2);
-	wrmsr(MSR_IA32_MCG_STATUS, mcgstl, mcgsth);
-}
-
-/* Set up machine check reporting for processors with Intel style MCE: */
-void intel_p6_mcheck_init(struct cpuinfo_x86 *c)
-{
-	u32 l, h;
-	int i;
-
-	/* Check for MCE support */
-	if (!cpu_has(c, X86_FEATURE_MCE))
-		return;
-
-	/* Check for PPro style MCA */
-	if (!cpu_has(c, X86_FEATURE_MCA))
-		return;
-
-	/* Ok machine check is available */
-	machine_check_vector = intel_machine_check;
-	/* Make sure the vector pointer is visible before we enable MCEs: */
-	wmb();
-
-	printk(KERN_INFO "Intel machine check architecture supported.\n");
-	rdmsr(MSR_IA32_MCG_CAP, l, h);
-	if (l & (1<<8))	/* Control register present ? */
-		wrmsr(MSR_IA32_MCG_CTL, 0xffffffff, 0xffffffff);
-	nr_mce_banks = l & 0xff;
-
-	/*
-	 * Following the example in IA-32 SDM Vol 3:
-	 * - MC0_CTL should not be written
-	 * - Status registers on all banks should be cleared on reset
-	 */
-	for (i = 1; i < nr_mce_banks; i++)
-		wrmsr(MSR_IA32_MC0_CTL+4*i, 0xffffffff, 0xffffffff);
-
-	for (i = 0; i < nr_mce_banks; i++)
-		wrmsr(MSR_IA32_MC0_STATUS+4*i, 0x0, 0x0);
-
-	set_in_cr4(X86_CR4_MCE);
-	printk(KERN_INFO "Intel machine check reporting enabled on CPU#%d.\n",
-		smp_processor_id());
-}
Index: linux/arch/x86/kernel/cpu/mcheck/non-fatal.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/non-fatal.c
+++ /dev/null
@@ -1,94 +0,0 @@
-/*
- * Non Fatal Machine Check Exception Reporting
- *
- * (C) Copyright 2002 Dave Jones. <davej@redhat.com>
- *
- * This file contains routines to check for non-fatal MCEs every 15s
- *
- */
-#include <linux/interrupt.h>
-#include <linux/workqueue.h>
-#include <linux/jiffies.h>
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/types.h>
-#include <linux/init.h>
-#include <linux/smp.h>
-
-#include <asm/processor.h>
-#include <asm/system.h>
-#include <asm/mce.h>
-#include <asm/msr.h>
-
-static int		firstbank;
-
-#define MCE_RATE	(15*HZ)	/* timer rate is 15s */
-
-static void mce_checkregs(void *info)
-{
-	u32 low, high;
-	int i;
-
-	for (i = firstbank; i < nr_mce_banks; i++) {
-		rdmsr(MSR_IA32_MC0_STATUS+i*4, low, high);
-
-		if (!(high & (1<<31)))
-			continue;
-
-		printk(KERN_INFO "MCE: The hardware reports a non fatal, "
-			"correctable incident occurred on CPU %d.\n",
-				smp_processor_id());
-
-		printk(KERN_INFO "Bank %d: %08x%08x\n", i, high, low);
-
-		/*
-		 * Scrub the error so we don't pick it up in MCE_RATE
-		 * seconds time:
-		 */
-		wrmsr(MSR_IA32_MC0_STATUS+i*4, 0UL, 0UL);
-
-		/* Serialize: */
-		wmb();
-		add_taint(TAINT_MACHINE_CHECK);
-	}
-}
-
-static void mce_work_fn(struct work_struct *work);
-static DECLARE_DELAYED_WORK(mce_work, mce_work_fn);
-
-static void mce_work_fn(struct work_struct *work)
-{
-	on_each_cpu(mce_checkregs, NULL, 1);
-	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
-}
-
-static int __init init_nonfatal_mce_checker(void)
-{
-	struct cpuinfo_x86 *c = &boot_cpu_data;
-
-	/* Check for MCE support */
-	if (!cpu_has(c, X86_FEATURE_MCE))
-		return -ENODEV;
-
-	/* Check for PPro style MCA */
-	if (!cpu_has(c, X86_FEATURE_MCA))
-		return -ENODEV;
-
-	/* Some Athlons misbehave when we frob bank 0 */
-	if (boot_cpu_data.x86_vendor == X86_VENDOR_AMD &&
-						boot_cpu_data.x86 == 6)
-		firstbank = 1;
-	else
-		firstbank = 0;
-
-	/*
-	 * Check for non-fatal errors every MCE_RATE s
-	 */
-	schedule_delayed_work(&mce_work, round_jiffies_relative(MCE_RATE));
-	printk(KERN_INFO "Machine check exception polling timer started.\n");
-
-	return 0;
-}
-module_init(init_nonfatal_mce_checker);
-
-MODULE_LICENSE("GPL");
Index: linux/Documentation/feature-removal-schedule.txt
===================================================================
--- linux.orig/Documentation/feature-removal-schedule.txt
+++ linux/Documentation/feature-removal-schedule.txt
@@ -448,13 +448,3 @@ What:	CONFIG_RFKILL_INPUT
 When:	2.6.33
 Why:	Should be implemented in userspace, policy daemon.
 Who:	Johannes Berg <johannes@sipsolutions.net>
-
-----------------------------
-
-What:	CONFIG_X86_OLD_MCE
-When:	2.6.32
-Why:	Remove the old legacy 32bit machine check code. This has been
-	superseded by the newer machine check code from the 64bit port,
-	but the old version has been kept around for easier testing. Note this
-	doesn't impact the old P5 and WinChip machine check handlers.
-Who:	Andi Kleen <andi@firstfloor.org>
