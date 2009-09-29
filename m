Return-Path: <linux-kernel-owner+w=401wt.eu-S1752507AbZI2OsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507AbZI2OsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 10:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI2OsM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 10:48:12 -0400
Received: from mail09.linbit.com ([212.69.161.110]:45600 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZI2OsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 10:48:11 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Philipp Reisner <philipp.reisner@linbit.com>
Subject: [PATCH] connector: Removed the destruct_data callback since it is always kfree_skb()
Date: Tue, 29 Sep 2009 16:48:11 +0200
Message-Id: <1254235692-1631-5-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1254235692-1631-4-git-send-email-philipp.reisner@linbit.com>
References: <1254235692-1631-1-git-send-email-philipp.reisner@linbit.com>
 <1254235692-1631-2-git-send-email-philipp.reisner@linbit.com>
 <1254235692-1631-3-git-send-email-philipp.reisner@linbit.com>
 <1254235692-1631-4-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Acked-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/connector/cn_queue.c  |    4 ++--
 drivers/connector/connector.c |   11 +++--------
 include/linux/connector.h     |    3 ---
 3 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 163c3e3..210338e 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -83,8 +83,8 @@ void cn_queue_wrapper(struct work_struct *work)
 
 	d->callback(msg, nsp);
 
-	d->destruct_data(d->ddata);
-	d->ddata = NULL;
+	kfree_skb(d->skb);
+	d->skb = NULL;
 
 	kfree(d->free);
 }
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index e59f0ab..f060246 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -129,7 +129,7 @@ EXPORT_SYMBOL_GPL(cn_netlink_send);
 /*
  * Callback helper - queues work and setup destructor for given data.
  */
-static int cn_call_callback(struct sk_buff *skb, void (*destruct_data)(void *), void *data)
+static int cn_call_callback(struct sk_buff *skb)
 {
 	struct cn_callback_entry *__cbq, *__new_cbq;
 	struct cn_dev *dev = &cdev;
@@ -140,12 +140,9 @@ static int cn_call_callback(struct sk_buff *skb, void (*destruct_data)(void *),
 	list_for_each_entry(__cbq, &dev->cbdev->queue_list, callback_entry) {
 		if (cn_cb_equal(&__cbq->id.id, &msg->id)) {
 			if (likely(!work_pending(&__cbq->work) &&
-					__cbq->data.ddata == NULL)) {
+					__cbq->data.skb == NULL)) {
 				__cbq->data.skb = skb;
 
-				__cbq->data.ddata = data;
-				__cbq->data.destruct_data = destruct_data;
-
 				if (queue_cn_work(__cbq, &__cbq->work))
 					err = 0;
 				else
@@ -159,8 +156,6 @@ static int cn_call_callback(struct sk_buff *skb, void (*destruct_data)(void *),
 					d = &__new_cbq->data;
 					d->skb = skb;
 					d->callback = __cbq->data.callback;
-					d->ddata = data;
-					d->destruct_data = destruct_data;
 					d->free = __new_cbq;
 
 					__new_cbq->pdev = __cbq->pdev;
@@ -208,7 +203,7 @@ static void cn_rx_skb(struct sk_buff *__skb)
 			return;
 		}
 
-		err = cn_call_callback(skb, (void (*)(void *))kfree_skb, skb);
+		err = cn_call_callback(skb);
 		if (err < 0)
 			kfree_skb(skb);
 	}
diff --git a/include/linux/connector.h b/include/linux/connector.h
index 545728e..3a14615 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -132,9 +132,6 @@ struct cn_callback_id {
 };
 
 struct cn_callback_data {
-	void (*destruct_data) (void *);
-	void *ddata;
-
 	struct sk_buff *skb;
 	void (*callback) (struct cn_msg *, struct netlink_skb_parms *);
 
-- 
1.6.0.4

