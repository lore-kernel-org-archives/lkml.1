Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbXJaGRk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbXJaGRk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 02:17:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752894AbXJaGRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 02:17:32 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36598 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751540AbXJaGRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 02:17:31 -0400
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, linux-kernel@vger.kernel.org,
       Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Andi Kleen <ak@suse.de>
Date: Tue, 30 Oct 2007 23:17:29 -0700
Message-Id: <20071031061729.18174.60384.sendpatchset@jackhammer.engr.sgi.com>
Subject: [RFC] cpuset relative memory policies - second choice
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

  RFC only so far - has been built and booted, but has received
  almost no testing.

Add a second choice for how node numbers are interpreted and returned
by the NUMA memory policy system calls mbind, set_mempolicy and
get_mempolicy.

The original choice remains the default, for compatibility.

The second choice overcomes some limitations of the first choice in
the interaction between cpusets and these memory policy calls, that
show up when tasks using these calls are also being moved between
different cpusets, especially between cpusets with varying numbers
of allowed nodes in the cpuset 'mems' file.

A new per-task mode, managed using added get_mempolicy calls, controls
which mode applies to subsequently created memory policies.

See the Documentation/vm/numa_memory_policy.txt section MEMORY
POLICIES AND CPUSETS for an explanation of how both these choices
for node numbering work and interact with cpusets.

Signed-off-by: Paul Jackson <pj@sgi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee.Schermerhorn@hp.com
Cc: Andi Kleen <ak@suse.de>

---
 Documentation/vm/numa_memory_policy.txt |  140 +++++++++++++++++++++++++-------
 include/linux/mempolicy.h               |   15 +++
 include/linux/sched.h                   |    1 
 mm/mempolicy.c                          |  123 +++++++++++++++++++++++-----
 4 files changed, 229 insertions(+), 50 deletions(-)

--- 2.6.23-mm1.orig/include/linux/mempolicy.h	2007-10-30 18:04:11.000000000 -0700
+++ 2.6.23-mm1/include/linux/mempolicy.h	2007-10-30 18:11:07.000000000 -0700
@@ -21,6 +21,10 @@
 #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
 #define MPOL_F_MEMS_ALLOWED (1<<2) /* return allowed memories */
 
+#define MPOL_F_MODE_DEFAULT (1<<3) /* set cpuset confined nodemask mode */
+#define MPOL_F_MODE_SYS_WIDE (1<<4) /* set system-wide nodemask mode */
+#define MPOL_F_MODE_GET	    (1<<5) /* return number mode: old => 1, new => 0 */
+
 /* Flags for mbind */
 #define MPOL_MF_STRICT	(1<<0)	/* Verify existing pages in the mapping */
 #define MPOL_MF_MOVE	(1<<1)	/* Move pages owned by this process to conform
@@ -28,6 +32,10 @@
 #define MPOL_MF_MOVE_ALL (1<<2)	/* Move every page to conform to mapping */
 #define MPOL_MF_INTERNAL (1<<3)	/* Internal flags start here */
 
+/* Internal values for mpol_nodemask_mode (just reuse get_mem_policy values) */
+#define MPOL_MODE_DEFAULT  MPOL_F_MODE_DEFAULT  /* relative to this cpuset */
+#define MPOL_MODE_SYS_WIDE MPOL_F_MODE_SYS_WIDE /* original input mask */
+
 #ifdef __KERNEL__
 
 #include <linux/mmzone.h>
