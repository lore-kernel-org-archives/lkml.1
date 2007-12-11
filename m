Return-Path: <linux-kernel-owner+w=401wt.eu-S1756797AbXLKWq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbXLKWq2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757524AbXLKWpP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:45:15 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863AbXLKWpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:45:11 -0500
Date: Tue, 11 Dec 2007 17:45:04 -0500 (EST)
Message-Id: <20071211.174504.82055916.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, davem@davemloft.net
Subject: [PATCH 10/30] blk_end_request: changing sunvdc (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts sunvdc to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

As a result, the interface of internal function, vdc_end_request(),
is changed.

Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/sunvdc.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

Index: 2.6.24-rc4/drivers/block/sunvdc.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/sunvdc.c
+++ 2.6.24-rc4/drivers/block/sunvdc.c
@@ -212,12 +212,9 @@ static void vdc_end_special(struct vdc_p
 	vdc_finish(&port->vio, -err, WAITING_FOR_GEN_CMD);
 }
 
-static void vdc_end_request(struct request *req, int uptodate, int num_sectors)
+static void vdc_end_request(struct request *req, int error, int num_sectors)
 {
-	if (end_that_request_first(req, uptodate, num_sectors))
-		return;
-	add_disk_randomness(req->rq_disk);
-	end_that_request_last(req, uptodate);
+	__blk_end_request(req, error, num_sectors << 9);
 }
 
 static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
@@ -242,7 +239,7 @@ static void vdc_end_one(struct vdc_port 
 
 	rqe->req = NULL;
 
-	vdc_end_request(req, !desc->status, desc->size >> 9);
+	vdc_end_request(req, (desc->status ? -EIO : 0), desc->size >> 9);
 
 	if (blk_queue_stopped(port->disk->queue))
 		blk_start_queue(port->disk->queue);
@@ -456,7 +453,7 @@ static void do_vdc_request(struct reques
 
 		blkdev_dequeue_request(req);
 		if (__send_request(req) < 0)
-			vdc_end_request(req, 0, req->hard_nr_sectors);
+			vdc_end_request(req, -EIO, req->hard_nr_sectors);
 	}
 }
 
