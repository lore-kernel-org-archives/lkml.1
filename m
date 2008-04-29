Return-Path: <linux-kernel-owner+w=401wt.eu-S1764019AbYD2Ram@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764019AbYD2Ram (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759217AbYD2RVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 13:21:42 -0400
Received: from ns2.suse.de ([195.135.220.15]:43375 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759194AbYD2RVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 13:21:39 -0400
Date: Tue, 29 Apr 2008 10:18:55 -0700
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
       "John W. Linville" <linville@tuxdriver.com>
Subject: [25/37] b43: Workaround DMA quirks
Message-ID: <20080429171855.GZ14724@suse.de>
References: <20080429171222.073929148@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="b43-workaround-dma-quirks.patch"
In-Reply-To: <20080429171730.GA14724@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Michael Buesch <mb@bu3sch.de>

commit 1033b3ea11820ea1fb1b877207bd6724e9aaedc3 upstream

Some mainboards/CPUs don't allow DMA masks bigger than a certain limit.
Some VIA crap^h^h^h^hdevices have an upper limit of 0xFFFFFFFF. So in this
case a 64-bit b43 device would always fail to acquire the mask.
Implement a workaround to fallback to lower DMA mask, as we can always
also support a lower mask.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Signed-off-by: John W. Linville <linville@tuxdriver.com>


---
 drivers/net/wireless/b43/dma.c |   73 +++++++++++++++++++++++++++++------------
 1 file changed, 52 insertions(+), 21 deletions(-)

--- a/drivers/net/wireless/b43/dma.c
+++ b/drivers/net/wireless/b43/dma.c
@@ -822,6 +822,18 @@ static u64 supported_dma_mask(struct b43
 	return DMA_30BIT_MASK;
 }
 
+static enum b43_dmatype dma_mask_to_engine_type(u64 dmamask)
+{
+	if (dmamask == DMA_30BIT_MASK)
+		return B43_DMA_30BIT;
+	if (dmamask == DMA_32BIT_MASK)
+		return B43_DMA_32BIT;
+	if (dmamask == DMA_64BIT_MASK)
+		return B43_DMA_64BIT;
+	B43_WARN_ON(1);
+	return B43_DMA_30BIT;
+}
+
 /* Main initialization function. */
 static
 struct b43_dmaring *b43_setup_dmaring(struct b43_wldev *dev,
@@ -982,6 +994,42 @@ void b43_dma_free(struct b43_wldev *dev)
 	dma->tx_ring0 = NULL;
 }
 
+static int b43_dma_set_mask(struct b43_wldev *dev, u64 mask)
+{
+	u64 orig_mask = mask;
+	bool fallback = 0;
+	int err;
+
+	/* Try to set the DMA mask. If it fails, try falling back to a
+	 * lower mask, as we can always also support a lower one. */
+	while (1) {
+		err = ssb_dma_set_mask(dev->dev, mask);
+		if (!err)
+			break;
+		if (mask == DMA_64BIT_MASK) {
+			mask = DMA_32BIT_MASK;
+			fallback = 1;
+			continue;
+		}
+		if (mask == DMA_32BIT_MASK) {
+			mask = DMA_30BIT_MASK;
+			fallback = 1;
+			continue;
+		}
+		b43err(dev->wl, "The machine/kernel does not support "
+		       "the required %u-bit DMA mask\n",
+		       (unsigned int)dma_mask_to_engine_type(orig_mask));
+		return -EOPNOTSUPP;
+	}
+	if (fallback) {
+		b43info(dev->wl, "DMA mask fallback from %u-bit to %u-bit\n",
+			(unsigned int)dma_mask_to_engine_type(orig_mask),
+			(unsigned int)dma_mask_to_engine_type(mask));
+	}
+
+	return 0;
+}
+
 int b43_dma_init(struct b43_wldev *dev)
 {
 	struct b43_dma *dma = &dev->dma;
@@ -991,27 +1039,10 @@ int b43_dma_init(struct b43_wldev *dev)
 	enum b43_dmatype type;
 
 	dmamask = supported_dma_mask(dev);
-	switch (dmamask) {
-	default:
-		B43_WARN_ON(1);
-	case DMA_30BIT_MASK:
-		type = B43_DMA_30BIT;
-		break;
-	case DMA_32BIT_MASK:
-		type = B43_DMA_32BIT;
-		break;
-	case DMA_64BIT_MASK:
-		type = B43_DMA_64BIT;
-		break;
-	}
-	err = ssb_dma_set_mask(dev->dev, dmamask);
-	if (err) {
-		b43err(dev->wl, "The machine/kernel does not support "
-		       "the required DMA mask (0x%08X%08X)\n",
-		       (unsigned int)((dmamask & 0xFFFFFFFF00000000ULL) >> 32),
-		       (unsigned int)(dmamask & 0x00000000FFFFFFFFULL));
-		return -EOPNOTSUPP;
-	}
+	type = dma_mask_to_engine_type(dmamask);
+	err = b43_dma_set_mask(dev, dmamask);
+	if (err)
+		return err;
 
 	err = -ENOMEM;
 	/* setup TX DMA channels. */

-- 
