Return-Path: <linux-kernel-owner+w=401wt.eu-S1752292AbYKLGCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbYKLGCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:02:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbYKLGCI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:02:08 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33852 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYKLGCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:02:07 -0500
Date: Wed, 12 Nov 2008 15:01:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v3)
Message-Id: <20081112150126.46ac6042.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <491A6E71.5010307@linux.vnet.ibm.com>
References: <20081111123314.6566.54133.sendpatchset@balbir-laptop>
	<20081111123417.6566.52629.sendpatchset@balbir-laptop>
	<20081112140236.46448b47.kamezawa.hiroyu@jp.fujitsu.com>
	<491A6E71.5010307@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 11:19:37 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Tue, 11 Nov 2008 18:04:17 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> This patch introduces hierarchical reclaim. When an ancestor goes over its
> >> limit, the charging routine points to the parent that is above its limit.
> >> The reclaim process then starts from the last scanned child of the ancestor
> >> and reclaims until the ancestor goes below its limit.
> >>
> > 
> >> +/*
> >> + * Dance down the hierarchy if needed to reclaim memory. We remember the
> >> + * last child we reclaimed from, so that we don't end up penalizing
> >> + * one child extensively based on its position in the children list.
> >> + *
> >> + * root_mem is the original ancestor that we've been reclaim from.
> >> + */
> >> +static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *mem,
> >> +						struct mem_cgroup *root_mem,
> >> +						gfp_t gfp_mask)
> >> +{
> >> +	struct cgroup *cg_current, *cgroup;
> >> +	struct mem_cgroup *mem_child;
> >> +	int ret = 0;
> >> +
> >> +	/*
> >> +	 * Reclaim unconditionally and don't check for return value.
> >> +	 * We need to reclaim in the current group and down the tree.
> >> +	 * One might think about checking for children before reclaiming,
> >> +	 * but there might be left over accounting, even after children
> >> +	 * have left.
> >> +	 */
> >> +	try_to_free_mem_cgroup_pages(mem, gfp_mask);
> >> +
> >> +	if (res_counter_check_under_limit(&root_mem->res))
> >> +		return 0;
> >> +
> >> +	cgroup_lock();
> >> +
> >> +	if (list_empty(&mem->css.cgroup->children)) {
> >> +		cgroup_unlock();
> >> +		return 0;
> >> +	}
> >> +
> >> +	/*
> >> +	 * Scan all children under the mem_cgroup mem
> >> +	 */
> >> +	if (!mem->last_scanned_child)
> >> +		cgroup = list_first_entry(&mem->css.cgroup->children,
> >> +				struct cgroup, sibling);
> >> +	else
> >> +		cgroup = mem->last_scanned_child->css.cgroup;
> >> +
> >> +	cg_current = cgroup;
> >> +
> >> +	do {
> >> +		struct list_head *next;
> >> +
> >> +		mem_child = mem_cgroup_from_cont(cgroup);
> >> +		cgroup_unlock();
> >> +
> >> +		ret = mem_cgroup_hierarchical_reclaim(mem_child, root_mem,
> >> +							gfp_mask);
> >> +		cgroup_lock();
> >> +		mem->last_scanned_child = mem_child;
> >> +		if (res_counter_check_under_limit(&root_mem->res)) {
> >> +			ret = 0;
> >> +			goto done;
> >> +		}
> >> +
> >> +		/*
> >> +		 * Since we gave up the lock, it is time to
> >> +		 * start from last cgroup
> >> +		 */
> >> +		cgroup = mem->last_scanned_child->css.cgroup;
> >> +		next = cgroup->sibling.next;
> >> +
> >> +		if (next == &cg_current->parent->children)
> >> +			cgroup = list_first_entry(&mem->css.cgroup->children,
> >> +							struct cgroup, sibling);
> >> +		else
> >> +			cgroup = container_of(next, struct cgroup, sibling);
> >> +	} while (cgroup != cg_current);
> >> +
> >> +done:
> >> +	cgroup_unlock();
> >> +	return ret;
> >> +}
> > 
> > Hmm, does this function is necessary to be complex as this ?
> > I'm sorry I don't have enough time to review now. (chasing memory online/offline bug.)
> > 
> > But I can't convice this is a good way to reclaim in hierachical manner.
> > 
> > In following tree, Assume that processes hit limitation of Level_2.
> > 
> >    Level_1 (no limit)
> > 	-> Level_2	(limit=1G)
> > 		-> Level_3_A (usage=30M)
> > 		-> Level_3_B (usage=100M)
> > 			-> Level_4_A (usage=50M)
> > 			-> Level_4_B (usage=400M)
> > 			-> Level_4_C (usage=420M)
> > 
> > Even if we know Level_4_C incudes tons of Inactive file caches,
> > some amount of swap-out will occur until reachin Level_4_C.
> > 
> > Can't we do this hierarchical reclaim in another way ?
> > (start from Level_4_C because we know it has tons of inactive caches.)
> > 
> > This style of recursive call doesn't have chance to do kind of optimization.
> > Can we do this reclaim in more flat manner as loop like following
> > =
> > try:
> >   select the most inactive one
> > 	-> try_to_fre_memory
> > 		-> check limit
> > 			-> go to try;
> > ==
> > 
> 
> I've been thinking along those lines as well and that will get more important as
> we try to implement soft limits. However, for the current version I wanted
> correctness. Fairness, I've seen is achieved, since groups with large number of
> inactive pages, does get reclaimed from more than others (in my simple
> experiments).
> 
> As far the pseudo code is concerned, select the most inactive one is an O(c)
> operation, where c is the number of nodes under the subtree and is expensive.
> The data structure and select algorithm get expensive. I am thinking about a
> more suitable approach for implementation, but I want to focus on correctness as
> the first step. Since the hierarchy is not enabled by default, I am not adding
> any additional overhead, so I think that this approach is suitable.
> 
What I say here is not "implement fairness" but "please make this algorithm easy
to be updated." If you'll implement soft-limit, please design this code to be
easily reused. (Again, I don't say do it now but please make code simpler.)

Can you make this code iterative rather than recursive ?

I don't like this kind of recursive call with complexed lock/unlock.

Thanks,
-Kame

