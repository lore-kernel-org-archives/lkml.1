Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbXLKLVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbXLKLVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 06:21:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbXLKLVC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 06:21:02 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35733 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbXLKLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 06:21:00 -0500
Date: Tue, 11 Dec 2007 20:24:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "riel@redhat.com" <riel@redhat.com>
Subject: Re: [PATCH][for -mm] fix accounting in vmscan.c for memory
 controller
Message-Id: <20071211202411.3c8d655c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071211112644.221a8dc5.kamezawa.hiroyu@jp.fujitsu.com>
References: <20071211112644.221a8dc5.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Dec 2007 11:26:44 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Without this, ALLOCSTALL and PGSCAN_DIRECT increases too much unless
> there is no memory shortage.
Sorry,

Without this, ALLOCSTALL and PGSCAN_DIRECT increases too much even if
                                                              ^^^^^^^
there is no memory shortage.

-Kame


> 
> against 2.6.24-rc4-mm1.
> 
> -Kame
> 
> ==
> Some amount of accounting is done while page reclaiming.
> 
> Now, there are 2 types of page reclaim (if memory controller is used)
>   - global: shortage of (global) pages.
>   - under cgroup: use up to limit.
> 
> I think 2 accountings, ALLOCSTALL and DIRECT should be accounted only under
> global lru scan. They are accounted against memory shortage at alloc_pages().
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
>  mm/vmscan.c |    6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.24-rc4-mm1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.24-rc4-mm1.orig/mm/vmscan.c
> +++ linux-2.6.24-rc4-mm1/mm/vmscan.c
> @@ -896,8 +896,9 @@ static unsigned long shrink_inactive_lis
>  		if (current_is_kswapd()) {
>  			__count_zone_vm_events(PGSCAN_KSWAPD, zone, nr_scan);
>  			__count_vm_events(KSWAPD_STEAL, nr_freed);
> -		} else
> +		} else if (scan_global_lru(sc))
>  			__count_zone_vm_events(PGSCAN_DIRECT, zone, nr_scan);
> +
>  		__count_zone_vm_events(PGSTEAL, zone, nr_freed);
>  
>  		if (nr_taken == 0)
> @@ -1333,7 +1334,8 @@ static unsigned long do_try_to_free_page
>  	unsigned long lru_pages = 0;
>  	int i;
>  
> -	count_vm_event(ALLOCSTALL);
> +	if (scan_global_lru(sc))
> +		count_vm_event(ALLOCSTALL);
>  	/*
>  	 * mem_cgroup will not do shrink_slab.
>  	 */
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

