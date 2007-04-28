Return-Path: <linux-kernel-owner+w=401wt.eu-S1756473AbXD2NhL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756473AbXD2NhL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 09:37:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbXD2NhK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 09:37:10 -0400
Received: from amsfep17-int.chello.nl ([213.46.243.15]:36078 "EHLO
	amsfep12-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756473AbXD2NhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 09:37:06 -0400
Subject: Re: [00/17] Large Blocksize Support V3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <20070428015555.73b50b8c.akpm@linux-foundation.org>
References: <20070426190438.3a856220.akpm@linux-foundation.org>
	 <20070427022731.GF65285596@melbourne.sgi.com>
	 <20070426195357.597ffd7e.akpm@linux-foundation.org>
	 <20070427042046.GI65285596@melbourne.sgi.com>
	 <20070426221528.655d79cb.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704262239580.4758@schroedinger.engr.sgi.com>
	 <20070426235542.bad7035a.akpm@linux-foundation.org>
	 <Pine.LNX.4.64.0704270007100.5388@schroedinger.engr.sgi.com>
	 <20070427002640.22a71d06.akpm@linux-foundation.org>
	 <20070427163620.GI32602149@melbourne.sgi.com>
	 <20070427173432.GJ32602149@melbourne.sgi.com>
	 <20070427121108.9ee05710.akpm@linux-foundation.org>
	 <4632A6DF.7080301@yahoo.com.au> <1177747448.28223.26.camel@twins>
	 <20070428012251.fae10a71.akpm@linux-foundation.org>
	 <1177749176.28223.34.camel@twins>
	 <20070428015555.73b50b8c.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 28 Apr 2007 11:36:03 +0200
Message-Id: <1177752979.5232.15.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 01:55 -0700, Andrew Morton wrote:
> On Sat, 28 Apr 2007 10:32:56 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Sat, 2007-04-28 at 01:22 -0700, Andrew Morton wrote:
> > > On Sat, 28 Apr 2007 10:04:08 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > > 
> > > > > 
> > > > > The other thing is that we can batch up pagecache page insertions for bulk
> > > > > writes as well (that is. write(2) with buffer size > page size). I should
> > > > > have a patch somewhere for that as well if anyone interested.
> > > > 
> > > > Together with the optimistic locking from my concurrent pagecache that
> > > > should bring most of the gains:
> > > > 
> > > > sequential insert of 8388608 items:
> > > > 
> > > > CONFIG_RADIX_TREE_CONCURRENT=n
> > > > 
> > > > [ffff81007d7f60c0] insert 0 done in 15286 ms
> > > > 
> > > > CONFIG_RADIX_TREE_OPTIMISTIC=y
> > > > 
> > > > [ffff81006b36e040] insert 0 done in 3443 ms
> > > > 
> > > > only 4.4 times faster, and more scalable, since we don't bounce the
> > > > upper level locks around.
> > > 
> > > I'm not sure what we're looking at here.  radix-tree changes?  Locking
> > > changes?  Both?
> > 
> > Both, the radix tree is basically node locked, and all modifying
> > operations are taught to node lock their way around the radix tree.
> > This, as Christoph pointed out, will suck on SMP because all the node
> > locks will bounce around like mad.
> > 
> > So what I did was couple that with an 'optimistic' RCU lookup of the
> > highest node that _needs_ to be locked for the operation to succeed,
> > lock that node, verify it is indeed still the node we need, and proceed
> > as normal (node locked). This avoid taking most/all of the upper level
> > node locks; esp for insert, which typically only needs one lock.
> 
> hm.  Maybe if we were taking the lock once per N pages rather than once per
> page, we could avoid such trickiness.

For insertion, maybe, not all insertion is coupled with strong
readahead.

But this also work for the other modifiers, like radix_tree_tag_set(),
which is typically called on single pages.

The whole idea is to entirely remove mapping->tree_lock, and serialize
the pagecache on page level.

> > > If we have a whole pile of pages to insert then there are obvious gains
> > > from not taking the lock once per page (gang insert).  But I expect there
> > > will also be gains from not walking down the radix tree once per page too:
> > > walk all the way down and populate all the way to the end of the node.
> > 
> > Yes, it will be even faster if we could batch insert a whole leaf node.
> > That would save 2^6 - 1 tree traversals and lock/unlock cycles.
> > Certainly not unwanted.
> > 
> > > The implementation could get a bit tricky, handling pages which a racer
> > > instantiated when we dropped the lock, and suitably adjusting ->index.  Not
> > > rocket science though.
> > 
> > *nod*
> > 
> > > The depth of the radix tree matters (ie, the file size).  'twould be useful
> > > to always describe the tree's size when publishing microbenchmark results
> > > like this.
> > 
> > Right, this was with two such sequences of 2^23, so 2^24 elements in
> > total, with 0 offset, which gives: 24/6 = 4 levels.
> 
> Where an element would be a page, so we're talking about a 64GB file with
> 4k pagesize?
> 
> Gosh that tree has huge fanout.  We fiddled around a bit with
> RADIX_TREE_MAP_SHIFT in the early days.  Changing it by quite large amounts
> didn't appear to have much effect on anything, actually.

It might make sense to decrease it a bit with this work, it gives more
opportunity to parallelize.

Currently the tree_lock is pretty much the most expensive operation in
this area, it happily bounces around the machine.

The lockless work showed there is lots of room for improvement here.

> btw, regarding __do_page_cache_readahead(): that function is presently
> optimised for file rereads - if all pages are present it'll only take the
> lock once.  The first version of it was optimised the other way around - it
> took the lock once for uncached file reads (no pages present), but once per
> page for rereads.  I made this change because Anton Blanchard had some
> workload which hurt, and we figured that rereads are the common case, and
> uncached reads are limited by disk speed anyway.
> 
> Thinking about it, I guess that was a correct decision, but we did
> pessimise these read-a-gargantuan-file cases.
> 
> But we could actually implement both flavours and pick the right one to
> call based upon the hit-rate metrics which the readahead code is
> maintaining (or add new ones).
> 
> Of course, gang-populate would be better.

I could try to do a gang insert operation on top of my concurrent
pagecache tree.

