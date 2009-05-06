Return-Path: <linux-kernel-owner+w=401wt.eu-S932086AbZEFUkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbZEFUkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 16:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761053AbZEFUjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 16:39:00 -0400
Received: from kroah.org ([198.145.64.141]:33876 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761096AbZEFUi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 16:38:58 -0400
X-Mailbox-Line: From greg@blue.kroah.org Wed May  6 13:31:29 2009
Message-Id: <20090506203128.969540094@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 06 May 2009 13:30:16 -0700
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
       Chris Wright <chrisw@sous-sol.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 06/18] b43: Refresh RX poison on buffer recycling
References: <20090506203010.615363711@blue.kroah.org>
Content-Disposition: inline; filename=b43-refresh-rx-poison-on-buffer-recycling.patch
In-Reply-To: <20090506203353.GA14624@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/b43/dma.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -1498,20 +1498,16 @@ static void dma_rx(struct b43_dmaring *r
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
@@ -1525,6 +1521,7 @@ static void dma_rx(struct b43_dmaring *r
 		while (1) {
 			desc = ops->idx2desc(ring, *slot, &meta);
 			/* recycle the descriptor buffer. */
+			b43_poison_rx_buffer(ring, meta->skb);
 			sync_descbuffer_for_device(ring, meta->dmaaddr,
 						   ring->rx_buffersize);
 			*slot = next_slot(ring, *slot);
@@ -1543,8 +1540,7 @@ static void dma_rx(struct b43_dmaring *r
 	err = setup_rx_descbuffer(ring, desc, meta, GFP_ATOMIC);
 	if (unlikely(err)) {
 		b43dbg(ring->dev->wl, "DMA RX: setup_rx_descbuffer() failed\n");
-		sync_descbuffer_for_device(ring, dmaaddr, ring->rx_buffersize);
-		goto drop;
+		goto drop_recycle_buffer;
 	}
 
 	unmap_descbuffer(ring, dmaaddr, ring->rx_buffersize, 0);
@@ -1554,6 +1550,11 @@ static void dma_rx(struct b43_dmaring *r
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


