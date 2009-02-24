Return-Path: <linux-kernel-owner+w=401wt.eu-S1756423AbZBXNdM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbZBXNdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 08:33:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZBXNc4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 08:32:56 -0500
Received: from gir.skynet.ie ([193.1.99.77]:34973 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754565AbZBXNc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 08:32:56 -0500
Date: Tue, 24 Feb 2009 13:32:53 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lin Ming <ming.m.lin@intel.com>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>
Subject: Re: [PATCH 11/20] Inline get_page_from_freelist() in the fast-path
Message-ID: <20090224133253.GB26239@csn.ul.ie>
References: <1235344649-18265-1-git-send-email-mel@csn.ul.ie> <1235344649-18265-12-git-send-email-mel@csn.ul.ie> <200902240232.39140.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <200902240232.39140.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 24, 2009 at 02:32:37AM +1100, Nick Piggin wrote:
> On Monday 23 February 2009 10:17:20 Mel Gorman wrote:
> > In the best-case scenario, use an inlined version of
> > get_page_from_freelist(). This increases the size of the text but avoids
> > time spent pushing arguments onto the stack.
> 
> I'm quite fond of inlining ;) But it can increase register pressure as
> well as icache footprint as well. x86-64 isn't spilling a lot more
> registers to stack after these changes, is it?
> 

I didn't actually check that closely so I don't know for sure. Is there a
handier way of figuring it out than eyeballing the assembly? In the end
I dropped the inline of this function anyway. It means the patches
reduce rather than increase text size which is a bit more clear-cut.

> Also,
> 
> 
> > @@ -1780,8 +1791,8 @@ __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int
> > order, if (!preferred_zone)
> >  		return NULL;
> >
> > -	/* First allocation attempt */
> > -	page = get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> > +	/* First allocation attempt. Fastpath uses inlined version */
> > +	page = __get_page_from_freelist(gfp_mask|__GFP_HARDWALL, nodemask, order,
> >  			zonelist, high_zoneidx, ALLOC_WMARK_LOW|ALLOC_CPUSET,
> >  			preferred_zone, migratetype);
> >  	if (unlikely(!page))
> 
> I think in a common case where there is background reclaim going on,
> it will be quite common to fail this, won't it? (I haven't run
> statistics though).
> 

Good question. It would be common to fail when background reclaim has
been kicked off for the first time but once we are over the low
watermark, background reclaim will continue even though we are
allocating pages. I recall that ther eis a profile likely/unlikely debug
option. I dont' recall using it before but now might be a good time to
fire it up.

> In which case you will get extra icache footprint. What speedup does
> it give in the cache-hot microbenchmark case?
> 

I wasn't measuring with a microbenchmark at the time of writing so I don't
know. I was going entirely by profile counts running kernbench and the
time spent running the benchmark.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
