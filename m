Return-Path: <linux-kernel-owner+w=401wt.eu-S1757528AbXITOyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757528AbXITOyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 10:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755763AbXITOyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 10:54:14 -0400
Received: from ns1.suse.de ([195.135.220.2]:39581 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755725AbXITOyN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 10:54:13 -0400
Date: Thu, 20 Sep 2007 16:54:07 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: David Chinner <dgc@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nathan Scott <nscott@aconex.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070920145407.GY4608@v2.random>
References: <Pine.LNX.4.64.0709171510280.29993@schroedinger.engr.sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org> <20070918191853.GB7541@v2.random> <alpine.LFD.0.999.0709181239320.16478@woody.linux-foundation.org> <1190163523.24970.378.camel@edge.yarra.acx> <alpine.LFD.0.999.0709181803020.16478@woody.linux-foundation.org> <20070919050910.GK995458@sgi.com> <20070919140430.GJ4608@v2.random> <20070920013821.GR995458@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070920013821.GR995458@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2007 at 11:38:21AM +1000, David Chinner wrote:
> Sure, and that's what I meant when I said VPC + large pages was
> a means to the end, not the only solution to the problem.

The whole point is that it's not an end, it's an end to your own fs
centric view only (which is sure fair enough), but I watch the whole
VM not just the pagecache...

The same way the fs-centric view will hope to get this little bit of
further optimization from largepages to reach "the end", my VM-wide
view wants the same little bit of opitmization for *everything*
including tmpfs and anonymous memory, slab etc..! This is clearly why
config-page-shift is better...

If you're ok not to be on the edge and you want a generic rpm image
that run quite optimally for any workload, then 4k+fslblock is just
fine of course. But if we go on the edge we should aim for the _very_
end for the whole VM, not just for "the end of the pagecache on
certain files". Especially when the complexity involved in the mmap
code is similar, and it will reject heavily if we merge this
not-very-end solution that only reaches "the end" for the pagecache.

> No, I don't like fsblock because it is inherently a "struture
> per filesystem block" construct, just like buggerheads. You
> still need to allocate millions of them when you have millions
> dirty pages around. Rather than type it all out again, read
> the fsblocks thread from here:
> 
> http://marc.info/?l=linux-fsdevel&m=118284983925719&w=2

Thanks for the pointer!

> FWIW, with Chris mason's extent-based block mapping (which btrfs
> is using and Christoph Hellwig is porting XFS over to) we completely
> remove buggerheads from XFS and so fsblock would be a pretty
> major step backwards for us if Chris's work goes into mainline.

I tend to agree if we change it fsblock should support extent if
that's what you need on xfs to support range-locking etc... Whatever
happens in vfs should please all existing fs without people needing to
go their own way again... Or replace fsblock with Chris's block
mapping. Frankly I didn't see Chris's code so I cannot comment
further. But your complains sounds sensible. We certainly want to
avoid lowlevel fs to get smarter again than the vfs. The brainer stuff
should be in vfs!

> That's not in the filesystem, though. ;)
> 
> However, I agree that if you don't have mmap then it's not
> worthwhile and the changes for VPC aren't trivial.

Yep.

> 
> > > 	3. avoiding the need for vmap() as it has great
> > > 	   overhead and does not scale
> > > 	   	-> Nick is starting to work on that and has
> > > 		   already had good results.
> > 
> > Frankly I don't follow this vmap thing. Can you elaborate?
> 
> We current support metadata blocks larger than page size for
> certain types of metadata in XFS. e.g. directory blocks.
> This however, requires vmap()ing a bunch of individual,
> non-contiguous pages out of a block device address space
> in exactly the fashion that was proposed by Nick with fsblock
> originally.
> 
> vmap() has severe scalability problems - read this subthread
> of this discussion between Nick and myself:
> 
> http://lkml.org/lkml/2007/9/11/508

So the idea of vmap is that it's much simpler to have a contiguous
virtual address space large blocksize, than to find the right
b_data[index] once you exceed PAGE_SIZE...

The global tlb flush with ipi would kill performance, you can forget
any global mapping here. The only chance to do this would be like we
do with kmap_atomic per-cpu on highmem, with preempt_disable (for the
enjoyment of the rt folks out there ;). what's the problem of having
it per-cpu? Is this what fsblock already does? You've just have to
allocate a new virtual range large numberofentriesinvmap*blocksize
every time you mount a new fs. Then instead of calling kmap you call
vmap and vunmap when you're finished. That should provide decent
performance, especially with physically indexed caches.

Anything more heavyweight than what I suggested is probably overkill,
even vmalloc_to_page.

> Hmm - so you'll need page cache tail packing as well in that case
> to prevent memory being wasted on small files. That means any way
> we look at it (VPC+mmap or config-page-shift+fsblock+pctails)
> we've got some non-trivial VM  modifications to make. 

Hmm no, the point of config-page-shift is that if you really need to
reach "the very end", you probably don't care about wasting some
memory, because either your workload can't fit in cache, or it fits in
cache regardless, or you're not wasting memory because you work with
large files...

The only point of this largepage stuff is to go an extra mile to save
a bit more of cpu vs a strict vmap based solution (fsblock of course
will be smart enough that if it notices the PAGE_SIZE is >= blocksize
it doesn't need to run any vmap at all and it can just use the direct
mapping, so vmap translates in 1 branch only to check the blocksize
variable, PAGE_SIZE is immediate in the .text at compile time). But if
you care about that tiny bit of performance during I/O operations
(variable order page cache only gives the tinybit of performance
during read/write syscalls!!!), then it means you actually want to
save CPU _everywhere_ not just in read/write and while mangling
metadata in the lowlevel fs. And that's what config-page-shift should
provide...

This is my whole argument for preferring config-page-shift+fsblock (or
whatever else fsblock replacement but then Nick design looked quite
sensible to me, if integrated with extent based locking, without
having seen Chris's yet). Regardless of the fact config-page-shift
also has the other benefit of providing guarantees for meminfo levels
and the other fact it doesn't strictly require defrag heuristics to
avoid hitting worst case huge-ram-waste scenarios.

> But, I'm not going to argue endlessly for one solution or another;
> I'm happy to see different solutions being chased, so may the
> best VM win ;)

;)
