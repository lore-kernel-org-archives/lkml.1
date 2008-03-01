Return-Path: <linux-kernel-owner+w=401wt.eu-S1761988AbYCAAp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761988AbYCAAp5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 19:45:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933002AbYCAAph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 19:45:37 -0500
Received: from smtp-out.google.com ([216.239.33.17]:52133 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932887AbYCAApg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 19:45:36 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=N2XVe3Yc/r8boUVeZqMrotew0WsgoTctUjo1Gb3i7NgSUyooi8YjxotsO00+tkKvP
	9OHemZLY0M0r6j6EDYaag==
Date: Fri, 29 Feb 2008 16:45:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
In-Reply-To: <alpine.DEB.1.00.0802291642290.30883@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.1.00.0802291644060.30883@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802291640570.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291641500.30883@chino.kir.corp.google.com> <alpine.DEB.1.00.0802291642110.30883@chino.kir.corp.google.com>
 <alpine.DEB.1.00.0802291642290.30883@chino.kir.corp.google.com>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds another optional mode flag, MPOL_F_RELATIVE_NODES, that specifies
nodemasks passed via set_mempolicy() or mbind() should be considered
relative to the current task's mems_allowed.

When the mempolicy is created, the passed nodemask is folded and mapped
onto the current task's mems_allowed.  For example, consider a task
using set_mempolicy() to pass MPOL_INTERLEAVE | MPOL_F_RELATIVE_NODES
with a nodemask of 1-3.  If current's mems_allowed is 4-7, the effected
nodemask is 5-7 (the second, third, and fourth node of mems_allowed).

If the same task is attached to a cpuset, the mempolicy nodemask is
rebound each time the mems are changed.  Some possible rebinds and
results are:

	mems			result
	1-3			1-3
	1-7			2-4
	1,5-6			1,5-6
	1,5-7			5-7

Likewise, the zonelist built for MPOL_BIND acts on the set of zones
assigned to the resultant nodemask from the relative remap.

In the MPOL_PREFERRED case, the preferred node is remapped from the
currently effected nodemask to the relative nodemask.

This mempolicy mode flag was conceived of by Paul Jackson <pj@sgi.com>.

Cc: Paul Jackson <pj@sgi.com>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 include/linux/mempolicy.h |    3 ++-
 mm/mempolicy.c            |   36 ++++++++++++++++++++++++++++++++++--
 mm/shmem.c                |    6 ++++++
 3 files changed, 42 insertions(+), 3 deletions(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -25,12 +25,13 @@ enum {
 
 /* Flags for set_mempolicy */
 #define MPOL_F_STATIC_NODES	(1 << 15)
+#define MPOL_F_RELATIVE_NODES	(1 << 14)
 
 /*
  * MPOL_MODE_FLAGS is the union of all possible optional mode flags passed to
  * either set_mempolicy() or mbind().
  */
-#define MPOL_MODE_FLAGS		(MPOL_F_STATIC_NODES)
+#define MPOL_MODE_FLAGS		(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
 
 /* Flags for get_mempolicy */
 #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -152,7 +152,15 @@ static struct zonelist *bind_zonelist(nodemask_t *nodes)
 
 static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
 {
-	return pol->flags & MPOL_F_STATIC_NODES;
+	return pol->flags & (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES);
+}
+
+static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,
+				   const nodemask_t *rel)
+{
+	nodemask_t tmp;
+	nodes_fold(tmp, *orig, nodes_weight(*rel));
+	nodes_onto(*ret, tmp, *rel);
 }
 
 /* Create a new policy */
@@ -173,7 +181,12 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
 	cpuset_update_task_memory_state();
-	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
+	if (flags & MPOL_F_RELATIVE_NODES)
+		mpol_relative_nodemask(&cpuset_context_nmask, nodes,
+				       &cpuset_current_mems_allowed);
+	else
+		nodes_and(cpuset_context_nmask, *nodes,
+			  cpuset_current_mems_allowed);
 	switch (mode) {
 	case MPOL_INTERLEAVE:
 		if (nodes_empty(*nodes) || nodes_empty(cpuset_context_nmask))
@@ -898,6 +911,9 @@ asmlinkage long sys_mbind(unsigned long start, unsigned long len,
 	mode &= ~MPOL_MODE_FLAGS;
 	if (mode >= MPOL_MAX)
 		return -EINVAL;
+	if ((mode_flags & MPOL_F_STATIC_NODES) &&
+	    (mode_flags & MPOL_F_RELATIVE_NODES))
+		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -916,6 +932,8 @@ asmlinkage long sys_set_mempolicy(int mode, unsigned long __user *nmask,
 	mode &= ~MPOL_MODE_FLAGS;
 	if ((unsigned int)mode >= MPOL_MAX)
 		return -EINVAL;
+	if ((flags & MPOL_F_STATIC_NODES) && (flags & MPOL_F_RELATIVE_NODES))
+		return -EINVAL;
 	err = get_nodes(&nodes, nmask, maxnode);
 	if (err)
 		return err;
@@ -1747,10 +1765,12 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 {
 	nodemask_t tmp;
 	int static_nodes;
+	int relative_nodes;
 
 	if (!pol)
 		return;
 	static_nodes = pol->flags & MPOL_F_STATIC_NODES;
+	relative_nodes = pol->flags & MPOL_F_RELATIVE_NODES;
 	if (!mpol_store_user_nodemask(pol) &&
 	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
 		return;
@@ -1761,6 +1781,9 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 	case MPOL_INTERLEAVE:
 		if (static_nodes)
 			nodes_and(tmp, pol->w.user_nodemask, *newmask);
+		else if (relative_nodes)
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
 		else {
 			nodes_remap(tmp, pol->v.nodes,
 				    pol->w.cpuset_mems_allowed, *newmask);
@@ -1783,6 +1806,10 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 				pol->v.preferred_node = node;
 			else
 				pol->v.preferred_node = -1;
+		} else if (relative_nodes) {
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
+			pol->v.preferred_node = first_node(tmp);
 		} else {
 			pol->v.preferred_node = node_remap(pol->v.preferred_node,
 					pol->w.cpuset_mems_allowed, *newmask);
@@ -1794,6 +1821,9 @@ static void mpol_rebind_policy(struct mempolicy *pol,
 
 		if (static_nodes)
 			nodes_and(tmp, pol->w.user_nodemask, *newmask);
+		else if (relative_nodes)
+			mpol_relative_nodemask(&tmp, &pol->w.user_nodemask,
+					       newmask);
 		else {
 			nodemask_t nodes;
 			struct zone **z;
@@ -1911,6 +1941,8 @@ static inline int mpol_to_str(char *buffer, int maxlen, struct mempolicy *pol)
 
 		if (flags & MPOL_F_STATIC_NODES)
 			p += sprintf(p, "%sstatic", need_bar++ ? "|" : "");
+		if (flags & MPOL_F_RELATIVE_NODES)
+			p += sprintf(p, "%srelative", need_bar++ ? "|" : "");
 	}
 
 	if (!nodes_empty(nodes)) {
diff --git a/mm/shmem.c b/mm/shmem.c
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1131,6 +1131,12 @@ static int shmem_parse_mpol(char *value, unsigned short *policy,
 	if (flags) {
 		if (!strcmp(flags, "static"))
 			*mode_flags |= MPOL_F_STATIC_NODES;
+		if (!strcmp(flags, "relative"))
+			*mode_flags |= MPOL_F_RELATIVE_NODES;
+
+		if ((*mode_flags & MPOL_F_STATIC_NODES) &&
+		    (*mode_flags & MPOL_F_RELATIVE_NODES))
+			err = 1;
 	}
 out:
 	/* Restore string for error message */
