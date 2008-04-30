Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbYD3Ob7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbYD3Ob7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 10:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755300AbYD3Obu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 10:31:50 -0400
Received: from mail08.svc.cra.dublin.eircom.net ([159.134.118.24]:47331 "HELO
	mail08.svc.cra.dublin.eircom.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755834AbYD3Obt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 10:31:49 -0400
From: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH] virtio_net: free transmit skbs in a timer
Date: Wed, 30 Apr 2008 15:31:46 +0100
Message-Id: <1209565906-9019-1-git-send-email-markmc@redhat.com>
X-Mailer: git-send-email 1.5.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

virtio_net currently only frees old transmit skbs just
before queueing new ones. If the queue is full, it then
enables interrupts and waits for notification that more
work has been performed.

However, a side-effect of this scheme is that there are
always xmit skbs left dangling when no new packets are
sent, against the Documentation/networking/driver.txt
guideline:

  "... it is not allowed for your TX mitigation scheme
   to let TX packets "hang out" in the TX ring unreclaimed
   forever if no new TX packets are sent."

Add a timer to ensure that any time we queue new TX
skbs, we will shortly free them again.

This fixes any easily reproduced hang at shutdown where
iptables attempts to unload nf_conntrack and nf_conntrack
waits for an skb it is tracking to be freed, but virtio_net
never frees it.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/net/virtio_net.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 555b70c..f331168 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -41,6 +41,8 @@ struct virtnet_info
 	struct net_device *dev;
 	struct napi_struct napi;
 
+	struct timer_list xmit_free_timer;
+
 	/* Number of input buffers, and max we've ever had. */
 	unsigned int num, max;
 
@@ -227,6 +229,15 @@ static void free_old_xmit_skbs(struct virtnet_info *vi)
 	}
 }
 
+static void xmit_free(unsigned long data)
+{
+	struct virtnet_info *vi = (void *)data;
+
+	netif_tx_lock(vi->dev);
+	free_old_xmit_skbs(vi);
+	netif_tx_unlock(vi->dev);
+}
+
 static int start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct virtnet_info *vi = netdev_priv(dev);
@@ -295,6 +306,8 @@ again:
 	}
 	vi->svq->vq_ops->kick(vi->svq);
 
+	mod_timer(&vi->xmit_free_timer, jiffies + (HZ/10));
+
 	return 0;
 }
 
@@ -396,6 +409,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 	skb_queue_head_init(&vi->recv);
 	skb_queue_head_init(&vi->send);
 
+	init_timer(&vi->xmit_free_timer);
+	vi->xmit_free_timer.data = (unsigned long)vi;
+	vi->xmit_free_timer.function = xmit_free;
+
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
@@ -433,6 +450,8 @@ static void virtnet_remove(struct virtio_device *vdev)
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
+	del_timer_sync(&vi->xmit_free_timer);
+
 	/* Free our skbs in send and recv queues, if any. */
 	while ((skb = __skb_dequeue(&vi->recv)) != NULL) {
 		kfree_skb(skb);
-- 
1.5.4.1