@@ -64,13 +72,18 @@ struct mm_struct;
 struct mempolicy {
 	atomic_t refcnt;
 	short policy; 	/* See MPOL_* above */
+	char mpol_nodemask_mode; /* See MPOL_MODE_* above; union c below */
 	union {
 		struct zonelist  *zonelist;	/* bind */
 		short 		 preferred_node; /* preferred */
 		nodemask_t	 nodes;		/* interleave */
 		/* undefined for default */
 	} v;
-	nodemask_t cpuset_mems_allowed;	/* mempolicy relative to these nodes */
+	/* Cpuset interface: Documentation/vm/numa_memory_policy.txt */
+	union {
+		nodemask_t cpuset_mems_allowed;	/* if MPOL_MODE_DEFAULT */
+		nodemask_t original_nodes;	/* if MPOL_MODE_SYS_WIDE */
+	} c;
 };
 
 /*
--- 2.6.23-mm1.orig/mm/mempolicy.c	2007-10-30 18:04:11.000000000 -0700
+++ 2.6.23-mm1/mm/mempolicy.c	2007-10-30 20:02:10.000000000 -0700
@@ -175,6 +175,7 @@ static struct zonelist *bind_zonelist(no
 static struct mempolicy *mpol_new(int mode, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
+	nodemask_t cpuset_centric_nodes;
 
 	pr_debug("setting mode %d nodes[0] %lx\n",
 		 mode, nodes ? nodes_addr(*nodes)[0] : -1);
@@ -185,9 +186,27 @@ static struct mempolicy *mpol_new(int mo
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
+
+	policy->mpol_nodemask_mode = current->mpol_nodemask_mode;
+	{
+		char m = current->mpol_nodemask_mode;
+		if (m != MPOL_MODE_DEFAULT && m != MPOL_MODE_SYS_WIDE)
+			printk(KERN_WARNING
+				"mempolicy mpol_new unset mode: %d\n", m);
+	}
+	if (policy->mpol_nodemask_mode == MPOL_MODE_SYS_WIDE) {
+		policy->c.original_nodes = *nodes;
+		nodes_remap(cpuset_centric_nodes, *nodes,
+						node_possible_map,
+						cpuset_current_mems_allowed);
+	} else /* MPOL_MODE_DEFAULT */ {
+		policy->c.cpuset_mems_allowed = cpuset_current_mems_allowed;
+		cpuset_centric_nodes = *nodes;
+	}
+
 	switch (mode) {
 	case MPOL_INTERLEAVE:
-		policy->v.nodes = *nodes;
+		policy->v.nodes = cpuset_centric_nodes;
 		nodes_and(policy->v.nodes, policy->v.nodes,
 					node_states[N_HIGH_MEMORY]);
 		if (nodes_weight(policy->v.nodes) == 0) {
@@ -196,12 +215,12 @@ static struct mempolicy *mpol_new(int mo
 		}
 		break;
 	case MPOL_PREFERRED:
-		policy->v.preferred_node = first_node(*nodes);
+		policy->v.preferred_node = first_node(cpuset_centric_nodes);
 		if (policy->v.preferred_node >= MAX_NUMNODES)
 			policy->v.preferred_node = -1;
 		break;
 	case MPOL_BIND:
-		policy->v.zonelist = bind_zonelist(nodes);
+		policy->v.zonelist = bind_zonelist(&cpuset_centric_nodes);
 		if (IS_ERR(policy->v.zonelist)) {
 			void *error_code = policy->v.zonelist;
 			kmem_cache_free(policy_cache, policy);
@@ -210,7 +229,6 @@ static struct mempolicy *mpol_new(int mo
 		break;
 	}
 	policy->policy = mode;
-	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
 	return policy;
 }
 
@@ -427,8 +445,10 @@ static int contextualize_policy(int mode
 		return 0;
 
 	cpuset_update_task_memory_state();
-	if (!cpuset_nodes_subset_current_mems_allowed(*nodes))
-		return -EINVAL;
+	if (current->mpol_nodemask_mode == MPOL_MODE_DEFAULT) {
+		if (!cpuset_nodes_subset_current_mems_allowed(*nodes))
+			return -EINVAL;
+	}
 	return mpol_check_policy(mode, nodes);
 }
 
@@ -533,6 +553,22 @@ static long do_get_mempolicy(int *policy
 	struct mempolicy *pol = current->mempolicy;
 
 	cpuset_update_task_memory_state();
+
+	switch (flags) {
+	case MPOL_F_MODE_DEFAULT:
+		current->mpol_nodemask_mode = MPOL_MODE_DEFAULT;
+		return 0;
+	case MPOL_F_MODE_SYS_WIDE:
+		current->mpol_nodemask_mode = MPOL_MODE_SYS_WIDE;
+		return 0;
+	case MPOL_F_MODE_GET:
+		if (current->mpol_nodemask_mode == MPOL_MODE_DEFAULT)
+			*policy = MPOL_F_MODE_DEFAULT;
+		else
+			*policy = MPOL_F_MODE_SYS_WIDE;
+		return 0;
+	}
+
 	if (flags &
 		~(unsigned long)(MPOL_F_NODE|MPOL_F_ADDR|MPOL_F_MEMS_ALLOWED))
 		return -EINVAL;
@@ -570,7 +606,12 @@ static long do_get_mempolicy(int *policy
 			*policy = err;
 		} else if (pol == current->mempolicy &&
 				pol->policy == MPOL_INTERLEAVE) {
-			*policy = current->il_next;
+			if (current->mpol_nodemask_mode == MPOL_MODE_DEFAULT)
+				*policy = current->il_next;
+			else
+				*policy = node_remap(current->il_next,
+						node_possible_map,
+						cpuset_current_mems_allowed);
 		} else {
 			err = -EINVAL;
 			goto out;
@@ -584,8 +625,12 @@ static long do_get_mempolicy(int *policy
 	}
 
 	err = 0;
-	if (nmask)
-		get_zonemask(pol, nmask);
+	if (nmask) {
+		if (current->mpol_nodemask_mode == MPOL_MODE_DEFAULT)
+			get_zonemask(pol, nmask);
+		else
+			*nmask = pol->c.original_nodes;
+	}
 
  out:
 	if (vma)
@@ -901,7 +946,10 @@ asmlinkage long sys_mbind(unsigned long 
 	if (err)
 		return err;
 	/* Restrict the nodes to the allowed nodes in the cpuset */
-	nodes_and(nodes, nodes, cpuset_current_mems_allowed);
+	/* XXX this is inconsistent: mbind silently discards extra nodes, */
+	/* XXX but set_mempolicy rejects them -EINVAL. */
+	if (current->mpol_nodemask_mode == MPOL_MODE_DEFAULT)
+		nodes_and(nodes, nodes, cpuset_current_mems_allowed);
 	return do_mbind(start, len, mode, &nodes, flags);
 }
 
@@ -1712,6 +1760,7 @@ void __init numa_policy_init(void)
 	if (unlikely(nodes_empty(interleave_nodes)))
 		node_set(prefer, interleave_nodes);
 
+	current->mpol_nodemask_mode = MPOL_MODE_DEFAULT;
 	if (do_set_mempolicy(MPOL_INTERLEAVE, &interleave_nodes))
 		printk("numa_policy_init: interleaving failed\n");
 }
@@ -1722,33 +1771,27 @@ void numa_default_policy(void)
 	do_set_mempolicy(MPOL_DEFAULT, NULL);
 }
 
-/* Migrate a policy to a different set of nodes */
-static void mpol_rebind_policy(struct mempolicy *pol,
+/* Migrate a policy to a different set of nodes: MPOL_MODE_DEFAULT */
+static void mpol_rebind_policy_default(struct mempolicy *pol,
 			       const nodemask_t *newmask)
 {
 	nodemask_t *mpolmask;
 	nodemask_t tmp;
 
-	if (!pol)
-		return;
-	mpolmask = &pol->cpuset_mems_allowed;
+	mpolmask = &pol->c.cpuset_mems_allowed;
 	if (nodes_equal(*mpolmask, *newmask))
 		return;
 
 	switch (pol->policy) {
-	case MPOL_DEFAULT:
-		break;
 	case MPOL_INTERLEAVE:
 		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
 		current->il_next = node_remap(current->il_next,
 						*mpolmask, *newmask);
-		*mpolmask = *newmask;
 		break;
 	case MPOL_PREFERRED:
 		pol->v.preferred_node = node_remap(pol->v.preferred_node,
 						*mpolmask, *newmask);
-		*mpolmask = *newmask;
 		break;
 	case MPOL_BIND: {
 		nodemask_t nodes;
@@ -1773,13 +1816,53 @@ static void mpol_rebind_policy(struct me
 			kfree(pol->v.zonelist);
 			pol->v.zonelist = zonelist;
 		}
-		*mpolmask = *newmask;
 		break;
 	}
 	default:
 		BUG();
 		break;
 	}
+	*mpolmask = *newmask;
+}
+
+/* Migrate a policy to a different set of nodes: MPOL_MODE_SYS_WIDE */
+static void mpol_rebind_policy_sys_wide(struct mempolicy *pol,
+			       const nodemask_t *newmask)
+{
+	nodemask_t cpuset_centric_nodes;
+	struct zonelist *zonelist;
+
+	nodes_remap(cpuset_centric_nodes, pol->c.original_nodes,
+						node_possible_map,
+						*newmask);
+	switch (pol->policy) {
+	case MPOL_INTERLEAVE:
+		pol->v.nodes = cpuset_centric_nodes;
+		current->il_next = first_node(pol->v.nodes);
+		break;
+	case MPOL_PREFERRED:
+		pol->v.preferred_node = first_node(cpuset_centric_nodes);
+		break;
+	case MPOL_BIND:
+		zonelist = bind_zonelist(&cpuset_centric_nodes);
+		if (!IS_ERR(zonelist)) {
+			kfree(pol->v.zonelist);
+			pol->v.zonelist = zonelist;
+		}
+		break;
+	}
+}
+
+/* Migrate a policy to a different set of nodes */
+static void mpol_rebind_policy(struct mempolicy *pol,
+			       const nodemask_t *newmask)
+{
+	if (!pol || pol->policy == MPOL_DEFAULT)
+		return;
+	if (pol->mpol_nodemask_mode == MPOL_MODE_DEFAULT)
+		mpol_rebind_policy_default(pol, newmask);
+	else
+		mpol_rebind_policy_sys_wide(pol, newmask);
 }
 
 /*
--- 2.6.23-mm1.orig/include/linux/sched.h	2007-10-30 18:04:11.000000000 -0700
+++ 2.6.23-mm1/include/linux/sched.h	2007-10-30 18:11:07.000000000 -0700
@@ -1112,6 +1112,7 @@ struct task_struct {
 #ifdef CONFIG_NUMA
   	struct mempolicy *mempolicy;
 	short il_next;
+	char mpol_nodemask_mode; /* new mem policies will get this mode */
 #endif
 #ifdef CONFIG_CPUSETS
 	nodemask_t mems_allowed;
--- 2.6.23-mm1.orig/Documentation/vm/numa_memory_policy.txt	2007-10-30 18:04:11.000000000 -0700
+++ 2.6.23-mm1/Documentation/vm/numa_memory_policy.txt	2007-10-30 22:52:38.000000000 -0700
@@ -300,32 +300,114 @@ package.
 
 MEMORY POLICIES AND CPUSETS
 
-Memory policies work within cpusets as described above.  For memory policies
-that require a node or set of nodes, the nodes are restricted to the set of
-nodes whose memories are allowed by the cpuset constraints.  If the nodemask
-specified for the policy contains nodes that are not allowed by the cpuset, or
-the intersection of the set of nodes specified for the policy and the set of
-nodes with memory is the empty set, the policy is considered invalid
-and cannot be installed.
-
-The interaction of memory policies and cpusets can be problematic for a
-couple of reasons:
-
-1) the memory policy APIs take physical node id's as arguments.  As mentioned
-   above, it is illegal to specify nodes that are not allowed in the cpuset.
-   The application must query the allowed nodes using the get_mempolicy()
-   API with the MPOL_F_MEMS_ALLOWED flag to determine the allowed nodes and
-   restrict itself to those nodes.  However, the resources available to a
-   cpuset can be changed by the system administrator, or a workload manager
-   application, at any time.  So, a task may still get errors attempting to
-   specify policy nodes, and must query the allowed memories again.
-
-2) when tasks in two cpusets share access to a memory region, such as shared
-   memory segments created by shmget() of mmap() with the MAP_ANONYMOUS and
-   MAP_SHARED flags, and any of the tasks install shared policy on the region,
-   only nodes whose memories are allowed in both cpusets may be used in the
-   policies.  Obtaining this information requires "stepping outside" the
-   memory policy APIs to use the cpuset information and requires that one
-   know in what cpusets other task might be attaching to the shared region.
-   Furthermore, if the cpusets' allowed memory sets are disjoint, "local"
-   allocation is the only valid policy.
+There are two different modes for how the node numbers and nodemasks
+passed to or from the get_mempolicy(), set_mempolicy(), and mbind()
+system calls are interpreted by the kernel.   If the per-task
+task_struct flag mpol_nodemask_mode is MPOL_MODE_DEFAULT, then
+these nodes and nodemasks should only include nodes allowed in the
+current tasks cpuset.  If mpol_nodemask_mode is MPOL_MODE_SYS_WIDE,
+then these nodes and nodemasks may include any nodes in the system.
+
+Either way, the kernel will subsequently do the best it can to
+automatically adapt a tasks memory policy to changes in that tasks
+cpuset, so as to (try to) keep that policies node numbers (for
+MPOL_BIND and MPOL_INTERLEAVE) and node masks (for MPOL_INTERLEAVE)
+unchanged relative to the nodes allowed to that task by its cpuset.
+
+Calling get_mempolicy() with MPOL_F_MODE_DEFAULT selects
+MPOL_MODE_DEFAULT, and calling it with MPOL_F_MODE_SYS_WIDE selects
+MPOL_MODE_SYS_WIDE.  Calling get_mempolicy() with MPOL_F_MODE_GET
+returns the current mode, MPOL_F_MODE_DEFAULT or MPOL_F_MODE_SYS_WIDE,
+in the policy argument to get_mempolicy.
+
+A tasks current mode, MPOL_F_MODE_DEFAULT or MPOL_F_MODE_SYS_WIDE,
+determines how subsequent node numbers and nodemasks passed to
+subsequent mbind and set_mempolicy calls will be interpreted, and
+how node numbers and nodemasks will be returned by get_mempolicy.
+Existing memory policies are not affected by changes in this mode,
+except as presented by get_mempolicy.
+
+The MPOL_MODE_DEFAULT mode has some limitations, but for historical
+reasons (it was the first and for a while the only mode available) it
+remains the default mode (hence its name.)
+
+The limitations of the MPOL_MODE_DEFAULT mode include:
+
+  1) Because the node numbers and masks passed into the mbind() and
+     set_mempolicy() system calls are taken relative to the tasks
+     current cpuset, and because that cpuset could change at the
+     same time, there is a small race condition.  The node numbers
+     and masks might end up being interpreted by the kernel relative
+     to a different cpuset placement than the application used while
+     preparing them, if the tasks cpuset was moved in the interim.
+
+     The application may query the allowed nodes using get_mempolicy()
+     with the MPOL_F_MEMS_ALLOWED flag to determine the allowed nodes
+     and restrict itself to those nodes.  However, the resources
+     available to a cpuset can be changed by the system administrator,
+     or a workload manager application, at any time.  So, a task
+     may still get errors attempting to specify policy nodes to
+     set_mempolicy(), and must query the allowed memories again.
+
+  2) Because only node numbers valid in the tasks current cpuset are
+     considered, a task can not specify which nodes should be added
+     to its memory policies if the task is subsequently moved to
+     a larger cpuset.  Similarly, if a task sets a memory policy,
+     then is later moved to a smaller cpuset (fewer memory nodes)
+     and then moved back to its first cpuset or one of the same size,
+     some nodes in its memory policy may be lost (no longer allowed
+     by that policy.)
+
+     This can result in a task not getting the memory policy node
+     placement that it requested.  Furthermore, the tasks memory policy
+     might fallback to MPOL_DEFAULT if it ends up with no remaining
+     nodes in its requested memory policy (see the "FALL THROUGH"
+     comments in mm/mempolicy.c.)
+
+  3) When tasks in two cpusets share access to a memory region, such
+     as shared memory segments created by shmget() of mmap() with the
+     MAP_ANONYMOUS and MAP_SHARED flags, and any of the tasks install
+     shared policy on the region, only nodes whose memories are allowed
+     in both cpusets may be used in the policies.  Obtaining this
+     information requires "stepping outside" the memory policy APIs
+     to use the cpuset information and requires that one know in
+     what cpusets other task might be attaching to the shared region.
+     Furthermore, if the cpusets' allowed memory sets are disjoint,
+     "local" allocation is the only valid policy.  [This limitation
+     may apply in some respects to the MPOL_F_MODE_SYS_WIDE mode as
+     well - this author doesn't know.]
+
+Depending on the situation, either of these two modes may be best
+suited to an applications needs.  Applications dealing with specific
+hardware node numbers, such as certain nodes having different i/o
+devices or more memory or faster processors or a particular NUMA
+topology, may be better expressed using the MPOL_MODE_DEFAULT mode.
+Applications dealing with nodes as more virtual and interchangeable
+entities, that are more concerned with being coded to support being
+moved by cpuset changes, without the above listed limitations, may
+be better expressed using the MPOL_F_MODE_SYS_WIDE mode.
+
+The MPOL_F_MODE_SYS_WIDE mode essentually virtualizes the node numbers
+passed back and forth across the memory policy system calls, as if
+the task was always in a cpuset containing all possible nodes in the
+system.  Then the kernel automatically folds the memory policy down
+to whatever memory nodes are in the tasks current cpuset.  This is
+useful to tasks that want to specify memory policies independently of
+what cpuset constraints or placement apply at the moment.  This is not
+so useful for tasks that have requirements for placement on specific
+hardware memory nodes.
+
+In the internal kernel's mm/mempolicy.c code, when a struct
+mempolicy mpol_nodemask_mode == MPOL_MODE_DEFAULT, it keeps the
+nodemask of the cpuset to which it was most recently bound in
+the policies c.cpuset_mems_allowed field.  When the mempolicy
+field mpol_nodemask_mode == MPOL_MODE_SYS_WIDE, it keeps the
+original nodemask from the set_mempolicy call that created that
+mempolicy in the policies c.original_nodes field.  The per-task
+task_struct keeps the mode to be used in future set_mempolicy and
+mbind calls in its mpol_nodemask_mode field.  The get_mempolicy
+options MPOL_F_MODE_DEFAULT and MPOL_F_MODE_SYS_WIDE set the current
+tasks mpol_nodemask_mode to MPOL_MODE_DEFAULT or MPOL_MODE_SYS_WIDE,
+respectively, and the get_mempolicy option MPOL_F_MODE_GET returns
+the current tasks mpol_nodemask_mode in the policy argument.
+

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
