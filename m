Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbYKNIiO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbYKNIiO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 03:38:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750825AbYKNIh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 03:37:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52617 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbYKNIh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 03:37:58 -0500
Message-ID: <491D387D.1000501@cn.fujitsu.com>
Date: Fri, 14 Nov 2008 16:36:13 +0800
From: Zhaolei <zhaolei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Jens Axboe <jens.axboe@oracle.com>, jeremy@xensource.com
Subject: [PATCH] Release old elevator on change elevator
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should release old elevator when change to use a new one.

Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
---
 drivers/block/xen-blkfront.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index b220c68..2d19f0c 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -338,12 +338,18 @@ wait:
 static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 {
 	struct request_queue *rq;
+	elevator_t *old_e;
 
 	rq = blk_init_queue(do_blkif_request, &blkif_io_lock);
 	if (rq == NULL)
 		return -1;
 
-	elevator_init(rq, "noop");
+	old_e = rq->elevator;
+	if (IS_ERR_VALUE(elevator_init(rq, "noop")))
+		printk(KERN_WARNING
+			"blkfront: Switch elevator failed, use default\n");
+	else
+		elevator_exit(old_e);
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
 	blk_queue_hardsect_size(rq, sector_size);
-- 
1.5.5.3


