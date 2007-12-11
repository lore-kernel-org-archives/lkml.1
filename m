Return-Path: <linux-kernel-owner+w=401wt.eu-S1758755AbXLKWte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755AbXLKWte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:49:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758706AbXLKWss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:48:48 -0500
Received: from mx1.redhat.com ([66.187.233.31]:39207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758631AbXLKWsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:48:46 -0500
Date: Tue, 11 Dec 2007 17:47:52 -0500 (EST)
Message-Id: <20071211.174752.76777839.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, sfr@canb.auug.org.au
Subject: [PATCH 15/30] blk_end_request: changing viocd (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts viocd to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, viocd_end_request(),
is changed.

Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/cdrom/viocd.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

Index: 2.6.24-rc4/drivers/cdrom/viocd.c
===================================================================
--- 2.6.24-rc4.orig/drivers/cdrom/viocd.c
+++ 2.6.24-rc4/drivers/cdrom/viocd.c
@@ -289,7 +289,7 @@ static int send_request(struct request *
 	return 0;
 }
 
-static void viocd_end_request(struct request *req, int uptodate)
+static void viocd_end_request(struct request *req, int error)
 {
 	int nsectors = req->hard_nr_sectors;
 
@@ -302,11 +302,8 @@ static void viocd_end_request(struct req
 	if (!nsectors)
 		nsectors = 1;
 
-	if (end_that_request_first(req, uptodate, nsectors))
+	if (__blk_end_request(req, error, nsectors << 9))
 		BUG();
-	add_disk_randomness(req->rq_disk);
-	blkdev_dequeue_request(req);
-	end_that_request_last(req, uptodate);
 }
 
 static int rwreq;
@@ -317,11 +314,11 @@ static void do_viocd_request(struct requ
 
 	while ((rwreq == 0) && ((req = elv_next_request(q)) != NULL)) {
 		if (!blk_fs_request(req))
-			viocd_end_request(req, 0);
+			viocd_end_request(req, -EIO);
 		else if (send_request(req) < 0) {
 			printk(VIOCD_KERN_WARNING
 					"unable to send message to OS/400!");
-			viocd_end_request(req, 0);
+			viocd_end_request(req, -EIO);
 		} else
 			rwreq++;
 	}
@@ -532,9 +529,9 @@ return_complete:
 					"with rc %d:0x%04X: %s\n",
 					req, event->xRc,
 					bevent->sub_result, err->msg);
-			viocd_end_request(req, 0);
+			viocd_end_request(req, -EIO);
 		} else
-			viocd_end_request(req, 1);
+			viocd_end_request(req, 0);
 
 		/* restart handling of incoming requests */
 		spin_unlock_irqrestore(&viocd_reqlock, flags);
