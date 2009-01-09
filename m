Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZAIF6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZAIF6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbZAIF6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:58:09 -0500
Received: from E23SMTP06.au.ibm.com ([202.81.18.175]:35795 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbZAIF6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:58:08 -0500
Date: Fri, 9 Jan 2009 11:28:04 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [RFC][PATCH 4/4] memcg: make oom less frequently
Message-ID: <20090109055804.GF9737@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp> <20090108191520.df9c1d92.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090108191520.df9c1d92.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2009-01-08 19:15:20]:

> In previous implementation, mem_cgroup_try_charge checked the return
> value of mem_cgroup_try_to_free_pages, and just retried if some pages
> had been reclaimed.
> But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
> only checks whether the usage is less than the limit.
> 
> This patch tries to change the behavior as before to cause oom less frequently.
> 
> To prevent try_charge from getting stuck in infinite loop,
> MEM_CGROUP_RECLAIM_RETRIES_MAX is defined.
> 
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  mm/memcontrol.c |   16 ++++++++++++----
>  1 files changed, 12 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 804c054..fedd76b 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -42,6 +42,7 @@
> 
>  struct cgroup_subsys mem_cgroup_subsys __read_mostly;
>  #define MEM_CGROUP_RECLAIM_RETRIES	5
> +#define MEM_CGROUP_RECLAIM_RETRIES_MAX	32

Why 32 are you seeing frequent OOMs? I had 5 iterations to allow

1. pages to move to swap cache, which added back pressure to memcg in
the original implementation, since the pages came back
2. It look longer to move, recalim those pages.

Ideally 3 would suffice, but I added an additional 2 retries for
safety.

> 
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  /* Turned on only when memory cgroup is enabled && really_do_swap_account = 0 */
> @@ -770,10 +771,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  	 * but there might be left over accounting, even after children
>  	 * have left.
>  	 */
> -	ret = try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
> +	ret += try_to_free_mem_cgroup_pages(root_mem, gfp_mask, noswap,
>  					   get_swappiness(root_mem));
>  	if (mem_cgroup_check_under_limit(root_mem))
> -		return 0;
> +		return 1;	/* indicate reclaim has succeeded */
>  	if (!root_mem->use_hierarchy)
>  		return ret;
> 
> @@ -785,10 +786,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
>  			next_mem = mem_cgroup_get_next_node(root_mem);
>  			continue;
>  		}
> -		ret = try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
> +		ret += try_to_free_mem_cgroup_pages(next_mem, gfp_mask, noswap,
>  						   get_swappiness(next_mem));
>  		if (mem_cgroup_check_under_limit(root_mem))
> -			return 0;
> +			return 1;	/* indicate reclaim has succeeded */
>  		next_mem = mem_cgroup_get_next_node(root_mem);
>  	}
>  	return ret;
> @@ -820,6 +821,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  {
>  	struct mem_cgroup *mem, *mem_over_limit;
>  	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	int nr_retries_max = MEM_CGROUP_RECLAIM_RETRIES_MAX;
>  	struct res_counter *fail_res;
> 
>  	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
> @@ -871,8 +873,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  		if (!(gfp_mask & __GFP_WAIT))
>  			goto nomem;
> 
> +		if (!nr_retries_max--)
> +			goto oom;
> +
>  		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
>  							noswap);
> +		if (ret)
> +			continue;
> 
>  		/*
>  		 * try_to_free_mem_cgroup_pages() might not give us a full
> @@ -886,6 +893,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  			continue;
> 
>  		if (!nr_retries--) {
> +oom:
>  			if (oom) {
>  				mutex_lock(&memcg_tasklist);
>  				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);

-- 
	Balbir
