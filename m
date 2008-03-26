Return-Path: <linux-kernel-owner+w=401wt.eu-S1761520AbYCZRTM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761520AbYCZRTM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 13:19:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761384AbYCZRJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 13:09:35 -0400
Received: from g4t0014.houston.hp.com ([15.201.24.17]:27510 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761180AbYCZRJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 13:09:15 -0400
Message-Id: <20080326171229.368625597@ldl.fc.hp.com>
References: <20080326171058.099442579@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 26 Mar 2008 11:11:28 -0600
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
Subject: [patch 30/37] PNP: convert resource accessors to use pnp_get_resource(), not pnp_resource_table
Content-Disposition: inline; filename=pnp-convert-accessors-to-pnp_get_resource
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes more direct references to pnp_resource_table.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work7/include/linux/pnp.h
===================================================================
--- work7.orig/include/linux/pnp.h	2008-03-24 15:19:46.000000000 -0600
+++ work7/include/linux/pnp.h	2008-03-24 15:19:47.000000000 -0600
@@ -28,12 +28,24 @@
 struct resource *pnp_get_resource(struct pnp_dev *, unsigned int, unsigned int);
 
 /* Use these instead of directly reading pnp_dev to get resource information */
-#define pnp_port_start(dev,bar)   ((dev)->res.port_resource[(bar)].start)
-#define pnp_port_end(dev,bar)     ((dev)->res.port_resource[(bar)].end)
-#define pnp_port_flags(dev,bar)   ((dev)->res.port_resource[(bar)].flags)
-#define pnp_port_valid(dev,bar) \
-	((pnp_port_flags((dev),(bar)) & (IORESOURCE_IO | IORESOURCE_UNSET)) \
-		== IORESOURCE_IO)
+
+#define pnp_port_start(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_IO, bar)->start
+#define pnp_port_end(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_IO, bar)->end
+#define pnp_port_flags(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_IO, bar)->flags
+
+static inline resource_size_t pnp_port_valid(struct pnp_dev *dev,
+					     unsigned int bar)
+{
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IO, bar);
+
+	if (res && !(res->flags & IORESOURCE_UNSET))
+		return 1;
+	return 0;
+}
+
 #define pnp_port_len(dev,bar) \
 	((pnp_port_start((dev),(bar)) == 0 &&	\
 	  pnp_port_end((dev),(bar)) ==		\
@@ -42,12 +54,23 @@
 	 (pnp_port_end((dev),(bar)) -		\
 	  pnp_port_start((dev),(bar)) + 1))
 
-#define pnp_mem_start(dev,bar)   ((dev)->res.mem_resource[(bar)].start)
-#define pnp_mem_end(dev,bar)     ((dev)->res.mem_resource[(bar)].end)
-#define pnp_mem_flags(dev,bar)   ((dev)->res.mem_resource[(bar)].flags)
-#define pnp_mem_valid(dev,bar) \
-	((pnp_mem_flags((dev),(bar)) & (IORESOURCE_MEM | IORESOURCE_UNSET)) \
-		== IORESOURCE_MEM)
+#define pnp_mem_start(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_MEM, bar)->start
+#define pnp_mem_end(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_MEM, bar)->end
+#define pnp_mem_flags(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_MEM, bar)->flags
+
+static inline resource_size_t pnp_mem_valid(struct pnp_dev *dev,
+					    unsigned int bar)
+{
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_MEM, bar);
+
+	if (res && !(res->flags & IORESOURCE_UNSET))
+		return 1;
+	return 0;
+}
+
 #define pnp_mem_len(dev,bar) \
 	((pnp_mem_start((dev),(bar)) == 0 &&	\
 	  pnp_mem_end((dev),(bar)) ==		\
@@ -56,17 +79,35 @@
 	 (pnp_mem_end((dev),(bar)) -		\
 	  pnp_mem_start((dev),(bar)) + 1))
 
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
+#define pnp_irq(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_IRQ, bar)->start
+#define pnp_irq_flags(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_IRQ, bar)->flags
+
+static inline resource_size_t pnp_irq_valid(struct pnp_dev *dev,
+					    unsigned int bar)
+{
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_IRQ, bar);
+
+	if (res && !(res->flags & IORESOURCE_UNSET))
+		return 1;
+	return 0;
+}
+
+#define pnp_dma(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_DMA, bar)->start
+#define pnp_dma_flags(dev,bar)	\
+	pnp_get_resource(dev, IORESOURCE_DMA, bar)->flags
+
+static inline resource_size_t pnp_dma_valid(struct pnp_dev *dev,
+					    unsigned int bar)
+{
+	struct resource *res = pnp_get_resource(dev, IORESOURCE_DMA, bar);
+
+	if (res && !(res->flags & IORESOURCE_UNSET))
+		return 1;
+	return 0;
+}
 
 #define PNP_PORT_FLAG_16BITADDR	(1<<0)
 #define PNP_PORT_FLAG_FIXED	(1<<1)

-- 
