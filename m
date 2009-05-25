Return-Path: <linux-kernel-owner+w=401wt.eu-S1758738AbZEYHfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbZEYHfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 03:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753993AbZEYHd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 03:33:27 -0400
Received: from brick.kernel.dk ([93.163.65.50]:38687 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571AbZEYHbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 03:31:13 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 11/13] block: disallow merging of read-ahead bits into normal request
Date: Mon, 25 May 2009 09:31:04 +0200
Message-Id: <1243236668-3398-22-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.6.3.rc0.1.gf800
In-Reply-To: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
References: <1243236668-3398-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For SSD type devices, the request latency is really low. So for those
types of devices, we may not want to merge the read part of a request into
the read-ahead request that is also generates.

Add code to mpage.c to properly propagate read vs reada information to
the block layer and let the elevator core check and prevent such merges.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 block/elevator.c |    7 +++++++
 fs/mpage.c       |   30 ++++++++++++++++++++++++------
 2 files changed, 31 insertions(+), 6 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index 6261b24..17cfaa2 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -67,6 +67,13 @@ static int elv_iosched_allow_merge(struct request *rq, struct bio *bio)
 {
 	struct request_queue *q = rq->q;
 
+	/*
+	 * Disallow merge of a read-ahead bio into a normal request for SSD
+	 */
+	if (blk_queue_nonrot(q) &&
+	    bio_rw_ahead(bio) && !(rq->cmd_flags & REQ_FAILFAST_DEV))
+		return 0;
+
 	if (q->elv_ops.elevator_allow_merge_fn)
 		return elv_call_allow_merge_fn(q, rq, bio);
 
diff --git a/fs/mpage.c b/fs/mpage.c
index 680ba60..d02cf51 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -180,11 +180,18 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 	unsigned page_block;
 	unsigned first_hole = blocks_per_page;
 	struct block_device *bdev = NULL;
-	int length;
+	int length, rw;
 	int fully_mapped = 1;
 	unsigned nblocks;
 	unsigned relative_block;
 
+	/*
+	 * If there's some read-ahead in this range, be sure to tell
+	 * the block layer about it. We start off as a READ, then switch
+	 * to READA if we spot the read-ahead marker on the page.
+	 */
+	rw = READ;
+
 	if (page_has_buffers(page))
 		goto confused;
 
@@ -289,7 +296,7 @@ do_mpage_readpage(struct bio *bio, struct page *page, unsigned nr_pages,
 	 * This page will go to BIO.  Do we need to send this BIO off first?
 	 */
 	if (bio && (*last_block_in_bio != blocks[0] - 1))
-		bio = mpage_bio_submit(READ, bio);
+		bio = mpage_bio_submit(rw, bio);
 
 alloc_new:
 	if (bio == NULL) {
@@ -301,8 +308,19 @@ alloc_new:
 	}
 
 	length = first_hole << blkbits;
-	if (bio_add_page(bio, page, length, 0) < length) {
-		bio = mpage_bio_submit(READ, bio);
+
+	/*
+	 * If this is an SSD, don't merge the read-ahead part of the IO
+	 * with the actual request. We want the interesting part to complete
+	 * as quickly as possible.
+	 */
+	if (blk_queue_nonrot(bdev_get_queue(bdev)) &&
+	    bio->bi_size && PageReadahead(page)) {
+		bio = mpage_bio_submit(rw, bio);
+		rw = READA;
+		goto alloc_new;
+	} else if (bio_add_page(bio, page, length, 0) < length) {
+		bio = mpage_bio_submit(rw, bio);
 		goto alloc_new;
 	}
 
@@ -310,7 +328,7 @@ alloc_new:
 	nblocks = map_bh->b_size >> blkbits;
 	if ((buffer_boundary(map_bh) && relative_block == nblocks) ||
 	    (first_hole != blocks_per_page))
-		bio = mpage_bio_submit(READ, bio);
+		bio = mpage_bio_submit(rw, bio);
 	else
 		*last_block_in_bio = blocks[blocks_per_page - 1];
 out:
@@ -318,7 +336,7 @@ out:
 
 confused:
 	if (bio)
-		bio = mpage_bio_submit(READ, bio);
+		bio = mpage_bio_submit(rw, bio);
 	if (!PageUptodate(page))
 	        block_read_full_page(page, get_block);
 	else
-- 
1.6.3.rc0.1.gf800

