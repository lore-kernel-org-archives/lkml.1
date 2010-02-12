Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090Ab0BLJfn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 04:35:43 -0500
Received: from sh.osrg.net ([192.16.179.4]:35886 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab0BLJff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 04:35:35 -0500
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       James Bottomley <James.Bottomley@suse.de>,
       "David S. Miller" <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Russell King <linux@arm.linux.org.uk>
Subject: [PATCH -mm 4/7] dma-mapping.h: add dma_set_coherent_mask
Date: Fri, 12 Feb 2010 18:33:29 +0900
Message-Id: <1265967212-9126-5-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
References: <1265967212-9126-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Fri, 12 Feb 2010 18:35:21 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma_set_coherent_mask corresponds to pci_set_consistent_dma_mask. This
is necessary to move to the generic device model DMA API from the PCI
bus specific API in the long term.

dma_set_coherent_mask works in the exact same way that
pci_set_consistent_dma_mask does. So this patch also changes
pci_set_consistent_dma_mask to call dma_set_coherent_mask.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: James Bottomley <James.Bottomley@suse.de>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Russell King <linux@arm.linux.org.uk>
---
 Documentation/DMA-API.txt   |   10 ++++++++++
 drivers/pci/pci.c           |    7 +++----
 include/linux/dma-mapping.h |    8 ++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/Documentation/DMA-API.txt b/Documentation/DMA-API.txt
index bd34a62..d7d9eef 100644
--- a/Documentation/DMA-API.txt
+++ b/Documentation/DMA-API.txt
@@ -167,6 +167,16 @@ parameters if it is.
 
 Returns: 0 if successful and a negative error if not.
 
+int
+dma_set_coherent_mask(struct device *dev, u64 mask)
+int
+pci_set_consistent_dma_mask(struct pci_device *dev, u64 mask)
+
+Checks to see if the mask is possible and updates the device
+parameters if it is.
+
+Returns: 0 if successful and a negative error if not.
+
 u64
 dma_get_required_mask(struct device *dev)
 
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 5c881e9..aacb86f 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2131,12 +2131,11 @@ pci_set_dma_mask(struct pci_dev *dev, u64 mask)
 int
 pci_set_consistent_dma_mask(struct pci_dev *dev, u64 mask)
 {
-	if (!pci_dma_supported(dev, mask))
-		return -EIO;
+	int ret = dma_set_coherent_mask(&dev->dev, mask);
+	if (ret)
+		return ret;
 
-	dev->dev.coherent_dma_mask = mask;
 	dev_dbg(&dev->dev, "using %dbit consistent DMA mask\n", fls64(mask));
-
 	return 0;
 }
 #endif
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 86e7dc3..599d8e4 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -127,6 +127,14 @@ static inline u64 dma_get_mask(struct device *dev)
 	return DMA_BIT_MASK(32);
 }
 
+static inline int dma_set_coherent_mask(struct device *dev, u64 mask)
+{
+	if (!dma_supported(dev, mask))
+		return -EIO;
+	dev->coherent_dma_mask = mask;
+	return 0;
+}
+
 extern u64 dma_get_required_mask(struct device *dev);
 
 static inline unsigned int dma_get_max_seg_size(struct device *dev)
-- 
1.5.6.5

