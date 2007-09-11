Return-Path: <linux-kernel-owner+w=401wt.eu-S933767AbXIKTAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933767AbXIKTAA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 15:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933395AbXIKS72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:59:28 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933623AbXIKS70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:59:26 -0400
Date: Tue, 11 Sep 2007 14:58:38 -0400 (EDT)
Message-Id: <20070911.145838.98716522.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
       mike.miller@hp.com, grant.likely@secretlab.ca
Cc: dm-devel@redhat.com, j-nomura@ce.jp.nec.com, k-ueda@ct.jp.nec.com
Subject: [PATCH 07/27] blk_end_request: changing floppy (take 2)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 3.3 on Emacs 21.3 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts floppy to use blk_end_request().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/floppy.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff -rupN 06-dac960-caller-change/drivers/block/floppy.c 07-floppy-caller-change/drivers/block/floppy.c
--- 06-dac960-caller-change/drivers/block/floppy.c	2007-09-10 17:32:11.000000000 -0400
+++ 07-floppy-caller-change/drivers/block/floppy.c	2007-09-10 18:01:23.000000000 -0400
@@ -2290,18 +2290,16 @@ static int do_format(int drive, struct f
 static void floppy_end_request(struct request *req, int uptodate)
 {
 	unsigned int nr_sectors = current_count_sectors;
+	unsigned int drive = (unsigned int)req->rq_disk->private_data;
 
 	/* current_count_sectors can be zero if transfer failed */
 	if (!uptodate)
 		nr_sectors = req->current_nr_sectors;
-	if (end_that_request_first(req, uptodate, nr_sectors))
+	if (__blk_end_request(req, uptodate, nr_sectors << 9))
 		return;
-	add_disk_randomness(req->rq_disk);
-	floppy_off((long)req->rq_disk->private_data);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 
 	/* We're done with the request */
+	floppy_off(drive);
 	current_req = NULL;
 }
 
