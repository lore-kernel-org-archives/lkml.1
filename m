Return-Path: <linux-kernel-owner+w=401wt.eu-S1755102AbXJVSP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102AbXJVSP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbXJVSMd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:12:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:22194 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbXJVSM0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:12:26 -0400
From: Jens Axboe <jens.axboe@oracle.com>
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Cc: Jens Axboe <jens.axboe@oracle.com>
Subject: [PATCH 08/10] [SG] Update arch/ to use sg helpers
Date: Mon, 22 Oct 2007 20:11:02 +0200
Message-Id: <1193076664-13652-9-git-send-email-jens.axboe@oracle.com>
X-Mailer: git-send-email 1.5.3.GIT
In-Reply-To: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
References: <1193076664-13652-1-git-send-email-jens.axboe@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jens Axboe <jens.axboe@oracle.com>
---
 arch/alpha/kernel/pci_iommu.c           |    2 +-
 arch/arm/common/dmabounce.c             |    2 +-
 arch/blackfin/kernel/dma-mapping.c      |    3 +--
 arch/ia64/hp/common/sba_iommu.c         |    2 +-
 arch/ia64/hp/sim/simscsi.c              |    4 ++--
 arch/ia64/sn/pci/pci_dma.c              |    2 +-
 arch/m68k/kernel/dma.c                  |    2 +-
 arch/mips/mm/dma-default.c              |   16 +++++++---------
 arch/powerpc/kernel/dma_64.c            |    3 +--
 arch/powerpc/kernel/ibmebus.c           |    3 +--
 arch/powerpc/kernel/iommu.c             |    2 +-
 arch/powerpc/platforms/ps3/system-bus.c |    5 ++---
 arch/sparc/kernel/ioport.c              |   17 ++++++++---------
 arch/sparc/mm/io-unit.c                 |    2 +-
 arch/sparc/mm/iommu.c                   |    8 ++++----
 arch/sparc/mm/sun4c.c                   |    2 +-
 arch/sparc64/kernel/iommu.c             |    7 ++-----
 arch/sparc64/kernel/iommu_common.c      |   13 ++++++-------
 arch/sparc64/kernel/ldc.c               |    2 +-
 arch/sparc64/kernel/pci_sun4v.c         |    7 ++-----
 arch/x86/kernel/pci-calgary_64.c        |   10 ++++++----
 arch/x86/kernel/pci-gart_64.c           |    4 ++--
 arch/x86/kernel/pci-nommu_64.c          |    4 ++--
 23 files changed, 55 insertions(+), 67 deletions(-)

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index e1c4707..ee07dce 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -465,7 +465,7 @@ EXPORT_SYMBOL(pci_free_consistent);
    Write dma_length of each leader with the combined lengths of
    the mergable followers.  */
 
-#define SG_ENT_VIRT_ADDRESS(SG) (page_address((SG)->page) + (SG)->offset)
+#define SG_ENT_VIRT_ADDRESS(SG) (sg_virt((SG)))
 #define SG_ENT_PHYS_ADDRESS(SG) __pa(SG_ENT_VIRT_ADDRESS(SG))
 
 static void
diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 44ab0da..9d371e4 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -442,7 +442,7 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	BUG_ON(dir == DMA_NONE);
 
 	for (i = 0; i < nents; i++, sg++) {
-		struct page *page = sg->page;
+		struct page *page = sg_page(sg);
 		unsigned int offset = sg->offset;
 		unsigned int length = sg->length;
 		void *ptr = page_address(page) + offset;
diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
index 94d7b11..a16cb03 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -160,8 +160,7 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for (i = 0; i < nents; i++, sg++) {
-		sg->dma_address = (dma_addr_t)(page_address(sg->page) +
-					sg->offset);
+		sg->dma_address = (dma_addr_t) sg_virt(sg);
 
 		invalidate_dcache_range(sg_dma_address(sg),
 					sg_dma_address(sg) +
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 3c95f41..bc859a3 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -246,7 +246,7 @@ static int reserve_sba_gart = 1;
 static SBA_INLINE void sba_mark_invalid(struct ioc *, dma_addr_t, size_t);
 static SBA_INLINE void sba_free_range(struct ioc *, dma_addr_t, size_t);
 
-#define sba_sg_address(sg)	(page_address((sg)->page) + (sg)->offset)
+#define sba_sg_address(sg)	sg_virt((sg))
 
 #ifdef FULL_VALID_PDIR
 static u64 prefetch_spill_page;
diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index a3a558a..6ef9b52 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -131,7 +131,7 @@ simscsi_sg_readwrite (struct scsi_cmnd *sc, int mode, unsigned long offset)
 	stat.fd = desc[sc->device->id];
 
 	scsi_for_each_sg(sc, sl, scsi_sg_count(sc), i) {
-		req.addr = __pa(page_address(sl->page) + sl->offset);
+		req.addr = __pa(sg_virt(sl));
 		req.len  = sl->length;
 		if (DBG)
 			printk("simscsi_sg_%s @ %lx (off %lx) use_sg=%d len=%d\n",
@@ -212,7 +212,7 @@ static void simscsi_fillresult(struct scsi_cmnd *sc, char *buf, unsigned len)
 		if (!len)
 			break;
 		thislen = min(len, slp->length);
-		memcpy(page_address(slp->page) + slp->offset, buf, thislen);
+		memcpy(sg_virt(slp), buf, thislen);
 		len -= thislen;
 	}
 }
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index ecd8a52..511db2f 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -16,7 +16,7 @@
 #include <asm/sn/pcidev.h>
 #include <asm/sn/sn_sal.h>
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
+#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 #define SG_ENT_PHYS_ADDRESS(SG)	virt_to_phys(SG_ENT_VIRT_ADDRESS(SG))
 
 /**
diff --git a/arch/m68k/kernel/dma.c b/arch/m68k/kernel/dma.c
index 9d4e4b5..ef490e1 100644
--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -121,7 +121,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i;
 
 	for (i = 0; i < nents; sg++, i++) {
-		sg->dma_address = page_to_phys(sg->page) + sg->offset;
+		sg->dma_address = sg_phys(sg);
 		dma_sync_single_for_device(dev, sg->dma_address, sg->length, dir);
 	}
 	return nents;
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 98b5e5b..b0b034c 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -165,12 +165,11 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	for (i = 0; i < nents; i++, sg++) {
 		unsigned long addr;
 
-		addr = (unsigned long) page_address(sg->page);
+		addr = (unsigned long) sg_virt(sg);
 		if (!plat_device_is_coherent(dev) && addr)
-			__dma_sync(addr + sg->offset, sg->length, direction);
+			__dma_sync(addr, sg->length, direction);
 		sg->dma_address = plat_map_dma_mem(dev,
-				                   (void *)(addr + sg->offset),
-						   sg->length);
+				                   (void *)addr, sg->length);
 	}
 
 	return nents;
@@ -223,10 +222,9 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	for (i = 0; i < nhwentries; i++, sg++) {
 		if (!plat_device_is_coherent(dev) &&
 		    direction != DMA_TO_DEVICE) {
-			addr = (unsigned long) page_address(sg->page);
+			addr = (unsigned long) sg_virt(sg);
 			if (addr)
-				__dma_sync(addr + sg->offset, sg->length,
-				           direction);
+				__dma_sync(addr, sg->length, direction);
 		}
 		plat_unmap_dma_mem(sg->dma_address);
 	}
@@ -304,7 +302,7 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (cpu_is_noncoherent_r10000(dev))
-			__dma_sync((unsigned long)page_address(sg->page),
+			__dma_sync((unsigned long)page_address(sg_page(sg)),
 			           sg->length, direction);
 		plat_unmap_dma_mem(sg->dma_address);
 	}
@@ -322,7 +320,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (!plat_device_is_coherent(dev))
-			__dma_sync((unsigned long)page_address(sg->page),
+			__dma_sync((unsigned long)page_address(sg_page(sg)),
 			           sg->length, direction);
 		plat_unmap_dma_mem(sg->dma_address);
 	}
diff --git a/arch/powerpc/kernel/dma_64.c b/arch/powerpc/kernel/dma_64.c
index 9001104..14206e3 100644
--- a/arch/powerpc/kernel/dma_64.c
+++ b/arch/powerpc/kernel/dma_64.c
@@ -161,8 +161,7 @@ static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i) {
-		sg->dma_address = (page_to_phys(sg->page) + sg->offset) |
-			dma_direct_offset;
+		sg->dma_address = sg_phys(sg) | dma_direct_offset;
 		sg->dma_length = sg->length;
 	}
 
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 289d7e9..72fd871 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -102,8 +102,7 @@ static int ibmebus_map_sg(struct device *dev,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i) {
-		sg->dma_address = (dma_addr_t)page_address(sg->page)
-			+ sg->offset;
+		sg->dma_address = (dma_addr_t) sg_virt(sg);
 		sg->dma_length = sg->length;
 	}
 
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 306a6f7..2d0c9ef 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -307,7 +307,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			continue;
 		}
 		/* Allocate iommu entries for that segment */
-		vaddr = (unsigned long)page_address(s->page) + s->offset;
+		vaddr = (unsigned long) sg_virt(s);
 		npages = iommu_num_pages(vaddr, slen);
 		entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);
 
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 07e64b4..6405f4a 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -628,9 +628,8 @@ static int ps3_sb_map_sg(struct device *_dev, struct scatterlist *sgl,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i) {
-		int result = ps3_dma_map(dev->d_region,
-			page_to_phys(sg->page) + sg->offset, sg->length,
-					 &sg->dma_address, 0);
+		int result = ps3_dma_map(dev->d_region, sg_phys(sg),
+					sg->length, &sg->dma_address, 0);
 
 		if (result) {
 			pr_debug("%s:%d: ps3_dma_map failed (%d)\n",
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 9c3ed88..97aa50d 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -727,9 +727,8 @@ int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
 	BUG_ON(direction == PCI_DMA_NONE);
 	/* IIep is write-through, not flushing. */
 	for_each_sg(sgl, sg, nents, n) {
-		BUG_ON(page_address(sg->page) == NULL);
-		sg->dvma_address =
-			virt_to_phys(page_address(sg->page)) + sg->offset;
+		BUG_ON(page_address(sg_page(sg)) == NULL);
+		sg->dvma_address = virt_to_phys(sg_virt(sg));
 		sg->dvma_length = sg->length;
 	}
 	return nents;
@@ -748,9 +747,9 @@ void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
 	BUG_ON(direction == PCI_DMA_NONE);
 	if (direction != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
-			BUG_ON(page_address(sg->page) == NULL);
+			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
-			    (unsigned long) page_address(sg->page),
+			    (unsigned long) page_address(sg_page(sg)),
 			    (sg->length + PAGE_SIZE-1) & PAGE_MASK);
 		}
 	}
@@ -798,9 +797,9 @@ void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sgl, int
 	BUG_ON(direction == PCI_DMA_NONE);
 	if (direction != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
-			BUG_ON(page_address(sg->page) == NULL);
+			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
-			    (unsigned long) page_address(sg->page),
+			    (unsigned long) page_address(sg_page(sg)),
 			    (sg->length + PAGE_SIZE-1) & PAGE_MASK);
 		}
 	}
@@ -814,9 +813,9 @@ void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sgl,
 	BUG_ON(direction == PCI_DMA_NONE);
 	if (direction != PCI_DMA_TODEVICE) {
 		for_each_sg(sgl, sg, nents, n) {
-			BUG_ON(page_address(sg->page) == NULL);
+			BUG_ON(page_address(sg_page(sg)) == NULL);
 			mmu_inval_dma_area(
-			    (unsigned long) page_address(sg->page),
+			    (unsigned long) page_address(sg_page(sg)),
 			    (sg->length + PAGE_SIZE-1) & PAGE_MASK);
 		}
 	}
diff --git a/arch/sparc/mm/io-unit.c b/arch/sparc/mm/io-unit.c
index 375b4db..1666087 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -144,7 +144,7 @@ static void iounit_get_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_bus
 	spin_lock_irqsave(&iounit->lock, flags);
 	while (sz != 0) {
 		--sz;
-		sg->dvma_address = iounit_get_area(iounit, (unsigned long)page_address(sg->page) + sg->offset, sg->length);
+		sg->dvma_address = iounit_get_area(iounit, sg_virt(sg), sg->length);
 		sg->dvma_length = sg->length;
 		sg = sg_next(sg);
 	}
diff --git a/arch/sparc/mm/iommu.c b/arch/sparc/mm/iommu.c
index 283656d..4b93427 100644
--- a/arch/sparc/mm/iommu.c
+++ b/arch/sparc/mm/iommu.c
@@ -238,7 +238,7 @@ static void iommu_get_scsi_sgl_noflush(struct scatterlist *sg, int sz, struct sb
 	while (sz != 0) {
 		--sz;
 		n = (sg->length + sg->offset + PAGE_SIZE-1) >> PAGE_SHIFT;
-		sg->dvma_address = iommu_get_one(sg->page, n, sbus) + sg->offset;
+		sg->dvma_address = iommu_get_one(sg_page(sg), n, sbus) + sg->offset;
 		sg->dvma_length = (__u32) sg->length;
 		sg = sg_next(sg);
 	}
@@ -252,7 +252,7 @@ static void iommu_get_scsi_sgl_gflush(struct scatterlist *sg, int sz, struct sbu
 	while (sz != 0) {
 		--sz;
 		n = (sg->length + sg->offset + PAGE_SIZE-1) >> PAGE_SHIFT;
-		sg->dvma_address = iommu_get_one(sg->page, n, sbus) + sg->offset;
+		sg->dvma_address = iommu_get_one(sg_page(sg), n, sbus) + sg->offset;
 		sg->dvma_length = (__u32) sg->length;
 		sg = sg_next(sg);
 	}
@@ -273,7 +273,7 @@ static void iommu_get_scsi_sgl_pflush(struct scatterlist *sg, int sz, struct sbu
 		 * XXX Is this a good assumption?
 		 * XXX What if someone else unmaps it here and races us?
 		 */
-		if ((page = (unsigned long) page_address(sg->page)) != 0) {
+		if ((page = (unsigned long) page_address(sg_page(sg))) != 0) {
 			for (i = 0; i < n; i++) {
 				if (page != oldpage) {	/* Already flushed? */
 					flush_page_for_dma(page);
@@ -283,7 +283,7 @@ static void iommu_get_scsi_sgl_pflush(struct scatterlist *sg, int sz, struct sbu
 			}
 		}
 
-		sg->dvma_address = iommu_get_one(sg->page, n, sbus) + sg->offset;
+		sg->dvma_address = iommu_get_one(sg_page(sg), n, sbus) + sg->offset;
 		sg->dvma_length = (__u32) sg->length;
 		sg = sg_next(sg);
 	}
diff --git a/arch/sparc/mm/sun4c.c b/arch/sparc/mm/sun4c.c
index ee6708f..a2cc141 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -1228,7 +1228,7 @@ static void sun4c_get_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_bus *
 {
 	while (sz != 0) {
 		--sz;
-		sg->dvma_address = (__u32)sun4c_lockarea(page_address(sg->page) + sg->offset, sg->length);
+		sg->dvma_address = (__u32)sun4c_lockarea(sg_virt(sg), sg->length);
 		sg->dvma_length = sg->length;
 		sg = sg_next(sg);
 	}
diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index 29af777..070a484 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -472,8 +472,7 @@ static void dma_4u_unmap_single(struct device *dev, dma_addr_t bus_addr,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-#define SG_ENT_PHYS_ADDRESS(SG)	\
-	(__pa(page_address((SG)->page)) + (SG)->offset)
+#define SG_ENT_PHYS_ADDRESS(SG)	(__pa(sg_virt((SG))))
 
 static void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 		    int nused, int nelems,
@@ -565,9 +564,7 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 	/* Fast path single entry scatterlists. */
 	if (nelems == 1) {
 		sglist->dma_address =
-			dma_4u_map_single(dev,
-					  (page_address(sglist->page) +
-					   sglist->offset),
+			dma_4u_map_single(dev, sg_virt(sglist),
 					  sglist->length, direction);
 		if (unlikely(sglist->dma_address == DMA_ERROR_CODE))
 			return 0;
diff --git a/arch/sparc64/kernel/iommu_common.c b/arch/sparc64/kernel/iommu_common.c
index d7ca900..78e8277 100644
--- a/arch/sparc64/kernel/iommu_common.c
+++ b/arch/sparc64/kernel/iommu_common.c
@@ -73,7 +73,7 @@ static int verify_one_map(struct scatterlist *dma_sg, struct scatterlist **__sg,
 
 	daddr = dma_sg->dma_address;
 	sglen = sg->length;
-	sgaddr = (unsigned long) (page_address(sg->page) + sg->offset);
+	sgaddr = (unsigned long) sg_virt(sg);
 	while (dlen > 0) {
 		unsigned long paddr;
 
@@ -123,7 +123,7 @@ static int verify_one_map(struct scatterlist *dma_sg, struct scatterlist **__sg,
 		sg = sg_next(sg);
 		if (--nents <= 0)
 			break;
-		sgaddr = (unsigned long) (page_address(sg->page) + sg->offset);
+		sgaddr = (unsigned long) sg_virt(sg);
 		sglen = sg->length;
 	}
 	if (dlen < 0) {
@@ -191,7 +191,7 @@ void verify_sglist(struct scatterlist *sglist, int nents, iopte_t *iopte, int np
 			printk("sg(%d): page_addr(%p) off(%x) length(%x) "
 			       "dma_address[%016x] dma_length[%016x]\n",
 			       i,
-			       page_address(sg->page), sg->offset,
+			       page_address(sg_page(sg)), sg->offset,
 			       sg->length,
 			       sg->dma_address, sg->dma_length);
 		}
@@ -207,15 +207,14 @@ unsigned long prepare_sg(struct scatterlist *sg, int nents)
 	unsigned long prev;
 	u32 dent_addr, dent_len;
 
-	prev  = (unsigned long) (page_address(sg->page) + sg->offset);
+	prev  = (unsigned long) sg_virt(sg);
 	prev += (unsigned long) (dent_len = sg->length);
-	dent_addr = (u32) ((unsigned long)(page_address(sg->page) + sg->offset)
-			   & (IO_PAGE_SIZE - 1UL));
+	dent_addr = (u32) ((unsigned long)(sg_virt(sg)) & (IO_PAGE_SIZE - 1UL));
 	while (--nents) {
 		unsigned long addr;
 
 		sg = sg_next(sg);
-		addr = (unsigned long) (page_address(sg->page) + sg->offset);
+		addr = (unsigned long) sg_virt(sg);
 		if (! VCONTIG(prev, addr)) {
 			dma_sg->dma_address = dent_addr;
 			dma_sg->dma_length = dent_len;
diff --git a/arch/sparc64/kernel/ldc.c b/arch/sparc64/kernel/ldc.c
index 85a2be0..c8313cb 100644
--- a/arch/sparc64/kernel/ldc.c
+++ b/arch/sparc64/kernel/ldc.c
@@ -2057,7 +2057,7 @@ static void fill_cookies(struct cookie_state *sp, unsigned long pa,
 
 static int sg_count_one(struct scatterlist *sg)
 {
-	unsigned long base = page_to_pfn(sg->page) << PAGE_SHIFT;
+	unsigned long base = page_to_pfn(sg_page(sg)) << PAGE_SHIFT;
 	long len = sg->length;
 
 	if ((sg->offset | len) & (8UL - 1))
diff --git a/arch/sparc64/kernel/pci_sun4v.c b/arch/sparc64/kernel/pci_sun4v.c
index fe46ace..8c4875b 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -365,8 +365,7 @@ static void dma_4v_unmap_single(struct device *dev, dma_addr_t bus_addr,
 	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
-#define SG_ENT_PHYS_ADDRESS(SG)	\
-	(__pa(page_address((SG)->page)) + (SG)->offset)
+#define SG_ENT_PHYS_ADDRESS(SG)	(__pa(sg_virt((SG))))
 
 static long fill_sg(long entry, struct device *dev,
 		    struct scatterlist *sg,
@@ -477,9 +476,7 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 	/* Fast path single entry scatterlists. */
 	if (nelems == 1) {
 		sglist->dma_address =
-			dma_4v_map_single(dev,
-					  (page_address(sglist->page) +
-					   sglist->offset),
+			dma_4v_map_single(dev, sg_virt(sglist),
 					  sglist->length, direction);
 		if (unlikely(sglist->dma_address == DMA_ERROR_CODE))
 			return 0;
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 5098f58..1a20fe3 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -411,8 +411,10 @@ static int calgary_nontranslate_map_sg(struct device* dev,
 	int i;
 
 	for_each_sg(sg, s, nelems, i) {
-		BUG_ON(!s->page);
-		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
+		struct page *p = sg_page(s);
+
+		BUG_ON(!p);
+		s->dma_address = virt_to_bus(sg_virt(s));
 		s->dma_length = s->length;
 	}
 	return nelems;
@@ -432,9 +434,9 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
 	for_each_sg(sg, s, nelems, i) {
-		BUG_ON(!s->page);
+		BUG_ON(!sg_page(s));
 
-		vaddr = (unsigned long)page_address(s->page) + s->offset;
+		vaddr = (unsigned long) sg_virt(s);
 		npages = num_dma_pages(vaddr, s->length);
 
 		entry = iommu_range_alloc(tbl, npages);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 5cdfab6..c56e9ee 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -302,7 +302,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 #endif
 
 	for_each_sg(sg, s, nents, i) {
-		unsigned long addr = page_to_phys(s->page) + s->offset; 
+		unsigned long addr = sg_phys(s);
 		if (nonforced_iommu(dev, addr, s->length)) { 
 			addr = dma_map_area(dev, addr, s->length, dir);
 			if (addr == bad_dma_address) { 
@@ -397,7 +397,7 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	start_sg = sgmap = sg;
 	ps = NULL; /* shut up gcc */
 	for_each_sg(sg, s, nents, i) {
-		dma_addr_t addr = page_to_phys(s->page) + s->offset;
+		dma_addr_t addr = sg_phys(s);
 		s->dma_address = addr;
 		BUG_ON(s->length == 0); 
 
diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index e85d436..faf70bd 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -62,8 +62,8 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	int i;
 
 	for_each_sg(sg, s, nents, i) {
-		BUG_ON(!s->page);
-		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
+		BUG_ON(!sg_page(s));
+		s->dma_address = virt_to_bus(sg_virt(s));
 		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
 			return 0;
 		s->dma_length = s->length;
-- 
1.5.3.GIT

