Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbYLAVmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbYLAVmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 16:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbYLAVl7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 16:41:59 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39818 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbYLAVl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 16:41:58 -0500
Date: Mon, 1 Dec 2008 13:41:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@saeurebad.de>
Cc: torvalds@linux-foundation.org, riel@redhat.com,
       kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch v2] vmscan: protect zone rotation stats by lru lock
Message-Id: <20081201134112.24c647ff.akpm@linux-foundation.org>
In-Reply-To: <E1L6y5T-0003q3-M3@cmpxchg.org>
References: <E1L6y5T-0003q3-M3@cmpxchg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Dec 2008 03:00:35 +0100
Johannes Weiner <hannes@saeurebad.de> wrote:

> The zone's rotation statistics must not be accessed without the
> corresponding LRU lock held.  Fix an unprotected write in
> shrink_active_list().
> 

I don't think it really matters.  It's quite common in that code to do
unlocked, racy update to statistics such as this.  Because on those
rare occasions where a race does happen, there's a small glitch in the
reclaim logic which nobody will notice anyway.

Of course, this does need to be done with some care, to ensure the
glitch _will_ be small.  If such a race would cause the scanner to go
off and reclaim 2^32 pages, well, that's not so good.

> 
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1243,32 +1243,32 @@ static void shrink_active_list(unsigned 
>  		/* page_referenced clears PageReferenced */
>  		if (page_mapping_inuse(page) &&
>  		    page_referenced(page, 0, sc->mem_cgroup))
>  			pgmoved++;
>  
>  		list_add(&page->lru, &l_inactive);
>  	}
>  
> +	spin_lock_irq(&zone->lru_lock);
>  	/*
>  	 * Count referenced pages from currently used mappings as
>  	 * rotated, even though they are moved to the inactive list.
>  	 * This helps balance scan pressure between file and anonymous
>  	 * pages in get_scan_ratio.
>  	 */
>  	zone->recent_rotated[!!file] += pgmoved;
>  
>  	/*
>  	 * Move the pages to the [file or anon] inactive list.
>  	 */
>  	pagevec_init(&pvec, 1);
>  
>  	pgmoved = 0;
>  	lru = LRU_BASE + file * LRU_FILE;
> -	spin_lock_irq(&zone->lru_lock);

We've unnecessarily moved a pile of other things inside the locked
region as well, needlessly extending the lock hold times.

>  	while (!list_empty(&l_inactive)) {
>  		page = lru_to_page(&l_inactive);
>  		prefetchw_prev_lru_page(page, &l_inactive, flags);
>  		VM_BUG_ON(PageLRU(page));
>  		SetPageLRU(page);
>  		VM_BUG_ON(!PageActive(page));
>  		ClearPageActive(page);
>  

You'll note that the code which _uses_ these values does so without
holding the lock.  So get_scan_ratio() sees incoherent values of
recent_scanned[0] and recent_scanned[1].  As is common in this code,
that is OK and deliberate.

It's also racy here:

	if (unlikely(zone->recent_scanned[0] > anon / 4)) {
		spin_lock_irq(&zone->lru_lock);
		zone->recent_scanned[0] /= 2;
		zone->recent_rotated[0] /= 2;
		spin_unlock_irq(&zone->lru_lock);
	}

failing to recheck the comparison after taking the lock..
