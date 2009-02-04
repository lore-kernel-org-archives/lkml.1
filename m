Return-Path: <linux-kernel-owner+w=401wt.eu-S1758273AbZBDT4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273AbZBDT4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 14:56:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753410AbZBDTzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 14:55:53 -0500
Received: from gw.goop.org ([64.81.55.164]:51759 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752559AbZBDTzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 14:55:53 -0500
Message-ID: <4989F2C5.6060405@goop.org>
Date: Wed, 04 Feb 2009 11:55:49 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg Harris <greg.harris@metacarta.com>,
       "Christopher S. Aker" <caker@theshore.net>
CC: Xen-devel <xen-devel@lists.xensource.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [TEST PATCH] xen/blkfront: use blk_rq_map_sg to generate ring entries
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Axboe <jens.axboe@oracle.com>

On occasion, the request will apparently have more segments than we
fit into the ring. Jens says:

> The second problem is that the block layer then appears to create one
> too many segments, but from the dump it has rq->nr_phys_segments ==
> BLKIF_MAX_SEGMENTS_PER_REQUEST. I suspect the latter is due to
> xen-blkfront not handling the merging on its own. It should check that
> the new page doesn't form part of the previous page. The
> rq_for_each_segment() iterates all single bits in the request, not dma
> segments. The "easiest" way to do this is to call blk_rq_map_sg() and
> then iterate the mapped sg list. That will give you what you are
> looking for.

> Here's a test patch, compiles but otherwise untested. I spent more
> time figuring out how to enable XEN than to code it up, so YMMV!
> Probably the sg list wants to be put inside the ring and only
> initialized on allocation, then you can get rid of the sg on stack and
> sg_init_table() loop call in the function. I'll leave that, and the
> testing, to you.

[Moved sg array into info structure, and initialize once. -J]

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 drivers/block/xen-blkfront.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

===================================================================
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -40,6 +40,7 @@
 #include <linux/hdreg.h>
 #include <linux/cdrom.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
 
 #include <xen/xenbus.h>
 #include <xen/grant_table.h>
@@ -82,6 +83,7 @@
 	enum blkif_state connected;
 	int ring_ref;
 	struct blkif_front_ring ring;
+	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	unsigned int evtchn, irq;
 	struct request_queue *rq;
 	struct work_struct work;
@@ -204,12 +206,11 @@
 	struct blkfront_info *info = req->rq_disk->private_data;
 	unsigned long buffer_mfn;
 	struct blkif_request *ring_req;
-	struct req_iterator iter;
-	struct bio_vec *bvec;
 	unsigned long id;
 	unsigned int fsect, lsect;
-	int ref;
+	int i, ref;
 	grant_ref_t gref_head;
+	struct scatterlist *sg;
 
 	if (unlikely(info->connected != BLKIF_STATE_CONNECTED))
 		return 1;
@@ -238,12 +239,13 @@
 	if (blk_barrier_rq(req))
 		ring_req->operation = BLKIF_OP_WRITE_BARRIER;
 
-	ring_req->nr_segments = 0;
-	rq_for_each_segment(bvec, req, iter) {
-		BUG_ON(ring_req->nr_segments == BLKIF_MAX_SEGMENTS_PER_REQUEST);
-		buffer_mfn = pfn_to_mfn(page_to_pfn(bvec->bv_page));
-		fsect = bvec->bv_offset >> 9;
-		lsect = fsect + (bvec->bv_len >> 9) - 1;
+	ring_req->nr_segments = blk_rq_map_sg(req->q, req, info->sg);
+	BUG_ON(ring_req->nr_segments > BLKIF_MAX_SEGMENTS_PER_REQUEST);
+
+	for_each_sg(info->sg, sg, ring_req->nr_segments, i) {
+		buffer_mfn = pfn_to_mfn(page_to_pfn(sg_page(sg)));
+		fsect = sg->offset >> 9;
+		lsect = fsect + (sg->length >> 9) - 1;
 		/* install a grant reference. */
 		ref = gnttab_claim_grant_reference(&gref_head);
 		BUG_ON(ref == -ENOSPC);
@@ -254,16 +256,12 @@
 				buffer_mfn,
 				rq_data_dir(req) );
 
-		info->shadow[id].frame[ring_req->nr_segments] =
-				mfn_to_pfn(buffer_mfn);
-
-		ring_req->seg[ring_req->nr_segments] =
+		info->shadow[id].frame[i] = mfn_to_pfn(buffer_mfn);
+		ring_req->seg[i] =
 				(struct blkif_request_segment) {
 					.gref       = ref,
 					.first_sect = fsect,
 					.last_sect  = lsect };
-
-		ring_req->nr_segments++;
 	}
 
 	info->ring.req_prod_pvt++;
@@ -622,6 +620,8 @@
 	SHARED_RING_INIT(sring);
 	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
+	sg_init_table(info->sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
+
 	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
 	if (err < 0) {
 		free_page((unsigned long)sring);


