Return-Path: <linux-kernel-owner+w=401wt.eu-S1753681AbZDWXN0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbZDWXN0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 19:13:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755813AbZDWXNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 19:13:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293AbZDWXND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 19:13:03 -0400
Date: Thu, 23 Apr 2009 16:06:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: mel@csn.ul.ie, linux-mm@kvack.org, kosaki.motohiro@jp.fujitsu.com,
       cl@linux-foundation.org, npiggin@suse.de, linux-kernel@vger.kernel.org,
       ming.m.lin@intel.com, yanmin_zhang@linux.intel.com,
       peterz@infradead.org, penberg@cs.helsinki.fi
Subject: Re: [PATCH 19/22] Update NR_FREE_PAGES only as necessary
Message-Id: <20090423160610.a093ddf0.akpm@linux-foundation.org>
In-Reply-To: <1240408407-21848-20-git-send-email-mel@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
	<1240408407-21848-20-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Apr 2009 14:53:24 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> When pages are being freed to the buddy allocator, the zone
> NR_FREE_PAGES counter must be updated. In the case of bulk per-cpu page
> freeing, it's updated once per page. This retouches cache lines more
> than necessary. Update the counters one per per-cpu bulk free.
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -460,7 +460,6 @@ static inline void __free_one_page(struct page *page,
>  		int migratetype)
>  {
>  	unsigned long page_idx;
> -	int order_size = 1 << order;
>  
>  	if (unlikely(PageCompound(page)))
>  		if (unlikely(destroy_compound_page(page, order)))
> @@ -470,10 +469,9 @@ static inline void __free_one_page(struct page *page,
>  
>  	page_idx = page_to_pfn(page) & ((1 << MAX_ORDER) - 1);
>  
> -	VM_BUG_ON(page_idx & (order_size - 1));
> +	VM_BUG_ON(page_idx & ((1 << order) - 1));
>  	VM_BUG_ON(bad_range(zone, page));
>  

<head spins>

Is this all a slow and obscure way of doing

	VM_BUG_ON(order > MAX_ORDER);

?

If not, what _is_ it asserting?
