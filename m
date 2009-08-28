Return-Path: <linux-kernel-owner+w=401wt.eu-S1751714AbZH1Ezg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbZH1Ezg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 00:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbZH1Ezf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 00:55:35 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:51809 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbZH1Ezf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 00:55:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Aug 2009 13:53:42 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
Message-Id: <20090828135342.276ac003.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
	<20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 13:24:38 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> In massive parallel enviroment, res_counter can be a performance bottleneck.
> This patch is a trial for reducing lock contention.
> One strong techinque to reduce lock contention is reducing calls by
> batching some amount of calls int one.
> 
> Considering charge/uncharge chatacteristic,
> 	- charge is done one by one via demand-paging.
> 	- uncharge is done by
> 		- in chunk at munmap, truncate, exit, execve...
> 		- one by one via vmscan/paging.
> 
> It seems we hace a chance to batched-uncharge.
> This patch is a base patch for batched uncharge. For avoiding
> scattering memcg's structure, this patch adds memcg batch uncharge
> information to the task. please see start/end usage in next patch.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
>  include/linux/memcontrol.h |   12 +++++++
>  include/linux/sched.h      |    7 ++++
>  mm/memcontrol.c            |   70 +++++++++++++++++++++++++++++++++++++++++----
>  3 files changed, 83 insertions(+), 6 deletions(-)
> 
> Index: mmotm-2.6.31-Aug27/include/linux/memcontrol.h
> ===================================================================
> --- mmotm-2.6.31-Aug27.orig/include/linux/memcontrol.h
> +++ mmotm-2.6.31-Aug27/include/linux/memcontrol.h
> @@ -54,6 +54,10 @@ extern void mem_cgroup_rotate_lru_list(s
>  extern void mem_cgroup_del_lru(struct page *page);
>  extern void mem_cgroup_move_lists(struct page *page,
>  				  enum lru_list from, enum lru_list to);
> +
> +extern void mem_cgroup_uncharge_batch_start(void);
> +extern void mem_cgroup_uncharge_batch_end(void);
> +
>  extern void mem_cgroup_uncharge_page(struct page *page);
>  extern void mem_cgroup_uncharge_cache_page(struct page *page);
>  extern int mem_cgroup_shmem_charge_fallback(struct page *page,
> @@ -151,6 +155,14 @@ static inline void mem_cgroup_cancel_cha
>  {
>  }
>  
> +static inline void mem_cgroup_uncharge_batch_start(void)
> +{
> +}
> +
> +static inline void mem_cgroup_uncharge_batch_start(void)
> +{
> +}
> +
>  static inline void mem_cgroup_uncharge_page(struct page *page)
>  {
>  }
> Index: mmotm-2.6.31-Aug27/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.31-Aug27.orig/mm/memcontrol.c
> +++ mmotm-2.6.31-Aug27/mm/memcontrol.c
> @@ -1837,7 +1837,35 @@ void mem_cgroup_cancel_charge_swapin(str
>  	css_put(&mem->css);
>  }
>  
> +static bool
> +__do_batch_uncharge(struct mem_cgroup *mem, const enum charge_type ctype)
> +{
> +	struct memcg_batch_info *batch = NULL;
> +	bool uncharge_memsw;
> +	/* If swapout, usage of swap doesn't decrease */
> +	if (do_swap_account && (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
> +		uncharge_memsw = false;
> +	else
> +		uncharge_memsw = true;
>  
> +	if (current->memcg_batch.do_batch) {
> +		batch = &current->memcg_batch;
> +		if (batch->memcg == NULL) {
> +			batch->memcg = mem;
> +			css_get(&mem->css);
> +		}
> +	}
> +	if (!batch || batch->memcg != mem) {
> +		res_counter_uncharge(&mem->res, PAGE_SIZE);
> +		if (uncharge_memsw)
> +			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
> +	} else {
> +		batch->pages += PAGE_SIZE;
> +		if (uncharge_memsw)
> +			batch->memsw += PAGE_SIZE;
> +	}
> +	return soft_limit_excess;
> +}
>  /*
>   * uncharge if !page_mapped(page)
>   */
> @@ -1886,12 +1914,8 @@ __mem_cgroup_uncharge_common(struct page
>  		break;
>  	}
>  
> -	if (!mem_cgroup_is_root(mem)) {
> -		res_counter_uncharge(&mem->res, PAGE_SIZE);
> -		if (do_swap_account &&
> -				(ctype != MEM_CGROUP_CHARGE_TYPE_SWAPOUT))
> -			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
> -	}
> +	if (!mem_cgroup_is_root(mem))
> +		__do_batch_uncharge(mem, ctype);
>  	if (ctype == MEM_CGROUP_CHARGE_TYPE_SWAPOUT)
>  		mem_cgroup_swap_statistics(mem, true);
>  	mem_cgroup_charge_statistics(mem, pc, false);
> @@ -1938,6 +1962,40 @@ void mem_cgroup_uncharge_cache_page(stru
>  	__mem_cgroup_uncharge_common(page, MEM_CGROUP_CHARGE_TYPE_CACHE);
>  }
>  
> +void mem_cgroup_uncharge_batch_start(void)
> +{
> +	VM_BUG_ON(current->memcg_batch.do_batch);
> +	/* avoid batch if killed by OOM */
> +	if (test_thread_flag(TIF_MEMDIE))
> +		return;
> +	current->memcg_batch.do_batch = 1;
> +	current->memcg_batch.memcg = NULL;
> +	current->memcg_batch.pages = 0;
> +	current->memcg_batch.memsw = 0;
> +}
> +
> +void mem_cgroup_uncharge_batch_end(void)
> +{
> +	struct mem_cgroup *mem;
> +
> +	if (!current->memcg_batch.do_batch)
> +		return;
> +
> +	current->memcg_batch.do_batch = 0;
> +
> +	mem = current->memcg_batch.memcg;
> +	if (!mem)
> +		return;
> +	if (current->memcg_batch.pages)
> +		res_counter_uncharge(&mem->res,
> +				     current->memcg_batch.pages, NULL);
> +	if (current->memcg_batch.memsw)
> +		res_counter_uncharge(&mem->memsw,
> +				     current->memcg_batch.memsw, NULL);

quilt refresh miss....above 2 NULL are unnecesary.

sorry,
-Kame

