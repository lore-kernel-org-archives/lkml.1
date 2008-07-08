Return-Path: <linux-kernel-owner+w=401wt.eu-S1757141AbYGHUKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757141AbYGHUKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbYGHUKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:10:31 -0400
Received: from smtp-out.google.com ([216.239.33.17]:37194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588AbYGHUKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:10:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=NblW82xkFaY5VqW9/dUI9nrissTwRzulFMH4RVwiu7l+zeyFI05lh/eyYvngv/8pT
	Nvj/TYW6rzlJVKJ+MEHSg==
Date: Tue, 8 Jul 2008 13:10:11 -0700
To: drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 001/001] mmcblk: Fix deadlock when cleanup is called from resume
Message-ID: <20080708201011.GB16849@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: san@google.com (San Mehat)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  When CONFIG_UNSAFE_RESUME is used, we may need to cleanup
  (and call kthread_stop) when threads are still frozen. To fix this
  deadlock, push cleanup off to a work-queue.

  Signed-off-by: San Mehat <san@android.com>

---
 drivers/mmc/card/queue.c |   36 ++++++++++++++++++++++++++++++++++--
 1 files changed, 34 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index 972738f..908e3cf 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -14,6 +14,7 @@
 #include <linux/freezer.h>
 #include <linux/kthread.h>
 #include <linux/scatterlist.h>
+#include <linux/workqueue.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -23,6 +24,11 @@
 
 #define MMC_QUEUE_SUSPENDED	(1 << 0)
 
+static void mq_cleanup_work(struct work_struct *work);
+static DECLARE_WORK(mq_cleanup_worker, mq_cleanup_work);
+static struct mmc_queue *cleanup_mq;
+static DEFINE_SPINLOCK(mq_cleanup_lock);
+
 /*
  * Prepare a MMC request. This just filters out odd stuff.
  */
@@ -217,9 +223,36 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 
 void mmc_cleanup_queue(struct mmc_queue *mq)
 {
-	struct request_queue *q = mq->queue;
 	unsigned long flags;
 
+	BUG_ON(!mq);
+
+	/*
+	 * The actual cleanup is done from a work_queue because if you
+	 * thread_stop() while resuming, you'll deadlock.
+	 */
+	spin_lock_irqsave(&mq_cleanup_lock, flags);
+	cleanup_mq = mq;
+	schedule_work(&mq_cleanup_worker);
+	spin_unlock_irqrestore(&mq_cleanup_lock, flags);
+}
+EXPORT_SYMBOL(mmc_cleanup_queue);
+
+static void mq_cleanup_work(struct work_struct *work)
+{
+	struct mmc_queue *mq;
+	unsigned long flags;
+	struct request_queue *q;
+
+	spin_lock_irqsave(&mq_cleanup_lock, flags);
+	mq = cleanup_mq;
+	cleanup_mq = NULL;
+	spin_unlock_irqrestore(&mq_cleanup_lock, flags);
+
+	BUG_ON(!mq);
+
+	q = mq->queue;
+
 	/* Mark that we should start throwing out stragglers */
 	spin_lock_irqsave(q->queue_lock, flags);
 	q->queuedata = NULL;
@@ -246,7 +279,6 @@ void mmc_cleanup_queue(struct mmc_queue *mq)
 
 	mq->card = NULL;
 }
-EXPORT_SYMBOL(mmc_cleanup_queue);
 
 /**
  * mmc_queue_suspend - suspend a MMC request queue
