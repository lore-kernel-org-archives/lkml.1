Return-Path: <linux-kernel-owner+w=401wt.eu-S934480AbZGQMSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480AbZGQMSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 08:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934419AbZGQMSy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 08:18:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:56178 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934410AbZGQMSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 08:18:53 -0400
Subject: Re: [PATCH 4/5] Use add_page_to_lru_list() helper function
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090716173921.9D54.A69D9226@jp.fujitsu.com>
References: <20090716173449.9D4B.A69D9226@jp.fujitsu.com>
	 <20090716173921.9D54.A69D9226@jp.fujitsu.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 17 Jul 2009 14:18:48 +0200
Message-Id: <1247833128.15751.41.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-16 at 17:40 +0900, KOSAKI Motohiro wrote:
> Subject: Use add_page_to_lru_list() helper function
> 
> add_page_to_lru_list() is equivalent to
>   - add lru list (global)
>   - add lru list (mem-cgroup)
>   - modify zone stat
> 
> We can use it.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/vmscan.c |    5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> Index: b/mm/vmscan.c
> ===================================================================
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1225,12 +1225,12 @@ static void move_active_pages_to_lru(str
>  
>  	while (!list_empty(list)) {
>  		page = lru_to_page(list);
> +		list_del(&page->lru);
>  
>  		VM_BUG_ON(PageLRU(page));
>  		SetPageLRU(page);
>  
> -		list_move(&page->lru, &zone->lru[lru].list);
> -		mem_cgroup_add_lru_list(page, lru);
> +		add_page_to_lru_list(zone, page, lru);
>  		pgmoved++;
>  
>  		if (!pagevec_add(&pvec, page) || list_empty(list)) {
> @@ -1241,7 +1241,6 @@ static void move_active_pages_to_lru(str
>  			spin_lock_irq(&zone->lru_lock);
>  		}
>  	}
> -	__mod_zone_page_state(zone, NR_LRU_BASE + lru, pgmoved);
>  	if (!is_active_lru(lru))
>  		__count_vm_events(PGDEACTIVATE, pgmoved);
>  }

This is a net loss, you introduce pgmoved calls to __inc_zone_state,
instead of the one __mod_zone_page_state() call.
