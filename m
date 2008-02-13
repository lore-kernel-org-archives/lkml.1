Return-Path: <linux-kernel-owner+w=401wt.eu-S1765135AbYBMQOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765135AbYBMQOx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 11:14:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754878AbYBMQOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 11:14:44 -0500
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:28214 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbYBMQOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 11:14:43 -0500
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>
In-Reply-To: <alpine.DEB.1.00.0802122004190.11889@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	 <alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	 <1202862136.4974.41.camel@localhost>
	 <alpine.DEB.1.00.0802122004190.11889@chino.kir.corp.google.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Wed, 13 Feb 2008 09:14:47 -0700
Message-Id: <1202919288.4978.51.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-12 at 20:18 -0800, David Rientjes wrote:
> On Tue, 12 Feb 2008, Lee Schermerhorn wrote:
> 
> > > Adds another member to struct mempolicy,
> > > 
> > > 	nodemask_t user_nodemask
> > > 
> > > that stores the the nodemask that the user passed when he or she created
> > > the mempolicy via set_mempolicy() or mbind().  When using
> > > MPOL_F_STATIC_NODES, which is passed with any mempolicy mode, the user's
> > > passed nodemask is always used when determining the preferred node,
> > > building the MPOL_BIND zonelist, or creating the interleave nodemask.
> > > This happens whenever the policy is rebound, including when a task's
> > > cpuset assignment changes or the cpuset's mems are changed.
> > 
> > When you say that the user's nodemask is "always used" you mean "after
> > cpuset contextualization", right?  I.e., after masking with mems_allowed
> > [which also restricts to nodes with memory].  That is what the code
> > still does.  
> > 
> 
> Yeah, I'm not introducing a loophole so that tasks can access memory to 
> which they don't have access.  I've clarified that for the next version.

I though so.  The description just seemed ambiguous to me.  Thanks for
the clarification.
> 
> > > It is also possible to mount tmpfs with the static nodemask behavior when
> > > specifying a node or nodemask.  To do this, simply add "=static"
> > > immediately following the mempolicy mode at mount time:
> > > 
> > > 	mount -o remount mpol=interleave=static:1-3
> > > 
> > > Also removes mpol_check_policy() and folds some of its logic into
> > > mpol_new() since it is now mostly obsoleted.
> > 
> > Couple of comments here:
> > 
> > 1) we've discussed the issue of returning EINVAL for non-empty nodemasks
> > with MPOL_DEFAULT.  By removing this restriction, we run the risk of
> > breaking applications if we should ever want to define a semantic to
> > non-empty node mask for MPOL_DEFAULT.   I think this is probably
> > unlikely, but consider the new mode flags part of the mode/policy
> > parameter:  by not rejecting undefined flags, we may break applications
> > by later defining additional flags.  I'd argue for fairly strict
> > argument checking.
> > 
> 
> As I've mentioned in a parallel thread, I've folded the entire logic of 
> mpol_check_policy() as it stands this minute in Linus' tree into 
> mpol_new().

OK.  
> 
> > 2) Before this patch, policy_nodemask from the shmem_sb_info was NOT
> > masked with allowed nodes because we passed this mask directly to
> > mpol_new() without "contextualization".  We DO guarantee that this
> > policy nodemask contains only nodes with memory [see
> > shmem_parse_mpol()].  Now that you've moved the contextualization to
> > mpol_new(), we are masking this policy with the cpuset mems allowed.
> > This is a change in behavior.  Do we want this?  I.e., are we preserving
> > the "intent" of the system administrator in setting the tmpfs policy?
> > Maybe they wanted to shared interleaved shmem areas between cpusets with
> > disjoint mems allowed.  Nothing prevents this...
> > 
> 
> We're still saving the intent in the new policy->user_nodemask field so 
> any future rebinds will still allow unaccessible nodes be effected by the 
> mempolicy if the permissions are changed later.
> 
> > If we just want to preserve existing behavior, we can define an
> > additional mode flag that we set in the sbinfo policy in
> > shmem_parse_mpol() and test in mpol_new().  If we want to be able to
> > specify existing or new behavior, we can use the same flag, but set it
> > or not based on an additional qualifier specified via the mount option.
> > 
> 
> Shmem areas between cpusets with disjoint mems_allowed seems like an error 
> in userspace to me and I would prefer that mpol_new() reject it outright.

