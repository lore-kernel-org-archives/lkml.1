Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbZAHLUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbZAHLUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 06:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZAHLTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 06:19:53 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35017 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977AbZAHLTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 06:19:52 -0500
Message-ID: <44480.10.75.179.62.1231413588.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090108191520.df9c1d92.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
    <20090108191520.df9c1d92.nishimura@mxp.nes.nec.co.jp>
Date: Thu, 8 Jan 2009 20:19:48 +0900 (JST)
Subject: Re: [RFC][PATCH 4/4] memcg: make oom less frequently
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: "Daisuke Nishimura" <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       kamezawa.hiroyu@jp.fujitsu.com, balbir@linux.vnet.ibm.com,
       lizf@cn.fujitsu.com, menage@google.com, nishimura@mxp.nes.nec.co.jp
User-Agent: SquirrelMail/1.4.3a
X-Mailer: SquirrelMail/1.4.3a
MIME-Version: 1.0
Content-Type: text/plain;charset=us-ascii
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura said:
> In previous implementation, mem_cgroup_try_charge checked the return
> value of mem_cgroup_try_to_free_pages, and just retried if some pages
> had been reclaimed.
> But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
> only checks whether the usage is less than the limit.
>
> This patch tries to change the behavior as before to cause oom less
> frequently.
>
> To prevent try_charge from getting stuck in infinite loop,
> MEM_CGROUP_RECLAIM_RETRIES_MAX is defined.
>
>
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

I think this is necessary change.
My version of hierarchy reclaim will do this.

But RETRIES_MAX is not clear ;) please use one counter.

And why MAX=32 ?
> +		if (ret)
> +			continue;
seems to do enough work.

While memory can be reclaimed, it's not dead lock.
To handle live-lock situation as "reclaimed memory is stolen very soon",
should we check signal_pending(current) or some flags ?

IMHO, using jiffies to detect how long we should retry is easy to understand
....like
 "if memory charging cannot make progress for XXXX minutes,
  trigger some notifier or show some flag to user via cgroupfs interface.
  to show we're tooooooo busy."

-Kame


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
>
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
>  /* Turned on only when memory cgroup is enabled && really_do_swap_account
> = 0 */
> @@ -770,10 +771,10 @@ static int mem_cgroup_hierarchical_reclaim(struct
> mem_cgroup *root_mem,
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
> @@ -785,10 +786,10 @@ static int mem_cgroup_hierarchical_reclaim(struct
> mem_cgroup *root_mem,
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
> @@ -820,6 +821,7 @@ static int __mem_cgroup_try_charge(struct mm_struct
> *mm,
>  {
>  	struct mem_cgroup *mem, *mem_over_limit;
>  	int nr_retries = MEM_CGROUP_RECLAIM_RETRIES;
> +	int nr_retries_max = MEM_CGROUP_RECLAIM_RETRIES_MAX;
>  	struct res_counter *fail_res;
>
>  	if (unlikely(test_thread_flag(TIF_MEMDIE))) {
> @@ -871,8 +873,13 @@ static int __mem_cgroup_try_charge(struct mm_struct
> *mm,
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
> @@ -886,6 +893,7 @@ static int __mem_cgroup_try_charge(struct mm_struct
> *mm,
>  			continue;
>
>  		if (!nr_retries--) {
> +oom:
>  			if (oom) {
>  				mutex_lock(&memcg_tasklist);
>  				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


