Return-Path: <linux-kernel-owner+w=401wt.eu-S1763899AbYCFUHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763899AbYCFUHS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:07:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765959AbYCFUGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:06:13 -0500
Received: from smtp-out.google.com ([216.239.33.17]:32042 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763679AbYCFUGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:06:11 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=ciXmCgCG5oPwYid5bWw3bgLDCJ2Z/sA96tCypbjpPG2VaKzDXQDTG/Q95rw+by7o3
	x/wb+E9qZGB3jWcJQ8fBg==
Date: Thu, 6 Mar 2008 12:05:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 2/4] mempolicy: create mempolicy_operations structure
In-Reply-To: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a mempolicy_operations structure that currently points to two
functions[*] for the various modes:

	int (*create)(struct mempolicy *, const nodemask_t *);
	void (*rebind)(struct mempolicy *, const nodemask_t *);

This splits the implementation for the various modes out of two large
functions, mpol_new() and mpol_rebind_policy().  Eventually it may be
beneficial to add additional functions to accomodate the existing switch()
statements in mm/mempolicy.c.

 [*] The ->create() function for MPOL_DEFAULT is currently NULL since no
     struct mempolicy is dynamically allocated.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |  191 ++++++++++++++++++++++++++++++++------------------------
 1 files changed, 110 insertions(+), 81 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -63,7 +63,6 @@
    grows down?
    make bind policy root only? It can trigger oom much faster and the
    kernel is not always grateful with that.
-   could replace all the switch()es with a mempolicy_ops structure.
 */
 
 #include <linux/mempolicy.h>
@@ -110,8 +109,13 @@ struct mempolicy default_policy = {
 	.policy = MPOL_DEFAULT,
 };
 
+static const struct mempolicy_operations {
+	int (*create)(struct mempolicy *pol, const nodemask_t *nodes);
+	void (*rebind)(struct mempolicy *pol, const nodemask_t *nodes);
+} mpol_ops[MPOL_MAX];
+
 /* Check that the nodemask contains at least one populated zone */
-static int is_valid_nodemask(nodemask_t *nodemask)
+static int is_valid_nodemask(const nodemask_t *nodemask)
 {
 	int nd, k;
 
@@ -144,19 +148,45 @@ static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
 	nodes_onto(*ret, tmp, *rel);
 }
 
+static int mpol_new_interleave(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	if (nodes_empty(*nodes))
+		return -EINVAL;
+	pol->v.nodes = *nodes;
+	return 0;
+}
+
+static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	if (nodes_empty(*nodes))
+		return -EINVAL;
+	pol->v.preferred_node = first_node(*nodes);
+	return 0;
+}
+
+static int mpol_new_bind(struct mempolicy *pol, const nodemask_t *nodes)
+{
+	if (!is_valid_nodemask(nodes))
+		return -EINVAL;
+	pol->v.nodes = *nodes;
+	return 0;
+}
+
 /* Create a new policy */
 static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 				  nodemask_t *nodes)
 {
 	struct mempolicy *policy;
 	nodemask_t cpuset_context_nmask;
+	int ret;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
+	if (nodes && nodes_empty(*nodes) && mode != MPOL_PREFERRED)
+		return ERR_PTR(-EINVAL);
 	if (mode == MPOL_DEFAULT)
-		return (nodes && nodes_weight(*nodes)) ? ERR_PTR(-EINVAL) :
-							 NULL;
+		return NULL;
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
@@ -168,101 +198,83 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 	else
 		nodes_and(cpuset_context_nmask, *nodes,
 			  cpuset_current_mems_allowed);
-	switch (mode) {
-	case MPOL_INTERLEAVE:
-		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask))
-			goto free;
-		policy->v.nodes = cpuset_context_nmask;
-		break;
-	case MPOL_PREFERRED:
-		policy->v.preferred_node = first_node(cpuset_context_nmask);
-		if (policy->v.preferred_node >= MAX_NUMNODES)
-			goto free;
-		break;
-	case MPOL_BIND:
-		if (!is_valid_nodemask(&cpuset_context_nmask))
-			goto free;
-		policy->v.nodes = cpuset_context_nmask;
-		break;
-	default:
-		BUG();
-	}
 	policy->policy = mode;
 	policy->flags = flags;
 	if (mpol_store_user_nodemask(policy))
 		policy->w.user_nodemask = *nodes;
 	else
 		policy->w.cpuset_mems_allowed = cpuset_mems_allowed(current);
+
+	ret = mpol_ops[mode].create(policy, &cpuset_context_nmask);
+	if (ret < 0) {
+		kmem_cache_free(policy_cache, policy);
+		return ERR_PTR(ret);
+	}
 	return policy;
