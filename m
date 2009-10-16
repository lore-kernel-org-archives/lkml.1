Return-Path: <linux-kernel-owner+w=401wt.eu-S1755301AbZJPRSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301AbZJPRSn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:18:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754869AbZJPRSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:18:40 -0400
Received: from kroah.org ([198.145.64.141]:48598 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561AbZJPRSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:35 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:02 2009
Message-Id: <20091016171202.389782069@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [30/46] connector: Removed the destruct_data callback since it is always kfree_skb()
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=connector-removed-the-destruct_data-callback-since-it-is-always-kfree_skb.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cherry picked from commit f4b5129f5e838942f759c2637967441cf4a98c20)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Acked-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/connector/cn_queue.c  |    4 ++--
 drivers/connector/connector.c |   11 +++--------
 include/linux/connector.h     |    3 ---
 3 files changed, 5 insertions(+), 13 deletions(-)

--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -83,8 +83,8 @@ void cn_queue_wrapper(struct work_struct
 
 	d->callback(msg, nsp);
 
-	d->destruct_data(d->ddata);
-	d->ddata = NULL;
+	kfree_skb(d->skb);
+	d->skb = NULL;
 
 	kfree(d->free);
 }
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
@@ -140,12 +140,9 @@ static int cn_call_callback(struct sk_bu
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
@@ -159,8 +156,6 @@ static int cn_call_callback(struct sk_bu
 					d = &__new_cbq->data;
 					d->skb = skb;
 					d->callback = __cbq->data.callback;
-					d->ddata = data;
-					d->destruct_data = destruct_data;
 					d->free = __new_cbq;
 
 					__new_cbq->pdev = __cbq->pdev;
@@ -208,7 +203,7 @@ static void cn_rx_skb(struct sk_buff *__
 			return;
 		}
 
-		err = cn_call_callback(skb, (void (*)(void *))kfree_skb, skb);
+		err = cn_call_callback(skb);
 		if (err < 0)
 			kfree_skb(skb);
 	}
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
 


