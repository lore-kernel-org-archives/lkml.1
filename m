Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbZJPRYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbZJPRYS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932609AbZJPRYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:24:09 -0400
Received: from kroah.org ([198.145.64.141]:48578 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754417AbZJPRSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:34 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:01 2009
Message-Id: <20091016171201.376625219@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com,
       Philipp Reisner <philipp.reisner@linbit.com>,
       Lars Ellenberg <lars.ellenberg@linbit.com>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       "David S. Miller" <davem@davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [28/46] connector: Keep the skb in cn_callback_data
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=connector-keep-the-skb-in-cn_callback_data.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Philipp Reisner <philipp.reisner@linbit.com>

(cherry picked from commit 5491c43845dae6c68cb4edbcf2e2dde9a32a863d)

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/connector/cn_queue.c  |    3 ++-
 drivers/connector/connector.c |   11 +++++------
 include/linux/connector.h     |    6 +++---
 3 files changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/connector/cn_queue.c
+++ b/drivers/connector/cn_queue.c
@@ -78,8 +78,9 @@ void cn_queue_wrapper(struct work_struct
 	struct cn_callback_entry *cbq =
 		container_of(work, struct cn_callback_entry, work);
 	struct cn_callback_data *d = &cbq->data;
+	struct cn_msg *msg = NLMSG_DATA(nlmsg_hdr(d->skb));
 
-	d->callback(d->callback_priv);
+	d->callback(msg);
 
 	d->destruct_data(d->ddata);
 	d->ddata = NULL;
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
@@ -140,7 +141,7 @@ static int cn_call_callback(struct cn_ms
 		if (cn_cb_equal(&__cbq->id.id, &msg->id)) {
 			if (likely(!work_pending(&__cbq->work) &&
 					__cbq->data.ddata == NULL)) {
-				__cbq->data.callback_priv = msg;
+				__cbq->data.skb = skb;
 
 				__cbq->data.ddata = data;
 				__cbq->data.destruct_data = destruct_data;
@@ -156,7 +157,7 @@ static int cn_call_callback(struct cn_ms
 				__new_cbq = kzalloc(sizeof(struct cn_callback_entry), GFP_ATOMIC);
 				if (__new_cbq) {
 					d = &__new_cbq->data;
-					d->callback_priv = msg;
+					d->skb = skb;
 					d->callback = __cbq->data.callback;
 					d->ddata = data;
 					d->destruct_data = destruct_data;
@@ -191,7 +192,6 @@ static int cn_call_callback(struct cn_ms
  */
 static void cn_rx_skb(struct sk_buff *__skb)
 {
-	struct cn_msg *msg;
 	struct nlmsghdr *nlh;
 	int err;
 	struct sk_buff *skb;
@@ -208,8 +208,7 @@ static void cn_rx_skb(struct sk_buff *__
 			return;
 		}
 
-		msg = NLMSG_DATA(nlh);
-		err = cn_call_callback(msg, (void (*)(void *))kfree_skb, skb);
+		err = cn_call_callback(skb, (void (*)(void *))kfree_skb, skb);
 		if (err < 0)
 			kfree_skb(skb);
 	}
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


