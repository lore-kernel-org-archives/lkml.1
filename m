Return-Path: <linux-kernel-owner+w=401wt.eu-S1751503AbZJPWcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbZJPWcc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 18:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZJPWcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 18:32:32 -0400
Received: from gir.skynet.ie ([193.1.99.77]:35941 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911AbZJPWcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 18:32:31 -0400
Date: Fri, 16 Oct 2009 23:32:37 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, stable <stable@kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       Frans Pop <elendil@planet.nl>,
       reinette chatre <reinette.chatre@intel.com>,
       Kalle Valo <kalle.valo@iki.fi>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Karol Lewandowski <karol.k.lewandowski@gmail.com>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/2] page allocator: Direct reclaim should always obey
	watermarks
Message-ID: <20091016223237.GE32397@csn.ul.ie>
References: <1255689446-3858-1-git-send-email-mel@csn.ul.ie> <1255689446-3858-3-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.00.0910161204140.21328@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0910161204140.21328@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 16, 2009 at 12:07:07PM -0700, David Rientjes wrote:
> On Fri, 16 Oct 2009, Mel Gorman wrote:
> 
> > ALLOC_NO_WATERMARKS should be cleared when trying to allocate from the
> > free-lists after a direct reclaim. If it's not, __GFP_NOFAIL allocations
> > from a process that is exiting can ignore watermarks. __GFP_NOFAIL is not
> > often used but the journal layer is one of those places. This is suspected of
> > causing an increase in the number of GFP_ATOMIC allocation failures reported.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  mm/page_alloc.c |    3 ++-
> >  1 files changed, 2 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index dfa4362..a3e5fed 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1860,7 +1860,8 @@ rebalance:
> >  	page = __alloc_pages_direct_reclaim(gfp_mask, order,
> >  					zonelist, high_zoneidx,
> >  					nodemask,
> > -					alloc_flags, preferred_zone,
> > +					alloc_flags & ~ALLOC_NO_WATERMARKS,
> > +					preferred_zone,
> >  					migratetype, &did_some_progress);
> >  	if (page)
> >  		goto got_pg;
> 
> I don't get it.  __alloc_pages_high_priority() will already loop 
> indefinitely if ALLOC_NO_WATERMARKS is set and its a __GFP_NOFAIL 
> allocation.  How do we even reach this code in such a condition?
> 

Frans, you reported that both patches in combination reduced the number
of failures. Was it in fact just the kswapd change that made the
difference?

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
