Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbZFOIWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbZFOIWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 04:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbZFOIVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 04:21:55 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45577 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758274AbZFOIVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 04:21:53 -0400
Date: Mon, 15 Jun 2009 17:20:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyuki@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Low overhead patches for the memory cgroup controller (v5)
Message-Id: <20090615172021.ab1a8a7a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090615043900.GF23577@balbir.in.ibm.com>
References: <20090615043900.GF23577@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Jun 2009 10:09:00 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> 
> Feature: Remove the overhead associated with the root cgroup
> 
> From: Balbir Singh <balbir@linux.vnet.ibm.com>
> 
> Changelog v5 -> v4
> 1. Moved back to v3 logic (Daisuke and Kamezawa like that better)
> 2. Incorporated changes from Daisuke (remove list_empty() checks)
> 3. Updated documentation to reflect that limits cannot be set on root
>    cgroup
> 
> Changelog v4 -> v3
> 1. Rebase to mmotm 9th june 2009
> 2. Remove PageCgroupRoot, we have account LRU flags to indicate that
>    we do only accounting and no reclaim.
> 3. pcg_default_flags has been used again, since PCGF_ROOT is gone,
>    we set PCGF_ACCT_LRU only in mem_cgroup_add_lru_list
> 4. More LRU functions are aware of PageCgroupAcctLRU
> 
> Changelog v3 -> v2
> 
> 1. Rebase to mmotm 2nd June 2009
> 2. Test with some of the test cases recommended by Daisuke-San
> 
> Changelog v2 -> v1
> 1. Rebase to latest mmotm
> 
> This patch changes the memory cgroup and removes the overhead associated
> with accounting all pages in the root cgroup. As a side-effect, we can
> no longer set a memory hard limit in the root cgroup.
> 
> A new flag to track whether the page has been accounted or not
> has been added as well. Flags are now set atomically for page_cgroup,
> pcg_default_flags is now obsolete and removed.
> 
> Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

Seems fine.
  Reviewd-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

But we'll have to do heavy test whether we see BUG_ON or not..

Regards,
-Kame

