Return-Path: <linux-kernel-owner+w=401wt.eu-S1758183AbXLKWqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758183AbXLKWqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:46:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXLKWp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:45:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:34263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756289AbXLKWpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:45:54 -0500
Date: Tue, 11 Dec 2007 17:44:39 -0500 (EST)
Message-Id: <20071211.174439.107256463.k-ueda@ct.jp.nec.com>
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, dm-devel@redhat.com, j-nomura@ce.jp.nec.com,
       k-ueda@ct.jp.nec.com, geoffrey.levand@am.sony.com,
       Geert.Uytterhoeven@sonycom.com
Subject: [PATCH 09/30] blk_end_request: changing ps3disk (take 4)
From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
X-Mailer: Mew version 4.2 on Emacs 21.4 / Mule 5.0
 =?iso-2022-jp?B?KBskQjgtTFobKEIp?=
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch converts ps3disk to use blk_end_request interfaces.
Related 'uptodate' arguments are converted to 'error'.

Cc: Geoff Levand <geoffrey.levand@am.sony.com>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 drivers/block/ps3disk.c |   12 ++++--------
 1 files changed, 4 insertions(+), 8 deletions(-)

Index: 2.6.24-rc4/drivers/block/ps3disk.c
===================================================================
--- 2.6.24-rc4.orig/drivers/block/ps3disk.c
+++ 2.6.24-rc4/drivers/block/ps3disk.c
@@ -229,7 +229,7 @@ static irqreturn_t ps3disk_interrupt(int
 	struct ps3_storage_device *dev = data;
 	struct ps3disk_private *priv;
 	struct request *req;
-	int res, read, uptodate;
+	int res, read, error;
 	u64 tag, status;
 	unsigned long num_sectors;
 	const char *op;
@@ -270,21 +270,17 @@ static irqreturn_t ps3disk_interrupt(int
 	if (status) {
 		dev_dbg(&dev->sbd.core, "%s:%u: %s failed 0x%lx\n", __func__,
 			__LINE__, op, status);
-		uptodate = 0;
+		error = -EIO;
 	} else {
 		dev_dbg(&dev->sbd.core, "%s:%u: %s completed\n", __func__,
 			__LINE__, op);
-		uptodate = 1;
+		error = 0;
 		if (read)
 			ps3disk_scatter_gather(dev, req, 0);
 	}
 
 	spin_lock(&priv->lock);
-	if (!end_that_request_first(req, uptodate, num_sectors)) {
-		add_disk_randomness(req->rq_disk);
-		blkdev_dequeue_request(req);
-		end_that_request_last(req, uptodate);
-	}
+	__blk_end_request(req, error, num_sectors << 9);
 	priv->req = NULL;
 	ps3disk_do_request(dev, priv->queue);
 	spin_unlock(&priv->lock);
