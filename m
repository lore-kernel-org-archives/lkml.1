Return-Path: <linux-kernel-owner+w=401wt.eu-S1761674AbZDSQOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761674AbZDSQOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 12:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761132AbZDSQO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 12:14:29 -0400
Received: from havoc.gtf.org ([69.61.125.42]:37955 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761109AbZDSQO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 12:14:28 -0400
Date: Sun, 19 Apr 2009 12:14:27 -0400
From: Jeff Garzik <jeff@garzik.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, axboe@kernel.dk,
       hch@lst.de
Subject: [PATCH 2/2] Fix bugs found during bio_list update
Message-ID: <20090419161427.GB12531@havoc.gtf.org>
References: <20090419161234.GA12105@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090419161234.GA12105@havoc.gtf.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Note - the very first change is not so much a fix as a cleanup.
bio_list_pop(), however, is a fix.

commit 18f987e9059c08bd61e5bded13d019cf521ada13
Author: Jeff Garzik <jeff@garzik.org>
Date:   Sun Apr 19 12:01:55 2009 -0400

    block: Be sure to initialize bio list tail properly
    
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

 block/blk-core.c  |    5 +++--
 block/blk-map.c   |    3 ++-
 block/blk-merge.c |    2 +-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0ec8621..a2cd281 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1753,11 +1753,12 @@ static int __end_that_request_first(struct request *req, int error,
 	blk_account_io_completion(req, nr_bytes);
 
 	total_bytes = bio_nbytes = 0;
-	while ((bio = req->bio_list.head) != NULL) {
+	bio = req->bio_list.head;
+	while (bio) {
 		int nbytes;
 
 		if (nr_bytes >= bio->bi_size) {
-			req->bio_list.head = bio->bi_next;
+			bio_list_pop(&req->bio_list);
 			nbytes = bio->bi_size;
 			req_bio_endio(req, bio, nbytes, error);
 			next_idx = 0;
diff --git a/block/blk-map.c b/block/blk-map.c
index 437b916..ca849d3 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -159,7 +159,7 @@ int blk_rq_map_user(struct request_queue *q, struct request *rq,
 	return 0;
 unmap_rq:
 	blk_rq_unmap_user(bio);
-	rq->bio_list.head = NULL;
+	rq->bio_list.head = rq->bio_list.tail = NULL;
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_user);
@@ -312,6 +312,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 
 	blk_rq_bio_prep(q, rq, bio);
 	blk_queue_bounce(q, &rq->bio_list.head);
+	rq->bio_list.tail = rq->bio_list.head;
 	rq->buffer = rq->data = NULL;
 	return 0;
 }
diff --git a/block/blk-merge.c b/block/blk-merge.c
index a1a23ae..6dc74d8 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -409,7 +409,7 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 		req->cpu = next->cpu;
 
 	/* owner-ship of bio passed from next to req */
-	next->bio_list.head = NULL;
+	next->bio_list.head = next->bio_list.tail = NULL;
 	__blk_put_request(q, next);
 	return 1;
 }
