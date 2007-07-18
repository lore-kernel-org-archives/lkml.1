Return-Path: <linux-kernel-owner+w=401wt.eu-S1760962AbXGRUMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962AbXGRUMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 16:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753313AbXGRUMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 16:12:17 -0400
Received: from brick.kernel.dk ([80.160.20.94]:14078 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754078AbXGRUMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 16:12:17 -0400
Date: Wed, 18 Jul 2007 22:11:53 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Message-ID: <20070718201152.GL11657@kernel.dk>
References: <469D1D5E.8050609@cateee.net> <200707172320.12141.bzolnier@gmail.com> <alpine.LFD.0.999.0707181238500.27353@woody.linux-foundation.org> <20070718200835.GK11657@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070718200835.GK11657@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18 2007, Jens Axboe wrote:
> Better still would be to make __ide_end_request() take a byte count
> instead and use end_that_request_chunk(). Then you can get rid of the
> rounding as well.

Ala:

diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index c5b5011..f9de798 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -55,7 +55,7 @@
 #include <asm/bitops.h>
 
 static int __ide_end_request(ide_drive_t *drive, struct request *rq,
-			     int uptodate, int nr_sectors)
+			     int uptodate, unsigned int nr_bytes)
 {
 	int ret = 1;
 
@@ -64,7 +64,7 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 	 * complete the whole request right now
 	 */
 	if (blk_noretry_request(rq) && end_io_error(uptodate))
-		nr_sectors = rq->hard_nr_sectors;
+		nr_bytes = rq->hard_nr_sectors << 9;
 
 	if (!blk_fs_request(rq) && end_io_error(uptodate) && !rq->errors)
 		rq->errors = -EIO;
@@ -78,7 +78,7 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 		HWGROUP(drive)->hwif->ide_dma_on(drive);
 	}
 
-	if (!end_that_request_first(rq, uptodate, nr_sectors)) {
+	if (!end_that_request_chunk(rq, uptodate, nr_bytes)) {
 		add_disk_randomness(rq->rq_disk);
 		if (!list_empty(&rq->queuelist))
 			blkdev_dequeue_request(rq);
@@ -103,6 +103,7 @@ static int __ide_end_request(ide_drive_t *drive, struct request *rq,
 
 int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 {
+	unsigned int nr_bytes = nr_sectors << 9;
 	struct request *rq;
 	unsigned long flags;
 	int ret = 1;
@@ -114,10 +115,14 @@ int ide_end_request (ide_drive_t *drive, int uptodate, int nr_sectors)
 	spin_lock_irqsave(&ide_lock, flags);
 	rq = HWGROUP(drive)->rq;
 
-	if (!nr_sectors)
-		nr_sectors = rq->hard_cur_sectors;
+	if (!nr_bytes) {
+		if (blk_pc_request(rq))
+			nr_bytes = rq->data_len;
+		else
+			nr_bytes = rq->hard_cur_sectors << 9;
+	}
 
-	ret = __ide_end_request(drive, rq, uptodate, nr_sectors);
+	ret = __ide_end_request(drive, rq, uptodate, nr_bytes);
 
 	spin_unlock_irqrestore(&ide_lock, flags);
 	return ret;

-- 
Jens Axboe

