Return-Path: <linux-kernel-owner+w=401wt.eu-S1753467AbYF3CUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467AbYF3CUz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750850AbYF3CUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:20:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35307 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815AbYF3CUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:20:47 -0400
Date: Mon, 30 Jun 2008 11:26:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@in.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: further checking of disabled flag
Message-Id: <20080630112608.94fe4762.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <Pine.LNX.4.64.0806290115440.20280@blonde.site>
References: <Pine.LNX.4.64.0806290108110.20280@blonde.site>
	<Pine.LNX.4.64.0806290115440.20280@blonde.site>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jun 2008 01:17:17 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> Further adjustments to the mem_cgroup_subsys.disabled tests: add one to
> mem_cgroup_shrink_usage; move mem_cgroup_charge_common's into its callers,
> before they've done any work; and add one to mem_cgroup_move_lists, to
> avoid the overhead of its bit spin locking and unlocking.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

seems better

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


> ---
> Should follow mmotm's memcg-clean-up-checking-of-the-disabled-flag.patch
> 
>  mm/memcontrol.c |   15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)
> 
> --- mmotm/mm/memcontrol.c	2008-06-27 13:39:20.000000000 +0100
> +++ linux/mm/memcontrol.c	2008-06-27 17:32:29.000000000 +0100
> @@ -354,6 +354,9 @@ void mem_cgroup_move_lists(struct page *
>  	struct mem_cgroup_per_zone *mz;
>  	unsigned long flags;
>  
> +	if (mem_cgroup_subsys.disabled)
> +		return;
> +
>  	/*
>  	 * We cannot lock_page_cgroup while holding zone's lru_lock,
>  	 * because other holders of lock_page_cgroup can be interrupted
> @@ -533,9 +536,6 @@ static int mem_cgroup_charge_common(stru
>  	unsigned long nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
>  	struct mem_cgroup_per_zone *mz;
>  
> -	if (mem_cgroup_subsys.disabled)
> -		return 0;
> -
>  	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
>  	if (unlikely(pc == NULL))
>  		goto err;
> @@ -620,6 +620,9 @@ err:
>  
>  int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
>  {
> +	if (mem_cgroup_subsys.disabled)
> +		return 0;
> +
>  	/*
>  	 * If already mapped, we don't have to account.
>  	 * If page cache, page->mapping has address_space.
> @@ -638,6 +641,9 @@ int mem_cgroup_charge(struct page *page,
>  int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  				gfp_t gfp_mask)
>  {
> +	if (mem_cgroup_subsys.disabled)
> +		return 0;
> +
>  	/*
>  	 * Corner case handling. This is called from add_to_page_cache()
>  	 * in usual. But some FS (shmem) precharges this page before calling it
> @@ -789,6 +795,9 @@ int mem_cgroup_shrink_usage(struct mm_st
>  	int progress = 0;
>  	int retry = MEM_CGROUP_RECLAIM_RETRIES;
>  
> +	if (mem_cgroup_subsys.disabled)
> +		return 0;
> +
>  	rcu_read_lock();
>  	mem = mem_cgroup_from_task(rcu_dereference(mm->owner));
>  	css_get(&mem->css);
> 

