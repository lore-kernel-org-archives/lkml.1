Return-Path: <linux-kernel-owner+w=401wt.eu-S1753264AbXJWHLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbXJWHLN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:11:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbXJWHK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:10:58 -0400
Received: from brick.kernel.dk ([87.55.233.238]:18386 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751684AbXJWHK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:10:58 -0400
Date: Tue, 23 Oct 2007 09:09:33 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: IDE crash...
Message-ID: <20071023070932.GB25962@kernel.dk>
References: <20071022.235010.59469063.davem@davemloft.net> <20071023070252.GA25962@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023070252.GA25962@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, Jens Axboe wrote:
> On Mon, Oct 22 2007, David Miller wrote:
> > 
> > I'm debugging a blk_rq_map_sg() crash that i'm getting on sparc64 as
> > root is mounted over IDE.  I think I know what is happening now.
> > 
> > The IDE sg table is allocated and initialized like this in
> > drivers/ide/ide-probe.c:
> > 
> > 	x = kmalloc(sizeof(struct scatterlist) * nents, GFP_XXX);
> > 	sg_init_table(x, nents);
> > 
> > So far, so good.
> > 
> > Now, ide_map_sg() passes requests down to blk_rq_map_sg() like this in
> > drivers/block/ide-io.c:
> > 
> > 		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> > 
> > Ok, so what does blk_rq_map_sg() do?
> > 
> > 	sg = NULL;
> > 	rq_for_each_segment(bvec, rq, iter) {
> >  ...
> > 		if (bvprv && cluster) {
> >  ...
> > 		} else {
> > new_segment:
> > 			if (!sg)
> > 				sg = sglist;
> > 			else
> > 				sg = sg_next(sg);
> >  ...
> > 		}
> > 		bvprv = bvec;
> > 	} /* segments in rq */
> > 
> > 	if (sg)
> > 		__sg_mark_end(sg);
> > 
> > So let's say the first request comes in and needs 2 segs.
> > This will mark sg[1].page_link with 0x2
> > 
> > If the next request from IDE needs 4 segs, we'll OOPS because
> > sg_next() on &sg[1] will see page_link bit 0x2 is set and
> > therefore return NULL.
> > 
> > A quick look shows that if you're testing on SCSI (or something
> > layered on top of it like SATA or PATA) you won't see this seemingly
> > guarenteed crash because the SCSI mid-layer allocates a fresh sglist
> > via mempool_alloc() and runs sg_init_table() on it for every I/O
> > request.
> 
> We should never see the end pointer in blk_rq_map_sg(), or that's a bug
> in the driver. So it should be OK to just clear the end pointer always
> in there, even if it's not the prettiest solution...
> 
> This just needs to be wrapped up in some scatterlist.h macro/function.
> 
> diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> index 61c2e39..a3bda2f 100644
> --- a/block/ll_rw_blk.c
> +++ b/block/ll_rw_blk.c
> @@ -1354,6 +1354,12 @@ new_segment:
>  			else
>  				sg = sg_next(sg);
>  
> +			/*
> +			 * Clear end-of-table pointer, we'll mark a new one
> +			 * at the end
> +			 */
> +			sg->page_link &= ~0x2;
> +
>  			sg_dma_len(sg) = 0;
>  			sg_dma_address(sg) = 0;
>  			sg_set_page(sg, bvec->bv_page);

Eh this wont work, it's the wrong entry... Here's a temporary
work-around.

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c89f0d3..108202b 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -822,6 +822,7 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
 		return;
 
 	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
+		sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
 	} else {
 		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ec55a17..cbfb113 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1324,8 +1324,6 @@ static int hwif_init(ide_hwif_t *hwif)
 		goto out;
 	}
 
-	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
-	
 	if (init_irq(hwif) == 0)
 		goto done;
 

-- 
Jens Axboe

