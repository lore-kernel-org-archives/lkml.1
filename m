Return-Path: <linux-kernel-owner+w=401wt.eu-S1756225AbYI2SK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225AbYI2SK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754025AbYI2SD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:26 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54356 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754012AbYI2SCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:54 -0400
Message-Id: <20080929180253.935410000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:03:18 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 28/31] cpumask: clean smp files
Content-Disposition: inline; filename=clean-smp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/smp.c     |    6 +++---
 arch/x86/kernel/smpboot.c |   20 ++++++++++++--------
 include/asm-x86/smp.h     |    6 +++---
 include/linux/smp.h       |    8 ++++----
 kernel/smp.c              |   15 ++++++++-------
 5 files changed, 30 insertions(+), 25 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/smp.c
+++ struct-cpumasks/arch/x86/kernel/smp.c
@@ -118,15 +118,15 @@ static void native_smp_send_reschedule(i
 		WARN_ON(1);
 		return;
 	}
-	send_IPI_mask(&cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
+	send_IPI_mask(cpumask_of_cpu(cpu), RESCHEDULE_VECTOR);
 }
 
 void native_send_call_func_single_ipi(int cpu)
 {
-	send_IPI_mask(&cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
+	send_IPI_mask(cpumask_of_cpu(cpu), CALL_FUNCTION_SINGLE_VECTOR);
 }
 
-void native_send_call_func_ipi(const cpumask_t *mask)
+void native_send_call_func_ipi(const_cpumask_t mask)
 {
 	int cpu = smp_processor_id();
 
--- struct-cpumasks.orig/arch/x86/kernel/smpboot.c
+++ struct-cpumasks/arch/x86/kernel/smpboot.c
@@ -466,7 +466,8 @@ void __cpuinit set_cpu_sibling_map(int c
 	cpu_set(cpu, c->llc_shared_map);
 
 	if (current_cpu_data.x86_max_cores == 1) {
-		per_cpu(cpu_core_map, cpu) = per_cpu(cpu_sibling_map, cpu);
+		cpus_copy(per_cpu(cpu_core_map, cpu),
+			  per_cpu(cpu_sibling_map, cpu));
 		c->booted_cores = 1;
 		return;
 	}
@@ -503,7 +504,7 @@ void __cpuinit set_cpu_sibling_map(int c
 }
 
 /* maps the cpu to the sched domain representing multi-core */
-const cpumask_t cpu_coregroup_map(int cpu)
+const_cpumask_t cpu_coregroup_map(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	/*
@@ -511,9 +512,9 @@ const cpumask_t cpu_coregroup_map(int cp
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return (const cpumask_t)per_cpu(cpu_core_map, cpu);
+		return (const_cpumask_t)per_cpu(cpu_core_map, cpu);
 	else
-		return (const cpumask_t)c->llc_shared_map;
+		return (const_cpumask_t)c->llc_shared_map;
 }
 
 static void impress_friends(void)
@@ -1036,12 +1037,13 @@ int __cpuinit native_cpu_up(unsigned int
  */
 static __init void disable_smp(void)
 {
-	cpu_present_map = cpumask_of_cpu(0);
-	cpu_possible_map = cpumask_of_cpu(0);
+	cpus_copy(cpu_present_map, cpumask_of_cpu(0));
+	cpus_copy(cpu_possible_map, cpumask_of_cpu(0));
 	smpboot_clear_io_apic_irqs();
 
 	if (smp_found_config)
-		physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
+		physid_set_mask_of_physid(boot_cpu_physical_apicid,
+					  &phys_cpu_present_map);
 	else
 		physid_set_mask_of_physid(0, &phys_cpu_present_map);
 	map_cpu_to_logical_apicid();
@@ -1169,7 +1171,7 @@ void __init native_smp_prepare_cpus(unsi
 	preempt_disable();
 	smp_cpu_index_default();
 	current_cpu_data = boot_cpu_data;
-	cpu_callin_map = cpumask_of_cpu(0);
+	cpus_copy(cpu_callin_map, cpumask_of_cpu(0));
 	mb();
 	/*
 	 * Setup boot CPU information
@@ -1337,7 +1339,9 @@ __init void prefill_possible_map(void)
 	for (i = 0; i < possible; i++)
 		cpu_set(i, cpu_possible_map);
 
+#ifndef nr_cpu_ids
 	nr_cpu_ids = possible;
+#endif
 }
 
 static void __ref remove_cpu_from_maps(int cpu)
--- struct-cpumasks.orig/include/asm-x86/smp.h
+++ struct-cpumasks/include/asm-x86/smp.h
@@ -60,7 +60,7 @@ struct smp_ops {
 	void (*cpu_die)(unsigned int cpu);
 	void (*play_dead)(void);
 
-	void (*send_call_func_ipi)(const cpumask_t mask);
+	void (*send_call_func_ipi)(const_cpumask_t mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
 
@@ -123,7 +123,7 @@ static inline void arch_send_call_functi
 	smp_ops.send_call_func_single_ipi(cpu);
 }
 
-static inline void arch_send_call_function_ipi(const cpumask_t mask)
+static inline void arch_send_call_function_ipi(const_cpumask_t mask)
 {
 	smp_ops.send_call_func_ipi(mask);
 }
@@ -138,7 +138,7 @@ void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
 
-void native_send_call_func_ipi(const cpumask_t mask);
+void native_send_call_func_ipi(const_cpumask_t mask);
 void native_send_call_func_single_ipi(int cpu);
 
 void smp_store_cpu_info(int id);
--- struct-cpumasks.orig/include/linux/smp.h
+++ struct-cpumasks/include/linux/smp.h
@@ -62,10 +62,10 @@ extern void smp_cpus_done(unsigned int m
  * Call a function on all other processors
  */
 int smp_call_function(void(*func)(void *info), void *info, int wait);
-int smp_call_function_mask(cpumask_t mask, void(*func)(void *info), void *info,
-				int wait);
-int smp_call_function_single(int cpuid, void (*func) (void *info), void *info,
-				int wait);
+int smp_call_function_mask(const_cpumask_t mask,
+				void (*func)(void *info), void *info, int wait);
+int smp_call_function_single(int cpuid,
+				void (*func)(void *info), void *info, int wait);
 void __smp_call_function_single(int cpuid, struct call_single_data *data);
 
 /*
--- struct-cpumasks.orig/kernel/smp.c
+++ struct-cpumasks/kernel/smp.c
@@ -24,7 +24,7 @@ struct call_function_data {
 	struct call_single_data csd;
 	spinlock_t lock;
 	unsigned int refs;
-	cpumask_t cpumask;
+	cpumask_map_t cpumask;
 	struct rcu_head rcu_head;
 };
 
@@ -287,7 +287,7 @@ static void quiesce_dummy(void *unused)
  * If a faster scheme can be made, we could go back to preferring stack based
  * data -- the data allocation/free is non-zero cost.
  */
-static void smp_call_function_mask_quiesce_stack(const cpumask_t *mask)
+static void smp_call_function_mask_quiesce_stack(const_cpumask_t mask)
 {
 	struct call_single_data data;
 	int cpu;
@@ -295,7 +295,7 @@ static void smp_call_function_mask_quies
 	data.func = quiesce_dummy;
 	data.info = NULL;
 
-	for_each_cpu(cpu, *mask) {
+	for_each_cpu(cpu, mask) {
 		data.flags = CSD_FLAG_WAIT;
 		generic_exec_single(cpu, &data);
 	}
@@ -318,7 +318,7 @@ static void smp_call_function_mask_quies
  * hardware interrupt handler or from a bottom half handler. Preemption
  * must be disabled when calling this function.
  */
-int smp_call_function_mask(cpumask_t mask, void (*func)(void *), void *info,
+int smp_call_function_mask(const_cpumask_t inmask, void (*func)(void *), void *info,
 			   int wait)
 {
 	struct call_function_data d;
@@ -326,12 +326,13 @@ int smp_call_function_mask(cpumask_t mas
 	unsigned long flags;
 	int cpu, num_cpus;
 	int slowpath = 0;
+	cpumask_var_t mask;
 
 	/* Can deadlock when called with interrupts disabled */
 	WARN_ON(irqs_disabled());
 
 	cpu = smp_processor_id();
-	cpus_and(mask, mask, cpu_online_map);
+	cpus_and(mask, inmask, cpu_online_map);
 	cpu_clear(cpu, mask);
 	num_cpus = cpus_weight(mask);
 
@@ -362,7 +363,7 @@ int smp_call_function_mask(cpumask_t mas
 	data->csd.func = func;
 	data->csd.info = info;
 	data->refs = num_cpus;
-	data->cpumask = mask;
+	cpus_copy(data->cpumask, mask);
 
 	spin_lock_irqsave(&call_function_lock, flags);
 	list_add_tail_rcu(&data->csd.list, &call_function_queue);
@@ -375,7 +376,7 @@ int smp_call_function_mask(cpumask_t mas
 	if (wait) {
 		csd_flag_wait(&data->csd);
 		if (unlikely(slowpath))
-			smp_call_function_mask_quiesce_stack(&mask);
+			smp_call_function_mask_quiesce_stack(mask);
 	}
 
 	return 0;

-- 
