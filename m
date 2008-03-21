Return-Path: <linux-kernel-owner+w=401wt.eu-S932881AbYCUXPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932881AbYCUXPO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 19:15:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763452AbYCUWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 18:53:29 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:41361 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763410AbYCUWx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 18:53:26 -0400
Message-Id: <20080321224421.540314761@sous-sol.org>
References: <20080321224250.144333319@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 21 Mar 2008 15:43:37 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Michael Buesch <mb@bu3sch.de>, Greg KH <greg@kroah.com>,
       linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
       alexey.zaytsev@gmail.com, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 47/76] b43: Backport bcm4311 fix
Content-Disposition: inline; filename=b43-backport-bcm4311-fix.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: Michael Buesch <mb@bu3sch.de>

This is a backport of upstream commit 013978b6 ("b43: Changes to enable
BCM4311 rev 02 with wireless core revision 13") and the changes include
the following:

(1) Add the 802.11 rev 13 device to the ssb_device_id table to load b43.
(2) Add PHY revision 9 to the supported list.
(3) Change the 2-bit routing code for address extensions to 0b10 rather
    than the 0b01 used for the 32-bit case.
(4) Remove some magic numbers in the DMA setup.

The DMA implementation for this chip supports full 64-bit addressing with
one exception. Whenever the Descriptor Ring Buffer is in high memory, a
fatal DMA error occurs. This problem was not present in 2.6.24-rc2 due
to code to "Bias the placement of kernel pages at lower PFNs". When
commit 44048d70 reverted that code, the DMA error appeared. As a "fix",
use the GFP_DMA flag when allocating the buffer for 64-bit DMA. At present,
this problem is thought to arise from a hardware error.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: John W. Linville <linville@tuxdriver.com>
Cc: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43/dma.c  |   30 ++++++++++++++++++++++--------
 drivers/net/wireless/b43/main.c |    3 ++-
 2 files changed, 24 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
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
 
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
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
