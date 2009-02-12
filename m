Return-Path: <linux-kernel-owner+w=401wt.eu-S1761450AbZBLMxf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761450AbZBLMxf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:53:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759365AbZBLMuo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:50:44 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54471 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759216AbZBLMum (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:50:42 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <20090212149.227733077@firstfloor.org>
In-Reply-To: <20090212149.227733077@firstfloor.org>
To: akpm@linux-foundation.org, mingo@elte.hu, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: [PATCH] [7/9] x86: CMCI: Add CMCI support
Message-Id: <20090212124936.5B9F73E666F@basil.firstfloor.org>
Date: Thu, 12 Feb 2009 13:49:36 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Intel CMCI (Corrected Machine Check Interrupt) is a new
feature on Nehalem CPUs. It allows the CPU to trigger
interrupts on corrected events, which allows faster
reaction to them instead of with the traditional 
polling timer.

Also use CMCI to discover shared banks. Machine check banks
can be shared by CPU threads or even cores. Using the CMCI enable
bit it is possible to detect the fact that another CPU already
saw a specific bank. Use this to assign shared banks only
to one CPU to avoid reporting duplicated events.

On CPU hot unplug bank sharing is re discovered. This is done
using a thread that cycles through all the CPUs.

To avoid races between the poller and CMCI we only poll
for banks that are not CMCI capable and only check CMCI 
owned banks on a interrupt. 

The shared banks ownership information is currently only used for
CMCI interrupts, not polled banks.

The sharing discovery code follows the algorithm recommended in the 
IA32 SDM Vol3a 14.5.2.1

The CMCI interrupt handler just calls the machine check poller to 
pick up the machine check event that caused the interrupt.

I decided not to implement a separate threshold event like
the AMD version has, because the threshold is always one currently
and adding another event didn't seem to add any value.

Some code inspired by Yunhong Jiang's Xen implementation,
which was in term inspired by a earlier CMCI implementation
by me.

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 arch/x86/include/asm/mce.h                |   10 +
 arch/x86/kernel/cpu/mcheck/mce_64.c       |   16 +-
 arch/x86/kernel/cpu/mcheck/mce_intel_64.c |  205 ++++++++++++++++++++++++++++++
 3 files changed, 228 insertions(+), 3 deletions(-)

Index: linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_intel_64.c	2009-02-12 12:10:16.000000000 +0100
@@ -1,6 +1,8 @@
 /*
  * Intel specific MCE features.
  * Copyright 2004 Zwane Mwaikambo <zwane@linuxpower.ca>
+ * Copyright (C) 2008, 2009 Intel Corporation
+ * Author: Andi Kleen
  */
 
 #include <linux/init.h>
@@ -12,6 +14,7 @@
 #include <asm/hw_irq.h>
 #include <asm/idle.h>
 #include <asm/therm_throt.h>
+#include <asm/apic.h>
 
 asmlinkage void smp_thermal_interrupt(void)
 {
@@ -84,7 +87,209 @@
 	return;
 }
 
+/*
+ * Support for Intel Correct Machine Check Interrupts. This allows
+ * the CPU to raise an interrupt when a corrected machine check happened.
+ * Normally we pick those up using a regular polling timer.
+ * Also supports reliable discovery of shared banks.
+ */
+
+static DEFINE_PER_CPU(mce_banks_t, mce_banks_owned);
+
+/*
+ * cmci_discover_lock protects against parallel discovery attempts
+ * which could race against each other.
+ */
+static DEFINE_SPINLOCK(cmci_discover_lock);
+
+#define CMCI_THRESHOLD 1
+
+static __cpuinit int cmci_supported(int *banks)
+{
+	u64 cap;
+
+	/*
+	 * Vendor check is not strictly needed, but the initial
+	 * initialization is vendor keyed and this
+	 * makes sure none of the backdoors are entered otherwise.
+	 */
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_INTEL)
+		return 0;
+	if (!cpu_has_apic || lapic_get_maxlvt() < 6)
+		return 0;
+	rdmsrl(MSR_IA32_MCG_CAP, cap);
+	*banks = min_t(unsigned, MAX_NR_BANKS, cap & 0xff);
+	return !!(cap & MCG_CMCI_P);
+}
+
+/*
+ * The interrupt handler. This is called on every event.
+ * Just call the poller directly to log any events.
+ * This could in theory increase the threshold under high load,
+ * but doesn't for now.
+ */
+static void intel_threshold_interrupt(void)
+{
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	mce_notify_user();
+}
+
+static void print_update(char *type, int *hdr, int num)
+{
+	if (*hdr == 0)
+		printk(KERN_INFO "CPU %d MCA banks", smp_processor_id());
+	*hdr = 1;
+	printk(KERN_CONT " %s:%d", type, num);
+}
+
+/*
+ * Enable CMCI (Corrected Machine Check Interrupt) for available MCE banks
+ * on this CPU. Use the algorithm recommended in the SDM to discover shared
+ * banks.
+ */
+static __cpuinit void cmci_discover(int banks, int boot)
+{
+	unsigned long *owned = (void *)&__get_cpu_var(mce_banks_owned);
+	int hdr = 0;
+	int i;
+
+	spin_lock(&cmci_discover_lock);
+	for (i = 0; i < banks; i++) {
+		u64 val;
+
+		if (test_bit(i, owned))
+			continue;
+
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+
+		/* Already owned by someone else? */
+		if (val & CMCI_EN) {
+			if (test_and_clear_bit(i, owned) || boot)
+				print_update("SHD", &hdr, i);
+			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+			continue;
+		}
+
+		val |= CMCI_EN | CMCI_THRESHOLD;
+		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+
+		/* Did the enable bit stick? -- the bank supports CMCI */
+		if (val & CMCI_EN) {
+			if (!test_and_set_bit(i, owned) || boot)
+				print_update("CMCI", &hdr, i);
+			__clear_bit(i, __get_cpu_var(mce_poll_banks));
+		} else {
+			WARN_ON(!test_bit(i, __get_cpu_var(mce_poll_banks)));
+		}
+	}
+	spin_unlock(&cmci_discover_lock);
+	if (hdr)
+		printk(KERN_CONT "\n");
+}
+
+/*
+ * Just in case we missed an event during initialization check
+ * all the CMCI owned banks.
+ */
+__cpuinit void cmci_recheck(void)
+{
+	unsigned long flags;
+	int banks;
+
+	if (!mce_available(&current_cpu_data) || !cmci_supported(&banks))
+		return;
+	local_irq_save(flags);
+	machine_check_poll(MCP_TIMESTAMP, &__get_cpu_var(mce_banks_owned));
+	local_irq_restore(flags);
+}
+
+/*
+ * Disable CMCI on this CPU for all banks it owns when it goes down.
+ * This allows other CPUs to claim the banks on rediscovery.
+ */
+void __cpuexit cmci_clear(void)
+{
+	int i;
+	int banks;
+	u64 val;
+
+	if (!cmci_supported(&banks))
+		return;
+	spin_lock(&cmci_discover_lock);
+	for (i = 0; i < banks; i++) {
+		if (!test_bit(i, __get_cpu_var(mce_banks_owned)))
+			continue;
+		/* Disable CMCI */
+		rdmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		val &= ~(CMCI_EN|CMCI_THRESHOLD_MASK);
+		wrmsrl(MSR_IA32_MC0_CTL2 + i, val);
+		__clear_bit(i, __get_cpu_var(mce_banks_owned));
+	}
+	spin_unlock(&cmci_discover_lock);
+}
+
+/*
+ * After a CPU went down cycle through all the others and rediscover
+ * Must run in process context.
+ */
+void __cpuexit cmci_rediscover(int dying)
+{
+	int banks;
+	int cpu;
+	cpumask_var_t old;
+
+	if (!cmci_supported(&banks))
+		return;
+	if (!alloc_cpumask_var(&old, GFP_KERNEL))
+		return;
+	cpumask_copy(old, &current->cpus_allowed);
+
+	for_each_online_cpu (cpu) {
+		if (cpu == dying)
+			continue;
+		if (set_cpus_allowed_ptr(current, &cpumask_of_cpu(cpu)))
+			continue;
+		/* Recheck banks in case CPUs don't all have the same */
+		if (cmci_supported(&banks))
+			cmci_discover(banks, 0);
+	}
+
+	set_cpus_allowed_ptr(current, old);
+	free_cpumask_var(old);
+}
+
+/*
+ * Reenable CMCI on this CPU in case a CPU down failed.
+ */
+void cmci_reenable(void)
+{
+	int banks;
+	if (cmci_supported(&banks))
+		cmci_discover(banks, 0);
+}
+
+static __cpuinit void intel_init_cmci(void)
+{
+	int banks;
+
+	if (!cmci_supported(&banks))
+		return;
+
+	mce_threshold_vector = intel_threshold_interrupt;
+	cmci_discover(banks, 1);
+	/*
+	 * For CPU #0 this runs with still disabled APIC, but that's
+	 * ok because only the vector is set up. We still do another
+	 * check for the banks later for CPU #0 just to make sure
+	 * to not miss any events.
+	 */
+	apic_write(APIC_LVTCMCI, THRESHOLD_APIC_VECTOR|APIC_DM_FIXED);
+	cmci_recheck();
+}
+
 void __cpuinit mce_intel_feature_init(struct cpuinfo_x86 *c)
 {
 	intel_init_thermal(c);
+	intel_init_cmci();
 }
