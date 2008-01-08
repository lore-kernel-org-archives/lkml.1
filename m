Return-Path: <linux-kernel-owner+w=401wt.eu-S1756277AbYAHChf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277AbYAHChf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 21:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753223AbYAHCh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 21:37:27 -0500
Received: from relay1.sgi.com ([192.48.171.29]:53524 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752602AbYAHCh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 21:37:26 -0500
From: akepner@sgi.com
Date: Mon, 7 Jan 2008 18:35:59 -0800
To: Tony Luck <tony.luck@intel.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@steeleye.com>,
       David Miller <davem@davemloft.net>, Muli Ben-Yehuda <muli@il.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [RFC/PARTIAL PATCH 1/3] dma: create linux/dma-direction.h
Message-ID: <20080108023559.GQ23661@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Place the definition of enum dma_data_direction in its own 
include file, and add the definition of enum dma_data_attr 
and some simple routines for manipulating the direction and 
attributes.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

-- 

 dma-direction.h |   53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 dma-mapping.h   |   17 +----------------
 2 files changed, 54 insertions(+), 16 deletions(-)

diff --git a/include/linux/dma-direction.h b/include/linux/dma-direction.h
index e69de29..4c67446 100644
--- a/include/linux/dma-direction.h
+++ b/include/linux/dma-direction.h
@@ -0,0 +1,53 @@
+#ifndef _LINUX_DMA_DIRECTION_H
+#define _LINUX_DMA_DIRECTION_H
+
+/* These definitions mirror those in pci.h, so they can be used
+ * interchangeably with their PCI_ counterparts */
+enum dma_data_direction {
+	DMA_BIDIRECTIONAL = 0,
+	DMA_TO_DEVICE = 1,
+	DMA_FROM_DEVICE = 2,
+	DMA_NONE = 3,
+};
+
+enum dma_data_attr {
+	DMA_ATTR_BARRIER = (1 << 0),
+	DMA_ATTR_FOO = (1 << 1),
+	DMA_ATTR_GOO = (1 << 2),
+	DMA_ATTR_MAX = (1 << 3),
+};
+
+#define DMA_FLAGS_ATTR_SHIFT	8
+#define DMA_FLAGS_DIR_MASK	((1 << DMA_FLAGS_ATTR_SHIFT) - 1)
+#define DMA_FLAGS_ATTR_MASK	~DMA_FLAGS_DIR_MASK
+
+static inline enum dma_data_direction dma_flags_get_dir(u32 fin)
+{
+	return (fin & DMA_FLAGS_DIR_MASK);
+}
+
+/* return a u32 (not a enum dma_data_attr) since more than one 
+ * attribute may be set */
+static inline u32 dma_flags_get_attr(u32 fin)
+{
+	return ((fin & DMA_FLAGS_ATTR_MASK) >> DMA_FLAGS_ATTR_SHIFT);
+}
+
+static inline u32 dma_flags_set_dir_attr(enum dma_data_direction dir, u32 attr)
+{
+	return (attr << DMA_FLAGS_ATTR_SHIFT) | (dir & DMA_FLAGS_DIR_MASK);
+}
+
+static inline int valid_dma_direction(enum dma_data_direction dir)
+{
+	return ((dir == DMA_BIDIRECTIONAL) ||
+		(dir == DMA_TO_DEVICE) ||
+		(dir == DMA_FROM_DEVICE));
+}
+
+static inline int valid_dma_attr(u32 attr)
+{
+	return(attr < DMA_ATTR_MAX);
+}
+
+#endif  /*_LINUX_DMA_DIRECTION_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 101a2d4..be5825e 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -3,15 +3,7 @@
 
 #include <linux/device.h>
 #include <linux/err.h>
-
-/* These definitions mirror those in pci.h, so they can be used
- * interchangeably with their PCI_ counterparts */
-enum dma_data_direction {
-	DMA_BIDIRECTIONAL = 0,
-	DMA_TO_DEVICE = 1,
-	DMA_FROM_DEVICE = 2,
-	DMA_NONE = 3,
-};
+#include <linux/dma-direction.h>
 
 #define DMA_BIT_MASK(n)	(((n) == 64) ? ~0ULL : ((1ULL<<(n))-1))
 
@@ -36,13 +28,6 @@ enum dma_data_direction {
 
 #define DMA_MASK_NONE	0x0ULL
 
-static inline int valid_dma_direction(int dma_direction)
-{
-	return ((dma_direction == DMA_BIDIRECTIONAL) ||
-		(dma_direction == DMA_TO_DEVICE) ||
-		(dma_direction == DMA_FROM_DEVICE));
-}
-
 static inline int is_device_dma_capable(struct device *dev)
 {
 	return dev->dma_mask != NULL && *dev->dma_mask != DMA_MASK_NONE;



-- 
Arthur

