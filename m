Return-Path: <linux-kernel-owner+w=401wt.eu-S1763288AbXEPIld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763288AbXEPIld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762533AbXEPIe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:34:26 -0400
Received: from brick.kernel.dk ([80.160.20.94]:6618 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762401AbXEPIeJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:34:09 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 15/19] SPARC64: sg chaining support
Date: Wed, 16 May 2007 10:32:29 +0200
Message-Id: <1179304354606-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.2.rc1
In-Reply-To: <11793043533744-git-send-email-jens.axboe@oracle.com>
References: <11793043533744-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This updates the sparc64 iommu/pci dma mappers to sg chaining.

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/sparc64/kernel/pci_iommu.c   |   39 +++++++++++++++++++++-----------
 arch/sparc64/kernel/pci_sun4v.c   |   32 ++++++++++++++++-----------
 arch/sparc64/kernel/sbus.c        |   44 ++++++++++++++++++++++--------------
 include/asm-sparc64/scatterlist.h |    2 +
 4 files changed, 73 insertions(+), 44 deletions(-)

diff --git a/arch/sparc64/kernel/pci_iommu.c b/arch/sparc64/kernel/pci_iommu.c
index 70d2364..2118a4d 100644
--- a/arch/sparc64/kernel/pci_iommu.c
+++ b/arch/sparc64/kernel/pci_iommu.c
@@ -9,6 +9,7 @@
 #include <linux/mm.h>
 #include <linux/delay.h>
 #include <linux/pci.h>
+#include <linux/scatterlist.h>
 
 #include <asm/oplib.h>
 
@@ -470,7 +471,7 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 			   int nused, int nelems, unsigned long iopte_protection)
 {
 	struct scatterlist *dma_sg = sg;
-	struct scatterlist *sg_end = sg + nelems;
+	struct scatterlist *sg_end = sg_last(sg, nelems);
 	int i;
 
 	for (i = 0; i < nused; i++) {
@@ -505,7 +506,7 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 					len -= (IO_PAGE_SIZE - (tmp & (IO_PAGE_SIZE - 1UL)));
 					break;
 				}
-				sg++;
+				sg = sg_next(sg);
 			}
 
 			pteval = iopte_protection | (pteval & IOPTE_PAGE);
@@ -518,7 +519,7 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 			}
 
 			pteval = (pteval & IOPTE_PAGE) + len;
-			sg++;
+			sg = sg_next(sg);
 
 			/* Skip over any tail mappings we've fully mapped,
 			 * adjusting pteval along the way.  Stop when we
@@ -530,12 +531,12 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 			       ((pteval ^
 				 (SG_ENT_PHYS_ADDRESS(sg) + sg->length - 1UL)) >> IO_PAGE_SHIFT) == 0UL) {
 				pteval += sg->length;
-				sg++;
+				sg = sg_next(sg);
 			}
 			if ((pteval << (64 - IO_PAGE_SHIFT)) == 0UL)
 				pteval = ~0UL;
 		} while (dma_npages != 0);
-		dma_sg++;
+		dma_sg = sg_next(dma_sg);
 	}
 }
 
@@ -599,7 +600,7 @@ static int pci_4u_map_sg(struct pci_dev *pdev, struct scatterlist *sglist, int n
 	sgtmp = sglist;
 	while (used && sgtmp->dma_length) {
 		sgtmp->dma_address += dma_base;
-		sgtmp++;
+		sgtmp = sg_next(sgtmp);
 		used--;
 	}
 	used = nelems - used;
@@ -635,6 +636,7 @@ static void pci_4u_unmap_sg(struct pci_dev *pdev, struct scatterlist *sglist, in
 	struct strbuf *strbuf;
 	iopte_t *base;
 	unsigned long flags, ctx, i, npages;
+	struct scatterlist *sg, *sgprv;
 	u32 bus_addr;
 
 	if (unlikely(direction == PCI_DMA_NONE)) {
@@ -647,11 +649,15 @@ static void pci_4u_unmap_sg(struct pci_dev *pdev, struct scatterlist *sglist, in
 	
 	bus_addr = sglist->dma_address & IO_PAGE_MASK;
 
-	for (i = 1; i < nelems; i++)
-		if (sglist[i].dma_length == 0)
+	sgprv = NULL;
+	for_each_sg(sglist, sg, nelems, i) {
+		if (sg->dma_length == 0)
 			break;
-	i--;
-	npages = (IO_PAGE_ALIGN(sglist[i].dma_address + sglist[i].dma_length) -
+
+		sgprv = sg;
+	}
+
+	npages = (IO_PAGE_ALIGN(sgprv->dma_address + sgprv->dma_length) -
 		  bus_addr) >> IO_PAGE_SHIFT;
 
 	base = iommu->page_table +
@@ -730,6 +736,7 @@ static void pci_4u_dma_sync_sg_for_cpu(struct pci_dev *pdev, struct scatterlist
 	struct iommu *iommu;
 	struct strbuf *strbuf;
 	unsigned long flags, ctx, npages, i;
+	struct scatterlist *sg, *sgprv;
 	u32 bus_addr;
 
 	iommu = pdev->dev.archdata.iommu;
@@ -753,11 +760,15 @@ static void pci_4u_dma_sync_sg_for_cpu(struct pci_dev *pdev, struct scatterlist
 
 	/* Step 2: Kick data out of streaming buffers. */
 	bus_addr = sglist[0].dma_address & IO_PAGE_MASK;
