Return-Path: <linux-kernel-owner+w=401wt.eu-S1756116Ab0ARVhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756116Ab0ARVhH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 16:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751636Ab0ARVhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 16:37:05 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49827 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753170Ab0ARVhC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 16:37:02 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 18 Jan 2010 22:36:49 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: net: fix panic in fwnet_write_complete
To: =?iso-8859-5?Q?=B8=DB=EC=EF_=B1=D0=E1=D8=DD?= <basinilya@gmail.com>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4B547154.40700@s5r6.in-berlin.de>
Message-ID: <tkrat.a8b022df2a5d588d@s5r6.in-berlin.de>
References: <574312453.20100114002526@gmail.com>
 <4B4E4D73.5060100@s5r6.in-berlin.de> <4B4E4FD7.9060403@s5r6.in-berlin.de>
 <4B53291A.5050901@s5r6.in-berlin.de> <1833218156.20100118151651@gmail.com>
 <4B547154.40700@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=utf-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Date: 
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: firewire: net: fix panic in fwnet_write_complete

In the transmit path of firewire-net (IPv4 over 1394), the following
race condition may occur:
  - The networking soft IRQ inserts a datagram into the 1394 async
    request transmit DMA.
  - The 1394 async transmit completion tasklet runs to finish cleaning
    up (unlink datagram from list of pending ones, release skb and
    outbound 1394 transaction object) --- before the networking soft IRQ
    had a chance to proceed and add the datagram to the list of pending
    datagrams.

This caused a panic in the 1394 async transmit completion tasklet when
it dereferenced unitialized list heads:
http://bugzilla.kernel.org/show_bug.cgi?id=15077

The fix is to add checks in the tx soft RQ and in the tasklet to
determine who of these two is the last referrer to the transaction
object.  Then handle the cleanup of the object by the last referrer
rather than assuming that the tasklet is always the last one.

There is another similar race:  Between said tasklet and fwnet_close,
i.e. at ifdown.  However, that race is much less likely to occur in
practice and shall be fixed in a separate update.

Reported-by: Илья Басин <basinilya@gmail.com>
Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---

Илья, could you give this a try?

 drivers/firewire/net.c |   53 ++++++++++++++++++++++++++++++-----------
 1 file changed, 39 insertions(+), 14 deletions(-)

Index: linux-2.6.32.2/drivers/firewire/net.c
===================================================================
--- linux-2.6.32.2.orig/drivers/firewire/net.c
+++ linux-2.6.32.2/drivers/firewire/net.c
@@ -893,20 +893,31 @@ static void fwnet_receive_broadcast(stru
 
 static struct kmem_cache *fwnet_packet_task_cache;
 
+static void fwnet_free_ptask(struct fwnet_packet_task *ptask)
+{
+	dev_kfree_skb_any(ptask->skb);
+	kmem_cache_free(fwnet_packet_task_cache, ptask);
+}
+
 static int fwnet_send_packet(struct fwnet_packet_task *ptask);
 
 static void fwnet_transmit_packet_done(struct fwnet_packet_task *ptask)
 {
-	struct fwnet_device *dev;
+	struct fwnet_device *dev = ptask->dev;
 	unsigned long flags;
-
-	dev = ptask->dev;
+	bool free;
 
 	spin_lock_irqsave(&dev->lock, flags);
-	list_del(&ptask->pt_link);
-	spin_unlock_irqrestore(&dev->lock, flags);
 
-	ptask->outstanding_pkts--; /* FIXME access inside lock */
+	ptask->outstanding_pkts--;
+
+	/* Check whether we or the networking TX soft-IRQ is last user. */
+	free = (ptask->outstanding_pkts == 0 && !list_empty(&ptask->pt_link));
+
+	if (ptask->outstanding_pkts == 0)
+		list_del(&ptask->pt_link);
+
+	spin_unlock_irqrestore(&dev->lock, flags);
 
 	if (ptask->outstanding_pkts > 0) {
 		u16 dg_size;
@@ -951,10 +962,10 @@ static void fwnet_transmit_packet_done(s
 			ptask->max_payload = skb->len + RFC2374_FRAG_HDR_SIZE;
 		}
 		fwnet_send_packet(ptask);
-	} else {
-		dev_kfree_skb_any(ptask->skb);
-		kmem_cache_free(fwnet_packet_task_cache, ptask);
 	}
+
+	if (free)
+		fwnet_free_ptask(ptask);
 }
 
 static void fwnet_write_complete(struct fw_card *card, int rcode,
@@ -977,6 +988,7 @@ static int fwnet_send_packet(struct fwne
 	unsigned tx_len;
 	struct rfc2734_header *bufhdr;
 	unsigned long flags;
+	bool free;
 
 	dev = ptask->dev;
 	tx_len = ptask->max_payload;
@@ -1022,12 +1034,16 @@ static int fwnet_send_packet(struct fwne
 				generation, SCODE_100, 0ULL, ptask->skb->data,
 				tx_len + 8, fwnet_write_complete, ptask);
 
-		/* FIXME race? */
 		spin_lock_irqsave(&dev->lock, flags);
-		list_add_tail(&ptask->pt_link, &dev->broadcasted_list);
+
+		/* If the AT tasklet already ran, we may be last user. */
+		free = (ptask->outstanding_pkts == 0 && list_empty(&ptask->pt_link));
+		if (!free)
+			list_add_tail(&ptask->pt_link, &dev->broadcasted_list);
+
 		spin_unlock_irqrestore(&dev->lock, flags);
 
-		return 0;
+		goto out;
 	}
 
 	fw_send_request(dev->card, &ptask->transaction,
@@ -1035,12 +1051,19 @@ static int fwnet_send_packet(struct fwne
 			ptask->generation, ptask->speed, ptask->fifo_addr,
 			ptask->skb->data, tx_len, fwnet_write_complete, ptask);
 
-	/* FIXME race? */
 	spin_lock_irqsave(&dev->lock, flags);
-	list_add_tail(&ptask->pt_link, &dev->sent_list);
+
+	/* If the AT tasklet already ran, we may be last user. */
+	free = (ptask->outstanding_pkts == 0 && list_empty(&ptask->pt_link));
+	if (!free)
+		list_add_tail(&ptask->pt_link, &dev->sent_list);
+
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	dev->netdev->trans_start = jiffies;
+ out:
+	if (free)
+		fwnet_free_ptask(ptask);
 
 	return 0;
 }
@@ -1298,6 +1321,8 @@ static netdev_tx_t fwnet_tx(struct sk_bu
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	ptask->max_payload = max_payload;
+	INIT_LIST_HEAD(&ptask->pt_link);
+
 	fwnet_send_packet(ptask);
 
 	return NETDEV_TX_OK;


-- 
Stefan Richter
-=====-==-=- ---= =--=-
http://arcgraph.de/sr/

