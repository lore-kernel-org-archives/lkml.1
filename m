Return-Path: <linux-kernel-owner+w=401wt.eu-S1757286AbZKWLxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757286AbZKWLxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 06:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZKWLxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 06:53:17 -0500
Received: from hera.kernel.org ([140.211.167.34]:56016 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757278AbZKWLxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 06:53:14 -0500
Date: Mon, 23 Nov 2009 11:52:43 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, rusty@rustcorp.com.au,
       torvalds@linux-foundation.org, akpm@linux-foundation.org, tj@kernel.org,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, rusty@rustcorp.com.au, tj@kernel.org,
       tglx@linutronix.de, rientjes@google.com, mingo@elte.hu
In-Reply-To: <4B07A739.3030104@kernel.org>
References: <4B07A739.3030104@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, numa: Use near(er) online node instead of roundrobin for NUMA
Message-ID: <tip-d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9@git.kernel.org>
Git-Commit-ID: d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9
Gitweb:     http://git.kernel.org/tip/d9c2d5ac6af87b4491bff107113aaf16f6c2b2d9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 21 Nov 2009 00:23:37 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 10:06:24 +0100

x86, numa: Use near(er) online node instead of roundrobin for NUMA

CPU to node mapping is set via the following sequence:

 1. numa_init_array(): Set up roundrobin from cpu to online node

 2. init_cpu_to_node(): Set that according to apicid_to_node[]
			according to srat only handle the node that
			is online, and leave other cpu on node
			without ram (aka not online) to still
			roundrobin.

3. later call srat_detect_node for Intel/AMD, will use first_online
   node or nearby node.

Problem is that setup_per_cpu_areas() is not called between 2 and 3,
the per_cpu for cpu on node with ram is on different node, and could
put that on node with two hops away.

So try to optimize this and add find_near_online_node() and call
init_cpu_to_node().

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
LKML-Reference: <4B07A739.3030104@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/intel.c |    6 +++++-
 arch/x86/mm/numa_64.c       |   21 ++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
index 40e1835..c900b73 100644
--- a/arch/x86/kernel/cpu/intel.c
+++ b/arch/x86/kernel/cpu/intel.c
@@ -263,8 +263,12 @@ static void __cpuinit srat_detect_node(struct cpuinfo_x86 *c)
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
diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
index 3acd870..83bbc70 100644
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -764,6 +764,25 @@ static __init int numa_setup(char *opt)
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
@@ -795,7 +814,7 @@ void __init init_cpu_to_node(void)
 		if (node == NUMA_NO_NODE)
 			continue;
 		if (!node_online(node))
-			continue;
+			node = find_near_online_node(node);
 		numa_set_node(cpu, node);
 	}
 }
