Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYLBHwb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYLBHwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 02:52:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbYLBHwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 02:52:22 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47681 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbYLBHwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 02:52:21 -0500
Date: Tue, 2 Dec 2008 16:51:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] memcg: make memory.swappiness file. take2
Message-Id: <20081202165130.da859fe1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081202164426.1D0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081202164334.1D0C.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	<20081202164426.1D0F.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Dec 2008 16:45:09 +0900 (JST)
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Currently, /proc/sys/vm/swappiness can change swappiness ratio for global reclaim.
> However, memcg reclaim doesn't have tuning parameter for itself.
> 
> In general, the optimal swappiness depend on workload.
> (e.g. hpc workload need to low swappiness than the others.)
> 
> Then, per cgroup swappiness improve administrator tunability.
> 
> 
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  Documentation/controllers/memory.txt |    6 ++
>  include/linux/swap.h                 |    3 -
>  mm/memcontrol.c                      |   72 ++++++++++++++++++++++++++++++++---
>  mm/vmscan.c                          |    7 +--
>  4 files changed, 78 insertions(+), 10 deletions(-)
> 
> Index: b/mm/memcontrol.c
> ===================================================================
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -161,6 +161,9 @@ struct mem_cgroup {
>  	unsigned long	last_oom_jiffies;
>  	int		obsolete;
>  	atomic_t	refcnt;
> +
> +	unsigned int	swappiness;
> +
>  	/*
>  	 * statistics. This must be placed at the end of memcg.
>  	 */
> @@ -586,6 +589,22 @@ done:
>  	return ret;
>  }
>  
> +static unsigned int get_swappiness(struct mem_cgroup *memcg)
> +{
> +	struct cgroup *cgrp = memcg->css.cgroup;
> +	unsigned int swappiness;
> +
> +	/* root ? */
> +	if (cgrp->parent == NULL)
> +		return vm_swappiness;
> +
> +	spin_lock(&memcg->reclaim_param_lock);
> +	swappiness = memcg->swappiness;
> +	spin_unlock(&memcg->reclaim_param_lock);
> +
> +	return swappiness;
> +}
> +
>  /*
>   * Dance down the hierarchy if needed to reclaim memory. We remember the
>   * last child we reclaimed from, so that we don't end up penalizing
> @@ -606,7 +625,8 @@ static int mem_cgroup_hierarchical_recla
>  	 * but there might be left over accounting, even after children
>  	 * have left.
>  	 */
> -	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap);
> +	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
> +					   get_swappiness(root_mem));
>  	if (res_counter_check_under_limit(&root_mem->res))
>  		return 0;
>  
> @@ -620,7 +640,8 @@ static int mem_cgroup_hierarchical_recla
>  			cgroup_unlock();
>  			continue;
>  		}
> -		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap);
> +		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
> +						   get_swappiness(next_mem));
>  		if (res_counter_check_under_limit(&root_mem->res))
>  			return 0;
>  		cgroup_lock();
> @@ -1348,7 +1369,8 @@ int mem_cgroup_shrink_usage(struct mm_st
>  	rcu_read_unlock();
>  
>  	do {
> -		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true);
> +		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true,
> +							get_swappiness(mem));
>  		progress += res_counter_check_under_limit(&mem->res);
>  	} while (!progress && --retry);
>  
> @@ -1393,7 +1415,9 @@ static int mem_cgroup_resize_limit(struc
>  			break;
>  
>  		progress = try_to_free_mem_cgroup_pages(memcg,
> -				GFP_HIGHUSER_MOVABLE, false);
> +							GFP_HIGHUSER_MOVABLE,
> +							false,
> +							get_swappiness(memcg));
>    		if (!progress)			retry_count--;
>  	}
>  	return ret;
> @@ -1433,7 +1457,8 @@ int mem_cgroup_resize_memsw_limit(struct
>  			break;
>  
>  		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
> -		try_to_free_mem_cgroup_pages(memcg, GFP_HIGHUSER_MOVABLE, true);
> +		try_to_free_mem_cgroup_pages(memcg, GFP_HIGHUSER_MOVABLE, true,
> +					     get_swappiness(memcg));
>  		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
>  		if (curusage >= oldusage)
>  			retry_count--;
> @@ -1565,7 +1590,9 @@ try_to_free:
>  			goto out;
>  		}
>  		progress = try_to_free_mem_cgroup_pages(mem,
> -						  GFP_HIGHUSER_MOVABLE, false);
> +							GFP_HIGHUSER_MOVABLE,
> +							false,
> +							get_swappiness(mem));
>  		if (!progress) {
>  			nr_retries--;
>  			/* maybe some writeback is necessary */
> @@ -1755,6 +1782,31 @@ static int mem_control_stat_show(struct 
>  	return 0;
>  }
>  
> +static u64 mem_cgroup_swappiness_read(struct cgroup *cgrp, struct cftype *cft)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> +
> +	return get_swappiness(memcg);
> +}
> +
> +static int mem_cgroup_swappiness_write(struct cgroup *cgrp, struct cftype *cft,
> +				       u64 val)
> +{
> +	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgrp);
> +
> +	if (val > 100)
> +		return -EINVAL;
> +
> +	if (cgrp->parent == NULL)
> +		return -EBUSY;
> +
Hmm, when -EBUSY, it seems this will success in somewher future...
I'll change this to -EINVAL at queuing.

