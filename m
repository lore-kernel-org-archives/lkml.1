Return-Path: <linux-kernel-owner+w=401wt.eu-S932154AbZAOUGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154AbZAOUGR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765568AbZAOUAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:30 -0500
Received: from kroah.org ([198.145.64.141]:48784 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762757AbZAOUAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:23 -0500
Date: Thu, 15 Jan 2009 11:57:34 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Zhu Yi <yi.zhu@intel.com>,
       Tomas Winkler <tomas.winkler@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 10/94] iwlwifi: use GFP_KERNEL to allocate Rx SKB memory
Message-ID: <20090115195734.GJ14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="iwlwifi-use-gfp_kernel-to-allocate-rx-skb-memory.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhu Yi <yi.zhu@intel.com>

commit f1bc4ac61f2c08515afd80c6dc3962aa6d0b138b upstream.

Previously we allocate Rx SKB with GFP_ATOMIC flag. This is because we need
to hold a spinlock to protect the two rx_used and rx_free lists operation
in the rxq.

	spin_lock();
	...
	element = rxq->rx_used.next;
	element->skb = alloc_skb(..., GFP_ATOMIC);
	list_del(element);
	list_add_tail(&element->list, &rxq->rx_free);
	...
	spin_unlock();

After spliting the rx_used delete and rx_free insert into two operations,
we don't require the skb allocation in an atomic context any more (the
function itself is scheduled in a workqueue).

	spin_lock();
	...
	element = rxq->rx_used.next;
	list_del(element);
	...
	spin_unlock();
	...
	element->skb = alloc_skb(..., GFP_KERNEL);
	...
	spin_lock()
	...
	list_add_tail(&element->list, &rxq->rx_free);
	...
	spin_unlock();

This patch should fix the "iwlagn: Can not allocate SKB buffers" warning
we see recently.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   12 +-----------
 drivers/net/wireless/iwlwifi/iwl-rx.c  |   29 +++++++++++++++++++----------
 2 files changed, 20 insertions(+), 21 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1334,16 +1334,6 @@ static void iwl_setup_rx_handlers(struct
 	priv->cfg->ops->lib->rx_handler_setup(priv);
 }
 
-/*
- * this should be called while priv->lock is locked
-*/
-static void __iwl_rx_replenish(struct iwl_priv *priv)
-{
-	iwl_rx_allocate(priv);
-	iwl_rx_queue_restock(priv);
-}
-
-
 /**
  * iwl_rx_handle - Main entry function for receiving responses from uCode
  *
@@ -1451,7 +1441,7 @@ void iwl_rx_handle(struct iwl_priv *priv
 			count++;
 			if (count >= 8) {
 				priv->rxq.read = i;
-				__iwl_rx_replenish(priv);
+				iwl_rx_queue_restock(priv);
 				count = 0;
 			}
 		}
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -245,25 +245,31 @@ void iwl_rx_allocate(struct iwl_priv *pr
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
 	unsigned long flags;
-	spin_lock_irqsave(&rxq->lock, flags);
-	while (!list_empty(&rxq->rx_used)) {
+
+	while (1) {
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			return;
+		}
 		element = rxq->rx_used.next;
 		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		/* Alloc a new receive buffer */
 		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
-				__GFP_NOWARN | GFP_ATOMIC);
+				     GFP_KERNEL);
 		if (!rxb->skb) {
-			if (net_ratelimit())
-				printk(KERN_CRIT DRV_NAME
-				       ": Can not allocate SKB buffers\n");
+			printk(KERN_CRIT DRV_NAME
+				   "Can not allocate SKB buffers\n");
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
 			 * more buffers it will schedule replenish */
 			break;
 		}
-		priv->alloc_rxb_skb++;
-		list_del(element);
 
 		/* Get physical address of RB/SKB */
 		rxb->real_dma_addr = pci_map_single(
@@ -277,12 +283,15 @@ void iwl_rx_allocate(struct iwl_priv *pr
 		rxb->aligned_dma_addr = ALIGN(rxb->real_dma_addr, 256);
 		skb_reserve(rxb->skb, rxb->aligned_dma_addr - rxb->real_dma_addr);
 
+		spin_lock_irqsave(&rxq->lock, flags);
+
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
+		priv->alloc_rxb_skb++;
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
 	}
-	spin_unlock_irqrestore(&rxq->lock, flags);
 }
-EXPORT_SYMBOL(iwl_rx_allocate);
 
 void iwl_rx_replenish(struct iwl_priv *priv)
 {

