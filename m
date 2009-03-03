Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbZCCNvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbZCCNvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 08:51:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbZCCNvK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 08:51:10 -0500
Received: from gir.skynet.ie ([193.1.99.77]:52996 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbZCCNvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 08:51:09 -0500
Date: Tue, 3 Mar 2009 13:51:05 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>
Cc: Lin Ming <ming.m.lin@intel.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Rik van Riel <riel@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Yanmin <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 00/19] Cleanup and optimise the page allocator V2
Message-ID: <20090303135105.GD10577@csn.ul.ie>
References: <20090226110336.GC32756@csn.ul.ie> <1235647139.16552.34.camel@penberg-laptop> <20090226112232.GE32756@csn.ul.ie> <1235724283.11610.212.camel@minggr> <20090302112122.GC21145@csn.ul.ie> <20090302113936.GJ1257@wotan.suse.de> <20090302121632.GA14217@csn.ul.ie> <20090303044239.GC3973@wotan.suse.de> <20090303082511.GA2809@csn.ul.ie> <20090303090442.GA17042@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090303090442.GA17042@wotan.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 10:04:42AM +0100, Nick Piggin wrote:
> On Tue, Mar 03, 2009 at 08:25:12AM +0000, Mel Gorman wrote:
> > On Tue, Mar 03, 2009 at 05:42:40AM +0100, Nick Piggin wrote:
> > > or if some change resulted in more cross-cpu operations then it
> > > could result in worse cache efficiency.
> > > 
> > 
> > It occured to me before sleeping last night that there could be a lot
> > of cross-cpu operations taking place in the buddy allocator itself. When
> > bulk-freeing pages, we have to examine all the buddies and merge them. In
> > the case of a freshly booted system, many of the pages of interest will be
> > within the same MAX_ORDER blocks. If multiple CPUs bulk free their pages,
> > they'll bounce the struct pages between each other a lot as we are writing
> > those cache lines. However, this would be incurring with or without my patches.
> 
> Oh yes it would definitely be a factor I think.
> 

It's on the list for a second or third pass to investigate.

>  
> > > OK, but the dynamic behaviour too. Free page A, free page B, allocate page
> > > A allocate page B etc.
> > > 
> > > The hot/cold removal would be an obvious example of what I mean, although
> > > that wasn't included in this recent patchset anyway.
> > > 
> > 
> > I get your point though, I'll keep it in mind. I've gone from plain
> > "reduce the clock cycles" to "reduce the cache misses" as if OLTP is
> > sensitive to this it has to be addressed as well.
> 
> OK cool. The patchset did look pretty good for reducing clock cycles
> though, so hopefully it turns out to be something simple.
> 

I'm hoping it is. I noticed a few oddities where we use more cache than we
need to that I cleaned up. However, the strongest possibility of being a
problem is actually the patch that removes the list-search for a page of a
given migratetype in the allocation path. The fix simplifies the allocation
path but increases the complexity of the bulk-free path by quite a bit and
increases the number of cache lines that are accessed. Worse, the fix grows
the per-cpu structure from one cache line to two on x86-64 NUMA machines
which I think is significant. I'm testing that at the moment but I might
end up dropping the patch from the first pass as a result and confine
the set to "obvious" wins.


-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
