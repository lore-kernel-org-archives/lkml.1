Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbXI2TVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbXI2TVQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 15:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754904AbXI2TU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 15:20:58 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985AbXI2TU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 15:20:56 -0400
Date: Sat, 29 Sep 2007 12:20:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Lameter <clameter@sgi.com>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
Message-Id: <20070929122010.56228dae.akpm@linux-foundation.org>
In-Reply-To: <200709290619.33918.nickpiggin@yahoo.com.au>
References: <20070919033605.785839297@sgi.com>
	<1191057242.18147.110.camel@lappy>
	<20070929022750.5d57d49e.akpm@linux-foundation.org>
	<200709290619.33918.nickpiggin@yahoo.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Sep 2007 06:19:33 +1000 Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> On Saturday 29 September 2007 19:27, Andrew Morton wrote:
> > On Sat, 29 Sep 2007 11:14:02 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> 
> wrote:
> > > > oom-killings, or page allocation failures?  The latter, one hopes.
> > >
> > > Linux version 2.6.23-rc4-mm1-dirty (root@dyad) (gcc version 4.1.2 (Ubuntu
> > > 4.1.2-0ubuntu4)) #27 Tue Sep 18 15:40:35 CEST 2007
> > >
> > > ...
> > >
> > >
> > > mm_tester invoked oom-killer: gfp_mask=0x40d0, order=2, oomkilladj=0
> > > Call Trace:
> > > 611b3878:  [<6002dd28>] printk_ratelimit+0x15/0x17
> > > 611b3888:  [<60052ed4>] out_of_memory+0x80/0x100
> > > 611b38c8:  [<60054b0c>] __alloc_pages+0x1ed/0x280
> > > 611b3948:  [<6006c608>] allocate_slab+0x5b/0xb0
> > > 611b3968:  [<6006c705>] new_slab+0x7e/0x183
> > > 611b39a8:  [<6006cbae>] __slab_alloc+0xc9/0x14b
> > > 611b39b0:  [<6011f89f>] radix_tree_preload+0x70/0xbf
> > > 611b39b8:  [<600980f2>] do_mpage_readpage+0x3b3/0x472
> > > 611b39e0:  [<6011f89f>] radix_tree_preload+0x70/0xbf
> > > 611b39f8:  [<6006cc81>] kmem_cache_alloc+0x51/0x98
> > > 611b3a38:  [<6011f89f>] radix_tree_preload+0x70/0xbf
> > > 611b3a58:  [<6004f8e2>] add_to_page_cache+0x22/0xf7
> > > 611b3a98:  [<6004f9c6>] add_to_page_cache_lru+0xf/0x24
> > > 611b3ab8:  [<6009821e>] mpage_readpages+0x6d/0x109
> > > 611b3ac0:  [<600d59f0>] ext3_get_block+0x0/0xf2
> > > 611b3b08:  [<6005483d>] get_page_from_freelist+0x8d/0xc1
> > > 611b3b88:  [<600d6937>] ext3_readpages+0x18/0x1a
> > > 611b3b98:  [<60056f00>] read_pages+0x37/0x9b
> > > 611b3bd8:  [<60057064>] __do_page_cache_readahead+0x100/0x157
> > > 611b3c48:  [<60057196>] do_page_cache_readahead+0x52/0x5f
> > > 611b3c78:  [<60050ab4>] filemap_fault+0x145/0x278
> > > 611b3ca8:  [<60022b61>] run_syscall_stub+0xd1/0xdd
> > > 611b3ce8:  [<6005eae3>] __do_fault+0x7e/0x3ca
> > > 611b3d68:  [<6005ee60>] do_linear_fault+0x31/0x33
> > > 611b3d88:  [<6005f149>] handle_mm_fault+0x14e/0x246
> > > 611b3da8:  [<60120a7b>] __up_read+0x73/0x7b
> > > 611b3de8:  [<60013177>] handle_page_fault+0x11f/0x23b
> > > 611b3e48:  [<60013419>] segv+0xac/0x297
> > > 611b3f28:  [<60013367>] segv_handler+0x68/0x6e
> > > 611b3f48:  [<600232ad>] get_skas_faultinfo+0x9c/0xa1
> > > 611b3f68:  [<60023853>] userspace+0x13a/0x19d
> > > 611b3fc8:  [<60010d58>] fork_handler+0x86/0x8d
> >
> > OK, that's different.  Someone broke the vm - order-2 GFP_KERNEL
> > allocations aren't supposed to fail.
> >
> > I'm suspecting that did_some_progress thing.
> 
> The allocation didn't fail -- it invoked the OOM killer because the kernel
> ran out of unfragmented memory.

We can't "run out of unfragmented memory" for an order-2 GFP_KERNEL
allocation in this workload.  We go and synchronously free stuff up to make
it work.

How did this get broken?

> Probably because higher order
> allocations are the new vogue in -mm at the moment ;)

That's a different bug.

bug 1: We shouldn't be doing higher-order allocations in slub because of
the considerable damage this does to atomic allocations.

bug 2: order-2 GFP_KERNEL allocations shouldn't fail like this.


