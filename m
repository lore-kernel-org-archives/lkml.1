Return-Path: <linux-kernel-owner+w=401wt.eu-S935144AbYBGVIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935144AbYBGVIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933501AbYBGUw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:52:58 -0500
Received: from mx2.suse.de ([195.135.220.15]:38689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933468AbYBGUwz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:52:55 -0500
Date: Thu, 7 Feb 2008 12:47:57 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       Michael Buesch <mb@bu3sch.de>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 33/45] b43: Fix dma-slot resource leakage
Message-ID: <20080207204757.GH16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-fix-dma-slot-resource-leakage.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Michael Buesch <mb@bu3sch.de>

patch 8dd0100ce9511e52614ecd0a6587c13ce5769c8b in mainline.

This fixes four resource leakages.
In any error path we must deallocate the DMA frame slots we
previously allocated by request_slot().
This is done by storing the ring pointers before doing any ring
allocation and restoring the old pointers in case of an error.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/dma.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1106,7 +1106,7 @@ static int dma_tx_fragment(struct b43_dm
 {
 	const struct b43_dma_ops *ops = ring->ops;
 	u8 *header;
-	int slot;
+	int slot, old_top_slot, old_used_slots;
 	int err;
 	struct b43_dmadesc_generic *desc;
 	struct b43_dmadesc_meta *meta;
@@ -1116,6 +1116,9 @@ static int dma_tx_fragment(struct b43_dm
 #define SLOTS_PER_PACKET  2
 	B43_WARN_ON(skb_shinfo(skb)->nr_frags);
 
+	old_top_slot = ring->current_slot;
+	old_used_slots = ring->used_slots;
+
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta_hdr);
@@ -1125,13 +1128,19 @@ static int dma_tx_fragment(struct b43_dm
 	err = b43_generate_txhdr(ring->dev, header,
 			   skb->data, skb->len, ctl,
 			   generate_cookie(ring, slot));
-	if (unlikely(err))
+	if (unlikely(err)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return err;
+	}
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 					   sizeof(struct b43_txhdr_fw4), 1);
-	if (dma_mapping_error(meta_hdr->dmaaddr))
+	if (dma_mapping_error(meta_hdr->dmaaddr)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return -EIO;
+	}
 	ops->fill_descriptor(ring, desc, meta_hdr->dmaaddr,
 			     sizeof(struct b43_txhdr_fw4), 1, 0, 0);
 
@@ -1149,6 +1158,8 @@ static int dma_tx_fragment(struct b43_dm
 	if (dma_mapping_error(meta->dmaaddr)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
 		}
@@ -1159,6 +1170,8 @@ static int dma_tx_fragment(struct b43_dm
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 		if (dma_mapping_error(meta->dmaaddr)) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -EIO;
 			goto out_free_bounce;
 		}

-- 
