Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbZGFTuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbZGFTuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 15:50:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZGFTuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 15:50:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53292
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752964AbZGFTuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 15:50:05 -0400
Date: Mon, 06 Jul 2009 12:50:11 -0700 (PDT)
Message-Id: <20090706.125011.56653570.davem@davemloft.net>
To: Larry.Finger@lwfinger.net
Cc: chunkeey@web.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p54: Fix regression in 2.6.31-rcX since commit a1091aa
 - sleeping function called from invalid context
From: David Miller <davem@davemloft.net>
In-Reply-To: <4A5253F1.50504@lwfinger.net>
References: <200907062119.25642.chunkeey@web.de>
	<20090706.123441.246532764.davem@davemloft.net>
	<4A5253F1.50504@lwfinger.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>
Date: Mon, 06 Jul 2009 14:43:45 -0500

> I'm available for testing.

I just committed the following to my net-2.6 tree, give
it a spin:

>From 0ca1b08eba627b4245efd0f71b55a062bf163777 Mon Sep 17 00:00:00 2001
From: David S. Miller <davem@davemloft.net>
Date: Mon, 6 Jul 2009 12:49:18 -0700
Subject: [PATCH] Revert "p54: Use SKB list handling helpers instead of by-hand code."

This reverts commit a1091aae19b1d9c85d91c86915a611387f67a26b.
---
 drivers/net/wireless/p54/p54common.c |   46 ++++++++++++++++++++--------------
 1 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/p54/p54common.c b/drivers/net/wireless/p54/p54common.c
index b618bd1..48d81d9 100644
--- a/drivers/net/wireless/p54/p54common.c
+++ b/drivers/net/wireless/p54/p54common.c
@@ -823,30 +823,30 @@ void p54_free_skb(struct ieee80211_hw *dev, struct sk_buff *skb)
 	struct p54_tx_info *range;
 	unsigned long flags;
 
-	if (unlikely(!skb || !dev || skb_queue_empty(&priv->tx_queue)))
+	if (unlikely(!skb || !dev || !skb_queue_len(&priv->tx_queue)))
 		return;
 
-	/* There used to be a check here to see if the SKB was on the
-	 * TX queue or not.  This can never happen because all SKBs we
-	 * see here successfully went through p54_assign_address()
-	 * which means the SKB is on the ->tx_queue.
+	/*
+	 * don't try to free an already unlinked skb
 	 */
+	if (unlikely((!skb->next) || (!skb->prev)))
+		return;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
 	info = IEEE80211_SKB_CB(skb);
 	range = (void *)info->rate_driver_data;
-	if (!skb_queue_is_first(&priv->tx_queue, skb)) {
+	if (skb->prev != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *ni;
 		struct p54_tx_info *mr;
 
-		ni = IEEE80211_SKB_CB(skb_queue_prev(&priv->tx_queue, skb));
+		ni = IEEE80211_SKB_CB(skb->prev);
 		mr = (struct p54_tx_info *)ni->rate_driver_data;
 	}
-	if (!skb_queue_is_last(&priv->tx_queue, skb)) {
+	if (skb->next != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *ni;
 		struct p54_tx_info *mr;
 
-		ni = IEEE80211_SKB_CB(skb_queue_next(&priv->tx_queue, skb));
+		ni = IEEE80211_SKB_CB(skb->next);
 		mr = (struct p54_tx_info *)ni->rate_driver_data;
 	}
 	__skb_unlink(skb, &priv->tx_queue);
@@ -864,13 +864,15 @@ static struct sk_buff *p54_find_tx_entry(struct ieee80211_hw *dev,
 	unsigned long flags;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
-	skb_queue_walk(&priv->tx_queue, entry) {
+	entry = priv->tx_queue.next;
+	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct p54_hdr *hdr = (struct p54_hdr *) entry->data;
 
 		if (hdr->req_id == req_id) {
 			spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 			return entry;
 		}
+		entry = entry->next;
 	}
 	spin_unlock_irqrestore(&priv->tx_queue.lock, flags);
 	return NULL;
@@ -888,22 +890,24 @@ static void p54_rx_frame_sent(struct ieee80211_hw *dev, struct sk_buff *skb)
 	int count, idx;
 
 	spin_lock_irqsave(&priv->tx_queue.lock, flags);
-	skb_queue_walk(&priv->tx_queue, entry) {
+	entry = (struct sk_buff *) priv->tx_queue.next;
+	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		struct ieee80211_tx_info *info = IEEE80211_SKB_CB(entry);
 		struct p54_hdr *entry_hdr;
 		struct p54_tx_data *entry_data;
 		unsigned int pad = 0, frame_len;
 
 		range = (void *)info->rate_driver_data;
-		if (range->start_addr != addr)
+		if (range->start_addr != addr) {
+			entry = entry->next;
 			continue;
+		}
 
-		if (!skb_queue_is_last(&priv->tx_queue, entry)) {
+		if (entry->next != (struct sk_buff *)&priv->tx_queue) {
 			struct ieee80211_tx_info *ni;
 			struct p54_tx_info *mr;
 
-			ni = IEEE80211_SKB_CB(skb_queue_next(&priv->tx_queue,
-							     entry));
+			ni = IEEE80211_SKB_CB(entry->next);
 			mr = (struct p54_tx_info *)ni->rate_driver_data;
 		}
 
@@ -1164,21 +1168,23 @@ static int p54_assign_address(struct ieee80211_hw *dev, struct sk_buff *skb,
 		}
 	}
 
-	skb_queue_walk(&priv->tx_queue, entry) {
+	entry = priv->tx_queue.next;
+	while (left--) {
 		u32 hole_size;
 		info = IEEE80211_SKB_CB(entry);
 		range = (void *)info->rate_driver_data;
 		hole_size = range->start_addr - last_addr;
 		if (!target_skb && hole_size >= len) {
-			target_skb = skb_queue_prev(&priv->tx_queue, entry);
+			target_skb = entry->prev;
 			hole_size -= len;
 			target_addr = last_addr;
 		}
 		largest_hole = max(largest_hole, hole_size);
 		last_addr = range->end_addr;
+		entry = entry->next;
 	}
 	if (!target_skb && priv->rx_end - last_addr >= len) {
-		target_skb = skb_peek_tail(&priv->tx_queue);
+		target_skb = priv->tx_queue.prev;
 		largest_hole = max(largest_hole, priv->rx_end - last_addr - len);
 		if (!skb_queue_empty(&priv->tx_queue)) {
 			info = IEEE80211_SKB_CB(target_skb);
@@ -2084,6 +2090,7 @@ out:
 static void p54_stop(struct ieee80211_hw *dev)
 {
 	struct p54_common *priv = dev->priv;
+	struct sk_buff *skb;
 
 	mutex_lock(&priv->conf_mutex);
 	priv->mode = NL80211_IFTYPE_UNSPECIFIED;
@@ -2098,7 +2105,8 @@ static void p54_stop(struct ieee80211_hw *dev)
 		p54_tx_cancel(dev, priv->cached_beacon);
 
 	priv->stop(dev);
-	skb_queue_purge(&priv->tx_queue);
+	while ((skb = skb_dequeue(&priv->tx_queue)))
+		kfree_skb(skb);
 	priv->cached_beacon = NULL;
 	priv->tsf_high32 = priv->tsf_low32 = 0;
 	mutex_unlock(&priv->conf_mutex);
-- 
1.6.3.3

