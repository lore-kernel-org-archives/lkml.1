Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYKUKpQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYKUKpQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:45:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753492AbYKUKoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:44:46 -0500
Received: from ozlabs.org ([203.10.76.45]:45217 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753214AbYKUKop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:44:45 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:12:13 +1030
Subject: [PATCH 2/8] cpumask: alpha: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Cc: Richard Henderson <rth@twiddle.net>
Message-Id: <20081121104444.08783DDEE2@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

I'm not sure the existing code even compiles, but new version is
straightforward.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Richard Henderson <rth@twiddle.net>
---
 arch/alpha/include/asm/topology.h |   17 +++++++++++++++++
 arch/alpha/kernel/setup.c         |    5 +++++
 2 files changed, 22 insertions(+)

diff --git a/arch/alpha/include/asm/topology.h b/arch/alpha/include/asm/topology.h
--- a/arch/alpha/include/asm/topology.h
+++ b/arch/alpha/include/asm/topology.h
@@ -39,7 +39,24 @@ static inline cpumask_t node_to_cpumask(
 	return node_cpu_mask;
 }
 
+extern struct cpumask node_to_cpumask_map[];
+/* FIXME: This is dumb, recalculating every time.  But simple. */
+static const struct cpumask *cpumask_of_node(int node)
+{
+	int cpu;
+
+	cpumask_clear(&node_to_cpumask_map[node]);
+
+	for_each_online_cpu(cpu) {
+		if (cpu_to_node(cpu) == node)
+			cpumask_set_cpu(cpu, node_to_cpumask_map[node]);
+	}
+
+	return &node_to_cpumask_map[node];
+}
+
 #define pcibus_to_cpumask(bus)	(cpu_online_map)
+#define cpumask_of_pcibus(bus)	(cpu_online_mask)
 
 #endif /* !CONFIG_NUMA */
 # include <asm-generic/topology.h>
diff --git a/arch/alpha/kernel/setup.c b/arch/alpha/kernel/setup.c
--- a/arch/alpha/kernel/setup.c
+++ b/arch/alpha/kernel/setup.c
@@ -77,6 +77,11 @@ int alpha_l3_cacheshape;
 /* 0=minimum, 1=verbose, 2=all */
 /* These can be overridden via the command line, ie "verbose_mcheck=2") */
 unsigned long alpha_verbose_mcheck = CONFIG_VERBOSE_MCHECK_ON;
+#endif
+
+#ifdef CONFIG_NUMA
+struct cpumask node_to_cpumask_map[MAX_NUMNODES] __read_mostly;
+EXPORT_SYMBOL(node_to_cpumask_map);
 #endif
 
 /* Which processor we booted from.  */

