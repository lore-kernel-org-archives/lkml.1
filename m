Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbYE2NDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbYE2NDi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 09:03:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755201AbYE2NBN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 09:01:13 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:3698 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755398AbYE2NBK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 09:01:10 -0400
Message-Id: <20080529125728.607920561@de.ibm.com>
References: <20080529125501.196123527@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Thu, 29 May 2008 14:55:03 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Michael Holzheu <holzheu@de.ibm.com>
Subject: [patch 02/11] tape: Fix race condition in tape block device driver
Content-Disposition: inline; filename=002-tape-block.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Holzheu <holzheu@de.ibm.com>

Due to incorrect function call sequence it can happen that a tape block
request is finished before the request is taken from the block request queue.

The following sequence leads to that condition:
 * tapeblock_start_request() -> start CCW program
 * Request finishes -> IO interrupt
 * tapeblock_end_request()
 * end_that_request_last()

If blkdev_dequeue_request() has not been called before end_that_request_last(),
a kernel bug is triggered in end_that_request_last() because the request is
still queued. To solve that problem blkdev_dequeue_request() has to be called
before starting the CCW program.

Signed-off-by: Michael Holzheu <holzheu@de.ibm.com>
---

 drivers/s390/char/tape_block.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: quilt-2.6/drivers/s390/char/tape_block.c
===================================================================
--- quilt-2.6.orig/drivers/s390/char/tape_block.c
+++ quilt-2.6/drivers/s390/char/tape_block.c
@@ -179,11 +179,11 @@ tapeblock_requeue(struct work_struct *wo
 			tapeblock_end_request(req, -EIO);
 			continue;
 		}
+		blkdev_dequeue_request(req);
+		nr_queued++;
 		spin_unlock_irq(&device->blk_data.request_queue_lock);
 		rc = tapeblock_start_request(device, req);
 		spin_lock_irq(&device->blk_data.request_queue_lock);
-		blkdev_dequeue_request(req);
-		nr_queued++;
 	}
 	spin_unlock_irq(&device->blk_data.request_queue_lock);
 	atomic_set(&device->blk_data.requeue_scheduled, 0);

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

