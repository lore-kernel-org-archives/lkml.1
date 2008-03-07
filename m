Return-Path: <linux-kernel-owner+w=401wt.eu-S932144AbYCGUoN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144AbYCGUoN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 15:44:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762826AbYCGUnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 15:43:55 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:40824 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761947AbYCGUnx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 15:43:53 -0500
Subject: Regression:  Re: [patch -mm 2/4] mempolicy: create
	mempolicy_operations structure
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Rientjes <rientjes@google.com>
Cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Andi Kleen <ak@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm <linux-mm@kvack.org>, Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803061135001.18590@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0803061135560.18590@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Fri, 07 Mar 2008 15:44:05 -0500
Message-Id: <1204922646.5340.73.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The subject patch causes a regression in the numactl package mempolicy
regression tests.

I'm using the numactl-1.0.2 package with the patches available at:

http://free.linux.hp.com/~lts/Patches/Numactl/numactl-1.0.2-patches-080226.tar.gz

The numastat and regress patches in that tarball are necessary for
recent kernels, else the tests will report false failures.

The following patch fixes the regression.

Lee

----------------------------------------------------

Against:  2.6.25-rc3-mm1 atop the following patches, which Andrew
has already added to the -mm tree:

[patch 1/6] mempolicy: convert MPOL constants to enum
[patch 2/6] mempolicy: support optional mode flags
[patch 3/6] mempolicy: add MPOL_F_STATIC_NODES flag
[patch 4/6] mempolicy: add bitmap_onto() and bitmap_fold() operations
[patch 5/6] mempolicy: add MPOL_F_RELATIVE_NODES flag
[patch 6/6] mempolicy: update NUMA memory policy documentation
[patch -mm 1/4] mempolicy: move rebind functions
[patch -mm 2/4] mempolicy: create mempolicy_operations structure
[patch -mm 3/4] mempolicy: small header file cleanup

Specifically this patch fixes problems introduced by the rework
of mpol_new() in patch 2/4 in the second series.  As a result,
we're no longer accepting NULL/empty nodemask with MPOL_PREFERRED
as "local" allocation.  This breaks the numactl regression tests.

"numactl --localalloc" <some command>" fails with invalid argument.

This patch fixes the regression by again treating NULL/empty nodemask
with MPOL_PREFERRED as "local allocation", and special casing this
condition, as needed, in mpol_new(), mpol_new_preferred() and 
mpol_rebind_preferred().

It also appears that the patch series listed above required a non-empty
nodemask with MPOL_DEFAULT.  However, I didn't test that.  With this
patch, MPOL_DEFAULT effectively ignores the nodemask--empty or not.
This is a change in behavior that I have argued against, but the
regression tests don't test this, so I'm not going to attempt to address
it with this patch.

Note:  I have no tests to test the 'STATIC_NODES and 'RELATIVE_NODES
behavior to ensure that this patch doesn't regress those.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/mempolicy.c |   54 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 36 insertions(+), 18 deletions(-)

Index: linux-2.6.25-rc3-mm1/mm/mempolicy.c
===================================================================
--- linux-2.6.25-rc3-mm1.orig/mm/mempolicy.c	2008-03-07 15:22:01.000000000 -0500
+++ linux-2.6.25-rc3-mm1/mm/mempolicy.c	2008-03-07 15:37:43.000000000 -0500
@@ -158,9 +158,12 @@ static int mpol_new_interleave(struct me
 
 static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	if (nodes_empty(*nodes))
-		return -EINVAL;
-	pol->v.preferred_node = first_node(*nodes);
+	if (!nodes)
+		pol->v.preferred_node = -1;	/* local allocation */
+	else if (nodes_empty(*nodes))
+		return -EINVAL;			/*  no allowed nodes */
+	else
+		pol->v.preferred_node = first_node(*nodes);
 	return 0;
 }
 
@@ -178,34 +181,43 @@ static struct mempolicy *mpol_new(unsign
 {
 	struct mempolicy *policy;
 	nodemask_t cpuset_context_nmask;
+	int localalloc = 0;
 	int ret;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
 		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
 
-	if (nodes && nodes_empty(*nodes) && mode != MPOL_PREFERRED)
-		return ERR_PTR(-EINVAL);
 	if (mode == MPOL_DEFAULT)
 		return NULL;
+	if (!nodes || nodes_empty(*nodes)) {
+		if (mode != MPOL_PREFERRED)
+			return ERR_PTR(-EINVAL);
+		localalloc = 1;	/* special case:  no mode flags */
+	}
 	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!policy)
 		return ERR_PTR(-ENOMEM);
 	atomic_set(&policy->refcnt, 1);
-	cpuset_update_task_memory_state();
-	if (flags & MPOL_F_RELATIVE_NODES)
-		mpol_relative_nodemask(&cpuset_context_nmask, nodes,
-				       &cpuset_current_mems_allowed);
-	else
-		nodes_and(cpuset_context_nmask, *nodes,
-			  cpuset_current_mems_allowed);
 	policy->policy = mode;
-	policy->flags = flags;
-	if (mpol_store_user_nodemask(policy))
-		policy->w.user_nodemask = *nodes;
-	else
-		policy->w.cpuset_mems_allowed = cpuset_mems_allowed(current);
 
-	ret = mpol_ops[mode].create(policy, &cpuset_context_nmask);
+	if (!localalloc) {
+		policy->flags = flags;
+		cpuset_update_task_memory_state();
+		if (flags & MPOL_F_RELATIVE_NODES)
+			mpol_relative_nodemask(&cpuset_context_nmask, nodes,
+					       &cpuset_current_mems_allowed);
+		else
+			nodes_and(cpuset_context_nmask, *nodes,
+				  cpuset_current_mems_allowed);
+		if (mpol_store_user_nodemask(policy))
+			policy->w.user_nodemask = *nodes;
+		else
+			policy->w.cpuset_mems_allowed =
+						cpuset_mems_allowed(current);
+	}
+
+	ret = mpol_ops[mode].create(policy,
+				localalloc ? NULL : &cpuset_context_nmask);
 	if (ret < 0) {
 		kmem_cache_free(policy_cache, policy);
 		return ERR_PTR(ret);
@@ -247,6 +259,10 @@ static void mpol_rebind_preferred(struct
 {
 	nodemask_t tmp;
 
+	/*
+	 * check 'STATIC_NODES first, as preferred_node == -1 may be
+	 * a temporary, "fallback" state for this policy.
+	 */
 	if (pol->flags & MPOL_F_STATIC_NODES) {
 		int node = first_node(pol->w.user_nodemask);
 
@@ -254,6 +270,8 @@ static void mpol_rebind_preferred(struct
 			pol->v.preferred_node = node;
 		else
 			pol->v.preferred_node = -1;
+	} else if (pol->v.preferred_node == -1) {
+		return;	/* no remap required for explicit local alloc */
 	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
 		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
 		pol->v.preferred_node = first_node(tmp);


