Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbZFCOfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbZFCOfV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 10:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbZFCOfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 10:35:09 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:40768 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753753AbZFCOfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 10:35:07 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i1a3h6bh17ch43j64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0KKO362-01-069-01
Date: Wed, 3 Jun 2009 16:34:07 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, Bert Wesarg <bert.wesarg@googlemail.com>
Subject: [PATCH 2/5] x86: provide CPU topology information for multi-node
	processors
Message-ID: <20090603143407.GK5736@alberich.amd.com>
References: <20090603142727.GI5736@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090603142727.GI5736@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Jun 2009 14:34:53.0790 (UTC) FILETIME=[7597AFE0:01C9E458]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide topology_cpu_node_id, topology_cpu_node_mask and cpu_node_map.
CPUs with matching phys_proc_id and cpu_node_id belong to the same
cpu_node.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/include/asm/smp.h       |    6 ++++++
 arch/x86/include/asm/topology.h  |    2 ++
 arch/x86/kernel/cpu/common.c     |    2 ++
 arch/x86/kernel/cpu/proc.c       |    1 +
 arch/x86/kernel/smpboot.c        |   10 ++++++++++
 6 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c776826..74d9258 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -106,6 +106,8 @@ struct cpuinfo_x86 {
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
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 066ef59..9eddb69 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -190,6 +190,8 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#define topology_cpu_node_id(cpu)		(cpu_data(cpu).cpu_node_id)
+#define topology_cpu_node_cpumask(cpu)		(per_cpu(cpu_node_map, cpu))
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
 #define arch_provides_topology_pointers		yes
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3ffdcfa..d14d074 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -478,6 +478,8 @@ out:
 	if ((c->x86_max_cores * smp_num_siblings) > 1) {
 		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
 		       c->phys_proc_id);
+		printk(KERN_INFO  "CPU: Processor Node ID: %d\n",
+		       c->cpu_node_id);
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
 	}
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index d5e3039..ff539c1 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -15,6 +15,7 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n",
 			   cpumask_weight(cpu_core_mask(cpu)));
+		seq_printf(m, "node id\t\t: %d\n", c->cpu_node_id);
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d2e8de9..d9750ad 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -108,6 +108,10 @@ EXPORT_PER_CPU_SYMBOL(cpu_sibling_map);
 DEFINE_PER_CPU(cpumask_var_t, cpu_core_map);
 EXPORT_PER_CPU_SYMBOL(cpu_core_map);
 
+/* representing node silbings on multi-node CPU */
+DEFINE_PER_CPU(cpumask_var_t, cpu_node_map);
+EXPORT_PER_CPU_SYMBOL(cpu_node_map);
+
 /* Per CPU bogomips and other parameters */
 DEFINE_PER_CPU_SHARED_ALIGNED(struct cpuinfo_x86, cpu_info);
 EXPORT_PER_CPU_SYMBOL(cpu_info);
@@ -401,6 +405,11 @@ void __cpuinit set_cpu_sibling_map(int cpu)
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
@@ -1218,6 +1227,7 @@ static void remove_siblinginfo(int cpu)
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
+	c->cpu_node_id = 0;
 	c->cpu_core_id = 0;
 	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
 }
-- 
1.6.3.1



