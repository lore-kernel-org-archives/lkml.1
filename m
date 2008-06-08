Return-Path: <linux-kernel-owner+w=401wt.eu-S1756199AbYFHPEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbYFHPEn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 11:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYFHPEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 11:04:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33343 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966AbYFHPEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 11:04:32 -0400
Date: Sun, 8 Jun 2008 11:04:12 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [PATCH -mm 07/25] second chance replacement for anonymous pages
Message-ID: <20080608110412.56126b2d@bree.surriel.com>
In-Reply-To: <20080606180443.43f782e2.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.744030156@redhat.com>
	<20080606180443.43f782e2.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:04:43 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > To keep the maximum amount of necessary work reasonable, we scale the
> > active to inactive ratio with the size of memory, using the formula
> > active:inactive ratio = sqrt(memory in GB * 10).
> 
> Should be scaled by PAGE_SIZE?

I suspect the value does not matter all that much.  It is meant to
make the number of inactive anon pages scale sub-linearly with the
size of memory in the system, so anon pages stay on the inactive
list long enough to get referenced again, while limiting the total
number of pages the VM needs to scan to something hopefully reasonable.

This formula has worked well in our testing, but maybe wider testing
in -mm will show us it needs to be tweaked.  Too early to tell whether
scaling by PAGE_SIZE will be needed at all.
 
> > +static inline int inactive_anon_low(struct zone *zone)
> > +{
> > +	unsigned long active, inactive;
> > +
> > +	active = zone_page_state(zone, NR_ACTIVE_ANON);
> > +	inactive = zone_page_state(zone, NR_INACTIVE_ANON);
> > +
> > +	if (inactive * zone->inactive_ratio < active)
> > +		return 1;
> > +
> > +	return 0;
> > +}
> 
> inactive_anon_low: "number of inactive anonymous pages which are in lowmem"?
> 
> Nope.
> 
> Needs a comment.  And maybe a better name, like inactive_anon_is_low. 
> Although making the return type a bool kind-of does that.

Added a comment and renamed the function.

> > +	/*
> > +	 * The ratio of active to inactive pages.
> > +	 */
> > +	unsigned int inactive_ratio;
> 
> That comment needs a lot of help please.  For a start, it's plain wrong
> - inactive_ratio would need to be a float to be able to record that ratio.
> 
> The comment should describe the units too.
.
Commented the hell out of the inactive_ratio stuff :)

> OK, so inactive_ratio is an integer 1 ..  N which determines our target
> number of inactive pages according to the formula
> 
> 	nr_inactive = nr_active / inactive_ratio
> 
> yes?
> 
> Can nr_inactive get larger than this?  I assume so.  I guess that
> doesn't matter much.  Except the problems which you're trying to sovle
> here can reoccur.   What would I need to do to trigger that?

All new anon pages start out on the active list.

The only way you could trigger this problem is by swapping a lot
of memory out through allocation of new memory, then freeing that
new memory and swapping the old memory back in.

That can only happen with the "add newly swapped in pages to the 
inactive list" patch applied, which is why that patch may need some
wider exposure in -mm.

It has not been problematic in our tests so far.
 
> >  long vm_total_pages;	/* The total number of pages which the VM controls */
> >  
> >  static LIST_HEAD(shrinker_list);
> > @@ -1008,7 +1008,7 @@ static inline int zone_is_near_oom(struc
> >  static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
> >  			struct scan_control *sc, int priority, int file)
> >  {
> > -	unsigned long pgmoved;
> > +	unsigned long pgmoved = 0;
> >  	int pgdeactivate = 0;
> >  	unsigned long pgscanned;
> >  	LIST_HEAD(l_hold);	/* The pages which were snipped off */
> > @@ -1036,17 +1036,32 @@ static void shrink_active_list(unsigned 
> >  		__mod_zone_page_state(zone, NR_ACTIVE_ANON, -pgmoved);
> >  	spin_unlock_irq(&zone->lru_lock);
> >  
> > +	pgmoved = 0;
> 
> didn't we just do that?

pgmoved was used in a call above.  I have gotten rid of the top
initialization instead, since it's assigned the return value from
a function.

> >  	while (!list_empty(&l_hold)) {
> >  		cond_resched();
> >  		page = lru_to_page(&l_hold);
> >  		list_del(&page->lru);
> > -		if (page_referenced(page, 0, sc->mem_cgroup))
> > -			list_add(&page->lru, &l_active);
> > -		else
> > +		if (page_referenced(page, 0, sc->mem_cgroup)) {
> > +			if (file) {
> > +				/* Referenced file pages stay active. */
> > +				list_add(&page->lru, &l_active);
> > +			} else {
> > +				/* Anonymous pages always get deactivated. */
> 
> hm.  That's going to make the machine swap like hell.  I guess I don't
> understand all this yet.

The file pages live on a separate LRU from the anon pages.  The anon
LRU will generally be scanned much slower than the file LRU, which
makes the always deactivation harmless.

> > +				list_add(&page->lru, &l_inactive);
> > +				pgmoved++;
> > +			}
> > +		} else
> >  			list_add(&page->lru, &l_inactive);
> >  	}
> >  
> >  	/*
> > +	 * Count the referenced anon pages as rotated, to balance pageout
> > +	 * scan pressure between file and anonymous pages in get_sacn_ratio.
> 
> tpyo

Fixed.

-- 
All rights reversed.
