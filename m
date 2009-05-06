Return-Path: <linux-kernel-owner+w=401wt.eu-S1761723AbZEFVzx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761723AbZEFVzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 17:55:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761350AbZEFVyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 17:54:23 -0400
Received: from kroah.org ([198.145.64.141]:56901 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761259AbZEFVyU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 17:54:20 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Wed May  6 14:47:55 2009
Message-Id: <20090506214755.728747673@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 14:45:32 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk,
       Francesco Gringoli <francesco.gringoli@ing.unibs.it>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: [patch 04/58] b43: Refresh RX poison on buffer recycling
References: <20090506214528.660389067@mini.kroah.org>
Content-Disposition: inline; filename=b43-refresh-rx-poison-on-buffer-recycling.patch
In-Reply-To: <20090506215017.GA21981@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael Buesch <mb@bu3sch.de>

upstream commit: cf68636a9773aa97915497fe54fa4a51e3f08f3a

The RX buffer poison needs to be refreshed, if we recycle an RX buffer,
because it might be (partially) overwritten by some DMA operations.

Cc: stable@kernel.org
Cc: Francesco Gringoli <francesco.gringoli@ing.unibs.it>
Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---
 drivers/net/wireless/b43/dma.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1496,20 +1496,16 @@ static void dma_rx(struct b43_dmaring *r
 			len = le16_to_cpu(rxhdr->frame_len);
 		} while (len == 0 && i++ < 5);
 		if (unlikely(len == 0)) {
-			/* recycle the descriptor buffer. */
-			sync_descbuffer_for_device(ring, meta->dmaaddr,
-						   ring->rx_buffersize);
-			goto drop;
+			dmaaddr = meta->dmaaddr;
+			goto drop_recycle_buffer;
 		}
 	}
 	if (unlikely(b43_rx_buffer_is_poisoned(ring, skb))) {
 		/* Something went wrong with the DMA.
 		 * The device did not touch the buffer and did not overwrite the poison. */
 		b43dbg(ring->dev->wl, "DMA RX: Dropping poisoned buffer.\n");
-		/* recycle the descriptor buffer. */
-		sync_descbuffer_for_device(ring, meta->dmaaddr,
-					   ring->rx_buffersize);
-		goto drop;
+		dmaaddr = meta->dmaaddr;
+		goto drop_recycle_buffer;
 	}
 	if (unlikely(len > ring->rx_buffersize)) {
 		/* The data did not fit into one descriptor buffer
@@ -1523,6 +1519,7 @@ static void dma_rx(struct b43_dmaring *r
 		while (1) {
 			desc = ops->idx2desc(ring, *slot, &meta);
 			/* recycle the descriptor buffer. */
+			b43_poison_rx_buffer(ring, meta->skb);
 			sync_descbuffer_for_device(ring, meta->dmaaddr,
 						   ring->rx_buffersize);
 			*slot = next_slot(ring, *slot);
@@ -1541,8 +1538,7 @@ static void dma_rx(struct b43_dmaring *r
 	err = setup_rx_descbuffer(ring, desc, meta, GFP_ATOMIC);
 	if (unlikely(err)) {
 		b43dbg(ring->dev->wl, "DMA RX: setup_rx_descbuffer() failed\n");
-		sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
-		goto drop;
+		goto drop_recycle_buffer;
 	}
 
 	unmap_descbuffer(ring, dmaaddr, ring->rx_buffersize, 0);
@@ -1552,6 +1548,11 @@ static void dma_rx(struct b43_dmaring *r
 	b43_rx(ring->dev, skb, rxhdr);
 drop:
 	return;
+
+drop_recycle_buffer:
+	/* Poison and recycle the RX buffer. */
+	b43_poison_rx_buffer(ring, skb);
+	sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
 }
 
 void b43_dma_rx(struct b43_dmaring *ring)


