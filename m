Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab0BVQAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 11:00:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab0BVQAI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 11:00:08 -0500
Date: Mon, 22 Feb 2010 10:58:40 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrea Righi <arighi@develer.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
	infrastructure
Message-ID: <20100222155840.GC13823@redhat.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-2-git-send-email-arighi@develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266765525-30890-2-git-send-email-arighi@develer.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 21, 2010 at 04:18:44PM +0100, Andrea Righi wrote:
> Infrastructure to account dirty pages per cgroup + add memory.dirty_bytes limit
> in cgroupfs.
> 
> Signed-off-by: Andrea Righi <arighi@develer.com>
> ---
>  include/linux/memcontrol.h |   31 ++++++
>  mm/memcontrol.c            |  218 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 248 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 1f9b119..ba3fe0d 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -25,6 +25,16 @@ struct page_cgroup;
>  struct page;
>  struct mm_struct;
>  
> +/* Cgroup memory statistics items exported to the kernel */
> +enum memcg_page_stat_item {
> +	MEMCG_NR_FREE_PAGES,
> +	MEMCG_NR_RECLAIMABLE_PAGES,
> +	MEMCG_NR_FILE_DIRTY,
> +	MEMCG_NR_WRITEBACK,
> +	MEMCG_NR_WRITEBACK_TEMP,
> +	MEMCG_NR_UNSTABLE_NFS,
> +};
> +
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  /*
>   * All "charge" functions with gfp_mask should use GFP_KERNEL or
> @@ -48,6 +58,8 @@ extern void mem_cgroup_cancel_charge_swapin(struct mem_cgroup *ptr);
>  
>  extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  					gfp_t gfp_mask);
> +extern void mem_cgroup_charge_dirty(struct page *page,
> +			enum zone_stat_item idx, int charge);
>  extern void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru);
>  extern void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru);
>  extern void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru);
> @@ -117,6 +129,10 @@ extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
>  extern int do_swap_account;
>  #endif
>  
> +extern unsigned long mem_cgroup_dirty_bytes(void);
> +
> +extern u64 mem_cgroup_page_state(enum memcg_page_stat_item item);
> +
>  static inline bool mem_cgroup_disabled(void)
>  {
>  	if (mem_cgroup_subsys.disabled)
> @@ -144,6 +160,11 @@ static inline int mem_cgroup_cache_charge(struct page *page,
>  	return 0;
>  }
>  
> +static inline void mem_cgroup_charge_dirty(struct page *page,
> +			enum zone_stat_item idx, int charge)
> +{
> +}
> +
>  static inline int mem_cgroup_try_charge_swapin(struct mm_struct *mm,
>  		struct page *page, gfp_t gfp_mask, struct mem_cgroup **ptr)
>  {
> @@ -312,6 +333,16 @@ unsigned long mem_cgroup_soft_limit_reclaim(struct zone *zone, int order,
>  	return 0;
>  }
>  
> +static inline unsigned long mem_cgroup_dirty_bytes(void)
> +{
> +	return vm_dirty_bytes;
> +}
> +
> +static inline u64 mem_cgroup_page_state(enum memcg_page_stat_item item)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_CGROUP_MEM_CONT */
>  
>  #endif /* _LINUX_MEMCONTROL_H */
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 954032b..288b9a4 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -64,13 +64,18 @@ enum mem_cgroup_stat_index {
>  	/*
>  	 * For MEM_CONTAINER_TYPE_ALL, usage = pagecache + rss.
>  	 */
> -	MEM_CGROUP_STAT_CACHE, 	   /* # of pages charged as cache */
> +	MEM_CGROUP_STAT_CACHE,	   /* # of pages charged as cache */
>  	MEM_CGROUP_STAT_RSS,	   /* # of pages charged as anon rss */
>  	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
>  	MEM_CGROUP_STAT_PGPGIN_COUNT,	/* # of pages paged in */
>  	MEM_CGROUP_STAT_PGPGOUT_COUNT,	/* # of pages paged out */
>  	MEM_CGROUP_STAT_EVENTS,	/* sum of pagein + pageout for internal use */
>  	MEM_CGROUP_STAT_SWAPOUT, /* # of pages, swapped out */
> +	MEM_CGROUP_STAT_FILE_DIRTY,   /* # of dirty pages in page cache */
> +	MEM_CGROUP_STAT_WRITEBACK,   /* # of pages under writeback */
> +	MEM_CGROUP_STAT_WRITEBACK_TEMP,   /* # of pages under writeback using
> +						temporary buffers */
> +	MEM_CGROUP_STAT_UNSTABLE_NFS,   /* # of NFS unstable pages */
>  
>  	MEM_CGROUP_STAT_NSTATS,
>  };
> @@ -225,6 +230,9 @@ struct mem_cgroup {
>  	/* set when res.limit == memsw.limit */
>  	bool		memsw_is_minimum;
>  
> +	/* control memory cgroup dirty pages */
> +	unsigned long dirty_bytes;
> +
>  	/*
>  	 * statistics. This must be placed at the end of memcg.
>  	 */
> @@ -519,6 +527,67 @@ static void mem_cgroup_charge_statistics(struct mem_cgroup *mem,
>  	put_cpu();
>  }
>  
> +static struct mem_cgroup *get_mem_cgroup_from_page(struct page *page)
> +{
> +	struct page_cgroup *pc;
> +	struct mem_cgroup *mem = NULL;
> +
> +	pc = lookup_page_cgroup(page);
> +	if (unlikely(!pc))
> +		return NULL;
> +	lock_page_cgroup(pc);
> +	if (PageCgroupUsed(pc)) {
> +		mem = pc->mem_cgroup;
> +		if (mem)
> +			css_get(&mem->css);
> +	}
> +	unlock_page_cgroup(pc);
> +	return mem;
> +}
> +
> +void mem_cgroup_charge_dirty(struct page *page,
> +			enum zone_stat_item idx, int charge)
> +{
> +	struct mem_cgroup *mem;
> +	struct mem_cgroup_stat_cpu *cpustat;
> +	unsigned long flags;
> +	int cpu;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +	/* Translate the zone_stat_item into a mem_cgroup_stat_index */
> +	switch (idx) {
> +	case NR_FILE_DIRTY:
> +		idx = MEM_CGROUP_STAT_FILE_DIRTY;
> +		break;
> +	case NR_WRITEBACK:
> +		idx = MEM_CGROUP_STAT_WRITEBACK;
> +		break;
> +	case NR_WRITEBACK_TEMP:
> +		idx = MEM_CGROUP_STAT_WRITEBACK_TEMP;
> +		break;
> +	case NR_UNSTABLE_NFS:
> +		idx = MEM_CGROUP_STAT_UNSTABLE_NFS;
> +		break;
> +	default:
> +		return;
> +	}
> +	/* Charge the memory cgroup statistics */
> +	mem = get_mem_cgroup_from_page(page);
> +	if (!mem) {
> +		mem = root_mem_cgroup;
> +		css_get(&mem->css);
> +	}
> +
> +	local_irq_save(flags);
> +	cpu = get_cpu();
> +	cpustat = &mem->stat.cpustat[cpu];
> +	__mem_cgroup_stat_add_safe(cpustat, idx, charge);
> +	put_cpu();
> +	local_irq_restore(flags);
> +	css_put(&mem->css);
> +}
> +

We seem to be doing same operation as existing "mem_cgroup_update_file_mapped"
function is doing to udpate some stats. Can we just reuse that? We
probably can create one core function which take index of stat to update
and update_file_mapped and other variants for memcg dirty ratio can make
use of it.

In fact instead of single function charge_dirty() accounting for
WRITEBACK, we well as other states like UNSTABLE_NFS is not very intutive.
May be we can have indivdual functions.

mem_cgroup_update_dirty()
mem_cgroup_update_writeback()
mem_cgroup_update_unstable_nfs() etc.

Thanks
Vivek
