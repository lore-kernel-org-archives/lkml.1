Return-Path: <linux-kernel-owner+w=401wt.eu-S1756093AbXJaHMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756093AbXJaHMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 03:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbXJaHMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 03:12:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:38880 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752709AbXJaHME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 03:12:04 -0400
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Andi Kleen <ak@suse.de>
Date: Wed, 31 Oct 2007 00:12:03 -0700
Message-Id: <20071031071203.21924.70083.sendpatchset@jackhammer.engr.sgi.com>
Subject: [RFC] mempolicy minor code cleanups
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Some minor code cleanups for mm/mempolicy.c.

This patch should have been sent out before,
to be applied first to 2.6.23-mm1, -before-
another patch I sent out an hour ago:

    [RFC] cpuset relative memory policies - second choice

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 include/linux/mempolicy.h |    5 +++--
 mm/mempolicy.c            |   20 ++++++++++----------
 2 files changed, 13 insertions(+), 12 deletions(-)

--- 2.6.23-mm1.orig/include/linux/mempolicy.h	2007-10-30 03:29:37.000000000 -0700
+++ 2.6.23-mm1/include/linux/mempolicy.h	2007-10-30 04:14:58.000000000 -0700
@@ -23,7 +23,8 @@
 
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
-#define MPOL_MF_MOVE	(1<<1)	/* Move pages owned by this process to conform to mapping */
+#define MPOL_MF_MOVE	(1<<1)	/* Move pages owned by this process to conform
+								to mapping */
 #define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
 #define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
 
@@ -48,7 +49,7 @@ struct mm_struct;
  * the process policy is used. Interrupts ignore the memory policy
  * of the current process.
  *
- * Locking policy for interlave:
+ * Locking policy for interleave:
  * In process context there is no locking because only the process accesses
  * its own state. All vma manipulation is somewhat protected by a down_read on
  * mmap_sem.
--- 2.6.23-mm1.orig/mm/mempolicy.c	2007-10-30 03:29:37.000000000 -0700
+++ 2.6.23-mm1/mm/mempolicy.c	2007-10-30 04:15:05.000000000 -0700
@@ -25,7 +25,7 @@
  *                to the last. It would be better if bind would truly restrict
  *                the allocation to memory nodes instead
  *
- * preferred       Try a specific node first before normal fallback.
+ * preferred      Try a specific node first before normal fallback.
  *                As a special case node -1 here means do the allocation
  *                on the local CPU. This is normally identical to default,
  *                but useful to set in a VMA when you have a non default
@@ -541,7 +541,7 @@ static long do_get_mempolicy(int *policy
 		if (flags & (MPOL_F_NODE|MPOL_F_ADDR))
 			return -EINVAL;
 		*policy = 0;	/* just so it's initialized */
-		*nmask  = cpuset_current_mems_allowed;
+		*nmask = cpuset_current_mems_allowed;
 		return 0;
 	}
 
@@ -688,7 +688,7 @@ int do_migrate_pages(struct mm_struct *m
 
 	tmp = *from_nodes;
 	while (!nodes_empty(tmp)) {
-		int s,d;
+		int s, d;
 		int source = -1;
 		int dest = 0;
 
@@ -783,6 +783,8 @@ static long do_mbind(unsigned long start
 	if (mpol_check_policy(mode, nmask))
 		return -EINVAL;
 
+	cpuset_update_task_memory_state();
+
 	new = mpol_new(mode, nmask);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
@@ -794,7 +796,7 @@ static long do_mbind(unsigned long start
 	if (!new)
 		flags |= MPOL_MF_DISCONTIG_OK;
 
-	pr_debug("mbind %lx-%lx mode:%ld nodes:%lx\n",start,start+len,
+	pr_debug("mbind %lx-%lx mode:%ld nodes:%lx\n", start, start+len,
 		 mode, nmask ? nodes_addr(*nmask)[0] : -1);
 
 	down_write(&mm->mmap_sem);
@@ -898,10 +900,8 @@ asmlinkage long sys_mbind(unsigned long 
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
-#ifdef CONFIG_CPUSETS
 	/* Restrict the nodes to the allowed nodes in the cpuset */
-	nodes_and(nodes, nodes, current->mems_allowed);
-#endif
+	nodes_and(nodes, nodes, cpuset_current_mems_allowed);
 	return do_mbind(start, len, mode, &nodes, flags);
 }
 
@@ -1384,7 +1384,7 @@ EXPORT_SYMBOL(alloc_pages_current);
 
 /*
  * If mpol_copy() sees current->cpuset == cpuset_being_rebound, then it
- * rebinds the mempolicy its copying by calling mpol_rebind_policy()
+ * rebinds the mempolicy it's copying by calling mpol_rebind_policy()
  * with the mems_allowed returned by cpuset_mems_allowed().  This
  * keeps mempolicies cpuset relative after its cpuset moves.  See
  * further kernel/cpuset.c update_nodemask().
@@ -1741,9 +1741,9 @@ static void mpol_rebind_policy(struct me
 	case MPOL_INTERLEAVE:
 		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
-		*mpolmask = *newmask;
 		current->il_next = node_remap(current->il_next,
 						*mpolmask, *newmask);
+		*mpolmask = *newmask;
 		break;
 	case MPOL_PREFERRED:
 		pol->v.preferred_node = node_remap(pol->v.preferred_node,
@@ -1763,7 +1763,7 @@ static void mpol_rebind_policy(struct me
 
 		zonelist = bind_zonelist(&nodes);
 
-		/* If no mem, then zonelist is NULL and we keep old zonelist.
+		/* If no mem, then zonelist is -ENOMEM and we keep old zonelist.
 		 * If that old zonelist has no remaining mems_allowed nodes,
 		 * then zonelist_policy() will "FALL THROUGH" to MPOL_DEFAULT.
 		 */

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
