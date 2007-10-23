Return-Path: <linux-kernel-owner+w=401wt.eu-S1754030AbXJWHY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbXJWHY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 03:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbXJWHYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 03:24:50 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11105 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752387AbXJWHYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 03:24:50 -0400
Date: Tue, 23 Oct 2007 09:23:24 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: davem@davemloft.net, linux-kernel@vger.kernel.org
Subject: Re: IDE crash...
Message-ID: <20071023072324.GG25962@kernel.dk>
References: <20071022.235010.59469063.davem@davemloft.net> <20071023070252.GA25962@kernel.dk> <20071023070932.GB25962@kernel.dk> <20071023161416W.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023161416W.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007, FUJITA Tomonori wrote:
> On Tue, 23 Oct 2007 09:09:33 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Tue, Oct 23 2007, Jens Axboe wrote:
> > > On Mon, Oct 22 2007, David Miller wrote:
> > > > 
> > > > I'm debugging a blk_rq_map_sg() crash that i'm getting on sparc64 as
> > > > root is mounted over IDE.  I think I know what is happening now.
> > > > 
> > > > The IDE sg table is allocated and initialized like this in
> > > > drivers/ide/ide-probe.c:
> > > > 
> > > > 	x = kmalloc(sizeof(struct scatterlist) * nents, GFP_XXX);
> > > > 	sg_init_table(x, nents);
> > > > 
> > > > So far, so good.
> > > > 
> > > > Now, ide_map_sg() passes requests down to blk_rq_map_sg() like this in
> > > > drivers/block/ide-io.c:
> > > > 
> > > > 		hwif->sg_nents = blk_rq_map_sg(drive->queue, rq, sg);
> > > > 
> > > > Ok, so what does blk_rq_map_sg() do?
> > > > 
> > > > 	sg = NULL;
> > > > 	rq_for_each_segment(bvec, rq, iter) {
> > > >  ...
> > > > 		if (bvprv && cluster) {
> > > >  ...
> > > > 		} else {
> > > > new_segment:
> > > > 			if (!sg)
> > > > 				sg = sglist;
> > > > 			else
> > > > 				sg = sg_next(sg);
> > > >  ...
> > > > 		}
> > > > 		bvprv = bvec;
> > > > 	} /* segments in rq */
> > > > 
> > > > 	if (sg)
> > > > 		__sg_mark_end(sg);
> > > > 
> > > > So let's say the first request comes in and needs 2 segs.
> > > > This will mark sg[1].page_link with 0x2
> > > > 
> > > > If the next request from IDE needs 4 segs, we'll OOPS because
> > > > sg_next() on &sg[1] will see page_link bit 0x2 is set and
> > > > therefore return NULL.
> > > > 
> > > > A quick look shows that if you're testing on SCSI (or something
> > > > layered on top of it like SATA or PATA) you won't see this seemingly
> > > > guarenteed crash because the SCSI mid-layer allocates a fresh sglist
> > > > via mempool_alloc() and runs sg_init_table() on it for every I/O
> > > > request.
> > > 
> > > We should never see the end pointer in blk_rq_map_sg(), or that's a bug
> > > in the driver. So it should be OK to just clear the end pointer always
> > > in there, even if it's not the prettiest solution...
> > > 
> > > This just needs to be wrapped up in some scatterlist.h macro/function.
> > > 
> > > diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
> > > index 61c2e39..a3bda2f 100644
> > > --- a/block/ll_rw_blk.c
> > > +++ b/block/ll_rw_blk.c
> > > @@ -1354,6 +1354,12 @@ new_segment:
> > >  			else
> > >  				sg = sg_next(sg);
> > >  
> > > +			/*
> > > +			 * Clear end-of-table pointer, we'll mark a new one
> > > +			 * at the end
> > > +			 */
> > > +			sg->page_link &= ~0x2;
> > > +
> > >  			sg_dma_len(sg) = 0;
> > >  			sg_dma_address(sg) = 0;
> > >  			sg_set_page(sg, bvec->bv_page);
> > 
> > Eh this wont work, it's the wrong entry... Here's a temporary
> > work-around.
> 
> Yeah, it won't work. Now we must call sg_init_table for every I/O
> request (it's not nice).

I think the fix would be to have a sg_next_and_clear() or something that
doesn't honor the 0x02 termination bit and clears it, for the cases
where you KNOW that there are more entries.

> I think that there are other blk_rq_map_sg users need such fix.

Possibly, I did do quite a few of them. Alternatively, we can remove
__sg_mark_end() and leave that up to the driver.


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

