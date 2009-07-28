Return-Path: <linux-kernel-owner+w=401wt.eu-S1754353AbZG1PHK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbZG1PHK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:07:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZG1PHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:07:08 -0400
Received: from sg2ehsobe005.messaging.microsoft.com ([207.46.51.79]:23062 "EHLO
	SG2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754304AbZG1PHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:07:00 -0400
X-SpamScore: 3
X-BigFish: VPS3(zzzz1202hzzz32i203h43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KNHZAQ-01-0O7-02
X-M-MSG: 
From: Borislav Petkov <borislav.petkov@amd.com>
To: <mingo@elte.hu>, <hpa@zytor.com>, <tglx@linutronix.de>, <norsk5@yahoo.com>,
       <aris@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <x86@kernel.org>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: [PATCH 02/20] x86: provide CPU topology information for multi-node processors
Date: Tue, 28 Jul 2009 17:06:02 +0200
Message-ID: <1248793580-29899-3-git-send-email-borislav.petkov@amd.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
References: <1248793580-29899-1-git-send-email-borislav.petkov@amd.com>
X-OriginalArrivalTime: 28 Jul 2009 15:06:23.0160 (UTC) FILETIME=[F876EB80:01CA0F94]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Herrmann <andreas.herrmann3@amd.com>

Provide topology_cpu_node_id, topology_cpu_node_mask and cpu_node_map.
CPUs with matching phys_proc_id and cpu_node_id belong to the same
cpu_node.

Also, use a cpuinfo_x86 ptr in the second loop too instead of deref-fing
cpu_info each time.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/include/asm/smp.h       |    6 ++++++
 arch/x86/include/asm/topology.h  |    2 ++
 arch/x86/kernel/cpu/common.c     |    2 ++
 arch/x86/kernel/cpu/proc.c       |    1 +
 arch/x86/kernel/smpboot.c        |   20 ++++++++++++++++----
 6 files changed, 29 insertions(+), 4 deletions(-)

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
index f1961c0..60db9b5 100644
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
index 2fecda6..d138c4e 100644
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
@@ -396,12 +400,19 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 	}
 
 	for_each_cpu(i, cpu_sibling_setup_mask) {
+		struct cpuinfo_x86 *o = &cpu_data(i);
+
 		if (per_cpu(cpu_llc_id, cpu) != BAD_APICID &&
 		    per_cpu(cpu_llc_id, cpu) == per_cpu(cpu_llc_id, i)) {
 			cpumask_set_cpu(i, c->llc_shared_map);
-			cpumask_set_cpu(cpu, cpu_data(i).llc_shared_map);
+			cpumask_set_cpu(cpu, o->llc_shared_map);
+		}
+		if ((c->phys_proc_id == o->phys_proc_id) &&
+		    (c->cpu_node_id == o->cpu_node_id)) {
+			cpumask_set_cpu(i, cpu_node_mask(cpu));
+			cpumask_set_cpu(cpu, cpu_node_mask(i));
 		}
-		if (c->phys_proc_id == cpu_data(i).phys_proc_id) {
+		if (c->phys_proc_id == o->phys_proc_id) {
 			cpumask_set_cpu(i, cpu_core_mask(cpu));
 			cpumask_set_cpu(cpu, cpu_core_mask(i));
 			/*
@@ -419,9 +430,9 @@ void __cpuinit set_cpu_sibling_map(int cpu)
 				 * the other cpus in this package
 				 */
 				if (i != cpu)
-					cpu_data(i).booted_cores++;
+					o->booted_cores++;
 			} else if (i != cpu && !c->booted_cores)
-				c->booted_cores = cpu_data(i).booted_cores;
+				c->booted_cores = o->booted_cores;
 		}
 	}
 }
@@ -1220,6 +1231,7 @@ static void remove_siblinginfo(int cpu)
 	cpumask_clear(cpu_sibling_mask(cpu));
 	cpumask_clear(cpu_core_mask(cpu));
 	c->phys_proc_id = 0;
+	c->cpu_node_id = 0;
 	c->cpu_core_id = 0;
 	cpumask_clear_cpu(cpu, cpu_sibling_setup_mask);
 }
-- 
1.6.3.3


