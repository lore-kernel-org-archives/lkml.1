Return-Path: <linux-kernel-owner+w=401wt.eu-S1762755AbXIKGrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762755AbXIKGrL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 02:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756462AbXIKGqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 02:46:55 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:47775 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755809AbXIKGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 02:46:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=B30tjrxMbNspOlFh2FeCCGP7Sk6bI0HXWsBsSApMuwV8QAyOL6lFAPGOSMcsITNVanThQELB1GeyU3ZC1OrF2M8ixVLPBQhasQ5/VVrnqrQSGVEvXWSP+o4VkJLCafFaic4A2KCdBKbIW1ZYm9IXtAAUUjGgF963E/R33WfUBXc=  ;
X-YMail-OSG: 0ygZJhgVM1lwOc_ygj3OHuP53YwOC7tEjgEZ3UlgkUCXlSDwZPiLXoCOBUa_f0fG08VM3tb0DcXdDMAFGlLPj44k1FYO05JphyuYYTsBTHYpL44sVJs-
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 7/13] Drain per-cpu lists when high-order allocations fail
Date: Tue, 11 Sep 2007 01:05:25 +1000
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
References: <20070910112011.3097.8438.sendpatchset@skynet.skynet.ie> <20070910112231.3097.53548.sendpatchset@skynet.skynet.ie>
In-Reply-To: <20070910112231.3097.53548.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709110105.25544.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2007 21:22, Mel Gorman wrote:
> Per-cpu pages can accidentally cause fragmentation because they are free,
> but pinned pages in an otherwise contiguous block.  When this patch is
> applied, the per-cpu caches are drained after the direct-reclaim is entered
> if the requested order is greater than 0.  It simply reuses the code used
> by suspend and hotplug.

Does this help? I have a more general version which could go in
instead (independently of the anti fragmentation patches).

> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  mm/page_alloc.c |   24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
>
> diff -rup -X /usr/src/patchset-0.6/bin//dontdiff
> linux-2.6.23-rc5-006-group-short-lived-and-reclaimable-kernel-allocations/m
>m/page_alloc.c
> linux-2.6.23-rc5-007-drain-per-cpu-lists-when-high-order-allocations-fail/m
>m/page_alloc.c ---
> linux-2.6.23-rc5-006-group-short-lived-and-reclaimable-kernel-allocations/m
>m/page_alloc.c	2007-09-02 16:20:31.000000000 +0100 +++
> linux-2.6.23-rc5-007-drain-per-cpu-lists-when-high-order-allocations-fail/m
>m/page_alloc.c	2007-09-02 16:20:48.000000000 +0100 @@ -852,6 +852,7 @@ void
> mark_free_pages(struct zone *zone)
>  	}
>  	spin_unlock_irqrestore(&zone->lock, flags);
>  }
> +#endif /* CONFIG_PM */
>
>  /*
>   * Spill all of this CPU's per-cpu pages back into the buddy allocator.
> @@ -864,7 +865,25 @@ void drain_local_pages(void)
>  	__drain_pages(smp_processor_id());
>  	local_irq_restore(flags);
>  }
> -#endif /* CONFIG_HIBERNATION */
> +
> +void smp_drain_local_pages(void *arg)
> +{
> +	drain_local_pages();
> +}
> +
> +/*
> + * Spill all the per-cpu pages from all CPUs back into the buddy allocator
> + */
> +void drain_all_local_pages(void)
> +{
> +	unsigned long flags;
> +
> +	local_irq_save(flags);
> +	__drain_pages(smp_processor_id());
> +	local_irq_restore(flags);
> +
> +	smp_call_function(smp_drain_local_pages, NULL, 0, 1);
> +}
>
>  /*
>   * Free a 0-order page
> @@ -1452,6 +1471,9 @@ nofail_alloc:
>
>  	cond_resched();
>
> +	if (order != 0)
> +		drain_all_local_pages();
> +
>  	if (likely(did_some_progress)) {
>  		page = get_page_from_freelist(gfp_mask, order,
>  						zonelist, alloc_flags);
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
