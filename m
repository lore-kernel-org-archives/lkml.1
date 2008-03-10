Return-Path: <linux-kernel-owner+w=401wt.eu-S1752629AbYCJQju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbYCJQju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 12:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751012AbYCJQjn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 12:39:43 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:25820 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855AbYCJQjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 12:39:41 -0400
Subject: Re: [patch -mm v2] mempolicy: disallow static or relative flags
	for local preferred mode
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Jackson <pj@sgi.com>, Christoph Lameter <clameter@sgi.com>,
       Andi Kleen <ak@suse.de>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.00.0803081409260.12095@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0803081409260.12095@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Mon, 10 Mar 2008 12:39:33 -0400
Message-Id: <1205167173.5579.56.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-03-08 at 14:14 -0800, David Rientjes wrote:
> MPOL_F_STATIC_NODES and MPOL_F_RELATIVE_NODES don't mean anything for
> MPOL_PREFERRED policies that were created with an empty nodemask (for
> purely local allocations).  They'll never be invalidated because the
> allowed mems of a task changes or need to be rebound relative to a
> cpuset's placement.

Good.

> 
> Also fixes a bug identified by Lee Schermerhorn that disallowed empty
> nodemasks to be passed to MPOL_PREFERRED to specify local allocations.

I tested this patch atop David's other patches on 2-6.25-rc3-mm1 and I
agree that it fixes the regression with local allocations.  It also
preserves existing behavior for MPOL_DEFAULT.  

