Return-Path: <linux-kernel-owner+w=401wt.eu-S1763128AbZEHDEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763128AbZEHDEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762757AbZEHC5U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:20 -0400
Received: from hera.kernel.org ([140.211.167.34]:36307 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762390AbZEHC5G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:57:06 -0400
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
Subject: [PATCH 15/18] z2ram: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:13 +0900
Message-Id: <1241751256-17435-16-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

z2ram processes requests one-by-one synchronously and can be easily
converted to dequeueing model.  Convert it.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/z2ram.c |   19 +++++++++++++++----
 1 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 6a13838..c909c1a 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -70,15 +70,21 @@ static struct gendisk *z2ram_gendisk;
 static void do_z2_request(struct request_queue *q)
 {
 	struct request *req;
-	while ((req = elv_next_request(q)) != NULL) {
+
+	req = elv_next_request(q);
+	if (req)
+		blkdev_dequeue_request(req);
+
+	while (req) {
 		unsigned long start = blk_rq_pos(req) << 9;
 		unsigned long len  = blk_rq_cur_bytes(req);
+		int err = 0;
 
 		if (start + len > z2ram_size) {
 			printk( KERN_ERR DEVICE_NAME ": bad access: block=%lu, count=%u\n",
 				blk_rq_pos(req), blk_rq_cur_sectors(req));
-			__blk_end_request_cur(req, -EIO);
-			continue;
+			err = -EIO;
+			goto done;
 		}
 		while (len) {
 			unsigned long addr = start & Z2RAM_CHUNKMASK;
@@ -93,7 +99,12 @@ static void do_z2_request(struct request_queue *q)
 			start += size;
 			len -= size;
 		}
-		__blk_end_request_cur(req, 0);
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

