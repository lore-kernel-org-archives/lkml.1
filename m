Return-Path: <linux-kernel-owner+w=401wt.eu-S1763611AbYBMAWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763611AbYBMAWY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 19:22:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbYBMAWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 19:22:15 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:26263 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610AbYBMAWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 19:22:13 -0500
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 12 Feb 2008 17:22:16 -0700
Message-Id: <1202862136.4974.41.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-02-11 at 07:30 -0800, David Rientjes wrote: 
> Add an optional mempolicy mode flag, MPOL_F_STATIC_NODES, that suppresses
> the node remap when the policy is rebound.
> 
> Adds another member to struct mempolicy,
> 
> 	nodemask_t user_nodemask
> 
> that stores the the nodemask that the user passed when he or she created
> the mempolicy via set_mempolicy() or mbind().  When using
> MPOL_F_STATIC_NODES, which is passed with any mempolicy mode, the user's
> passed nodemask is always used when determining the preferred node,
> building the MPOL_BIND zonelist, or creating the interleave nodemask.
> This happens whenever the policy is rebound, including when a task's
> cpuset assignment changes or the cpuset's mems are changed.

When you say that the user's nodemask is "always used" you mean "after
cpuset contextualization", right?  I.e., after masking with mems_allowed
[which also restricts to nodes with memory].  That is what the code
still does.  

> 
> This creates an interesting side-effect in that it allows the mempolicy
> "intent" to lie dormant and uneffected until it has access to the node(s)
> that it desires.  For example, if you currently ask for an interleaved
> policy over a set of nodes that you do not have access to, the mempolicy
> is not created and the task continues to use the equivalent of
> MPOL_DEFAULT.  

You get an error [EINVAL], right?  The target policy [task or vma]
remains unchanged.  That may or may not be MPOL_DEFAULT, depending on
how the task was started [via numactl()] or the success of prior
set_mempolicy()/mbind() calls.

> With this change, however, it is possible to create the
> same mempolicy; it is effected only when access to the nodes is acquired.
> 
> It is also possible to mount tmpfs with the static nodemask behavior when
> specifying a node or nodemask.  To do this, simply add "=static"
> immediately following the mempolicy mode at mount time:
> 
> 	mount -o remount mpol=interleave=static:1-3
> 
> Also removes mpol_check_policy() and folds some of its logic into
> mpol_new() since it is now mostly obsoleted.

Couple of comments here:

1) we've discussed the issue of returning EINVAL for non-empty nodemasks
with MPOL_DEFAULT.  By removing this restriction, we run the risk of
breaking applications if we should ever want to define a semantic to
non-empty node mask for MPOL_DEFAULT.   I think this is probably
unlikely, but consider the new mode flags part of the mode/policy
parameter:  by not rejecting undefined flags, we may break applications
by later defining additional flags.  I'd argue for fairly strict
argument checking.

2) Before this patch, policy_nodemask from the shmem_sb_info was NOT
masked with allowed nodes because we passed this mask directly to
mpol_new() without "contextualization".  We DO guarantee that this
policy nodemask contains only nodes with memory [see
shmem_parse_mpol()].  Now that you've moved the contextualization to
mpol_new(), we are masking this policy with the cpuset mems allowed.
This is a change in behavior.  Do we want this?  I.e., are we preserving
the "intent" of the system administrator in setting the tmpfs policy?
Maybe they wanted to shared interleaved shmem areas between cpusets with
disjoint mems allowed.  Nothing prevents this...

If we just want to preserve existing behavior, we can define an
additional mode flag that we set in the sbinfo policy in
shmem_parse_mpol() and test in mpol_new().  If we want to be able to
specify existing or new behavior, we can use the same flag, but set it
or not based on an additional qualifier specified via the mount option.

[more below]

