Return-Path: <linux-kernel-owner+w=401wt.eu-S1758517AbYLENyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758517AbYLENyx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 08:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYLENyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 08:54:45 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:49982 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbYLENyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 08:54:44 -0500
Date: Fri, 5 Dec 2008 19:24:53 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>
Subject: Re: [RFC][PATCH -mmotm 4/4] memcg: change try_to_free_pages to
	hierarchical_reclaim
Message-ID: <20081205135453.GC10004@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
	LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
	Paul Menage <menage@google.com>
References: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp> <20081205212529.8d895526.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081205212529.8d895526.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2008-12-05 21:25:29]:

> mem_cgroup_hierarchicl_reclaim() works properly even when !use_hierarchy now,
> so, instead of try_to_free_mem_cgroup_pages(), it should be used in many cases.
>

Yes, that was by design. The design is such that use_hierarchy is set
for all children when the parent has it set and the resource counters
are also linked, such that the charge propagates to the root of the
current hierarchy and not any further.
 
> The only exception is force_empty. The group has no children in this case.
> 
> 
> Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> ---
>  mm/memcontrol.c |   12 ++++--------
>  1 files changed, 4 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index ab04725..c0b4f37 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -1399,8 +1399,7 @@ int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask)
>  	rcu_read_unlock();
> 
>  	do {
> -		progress = try_to_free_mem_cgroup_pages(mem, gfp_mask, true,
> -							get_swappiness(mem));
> +		progress = mem_cgroup_hierarchical_reclaim(mem, gfp_mask, true);
>  		progress += mem_cgroup_check_under_limit(mem);
>  	} while (!progress && --retry);
> 
> @@ -1467,10 +1466,8 @@ static int mem_cgroup_resize_limit(struct mem_cgroup *memcg,
>  		if (!ret)
>  			break;
> 
> -		progress = try_to_free_mem_cgroup_pages(memcg,
> -							GFP_KERNEL,
> -							false,
> -							get_swappiness(memcg));
> +		progress = mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL,
> +							   false);
>    		if (!progress)			retry_count--;
>  	}
> 
> @@ -1514,8 +1511,7 @@ int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
>  			break;
> 
>  		oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
> -		try_to_free_mem_cgroup_pages(memcg, GFP_KERNEL, true,
> -					     get_swappiness(memcg));
> +		mem_cgroup_hierarchical_reclaim(memcg, GFP_KERNEL, true);
>  		curusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
>  		if (curusage >= oldusage)
>  			retry_count--;
> 

Looks good to me

Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

-- 
	Balbir
