Return-Path: <linux-kernel-owner+w=401wt.eu-S1762207AbXERQCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762207AbXERQCp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 12:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761135AbXERQCf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 12:02:35 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:54536 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760812AbXERQCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 12:02:33 -0400
Subject: Re: [PATCH] Chaining sg lists for big IO commands v5
From: Badari Pulavarty <pbadari@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, bhalevy@panasas.com,
       Andrew Morton <akpm@linux-foundation.org>,
       fujita.tomonori@lab.ntt.co.jp, michaelc@cs.wisc.edu
In-Reply-To: <20070518073331.GC23798@kernel.dk>
References: <20070511135108.GF4629@kernel.dk>
	 <1179249337.2836.110.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515172001.GB23798@kernel.dk>
	 <1179251020.2836.118.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515175025.GE23798@kernel.dk>
	 <1179349294.16195.6.camel@dyn9047017100.beaverton.ibm.com>
	 <20070517062742.GW23798@kernel.dk>
	 <1179414662.23725.3.camel@dyn9047017100.beaverton.ibm.com>
	 <20070518073331.GC23798@kernel.dk>
Content-Type: text/plain
Date: Fri, 18 May 2007 09:03:18 -0700
Message-Id: <1179504198.29302.12.camel@dyn9047017100.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.4 (2.0.4-4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-18 at 09:33 +0200, Jens Axboe wrote:
> On Thu, May 17 2007, Badari Pulavarty wrote:
> > On Thu, 2007-05-17 at 08:27 +0200, Jens Axboe wrote:
> > .. 
> > > > > 
> > > > > Ah ok, you need the updated patch series for ppc64 support. Builds fine
> > > > > here on ppc64. See the #sglist branch of the block repo:
> > > > > 
> > > > > git://git.kernel.dk/data/git/linux-2.6-block.git
> > > > > 
> > > > > I can mail you an updated patch, if you want.
> > > > 
> > > > 
> > > > Here is the whole panic stack..
> > > 
> > > Thanks will fix that up, the IDE part is totally untested. Can you try
> > > and backout this patch and see if it boots?
> > 
> > Yes. It boots fine with following backed out.
> > 
> > Looking at the code ide_probe.c: hwif_init() is doing
> > 
> >         hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
> >                                  GFP_KERNEL);
> > 
> > blk_rq_map_sg() is looking for the chaining info and going over end of the
> > allocation.
> 
> Hmm, looks ok, I'm guessing it's just missing a memset (or just turn it
> into a kzalloc())?
> 

Even with backing out all the ide changes, I get this on boot
once in a while.

Thanks,
Badari

ReiserFS: hda2: checking transaction log (hda2)
Unable to handle kernel paging request at 00000000005e5e66 RIP:
 [<ffffffff80381aa1>] blk_rq_map_sg+0x71/0x1b0
PGD 0
Oops: 0000 [1] SMP
CPU 3
Modules linked in:
Pid: 1, comm: swapper Not tainted 2.6.22-rc1-sg #7
RIP: 0010:[<ffffffff80381aa1>]  [<ffffffff80381aa1>] blk_rq_map_sg
+0x71/0x1b0
RSP: 0000:ffff8101a024fcc8  EFLAGS: 00010287
RAX: 00000001df33e000 RBX: ffff8101df2b5f70 RCX: 000000019f352000
RDX: 0000000000000000 RSI: ffff8101df228300 RDI: 00000000001df33e
RBP: ffff8101a024fd28 R08: 00000000000004e2 R09: 0000000000000000
R10: 000000000000007f R11: 0000000000000001 R12: 00000000005e5e46
R13: 0000000000001000 R14: 0000000000000000 R15: ffff8101df2b5f60
FS:  0000000000000000(0000) GS:ffff8101c021f300(0000)
knlGS:0000000000000000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00000000005e5e66 CR3: 0000000000201000 CR4: 00000000000006e0
Process swapper (pid: 1, threadinfo ffff8101a0238000, task
ffff810180238000)
Stack:  0000000300000000 ffff810179c58000 000000019f352000
ffff810179c562c0
 ffff8101df228e80 0000001700000082 01ff810100000001 ffff8101df3207a8
 ffffffff8078a500 ffff810179c56000 ffffffff8078a500 ffff8101df3207a8
