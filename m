Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbXIQKNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbXIQKNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 06:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbXIQKNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 06:13:12 -0400
Received: from gir.skynet.ie ([193.1.99.77]:40593 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752973AbXIQKNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 06:13:10 -0400
Date: Mon, 17 Sep 2007 11:13:07 +0100
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
Message-ID: <20070917101307.GD25706@skynet.ie>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <20070911121225.GE13132@lazybastard.org> <20070915014449.4f9cdb51.akpm@linux-foundation.org> <87ir6c3z2l.fsf@informatik.uni-tuebingen.de> <20070915155100.GA21861@v2.random> <20070916181504.GB16406@skynet.ie> <20070916185052.GG6708@v2.random> <20070916205418.GC16406@skynet.ie> <20070916213126.GH6708@v2.random>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070916213126.GH6708@v2.random>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (16/09/07 23:31), Andrea Arcangeli didst pronounce:
> On Sun, Sep 16, 2007 at 09:54:18PM +0100, Mel Gorman wrote:
> > The 16MB is the size of a hugepage, the size of interest as far as I am
> > concerned. Your idea makes sense for large block support, but much less
> > for huge pages because you are incurring a cost in the general case for
> > something that may not be used.
> 
> Sorry for the misunderstanding, I totally agree!
> 

Great. It's clear that we had different use cases in mind when we were
poking holes in each approach.

> > There is nothing to say that both can't be done. Raise the size of
> > order-0 for large block support and continue trying to group the block
> > to make hugepage allocations likely succeed during the lifetime of the
> > system.
> 
> Sure, I completely agree.
> 
> > At the risk of repeating, your approach will be adding a new and
> > significant dimension to the internal fragmentation problem where a
> > kernel allocation may fail because the larger order-0 pages are all
> > being pinned by userspace pages.
> 
> This is exactly correct, some memory will be wasted. It'll reach 0
> free memory more quickly depending on which kind of applications are
> being run.
> 

I look forward to seeing how you deal with it. When/if you get to trying
to move pages out of slabs, I suggest you take a look at the Memory
Compaction patches or the memory unplug patches for simple examples of
how to use  page migration.

> > It improves the probabilty of hugepage allocations working because the
> > blocks with slab pages can be targetted and cleared if necessary.
> 
> Agreed.
> 
> > That suggestion was aimed at the large block support more than
> > hugepages. It helps large blocks because we'll be allocating and freeing
> > as more or less the same size. It certainly is easier to set
> > slub_min_order to the same size as what is needed for large blocks in
> > the system than introducing the necessary mechanics to allocate
> > pagetable pages and userspace pages from slab.
> 
> Allocating userpages from slab in 4k chunks with a 64k PAGE_SIZE is
> really complex indeed. I'm not planning for that in the short term but
> it remains a possibility to make the kernel more generic. Perhaps it
> could worth it...
> 

Perhaps.

> Allocating ptes from slab is fairly simple but I think it would be
> better to allocate ptes in PAGE_SIZE (64k) chunks and preallocate the
> nearby ptes in the per-task local pagetable tree, to reduce the number
> of locks taken and not to enter the slab at all for that.

It runs the risk of pinning up to 60K of data per task that is unusable for
any other purpose. On average, it'll be more like 32K but worth keeping
in mind.

> Infact we
> could allocate the 4 levels (or anyway more than one level) in one
> single alloc_pages(0) and track the leftovers in the mm (or similar).
> 
> > I'm not sure what you are getting at here. I think it would make more
> > sense if you said "when you read /proc/buddyinfo, you know the order-0
> > pages are really free for use with large blocks" with your approach.
> 
> I'm unsure who reads /proc/buddyinfo (that can change a lot and that
> is not very significant information if the vm can defrag well inside
> the reclaim code),

I read it although as you say, it's difficult to know what will happen if
you try and reclaim memory. It's why there is also a /proc/pagetypeinfo so
one can see the number of movable blocks that exist. That leads to better
guessing. In -mm, you can also see the number of mixed blocks but that will
not be available in mainline.

> but it's not much different and it's more about
> knowing the real meaning of /proc/meminfo, freeable (unmapped) cache,
> anon ram, and free memory.
> 
> The idea is that to succeed an mmap over a large xfs file with
> mlockall being invoked, those largepages must become available or
> it'll be oom despite there are still 512M free... I'm quite sure
> admins will gets confused if they get oom killer invoked with lots of
> ram still free.
> 
> The overcommit feature will also break, just to make an example (so
> much for overcommit 2 guaranteeing -ENOMEM retvals instead of oom
> killage ;).
> 
> > All this aside, there is nothing mutually exclusive with what you are proposing
> > and what grouping pages by mobility does. Your stuff can exist even if grouping
> > pages by mobility is in place. In fact, it'll help us by giving an important
> > comparison point as grouping pages by mobility can be trivially disabled with
> > a one-liner for the purposes of testing. If your approach is brought to being
> > a general solution that also helps hugepage allocation, then we can revisit
> > grouping pages by mobility by comparing kernels with it enabled and without.
> 
> Yes, I totally agree. It sounds worthwhile to have a good defrag logic
> in the VM. Even allocating the kernel stack in today kernels should be
> able to benefit from your work. It's just comparing a fork() failure
> (something that will happen with ulimit -n too and that apps must be
> able to deal with) with an I/O failure that worries me a bit.

I agree here with the IO failure. It's why I've been saying that Nick's
approach is what was needed to make large blocks a fully supported
feature. Your approach may work out as well. While those are in development,
Christoph's approach will let us know how regularly these failures actually
occur so we'll know in advance how often the slower paths in both Nick's
and your approach will be exercised.

> I'm
> quite sure a db failing I/O will not recover too nicely. If fork fails
> that's most certainly ok... at worst a new client won't be able to
> connect and he can retry later. Plus order 1 isn't really a big deal,
> you know the probability to succeeds decreases exponentially with the
> order.
> 

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
