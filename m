Return-Path: <linux-kernel-owner+w=401wt.eu-S2992909AbXCIDGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992909AbXCIDGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 22:06:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030859AbXCIDGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 22:06:25 -0500
Received: from ozlabs.org ([203.10.76.45]:44783 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030844AbXCIDGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 22:06:24 -0500
Subject: [PATCH 1/9] lguest: block device speedup
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain
Date: Fri, 09 Mar 2007 14:05:24 +1100
Message-Id: <1173409524.32234.67.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe pointed out that end_request() does not end the entire
request.  Go figure.  On the upside, he wrote the replacement for me!
Now we do far less block traffic, and our performance sucks less.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r fdc8cbc1fd61 drivers/block/lguest_blk.c
--- a/drivers/block/lguest_blk.c	Thu Mar 08 13:35:39 2007 +1100
+++ b/drivers/block/lguest_blk.c	Thu Mar 08 15:51:55 2007 +1100
@@ -45,6 +45,16 @@ struct blockdev
 	struct request *req;
 };
 
+/* Jens gave me this nice helper to end all chunks of a request. */
+static void end_entire_request(struct request *req, int uptodate)
+{
+	if (end_that_request_first(req, uptodate, req->hard_nr_sectors))
+		BUG();
+	add_disk_randomness(req->rq_disk);
+	blkdev_dequeue_request(req);
+	end_that_request_last(req, uptodate);
+}
+
 static irqreturn_t lgb_irq(int irq, void *_bd)
 {
 	struct blockdev *bd = _bd;
@@ -61,7 +71,7 @@ static irqreturn_t lgb_irq(int irq, void
 	}
 
 	spin_lock_irqsave(&bd->lock, flags);
-	end_request(bd->req, bd->lb_page->result == 1);
+	end_entire_request(bd->req, bd->lb_page->result == 1);
 	bd->req = NULL;
 	bd->dma.used_len = 0;
 	blk_start_queue(bd->disk->queue);
@@ -149,7 +159,7 @@ again:
 		pr_debug("Got non-command 0x%08x\n", req->cmd_type);
 	error:
 		req->errors++;
-		end_request(req, 0);
+		end_entire_request(req, 0);
 		goto again;
 	} else {
 		if (rq_data_dir(req) == WRITE)


