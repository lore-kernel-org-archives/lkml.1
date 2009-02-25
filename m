Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZBYHJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZBYHJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 02:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBYHJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 02:09:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60726 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751736AbZBYHJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 02:09:10 -0500
Message-ID: <49A4EEA0.3010309@cn.fujitsu.com>
Date: Wed, 25 Feb 2009 15:09:20 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH] use CSS ID in swap_cgroup for saving memory
References: <20090225152617.df4eeb35.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090225152617.df4eeb35.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  static inline
> -struct mem_cgroup *swap_cgroup_record(swp_entry_t ent, struct mem_cgroup *mem)
> +unsigned short swap_cgroup_record(swp_entry_t ent, unsigned short id)
>  {
>  	return NULL;

return 0;

>  }
>  
>  static inline
> -struct mem_cgroup *lookup_swap_cgroup(swp_entry_t ent)
> +unsigned short lookup_swap_cgroup(swp_entry_t ent)
>  {
>  	return NULL;

return 0;

>  }

> @@ -1265,12 +1286,20 @@ int mem_cgroup_cache_charge(struct page 
>  
>  	if (do_swap_account && !ret && PageSwapCache(page)) {
>  		swp_entry_t ent = {.val = page_private(page)};
> +		unsigned short id;
>  		/* avoid double counting */
> -		mem = swap_cgroup_record(ent, NULL);
> +		id = swap_cgroup_record(ent, 0);
> +		rcu_read_lock();
> +		mem = mem_cgroup_lookup(id);
>  		if (mem) {
> +			/*
> +			 * Recorded ID can be obsolete. We avoid calling
> +			 * css_tryget()
> +			 */
>  			res_counter_uncharge(&mem->memsw, PAGE_SIZE);
>  			mem_cgroup_put(mem);
>  		}
> +		rcu_read_unlock();
>  	}
>  	return ret;
>  }
> @@ -1335,13 +1364,21 @@ void mem_cgroup_commit_charge_swapin(str
>  	 */
>  	if (do_swap_account && PageSwapCache(page)) {
>  		swp_entry_t ent = {.val = page_private(page)};
> +		unsigned short id;
>  		struct mem_cgroup *memcg;
> -		memcg = swap_cgroup_record(ent, NULL);
> +
> +		id = swap_cgroup_record(ent, 0);
> +		rcu_read_lock();
> +		memcg = mem_cgroup_lookup(id);
>  		if (memcg) {
> +			/*
> +			 * This recorded memcg can be obsolete one. So, avoid
> +			 * calling css_tryget
> +			 */
>  			res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
>  			mem_cgroup_put(memcg);
>  		}
> -
> +		rcu_read_unlock();
>  	}
>  	/* add this page(page_cgroup) to the LRU we want. */
>  
> @@ -1462,7 +1499,7 @@ void mem_cgroup_uncharge_swapcache(struc
>  					MEM_CGROUP_CHARGE_TYPE_SWAPOUT);
>  	/* record memcg information */
>  	if (do_swap_account && memcg) {
> -		swap_cgroup_record(ent, memcg);
> +		swap_cgroup_record(ent, css_id(&memcg->css));
>  		mem_cgroup_get(memcg);
>  	}
>  	if (memcg)
> @@ -1477,15 +1514,22 @@ void mem_cgroup_uncharge_swapcache(struc
>  void mem_cgroup_uncharge_swap(swp_entry_t ent)
>  {
>  	struct mem_cgroup *memcg;
> +	unsigned short id;
>  
>  	if (!do_swap_account)
>  		return;
>  
> -	memcg = swap_cgroup_record(ent, NULL);
> +	id = swap_cgroup_record(ent, 0);
> +	rcu_read_lock();
> +	memcg = mem_cgroup_lookup(id);
>  	if (memcg) {
> +		/*
> +		 * This memcg can be obsolete one. We avoid calling css_tryget
> +		 */
>  		res_counter_uncharge(&memcg->memsw, PAGE_SIZE);
>  		mem_cgroup_put(memcg);
>  	}
> +	rcu_read_unlock();

can we have a common function for the above 3 pieces of code?

>  }
>  #endif
>  
> Index: mmotm-2.6.29-Feb24/mm/page_cgroup.c
> ===================================================================
> --- mmotm-2.6.29-Feb24.orig/mm/page_cgroup.c
> +++ mmotm-2.6.29-Feb24/mm/page_cgroup.c
> @@ -290,7 +290,7 @@ struct swap_cgroup_ctrl swap_cgroup_ctrl
>   * cgroup rather than pointer.
>   */

this comment should be updated/removed:

/*
 * This 8bytes seems big..maybe we can reduce this when we can use "id" for
 * cgroup rather than pointer.
 */

>  struct swap_cgroup {
> -	struct mem_cgroup	*val;
> +	unsigned short		id;
>  };
>  #define SC_PER_PAGE	(PAGE_SIZE/sizeof(struct swap_cgroup))
>  #define SC_POS_MASK	(SC_PER_PAGE - 1)
