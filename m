Return-Path: <linux-kernel-owner+w=401wt.eu-S1760858AbZEHDCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760858AbZEHDCE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762354AbZEHC5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:36264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756691AbZEHC4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 22:56:40 -0400
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
Subject: [PATCH 14/18] jsflash: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:12 +0900
Message-Id: <1241751256-17435-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:34 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jsflash processes requests one-by-one synchronously from a kthread and
can be easily converted to dequeueing model.  Convert it.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Pete Zaitcev <zaitcev@redhat.com>
---
 drivers/sbus/char/jsflash.c |   28 +++++++++++++++++-----------
 1 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/drivers/sbus/char/jsflash.c b/drivers/sbus/char/jsflash.c
index d56ddaa..f572a4a 100644
--- a/drivers/sbus/char/jsflash.c
+++ b/drivers/sbus/char/jsflash.c
@@ -186,31 +186,37 @@ static void jsfd_do_request(struct request_queue *q)
 {
 	struct request *req;
 
-	while ((req = elv_next_request(q)) != NULL) {
+	req = elv_next_request(q);
+	if (req)
+		blkdev_dequeue_request(req);
+
+	while (req) {
 		struct jsfd_part *jdp = req->rq_disk->private_data;
 		unsigned long offset = blk_rq_pos(req) << 9;
 		size_t len = blk_rq_cur_bytes(req);
+		int err = -EIO;
 
-		if ((offset + len) > jdp->dsize) {
-			__blk_end_request_cur(req, -EIO);
-			continue;
-		}
+		if ((offset + len) > jdp->dsize)
+			goto end;
 
 		if (rq_data_dir(req) != READ) {
 			printk(KERN_ERR "jsfd: write\n");
-			__blk_end_request_cur(req, -EIO);
-			continue;
+			goto end;
 		}
 
 		if ((jdp->dbase & 0xff000000) != 0x20000000) {
 			printk(KERN_ERR "jsfd: bad base %x\n", (int)jdp->dbase);
-			__blk_end_request_cur(req, -EIO);
-			continue;
+			goto end;
 		}
 
 		jsfd_read(req->buffer, jdp->dbase + offset, len);
-
-		__blk_end_request_cur(req, 0);
+		err = 0;
+	end:
+		if (!__blk_end_request_cur(req, err)) {
+			req = elv_next_request(q);
+			if (req)
+				blkdev_dequeue_request(req);
+		}
 	}
 }
 
-- 
1.6.0.2

