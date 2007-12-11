Return-Path: <linux-kernel-owner+w=401wt.eu-S1757163AbXLKWqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163AbXLKWqA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757157AbXLKWoW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:44:22 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757150AbXLKWoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:44:18 -0500
Date: Tue, 11 Dec 2007 17:44:06 -0500 (EST)
Message-Id: <20071211.174406.35360021.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, Paul.Clements@steeleye.com
Subject: [PATCH 08/30] blk_end_request: changing nbd (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts nbd to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Paul Clements <Paul.Clements@steeleye.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/nbd.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

Index: 2.6.24-rc4/drivers/block/nbd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/nbd.c
+++ 2.6.24-rc4/drivers/block/nbd.c
@@ -100,17 +100,15 @@ static const char *nbdcmd_to_ascii(int c
 
 static void nbd_end_request(struct request *req)
 {
-	int uptodate = (req->errors == 0) ? 1 : 0;
+	int error = req->errors ? -EIO : 0;
 	struct request_queue *q = req->q;
 	unsigned long flags;
 
 	dprintk(DBG_BLKDEV, "%s: request %p: %s\n", req->rq_disk->disk_name,
-			req, uptodate? "done": "failed");
+			req, error ? "failed" : "done");
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (!end_that_request_first(req, uptodate, req->nr_sectors)) {
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, error, req->nr_sectors << 9);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
