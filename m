Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbZHaNAI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbZHaNAI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 09:00:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753110AbZHaNAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 09:00:06 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:19263
	"EHLO VA3EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753106AbZHaNAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 09:00:01 -0400
X-SpamScore: -2
X-BigFish: VPS-2(zz936eMzz1202hzzz32i6bh203h43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KP8S3T-01-9Z3-02
X-M-MSG: 
Date: Mon, 31 Aug 2009 14:59:47 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: Borislav Petkov <borislav.petkov@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: Store CPU topology information for multi-node
	processors
Message-ID: <20090831125947.GC21867@alberich.amd.com>
References: <20090831125349.GA21867@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090831125349.GA21867@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 31 Aug 2009 12:59:47.0872 (UTC) FILETIME=[EB5D7200:01CA2A3A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduce cpu_node_map, i.e. map of CPUs on same internal node.
CPUs with matching phys_proc_id and cpu_node_id belong to the same
cpu_node.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/include/asm/smp.h       |    6 ++++++
 arch/x86/kernel/smpboot.c        |   12 ++++++++++++
 3 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 2b03f70..0e0b363 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -107,6 +107,8 @@ struct cpuinfo_x86 {
 	u16			booted_cores;
 	/* Physical processor id: */
 	u16			phys_proc_id;
+	/* Node id in case of multi-node processor: */
+	u16			cpu_node_id;
 	/* Core id: */
 	u16			cpu_core_id;
 	/* Index into per_cpu list: */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 6a84ed1..aad37c6 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -22,6 +22,7 @@ extern int smp_num_siblings;
 extern unsigned int num_processors;
 
 DECLARE_PER_CPU(cpumask_var_t, cpu_sibling_map);
+DECLARE_PER_CPU(cpumask_var_t, cpu_node_map);
 DECLARE_PER_CPU(cpumask_var_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
 DECLARE_PER_CPU(int, cpu_number);
@@ -31,6 +32,11 @@ static inline struct cpumask *cpu_sibling_mask(int cpu)
 	return per_cpu(cpu_sibling_map, cpu);
 }
 
+static inline struct cpumask *cpu_node_mask(int cpu)
+{
+	return per_cpu(cpu_node_map, cpu);
+}
+
 static inline struct cpumask *cpu_core_mask(int cpu)
 {
 	return per_cpu(cpu_core_map, cpu);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 4701f90..b80b46b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -109,6 +109,10 @@ EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
+/* representing node silbings on multi-node CPU */
+DEFINE_PER_CPU(cpumask_var_t, cpu_node_map);
+EXPORT_PER_CPU_SYMBOL(cpu_node_map);
+
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -403,6 +407,11 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 			cpumask_set_cpu(i, c->llc_shared_map);
 			cpumask_set_cpu(cpu, cpu_data(i).llc_shared_map);
 		}
+		if ((c->phys_proc_id == cpu_data(i).phys_proc_id) &&
+		    (c->cpu_node_id == cpu_data(i).cpu_node_id)) {
+			cpumask_set_cpu(i, cpu_node_mask(cpu));
+			cpumask_set_cpu(cpu, cpu_node_mask(i));
+		}
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
@@ -1062,6 +1071,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
 		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
 		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
+		zalloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
 	}
 	set_cpu_sibling_map(0);
 
@@ -1221,6 +1231,7 @@ static void remove_siblinginfo(int cpu)
 
 	for_each_cpu(sibling, cpu_core_mask(cpu)) {
 		cpumask_clear_cpu(cpu, cpu_core_mask(sibling));
+		cpumask_clear_cpu(cpu, cpu_node_mask(sibling));
 		/*/
 		 * last thread sibling in this cpu core going down
 		 */
@@ -1233,6 +1244,7 @@ static void remove_siblinginfo(int cpu)
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
+	c->cpu_node_id = 0;
 	c->cpu_core_id = 0;
 	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
 }
-- 
1.6.4



