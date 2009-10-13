Return-Path: <linux-kernel-owner+w=401wt.eu-S1759269AbZJMJ26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759269AbZJMJ26 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 05:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755316AbZJMJ25
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 05:28:57 -0400
Received: from mail09.linbit.com ([212.69.161.110]:52236 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbZJMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 05:28:56 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: [PATCH 1/7] connector: Keep the skb in cn_callback_data
Date: Tue, 13 Oct 2009 11:28:12 +0200
Message-Id: <1255426098-9411-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
References: <20091009222505.GA28979@kroah.com>
 <1255426098-9411-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
(cherry picked from commit 5491c43845dae6c68cb4edbcf2e2dde9a32a863d)
---
 drivers/connector/cn_queue.c  |    3 ++-
 drivers/connector/connector.c |   11 +++++------
 include/linux/connector.h     |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/connector/cn_queue.c b/drivers/connector/cn_queue.c
index 408c2af..327dfde 100644
--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -78,8 +78,9 @@ void cn_queue_wrapper(struct work_struct *work)
 	struct cn_callback_entry *cbq =
 		container_of(work, struct cn_callback_entry, work);
 	struct cn_callback_data *d = &cbq->data;
+	struct cn_msg *msg = NLMSG_DATA(nlmsg_hdr(d->skb));
 
-	d->callback(d->callback_priv);
+	d->callback(msg);
 
 	d->destruct_data(d->ddata);
 	d->ddata = NULL;
diff --git a/drivers/connector/connector.c b/drivers/connector/connector.c
index 08b2500..9bb14ac 100644
--- a/drivers/connector/connector.c
+++ b/drivers/connector/connector.c
@@ -129,10 +129,11 @@ EXPORT_SYMBOL_GPL(cn_netlink_send);
 /*
  * Callback helper - queues work and setup destructor for given data.
  */
-static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), void *data)
+static int cn_call_callback(struct sk_buff *skb, void (*destruct_data)(void *), void *data)
 {
 	struct cn_callback_entry *__cbq, *__new_cbq;
 	struct cn_dev *dev = &cdev;
+	struct cn_msg *msg = NLMSG_DATA(nlmsg_hdr(skb));
 	int err = -ENODEV;
 
 	spin_lock_bh(&dev->cbdev->queue_lock);
@@ -140,7 +141,7 @@ static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), v
 		if (cn_cb_equal(&__cbq->id.id, &msg->id)) {
 			if (likely(!work_pending(&__cbq->work) &&
 					__cbq->data.ddata == NULL)) {
-				__cbq->data.callback_priv = msg;
+				__cbq->data.skb = skb;
 
 				__cbq->data.ddata = data;
 				__cbq->data.destruct_data = destruct_data;
@@ -156,7 +157,7 @@ static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), v
 				__new_cbq = kzalloc(sizeof(struct cn_callback_entry), GFP_ATOMIC);
 				if (__new_cbq) {
 					d = &__new_cbq->data;
-					d->callback_priv = msg;
+					d->skb = skb;
 					d->callback = __cbq->data.callback;
 					d->ddata = data;
 					d->destruct_data = destruct_data;
@@ -191,7 +192,6 @@ static int cn_call_callback(struct cn_msg *msg, void (*destruct_data)(void *), v
  */
 static void cn_rx_skb(struct sk_buff *__skb)
 {
-	struct cn_msg *msg;
 	struct nlmsghdr *nlh;
 	int err;
 	struct sk_buff *skb;
@@ -208,8 +208,7 @@ static void cn_rx_skb(struct sk_buff *__skb)
 			return;
 		}
 
-		msg = NLMSG_DATA(nlh);
-		err = cn_call_callback(msg, (void (*)(void *))kfree_skb, skb);
+		err = cn_call_callback(skb, (void (*)(void *))kfree_skb, skb);
 		if (err < 0)
 			kfree_skb(skb);
 	}
diff --git a/include/linux/connector.h b/include/linux/connector.h
index b68d278..51b9ebd 100644
--- a/include/linux/connector.h
+++ b/include/linux/connector.h
@@ -134,9 +134,9 @@ struct cn_callback_id {
 struct cn_callback_data {
 	void (*destruct_data) (void *);
 	void *ddata;
-	
-	void *callback_priv;
-	void (*callback) (void *);
+
+	struct sk_buff *skb;
+	void (*callback) (struct cn_msg *);
 
 	void *free;
 };
-- 
1.6.0.4

