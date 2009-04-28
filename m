Return-Path: <linux-kernel-owner+w=401wt.eu-S1761622AbZD1SgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761622AbZD1SgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:36:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZD1SgH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:36:07 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35573 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633AbZD1SgF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:36:05 -0400
Date: Tue, 28 Apr 2009 19:36:01 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Hugh Dickins <hugh@veritas.com>
Cc: Christoph Lameter <cl@linux.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH] Properly account for freed pages in free_pages_bulk()
	and when allocating high-order pages in buffered_rmqueue()
Message-ID: <20090428183601.GC18893@csn.ul.ie>
References: <1240408407-21848-1-git-send-email-mel@csn.ul.ie> <1240819119.2567.884.camel@ymzhang> <20090427143845.GC912@csn.ul.ie> <1240883957.2567.886.camel@ymzhang> <20090428103159.GB23540@csn.ul.ie> <alpine.DEB.1.10.0904281236350.21913@qirst.com> <20090428165129.GA18893@csn.ul.ie> <Pine.LNX.4.64.0904281810240.30878@blonde.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904281810240.30878@blonde.anvils>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 06:15:30PM +0100, Hugh Dickins wrote:
> On Tue, 28 Apr 2009, Mel Gorman wrote:
> > On Tue, Apr 28, 2009 at 12:37:22PM -0400, Christoph Lameter wrote:
> > > On Tue, 28 Apr 2009, Mel Gorman wrote:
> > > 
> > > > @@ -1151,6 +1151,7 @@ again:
> > > >  	} else {
> > > >  		spin_lock_irqsave(&zone->lock, flags);
> > > >  		page = __rmqueue(zone, order, migratetype);
> > > > +		__mod_zone_page_state(zone, NR_FREE_PAGES, -(1UL << order));
> > > >  		spin_unlock(&zone->lock);
> > > >  		if (!page)
> > > >  			goto failed;
> > > 
> > > __mod_zone_page_state takes an signed integer argument. Not sure what is
> > > won by the UL suffix here.
> > > 
> > 
> > Matches other call sites such as in __offline_isolated_pages(), habit when
> > using shifts like this and matches other locations, paranoia, doesn't hurt.
> 
> Well, not a big deal, but I'd say that it does hurt: by wasting people's
> time (mine!), wondering what that "UL" is for - I'd have had to ask, if
> Christoph hadn't cleared this up first (thank you).  And elsewhere,
> you're using an int << order to update NR_FREE_PAGES, so I don't see
> the consistency argument.
> 

Ok, I'll concede things are not super-consistent. In this case, I felt it
"didn't hurt" but I didn't take into account that it needs to be worked out
each time and I posted a second revision that should be clearer.

As an aside, in other places order changes from being signed in some places
to being unsigned in others. There is probably a pass in there just for
dealing with this sort of inconsistency.

Thanks

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