+}
+
+static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
+{
+}
+
+static void mpol_rebind_nodemask(struct mempolicy *pol,
+				 const nodemask_t *nodes)
+{
+	nodemask_t tmp;
 
-free:
-	kmem_cache_free(policy_cache, policy);
-	return ERR_PTR(-EINVAL);
+	if (pol->flags & MPOL_F_STATIC_NODES)
+		nodes_and(tmp, pol->w.user_nodemask, *nodes);
+	else if (pol->flags & MPOL_F_RELATIVE_NODES)
+		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
+	else {
+		nodes_remap(tmp, pol->v.nodes, pol->w.cpuset_mems_allowed,
+			    *nodes);
+		pol->w.cpuset_mems_allowed = *nodes;
+	}
+
+	pol->v.nodes = tmp;
+	if (!node_isset(current->il_next, tmp)) {
+		current->il_next = next_node(current->il_next, tmp);
+		if (current->il_next >= MAX_NUMNODES)
+			current->il_next = first_node(tmp);
+		if (current->il_next >= MAX_NUMNODES)
+			current->il_next = numa_node_id();
+	}
+}
+
+static void mpol_rebind_preferred(struct mempolicy *pol,
+				  const nodemask_t *nodes)
+{
+	nodemask_t tmp;
+
+	if (pol->flags & MPOL_F_STATIC_NODES) {
+		int node = first_node(pol->w.user_nodemask);
+
+		if (node_isset(node, *nodes))
+			pol->v.preferred_node = node;
+		else
+			pol->v.preferred_node = -1;
+	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
+		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
+		pol->v.preferred_node = first_node(tmp);
+	} else {
+		pol->v.preferred_node = node_remap(pol->v.preferred_node,
+						   pol->w.cpuset_mems_allowed,
+						   *nodes);
+		pol->w.cpuset_mems_allowed = *nodes;
+	}
 }
 
 /* Migrate a policy to a different set of nodes */
 static void mpol_rebind_policy(struct mempolicy *pol,
 			       const nodemask_t *newmask)
 {
-	nodemask_t tmp;
-	int static_nodes;
-	int relative_nodes;
-
 	if (!pol)
 		return;
-	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
-	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
 	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
-
-	switch (pol->policy) {
-	case MPOL_DEFAULT:
-		break;
-	case MPOL_BIND:
-		/* Fall through */
-	case MPOL_INTERLEAVE:
-		if (static_nodes)
-			nodes_and(tmp, pol->w.user_nodemask, *newmask);
-		else if (relative_nodes)
-			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
-					       newmask);
-		else {
-			nodes_remap(tmp, pol->v.nodes,
-				    pol->w.cpuset_mems_allowed, *newmask);
-			pol->w.cpuset_mems_allowed = *newmask;
-		}
-		pol->v.nodes = tmp;
-		if (!node_isset(current->il_next, tmp)) {
-			current->il_next = next_node(current->il_next, tmp);
-			if (current->il_next >= MAX_NUMNODES)
-				current->il_next = first_node(tmp);
-			if (current->il_next >= MAX_NUMNODES)
-				current->il_next = numa_node_id();
-		}
-		break;
-	case MPOL_PREFERRED:
-		if (static_nodes) {
-			int node = first_node(pol->w.user_nodemask);
-
-			if (node_isset(node, *newmask))
-				pol->v.preferred_node = node;
-			else
-				pol->v.preferred_node = -1;
-		} else if (relative_nodes) {
-			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
-					       newmask);
-			pol->v.preferred_node = first_node(tmp);
-		} else {
-			pol->v.preferred_node = node_remap(pol->v.preferred_node,
-					pol->w.cpuset_mems_allowed, *newmask);
-			pol->w.cpuset_mems_allowed = *newmask;
-		}
-		break;
-	default:
-		BUG();
-		break;
-	}
+	mpol_ops[pol->policy].rebind(pol, newmask);
 }
 
 /*
@@ -291,6 +303,24 @@ void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
 	up_write(&mm->mmap_sem);
 }
 
+static const struct mempolicy_operations mpol_ops[MPOL_MAX] = {
+	[MPOL_DEFAULT] = {
+		.rebind = mpol_rebind_default,
+	},
+	[MPOL_INTERLEAVE] = {
+		.create = mpol_new_interleave,
+		.rebind = mpol_rebind_nodemask,
+	},
+	[MPOL_PREFERRED] = {
+		.create = mpol_new_preferred,
+		.rebind = mpol_rebind_preferred,
+	},
+	[MPOL_BIND] = {
+		.create = mpol_new_bind,
+		.rebind = mpol_rebind_nodemask,
+	},
+};
+
 static void gather_stats(struct page *, void *, int pte_dirty);
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
@@ -1836,7 +1866,6 @@ void numa_default_policy(void)
 /*
  * Display pages allocated per node and memory policy via /proc.
  */
-
 static const char * const policy_types[] =
 	{ "default", "prefer", "bind", "interleave" };
 
