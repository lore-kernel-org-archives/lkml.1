Return-Path: <linux-kernel-owner+w=401wt.eu-S1756015AbYBFRiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756015AbYBFRiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 12:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYBFRiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 12:38:11 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:23145 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbYBFRiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 12:38:10 -0500
Subject: Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't
	works on memoryless node.
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       David Rientjes <rientjes@google.com>, Mel Gorman <mel@csn.ul.ie>,
       torvalds@linux-foundation.org, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1202149243.5028.61.camel@localhost>
	 <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 06 Feb 2008 12:38:15 -0500
Message-Id: <1202319495.5453.64.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've updated the patch to restore some error checking that my previous
version and the memoryless-nodes series lost.  

Again, tested with "numactl --interleave=all" and memtoy on ia64 using
mem= command line argument to simulate memoryless node.

Lee
----------------------------------
[PATCH] 2.6.24-mm1 - mempolicy:  silently restrict to allowed nodes

V1 -> V2:
+ Communicate whether or not incoming node mask was empty to
  mpol_check_policy() for better error checking.
+ As suggested by David Rientjes, remove the now unused
   cpuset_nodes_subset_current_mems_allowed() from cpuset.h

Kosaki Motohito noted that "numactl --interleave=all ..." failed in the
presence of memoryless nodes.  This patch attempts to fix that problem.

Some background:  

numactl --interleave=all calls set_mempolicy(2) with a fully
populated [out to MAXNUMNODES] nodemask.  set_mempolicy()
[in do_set_mempolicy()] calls contextualize_policy() which
requires that the nodemask be a subset of the current task's
mems_allowed; else EINVAL will be returned.  A task's
mems_allowed will always be a subset of node_states[N_HIGH_MEMORY]--
i.e., nodes with memory.  So, a fully populated nodemask will
be declared invalid if it includes memoryless nodes.

  NOTE:  the same thing will occur when running in a cpuset
         with restricted mem_allowed--for the same reason:
         node mask contains dis-allowed nodes.

mbind(2), on the other hand, just masks off any nodes in the 
nodemask that are not included in the caller's mems_allowed.

In each case [mbind() and set_mempolicy()], mpol_check_policy()
will complain [again, resulting in EINVAL] if the nodemask contains 
any memoryless nodes.  This is somewhat redundant as mpol_new() 
will remove memoryless nodes for interleave policy, as will 
bind_zonelist()--called by mpol_new() for BIND policy.

Proposed fix:

1) modify contextualize_policy to:
   a) remember whether the incoming node mask is empty.
   b) if not, restrict the nodemask to allowed nodes, as is
      currently done in-line for mbind().  This guarantees
      that the resulting mask includes only nodes with memory.

      NOTE:  this is a [benign, IMO] change in behavior for
             set_mempolicy().  Dis-allowed nodes will be
             silently ignored, rather than returning an error.

   c) pass the "was_empty" state of the incoming mask to
      mpol_check_policy() for vetting the user specified 
      nodemask for MPOL_DEFAULT and MPOL_PREFERRED

2) In mpol_check_policy():
   a) MPOL_DEFAULT:  require that in coming mask "was_empty"
   a) add a case for MPOL_PREFERRED:  if in coming was not empty
      and resulting mask IS empty, user specified invalid nodes.
      Return EINVAL.
   b) remove the now redundant check for memoryless nodes

3) modify mbind() to use contextualize_policy(), like set_mempolicy(),
   instead of masking nodes in-line.  This preserves the current
   behavior of mbind() and restores some error checking that the
   memoryless-nodes series lost when restricting node masks to
   allowed_nodes [== subset of nodes with memory].

4) remove the now redundant masking of policy nodes for interleave
   policy from mpol_new().

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 include/linux/cpuset.h |    3 --
 mm/mempolicy.c         |   50 ++++++++++++++++++++++++++++++++-----------------
 2 files changed, 33 insertions(+), 20 deletions(-)

Index: Linux/mm/mempolicy.c
===================================================================
--- Linux.orig/mm/mempolicy.c	2008-02-05 16:51:19.000000000 -0500
+++ Linux/mm/mempolicy.c	2008-02-06 10:58:57.000000000 -0500
@@ -114,24 +114,37 @@ static void mpol_rebind_policy(struct me
                                const nodemask_t *newmask);
 
 /* Do sanity checking on a policy */
