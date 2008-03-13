Return-Path: <linux-kernel-owner+w=401wt.eu-S1752078AbYCMEB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078AbYCMEB7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750749AbYCMEBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:01:51 -0400
Received: from relay1.sgi.com ([192.48.171.29]:42342 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750722AbYCMEBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:01:51 -0400
From: akepner@sgi.com
Date: Wed, 12 Mar 2008 21:00:22 -0700
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4 v4] dma: dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080313040022.GJ12370@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v3-v4 changes:

slight reorganization: split off one arch-independent patch, 
and moved both new include/linux/*.h files to the first patch 
in the series.

changed the name DMA_ATTR_SYNC_ON_WRITE to DMA_ATTR_BARRIER.

describe the semantics of DMA_ATTR_BARRIER in a very general, 
architecture-neutral way.

---
Introduce a new interface for passing architecture-specific
attributes when memory is mapped and unmapped for DMA. Give
the interface a default implementation which ignores
attributes. Also introduce the dma_{set|get}_attr() interface
for setting and retrieving individual attributes. Define one 
attribute DMA_ATTR_BARRIER in anticipation of its use by ia64/sn.

Signed-off-by: Arthur Kepner <akepner@sgi.com>
Acked-by:  Jesse Barnes <jesse.barnes@intel.com>

---

 dma-attrs.h   |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 dma-mapping.h |   35 +++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index e69de29..05b6e91 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -0,0 +1,55 @@
+#ifndef _DMA_ATTR_H
+#define _DMA_ATTR_H
+
+enum dma_attr {
+	DMA_ATTR_BARRIER,
+	DMA_ATTR_MAX,
+};
+
+struct dma_attrs {
+	unsigned flags;
+};
+
+#define __DMA_ATTRS_INIT() { .flags = 0, }
+
+#define DECLARE_DMA_ATTRS(x) struct dma_attrs x = __DMA_ATTRS_INIT()
+
+#define INIT_DMA_ATTRS(x) (x)->flags = 0;
+
+#ifdef ARCH_USES_DMA_ATTRS
+/*
+ * dma_set_attr - set a specific attribute
+ * may be called with a null attrs
+ */
+static inline int dma_set_attr(struct dma_attrs *attrs, enum dma_attr attr)
+{
+	if (!attrs)
+		return 0;
+	if (attr < DMA_ATTR_MAX) {
+		attrs->flags |= (1 << attr);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+/*
+ * dma_get_attr - check for a specific attribute
+ * may be called with a null attrs
+ */
+static inline int dma_get_attr(struct dma_attrs *attrs, enum dma_attr attr)
+{
+	if (!attrs)
+		return 0;
+	if (attr < DMA_ATTR_MAX) {
+		int ret = attrs->flags & (1 << attr);
+		return !!ret;
+	}
+	return -EINVAL;
+}
+#else /* !ARCH_USES_DMA_ATTRS */
+static inline int dma_set_attr(struct dma_attrs *attrs, enum dma_attr attr)
+{
+	return 0;
+}
+#endif /* ARCH_USES_DMA_ATTRS */
+#endif /* _DMA_ATTR_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 3320307..5a0e924 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -146,4 +146,39 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef ARCH_USES_DMA_ATTRS
+struct dma_attrs;
+
+static inline dma_addr_t dma_map_single_attrs(struct device *dev,
+					      void *cpu_addr, size_t size,
+					      enum dma_data_direction dir,
+					      struct dma_attrs *attrs)
+{
+	return dma_map_single(dev, cpu_addr, size, dir);
+}
+
+static inline void dma_unmap_single_attrs(struct device *dev,
+					  dma_addr_t dma_addr, size_t size,
+					  enum dma_data_direction dir,
+					  struct dma_attrs *attrs)
+{
+	return dma_unmap_single(dev, dma_addr, size, dir);
+}
+
+static inline int dma_map_sg_attrs(struct device *dev, struct scatterlist *sgl,
+				   int nents, enum dma_data_direction dir,
+				   struct dma_attrs *attrs)
+{
+	return dma_map_sg(dev, sgl, nents, dir);
+}
+
+static inline void dma_unmap_sg_attrs(struct device *dev,
+				      struct scatterlist *sgl, int nents,
+				      enum dma_data_direction dir,
+				      struct dma_attrs *attrs)
+{
+	return dma_unmap_sg(dev, sgl, nents, dir);
+}
+#endif /* ARCH_USES_DMA_ATTRS */
+
 #endif
