Return-Path: <linux-kernel-owner+w=401wt.eu-S933663AbXDZIkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933663AbXDZIkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 04:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933662AbXDZIkT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 04:40:19 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56304 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933666AbXDZIkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 04:40:15 -0400
Date: Thu, 26 Apr 2007 09:40:12 +0100
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       clameter@sgi.com, linux-kernel@vger.kernel.org,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [00/17] Large Blocksize Support V3
Message-ID: <20070426084012.GA26926@skynet.ie>
References: <20070424222105.883597089@sgi.com> <m1hcr3oi0m.fsf@ebiederm.dsl.xmission.com> <46303A98.9000605@yahoo.com.au> <20070426063830.GE32602149@melbourne.sgi.com> <46304B9E.5070604@yahoo.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <46304B9E.5070604@yahoo.com.au>
User-Agent: Mutt/1.5.9i
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (26/04/07 16:50), Nick Piggin didst pronounce:
> David Chinner wrote:
> >On Thu, Apr 26, 2007 at 03:37:28PM +1000, Nick Piggin wrote:
> >
> >>I think starting with the assumption that we _want_ to use higher order
> >>allocations, and then creating all this complexity around that is not a
> >>good one, and if we start introducing things that _require_ significant
> >>higher order allocations to function then it is a nasty thing for
> >>robustness.
> >
> >
> >>From my POV, we started with the problem of how to provide atomic
> >access to a multi-page block in the page cache. For example, we want
> >to lock the filesystem block and prevent any updates to it, so we
> >need to lock all the pages in it. And then when we write them back,
> >they all need to change state at the same time, and they all need to
> >have their radix tree tags changed at the same time, the problem of
> >mapping them to disk, getting writeback to do block aligned and
> >sized writeback chunks, and so on.
> >
> >And then there's the problem that most hardware is limited to 128
> >s/g entries and that means 128 non-contiguous pages in memory is the
> >maximum I/O size we can issue to these devices. We have RAID arrays
> >that go twice as fast if we can send them 1MB I/Os instead of 512k
> >I/Os and that means we need contiguous pages to be handled to the
> >devices....
> >
> >All of these things require some aggregating structure to
> >co-ordinate. In times gone by on other OSs, this has been done with
> >a buffer cache, but Linux got rid of that long ago and we don't want
> >to reintroduce one. We can't use buffer heads - they can only point
> >to one page. So what do we do?
> 
> Improving the buffer layer would be a good way. Of course, that is
> a long and difficult task, so nobody wants to do it.
> 
> 
> >That's where compound pages are so nice - they solve all of these
> >problems with only a very small amount of code perturbation and they
> >don't change any algorithms or fundamental design of the OS at all.
> >
> >We don't have to rewrite filesystems to support this. We don't have
> >to redesign the VM to support this. We don't have to do very much
> >work to the block layer and drivers to make this work.
> 
> Fragmentation is the problem. The anti-frag patches don't actually
> guarantee anything about fragmentation, and even if they did, then

The grouping pages by mobility do not guarantee anything but the memory
partition (kernelcore= boot parameter) does give hard guarantees about
the amount of memory that is "movable". Of course, the partition requires
configuration at boot-time so it's less than ideal but it does give hard
guarantees.

> it takes more effort to actually find and reclaim higher order
> pages (even after the lumpy reclaim thing). So we've redesigned
> the page allocator and page reclaim and still don't have something
> that you should rely on without fallbacks.
> 
> 
> >FWIW, if you want 32 bit machines to support larger than 16TB
> >devices, you need high order page indexing in the page cache....
> 
> How about a 64-bit pgoff_t and radix-tree key? Or larger PAGE_SIZE?
> 

Larger page size can result in wastage for small files and there is no
guarantee that the hardware supports the large page size so you now have to
deal with inserting pages into PTEs that are smaller than PAGE_SIZE.

> 
> >>I am working now and again on some code to do this, it is a big job but
> >>I think it is the right way to do it. But it would take a long time to
> >>get stable and supported by filesystems...
> >
> >
> >Compared to a method that requires almost no change to the
> >filesystems that want to support large block sizes?
> 
> Luckily we have filesystem maintainers who want to support larger
> block sizes ;)
> 
> 
> >>>That would make the choice of using larger order pages (essentially
> >>>increasing PAGE_SIZE) something that can be investigated in parallel.
> >>
> >>I agree that hardware inefficiencies should be handled by increasing
> >>PAGE_SIZE (not making PAGE_CACHE_SIZE > PAGE_SIZE) at the arch level.
> >
> >
> >And what do we do for arches that can't do multiple page sizes, only
> >only have a limited and mostly useless set of page sizes to choose
> >from?
> 
> Well, for those architectures (and this would solve your large block
> size and 16TB pagecache size without any core kernel changes), you
> can manage 1<<order hardware ptes as a single Linux pte. There is
> nothing that says you must implement PAGE_SIZE as a single TLB sized
> page.

Indeed but then you have to deal with internal fragmentation 
for pages-larger-than-TLB-page. I'm not saying it's wrong but it does
come with it's own set of issues.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
