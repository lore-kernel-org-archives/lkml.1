Return-Path: <linux-kernel-owner+w=401wt.eu-S1758276AbYCTBI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758276AbYCTBI4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 21:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754402AbYCTBIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 21:08:40 -0400
Received: from relay1.sgi.com ([192.48.171.29]:32772 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755330AbYCTBIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 21:08:38 -0400
From: akepner@sgi.com
Date: Wed, 19 Mar 2008 18:07:09 -0700
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>,
       Michael Ellerman <michael@ellerman.id.au>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v5] dma: add dma_*map*_attrs() interfaces
Message-ID: <20080320010709.GN1843@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v4-v5 changes:

- select HAVE_DMA_ATTRS via Kconfig
- changed the name DMA_ATTR_BARRIER to DMA_ATTR_WRITE_BARRIER
- changed struct dma_attrs to be a wrapper around a bitmap
- kernel-doc-ified some comments
- recombined the lib/swiotlb.c patch into the ia64-arch patch 
  (they need to go in together, or other forward decls are needed)

--- 

Introduce new interfaces, dma_*map*_attrs(), for passing 
architecture-specific attributes when memory is mapped and 
unmapped for DMA. Give the interfaces default implementations 
which ignore attributes. Also introduce the dma_{set|get}_attr() 
interfaces for setting and retrieving individual attributes. Define 
one attribute, DMA_ATTR_WRITE_BARRIER, in anticipation of its use 
by ia64/sn. Select whether architectures implement arch-specific 
versions of the dma_*map*_attrs() interfaces via HAVE_DMA_ATTRS in 
Kconfig.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 arch/Kconfig                |    3 +
 arch/ia64/Kconfig           |    1 
 include/linux/dma-attrs.h   |   74 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/dma-mapping.h |   35 ++++++++++++++++++++
 4 files changed, 113 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 694c9af..3ea332b 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -36,3 +36,6 @@ config HAVE_KPROBES
 
 config HAVE_KRETPROBES
 	def_bool n
+
+config HAVE_DMA_ATTRS
+	def_bool n
diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 8fa3faf..985b267 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -19,6 +19,7 @@ config IA64
 	select HAVE_OPROFILE
 	select HAVE_KPROBES
 	select HAVE_KRETPROBES
+	select HAVE_DMA_ATTRS
 	default y
 	help
 	  The Itanium Processor Family is Intel's 64-bit successor to
diff --git a/include/linux/dma-attrs.h b/include/linux/dma-attrs.h
index e69de29..5f151fb 100644
--- a/include/linux/dma-attrs.h
+++ b/include/linux/dma-attrs.h
@@ -0,0 +1,74 @@
+#ifndef _DMA_ATTR_H
+#define _DMA_ATTR_H
+
+#include <linux/bitmap.h>
+#include <linux/bitops.h>
+#include <linux/bug.h>
+
+/**
+ * an enum dma_attr represents an attribute associated with a DMA
+ * mapping. The semantics of each attribute should be defined in
+ * Documentation/DMA-attributes.txt.
+ */
+enum dma_attr {
+	DMA_ATTR_WRITE_BARRIER,
+	DMA_ATTR_MAX,
+};
+
+#define __DMA_ATTRS_LONGS BITS_TO_LONGS(DMA_ATTR_MAX)
+
+/**
+ * struct dma_attrs - an opaque container for DMA attributes
+ * @flags - bitmask representing a collection of enum dma_attr
+ */
+struct dma_attrs {
+	unsigned long flags[__DMA_ATTRS_LONGS];
+};
+
+#define DEFINE_DMA_ATTRS(x) 					\
+	struct dma_attrs x = {					\
+		.flags = { [0 ... __DMA_ATTRS_LONGS-1] = 0 },	\
+	}
+
+static inline void init_dma_attrs(struct dma_attrs *attrs)
+{
+	bitmap_zero(attrs->flags, __DMA_ATTRS_LONGS);
+}
+
+#ifdef CONFIG_HAVE_DMA_ATTRS
+/**
+ * dma_set_attr - set a specific attribute
+ * @attr: attribute to set
+ * @attrs: struct dma_attrs (may be NULL)
+ */
+void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+	if (attrs == NULL)
+		return;
+	BUG_ON(attr >= DMA_ATTR_MAX);
+	__set_bit(attr, attrs->flags);
+}
+
+/**
+ * dma_get_attr - check for a specific attribute
+ * @attr: attribute to set
+ * @attrs: struct dma_attrs (may be NULL)
+ */
+int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+	if (attrs == NULL)
+		return 0;
+	BUG_ON(attr >= DMA_ATTR_MAX);
+	return test_bit(attr, attrs->flags);
+}
+#else /* !CONFIG_HAVE_DMA_ATTRS */
+static inline void dma_set_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+}
+
+static inline int dma_get_attr(enum dma_attr attr, struct dma_attrs *attrs)
+{
+	return 0;
+}
+#endif /* CONFIG_HAVE_DMA_ATTRS */
+#endif /* _DMA_ATTR_H */
diff --git a/include/linux/dma-mapping.h b/include/linux/dma-mapping.h
index 3320307..f757d63 100644
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -146,4 +146,39 @@ static inline void dmam_release_declared_memory(struct device *dev)
 }
 #endif /* ARCH_HAS_DMA_DECLARE_COHERENT_MEMORY */
 
+#ifndef CONFIG_HAVE_DMA_ATTRS
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
+#endif /* CONFIG_HAVE_DMA_ATTRS */
+
 #endif
