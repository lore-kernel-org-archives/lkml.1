Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbZDUQmk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbZDUQmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 12:42:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755209AbZDUQjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 12:39:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:40158 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756281AbZDUQjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 12:39:18 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, bzolnier@gmail.com
Cc: Tejun Heo <tj@kernel.org>, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 13/14] block: don't abuse rq->data
Date: Wed, 22 Apr 2009 01:38:00 +0900
Message-Id: <1240331881-28218-14-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1240331881-28218-1-git-send-email-tj@kernel.org>
References: <1240331881-28218-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 21 Apr 2009 16:38:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

omap mailbox uses rq->data as the second opaque pointer to carry
mbox_msg_t and rq->special message argument which is needed only for
tx.  Add and use omap_msg_tx_data struct for tx and use rq->special
for mbox_msg_t for rx such that only rq->special is used as opaque
pointer.

[ Impact: cleanup rq->data usage, extra kmalloc in msg_send ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
---
 arch/arm/plat-omap/mailbox.c |   43 ++++++++++++++++++++++++++++++-----------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/arch/arm/plat-omap/mailbox.c b/arch/arm/plat-omap/mailbox.c
index cf81bad..538ba75 100644
--- a/arch/arm/plat-omap/mailbox.c
+++ b/arch/arm/plat-omap/mailbox.c
@@ -147,24 +147,40 @@ static int __mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg, void *arg)
 	return ret;
 }
 
+struct omap_msg_tx_data {
+	mbox_msg_t	msg;
+	void		*arg;
+};
+
+static void omap_msg_tx_end_io(struct request *rq, int error)
+{
+	kfree(rq->special);
+	__blk_put_request(rq->q, rq);
+}
+
 int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg, void* arg)
 {
+	struct omap_msg_tx_data *tx_data;
 	struct request *rq;
 	struct request_queue *q = mbox->txq->queue;
-	int ret = 0;
+
+	tx_data = kmalloc(sizeof(*tx_data), GFP_ATOMIC);
+	if (unlikely(!tx_data))
+		return -ENOMEM;
 
 	rq = blk_get_request(q, WRITE, GFP_ATOMIC);
 	if (unlikely(!rq)) {
-		ret = -ENOMEM;
-		goto fail;
+		kfree(tx_data);
+		return -ENOMEM;
 	}
 
-	rq->data = (void *)msg;
-	blk_insert_request(q, rq, 0, arg);
+	tx_data->msg = msg;
+	tx_data->arg = arg;
+	rq->end_io = omap_msg_tx_end_io;
+	blk_insert_request(q, rq, 0, tx_data);
 
 	schedule_work(&mbox->txq->work);
- fail:
-	return ret;
+	return 0;
 }
 EXPORT_SYMBOL(omap_mbox_msg_send);
 
@@ -178,6 +194,8 @@ static void mbox_tx_work(struct work_struct *work)
 	struct request_queue *q = mbox->txq->queue;
 
 	while (1) {
+		struct omap_msg_tx_data *tx_data;
+
 		spin_lock(q->queue_lock);
 		rq = elv_next_request(q);
 		spin_unlock(q->queue_lock);
@@ -185,7 +203,9 @@ static void mbox_tx_work(struct work_struct *work)
 		if (!rq)
 			break;
 
-		ret = __mbox_msg_send(mbox, (mbox_msg_t) rq->data, rq->special);
+		tx_data = rq->special;
+
+		ret = __mbox_msg_send(mbox, tx_data->msg, tx_data->arg);
 		if (ret) {
 			enable_mbox_irq(mbox, IRQ_TX);
 			return;
@@ -222,7 +242,7 @@ static void mbox_rx_work(struct work_struct *work)
 		if (!rq)
 			break;
 
-		msg = (mbox_msg_t) rq->data;
+		msg = (mbox_msg_t)rq->special;
 		blk_end_request_all(rq, 0);
 		mbox->rxq->callback((void *)msg);
 	}
@@ -260,7 +280,6 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
 			goto nomem;
 
 		msg = mbox_fifo_read(mbox);
-		rq->data = (void *)msg;
 
 		if (unlikely(mbox_seq_test(mbox, msg))) {
 			pr_info("mbox: Illegal seq bit!(%08x)\n", msg);
@@ -268,7 +287,7 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
 				mbox->err_notify();
 		}
 
-		blk_insert_request(q, rq, 0, NULL);
+		blk_insert_request(q, rq, 0, (void *)msg);
 		if (mbox->ops->type == OMAP_MBOX_TYPE1)
 			break;
 	}
@@ -331,7 +350,7 @@ omap_mbox_read(struct device *dev, struct device_attribute *attr, char *buf)
 		if (!rq)
 			break;
 
-		*p = (mbox_msg_t) rq->data;
+		*p = (mbox_msg_t)rq->special;
 
 		blk_end_request_all(rq, 0);
 
-- 
1.6.0.2

