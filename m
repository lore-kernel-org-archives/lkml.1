Return-Path: <linux-kernel-owner+w=401wt.eu-S1759292AbXKMQZZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759292AbXKMQZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 11:25:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbXKMQZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 11:25:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53352 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbXKMQZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 11:25:13 -0500
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: mel@csn.ul.ie, akpm@osdl.org, torvalds@osdl.org,
       linux-kernel@vger.kernel.org, linux-mm@vger.kernel.org
Subject: Re: Major mke2fs slowdown (reproducable, bisected)
From: Andi Kleen <andi@firstfloor.org>
References: <20071112182526.GC11244@martell.zuzino.mipt.ru>
Date: Tue, 13 Nov 2007 17:25:09 +0100
In-Reply-To: <20071112182526.GC11244@martell.zuzino.mipt.ru> (Alexey Dobriyan's message of "Mon\, 12 Nov 2007 21\:25\:26 +0300")
Message-ID: <p736406yuxm.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan <adobriyan@gmail.com> writes:
>  
> +/* Return the page with the lowest PFN in the list */
> +static struct page *min_page(struct list_head *list)
> +{
> +	unsigned long min_pfn = -1UL;
> +	struct page *min_page = NULL, *page;;
> +
> +	list_for_each_entry(page, list, lru) {
> +		unsigned long pfn = page_to_pfn(page);
> +		if (pfn < min_pfn) {
> +			min_pfn = pfn;
> +			min_page = page;
> +		}
> +	}
> +
> +	return min_page;
> +}
> +
>  /* Remove an element from the buddy allocator from the fallback list */
>  static struct page *__rmqueue_fallback(struct zone *zone, int order,
>  						int start_migratetype)
> @@ -795,8 +812,11 @@ retry:
>  			if (list_empty(&area->free_list[migratetype]))
>  				continue;
>  
> +			/* Bias kernel allocations towards low pfns */
>  			page = list_entry(area->free_list[migratetype].next,
>  					struct page, lru);
> +			if (unlikely(start_migratetype != MIGRATE_MOVABLE))
> +				page = min_page(&area->free_list[migratetype]);

Do I misread this, or does it really turn the O(1) buddy allocation into
a "search whole free list" algorithm?  Even as fallback that looks like
a quite extreme thing to do.

-Andi
