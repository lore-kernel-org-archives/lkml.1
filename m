Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbXLQSzU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbXLQSzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:55:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXLQSzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:55:09 -0500
Received: from smtp-out.google.com ([216.239.33.17]:45614 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbXLQSzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:55:07 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:to:subject:message-id:date:from;
	b=GWifyJyiNM6xpT4MPPIJ2GTMtcCUxLxDcmL/ff+nm28GLZfkrsMbpAgqZcUwYQpGE
	x0Fnr2jrMKGyBFr5HfPAw==
To: linux-kernel@vger.kernel.org
Subject: [PATCH] AMD Thermal Interrupt Support
Message-Id: <20071217185453.C4597CC562@localhost>
Date: Mon, 17 Dec 2007 10:54:53 -0800 (PST)
From: rml@google.com (Russell Leidich)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch to 2.6.24-rc5 enables AMD Barcelona CPUs to register thermal throttling events as machine checks, in the
same fashion as the analogous Intel code.

Changed files:

arch/x86/kernel/cpu/mcheck/Makefile
arch/x86/kernel/cpu/mcheck/mce_amd_64.c
arch/x86/kernel/cpu/mcheck/mce_intel_64.c
include/asm-x86/mce.h

New files:

arch/x86/kernel/cpu/mcheck/mce_thermal.c

Signed-off-by Russell Leidich <rml@google.com>
--
Russell Leidich

diff -uprN linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/Makefile linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/Makefile
--- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/Makefile	2007-12-11 14:30:53.533297000 -0800
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/Makefile	2007-12-11 11:56:20.549185000 -0800
@@ -1,4 +1,4 @@
-obj-y				=  mce_$(BITS).o therm_throt.o
+obj-y				=  mce_$(BITS).o therm_throt.o mce_thermal.o
 
 obj-$(CONFIG_X86_32)		+= k7.o p4.o p5.o p6.o winchip.o
 obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel_64.o
diff -uprN linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_amd_64.c
--- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2007-12-11 14:30:53.559298000 -0800
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_amd_64.c	2007-12-14 17:34:18.749040000 -0800
@@ -20,6 +20,8 @@
 #include <linux/interrupt.h>
 #include <linux/kobject.h>
 #include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pci_ids.h>
 #include <linux/sched.h>
 #include <linux/smp.h>
 #include <linux/sysdev.h>
@@ -29,6 +31,7 @@
 #include <asm/msr.h>
 #include <asm/percpu.h>
 #include <asm/idle.h>
+#include <asm/therm_throt.h>
 
 #define PFX               "mce_threshold: "
 #define VERSION           "version 1.1.1"
@@ -46,6 +49,19 @@
 #define MASK_ERR_COUNT_HI 0x00000FFF
 #define MASK_BLKPTR_LO    0xFF000000
 #define MCG_XBLK_ADDR     0xC0000400
+#define THERM_CTL_F3X64   0x64
+#define PSL_APIC_LO_EN    0x80
+#define PSL_APIC_HI_EN    0x40
+#define HTC_ACTIVE        0x10
+#define HTC_EN            1
+#define NB_PCI_DEV_BASE   0x18
+
+extern int num_k8_northbridges;
+extern struct pci_dev **k8_northbridges;
+
+static int smp_thermal_interrupt_init(void);
+static int thermal_apic_init_allowed;
+static void thermal_apic_init(void *unused);
 
 struct threshold_block {
 	unsigned int block;
@@ -644,20 +660,31 @@ static void threshold_remove_device(unsi
 }
 
 /* get notified when a cpu comes on/off */
-static int threshold_cpu_callback(struct notifier_block *nfb,
+static int amd_cpu_callback(struct notifier_block *nfb,
 					    unsigned long action, void *hcpu)
 {
 	/* cpu was unsigned int to begin with */
 	unsigned int cpu = (unsigned long)hcpu;
 
-	if (cpu >= NR_CPUS)
-		goto out;
-
 	switch (action) {
 	case CPU_ONLINE:
 	case CPU_ONLINE_FROZEN:
 		threshold_create_device(cpu);
-		break;
+		if (thermal_apic_init_allowed) {
+			/*
+			 * We need to run thermal_apic_init() on the core that
+			 * just came online.  If we're already on that core,
+			 * then directly run it.  Otherwise
+			 * smp_call_function_single() to that core.
+			 */
+			if (cpu == get_cpu())
+				thermal_apic_init(NULL);
+			else
+				smp_call_function_single(cpu,
+						&thermal_apic_init, NULL, 1, 0);
+			put_cpu();
+		}
+ 		break;
 	case CPU_DEAD:
 	case CPU_DEAD_FROZEN:
 		threshold_remove_device(cpu);
@@ -665,12 +692,11 @@ static int threshold_cpu_callback(struct
 	default:
 		break;
 	}
-      out:
 	return NOTIFY_OK;
 }
 
-static struct notifier_block threshold_cpu_notifier = {
-	.notifier_call = threshold_cpu_callback,
+static struct notifier_block amd_cpu_notifier = {
+	.notifier_call = amd_cpu_callback,
 };
 
 static __init int threshold_init_device(void)
@@ -683,8 +709,191 @@ static __init int threshold_init_device(
 		if (err)
 			return err;
 	}
-	register_hotcpu_notifier(&threshold_cpu_notifier);
+	register_hotcpu_notifier(&amd_cpu_notifier);
 	return 0;
 }
 
 device_initcall(threshold_init_device);
+
+/*
+ * AMD-specific thermal interrupt handler. 
+ */
+void amd_smp_thermal_interrupt(void)
+{
+	unsigned int cpu = smp_processor_id();
+
+	/*
+	 * We're here because thermal throttling has just been activated -- not
+	 * deactivated -- hence therm_throt_process(1).
+	 */
+	if (therm_throt_process(1))
+		mce_log_therm_throt_event(cpu, 1);
+	/*
+	 * We'll still get subsequent interrupts even if we don't clear the
+	 * status bit in THERM_CTL_F3X64.  Take advantage of this fact to avoid
+	 * touching PCI space.  (If this assumption fails at some point, we'll
+	 * need to schedule_work() in order to enter a process context, so that
+	 * PCI locks can be asserted for proper access.  This requirement, in
+	 * turn, creates the need to remember which core interrupted, as the
+	 * core which ultimately takes the scheduled work may be different.
+	 * With any luck, we'll never need to do this.)
+	 */
+}
+
+/*
+ * Initialize each northbridge's thermal throttling logic.
+ */
+static void smp_thermal_northbridge_init(void)
+{
+	int nb_num;
+	u32 therm_ctl_f3x64;
+
+	for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
+		/*
+		 * Configure the thermal interrupt for this northbridge.
+		 */
+		pci_read_config_dword(k8_northbridges[nb_num],
+					THERM_CTL_F3X64, &therm_ctl_f3x64);
+		therm_ctl_f3x64 |= PSL_APIC_HI_EN | HTC_EN;
+		therm_ctl_f3x64 &= (~PSL_APIC_LO_EN);
+		pci_write_config_dword(k8_northbridges[nb_num],
+					THERM_CTL_F3X64, therm_ctl_f3x64);
+		printk(KERN_INFO "Northbridge at PCI device 0x%x: "
+			"thermal monitoring enabled.\n", NB_PCI_DEV_BASE +
+									nb_num);
+	}
+}
+
+/*
+ * Enable the delivery of thermal interrupts via the local APIC.
+ */
+static void thermal_apic_init(void *unused) {
+	unsigned int apic_lv_therm;
+
+	/* Set up APIC_LVTTHMR to issue THERMAL_APIC_VECTOR. */
+	apic_lv_therm = apic_read(APIC_LVTTHMR);
+	/*
+	 * See if some agent other than this routine has already initialized
+	 * APIC_LVTTHMR, i.e. if it's unmasked, but not equal to the value that
+	 * we would have programmed, had we been here before on this core.
+	 */
+	if ((!(apic_lv_therm & APIC_LVT_MASKED)) && ((apic_lv_therm &
+		(APIC_MODE_MASK | APIC_VECTOR_MASK)) != (APIC_DM_FIXED |
+		THERMAL_APIC_VECTOR))) {
+		unsigned int cpu = smp_processor_id();
+
+		printk(KERN_CRIT "CPU 0x%x: Thermal monitoring not "
+			"functional.\n", cpu);
+		if ((apic_lv_therm & APIC_MODE_MASK) == APIC_DM_SMI)
+			printk(KERN_DEBUG "Thermal interrupts already "
+				"handled by SMI according to (((local APIC "
+				"base) + 0x330) bit 0x9).\n");
+		else
+			printk(KERN_DEBUG "Thermal interrupts unexpectedly "
+				"enabled at (((local APIC base) + 0x330) bit "
+				"0x10).\n");
+	} else {
+		/*
+		 * Configure the Local Thermal Vector Table Entry to issue
+		 * issue thermal interrupts to THERMAL_APIC_VECTOR.
+		 *
+		 * Start by masking off Delivery Mode and Vector.
+		 */
+		apic_lv_therm &= ~(APIC_MODE_MASK | APIC_VECTOR_MASK);
+		/* Fixed interrupt, masked for now. */
+		apic_lv_therm |= APIC_LVT_MASKED | APIC_DM_FIXED |
+							THERMAL_APIC_VECTOR;
+		apic_write(APIC_LVTTHMR, apic_lv_therm);
+		/*
+		 * The Intel thermal kernel code implies that there may be a
+		 * race involving the mask bit, so clear it only now, after
+		 * the other bits have settled.
+		 */
+		apic_write(APIC_LVTTHMR, apic_lv_therm & ~APIC_LVT_MASKED);
+	}
+}
+
+/*
+* This function is intended to be called just after thermal throttling has
+ * been enabled.  It warns the user if throttling is already active, which
+ * could indicate a failed cooling system.  It may be the last chance to get
+ * a warning out before thermal shutdown occurs.
+ */
+static void smp_thermal_early_throttle_check(void)
+{
+	int nb_num;
+	u32 therm_ctl_f3x64;
+
+	for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
+		/*
+		 * Read back THERM_CTL_F3X64 to check whther HTC_ACTIVE is
+		 * asserted, in which case, warn the user.
+		 */
+		pci_read_config_dword(k8_northbridges[nb_num],
+					THERM_CTL_F3X64, &therm_ctl_f3x64);
+		if (therm_ctl_f3x64 & HTC_ACTIVE)
+			printk(KERN_WARNING "High temperature on northbridge "
+				"at PCI device 0x%x.  Throttling enabled.\n",
+				NB_PCI_DEV_BASE + nb_num);
+	}
+}
+
+/*
+ * Determine whether or not the northbridges support thermal throttling
+ * interrupts.  If so, initialize them for receiving the same, then perform
+ * corresponding APIC initialization on each core.
+ */
+static int smp_thermal_interrupt_init(void)
+{
+	int nb_num;
+	int thermal_registers_functional;
+
+	/*
+	 * If there are no recognized northbridges, then we can't talk to the
+	 * thermal registers.
+ 	 */
+	thermal_registers_functional = num_k8_northbridges; 
+	/*
+	 * If any of the northbridges has PCI ID 0x1103, then its thermal
+	 * hardware suffers from an erratum which prevents this code from working,
+	 * so abort.
+	 */
+	for (nb_num = 0; nb_num < num_k8_northbridges; nb_num++) {
+		if ((k8_northbridges[nb_num]->device) == 0x1103) {
+			thermal_registers_functional = 0;
+			break;
+		}
+	}
+	if (thermal_registers_functional) {
+		/*
+		 * Assert that we should log thermal throttling events, whenever
+		 * we eventually get around to enabling them.
+		 */
+		atomic_set(&therm_throt_en, 1);
+		/*
+		 * Bind cpu_specific_smp_thermal_interrupt() to
+		 * amd_smp_thermal_interrupt().
+		 */
+		cpu_specific_smp_thermal_interrupt = amd_smp_thermal_interrupt;
+		smp_thermal_northbridge_init();
+		/*
+		 * We've now initialized sufficient fabric to permit the
+		 * initialization of the thermal interrupt APIC vectors, such as
+		 * when a core comes online and calls amd_cpu_callback().
+		 */
+		thermal_apic_init_allowed = 1;			
+		/*
+		 * Call thermal_apic_init() on each core.
+		 */
+		on_each_cpu(&thermal_apic_init, NULL, 1, 0);
+		smp_thermal_early_throttle_check();
+	}
+	return 0;
+}
+
+/*
+ * smp_thermal_interrupt_init cannot execute until PCI has been fully 
+ * initialized, hence late_initcall().
+ */
+late_initcall(smp_thermal_interrupt_init);
+
diff -uprN linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
--- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2007-12-11 14:30:53.564303000 -0800
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2007-12-13 12:31:55.311145000 -0800
@@ -13,21 +13,15 @@
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
 
-asmlinkage void smp_thermal_interrupt(void)
+void intel_smp_thermal_interrupt(void)
 {
 	__u64 msr_val;
 
-	ack_APIC_irq();
-
-	exit_idle();
-	irq_enter();
-
 	rdmsrl(MSR_IA32_THERM_STATUS, msr_val);
 	if (therm_throt_process(msr_val & 1))
 		mce_log_therm_throt_event(smp_processor_id(), msr_val);
 
 	add_pda(irq_thermal_count, 1);
-	irq_exit();
 }
 
 static void __cpuinit intel_init_thermal(struct cpuinfo_x86 *c)
@@ -75,6 +69,11 @@ static void __cpuinit intel_init_thermal
 	wrmsr(MSR_IA32_MISC_ENABLE, l | (1 << 3), h);
 
 	l = apic_read(APIC_LVTTHMR);
+        /*
+	 * Bind the cpu_specific_smp_thermal_interrupt trampoline to
+	 * intel_smp_thermal_interrupt.
+	 */
+	cpu_specific_smp_thermal_interrupt = intel_smp_thermal_interrupt;	
 	apic_write(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
 	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
 		cpu, tm2 ? "TM2" : "TM1");
diff -uprN linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/mce_thermal.c linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_thermal.c
--- linux-2.6.24-rc5.orig/arch/x86/kernel/cpu/mcheck/mce_thermal.c	1969-12-31 16:00:00.000000000 -0800
+++ linux-2.6.24-rc5/arch/x86/kernel/cpu/mcheck/mce_thermal.c	2007-12-13 12:26:13.057412000 -0800
@@ -0,0 +1,32 @@
+/*
+ * Copyright (c) 2007 Google Inc.
+ *
+ * Written by Mike Waychison <mikew@google.com> and Russell Leidich <rml@google.com>.
+ *
+ * CPU-independent thermal interrupt handler.
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include "mce.h"
+#include <asm/hw_irq.h>
+#include <asm/idle.h>
+
+static void default_smp_thermal_interrupt(void) {}
+
+cpu_specific_smp_thermal_interrupt_callback cpu_specific_smp_thermal_interrupt =
+						default_smp_thermal_interrupt;
+
+/*
+ * Wrapper for the CPU-specific thermal interrupt service routine.  Without
+ * this, we'd have to discern the CPU brand at runtime (because support could
+ * be installed for more than one).
+ */
+asmlinkage void smp_thermal_interrupt(void)
+{
+	ack_APIC_irq();
+	exit_idle();
+	irq_enter();
+	cpu_specific_smp_thermal_interrupt();
+	irq_exit();
+}
diff -uprN linux-2.6.24-rc5.orig/include/asm-x86/mce.h linux-2.6.24-rc5/include/asm-x86/mce.h
--- linux-2.6.24-rc5.orig/include/asm-x86/mce.h	2007-12-11 14:31:34.263515000 -0800
+++ linux-2.6.24-rc5/include/asm-x86/mce.h	2007-12-13 14:10:37.923970000 -0800
@@ -113,7 +113,10 @@ static inline void mce_amd_feature_init(
 #endif
 
 void mce_log_therm_throt_event(unsigned int cpu, __u64 status);
+typedef void (*cpu_specific_smp_thermal_interrupt_callback)(void);
 
+extern cpu_specific_smp_thermal_interrupt_callback
+                                       cpu_specific_smp_thermal_interrupt;
 extern atomic_t mce_entry;
 
 extern void do_machine_check(struct pt_regs *, long);
