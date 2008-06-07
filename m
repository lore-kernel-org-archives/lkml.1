Return-Path: <linux-kernel-owner+w=401wt.eu-S1758201AbYFGBJC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201AbYFGBJC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 21:09:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757132AbYFGBG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 21:06:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758409AbYFGBG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 21:06:26 -0400
Date: Fri, 6 Jun 2008 18:05:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 16/25] SHM_LOCKED pages are non-reclaimable
Message-Id: <20080606180514.93f620ff.akpm@linux-foundation.org>
In-Reply-To: <20080606202859.466929557@redhat.com>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.466929557@redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Jun 2008 16:28:54 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
> 
> Against:  2.6.26-rc2-mm1
> 
> While working with Nick Piggin's mlock patches,

Change log refers to information which its reader has not got a hope
of actually locating.

> I noticed that
> shmem segments locked via shmctl(SHM_LOCKED) were not being handled.
> SHM_LOCKed pages work like ramdisk pages

Well, OK.  As long as one remembers that "ramdisk pages" are different
from "pages of a file which is on ramdisk".  Tricky, huh?

> --the writeback function
> just redirties the page so that it can't be reclaimed.  Deal with
> these using the same approach as for ram disk pages.
> 
> Use the AS_NORECLAIM flag to mark address_space of SHM_LOCKed
> shared memory regions as non-reclaimable.  Then these pages
> will be culled off the normal LRU lists during vmscan.

So I guess there's more justification for handling these pages in this
manner, because someone could come along later and unlock them.  But
that isn't true of /dev/ram0 pages and ramfs pages, etc.

> Add new wrapper function to clear the mapping's noreclaim state
> when/if shared memory segment is munlocked.
> 
> Add 'scan_mapping_noreclaim_page()' to mm/vmscan.c to scan all
> pages in the shmem segment's mapping [struct address_space] for
> reclaimability now that they're no longer locked.  If so, move
> them to the appropriate zone lru list.  Note that
> scan_mapping_noreclaim_page() must be able to sleep on page_lock(),
> so we can't call it holding the shmem info spinlock nor the shmid
> spinlock.  So, we pass the mapping [address_space] back to shmctl()
> on SHM_UNLOCK for rescuing any nonreclaimable pages after dropping
> the spinlocks.  Once we drop the shmid lock, the backing shmem file
> can be deleted if the calling task doesn't have the shm area
> attached.  To handle this, we take an extra reference on the file
> before dropping the shmid lock and drop the reference after scanning
> the mapping's noreclaim pages.
> 
>
> ...
>
> +
> +/**
> + * check_move_noreclaim_page - check page for reclaimability and move to appropriate zone lru list
> + * @page: page to check reclaimability and move to appropriate lru list
> + * @zone: zone page is in
> + *
> + * Checks a page for reclaimability and moves the page to the appropriate
> + * zone lru list.
> + *
> + * Restrictions: zone->lru_lock must be held, page must be on LRU and must
> + * have PageNoreclaim set.
> + */
> +static void check_move_noreclaim_page(struct page *page, struct zone *zone)
> +{
> +
> +	ClearPageNoreclaim(page); /* for page_reclaimable() */

Confused.  Didn't we just lose track of our NR_NORECLAIM accounting?

> +	if (page_reclaimable(page, NULL)) {
> +		enum lru_list l = LRU_INACTIVE_ANON + page_file_cache(page);
> +		__dec_zone_state(zone, NR_NORECLAIM);
> +		list_move(&page->lru, &zone->list[l]);
> +		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
> +	} else {
> +		/*
> +		 * rotate noreclaim list
> +		 */
> +		SetPageNoreclaim(page);
> +		list_move(&page->lru, &zone->list[LRU_NORECLAIM]);
> +	}
> +}
> +
> +/**
> + * scan_mapping_noreclaim_pages - scan an address space for reclaimable pages
> + * @mapping: struct address_space to scan for reclaimable pages
> + *
> + * Scan all pages in mapping.  Check non-reclaimable pages for
> + * reclaimability and move them to the appropriate zone lru list.
> + */
> +void scan_mapping_noreclaim_pages(struct address_space *mapping)
> +{
> +	pgoff_t next = 0;
> +	pgoff_t end   = (i_size_read(mapping->host) + PAGE_CACHE_SIZE - 1) >>
> +			 PAGE_CACHE_SHIFT;
> +	struct zone *zone;
> +	struct pagevec pvec;
> +
> +	if (mapping->nrpages == 0)
> +		return;
> +
> +	pagevec_init(&pvec, 0);
> +	while (next < end &&
> +		pagevec_lookup(&pvec, mapping, next, PAGEVEC_SIZE)) {
> +		int i;
> +
> +		zone = NULL;
> +
> +		for (i = 0; i < pagevec_count(&pvec); i++) {
> +			struct page *page = pvec.pages[i];
> +			pgoff_t page_index = page->index;
> +			struct zone *pagezone = page_zone(page);
> +
> +			if (page_index > next)
> +				next = page_index;
> +			next++;
> +
> +			if (TestSetPageLocked(page)) {
> +				/*
> +				 * OK, let's do it the hard way...
> +				 */
> +				if (zone)
> +					spin_unlock_irq(&zone->lru_lock);
> +				zone = NULL;
> +				lock_page(page);
> +			}
> +
> +			if (pagezone != zone) {
> +				if (zone)
> +					spin_unlock_irq(&zone->lru_lock);
> +				zone = pagezone;
> +				spin_lock_irq(&zone->lru_lock);
> +			}
> +
> +			if (PageLRU(page) && PageNoreclaim(page))
> +				check_move_noreclaim_page(page, zone);
> +
> +			unlock_page(page);
> +
> +		}
> +		if (zone)
> +			spin_unlock_irq(&zone->lru_lock);
> +		pagevec_release(&pvec);
> +	}
> +
> +}

This function can spend fantastically large amounts of time under
spin_lock_irq().

