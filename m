Return-Path: <linux-kernel-owner+w=401wt.eu-S1753370AbXD0R4k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370AbXD0R4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:56:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXD0R4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:56:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:15594 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756093AbXD0R4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:56:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,462,1170662400"; 
   d="scan'208";a="80253712"
Date: Fri, 27 Apr 2007 10:54:12 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Mel Gorman <mel@skynet.ie>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       clameter@engr.sgi.com, dada1@cosmosbay.com, rientjes@google.com
Subject: Re: 2.6.21-rc7-mm2 -- x86_64 blade hard hangs
Message-ID: <20070427175412.GA30924@linux-os.sc.intel.com>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org> <46309B59.4090701@shadowen.org> <p73fy6n2qhg.fsf@bingen.suse.de> <20070426133344.GB16909@skynet.ie> <20070426144622.GE16909@skynet.ie> <20070426174036.GH16909@skynet.ie> <20070426234002.GH5475@linux-os.sc.intel.com> <20070427110709.GE3645@skynet.ie>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070427110709.GE3645@skynet.ie>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 12:07:10PM +0100, Mel Gorman wrote:
> On (26/04/07 16:40), Siddha, Suresh B didst pronounce:
> > oops. Appended patch should fix this. Can you please check this and Ack it?
> 
> This patch does not apply cleanly to 2.6.21-rc7-mm2.

Mel, Please backout the existing  x86_64-set-node_possible_map-at-runtime.patch
in rc7-mm2  and apply the appended patch instead.

Andrew, as you already backedout x86_64-set-node_possible_map-at-runtime.patch
from your -mm series, please include the appended patch (as try 2), after
Mel confirms that it works fine on his setup.

Thanks!

---
From: Suresh Siddha <suresh.b.siddha@intel.com>
[patch] x86_64: set node_possible_map at runtime - try 2

Set the node_possible_map at runtime on x86_64.  On a non NUMA system,
num_possible_nodes() will now say '1'.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Eric Dumazet <dada1@cosmosbay.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@engr.sgi.com>
---

diff -pNru linux/arch/x86_64/mm/k8topology.c linux~/arch/x86_64/mm/k8topology.c
--- linux/arch/x86_64/mm/k8topology.c	2007-04-27 10:37:19.000000000 -0700
+++ linux~/arch/x86_64/mm/k8topology.c	2007-04-27 10:34:10.000000000 -0700
@@ -49,11 +49,8 @@ int __init k8_scan_nodes(unsigned long s
 	int found = 0;
 	u32 reg;
 	unsigned numnodes;
-	nodemask_t nodes_parsed;
 	unsigned dualcore = 0;
 
-	nodes_clear(nodes_parsed);
-
 	if (!early_pci_allowed())
 		return -1;
 
@@ -102,7 +99,7 @@ int __init k8_scan_nodes(unsigned long s
 			       nodeid, (base>>8)&3, (limit>>8) & 3); 
 			return -1; 
 		}	
-		if (node_isset(nodeid, nodes_parsed)) { 
+		if (node_isset(nodeid, node_possible_map)) {
 			printk(KERN_INFO "Node %d already present. Skipping\n", 
 			       nodeid);
 			continue;
@@ -155,7 +152,7 @@ int __init k8_scan_nodes(unsigned long s
 
 		prevbase = base;
 
-		node_set(nodeid, nodes_parsed);
+		node_set(nodeid, node_possible_map);
 	} 
 
 	if (!found)
diff -pNru linux/arch/x86_64/mm/numa.c linux~/arch/x86_64/mm/numa.c
--- linux/arch/x86_64/mm/numa.c	2007-04-27 10:37:19.000000000 -0700
+++ linux~/arch/x86_64/mm/numa.c	2007-04-27 10:34:10.000000000 -0700
@@ -298,7 +298,7 @@ static int __init setup_node_range(int n
 		ret = -1;
 	}
 	nodes[nid].end = *addr;
-	node_set_online(nid);
+	node_set(nid, node_possible_map);
 	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
 	       nodes[nid].start, nodes[nid].end,
 	       (nodes[nid].end - nodes[nid].start) >> 20);
@@ -482,7 +482,7 @@ out:
 	 * SRAT.
 	 */
 	remove_all_active_ranges();
-	for_each_online_node(i) {
+	for_each_node_mask(i, node_possible_map) {
 		e820_register_active_regions(i, nodes[i].start >> PAGE_SHIFT,
 						nodes[i].end >> PAGE_SHIFT);
  		setup_node_bootmem(i, nodes[i].start, nodes[i].end);
@@ -497,20 +497,25 @@ void __init numa_initmem_init(unsigned l
 { 
 	int i;
 
+	nodes_clear(node_possible_map);
+
 #ifdef CONFIG_NUMA_EMU
 	if (cmdline && !numa_emulation(start_pfn, end_pfn))
  		return;
+	nodes_clear(node_possible_map);
 #endif
 
 #ifdef CONFIG_ACPI_NUMA
 	if (!numa_off && !acpi_scan_nodes(start_pfn << PAGE_SHIFT,
 					  end_pfn << PAGE_SHIFT))
  		return;
+	nodes_clear(node_possible_map);
 #endif
 
 #ifdef CONFIG_K8_NUMA
 	if (!numa_off && !k8_scan_nodes(start_pfn<<PAGE_SHIFT, end_pfn<<PAGE_SHIFT))
 		return;
+	nodes_clear(node_possible_map);
 #endif
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
@@ -524,6 +529,7 @@ void __init numa_initmem_init(unsigned l
 	memnodemap[0] = 0;
 	nodes_clear(node_online_map);
 	node_set_online(0);
+	node_set(0, node_possible_map);
 	for (i = 0; i < NR_CPUS; i++)
 		numa_set_node(i, 0);
 	node_to_cpumask[0] = cpumask_of_cpu(0);
diff -pNru linux/arch/x86_64/mm/srat.c linux~/arch/x86_64/mm/srat.c
--- linux/arch/x86_64/mm/srat.c	2007-04-27 10:37:19.000000000 -0700
+++ linux~/arch/x86_64/mm/srat.c	2007-04-27 10:34:10.000000000 -0700
@@ -419,19 +419,21 @@ int __init acpi_scan_nodes(unsigned long
 		return -1;
 	}
 
+	node_possible_map = nodes_parsed;
+
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