> ---
> 
>  Documentation/cgroups/memory.txt |    4 +++
>  include/linux/page_cgroup.h      |   13 +++++++++
>  mm/memcontrol.c                  |   54 ++++++++++++++++++++++++++++----------
>  3 files changed, 57 insertions(+), 14 deletions(-)
> 
> 
> diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> index 23d1262..9ce27c6 100644
> --- a/Documentation/cgroups/memory.txt
> +++ b/Documentation/cgroups/memory.txt
> @@ -179,6 +179,9 @@ The reclaim algorithm has not been modified for cgroups, except that
>  pages that are selected for reclaiming come from the per cgroup LRU
>  list.
>  
> +NOTE: Reclaim does not works for the root cgroup, since we cannot
> +set any limits on the root cgroup
> +
>  2. Locking
>  
>  The memory controller uses the following hierarchy
> @@ -210,6 +213,7 @@ We can alter the memory limit:
>  NOTE: We can use a suffix (k, K, m, M, g or G) to indicate values in kilo,
>  mega or gigabytes.
>  NOTE: We can write "-1" to reset the *.limit_in_bytes(unlimited).
> +NOTE: We cannot set limits on the root cgroup anymore.
>  
>  # cat /cgroups/0/memory.limit_in_bytes
>  4194304
> diff --git a/include/linux/page_cgroup.h b/include/linux/page_cgroup.h
> index 7339c7b..debd8ba 100644
> --- a/include/linux/page_cgroup.h
> +++ b/include/linux/page_cgroup.h
> @@ -26,6 +26,7 @@ enum {
>  	PCG_LOCK,  /* page cgroup is locked */
>  	PCG_CACHE, /* charged as cache */
>  	PCG_USED, /* this object is in use. */
> +	PCG_ACCT_LRU, /* page has been accounted for */
>  };
>  
>  #define TESTPCGFLAG(uname, lname)			\
> @@ -40,11 +41,23 @@ static inline void SetPageCgroup##uname(struct page_cgroup *pc)\
>  static inline void ClearPageCgroup##uname(struct page_cgroup *pc)	\
>  	{ clear_bit(PCG_##lname, &pc->flags);  }
>  
> +#define TESTCLEARPCGFLAG(uname, lname)			\
> +static inline int TestClearPageCgroup##uname(struct page_cgroup *pc)	\
> +	{ return test_and_clear_bit(PCG_##lname, &pc->flags);  }
> +
>  /* Cache flag is set only once (at allocation) */
>  TESTPCGFLAG(Cache, CACHE)
> +CLEARPCGFLAG(Cache, CACHE)
> +SETPCGFLAG(Cache, CACHE)
>  
>  TESTPCGFLAG(Used, USED)
>  CLEARPCGFLAG(Used, USED)
> +SETPCGFLAG(Used, USED)
> +
> +SETPCGFLAG(AcctLRU, ACCT_LRU)
> +CLEARPCGFLAG(AcctLRU, ACCT_LRU)
> +TESTPCGFLAG(AcctLRU, ACCT_LRU)
> +TESTCLEARPCGFLAG(AcctLRU, ACCT_LRU)
>  
>  static inline int page_cgroup_nid(struct page_cgroup *pc)
>  {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6ceb6f2..bcbbd89 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -43,6 +43,7 @@
>  
>  struct cgroup_subsys mem_cgroup_subsys __read_mostly;
>  #define MEM_CGROUP_RECLAIM_RETRIES	5
> +struct mem_cgroup *root_mem_cgroup __read_mostly;
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  /* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
> @@ -200,13 +201,8 @@ enum charge_type {
>  #define PCGF_CACHE	(1UL << PCG_CACHE)
>  #define PCGF_USED	(1UL << PCG_USED)
>  #define PCGF_LOCK	(1UL << PCG_LOCK)
> -static const unsigned long
> -pcg_default_flags[NR_CHARGE_TYPE] = {
> -	PCGF_CACHE | PCGF_USED | PCGF_LOCK, /* File Cache */
> -	PCGF_USED | PCGF_LOCK, /* Anon */
> -	PCGF_CACHE | PCGF_USED | PCGF_LOCK, /* Shmem */
> -	0, /* FORCE */
> -};
> +/* Not used, but added here for completeness */
> +#define PCGF_ACCT	(1UL << PCG_ACCT)
>  
>  /* for encoding cft->private value on file */
>  #define _MEM			(0)
> @@ -354,6 +350,11 @@ static int mem_cgroup_walk_tree(struct mem_cgroup *root, void *data,
>  	return ret;
>  }
>  
> +static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
> +{
> +	return (mem == root_mem_cgroup);
> +}
> +
>  /*
>   * Following LRU functions are allowed to be used without PCG_LOCK.
>   * Operations are called by routine of global LRU independently from memcg.
> @@ -371,22 +372,24 @@ static int mem_cgroup_walk_tree(struct mem_cgroup *root, void *data,
>  void mem_cgroup_del_lru_list(struct page *page, enum lru_list lru)
>  {
>  	struct page_cgroup *pc;
> -	struct mem_cgroup *mem;
>  	struct mem_cgroup_per_zone *mz;
>  
>  	if (mem_cgroup_disabled())
>  		return;
>  	pc = lookup_page_cgroup(page);
>  	/* can happen while we handle swapcache. */
> -	if (list_empty(&pc->lru) || !pc->mem_cgroup)
> +	if (!TestClearPageCgroupAcctLRU(pc))
>  		return;
> +	VM_BUG_ON(!pc->mem_cgroup);
>  	/*
>  	 * We don't check PCG_USED bit. It's cleared when the "page" is finally
>  	 * removed from global LRU.
>  	 */
>  	mz = page_cgroup_zoneinfo(pc);
> -	mem = pc->mem_cgroup;
>  	MEM_CGROUP_ZSTAT(mz, lru) -= 1;
> +	if (mem_cgroup_is_root(pc->mem_cgroup))
> +		return;
> +	VM_BUG_ON(list_empty(&pc->lru));
>  	list_del_init(&pc->lru);
>  	return;
>  }
> @@ -410,8 +413,8 @@ void mem_cgroup_rotate_lru_list(struct page *page, enum lru_list lru)
>  	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
>  	 */
>  	smp_rmb();
> -	/* unused page is not rotated. */
> -	if (!PageCgroupUsed(pc))
> +	/* unused or root page is not rotated. */
> +	if (!PageCgroupUsed(pc) || PageCgroupAcctLRU(pc))
>  		return;
>  	mz = page_cgroup_zoneinfo(pc);
>  	list_move(&pc->lru, &mz->lists[lru]);
> @@ -425,6 +428,7 @@ void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
>  	if (mem_cgroup_disabled())
>  		return;
>  	pc = lookup_page_cgroup(page);
> +	VM_BUG_ON(PageCgroupAcctLRU(pc));
>  	/*
>  	 * Used bit is set without atomic ops but after smp_wmb().
>  	 * For making pc->mem_cgroup visible, insert smp_rmb() here.
> @@ -435,6 +439,9 @@ void mem_cgroup_add_lru_list(struct page *page, enum lru_list lru)
>  
>  	mz = page_cgroup_zoneinfo(pc);
>  	MEM_CGROUP_ZSTAT(mz, lru) += 1;
> +	SetPageCgroupAcctLRU(pc);
> +	if (mem_cgroup_is_root(pc->mem_cgroup))
> +		return;
>  	list_add(&pc->lru, &mz->lists[lru]);
>  }
>  
> @@ -469,7 +476,7 @@ static void mem_cgroup_lru_add_after_commit_swapcache(struct page *page)
>  
>  	spin_lock_irqsave(&zone->lru_lock, flags);
>  	/* link when the page is linked to LRU but page_cgroup isn't */
> -	if (PageLRU(page) && list_empty(&pc->lru))
> +	if (PageLRU(page) && !PageCgroupAcctLRU(pc))
>  		mem_cgroup_add_lru_list(page, page_lru(page));
>  	spin_unlock_irqrestore(&zone->lru_lock, flags);
>  }
> @@ -1114,9 +1121,22 @@ static void __mem_cgroup_commit_charge(struct mem_cgroup *mem,
>  		css_put(&mem->css);
>  		return;
>  	}
> +
>  	pc->mem_cgroup = mem;
>  	smp_wmb();
> -	pc->flags = pcg_default_flags[ctype];
> +	switch (ctype) {
> +	case MEM_CGROUP_CHARGE_TYPE_CACHE:
> +	case MEM_CGROUP_CHARGE_TYPE_SHMEM:
> +		SetPageCgroupCache(pc);
> +		SetPageCgroupUsed(pc);
> +		break;
> +	case MEM_CGROUP_CHARGE_TYPE_MAPPED:
> +		ClearPageCgroupCache(pc);
> +		SetPageCgroupUsed(pc);
> +		break;
> +	default:
> +		break;
> +	}
>  
>  	mem_cgroup_charge_statistics(mem, pc, true);
>  
> @@ -2055,6 +2075,10 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
>  	name = MEMFILE_ATTR(cft->private);
>  	switch (name) {
>  	case RES_LIMIT:
> +		if (mem_cgroup_is_root(memcg)) { /* Can't set limit on root */
> +			ret = -EINVAL;
> +			break;
> +		}
>  		/* This function does all necessary parse...reuse it */
>  		ret = res_counter_memparse_write_strategy(buffer, &val);
>  		if (ret)
> @@ -2521,6 +2545,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  	if (cont->parent == NULL) {
>  		enable_swap_cgroup();
>  		parent = NULL;
> +		root_mem_cgroup = mem;
>  	} else {
>  		parent = mem_cgroup_from_cont(cont->parent);
>  		mem->use_hierarchy = parent->use_hierarchy;
> @@ -2549,6 +2574,7 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
>  	return &mem->css;
>  free_out:
>  	__mem_cgroup_free(mem);
> +	root_mem_cgroup = NULL;
>  	return ERR_PTR(error);
>  }
>  
> 
> -- 
> 	Balbir
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

