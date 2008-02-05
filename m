Return-Path: <linux-kernel-owner+w=401wt.eu-S1762126AbYBEWMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762126AbYBEWMV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 17:12:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760533AbYBEWMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 17:12:14 -0500
Received: from relay2.sgi.com ([192.48.171.30]:50742 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760065AbYBEWMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 17:12:12 -0500
Date: Tue, 5 Feb 2008 14:12:11 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>,
       Mel Gorman <mel@csn.ul.ie>, torvalds@linux-foundation.org,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't
 works on memoryless node.
In-Reply-To: <1202248652.5332.51.camel@localhost>
Message-ID: <Pine.LNX.4.64.0802051406500.14665@schroedinger.engr.sgi.com>
References: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com> 
 <1202149243.5028.61.camel@localhost>  <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
 <1202248652.5332.51.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Lee Schermerhorn wrote:

> mbind(2), on the other hand, just masks off any nodes in the 
> nodemask that are not included in the caller's mems_allowed.

Ok so we temporarily adopt these semantics for set_mempolicy.

> 1) modify contextualize_policy to just remove the non-allowed
>    nodes, as is currently done in-line for mbind().  This
>    guarantees that the resulting mask includes only nodes with
>    memory.

Right make ssense. we already contextualize for cpusets.

> Index: Linux/mm/mempolicy.c
> ===================================================================
> --- Linux.orig/mm/mempolicy.c	2008-02-05 11:25:17.000000000 -0500
> +++ Linux/mm/mempolicy.c	2008-02-05 16:03:11.000000000 -0500
> @@ -131,7 +131,7 @@ static int mpol_check_policy(int mode, n
>  			return -EINVAL;
>  		break;
>  	}
> - 	return nodes_subset(*nodes, node_states[N_HIGH_MEMORY]) ? 0 : -EINVAL;
> + 	return 0;
>  }

Hmmm... That is a pretty drastic change.

> @@ -188,8 +188,6 @@ static struct mempolicy *mpol_new(int mo
>  	switch (mode) {
>  	case MPOL_INTERLEAVE:
>  		policy->v.nodes = *nodes;
> -		nodes_and(policy->v.nodes, policy->v.nodes,
> -					node_states[N_HIGH_MEMORY]);
>  		if (nodes_weight(policy->v.nodes) == 0) {
>  			kmem_cache_free(policy_cache, policy);
>  			return ERR_PTR(-EINVAL);

Do we really need to remove these lines if we change set_mempolicy?

> @@ -426,9 +424,13 @@ static int contextualize_policy(int mode
>  	if (!nodes)
>  		return 0;
>  
> +	/*
> +	 * Restrict the nodes to the allowed nodes in the cpuset.
> +	 * This is guaranteed to be a subset of nodes with memory.
> +	 */
>  	cpuset_update_task_memory_state();
> -	if (!cpuset_nodes_subset_current_mems_allowed(*nodes))
> -		return -EINVAL;
> +	nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
> +
>  	return mpol_check_policy(mode, nodes);
>  }
>  

Ditto?

> @@ -797,7 +799,7 @@ static long do_mbind(unsigned long start
>  	if (end == start)
>  		return 0;
>  
> -	if (mpol_check_policy(mode, nmask))
> +	if (contextualize_policy(mode, nmask))
>  		return -EINVAL;
>  
>  	new = mpol_new(mode, nmask);
> @@ -915,10 +917,6 @@ asmlinkage long sys_mbind(unsigned long 
>  	err = get_nodes(&nodes, nmask, maxnode);
>  	if (err)
>  		return err;
> -#ifdef CONFIG_CPUSETS
> -	/* Restrict the nodes to the allowed nodes in the cpuset */
> -	nodes_and(nodes, nodes, current->mems_allowed);
> -#endif

Would just removing #ifdef CONFIG_CPUSETS work? mems_allowed falls back to 
node_possible_map.... Shouldnt that be node_online_map?