I don't think so, and I'd like to explain why.  Perhaps this is too big
a topic to cover in the context of this patch response.  I think I'll
start another thread.  Suffice it to say here that cpusets and
mempolicies don't constrain, in anyway, the ability of tasks in a cpuset
to attach to shmem segments created by tasks in other, perhaps disjoint,
cpusets.  The cpusets and mempolicies DO constrain page allocations,
however.  This can result in OOM faults for tasks in cpusets whose
mems_allowed contains no overlap with a shared policy installed by the
creating task.  This can be avoided if the task that creates the shmem
segment faults in all of the pages and SHM_LOCKs them down.  Whether
this is sufficient for all applications is subject of the other
discussion.  In any case, I think we need to point this out in mempolicy
and cpuset man pages.

> 
> > > @@ -218,21 +167,27 @@ static struct mempolicy *mpol_new(enum mempolicy_mode mode,
> > >  		return ERR_PTR(-ENOMEM);
> > >  	flags &= MPOL_MODE_FLAGS;
> > >  	atomic_set(&policy->refcnt, 1);
> > > +	cpuset_update_task_memory_state();
> > > +	nodes_and(cpuset_context_nmask, *nodes, cpuset_current_mems_allowed);
> > >  	switch (mode) {
> > >  	case MPOL_INTERLEAVE:
> > > -		policy->v.nodes = *nodes;
> > > +		if (nodes_empty(*nodes))
> > > +			return ERR_PTR(-EINVAL);
> > > +		policy->v.nodes = cpuset_context_nmask;
> > >  		if (nodes_weight(policy->v.nodes) == 0) {
> > >  			kmem_cache_free(policy_cache, policy);
> > >  			return ERR_PTR(-EINVAL);
> > >  		}
> > >  		break;
> > >  	case MPOL_PREFERRED:
> > > -		policy->v.preferred_node = first_node(*nodes);
> > > +		policy->v.preferred_node = first_node(cpuset_context_nmask);
> > >  		if (policy->v.preferred_node >= MAX_NUMNODES)
> > >  			policy->v.preferred_node = -1;
> > >  		break;
> > >  	case MPOL_BIND:
> > > -		policy->v.zonelist = bind_zonelist(nodes);
> > > +		if (nodes_empty(*nodes))
> > 
> > Kosaki-san already pointed out the need to free the policy struct
> > here.  
> > 
> 
> I folded your fix to have only one
> 
> 	kmem_cache_free(policy_cache, policy); 
> 	return ERR_PTR(error_code);
> 
> point in mpol_new().
> 
> > > @@ -1780,51 +1737,67 @@ static void mpol_rebind_policy(struct mempolicy *pol,
> > >  	if (nodes_equal(*mpolmask, *newmask))
> > >  		return;
> > >  
> > > +	remap = !(mpol_flags(pol->policy) & MPOL_F_STATIC_NODES);
> > >  	switch (mpol_mode(pol->policy)) {
> > >  	case MPOL_DEFAULT:
> > >  		break;
> > >  	case MPOL_INTERLEAVE:
> > > -		nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
> > > +		if (!remap)
> > > +			nodes_and(tmp, pol->user_nodemask, *newmask);
> > > +		else
> > > +			nodes_remap(tmp, pol->v.nodes, *mpolmask, *newmask);
> > >  		pol->v.nodes = tmp;
> > > -		*mpolmask = *newmask;
> > > -		current->il_next = node_remap(current->il_next,
> > > -						*mpolmask, *newmask);
> > > +		if (!node_isset(current->il_next, tmp)) {
> > > +			current->il_next = next_node(current->il_next, tmp);
> > > +			if (current->il_next >= MAX_NUMNODES)
> > > +				current->il_next = first_node(tmp);
> > > +			if (current->il_next >= MAX_NUMNODES)
> > > +				current->il_next = numa_node_id();
> > > +		}
> > >  		break;
> > >  	case MPOL_PREFERRED:
> > > -		pol->v.preferred_node = node_remap(pol->v.preferred_node,
> > > -						*mpolmask, *newmask);
> > > -		*mpolmask = *newmask;
> > > +		if (!remap && !node_isset(pol->v.preferred_node, *newmask))
> > > +			pol->v.preferred_node = -1;
> > > +		else
> > > +			pol->v.preferred_node = node_remap(pol->v.preferred_node,
> > > +							*mpolmask, *newmask);
> > 
> > Note:  "local allocation" [MPOL_PREFERRED with preferred_node == -1]
> > does not need and, IMO, should not be remapped.  Current code doesn't
> > check for this, but I think that it will do the right thing because
> > node_remap() will not remap an invalid node id.  However, I think it's
> > cleaner to explicitly check in the code.  I have a pending
> > MPOL_PREFERRED cleanup patch that address this.
> > 
> > That being said, I don't understand what you're trying to do with the
> > "then" clause, or rather, why.  Looks like you're explicitly dropping
> > back to local allocation?  Would you/could you add a comment explaining
> > the "intent"?
> > 
> 
> Since we're allowed to remap the node to a different node than the user 
> specified with either syscall, the current behavior is that "one node is 
> as good as another."  In other words, we're trying to accomodate the mode 
> first by setting pol->v.preferred_node to some accessible node and only 
> setting that to the user-supplied node if it is available.
> 
> If the node isn't available and the user specifically asked that it is not 
> remapped (with MPOL_F_STATIC_NODES), then I felt local allocation was best 
> compared to remapping to a node that may be unrelated to the VMA or task.  
> This preserves a sense of the current behavior that "one node is as good 
> as another," but the user specifically asked for no remap.

Yeah.  I went back and read the update to the mempolicy doc where you
make it clear that this is the semantic of 'STATIC_NODES.  You also
mentioned it in the patch description, but I didn't "get it".  Sorry.  

Still a comment in the code would, I think, help future spelunkers.

> 
> > >  		break;
> > >  	case MPOL_BIND: {
> > > -		nodemask_t nodes;
> > > -		struct zone **z;
> > > -		struct zonelist *zonelist;
> > > -
> > > -		nodes_clear(nodes);
> > > -		for (z = pol->v.zonelist->zones; *z; z++)
> > > -			node_set(zone_to_nid(*z), nodes);
> > > -		nodes_remap(tmp, nodes, *mpolmask, *newmask);
> > > -		nodes = tmp;
> > > +		struct zonelist *zonelist = NULL;
> > > +
> > > +		if (!remap)
> > > +			nodes_and(tmp, pol->user_nodemask, *newmask);
> > > +		else {
> > > +			nodemask_t nodes;
> > > +			struct zone **z;
> > > +
> > > +			nodes_clear(nodes);
> > > +			for (z = pol->v.zonelist->zones; *z; z++)
> > > +				node_set(zone_to_nid(*z), nodes);
> > > +			nodes_remap(tmp, nodes, *mpolmask, *newmask);
> > > +		}
> > >  
> > > -		zonelist = bind_zonelist(&nodes);
> > > +		if (nodes_weight(tmp))
> > > +			zonelist = bind_zonelist(&tmp);
> > 
> > Not sure I understand what's going on here [nor with the comment below
> > about "falling thru'" to MPOL_DEFAULT means].  However, this area is
> > vastly simplified by Mel Gorman's "two zonelist" patch series.  He
> > replaces the zonelist with a nodemask, so _BIND can share the
> > _INTERLEAVE case code.
> > 
> > Suggest you consider basing atop those.  
> > 
> 
> We'll have to see what the merge order turns out to be, because the 
> patchset you're referring to that modifies this in mm/mempolicy.c is not 
> currently in -mm.

Right.   I was hoping I could entice you to join the chorus in support
of Mel's patches because of the way they simplify the mempolicy
work. :-)

Lee
> 
> 		David

