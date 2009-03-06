Return-Path: <linux-kernel-owner+w=401wt.eu-S1755813AbZCFJw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755813AbZCFJw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 04:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZCFJwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 04:52:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39700 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324AbZCFJws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 04:52:48 -0500
Date: Fri, 6 Mar 2009 18:51:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] Memory controller soft limit reclaim on contention
 (v4)
Message-Id: <20090306185124.51a52519.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090306092353.21063.11068.sendpatchset@localhost.localdomain>
References: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
	<20090306092353.21063.11068.sendpatchset@localhost.localdomain>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Mar 2009 14:53:53 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> ---
> 
>  include/linux/memcontrol.h |    9 ++
>  include/linux/swap.h       |    5 +
>  mm/memcontrol.c            |  223 +++++++++++++++++++++++++++++++++++++++++---
>  mm/vmscan.c                |   26 +++++
>  4 files changed, 245 insertions(+), 18 deletions(-)
> 
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 18146c9..16343d0 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -116,6 +116,9 @@ static inline bool mem_cgroup_disabled(void)
>  }
>  
>  extern bool mem_cgroup_oom_called(struct task_struct *task);
> +unsigned long
> +mem_cgroup_soft_limit_reclaim(int priority, struct zone *zone, int nid,
> +				gfp_t gfp_mask);
>  
>  #else /* CONFIG_CGROUP_MEM_RES_CTLR */
>  struct mem_cgroup;
> @@ -264,6 +267,12 @@ mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  {
>  }
>  
> +static inline unsigned long
> +mem_cgroup_soft_limit_reclaim(int priority, struct zone *zone, int nid,
> +				gfp_t gfp_mask)
> +{
> +	return 0;
> +}
>  #endif /* CONFIG_CGROUP_MEM_CONT */
>  
>  #endif /* _LINUX_MEMCONTROL_H */
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 989eb53..37bc2a9 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -217,6 +217,11 @@ extern unsigned long try_to_free_pages(struct zonelist *zonelist, int order,
>  extern unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem,
>  						  gfp_t gfp_mask, bool noswap,
>  						  unsigned int swappiness);
> +extern unsigned long mem_cgroup_shrink_zone(struct mem_cgroup *mem,
> +						struct zone *zone,
> +						gfp_t gfp_mask,
> +						unsigned int swappiness,
> +						int priority);
>  extern int __isolate_lru_page(struct page *page, int mode, int file);
>  extern unsigned long shrink_all_memory(unsigned long nr_pages);
>  extern int vm_swappiness;
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d548dd2..3be1f27 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -20,6 +20,7 @@
>  #include <linux/res_counter.h>
>  #include <linux/memcontrol.h>
>  #include <linux/cgroup.h>
> +#include <linux/completion.h>
>  #include <linux/mm.h>
>  #include <linux/pagemap.h>
>  #include <linux/smp.h>
> @@ -191,6 +192,14 @@ struct mem_cgroup {
>  	unsigned long last_tree_update;		/* Last time the tree was */
>  						/* updated in jiffies     */
>  
> +	bool on_tree;				/* Is the node on tree? */
> +	struct completion wait_on_soft_reclaim;
> +	/*
> +	 * Set to > 0, when reclaim is initiated due to 
> +	 * the soft limit being exceeded. It adds an additional atomic
> +	 * operation to page fault path.
> +	 */
> +	int soft_limit_reclaim_count;
>  	/*
>  	 * statistics. This must be placed at the end of memcg.
>  	 */
> @@ -227,18 +236,29 @@ pcg_default_flags[NR_CHARGE_TYPE] = {
>  #define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
>  #define MEMFILE_ATTR(val)	((val) & 0xffff)
>  
> +/*
> + * Bits used for hierarchical reclaim bits
> + */
> +#define MEM_CGROUP_RECLAIM_NOSWAP_BIT	0x0
> +#define MEM_CGROUP_RECLAIM_NOSWAP	(1 << MEM_CGROUP_RECLAIM_NOSWAP_BIT)
> +#define MEM_CGROUP_RECLAIM_SHRINK_BIT	0x1
> +#define MEM_CGROUP_RECLAIM_SHRINK	(1 << MEM_CGROUP_RECLAIM_SHRINK_BIT)
> +#define MEM_CGROUP_RECLAIM_SOFT_BIT	0x2
> +#define MEM_CGROUP_RECLAIM_SOFT		(1 << MEM_CGROUP_RECLAIM_SOFT_BIT)
> +
>  static void mem_cgroup_get(struct mem_cgroup *mem);
>  static void mem_cgroup_put(struct mem_cgroup *mem);
>  static struct mem_cgroup *parent_mem_cgroup(struct mem_cgroup *mem);
>  
> -static void mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
> +static void __mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
>  {
>  	struct rb_node **p = &mem_cgroup_soft_limit_tree.rb_node;
>  	struct rb_node *parent = NULL;
>  	struct mem_cgroup *mem_node;
> -	unsigned long flags;
>  
> -	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> +	if (mem->on_tree)
> +		return;
> +
>  	while (*p) {
>  		parent = *p;
>  		mem_node = rb_entry(parent, struct mem_cgroup, mem_cgroup_node);
> @@ -255,6 +275,23 @@ static void mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
>  	rb_insert_color(&mem->mem_cgroup_node,
>  			&mem_cgroup_soft_limit_tree);
>  	mem->last_tree_update = jiffies;
> +	mem->on_tree = true;
> +}
> +
> +static void __mem_cgroup_remove_exceeded(struct mem_cgroup *mem)
> +{
> +	if (!mem->on_tree)
> +		return;
> +	rb_erase(&mem->mem_cgroup_node, &mem_cgroup_soft_limit_tree);
> +	mem->on_tree = false;
> +}
> +
> +static void mem_cgroup_insert_exceeded(struct mem_cgroup *mem)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> +	__mem_cgroup_insert_exceeded(mem);
>  	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
>  }
>  
> @@ -262,8 +299,34 @@ static void mem_cgroup_remove_exceeded(struct mem_cgroup *mem)
>  {
>  	unsigned long flags;
>  	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> -	rb_erase(&mem->mem_cgroup_node, &mem_cgroup_soft_limit_tree);
> +	__mem_cgroup_remove_exceeded(mem);
> +	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
> +}
> +
> +static struct mem_cgroup *mem_cgroup_get_largest_soft_limit_exceeding_node(void)
> +{
> +	struct rb_node *rightmost = NULL;
> +	struct mem_cgroup *mem = NULL;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> +retry:
> +	rightmost = rb_last(&mem_cgroup_soft_limit_tree);
> +	if (!rightmost)
> +		goto done;		/* Nothing to reclaim from */
> +
> +	mem = rb_entry(rightmost, struct mem_cgroup, mem_cgroup_node);
> +	/*
> +	 * Remove the node now but someone else can add it back,
> +	 * we will to add it back at the end of reclaim to its correct
> +	 * position in the tree.
> +	 */
> +	__mem_cgroup_remove_exceeded(mem);
> +	if (!css_tryget(&mem->css) || !res_counter_soft_limit_excess(&mem->res))
> +		goto retry;
> +done:
>  	spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
> +	return mem;
>  }
>  
>  static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
> @@ -324,6 +387,27 @@ static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
>  	return total;
>  }
>  
> +static unsigned long long
> +mem_cgroup_get_node_zone_usage(struct mem_cgroup *mem, struct zone *zone,
> +				int nid)
> +{
> +	int l;
> +	unsigned long long total = 0;
> +	struct mem_cgroup_per_zone *mz;
> +	unsigned long flags;
> +
> +	/*
> +	 * Is holding the zone LRU lock being overly protective?
> +	 * This routine is not invoked from the hot path anyway.
> +	 */
> +	spin_lock_irqsave(&zone->lru_lock, flags);
> +	mz = mem_cgroup_zoneinfo(mem, nid, zone_idx(zone));
> +	for_each_evictable_lru(l)
> +		total += MEM_CGROUP_ZSTAT(mz, l);
> +	spin_unlock_irqrestore(&zone->lru_lock, flags);
> +	return total * PAGE_SIZE;
> +}
> +
>  static struct mem_cgroup *mem_cgroup_from_cont(struct cgroup *cont)
>  {
>  	return container_of(cgroup_subsys_state(cont,
> @@ -888,14 +972,30 @@ mem_cgroup_select_victim(struct mem_cgroup *root_mem)
>   * If shrink==true, for avoiding to free too much, this returns immedieately.
>   */
>  static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
> -				   gfp_t gfp_mask, bool noswap, bool shrink)
> +						struct zone *zone,
> +						gfp_t gfp_mask,
> +						unsigned long flags,
> +						int priority)
>  {
>  	struct mem_cgroup *victim;
>  	int ret, total = 0;
>  	int loop = 0;
> +	bool noswap = flags & MEM_CGROUP_RECLAIM_NOSWAP;
> +	bool shrink = flags & MEM_CGROUP_RECLAIM_SHRINK;
> +	bool check_soft = flags & MEM_CGROUP_RECLAIM_SOFT;
>  
>  	while (loop < 2) {
>  		victim = mem_cgroup_select_victim(root_mem);
> +		/*
> +		 * In the first loop, don't reclaim from victims below
> +		 * their soft limit
> +		 */
> +		if (!loop && res_counter_check_under_soft_limit(&victim->res)) {
> +			if (victim == root_mem)
> +				loop++;
> +			css_put(&victim->css);
> +			continue;
> +		}
>  		if (victim == root_mem)
>  			loop++;
>  		if (!mem_cgroup_local_usage(&victim->stat)) {
> @@ -904,8 +1004,14 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  			continue;
>  		}
>  		/* we use swappiness of local cgroup */
> -		ret = try_to_free_mem_cgroup_pages(victim, gfp_mask, noswap,
> -						   get_swappiness(victim));
> +		if (!check_soft)
> +			ret = try_to_free_mem_cgroup_pages(victim, gfp_mask,
> +							noswap,
> +							get_swappiness(victim));
> +		else
> +			ret = mem_cgroup_shrink_zone(victim, zone, gfp_mask,
> +							get_swappiness(victim),
> +							priority);
>  		css_put(&victim->css);
>  		/*
>  		 * At shrinking usage, we can't check we should stop here or
> @@ -915,7 +1021,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  		if (shrink)
>  			return ret;
>  		total += ret;
> -		if (mem_cgroup_check_under_limit(root_mem))
> +		if (check_soft) {
> +			if (res_counter_check_under_soft_limit(&root_mem->res))
> +				return total;
> +		} else if (mem_cgroup_check_under_limit(root_mem))
>  			return 1 + total;
>  	}
>  	return total;
> @@ -1025,7 +1134,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  
>  	while (1) {
>  		int ret;
> -		bool noswap = false;
> +		unsigned long flags = 0;
>  
>  		ret = res_counter_charge(&mem->res, PAGE_SIZE, &fail_res,
>  						&soft_fail_res);
> @@ -1038,7 +1147,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  				break;
>  			/* mem+swap counter fails */
>  			res_counter_uncharge(&mem->res, PAGE_SIZE);
> -			noswap = true;
> +			flags = MEM_CGROUP_RECLAIM_NOSWAP;
>  			mem_over_limit = mem_cgroup_from_res_counter(fail_res,
>  									memsw);
>  		} else
> @@ -1049,8 +1158,8 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  		if (!(gfp_mask & __GFP_WAIT))
>  			goto nomem;
>  
> -		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
> -							noswap, false);
> +		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, NULL,
> +							gfp_mask, flags, 0);
>  		if (ret)
>  			continue;
>  
> @@ -1082,9 +1191,29 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  	 * soft limit
>  	 */
>  	if (soft_fail_res) {
> +		/*
> +		 * Throttle the task here, if it is undergoing soft limit
> +		 * reclaim and failing soft limits
> +		 */
> +		unsigned long flags;
> +		bool wait = false;
> +
> +		spin_lock_irqsave(&memcg_soft_limit_tree_lock, flags);
> +		if (mem->soft_limit_reclaim_count) {
> +			INIT_COMPLETION(mem->wait_on_soft_reclaim);
> +			wait = true;
> +		}
> +		spin_unlock_irqrestore(&memcg_soft_limit_tree_lock, flags);
>  		mem_over_soft_limit =
>  			mem_cgroup_from_res_counter(soft_fail_res, res);
>  		mem_cgroup_check_and_update_tree(mem_over_soft_limit, true);
> +		/*
> +		 * We hold the mmap_sem and throttle, I don't think there
> +		 * should be corner cases, but this part could use more
> +		 * review
> +		 */
> +		if (wait)
> +			wait_for_completion(&mem->wait_on_soft_reclaim);
>  	}
What ???? Why we have to wait here...holding mmap->sem...This is too bad.



>  	return 0;
>  nomem:
> @@ -1695,8 +1824,8 @@ int mem_cgroup_shrink_usage(struct page *page,
>  		return 0;
>  
>  	do {
> -		progress = mem_cgroup_hierarchical_reclaim(mem,
> -					gfp_mask, true, false);
> +		progress = mem_cgroup_hierarchical_reclaim(mem, NULL,
> +					gfp_mask, MEM_CGROUP_RECLAIM_NOSWAP, 0);
>  		progress += mem_cgroup_check_under_limit(mem);
>  	} while (!progress && --retry);
>  
> @@ -1750,8 +1879,9 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		progress = mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
> -						   false, true);
> +		progress = mem_cgroup_hierarchical_reclaim(memcg, NULL,
> +						GFP_KERNEL,
> +						MEM_CGROUP_RECLAIM_SHRINK, 0);
>  		curusage = res_counter_read_u64(&memcg->res, RES_USAGE);
>  		/* Usage is reduced ? */
>    		if (curusage >= oldusage)
> @@ -1799,7 +1929,9 @@ int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
>  
> -		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true, true);
> +		mem_cgroup_hierarchical_reclaim(memcg, NULL, GFP_KERNEL,
> +						MEM_CGROUP_RECLAIM_NOSWAP |
> +						MEM_CGROUP_RECLAIM_SHRINK, 0);
>  		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
>  		/* Usage is reduced ? */
>  		if (curusage >= oldusage)
> @@ -1810,6 +1942,59 @@ int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  	return ret;
>  }
>  
> +unsigned long
> +mem_cgroup_soft_limit_reclaim(int priority, struct zone *zone, int nid,
> +				gfp_t gfp_mask)
> +{
> +	unsigned long nr_reclaimed = 0;
> +	struct mem_cgroup *mem;
> +	unsigned long flags;
> +	unsigned long long usage;
> +
> +	/*
> +	 * This loop can run a while, specially if mem_cgroup's continuously
> +	 * keep exceeding their soft limit and putting the system under
> +	 * pressure
> +	 */
> +	do {
> +		mem = mem_cgroup_get_largest_soft_limit_exceeding_node();
> +		if (!mem)
> +			break;
> +		usage = mem_cgroup_get_node_zone_usage(mem, zone, nid);
> +		if (!usage)
> +			goto skip_reclaim;

Why this works well ? if "mem" is the laragest, it will be inserted again
as the largest. Do I miss any ?

Thanks,
-Kame

