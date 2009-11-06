Return-Path: <linux-kernel-owner+w=401wt.eu-S1760274AbZKFW0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760274AbZKFW0a (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760198AbZKFW02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:26:28 -0500
Received: from kroah.org ([198.145.64.141]:57190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932704AbZKFWXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:40 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:51 2009
Message-Id: <20091106221551.389639017@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:15:28 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [90/99] iwlwifi: fix potential rx buffer loss
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=iwlwifi-fix-potential-rx-buffer-loss.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Reinette Chatre <reinette.chatre@intel.com>

commit de0bd50845eb5935ce3d503c5d2f565d6cb9ece1 upstream.

RX handling maintains a few lists that keep track of the RX buffers.
Buffers move from one list to the other as they are used, replenished, and
again made available for usage. In one such instance, when a buffer is used
it enters the "rx_used" list. When buffers are replenished an skb is
attached to the buffer and it is moved to the "rx_free" list. The problem
here is that the buffer is first removed from the "rx_used" list _before_ the
skb is allocated. Thus, if the skb allocation fails this buffer remains
removed from the "rx_used" list and is thus lost for future usage.

Fix this by first allocating the skb before trying to attach it to a list.
We add an additional check to not do this unnecessarily.

Reported-by: Rick Farrington <rickdic@hotmail.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   24 +++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   24 ++++++++++++++++--------
 2 files changed, 33 insertions(+), 15 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -1196,6 +1196,7 @@ static void iwl3945_rx_allocate(struct i
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
+	struct sk_buff *skb;
 	unsigned long flags;
 
 	while (1) {
@@ -1205,17 +1206,11 @@ static void iwl3945_rx_allocate(struct i
 			spin_unlock_irqrestore(&rxq->lock, flags);
 			return;
 		}
-
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		/* Alloc a new receive buffer */
-		rxb->skb =
-		    alloc_skb(priv->hw_params.rx_buf_size,
-				priority);
-		if (!rxb->skb) {
+		skb = alloc_skb(priv->hw_params.rx_buf_size, priority);
+		if (!skb) {
 			if (net_ratelimit())
 				IWL_CRIT(priv, ": Can not allocate SKB buffers\n");
 			/* We don't reschedule replenish work here -- we will
@@ -1224,6 +1219,19 @@ static void iwl3945_rx_allocate(struct i
 			break;
 		}
 
+		spin_lock_irqsave(&rxq->lock, flags);
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			dev_kfree_skb_any(skb);
+			return;
+		}
+		element = rxq->rx_used.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		rxb->skb = skb;
+
 		/* If radiotap head is required, reserve some headroom here.
 		 * The physical head count is a variable rx_stats->phy_count.
 		 * We reserve 4 bytes here. Plus these extra bytes, the
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -239,26 +239,22 @@ void iwl_rx_allocate(struct iwl_priv *pr
 	struct iwl_rx_queue *rxq = &priv->rxq;
 	struct list_head *element;
 	struct iwl_rx_mem_buffer *rxb;
+	struct sk_buff *skb;
 	unsigned long flags;
 
 	while (1) {
 		spin_lock_irqsave(&rxq->lock, flags);
-
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
 			return;
 		}
-		element = rxq->rx_used.next;
-		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
-		list_del(element);
-
 		spin_unlock_irqrestore(&rxq->lock, flags);
 
 		/* Alloc a new receive buffer */
-		rxb->skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
+		skb = alloc_skb(priv->hw_params.rx_buf_size + 256,
 						priority);
 
-		if (!rxb->skb) {
+		if (!skb) {
 			IWL_CRIT(priv, "Can not allocate SKB buffers\n");
 			/* We don't reschedule replenish work here -- we will
 			 * call the restock method and if it still needs
@@ -266,6 +262,20 @@ void iwl_rx_allocate(struct iwl_priv *pr
 			break;
 		}
 
+		spin_lock_irqsave(&rxq->lock, flags);
+
+		if (list_empty(&rxq->rx_used)) {
+			spin_unlock_irqrestore(&rxq->lock, flags);
+			dev_kfree_skb_any(skb);
+			return;
+		}
+		element = rxq->rx_used.next;
+		rxb = list_entry(element, struct iwl_rx_mem_buffer, list);
+		list_del(element);
+
+		spin_unlock_irqrestore(&rxq->lock, flags);
+
+		rxb->skb = skb;
 		/* Get physical address of RB/SKB */
 		rxb->real_dma_addr = pci_map_single(
 					priv->pci_dev,


