Return-Path: <linux-kernel-owner+w=401wt.eu-S1753699Ab0AHPIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab0AHPIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 10:08:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596Ab0AHPIV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 10:08:21 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:44022 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab0AHPIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 10:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=nT01av02zCF5ANfpLRX/DWsxyyTx4TuGN58peBYLlY9iyrBvEp15Epc/2UHKkCtKDR
         FUklGw64YtIfKNMSiKTiz+/s1BAuH+9yfPlaMLvty6m3WeF2pi2n0dhBt7Wx3t5/P0Xi
         /qThxq1aorxu3lK+elyHOvN/fOQWbOjUXrvzg=
Subject: [PATCH 4/9] MTD: make mtdtrans thread freezable.
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: linux-mtd <linux-mtd@lists.infradead.org>, Alex Dubov <oakad@yahoo.com>,
       joern <joern@logfs.org>
In-Reply-To: <1262963092.12577.14.camel@maxim-laptop>
References: <1262963092.12577.14.camel@maxim-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jan 2010 17:08:16 +0200
Message-ID: <1262963296.12577.18.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From e8648ebdc31d65556fccb340e4c16edc43017cf1 Mon Sep 17 00:00:00 2001
From: Maxim Levitsky <maximlevitsky@gmail.com>
Date: Fri, 8 Jan 2010 15:52:18 +0200
Subject: [PATCH 4/9] MTD: make mtdtrans thread freezable.

This makes the mtd blktrans thread enter the freezer in between accesses
to nand device.
This will ensure that we aren't suspending the system in the middle
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



