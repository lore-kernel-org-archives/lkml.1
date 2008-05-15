Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbYEOBoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbYEOBoT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 21:44:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750740AbYEOBoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 21:44:08 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52837 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750836AbYEOBoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 21:44:07 -0400
Message-ID: <482B950C.2060408@cn.fujitsu.com>
Date: Thu, 15 May 2008 09:42:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "xemul@openvz.org" <xemul@openvz.org>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       "hugh@veritas.com" <hugh@veritas.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC/PATCH 2/6] memcg: remove refcnt
References: <20080514170236.23c9ddd7.kamezawa.hiroyu@jp.fujitsu.com> <20080514170703.db2d9802.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20080514170703.db2d9802.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
> - * Uncharging is always a welcome operation, we never complain, simply
> - * uncharge.
> + * uncharge if !page_mapped(page)
>   */
> -void mem_cgroup_uncharge_page(struct page *page)
> +void __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)

static void ?

>  {
>  	struct page_cgroup *pc;
>  	struct mem_cgroup *mem;
> @@ -704,29 +693,41 @@ void mem_cgroup_uncharge_page(struct pag
>  		goto unlock;
>  

[..snip..]

> Index: linux-2.6.26-rc2/include/linux/memcontrol.h
> ===================================================================
> --- linux-2.6.26-rc2.orig/include/linux/memcontrol.h
> +++ linux-2.6.26-rc2/include/linux/memcontrol.h
> @@ -35,6 +35,8 @@ extern int mem_cgroup_charge(struct page
>  extern int mem_cgroup_cache_charge(struct page *page, struct mm_struct *mm,
>  					gfp_t gfp_mask);
>  extern void mem_cgroup_uncharge_page(struct page *page);
> +extern void mem_cgroup_uncharge_cache_page(struct page *page);
> +extern int mem_cgroup_shrink_usage(struct mm_struct *mm, gfp_t gfp_mask);

This function is defined and used in the 4th patch, so the declaration
should be moved to that patch.

>  extern void mem_cgroup_move_lists(struct page *page, bool active);
>  extern unsigned long mem_cgroup_isolate_pages(unsigned long nr_to_scan,
>  					struct list_head *dst,
> @@ -53,7 +55,6 @@ extern struct mem_cgroup *mem_cgroup_fro
>  extern int
>  mem_cgroup_prepare_migration(struct page *page, struct page *newpage);
>  extern void mem_cgroup_end_migration(struct page *page);
> -extern int mem_cgroup_getref(struct page *page);
>  
>  /*
>   * For memory reclaim.
> @@ -97,6 +98,14 @@ static inline int mem_cgroup_cache_charg
>  static inline void mem_cgroup_uncharge_page(struct page *page)
>  {
>  }

need a blank line here

> +static inline void mem_cgroup_uncharge_cache_page(struct page *page)
> +{
> +}
> +

[..snip..]

>  #ifdef CONFIG_DEBUG_VM
> Index: linux-2.6.26-rc2/mm/shmem.c
> ===================================================================
> --- linux-2.6.26-rc2.orig/mm/shmem.c
> +++ linux-2.6.26-rc2/mm/shmem.c
> @@ -961,13 +961,14 @@ found:
>  		shmem_swp_unmap(ptr);
>  	spin_unlock(&info->lock);
>  	radix_tree_preload_end();
> -uncharge:
> -	mem_cgroup_uncharge_page(page);
>  out:
>  	unlock_page(page);
>  	page_cache_release(page);
>  	iput(inode);		/* allows for NULL */
>  	return error;
> +uncharge:
> +	mem_cgroup_uncharge_cache_page(page);
> +	goto out;
>  }
>  

Seems the logic is changed here. is it intended ?
