Return-Path: <linux-kernel-owner+w=401wt.eu-S932559AbZFLDJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559AbZFLDJQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 23:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932251AbZFLDJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 23:09:05 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44947 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbZFLDJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 23:09:04 -0400
Date: Fri, 12 Jun 2009 11:40:32 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, mel@csn.ul.ie,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [BUGFIX][PATCH] memcg fix lru rotation in isolate_pages v2
Message-Id: <20090612114032.a2942948.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090612102821.5dd33523.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090612102644.a3e7ad3a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090612102821.5dd33523.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009 10:28:21 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> This patch tries to fix memcg's lru rotation sanity...make memcg use
> the same logic as global LRU does.
> 
> Now, at __isolate_lru_page() retruns -EBUSY, the page is rotated to
> the tail of LRU in global LRU's isolate LRU pages. But in memcg,
> it's not handled. This makes memcg do the same behavior as global LRU
> and rotate LRU in the page is busy.
> 
> Changelog: v1->v2
>  - adjusted to new beas patch.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
Looks good to me.

	Reviewed-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>

> ---
> Index: lumpy-reclaim-trial/mm/vmscan.c
> ===================================================================
> --- lumpy-reclaim-trial.orig/mm/vmscan.c
> +++ lumpy-reclaim-trial/mm/vmscan.c
> @@ -844,7 +844,6 @@ int __isolate_lru_page(struct page *page
>  		 */
>  		ClearPageLRU(page);
>  		ret = 0;
> -		mem_cgroup_del_lru(page);
>  	}
>  
>  	return ret;
> @@ -892,12 +891,14 @@ static unsigned long isolate_lru_pages(u
>  		switch (__isolate_lru_page(page, mode, file)) {
>  		case 0:
>  			list_move(&page->lru, dst);
> +			mem_cgroup_del_lru(page);
>  			nr_taken++;
>  			break;
>  
>  		case -EBUSY:
>  			/* else it is being freed elsewhere */
>  			list_move(&page->lru, src);
> +			mem_cgroup_rotate_lru_list(page, page_lru(page));
>  			continue;
>  
>  		default:
> @@ -938,6 +939,7 @@ static unsigned long isolate_lru_pages(u
>  				continue;
>  			if (__isolate_lru_page(cursor_page, mode, file) == 0) {
>  				list_move(&cursor_page->lru, dst);
> +				mem_cgroup_del_lru(page);
>  				nr_taken++;
>  				scan++;
>  			}
> Index: lumpy-reclaim-trial/mm/memcontrol.c
> ===================================================================
> --- lumpy-reclaim-trial.orig/mm/memcontrol.c
> +++ lumpy-reclaim-trial/mm/memcontrol.c
> @@ -649,6 +649,7 @@ unsigned long mem_cgroup_isolate_pages(u
>  	int zid = zone_idx(z);
>  	struct mem_cgroup_per_zone *mz;
>  	int lru = LRU_FILE * !!file + !!active;
> +	int ret;
>  
>  	BUG_ON(!mem_cont);
>  	mz = mem_cgroup_zoneinfo(mem_cont, nid, zid);
> @@ -666,9 +667,19 @@ unsigned long mem_cgroup_isolate_pages(u
>  			continue;
>  
>  		scan++;
> -		if (__isolate_lru_page(page, mode, file) == 0) {
> +		ret = __isolate_lru_page(page, mode, file);
> +		switch (ret) {
> +		case 0:
>  			list_move(&page->lru, dst);
> +			mem_cgroup_del_lru(page);
>  			nr_taken++;
> +			break;
> +		case -EBUSY:
> +			/* we don't affect global LRU but rotate in our LRU */
> +			mem_cgroup_rotate_lru_list(page, page_lru(page));
> +			break;
> +		default:
> +			break;
>  		}
>  	}
>  
> 
