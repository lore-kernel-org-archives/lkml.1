Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbYBKPce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbYBKPce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754581AbYBKPcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:32:11 -0500
Received: from smtp-out.google.com ([216.239.45.13]:45389 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbYBKPcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:32:09 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=qTQuxSYaP2fEJZjfG4K8Q8pfqsk7A53fETStO58geaSVUc+NnPsqh4qAS8ugZe8HV
	JJ4qLgfvHQsC8Hc5uHiMw==
Date: Mon, 11 Feb 2008 07:30:36 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com> <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an optional mempolicy mode flag, MPOL_F_STATIC_NODES, that suppresses
the node remap when the policy is rebound.

Adds another member to struct mempolicy,

	nodemask_t user_nodemask

that stores the the nodemask that the user passed when he or she created
the mempolicy via set_mempolicy() or mbind().  When using
MPOL_F_STATIC_NODES, which is passed with any mempolicy mode, the user's
passed nodemask is always used when determining the preferred node,
building the MPOL_BIND zonelist, or creating the interleave nodemask.
This happens whenever the policy is rebound, including when a task's
cpuset assignment changes or the cpuset's mems are changed.

This creates an interesting side-effect in that it allows the mempolicy
"intent" to lie dormant and uneffected until it has access to the node(s)
that it desires.  For example, if you currently ask for an interleaved
policy over a set of nodes that you do not have access to, the mempolicy
is not created and the task continues to use the equivalent of
MPOL_DEFAULT.  With this change, however, it is possible to create the
same mempolicy; it is effected only when access to the nodes is acquired.

It is also possible to mount tmpfs with the static nodemask behavior when
specifying a node or nodemask.  To do this, simply add "=static"
immediately following the mempolicy mode at mount time:

	mount -o remount mpol=interleave=static:1-3

Also removes mpol_check_policy() and folds some of its logic into
mpol_new() since it is now mostly obsoleted.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/mempolicy.h |    4 +-
 mm/mempolicy.c            |  137 ++++++++++++++++++---------------------------
 mm/shmem.c                |    2 +
 3 files changed, 60 insertions(+), 83 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -26,7 +26,8 @@ enum mempolicy_mode {
 #define MPOL_MODE_MASK	((1 << MPOL_FLAG_SHIFT) - 1)
 
 /* Flags for set_mempolicy */
-#define MPOL_MODE_FLAGS	(0)	/* legal set_mempolicy() MPOL_* mode flags */
+#define MPOL_F_STATIC_NODES	(1 << MPOL_FLAG_SHIFT)
+#define MPOL_MODE_FLAGS	(MPOL_F_STATIC_NODES)	/* legal set_mempolicy() MPOL_* mode flags */
 
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
@@ -82,6 +83,7 @@ struct mempolicy {
 		/* undefined for default */
 	} v;
 	nodemask_t cpuset_mems_allowed;	/* mempolicy relative to these nodes */
+	nodemask_t user_nodemask;	/* nodemask passed by user */
 };
 
 /*
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -113,58 +113,6 @@ struct mempolicy default_policy = {
 static void mpol_rebind_policy(struct mempolicy *pol,
                                const nodemask_t *newmask);
 
-/* Do sanity checking on a policy */
-static int mpol_check_policy(enum mempolicy_mode mode, nodemask_t *nodes)
-{
-	int was_empty, is_empty;
-
-	if (!nodes)
-		return 0;
-
-	/*
-	 * "Contextualize" the in-coming nodemast for cpusets:
-	 * Remember whether in-coming nodemask was empty,  If not,
-	 * restrict the nodes to the allowed nodes in the cpuset.
-	 * This is guaranteed to be a subset of nodes with memory.
-	 */
-	cpuset_update_task_memory_state();
-	is_empty = was_empty = nodes_empty(*nodes);
-	if (!was_empty) {
-		nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
-		is_empty = nodes_empty(*nodes);	/* after "contextualization" */
-	}
-
-	switch (mode) {
-	case MPOL_DEFAULT:
-		/*
-		 * require caller to specify an empty nodemask
-		 * before "contextualization"
-		 */
-		if (!was_empty)
-			return -EINVAL;
-		break;
-	case MPOL_BIND:
-	case MPOL_INTERLEAVE:
-		/*
-		 * require at least 1 valid node after "contextualization"
-		 */
-		if (is_empty)
-			return -EINVAL;
-		break;
-	case MPOL_PREFERRED:
-		/*
-		 * Did caller specify invalid nodes?
-		 * Don't silently accept this as "local allocation".
-		 */
-		if (!was_empty && is_empty)
-			return -EINVAL;
-		break;
-	default:
-		BUG();
-	}
-	return 0;
-}
-
 /* Generate a custom zonelist for the BIND policy. */
 static struct zonelist *bind_zonelist(nodemask_t *nodes)
 {
@@ -207,6 +155,7 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
 				  unsigned short flags, nodemask_t *nodes)
 {
 	struct mempolicy *policy;
+	nodemask_t cpuset_context_nmask;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
@@ -218,21 +167,27 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
 		return ERR_PTR(-ENOMEM);
 	flags &= MPOL_MODE_FLAGS;
 	atomic_set(&policy->refcnt, 1);
+	cpuset_update_task_memory_state();
+	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
-		policy->v.nodes = *nodes;
+		if (nodes_empty(*nodes))
+			return ERR_PTR(-EINVAL);
+		policy->v.nodes = cpuset_context_nmask;
 		if (nodes_weight(policy->v.nodes) == 0) {
 			kmem_cache_free(policy_cache, policy);
 			return ERR_PTR(-EINVAL);
 		}
 		break;
 	case MPOL_PREFERRED:
-		policy->v.preferred_node = first_node(*nodes);
+		policy->v.preferred_node = first_node(cpuset_context_nmask);
 		if (policy->v.preferred_node >= MAX_NUMNODES)
 			policy->v.preferred_node = -1;
 		break;
 	case MPOL_BIND:
-		policy->v.zonelist = bind_zonelist(nodes);
+		if (nodes_empty(*nodes))
+			return ERR_PTR(-EINVAL);
+		policy->v.zonelist = bind_zonelist(&cpuset_context_nmask);
 		if (IS_ERR(policy->v.zonelist)) {
 			void *error_code = policy->v.zonelist;
 			kmem_cache_free(policy_cache, policy);
@@ -244,6 +199,7 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
 	}
 	policy->policy = mode | flags;
 	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
+	policy->user_nodemask = *nodes;
 	return policy;
 }
 
@@ -490,15 +446,14 @@ static long do_set_mempolicy(enum mempolicy_mode mode, unsigned short flags,
 {
 	struct mempolicy *new;
 
-	if (mpol_check_policy(mode, nodes))
-		return -EINVAL;
 	new = mpol_new(mode, flags, nodes);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
 	mpol_free(current->mempolicy);
 	current->mempolicy = new;
 	mpol_set_task_struct_flag();
-	if (new && mpol_mode(new->policy) == MPOL_INTERLEAVE)
+	if (new && mpol_mode(new->policy) == MPOL_INTERLEAVE &&
+	    nodes_weight(new->v.nodes))
 		current->il_next = first_node(new->v.nodes);
 	return 0;
 }
@@ -818,9 +773,6 @@ static long do_mbind(unsigned long start, unsigned long len,
 	if (end == start)
 		return 0;
 
-	if (mpol_check_policy(mode, nmask))
-		return -EINVAL;
-
 	new = mpol_new(mode, mode_flags, nmask);
 	if (IS_ERR(new))
 		return PTR_ERR(new);
@@ -1211,7 +1163,8 @@ static unsigned interleave_nodes(struct mempolicy *policy)
 	next = next_node(nid, policy->v.nodes);
 	if (next >= MAX_NUMNODES)
 		next = first_node(policy->v.nodes);
-	me->il_next = next;
+	if (next < MAX_NUMNODES)
+		me->il_next = next;
 	return nid;
 }
 
@@ -1250,10 +1203,13 @@ static unsigned offset_il_node(struct mempolicy *pol,
 		struct vm_area_struct *vma, unsigned long off)
 {
 	unsigned nnodes = nodes_weight(pol->v.nodes);
-	unsigned target = (unsigned)off % nnodes;
+	unsigned target;
 	int c;
 	int nid = -1;
 
+	if (!nnodes)
+		return numa_node_id();
+	target = (unsigned)off % nnodes;
 	c = 0;
 	do {
 		nid = next_node(nid, pol->v.nodes);
@@ -1773,6 +1729,7 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 {
 	nodemask_t *mpolmask;
 	nodemask_t tmp;
+	int remap;
 
 	if (!pol)
 		return;
@@ -1780,51 +1737,67 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 	if (nodes_equal(*mpolmask, *newmask))
 		return;
 
+	remap = !(mpol_flags(pol->policy) & MPOL_F_STATIC_NODES);
 	switch (mpol_mode(pol->policy)) {
 	case MPOL_DEFAULT:
 		break;
 	case MPOL_INTERLEAVE:
-		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
+		if (!remap)
+			nodes_and(tmp, pol->user_nodemask, *newmask);
+		else
+			nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
 		pol->v.nodes = tmp;
-		*mpolmask = *newmask;
-		current->il_next = node_remap(current->il_next,
-						*mpolmask, *newmask);
+		if (!node_isset(current->il_next, tmp)) {
+			current->il_next = next_node(current->il_next, tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = first_node(tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = numa_node_id();
+		}
 		break;
 	case MPOL_PREFERRED:
-		pol->v.preferred_node = node_remap(pol->v.preferred_node,
-						*mpolmask, *newmask);
-		*mpolmask = *newmask;
+		if (!remap && !node_isset(pol->v.preferred_node, *newmask))
+			pol->v.preferred_node = -1;
+		else
+			pol->v.preferred_node = node_remap(pol->v.preferred_node,
+							*mpolmask, *newmask);
 		break;
 	case MPOL_BIND: {
-		nodemask_t nodes;
-		struct zone **z;
-		struct zonelist *zonelist;
-
-		nodes_clear(nodes);
-		for (z = pol->v.zonelist->zones; *z; z++)
-			node_set(zone_to_nid(*z), nodes);
-		nodes_remap(tmp, nodes, *mpolmask, *newmask);
-		nodes = tmp;
+		struct zonelist *zonelist = NULL;
+
+		if (!remap)
+			nodes_and(tmp, pol->user_nodemask, *newmask);
+		else {
+			nodemask_t nodes;
+			struct zone **z;
+
+			nodes_clear(nodes);
+			for (z = pol->v.zonelist->zones; *z; z++)
+				node_set(zone_to_nid(*z), nodes);
+			nodes_remap(tmp, nodes, *mpolmask, *newmask);
+		}
 
-		zonelist = bind_zonelist(&nodes);
+		if (nodes_weight(tmp))
+			zonelist = bind_zonelist(&tmp);
 
 		/* If no mem, then zonelist is NULL and we keep old zonelist.
 		 * If that old zonelist has no remaining mems_allowed nodes,
 		 * then zonelist_policy() will "FALL THROUGH" to MPOL_DEFAULT.
 		 */
 
-		if (!IS_ERR(zonelist)) {
+		if (zonelist && !IS_ERR(zonelist)) {
 			/* Good - got mem - substitute new zonelist */
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
+	if (mpol_mode(pol->policy) != MPOL_DEFAULT)
+		*mpolmask = *newmask;
 }
 
 /*
diff --git a/mm/shmem.c b/mm/shmem.c
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1129,6 +1129,8 @@ static int shmem_parse_mpol(char *value, unsigned short *policy,
 		err = 0;
 	}
 	if (flags) {
+		if (!strcmp(flags, "static"))
+			*policy |= MPOL_F_STATIC_NODES;
 	}
 out:
 	/* Restore string for error message */
