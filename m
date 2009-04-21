Return-Path: <linux-kernel-owner+w=401wt.eu-S1754828AbZDUIli@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754828AbZDUIli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:41:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbZDUIl3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:41:29 -0400
Received: from gir.skynet.ie ([193.1.99.77]:36157 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751899AbZDUIl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:41:28 -0400
Date: Tue, 21 Apr 2009 09:41:24 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 11/25] Calculate the cold parameter for allocation only
	once
Message-ID: <20090421084124.GD12713@csn.ul.ie>
References: <1240266011-11140-1-git-send-email-mel@csn.ul.ie> <1240266011-11140-12-git-send-email-mel@csn.ul.ie> <1240299805.771.46.camel@penberg-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1240299805.771.46.camel@penberg-laptop>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 21, 2009 at 10:43:25AM +0300, Pekka Enberg wrote:
> On Mon, 2009-04-20 at 23:19 +0100, Mel Gorman wrote:
> > GFP mask is checked for __GFP_COLD has been specified when deciding which
> > end of the PCP lists to use. However, it is happening multiple times per
> > allocation, at least once per zone traversed. Calculate it once.
> > 
> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  mm/page_alloc.c |   35 ++++++++++++++++++-----------------
> >  1 files changed, 18 insertions(+), 17 deletions(-)
> > 
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 1506cd5..51e1ded 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -1066,11 +1066,10 @@ void split_page(struct page *page, unsigned int order)
> >   */
> >  static struct page *buffered_rmqueue(struct zone *preferred_zone,
> >  			struct zone *zone, int order, gfp_t gfp_flags,
> > -			int migratetype)
> > +			int migratetype, int cold)
> >  {
> >  	unsigned long flags;
> >  	struct page *page;
> > -	int cold = !!(gfp_flags & __GFP_COLD);
> >  	int cpu;
> >  
> >  again:
> 
> Is this a measurable win? And does gcc inline all this nicely or does
> this change actually increase kernel text size?
> 

It gets inlined later so it shouldn't affect code size as part of the overall
patchset although it probably adds a small bit here. It showed up on profiles
as a place where cache misses were hitting hard although it's probable that
the misses are being incurred anyway but not as obvious due to sampling.

The win overall is small but it's the same mask that is applied to gfp_mask
over and over again and could be considered a loop invariant in a weird sort
of way.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
