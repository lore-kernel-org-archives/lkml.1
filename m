Return-Path: <linux-kernel-owner+w=401wt.eu-S1753366AbXJWHE1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366AbXJWHE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:04:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbXJWHET
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:04:19 -0400
Received: from brick.kernel.dk ([87.55.233.238]:7557 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbXJWHES (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:04:18 -0400
Date: Tue, 23 Oct 2007 09:02:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: IDE crash...
Message-ID: <20071023070252.GA25962@kernel.dk>
References: <20071022.235010.59469063.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071022.235010.59469063.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22 2007, David Miller wrote:
> 
> I'm debugging a blk_rq_map_sg() crash that i'm getting on sparc64 as
> root is mounted over IDE.  I think I know what is happening now.
> 
> The IDE sg table is allocated and initialized like this in
> drivers/ide/ide-probe.c:
> 
> 	x = kmalloc(sizeof(struct scatterlist) * nents, GFP_XXX);
> 	sg_init_table(x, nents);
> 
> So far, so good.
> 
> Now, ide_map_sg() passes requests down to blk_rq_map_sg() like this in
> drivers/block/ide-io.c:
> 
> 		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> 
> Ok, so what does blk_rq_map_sg() do?
> 
> 	sg = NULL;
> 	rq_for_each_segment(bvec, rq, iter) {
>  ...
> 		if (bvprv && cluster) {
>  ...
> 		} else {
> new_segment:
> 			if (!sg)
> 				sg = sglist;
> 			else
> 				sg = sg_next(sg);
>  ...
> 		}
> 		bvprv = bvec;
> 	} /* segments in rq */
> 
> 	if (sg)
> 		__sg_mark_end(sg);
> 
> So let's say the first request comes in and needs 2 segs.
> This will mark sg[1].page_link with 0x2
> 
> If the next request from IDE needs 4 segs, we'll OOPS because
> sg_next() on &sg[1] will see page_link bit 0x2 is set and
> therefore return NULL.
> 
> A quick look shows that if you're testing on SCSI (or something
> layered on top of it like SATA or PATA) you won't see this seemingly
> guarenteed crash because the SCSI mid-layer allocates a fresh sglist
> via mempool_alloc() and runs sg_init_table() on it for every I/O
> request.

We should never see the end pointer in blk_rq_map_sg(), or that's a bug
in the driver. So it should be OK to just clear the end pointer always
in there, even if it's not the prettiest solution...

This just needs to be wrapped up in some scatterlist.h macro/function.

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 61c2e39..a3bda2f 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1354,6 +1354,12 @@ new_segment:
 			else
 				sg = sg_next(sg);
 
+			/*
+			 * Clear end-of-table pointer, we'll mark a new one
+			 * at the end
+			 */
+			sg->page_link &= ~0x2;
+
 			sg_dma_len(sg) = 0;
 			sg_dma_address(sg) = 0;
 			sg_set_page(sg, bvec->bv_page);

-- 
Jens Axboe

