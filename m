Return-Path: <linux-kernel-owner+w=401wt.eu-S1762192AbZE2SoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762192AbZE2SoS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 14:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZE2SoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 14:44:04 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:25355
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754336AbZE2SoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 14:44:03 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i6bh17ch43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KKF5CM-02-KY3-01
Date: Fri, 29 May 2009 20:42:25 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] x86: provide CPU topology information for multi-node
	processors
Message-ID: <20090529184225.GE23770@alberich.amd.com>
References: <20090529184023.GD23770@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20090529184023.GD23770@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 29 May 2009 18:43:07.0300 (UTC) FILETIME=[4EC03640:01C9E08D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This support can be switched off/on using a new config option
MULTI_NODE_CPU. If the option is set the CPU topology information is
extended with cpu_node information. This includes a cpu_node_id,
cpu_node_siblings and cpu_node_siblings_list.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/Kconfig                 |    9 +++++++++
 arch/x86/include/asm/processor.h |    4 ++++
 arch/x86/include/asm/smp.h       |    8 ++++++++
 arch/x86/include/asm/topology.h  |    5 +++++
 arch/x86/kernel/cpu/common.c     |    4 ++++
 arch/x86/kernel/cpu/proc.c       |    3 +++
 arch/x86/kernel/smpboot.c        |   14 ++++++++++++++
 drivers/base/topology.c          |   14 ++++++++++++++
 8 files changed, 61 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ddc207f..af86631 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -710,6 +710,15 @@ config SCHED_MC
 	  making when dealing with multi-core CPU chips at a cost of slightly
 	  increased overhead in some places. If unsure say N here.
 
+config MULTI_NODE_CPU
+	def_bool y
+	prompt "Multi-node processor support"
+	depends on SMP
+	---help---
+	  Multi-node processor support allows proper representation of
+	  CPU topology for processors having multiple-nodes per socket.
+	  If unsure say N here.
+
 source "kernel/Kconfig.preempt"
 
 config X86_UP_APIC
diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c776826..7a791b7 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -106,6 +106,10 @@ struct cpuinfo_x86 {
 	u16			booted_cores;
 	/* Physical processor id: */
 	u16			phys_proc_id;
+#ifdef CONFIG_MULTI_NODE_CPU
+	/* Node id in case of multi-node processor: */
+	u16			cpu_node_id;
+#endif
 	/* Core id: */
 	u16			cpu_core_id;
 	/* Index into per_cpu list: */
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 6a84ed1..03f9d85 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -31,6 +31,14 @@ static inline struct cpumask *cpu_sibling_mask(int cpu)
 	return per_cpu(cpu_sibling_map, cpu);
 }
 
+#ifdef CONFIG_MULTI_NODE_CPU
+DECLARE_PER_CPU(cpumask_var_t, cpu_node_map);
+static inline struct cpumask *cpu_node_mask(int cpu)
+{
+	return per_cpu(cpu_node_map, cpu);
+}
+#endif
+
 static inline struct cpumask *cpu_core_mask(int cpu)
 {
 	return per_cpu(cpu_core_map, cpu);
diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 066ef59..e04d2a4 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -190,6 +190,11 @@ extern const struct cpumask *cpu_coregroup_mask(int cpu);
 #define topology_core_id(cpu)			(cpu_data(cpu).cpu_core_id)
 #define topology_core_cpumask(cpu)		(per_cpu(cpu_core_map, cpu))
 #define topology_thread_cpumask(cpu)		(per_cpu(cpu_sibling_map, cpu))
+#ifdef CONFIG_MULTI_NODE_CPU
+#define topology_cpu_node_id(cpu)		(cpu_data(cpu).cpu_node_id)
+#define topology_cpu_node_cpumask(cpu)		(per_cpu(cpu_node_map, cpu))
+#define arch_provides_multi_node_cpu_topology	yes
+#endif
 
 /* indicates that pointers to the topology cpumask_t maps are valid */
 #define arch_provides_topology_pointers		yes
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 3ffdcfa..d80e05e 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -478,6 +478,10 @@ out:
 	if ((c->x86_max_cores * smp_num_siblings) > 1) {
 		printk(KERN_INFO  "CPU: Physical Processor ID: %d\n",
 		       c->phys_proc_id);
+#ifdef CONFIG_MULTI_NODE_CPU
+		printk(KERN_INFO  "CPU: Processor Node ID: %d\n",
+		       c->cpu_node_id);
+#endif
 		printk(KERN_INFO  "CPU: Processor Core ID: %d\n",
 		       c->cpu_core_id);
 	}
diff --git a/arch/x86/kernel/cpu/proc.c b/arch/x86/kernel/cpu/proc.c
index d5e3039..ebb34e9 100644
--- a/arch/x86/kernel/cpu/proc.c
+++ b/arch/x86/kernel/cpu/proc.c
@@ -15,6 +15,9 @@ static void show_cpuinfo_core(struct seq_file *m, struct cpuinfo_x86 *c,
 		seq_printf(m, "physical id\t: %d\n", c->phys_proc_id);
 		seq_printf(m, "siblings\t: %d\n",
 			   cpumask_weight(cpu_core_mask(cpu)));
+#ifdef CONFIG_MULTI_NODE_CPU
+		seq_printf(m, "node id\t\t: %d\n", c->cpu_node_id);
+#endif
 		seq_printf(m, "core id\t\t: %d\n", c->cpu_core_id);
 		seq_printf(m, "cpu cores\t: %d\n", c->booted_cores);
 		seq_printf(m, "apicid\t\t: %d\n", c->apicid);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index d2e8de9..6041fca 100644
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
@@ -401,6 +405,13 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 			cpumask_set_cpu(i, c->llc_shared_map);
 			cpumask_set_cpu(cpu, cpu_data(i).llc_shared_map);
 		}
+#ifdef CONFIG_MULTI_NODE_CPU
+		if ((c->phys_proc_id == cpu_data(i).phys_proc_id) &&
+		    (c->cpu_node_id == cpu_data(i).cpu_node_id)) {
+			cpumask_set_cpu(i, cpu_node_mask(cpu));
+			cpumask_set_cpu(cpu, cpu_node_mask(i));
+		}
+#endif
 		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
@@ -1220,6 +1231,9 @@ static void remove_siblinginfo(int cpu)
 	c->phys_proc_id = 0;
 	c->cpu_core_id = 0;
 	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
+#ifdef CONFIG_MULTI_NODE_CPU
+	c->cpu_node_id = 0;
+#endif
 }
 
 static void __ref remove_cpu_from_maps(int cpu)
diff --git a/drivers/base/topology.c b/drivers/base/topology.c
index bf6b132..9196632 100644
--- a/drivers/base/topology.c
+++ b/drivers/base/topology.c
@@ -114,11 +114,25 @@ define_siblings_show_func(core_cpumask);
 define_one_ro_named(core_siblings, show_core_cpumask);
 define_one_ro_named(core_siblings_list, show_core_cpumask_list);
 
+#ifdef arch_provides_multi_node_cpu_topology
+define_id_show_func(cpu_node_id);
+define_one_ro(cpu_node_id);
+define_siblings_show_func(cpu_node_cpumask);
+define_one_ro_named(cpu_node_siblings, show_cpu_node_cpumask);
+define_one_ro_named(cpu_node_siblings_list, show_cpu_node_cpumask_list);
+#endif
+
+
 static struct attribute *default_attrs[] = {
 	&attr_physical_package_id.attr,
 	&attr_core_id.attr,
 	&attr_thread_siblings.attr,
 	&attr_thread_siblings_list.attr,
+#ifdef arch_provides_multi_node_cpu_topology
+	&attr_cpu_node_id.attr,
+	&attr_cpu_node_siblings.attr,
+	&attr_cpu_node_siblings_list.attr,
+#endif
 	&attr_core_siblings.attr,
 	&attr_core_siblings_list.attr,
 	NULL
-- 
1.6.3.1



