Return-Path: <linux-kernel-owner+w=401wt.eu-S935123AbYEIGIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935123AbYEIGIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764925AbYEIGIi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:08:38 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51078 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759582AbYEIGIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:08:37 -0400
Message-ID: <4823EA11.3060907@cn.fujitsu.com>
Date: Fri, 09 May 2008 14:07:13 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [PATCH] memcg: avoid unnecessary initialization
References: <20080509145941.f68e8f66.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080509145941.f68e8f66.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> An easy cut out from memcg: performance improvement patch set.
> Tested on: x86-64/linux-2.6.26-rc1-git6
> 
> Thanks,
> -Kame
> ==
> * remove over-killing initialization (in fast path)
> * makeing the condition for PAGE_CGROUP_FLAG_ACTIVE be more obvious.
> 
> Signed-off-by: KAMEAZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 

Yes we don't need to init or del_init pc->lru.

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

> ---
>  mm/memcontrol.c |   11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> Index: linux-2.6.26-rc1/mm/memcontrol.c
> ===================================================================
> --- linux-2.6.26-rc1.orig/mm/memcontrol.c
> +++ linux-2.6.26-rc1/mm/memcontrol.c
> @@ -296,7 +296,7 @@ static void __mem_cgroup_remove_list(str
>  		MEM_CGROUP_ZSTAT(mz, MEM_CGROUP_ZSTAT_INACTIVE) -= 1;
>  
>  	mem_cgroup_charge_statistics(pc->mem_cgroup, pc->flags, false);
> -	list_del_init(&pc->lru);
> +	list_del(&pc->lru);
>  }
>  
>  static void __mem_cgroup_add_list(struct mem_cgroup_per_zone *mz,
> @@ -559,7 +559,7 @@ retry:
>  	}
>  	unlock_page_cgroup(page);
>  
> -	pc = kmem_cache_zalloc(page_cgroup_cache, gfp_mask);
> +	pc = kmem_cache_alloc(page_cgroup_cache, gfp_mask);
>  	if (pc == NULL)
>  		goto err;
>  
> @@ -606,9 +606,14 @@ retry:
>  	pc->ref_cnt = 1;
>  	pc->mem_cgroup = mem;
>  	pc->page = page;
> -	pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
> +	/*
> +	 * If a page is accounted as a page cache, insert to inactive list.
> +	 * If anon, insert to active list.
> +	 */
>  	if (ctype == MEM_CGROUP_CHARGE_TYPE_CACHE)
>  		pc->flags = PAGE_CGROUP_FLAG_CACHE;
> +	else
> +		pc->flags = PAGE_CGROUP_FLAG_ACTIVE;
>  
>  	lock_page_cgroup(page);
>  	if (page_get_page_cgroup(page)) {
> 
> 
> 