Call Trace:
 <IRQ>  [<ffffffff8042faf2>] ide_map_sg+0x42/0xd0
 [<ffffffff8043936a>] ide_build_sglist+0x2a/0x90
 [<ffffffff804393ff>] ide_build_dmatable+0x2f/0x180
 [<ffffffff80439594>] ide_dma_setup+0x44/0xe0
 [<ffffffff8043cd99>] ide_do_rw_disk+0x349/0x510
 [<ffffffff80430442>] ide_do_request+0x622/0xb40
 [<ffffffff8042fd2d>] ide_end_request+0x9d/0x160
 [<ffffffff80439660>] ide_dma_intr+0x0/0xd0
 [<ffffffff80439660>] ide_dma_intr+0x0/0xd0
 [<ffffffff80430cdf>] ide_intr+0x23f/0x250
 [<ffffffff802571b5>] handle_IRQ_event+0x35/0x70
 [<ffffffff80258c8c>] handle_edge_irq+0xcc/0x150
 [<ffffffff8020caf0>] do_IRQ+0x80/0x100
 [<ffffffff8020a021>] ret_from_intr+0x0/0xa
 <EOI>  [<ffffffff802816c0>] kmem_cache_alloc+0x40/0x70
 [<ffffffff8025d001>] mempool_alloc_slab+0x11/0x20
 [<ffffffff8025d122>] mempool_alloc+0x42/0x110
 [<ffffffff80382db8>] generic_make_request+0x198/0x240
 [<ffffffff802aefee>] bio_alloc_bioset+0x2e/0x120
 [<ffffffff802af140>] bio_alloc+0x10/0x20
 [<ffffffff802ab11b>] submit_bh+0x6b/0x140
 [<ffffffff802ac180>] ll_rw_block+0xd0/0xe0
 [<ffffffff802ff1ae>] journal_read+0xb5e/0xec0
 [<ffffffff80265d71>] zone_statistics+0x61/0xa0
 [<ffffffff8025f528>] get_page_from_freelist+0x3c8/0x510
 [<ffffffff8025f7ae>] __alloc_pages+0x6e/0x330
 [<ffffffff80278aed>] alloc_page_interleave+0x8d/0xa0
 [<ffffffff80279c86>] alloc_pages_current+0x86/0x90
 [<ffffffff8025f140>] get_zeroed_page+0x20/0x40
 [<ffffffff80267704>] __pte_alloc_kernel+0x64/0x80
 [<ffffffff802721dc>] map_vm_area+0x1dc/0x2e0
 [<ffffffff80272907>] __vmalloc_area_node+0x157/0x1a0
 [<ffffffff80302169>] journal_init+0x819/0x990
 [<ffffffff80272907>] __vmalloc_area_node+0x157/0x1a0
 [<ffffffff802729bf>] __vmalloc_node+0x6f/0x80
 [<ffffffff802729fe>] __vmalloc+0xe/0x10
 [<ffffffff802f109a>] reiserfs_fill_super+0x2ba/0xc20
 [<ffffffff80394357>] vsnprintf+0x2e7/0x680
 [<ffffffff80394959>] snprintf+0x59/0x60
 [<ffffffff80505117>] __down_write_nested+0x17/0xc0
 [<ffffffff8039310f>] strlcpy+0x4f/0x70
 [<ffffffff80287ef0>] test_bdev_super+0x0/0x20
 [<ffffffff802892cc>] get_sb_bdev+0x13c/0x170
 [<ffffffff802f0de0>] reiserfs_fill_super+0x0/0xc20
 [<ffffffff802ee793>] get_super_block+0x13/0x20
 [<ffffffff80288b68>] vfs_kern_mount+0xd8/0x160
 [<ffffffff80288c5e>] do_kern_mount+0x4e/0x100
 [<ffffffff802a0852>] do_mount+0x4e2/0x790
 [<ffffffff8029a3ac>] __d_lookup+0x9c/0x130
 [<ffffffff8028ec24>] do_lookup+0x84/0x200
 [<ffffffff8028ec24>] do_lookup+0x84/0x200
 [<ffffffff802995c4>] dput+0x24/0x140
 [<ffffffff80290e49>] __link_path_walk+0x469/0xec0
 [<ffffffff80265d8d>] zone_statistics+0x7d/0xa0
 [<ffffffff8025f7ae>] __alloc_pages+0x6e/0x330
 [<ffffffff80278aed>] alloc_page_interleave+0x8d/0xa0
 [<ffffffff80279c86>] alloc_pages_current+0x86/0x90
 [<ffffffff8025f0fb>] __get_free_pages+0x1b/0x40
 [<ffffffff8029f0b2>] copy_mount_options+0x52/0x180
 [<ffffffff802a0b94>] sys_mount+0x94/0xf0
 [<ffffffff806aecf1>] do_mount_root+0x21/0xa0
 [<ffffffff806aef40>] mount_block_root+0x90/0x220
 [<ffffffff80292421>] sys_rmdir+0x11/0x20
 [<ffffffff806af1b6>] mount_root+0xe6/0xf0
 [<ffffffff806af26d>] prepare_namespace+0xad/0x160
 [<ffffffff806aeafa>] kernel_init+0x23a/0x330
 [<ffffffff8020a928>] child_rip+0xa/0x12
 [<ffffffff806ae8c0>] kernel_init+0x0/0x330
 [<ffffffff8020a91e>] child_rip+0x0/0x12


Code: 49 8b 44 24 20 49 8d 4c 24 20 48 89 c2 48 83 e2 fe a8 01 48
RIP  [<ffffffff80381aa1>] blk_rq_map_sg+0x71/0x1b0
 RSP <ffff8101a024fcc8>
CR2: 00000000005e5e66


