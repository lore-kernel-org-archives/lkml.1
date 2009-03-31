Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbZCaIUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbZCaIUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 04:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZCaIUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 04:20:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58156 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZCaIUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 04:20:14 -0400
Date: Tue, 31 Mar 2009 17:18:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC][PATCH 5/8] memcg soft limit (yet another new design) v1
Message-Id: <20090331171840.83fb7dab.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090327140923.7dbbf677.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090327135933.789729cb.kamezawa.hiroyu@jp.fujitsu.com>
	<20090327140923.7dbbf677.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Mar 2009 14:09:23 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> memcg's reclaim routine is designed to ignore locality andplacements and
> then, inactive_anon_is_low() function doesn't take "zone" as its argument.
> 
> In later soft limit patch, we use "zone" as an arguments.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> ---
> Index: mmotm-2.6.29-Mar23/mm/memcontrol.c
> ===================================================================
> --- mmotm-2.6.29-Mar23.orig/mm/memcontrol.c
> +++ mmotm-2.6.29-Mar23/mm/memcontrol.c
> @@ -561,15 +561,28 @@ void mem_cgroup_record_reclaim_priority(
>  	spin_unlock(&mem->reclaim_param_lock);
>  }
>  
> -static int calc_inactive_ratio(struct mem_cgroup *memcg, unsigned long *present_pages)
> +static int calc_inactive_ratio(struct mem_cgroup *memcg,
> +			       unsigned long *present_pages,
> +			       struct zone *z)
>  {
>  	unsigned long active;
>  	unsigned long inactive;
>  	unsigned long gb;
>  	unsigned long inactive_ratio;
>  
> -	inactive = mem_cgroup_get_local_zonestat(memcg, LRU_INACTIVE_ANON);
> -	active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_ANON);
> +	if (!z) {
> +		inactive = mem_cgroup_get_local_zonestat(memcg,
> +							 LRU_INACTIVE_ANON);
> +		active = mem_cgroup_get_local_zonestat(memcg, LRU_ACTIVE_ANON);
> +	} else {
> +		int nid = z->zone_pgdat->node_id;
> +		int zid = zone_idx(z);
> +		struct mem_cgroup_per_zone *mz;
> +
> +		mz = mem_cgroup_zoneinfo(memcg, nid, zid);
> +		inactive = MEM_CGROUP_ZSTAT(mz, LRU_INACTIVE_ANON);
> +		active = MEM_CGROUP_ZSTAT(mz, LRU_ACTIVE_ANON);
> +	}
>  
>  	gb = (inactive + active) >> (30 - PAGE_SHIFT);
>  	if (gb)
> @@ -585,14 +598,14 @@ static int calc_inactive_ratio(struct me
>  	return inactive_ratio;
>  }
>  
> -int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg)
> +int mem_cgroup_inactive_anon_is_low(struct mem_cgroup *memcg, struct zone *z)
>  {
>  	unsigned long active;
>  	unsigned long inactive;
>  	unsigned long present_pages[2];
>  	unsigned long inactive_ratio;
>  
> -	inactive_ratio = calc_inactive_ratio(memcg, present_pages);
> +	inactive_ratio = calc_inactive_ratio(memcg, present_pages, NULL);

The last arguments should be "z" not NULL...

seems posted version is a bit old...OMG, sorry.

I'm now adding bugfix etc..

-Kame

