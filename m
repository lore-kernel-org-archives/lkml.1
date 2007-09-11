Return-Path: <linux-kernel-owner+w=401wt.eu-S1759509AbXIKQrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759509AbXIKQrV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 12:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbXIKQrK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 12:47:10 -0400
Received: from mx2.suse.de ([195.135.220.15]:59321 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbXIKQrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 12:47:09 -0400
Date: Tue, 11 Sep 2007 18:47:02 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, torvalds@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>, Mel Gorman <mel@skynet.ie>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911164702.GD10831@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <1189524967.32731.58.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189524967.32731.58.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On Tue, Sep 11, 2007 at 04:36:07PM +0100, Mel Gorman wrote:
> that increasing the pagesize like what Andrea suggested would lead to
> internal fragmentation problems. Regrettably we didn't discuss Andrea's

The config_page_shift guarantees the kernel stacks or whatever not
defragmentable allocation other allocation goes into the same 64k "not
defragmentable" page. Not like with SGI design that a 8k kernel stack
could be allocated in the first 64k page, and then another 8k stack
could be allocated in the next 64k page, effectively pinning all 64k
pages until Nick worst case scenario triggers.

What I said at the VM summit is that your reclaim-defrag patch in the
slub isn't necessarily entirely useless with config_page_shift,
because the larger the software page_size, the more partial pages we
could find in the slab, so to save some memory if there are tons of
pages very partially used, we could free some of them.

But the whole point is that with the config_page_shift, Nick's worst
case scenario can't happen by design regardless of defrag or not
defrag. While it can _definitely_ happen with SGI design (regardless
of any defrag thing). We can still try to save some memory by
defragging the slab a bit, but it's by far *not* required with
config_page_shift. No defrag at all is required infact.

Plus there's a cost in defragging and freeing cache... the more you
need defrag, the slower the kernel will be.

> approach in depth.

Well it wasn't my fault if we didn't discuss it in depth though. I
tried to discuss it in all possible occasions where I was suggested to
talk about it and where it was somewhat on topic. Given I wasn't even
invited at the KS, I felt it would not be appropriate for me to try to
monopolize the VM summit according to my agenda. So I happily listened
to what the top kernel developers are planning ;), while giving
some hints on what I think the right direction is instead.

> I *thought* that the end conclusion was that we would go with

Frankly I don't care what the end conclusion was.

> Christoph's approach pending two things being resolved;
> 
> o mmap() support that we agreed on is good

Let's see how good the mmap support for variable order page size will
work after the 2 weeks...

> o A clear statement, with logging maybe for users that mounted a large 
>   block filesystem that it might blow up and they get to keep both parts
>   when it does. Basically, for now it's only suitable in specialised
>   environments.

Yes, but perhaps you missed that such printk is needed exactly to
provide proof that SGI design is the wrong way and it needs to be
dumped. If that printk ever triggers it means you were totally wrong.

> I also thought there was an acknowledgement that long-term, fs-block was
> the way to go - possibly using contiguous pages optimistically instead
> of virtual mapping the pages. At that point, it would be a general
> solution and we could remove the warnings.

fsblock should stack on top of config_page_shift simply. Both are
needed. You don't want to use 64k pages on a laptop but you may want a
larger blocksize for the btrees etc... if you've a large harddisk and
not much ram.

> That's the absolute worst case but yes, in theory this can occur and
> it's safest to assume the situation will occur somewhere to someone. It

Do you agree this worst case can't happen with config_page_shift?

> Where we expected to see the the use of this patchset was in specialised
> environments *only*. The SGI people can mitigate their mixed
> fragmentation problems somewhat by setting slub_min_order ==
> large_block_order so that blocks get allocated and freed at the same
> size. This is partial way towards Andrea's solution of raising the size
> of an order-0 allocation. The point of printing out the warnings at

Except you don't get all the full benefits of it...

Even if I could end up mapping 4k kmalloced entries in userland for
the tail packing, that IMHO would still be a preferable solution than
to keep the base-page small and to make an hard effort to create large
pages out of small pages. The approach I advocate keeps the base page
big and the fast path fast, and it rather does some work to split the
base pages outside the buddy for the small files.

All your defrag work is still good to have, like I said at the VM
summit if you remember, to grow the hugetlbfs at runtime etc... I just
rather avoid to depend on it to avoid I/O failure in presence of
mlocked pagecache for example.

> Independently of that, we would work on order-0 scalability,
> particularly readahead and batching operations on ranges of pages as
> much as possible.

That's pretty much an unnecessary logic, if the order0 pages become
larger.
