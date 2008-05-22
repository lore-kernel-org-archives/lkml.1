Return-Path: <linux-kernel-owner+w=401wt.eu-S935246AbYEVIbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935246AbYEVIbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 04:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757051AbYEVIbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 04:31:11 -0400
Received: from mga06.intel.com ([134.134.136.21]:24588 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756541AbYEVIbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 04:31:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,524,1204531200"; 
   d="scan'208";a="283893053"
Subject: [PATCH] Move the second call to get_request to the end of the loop
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 22 May 2008 16:29:44 +0800
Message-Id: <1211444984.3177.256.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In function get_request_wait, the second call to get_request could be moved to the end of the while loop,
because if the first call to get_request fails, the second call will fail without sleep.

﻿Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>

---

--- linux-2.6.26-rc3/block/blk-core.c	2008-05-19 07:17:18.000000000 +0800
+++ linux-2.6.26-rc3_block/block/blk-core.c	2008-05-22 07:00:15.000000000 +0800
@@ -806,35 +806,32 @@ static struct request *get_request_wait(
 	rq = get_request(q, rw_flags, bio, GFP_NOIO);
 	while (!rq) {
 		DEFINE_WAIT(wait);
+		struct io_context *ioc;
 		struct request_list *rl = &q->rq;
 
 		prepare_to_wait_exclusive(&rl->wait[rw], &wait,
 				TASK_UNINTERRUPTIBLE);
 
-		rq = get_request(q, rw_flags, bio, GFP_NOIO);
-
-		if (!rq) {
-			struct io_context *ioc;
+		blk_add_trace_generic(q, bio, rw, BLK_TA_SLEEPRQ);
 
-			blk_add_trace_generic(q, bio, rw, BLK_TA_SLEEPRQ);
-
-			__generic_unplug_device(q);
-			spin_unlock_irq(q->queue_lock);
-			io_schedule();
+		__generic_unplug_device(q);
+		spin_unlock_irq(q->queue_lock);
+		io_schedule();
 
-			/*
-			 * After sleeping, we become a "batching" process and
-			 * will be able to allocate at least one request, and
-			 * up to a big batch of them for a small period time.
-			 * See ioc_batching, ioc_set_batching
-			 */
-			ioc = current_io_context(GFP_NOIO, q->node);
-			ioc_set_batching(q, ioc);
+		/*
+		 * After sleeping, we become a "batching" process and
+		 * will be able to allocate at least one request, and
+		 * up to a big batch of them for a small period time.
+		 * See ioc_batching, ioc_set_batching
+		 */
+		ioc = current_io_context(GFP_NOIO, q->node);
+		ioc_set_batching(q, ioc);
 
-			spin_lock_irq(q->queue_lock);
-		}
+		spin_lock_irq(q->queue_lock);
 		finish_wait(&rl->wait[rw], &wait);
-	}
+
+		rq = get_request(q, rw_flags, bio, GFP_NOIO);
+	};
 
 	return rq;
 }


