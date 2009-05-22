Return-Path: <linux-kernel-owner+w=401wt.eu-S1751696AbZEVISI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751696AbZEVISI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:18:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751463AbZEVIR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:17:56 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55611 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZEVIRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:17:54 -0400
Date: Fri, 22 May 2009 17:16:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] memcg: remove some redundant checks
Message-Id: <20090522171618.6cea6dde.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A1645CC.8000600@cn.fujitsu.com>
References: <4A1645CC.8000600@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 14:27:24 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> We don't need to check do_swap_account in the case that the
> function which checks do_swap_account will never get called if
> do_swap_account == 0.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Exactly. thanks.
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

> ---
>  memcontrol.c  |   11 ++++-------
>  page_cgroup.c |    8 --------
>  2 files changed, 4 insertions(+), 15 deletions(-)
> 
> --- a/mm/memcontrol.c	2009-05-22 11:38:06.000000000 +0800
> +++ b/mm/memcontrol.c	2009-05-22 11:40:38.000000000 +0800
> @@ -45,7 +45,7 @@ struct cgroup_subsys mem_cgroup_subsys _
>  #define MEM_CGROUP_RECLAIM_RETRIES	5
>  
>  #ifdef CONFIG_CGROUP_MEM_RES_CTLR_SWAP
> -/* Turned on only when memory cgroup is enabled && really_do_swap_account = 0 */
> +/* Turned on only when memory cgroup is enabled && really_do_swap_account = 1 */
>  int do_swap_account __read_mostly;
>  static int really_do_swap_account __initdata = 1; /* for remember boot option*/
>  #else
> @@ -1771,16 +1771,14 @@ static int mem_cgroup_resize_limit(struc
>  	return ret;
>  }
>  
> -int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
> -				unsigned long long val)
> +static int mem_cgroup_resize_memsw_limit(struct mem_cgroup *memcg,
> +					unsigned long long val)
>  {
>  	int retry_count;
>  	u64 memlimit, oldusage, curusage;
>  	int children = mem_cgroup_count_children(memcg);
>  	int ret = -EBUSY;
>  
> -	if (!do_swap_account)
> -		return -EINVAL;
>  	/* see mem_cgroup_resize_res_limit */
>   	retry_count = children * MEM_CGROUP_RECLAIM_RETRIES;
>  	oldusage = res_counter_read_u64(&memcg->memsw, RES_USAGE);
> @@ -2015,8 +2013,7 @@ static u64 mem_cgroup_read(struct cgroup
>  		val = res_counter_read_u64(&mem->res, name);
>  		break;
>  	case _MEMSWAP:
> -		if (do_swap_account)
> -			val = res_counter_read_u64(&mem->memsw, name);
> +		val = res_counter_read_u64(&mem->memsw, name);
>  		break;
>  	default:
>  		BUG();
> --- a/mm/page_cgroup.c	2009-05-22 11:41:35.000000000 +0800
> +++ b/mm/page_cgroup.c	2009-05-22 11:44:13.000000000 +0800
> @@ -316,8 +316,6 @@ static int swap_cgroup_prepare(int type)
>  	struct swap_cgroup_ctrl *ctrl;
>  	unsigned long idx, max;
>  
> -	if (!do_swap_account)
> -		return 0;
>  	ctrl = &swap_cgroup_ctrl[type];
>  
>  	for (idx = 0; idx < ctrl->length; idx++) {
> @@ -354,9 +352,6 @@ unsigned short swap_cgroup_record(swp_en
>  	struct swap_cgroup *sc;
>  	unsigned short old;
>  
> -	if (!do_swap_account)
> -		return 0;
> -
>  	ctrl = &swap_cgroup_ctrl[type];
>  
>  	mappage = ctrl->map[idx];
> @@ -385,9 +380,6 @@ unsigned short lookup_swap_cgroup(swp_en
>  	struct swap_cgroup *sc;
>  	unsigned short ret;
>  
> -	if (!do_swap_account)
> -		return 0;
> -
>  	ctrl = &swap_cgroup_ctrl[type];
>  	mappage = ctrl->map[idx];
>  	sc = page_address(mappage);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

