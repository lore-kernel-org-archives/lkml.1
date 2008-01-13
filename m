Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbYAMSff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbYAMSff (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2008 13:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753388AbYAMSe7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jan 2008 13:34:59 -0500
Received: from relay1.sgi.com ([192.48.171.29]:50032 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753307AbYAMSe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2008 13:34:56 -0500
Message-Id: <20080113183455.077460000@sgi.com>
References: <20080113183453.973425000@sgi.com>
User-Agent: quilt/0.46-1
Date: Sun, 13 Jan 2008 10:35:01 -0800
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       mingo@elte.hu
Cc: Christoph Lameter <clameter@sgi.com>, Jack Steiner <steiner@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] x86: Change NR_CPUS arrays in numa_64
Content-Disposition: inline; filename=NR_CPUS-arrays-in-numa_64
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the following static arrays sized by NR_CPUS to
per_cpu data variables:

	char cpu_to_node_map[NR_CPUS];


Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Christoph Lameter <clameter@sgi.com>
---
 arch/x86/kernel/setup_64.c   |    4 +++-
 arch/x86/kernel/smpboot_64.c |    6 +++++-
 arch/x86/mm/numa_64.c        |   20 ++++++++++++++++----
 include/asm-x86/numa_64.h    |    2 --
 include/asm-x86/topology.h   |   15 +++++++++++++--
 net/sunrpc/svc.c             |    1 +
 6 files changed, 38 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -63,6 +63,7 @@
 #include <asm/cacheflush.h>
 #include <asm/mce.h>
 #include <asm/ds.h>
+#include <asm/topology.h>
 
 #ifdef CONFIG_PARAVIRT
 #include <asm/paravirt.h>
@@ -372,8 +373,9 @@ void __init setup_arch(char **cmdline_p)
 	io_delay_init();
 
 #ifdef CONFIG_SMP
-	/* setup to use the static apicid table during kernel startup */
+	/* setup to use the early static init tables during kernel startup */
 	x86_cpu_to_apicid_early_ptr = (void *)&x86_cpu_to_apicid_init;
+	x86_cpu_to_node_map_early_ptr = (void *)&x86_cpu_to_node_map_init;
 #endif
 
 #ifdef CONFIG_ACPI
--- a/arch/x86/kernel/smpboot_64.c
+++ b/arch/x86/kernel/smpboot_64.c
@@ -861,9 +861,12 @@ void __init smp_set_apicids(void)
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
-		if (per_cpu_offset(cpu))
+		if (per_cpu_offset(cpu)) {
 			per_cpu(x86_cpu_to_apicid, cpu) =
 						x86_cpu_to_apicid_init[cpu];
+			per_cpu(x86_cpu_to_node_map, cpu) =
+						x86_cpu_to_node_map_init[cpu];
+		}
 		else
 			printk(KERN_NOTICE "per_cpu_offset zero for cpu %d\n",
 									cpu);
@@ -871,6 +874,7 @@ void __init smp_set_apicids(void)
 
 	/* indicate the early static arrays are gone */
 	x86_cpu_to_apicid_early_ptr = NULL;
+	x86_cpu_to_node_map_early_ptr = NULL;
 }
 
 static void __init smp_cpu_index_default(void)
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -31,10 +31,14 @@ bootmem_data_t plat_node_bdata[MAX_NUMNO
 
 struct memnode memnode;
 
-u16 cpu_to_node_map[NR_CPUS] __read_mostly = {
+u16 x86_cpu_to_node_map_init[NR_CPUS] __initdata = {
 	[0 ... NR_CPUS-1] = NUMA_NO_NODE
 };
-EXPORT_SYMBOL(cpu_to_node_map);
+void *x86_cpu_to_node_map_early_ptr;
+EXPORT_SYMBOL(x86_cpu_to_node_map_init);
+EXPORT_SYMBOL(x86_cpu_to_node_map_early_ptr);
+DEFINE_PER_CPU(u16, x86_cpu_to_node_map) = NUMA_NO_NODE;
+EXPORT_PER_CPU_SYMBOL(x86_cpu_to_node_map);
 
 u16 apicid_to_node[MAX_LOCAL_APIC] __cpuinitdata = {
 	[0 ... MAX_LOCAL_APIC-1] = NUMA_NO_NODE
@@ -545,7 +549,7 @@ void __init numa_initmem_init(unsigned l
 	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
 		numa_set_node(i, 0);
-	/* we can't use cpumask_of_cpu() yet */
+	/* cpumask_of_cpu() may not be available during early startup */
 	memset(&node_to_cpumask_map[0], 0, sizeof(node_to_cpumask_map[0]));
 	cpu_set(0, node_to_cpumask_map[0]);
 	e820_register_active_regions(0, start_pfn, end_pfn);
@@ -559,8 +563,16 @@ __cpuinit void numa_add_cpu(int cpu)
 
 void __cpuinit numa_set_node(int cpu, int node)
 {
+	u16 *cpu_to_node_map = (u16 *)x86_cpu_to_node_map_early_ptr;
+
 	cpu_pda(cpu)->nodenumber = node;
-	cpu_to_node_map[cpu] = node;
+
+	if(cpu_to_node_map)
+		cpu_to_node_map[cpu] = node;
+	else if(per_cpu_offset(cpu))
+		per_cpu(x86_cpu_to_node_map, cpu) = node;
+	else
+		Dprintk(KERN_INFO "Setting node for non-present cpu %d\n", cpu);
 }
 
 unsigned long __init numa_free_all_bootmem(void)
--- a/include/asm-x86/numa_64.h
+++ b/include/asm-x86/numa_64.h
@@ -40,6 +40,4 @@ static inline void clear_node_cpumask(in
 #define clear_node_cpumask(cpu) do {} while (0)
 #endif
 
-#define NUMA_NO_NODE 0xffff
-
 #endif
--- a/include/asm-x86/topology.h
+++ b/include/asm-x86/topology.h
@@ -30,13 +30,24 @@
 #include <asm/mpspec.h>
 
 /* Mappings between logical cpu number and node number */
-extern u16 cpu_to_node_map[];
+DECLARE_PER_CPU(u16, x86_cpu_to_node_map);
+extern u16 __initdata x86_cpu_to_node_map_init[];
+extern void *x86_cpu_to_node_map_early_ptr;
 extern cpumask_t node_to_cpumask_map[];
 
+#define NUMA_NO_NODE	((u16)(~0))
+
 /* Returns the number of the node containing CPU 'cpu' */
 static inline int cpu_to_node(int cpu)
 {
-	return cpu_to_node_map[cpu];
+	u16 *cpu_to_node_map = (u16 *)x86_cpu_to_node_map_early_ptr;
+
+	if (cpu_to_node_map)
+		return cpu_to_node_map[cpu];
+	else if(per_cpu_offset(cpu))
+		return per_cpu(x86_cpu_to_node_map, cpu);
+	else
+		return NUMA_NO_NODE;
 }
 
 /*
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -18,6 +18,7 @@
 #include <linux/mm.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/sched.h>
 
 #include <linux/sunrpc/types.h>
 #include <linux/sunrpc/xdr.h>

-- 
