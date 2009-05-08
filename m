Return-Path: <linux-kernel-owner+w=401wt.eu-S1763983AbZEHDDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763983AbZEHDDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 23:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762725AbZEHC5S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 22:57:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:36273 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759250AbZEHC4o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 09/18] ps3disk: dequeue in-flight request
Date: Fri,  8 May 2009 11:54:07 +0900
Message-Id: <1241751256-17435-10-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1241751256-17435-1-git-send-email-tj@kernel.org>
References: <1241751256-17435-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 02:54:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Other than in issue error paths, ps3disk always completely finishes
fetched requests.  With full completion on error paths, it can be
easily converted to dequeueing model.

* After L1 r/w call failure, ps3disk_submit_request_sg() now fails the
  whole request.  Issue failure isn't likely to benefit from partial
  retry anyway and ps3disk uses full failure in completion error path
  too, so I don't think this amounts to any meaningful functionality
  loss.

* flush completion is converted to _all for consistency.  It doesn't
  make any functional difference.

[ Impact: dequeue in-flight request ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
 drivers/block/ps3disk.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 8d58308..f4d8db9 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -157,7 +157,7 @@ static int ps3disk_submit_request_sg(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: %s failed %d\n", __func__,
 			__LINE__, op, res);
-		__blk_end_request_cur(req, -EIO);
+		__blk_end_request_all(req, -EIO);
 		return 0;
 	}
 
@@ -179,7 +179,7 @@ static int ps3disk_submit_flush_request(struct ps3_storage_device *dev,
 	if (res) {
 		dev_err(&dev->sbd.core, "%s:%u: sync cache failed 0x%llx\n",
 			__func__, __LINE__, res);
-		__blk_end_request_cur(req, -EIO);
+		__blk_end_request_all(req, -EIO);
 		return 0;
 	}
 
@@ -195,6 +195,8 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 	dev_dbg(&dev->sbd.core, "%s:%u\n", __func__, __LINE__);
 
 	while ((req = elv_next_request(q))) {
+		blkdev_dequeue_request(req);
+
 		if (blk_fs_request(req)) {
 			if (ps3disk_submit_request_sg(dev, req))
 				break;
@@ -204,7 +206,7 @@ static void ps3disk_do_request(struct ps3_storage_device *dev,
 				break;
 		} else {
 			blk_dump_rq_flags(req, DEVICE_NAME " bad request");
-			__blk_end_request_cur(req, -EIO);
+			__blk_end_request_all(req, -EIO);
 			continue;
 		}
 	}
-- 
1.6.0.2

