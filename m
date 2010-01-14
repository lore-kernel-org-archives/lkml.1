Return-Path: <linux-kernel-owner+w=401wt.eu-S1757443Ab0ANWeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443Ab0ANWeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756665Ab0ANW2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:44 -0500
Received: from kroah.org ([198.145.64.141]:60599 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756269Ab0ANW2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:42 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Adrian Hunter <adrian.hunter@nokia.com>, <linux-mmc@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 28/52] mmc_block: fix queue cleanup
Date: Thu, 14 Jan 2010 14:27:07 -0800
Message-Id: <1263508051-7868-28-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-27-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
 <1263508051-7868-17-git-send-email-gregkh@suse.de>
 <1263508051-7868-18-git-send-email-gregkh@suse.de>
 <1263508051-7868-19-git-send-email-gregkh@suse.de>
 <1263508051-7868-20-git-send-email-gregkh@suse.de>
 <1263508051-7868-21-git-send-email-gregkh@suse.de>
 <1263508051-7868-22-git-send-email-gregkh@suse.de>
 <1263508051-7868-23-git-send-email-gregkh@suse.de>
 <1263508051-7868-24-git-send-email-gregkh@suse.de>
 <1263508051-7868-25-git-send-email-gregkh@suse.de>
 <1263508051-7868-26-git-send-email-gregkh@suse.de>
 <1263508051-7868-27-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@nokia.com>

commit 5fa83ce284a4b7cd9dcfadd01500b0ed4ab9b740 upstream.

The main bug was that 'blk_cleanup_queue()' was called while the block
device could still be in use, for example, because the card was removed
while files were still open.

In addition, to be sure that 'mmc_request()' will get called for all new
requests (so it can error them out), the queue is emptied during cleanup.
This is done after the worker thread is stopped to avoid racing with it.

Finally, it is not a device error for this to be happening, so quiet the
(sometimes very many) error messages.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
Cc: <linux-mmc@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/card/block.c |    2 ++
 drivers/mmc/card/queue.c |   18 +++++++++---------
 2 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index ee87911..1f552c6 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -91,6 +91,8 @@ static void mmc_blk_put(struct mmc_blk_data *md)
 		if (!devmaj)
 			devidx = md->disk->first_minor >> MMC_SHIFT;
 
+		blk_cleanup_queue(md->queue.queue);
+
 		__clear_bit(devidx, dev_use);
 
 		put_disk(md->disk);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 49e5823..c5a7a85 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -90,9 +90,10 @@ static void mmc_request(struct request_queue *q)
 	struct request *req;
 
 	if (!mq) {
-		printk(KERN_ERR "MMC: killing requests for dead queue\n");
-		while ((req = blk_fetch_request(q)) != NULL)
+		while ((req = blk_fetch_request(q)) != NULL) {
+			req->cmd_flags |= REQ_QUIET;
 			__blk_end_request_all(req, -EIO);
+		}
 		return;
 	}
 
@@ -223,17 +224,18 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 	struct request_queue *q = mq->queue;
 	unsigned long flags;
 
-	/* Mark that we should start throwing out stragglers */
-	spin_lock_irqsave(q->queue_lock, flags);
-	q->queuedata = NULL;
-	spin_unlock_irqrestore(q->queue_lock, flags);
-
 	/* Make sure the queue isn't suspended, as that will deadlock */
 	mmc_queue_resume(mq);
 
 	/* Then terminate our worker thread */
 	kthread_stop(mq->thread);
 
+	/* Empty the queue */
+	spin_lock_irqsave(q->queue_lock, flags);
+	q->queuedata = NULL;
+	blk_start_queue(q);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
  	if (mq->bounce_sg)
  		kfree(mq->bounce_sg);
  	mq->bounce_sg = NULL;
@@ -245,8 +247,6 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 		kfree(mq->bounce_buf);
 	mq->bounce_buf = NULL;
 
-	blk_cleanup_queue(mq->queue);
-
 	mq->card = NULL;
 }
 EXPORT_SYMBOL(mmc_cleanup_queue);
-- 
1.6.6

