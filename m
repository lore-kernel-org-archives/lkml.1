Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbYF0RK1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbYF0RK1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 13:10:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753568AbYF0RKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 13:10:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59768 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752004AbYF0RKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 13:10:15 -0400
Message-ID: <48651EF5.5090808@sgi.com>
Date: Fri, 27 Jun 2008 10:10:13 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Vegard Nossum <vegard.nossum@gmail.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask
 V3
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org> <19f34abd0806090420r4100241cgb4b828441de3b102@mail.gmail.com> <20080609113547.GA1534@elte.hu> <484D54F2.4070603@sgi.com> <20080626113229.GB29619@elte.hu> <4863C334.2090007@sgi.com> <486452CC.8050502@sgi.com>
In-Reply-To: <486452CC.8050502@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3

  * When CONFIG_DEBUG_PER_CPU_MAPS is set, the node passed to
    node_to_cpumask and node_to_cpumask_ptr should be validated.
    If invalid, then a dump_stack is performed and a zero cpumask
    is returned.

Based on "Fri Jun 27 10:06:06 PDT 2008" tip/master...  ;-) 

Signed-off-by: Mike Travis <travis@sgi.com>
---
V2: Slightly different version to remove a compiler warning.
V3: Redone to reflect moving setup.c -> setup_percpu.c
---
 arch/x86/kernel/setup_percpu.c |   26 +++++++++++++++++++++++---
 include/asm-x86/topology.h     |    7 ++++++-
 2 files changed, 29 insertions(+), 4 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -346,6 +346,10 @@ int early_cpu_to_node(int cpu)
 	return per_cpu(x86_cpu_to_node_map, cpu);
 }
 
+
+/* empty cpumask */
+static const cpumask_t cpu_mask_none;
+
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
@@ -358,13 +362,23 @@ cpumask_t *_node_to_cpumask_ptr(int node
 		dump_stack();
 		return &cpu_online_map;
 	}
-	BUG_ON(node >= nr_node_ids);
-	return &node_to_cpumask_map[node];
+	if (node >= nr_node_ids) {
+		printk(KERN_WARNING
+			"_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
+			node, nr_node_ids);
+		dump_stack();
+		return (cpumask_t *)&cpu_mask_none;
+	}
+	return (cpumask_t *)&node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(_node_to_cpumask_ptr);
 
 /*
  * Returns a bitmask of CPUs on Node 'node'.
+ *
+ * Side note: this function creates the returned cpumask on the stack
+ * so with a high NR_CPUS count, excessive stack space is used.  The
+ * node_to_cpumask_ptr function should be used whenever possible.
  */
 cpumask_t node_to_cpumask(int node)
 {
@@ -374,7 +388,13 @@ cpumask_t node_to_cpumask(int node)
 		dump_stack();
 		return cpu_online_map;
 	}
-	BUG_ON(node >= nr_node_ids);
+	if (node >= nr_node_ids) {
+		printk(KERN_WARNING
+			"node_to_cpumask(%d): node > nr_node_ids(%d)\n",
+			node, nr_node_ids);
+		dump_stack();
+		return cpu_mask_none;
+	}
 	return node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(node_to_cpumask);
--- linux-2.6.tip.orig/include/asm-x86/topology.h
+++ linux-2.6.tip/include/asm-x86/topology.h
@@ -57,7 +57,12 @@ static inline int cpu_to_node(int cpu)
 }
 #define early_cpu_to_node(cpu)	cpu_to_node(cpu)
 
-/* Returns a bitmask of CPUs on Node 'node'. */
+/* Returns a bitmask of CPUs on Node 'node'.
+ *
+ * Side note: this function creates the returned cpumask on the stack
+ * so with a high NR_CPUS count, excessive stack space is used.  The
+ * node_to_cpumask_ptr function should be used whenever possible.
+ */
 static inline cpumask_t node_to_cpumask(int node)
 {
 	return node_to_cpumask_map[node];

