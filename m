Return-Path: <linux-kernel-owner+w=401wt.eu-S1758727AbZLGAQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758727AbZLGAQf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 19:16:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934380AbZLGAOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 19:14:07 -0500
Received: from kroah.org ([198.145.64.141]:34732 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758624AbZLGAOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 19:14:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Sun Dec  6 16:06:59 2009
Message-Id: <20091207000658.952588555@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Sun, 06 Dec 2009 16:01:20 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [104/119] b43: Fix DMA TX bounce buffer copying
References: <20091206235936.208334321@mini.kroah.org>
Content-Disposition: inline; filename=b43-fix-dma-tx-bounce-buffer-copying.patch
In-Reply-To: <20091207000938.GA24743@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 9a3f45116f5e08819136cd512fd7f6450ac22aa8 upstream.

b43 allocates a bouncebuffer, if the supplied TX skb is in an invalid
memory range for DMA.
However, this is broken in that it fails to copy over some metadata to the
new skb.

This patch fixes three problems:
* Failure to adjust the ieee80211_tx_info pointer to the new buffer.
  This results in a kmemcheck warning.
* Failure to copy the skb cb, which contains ieee80211_tx_info, to the new skb.
  This results in breakage of various TX-status postprocessing (Rate control).
* Failure to transfer the queue mapping.
  This results in the wrong queue being stopped on saturation and can result in queue overflow.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Tested-by: Christian Casteyde <casteyde.christian@free.fr>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/dma.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1158,8 +1158,9 @@ struct b43_dmaring *parse_cookie(struct 
 }
 
 static int dma_tx_fragment(struct b43_dmaring *ring,
-			   struct sk_buff *skb)
+			   struct sk_buff **in_skb)
 {
+	struct sk_buff *skb = *in_skb;
 	const struct b43_dma_ops *ops = ring->ops;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	u8 *header;
@@ -1225,8 +1226,14 @@ static int dma_tx_fragment(struct b43_dm
 		}
 
 		memcpy(skb_put(bounce_skb, skb->len), skb->data, skb->len);
+		memcpy(bounce_skb->cb, skb->cb, sizeof(skb->cb));
+		bounce_skb->dev = skb->dev;
+		skb_set_queue_mapping(bounce_skb, skb_get_queue_mapping(skb));
+		info = IEEE80211_SKB_CB(bounce_skb);
+
 		dev_kfree_skb_any(skb);
 		skb = bounce_skb;
+		*in_skb = bounce_skb;
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 		if (b43_dma_mapping_error(ring, meta->dmaaddr, skb->len, 1)) {
@@ -1359,7 +1366,11 @@ int b43_dma_tx(struct b43_wldev *dev, st
 	 * static, so we don't need to store it per frame. */
 	ring->queue_prio = skb_get_queue_mapping(skb);
 
-	err = dma_tx_fragment(ring, skb);
+	/* dma_tx_fragment might reallocate the skb, so invalidate pointers pointing
+	 * into the skb data or cb now. */
+	hdr = NULL;
+	info = NULL;
+	err = dma_tx_fragment(ring, &skb);
 	if (unlikely(err == -ENOKEY)) {
 		/* Drop this packet, as we don't have the encryption key
 		 * anymore and must not transmit it unencrypted. */


