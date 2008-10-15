Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbYJOPva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbYJOPva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 11:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYJOPu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 11:50:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46674 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594AbYJOPu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 11:50:58 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/7] FRV: Provide dma_map_page() for NOMMU and fix comments
To: torvalds@osdl.org
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 15 Oct 2008 16:50:53 +0100
Message-ID: <20081015155053.2158.38001.stgit@warthog.procyon.org.uk>
In-Reply-To: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
References: <20081015155048.2158.35981.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Provide dma_map_page() for the NOMMU-mode FRV arch.

Also do some fixing on the comments attached to the various DMA functions for
both MMU and NOMMU mode FRV code.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/mb93090-mb00/pci-dma-nommu.c |   23 ++++++++++++++++++++---
 arch/frv/mb93090-mb00/pci-dma.c       |   11 +++++++++--
 2 files changed, 29 insertions(+), 5 deletions(-)


diff --git a/arch/frv/mb93090-mb00/pci-dma-nommu.c b/arch/frv/mb93090-mb00/pci-dma-nommu.c
index 64ee58d..52ff9ae 100644
--- a/arch/frv/mb93090-mb00/pci-dma-nommu.c
+++ b/arch/frv/mb93090-mb00/pci-dma-nommu.c
@@ -111,7 +111,7 @@ EXPORT_SYMBOL(dma_free_coherent);
  * The 32-bit bus address to use is returned.
  *
  * Once the device is given the dma address, the device owns this memory
- * until either pci_unmap_single or pci_dma_sync_single is performed.
+ * until either dma_unmap_single or pci_dma_sync_single is performed.
  */
 dma_addr_t dma_map_single(struct device *dev, void *ptr, size_t size,
 			  enum dma_data_direction direction)
@@ -129,7 +129,7 @@ EXPORT_SYMBOL(dma_map_single);
 /*
  * Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
+ * above dma_map_single interface.  Here the scatter gather list
  * elements are each tagged with the appropriate dma address
  * and length.  They are obtained via sg_dma_{address,length}(SG).
  *
@@ -139,7 +139,7 @@ EXPORT_SYMBOL(dma_map_single);
  *       The routine returns the number of addr/length pairs actually
  *       used, at most nents.
  *
- * Device ownership issues as mentioned above for pci_map_single are
+ * Device ownership issues as mentioned above for dma_map_single are
  * the same here.
  */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
@@ -158,3 +158,20 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 }
 
 EXPORT_SYMBOL(dma_map_sg);
+
+/*
+ * Map a single page of the indicated size for DMA in streaming mode.
+ * The 32-bit bus address to use is returned.
+ *
+ * Device ownership issues as mentioned above for dma_map_single are
+ * the same here.
+ */
+dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
+			size_t size, enum dma_data_direction direction)
+{
+	BUG_ON(direction == DMA_NONE);
+	flush_dcache_page(page);
+	return (dma_addr_t) page_to_phys(page) + offset;
+}
+
+EXPORT_SYMBOL(dma_map_page);
diff --git a/arch/frv/mb93090-mb00/pci-dma.c b/arch/frv/mb93090-mb00/pci-dma.c
index 662f7b1..3ddedeb 100644
--- a/arch/frv/mb93090-mb00/pci-dma.c
+++ b/arch/frv/mb93090-mb00/pci-dma.c
@@ -61,7 +61,7 @@ EXPORT_SYMBOL(dma_map_single);
 /*
  * Map a set of buffers described by scatterlist in streaming
  * mode for DMA.  This is the scather-gather version of the
- * above pci_map_single interface.  Here the scatter gather list
+ * above dma_map_single interface.  Here the scatter gather list
  * elements are each tagged with the appropriate dma address
  * and length.  They are obtained via sg_dma_{address,length}(SG).
  *
@@ -71,7 +71,7 @@ EXPORT_SYMBOL(dma_map_single);
  *       The routine returns the number of addr/length pairs actually
  *       used, at most nents.
  *
- * Device ownership issues as mentioned above for pci_map_single are
+ * Device ownership issues as mentioned above for dma_map_single are
  * the same here.
  */
 int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
@@ -105,6 +105,13 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 
 EXPORT_SYMBOL(dma_map_sg);
 
+/*
+ * Map a single page of the indicated size for DMA in streaming mode.
+ * The 32-bit bus address to use is returned.
+ *
+ * Device ownership issues as mentioned above for dma_map_single are
+ * the same here.
+ */
 dma_addr_t dma_map_page(struct device *dev, struct page *page, unsigned long offset,
 			size_t size, enum dma_data_direction direction)
 {