-	for(i = 1; i < nelems; i++)
-		if (!sglist[i].dma_length)
+	sgprv = NULL;
+	for_each_sg(sglist, sg, nelems, i) {
+		if (sg->dma_length == 0)
 			break;
-	i--;
-	npages = (IO_PAGE_ALIGN(sglist[i].dma_address + sglist[i].dma_length)
+
+		sgprv = sg;
+	}
+
+	npages = (IO_PAGE_ALIGN(sgprv->dma_address + sgprv->dma_length)
 		  - bus_addr) >> IO_PAGE_SHIFT;
 	pci_strbuf_flush(strbuf, iommu, bus_addr, ctx, npages, direction);
 
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index 044e8ec..c385704 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -12,6 +12,7 @@
 #include <linux/percpu.h>
 #include <linux/irq.h>
 #include <linux/msi.h>
+#include <linux/scatterlist.h>
 
 #include <asm/iommu.h>
 #include <asm/irq.h>
@@ -364,7 +365,7 @@ static inline long fill_sg(long entry, struct pci_dev *pdev,
 			   int nused, int nelems, unsigned long prot)
 {
 	struct scatterlist *dma_sg = sg;
-	struct scatterlist *sg_end = sg + nelems;
+	struct scatterlist *sg_end = sg_last(sg, nelems);
 	unsigned long flags;
 	int i;
 
@@ -404,7 +405,7 @@ static inline long fill_sg(long entry, struct pci_dev *pdev,
 					len -= (IO_PAGE_SIZE - (tmp & (IO_PAGE_SIZE - 1UL)));
 					break;
 				}
-				sg++;
+				sg = sg_next(sg);
 			}
 
 			pteval = (pteval & IOPTE_PAGE);
@@ -422,24 +423,25 @@ static inline long fill_sg(long entry, struct pci_dev *pdev,
 			}
 
 			pteval = (pteval & IOPTE_PAGE) + len;
-			sg++;
+			sg = sg_next(sg);
 
 			/* Skip over any tail mappings we've fully mapped,
 			 * adjusting pteval along the way.  Stop when we
 			 * detect a page crossing event.
 			 */
-			while (sg < sg_end &&
-			       (pteval << (64 - IO_PAGE_SHIFT)) != 0UL &&
+			while ((pteval << (64 - IO_PAGE_SHIFT)) != 0UL &&
 			       (pteval == SG_ENT_PHYS_ADDRESS(sg)) &&
 			       ((pteval ^
 				 (SG_ENT_PHYS_ADDRESS(sg) + sg->length - 1UL)) >> IO_PAGE_SHIFT) == 0UL) {
 				pteval += sg->length;
-				sg++;
+				if (sg == sg_end)
+					break;
+				sg = sg_next(sg);
 			}
 			if ((pteval << (64 - IO_PAGE_SHIFT)) == 0UL)
 				pteval = ~0UL;
 		} while (dma_npages != 0);
-		dma_sg++;
+		dma_sg = sg_next(dma_sg);
 	}
 
 	if (unlikely(pci_iommu_batch_end() < 0L))
