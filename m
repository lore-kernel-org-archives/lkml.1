Return-Path: <linux-kernel-owner+w=401wt.eu-S1764205AbYFGSnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764205AbYFGSnl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 14:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760479AbYFGSnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 14:43:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42361 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761775AbYFGSnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 14:43:32 -0400
Date: Sat, 7 Jun 2008 14:42:45 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, lee.schermerhorn@hp.com,
       kosaki.motohiro@jp.fujitsu.com, clameter@sgi.com
Subject: Re: [PATCH -mm 02/25] Use an indexed array for LRU variables
Message-ID: <20080607144245.03b34d49@bree.surriel.com>
In-Reply-To: <20080606180426.89989a07.akpm@linux-foundation.org>
References: <20080606202838.390050172@redhat.com>
	<20080606202858.449902618@redhat.com>
	<20080606180426.89989a07.akpm@linux-foundation.org>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jun 2008 18:04:26 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> I would have spat the dummy at pointless churn and code uglification
> but I see that we end up with five LRU lsits so ho hum.

> >  	/* Fields commonly accessed by the page reclaim scanner */
> >  	spinlock_t		lru_lock;	
> > -	struct list_head	active_list;
> > -	struct list_head	inactive_list;
> > -	unsigned long		nr_scan_active;
> > -	unsigned long		nr_scan_inactive;
> > +	struct list_head	list[NR_LRU_LISTS];
> > +	unsigned long		nr_scan[NR_LRU_LISTS];
> 
> It'd be a little cache-friendlier to lay this out as
> 
> 	struct {
> 		struct list_head list;
> 		unsigned long nr_scan;
> 	} lru_stuff[NR_LRU_LISTS];

OK, done.  As zone.lru though for brevity.

> > +++ linux-2.6.26-rc2-mm1/include/linux/mm_inline.h	2008-05-23 14:21:33.000000000 -0400
> > @@ -1,40 +1,51 @@
> >  static inline void
> > +add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l)
> > +{
> > +	list_add(&page->lru, &zone->list[l]);
> > +	__inc_zone_state(zone, NR_INACTIVE + l);
> 
>                                ^ that's a bug, isn't it?
> 
> oh, no it isn't.
> 
> Can we rename NR_INACTIVE?  Maybe VMSCAN_BASE or something?

I turned it into NR_LRU_BASE, since everything in zone_stat_item
starts with NR_

enum zone_stat_item {
        /* First 128 byte cacheline (assuming 64 bit words) */
        NR_FREE_PAGES,
        NR_LRU_BASE,
        NR_INACTIVE = NR_LRU_BASE, /* must match order of LRU_[IN]ACTIVE */
        NR_ACTIVE,      /*  "     "     "   "       "         */

> > -			if (PageActive(page))
> > -				add_page_to_active_list(zone, page);
> > -			else
> > -				add_page_to_inactive_list(zone, page);
> > +			add_page_to_lru_list(zone, page, PageActive(page));
> 
> urgh.  the third arg to add_page_to_lru_list() is an `enum lru_list'
> and here we are secretly coercing PageActive()'s boolean return into a
> just-happens-to-be-right `enum lru_list'.
> 
> That's pretty nasty?

I've pulled page_lru() back from patch 03/25 into 02/25 and
will use that.
 
-- 
All rights reversed.
