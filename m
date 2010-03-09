Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049Ab0CIJx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 04:53:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39029 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924Ab0CIJxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 04:53:53 -0500
Date: Tue, 9 Mar 2010 20:53:42 +1100
From: Nick Piggin <npiggin@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: linux-mm@kvack.org, Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>,
       Chris Mason <chris.mason@oracle.com>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] page-allocator: Check zone pressure when batch of
 pages are freed
Message-ID: <20100309095342.GD8653@laptop>
References: <1268048904-19397-1-git-send-email-mel@csn.ul.ie>
 <1268048904-19397-3-git-send-email-mel@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268048904-19397-3-git-send-email-mel@csn.ul.ie>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cool, you found this doesn't hurt performance too much?

Can't you remove the check from the reclaim code now? (The check
here should give a more timely wait anyway)

This is good because it should eliminate most all cases of extra
waiting. I wonder if you've also thought of doing the check in the
allocation path too as we were discussing? (this would give a better
FIFO behaviour under memory pressure but I could easily agree it is not
worth the cost)

On Mon, Mar 08, 2010 at 11:48:22AM +0000, Mel Gorman wrote:
> When a batch of pages have been freed to the buddy allocator, it is possible
> that it is enough to push a zone above its watermarks. This patch puts a
> check in the free path for zone pressure. It's in a common path but for
> the most part, it should only be checking if a linked list is empty and
> have minimal performance impact.
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> ---
>  mm/page_alloc.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 1383ff9..3c8e8b7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -562,6 +562,9 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  		} while (--count && --batch_free && !list_empty(list));
>  	}
>  	spin_unlock(&zone->lock);
> +
> +	/* A batch of pages have been freed so check zone pressure */
> +	check_zone_pressure(zone);
>  }
>  
>  static void free_one_page(struct zone *zone, struct page *page, int order,
> -- 
> 1.6.5
