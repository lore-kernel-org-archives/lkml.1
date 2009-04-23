Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZDWIrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZDWIrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 04:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZDWIqx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 04:46:53 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45820 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbZDWIqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 04:46:52 -0400
Date: Thu, 23 Apr 2009 17:45:16 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "hugh@veritas.com" <hugh@veritas.com>
Subject: Re: [RFC][PATCH] fix swap entries is not reclaimed in proper way
 for mem+swap controller
Message-Id: <20090423174516.31e75286.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090423131438.062cfb13.nishimura@mxp.nes.nec.co.jp>
References: <20090421162121.1a1d15fe.kamezawa.hiroyu@jp.fujitsu.com>
	<20090422143833.2e11e10b.nishimura@mxp.nes.nec.co.jp>
	<20090423131438.062cfb13.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009 13:14:37 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > I'll dig and try more including another aproach..
> > 
> How about this patch ?
> 
> It seems to have been working fine for several hours.
> I should add more and more comments and clean it up, of course :)
> (I think it would be better to unify definitions of new functions to swapfile.c,
> and checking page_mapped() might be enough for mem_cgroup_free_unused_swapcache().)
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Hmm, I still think this patch is overkill. 



> ---
>  include/linux/memcontrol.h |    5 +++
>  include/linux/swap.h       |   11 ++++++++
>  mm/memcontrol.c            |   62 ++++++++++++++++++++++++++++++++++++++++++++
>  mm/swap_state.c            |    8 +++++
>  mm/swapfile.c              |   32 ++++++++++++++++++++++-
>  mm/vmscan.c                |    8 +++++
>  6 files changed, 125 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 25b9ca9..8b674c2 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -101,6 +101,7 @@ struct zone_reclaim_stat *mem_cgroup_get_reclaim_stat(struct mem_cgroup *memcg,
>  						      struct zone *zone);
>  struct zone_reclaim_stat*
>  mem_cgroup_get_reclaim_stat_from_page(struct page *page);
> +extern void mem_cgroup_free_unused_swapcache(struct page *page);
>  extern void mem_cgroup_print_oom_info(struct mem_cgroup *memcg,
>  					struct task_struct *p);
>  
> @@ -259,6 +260,10 @@ mem_cgroup_get_reclaim_stat_from_page(struct page *page)
>  	return NULL;
>  }
>  
> +static inline void mem_cgroup_free_unused_swapcache(struct page *page)
> +{
> +}
> +
>  static inline void
>  mem_cgroup_print_oom_info(struct mem_cgroup *memcg, struct task_struct *p)
>  {
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 62d8143..cdfa982 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -336,11 +336,22 @@ static inline void disable_swap_token(void)
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR
>  extern void mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent);
> +extern int mem_cgroup_fixup_swapin(struct page *page);
> +extern void mem_cgroup_fixup_swapfree(struct page *page);
>  #else
>  static inline void
>  mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
>  {
>  }
> +static inline int
> +mem_cgroup_fixup_swapin(struct page *page)
> +{
> +	return 0;
> +}
> +static inline void
> +mem_cgroup_fixup_swapfree(struct page *page)
> +{
> +}
>  #endif
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  extern void mem_cgroup_uncharge_swap(swp_entry_t ent);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 79c32b8..f90967b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1536,6 +1536,68 @@ void mem_cgroup_uncharge_swap(swp_entry_t ent)
>  }
>  #endif
>  
> +struct mem_cgroup_swap_fixup_work {
> +	struct work_struct work;
> +	struct page *page;
> +};
> +
> +static void mem_cgroup_fixup_swapfree_cb(struct work_struct *work)
> +{
> +	struct mem_cgroup_swap_fixup_work *my_work;
> +	struct page *page;
> +
> +	my_work = container_of(work, struct mem_cgroup_swap_fixup_work, work);
> +	page = my_work->page;
> +
> +	lock_page(page);
> +	if (PageSwapCache(page))
> +		mem_cgroup_free_unused_swapcache(page);
> +	unlock_page(page);
> +
> +	kfree(my_work);
> +	put_page(page);
> +}
> +
> +void mem_cgroup_fixup_swapfree(struct page *page)
> +{
> +	struct mem_cgroup_swap_fixup_work *my_work;
> +
> +	if (mem_cgroup_disabled())
> +		return;
> +
> +	if (!PageSwapCache(page) || page_mapped(page))
> +		return;
> +
> +	my_work = kmalloc(sizeof(*my_work), GFP_ATOMIC); /* cannot sleep */
> +	if (my_work) {
> +		get_page(page);	/* put_page will be called in callback */
> +		my_work->page = page;
> +		INIT_WORK(&my_work->work, mem_cgroup_fixup_swapfree_cb);
> +		schedule_work(&my_work->work);
> +	}
> +
> +	return;
> +}
> +
> +/*
> + * called from shrink_page_list() and mem_cgroup_fixup_swapfree_cb() to free
> + * !PageCgroupUsed SwapCache, because memcg cannot handle these SwapCache well.
> + */
> +void mem_cgroup_free_unused_swapcache(struct page *page)
> +{
> +		struct page_cgroup *pc;
> +
> +		VM_BUG_ON(!PageLocked(page));
> +		VM_BUG_ON(!PageSwapCache(page));
> +
> +		pc = lookup_page_cgroup(page);
> +		/*
> +		 * Used bit of swapcache is solid under page lock.
> +		 */
> +		if (!PageCgroupUsed(pc))
> +			try_to_free_swap(page);
> +}
> +
>  /*
>   * Before starting migration, account PAGE_SIZE to mem_cgroup that the old
>   * page belongs to.
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 3ecea98..57d9678 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -310,6 +310,14 @@ struct page *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
>  		SetPageSwapBacked(new_page);
>  		err = add_to_swap_cache(new_page, entry, gfp_mask & GFP_KERNEL);
>  		if (likely(!err)) {
> +			if (unlikely(mem_cgroup_fixup_swapin(new_page)))
> +				/*
> +				 * new_page is not used by anyone.
> +				 * And it has been already removed from
> +				 * SwapCache and freed.
> +				 */
> +				return NULL;
> +

Can't we check refcnt of swp_entry here, again ?
if (refcnt == 1), we can make this as STALE.
(and can free swap cache here)


Thanks,
-Kame

