Return-Path: <linux-kernel-owner+w=401wt.eu-S1753894AbYKDCSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbYKDCSg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 21:18:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYKDCS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 21:18:28 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48399 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbYKDCS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 21:18:27 -0500
Date: Tue, 4 Nov 2008 11:17:51 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [mm] [PATCH 3/4] Memory cgroup hierarchical reclaim
Message-Id: <20081104111751.51ea897b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <490D3E50.9070606@linux.vnet.ibm.com>
References: <20081101184812.2575.68112.sendpatchset@balbir-laptop>
	<20081101184849.2575.37734.sendpatchset@balbir-laptop>
	<20081102143707.1bf7e2d0.kamezawa.hiroyu@jp.fujitsu.com>
	<490D3E50.9070606@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008 11:14:48 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Sun, 02 Nov 2008 00:18:49 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 
> >> This patch introduces hierarchical reclaim. When an ancestor goes over its
> >> limit, the charging routine points to the parent that is above its limit.
> >> The reclaim process then starts from the last scanned child of the ancestor
> >> and reclaims until the ancestor goes below its limit.
> >>
> >> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> >> ---
> >>
> >>  mm/memcontrol.c |  153 +++++++++++++++++++++++++++++++++++++++++++++++---------
> >>  1 file changed, 129 insertions(+), 24 deletions(-)
> >>
> >> diff -puN mm/memcontrol.c~memcg-hierarchical-reclaim mm/memcontrol.c
> >> --- linux-2.6.28-rc2/mm/memcontrol.c~memcg-hierarchical-reclaim	2008-11-02 00:14:59.000000000 +0530
> >> +++ linux-2.6.28-rc2-balbir/mm/memcontrol.c	2008-11-02 00:14:59.000000000 +0530
> >> @@ -132,6 +132,11 @@ struct mem_cgroup {
> >>  	 * statistics.
> >>  	 */
> >>  	struct mem_cgroup_stat stat;
> >> +	/*
> >> +	 * While reclaiming in a hiearchy, we cache the last child we
> >> +	 * reclaimed from.
> >> +	 */
> >> +	struct mem_cgroup *last_scanned_child;
> >>  };
> >>  static struct mem_cgroup init_mem_cgroup;
> >>  
> >> @@ -467,6 +472,125 @@ unsigned long mem_cgroup_isolate_pages(u
> >>  	return nr_taken;
> >>  }
> >>  
> >> +static struct mem_cgroup *
> >> +mem_cgroup_from_res_counter(struct res_counter *counter)
> >> +{
> >> +	return container_of(counter, struct mem_cgroup, res);
> >> +}
> >> +
> >> +/*
> >> + * Dance down the hierarchy if needed to reclaim memory. We remember the
> >> + * last child we reclaimed from, so that we don't end up penalizing
> >> + * one child extensively based on its position in the children list
> >> + */
> >> +static int
> >> +mem_cgroup_hierarchical_reclaim(struct mem_cgroup *mem, gfp_t gfp_mask)
> >> +{
> >> +	struct cgroup *cg, *cg_current, *cgroup;
> >> +	struct mem_cgroup *mem_child;
> >> +	int ret = 0;
> >> +
> >> +	if (try_to_free_mem_cgroup_pages(mem, gfp_mask))
> >> +		return -ENOMEM;
> >> +
> >> +	/*
> >> +	 * try_to_free_mem_cgroup_pages() might not give us a full
> >> +	 * picture of reclaim. Some pages are reclaimed and might be
> >> +	 * moved to swap cache or just unmapped from the cgroup.
> >> +	 * Check the limit again to see if the reclaim reduced the
> >> +	 * current usage of the cgroup before giving up
> >> +	 */
> >> +	if (res_counter_check_under_limit(&mem->res))
> >> +		return 0;
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
> >> +	/*
> >> +	 * We iterate twice, one of it is fundamental list issue, where
> >> +	 * the elements are inserted using list_add and hence the list
> >> +	 * behaves like a stack and list_for_entry_safe_from() stops
> >> +	 * after seeing the first child. The two loops help us work
> >> +	 * independently of the insertion and it helps us get a full pass at
> >> +	 * scanning all list entries for reclaim
> >> +	 */
> >> +	list_for_each_entry_safe_from(cgroup, cg, &cg_current->parent->children,
> >> +						 sibling) {
> >> +		mem_child = mem_cgroup_from_cont(cgroup);
> >> +
> >> +		/*
> >> +		 * Move beyond last scanned child
> >> +		 */
> >> +		if (mem_child == mem->last_scanned_child)
> >> +			continue;
> >> +
> >> +		ret = try_to_free_mem_cgroup_pages(mem_child, gfp_mask);
> >> +		mem->last_scanned_child = mem_child;
> >> +
> >> +		if (res_counter_check_under_limit(&mem->res)) {
> >> +			ret = 0;
> >> +			goto done;
> >> +		}
> >> +	}
> > 
> > Is this safe against cgroup create/remove ? cgroup_mutex is held ?
> 
> Yes, I thought about it, but with the setup, each parent will be busy since they
> have children and hence cannot be removed. The leaf child itself has tasks, so
> it cannot be removed. IOW, it should be safe against removal.
> 
I'm sorry if I misunderstand something. could you explain folloing ?

In following tree,

    level-1
         -  level-2
                -  level-3
                       -  level-4
level-1's usage = level-1 + level-2 + level-3 + level-4
level-2's usage = level-2 + level-3 + level-4
level-3's usage = level-3 + level-4
level-4's usage = level-4

Assume that a task in level-2 hits its limit. It has to reclaim memory from
level-2 and level-3, level-4.

How can we guarantee level-4 has a task in this case ?

Thanks,
-Kame

