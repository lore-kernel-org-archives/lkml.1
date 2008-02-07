Return-Path: <linux-kernel-owner+w=401wt.eu-S935338AbYBGVKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935338AbYBGVKn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933627AbYBGUxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 15:53:42 -0500
Received: from mx1.suse.de ([195.135.220.2]:45965 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614AbYBGUxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 15:53:40 -0500
Date: Thu, 7 Feb 2008 12:48:07 -0800
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
       Michael@hera.kernel.org, linux-wireless@vger.kernel.org,
       bcm43xx-dev@lists.berlios.de, Buesch <mb@bu3sch.de>,
       Stefano Brivio <stefano.brivio@polimi.it>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [patch 37/45] b43legacy: fix DMA slot resource leakage
Message-ID: <20080207204807.GL16389@suse.de>
References: <20080207204118.202098927@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43legacy-fix-dma-slot-resource-leakage.patch"
In-Reply-To: <20080207204549.GA16389@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.24-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Stefano Brivio <stefano.brivio@polimi.it>

patch 8dd0100ce9511e52614ecd0a6587c13ce5769c8b in mainline.

This fixes four resource leakages.
In any error path we must deallocate the DMA frame slots we
previously allocated by request_slot().
This is done by storing the ring pointers before doing any ring
allocation and restoring the old pointers in case of an error.

This patch by Michael Buesch has been ported to b43legacy.

Cc: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Stefano Brivio <stefano.brivio@polimi.it>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43legacy/dma.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/b43legacy/dma.c
+++ b/drivers/net/wireless/b43legacy/dma.c
@@ -1164,7 +1164,7 @@ static int dma_tx_fragment(struct b43leg
 {
 	const struct b43legacy_dma_ops *ops = ring->ops;
 	u8 *header;
-	int slot;
+	int slot, old_top_slot, old_used_slots;
 	int err;
 	struct b43legacy_dmadesc_generic *desc;
 	struct b43legacy_dmadesc_meta *meta;
@@ -1174,6 +1174,9 @@ static int dma_tx_fragment(struct b43leg
 #define SLOTS_PER_PACKET  2
 	B43legacy_WARN_ON(skb_shinfo(skb)->nr_frags != 0);
 
+	old_top_slot = ring->current_slot;
+	old_used_slots = ring->used_slots;
+
 	/* Get a slot for the header. */
 	slot = request_slot(ring);
 	desc = ops->idx2desc(ring, slot, &meta_hdr);
@@ -1184,8 +1187,11 @@ static int dma_tx_fragment(struct b43leg
 	err = b43legacy_generate_txhdr(ring->dev, header,
 				 skb->data, skb->len, ctl,
 				 generate_cookie(ring, slot));
-	if (unlikely(err))
+	if (unlikely(err)) {
+		ring->current_slot = old_top_slot;
+		ring->used_slots = old_used_slots;
 		return err;
+	}
 
 	meta_hdr->dmaaddr = map_descbuffer(ring, (unsigned char *)header,
 				       sizeof(struct b43legacy_txhdr_fw3), 1);
@@ -1208,6 +1214,8 @@ static int dma_tx_fragment(struct b43leg
 	if (dma_mapping_error(meta->dmaaddr)) {
 		bounce_skb = __dev_alloc_skb(skb->len, GFP_ATOMIC | GFP_DMA);
 		if (!bounce_skb) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -ENOMEM;
 			goto out_unmap_hdr;
 		}
@@ -1218,6 +1226,8 @@ static int dma_tx_fragment(struct b43leg
 		meta->skb = skb;
 		meta->dmaaddr = map_descbuffer(ring, skb->data, skb->len, 1);
 		if (dma_mapping_error(meta->dmaaddr)) {
+			ring->current_slot = old_top_slot;
+			ring->used_slots = old_used_slots;
 			err = -EIO;
 			goto out_free_bounce;
 		}

-- 
