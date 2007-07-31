Return-Path: <linux-kernel-owner+w=401wt.eu-S936275AbXGaC0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936275AbXGaC0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:26:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763431AbXGaCSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:18:12 -0400
Received: from ns1.suse.de ([195.135.220.2]:52818 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939599AbXGaCSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:18:09 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:17:53 +1000
Message-Id: <1070731021753.25466@suse.de>
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 024 of 35] Allow request bio list not to end with NULL
References: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


If we are going to share a bio between requests, then the
last bio in a list may not point to NULL, but may point to
the next bio in a different list.
So instead of testing if ->bi_next is NULL, test if the bio
matches rq->biotail.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c        |    8 ++++----
 ./drivers/block/cciss.c    |   16 +++++++++-------
 ./drivers/block/cpqarray.c |   18 ++++++++----------
 ./include/linux/blkdev.h   |    5 +++--
 4 files changed, 24 insertions(+), 23 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2007-07-31 11:21:07.000000000 +1000
+++ ./block/ll_rw_blk.c	2007-07-31 11:21:14.000000000 +1000
@@ -1196,13 +1196,10 @@ EXPORT_SYMBOL(blk_dump_rq_flags);
 void blk_recount_segments(struct request_queue *q, struct bio *bio)
 {
 	struct request rq;
-	struct bio *nxt = bio->bi_next;
 	rq.q = q;
 	rq.bio = rq.biotail = bio;
 	rq.first_offset = 0;
-	bio->bi_next = NULL;
 	blk_recalc_rq_segments(&rq);
-	bio->bi_next = nxt;
 	bio->bi_phys_segments = rq.nr_phys_segments;
 	bio->bi_hw_segments = rq.nr_hw_segments;
 	bio->bi_flags |= (1 << BIO_SEG_VALID);
@@ -3416,7 +3413,10 @@ static int __end_that_request_first(stru
 		int nbytes;
 
 		if (nr_bytes >= bio->bi_size) {
-			req->bio = bio->bi_next;
+			if (req->bio == req->biotail)
+				req->bio = NULL;
+			else
+				req->bio = bio->bi_next;
 			nbytes = bio->bi_size;
 			if (!ordered_bio_endio(req, bio, error))
 				bio_endio(bio, error);

diff .prev/drivers/block/cciss.c ./drivers/block/cciss.c
--- .prev/drivers/block/cciss.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/block/cciss.c	2007-07-31 11:21:14.000000000 +1000
@@ -1187,15 +1187,17 @@ static int cciss_ioctl(struct inode *ino
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int status)
+static inline void complete_buffers(struct request *req, int status)
 {
-	while (bio) {
-		struct bio *xbh = bio->bi_next;
-		int nr_sectors = bio_sectors(bio);
+	while (req->bio) {
+		struct bio *bio = req->bio;
+
+		if (bio == req->biotail)
+			req->bio = NULL;
+		else
+			req->bio = bio->bi_next;
 
-		bio->bi_next = NULL;
 		bio_endio(bio, status ? 0 : -EIO);
-		bio = xbh;
 	}
 }
 
@@ -1264,7 +1266,7 @@ static void cciss_softirq_done(struct re
 		pci_unmap_page(h->pdev, temp64.val, cmd->SG[i].Len, ddir);
 	}
 
-	complete_buffers(rq->bio, (rq->errors == 0));
+	complete_buffers(rq, (rq->errors == 0));
 
 	if (blk_fs_request(rq)) {
 		const int rw = rq_data_dir(rq);

diff .prev/drivers/block/cpqarray.c ./drivers/block/cpqarray.c
--- .prev/drivers/block/cpqarray.c	2007-07-31 11:20:51.000000000 +1000
+++ ./drivers/block/cpqarray.c	2007-07-31 11:21:14.000000000 +1000
@@ -166,7 +166,6 @@ static void start_io(ctlr_info_t *h);
 
 static inline void addQ(cmdlist_t **Qptr, cmdlist_t *c);
 static inline cmdlist_t *removeQ(cmdlist_t **Qptr, cmdlist_t *c);
-static inline void complete_buffers(struct bio *bio, int ok);
 static inline void complete_command(cmdlist_t *cmd, int timeout);
 
 static irqreturn_t do_ida_intr(int irq, void *dev_id);
@@ -979,18 +978,17 @@ static void start_io(ctlr_info_t *h)
 	}
 }
 
-static inline void complete_buffers(struct bio *bio, int ok)
+static inline void complete_buffers(struct request *req, int ok)
 {
-	struct bio *xbh;
-	while(bio) {
-		int nr_sectors = bio_sectors(bio);
+	while (req->bio) {
+		struct bio *bio = req->bio;
 
-		xbh = bio->bi_next;
-		bio->bi_next = NULL;
+		if (bio == req->biotail)
+			req->bio = NULL;
+		else
+			req->bio = bio->bi_next;
 		
 		bio_endio(bio, ok ? 0 : -EIO);
-
-		bio = xbh;
 	}
 }
 /*
@@ -1030,7 +1028,7 @@ static inline void complete_command(cmdl
                 pci_unmap_page(hba[cmd->ctlr]->pci_dev, cmd->req.sg[i].addr,
 				cmd->req.sg[i].size, ddir);
 
-	complete_buffers(rq->bio, ok);
+	complete_buffers(rq, ok);
 
 	if (blk_fs_request(rq)) {
 		const int rw = rq_data_dir(rq);

diff .prev/include/linux/blkdev.h ./include/linux/blkdev.h
--- .prev/include/linux/blkdev.h	2007-07-31 11:21:07.000000000 +1000
+++ ./include/linux/blkdev.h	2007-07-31 11:21:14.000000000 +1000
@@ -660,12 +660,13 @@ struct req_iterator {
 };
 #define rq_for_each_segment(rq, _iter, bvec)	\
 	for (_iter.bio = (rq)->bio, _iter.offset = (rq)->first_offset;	       \
-	     _iter.bio;							       \
+	     _iter.bio && _iter.bio != rq->biotail->bi_next;		       \
 	     _iter.bio = _iter.bio->bi_next, _iter.offset = 0) 		       \
 		bio_for_each_segment_offset(bvec, _iter.bio, _iter.i,	       \
 			_iter.offset)
 
-#define rq_iter_last(rq, _iter) (_iter.bio->bi_next == NULL && 	\
+#define rq_iter_last(rq, _iter) ((_iter.bio->bi_next == NULL ||		\
+				  _iter.bio == rq->biotail) &&		\
 				 _iter.i.i == _iter.bio->bi_vcnt - 1)
 
 extern int blk_register_queue(struct gendisk *disk);
