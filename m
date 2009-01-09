Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbZAICFT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbZAICFT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 21:05:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753086AbZAICFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 21:05:04 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35081 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbZAICFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 21:05:02 -0500
Date: Fri, 9 Jan 2009 11:03:58 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, menage@google.com
Subject: Re: [RFC][PATCH 4/4] memcg: make oom less frequently
Message-Id: <20090109110358.8a0d991a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090109104416.9bf4aab7.nishimura@mxp.nes.nec.co.jp>
References: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
	<20090108191520.df9c1d92.nishimura@mxp.nes.nec.co.jp>
	<44480.10.75.179.62.1231413588.squirrel@webmail-b.css.fujitsu.com>
	<20090109104416.9bf4aab7.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 10:44:16 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> > To handle live-lock situation as "reclaimed memory is stolen very soon",
> > should we check signal_pending(current) or some flags ?
> > 
> > IMHO, using jiffies to detect how long we should retry is easy to understand
> > ....like
> >  "if memory charging cannot make progress for XXXX minutes,
> >   trigger some notifier or show some flag to user via cgroupfs interface.
> >   to show we're tooooooo busy."
> > 
> Good Idea.
> 
> But I think it would be enough for now to check signal_pending(curren) and
> return -ENOMEM.
> 
> How about this one?

Hmm, looks much simpler.

> ===
> From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> In previous implementation, mem_cgroup_try_charge checked the return
> value of mem_cgroup_try_to_free_pages, and just retried if some pages
> had been reclaimed.
> But now, try_charge(and mem_cgroup_hierarchical_reclaim called from it)
> only checks whether the usage is less than the limit.
> 
> This patch tries to change the behavior as before to cause oom less frequently.
> 
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  mm/memcontrol.c |   14 ++++++++++----
>  1 files changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index dc38a0e..2ab0a5c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -770,10 +770,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
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
> @@ -784,10 +784,10 @@ static int mem_cgroup_hierarchical_reclaim(struct mem_cgroup *root_mem,
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
> @@ -870,8 +870,13 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  		if (!(gfp_mask & __GFP_WAIT))
>  			goto nomem;
>  
> +		if (signal_pending(current))
> +			goto oom;
> +

I think it's better to avoid to add this check *now*. and "signal is pending" 
doesn't mean oom situation.

Hmm..Maybe we can tell "please retry page fault again, it's too long latency in
memory reclaim and you received signal." in future.

IMHO, only quick path which we can add here now is
==
	if (test_thread_flag(TIG_MEMDIE)) { /* This thread is killed by OOM */
		*memcg = NULL;
		return 0;
	}
==
like this.

Anyway, please discuss this "quick exit path" in other patch and just remove 
siginal check.

Other part looks ok to me.

Thanks,
-Kame




>  		ret = mem_cgroup_hierarchical_reclaim(mem_over_limit, gfp_mask,
>  							noswap);
> +		if (ret)
> +			continue;
>  
>  		/*
>  		 * try_to_free_mem_cgroup_pages() might not give us a full
> @@ -885,6 +890,7 @@ static int __mem_cgroup_try_charge(struct mm_struct *mm,
>  			continue;
>  
>  		if (!nr_retries--) {
> +oom:
>  			if (oom) {
>  				mutex_lock(&memcg_tasklist);
>  				mem_cgroup_out_of_memory(mem_over_limit, gfp_mask);
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

