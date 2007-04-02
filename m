Return-Path: <linux-kernel-owner+w=401wt.eu-S965966AbXDBW4L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965966AbXDBW4L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 18:56:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965994AbXDBW4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 18:56:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:31654 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965966AbXDBW4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 18:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,362,1170662400"; 
   d="scan'208"; a="223635034:sNHT25418617"
Date: Mon, 2 Apr 2007 15:55:12 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Christoph Lameter <christoph@lameter.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: non-NUMA cache_free_alien() (was Re: [RFC] SLAB : NUMA cache_free_alien() very expensive because of virt_to_slab(objp); nodeid = slabp->nodeid;)
Message-ID: <20070402225512.GA31026@linux-os.sc.intel.com>
References: <20070320181235.77d28864.dada1@cosmosbay.com> <Pine.LNX.4.64.0703201248530.12664@graphe.net> <20070320213218.GA13952@one.firstfloor.org> <Pine.LNX.4.64.0703201716440.17799@graphe.net> <20070321024452.GA17532@one.firstfloor.org> <Pine.LNX.4.64.0703202006230.20568@graphe.net> <20070322212831.GA25665@linux-os.sc.intel.com> <4602FF57.7030001@cosmosbay.com> <20070322224045.GA3200@linux-os.sc.intel.com> <20070323141210.GA20548@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323141210.GA20548@one.firstfloor.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 03:12:10PM +0100, Andi Kleen wrote:
> > But that is based on compile time option, isn't it? Perhaps I need
> > to use some other mechanism to find out the platform is not NUMA capable..
> 
> We can probably make it runtime on x86. That will be needed sooner or 
> later for correct NUMA hotplug support anyways.

How about this patch? Thanks.

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
[patch] x86_64: set node_possible_map at runtime.

Set the node_possible_map at runtime. On a non NUMA system,
num_possible_nodes() will now say '1'

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86_64/mm/k8topology.c b/arch/x86_64/mm/k8topology.c
index b5b8dba..d6f4447 100644
--- a/arch/x86_64/mm/k8topology.c
+++ b/arch/x86_64/mm/k8topology.c
@@ -49,11 +49,8 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 	int found = 0;
 	u32 reg;
 	unsigned numnodes;
-	nodemask_t nodes_parsed;
 	unsigned dualcore = 0;
 
-	nodes_clear(nodes_parsed);
-
 	if (!early_pci_allowed())
 		return -1;
 
@@ -102,7 +99,7 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 			       nodeid, (base>>8)&3, (limit>>8) & 3); 
 			return -1; 
 		}	
-		if (node_isset(nodeid, nodes_parsed)) { 
+		if (node_isset(nodeid, node_possible_map)) { 
 			printk(KERN_INFO "Node %d already present. Skipping\n", 
 			       nodeid);
 			continue;
@@ -155,7 +152,7 @@ int __init k8_scan_nodes(unsigned long start, unsigned long end)
 
 		prevbase = base;
 
-		node_set(nodeid, nodes_parsed);
+		node_set(nodeid, node_possible_map);
 	} 
 
 	if (!found)
diff --git a/arch/x86_64/mm/numa.c b/arch/x86_64/mm/numa.c
index 41b8fb0..5f7d4d8 100644
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -383,6 +383,7 @@ static int __init numa_emulation(unsigned long start_pfn, unsigned long end_pfn)
  		       i,
  		       nodes[i].start, nodes[i].end,
  		       (nodes[i].end - nodes[i].start) >> 20);
+		node_set(i, node_possible_map);
 		node_set_online(i);
  	}
  	memnode_shift = compute_hash_shift(nodes, numa_fake);
@@ -405,6 +406,8 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 { 
 	int i;
 
+	nodes_clear(node_possible_map);
+
 #ifdef CONFIG_NUMA_EMU
 	if (numa_fake && !numa_emulation(start_pfn, end_pfn))
  		return;
@@ -432,6 +435,7 @@ void __init numa_initmem_init(unsigned long start_pfn, unsigned long end_pfn)
 	memnodemap[0] = 0;
 	nodes_clear(node_online_map);
 	node_set_online(0);
+	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
 		numa_set_node(i, 0);
 	node_to_cpumask[0] = cpumask_of_cpu(0);
diff --git a/arch/x86_64/mm/srat.c b/arch/x86_64/mm/srat.c
index 2efe215..9f26e2b 100644
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -25,7 +25,6 @@ int acpi_numa __initdata;
 
 static struct acpi_table_slit *acpi_slit;
 
-static nodemask_t nodes_parsed __initdata;
 static struct bootnode nodes[MAX_NUMNODES] __initdata;
 static struct bootnode nodes_add[MAX_NUMNODES];
 static int found_add_area __initdata;
@@ -43,7 +42,7 @@ static __init int setup_node(int pxm)
 static __init int conflicting_nodes(unsigned long start, unsigned long end)
 {
 	int i;
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, node_possible_map) {
 		struct bootnode *nd = &nodes[i];
 		if (nd->start == nd->end)
 			continue;
@@ -321,7 +320,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 	}
 	nd = &nodes[node];
 	oldnode = *nd;
-	if (!node_test_and_set(node, nodes_parsed)) {
+	if (!node_test_and_set(node, node_possible_map)) {
 		nd->start = start;
 		nd->end = end;
 	} else {
@@ -344,7 +343,7 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		printk(KERN_NOTICE "SRAT: Hotplug region ignored\n");
 		*nd = oldnode;
 		if ((nd->start | nd->end) == 0)
-			node_clear(node, nodes_parsed);
+			node_clear(node, node_possible_map);
 	}
 }
 
@@ -356,7 +355,7 @@ static int nodes_cover_memory(void)
 	unsigned long pxmram, e820ram;
 
 	pxmram = 0;
-	for_each_node_mask(i, nodes_parsed) {
+	for_each_node_mask(i, node_possible_map) {
 		unsigned long s = nodes[i].start >> PAGE_SHIFT;
 		unsigned long e = nodes[i].end >> PAGE_SHIFT;
 		pxmram += e - s;
@@ -380,7 +379,7 @@ static int nodes_cover_memory(void)
 static void unparse_node(int node)
 {
 	int i;
-	node_clear(node, nodes_parsed);
+	node_clear(node, node_possible_map);
 	for (i = 0; i < MAX_LOCAL_APIC; i++) {
 		if (apicid_to_node[i] == node)
 			apicid_to_node[i] = NUMA_NO_NODE;
@@ -420,18 +419,18 @@ int __init acpi_scan_nodes(unsigned long start, unsigned long end)
 	}
 
 	/* Finally register nodes */
-	for_each_node_mask(i, nodes_parsed)
+	for_each_node_mask(i, node_possible_map)
 		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 	/* Try again in case setup_node_bootmem missed one due
 	   to missing bootmem */
-	for_each_node_mask(i, nodes_parsed)
+	for_each_node_mask(i, node_possible_map)
 		if (!node_online(i))
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 
 	for (i = 0; i < NR_CPUS; i++) {
 		if (cpu_to_node[i] == NUMA_NO_NODE)
 			continue;
-		if (!node_isset(cpu_to_node[i], nodes_parsed))
+		if (!node_isset(cpu_to_node[i], node_possible_map))
 			numa_set_node(i, NUMA_NO_NODE);
 	}
 	numa_init_array();
