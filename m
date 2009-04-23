Return-Path: <linux-kernel-owner+w=401wt.eu-S1757494AbZDWM3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757494AbZDWM3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 08:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755499AbZDWM1Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 08:27:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:38558 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754277AbZDWM1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 08:27:23 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, joerg@dorchain.net,
       geert@linux-m68k.org, donari75@gmail.com, davem@davemloft.net,
       jdike@linux.intel.com, benh@kernel.crashing.org, Laurent@lvivier.info
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/12] ps3disk: simplify request completion
Date: Thu, 23 Apr 2009 21:25:45 +0900
Message-Id: <1240489553-15724-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240489553-15724-1-git-send-email-tj@kernel.org>
References: <1240489553-15724-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 12:26:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ps3disk_interrupt() always completes requests fully but it uses
rq->hard_cur_sectors for FLUSH requests for some reason.  Drop them
and simply use __blk_end_request_all().

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 drivers/block/ps3disk.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index d23b54b..f6586e4 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -231,7 +231,6 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 	struct request *req;
 	int res, read, error;
 	u64 tag, status;
-	unsigned long num_sectors;
 	const char *op;
 
 	res = lv1_storage_get_async_status(dev->sbd.dev_id, &tag, &status);
@@ -261,11 +260,9 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 	if (req->cmd_type == REQ_TYPE_LINUX_BLOCK &&
 	    req->cmd[0] == REQ_LB_OP_FLUSH) {
 		read = 0;
-		num_sectors = req->hard_cur_sectors;
 		op = "flush";
 	} else {
 		read = !rq_data_dir(req);
-		num_sectors = req->nr_sectors;
 		op = read ? "read" : "write";
 	}
 	if (status) {
@@ -281,7 +278,7 @@ static irqreturn_t ps3disk_interrupt(int irq, void *data)
 	}
 
 	spin_lock(&priv->lock);
-	__blk_end_request(req, error, num_sectors << 9);
+	__blk_end_request_all(req, error);
 	priv->req = NULL;
 	ps3disk_do_request(dev, priv->queue);
 	spin_unlock(&priv->lock);
-- 
1.6.0.2

