Return-Path: <linux-kernel-owner+w=401wt.eu-S1765808AbYBZWnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765808AbYBZWnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 17:43:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763258AbYBZWmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 17:42:51 -0500
Received: from vs166246.vserver.de ([62.75.166.246]:36148 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762977AbYBZWmu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 17:42:50 -0500
From: Michael Buesch <mb@bu3sch.de>
To: "Alexey Zaytsev" <alexey.zaytsev@gmail.com>
Subject: Re: bcm43xx regression in 2.6.24 (with patch)
Date: Tue, 26 Feb 2008 23:41:55 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: "John W. Linville" <linville@tuxdriver.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Alexey Zaytsev" <zaytsev.a@protei.ru>, "Greg KH" <greg@kroah.com>,
       linux-kernel@vger.kernel.org
References: <47BEAF3B.3080809@protei.ru> <200802262304.39882.mb@bu3sch.de> <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com>
In-Reply-To: <f19298770802261412j7a3fec4bv1754db8123796d54@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802262341.55675.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 26 February 2008 23:12:32 Alexey Zaytsev wrote:
> >  Yeah, seems so. But if you are willing to test an adjusted version, I can
> >  probably do a backported version of this patch.
> >  This patch is well tested and does the right thing, so I'm willing to sign
> >  off a backported version of this.
> >  First need to find the place in the old phy.c code that matches the new wa.c code.
> >
> I'll do the testing.

Index: linux-2.6.24.3/drivers/net/wireless/b43/dma.c
===================================================================
--- linux-2.6.24.3.orig/drivers/net/wireless/b43/dma.c	2008-02-26 23:39:39.000000000 +0100
+++ linux-2.6.24.3/drivers/net/wireless/b43/dma.c	2008-02-26 23:39:43.000000000 +0100
@@ -165,7 +165,7 @@ static void op64_fill_descriptor(struct 
 	addrhi = (((u64) dmaaddr >> 32) & ~SSB_DMA_TRANSLATION_MASK);
 	addrext = (((u64) dmaaddr >> 32) & SSB_DMA_TRANSLATION_MASK)
 	    >> SSB_DMA_TRANSLATION_SHIFT;
-	addrhi |= ssb_dma_translation(ring->dev->dev);
+	addrhi |= (ssb_dma_translation(ring->dev->dev) << 1);
 	if (slot == ring->nr_slots - 1)
 		ctl0 |= B43_DMA64_DCTL0_DTABLEEND;
 	if (start)
@@ -426,9 +426,21 @@ static inline
 static int alloc_ringmemory(struct b43_dmaring *ring)
 {
 	struct device *dev = ring->dev->dev->dev;
+	gfp_t flags = GFP_KERNEL;
 
+	/* The specs call for 4K buffers for 30- and 32-bit DMA with 4K
+	 * alignment and 8K buffers for 64-bit DMA with 8K alignment. Testing
+	 * has shown that 4K is sufficient for the latter as long as the buffer
+	 * does not cross an 8K boundary.
+	 *
+	 * For unknown reasons - possibly a hardware error - the BCM4311 rev
+	 * 02, which uses 64-bit DMA, needs the ring buffer in very low memory,
+	 * which accounts for the GFP_DMA flag below.
+	 */
+	if (ring->dma64)
+		flags |= GFP_DMA;
 	ring->descbase = dma_alloc_coherent(dev, B43_DMA_RINGMEMSIZE,
-					    &(ring->dmabase), GFP_KERNEL);
+					    &(ring->dmabase), flags);
 	if (!ring->descbase) {
 		b43err(ring->dev->wl, "DMA ringmemory allocation failed\n");
 		return -ENOMEM;
@@ -483,7 +495,7 @@ int b43_dmacontroller_rx_reset(struct b4
 	return 0;
 }
 
-/* Reset the RX DMA channel */
+/* Reset the TX DMA channel */
 int b43_dmacontroller_tx_reset(struct b43_wldev *dev, u16 mmio_base, int dma64)
 {
 	int i;
@@ -647,7 +659,7 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA64_TXRINGHI,
 				      ((ringbase >> 32) &
 				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
+				      | (trans << 1));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -680,8 +692,9 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA64_RXRINGHI,
 				      ((ringbase >> 32) &
 				       ~SSB_DMA_TRANSLATION_MASK)
-				      | trans);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, 200);
+				      | (trans << 1));
+			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 
@@ -695,11 +708,12 @@ static int dmacontroller_setup(struct b4
 			b43_dma_write(ring, B43_DMA32_RXRING,
 				      (ringbase & ~SSB_DMA_TRANSLATION_MASK)
 				      | trans);
-			b43_dma_write(ring, B43_DMA32_RXINDEX, 200);
+			b43_dma_write(ring, B43_DMA32_RXINDEX, ring->nr_slots *
+				      sizeof(struct b43_dmadesc32));
 		}
 	}
 
-      out:
+out:
 	return err;
 }
 
Index: linux-2.6.24.3/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.24.3.orig/drivers/net/wireless/b43/main.c	2008-02-26 23:39:39.000000000 +0100
+++ linux-2.6.24.3/drivers/net/wireless/b43/main.c	2008-02-26 23:39:43.000000000 +0100
@@ -101,6 +101,7 @@ static const struct ssb_device_id b43_ss
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 7),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 9),
 	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 10),
+	SSB_DEVICE(SSB_VENDOR_BROADCOM, SSB_DEV_80211, 13),
 	SSB_DEVTABLE_END
 };
 
@@ -3079,7 +3080,7 @@ static int b43_phy_versioning(struct b43
 			unsupported = 1;
 		break;
 	case B43_PHYTYPE_G:
-		if (phy_rev > 8)
+		if (phy_rev > 9)
 			unsupported = 1;
 		break;
 	default:


-- 
Greetings Michael.
