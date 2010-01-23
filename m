Return-Path: <linux-kernel-owner+w=401wt.eu-S1756354Ab0AWA0b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0AWA0b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 19:26:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190Ab0AWA0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 19:26:20 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47246 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0AWA0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 19:26:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rzo/jva/DSy+razYUzOXiqnRaHMcM5zR4qqjbY7ZmkZVtVwa7ij4P6UU+7D/0dWGdC
         nZew6ggFu85LvBPkihYYGZyUd7pbLp1lQnBVvsYkaeHZas9mpS3KsoCuiL+/YHpsco43
         3QPi4GEEIqb/3Mc6IJx4B7TjvYf+GizMvAD+M=
Subject: [PATCH 8/8] MTD: make mtdtrans thread freezeable.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1264205925.31827.3.camel@maxim-laptop>
References: <1264205925.31827.3.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Jan 2010 02:26:07 +0200
Message-ID: <1264206367.31827.12.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ebc69b9819f963a17574aa42e93f409368acdfaa Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Sat, 23 Jan 2010 02:09:33 +0200
Subject: [PATCH 8/8] MTD: make mtdtrans thread freezeable.

This makes the mtd blktrans thread enter the freezer in between accesses
to nand device.
This will ensure that we aren't suspening the system in the middle
of page read/write and even worse erase, which is a bad idea.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 33bdef1..ed82396 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -20,6 +20,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/kthread.h>
+#include <linux/freezer.h>
 #include <asm/uaccess.h>
 
 #include "mtdcore.h"
@@ -79,36 +80,35 @@ static int mtd_blktrans_thread(void *arg)
 	struct request_queue *rq = dev->rq;
 	struct request *req = NULL;
 
-	spin_lock_irq(rq->queue_lock);
+	set_freezable();
 
 	while (!kthread_should_stop()) {
 		int res;
 
+		try_to_freeze();
+
+		spin_lock_irq(rq->queue_lock);
 		if (!req && !(req = blk_fetch_request(rq))) {
 			set_current_state(TASK_INTERRUPTIBLE);
 			spin_unlock_irq(rq->queue_lock);
 			schedule();
-			spin_lock_irq(rq->queue_lock);
 			continue;
 		}
-
 		spin_unlock_irq(rq->queue_lock);
 
+
 		mutex_lock(&dev->lock);
 		res = do_blktrans_request(dev->tr, dev, req);
 		mutex_unlock(&dev->lock);
 
 		spin_lock_irq(rq->queue_lock);
-
 		if (!__blk_end_request_cur(req, res))
 			req = NULL;
+		spin_unlock_irq(rq->queue_lock);
 	}
 
 	if (req)
 		__blk_end_request_all(req, -EIO);
-
-	spin_unlock_irq(rq->queue_lock);
-
 	return 0;
 }
 
-- 
1.6.3.3



