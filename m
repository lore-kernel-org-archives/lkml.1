Return-Path: <linux-kernel-owner+w=401wt.eu-S1758417AbYB1DZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758417AbYB1DZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 22:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753518AbYB1DZT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 22:25:19 -0500
Received: from relay2.sgi.com ([192.48.171.30]:45419 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753271AbYB1DZT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 22:25:19 -0500
From: akepner@sgi.com
Date: Wed, 27 Feb 2008 19:23:51 -0800
To: Tony Luck <tony.luck@intel.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jes Sorensen <jes@sgi.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Grant Grundler <grundler@parisc-linux.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 v3] dma: dma_{un}map_{single|sg}_attrs() interface
Message-ID: <20080228032351.GR11012@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2->v3 changes:
mainly cosmetic changes to make checkpatch a little happier - 
trailing whitespace, long lines.... Also made dma_set_attr() a 
no-op inline func when ARCH_USES_DMA_ATTRS is not defined instead 
of a macro.

I'd like to get this one queued up for 2.6.26.

--- 

Introduce a new interface for passing architecture-specific
attributes when memory is mapped and unmapped for DMA. Give
the interface a default implementation which ignores
attributes.

Signed-off-by: Arthur Kepner <akepner@sgi.com>

---

 dma-mapping.h |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+)


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
