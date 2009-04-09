Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbZDIRof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbZDIRof (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 13:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755055AbZDIRoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 13:44:23 -0400
Received: from brick.kernel.dk ([93.163.65.50]:46573 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753397AbZDIRoW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 13:44:22 -0400
Date: Thu, 9 Apr 2009 19:44:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [CFQ/OOPS]  rb_erase with April 9 next tree
Message-ID: <20090409174420.GG5178@kernel.dk>
References: <20090409163305.8c7a0371.sfr@canb.auug.org.au> <49DE1969.1000709@in.ibm.com> <20090409172918.GE5178@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090409172918.GE5178@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09 2009, Jens Axboe wrote:
> On Thu, Apr 09 2009, Sachin Sant wrote:
> > I had Next 09 booted on a powerpc box and was compiling a kernel.
> > That's when i ran into this oops.
> >
> > Unable to handle kernel paging request for data at address 0x00000010.
> > Faulting instruction address: 0xc0000000002ee1b0...................
> > 0:mon> e
> > cpu 0x0: Vector: 300 (Data Access) at [c0000000d6cf63c0]
> >    pc: c0000000002ee1b0: .rb_erase+0x16c/0x3b4
> >    lr: c0000000002e14d0: .cfq_prio_tree_add+0x58/0x120
> >    sp: c0000000d6cf6640
> >   msr: 8000000000009032
> >   dar: 10
> > dsisr: 40000000
> >  current = 0xc0000000fbdf5880
> >  paca    = 0xc000000000a92300
> >   pid   = 1867, comm = ld
> > 0:mon> t
> > [c0000000d6cf66d0] c0000000002e14d0 .cfq_prio_tree_add+0x58/0x120
> > [c0000000d6cf6770] c0000000002e16c8 .__cfq_slice_expired+0xc8/0x11c
> > [c0000000d6cf6800] c0000000002e3920 .cfq_insert_request+0x374/0x3f4
> > [c0000000d6cf68a0] c0000000002cf448 .elv_insert+0x234/0x348
> > [c0000000d6cf6940] c0000000002d3348 .__make_request+0x514/0x5b0
> > [c0000000d6cf6a00] c0000000002d1348 .generic_make_request+0x430/0x4c8
> > [c0000000d6cf6b30] c0000000002d14dc .submit_bio+0xfc/0x124
> > [c0000000d6cf6bf0] c000000000156998 .submit_bh+0x14c/0x198
> > [c0000000d6cf6c80] c00000000015ba78 .block_read_full_page+0x394/0x40c
> > [c0000000d6cf7180] c000000000163080 .do_mpage_readpage+0x680/0x688
> > [c0000000d6cf7690] c000000000163200 .mpage_readpages+0x104/0x190
> > [c0000000d6cf77f0] c0000000001e2aac .ext3_readpages+0x28/0x40
> > [c0000000d6cf7870] c0000000000ebd20 .__do_page_cache_readahead+0x180/0x278
> > [c0000000d6cf7960] c0000000000ec16c .ondemand_readahead+0x1ac/0x1d8
> > [c0000000d6cf7a00] c0000000000e1f28 .generic_file_aio_read+0x260/0x6b0
> > [c0000000d6cf7b40] c000000000129f74 .do_sync_read+0xcc/0x130
> > [c0000000d6cf7ce0] c00000000012af44 .vfs_read+0xd0/0x1bc
> > [c0000000d6cf7d80] c00000000012b138 .SyS_read+0x58/0xa0
> > [c0000000d6cf7e30] c0000000000084ac syscall_exit+0x0/0x40
> 
> Just ran into this myself, too. I'll pull that bad patch from -next
> asap. I wont be able to fix this before next week.

Can you see if this fixes it for you?

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e01b103..64de5c0 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1654,6 +1654,7 @@ retry:
 		}
 
 		RB_CLEAR_NODE(&cfqq->rb_node);
+		RB_CLEAR_NODE(&cfqq->p_node);
 		INIT_LIST_HEAD(&cfqq->fifo);
 
 		atomic_set(&cfqq->ref, 0);

-- 
Jens Axboe

