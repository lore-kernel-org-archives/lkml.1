Return-Path: <linux-kernel-owner+w=401wt.eu-S1763439AbYDRVIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763439AbYDRVIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 17:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757918AbYDRUxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 16:53:15 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:7407 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761106AbYDRUwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 16:52:14 -0400
Message-Id: <20080418205052.337337918@ldl.fc.hp.com>
References: <20080418204955.342963315@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Apr 2008 14:50:20 -0600
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Adam Belay <ambx1@neo.rr.com>
Cc: Li Shaohua <shaohua.li@intel.com>
Cc: Matthieu Castet <castet.matthieu@free.fr>
Cc: Thomas Renninger <trenn@suse.de>
Cc: Rene Herman <rene.herman@keyaccess.nl>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 25/53] PNP: convert resource accessors to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-accessors-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

---
 include/linux/pnp.h |  148 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 108 insertions(+), 40 deletions(-)

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-04-02 11:08:02.000000000 -0600
+++ work7/include/linux/pnp.h	2008-04-02 13:02:29.000000000 -0600
@@ -27,46 +27,114 @@
  */
 struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
 
-/* Use these instead of directly reading pnp_dev to get resource information */
-#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
-#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
-#define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)].flags)
-#define pnp_port_valid(dev,bar) \
-	((pnp_port_flags((dev),(bar)) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
-		== IORESOURCE_IO)
-#define pnp_port_len(dev,bar) \
-	((pnp_port_start((dev),(bar)) == 0 &&	\
-	  pnp_port_end((dev),(bar)) ==		\
-	  pnp_port_start((dev),(bar))) ? 0 :	\
-	  					\
-	 (pnp_port_end((dev),(bar)) -		\
-	  pnp_port_start((dev),(bar)) + 1))
-
-#define pnp_mem_start(dev,bar)   ((dev)->res.mem_resource[(bar)].start)
-#define pnp_mem_end(dev,bar)     ((dev)->res.mem_resource[(bar)].end)
-#define pnp_mem_flags(dev,bar)   ((dev)->res.mem_resource[(bar)].flags)
-#define pnp_mem_valid(dev,bar) \
-	((pnp_mem_flags((dev),(bar)) & (IORESOURCE_MEM | IORESOURCE_UNSET)) \
-		== IORESOURCE_MEM)
-#define pnp_mem_len(dev,bar) \
-	((pnp_mem_start((dev),(bar)) == 0 &&	\
-	  pnp_mem_end((dev),(bar)) ==		\
-	  pnp_mem_start((dev),(bar))) ? 0 :	\
-	  					\
-	 (pnp_mem_end((dev),(bar)) -		\
-	  pnp_mem_start((dev),(bar)) + 1))
-
-#define pnp_irq(dev,bar)	 ((dev)->res.irq_resource[(bar)].start)
-#define pnp_irq_flags(dev,bar)	 ((dev)->res.irq_resource[(bar)].flags)
-#define pnp_irq_valid(dev,bar) \
-	((pnp_irq_flags((dev),(bar)) & (IORESOURCE_IRQ | IORESOURCE_UNSET)) \
-		== IORESOURCE_IRQ)
-
-#define pnp_dma(dev,bar)	 ((dev)->res.dma_resource[(bar)].start)
-#define pnp_dma_flags(dev,bar)	 ((dev)->res.dma_resource[(bar)].flags)
-#define pnp_dma_valid(dev,bar) \
-	((pnp_dma_flags((dev),(bar)) & (IORESOURCE_DMA | IORESOURCE_UNSET)) \
-		== IORESOURCE_DMA)
+static inline int pnp_resource_valid(struct resource *res)
+{
+	if (res && !(res->flags & IORESOURCE_UNSET))
+		return 1;
+	return 0;
+}
+
+static inline resource_size_t pnp_resource_len(struct resource *res)
+{
+	if (res->start == 0 && res->end == 0)
+		return 0;
+	return res->end - res->start + 1;
+}
+
+
+static inline resource_size_t pnp_port_start(struct pnp_dev *dev,
+					     unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_IO, bar)->start;
+}
+
+static inline resource_size_t pnp_port_end(struct pnp_dev *dev,
+					   unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_IO, bar)->end;
+}
+
+static inline resource_size_t pnp_port_flags(struct pnp_dev *dev,
+					     unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_IO, bar)->flags;
+}
+
+static inline int pnp_port_valid(struct pnp_dev *dev, unsigned int bar)
+{
+	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_IO, bar));
+}
+
+static inline resource_size_t pnp_port_len(struct pnp_dev *dev,
+					   unsigned int bar)
+{
+	return pnp_resource_len(pnp_get_resource(dev, IORESOURCE_IO, bar));
+}
+
+
+static inline resource_size_t pnp_mem_start(struct pnp_dev *dev,
+					    unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_MEM, bar)->start;
+}
+
+static inline resource_size_t pnp_mem_end(struct pnp_dev *dev,
+					  unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_MEM, bar)->end;
+}
+
+static inline resource_size_t pnp_mem_flags(struct pnp_dev *dev,
+					    unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_MEM, bar)->flags;
+}
+
+static inline int pnp_mem_valid(struct pnp_dev *dev, unsigned int bar)
+{
+	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_MEM, bar));
+}
+
+static inline resource_size_t pnp_mem_len(struct pnp_dev *dev,
+					  unsigned int bar)
+{
+	return pnp_resource_len(pnp_get_resource(dev, IORESOURCE_MEM, bar));
+}
+
+
+static inline resource_size_t pnp_irq(struct pnp_dev *dev, unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_IRQ, bar)->start;
+}
+
+static inline resource_size_t pnp_irq_flags(struct pnp_dev *dev,
+					    unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_IRQ, bar)->flags;
+}
+
+static inline int pnp_irq_valid(struct pnp_dev *dev, unsigned int bar)
+{
+	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_IRQ, bar));
+}
+
+
+static inline resource_size_t pnp_dma(struct pnp_dev *dev, unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_DMA, bar)->start;
+}
+
+static inline resource_size_t pnp_dma_flags(struct pnp_dev *dev,
+					    unsigned int bar)
+{
+	return pnp_get_resource(dev, IORESOURCE_DMA, bar)->flags;
+}
+
+static inline int pnp_dma_valid(struct pnp_dev *dev, unsigned int bar)
+{
+	return pnp_resource_valid(pnp_get_resource(dev, IORESOURCE_DMA, bar));
+}
+
 
 #define PNP_PORT_FLAG_16BITADDR	(1<<0)
 #define PNP_PORT_FLAG_FIXED	(1<<1)

-- 
