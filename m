Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYI2SFp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYI2SFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:05:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754099AbYI2SDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:03:03 -0400
Received: from relay1.sgi.com ([192.48.171.29]:54307 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753632AbYI2SCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:02:51 -0400
Message-Id: <20080929180251.229466000@polaris-admin.engr.sgi.com>
References: <20080929180250.111209000@polaris-admin.engr.sgi.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Sep 2008 11:02:58 -0700
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/31] cpumask: Change cpumask maps
Content-Disposition: inline; filename=cpu-maps
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-of-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/smpboot.c |   20 ++++++++++----------
 include/asm-x86/smp.h     |   20 ++++++++++----------
 2 files changed, 20 insertions(+), 20 deletions(-)

--- struct-cpumasks.orig/arch/x86/kernel/smpboot.c
+++ struct-cpumasks/arch/x86/kernel/smpboot.c
@@ -102,20 +102,20 @@ EXPORT_SYMBOL(smp_num_siblings);
 DEFINE_PER_CPU(u16, cpu_llc_id) = BAD_APICID;
 
 /* bitmap of online cpus */
-cpumask_t cpu_online_map __read_mostly;
+cpumask_map_t cpu_online_map __read_mostly;
 EXPORT_SYMBOL(cpu_online_map);
 
-cpumask_t cpu_callin_map;
-cpumask_t cpu_callout_map;
-cpumask_t cpu_possible_map;
+cpumask_map_t cpu_callin_map;
+cpumask_map_t cpu_callout_map;
+cpumask_map_t cpu_possible_map;
 EXPORT_SYMBOL(cpu_possible_map);
 
 /* representing HT siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_sibling_map);
+DEFINE_PER_CPU(cpumask_map_t, cpu_sibling_map);
 EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 
 /* representing HT and core siblings of each logical CPU */
-DEFINE_PER_CPU(cpumask_t, cpu_core_map);
+DEFINE_PER_CPU(cpumask_map_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
 /* Per CPU bogomips and other parameters */
@@ -126,7 +126,7 @@ static atomic_t init_deasserted;
 
 
 /* representing cpus for which sibling maps can be computed */
-static cpumask_t cpu_sibling_setup_map;
+static cpumask_map_t cpu_sibling_setup_map;
 
 /* Set if we find a B stepping CPU */
 static int __cpuinitdata smp_b_stepping;
@@ -503,7 +503,7 @@ void __cpuinit set_cpu_sibling_map(int c
 }
 
 /* maps the cpu to the sched domain representing multi-core */
-cpumask_t cpu_coregroup_map(int cpu)
+const cpumask_t cpu_coregroup_map(int cpu)
 {
 	struct cpuinfo_x86 *c = &cpu_data(cpu);
 	/*
@@ -511,9 +511,9 @@ cpumask_t cpu_coregroup_map(int cpu)
 	 * And for power savings, we return cpu_core_map
 	 */
 	if (sched_mc_power_savings || sched_smt_power_savings)
-		return per_cpu(cpu_core_map, cpu);
+		return (const cpumask_t)per_cpu(cpu_core_map, cpu);
 	else
-		return c->llc_shared_map;
+		return (const cpumask_t)c->llc_shared_map;
 }
 
 static void impress_friends(void)
--- struct-cpumasks.orig/include/asm-x86/smp.h
+++ struct-cpumasks/include/asm-x86/smp.h
@@ -18,9 +18,9 @@
 #include <asm/pda.h>
 #include <asm/thread_info.h>
 
-extern cpumask_t cpu_callout_map;
-extern cpumask_t cpu_initialized;
-extern cpumask_t cpu_callin_map;
+extern cpumask_map_t cpu_callout_map;
+extern cpumask_map_t cpu_initialized;
+extern cpumask_map_t cpu_callin_map;
 
 extern void (*mtrr_hook)(void);
 extern void zap_low_mappings(void);
@@ -29,10 +29,10 @@ extern int __cpuinit get_local_pda(int c
 
 extern int smp_num_siblings;
 extern unsigned int num_processors;
-extern cpumask_t cpu_initialized;
+extern cpumask_map_t cpu_initialized;
 
-DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
-DECLARE_PER_CPU(cpumask_t, cpu_core_map);
+DECLARE_PER_CPU(cpumask_map_t, cpu_sibling_map);
+DECLARE_PER_CPU(cpumask_map_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 #ifdef CONFIG_X86_32
 DECLARE_PER_CPU(int, cpu_number);
@@ -60,7 +60,7 @@ struct smp_ops {
 	void (*cpu_die)(unsigned int cpu);
 	void (*play_dead)(void);
 
-	void (*send_call_func_ipi)(const cpumask_t *mask);
+	void (*send_call_func_ipi)(const cpumask_t mask);
 	void (*send_call_func_single_ipi)(int cpu);
 };
 
@@ -123,9 +123,9 @@ static inline void arch_send_call_functi
 	smp_ops.send_call_func_single_ipi(cpu);
 }
 
-static inline void arch_send_call_function_ipi(cpumask_t mask)
+static inline void arch_send_call_function_ipi(const cpumask_t mask)
 {
-	smp_ops.send_call_func_ipi(&mask);
+	smp_ops.send_call_func_ipi(mask);
 }
 
 void cpu_disable_common(void);
@@ -138,7 +138,7 @@ void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
 void play_dead_common(void);
 
-void native_send_call_func_ipi(const cpumask_t *mask);
+void native_send_call_func_ipi(const cpumask_t mask);
 void native_send_call_func_single_ipi(int cpu);
 
 void smp_store_cpu_info(int id);

-- 
