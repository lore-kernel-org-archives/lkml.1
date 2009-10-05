Return-Path: <linux-kernel-owner+w=401wt.eu-S1758668AbZJEIVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758668AbZJEIVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:21:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758558AbZJEIVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:21:36 -0400
Received: from msr14.hinet.net ([168.95.4.114]:35226 "EHLO msr14.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758551AbZJEIVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:21:35 -0400
X-Greylist: delayed 2254 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 04:20:43 EDT
From: Thomas Chou <thomas@wytron.com.tw>
To: thierry.reding@avionic-design.de
Cc: Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       linux-kernel@vger.kernel.org, Thomas Chou <thomas@wytron.com.tw>
Subject: [PATCH 2/4] ethoc: fix buffer address mapping
Date: Mon,  5 Oct 2009 15:43:03 +0800
Message-Id: <1254728585-31964-2-git-send-email-thomas@wytron.com.tw>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254728585-31964-1-git-send-email-thomas@wytron.com.tw>
References: <1254728585-31964-1-git-send-email-thomas@wytron.com.tw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pointer address in buffer descriptors is physical address. The
pointer that processor used to access packet is virtual address.

Though the higher bits of pointer address used by the MAC may be
truncated to zero in special case, it is not always true in larger
designs.

Signed-off-by: Thomas Chou <thomas@wytron.com.tw>
---
 drivers/net/ethoc.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethoc.c b/drivers/net/ethoc.c
index 7475620..f92747f 100644
--- a/drivers/net/ethoc.c
+++ b/drivers/net/ethoc.c
@@ -284,7 +284,7 @@ static int ethoc_init_ring(struct ethoc *dev)
 	dev->cur_rx = 0;
 
 	/* setup transmission buffers */
-	bd.addr = 0;
+	bd.addr = virt_to_phys(dev->membase);
 	bd.stat = TX_BD_IRQ | TX_BD_CRC;
 
 	for (i = 0; i < dev->num_tx; i++) {
@@ -295,7 +295,6 @@ static int ethoc_init_ring(struct ethoc *dev)
 		bd.addr += ETHOC_BUFSIZ;
 	}
 
-	bd.addr = dev->num_tx * ETHOC_BUFSIZ;
 	bd.stat = RX_BD_EMPTY | RX_BD_IRQ;
 
 	for (i = 0; i < dev->num_rx; i++) {
@@ -401,7 +400,7 @@ static int ethoc_rx(struct net_device *dev, int limit)
 			int size = bd.stat >> 16;
 			struct sk_buff *skb = netdev_alloc_skb(dev, size);
 			if (likely(skb)) {
-				void *src = priv->membase + bd.addr;
+				void *src = phys_to_virt(bd.addr);
 				memcpy_fromio(skb_put(skb, size), src, size);
 				skb->protocol = eth_type_trans(skb, dev);
 				priv->stats.rx_packets++;
@@ -823,7 +822,7 @@ static netdev_tx_t ethoc_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	else
 		bd.stat &= ~TX_BD_PAD;
 
-	dest = priv->membase + bd.addr;
+	dest = phys_to_virt(bd.addr);
 	memcpy_toio(dest, skb->data, skb->len);
 
 	bd.stat &= ~(TX_BD_STATS | TX_BD_LEN_MASK);
-- 
1.6.2.5

