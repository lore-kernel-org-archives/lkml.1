Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbZCNAoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbZCNAoe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:44:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753731AbZCNATr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:47 -0400
Received: from kroah.org ([198.145.64.141]:34934 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752491AbZCNATe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:34 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:50 2009
Message-Id: <20090314000750.155500415@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jens Axboe <jens.axboe@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       =?ISO-8859-15?q?Sven=20K=C3=B6hler?= <sven.koehler@gmail.com>
Subject: [patch 73/96] xen/blkfront: use blk_rq_map_sg to generate ring entries
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=xen-blkfront-use-blk_rq_map_sg-to-generate-ring-entries.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jens Axboe <jens.axboe@oracle.com>

commit 9e973e64ac6dc504e6447d52193d4fff1a670156 upstream.

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
Cc: Sven Köhler <sven.koehler@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/xen-blkfront.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -40,6 +40,7 @@
 #include <linux/hdreg.h>
 #include <linux/cdrom.h>
 #include <linux/module.h>
+#include <linux/scatterlist.h>
 
 #include <xen/xenbus.h>
 #include <xen/grant_table.h>
@@ -82,6 +83,7 @@ struct blkfront_info
 	enum blkif_state connected;
 	int ring_ref;
 	struct blkif_front_ring ring;
+	struct scatterlist sg[BLKIF_MAX_SEGMENTS_PER_REQUEST];
 	unsigned int evtchn, irq;
 	struct request_queue *rq;
 	struct work_struct work;
@@ -203,12 +205,11 @@ static int blkif_queue_request(struct re
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
@@ -237,12 +238,13 @@ static int blkif_queue_request(struct re
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
@@ -253,16 +255,12 @@ static int blkif_queue_request(struct re
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
@@ -592,6 +590,8 @@ static int setup_blkring(struct xenbus_d
 	SHARED_RING_INIT(sring);
 	FRONT_RING_INIT(&info->ring, sring, PAGE_SIZE);
 
+	sg_init_table(info->sg, BLKIF_MAX_SEGMENTS_PER_REQUEST);
+
 	err = xenbus_grant_ring(dev, virt_to_mfn(info->ring.sring));
 	if (err < 0) {
 		free_page((unsigned long)sring);


