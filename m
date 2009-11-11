Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbZKKC0o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbZKKC0o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 21:26:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbZKKC0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 21:26:43 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51340 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756333AbZKKC0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 21:26:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 11 Nov 2009 11:24:04 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       cl@linux-foundation.org, rientjes@google.com
Subject: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with nodemask v3
Message-Id: <20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com>
	<20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110163419.361E.A69D9226@jp.fujitsu.com>
	<20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
	<20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>

Fixing node-oriented allocation handling in oom-kill.c
I myself think this as bugfix not as ehnancement.

In these days, things are changed as
  - alloc_pages() eats nodemask as its arguments, __alloc_pages_nodemask().
  - mempolicy don't maintain its own private zonelists.
  (And cpuset doesn't use nodemask for __alloc_pages_nodemask())

But, current oom-killer's doesn't handle nodemask and it's wrong.

This patch does
  - check nodemask, if nodemask && nodemask doesn't cover all
    node_states[N_HIGH_MEMORY], this is CONSTRAINT_MEMORY_POLICY.
  - Scan all zonelist under nodemask, if it hits cpuset's wall
    this faiulre is from cpuset.
And
  - modifies the caller of out_of_memory not to call oom if __GFP_THISNODE.
    This doesn't change "current" behavior.
    If callers use __GFP_THISNODE, it should handle "page allocation failure"
    by itself.

Changelog: 2009/11/11
 - fixed nodes_equal() calculation.
 - return CONSTRAINT_MEMPOLICY always if given nodemask is not enough big.

Changelog: 2009/11/06
 - fixed lack of oom.h

Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hioryu@jp.fujitsu.com>
---
 drivers/char/sysrq.c |    2 +-
 include/linux/oom.h  |    4 +++-
 mm/oom_kill.c        |   44 ++++++++++++++++++++++++++++++++------------
 mm/page_alloc.c      |   10 ++++++++--
 4 files changed, 44 insertions(+), 16 deletions(-)

Index: mm-test-kernel/drivers/char/sysrq.c
===================================================================
--- mm-test-kernel.orig/drivers/char/sysrq.c
+++ mm-test-kernel/drivers/char/sysrq.c
@@ -339,7 +339,7 @@ static struct sysrq_key_op sysrq_term_op
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0);
+	out_of_memory(node_zonelist(0, GFP_KERNEL), GFP_KERNEL, 0, NULL);
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
Index: mm-test-kernel/mm/oom_kill.c
===================================================================
--- mm-test-kernel.orig/mm/oom_kill.c
+++ mm-test-kernel/mm/oom_kill.c
@@ -196,27 +196,45 @@ unsigned long badness(struct task_struct
 /*
  * Determine the type of allocation constraint.
  */
+#ifdef CONFIG_NUMA
 static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
-						    gfp_t gfp_mask)
+				    gfp_t gfp_mask, nodemask_t *nodemask)
 {
-#ifdef CONFIG_NUMA
 	struct zone *zone;
 	struct zoneref *z;
 	enum zone_type high_zoneidx = gfp_zone(gfp_mask);
-	nodemask_t nodes = node_states[N_HIGH_MEMORY];
+	int ret = CONSTRAINT_NONE;
 
-	for_each_zone_zonelist(zone, z, zonelist, high_zoneidx)
-		if (cpuset_zone_allowed_softwall(zone, gfp_mask))
-			node_clear(zone_to_nid(zone), nodes);
-		else
+	/*
+ 	 * The nodemask here is a nodemask passed to alloc_pages(). Now,
+ 	 * cpuset doesn't use this nodemask for its hardwall/softwall/hierarchy
+ 	 * feature. mempolicy is an only user of nodemask here.
+ 	 */
+	if (nodemask) {
+		nodemask_t mask;
+		/* check mempolicy's nodemask contains all N_HIGH_MEMORY */
+		nodes_and(mask, *nodemask, node_states[N_HIGH_MEMORY]);
+		if (!nodes_equal(mask, node_states[N_HIGH_MEMORY]))
+			return CONSTRAINT_MEMORY_POLICY;
+	}
+
+	/* Check this allocation failure is caused by cpuset's wall function */
+	for_each_zone_zonelist_nodemask(zone, z, zonelist,
+			high_zoneidx, nodemask)
+		if (!cpuset_zone_allowed_softwall(zone, gfp_mask))
 			return CONSTRAINT_CPUSET;
 
-	if (!nodes_empty(nodes))
-		return CONSTRAINT_MEMORY_POLICY;
-#endif
+	/* __GFP_THISNODE never calls OOM.*/
 
 	return CONSTRAINT_NONE;
 }
+#else
+static inline enum oom_constraint constrained_alloc(struct zonelist *zonelist,
+				gfp_t gfp_mask, nodemask_t *nodemask)
+{
+	return CONSTRAINT_NONE;
+}
+#endif
 
 /*
  * Simple selection loop. We chose the process with the highest
@@ -603,7 +621,8 @@ rest_and_return:
  * OR try to be smart about which process to kill. Note that we
  * don't have to be perfect here, we just have to be good.
  */
-void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order)
+void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		int order, nodemask_t *nodemask)
 {
 	unsigned long freed = 0;
 	enum oom_constraint constraint;
@@ -622,11 +641,12 @@ void out_of_memory(struct zonelist *zone
 	 * Check if there were limitations on the allocation (only relevant for
 	 * NUMA) that may require different handling.
 	 */
-	constraint = constrained_alloc(zonelist, gfp_mask);
+	constraint = constrained_alloc(zonelist, gfp_mask, nodemask);
 	read_lock(&tasklist_lock);
 
 	switch (constraint) {
 	case CONSTRAINT_MEMORY_POLICY:
+		/* kill by process's its own memory alloc limitation */
 		oom_kill_process(current, gfp_mask, order, 0, NULL,
 				"No available memory (MPOL_BIND)");
 		break;
Index: mm-test-kernel/mm/page_alloc.c
===================================================================
--- mm-test-kernel.orig/mm/page_alloc.c
+++ mm-test-kernel/mm/page_alloc.c
@@ -1667,9 +1667,15 @@ __alloc_pages_may_oom(gfp_t gfp_mask, un
 	/* The OOM killer will not help higher order allocs */
 	if (order > PAGE_ALLOC_COSTLY_ORDER && !(gfp_mask & __GFP_NOFAIL))
 		goto out;
-
+	/*
+	 * In usual, GFP_THISNODE contains __GFP_NORETRY and we never hit this.
+	 * Sanity check for bare calls of __GFP_THISNODE, not real OOM.
+	 * Note: Hugepage uses it but will hit PAGE_ALLOC_COSTLY_ORDER.
+	 */
+	if (gfp_mask & __GFP_THISNODE)
+		goto out;
 	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(zonelist, gfp_mask, order);
+	out_of_memory(zonelist, gfp_mask, order, nodemask);
 
 out:
 	clear_zonelist_oom(zonelist, gfp_mask);
Index: mm-test-kernel/include/linux/oom.h
===================================================================
--- mm-test-kernel.orig/include/linux/oom.h
+++ mm-test-kernel/include/linux/oom.h
@@ -10,6 +10,7 @@
 #ifdef __KERNEL__
 
 #include <linux/types.h>
+#include <linux/nodemask.h>
 
 struct zonelist;
 struct notifier_block;
@@ -26,7 +27,8 @@ enum oom_constraint {
 extern int try_set_zone_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 extern void clear_zonelist_oom(struct zonelist *zonelist, gfp_t gfp_flags);
 
-extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask, int order);
+extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		int order, nodemask_t *mask);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 

