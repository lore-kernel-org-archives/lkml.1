Return-Path: <linux-kernel-owner+w=401wt.eu-S1757391AbXGSGNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757391AbXGSGNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 02:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750866AbXGSGNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 02:13:23 -0400
Received: from brick.kernel.dk ([80.160.20.94]:29442 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751952AbXGSGNW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 02:13:22 -0400
Date: Thu, 19 Jul 2007 08:13:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Giacomo Catenazzi <cate@cateee.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: regression: disk error loop (panic?) ide_do_rw_disk-bad:
Message-ID: <20070719061300.GP11657@kernel.dk>
References: <469D1D5E.8050609@cateee.net> <alpine.LFD.0.999.0707181313100.27353@woody.linux-foundation.org> <20070718202740.GN11657@kernel.dk> <200707190053.24578.bzolnier@gmail.com> <alpine.LFD.0.999.0707181618340.27353@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.999.0707181618340.27353@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18 2007, Linus Torvalds wrote:
> 
> 
> On Thu, 19 Jul 2007, Bartlomiej Zolnierkiewicz wrote:
> > 
> > Thanks for finding and fixing this.
> > 
> > The latest patch (with additional cleanups) also looks good and should be
> > safe enough (unchanged behavior for all non-pc requests) to merge it now.
> > 
> > Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> 
> Ok, Jens - mind signing off on the patch you sent out, and writing an 
> explanatory message? Feel free to just crib from my explanation of my 
> original patch, or whatever.

Sure thing, it's below.

> And it would be beautiful if people who saw the bad behaviour before
> reverting the ide.c changes were to go back to that broken state, and
> try the patch, and just verify that it acts like it should (ie you
> should see just a few error messages, and it shouldn't cause the IDE
> layer to go ballistic any more).

---

[PATCH] IDE: fix termination of non-fs requests

ide-disk calls

        ide_end_request(drive, 0, 0);

to finish an unknown request, but this doesn't work so well for non-fs
requests, since ide_end_request() internally looks at ->hard_cur_sectors
to see how much data to end. Only file system requests store a transfer
value in there, pc requests fill out ->data_len as a byte based transfer
value instead.

Since we ask to end 0 bytes of that request, it will never be terminated
and ide-disk gets stuck in a loop "handling" that same request over and
over.

Switch __ide_end_request() to take a byte based transfer count, and
adjust ide_end_request() to look at the right field to determine how
much IO to end when it's being passed in 0.

Acked-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jens Axboe <jens.axboe@oracle.com>

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

