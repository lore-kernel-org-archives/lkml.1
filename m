Return-Path: <linux-kernel-owner+w=401wt.eu-S1763823AbZEHDDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763823AbZEHDDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762666AbZEHC5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:36274 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757627AbZEHC4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:44 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, rusty@rustcorp.com.au,
       James.Bottomley@HansenPartnership.com, mike.miller@hp.com,
       donari75@gmail.com, paul.clements@steeleye.com, tim@cyberelk.net,
       Geert.Uytterhoeven@sonycom.com, davem@davemloft.net,
       Laurent@lvivier.info, jgarzik@pobox.com, jeremy@xensource.com,
       grant.likely@secretlab.ca, adrian@mcmen.demon.co.uk,
       sfr@canb.auug.org.au, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, oakad@yahoo.com, drzeus@drzeus.cx,
       dwmw2@infradead.org, Markus.Lidel@shadowconnect.com, wein@de.ibm.com,
       schwidefsky@de.ibm.com, zaitcev@redhat.com,
       fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 11/18] swim: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:09 +0900
Message-Id: <1241751256-17435-12-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swim processes requests one-by-one synchronously and can easily be
converted to dequeuing model.  Convert it.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Laurent Vivier <Laurent@lvivier.info>
---
 drivers/block/swim.c |   47 +++++++++++++++++++++++------------------------
 1 files changed, 23 insertions(+), 24 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index fc6a1c3..dedd489 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -514,7 +514,7 @@ static int floppy_read_sectors(struct floppy_state *fs,
 			ret = swim_read_sector(fs, side, track, sector,
 						buffer);
 			if (try-- == 0)
-				return -1;
+				return -EIO;
 		} while (ret != 512);
 
 		buffer += ret;
@@ -528,38 +528,37 @@ static void redo_fd_request(struct request_queue *q)
 	struct request *req;
 	struct floppy_state *fs;
 
-	while ((req = elv_next_request(q))) {
+	req = elv_next_request(q);
+	if (req)
+		blkdev_dequeue_request(req);
+
+	while (req) {
+		int err = -EIO;
 
 		fs = req->rq_disk->private_data;
-		if (blk_rq_pos(req) >= fs->total_secs) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
-		if (!fs->disk_in) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
-		if (rq_data_dir(req) == WRITE) {
-			if (fs->write_protected) {
-				__blk_end_request_cur(req, -EIO);
-				continue;
-			}
-		}
+		if (blk_rq_pos(req) >= fs->total_secs)
+			goto done;
+		if (!fs->disk_in)
+			goto done;
+		if (rq_data_dir(req) == WRITE && fs->write_protected)
+			goto done;
+
 		switch (rq_data_dir(req)) {
 		case WRITE:
 			/* NOT IMPLEMENTED */
-			__blk_end_request_cur(req, -EIO);
 			break;
 		case READ:
-			if (floppy_read_sectors(fs, blk_rq_pos(req),
-						blk_rq_cur_sectors(req),
-						req->buffer)) {
-				__blk_end_request_cur(req, -EIO);
-				continue;
-			}
-			__blk_end_request_cur(req, 0);
+			err = floppy_read_sectors(fs, blk_rq_pos(req),
+						  blk_rq_cur_sectors(req),
+						  req->buffer);
 			break;
 		}
+	done:
+		if (!__blk_end_request_cur(req, err)) {
+			req = elv_next_request(q);
+			if (req)
+				blkdev_dequeue_request(req);
+		}
 	}
 }
 
-- 
1.6.0.2

