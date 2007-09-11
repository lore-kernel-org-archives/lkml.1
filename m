Return-Path: <linux-kernel-owner+w=401wt.eu-S1764728AbXIKTVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764728AbXIKTVT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762433AbXIKTVA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 15:21:00 -0400
Received: from mail.suse.de ([195.135.220.2]:48931 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756604AbXIKTU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 15:20:58 -0400
Date: Tue, 11 Sep 2007 21:20:52 +0200
From: Andrea Arcangeli <andrea@suse.de>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <andrea@suse.de>, Christoph Lameter <clameter@sgi.com>,
       torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, William Lee Irwin III <wli@holomorphy.com>,
       David Chinner <dgc@sgi.com>, Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Message-ID: <20070911192052.GA14675@v2.random>
References: <20070911060349.993975297@sgi.com> <200709110452.20363.nickpiggin@yahoo.com.au> <1189524967.32731.58.camel@localhost> <20070911164702.GD10831@v2.random> <1189535461.32731.75.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1189535461.32731.75.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 11, 2007 at 07:31:01PM +0100, Mel Gorman wrote:
> Now, the worst case scenario for your patch is that a hostile process
> allocates large amount of memory and mlocks() one 4K page per 64K chunk
> (this is unlikely in practice I know). The end result is you have many
> 64KB regions that are now unusable because 4K is pinned in each of them.

Initially 4k kmalloced tails aren't going to be mapped in
userland. But let's take the kernel stack that would generate the same
problem and that is clearly going to pin the whole 64k slab/slub
page.

What I think you're missing is that for Nick's worst case to trigger
with the config_page_shift design, you would need the _whole_ ram to
be _at_least_once_ allocated completely in kernel stacks. If the whole
100% of ram wouldn't go allocated in slub as a pure kernel stack, such
a scenario could never materialize.

With the SGI design + defrag, Nick's scenario can instead happen with
only total_ram/64k kernel stacks allocated.

The the problem with the slub fragmentation isn't a new problem, it
happens in today kernels as well and at least the slab by design is
meant to _defrag_ internally. So it's practically already solved and
it provides some guarantee unlike the buddy allocator.

> If it's my fault, sorry about that. It wasn't my intention.

It's not the fault of anyone, I simply didn't push too hard towards my
agenda for the reasons I just said, but I used any given opportunity
to discuss it.

With on-topic I meant not talking about it during the other topics,
like mmap_sem or RCU with radix tree lock ;)

> heh. Well we need to come to some sort of conclusion here or this will
> go around the merri-go-round till we're all bald.

Well, I only meant I'm still free to disagree if I think there's a
better way. All SGI has provided so far is data to show that their I/O
subsystem is much faster if the data is physically contiguous in ram
(ask Linus if you want more details, or better don't ask). That's not
very interesting data for my usages and with my hardware, and I guess
it's more likely that config_page_shift will produce interesting
numbers than their patch on my possible usage cases, but we'll never
know until both are finished.

> heh, I suggested printing the warning because I knew it had this
> problem. The purpose in my mind was to see how far the design could be
> brought before fs-block had to fill in the holes.

Indeed!

> I am still failing to see what happens when there are pagetable pages,
> slab objects or mlocked 4k pages pinning the 64K pages and you need to
> allocate another 64K page for the filesystem. I *think* you deadlock in
> a similar fashion to Christoph's approach but the shape of the problem
> is different because we are dealing with internal instead of external
> fragmentation. Am I wrong?

pagetables aren't the issue. They should be still pre-allocated in
page_size chunks. The 4k entries with 64k page-size are sure not worse
than a 32byte kmalloc today, the slab by design defragments the
stuff. There's probably room for improvement in that area even without
freeing any object by just ordering the list with an rbtree (or better
an heak like CFS should also use!!) so to always allocate new slabs
from the most full partial slab, that alone would help a lot probably
(not sure if slub does anything like that, I'm not fond on slub yet).

> Yes. I just think you have a different worst case that is just as bad.

Disagree here...

> small files (you need something like Shaggy's page tail packing),
> pagetable pages, pte pages all have to be dealt with. These are the
> things I think will cause us internal fragmentaiton problems.

Also note that not all users will need to turn on the tail
packing. We're here talking about features that not all users will
need anyway.. And we're in the same boat as ppc64, no difference.

Thanks!