Index: linux/arch/x86/include/asm/mce.h
===================================================================
--- linux.orig/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/include/asm/mce.h	2009-02-12 11:30:51.000000000 +0100
@@ -105,8 +105,16 @@
 
 #ifdef CONFIG_X86_MCE_INTEL
 void mce_intel_feature_init(struct cpuinfo_x86 *c);
+void cmci_clear(void);
+void cmci_reenable(void);
+void cmci_rediscover(int dying);
+void cmci_recheck(void);
 #else
 static inline void mce_intel_feature_init(struct cpuinfo_x86 *c) { }
+static inline void cmci_clear(void) {}
+static inline void cmci_reenable(void) {}
+static inline void cmci_rediscover(int dying) {}
+static inline void cmci_recheck(void) {}
 #endif
 
 #ifdef CONFIG_X86_MCE_AMD
@@ -115,6 +123,8 @@
 static inline void mce_amd_feature_init(struct cpuinfo_x86 *c) { }
 #endif
 
+extern int mce_available(struct cpuinfo_x86 *c);
+
 void mce_log_therm_throt_event(__u64 status);
 
 extern atomic_t mce_entry;
Index: linux/arch/x86/kernel/cpu/mcheck/mce_64.c
===================================================================
--- linux.orig/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 11:30:51.000000000 +0100
+++ linux/arch/x86/kernel/cpu/mcheck/mce_64.c	2009-02-12 12:10:16.000000000 +0100
@@ -166,7 +166,7 @@
 	panic(msg);
 }
 
