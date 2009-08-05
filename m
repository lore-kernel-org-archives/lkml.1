Return-Path: <linux-kernel-owner+w=401wt.eu-S933894AbZHEJYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933894AbZHEJYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 05:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932946AbZHEJYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 05:24:43 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:37240 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932805AbZHEJYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 05:24:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 3/4] tracing, page-allocator: Add trace event for page traffic related to the buddy lists
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>, riel@redhat.com,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
In-Reply-To: <1249409546-6343-4-git-send-email-mel@csn.ul.ie>
References: <1249409546-6343-1-git-send-email-mel@csn.ul.ie> <1249409546-6343-4-git-send-email-mel@csn.ul.ie>
Message-Id: <20090805182034.5BCD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  5 Aug 2009 18:24:40 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The page allocation trace event reports that a page was successfully allocated
> but it does not specify where it came from. When analysing performance,
> it can be important to distinguish between pages coming from the per-cpu
> allocator and pages coming from the buddy lists as the latter requires the
> zone lock to the taken and more data structures to be examined.
> 
> This patch adds a trace event for __rmqueue reporting when a page is being
> allocated from the buddy lists. It distinguishes between being called
> to refill the per-cpu lists or whether it is a high-order allocation.
> Similarly, this patch adds an event to catch when the PCP lists are being
> drained a little and pages are going back to the buddy lists.
> 
> This is trickier to draw conclusions from but high activity on those
> events could explain why there were a large number of cache misses on a
> page-allocator-intensive workload. The coalescing and splitting of buddies
> involves a lot of writing of page metadata and cache line bounces not to
> mention the acquisition of an interrupt-safe lock necessary to enter this
> path.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Acked-by: Rik van Riel <riel@redhat.com>
> ---
>  include/trace/events/kmem.h |   54 +++++++++++++++++++++++++++++++++++++++++++
>  mm/page_alloc.c             |    2 +
>  2 files changed, 56 insertions(+), 0 deletions(-)
> 
> diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
> index 0b4002e..3be3df3 100644
> --- a/include/trace/events/kmem.h
> +++ b/include/trace/events/kmem.h
> @@ -311,6 +311,60 @@ TRACE_EVENT(mm_page_alloc,
>  		show_gfp_flags(__entry->gfp_flags))
>  );
>  
> +TRACE_EVENT(mm_page_alloc_zone_locked,
> +
> +	TP_PROTO(const void *page, unsigned int order,
> +				int migratetype, int percpu_refill),
> +
> +	TP_ARGS(page, order, migratetype, percpu_refill),
> +
> +	TP_STRUCT__entry(
> +		__field(	const void *,	page		)
> +		__field(	unsigned int,	order		)
> +		__field(	int,		migratetype	)
> +		__field(	int,		percpu_refill	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->page		= page;
> +		__entry->order		= order;
> +		__entry->migratetype	= migratetype;
> +		__entry->percpu_refill	= percpu_refill;
> +	),
> +
> +	TP_printk("page=%p pfn=%lu order=%u migratetype=%d percpu_refill=%d",
> +		__entry->page,
> +		page_to_pfn((struct page *)__entry->page),
> +		__entry->order,
> +		__entry->migratetype,
> +		__entry->percpu_refill)
> +);
> +
> +TRACE_EVENT(mm_page_pcpu_drain,
> +
> +	TP_PROTO(const void *page, int order, int migratetype),
> +
> +	TP_ARGS(page, order, migratetype),
> +
> +	TP_STRUCT__entry(
> +		__field(	const void *,	page		)
> +		__field(	int,		order		)
> +		__field(	int,		migratetype	)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->page		= page;
> +		__entry->order		= order;
> +		__entry->migratetype	= migratetype;
> +	),
> +
> +	TP_printk("page=%p pfn=%lu order=%d migratetype=%d",
> +		__entry->page,
> +		page_to_pfn((struct page *)__entry->page),
> +		__entry->order,
> +		__entry->migratetype)
> +);
> +
>  TRACE_EVENT(mm_page_alloc_extfrag,
>  
>  	TP_PROTO(const void *page,
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index c2c90cd..35b92a9 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -535,6 +535,7 @@ static void free_pages_bulk(struct zone *zone, int count,
>  		page = list_entry(list->prev, struct page, lru);
>  		/* have to delete it as __free_one_page list manipulates */
>  		list_del(&page->lru);
> +		trace_mm_page_pcpu_drain(page, order, page_private(page));

pcp refill (trace_mm_page_alloc_zone_locked) logged migratetype, but
this tracepoint doesn't. why?


>  		__free_one_page(page, zone, order, page_private(page));
>  	}
>  	spin_unlock(&zone->lock);
> @@ -878,6 +879,7 @@ retry_reserve:
>  		}
>  	}
>  
> +	trace_mm_page_alloc_zone_locked(page, order, migratetype, order == 0);
>  	return page;
>  }

Umm, Can we assume order-0 always mean pcp refill?




