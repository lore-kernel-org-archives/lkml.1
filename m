Return-Path: <linux-kernel-owner+w=401wt.eu-S1753007AbXIPUyf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007AbXIPUyf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 16:54:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbXIPUyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 16:54:23 -0400
Received: from gir.skynet.ie ([193.1.99.77]:39022 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753832AbXIPUyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 16:54:22 -0400
Date: Sun, 16 Sep 2007 21:54:18 +0100
To: Andrea Arcangeli <andrea@suse.de>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joern Engel <joern@logfs.org>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070916205418.GC16406@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie> <20070916185052.GG6708@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070916185052.GG6708@v2.random>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/09/07 20:50), Andrea Arcangeli didst pronounce:
> On Sun, Sep 16, 2007 at 07:15:04PM +0100, Mel Gorman wrote:
> > Except now as I've repeatadly pointed out, you have internal fragmentation
> > problems. If we went with the SLAB, we would need 16MB slabs on PowerPC for
> > example to get the same sort of results and a lot of copying and moving when
> 
> Well not sure about the 16MB number, since I'm unsure what the size of
> the ram was.

The 16MB is the size of a hugepage, the size of interest as far as I am
concerned. Your idea makes sense for large block support, but much less
for huge pages because you are incurring a cost in the general case for
something that may not be used.

There is nothing to say that both can't be done. Raise the size of
order-0 for large block support and continue trying to group the block
to make hugepage allocations likely succeed during the lifetime of the
system.

> But clearly I agree there are fragmentation issues in the
> slab too, there have always been, except they're much less severe, and
> the slab is meant to deal with that regardless of the PAGE_SIZE. That
> is not a new problem, you are introducing a new problem instead.
> 

At the risk of repeating, your approach will be adding a new and
significant dimension to the internal fragmentation problem where a
kernel allocation may fail because the larger order-0 pages are all
being pinned by userspace pages.

> We can do a lot better than slab currently does without requiring any
> defrag move-or-shrink at all.
> 
> slab is trying to defrag memory for small objects at nearly zero cost,
> by not giving pages away randomly. I thought you agreed that solving
> the slab fragmentation was going to provide better guarantees when in

It improves the probabilty of hugepage allocations working because the
blocks with slab pages can be targetted and cleared if necessary.

> another email you suggested that you could start allocating order > 0
> pages in the slab to reduce the fragmentation (to achieve most of the
> guarantee provided by config-page-shift, but while still keeping the
> order 0 at 4k for whatever reason I can't see).
> 

That suggestion was aimed at the large block support more than
hugepages. It helps large blocks because we'll be allocating and freeing
as more or less the same size. It certainly is easier to set
slub_min_order to the same size as what is needed for large blocks in
the system than introducing the necessary mechanics to allocate
pagetable pages and userspace pages from slab.

> > a suitable slab page was not available.
> 
> You ignore one other bit, when "/usr/bin/free" says 1G is free, with
> config-page-shift it's free no matter what, same goes for not mlocked
> cache. With variable order page cache, /usr/bin/free becomes mostly a
> lie as long as there's no 4k fallback (like fsblock).
> 

I'm not sure what you are getting at here. I think it would make more
sense if you said "when you read /proc/buddyinfo, you know the order-0
pages are really free for use with large blocks" with your approach.

> And most important you're only tackling on the pagecache and I/O
> performance with the inefficient I/O devices, the whole kernel has no
> cahnce to get a speedup, infact you're making the fast paths slower,
> just the opposite of config-page-shift and original Hugh's large
> PAGE_SIZE ;).
> 

As the kernel pages are all getting grouped together, there are fewer TLB
entries needed to address the kernels working set so there is a general
improvement although how much is workload

All this aside, there is nothing mutually exclusive with what you are proposing
and what grouping pages by mobility does. Your stuff can exist even if grouping
pages by mobility is in place. In fact, it'll help us by giving an important
comparison point as grouping pages by mobility can be trivially disabled with
a one-liner for the purposes of testing. If your approach is brought to being
a general solution that also helps hugepage allocation, then we can revisit
grouping pages by mobility by comparing kernels with it enabled and without.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