-static int mpol_check_policy(int mode, nodemask_t *nodes)
+static int mpol_check_policy(int mode, nodemask_t *nodes, int was_empty)
 {
-	int empty = nodes_empty(*nodes);
+	int is_empty = nodes_empty(*nodes);
 
 	switch (mode) {
 	case MPOL_DEFAULT:
-		if (!empty)
+		/*
+		 * require caller to specify an empty nodemask
+		 * before "contextualization"
+		 */
+		if (!was_empty)
 			return -EINVAL;
 		break;
 	case MPOL_BIND:
 	case MPOL_INTERLEAVE:
-		/* Preferred will only use the first bit, but allow
-		   more for now. */
-		if (empty)
+		/*
+		 * require at least 1 valid node after "contextualization"
+		 */
+		if (is_empty)
+			return -EINVAL;
+		break;
+	case MPOL_PREFERRED:
+		/*
+		 * Did caller specify invalid nodes?
+		 * Don't silently accept this as "local allocation".
+		 */
+		if (!was_empty && is_empty)
 			return -EINVAL;
 		break;
 	}
- 	return nodes_subset(*nodes, node_states[N_HIGH_MEMORY]) ? 0 : -EINVAL;
+ 	return 0;
 }
 
 /* Generate a custom zonelist for the BIND policy. */
@@ -188,8 +201,6 @@ static struct mempolicy *mpol_new(int mo
 	switch (mode) {
 	case MPOL_INTERLEAVE:
 		policy->v.nodes = *nodes;
-		nodes_and(policy->v.nodes, policy->v.nodes,
-					node_states[N_HIGH_MEMORY]);
 		if (nodes_weight(policy->v.nodes) == 0) {
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
@@ -423,13 +434,22 @@ static int mbind_range(struct vm_area_st
 
 static int contextualize_policy(int mode, nodemask_t *nodes)
 {
+	int was_empty;
+
 	if (!nodes)
 		return 0;
 
+	/*
+	 * Remember whether in coming nodemask was empty,  If not,
+	 * restrict the nodes to the allowed nodes in the cpuset.
+	 * This is guaranteed to be a subset of nodes with memory.
+	 */
 	cpuset_update_task_memory_state();
-	if (!cpuset_nodes_subset_current_mems_allowed(*nodes))
-		return -EINVAL;
-	return mpol_check_policy(mode, nodes);
+	was_empty = nodes_empty(*nodes);
+	if (!was_empty)
+		nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
+
+	return mpol_check_policy(mode, nodes, was_empty);
 }
 
 
@@ -797,7 +817,7 @@ static long do_mbind(unsigned long start
 	if (end == start)
 		return 0;
 
-	if (mpol_check_policy(mode, nmask))
+	if (contextualize_policy(mode, nmask))
 		return -EINVAL;
 
 	new = mpol_new(mode, nmask);
@@ -915,10 +935,6 @@ asmlinkage long sys_mbind(unsigned long 
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-#ifdef CONFIG_CPUSETS
-	/* Restrict the nodes to the allowed nodes in the cpuset */
-	nodes_and(nodes, nodes, current->mems_allowed);
-#endif
 	return do_mbind(start, len, mode, &nodes, flags);
 }
 
Index: Linux/include/linux/cpuset.h
===================================================================
--- Linux.orig/include/linux/cpuset.h	2008-02-05 16:05:15.000000000 -0500
+++ Linux/include/linux/cpuset.h	2008-02-06 10:47:48.000000000 -0500
@@ -26,8 +26,6 @@ extern nodemask_t cpuset_mems_allowed(st
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
 void cpuset_update_task_memory_state(void);
-#define cpuset_nodes_subset_current_mems_allowed(nodes) \
-		nodes_subset((nodes), current->mems_allowed)
 int cpuset_zonelist_valid_mems_allowed(struct zonelist *zl);
 
 extern int __cpuset_zone_allowed_softwall(struct zone *z, gfp_t gfp_mask);
@@ -103,7 +101,6 @@ static inline nodemask_t cpuset_mems_all
 #define cpuset_current_mems_allowed (node_states[N_HIGH_MEMORY])
 static inline void cpuset_init_current_mems_allowed(void) {}
 static inline void cpuset_update_task_memory_state(void) {}
-#define cpuset_nodes_subset_current_mems_allowed(nodes) (1)
 
 static inline int cpuset_zonelist_valid_mems_allowed(struct zonelist *zl)
 {


