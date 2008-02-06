Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbYBFQA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbYBFQA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 11:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751851AbYBFQAS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 11:00:18 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:35831 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYBFQAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 11:00:16 -0500
Subject: Re: [2.6.24 regression][BUGFIX] numactl --interleave=all doesn't
	works on memoryless node.
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Christoph Lameter <clameter@sgi.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Paul Jackson <pj@sgi.com>, David Rientjes <rientjes@google.com>,
       Mel Gorman <mel@csn.ul.ie>, torvalds@linux-foundation.org,
       Eric Whitney <eric.whitney@hp.com>
In-Reply-To: <Pine.LNX.4.64.0802051406500.14665@schroedinger.engr.sgi.com>
References: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1202149243.5028.61.camel@localhost>
	 <20080205163406.270B.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <1202248652.5332.51.camel@localhost>
	 <Pine.LNX.4.64.0802051406500.14665@schroedinger.engr.sgi.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 06 Feb 2008 11:00:17 -0500
Message-Id: <1202313618.5453.29.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-05 at 14:12 -0800, Christoph Lameter wrote:
> On Tue, 5 Feb 2008, Lee Schermerhorn wrote:
> 
> > mbind(2), on the other hand, just masks off any nodes in the 
> > nodemask that are not included in the caller's mems_allowed.
> 
> Ok so we temporarily adopt these semantics for set_mempolicy.
> 
> > 1) modify contextualize_policy to just remove the non-allowed
> >    nodes, as is currently done in-line for mbind().  This
> >    guarantees that the resulting mask includes only nodes with
> >    memory.
> 
> Right make ssense. we already contextualize for cpusets.

Only for mbind().  set_mempolicy(), via contextualize_policy() was just
returning EINVAL for invalid nodes in the mask.  I don't know if it
always worked like this, or if we did this in the memoryless nodes
series...

> 
> > Index: Linux/mm/mempolicy.c
> > ===================================================================
> > --- Linux.orig/mm/mempolicy.c	2008-02-05 11:25:17.000000000 -0500
> > +++ Linux/mm/mempolicy.c	2008-02-05 16:03:11.000000000 -0500
> > @@ -131,7 +131,7 @@ static int mpol_check_policy(int mode, n
> >  			return -EINVAL;
> >  		break;
> >  	}
> > - 	return nodes_subset(*nodes, node_states[N_HIGH_MEMORY]) ? 0 : -EINVAL;
> > + 	return 0;
> >  }
> 
> Hmmm... That is a pretty drastic change.

the nodes_subset() would always return true, once we mask it with
cpuset_current_mems_allowed(), right?  mems_allowed can now only contain
nodes with memory and if cpusets are not configured,
cpuset_current_mems_allowed() just returns node_states[N_HIGH_MEMORY].

So, I think this is a no-op.

> 
> > @@ -188,8 +188,6 @@ static struct mempolicy *mpol_new(int mo
> >  	switch (mode) {
> >  	case MPOL_INTERLEAVE:
> >  		policy->v.nodes = *nodes;
> > -		nodes_and(policy->v.nodes, policy->v.nodes,
> > -					node_states[N_HIGH_MEMORY]);
> >  		if (nodes_weight(policy->v.nodes) == 0) {
> >  			kmem_cache_free(policy_cache, policy);
> >  			return ERR_PTR(-EINVAL);
> 
> Do we really need to remove these lines if we change set_mempolicy?

Again, with the change to contextualize_policy(), the nodemask is
guaranteed to only contain nodes with memory, so this was redundant.

> 
> > @@ -426,9 +424,13 @@ static int contextualize_policy(int mode
> >  	if (!nodes)
> >  		return 0;
> >  
> > +	/*
> > +	 * Restrict the nodes to the allowed nodes in the cpuset.
> > +	 * This is guaranteed to be a subset of nodes with memory.
> > +	 */
> >  	cpuset_update_task_memory_state();
> > -	if (!cpuset_nodes_subset_current_mems_allowed(*nodes))
> > -		return -EINVAL;
> > +	nodes_and(*nodes, *nodes, cpuset_current_mems_allowed);
> > +
> >  	return mpol_check_policy(mode, nodes);
> >  }
> >  
> 
> Ditto?

This is the main change in the patch:  masking off the invalid nodes
[like sys_mbind() did inline] rather than complaining about them.

However, after I finish testing, I will post an update to this patch
which restores some of the error checks that this change lost.

> 
> > @@ -797,7 +799,7 @@ static long do_mbind(unsigned long start
> >  	if (end == start)
> >  		return 0;
> >  
> > -	if (mpol_check_policy(mode, nmask))
> > +	if (contextualize_policy(mode, nmask))
> >  		return -EINVAL;
> >  
> >  	new = mpol_new(mode, nmask);
> > @@ -915,10 +917,6 @@ asmlinkage long sys_mbind(unsigned long 
> >  	err = get_nodes(&nodes, nmask, maxnode);
> >  	if (err)
> >  		return err;
> > -#ifdef CONFIG_CPUSETS
> > -	/* Restrict the nodes to the allowed nodes in the cpuset */
> > -	nodes_and(nodes, nodes, current->mems_allowed);
> > -#endif
> 
> Would just removing #ifdef CONFIG_CPUSETS work? mems_allowed falls back to 
> node_possible_map.... Shouldnt that be node_online_map?

I removed this because I changed do_mbind() to call the revised
contextualize_policy() that does exactly this masking.  I didn't see any
reason to leave the duplicate code there.

I think that mems_allowed now falls back to nodes with memory.  Or it
should in the current code.  When Paul adds his new magic, that might
change.

Lee
> 

