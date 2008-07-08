Return-Path: <linux-kernel-owner+w=401wt.eu-S1754462AbYGHVfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462AbYGHVfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 17:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbYGHVfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 17:35:24 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:59951 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750965AbYGHVfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 17:35:23 -0400
Message-ID: <4873DD99.7050001@sgi.com>
Date: Tue, 08 Jul 2008 14:35:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       mm-commits@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const
 ptr
References: <200806090918.m599Ib0G012837@imap1.linux-foundation.org>	 <48651EF5.5090808@sgi.com> <20080703084401.GB7873@elte.hu>	 <19f34abd0807030155x22b0033dj780830bad840216f@mail.gmail.com>	 <20080703090100.GA10872@elte.hu> <48739E87.2060604@sgi.com>	 <19f34abd0807081035k2c7a18eckc8aa749a6f015f65@mail.gmail.com>	 <4873AC5C.1040705@sgi.com>	 <19f34abd0807081122p20c73cd9p7129d297ac36a3ad@mail.gmail.com>	 <4873D33B.4040300@sgi.com> <19f34abd0807081421j67771dbclfae1fcfaa9ad4bcd@mail.gmail.com>
In-Reply-To: <19f34abd0807081421j67771dbclfae1fcfaa9ad4bcd@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 1/1] x86: Change _node_to_cpumask_ptr to return const ptr

  * Strengthen the return type for the _node_to_cpumask_ptr to be
    a const pointer.  This adds compiler checking to insure that
    node_to_cpumask_map[] is not changed inadvertently.

Applies to tip/master with the following patch applied:

	"[PATCH 1/1] x86: Add check for node passed to node_to_cpumask V3"

Signed-off-by: Mike Travis <travis@sgi.com>
---
 arch/x86/kernel/setup_percpu.c |    8 ++++----
 include/asm-generic/topology.h |    3 ++-
 include/asm-x86/topology.h     |   10 +++++-----
 3 files changed, 11 insertions(+), 10 deletions(-)

--- linux-2.6.tip.orig/arch/x86/kernel/setup_percpu.c
+++ linux-2.6.tip/arch/x86/kernel/setup_percpu.c
@@ -353,23 +353,23 @@ static const cpumask_t cpu_mask_none;
 /*
  * Returns a pointer to the bitmask of CPUs on Node 'node'.
  */
-cpumask_t *_node_to_cpumask_ptr(int node)
+const cpumask_t *_node_to_cpumask_ptr(int node)
 {
 	if (node_to_cpumask_map == NULL) {
 		printk(KERN_WARNING
 			"_node_to_cpumask_ptr(%d): no node_to_cpumask_map!\n",
 			node);
 		dump_stack();
-		return &cpu_online_map;
+		return (const cpumask_t *)&cpu_online_map;
 	}
 	if (node >= nr_node_ids) {
 		printk(KERN_WARNING
 			"_node_to_cpumask_ptr(%d): node > nr_node_ids(%d)\n",
 			node, nr_node_ids);
 		dump_stack();
-		return (cpumask_t *)&cpu_mask_none;
+		return &cpu_mask_none;
 	}
-	return (cpumask_t *)&node_to_cpumask_map[node];
+	return &node_to_cpumask_map[node];
 }
 EXPORT_SYMBOL(_node_to_cpumask_ptr);
 
--- linux-2.6.tip.orig/include/asm-generic/topology.h
+++ linux-2.6.tip/include/asm-generic/topology.h
@@ -60,7 +60,8 @@
 #ifndef node_to_cpumask_ptr
 
 #define	node_to_cpumask_ptr(v, node) 					\
-		cpumask_t _##v = node_to_cpumask(node), *v = &_##v
+		cpumask_t _##v = node_to_cpumask(node);			\
+		const cpumask_t *v = &_##v
 
 #define node_to_cpumask_ptr_next(v, node)				\
 			  _##v = node_to_cpumask(node)
--- linux-2.6.tip.orig/include/asm-x86/topology.h
+++ linux-2.6.tip/include/asm-x86/topology.h
@@ -82,7 +82,7 @@ DECLARE_EARLY_PER_CPU(int, x86_cpu_to_no
 #ifdef CONFIG_DEBUG_PER_CPU_MAPS
 extern int cpu_to_node(int cpu);
 extern int early_cpu_to_node(int cpu);
-extern cpumask_t *_node_to_cpumask_ptr(int node);
+extern const cpumask_t *_node_to_cpumask_ptr(int node);
 extern cpumask_t node_to_cpumask(int node);
 
 #else	/* !CONFIG_DEBUG_PER_CPU_MAPS */
@@ -103,7 +103,7 @@ static inline int early_cpu_to_node(int 
 }
 
 /* Returns a pointer to the cpumask of CPUs on Node 'node'. */
-static inline cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const cpumask_t *_node_to_cpumask_ptr(int node)
 {
 	return &node_to_cpumask_map[node];
 }
@@ -118,7 +118,7 @@ static inline cpumask_t node_to_cpumask(
 
 /* Replace default node_to_cpumask_ptr with optimized version */
 #define node_to_cpumask_ptr(v, node)		\
-		cpumask_t *v = _node_to_cpumask_ptr(node)
+		const cpumask_t *v = _node_to_cpumask_ptr(node)
 
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = _node_to_cpumask_ptr(node)
@@ -186,7 +186,7 @@ extern int __node_distance(int, int);
 #define	cpu_to_node(cpu)	0
 #define	early_cpu_to_node(cpu)	0
 
-static inline cpumask_t *_node_to_cpumask_ptr(int node)
+static inline const cpumask_t *_node_to_cpumask_ptr(int node)
 {
 	return &cpu_online_map;
 }
@@ -201,7 +201,7 @@ static inline int node_to_first_cpu(int 
 
 /* Replace default node_to_cpumask_ptr with optimized version */
 #define node_to_cpumask_ptr(v, node)		\
-		cpumask_t *v = _node_to_cpumask_ptr(node)
+		const cpumask_t *v = _node_to_cpumask_ptr(node)
 
 #define node_to_cpumask_ptr_next(v, node)	\
 			   v = _node_to_cpumask_ptr(node)
