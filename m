Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399Ab0AVPgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399Ab0AVPgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:36:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640Ab0AVPgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:36:12 -0500
Received: from fg-out-1718.google.com ([72.14.220.152]:24074 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753197Ab0AVPgG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:36:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R/Qu+v4dfLscr3MIFhBIGxn5WL+z2kvmt8EJ8+PptNQNPlzyn+vGHGpR5GUMUhwvk9
         6EVT5vd0+JwvWOIPNmq5UbJsB4Xw59qsa+ms0rUtOsFQaJ2VjzERf1tu0AG2s+9Kb52w
         cUHy6PSZ7R2WHuA+N3fanLERJJ1XkqaZMsW90=
Subject: [PATCH 4/4] MTD: make mtdtrans thread freezeable.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alex Dubov <oakad@yahoo.com>, joern <joern@logfs.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1264174316.24012.17.camel@maxim-laptop>
References: <1264174316.24012.17.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jan 2010 17:36:00 +0200
Message-ID: <1264174560.24012.22.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0904b692e95b22564a570e03956e89911a5e56b3 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 22 Jan 2010 15:00:55 +0200
Subject: [PATCH 4/4] MTD: make mtdtrans thread freezeable.

This makes the mtd blktrans thread enter the freezer in between accesses
to nand device.
This will ensure that we aren't suspening the system in the middle
of page read/write and even worse erase, which is a bad idea.

Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/mtd/mtd_blkdevs.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 04a875f..db996d6 100644
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



