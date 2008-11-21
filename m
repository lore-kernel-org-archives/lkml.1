Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYKULgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYKULgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752865AbYKULgL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:36:11 -0500
Received: from ozlabs.org ([203.10.76.45]:59612 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbYKULgK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:36:10 -0500
To: "David S. Miller" <davem@davemloft.net>
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 22:06:04 +1030
Subject: [PATCH 7/8] cpumask: sparc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811212206.04337.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: David S. Miller <davem@davemloft.net>
---
 arch/sparc/include/asm/topology_64.h |   10 ++++++----
 arch/sparc64/kernel/of_device.c      |    2 +-
 arch/sparc64/kernel/pci_msi.c        |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

--- linux-2.6.orig/arch/sparc/include/asm/topology_64.h
+++ linux-2.6/arch/sparc/include/asm/topology_64.h
@@ -16,8 +16,12 @@ static inline cpumask_t node_to_cpumask(
 {
 	return numa_cpumask_lookup_table[node];
 }
+#define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
 
-/* Returns a pointer to the cpumask of CPUs on Node 'node'. */
+/*
+ * Returns a pointer to the cpumask of CPUs on Node 'node'.
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #define node_to_cpumask_ptr(v, node)		\
 		cpumask_t *v = &(numa_cpumask_lookup_table[node])
 
@@ -26,9 +30,7 @@ static inline cpumask_t node_to_cpumask(
 
 static inline int node_to_first_cpu(int node)
 {
-	cpumask_t tmp;
-	tmp = node_to_cpumask(node);
-	return first_cpu(tmp);
+	return cpumask_first(cpumask_of_node(node));
 }
 
 struct pci_bus;
--- linux-2.6.orig/arch/sparc64/kernel/of_device.c
+++ linux-2.6/arch/sparc64/kernel/of_device.c
@@ -778,7 +778,7 @@ static unsigned int __init build_one_dev
 out:
 	nid = of_node_to_nid(dp);
 	if (nid != -1) {
-		cpumask_t numa_mask = node_to_cpumask(nid);
+		cpumask_t numa_mask = *cpumask_of_node(nid);
 
 		irq_set_affinity(irq, numa_mask);
 	}
--- linux-2.6.orig/arch/sparc64/kernel/pci_msi.c
+++ linux-2.6/arch/sparc64/kernel/pci_msi.c
@@ -286,7 +286,7 @@ static int bringup_one_msi_queue(struct 
 
 	nid = pbm->numa_node;
 	if (nid != -1) {
-		cpumask_t numa_mask = node_to_cpumask(nid);
+		cpumask_t numa_mask = *cpumask_of_node(nid);
 
 		irq_set_affinity(irq, numa_mask);
 	}


