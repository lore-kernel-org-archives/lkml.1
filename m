Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbYELUjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbYELUjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 16:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYELUjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 16:39:35 -0400
Received: from mx1.redhat.com ([66.187.233.31]:54122 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbYELUje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 16:39:34 -0400
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200805022055.25870.rusty@rustcorp.com.au>
References: <1209565906-9019-1-git-send-email-markmc@redhat.com>
	 <200805022055.25870.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Mon, 12 May 2008 21:37:43 +0100
Message-Id: <1210624663.14409.20.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,
	Sorry 'bout the lag ...

On Fri, 2008-05-02 at 20:55 +1000, Rusty Russell wrote:
> On Thursday 01 May 2008 00:31:46 Mark McLoughlin wrote:
> > virtio_net currently only frees old transmit skbs just
> > before queueing new ones. If the queue is full, it then
> > enables interrupts and waits for notification that more
> > work has been performed.
> 
> Hi Mark,
> 
>    This patch is fine, but it's better to do it from skb_xmit_done().

Unless I'm missing something, we only get this callback when we've
stopped the queue and we're waiting for buffers to be freed up.

In the normal case, where the callback is disabled, we don't get any
notification that the host has finished with the buffer ... hence the
need for a timer.

2.6.25-rc2 rebase below.

>   Of 
> course, this is usually called from an interrupt handler, so it's not 
> entirely trivial: we can't free the skbs there.
> 
>    A softirq is probably the answer here, but AFAICT that's old fashioned.  
> Not sure what the right way of doing this is now...

Thanks,
Mark.

Subject: [PATCH] virtio_net: free transmit skbs in a timer

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

This fixes an easily reproduced hang at shutdown where
iptables attempts to unload nf_conntrack and nf_conntrack
waits for an skb it is tracking to be freed, but virtio_net
never frees it.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/net/virtio_net.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index f926b5a..69b308a 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -44,6 +44,8 @@ struct virtnet_info
 	/* The skb we couldn't send because buffers were full. */
 	struct sk_buff *last_xmit_skb;
 
+	struct timer_list xmit_free_timer;
+
 	/* Number of input buffers, and max we've ever had. */
 	unsigned int num, max;
 
@@ -230,9 +232,23 @@ static void free_old_xmit_skbs(struct virtnet_info *vi)
 	}
 }
 
+static void xmit_free(unsigned long data)
+{
+	struct virtnet_info *vi = (void *)data;
+
+	netif_tx_lock(vi->dev);
+
+	free_old_xmit_skbs(vi);
+
+	if (!skb_queue_empty(&vi->send))
+		mod_timer(&vi->xmit_free_timer, jiffies + (HZ/10));
+
+	netif_tx_unlock(vi->dev);
+}
+
 static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
 {
-	int num;
+	int num, err;
 	struct scatterlist sg[2+MAX_SKB_FRAGS];
 	struct virtio_net_hdr *hdr;
 	const unsigned char *dest = ((struct ethhdr *)skb->data)->h_dest;
@@ -275,7 +291,11 @@ static int xmit_skb(struct virtnet_info *vi, struct sk_buff *skb)
 	vnet_hdr_to_sg(sg, skb);
 	num = skb_to_sgvec(skb, sg+1, 0, skb->len) + 1;
 
-	return vi->svq->vq_ops->add_buf(vi->svq, sg, num, 0, skb);
+	err = vi->svq->vq_ops->add_buf(vi->svq, sg, num, 0, skb);
+	if (!err)
+		mod_timer(&vi->xmit_free_timer, jiffies + (HZ/10));
+
+	return err;
 }
 
 static int start_xmit(struct sk_buff *skb, struct net_device *dev)
@@ -428,6 +448,10 @@ static int virtnet_probe(struct virtio_device *vdev)
 	skb_queue_head_init(&vi->recv);
 	skb_queue_head_init(&vi->send);
 
+	init_timer(&vi->xmit_free_timer);
+	vi->xmit_free_timer.data = (unsigned long)vi;
+	vi->xmit_free_timer.function = xmit_free;
+
 	err = register_netdev(dev);
 	if (err) {
 		pr_debug("virtio_net: registering device failed\n");
@@ -465,6 +489,8 @@ static void virtnet_remove(struct virtio_device *vdev)
 	/* Stop all the virtqueues. */
 	vdev->config->reset(vdev);
 
+	del_timer_sync(&vi->xmit_free_timer);
+
 	/* Free our skbs in send and recv queues, if any. */
 	while ((skb = __skb_dequeue(&vi->recv)) != NULL) {
 		kfree_skb(skb);
--

