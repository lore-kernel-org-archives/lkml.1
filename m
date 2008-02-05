Return-Path: <linux-kernel-owner+w=401wt.eu-S932119AbYBEV5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbYBEV5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 16:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757800AbYBEV5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 16:57:31 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:38654 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbYBEV53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 16:57:29 -0500
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
Date: Tue, 05 Feb 2008 16:57:32 -0500
Message-Id: <1202248652.5332.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a patch that addresses the problem w/o requiring change to
numactl or libnuma.  It DOES have side affects, discussed in the
description.

Tested with memoryless nodes and restricted cpusets using the numactl
installed with RHEL5.1.

Altho' nominally against 24-mm1, applies cleanly to 2.6.24.  Should be
suitable for 'stable' if everyone agrees.

Lee
----------------------------------

[PATCH] 2.6.24-mm1 - mempolicy:  silently restrict to allowed nodes

Kosaki-san noted that "numactl --interleave=all ..." failed in the
presence of memoryless nodes.  This patch attempts to fix that 
problem.

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

1) modify contextualize_policy to just remove the non-allowed
   nodes, as is currently done in-line for mbind().  This
   guarantees that the resulting mask includes only nodes with
   memory.

   NOTE:  this is a [benign, IMO] change in behavior for
          set_mempolicy().  Dis-allowed nodes will be silently
          ignored, rather than returning an error.

          Another, perhaps less benign, change in behavior:
          MPOL_PREFERRED policy that specifies only memoryless nodes
          or nodes that are disallowed in the cpuset will be interpreted
          as "local allocation" as the nodemask will be empty after
          the masking in contextualize_policy().  With a bit of
          additional hackery I can make this return EINVAL.

          Comments?

2) modify mbind() to use contextualize_policy(), like set_mempolicy(),
   instead of masking nodes in-line.

3) remove the now redundant check for memoryless nodes from
   mpol_check_policy().

4) remove the masking of policy nodes for interleave policy from
   mpol_new().

Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/mempolicy.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

Index: Linux/mm/mempolicy.c
===================================================================
--- Linux.orig/mm/mempolicy.c	2008-02-05 11:25:17.000000000 -0500
+++ Linux/mm/mempolicy.c	2008-02-05 16:03:11.000000000 -0500
@@ -131,7 +131,7 @@ static int mpol_check_policy(int mode, n
 			return -EINVAL;
 		break;
 	}
- 	return nodes_subset(*nodes, node_states[N_HIGH_MEMORY]) ? 0 : -EINVAL;
+ 	return 0;
 }
 
 /* Generate a custom zonelist for the BIND policy. */
@@ -188,8 +188,6 @@ static struct mempolicy *mpol_new(int mo
 	switch (mode) {
 	case MPOL_INTERLEAVE:
 		policy->v.nodes = *nodes;
-		nodes_and(policy->v.nodes, policy->v.nodes,
-					node_states[N_HIGH_MEMORY]);
 		if (nodes_weight(policy->v.nodes) == 0) {
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
@@ -426,9 +424,13 @@ static int contextualize_policy(int mode
 	if (!nodes)
 		return 0;
 
+	/*
+	 * Restrict the nodes to the allowed nodes in the cpuset.
+	 * This is guaranteed to be a subset of nodes with memory.
+	 */
 	cpuset_update_task_memory_state();
-	if (!cpuset_nodes_subset_current_mems_allowed(*nodes))
-		return -EINVAL;
+	nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
+
 	return mpol_check_policy(mode, nodes);
 }
 
@@ -797,7 +799,7 @@ static long do_mbind(unsigned long start
 	if (end == start)
 		return 0;
 
-	if (mpol_check_policy(mode, nmask))
+	if (contextualize_policy(mode, nmask))
 		return -EINVAL;
 
 	new = mpol_new(mode, nmask);
@@ -915,10 +917,6 @@ asmlinkage long sys_mbind(unsigned long 
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-#ifdef CONFIG_CPUSETS
-	/* Restrict the nodes to the allowed nodes in the cpuset */
-	nodes_and(nodes, nodes, current->mems_allowed);
-#endif
 	return do_mbind(start, len, mode, &nodes, flags);
 }
 



