Return-Path: <linux-kernel-owner+w=401wt.eu-S1753341AbXILB5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341AbXILB5w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763006AbXILB4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:56:53 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:48643 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752079AbXILB4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:56:47 -0400
Message-Id: <20070912015645.566522143@sgi.com>
References: <20070912015644.927677070@sgi.com>
User-Agent: quilt/0.46-1
Date: Tue, 11 Sep 2007 18:56:46 -0700
From: travis@sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <ak@suse.de>, Christoph Lameter <clameter@sgi.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, sparclinux@vger.kernel.org
Subject: [PATCH 02/10] x86: fix cpu_to_node references (v3)
Content-Disposition: inline; filename=fix-cpu_to_node-refs
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fix four instances where cpu_to_node is referenced
by array instead of via the cpu_to_node macro.  This
is preparation to moving it to the per_cpu data area.

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86_64/kernel/vsyscall.c |    2 +-
 arch/x86_64/mm/numa.c         |    4 ++--
 arch/x86_64/mm/srat.c         |    4 ++--
 3 files changed, 5 insertions(+), 5 deletions(-)

--- a/arch/x86_64/kernel/vsyscall.c
+++ b/arch/x86_64/kernel/vsyscall.c
@@ -291,7 +291,7 @@
 	unsigned long *d;
 	unsigned long node = 0;
 #ifdef CONFIG_NUMA
-	node = cpu_to_node[cpu];
+	node = cpu_to_node(cpu);
 #endif
 	if (cpu_has(&cpu_data[cpu], X86_FEATURE_RDTSCP))
 		write_rdtscp_aux((node << 12) | cpu);
--- a/arch/x86_64/mm/numa.c
+++ b/arch/x86_64/mm/numa.c
@@ -261,7 +261,7 @@
 	   We round robin the existing nodes. */
 	rr = first_node(node_online_map);
 	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_to_node[i] != NUMA_NO_NODE)
+		if (cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
  		numa_set_node(i, rr);
 		rr = next_node(rr, node_online_map);
@@ -543,7 +543,7 @@
 void __cpuinit numa_set_node(int cpu, int node)
 {
 	cpu_pda(cpu)->nodenumber = node;
-	cpu_to_node[cpu] = node;
+	cpu_to_node(cpu) = node;
 }
 
 unsigned long __init numa_free_all_bootmem(void) 
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -431,9 +431,9 @@
 			setup_node_bootmem(i, nodes[i].start, nodes[i].end);
 
 	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_to_node[i] == NUMA_NO_NODE)
+		if (cpu_to_node(i) == NUMA_NO_NODE)
 			continue;
-		if (!node_isset(cpu_to_node[i], node_possible_map))
+		if (!node_isset(cpu_to_node(i), node_possible_map))
 			numa_set_node(i, NUMA_NO_NODE);
 	}
 	numa_init_array();

-- 
