Return-Path: <linux-kernel-owner+w=401wt.eu-S1763484AbZEHDEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763484AbZEHDEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762839AbZEHC5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:36322 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762355AbZEHC5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:57:25 -0400
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
Subject: [PATCH 12/18] xd: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:10 +0900
Message-Id: <1241751256-17435-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xd processes requests one-by-one synchronously and can be easily
converted to dequeueing model.  Convert it.

While at it, use rq_cur_bytes instead of rq_bytes when checking for
sector overflow.  This is for for consistency and better behavior for
merged requests.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/xd.c |   29 +++++++++++++++++------------
 1 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 4ef8801..d4c4352 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -305,26 +305,31 @@ static void do_xd_request (struct request_queue * q)
 	if (xdc_busy)
 		return;
 
-	while ((req = elv_next_request(q)) != NULL) {
+	req = elv_next_request(q);
+	if (req)
+		blkdev_dequeue_request(req);
+
+	while (req) {
 		unsigned block = blk_rq_pos(req);
-		unsigned count = blk_rq_sectors(req);
+		unsigned count = blk_rq_cur_sectors(req);
 		XD_INFO *disk = req->rq_disk->private_data;
-		int res = 0;
+		int res = -EIO;
 		int retry;
 
-		if (!blk_fs_request(req)) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
-		if (block + count > get_capacity(req->rq_disk)) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
+		if (!blk_fs_request(req))
+			goto done;
+		if (block + count > get_capacity(req->rq_disk))
+			goto done;
 		for (retry = 0; (retry < XD_RETRIES) && !res; retry++)
 			res = xd_readwrite(rq_data_dir(req), disk, req->buffer,
 					   block, count);
+	done:
 		/* wrap up, 0 = success, -errno = fail */
-		__blk_end_request_cur(req, res);
+		if (!__blk_end_request_cur(req, res)) {
+			req = elv_next_request(q);
+			if (req)
+				blkdev_dequeue_request(req);
+		}
 	}
 }
 
-- 
1.6.0.2

