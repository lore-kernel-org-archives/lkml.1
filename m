Return-Path: <linux-kernel-owner+w=401wt.eu-S1762759AbYBFCSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762759AbYBFCSg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 21:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbYBFCS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 21:18:27 -0500
Received: from smtp-out.google.com ([216.239.33.17]:15783 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbYBFCS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 21:18:26 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:user-agent:mime-version:content-type;
	b=k8kGGTvLCRQaizEwbNJ7TCFoftSPRM9uXm0+O8tkFfjXExMbOXPQk0h/I+c5t+ddN
	YQzmkvDTnOvJnay1KwXDQ==
Date: Tue, 5 Feb 2008 18:17:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Paul Jackson <pj@sgi.com>,
       Mel Gorman <mel@csn.ul.ie>, torvalds@linux-foundation.org,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't
 works on memoryless node.
In-Reply-To: <1202248652.5332.51.camel@localhost>
Message-ID: <alpine.DEB.1.00.0802051813250.19033@chino.kir.corp.google.com>
References: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>  <1202149243.5028.61.camel@localhost>  <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com> <1202248652.5332.51.camel@localhost>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2008, Lee Schermerhorn wrote:

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
>  
>  /* Generate a custom zonelist for the BIND policy. */

This change will be necessary when the nodemask passed from the syscall is 
saved in the struct mempolicy as the intent of the application as well.

> @@ -188,8 +188,6 @@ static struct mempolicy *mpol_new(int mo
>  	switch (mode) {
>  	case MPOL_INTERLEAVE:
>  		policy->v.nodes = *nodes;
> -		nodes_and(policy->v.nodes, policy->v.nodes,
> -					node_states[N_HIGH_MEMORY]);
>  		if (nodes_weight(policy->v.nodes) == 0) {
>  			kmem_cache_free(policy_cache, policy);
>  			return ERR_PTR(-EINVAL);
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

I would defer the intersection until later because contextualize_policy() 
is called before mpol_new() so we have no struct mempolicy to save the 
intent in.  It doesn't matter for the sake of this change, I know, but you 
could move this intersection to mpol_new() and give us an opportunity to 
store the user's nodemask in the mempolicy with a one-line change and get 
the same desired result.

You can now remove cpuset_nodes_subset_current_mems_allowed() from 
linux/cpuset.h.

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
>  	return do_mbind(start, len, mode, &nodes, flags);
>  }
>  

Looks good, thanks for doing this.
