Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbXIUFTr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbXIUFTr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 01:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751312AbXIUFTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 01:19:41 -0400
Received: from brick.kernel.dk ([87.55.233.238]:28693 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbXIUFTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 01:19:40 -0400
Date: Fri, 21 Sep 2007 07:20:27 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [PATCH 2.6.23-rc6-mm1] - Panic in blk_rq_map_sg() from CCISS
	driver
Message-ID: <20070921052026.GQ2367@kernel.dk>
References: <1190324222.5326.42.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1190324222.5326.42.camel@localhost>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20 2007, Lee Schermerhorn wrote:
> PATCH 2.6.23-rc6-mm1 - Panic in blk_rq_map_sg() from CCISS driver
> 
> New scatter/gather list chaining [sg_next()] treats 'page' member of
> struct scatterlist with low bit set [0x01] as a chain pointer to
> another struct scatterlist [array].  The CCISS driver request function
> passes an uninitialized, temporary, on-stack scatterlist array to 
> blk_rq_map_sq().  sg_next() interprets random data on the stack as a
> chain pointer and eventually tries to de-reference an invalid pointer,
> resulting in:
> 
> [<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
> PGD 6090c3067 PUD 0
> Oops: 0000 [1] SMP
> last sysfs file: /block/cciss!c0d0/cciss!c0d0p1/dev
> CPU 6
> Modules linked in: ehci_hcd ohci_hcd uhci_hcd
> Pid: 1, comm: init Not tainted 2.6.23-rc6-mm1 #3
> RIP: 0010:[<ffffffff8031dd70>] [<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
> RSP: 0018:ffff81060901f768 EFLAGS: 00010206
> RAX: 000000040b161000 RBX: ffff81060901f7d8 RCX: 000000040b162c00
> RDX: 0000000000000000 RSI: ffff81060b13a260 RDI: ffff81060b139600
> RBP: 0000000000001400 R08: 00000000fffffffe R09: 0000000000000400
> R10: 0000000000000000 R11: 000000040b163000 R12: ffff810102fe0000
> R13: 0000000000000001 R14: 0000000000000001 R15: 00001e0000000000
> FS: 00000000026108f0(0063) GS:ffff810409000b80(0000) knlGS:0000000000000000
> CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> CR2: 000000010000001e CR3: 00000006090c6000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process init (pid: 1, threadinfo ffff81060901e000, task ffff810409020800)
> last branch before last exception/interrupt
> from [<ffffffff8031de0a>] blk_rq_map_sg+0x10a/0x170
> to [<ffffffff8031dd70>] blk_rq_map_sg+0x70/0x170
> Stack: 000000018068ea00 ffff810102fe0000 0000000000000000 ffff810011400000
> 0000000000000002 0000000000000000 ffff81040b172000 ffffffff803acd3d
> 0000000000003ec1 ffff8106090d5000 ffff8106090d5000 ffff810102fe0000
> Call Trace:
> [<ffffffff803acd3d>] do_cciss_request+0x15d/0x4c0
> [<ffffffff80298968>] new_slab+0x1c8/0x270
> [<ffffffff80298ffd>] __slab_alloc+0x22d/0x470
> [<ffffffff8027327b>] mempool_alloc+0x4b/0x130
> [<ffffffff8032b21e>] cfq_set_request+0xee/0x380
> [<ffffffff8027327b>] mempool_alloc+0x4b/0x130
> [<ffffffff8031ff98>] get_request+0x168/0x360
> [<ffffffff80331b0d>] rb_insert_color+0x8d/0x110
> [<ffffffff8031cfd8>] elv_rb_add+0x58/0x60
> [<ffffffff8032a329>] cfq_add_rq_rb+0x69/0xa0
> [<ffffffff8031c1ab>] elv_merged_request+0x5b/0x60
> [<ffffffff803224fd>] __make_request+0x23d/0x650
> [<ffffffff80298ffd>] __slab_alloc+0x22d/0x470
> [<ffffffff80270000>] generic_write_checks+0x140/0x190
> [<ffffffff8031f012>] generic_make_request+0x1c2/0x3a0
> <etc>
> Kernel panic - not syncing: Attempted to kill init!
> 
> This patch initializes the tmp_sg array to zeroes.  Perhaps not the ultimate
> fix, but an effective work-around.  I can now boot 23-rc6-mm1 on an HP
> Proliant x86_64 with CCISS boot disk.
> 
> Signed-off-by:  Lee Schermerhorn <lee.schermerhorn@hp.com>
> 
>  drivers/block/cciss.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: Linux/drivers/block/cciss.c
> ===================================================================
> --- Linux.orig/drivers/block/cciss.c	2007-09-20 14:59:29.000000000 -0400
> +++ Linux/drivers/block/cciss.c	2007-09-20 15:06:39.000000000 -0400
> @@ -2611,6 +2611,7 @@ static void do_cciss_request(struct requ
>  	       (int)creq->nr_sectors);
>  #endif				/* CCISS_DEBUG */
>  
> +	memset(tmp_sg, 0, sizeof(tmp_sg));
>  	seg = blk_rq_map_sg(q, creq, tmp_sg);
>  
>  	/* get the DMA records for the setup */
> 

Thanks Lee, applied.

-- 
Jens Axboe

