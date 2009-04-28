Return-Path: <linux-kernel-owner+w=401wt.eu-S1755761AbZD1S2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761AbZD1S2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753179AbZD1S2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:28:40 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:51127 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752027AbZD1S2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:28:39 -0400
Date: Tue, 28 Apr 2009 19:25:59 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] Properly account for freed pages in free_pages_bulk()
 and when allocating high-order pages in buffered_rmqueue() V2
In-Reply-To: <20090428180759.GB18893@csn.ul.ie>
Message-ID: <Pine.LNX.4.64.0904281922210.8561@blonde.anvils>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie>
 <1240819119.2567.884.camel@ymzhang> <20090427143845.GC912@csn.ul.ie>
 <1240883957.2567.886.camel@ymzhang> <20090428103159.GB23540@csn.ul.ie>
 <alpine.DEB.1.10.0904281236350.21913@qirst.com> <20090428165129.GA18893@csn.ul.ie>
 <Pine.LNX.4.64.0904281810240.30878@blonde.anvils> <20090428180759.GB18893@csn.ul.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Apr 2009, Mel Gorman wrote:

> free_pages_bulk() updates the number of free pages in the zone but it is
> assuming that the pages being freed are order-0. While this is currently
> always true, it's wrong to assume the order is 0. This patch fixes the problem.
> 
> buffered_rmqueue() is not updating NR_FREE_PAGES when allocating pages with
> __rmqueue(). As a result, high-order allocation will appear to increase
> the number of free pages leading to the situation where the free page count
> exceeds available RAM. This patch accounts for those allocated pages properly.
> 
> This is a fix for page-allocator-update-nr_free_pages-only-as-necessary.patch.
> 
> Changelog since V1
>   o Change 1UL to 1 as it's unnecessary in this case to be unsigned long
> 
> Reported-by: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>

Thanks, Mel!  (And I don't need to test it, since it's now
remarkably similar to a patch I was preparing yesterday.)

Acked-by: Hugh Dickins <hugh@veritas.com>

> --- 
>  mm/page_alloc.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5dd2d59..59eb2e1 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -545,7 +545,7 @@ static void free_pages_bulk(struct zone *zone, int count,
>  	zone_clear_flag(zone, ZONE_ALL_UNRECLAIMABLE);
>  	zone->pages_scanned = 0;
>  
> -	__mod_zone_page_state(zone, NR_FREE_PAGES, count);
> +	__mod_zone_page_state(zone, NR_FREE_PAGES, count << order);
>  	while (count--) {
>  		struct page *page;
>  
> @@ -1151,6 +1151,7 @@ again:
>  	} else {
>  		spin_lock_irqsave(&zone->lock, flags);
>  		page = __rmqueue(zone, order, migratetype);
> +		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1 << order));
>  		spin_unlock(&zone->lock);
>  		if (!page)
>  			goto failed;