@@ -499,7 +501,7 @@ static int pci_4v_map_sg(struct pci_dev *pdev, struct scatterlist *sglist, int n
 	sgtmp = sglist;
 	while (used && sgtmp->dma_length) {
 		sgtmp->dma_address += dma_base;
-		sgtmp++;
+		sgtmp = sg_next(sgtmp);
 		used--;
 	}
 	used = nelems - used;
@@ -533,6 +535,7 @@ static void pci_4v_unmap_sg(struct pci_dev *pdev, struct scatterlist *sglist, in
 	struct pci_pbm_info *pbm;
 	struct iommu *iommu;
 	unsigned long flags, i, npages;
+	struct scatterlist *sg, *sgprv;
 	long entry;
 	u32 devhandle, bus_addr;
 
@@ -546,12 +549,15 @@ static void pci_4v_unmap_sg(struct pci_dev *pdev, struct scatterlist *sglist, in
 	devhandle = pbm->devhandle;
 	
 	bus_addr = sglist->dma_address & IO_PAGE_MASK;
-
-	for (i = 1; i < nelems; i++)
-		if (sglist[i].dma_length == 0)
+	sgprv = NULL;
+	for_each_sg(sglist, sg, nelems, i) {
+		if (sg->dma_length == 0)
 			break;
-	i--;
-	npages = (IO_PAGE_ALIGN(sglist[i].dma_address + sglist[i].dma_length) -
+
+		sgprv = sg;
+	}
+
+	npages = (IO_PAGE_ALIGN(sgprv->dma_address + sgprv->dma_length) -
 		  bus_addr) >> IO_PAGE_SHIFT;
 
 	entry = ((bus_addr - iommu->page_table_map_base) >> IO_PAGE_SHIFT);
diff --git a/arch/sparc64/kernel/sbus.c b/arch/sparc64/kernel/sbus.c
index 91f6e2a..125c0d7 100644
--- a/arch/sparc64/kernel/sbus.c
+++ b/arch/sparc64/kernel/sbus.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/interrupt.h>
+#include <linux/scatterlist.h>
 
 #include <asm/page.h>
 #include <asm/sbus.h>
@@ -348,7 +349,7 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 			   int nused, int nelems, unsigned long iopte_protection)
 {
 	struct scatterlist *dma_sg = sg;
-	struct scatterlist *sg_end = sg + nelems;
+	struct scatterlist *sg_end = sg_last(sg, nelems);
 	int i;
 
 	for (i = 0; i < nused; i++) {
@@ -383,7 +384,7 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 					len -= (IO_PAGE_SIZE - (tmp & (IO_PAGE_SIZE - 1UL)));
 					break;
 				}
-				sg++;
+				sg = sg_next(sg);
 			}
 
 			pteval = iopte_protection | (pteval & IOPTE_PAGE);
@@ -396,24 +397,25 @@ static inline void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 			}
 
 			pteval = (pteval & IOPTE_PAGE) + len;
-			sg++;
+			sg = sg_next(sg);
 
 			/* Skip over any tail mappings we've fully mapped,
 			 * adjusting pteval along the way.  Stop when we
 			 * detect a page crossing event.
 			 */
-			while (sg < sg_end &&
-			       (pteval << (64 - IO_PAGE_SHIFT)) != 0UL &&
+			while ((pteval << (64 - IO_PAGE_SHIFT)) != 0UL &&
 			       (pteval == SG_ENT_PHYS_ADDRESS(sg)) &&
 			       ((pteval ^
 				 (SG_ENT_PHYS_ADDRESS(sg) + sg->length - 1UL)) >> IO_PAGE_SHIFT) == 0UL) {
 				pteval += sg->length;
-				sg++;
+				if (sg == sg_end)
+					break;
+				sg = sg_next(sg);
 			}
 			if ((pteval << (64 - IO_PAGE_SHIFT)) == 0UL)
 				pteval = ~0UL;
 		} while (dma_npages != 0);
-		dma_sg++;
+		dma_sg = sg_next(dma_sg);
 	}
 }
 