-static int mce_available(struct cpuinfo_x86 *c)
+int mce_available(struct cpuinfo_x86 *c)
 {
 	if (mce_dont_init)
 		return 0;
@@ -1052,9 +1052,12 @@
 static void __cpuexit mce_disable_cpu(void *h)
 {
 	int i;
+	unsigned long action = *(unsigned long *)h;
 
 	if (!mce_available(&current_cpu_data))
 		return;
+	if (!(action & CPU_TASKS_FROZEN))
+		cmci_clear();
 	for (i = 0; i < banks; i++)
 		wrmsrl(MSR_IA32_MC0_CTL + i*4, 0);
 }
@@ -1062,9 +1065,12 @@
 static void __cpuexit mce_reenable_cpu(void *h)
 {
 	int i;
+	unsigned long action = *(unsigned long *)h;
 
 	if (!mce_available(&current_cpu_data))
 		return;
+	if (!(action & CPU_TASKS_FROZEN))
+		cmci_reenable();
 	for (i = 0; i < banks; i++)
 		wrmsrl(MSR_IA32_MC0_CTL + i*4, bank[i]);
 }
@@ -1092,13 +1098,17 @@
 	case CPU_DOWN_PREPARE:
 	case CPU_DOWN_PREPARE_FROZEN:
 		del_timer_sync(t);
-		smp_call_function_single(cpu, mce_disable_cpu, NULL, 1);
+		smp_call_function_single(cpu, mce_disable_cpu, &action, 1);
 		break;
 	case CPU_DOWN_FAILED:
 	case CPU_DOWN_FAILED_FROZEN:
 		t->expires = round_jiffies_relative(jiffies + next_interval);
 		add_timer_on(t, cpu);
-		smp_call_function_single(cpu, mce_reenable_cpu, NULL, 1);
+		smp_call_function_single(cpu, mce_reenable_cpu, &action, 1);
+		break;
+	case CPU_POST_DEAD:
+		/* intentionally ignoring frozen here */
+		cmci_rediscover(cpu);
 		break;
 	}
 	return NOTIFY_OK;
