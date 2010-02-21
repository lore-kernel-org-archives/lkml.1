Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab0BUV24 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 16:28:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:51623 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752990Ab0BUV2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 16:28:54 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=A9IGRa12i8QUDM33K9IiWkxAtZnLS1VCfUlkU6aQR/dj0Jm0cCxkKR5x36jnAjgHB
	Vk000rm6GKjo0QwgU9GiA==
Date: Sun, 21 Feb 2010 13:28:35 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrea Righi <arighi@develer.com>
cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Suleiman Souhlal <suleiman@google.com>, Vivek Goyal <vgoyal@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] memcg: dirty pages accounting and limiting
 infrastructure
In-Reply-To: <1266765525-30890-2-git-send-email-arighi@develer.com>
Message-ID: <alpine.DEB.2.00.1002211321010.22858@chino.kir.corp.google.com>
References: <1266765525-30890-1-git-send-email-arighi@develer.com> <1266765525-30890-2-git-send-email-arighi@develer.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Feb 2010, Andrea Righi wrote:

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

Is it possible to merge this with try_get_mem_cgroup_from_page()?

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

WARN()?  We don't want to silently leak counters.

> +	}
> +	/* Charge the memory cgroup statistics */
> +	mem = get_mem_cgroup_from_page(page);
> +	if (!mem) {
> +		mem = root_mem_cgroup;
> +		css_get(&mem->css);
> +	}

get_mem_cgroup_from_page() should probably handle the root_mem_cgroup case 
and return a reference from it.

> +
> +	local_irq_save(flags);
> +	cpu = get_cpu();
> +	cpustat = &mem->stat.cpustat[cpu];
> +	__mem_cgroup_stat_add_safe(cpustat, idx, charge);

get_cpu()?  Preemption is already disabled, just use smp_processor_id().

> +	put_cpu();
> +	local_irq_restore(flags);
> +	css_put(&mem->css);
> +}
> +
>  static unsigned long mem_cgroup_get_local_zonestat(struct mem_cgroup *mem,
>  					enum lru_list idx)
>  {
> @@ -992,6 +1061,97 @@ static unsigned int get_swappiness(struct mem_cgroup *memcg)
>  	return swappiness;
>  }
>  
> +static unsigned long get_dirty_bytes(struct mem_cgroup *memcg)
> +{
> +	struct cgroup *cgrp = memcg->css.cgroup;
> +	unsigned long dirty_bytes;
> +
> +	/* root ? */
> +	if (cgrp->parent == NULL)
> +		return vm_dirty_bytes;
> +
> +	spin_lock(&memcg->reclaim_param_lock);
> +	dirty_bytes = memcg->dirty_bytes;
> +	spin_unlock(&memcg->reclaim_param_lock);
> +
> +	return dirty_bytes;
> +}
> +
> +unsigned long mem_cgroup_dirty_bytes(void)
> +{
> +	struct mem_cgroup *memcg;
> +	unsigned long dirty_bytes;
> +
> +	if (mem_cgroup_disabled())
> +		return vm_dirty_bytes;
> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(current);
> +	if (memcg == NULL)
> +		dirty_bytes = vm_dirty_bytes;
> +	else
> +		dirty_bytes = get_dirty_bytes(memcg);
> +	rcu_read_unlock();

The rcu_read_lock() isn't protecting anything here.

> +
> +	return dirty_bytes;
> +}
> +
> +u64 mem_cgroup_page_state(enum memcg_page_stat_item item)
> +{
> +	struct mem_cgroup *memcg;
> +	struct cgroup *cgrp;
> +	u64 ret = 0;
> +
> +	if (mem_cgroup_disabled())
> +		return 0;
> +
> +	rcu_read_lock();

Again, this isn't necessary.
