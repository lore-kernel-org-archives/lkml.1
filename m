Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXD1IdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXD1IdE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 04:33:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbXD1IdC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 04:33:02 -0400
Received: from amsfep19-int.chello.nl ([213.46.243.16]:55144 "EHLO
	amsfep11-int.chello.nl" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753225AbXD1IdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 04:33:00 -0400
Subject: Re: [00/17] Large Blocksize Support V3
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, David Chinner <dgc@sgi.com>,
       Christoph Lameter <clameter@sgi.com>, linux-kernel@vger.kernel.org,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
In-Reply-To: <20070428012251.fae10a71.akpm@linux-foundation.org>
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
Content-Type: text/plain
Date: Sat, 28 Apr 2007 10:32:56 +0200
Message-Id: <1177749176.28223.34.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-28 at 01:22 -0700, Andrew Morton wrote:
> On Sat, 28 Apr 2007 10:04:08 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > > 
> > > The other thing is that we can batch up pagecache page insertions for bulk
> > > writes as well (that is. write(2) with buffer size > page size). I should
> > > have a patch somewhere for that as well if anyone interested.
> > 
> > Together with the optimistic locking from my concurrent pagecache that
> > should bring most of the gains:
> > 
> > sequential insert of 8388608 items:
> > 
> > CONFIG_RADIX_TREE_CONCURRENT=n
> > 
> > [ffff81007d7f60c0] insert 0 done in 15286 ms
> > 
> > CONFIG_RADIX_TREE_OPTIMISTIC=y
> > 
> > [ffff81006b36e040] insert 0 done in 3443 ms
> > 
> > only 4.4 times faster, and more scalable, since we don't bounce the
> > upper level locks around.
> 
> I'm not sure what we're looking at here.  radix-tree changes?  Locking
> changes?  Both?

Both, the radix tree is basically node locked, and all modifying
operations are taught to node lock their way around the radix tree.
This, as Christoph pointed out, will suck on SMP because all the node
locks will bounce around like mad.

So what I did was couple that with an 'optimistic' RCU lookup of the
highest node that _needs_ to be locked for the operation to succeed,
lock that node, verify it is indeed still the node we need, and proceed
as normal (node locked). This avoid taking most/all of the upper level
node locks; esp for insert, which typically only needs one lock.

> If we have a whole pile of pages to insert then there are obvious gains
> from not taking the lock once per page (gang insert).  But I expect there
> will also be gains from not walking down the radix tree once per page too:
> walk all the way down and populate all the way to the end of the node.

Yes, it will be even faster if we could batch insert a whole leaf node.
That would save 2^6 - 1 tree traversals and lock/unlock cycles.
Certainly not unwanted.

> The implementation could get a bit tricky, handling pages which a racer
> instantiated when we dropped the lock, and suitably adjusting ->index.  Not
> rocket science though.

*nod*

> The depth of the radix tree matters (ie, the file size).  'twould be useful
> to always describe the tree's size when publishing microbenchmark results
> like this.

Right, this was with two such sequences of 2^23, so 2^24 elements in
total, with 0 offset, which gives: 24/6 = 4 levels.

