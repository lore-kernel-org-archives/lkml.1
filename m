Return-Path: <linux-kernel-owner+w=401wt.eu-S1757031AbXI2JSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757031AbXI2JSy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Sep 2007 05:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754954AbXI2JSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Sep 2007 05:18:44 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47301 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554AbXI2JSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Sep 2007 05:18:42 -0400
Subject: Re: [15/17] SLUB: Support virtual fallback via SLAB_VFALLBACK
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <clameter@sgi.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Christoph Hellwig <hch@lst.de>,
       Mel Gorman <mel@skynet.ie>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20070929020141.e7684eb8.akpm@linux-foundation.org>
References: <20070919033605.785839297@sgi.com>
	 <20070919033643.763818012@sgi.com>
	 <200709280742.38262.nickpiggin@yahoo.com.au>
	 <Pine.LNX.4.64.0709281014060.4713@schroedinger.engr.sgi.com>
	 <1191002119.18147.80.camel@lappy>
	 <Pine.LNX.4.64.0709281114250.5149@schroedinger.engr.sgi.com>
	 <1191003950.18147.85.camel@lappy>
	 <20070929011311.8b51dedb.akpm@linux-foundation.org>
	 <1191055632.18147.101.camel@lappy> <1191056021.18147.104.camel@lappy>
	 <20070929020141.e7684eb8.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 29 Sep 2007 11:14:02 +0200
Message-Id: <1191057242.18147.110.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-09-29 at 02:01 -0700, Andrew Morton wrote:
> On Sat, 29 Sep 2007 10:53:41 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > 
> > On Sat, 2007-09-29 at 10:47 +0200, Peter Zijlstra wrote:
> > 
> > > Ah, right, that was the detail... all this lumpy reclaim is useless for
> > > atomic allocations. And with SLUB using higher order pages, atomic !0
> > > order allocations will be very very common.
> > > 
> > > One I can remember was:
> > > 
> > >   add_to_page_cache()
> > >     radix_tree_insert()
> > >       radix_tree_node_alloc()
> > >         kmem_cache_alloc()
> > > 
> > > which is an atomic callsite.
> > > 
> > > Which leaves us in a situation where we can load pages, because there is
> > > free memory, but can't manage to allocate memory to track them.. 
> > 
> > Ah, I found a boot log of one of these sessions, its also full of
> > order-2 OOMs.. :-/
> 
> oom-killings, or page allocation failures?  The latter, one hopes.


Linux version 2.6.23-rc4-mm1-dirty (root@dyad) (gcc version 4.1.2 (Ubuntu 4.1.2-0ubuntu4)) #27 Tue Sep 18 15:40:35 CEST 2007

...


mm_tester invoked oom-killer: gfp_mask=0x40d0, order=2, oomkilladj=0
Call Trace:
611b3878:  [<6002dd28>] printk_ratelimit+0x15/0x17
611b3888:  [<60052ed4>] out_of_memory+0x80/0x100
611b38c8:  [<60054b0c>] __alloc_pages+0x1ed/0x280
611b3948:  [<6006c608>] allocate_slab+0x5b/0xb0
611b3968:  [<6006c705>] new_slab+0x7e/0x183
611b39a8:  [<6006cbae>] __slab_alloc+0xc9/0x14b
611b39b0:  [<6011f89f>] radix_tree_preload+0x70/0xbf
611b39b8:  [<600980f2>] do_mpage_readpage+0x3b3/0x472
611b39e0:  [<6011f89f>] radix_tree_preload+0x70/0xbf
611b39f8:  [<6006cc81>] kmem_cache_alloc+0x51/0x98
611b3a38:  [<6011f89f>] radix_tree_preload+0x70/0xbf
611b3a58:  [<6004f8e2>] add_to_page_cache+0x22/0xf7
611b3a98:  [<6004f9c6>] add_to_page_cache_lru+0xf/0x24
611b3ab8:  [<6009821e>] mpage_readpages+0x6d/0x109
611b3ac0:  [<600d59f0>] ext3_get_block+0x0/0xf2
611b3b08:  [<6005483d>] get_page_from_freelist+0x8d/0xc1
611b3b88:  [<600d6937>] ext3_readpages+0x18/0x1a
611b3b98:  [<60056f00>] read_pages+0x37/0x9b
611b3bd8:  [<60057064>] __do_page_cache_readahead+0x100/0x157
611b3c48:  [<60057196>] do_page_cache_readahead+0x52/0x5f
611b3c78:  [<60050ab4>] filemap_fault+0x145/0x278
611b3ca8:  [<60022b61>] run_syscall_stub+0xd1/0xdd
611b3ce8:  [<6005eae3>] __do_fault+0x7e/0x3ca
611b3d68:  [<6005ee60>] do_linear_fault+0x31/0x33
611b3d88:  [<6005f149>] handle_mm_fault+0x14e/0x246
611b3da8:  [<60120a7b>] __up_read+0x73/0x7b
611b3de8:  [<60013177>] handle_page_fault+0x11f/0x23b
611b3e48:  [<60013419>] segv+0xac/0x297
611b3f28:  [<60013367>] segv_handler+0x68/0x6e
611b3f48:  [<600232ad>] get_skas_faultinfo+0x9c/0xa1
611b3f68:  [<60023853>] userspace+0x13a/0x19d
611b3fc8:  [<60010d58>] fork_handler+0x86/0x8d

Mem-info:
Normal per-cpu:
CPU    0: Hot: hi:   42, btch:   7 usd:   0   Cold: hi:   14, btch:   3 usd:   0
Active:11 inactive:9 dirty:0 writeback:1 unstable:0
 free:19533 slab:10587 mapped:0 pagetables:260 bounce:0
Normal free:78132kB min:4096kB low:5120kB high:6144kB active:44kB inactive:36kB present:129280kB pages_scanned:0 all_unreclaimable? no
lowmem_reserve[]: 0 0
Normal: 7503*4kB 5977*8kB 19*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 0*1024kB 0*2048kB 0*4096kB = 78132kB
Swap cache: add 1192822, delete 1192790, find 491441/626861, race 0+1
Free swap  = 455300kB
Total swap = 524280kB
Free swap:       455300kB
32768 pages of RAM
0 pages of HIGHMEM
1948 reserved pages
11 pages shared
32 pages swap cached
Out of memory: kill process 2647 (portmap) score 2233 or a child
Killed process 2647 (portmap)


