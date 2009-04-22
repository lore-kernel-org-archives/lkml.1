Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbZDVANZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbZDVANZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 20:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753425AbZDVANP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 20:13:15 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:60223 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbZDVANO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 20:13:14 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 18/25] Do not disable interrupts in free_page_mlock()
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linux Memory Management List <linux-mm@kvack.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Andrew Morton <akpm@linux-foundation.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>
In-Reply-To: <1240266011-11140-19-git-send-email-mel@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-19-git-send-email-mel@csn.ul.ie>
Message-Id: <20090422091144.626B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Wed, 22 Apr 2009 09:13:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc to Lee)

> free_page_mlock() tests and clears PG_mlocked using locked versions of the
> bit operations. If set, it disables interrupts to update counters and this
> happens on every page free even though interrupts are disabled very shortly
> afterwards a second time.  This is wasteful.
> 
> This patch splits what free_page_mlock() does. The bit check is still
> made. However, the update of counters is delayed until the interrupts are
> disabled and the non-lock version for clearing the bit is used. One potential
> weirdness with this split is that the counters do not get updated if the
> bad_page() check is triggered but a system showing bad pages is getting
> screwed already.

Looks good. thanks good improvement.
I hope Lee also ack this.

	Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


  -kosaki


> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: Christoph Lameter <cl@linux-foundation.org>
> ---
>  mm/internal.h   |   11 +++--------
>  mm/page_alloc.c |    8 +++++++-
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 987bb03..58ec1bc 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -157,14 +157,9 @@ static inline void mlock_migrate_page(struct page *newpage, struct page *page)
>   */
>  static inline void free_page_mlock(struct page *page)
>  {
> -	if (unlikely(TestClearPageMlocked(page))) {
> -		unsigned long flags;
> -
> -		local_irq_save(flags);
> -		__dec_zone_page_state(page, NR_MLOCK);
> -		__count_vm_event(UNEVICTABLE_MLOCKFREED);
> -		local_irq_restore(flags);
> -	}
> +	__ClearPageMlocked(page);
> +	__dec_zone_page_state(page, NR_MLOCK);
> +	__count_vm_event(UNEVICTABLE_MLOCKFREED);
>  }
>  
>  #else /* CONFIG_HAVE_MLOCKED_PAGE_BIT */
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a1ca038..bf4b8d9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -499,7 +499,6 @@ static inline void __free_one_page(struct page *page,
>  
>  static inline int free_pages_check(struct page *page)
>  {
> -	free_page_mlock(page);
>  	if (unlikely(page_mapcount(page) |
>  		(page->mapping != NULL)  |
>  		(page_count(page) != 0)  |
> @@ -556,6 +555,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>  	unsigned long flags;
>  	int i;
>  	int bad = 0;
> +	int clearMlocked = PageMlocked(page);
>  
>  	for (i = 0 ; i < (1 << order) ; ++i)
>  		bad += free_pages_check(page + i);
> @@ -571,6 +571,8 @@ static void __free_pages_ok(struct page *page, unsigned int order)
>  	kernel_map_pages(page, 1 << order, 0);
>  
>  	local_irq_save(flags);
> +	if (unlikely(clearMlocked))
> +		free_page_mlock(page);
>  	__count_vm_events(PGFREE, 1 << order);
>  	free_one_page(page_zone(page), page, order,
>  					get_pageblock_migratetype(page));
> @@ -1018,6 +1020,7 @@ static void free_hot_cold_page(struct page *page, int cold)
>  	struct zone *zone = page_zone(page);
>  	struct per_cpu_pages *pcp;
>  	unsigned long flags;
> +	int clearMlocked = PageMlocked(page);
>  
>  	if (PageAnon(page))
>  		page->mapping = NULL;
> @@ -1033,7 +1036,10 @@ static void free_hot_cold_page(struct page *page, int cold)
>  
>  	pcp = &zone_pcp(zone, get_cpu())->pcp;
>  	local_irq_save(flags);
> +	if (unlikely(clearMlocked))
> +		free_page_mlock(page);
>  	__count_vm_event(PGFREE);
> +
>  	if (cold)
>  		list_add_tail(&page->lru, &pcp->list);
>  	else
> -- 
> 1.5.6.5
> 



