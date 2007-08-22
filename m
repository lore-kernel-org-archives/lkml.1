Return-Path: <linux-kernel-owner+w=401wt.eu-S1758870AbXHVS7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758870AbXHVS7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 14:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756510AbXHVS7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 14:59:12 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:42343 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750971AbXHVS7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 14:59:09 -0400
Message-Id: <20070822172124.071200000@sgi.com>
References: <20070822172101.138513000@sgi.com>
User-Agent: quilt/0.46-1
Date: Wed, 22 Aug 2007 10:21:06 -0700
From: travis@sgi.com
To: Andi Kleen <ak@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 5/6] x86: fix cpu_to_node references
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
@@ -283,7 +283,7 @@ static void __cpuinit vsyscall_set_cpu(i
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
@@ -264,7 +264,7 @@ void __init numa_init_array(void)
 	   We round robin the existing nodes. */
 	rr = first_node(node_online_map);
 	for (i = 0; i < NR_CPUS; i++) {
-		if (cpu_to_node[i] != NUMA_NO_NODE)
+		if (cpu_to_node(i) != NUMA_NO_NODE)
 			continue;
  		numa_set_node(i, rr);
 		rr = next_node(rr, node_online_map);
@@ -546,7 +546,7 @@ __cpuinit void numa_add_cpu(int cpu)
 void __cpuinit numa_set_node(int cpu, int node)
 {
 	cpu_pda(cpu)->nodenumber = node;
-	cpu_to_node[cpu] = node;
+	cpu_to_node(cpu) = node;
 }
 
 unsigned long __init numa_free_all_bootmem(void) 
--- a/arch/x86_64/mm/srat.c
+++ b/arch/x86_64/mm/srat.c
@@ -431,9 +431,9 @@ int __init acpi_scan_nodes(unsigned long
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
