Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYFJVEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYFJVEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYFJVEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:04:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753749AbYFJVE3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:04:29 -0400
Date: Tue, 10 Jun 2008 17:03:48 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 16/25] SHM_LOCKED pages are non-reclaimable
Message-ID: <20080610170348.5750491c@cuia.bos.redhat.com>
In-Reply-To: <20080606180514.93f620ff.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202859.466929557@redhat.com>
	<20080606180514.93f620ff.akpm@linux-foundation.org>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:05:14 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > While working with Nick Piggin's mlock patches,
> 
> Change log refers to information which its reader has not got a hope
> of actually locating.

Fixed that, and renamed everything to "unevictable".

> > Use the AS_NORECLAIM flag to mark address_space of SHM_LOCKed
> > shared memory regions as non-reclaimable.  Then these pages
> > will be culled off the normal LRU lists during vmscan.
> 
> So I guess there's more justification for handling these pages in this
> manner, because someone could come along later and unlock them.  But
> that isn't true of /dev/ram0 pages and ramfs pages, etc.

Bingo.  Ramdisk and ramfs pages will never become evictable again,
while the pages in an SHM_LOCKED segment might.
 
> > +static void check_move_noreclaim_page(struct page *page, struct zone *zone)
> > +{
> > +
> > +	ClearPageNoreclaim(page); /* for page_reclaimable() */
> 
> Confused.  Didn't we just lose track of our NR_NORECLAIM accounting?
> 
> > +	if (page_reclaimable(page, NULL)) {
> > +		enum lru_list l = LRU_INACTIVE_ANON + page_file_cache(page);
> > +		__dec_zone_state(zone, NR_NORECLAIM);

No, we decrement the zone count here if the page is indeed
unevictable.

> > +		list_move(&page->lru, &zone->list[l]);
> > +		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
> > +	} else {
> > +		/*
> > +		 * rotate noreclaim list
> > +		 */
> > +		SetPageNoreclaim(page);
> > +		list_move(&page->lru, &zone->list[LRU_NORECLAIM]);
> > +	}
> > +}

Or mark it unevictable again if it still is.

> > + * scan_mapping_noreclaim_pages - scan an address space for reclaimable pages
> > + * @mapping: struct address_space to scan for reclaimable pages
> > + *
> > + * Scan all pages in mapping.  Check non-reclaimable pages for
> > + * reclaimability and move them to the appropriate zone lru list.
> > + */
> > +void scan_mapping_noreclaim_pages(struct address_space *mapping)
> > +{

> This function can spend fantastically large amounts of time under
> spin_lock_irq().

I'll leave it up to Lee and Kosaki-san to fix this, once
you have the cleaned up versions.

Fixing this now would just delay my other janitorial work on
this patch series...

-- 
All Rights Reversed
