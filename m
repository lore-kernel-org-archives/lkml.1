Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbXEPIe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbXEPIe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759305AbXEPIdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:33:14 -0400
Received: from brick.kernel.dk ([80.160.20.94]:7080 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757792AbXEPIdL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:33:11 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 4/10] block: convert to using sg helpers
Date: Wed, 16 May 2007 10:31:34 +0200
Message-Id: <11793043002221-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <1179304300358-git-send-email-jens.axboe@oracle.com>
References: <1179304300358-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the main rq mapper (blk_rq_map_sg()) to the sg helper setup.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/ll_rw_blk.c |   19 ++++++++++++-------
 1 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index d99d402..0ad4c34 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -30,6 +30,7 @@
 #include <linux/cpu.h>
 #include <linux/blktrace_api.h>
 #include <linux/fault-inject.h>
+#include <linux/scatterlist.h>
 
 /*
  * for max sense size
@@ -1307,9 +1308,11 @@ static int blk_hw_contig_segment(request_queue_t *q, struct bio *bio,
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
  */
-int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg)
+int blk_rq_map_sg(request_queue_t *q, struct request *rq,
+		  struct scatterlist *sglist)
 {
 	struct bio_vec *bvec, *bvprv;
+	struct scatterlist *next_sg, *sg;
 	struct bio *bio;
 	int nsegs, i, cluster;
 
@@ -1320,6 +1323,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
 	 * for each bio in rq
 	 */
 	bvprv = NULL;
+	sg = next_sg = &sglist[0];
 	rq_for_each_bio(bio, rq) {
 		/*
 		 * for each segment in bio
@@ -1328,7 +1332,7 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
 			int nbytes = bvec->bv_len;
 
 			if (bvprv && cluster) {
-				if (sg[nsegs - 1].length + nbytes > q->max_segment_size)
+				if (sg->length + nbytes > q->max_segment_size)
 					goto new_segment;
 
 				if (!BIOVEC_PHYS_MERGEABLE(bvprv, bvec))
@@ -1336,14 +1340,15 @@ int blk_rq_map_sg(request_queue_t *q, struct request *rq, struct scatterlist *sg
 				if (!BIOVEC_SEG_BOUNDARY(q, bvprv, bvec))
 					goto new_segment;
 
-				sg[nsegs - 1].length += nbytes;
+				sg->length += nbytes;
 			} else {
 new_segment:
-				memset(&sg[nsegs],0,sizeof(struct scatterlist));
-				sg[nsegs].page = bvec->bv_page;
-				sg[nsegs].length = nbytes;
-				sg[nsegs].offset = bvec->bv_offset;
+				sg = next_sg;
+				next_sg = sg_next(sg);
 
+				sg->page = bvec->bv_page;
+				sg->length = nbytes;
+				sg->offset = bvec->bv_offset;
 				nsegs++;
 			}
 			bvprv = bvec;
-- 
1.5.2.rc1