Thanks,
-Kame

> +	spin_lock(&memcg->reclaim_param_lock);
> +	memcg->swappiness = val;
> +	spin_unlock(&memcg->reclaim_param_lock);
> +
> +	return 0;
> +}
> +
>  
>  static struct cftype mem_cgroup_files[] = {
>  	{
> @@ -1793,6 +1845,11 @@ static struct cftype mem_cgroup_files[] 
>  		.write_u64 = mem_cgroup_hierarchy_write,
>  		.read_u64 = mem_cgroup_hierarchy_read,
>  	},
> +	{
> +		.name = "swappiness",
> +		.read_u64 = mem_cgroup_swappiness_read,
> +		.write_u64 = mem_cgroup_swappiness_write,
> +	},
>  };
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> @@ -1984,6 +2041,9 @@ mem_cgroup_create(struct cgroup_subsys *
>  	mem->last_scanned_child = NULL;
>  	spin_lock_init(&mem->reclaim_param_lock);
>  
> +	if (parent)
> +		mem->swappiness = get_swappiness(parent);
> +
>  	return &mem->css;
>  free_out:
>  	for_each_node_state(node, N_POSSIBLE)
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1716,14 +1716,15 @@ unsigned long try_to_free_pages(struct z
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  
>  unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
> -						gfp_t gfp_mask,
> -					   bool noswap)
> +					   gfp_t gfp_mask,
> +					   bool noswap,
> +					   unsigned int swappiness)
>  {
>  	struct scan_control sc = {
>  		.may_writepage = !laptop_mode,
>  		.may_swap = 1,
>  		.swap_cluster_max = SWAP_CLUSTER_MAX,
> -		.swappiness = vm_swappiness,
> +		.swappiness = swappiness,
>  		.order = 0,
>  		.mem_cgroup = mem_cont,
>  		.isolate_pages = mem_cgroup_isolate_pages,
> Index: b/include/linux/swap.h
> ===================================================================
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -214,7 +214,8 @@ static inline void lru_cache_add_active_
>  extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  					gfp_t gfp_mask);
>  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
> -						gfp_t gfp_mask, bool noswap);
> +						  gfp_t gfp_mask, bool noswap,
> +						  unsigned int swappiness);
>  extern int __isolate_lru_page(struct page *page, int mode, int file);
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
>  extern int vm_swappiness;
> Index: b/Documentation/controllers/memory.txt
> ===================================================================
> --- a/Documentation/controllers/memory.txt
> +++ b/Documentation/controllers/memory.txt
> @@ -289,6 +289,12 @@ will be charged as a new owner of it.
>    Because rmdir() moves all pages to parent, some out-of-use page caches can be
>    moved to the parent. If you want to avoid that, force_empty will be useful.
>  
> +5.2 swappiness
> +  Similar to /proc/sys/vm/swappiness, but affecting one group only.
> +
> +  The root cgroup can't be changed this parameter.
> +  it always use /proc/sys/vm/swappiness internally.
> +
>  6. Hierarchy support
>  
>  The memory controller supports a deep hierarchy and hierarchical accounting.
> 
> 
> 

