Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbZJCS1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbZJCS1h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 14:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756860AbZJCS1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 14:27:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:53514 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385AbZJCS1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 14:27:35 -0400
Message-ID: <4AC7974C.20304@kernel.org>
Date: Sat, 03 Oct 2009 11:26:20 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Tejun Heo <tj@kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: use near online node instead of round bin for numa
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


cpu to node mapping is set in following sequence:
1. numa_init_array: set up roundbin from cpu to online node
2. init_cpu_to_node: set that according to apicid_to_node[] according to srat
		  only handle that node is online, and leave other cpu on node
		  without ram (aka not online) to still round-bin
3. later srat_detect_node for intel/amd, will use first_online node or near by
   node.

problem is that setup_per_cpu_areas() is called between  2 and 3. the per_cpu
for cpu on node with ram is on different node. and could put that on node with
two hops away.

so try add find_near_online_node() and call int init_cpu_to_node()

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/cpu/intel.c |    6 +++++-
 arch/x86/mm/numa_64.c       |   21 ++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/mm/numa_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/numa_64.c
+++ linux-2.6/arch/x86/mm/numa_64.c
@@ -601,6 +601,25 @@ static __init int numa_setup(char *opt)
 early_param("numa", numa_setup);
 
 #ifdef CONFIG_NUMA
+
+static __init int find_near_online_node(int node)
+{
+	int n, val;
+	int min_val = INT_MAX;
+	int best_node = -1;
+
+	for_each_online_node(n) {
+		val = node_distance(node, n);
+
+		if (val < min_val) {
+			min_val = val;
+			best_node = n;
+		}
+	}
+
+	return best_node;
+}
+
 /*
  * Setup early cpu_to_node.
  *
@@ -632,7 +651,7 @@ void __init init_cpu_to_node(void)
 		if (node == NUMA_NO_NODE)
 			continue;
 		if (!node_online(node))
-			continue;
+			node = find_near_online_node(node);
 		numa_set_node(cpu, node);
 	}
 }
Index: linux-2.6/arch/x86/kernel/cpu/intel.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/intel.c
+++ linux-2.6/arch/x86/kernel/cpu/intel.c
@@ -263,8 +263,12 @@ static void __cpuinit srat_detect_node(s
 	/* Don't do the funky fallback heuristics the AMD version employs
 	   for now. */
 	node = apicid_to_node[apicid];
-	if (node == NUMA_NO_NODE || !node_online(node))
+	if (node == NUMA_NO_NODE)
 		node = first_node(node_online_map);
+	else if (!node_online(node)) {
+		/* reuse the value from init_cpu_to_node() */
+		node = cpu_to_node(cpu);
+	}
 	numa_set_node(cpu, node);
 
 	printk(KERN_INFO "CPU %d/0x%x -> Node %d\n", cpu, apicid, node);
