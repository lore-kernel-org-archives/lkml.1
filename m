Return-Path: <linux-kernel-owner+w=401wt.eu-S1751714AbZHSAba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbZHSAba (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZHSAb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:31:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:24717 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511AbZHSAb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:31:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,405,1246863600"; 
   d="scan'208";a="718316869"
Subject: [patch] x86: Rendezvous all the cpu's for MTRR/PAT init
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 18 Aug 2009 17:30:35 -0700
Message-Id: <1250641835.2744.56.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please consider applying this patch after the clockevents bugfix posted
yesterday http://marc.info/?l=linux-kernel&m=125054497316006&w=2

thanks,
suresh
---

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: Rendezvous all the cpu's for MTRR/PAT init

SDM Vol 3a section titled "MTRR considerations in MP systems" specifies
the need for synchronizing the logical cpu's while initializing/updating
MTRR.

Currently Linux kernel does the synchronization of all cpu's only when
a single MTRR register is programmed/updated. During an AP online
(during boot/cpu-online/resume)  where we initialize all the MTRR/PAT registers,
we don't follow this synchronization algorithm.

This can lead to scenarios where during a dynamic cpu online, that logical cpu
is initializing MTRR/PAT with cache disabled (cr0.cd=1) etc while other logical
HT sibling continue to run (also with cache disabled because of cr0.cd=1
on its sibling).

Starting from Westmere, VMX transitions with cr0.cd=1 don't work properly
(because of some VMX performance optimizations) and the above scenario
(with one logical cpu doing VMX activity and another logical cpu coming online)
can result in system crash.

Fix the MTRR initialization by doing rendezvous of all the cpus. During
boot and resume, we delay the MTRR/PAT init for APs till all the
logical cpu's come online and the rendezvous process at the end of AP's bringup,
will initialize the MTRR/PAT for all AP's.

For dynamic single cpu online, we synchronize all the logical cpus and
do the MTRR/PAT init on the AP that is coming online.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

Index: tip/arch/x86/include/asm/mtrr.h
===================================================================
--- tip.orig/arch/x86/include/asm/mtrr.h
+++ tip/arch/x86/include/asm/mtrr.h
@@ -121,8 +121,12 @@ extern int mtrr_del_page(int reg, unsign
 extern void mtrr_centaur_report_mcr(int mcr, u32 lo, u32 hi);
 extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
+extern void set_mtrr_aps_delayed_init(void);
+extern void mtrr_aps_init(void);
+extern void mtrr_bp_restore(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 extern int amd_special_default_mtrr(void);
+extern u32 mtrr_aps_delayed_init;
 #  else
 static inline u8 mtrr_type_lookup(u64 addr, u64 end)
 {
@@ -161,6 +165,9 @@ static inline void mtrr_centaur_report_m
 
 #define mtrr_ap_init() do {} while (0)
 #define mtrr_bp_init() do {} while (0)
+#define set_mtrr_aps_delayed_init() do {} while (0)
+#define mtrr_aps_init() do {} while (0)
+#define mtrr_bp_restore() do {} while (0)
 #  endif
 
 #ifdef CONFIG_COMPAT
Index: tip/arch/x86/kernel/cpu/common.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/common.c
+++ tip/arch/x86/kernel/cpu/common.c
@@ -880,7 +880,12 @@ void __cpuinit identify_secondary_cpu(st
 #ifdef CONFIG_X86_32
 	enable_sep_cpu();
 #endif
+	/*
+	 * mtrr_ap_init() uses smp_call_function. Enable interrupts.
+	 */
+	local_irq_enable();
 	mtrr_ap_init();
+	local_irq_disable();
 }
 
 struct msr_range {
Index: tip/arch/x86/kernel/cpu/mtrr/main.c
===================================================================
--- tip.orig/arch/x86/kernel/cpu/mtrr/main.c
+++ tip/arch/x86/kernel/cpu/mtrr/main.c
@@ -58,6 +58,7 @@ unsigned int mtrr_usage_table[MTRR_MAX_V
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
+u32 mtrr_aps_delayed_init;
 
 static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
 
@@ -163,7 +164,10 @@ static void ipi_handler(void *info)
 	if (data->smp_reg != ~0U) {
 		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
-	} else {
+	} else if (mtrr_aps_delayed_init) {
+		/*
+		 * Initialize the MTRRs inaddition to the synchronisation.
+		 */
 		mtrr_if->set_all();
 	}
 
@@ -265,6 +269,8 @@ set_mtrr(unsigned int reg, unsigned long
 	 */
 	if (reg != ~0U)
 		mtrr_if->set(reg, base, size, type);
+	else if (!mtrr_aps_delayed_init)
+		mtrr_if->set_all();
 
 	/* Wait for the others */
 	while (atomic_read(&data.count))
@@ -721,9 +727,7 @@ void __init mtrr_bp_init(void)
 
 void mtrr_ap_init(void)
 {
-	unsigned long flags;
-
-	if (!mtrr_if || !use_intel())
+	if (!use_intel() || mtrr_aps_delayed_init)
 		return;
 	/*
 	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
@@ -738,11 +742,7 @@ void mtrr_ap_init(void)
 	 *   2. cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug
 	 *      lock to prevent mtrr entry changes
 	 */
-	local_irq_save(flags);
-
-	mtrr_if->set_all();
-
-	local_irq_restore(flags);
+	set_mtrr(~0U, 0, 0, 0);
 }
 
 /**
@@ -753,6 +753,42 @@ void mtrr_save_state(void)
 	smp_call_function_single(0, mtrr_save_fixed_ranges, NULL, 1);
 }
 
+void set_mtrr_aps_delayed_init(void)
+{
+	if (!use_intel())
+		return;
+
+	mtrr_aps_delayed_init = 1;
+}
+
+/*
+ * MTRR initialization for all AP's
+ */
+void mtrr_aps_init(void)
+{
+	if (!use_intel())
+		return;
+
+	/*
+	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries changed,
+	 * but this routine will be called in cpu boot time, holding the lock
+	 * breaks it. This routine is called in two cases: 1.very earily time
+	 * of software resume, when there absolutely isn't mtrr entry changes;
+	 * 2.cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug lock to
+	 * prevent mtrr entry changes
+	 */
+	set_mtrr(~0U, 0, 0, 0);
+	mtrr_aps_delayed_init = 0;
+}
+
+void mtrr_bp_restore(void)
+{
+	if (!use_intel())
+		return;
+
+	mtrr_if->set_all();
+}
+
 static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
Index: tip/arch/x86/kernel/smpboot.c
===================================================================
--- tip.orig/arch/x86/kernel/smpboot.c
+++ tip/arch/x86/kernel/smpboot.c
@@ -1118,9 +1118,22 @@ void __init native_smp_prepare_cpus(unsi
 
 	if (is_uv_system())
 		uv_system_init();
+
+	set_mtrr_aps_delayed_init();
 out:
 	preempt_enable();
 }
+
+void arch_enable_nonboot_cpus_begin(void)
+{
+	set_mtrr_aps_delayed_init();
+}
+
+void arch_enable_nonboot_cpus_end(void)
+{
+	mtrr_aps_init();
+}
+
 /*
  * Early setup to make printk work.
  */
@@ -1142,6 +1155,7 @@ void __init native_smp_cpus_done(unsigne
 	setup_ioapic_dest();
 #endif
 	check_nmi_watchdog();
+	mtrr_aps_init();
 }
 
 static int __initdata setup_possible_cpus = -1;
Index: tip/arch/x86/power/cpu.c
===================================================================
--- tip.orig/arch/x86/power/cpu.c
+++ tip/arch/x86/power/cpu.c
@@ -224,7 +224,7 @@ static void __restore_processor_state(st
 	fix_processor_context();
 
 	do_fpu_end();
-	mtrr_ap_init();
+	mtrr_bp_restore();
 
 #ifdef CONFIG_X86_OLD_MCE
 	mcheck_init(&boot_cpu_data);
Index: tip/kernel/cpu.c
===================================================================
--- tip.orig/kernel/cpu.c
+++ tip/kernel/cpu.c
@@ -413,6 +413,14 @@ int disable_nonboot_cpus(void)
 	return error;
 }
 
+void __attribute__((weak)) arch_enable_nonboot_cpus_begin(void)
+{
+}
+
+void __attribute__((weak)) arch_enable_nonboot_cpus_end(void)
+{
+}
+
 void __ref enable_nonboot_cpus(void)
 {
 	int cpu, error;
@@ -424,6 +432,9 @@ void __ref enable_nonboot_cpus(void)
 		goto out;
 
 	printk("Enabling non-boot CPUs ...\n");
+
+	arch_enable_nonboot_cpus_begin();
+
 	for_each_cpu(cpu, frozen_cpus) {
 		error = _cpu_up(cpu, 1);
 		if (!error) {
@@ -432,6 +443,9 @@ void __ref enable_nonboot_cpus(void)
 		}
 		printk(KERN_WARNING "Error taking CPU%d up: %d\n", cpu, error);
 	}
+
+	arch_enable_nonboot_cpus_end();
+
 	cpumask_clear(frozen_cpus);
 out:
 	cpu_maps_update_done();


