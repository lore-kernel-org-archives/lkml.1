Return-Path: <linux-kernel-owner+w=401wt.eu-S1030778AbXD1TTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030778AbXD1TTv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031190AbXD1TTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:19:48 -0400
Received: from holomorphy.com ([66.93.40.71]:53304 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030778AbXD1TTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:19:40 -0400
Date: Sat, 28 Apr 2007 12:19:56 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070428191956.GY31925@holomorphy.com>
References: <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com> <20070427002640.22a71d06.akpm@linux-foundation.org> <20070427163620.GI32602149@melbourne.sgi.com> <20070427173432.GJ32602149@melbourne.sgi.com> <20070427121108.9ee05710.akpm@linux-foundation.org> <4632A6DF.7080301@yahoo.com.au> <1177747448.28223.26.camel@twins> <20070428012251.fae10a71.akpm@linux-foundation.org> <20070428140907.GU19966@holomorphy.com> <20070428112640.5b92b995.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428112640.5b92b995.akpm@linux-foundation.org>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007 07:09:07 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> The gang allocation affair would may also want to make the calls into
>> the page allocator batched. For instance, grab enough compound pages to
>> build the gang under the lock, since we're going to blow the per-cpu
>> lists with so many pages, then break the compound pages up outside the
>> zone->lock.

On Sat, Apr 28, 2007 at 11:26:40AM -0700, Andrew Morton wrote:
> Sure, but...
> Allocating a single order-3 (say) page _is_ a form of batching

Sorry, I should clarify here. If we fall back, we may still want to
get all the pages together. For instance, if we can't get an order 3,
grab an order 2, then if a second order 2 doesn't pan out, an order
1, and so on, until as many pages as requested are allocated or an
allocation failure occurs.

Also, passing around the results linked together into a list vs.
e.g. filling an array has the advantage of splice operations under
the lock, though arrays can catch up for the most part if their
elements are allowed to vary in terms of the orders of the pages.


On Sat, Apr 28, 2007 at 11:26:40AM -0700, Andrew Morton wrote:
> We don't want compound pages here: just higher-order ones
> Higher-order allocations bypass the per-cpu lists

Sorry again. I conflated the two, and failed to take the use of
higher-order pages as an assumption as I should've.


On Sat, 28 Apr 2007 07:09:07 -0700 William Lee Irwin III <wli@holomorphy.com> wrote:
>> I think it'd be good to have some corresponding tactics for freeing as
>> well.

On Sat, Apr 28, 2007 at 11:26:40AM -0700, Andrew Morton wrote:
> hm, hadn't thought about that - would need to peek at contiguous pages in
> the pagecache and see if we can gang-free them as higher-order pages.
> The place to do that is perhaps inside the per-cpu magazines: it's more
> general.  Dunno if it would net advantageous though.

What I was hoping for was an interface to hand back groups of pages at
a time which would then do contiguity detection if advantageous, and if
not, just assembles the pages into something that can be slung around
more quickly under the lock. Essentially doing small bits of the buddy
system's work for it outside the lock. Arrays make more sense here, as
it's relatively easy to do contiguity detection by heapifying them
and dequeueing in order in preparation for work under the lock.

There is an issue in that reclaim is not organized in such a fashion as
to issue calls to such freeing functions. An implicit effect of this
sort could be achieved by maintaining the pcp lists as an array-based
deque via duelling heap arrays with reversed comparators if an
appropriate deque structure for sets as small as the pcp arrays can't
be dredged up, or an auxiliary adjacency detection structure.

I'm skeptical, however, that the contiguity gains will compensate for
the CPU required to do such with the pcp lists. I think rather that
users of an interface for likely-contiguous batched freeing would be
better to arrange provided reclaim in such manners makes sense from
the standpoint of IO. Gang freeing in general could do adjacency
detection without disturbing the characteristics of the pcp lists,
though it, too, may not be productive without some specific notion
of whether contiguity is likely. For instance, quicklist_trim()
could readily use gang freeing, but it's not likely to have much in
the way of contiguity.

These sorts of algorithmic concerns are probably not quite as pressing
as the general notion of trying to establish some sort of contiguity,
so I'm by no means insistent on any of this.


-- wli
