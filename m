Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbYKKFCX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbYKKFCX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 00:02:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbYKKFBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 00:01:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57842 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYKKFBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 00:01:51 -0500
Date: Tue, 11 Nov 2008 14:01:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v2)
Message-Id: <20081111140113.fc24d317.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49190E5F.2050109@linux.vnet.ibm.com>
References: <20081108091009.32236.26177.sendpatchset@localhost.localdomain>
	<20081108091100.32236.89666.sendpatchset@localhost.localdomain>
	<20081111120607.5ffe8a9c.kamezawa.hiroyu@jp.fujitsu.com>
	<49190E5F.2050109@linux.vnet.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 10:17:27 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Sat, 08 Nov 2008 14:41:00 +0530
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
> >>  mm/memcontrol.c |  152 +++++++++++++++++++++++++++++++++++++++++++++++---------
> >>  1 file changed, 128 insertions(+), 24 deletions(-)
> >>
> >> diff -puN mm/memcontrol.c~memcg-hierarchical-reclaim mm/memcontrol.c
> >> --- linux-2.6.28-rc2/mm/memcontrol.c~memcg-hierarchical-reclaim	2008-11-08 14:09:32.000000000 +0530
> >> +++ linux-2.6.28-rc2-balbir/mm/memcontrol.c	2008-11-08 14:09:32.000000000 +0530
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
> >> @@ -467,6 +472,124 @@ unsigned long mem_cgroup_isolate_pages(u
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
> >> +	if (list_empty(&mem->css.cgroup->children))
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
> > 
> > Who guarantee this last_scan_child is accessible at this point ?
> > 
> 
> Good catch! I'll fix this in mem_cgroup_destroy. It'll need some locking around
> it as well.
> 
please see mem+swap controller's refcnt-to-memcg for delaying free of memcg.
it will be a hint.

Thanks,
-Kame


> -- 
> 	Balbir
> 

