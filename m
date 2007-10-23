Return-Path: <linux-kernel-owner+w=401wt.eu-S1754508AbXJWHZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508AbXJWHZd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:25:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbXJWHZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:25:25 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11111 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752797AbXJWHZZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:25:25 -0400
Date: Tue, 23 Oct 2007 09:23:59 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org
Subject: Re: IDE crash...
Message-ID: <20071023072359.GH25962@kernel.dk>
References: <20071022.235010.59469063.davem@davemloft.net> <20071023070252.GA25962@kernel.dk> <20071023070932.GB25962@kernel.dk> <20071023.001850.130236174.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023.001850.130236174.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, David Miller wrote:
> From: Jens Axboe <jens.axboe@oracle.com>
> Date: Tue, 23 Oct 2007 09:09:33 +0200
> 
> > Eh this wont work, it's the wrong entry... Here's a temporary
> > work-around.
> > 
> > diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
> > index c89f0d3..108202b 100644
> > --- a/drivers/ide/ide-io.c
> > +++ b/drivers/ide/ide-io.c
> > @@ -822,6 +822,7 @@ void ide_map_sg(ide_drive_t *drive, struct request *rq)
> >  		return;
> >  
> >  	if (rq->cmd_type != REQ_TYPE_ATA_TASKFILE) {
> > +		sg_init_table(hwif->sg_table, hwif->sg_max_nents);
> >  		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> >  	} else {
> >  		sg_init_one(sg, rq->buffer, rq->nr_sectors * SECTOR_SIZE);
> 
> That's the exact patch I'm about to boot test :-)

That should work - once you verify that, would you mind testing this one
as well? Thanks!

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 61c2e39..290836f 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1352,7 +1352,7 @@ new_segment:
 			if (!sg)
 				sg = sglist;
 			else
-				sg = sg_next(sg);
+				sg = sg_next_force(sg);
 
 			sg_dma_len(sg) = 0;
 			sg_dma_address(sg) = 0;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 42daf5e..a98a2ee 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -99,6 +99,22 @@ static inline struct scatterlist *sg_next(struct scatterlist *sg)
 	return sg;
 }
 
+/**
+ * sg_next_force - return the next scatterlist entry in a list
+ * @sg:		   The current sg entry
+ *
+ * Description:
+ *   Must only be used when more entries beyond this one is known to exist,
+ *   as it clears the termination bit. Useful to avoid adding a full sg
+ *   table init on every mapping.
+ *
+ **/
+static inline struct scatterlist *sg_next_force(struct scatterlist *sg)
+{
+	sg->page_link &= ~0x02;
+	return sg_next(sg);
+}
+
 /*
  * Loop over each sg element, following the pointer to a new list if necessary
  */

-- 
Jens Axboe