@@ -461,7 +463,7 @@ int sbus_map_sg(struct sbus_dev *sdev, struct scatterlist *sglist, int nelems, i
 	sgtmp = sglist;
 	while (used && sgtmp->dma_length) {
 		sgtmp->dma_address += dma_base;
-		sgtmp++;
+		sgtmp = sg_next(sgtmp);
 		used--;
 	}
 	used = nelems - used;
@@ -486,6 +488,7 @@ void sbus_unmap_sg(struct sbus_dev *sdev, struct scatterlist *sglist, int nelems
 	struct strbuf *strbuf;
 	iopte_t *base;
 	unsigned long flags, i, npages;
+	struct scatterlist *sg, *sgprv;
 	u32 bus_addr;
 
 	if (unlikely(direction == SBUS_DMA_NONE))
@@ -496,12 +499,15 @@ void sbus_unmap_sg(struct sbus_dev *sdev, struct scatterlist *sglist, int nelems
 	strbuf = &info->strbuf;
 
 	bus_addr = sglist->dma_address & IO_PAGE_MASK;
-
-	for (i = 1; i < nelems; i++)
-		if (sglist[i].dma_length == 0)
+	sgprv = NULL;
+	for_each_sg(sglist, sg, nelems, i) {
+		if (sg->dma_length == 0)
 			break;
-	i--;
-	npages = (IO_PAGE_ALIGN(sglist[i].dma_address + sglist[i].dma_length) -
+
+		sgprv = sg;
+	}
+
+	npages = (IO_PAGE_ALIGN(sgprv->dma_address + sgprv->dma_length) -
 		  bus_addr) >> IO_PAGE_SHIFT;
 
 	base = iommu->page_table +
@@ -545,6 +551,7 @@ void sbus_dma_sync_sg_for_cpu(struct sbus_dev *sdev, struct scatterlist *sglist,
 	struct iommu *iommu;
 	struct strbuf *strbuf;
 	unsigned long flags, npages, i;
+	struct scatterlist *sg, *sgprv;
 	u32 bus_addr;
 
 	info = sdev->bus->iommu;
@@ -552,12 +559,15 @@ void sbus_dma_sync_sg_for_cpu(struct sbus_dev *sdev, struct scatterlist *sglist,
 	strbuf = &info->strbuf;
 
 	bus_addr = sglist[0].dma_address & IO_PAGE_MASK;
-	for (i = 0; i < nelems; i++) {
-		if (!sglist[i].dma_length)
+	sgprv = NULL;
+	for_each_sg(sglist, sg, nelems, i) {
+		if (sg->dma_length == 0)
 			break;
+
+		sgprv = sg;
 	}
-	i--;
-	npages = (IO_PAGE_ALIGN(sglist[i].dma_address + sglist[i].dma_length)
+
+	npages = (IO_PAGE_ALIGN(sgprv->dma_address + sgprv->dma_length)
 		  - bus_addr) >> IO_PAGE_SHIFT;
 
 	spin_lock_irqsave(&iommu->lock, flags);
diff --git a/include/asm-sparc64/scatterlist.h b/include/asm-sparc64/scatterlist.h
index 048fdb4..703c5bb 100644
--- a/include/asm-sparc64/scatterlist.h
+++ b/include/asm-sparc64/scatterlist.h
@@ -20,4 +20,6 @@ struct scatterlist {
 
 #define ISA_DMA_THRESHOLD	(~0UL)
 
+#define ARCH_HAS_SG_CHAIN
+
 #endif /* !(_SPARC64_SCATTERLIST_H) */
-- 
1.5.2.rc1

