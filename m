Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYFJVWa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYFJVWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 17:22:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbYFJVWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 17:22:20 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:21134 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756438AbYFJVWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 17:22:19 -0400
Subject: Re: [PATCH -mm 16/25] SHM_LOCKED pages are non-reclaimable
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20080610170348.5750491c@cuia.bos.redhat.com>
References: <20080606202838.390050172@redhat.com>
	 <20080606202859.466929557@redhat.com>
	 <20080606180514.93f620ff.akpm@linux-foundation.org>
	 <20080610170348.5750491c@cuia.bos.redhat.com>
Content-Type: text/plain
Organization: HP/OSLO
Date: Tue, 10 Jun 2008 17:22:26 -0400
Message-Id: <1213132946.6872.27.camel@lts-notebook>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-10 at 17:03 -0400, Rik van Riel wrote:
> On Fri, 6 Jun 2008 18:05:14 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > While working with Nick Piggin's mlock patches,
> > 
> > Change log refers to information which its reader has not got a hope
> > of actually locating.
> 
> Fixed that, and renamed everything to "unevictable".

So, we're making a global change of "[no[n]]reclaim[able]" =>
"[un]evictable"?


Shall I take a cut at renaming and updating the document once the code
renames are complete?

> 
> > > Use the AS_NORECLAIM flag to mark address_space of SHM_LOCKed
> > > shared memory regions as non-reclaimable.  Then these pages
> > > will be culled off the normal LRU lists during vmscan.
> > 
> > So I guess there's more justification for handling these pages in this
> > manner, because someone could come along later and unlock them.  But
> > that isn't true of /dev/ram0 pages and ramfs pages, etc.
> 
> Bingo.  Ramdisk and ramfs pages will never become evictable again,
> while the pages in an SHM_LOCKED segment might.
>  
> > > +static void check_move_noreclaim_page(struct page *page, struct zone *zone)
> > > +{
> > > +
> > > +	ClearPageNoreclaim(page); /* for page_reclaimable() */
> > 
> > Confused.  Didn't we just lose track of our NR_NORECLAIM accounting?
> > 
> > > +	if (page_reclaimable(page, NULL)) {
> > > +		enum lru_list l = LRU_INACTIVE_ANON + page_file_cache(page);
> > > +		__dec_zone_state(zone, NR_NORECLAIM);
> 
> No, we decrement the zone count here if the page is indeed
> unevictable.
> 
> > > +		list_move(&page->lru, &zone->list[l]);
> > > +		__inc_zone_state(zone, NR_INACTIVE_ANON + l);
> > > +	} else {
> > > +		/*
> > > +		 * rotate noreclaim list
> > > +		 */
> > > +		SetPageNoreclaim(page);
> > > +		list_move(&page->lru, &zone->list[LRU_NORECLAIM]);
> > > +	}
> > > +}
> 
> Or mark it unevictable again if it still is.
> 
> > > + * scan_mapping_noreclaim_pages - scan an address space for reclaimable pages
> > > + * @mapping: struct address_space to scan for reclaimable pages
> > > + *
> > > + * Scan all pages in mapping.  Check non-reclaimable pages for
> > > + * reclaimability and move them to the appropriate zone lru list.
> > > + */
> > > +void scan_mapping_noreclaim_pages(struct address_space *mapping)
> > > +{
> 
> > This function can spend fantastically large amounts of time under
> > spin_lock_irq().

Yes, if we get a run of pages from the same zone [likely, I think],
we'll hold the lock over a full "batch" of  PAGEVEC_SIZE [14] pages.  I
haven't measured the hold time, but can do.

> 
> I'll leave it up to Lee and Kosaki-san to fix this, once
> you have the cleaned up versions.

I could use some advice on the batch size.  E.g., I could cycle the lock
for each page in the mapping, or choose a batch size somewhat less than
PAGEVEC_SIZE, but > 1.  Thoughts?  Is there a target "max hold time"?

Lee

