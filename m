Return-Path: <linux-kernel-owner+w=401wt.eu-S1754588Ab0ARVGL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754588Ab0ARVGL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:06:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754520Ab0ARVGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:06:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50237 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437Ab0ARVGJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:06:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: Memory allocations in .suspend became very unreliable)
Date: Mon, 18 Jan 2010 22:06:36 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc4-rjw; KDE/4.3.3; x86_64; ; )
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-mm" <linux-mm@kvack.org>, linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <1263745267.2162.42.camel@barrios-desktop> <201001180125.59413.rjw@sisk.pl> <20100118111703.AE36.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100118111703.AE36.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201001182206.36365.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 January 2010, KOSAKI Motohiro wrote:
> > Index: linux-2.6/mm/page_alloc.c
> > ===================================================================
> > --- linux-2.6.orig/mm/page_alloc.c
> > +++ linux-2.6/mm/page_alloc.c
> > @@ -1963,10 +1963,13 @@ __alloc_pages_nodemask(gfp_t gfp_mask, u
> >  	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> >  			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
> >  			preferred_zone, migratetype);
> > -	if (unlikely(!page))
> > +	if (unlikely(!page)) {
> > +		mm_lock_suspend(gfp_mask);
> >  		page = __alloc_pages_slowpath(gfp_mask, order,
> >  				zonelist, high_zoneidx, nodemask,
> >  				preferred_zone, migratetype);
> > +		mm_unlock_suspend(gfp_mask);
> > +	}
> >  
> >  	trace_mm_page_alloc(page, order, gfp_mask, migratetype);
> >  	return page;
> 
> I think we don't need read side lock at all. generally, no lock might makes race.
> But in this case, changing gfp_allowed_mask and nvidia suspend method should be
> serialized higher level. Why the above two code need to run concurrently?

The changing of gfp_allowed_mask is serialized with the suspend of devices,
so there's no concurrency here.

I was concerned about another problem, though, which is what happens if the
suspend process runs in parallel with a memory allocation that started earlier
and happens to do some I/O.  I that case the suspend process doesn't know
about the I/O done by the mm subsystem and may disturb it in principle.

That said, perhaps that should be a concern for the block devices subsystem to
prevent such situations from happening.

So, perhaps I'll remove the reader-side lock altogether and go back to
something like the first version of the patch.

Rafael
