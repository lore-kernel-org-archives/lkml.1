Return-Path: <linux-kernel-owner+w=401wt.eu-S1761422AbYCDIgb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761422AbYCDIgb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 03:36:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbYCDIbG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 03:31:06 -0500
Received: from de01egw01.freescale.net ([192.88.165.102]:46179 "EHLO
	de01egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458AbYCDIbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 03:31:02 -0500
From: Zhang Wei <wei.zhang@freescale.com>
To: mporter@kernel.crashing.org, galak@kernel.crashing.org
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Zhang Wei <wei.zhang@freescale.com>
Subject: [PATCH 17/17] Add the memory mapping support in rionet driver.
Date: Wed,  5 Mar 2008 00:30:02 +0800
Message-Id: <1204648202-5495-17-git-send-email-wei.zhang@freescale.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1204648202-5495-16-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-7-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-8-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-9-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-10-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-11-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-12-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-13-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-14-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-15-git-send-email-wei.zhang@freescale.com>
 <1204648202-5495-16-git-send-email-wei.zhang@freescale.com>
X-OriginalArrivalTime: 04 Mar 2008 08:30:37.0750 (UTC) FILETIME=[0602A560:01C87DD2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user can select memory mapping mode or message mode in CONFIG.
It is also an example to how-to use memory mapping driver for RapidIO.

Signed-off-by: Zhang Wei <wei.zhang@freescale.com>
---
 drivers/net/Kconfig  |   10 ++
 drivers/net/rionet.c |  321 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 331 insertions(+), 0 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 50c2b60..1e47a86 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -2695,6 +2695,16 @@ config RIONET_RX_SIZE
 	depends on RIONET
 	default "128"
 
+config RIONET_MEMMAP
+	bool "Use memory map instead of message"
+	depends on RIONET
+	default n
+
+config RIONET_DMA
+	bool "Use DMA for memory mapping data transfer"
+	depends on RIONET_MEMMAP && FSL_DMA
+	default y
+
 config FDDI
 	bool "FDDI driver support"
 	depends on (PCI || EISA || TC)
diff --git a/drivers/net/rionet.c b/drivers/net/rionet.c
index 6aa9731..53b53a8 100644
--- a/drivers/net/rionet.c
+++ b/drivers/net/rionet.c
@@ -1,6 +1,13 @@
 /*
  * rionet - Ethernet driver over RapidIO messaging services
  *
+ * Copyright (C) 2007 Freescale Semiconductor, Inc. All rights reserved.
+ * Author: Zhang Wei, wei.zhang@freescale.com, Jun 2007
+ *
+ * Changelog:
+ * Jun 2007 Zhang Wei <wei.zhang@freescale.com>
+ * - Added the support to RapidIO memory driver. 2007.
+ *
  * Copyright 2005 MontaVista Software, Inc.
  * Matt Porter <mporter@kernel.crashing.org>
  *
@@ -8,6 +15,7 @@
  * under  the terms of  the GNU General  Public License as published by the
  * Free Software Foundation;  either version 2 of the  License, or (at your
  * option) any later version.
+ *
  */
 
 #include <linux/module.h>
@@ -23,6 +31,7 @@
 #include <linux/skbuff.h>
 #include <linux/crc32.h>
 #include <linux/ethtool.h>
+#include <linux/dmaengine.h>
 
 #define DRV_NAME        "rionet"
 #define DRV_VERSION     "0.2"
@@ -40,13 +49,47 @@ MODULE_LICENSE("GPL");
 			 NETIF_MSG_TX_ERR)
 
 #define RIONET_DOORBELL_JOIN	0x1000
+#ifdef CONFIG_RIONET_MEMMAP
+#define RIONET_DOORBELL_SEND	0x1001
+#define RIONET_DOORBELL_LEAVE	0x1002
+#else
 #define RIONET_DOORBELL_LEAVE	0x1001
+#endif
 
 #define RIONET_MAILBOX		0
 
 #define RIONET_TX_RING_SIZE	CONFIG_RIONET_TX_SIZE
 #define RIONET_RX_RING_SIZE	CONFIG_RIONET_RX_SIZE
 
+#define ERR(fmt, arg...) \
+	printk(KERN_ERR "ERROR %s - %s: " fmt,  __FILE__, __FUNCTION__, ## arg)
+
+#ifdef CONFIG_RIONET_MEMMAP
+/* Definitions for rionet memory map driver */
+#define RIONET_DRVID		0x101
+#define RIONET_MAX_SK_DATA_SIZE	0x1000
+#define RIONET_TX_RX_BUFF_SIZE	(0x1000 * (128 + 128))
+#define RIONET_QUEUE_NEXT(x)	(((x) < 127) ? ((x) + 1) : 0)
+#define RIONET_QUEUE_INC(x)	(x = RIONET_QUEUE_NEXT(x))
+
+struct sk_data {
+	u8	data[0x1000];
+};
+
+#define RIONET_SKDATA_EN	0x80000000
+struct rionet_tx_rx_buff {
+	volatile int	enqueue;		/* enqueue point */
+	volatile int	dequeue;		/* dequeue point */
+	u32		size[128];		/* size[i] is skdata[i] size
+						 * the most high bit [31] is
+						 * enable bit. The
+						 * max size is 4096.
+						 */
+	u8		rev1[3576];
+	struct sk_data	skdata[128];		/* all size are 0x1000 * 128 */
+};
+#endif /* CONFIG_RIONET_MEMMAP */
+
 static LIST_HEAD(rionet_peers);
 
 struct rionet_private {
@@ -60,6 +103,18 @@ struct rionet_private {
 	spinlock_t lock;
 	spinlock_t tx_lock;
 	u32 msg_enable;
+#ifdef CONFIG_RIONET_MEMMAP
+	struct rionet_tx_rx_buff *rxbuff;
+	struct rionet_tx_rx_buff __iomem *txbuff;
+	struct rio_mem *rxmem;
+	struct rio_mem *txmem;
+#ifdef CONFIG_RIONET_DMA
+	struct dma_chan *txdmachan;
+	struct dma_chan *rxdmachan;
+	struct dma_client rio_dma_client;
+	spinlock_t rio_dma_event_lock;
+#endif
+#endif
 };
 
 struct rionet_peer {
@@ -108,9 +163,11 @@ static int rionet_rx_clean(struct net_device *ndev)
 
 		rnet->rx_skb[i]->data = data;
 		skb_put(rnet->rx_skb[i], RIO_MAX_MSG_SIZE);
+		rnet->rx_skb[i]->dev = ndev;
 		rnet->rx_skb[i]->protocol =
 		    eth_type_trans(rnet->rx_skb[i], ndev);
 		error = netif_rx(rnet->rx_skb[i]);
+		rnet->rx_skb[i] = NULL;
 
 		if (error == NET_RX_DROP) {
 			ndev->stats.rx_dropped++;
@@ -141,19 +198,96 @@ static void rionet_rx_fill(struct net_device *ndev, int end)
 		if (!rnet->rx_skb[i])
 			break;
 
+#ifndef CONFIG_RIONET_MEMMAP
 		rio_add_inb_buffer(rnet->mport, RIONET_MAILBOX,
 				   rnet->rx_skb[i]->data);
+#endif
 	} while ((i = (i + 1) % RIONET_RX_RING_SIZE) != end);
 
 	rnet->rx_slot = i;
 }
 
+#ifdef CONFIG_RIONET_MEMMAP
+static int rio_send_mem(struct sk_buff *skb,
+				struct net_device *ndev, struct rio_dev *rdev)
+{
+	struct rionet_private *rnet = ndev->priv;
+	int enqueue, dequeue;
+	int err;
+
+	if (!rdev)
+		return -EFAULT;
+
+	if (skb->len > RIONET_MAX_SK_DATA_SIZE) {
+		printk("Net frame len more than RIONET max sk_data size!\n");
+		return -EINVAL;
+	}
+
+	err = rio_space_find_mem(rnet->mport, rdev->destid, RIONET_DRVID,
+					&rnet->txmem->riores);
+	if (err) {
+		ndev->stats.tx_dropped++;
+		printk("err %d\n", err);
+		return -EBUSY;
+	}
+	rio_map_outb_region(rnet->mport, rdev->destid, rnet->txmem, 0);
+
+	enqueue = in_be32(&rnet->txbuff->enqueue);
+	dequeue = in_be32(&rnet->txbuff->dequeue);
+
+	if (!(in_be32(&rnet->txbuff->size[enqueue]) & RIONET_SKDATA_EN)
+			&& (RIONET_QUEUE_NEXT(enqueue) != dequeue)) {
+#ifdef CONFIG_RIONET_DMA
+		struct dma_device *dmadev;
+		struct dma_async_tx_descriptor *tx;
+		dma_cookie_t tx_cookie = 0;
+
+		dmadev = rnet->txdmachan->device;
+		tx = dmadev->device_prep_dma_memcpy(rnet->txdmachan, skb->len,
+							0);
+		if (!tx)
+			return;
+		tx->ack = 1;
+		tx->tx_set_dest((void *)rnet->txbuff->skdata[enqueue].data
+				- (void *)rnet->txbuff
+				+ rnet->txmem->iores.start, tx, 0);
+		tx->tx_set_src(dma_map_single(&ndev->dev, skb->data, skb->len,
+					DMA_TO_DEVICE), tx, 0);
+		tx_cookie = tx->tx_submit(tx);
+
+		dma_async_memcpy_issue_pending(rnet->txdmachan);
+		while (dma_async_memcpy_complete(rnet->txdmachan,
+					tx_cookie, NULL, NULL) == DMA_IN_PROGRESS) ;
+#else
+		memcpy(rnet->txbuff->skdata[enqueue].data, skb->data, skb->len);
+#endif /* CONFIG_RIONET_DMA */
+		out_be32(&rnet->txbuff->size[enqueue],
+						RIONET_SKDATA_EN | skb->len);
+		out_be32(&rnet->txbuff->enqueue,
+						RIONET_QUEUE_NEXT(enqueue));
+		in_be32(&rnet->txbuff->enqueue);	/* verify read */
+	} else if (netif_msg_tx_err(rnet))
+		printk("txbuff is busy!\n");
+
+	rio_unmap_outb_region(rnet->mport, rnet->txmem);
+	rio_send_doorbell(rdev, RIONET_DOORBELL_SEND);
+	return 0;
+}
+#endif
+
 static int rionet_queue_tx_msg(struct sk_buff *skb, struct net_device *ndev,
 			       struct rio_dev *rdev)
 {
 	struct rionet_private *rnet = ndev->priv;
 
+#ifdef CONFIG_RIONET_MEMMAP
+	int ret = 0;
+	ret = rio_send_mem(skb, ndev, rdev);
+	if (ret)
+		return ret;
+#else
 	rio_add_outb_message(rnet->mport, rdev, 0, skb->data, skb->len);
+#endif
 	rnet->tx_skb[rnet->tx_slot] = skb;
 
 	ndev->stats.tx_packets++;
@@ -165,6 +299,19 @@ static int rionet_queue_tx_msg(struct sk_buff *skb, struct net_device *ndev,
 	++rnet->tx_slot;
 	rnet->tx_slot &= (RIONET_TX_RING_SIZE - 1);
 
+#ifdef CONFIG_RIONET_MEMMAP
+	while (rnet->tx_cnt && (rnet->ack_slot != rnet->tx_slot)) {
+		/* dma unmap single */
+		dev_kfree_skb_any(rnet->tx_skb[rnet->ack_slot]);
+		rnet->tx_skb[rnet->ack_slot] = NULL;
+		++rnet->ack_slot;
+		rnet->ack_slot &= (RIONET_TX_RING_SIZE - 1);
+		rnet->tx_cnt--;
+	}
+
+	if (rnet->tx_cnt < RIONET_TX_RING_SIZE)
+		netif_wake_queue(ndev);
+#endif
 	if (netif_msg_tx_queued(rnet))
 		printk(KERN_INFO "%s: queued skb %8.8x len %8.8x\n", DRV_NAME,
 		       (u32) skb, skb->len);
@@ -211,6 +358,92 @@ static int rionet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 	return 0;
 }
 
+#ifdef CONFIG_RIONET_MEMMAP
+static void rio_recv_mem(struct net_device *ndev)
+{
+	struct rionet_private *rnet = (struct rionet_private *)ndev->priv;
+	struct sk_buff *skb;
+	u32 enqueue, dequeue, size;
+	int error = 0;
+	dma_cookie_t rx_cookie = 0;
+#ifdef CONFIG_RIONET_DMA
+	struct dma_device *dmadev;
+	struct dma_async_tx_descriptor *tx;
+#endif
+
+	dequeue = rnet->rxbuff->dequeue;
+	enqueue = rnet->rxbuff->enqueue;
+
+	while (enqueue != dequeue) {
+		size = rnet->rxbuff->size[dequeue];
+		if (!(size & RIONET_SKDATA_EN))
+			return;
+		size &= ~RIONET_SKDATA_EN;
+
+		if (!(skb = dev_alloc_skb(size + 2)))
+			return;
+
+#ifdef CONFIG_RIONET_DMA
+		dmadev = rnet->rxdmachan->device;
+		tx = dmadev->device_prep_dma_memcpy(rnet->rxdmachan, size, 0);
+		if (!tx)
+			return;
+		tx->ack = 1;
+		tx->tx_set_dest(dma_map_single(&ndev->dev, skb_put(skb, size),
+					size, DMA_FROM_DEVICE), tx, 0);
+		tx->tx_set_src((void *)rnet->rxbuff->skdata[dequeue].data
+				- (void *)rnet->rxbuff
+				+ rnet->rxmem->iores.start, tx, 0);
+		rx_cookie = tx->tx_submit(tx);
+		dma_async_memcpy_issue_pending(rnet->rxdmachan);
+		while (dma_async_memcpy_complete(rnet->rxdmachan,
+				rx_cookie, NULL, NULL) == DMA_IN_PROGRESS) ;
+#else
+		memcpy(skb_put(skb, size),
+				rnet->rxbuff->skdata[dequeue].data,
+				size);
+#endif /* CONFIG_RIONET_DMA */
+		skb->dev = ndev;
+		skb->protocol = eth_type_trans(skb, ndev);
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+
+		error = netif_rx(skb);
+
+		rnet->rxbuff->size[dequeue] &= ~RIONET_SKDATA_EN;
+		rnet->rxbuff->dequeue = RIONET_QUEUE_NEXT(dequeue);
+		dequeue = RIONET_QUEUE_NEXT(dequeue);
+
+		if (error == NET_RX_DROP) {
+			ndev->stats.rx_dropped++;
+		} else if (error == NET_RX_BAD) {
+			if (netif_msg_rx_err(rnet))
+				printk(KERN_WARNING "%s: bad rx packet\n",
+				       DRV_NAME);
+			ndev->stats.rx_errors++;
+		} else {
+			ndev->stats.rx_packets++;
+			ndev->stats.rx_bytes += RIO_MAX_MSG_SIZE;
+		}
+	}
+}
+
+static void rionet_inb_recv_event(struct rio_mport *mport, void *dev_id)
+{
+	struct net_device *ndev = dev_id;
+	struct rionet_private *rnet = (struct rionet_private *)ndev->priv;
+	unsigned long flags;
+
+	if (netif_msg_intr(rnet))
+		printk(KERN_INFO "%s: inbound memory data receive event\n",
+		       DRV_NAME);
+
+	spin_lock_irqsave(&rnet->lock, flags);
+	rio_recv_mem(ndev);
+	spin_unlock_irqrestore(&rnet->lock, flags);
+}
+#endif
+
+
 static void rionet_dbell_event(struct rio_mport *mport, void *dev_id, u16 sid, u16 tid,
 			       u16 info)
 {
@@ -232,6 +465,10 @@ static void rionet_dbell_event(struct rio_mport *mport, void *dev_id, u16 sid, u
 		}
 	} else if (info == RIONET_DOORBELL_LEAVE) {
 		rionet_active[sid] = NULL;
+#ifdef CONFIG_RIONET_MEMMAP
+	} else if (info == RIONET_DOORBELL_SEND) {
+		rionet_inb_recv_event(mport, ndev);
+#endif
 	} else {
 		if (netif_msg_intr(rnet))
 			printk(KERN_WARNING "%s: unhandled doorbell\n",
@@ -239,6 +476,7 @@ static void rionet_dbell_event(struct rio_mport *mport, void *dev_id, u16 sid, u
 	}
 }
 
+#ifndef CONFIG_RIONET_MEMMAP
 static void rionet_inb_msg_event(struct rio_mport *mport, void *dev_id, int mbox, int slot)
 {
 	int n;
@@ -281,6 +519,58 @@ static void rionet_outb_msg_event(struct rio_mport *mport, void *dev_id, int mbo
 
 	spin_unlock(&rnet->lock);
 }
+#endif
+
+#ifdef CONFIG_RIONET_DMA
+static enum dma_state_client rionet_dma_event(struct dma_client *client,
+		struct dma_chan *chan, enum dma_state state)
+{
+	struct rionet_private *rnet = container_of(client,
+			struct rionet_private, rio_dma_client);
+	enum dma_state_client ack = DMA_DUP;
+
+	spin_lock(&rnet->lock);
+	switch (state) {
+	case DMA_RESOURCE_AVAILABLE:
+		if (!rnet->txdmachan) {
+			ack = DMA_ACK;
+			rnet->txdmachan = chan;
+		} else if (!rnet->rxdmachan) {
+			ack = DMA_ACK;
+			rnet->rxdmachan = chan;
+		}
+		break;
+	case DMA_RESOURCE_REMOVED:
+		if (rnet->txdmachan == chan) {
+			ack = DMA_ACK;
+			rnet->txdmachan = NULL;
+		} else if (rnet->rxdmachan == chan) {
+			ack = DMA_ACK;
+			rnet->rxdmachan = NULL;
+		}
+		break;
+	default:
+		break;
+	}
+	spin_unlock(&rnet->lock);
+	return ack;
+}
+
+static int rionet_dma_register(struct rionet_private *rnet)
+{
+	int rc = 0;
+	spin_lock_init(&rnet->rio_dma_event_lock);
+	rnet->rio_dma_client.event_callback = rionet_dma_event;
+	dma_cap_set(DMA_MEMCPY, rnet->rio_dma_client.cap_mask);
+	dma_async_client_register(&rnet->rio_dma_client);
+	dma_async_client_chan_request(&rnet->rio_dma_client);
+
+	if (!rnet->txdmachan || !rnet->rxdmachan)
+		rc = -ENODEV;
+
+	return rc;
+}
+#endif
 
 static int rionet_open(struct net_device *ndev)
 {
@@ -299,6 +589,26 @@ static int rionet_open(struct net_device *ndev)
 					rionet_dbell_event)) < 0)
 		goto out;
 
+#ifdef CONFIG_RIONET_MEMMAP
+	if (!(rnet->rxmem = rio_request_inb_region(rnet->mport, NULL,
+		  RIONET_TX_RX_BUFF_SIZE, "rionet_rx_buff", RIONET_DRVID))) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	rnet->rxbuff = rnet->rxmem->virt;
+
+	if (!(rnet->txmem = rio_prepare_io_mem(rnet->mport, NULL,
+				RIONET_TX_RX_BUFF_SIZE, "rionet_tx_buff"))) {
+		rc = -ENOMEM;
+		goto out;
+	}
+	rnet->txbuff = rnet->txmem->virt;
+#ifdef CONFIG_RIONET_DMA
+	rc = rionet_dma_register(rnet);
+	if (rc)
+		goto out;
+#endif /* CONFIG_RIONET_DMA */
+#else
 	if ((rc = rio_request_inb_mbox(rnet->mport,
 				       (void *)ndev,
 				       RIONET_MAILBOX,
@@ -312,6 +622,7 @@ static int rionet_open(struct net_device *ndev)
 					RIONET_TX_RING_SIZE,
 					rionet_outb_msg_event)) < 0)
 		goto out;
+#endif
 
 	/* Initialize inbound message ring */
 	for (i = 0; i < RIONET_RX_RING_SIZE; i++)
@@ -375,8 +686,18 @@ static int rionet_close(struct net_device *ndev)
 
 	rio_release_inb_dbell(rnet->mport, RIONET_DOORBELL_JOIN,
 			      RIONET_DOORBELL_LEAVE);
+#ifdef CONFIG_RIONET_MEMMAP
+	rio_release_inb_region(rnet->mport, rnet->rxmem);
+	rio_release_outb_region(rnet->mport, rnet->txmem);
+	rnet->rxbuff = NULL;
+	rnet->txbuff = NULL;
+#ifdef CONFIG_RIONET_DMA
+	dma_async_client_unregister(&rnet->rio_dma_client);
+#endif
+#else
 	rio_release_inb_mbox(rnet->mport, RIONET_MAILBOX);
 	rio_release_outb_mbox(rnet->mport, RIONET_MAILBOX);
+#endif
 
 	return 0;
 }
-- 
1.5.4