> 
> Cc: Paul Jackson <pj@sgi.com>
> Cc: Christoph Lameter <clameter@sgi.com>
> Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> Cc: Andi Kleen <ak@suse.de>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  include/linux/mempolicy.h |    4 +-
>  mm/mempolicy.c            |  137 ++++++++++++++++++---------------------------
>  mm/shmem.c                |    2 +
>  3 files changed, 60 insertions(+), 83 deletions(-)
> 
> diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
> --- a/include/linux/mempolicy.h
> +++ b/include/linux/mempolicy.h
> @@ -26,7 +26,8 @@ enum mempolicy_mode {
>  #define MPOL_MODE_MASK	((1 << MPOL_FLAG_SHIFT) - 1)
>  
>  /* Flags for set_mempolicy */
> -#define MPOL_MODE_FLAGS	(0)	/* legal set_mempolicy() MPOL_* mode flags */
> +#define MPOL_F_STATIC_NODES	(1 << MPOL_FLAG_SHIFT)
> +#define MPOL_MODE_FLAGS	(MPOL_F_STATIC_NODES)	/* legal set_mempolicy() MPOL_* mode flags */
>  
>  /* Flags for get_mempolicy */
>  #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
> @@ -82,6 +83,7 @@ struct mempolicy {
>  		/* undefined for default */
>  	} v;
>  	nodemask_t cpuset_mems_allowed;	/* mempolicy relative to these nodes */
> +	nodemask_t user_nodemask;	/* nodemask passed by user */
>  };
>  
>  /*
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -113,58 +113,6 @@ struct mempolicy default_policy = {
>  static void mpol_rebind_policy(struct mempolicy *pol,
>                                 const nodemask_t *newmask);
>  
> -/* Do sanity checking on a policy */
> -static int mpol_check_policy(enum mempolicy_mode mode, nodemask_t *nodes)
> -{
> -	int was_empty, is_empty;
> -
> -	if (!nodes)
> -		return 0;
> -
> -	/*
> -	 * "Contextualize" the in-coming nodemast for cpusets:
> -	 * Remember whether in-coming nodemask was empty,  If not,
> -	 * restrict the nodes to the allowed nodes in the cpuset.
> -	 * This is guaranteed to be a subset of nodes with memory.
> -	 */
> -	cpuset_update_task_memory_state();
> -	is_empty = was_empty = nodes_empty(*nodes);
> -	if (!was_empty) {
> -		nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
> -		is_empty = nodes_empty(*nodes);	/* after "contextualization" */
> -	}
> -
> -	switch (mode) {
> -	case MPOL_DEFAULT:
> -		/*
> -		 * require caller to specify an empty nodemask
> -		 * before "contextualization"
> -		 */
> -		if (!was_empty)
> -			return -EINVAL;

I'd like to see an equivalent check added to mpol_new().

> -		break;
> -	case MPOL_BIND:
> -	case MPOL_INTERLEAVE:
> -		/*
> -		 * require at least 1 valid node after "contextualization"
> -		 */
> -		if (is_empty)
> -			return -EINVAL;
> -		break;
> -	case MPOL_PREFERRED:
> -		/*
> -		 * Did caller specify invalid nodes?
> -		 * Don't silently accept this as "local allocation".
> -		 */
> -		if (!was_empty && is_empty)
> -			return -EINVAL;

Similar here:  without an equivalent check in mpol_new(), one can
specify a dis-allowed node, and end up with explict local allocation.  I
think that an error would be preferable in this case.

> -		break;
> -	default:
> -		BUG();
> -	}
> -	return 0;
> -}
> -
>  /* Generate a custom zonelist for the BIND policy. */
>  static struct zonelist *bind_zonelist(nodemask_t *nodes)
>  {
> @@ -207,6 +155,7 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
>  				  unsigned short flags, nodemask_t *nodes)
>  {
>  	struct mempolicy *policy;
> +	nodemask_t cpuset_context_nmask;
>  
>  	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
>  		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
> @@ -218,21 +167,27 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
>  		return ERR_PTR(-ENOMEM);
>  	flags &= MPOL_MODE_FLAGS;
>  	atomic_set(&policy->refcnt, 1);
> +	cpuset_update_task_memory_state();
> +	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
>  	switch (mode) {
>  	case MPOL_INTERLEAVE:
> -		policy->v.nodes = *nodes;
> +		if (nodes_empty(*nodes))
> +			return ERR_PTR(-EINVAL);
> +		policy->v.nodes = cpuset_context_nmask;
>  		if (nodes_weight(policy->v.nodes) == 0) {
>  			kmem_cache_free(policy_cache, policy);
>  			return ERR_PTR(-EINVAL);
>  		}
>  		break;
>  	case MPOL_PREFERRED:
> -		policy->v.preferred_node = first_node(*nodes);
> +		policy->v.preferred_node = first_node(cpuset_context_nmask);
>  		if (policy->v.preferred_node >= MAX_NUMNODES)
>  			policy->v.preferred_node = -1;
>  		break;
>  	case MPOL_BIND:
> -		policy->v.zonelist = bind_zonelist(nodes);
> +		if (nodes_empty(*nodes))

Kosaki-san already pointed out the need to free the policy struct
here.  

> +			return ERR_PTR(-EINVAL);
> +		policy->v.zonelist = bind_zonelist(&cpuset_context_nmask);
>  		if (IS_ERR(policy->v.zonelist)) {
>  			void *error_code = policy->v.zonelist;
>  			kmem_cache_free(policy_cache, policy);
> @@ -244,6 +199,7 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
>  	}
>  	policy->policy = mode | flags;
>  	policy->cpuset_mems_allowed = cpuset_mems_allowed(current);
> +	policy->user_nodemask = *nodes;
>  	return policy;
>  }
>  
> @@ -490,15 +446,14 @@ static long do_set_mempolicy(enum mempolicy_mode mode, unsigned short flags,
>  {
>  	struct mempolicy *new;
>  
> -	if (mpol_check_policy(mode, nodes))
> -		return -EINVAL;
>  	new = mpol_new(mode, flags, nodes);
>  	if (IS_ERR(new))
>  		return PTR_ERR(new);
>  	mpol_free(current->mempolicy);
>  	current->mempolicy = new;
>  	mpol_set_task_struct_flag();
> -	if (new && mpol_mode(new->policy) == MPOL_INTERLEAVE)
> +	if (new && mpol_mode(new->policy) == MPOL_INTERLEAVE &&
> +	    nodes_weight(new->v.nodes))
>  		current->il_next = first_node(new->v.nodes);
>  	return 0;
>  }
> @@ -818,9 +773,6 @@ static long do_mbind(unsigned long start, unsigned long len,
>  	if (end == start)
>  		return 0;
>  
> -	if (mpol_check_policy(mode, nmask))
> -		return -EINVAL;
> -
>  	new = mpol_new(mode, mode_flags, nmask);
>  	if (IS_ERR(new))
>  		return PTR_ERR(new);
> @@ -1211,7 +1163,8 @@ static unsigned interleave_nodes(struct mempolicy *policy)
>  	next = next_node(nid, policy->v.nodes);
>  	if (next >= MAX_NUMNODES)
>  		next = first_node(policy->v.nodes);
> -	me->il_next = next;
> +	if (next < MAX_NUMNODES)
> +		me->il_next = next;
>  	return nid;
>  }
>  
> @@ -1250,10 +1203,13 @@ static unsigned offset_il_node(struct mempolicy *pol,
>  		struct vm_area_struct *vma, unsigned long off)
>  {
>  	unsigned nnodes = nodes_weight(pol->v.nodes);
> -	unsigned target = (unsigned)off % nnodes;
> +	unsigned target;
>  	int c;
>  	int nid = -1;
>  
> +	if (!nnodes)
> +		return numa_node_id();
> +	target = (unsigned)off % nnodes;
>  	c = 0;
>  	do {
>  		nid = next_node(nid, pol->v.nodes);
> @@ -1773,6 +1729,7 @@ static void mpol_rebind_policy(struct mempolicy *pol,
>  {
>  	nodemask_t *mpolmask;
>  	nodemask_t tmp;
> +	int remap;
>  
>  	if (!pol)
>  		return;
> @@ -1780,51 +1737,67 @@ static void mpol_rebind_policy(struct mempolicy *pol,
>  	if (nodes_equal(*mpolmask, *newmask))
>  		return;
>  
> +	remap = !(mpol_flags(pol->policy) & MPOL_F_STATIC_NODES);
>  	switch (mpol_mode(pol->policy)) {
>  	case MPOL_DEFAULT:
>  		break;
>  	case MPOL_INTERLEAVE:
> -		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
> +		if (!remap)
> +			nodes_and(tmp, pol->user_nodemask, *newmask);
> +		else
> +			nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
>  		pol->v.nodes = tmp;
> -		*mpolmask = *newmask;
> -		current->il_next = node_remap(current->il_next,
> -						*mpolmask, *newmask);
> +		if (!node_isset(current->il_next, tmp)) {
> +			current->il_next = next_node(current->il_next, tmp);
> +			if (current->il_next >= MAX_NUMNODES)
> +				current->il_next = first_node(tmp);
> +			if (current->il_next >= MAX_NUMNODES)
> +				current->il_next = numa_node_id();
> +		}
>  		break;
>  	case MPOL_PREFERRED:
> -		pol->v.preferred_node = node_remap(pol->v.preferred_node,
> -						*mpolmask, *newmask);
> -		*mpolmask = *newmask;
> +		if (!remap && !node_isset(pol->v.preferred_node, *newmask))
> +			pol->v.preferred_node = -1;
> +		else
> +			pol->v.preferred_node = node_remap(pol->v.preferred_node,
> +							*mpolmask, *newmask);

Note:  "local allocation" [MPOL_PREFERRED with preferred_node == -1]
does not need and, IMO, should not be remapped.  Current code doesn't
check for this, but I think that it will do the right thing because
node_remap() will not remap an invalid node id.  However, I think it's
cleaner to explicitly check in the code.  I have a pending
MPOL_PREFERRED cleanup patch that address this.

That being said, I don't understand what you're trying to do with the
"then" clause, or rather, why.  Looks like you're explicitly dropping
back to local allocation?  Would you/could you add a comment explaining
the "intent"?

>  		break;
>  	case MPOL_BIND: {
> -		nodemask_t nodes;
> -		struct zone **z;
> -		struct zonelist *zonelist;
> -
> -		nodes_clear(nodes);
> -		for (z = pol->v.zonelist->zones; *z; z++)
> -			node_set(zone_to_nid(*z), nodes);
> -		nodes_remap(tmp, nodes, *mpolmask, *newmask);
> -		nodes = tmp;
> +		struct zonelist *zonelist = NULL;
> +
> +		if (!remap)
> +			nodes_and(tmp, pol->user_nodemask, *newmask);
> +		else {
> +			nodemask_t nodes;
> +			struct zone **z;
> +
> +			nodes_clear(nodes);
> +			for (z = pol->v.zonelist->zones; *z; z++)
> +				node_set(zone_to_nid(*z), nodes);
> +			nodes_remap(tmp, nodes, *mpolmask, *newmask);
> +		}
>  
> -		zonelist = bind_zonelist(&nodes);
> +		if (nodes_weight(tmp))
> +			zonelist = bind_zonelist(&tmp);

Not sure I understand what's going on here [nor with the comment below
about "falling thru'" to MPOL_DEFAULT means].  However, this area is
vastly simplified by Mel Gorman's "two zonelist" patch series.  He
replaces the zonelist with a nodemask, so _BIND can share the
_INTERLEAVE case code.

Suggest you consider basing atop those.  

>  
>  		/* If no mem, then zonelist is NULL and we keep old zonelist.
>  		 * If that old zonelist has no remaining mems_allowed nodes,
>  		 * then zonelist_policy() will "FALL THROUGH" to MPOL_DEFAULT.
>  		 */
>  
> -		if (!IS_ERR(zonelist)) {
> +		if (zonelist && !IS_ERR(zonelist)) {
>  			/* Good - got mem - substitute new zonelist */
>  			kfree(pol->v.zonelist);
>  			pol->v.zonelist = zonelist;
>  		}
> -		*mpolmask = *newmask;
>  		break;
>  	}
>  	default:
>  		BUG();
>  		break;
>  	}
> +	if (mpol_mode(pol->policy) != MPOL_DEFAULT)
> +		*mpolmask = *newmask;
>  }
>  
>  /*
> diff --git a/mm/shmem.c b/mm/shmem.c
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1129,6 +1129,8 @@ static int shmem_parse_mpol(char *value, unsigned short *policy,
>  		err = 0;
>  	}
>  	if (flags) {
> +		if (!strcmp(flags, "static"))
> +			*policy |= MPOL_F_STATIC_NODES;
>  	}
>  out:
>  	/* Restore string for error message */

