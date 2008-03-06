Return-Path: <linux-kernel-owner+w=401wt.eu-S1761676AbYCFUFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761676AbYCFUFf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbYCFUFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:05:22 -0500
Received: from smtp-out.google.com ([216.239.45.13]:25889 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758051AbYCFUFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:05:20 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:message-id:
	user-agent:mime-version:content-type;
	b=wBvKQ3xrWZAWJ4x/L5Gpk+vzmeCeg58Mmo+r+deFdwDnclhvDhI+AX7T4q7x4eK3e
	2esUd37WpfiW3lhu1UU9Q==
Date: Thu, 6 Mar 2008 12:05:03 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch -mm 1/4] mempolicy: move rebind functions
Message-ID: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the mpol_rebind_{policy,task,mm}() functions after mpol_new() to
avoid having to declare function prototypes.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/mempolicy.c |  185 +++++++++++++++++++++++++++----------------------------
 1 files changed, 91 insertions(+), 94 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -110,9 +110,6 @@ struct mempolicy default_policy = {
 	.policy = MPOL_DEFAULT,
 };
 
-static void mpol_rebind_policy(struct mempolicy *pol,
-                               const nodemask_t *newmask);
-
 /* Check that the nodemask contains at least one populated zone */
 static int is_valid_nodemask(nodemask_t *nodemask)
 {
@@ -203,6 +200,97 @@ free:
 	return ERR_PTR(-EINVAL);
 }
 
+/* Migrate a policy to a different set of nodes */
+static void mpol_rebind_policy(struct mempolicy *pol,
+			       const nodemask_t *newmask)
+{
+	nodemask_t tmp;
+	int static_nodes;
+	int relative_nodes;
+
+	if (!pol)
+		return;
+	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
+	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
+	if (!mpol_store_user_nodemask(pol) &&
+	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
+		return;
+
+	switch (pol->policy) {
+	case MPOL_DEFAULT:
+		break;
+	case MPOL_BIND:
+		/* Fall through */
+	case MPOL_INTERLEAVE:
+		if (static_nodes)
+			nodes_and(tmp, pol->w.user_nodemask, *newmask);
+		else if (relative_nodes)
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
+		else {
+			nodes_remap(tmp, pol->v.nodes,
+				    pol->w.cpuset_mems_allowed, *newmask);
+			pol->w.cpuset_mems_allowed = *newmask;
+		}
+		pol->v.nodes = tmp;
+		if (!node_isset(current->il_next, tmp)) {
+			current->il_next = next_node(current->il_next, tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = first_node(tmp);
+			if (current->il_next >= MAX_NUMNODES)
+				current->il_next = numa_node_id();
+		}
+		break;
+	case MPOL_PREFERRED:
+		if (static_nodes) {
+			int node = first_node(pol->w.user_nodemask);
+
+			if (node_isset(node, *newmask))
+				pol->v.preferred_node = node;
+			else
+				pol->v.preferred_node = -1;
+		} else if (relative_nodes) {
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
+			pol->v.preferred_node = first_node(tmp);
+		} else {
+			pol->v.preferred_node = node_remap(pol->v.preferred_node,
+					pol->w.cpuset_mems_allowed, *newmask);
+			pol->w.cpuset_mems_allowed = *newmask;
+		}
+		break;
+	default:
+		BUG();
+		break;
+	}
+}
+
+/*
+ * Wrapper for mpol_rebind_policy() that just requires task
+ * pointer, and updates task mempolicy.
+ */
+
+void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
+{
+	mpol_rebind_policy(tsk->mempolicy, new);
+}
+
+/*
+ * Rebind each vma in mm to new nodemask.
+ *
+ * Call holding a reference to mm.  Takes mm->mmap_sem during call.
+ */
+
+void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
+{
+	struct vm_area_struct *vma;
+
+	down_write(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next)
+		mpol_rebind_policy(vma->vm_policy, new);
+	up_write(&mm->mmap_sem);
+}
+
 static void gather_stats(struct page *, void *, int pte_dirty);
 static void migrate_page_add(struct page *page, struct list_head *pagelist,
 				unsigned long flags);
@@ -1745,97 +1833,6 @@ void numa_default_policy(void)
 	do_set_mempolicy(MPOL_DEFAULT, 0, NULL);
 }
 
-/* Migrate a policy to a different set of nodes */
-static void mpol_rebind_policy(struct mempolicy *pol,
-			       const nodemask_t *newmask)
-{
-	nodemask_t tmp;
-	int static_nodes;
-	int relative_nodes;
-
-	if (!pol)
-		return;
-	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
-	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
-	if (!mpol_store_user_nodemask(pol) &&
-	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
-		return;
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
-}
-
-/*
- * Wrapper for mpol_rebind_policy() that just requires task
- * pointer, and updates task mempolicy.
- */
-
-void mpol_rebind_task(struct task_struct *tsk, const nodemask_t *new)
-{
-	mpol_rebind_policy(tsk->mempolicy, new);
-}
-
-/*
- * Rebind each vma in mm to new nodemask.
- *
- * Call holding a reference to mm.  Takes mm->mmap_sem during call.
- */
-
-void mpol_rebind_mm(struct mm_struct *mm, nodemask_t *new)
-{
-	struct vm_area_struct *vma;
-
-	down_write(&mm->mmap_sem);
-	for (vma = mm->mmap; vma; vma = vma->vm_next)
-		mpol_rebind_policy(vma->vm_policy, new);
-	up_write(&mm->mmap_sem);
-}
-
 /*
  * Display pages allocated per node and memory policy via /proc.
  */
