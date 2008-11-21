Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYKUKo4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYKUKo4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 05:44:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYKUKop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 05:44:45 -0500
Received: from ozlabs.org ([203.10.76.45]:45216 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752848AbYKUKop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 05:44:45 -0500
To: linux-kernel@vger.kernel.org
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 21 Nov 2008 21:12:13 +1030
Subject: [PATCH 1/8] cpumask: Introduce cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
Message-Id: <20081121104443.67C3FDDED9@ozlabs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: New APIs

The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
return a pointer to a struct cpumask.  Part of removing cpumasks from
the stack.

Please take (or ack) the patch for your arch so I can get substitute
the callers and kill the old versions.

This does the generic ones.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Richard Henderson <rth@twiddle.net>
---
 include/asm-generic/topology.h |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/asm-generic/topology.h b/include/asm-generic/topology.h
--- a/include/asm-generic/topology.h
+++ b/include/asm-generic/topology.h
@@ -40,6 +40,9 @@
 #ifndef node_to_cpumask
 #define node_to_cpumask(node)	((void)node, cpu_online_map)
 #endif
+#ifndef cpumask_of_node
+#define cpumask_of_node(node)	((void)node, cpu_online_mask)
+#endif
 #ifndef node_to_first_cpu
 #define node_to_first_cpu(node)	((void)(node),0)
 #endif
@@ -54,9 +57,18 @@
 				)
 #endif
 
+#ifndef cpumask_of_pcibus
+#define cpumask_of_pcibus(bus)	(pcibus_to_node(bus) == -1 ?		\
+				 cpu_all_mask :				\
+				 cpumask_of_node(pcibus_to_node(bus)))
+#endif
+
 #endif	/* CONFIG_NUMA */
 
-/* returns pointer to cpumask for specified node */
+/*
+ * returns pointer to cpumask for specified node
+ * Deprecated: use "const struct cpumask *mask = cpumask_of_node(node)"
+ */
 #ifndef node_to_cpumask_ptr
 
 #define	node_to_cpumask_ptr(v, node) 					\