However, [and I'm going to sound like the "Nodemask Nazi" again, sorry]
it does change the behavior of MPOL_PREFERRED when one specifies a
non-empty nodemask with preferred/all node[s] outside of the
mems_allowed mask and neither MPOL_F_{STATIC|RELATIVE}_NODES are
specified.

Existing behavior is to return EINVAL in this case.  I had tried to
preserve this behavior with my
"silently-restrict-nodemask-to-allowed-nodes" patch with those ugly
"was_empty" and "is_empty" variables to capture the state of the
nodemask before and after we remove !allowed nodes.  I also tried to
preserve this behavior in the fix I had sent to the local alloc
regression, by passing a NULL nodemask pointer to the create op for
localalloc.

With this patch, we silently fall back to local allocation for
MPOL_PREFERRED.  This occurs because by the time mpol_new_preferred()
sees the nodemask, we may have masked off all nodes with the
current_mems_allowed mask.  I have a proposed patch below to address
this [atop this one].

Another comment in-line below.

Lee
> 
> Cc: Paul Jackson <pj@sgi.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Andi Kleen <ak@suse.de>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  Documentation/vm/numa_memory_policy.txt |   16 ++++++++++++++--
>  mm/mempolicy.c                          |   24 +++++++++++++++++-------
>  2 files changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
> --- a/Documentation/vm/numa_memory_policy.txt
> +++ b/Documentation/vm/numa_memory_policy.txt
> @@ -210,6 +210,12 @@ Components of Memory Policies
>  	    local allocation for a specific range of addresses--i.e. for
>  	    VMA policies.
>  
> +	    It is possible for the user to specify that local allocation is
> +	    always preferred by passing an empty nodemask with this mode.
> +	    If an empty nodemask is passed, the policy cannot use the
> +	    MPOL_F_STATIC_NODES or MPOL_F_RELATIVE_NODES flags described
> +	    below.
> +
>  	MPOL_INTERLEAVED:  This mode specifies that page allocations be
>  	interleaved, on a page granularity, across the nodes specified in
>  	the policy.  This mode also behaves slightly differently, based on
> @@ -259,7 +265,10 @@ Components of Memory Policies
>  	    occurs over that node.  If no nodes from the user's nodemask are
>  	    now allowed, the Default behavior is used.
>  
> -	    MPOL_F_STATIC_NODES cannot be used with MPOL_F_RELATIVE_NODES.
> +	    MPOL_F_STATIC_NODES cannot be combined with the
> +	    MPOL_F_RELATIVE_NODES flag.  It also cannot be used for
> +	    MPOL_PREFERRED policies that were created with an empty nodemask
> +	    (local allocation).
>  
>  	MPOL_F_RELATIVE_NODES:  This flag specifies that the nodemask passed
>  	by the user will be mapped relative to the set of the task or VMA's
> @@ -306,7 +315,10 @@ Components of Memory Policies
>  	    set of memory nodes allowed by the task's cpuset, as that may
>  	    change over time.
>  
> -	    MPOL_F_RELATIVE_NODES cannot be used with MPOL_F_STATIC_NODES.
> +	    MPOL_F_RELATIVE_NODES cannot be combined with the
> +	    MPOL_F_STATIC_NODES flag.  It also cannot be used for
> +	    MPOL_PREFERRED policies that were created with an empty nodemask
> +	    (local allocation).
>  
>  MEMORY POLICY APIs
>  
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -151,9 +151,7 @@ static int mpol_new_interleave(struct mempolicy *pol, const nodemask_t *nodes)
>  
>  static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
>  {
> -	if (nodes_empty(*nodes))
> -		return -EINVAL;
> -	pol->v.preferred_node = first_node(*nodes);
> +	pol->v.preferred_node = !nodes_empty(*nodes) ? first_node(*nodes) : -1;
>  	return 0;
>  }
>  
> @@ -176,10 +174,22 @@ static struct mempolicy *mpol_new(unsigned short mode, unsigned short flags,
>  	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
>  		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
>  
> -	if (nodes && nodes_empty(*nodes) && mode != MPOL_PREFERRED)
> -		return ERR_PTR(-EINVAL);
> -	if (mode == MPOL_DEFAULT)
> +	if (mode == MPOL_DEFAULT) {
> +		if (nodes && !nodes_empty(*nodes))
> +			return ERR_PTR(-EINVAL);
>  		return NULL;
> +	}

So, the only time we get a NULL 'nodes' pointer to mpol_new() is when we
pass MPOL_DEFAULT to mpol_shared_policy_init().  The syscall entries
always pass a non-null nodemask pointer to an on-stack nodemask_t.  I've
added a VM_BUG_ON() to assert this in the patch below, as the rest of
mpol_new() assumes a non-NULL 'nodes'.  Maybe should be just 'BUG_ON()'?

> +	/*
> +	 * MPOL_PREFERRED cannot be used with MPOL_F_STATIC_NODES or
> +	 * MPOL_F_RELATIVE_NODES if the nodemask is empty (local allocation).
> +	 * All other modes require a valid pointer to a non-empty nodemask.
> +	 */
> +	if (mode == MPOL_PREFERRED) {
> +		if (nodes_empty(*nodes) && ((flags & MPOL_F_STATIC_NODES) ||
> +					    (flags & MPOL_F_RELATIVE_NODES)))
> +			return ERR_PTR(-EINVAL);
> +	} else if (nodes_empty(*nodes))
> +		return ERR_PTR(-EINVAL);
>  	policy = kmem_cache_alloc(policy_cache, GFP_KERNEL);
>  	if (!policy)
>  		return ERR_PTR(-ENOMEM);
> @@ -250,7 +260,7 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
>  	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
>  		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
>  		pol->v.preferred_node = first_node(tmp);
> -	} else {
> +	} else if (pol->v.preferred_node != -1) {
>  		pol->v.preferred_node = node_remap(pol->v.preferred_node,
>  						   pol->w.cpuset_mems_allowed,
>  						   *nodes);

Here's a patch, atop the subject patch, that addresses the issues
discussed above.  Tested with the numactl regression "suite", my little
MPOL_DEFAULT error return test and a couple of ad hoc memtoy sessions in
and out of restricted cpusets.  All passed--once I remembered to exit
the restricted cpuset that didn't include nodes 0 & 1, used by the
regression test...

David:  if you agree with this, I can generate a combined patch with
your signoff and mine to replace the previous regression fix which I
believe Andrew has already added to -mm.  Or,

Andrew:  if you prefer, I can generate a patch atop the one you've
already added to the tree to accomplish the same thing.

Please advise...

Lee

-----------------------------------------------------------------------
Against:  2.6.25-rc3-mm1 atop "mempolicy:  disallow static or relative
flags for local preferred allocation - v2"

Restores error checking for MPOL_PREFERRED that specifies only
dis-allowed nodes.  Skips cpuset related mempolicy setup for 
local allocation.

Also, enforce mpol_new() assumption that 'nodes' arg is non-NULL
except for MPOL_DEFAULT.

Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>

 mm/mempolicy.c |   47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

Index: linux-2.6.25-rc3-mm1/mm/mempolicy.c
===================================================================
--- linux-2.6.25-rc3-mm1.orig/mm/mempolicy.c	2008-03-10 10:25:58.000000000 -0400
+++ linux-2.6.25-rc3-mm1/mm/mempolicy.c	2008-03-10 12:12:19.000000000 -0400
@@ -158,7 +158,9 @@ static int mpol_new_interleave(struct me
 
 static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	pol->v.preferred_node = !nodes_empty(*nodes) ? first_node(*nodes) : -1;
+	if (nodes && nodes_empty(*nodes))
+		return -EINVAL;
+	pol->v.preferred_node = nodes ? first_node(*nodes) : -1;
 	return 0;
 }
 
@@ -176,6 +178,7 @@ static struct mempolicy *mpol_new(unsign
 {
 	struct mempolicy *policy;
 	nodemask_t cpuset_context_nmask;
+	int localalloc = 0;
 	int ret;
 
 	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
@@ -186,36 +189,48 @@ static struct mempolicy *mpol_new(unsign
 			return ERR_PTR(-EINVAL);
 		return NULL;
 	}
+	VM_BUG_ON(!nodes);
+
 	/*
 	 * MPOL_PREFERRED cannot be used with MPOL_F_STATIC_NODES or
 	 * MPOL_F_RELATIVE_NODES if the nodemask is empty (local allocation).
 	 * All other modes require a valid pointer to a non-empty nodemask.
 	 */
 	if (mode == MPOL_PREFERRED) {
-		if (nodes_empty(*nodes) && ((flags & MPOL_F_STATIC_NODES) ||
-					    (flags & MPOL_F_RELATIVE_NODES)))
-			return ERR_PTR(-EINVAL);
+		if (nodes_empty(*nodes)) {
+			if (((flags & MPOL_F_STATIC_NODES) ||
+			     (flags & MPOL_F_RELATIVE_NODES)))
+				return ERR_PTR(-EINVAL);
+			localalloc++;
+		}
 	} else if (nodes_empty(*nodes))
 		return ERR_PTR(-EINVAL);
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
 	policy->flags = flags;
-	if (mpol_store_user_nodemask(policy))
-		policy->w.user_nodemask = *nodes;
-	else
-		policy->w.cpuset_mems_allowed = cpuset_mems_allowed(current);
+	if (!localalloc) {
+		/*
+		 * cpuset related setup doesn't apply to local allocation
+		 */
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
 
-	ret = mpol_ops[mode].create(policy, &cpuset_context_nmask);
+	ret = mpol_ops[mode].create(policy,
+				    localalloc ? NULL : &cpuset_context_nmask);
 	if (ret < 0) {
 		kmem_cache_free(policy_cache, policy);
 		return ERR_PTR(ret);


