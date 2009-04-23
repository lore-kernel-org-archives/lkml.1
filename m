Return-Path: <linux-kernel-owner+w=401wt.eu-S1757289AbZDWM2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289AbZDWM2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZDWM1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:38553 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543AbZDWM1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:22 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/12] sunvdc: kill vdc_end_request()
Date: Thu, 23 Apr 2009 21:25:46 +0900
Message-Id: <1240489553-15724-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

vdc_end_request() is a thin silly wrapper on top of
__blk_end_request().  Kill it.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: David S. Miller <davem@davemloft.net>
---
 drivers/block/sunvdc.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 5861e33..f59887c 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -212,11 +212,6 @@ static void vdc_end_special(struct vdc_port *port, struct vio_disk_desc *desc)
 	vdc_finish(&port->vio, -err, WAITING_FOR_GEN_CMD);
 }
 
-static void vdc_end_request(struct request *req, int error, int num_sectors)
-{
-	__blk_end_request(req, error, num_sectors << 9);
-}
-
 static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
 			unsigned int index)
 {
@@ -239,7 +234,7 @@ static void vdc_end_one(struct vdc_port *port, struct vio_dring_state *dr,
 
 	rqe->req = NULL;
 
-	vdc_end_request(req, (desc->status ? -EIO : 0), desc->size >> 9);
+	__blk_end_request(req, (desc->status ? -EIO : 0), desc->size);
 
 	if (blk_queue_stopped(port->disk->queue))
 		blk_start_queue(port->disk->queue);
@@ -453,7 +448,7 @@ static void do_vdc_request(struct request_queue *q)
 
 		blkdev_dequeue_request(req);
 		if (__send_request(req) < 0)
-			vdc_end_request(req, -EIO, req->hard_nr_sectors);
+			__blk_end_request_all(req, -EIO);
 	}
 }
 
-- 
1.6.0.2

