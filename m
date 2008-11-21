Return-Path: <linux-kernel-owner+w=401wt.eu-S1756861AbYKUKqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861AbYKUKqj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:46:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYKUKou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:44:50 -0500
Received: from ozlabs.org ([203.10.76.45]:45225 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850AbYKUKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:44:49 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:12:13 +1030
Subject: [PATCH 5/8] cpumask: powerpc: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Message-Id: <20081121104446.A45F1DDEE8@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

(Also replaces powerpc internal uses of node_to_cpumask).

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 arch/powerpc/include/asm/topology.h          |   10 +++++++---
 arch/powerpc/platforms/cell/spu_priv1_mmio.c |    6 +++---
 arch/powerpc/platforms/cell/spufs/sched.c    |    4 ++--
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/topology.h b/arch/powerpc/include/asm/topology.h
--- a/arch/powerpc/include/asm/topology.h
+++ b/arch/powerpc/include/asm/topology.h
@@ -22,11 +22,11 @@ static inline cpumask_t node_to_cpumask(
 	return numa_cpumask_lookup_table[node];
 }
 
+#define cpumask_of_node(node) (&numa_cpumask_lookup_table[node])
+
 static inline int node_to_first_cpu(int node)
 {
-	cpumask_t tmp;
-	tmp = node_to_cpumask(node);
-	return first_cpu(tmp);
+	return cpumask_first(cpumask_of_node(node));
 }
 
 int of_node_to_nid(struct device_node *device);
@@ -45,6 +45,10 @@ static inline int pcibus_to_node(struct 
 					CPU_MASK_ALL : \
 					node_to_cpumask(pcibus_to_node(bus)) \
 				)
+
+#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
+				 cpu_all_mask :				\
+				 cpumask_of_node(pcibus_to_node(bus)))
 
 /* sched_domains SD_NODE_INIT for PPC64 machines */
 #define SD_NODE_INIT (struct sched_domain) {		\
diff --git a/arch/powerpc/platforms/cell/spu_priv1_mmio.c b/arch/powerpc/platforms/cell/spu_priv1_mmio.c
--- a/arch/powerpc/platforms/cell/spu_priv1_mmio.c
+++ b/arch/powerpc/platforms/cell/spu_priv1_mmio.c
@@ -80,10 +80,10 @@ static void cpu_affinity_set(struct spu 
 	u64 route;
 
 	if (nr_cpus_node(spu->node)) {
-		cpumask_t spumask = node_to_cpumask(spu->node);
-		cpumask_t cpumask = node_to_cpumask(cpu_to_node(cpu));
+		const struct cpumask *spumask = cpumask_of_node(spu->node),
+			*cpumask = cpumask_of_node(cpu_to_node(cpu));
 
-		if (!cpus_intersects(spumask, cpumask))
+		if (!cpumask_intersects(spumask, cpumask))
 			return;
 	}
 
diff --git a/arch/powerpc/platforms/cell/spufs/sched.c b/arch/powerpc/platforms/cell/spufs/sched.c
--- a/arch/powerpc/platforms/cell/spufs/sched.c
+++ b/arch/powerpc/platforms/cell/spufs/sched.c
@@ -166,9 +166,9 @@ static int __node_allowed(struct spu_con
 static int __node_allowed(struct spu_context *ctx, int node)
 {
 	if (nr_cpus_node(node)) {
-		cpumask_t mask = node_to_cpumask(node);
+		const struct cpumask *mask = cpumask_of_node(node);
 
-		if (cpus_intersects(mask, ctx->cpus_allowed))
+		if (cpumask_intersects(mask, &ctx->cpus_allowed))
 			return 1;
 	}
 

