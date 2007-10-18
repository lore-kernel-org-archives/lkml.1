Return-Path: <linux-kernel-owner+w=401wt.eu-S1765481AbXJRN7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765481AbXJRN7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 09:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762191AbXJRN7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 09:59:08 -0400
Received: from brick.kernel.dk ([87.55.233.238]:24829 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762089AbXJRN7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 09:59:00 -0400
Date: Thu, 18 Oct 2007 15:58:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Mark Lord <lkml@rtr.ca>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       fujita.tomonori@lab.ntt.co.jp, mingo@elte.hu,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018135810.GM5063@kernel.dk>
References: <20071018082145.GK5063@kernel.dk> <20071018.045505.106265100.davem@davemloft.net> <20071018115702.GW5063@kernel.dk> <20071018.050554.115911163.davem@davemloft.net> <20071018120950.GX5063@kernel.dk> <20071018121547.GY5063@kernel.dk> <20071018125840.GF5063@kernel.dk> <20071018133200.GH5063@kernel.dk> <471764CB.5020906@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471764CB.5020906@rtr.ca>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2007, Mark Lord wrote:
> Jens wrote:
>> OK, I think that covers every arch out there. I haven't been able to
>> compile any of them, but it's mostly search'n replace operations. I hope
>> nothing is missing linux/scatterlist.h includes...
>
> Patch fails on drivers/scsi/scsi_lib.c.
>
> I replaced that part of the patch with this updated portion instead:

Hmm, what are you applying against? Must be a clean tree, throw away any
patches that you already applied in this thread.

Updated below.

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index e1c4707..094a95e 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -465,7 +465,7 @@ EXPORT_SYMBOL(pci_free_consistent);
    Write dma_length of each leader with the combined lengths of
    the mergable followers.  */
 
-#define SG_ENT_VIRT_ADDRESS(SG) (page_address((SG)->page) + (SG)->offset)
+#define SG_ENT_VIRT_ADDRESS(SG) (page_address(sg_page((SG)) + (SG)->offset))
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
index 94d7b11..dbf7222 100644
--- a/arch/blackfin/kernel/dma-mapping.c
+++ b/arch/blackfin/kernel/dma-mapping.c
@@ -160,7 +160,7 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for (i = 0; i < nents; i++, sg++) {
-		sg->dma_address = (dma_addr_t)(page_address(sg->page) +
+		sg->dma_address = (dma_addr_t)(page_address(sg_page(sg)) +
 					sg->offset);
 
 		invalidate_dcache_range(sg_dma_address(sg),
diff --git a/arch/ia64/hp/common/sba_iommu.c b/arch/ia64/hp/common/sba_iommu.c
index 3c95f41..0b74c63 100644
--- a/arch/ia64/hp/common/sba_iommu.c
+++ b/arch/ia64/hp/common/sba_iommu.c
@@ -246,7 +246,7 @@ static int reserve_sba_gart = 1;
 static SBA_INLINE void sba_mark_invalid(struct ioc *, dma_addr_t, size_t);
 static SBA_INLINE void sba_free_range(struct ioc *, dma_addr_t, size_t);
 
-#define sba_sg_address(sg)	(page_address((sg)->page) + (sg)->offset)
+#define sba_sg_address(sg)	(page_address(sg_page((sg)) + (sg)->offset))
 
 #ifdef FULL_VALID_PDIR
 static u64 prefetch_spill_page;
diff --git a/arch/ia64/hp/sim/simscsi.c b/arch/ia64/hp/sim/simscsi.c
index a3a558a..7f1794f 100644
--- a/arch/ia64/hp/sim/simscsi.c
+++ b/arch/ia64/hp/sim/simscsi.c
@@ -131,7 +131,7 @@ simscsi_sg_readwrite (struct scsi_cmnd *sc, int mode, unsigned long offset)
 	stat.fd = desc[sc->device->id];
 
 	scsi_for_each_sg(sc, sl, scsi_sg_count(sc), i) {
-		req.addr = __pa(page_address(sl->page) + sl->offset);
+		req.addr = __pa(page_address(sg_page(sl)) + sl->offset);
 		req.len  = sl->length;
 		if (DBG)
 			printk("simscsi_sg_%s @ %lx (off %lx) use_sg=%d len=%d\n",
@@ -212,7 +212,7 @@ static void simscsi_fillresult(struct scsi_cmnd *sc, char *buf, unsigned len)
 		if (!len)
 			break;
 		thislen = min(len, slp->length);
-		memcpy(page_address(slp->page) + slp->offset, buf, thislen);
+		memcpy(page_address(sg_page(slp)) + slp->offset, buf, thislen);
 		len -= thislen;
 	}
 }
diff --git a/arch/ia64/sn/pci/pci_dma.c b/arch/ia64/sn/pci/pci_dma.c
index ecd8a52..6048eaf 100644
--- a/arch/ia64/sn/pci/pci_dma.c
+++ b/arch/ia64/sn/pci/pci_dma.c
@@ -16,7 +16,7 @@
 #include <asm/sn/pcidev.h>
 #include <asm/sn/sn_sal.h>
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
+#define SG_ENT_VIRT_ADDRESS(sg)	(page_address(sg_page((sg)) + (sg)->offset))
 #define SG_ENT_PHYS_ADDRESS(SG)	virt_to_phys(SG_ENT_VIRT_ADDRESS(SG))
 
 /**
diff --git a/arch/m68k/kernel/dma.c b/arch/m68k/kernel/dma.c
index 9d4e4b5..b2d620b 100644
--- a/arch/m68k/kernel/dma.c
+++ b/arch/m68k/kernel/dma.c
@@ -121,7 +121,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	int i;
 
 	for (i = 0; i < nents; sg++, i++) {
-		sg->dma_address = page_to_phys(sg->page) + sg->offset;
+		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;
 		dma_sync_single_for_device(dev, sg->dma_address, sg->length, dir);
 	}
 	return nents;
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index 98b5e5b..4aa143b 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -165,7 +165,7 @@ int dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	for (i = 0; i < nents; i++, sg++) {
 		unsigned long addr;
 
-		addr = (unsigned long) page_address(sg->page);
+		addr = (unsigned long) page_address(sg_page(sg));
 		if (!plat_device_is_coherent(dev) && addr)
 			__dma_sync(addr + sg->offset, sg->length, direction);
 		sg->dma_address = plat_map_dma_mem(dev,
@@ -223,7 +223,7 @@ void dma_unmap_sg(struct device *dev, struct scatterlist *sg, int nhwentries,
 	for (i = 0; i < nhwentries; i++, sg++) {
 		if (!plat_device_is_coherent(dev) &&
 		    direction != DMA_TO_DEVICE) {
-			addr = (unsigned long) page_address(sg->page);
+			addr = (unsigned long) page_address(sg_page(sg));
 			if (addr)
 				__dma_sync(addr + sg->offset, sg->length,
 				           direction);
@@ -304,7 +304,7 @@ void dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nelems,
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (cpu_is_noncoherent_r10000(dev))
-			__dma_sync((unsigned long)page_address(sg->page),
+			__dma_sync((unsigned long)page_address(sg_page(sg)),
 			           sg->length, direction);
 		plat_unmap_dma_mem(sg->dma_address);
 	}
@@ -322,7 +322,7 @@ void dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nele
 	/* Make sure that gcc doesn't leave the empty loop body.  */
 	for (i = 0; i < nelems; i++, sg++) {
 		if (!plat_device_is_coherent(dev))
-			__dma_sync((unsigned long)page_address(sg->page),
+			__dma_sync((unsigned long)page_address(sg_page(sg)),
 			           sg->length, direction);
 		plat_unmap_dma_mem(sg->dma_address);
 	}
diff --git a/arch/powerpc/kernel/dma_64.c b/arch/powerpc/kernel/dma_64.c
index 9001104..5d0aa90 100644
--- a/arch/powerpc/kernel/dma_64.c
+++ b/arch/powerpc/kernel/dma_64.c
@@ -161,7 +161,7 @@ static int dma_direct_map_sg(struct device *dev, struct scatterlist *sgl,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i) {
-		sg->dma_address = (page_to_phys(sg->page) + sg->offset) |
+		sg->dma_address = (page_to_phys(sg_page(sg)) + sg->offset) |
 			dma_direct_offset;
 		sg->dma_length = sg->length;
 	}
diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 289d7e9..3d0e71b 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -102,7 +102,7 @@ static int ibmebus_map_sg(struct device *dev,
 	int i;
 
 	for_each_sg(sgl, sg, nents, i) {
-		sg->dma_address = (dma_addr_t)page_address(sg->page)
+		sg->dma_address = (dma_addr_t)page_address(sg_page(sg))
 			+ sg->offset;
 		sg->dma_length = sg->length;
 	}
diff --git a/arch/powerpc/kernel/iommu.c b/arch/powerpc/kernel/iommu.c
index 306a6f7..47d745a 100644
--- a/arch/powerpc/kernel/iommu.c
+++ b/arch/powerpc/kernel/iommu.c
@@ -307,7 +307,7 @@ int iommu_map_sg(struct iommu_table *tbl, struct scatterlist *sglist,
 			continue;
 		}
 		/* Allocate iommu entries for that segment */
-		vaddr = (unsigned long)page_address(s->page) + s->offset;
+		vaddr = (unsigned long)page_address(sg_page(s)) + s->offset;
 		npages = iommu_num_pages(vaddr, slen);
 		entry = iommu_range_alloc(tbl, npages, &handle, mask >> IOMMU_PAGE_SHIFT, 0);
 
diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index 07e64b4..e8202b6 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -629,7 +629,7 @@ static int ps3_sb_map_sg(struct device *_dev, struct scatterlist *sgl,
 
 	for_each_sg(sgl, sg, nents, i) {
 		int result = ps3_dma_map(dev->d_region,
-			page_to_phys(sg->page) + sg->offset, sg->length,
+			page_to_phys(sg_page(sg)) + sg->offset, sg->length,
 					 &sg->dma_address, 0);
 
 		if (result) {
diff --git a/arch/sparc/kernel/ioport.c b/arch/sparc/kernel/ioport.c
index 9c3ed88..abc4470 100644
--- a/arch/sparc/kernel/ioport.c
+++ b/arch/sparc/kernel/ioport.c
@@ -727,9 +727,9 @@ int pci_map_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
 	BUG_ON(direction == PCI_DMA_NONE);
 	/* IIep is write-through, not flushing. */
 	for_each_sg(sgl, sg, nents, n) {
-		BUG_ON(page_address(sg->page) == NULL);
+		BUG_ON(page_address(sg_page(sg)) == NULL);
 		sg->dvma_address =
-			virt_to_phys(page_address(sg->page)) + sg->offset;
+			virt_to_phys(page_address(sg_page(sg))) + sg->offset;
 		sg->dvma_length = sg->length;
 	}
 	return nents;
@@ -748,9 +748,9 @@ void pci_unmap_sg(struct pci_dev *hwdev, struct scatterlist *sgl, int nents,
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
@@ -798,9 +798,9 @@ void pci_dma_sync_sg_for_cpu(struct pci_dev *hwdev, struct scatterlist *sgl, int
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
@@ -814,9 +814,9 @@ void pci_dma_sync_sg_for_device(struct pci_dev *hwdev, struct scatterlist *sgl,
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
index 375b4db..0f2ad57 100644
--- a/arch/sparc/mm/io-unit.c
+++ b/arch/sparc/mm/io-unit.c
@@ -144,7 +144,7 @@ static void iounit_get_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_bus
 	spin_lock_irqsave(&iounit->lock, flags);
 	while (sz != 0) {
 		--sz;
-		sg->dvma_address = iounit_get_area(iounit, (unsigned long)page_address(sg->page) + sg->offset, sg->length);
+		sg->dvma_address = iounit_get_area(iounit, (unsigned long)page_address(sg_page(sg)) + sg->offset, sg->length);
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
index ee6708f..f172dbe 100644
--- a/arch/sparc/mm/sun4c.c
+++ b/arch/sparc/mm/sun4c.c
@@ -1228,7 +1228,7 @@ static void sun4c_get_scsi_sgl(struct scatterlist *sg, int sz, struct sbus_bus *
 {
 	while (sz != 0) {
 		--sz;
-		sg->dvma_address = (__u32)sun4c_lockarea(page_address(sg->page) + sg->offset, sg->length);
+		sg->dvma_address = (__u32)sun4c_lockarea(page_address(sg_page(sg)) + sg->offset, sg->length);
 		sg->dvma_length = sg->length;
 		sg = sg_next(sg);
 	}
diff --git a/arch/sparc64/kernel/iommu.c b/arch/sparc64/kernel/iommu.c
index 29af777..73852a2 100644
--- a/arch/sparc64/kernel/iommu.c
+++ b/arch/sparc64/kernel/iommu.c
@@ -473,7 +473,7 @@ static void dma_4u_unmap_single(struct device *dev, dma_addr_t bus_addr,
 }
 
 #define SG_ENT_PHYS_ADDRESS(SG)	\
-	(__pa(page_address((SG)->page)) + (SG)->offset)
+	(__pa(page_address(sg_page(SG))) + (SG)->offset)
 
 static void fill_sg(iopte_t *iopte, struct scatterlist *sg,
 		    int nused, int nelems,
@@ -566,7 +566,7 @@ static int dma_4u_map_sg(struct device *dev, struct scatterlist *sglist,
 	if (nelems == 1) {
 		sglist->dma_address =
 			dma_4u_map_single(dev,
-					  (page_address(sglist->page) +
+					  (page_address(sg_page(sglist)) +
 					   sglist->offset),
 					  sglist->length, direction);
 		if (unlikely(sglist->dma_address == DMA_ERROR_CODE))
diff --git a/arch/sparc64/kernel/iommu_common.c b/arch/sparc64/kernel/iommu_common.c
index d7ca900..ec863e0 100644
--- a/arch/sparc64/kernel/iommu_common.c
+++ b/arch/sparc64/kernel/iommu_common.c
@@ -73,7 +73,7 @@ static int verify_one_map(struct scatterlist *dma_sg, struct scatterlist **__sg,
 
 	daddr = dma_sg->dma_address;
 	sglen = sg->length;
-	sgaddr = (unsigned long) (page_address(sg->page) + sg->offset);
+	sgaddr = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
 	while (dlen > 0) {
 		unsigned long paddr;
 
@@ -123,7 +123,7 @@ static int verify_one_map(struct scatterlist *dma_sg, struct scatterlist **__sg,
 		sg = sg_next(sg);
 		if (--nents <= 0)
 			break;
-		sgaddr = (unsigned long) (page_address(sg->page) + sg->offset);
+		sgaddr = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
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
@@ -207,15 +207,15 @@ unsigned long prepare_sg(struct scatterlist *sg, int nents)
 	unsigned long prev;
 	u32 dent_addr, dent_len;
 
-	prev  = (unsigned long) (page_address(sg->page) + sg->offset);
+	prev  = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
 	prev += (unsigned long) (dent_len = sg->length);
-	dent_addr = (u32) ((unsigned long)(page_address(sg->page) + sg->offset)
+	dent_addr = (u32) ((unsigned long)(page_address(sg_page(sg)) + sg->offset)
 			   & (IO_PAGE_SIZE - 1UL));
 	while (--nents) {
 		unsigned long addr;
 
 		sg = sg_next(sg);
-		addr = (unsigned long) (page_address(sg->page) + sg->offset);
+		addr = (unsigned long) (page_address(sg_page(sg)) + sg->offset);
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
index fe46ace..5324a34 100644
--- a/arch/sparc64/kernel/pci_sun4v.c
+++ b/arch/sparc64/kernel/pci_sun4v.c
@@ -366,7 +366,7 @@ static void dma_4v_unmap_single(struct device *dev, dma_addr_t bus_addr,
 }
 
 #define SG_ENT_PHYS_ADDRESS(SG)	\
-	(__pa(page_address((SG)->page)) + (SG)->offset)
+	(__pa(page_address(sg_page(SG))) + (SG)->offset)
 
 static long fill_sg(long entry, struct device *dev,
 		    struct scatterlist *sg,
@@ -478,7 +478,7 @@ static int dma_4v_map_sg(struct device *dev, struct scatterlist *sglist,
 	if (nelems == 1) {
 		sglist->dma_address =
 			dma_4v_map_single(dev,
-					  (page_address(sglist->page) +
+					  (page_address(sg_page(sglist)) +
 					   sglist->offset),
 					  sglist->length, direction);
 		if (unlikely(sglist->dma_address == DMA_ERROR_CODE))
diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 25b248a..3a8cd3d 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -1115,7 +1115,7 @@ static void do_ubd_request(struct request_queue *q)
 			}
 			prepare_request(req, io_req,
 					(unsigned long long) req->sector << 9,
-					sg->offset, sg->length, sg->page);
+					sg->offset, sg->length, sg_page(sg));
 
 			last_sectors = sg->length >> 9;
 			n = os_write_file(thread_fd, &io_req,
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 5098f58..c9f0eb0 100644
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
+		s->dma_address = virt_to_bus(page_address(p) + s->offset);
 		s->dma_length = s->length;
 	}
 	return nelems;
@@ -432,9 +434,11 @@ static int calgary_map_sg(struct device *dev, struct scatterlist *sg,
 		return calgary_nontranslate_map_sg(dev, sg, nelems, direction);
 
 	for_each_sg(sg, s, nelems, i) {
-		BUG_ON(!s->page);
+		struct page *p = sg_page(s);
+
+		BUG_ON(!p);
 
-		vaddr = (unsigned long)page_address(s->page) + s->offset;
+		vaddr = (unsigned long)page_address(p) + s->offset;
 		npages = num_dma_pages(vaddr, s->length);
 
 		entry = iommu_range_alloc(tbl, npages);
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index 5cdfab6..daaf636 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -302,7 +302,7 @@ static int dma_map_sg_nonforce(struct device *dev, struct scatterlist *sg,
 #endif
 
 	for_each_sg(sg, s, nents, i) {
-		unsigned long addr = page_to_phys(s->page) + s->offset; 
+		unsigned long addr = page_to_phys(sg_page(s)) + s->offset; 
 		if (nonforced_iommu(dev, addr, s->length)) { 
 			addr = dma_map_area(dev, addr, s->length, dir);
 			if (addr == bad_dma_address) { 
@@ -397,7 +397,7 @@ static int gart_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	start_sg = sgmap = sg;
 	ps = NULL; /* shut up gcc */
 	for_each_sg(sg, s, nents, i) {
-		dma_addr_t addr = page_to_phys(s->page) + s->offset;
+		dma_addr_t addr = page_to_phys(sg_page(s)) + s->offset;
 		s->dma_address = addr;
 		BUG_ON(s->length == 0); 
 
diff --git a/arch/x86/kernel/pci-nommu_64.c b/arch/x86/kernel/pci-nommu_64.c
index e85d436..d64a4a5 100644
--- a/arch/x86/kernel/pci-nommu_64.c
+++ b/arch/x86/kernel/pci-nommu_64.c
@@ -62,8 +62,8 @@ static int nommu_map_sg(struct device *hwdev, struct scatterlist *sg,
 	int i;
 
 	for_each_sg(sg, s, nents, i) {
-		BUG_ON(!s->page);
-		s->dma_address = virt_to_bus(page_address(s->page) +s->offset);
+		BUG_ON(!sg_page(s));
+		s->dma_address = virt_to_bus(page_address(sg_page(s)) +s->offset);
 		if (!check_addr("map_sg", hwdev, s->dma_address, s->length))
 			return 0;
 		s->dma_length = s->length;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 3935469..ce9754f 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1354,8 +1354,9 @@ new_segment:
 			else
 				sg = sg_next(sg);
 
-			memset(sg, 0, sizeof(*sg));
-			sg->page = bvec->bv_page;
+			sg_dma_len(sg) = 0;
+			sg_dma_address(sg) = 0;
+			sg_set_page(sg, bvec->bv_page);
 			sg->length = nbytes;
 			sg->offset = bvec->bv_offset;
 			nsegs++;
diff --git a/crypto/digest.c b/crypto/digest.c
index e56de67..8871dec 100644
--- a/crypto/digest.c
+++ b/crypto/digest.c
@@ -41,7 +41,7 @@ static int update2(struct hash_desc *desc,
 		return 0;
 
 	for (;;) {
-		struct page *pg = sg->page;
+		struct page *pg = sg_page(sg);
 		unsigned int offset = sg->offset;
 		unsigned int l = sg->length;
 
diff --git a/crypto/hmac.c b/crypto/hmac.c
index 8802fb6..e4eb6ac 100644
--- a/crypto/hmac.c
+++ b/crypto/hmac.c
@@ -159,7 +159,8 @@ static int hmac_digest(struct hash_desc *pdesc, struct scatterlist *sg,
 	desc.flags = pdesc->flags & CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	sg_set_buf(sg1, ipad, bs);
-	sg1[1].page = (void *)sg;
+
+	sg_set_page(&sg[1], (void *) sg);
 	sg1[1].length = 0;
 	sg_set_buf(sg2, opad, bs + ds);
 
diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index d6852c3..b9bbda0 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -54,7 +54,7 @@ static void scatterwalk_pagedone(struct scatter_walk *walk, int out,
 	if (out) {
 		struct page *page;
 
-		page = walk->sg->page + ((walk->offset - 1) >> PAGE_SHIFT);
+		page = sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT);
 		flush_dcache_page(page);
 	}
 
diff --git a/crypto/scatterwalk.h b/crypto/scatterwalk.h
index 9c73e37..87ed681 100644
--- a/crypto/scatterwalk.h
+++ b/crypto/scatterwalk.h
@@ -22,13 +22,13 @@
 
 static inline struct scatterlist *scatterwalk_sg_next(struct scatterlist *sg)
 {
-	return (++sg)->length ? sg : (void *)sg->page;
+	return (++sg)->length ? sg : (void *) sg_page(sg);
 }
 
 static inline unsigned long scatterwalk_samebuf(struct scatter_walk *walk_in,
 						struct scatter_walk *walk_out)
 {
-	return !(((walk_in->sg->page - walk_out->sg->page) << PAGE_SHIFT) +
+	return !(((sg_page(walk_in->sg) - sg_page(walk_out->sg)) << PAGE_SHIFT) +
 		 (int)(walk_in->offset - walk_out->offset));
 }
 
@@ -60,7 +60,7 @@ static inline unsigned int scatterwalk_aligned(struct scatter_walk *walk,
 
 static inline struct page *scatterwalk_page(struct scatter_walk *walk)
 {
-	return walk->sg->page + (walk->offset >> PAGE_SHIFT);
+	return sg_page(walk->sg) + (walk->offset >> PAGE_SHIFT);
 }
 
 static inline void scatterwalk_unmap(void *vaddr, int out)
diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 18d489c..d741c63 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -317,7 +317,7 @@ static void test_cipher(char *algo, int enc,
 				goto out;
 			}
 
-			q = kmap(sg[0].page) + sg[0].offset;
+			q = kmap(sg_page(&sg[0])) + sg[0].offset;
 			hexdump(q, cipher_tv[i].rlen);
 
 			printk("%s\n",
@@ -390,7 +390,7 @@ static void test_cipher(char *algo, int enc,
 			temp = 0;
 			for (k = 0; k < cipher_tv[i].np; k++) {
 				printk("page %u\n", k);
-				q = kmap(sg[k].page) + sg[k].offset;
+				q = kmap(sg_page(&sg[k])) + sg[k].offset;
 				hexdump(q, cipher_tv[i].tap[k]);
 				printk("%s\n",
 					memcmp(q, cipher_tv[i].result + temp,
diff --git a/crypto/xcbc.c b/crypto/xcbc.c
index 9f502b8..ac68f3b 100644
--- a/crypto/xcbc.c
+++ b/crypto/xcbc.c
@@ -120,7 +120,7 @@ static int crypto_xcbc_digest_update2(struct hash_desc *pdesc,
 
 	do {
 
-		struct page *pg = sg[i].page;
+		struct page *pg = sg_page(&sg[i]);
 		unsigned int offset = sg[i].offset;
 		unsigned int slen = sg[i].length;
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index bbaa545..b1fa70a 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4296,7 +4296,7 @@ void ata_sg_clean(struct ata_queued_cmd *qc)
 		sg_last(sg, qc->orig_n_elem)->length += qc->pad_len;
 		if (pad_buf) {
 			struct scatterlist *psg = &qc->pad_sgent;
-			void *addr = kmap_atomic(psg->page, KM_IRQ0);
+			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
 			memcpy(addr + psg->offset, pad_buf, qc->pad_len);
 			kunmap_atomic(addr, KM_IRQ0);
 		}
@@ -4686,11 +4686,11 @@ static int ata_sg_setup(struct ata_queued_cmd *qc)
 		 * data in this function or read data in ata_sg_clean.
 		 */
 		offset = lsg->offset + lsg->length - qc->pad_len;
-		psg->page = nth_page(lsg->page, offset >> PAGE_SHIFT);
+		sg_set_page(psg, nth_page(sg_page(lsg), offset >> PAGE_SHIFT));
 		psg->offset = offset_in_page(offset);
 
 		if (qc->tf.flags & ATA_TFLAG_WRITE) {
-			void *addr = kmap_atomic(psg->page, KM_IRQ0);
+			void *addr = kmap_atomic(sg_page(psg), KM_IRQ0);
 			memcpy(pad_buf, addr + psg->offset, qc->pad_len);
 			kunmap_atomic(addr, KM_IRQ0);
 		}
@@ -4836,7 +4836,7 @@ static void ata_pio_sector(struct ata_queued_cmd *qc)
 	if (qc->curbytes == qc->nbytes - qc->sect_size)
 		ap->hsm_task_state = HSM_ST_LAST;
 
-	page = qc->cursg->page;
+	page = sg_page(qc->cursg);
 	offset = qc->cursg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
@@ -4988,7 +4988,7 @@ next_sg:
 
 	sg = qc->cursg;
 
-	page = sg->page;
+	page = sg_page(sg);
 	offset = sg->offset + qc->cursg_ofs;
 
 	/* get the current page and offset */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 9fbb39c..5b758b9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1544,7 +1544,7 @@ static unsigned int ata_scsi_rbuf_get(struct scsi_cmnd *cmd, u8 **buf_out)
 	struct scatterlist *sg = scsi_sglist(cmd);
 
 	if (sg) {
-		buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 		buflen = sg->length;
 	} else {
 		buf = NULL;
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 7c2cfde..5a6fe17 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -2610,7 +2610,7 @@ static void do_cciss_request(struct request_queue *q)
 	       (int)creq->nr_sectors);
 #endif				/* CCISS_DEBUG */
 
-	memset(tmp_sg, 0, sizeof(tmp_sg));
+	sg_init_table(tmp_sg, MAXSGENTRIES);
 	seg = blk_rq_map_sg(q, creq, tmp_sg);
 
 	/* get the DMA records for the setup */
@@ -2621,7 +2621,7 @@ static void do_cciss_request(struct request_queue *q)
 
 	for (i = 0; i < seg; i++) {
 		c->SG[i].Len = tmp_sg[i].length;
-		temp64.val = (__u64) pci_map_page(h->pdev, tmp_sg[i].page,
+		temp64.val = (__u64) pci_map_page(h->pdev, sg_page(&tmp_sg[i]),
 						  tmp_sg[i].offset,
 						  tmp_sg[i].length, dir);
 		c->SG[i].Addr.lower = temp64.val32.lower;
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 568603d..efab27f 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -918,6 +918,7 @@ queue_next:
 DBGPX(
 	printk("sector=%d, nr_sectors=%d\n", creq->sector, creq->nr_sectors);
 );
+	sg_init_table(tmp_sg, SG_MAX);
 	seg = blk_rq_map_sg(q, creq, tmp_sg);
 
 	/* Now do all the DMA Mappings */
@@ -929,7 +930,7 @@ DBGPX(
 	{
 		c->req.sg[i].size = tmp_sg[i].length;
 		c->req.sg[i].addr = (__u32) pci_map_page(h->pci_dev,
-						 tmp_sg[i].page,
+						 sg_page(&tmp_sg[i]),
 						 tmp_sg[i].offset,
 						 tmp_sg[i].length, dir);
 	}
diff --git a/drivers/block/cryptoloop.c b/drivers/block/cryptoloop.c
index 4053503..1b58b01 100644
--- a/drivers/block/cryptoloop.c
+++ b/drivers/block/cryptoloop.c
@@ -26,6 +26,7 @@
 #include <linux/crypto.h>
 #include <linux/blkdev.h>
 #include <linux/loop.h>
+#include <linux/scatterlist.h>
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
@@ -119,14 +120,17 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
 		.tfm = tfm,
 		.flags = CRYPTO_TFM_REQ_MAY_SLEEP,
 	};
-	struct scatterlist sg_out = { NULL, };
-	struct scatterlist sg_in = { NULL, };
+	struct scatterlist sg_out;
+	struct scatterlist sg_in;
 
 	encdec_cbc_t encdecfunc;
 	struct page *in_page, *out_page;
 	unsigned in_offs, out_offs;
 	int err;
 
+	sg_init_table(&sg_out, 1);
+	sg_init_table(&sg_in, 1);
+
 	if (cmd == READ) {
 		in_page = raw_page;
 		in_offs = raw_off;
@@ -146,11 +150,11 @@ cryptoloop_transfer(struct loop_device *lo, int cmd,
 		u32 iv[4] = { 0, };
 		iv[0] = cpu_to_le32(IV & 0xffffffff);
 
-		sg_in.page = in_page;
+		sg_set_page(&sg_in, in_page);
 		sg_in.offset = in_offs;
 		sg_in.length = sz;
 
-		sg_out.page = out_page;
+		sg_set_page(&sg_out, out_page);
 		sg_out.offset = out_offs;
 		sg_out.length = sz;
 
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index c57dd2b..d6f7b43 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -25,6 +25,7 @@
 #include <linux/usb_usual.h>
 #include <linux/blkdev.h>
 #include <linux/timer.h>
+#include <linux/scatterlist.h>
 #include <scsi/scsi.h>
 
 #define DRV_NAME "ub"
@@ -656,6 +657,7 @@ static int ub_request_fn_1(struct ub_lun *lun, struct request *rq)
 	if ((cmd = ub_get_cmd(lun)) == NULL)
 		return -1;
 	memset(cmd, 0, sizeof(struct ub_scsi_cmd));
+	sg_init_table(cmd->sgv, UB_MAX_REQ_SG);
 
 	blkdev_dequeue_request(rq);
 
@@ -1310,7 +1312,7 @@ static void ub_data_start(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 		pipe = sc->send_bulk_pipe;
 	sc->last_pipe = pipe;
 	usb_fill_bulk_urb(&sc->work_urb, sc->dev, pipe,
-	    page_address(sg->page) + sg->offset, sg->length,
+	    page_address(sg_page(sg)) + sg->offset, sg->length,
 	    ub_urb_complete, sc);
 	sc->work_urb.actual_length = 0;
 	sc->work_urb.error_count = 0;
@@ -1427,7 +1429,7 @@ static void ub_state_sense(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
 	scmd->state = UB_CMDST_INIT;
 	scmd->nsg = 1;
 	sg = &scmd->sgv[0];
-	sg->page = virt_to_page(sc->top_sense);
+	sg_set_page(sg, virt_to_page(sc->top_sense));
 	sg->offset = (unsigned long)sc->top_sense & (PAGE_SIZE-1);
 	sg->length = UB_SENSE_SIZE;
 	scmd->len = UB_SENSE_SIZE;
@@ -1863,7 +1865,7 @@ static int ub_sync_read_cap(struct ub_dev *sc, struct ub_lun *lun,
 	cmd->state = UB_CMDST_INIT;
 	cmd->nsg = 1;
 	sg = &cmd->sgv[0];
-	sg->page = virt_to_page(p);
+	sg_set_page(sg, virt_to_page(p));
 	sg->offset = (unsigned long)p & (PAGE_SIZE-1);
 	sg->length = 8;
 	cmd->len = 8;
diff --git a/drivers/ide/cris/ide-cris.c b/drivers/ide/cris/ide-cris.c
index 06c75f1..3979bf4 100644
--- a/drivers/ide/cris/ide-cris.c
+++ b/drivers/ide/cris/ide-cris.c
@@ -934,11 +934,11 @@ static int cris_ide_build_dmatable (ide_drive_t *drive)
 		 * than two possibly non-adjacent physical 4kB pages.
 		 */
 		/* group sequential buffers into one large buffer */
-		addr = page_to_phys(sg->page) + sg->offset;
+		addr = page_to_phys(sg_page(sg)) + sg->offset;
 		size = sg_dma_len(sg);
 		while (--i) {
 			sg = sg_next(sg);
-			if ((addr + size) != page_to_phys(sg->page) + sg->offset)
+			if ((addr + size) != page_to_phys(sg_page(sg)) + sg->offset)
 				break;
 			size += sg_dma_len(sg);
 		}
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 3c945d6..7c640cd 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -1337,12 +1337,14 @@ static int hwif_init(ide_hwif_t *hwif)
 	if (!hwif->sg_max_nents)
 		hwif->sg_max_nents = PRD_ENTRIES;
 
-	hwif->sg_table = kzalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
+	hwif->sg_table = kmalloc(sizeof(struct scatterlist)*hwif->sg_max_nents,
 				 GFP_KERNEL);
 	if (!hwif->sg_table) {
 		printk(KERN_ERR "%s: unable to allocate SG table.\n", hwif->name);
 		goto out;
 	}
+
+	sg_init_table(hwif->sg_table, hwif->sg_max_nents);
 	
 	if (init_irq(hwif) == 0)
 		goto done;
diff --git a/drivers/ide/ide-taskfile.c b/drivers/ide/ide-taskfile.c
index 2a3c8d4..086157f 100644
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -278,7 +278,7 @@ static void ide_pio_sector(ide_drive_t *drive, unsigned int write)
 		hwif->cursg = sg;
 	}
 
-	page = cursg->page;
+	page = sg_page(cursg);
 	offset = cursg->offset + hwif->cursg_ofs * SECTOR_SIZE;
 
 	/* get the current page and offset */
diff --git a/drivers/ide/mips/au1xxx-ide.c b/drivers/ide/mips/au1xxx-ide.c
index 47c035a..1b22ab7 100644
--- a/drivers/ide/mips/au1xxx-ide.c
+++ b/drivers/ide/mips/au1xxx-ide.c
@@ -276,7 +276,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 
 			if (iswrite) {
 				if(!put_source_flags(ahwif->tx_chan, 
-						     (void*)(page_address(sg->page) 
+						     (void*)(page_address(sg_page(sg)) 
 							     + sg->offset), 
 						     tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
@@ -285,7 +285,7 @@ static int auide_build_dmatable(ide_drive_t *drive)
 			} else 
 			{
 				if(!put_dest_flags(ahwif->rx_chan, 
-						   (void*)(page_address(sg->page) 
+						   (void*)(page_address(sg_page(sg)) 
 							   + sg->offset), 
 						   tc, flags)) { 
 					printk(KERN_ERR "%s failed %d\n", 
diff --git a/drivers/ieee1394/dma.c b/drivers/ieee1394/dma.c
index 45d6055..25e113b 100644
--- a/drivers/ieee1394/dma.c
+++ b/drivers/ieee1394/dma.c
@@ -111,7 +111,7 @@ int dma_region_alloc(struct dma_region *dma, unsigned long n_bytes,
 		unsigned long va =
 		    (unsigned long)dma->kvirt + (i << PAGE_SHIFT);
 
-		dma->sglist[i].page = vmalloc_to_page((void *)va);
+		sg_set_page(&dma->sglist[i], vmalloc_to_page((void *)va));
 		dma->sglist[i].length = PAGE_SIZE;
 	}
 
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index 1b353b9..d5dfe11 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -1466,7 +1466,7 @@ static void sbp2_prep_command_orb_sg(struct sbp2_command_orb *orb,
 		cmd->dma_size = sgpnt[0].length;
 		cmd->dma_type = CMD_DMA_PAGE;
 		cmd->cmd_dma = dma_map_page(hi->host->device.parent,
-					    sgpnt[0].page, sgpnt[0].offset,
+					    sg_page(&sgpnt[0]), sgpnt[0].offset,
 					    cmd->dma_size, cmd->dma_dir);
 
 		orb->data_descriptor_lo = cmd->cmd_dma;
diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 2f54e29..14159ff 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -55,9 +55,11 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 		ib_dma_unmap_sg(dev, chunk->page_list,
 				chunk->nents, DMA_BIDIRECTIONAL);
 		for (i = 0; i < chunk->nents; ++i) {
+			struct page *page = sg_page(&chunk->page_list[i]);
+
 			if (umem->writable && dirty)
-				set_page_dirty_lock(chunk->page_list[i].page);
-			put_page(chunk->page_list[i].page);
+				set_page_dirty_lock(page);
+			put_page(page);
 		}
 
 		kfree(chunk);
@@ -164,11 +166,12 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 			}
 
 			chunk->nents = min_t(int, ret, IB_UMEM_MAX_PAGE_CHUNK);
+			sg_init_table(chunk->page_list, chunk->nents);
 			for (i = 0; i < chunk->nents; ++i) {
 				if (vma_list &&
 				    !is_vm_hugetlb_page(vma_list[i + off]))
 					umem->hugetlb = 0;
-				chunk->page_list[i].page   = page_list[i + off];
+				sg_set_page(&chunk->page_list[i], page_list[i + off]);
 				chunk->page_list[i].offset = 0;
 				chunk->page_list[i].length = PAGE_SIZE;
 			}
@@ -179,7 +182,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 						    DMA_BIDIRECTIONAL);
 			if (chunk->nmap <= 0) {
 				for (i = 0; i < chunk->nents; ++i)
-					put_page(chunk->page_list[i].page);
+					put_page(sg_page(&chunk->page_list[i]));
 				kfree(chunk);
 
 				ret = -ENOMEM;
diff --git a/drivers/infiniband/hw/ipath/ipath_dma.c b/drivers/infiniband/hw/ipath/ipath_dma.c
index 22709a4..e90a0ea 100644
--- a/drivers/infiniband/hw/ipath/ipath_dma.c
+++ b/drivers/infiniband/hw/ipath/ipath_dma.c
@@ -108,7 +108,7 @@ static int ipath_map_sg(struct ib_device *dev, struct scatterlist *sgl,
 	BUG_ON(!valid_dma_direction(direction));
 
 	for_each_sg(sgl, sg, nents, i) {
-		addr = (u64) page_address(sg->page);
+		addr = (u64) page_address(sg_page(sg));
 		/* TODO: handle highmem pages */
 		if (!addr) {
 			ret = 0;
@@ -127,7 +127,7 @@ static void ipath_unmap_sg(struct ib_device *dev,
 
 static u64 ipath_sg_dma_address(struct ib_device *dev, struct scatterlist *sg)
 {
-	u64 addr = (u64) page_address(sg->page);
+	u64 addr = (u64) page_address(sg_page(sg));
 
 	if (addr)
 		addr += sg->offset;
diff --git a/drivers/infiniband/hw/ipath/ipath_mr.c b/drivers/infiniband/hw/ipath/ipath_mr.c
index e442470..db4ba92 100644
--- a/drivers/infiniband/hw/ipath/ipath_mr.c
+++ b/drivers/infiniband/hw/ipath/ipath_mr.c
@@ -225,7 +225,7 @@ struct ib_mr *ipath_reg_user_mr(struct ib_pd *pd, u64 start, u64 length,
 		for (i = 0; i < chunk->nents; i++) {
 			void *vaddr;
 
-			vaddr = page_address(chunk->page_list[i].page);
+			vaddr = page_address(sg_page(&chunk->page_list[i]));
 			if (!vaddr) {
 				ret = ERR_PTR(-EINVAL);
 				goto bail;
diff --git a/drivers/infiniband/hw/mthca/mthca_memfree.c b/drivers/infiniband/hw/mthca/mthca_memfree.c
index e61f3e6..007b381 100644
--- a/drivers/infiniband/hw/mthca/mthca_memfree.c
+++ b/drivers/infiniband/hw/mthca/mthca_memfree.c
@@ -71,7 +71,7 @@ static void mthca_free_icm_pages(struct mthca_dev *dev, struct mthca_icm_chunk *
 			     PCI_DMA_BIDIRECTIONAL);
 
 	for (i = 0; i < chunk->npages; ++i)
-		__free_pages(chunk->mem[i].page,
+		__free_pages(sg_page(&chunk->mem[i]),
 			     get_order(chunk->mem[i].length));
 }
 
@@ -81,7 +81,7 @@ static void mthca_free_icm_coherent(struct mthca_dev *dev, struct mthca_icm_chun
 
 	for (i = 0; i < chunk->npages; ++i) {
 		dma_free_coherent(&dev->pdev->dev, chunk->mem[i].length,
-				  lowmem_page_address(chunk->mem[i].page),
+				  lowmem_page_address(sg_page(&chunk->mem[i])),
 				  sg_dma_address(&chunk->mem[i]));
 	}
 }
@@ -107,10 +107,13 @@ void mthca_free_icm(struct mthca_dev *dev, struct mthca_icm *icm, int coherent)
 
 static int mthca_alloc_icm_pages(struct scatterlist *mem, int order, gfp_t gfp_mask)
 {
-	mem->page = alloc_pages(gfp_mask, order);
-	if (!mem->page)
+	struct page *page;
+
+	page = alloc_pages(gfp_mask, order);
+	if (!page)
 		return -ENOMEM;
 
+	sg_set_page(mem, page);
 	mem->length = PAGE_SIZE << order;
 	mem->offset = 0;
 	return 0;
@@ -157,6 +160,7 @@ struct mthca_icm *mthca_alloc_icm(struct mthca_dev *dev, int npages,
 			if (!chunk)
 				goto fail;
 
+			sg_init_table(chunk->mem, MTHCA_ICM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg    = 0;
 			list_add_tail(&chunk->list, &icm->chunk_list);
@@ -304,7 +308,7 @@ void *mthca_table_find(struct mthca_icm_table *table, int obj, dma_addr_t *dma_h
 			 * so if we found the page, dma_handle has already
 			 * been assigned to. */
 			if (chunk->mem[i].length > offset) {
-				page = chunk->mem[i].page;
+				page = sg_page(&chunk->mem[i]);
 				goto out;
 			}
 			offset -= chunk->mem[i].length;
@@ -445,6 +449,7 @@ static u64 mthca_uarc_virt(struct mthca_dev *dev, struct mthca_uar *uar, int pag
 int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		      struct mthca_user_db_table *db_tab, int index, u64 uaddr)
 {
+	struct page *pages[1];
 	int ret = 0;
 	u8 status;
 	int i;
@@ -472,16 +477,17 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 	}
 
 	ret = get_user_pages(current, current->mm, uaddr & PAGE_MASK, 1, 1, 0,
-			     &db_tab->page[i].mem.page, NULL);
+			     pages, NULL);
 	if (ret < 0)
 		goto out;
 
+	sg_set_page(&db_tab->page[i].mem, pages[0]);
 	db_tab->page[i].mem.length = MTHCA_ICM_PAGE_SIZE;
 	db_tab->page[i].mem.offset = uaddr & ~PAGE_MASK;
 
 	ret = pci_map_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
 	if (ret < 0) {
-		put_page(db_tab->page[i].mem.page);
+		put_page(pages[0]);
 		goto out;
 	}
 
@@ -491,7 +497,7 @@ int mthca_map_user_db(struct mthca_dev *dev, struct mthca_uar *uar,
 		ret = -EINVAL;
 	if (ret) {
 		pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-		put_page(db_tab->page[i].mem.page);
+		put_page(sg_page(&db_tab->page[i].mem));
 		goto out;
 	}
 
@@ -557,7 +563,7 @@ void mthca_cleanup_user_db_tab(struct mthca_dev *dev, struct mthca_uar *uar,
 		if (db_tab->page[i].uvirt) {
 			mthca_UNMAP_ICM(dev, mthca_uarc_virt(dev, uar, i), 1, &status);
 			pci_unmap_sg(dev->pdev, &db_tab->page[i].mem, 1, PCI_DMA_TODEVICE);
-			put_page(db_tab->page[i].mem.page);
+			put_page(sg_page(&db_tab->page[i].mem));
 		}
 	}
 
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index f3529b6..813b96b 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -131,7 +131,7 @@ static int iser_start_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 
 		p = mem;
 		for_each_sg(sgl, sg, data->size, i) {
-			from = kmap_atomic(sg->page, KM_USER0);
+			from = kmap_atomic(sg_page(sg), KM_USER0);
 			memcpy(p,
 			       from + sg->offset,
 			       sg->length);
@@ -191,7 +191,7 @@ void iser_finalize_rdma_unaligned_sg(struct iscsi_iser_cmd_task *iser_ctask,
 
 		p = mem;
 		for_each_sg(sgl, sg, sg_size, i) {
-			to = kmap_atomic(sg->page, KM_SOFTIRQ0);
+			to = kmap_atomic(sg_page(sg), KM_SOFTIRQ0);
 			memcpy(to + sg->offset,
 			       p,
 			       sg->length);
@@ -300,7 +300,7 @@ static unsigned int iser_data_buf_aligned_len(struct iser_data_buf *data,
 	for_each_sg(sgl, sg, data->dma_nents, i) {
 		/* iser_dbg("Checking sg iobuf [%d]: phys=0x%08lX "
 		   "offset: %ld sz: %ld\n", i,
-		   (unsigned long)page_to_phys(sg->page),
+		   (unsigned long)page_to_phys(sg_page(sg)),
 		   (unsigned long)sg->offset,
 		   (unsigned long)sg->length); */
 		end_addr = ib_sg_dma_address(ibdev, sg) +
@@ -336,7 +336,7 @@ static void iser_data_buf_dump(struct iser_data_buf *data,
 		iser_err("sg[%d] dma_addr:0x%lX page:0x%p "
 			 "off:0x%x sz:0x%x dma_len:0x%x\n",
 			 i, (unsigned long)ib_sg_dma_address(ibdev, sg),
-			 sg->page, sg->offset,
+			 sg_page(sg), sg->offset,
 			 sg->length, ib_sg_dma_len(ibdev, sg));
 }
 
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 64fee90..cde915f 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -346,16 +346,17 @@ static int crypt_convert(struct crypt_config *cc,
 	      ctx->idx_out < ctx->bio_out->bi_vcnt) {
 		struct bio_vec *bv_in = bio_iovec_idx(ctx->bio_in, ctx->idx_in);
 		struct bio_vec *bv_out = bio_iovec_idx(ctx->bio_out, ctx->idx_out);
-		struct scatterlist sg_in = {
-			.page = bv_in->bv_page,
-			.offset = bv_in->bv_offset + ctx->offset_in,
-			.length = 1 << SECTOR_SHIFT
-		};
-		struct scatterlist sg_out = {
-			.page = bv_out->bv_page,
-			.offset = bv_out->bv_offset + ctx->offset_out,
-			.length = 1 << SECTOR_SHIFT
-		};
+		struct scatterlist sg_in, sg_out;
+
+		sg_init_table(&sg_in, 1);
+		sg_set_page(&sg_in, bv_in->bv_page);
+		sg_in.offset = bv_in->bv_offset + ctx->offset_in;
+		sg_in.length = 1 << SECTOR_SHIFT;
+		
+		sg_init_table(&sg_out, 1);
+		sg_set_page(&sg_out, bv_out->bv_page);
+		sg_out.offset = bv_out->bv_offset + ctx->offset_out;
+		sg_out.length = 1 << SECTOR_SHIFT;
 
 		ctx->offset_in += sg_in.length;
 		if (ctx->offset_in >= bv_in->bv_len) {
diff --git a/drivers/media/common/saa7146_core.c b/drivers/media/common/saa7146_core.c
index 365a221..2b1f8b4 100644
--- a/drivers/media/common/saa7146_core.c
+++ b/drivers/media/common/saa7146_core.c
@@ -112,12 +112,13 @@ static struct scatterlist* vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	sglist = kcalloc(nr_pages, sizeof(struct scatterlist), GFP_KERNEL);
 	if (NULL == sglist)
 		return NULL;
+	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
 		if (NULL == pg)
 			goto err;
 		BUG_ON(PageHighMem(pg));
-		sglist[i].page   = pg;
+		sg_set_page(&sglist[i], pg);
 		sglist[i].length = PAGE_SIZE;
 	}
 	return sglist;
diff --git a/drivers/media/video/ivtv/ivtv-udma.c b/drivers/media/video/ivtv/ivtv-udma.c
index c4626d1..912b424 100644
--- a/drivers/media/video/ivtv/ivtv-udma.c
+++ b/drivers/media/video/ivtv/ivtv-udma.c
@@ -63,10 +63,10 @@ int ivtv_udma_fill_sg_list (struct ivtv_user_dma *dma, struct ivtv_dma_page_info
 			memcpy(page_address(dma->bouncemap[map_offset]) + offset, src, len);
 			kunmap_atomic(src, KM_BOUNCE_READ);
 			local_irq_restore(flags);
-			dma->SGlist[map_offset].page = dma->bouncemap[map_offset];
+			sg_set_page(&dma->SGlist[map_offset], dma->bouncemap[map_offset]);
 		}
 		else {
-			dma->SGlist[map_offset].page = dma->map[map_offset];
+			sg_set_page(&dma->SGlist[map_offset], dma->map[map_offset]);
 		}
 		offset = 0;
 		map_offset++;
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 3eb6123..0a18286 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -60,12 +60,13 @@ videobuf_vmalloc_to_sg(unsigned char *virt, int nr_pages)
 	sglist = kcalloc(nr_pages, sizeof(struct scatterlist), GFP_KERNEL);
 	if (NULL == sglist)
 		return NULL;
+	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
 		if (NULL == pg)
 			goto err;
 		BUG_ON(PageHighMem(pg));
-		sglist[i].page   = pg;
+		sg_set_page(&sglist[i], pg);
 		sglist[i].length = PAGE_SIZE;
 	}
 	return sglist;
@@ -86,13 +87,14 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 	sglist = kcalloc(nr_pages, sizeof(*sglist), GFP_KERNEL);
 	if (NULL == sglist)
 		return NULL;
+	sg_init_table(sglist, nr_pages);
 
 	if (NULL == pages[0])
 		goto nopage;
 	if (PageHighMem(pages[0]))
 		/* DMA to highmem pages might not work */
 		goto highmem;
-	sglist[0].page   = pages[0];
+	sg_set_page(&sglist[0], pages[0]);
 	sglist[0].offset = offset;
 	sglist[0].length = PAGE_SIZE - offset;
 	for (i = 1; i < nr_pages; i++) {
@@ -100,7 +102,7 @@ videobuf_pages_to_sg(struct page **pages, int nr_pages, int offset)
 			goto nopage;
 		if (PageHighMem(pages[i]))
 			goto highmem;
-		sglist[i].page   = pages[i];
+		sg_set_page(&sglist[i], pages[i]);
 		sglist[i].length = PAGE_SIZE;
 	}
 	return sglist;
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index a5d0354..68c1fe9 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -13,6 +13,7 @@
 #include <linux/blkdev.h>
 #include <linux/freezer.h>
 #include <linux/kthread.h>
+#include <linux/scatterlist.h>
 
 #include <linux/mmc/card.h>
 #include <linux/mmc/host.h>
@@ -153,19 +154,21 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 			blk_queue_max_hw_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_segment_size(mq->queue, bouncesz);
 
-			mq->sg = kzalloc(sizeof(struct scatterlist),
+			mq->sg = kmalloc(sizeof(struct scatterlist),
 				GFP_KERNEL);
 			if (!mq->sg) {
 				ret = -ENOMEM;
 				goto cleanup_queue;
 			}
+			sg_init_table(mq->sg, 1);
 
-			mq->bounce_sg = kzalloc(sizeof(struct scatterlist) *
+			mq->bounce_sg = kmalloc(sizeof(struct scatterlist) *
 				bouncesz / 512, GFP_KERNEL);
 			if (!mq->bounce_sg) {
 				ret = -ENOMEM;
 				goto cleanup_queue;
 			}
+			sg_init_table(mq->bounce_sg, bouncesz / 512);
 		}
 	}
 #endif
@@ -302,12 +305,12 @@ static void copy_sg(struct scatterlist *dst, unsigned int dst_len,
 		BUG_ON(dst_len == 0);
 
 		if (dst_size == 0) {
-			dst_buf = page_address(dst->page) + dst->offset;
+			dst_buf = page_address(sg_page(dst)) + dst->offset;
 			dst_size = dst->length;
 		}
 
 		if (src_size == 0) {
-			src_buf = page_address(src->page) + src->offset;
+			src_buf = page_address(sg_page(src)) + src->offset;
 			src_size = src->length;
 		}
 
@@ -353,9 +356,7 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq)
 		return 1;
 	}
 
-	mq->sg[0].page = virt_to_page(mq->bounce_buf);
-	mq->sg[0].offset = offset_in_page(mq->bounce_buf);
-	mq->sg[0].length = 0;
+	sg_init_one(mq->sg, mq->bounce_buf, 0);
 
 	while (sg_len) {
 		mq->sg[0].length += mq->bounce_sg[sg_len - 1].length;
diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
index 7a452c2..b1edcef 100644
--- a/drivers/mmc/host/at91_mci.c
+++ b/drivers/mmc/host/at91_mci.c
@@ -149,7 +149,7 @@ static inline void at91_mci_sg_to_dma(struct at91mci_host *host, struct mmc_data
 
 		sg = &data->sg[i];
 
-		sgbuffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
+		sgbuffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
 		amount = min(size, sg->length);
 		size -= amount;
 
@@ -226,7 +226,7 @@ static void at91_mci_pre_dma_read(struct at91mci_host *host)
 		sg = &data->sg[host->transfer_index++];
 		pr_debug("sg = %p\n", sg);
 
-		sg->dma_address = dma_map_page(NULL, sg->page, sg->offset, sg->length, DMA_FROM_DEVICE);
+		sg->dma_address = dma_map_page(NULL, sg_page(sg), sg->offset, sg->length, DMA_FROM_DEVICE);
 
 		pr_debug("dma address = %08X, length = %d\n", sg->dma_address, sg->length);
 
@@ -283,7 +283,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 			int index;
 
 			/* Swap the contents of the buffer */
-			buffer = kmap_atomic(sg->page, KM_BIO_SRC_IRQ) + sg->offset;
+			buffer = kmap_atomic(sg_page(sg), KM_BIO_SRC_IRQ) + sg->offset;
 			pr_debug("buffer = %p, length = %d\n", buffer, sg->length);
 
 			for (index = 0; index < (sg->length / 4); index++)
@@ -292,7 +292,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
 			kunmap_atomic(buffer, KM_BIO_SRC_IRQ);
 		}
 
-		flush_dcache_page(sg->page);
+		flush_dcache_page(sg_page(sg));
 	}
 
 	/* Is there another transfer to trigger? */
diff --git a/drivers/mmc/host/au1xmmc.c b/drivers/mmc/host/au1xmmc.c
index 92c4d0d..0632f4d 100644
--- a/drivers/mmc/host/au1xmmc.c
+++ b/drivers/mmc/host/au1xmmc.c
@@ -340,7 +340,7 @@ static void au1xmmc_send_pio(struct au1xmmc_host *host)
 
 	/* This is the pointer to the data buffer */
 	sg = &data->sg[host->pio.index];
-	sg_ptr = page_address(sg->page) + sg->offset + host->pio.offset;
+	sg_ptr = page_address(sg_page(sg)) + sg->offset + host->pio.offset;
 
 	/* This is the space left inside the buffer */
 	sg_len = data->sg[host->pio.index].length - host->pio.offset;
@@ -400,7 +400,7 @@ static void au1xmmc_receive_pio(struct au1xmmc_host *host)
 
 	if (host->pio.index < host->dma.len) {
 		sg = &data->sg[host->pio.index];
-		sg_ptr = page_address(sg->page) + sg->offset + host->pio.offset;
+		sg_ptr = page_address(sg_page(sg)) + sg->offset + host->pio.offset;
 
 		/* This is the space left inside the buffer */
 		sg_len = sg_dma_len(&data->sg[host->pio.index]) - host->pio.offset;
@@ -613,13 +613,13 @@ au1xmmc_prepare_data(struct au1xmmc_host *host, struct mmc_data *data)
 
     			if (host->flags & HOST_F_XMIT){
       				ret = au1xxx_dbdma_put_source_flags(channel,
-					(void *) (page_address(sg->page) +
+					(void *) (page_address(sg_page(sg)) +
 						  sg->offset),
 					len, flags);
 			}
     			else {
       				ret = au1xxx_dbdma_put_dest_flags(channel,
-					(void *) (page_address(sg->page) +
+					(void *) (page_address(sg_page(sg)) +
 						  sg->offset),
 					len, flags);
 			}
diff --git a/drivers/mmc/host/imxmmc.c b/drivers/mmc/host/imxmmc.c
index 6ebc41e..581bb8f 100644
--- a/drivers/mmc/host/imxmmc.c
+++ b/drivers/mmc/host/imxmmc.c
@@ -262,7 +262,7 @@ static void imxmci_setup_data(struct imxmci_host *host, struct mmc_data *data)
 		}
 
 		/* Convert back to virtual address */
-		host->data_ptr = (u16*)(page_address(data->sg->page) + data->sg->offset);
+		host->data_ptr = (u16*)(page_address(sg_page(data->sg)) + data->sg->offset);
 		host->data_cnt = 0;
 
 		clear_bit(IMXMCI_PEND_DMA_DATA_b, &host->pending_events);
diff --git a/drivers/mmc/host/mmc_spi.c b/drivers/mmc/host/mmc_spi.c
index 7ae18ea..12c2d80 100644
--- a/drivers/mmc/host/mmc_spi.c
+++ b/drivers/mmc/host/mmc_spi.c
@@ -813,7 +813,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 					&& dir == DMA_FROM_DEVICE)
 				dir = DMA_BIDIRECTIONAL;
 
-			dma_addr = dma_map_page(dma_dev, sg->page, 0,
+			dma_addr = dma_map_page(dma_dev, sg_page(sg), 0,
 						PAGE_SIZE, dir);
 			if (direction == DMA_TO_DEVICE)
 				t->tx_dma = dma_addr + sg->offset;
@@ -822,7 +822,7 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 		}
 
 		/* allow pio too; we don't allow highmem */
-		kmap_addr = kmap(sg->page);
+		kmap_addr = kmap(sg_page(sg));
 		if (direction == DMA_TO_DEVICE)
 			t->tx_buf = kmap_addr + sg->offset;
 		else
@@ -855,8 +855,8 @@ mmc_spi_data_do(struct mmc_spi_host *host, struct mmc_command *cmd,
 
 		/* discard mappings */
 		if (direction == DMA_FROM_DEVICE)
-			flush_kernel_dcache_page(sg->page);
-		kunmap(sg->page);
+			flush_kernel_dcache_page(sg_page(sg));
+		kunmap(sg_page(sg));
 		if (dma_dev)
 			dma_unmap_page(dma_dev, dma_addr, PAGE_SIZE, dir);
 
diff --git a/drivers/mmc/host/omap.c b/drivers/mmc/host/omap.c
index 60a67df..649f647 100644
--- a/drivers/mmc/host/omap.c
+++ b/drivers/mmc/host/omap.c
@@ -24,10 +24,10 @@
 #include <linux/mmc/host.h>
 #include <linux/mmc/card.h>
 #include <linux/clk.h>
+#include <linux/scatterlist.h>
 
 #include <asm/io.h>
 #include <asm/irq.h>
-#include <asm/scatterlist.h>
 #include <asm/mach-types.h>
 
 #include <asm/arch/board.h>
@@ -383,7 +383,7 @@ mmc_omap_sg_to_buf(struct mmc_omap_host *host)
 
 	sg = host->data->sg + host->sg_idx;
 	host->buffer_bytes_left = sg->length;
-	host->buffer = page_address(sg->page) + sg->offset;
+	host->buffer = page_address(sg_page(sg)) + sg->offset;
 	if (host->buffer_bytes_left > host->total_bytes_left)
 		host->buffer_bytes_left = host->total_bytes_left;
 }
diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index b397121..b6500e9 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -231,7 +231,7 @@ static void sdhci_deactivate_led(struct sdhci_host *host)
 
 static inline char* sdhci_sg_to_buffer(struct sdhci_host* host)
 {
-	return page_address(host->cur_sg->page) + host->cur_sg->offset;
+	return page_address(sg_page(host->cur_sg)) + host->cur_sg->offset;
 }
 
 static inline int sdhci_next_sg(struct sdhci_host* host)
diff --git a/drivers/mmc/host/tifm_sd.c b/drivers/mmc/host/tifm_sd.c
index 9b90479..c11a3d2 100644
--- a/drivers/mmc/host/tifm_sd.c
+++ b/drivers/mmc/host/tifm_sd.c
@@ -192,7 +192,7 @@ static void tifm_sd_transfer_data(struct tifm_sd *host)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg[host->sg_pos].page, off >> PAGE_SHIFT);
+		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
@@ -241,18 +241,18 @@ static void tifm_sd_bounce_block(struct tifm_sd *host, struct mmc_data *r_data)
 		}
 		off = sg[host->sg_pos].offset + host->block_pos;
 
-		pg = nth_page(sg[host->sg_pos].page, off >> PAGE_SHIFT);
+		pg = nth_page(sg_page(&sg[host->sg_pos]), off >> PAGE_SHIFT);
 		p_off = offset_in_page(off);
 		p_cnt = PAGE_SIZE - p_off;
 		p_cnt = min(p_cnt, cnt);
 		p_cnt = min(p_cnt, t_size);
 
 		if (r_data->flags & MMC_DATA_WRITE)
-			tifm_sd_copy_page(host->bounce_buf.page,
+			tifm_sd_copy_page(sg_page(&host->bounce_buf),
 					  r_data->blksz - t_size,
 					  pg, p_off, p_cnt);
 		else if (r_data->flags & MMC_DATA_READ)
-			tifm_sd_copy_page(pg, p_off, host->bounce_buf.page,
+			tifm_sd_copy_page(pg, p_off, sg_page(&host->bounce_buf),
 					  r_data->blksz - t_size, p_cnt);
 
 		t_size -= p_cnt;
diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
index 80db11c..971ca0f 100644
--- a/drivers/mmc/host/wbsd.c
+++ b/drivers/mmc/host/wbsd.c
@@ -269,7 +269,7 @@ static inline int wbsd_next_sg(struct wbsd_host *host)
 
 static inline char *wbsd_sg_to_buffer(struct wbsd_host *host)
 {
-	return page_address(host->cur_sg->page) + host->cur_sg->offset;
+	return page_address(sg_page(host->cur_sg)) + host->cur_sg->offset;
 }
 
 static inline void wbsd_sg_to_dma(struct wbsd_host *host, struct mmc_data *data)
@@ -283,7 +283,7 @@ static inline void wbsd_sg_to_dma(struct wbsd_host *host, struct mmc_data *data)
 	len = data->sg_len;
 
 	for (i = 0; i < len; i++) {
-		sgbuf = page_address(sg[i].page) + sg[i].offset;
+		sgbuf = page_address(sg_page(&sg[i])) + sg[i].offset;
 		memcpy(dmabuf, sgbuf, sg[i].length);
 		dmabuf += sg[i].length;
 	}
@@ -300,7 +300,7 @@ static inline void wbsd_dma_to_sg(struct wbsd_host *host, struct mmc_data *data)
 	len = data->sg_len;
 
 	for (i = 0; i < len; i++) {
-		sgbuf = page_address(sg[i].page) + sg[i].offset;
+		sgbuf = page_address(sg_page(&sg[i])) + sg[i].offset;
 		memcpy(sgbuf, dmabuf, sg[i].length);
 		dmabuf += sg[i].length;
 	}
diff --git a/drivers/net/mlx4/icm.c b/drivers/net/mlx4/icm.c
index 4b3c109..887633b 100644
--- a/drivers/net/mlx4/icm.c
+++ b/drivers/net/mlx4/icm.c
@@ -60,7 +60,7 @@ static void mlx4_free_icm_pages(struct mlx4_dev *dev, struct mlx4_icm_chunk *chu
 			     PCI_DMA_BIDIRECTIONAL);
 
 	for (i = 0; i < chunk->npages; ++i)
-		__free_pages(chunk->mem[i].page,
+		__free_pages(sg_page(&chunk->mem[i]),
 			     get_order(chunk->mem[i].length));
 }
 
@@ -70,7 +70,7 @@ static void mlx4_free_icm_coherent(struct mlx4_dev *dev, struct mlx4_icm_chunk *
 
 	for (i = 0; i < chunk->npages; ++i)
 		dma_free_coherent(&dev->pdev->dev, chunk->mem[i].length,
-				  lowmem_page_address(chunk->mem[i].page),
+				  lowmem_page_address(sg_page(&chunk->mem[i])),
 				  sg_dma_address(&chunk->mem[i]));
 }
 
@@ -95,10 +95,13 @@ void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm, int coherent)
 
 static int mlx4_alloc_icm_pages(struct scatterlist *mem, int order, gfp_t gfp_mask)
 {
-	mem->page = alloc_pages(gfp_mask, order);
-	if (!mem->page)
+	struct page *page;
+
+	page = alloc_pages(gfp_mask, order);
+	if (!page)
 		return -ENOMEM;
 
+	sg_set_page(mem, page);
 	mem->length = PAGE_SIZE << order;
 	mem->offset = 0;
 	return 0;
@@ -145,6 +148,7 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 			if (!chunk)
 				goto fail;
 
+			sg_init_table(chunk->mem, MLX4_ICM_CHUNK_LEN);
 			chunk->npages = 0;
 			chunk->nsg    = 0;
 			list_add_tail(&chunk->list, &icm->chunk_list);
@@ -334,7 +338,7 @@ void *mlx4_table_find(struct mlx4_icm_table *table, int obj, dma_addr_t *dma_han
 			 * been assigned to.
 			 */
 			if (chunk->mem[i].length > offset) {
-				page = chunk->mem[i].page;
+				page = sg_page(&chunk->mem[i]);
 				goto out;
 			}
 			offset -= chunk->mem[i].length;
diff --git a/drivers/net/ppp_mppe.c b/drivers/net/ppp_mppe.c
index c0b6d19..bcb0885 100644
--- a/drivers/net/ppp_mppe.c
+++ b/drivers/net/ppp_mppe.c
@@ -55,7 +55,7 @@
 #include <linux/mm.h>
 #include <linux/ppp_defs.h>
 #include <linux/ppp-comp.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 #include "ppp_mppe.h"
 
@@ -68,9 +68,7 @@ MODULE_VERSION("1.0.2");
 static unsigned int
 setup_sg(struct scatterlist *sg, const void *address, unsigned int length)
 {
-	sg[0].page = virt_to_page(address);
-	sg[0].offset = offset_in_page(address);
-	sg[0].length = length;
+	sg_init_one(sg, address, length);
 	return length;
 }
 
diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index fb14014..afb262b 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -1840,7 +1840,7 @@ static int twa_scsiop_execute_scsi(TW_Device_Extension *tw_dev, int request_id,
 			    (scsi_bufflen(srb) < TW_MIN_SGL_LENGTH)) {
 				if (srb->sc_data_direction == DMA_TO_DEVICE || srb->sc_data_direction == DMA_BIDIRECTIONAL) {
 					struct scatterlist *sg = scsi_sglist(srb);
-					char *buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+					char *buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 					memcpy(tw_dev->generic_buffer_virt[request_id], buf, sg->length);
 					kunmap_atomic(buf - sg->offset, KM_IRQ0);
 				}
@@ -1919,7 +1919,7 @@ static void twa_scsiop_execute_scsi_complete(TW_Device_Extension *tw_dev, int re
 			char *buf;
 			unsigned long flags = 0;
 			local_irq_save(flags);
-			buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 			memcpy(buf, tw_dev->generic_buffer_virt[request_id], sg->length);
 			kunmap_atomic(buf - sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index a64153b..59716eb 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -1469,7 +1469,7 @@ static void tw_transfer_internal(TW_Device_Extension *tw_dev, int request_id,
 	struct scatterlist *sg = scsi_sglist(cmd);
 
 	local_irq_save(flags);
-	buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 	transfer_len = min(sg->length, len);
 
 	memcpy(buf, data, transfer_len);
diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 988f0bc..7a76b4b 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -298,7 +298,7 @@ static __inline__ void initialize_SCp(Scsi_Cmnd * cmd)
 	if (cmd->use_sg) {
 		cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 		cmd->SCp.buffers_residual = cmd->use_sg - 1;
-		cmd->SCp.ptr = page_address(cmd->SCp.buffer->page)+
+		cmd->SCp.ptr = page_address(sg_page(cmd->SCp.buffer))+
 			       cmd->SCp.buffer->offset;
 		cmd->SCp.this_residual = cmd->SCp.buffer->length;
 	} else {
@@ -2143,7 +2143,7 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 					++cmd->SCp.buffer;
 					--cmd->SCp.buffers_residual;
 					cmd->SCp.this_residual = cmd->SCp.buffer->length;
-					cmd->SCp.ptr = page_address(cmd->SCp.buffer->page)+
+					cmd->SCp.ptr = page_address(sg_page(cmd->SCp.buffer))+
 						       cmd->SCp.buffer->offset;
 					dprintk(NDEBUG_INFORMATION, ("scsi%d : %d bytes and %d buffers left\n", instance->host_no, cmd->SCp.this_residual, cmd->SCp.buffers_residual));
 				}
diff --git a/drivers/scsi/NCR53c406a.c b/drivers/scsi/NCR53c406a.c
index 3168a17..db1a8bc 100644
--- a/drivers/scsi/NCR53c406a.c
+++ b/drivers/scsi/NCR53c406a.c
@@ -875,7 +875,7 @@ static void NCR53c406a_intr(void *dev_id)
 			outb(TRANSFER_INFO | DMA_OP, CMD_REG);
 #if USE_PIO
                         scsi_for_each_sg(current_SC, sg, scsi_sg_count(current_SC), i) {
-                                NCR53c406a_pio_write(page_address(sg->page) + sg->offset,
+                                NCR53c406a_pio_write(page_address(sg_page(sg)) + sg->offset,
                                                      sg->length);
                         }
 			REG0;
@@ -897,7 +897,7 @@ static void NCR53c406a_intr(void *dev_id)
 			outb(TRANSFER_INFO | DMA_OP, CMD_REG);
 #if USE_PIO
                         scsi_for_each_sg(current_SC, sg, scsi_sg_count(current_SC), i) {
-                                NCR53c406a_pio_read(page_address(sg->page) + sg->offset,
+                                NCR53c406a_pio_read(page_address(sg_page(sg)) + sg->offset,
                                                     sg->length);
                         }
 			REG0;
diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 80e448d..a77ab8d 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -356,7 +356,7 @@ static void aac_internal_transfer(struct scsi_cmnd *scsicmd, void *data, unsigne
 	int transfer_len;
 	struct scatterlist *sg = scsi_sglist(scsicmd);
 
-	buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 	transfer_len = min(sg->length, len + offset);
 
 	transfer_len -= offset;
diff --git a/drivers/scsi/aha1542.c b/drivers/scsi/aha1542.c
index 961a188..50da0a3 100644
--- a/drivers/scsi/aha1542.c
+++ b/drivers/scsi/aha1542.c
@@ -49,7 +49,7 @@
 #include "aha1542.h"
 
 #define SCSI_BUF_PA(address)	isa_virt_to_bus(address)
-#define SCSI_SG_PA(sgent)	(isa_page_to_bus((sgent)->page) + (sgent)->offset)
+#define SCSI_SG_PA(sgent)	(isa_page_to_bus(sg_page((sgent))) + (sgent)->offset)
 
 static void BAD_DMA(void *address, unsigned int length)
 {
@@ -67,7 +67,7 @@ static void BAD_SG_DMA(Scsi_Cmnd * SCpnt,
 {
 	printk(KERN_CRIT "sgpnt[%d:%d] page %p/0x%llx length %u\n",
 	       badseg, nseg,
-	       page_address(sgp->page) + sgp->offset,
+	       page_address(sg_page(sgp)) + sgp->offset,
 	       (unsigned long long)SCSI_SG_PA(sgp),
 	       sgp->length);
 
@@ -712,7 +712,7 @@ static int aha1542_queuecommand(Scsi_Cmnd * SCpnt, void (*done) (Scsi_Cmnd *))
 				printk(KERN_CRIT "Bad segment list supplied to aha1542.c (%d, %d)\n", SCpnt->use_sg, i);
 				scsi_for_each_sg(SCpnt, sg, SCpnt->use_sg, i) {
 					printk(KERN_CRIT "%d: %p %d\n", i,
-					       (page_address(sg->page) +
+					       (page_address(sg_page(sg)) +
 						sg->offset), sg->length);
 				};
 				printk(KERN_CRIT "cptr %x: ", (unsigned int) cptr);
diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index f817775..f7a2528 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -1343,7 +1343,7 @@ static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, \
 						/* 4 bytes: Areca io control code */
 
 	sg = scsi_sglist(cmd);
-	buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+	buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 	if (scsi_sg_count(cmd) > 1) {
 		retvalue = ARCMSR_MESSAGE_FAIL;
 		goto message_out;
@@ -1593,7 +1593,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
 
 		sg = scsi_sglist(cmd);
-		buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+		buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 
 		memcpy(buffer, inqdata, sizeof(inqdata));
 		sg = scsi_sglist(cmd);
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 5d282e6..dc4e463 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1321,7 +1321,7 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 	    if (current_SC->SCp.buffers_residual) {
 	       --current_SC->SCp.buffers_residual;
 	       ++current_SC->SCp.buffer;
-	       current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
+	       current_SC->SCp.ptr = page_address(sg_page(current_SC->SCp.buffer)) + current_SC->SCp.buffer->offset;
 	       current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
 	    } else
 		  break;
@@ -1354,7 +1354,7 @@ static irqreturn_t do_fdomain_16x0_intr(int irq, void *dev_id)
 	     && current_SC->SCp.buffers_residual) {
 	    --current_SC->SCp.buffers_residual;
 	    ++current_SC->SCp.buffer;
-	    current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page) + current_SC->SCp.buffer->offset;
+	    current_SC->SCp.ptr = page_address(sg_page(current_SC->SCp.buffer)) + current_SC->SCp.buffer->offset;
 	    current_SC->SCp.this_residual = current_SC->SCp.buffer->length;
 	 }
       }
@@ -1439,7 +1439,7 @@ static int fdomain_16x0_queue(struct scsi_cmnd *SCpnt,
 
    if (scsi_sg_count(current_SC)) {
 	   current_SC->SCp.buffer = scsi_sglist(current_SC);
-	   current_SC->SCp.ptr = page_address(current_SC->SCp.buffer->page)
+	   current_SC->SCp.ptr = page_address(sg_page(current_SC->SCp.buffer))
 		   + current_SC->SCp.buffer->offset;
 	   current_SC->SCp.this_residual    = current_SC->SCp.buffer->length;
 	   current_SC->SCp.buffers_residual = scsi_sg_count(current_SC) - 1;
diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index 3ac080e..ac6c57a 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -2374,13 +2374,13 @@ static void gdth_copy_internal_data(gdth_ha_str *ha, Scsi_Cmnd *scp,
             if (cpsum+cpnow > cpcount) 
                 cpnow = cpcount - cpsum;
             cpsum += cpnow;
-            if (!sl->page) {
+            if (!sg_page(sl)) {
                 printk("GDT-HA %d: invalid sc/gt element in gdth_copy_internal_data()\n",
                        ha->hanum);
                 return;
             }
             local_irq_save(flags);
-            address = kmap_atomic(sl->page, KM_BIO_SRC_IRQ) + sl->offset;
+            address = kmap_atomic(sg_page(sl), KM_BIO_SRC_IRQ) + sl->offset;
             if (to_buffer)
                 memcpy(buffer, address, cpnow);
             else
diff --git a/drivers/scsi/ibmmca.c b/drivers/scsi/ibmmca.c
index 714e627..db004a4 100644
--- a/drivers/scsi/ibmmca.c
+++ b/drivers/scsi/ibmmca.c
@@ -1828,7 +1828,7 @@ static int ibmmca_queuecommand(Scsi_Cmnd * cmd, void (*done) (Scsi_Cmnd *))
 		BUG_ON(scsi_sg_count(cmd) > 16);
 
 		scsi_for_each_sg(cmd, sg, scsi_sg_count(cmd), i) {
-			ld(shpnt)[ldn].sge[i].address = (void *) (isa_page_to_bus(sg->page) + sg->offset);
+			ld(shpnt)[ldn].sge[i].address = (void *) (isa_page_to_bus(sg_page(sg)) + sg->offset);
 			ld(shpnt)[ldn].sge[i].byte_length = sg->length;
 		}
 		scb->enable |= IM_POINTER_TO_LIST;
diff --git a/drivers/scsi/ide-scsi.c b/drivers/scsi/ide-scsi.c
index fa7ba64..2c7dd8b 100644
--- a/drivers/scsi/ide-scsi.c
+++ b/drivers/scsi/ide-scsi.c
@@ -175,18 +175,18 @@ static void idescsi_input_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsigne
 
 	while (bcount) {
 		count = min(pc->sg->length - pc->b_count, bcount);
-		if (PageHighMem(pc->sg->page)) {
+		if (PageHighMem(sg_page(pc->sg))) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pc->sg->page, KM_IRQ0) +
+			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 					pc->sg->offset;
 			drive->hwif->atapi_input_bytes(drive,
 						buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
-			buf = page_address(pc->sg->page) + pc->sg->offset;
+			buf = page_address(sg_page(pc->sg)) + pc->sg->offset;
 			drive->hwif->atapi_input_bytes(drive,
 						buf + pc->b_count, count);
 		}
@@ -212,18 +212,18 @@ static void idescsi_output_buffers (ide_drive_t *drive, idescsi_pc_t *pc, unsign
 
 	while (bcount) {
 		count = min(pc->sg->length - pc->b_count, bcount);
-		if (PageHighMem(pc->sg->page)) {
+		if (PageHighMem(sg_page(pc->sg))) {
 			unsigned long flags;
 
 			local_irq_save(flags);
-			buf = kmap_atomic(pc->sg->page, KM_IRQ0) +
+			buf = kmap_atomic(sg_page(pc->sg), KM_IRQ0) +
 						pc->sg->offset;
 			drive->hwif->atapi_output_bytes(drive,
 						buf + pc->b_count, count);
 			kunmap_atomic(buf - pc->sg->offset, KM_IRQ0);
 			local_irq_restore(flags);
 		} else {
-			buf = page_address(pc->sg->page) + pc->sg->offset;
+			buf = page_address(sg_page(pc->sg)) + pc->sg->offset;
 			drive->hwif->atapi_output_bytes(drive,
 						buf + pc->b_count, count);
 		}
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 74cdc1f..da9b0ba 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -706,7 +706,7 @@ static int imm_completion(struct scsi_cmnd *cmd)
 				cmd->SCp.this_residual =
 				    cmd->SCp.buffer->length;
 				cmd->SCp.ptr =
-				    page_address(cmd->SCp.buffer->page) +
+				    page_address(sg_page(cmd->SCp.buffer)) +
 				    cmd->SCp.buffer->offset;
 
 				/*
@@ -845,7 +845,7 @@ static int imm_engine(imm_struct *dev, struct scsi_cmnd *cmd)
 			    (struct scatterlist *) cmd->request_buffer;
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
 			cmd->SCp.ptr =
-			    page_address(cmd->SCp.buffer->page) +
+			    page_address(sg_page(cmd->SCp.buffer)) +
 			    cmd->SCp.buffer->offset;
 		} else {
 			/* else fill the only available buffer */
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index b41dfb5..dc98a85 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -2872,6 +2872,7 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
 	}
 
 	scatterlist = sglist->scatterlist;
+	sg_init_table(scatterlist, num_elem);
 
 	sglist->order = order;
 	sglist->num_sg = num_elem;
@@ -2884,12 +2885,12 @@ static struct ipr_sglist *ipr_alloc_ucode_buffer(int buf_len)
 
 			/* Free up what we already allocated */
 			for (j = i - 1; j >= 0; j--)
-				__free_pages(scatterlist[j].page, order);
+				__free_pages(sg_page(&scatterlist[j]), order);
 			kfree(sglist);
 			return NULL;
 		}
 
-		scatterlist[i].page = page;
+		sg_set_page(&scatterlist[i], page);
 	}
 
 	return sglist;
@@ -2910,7 +2911,7 @@ static void ipr_free_ucode_buffer(struct ipr_sglist *sglist)
 	int i;
 
 	for (i = 0; i < sglist->num_sg; i++)
-		__free_pages(sglist->scatterlist[i].page, sglist->order);
+		__free_pages(sg_page(&sglist->scatterlist[i]), sglist->order);
 
 	kfree(sglist);
 }
@@ -2940,9 +2941,11 @@ static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 	scatterlist = sglist->scatterlist;
 
 	for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
-		kaddr = kmap(scatterlist[i].page);
+		struct page *page = sg_page(&scatterlist[i]);
+
+		kaddr = kmap(page);
 		memcpy(kaddr, buffer, bsize_elem);
-		kunmap(scatterlist[i].page);
+		kunmap(page);
 
 		scatterlist[i].length = bsize_elem;
 
@@ -2953,9 +2956,11 @@ static int ipr_copy_ucode_buffer(struct ipr_sglist *sglist,
 	}
 
 	if (len % bsize_elem) {
-		kaddr = kmap(scatterlist[i].page);
+		struct page *page = sg_page(&scatterlist[i]);
+
+		kaddr = kmap(page);
 		memcpy(kaddr, buffer, len % bsize_elem);
-		kunmap(scatterlist[i].page);
+		kunmap(page);
 
 		scatterlist[i].length = len % bsize_elem;
 	}
diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index edaac27..5c5a9b2 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -1515,7 +1515,7 @@ static int ips_is_passthru(struct scsi_cmnd *SC)
                 /* kmap_atomic() ensures addressability of the user buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+                buffer = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
                 if (buffer && buffer[0] == 'C' && buffer[1] == 'O' &&
                     buffer[2] == 'P' && buffer[3] == 'P') {
                         kunmap_atomic(buffer - sg->offset, KM_IRQ0);
@@ -3523,7 +3523,7 @@ ips_scmd_buf_write(struct scsi_cmnd *scmd, void *data, unsigned int count)
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
                 memcpy(buffer, &cdata[xfer_cnt], min_cnt);
                 kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
                 local_irq_restore(flags);
@@ -3556,7 +3556,7 @@ ips_scmd_buf_read(struct scsi_cmnd *scmd, void *data, unsigned int count)
                 /* kmap_atomic() ensures addressability of the data buffer.*/
                 /* local_irq_save() protects the KM_IRQ0 address slot.     */
                 local_irq_save(flags);
-                buffer = kmap_atomic(sg[i].page, KM_IRQ0) + sg[i].offset;
+                buffer = kmap_atomic(sg_page(&sg[i]), KM_IRQ0) + sg[i].offset;
                 memcpy(&cdata[xfer_cnt], buffer, min_cnt);
                 kunmap_atomic(buffer - sg[i].offset, KM_IRQ0);
                 local_irq_restore(flags);
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index a21455d..6ce4109 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -70,9 +70,7 @@ module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 static inline void
 iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 {
-	ibuf->sg.page = virt_to_page(vbuf);
-	ibuf->sg.offset = offset_in_page(vbuf);
-	ibuf->sg.length = size;
+	sg_init_one(&ibuf->sg, vbuf, size);
 	ibuf->sent = 0;
 	ibuf->use_sendmsg = 1;
 }
@@ -80,13 +78,14 @@ iscsi_buf_init_iov(struct iscsi_buf *ibuf, char *vbuf, int size)
 static inline void
 iscsi_buf_init_sg(struct iscsi_buf *ibuf, struct scatterlist *sg)
 {
-	ibuf->sg.page = sg->page;
+	sg_init_table(&ibuf->sg, 1);
+	sg_set_page(&ibuf->sg, sg_page(sg));
 	ibuf->sg.offset = sg->offset;
 	ibuf->sg.length = sg->length;
 	/*
 	 * Fastpath: sg element fits into single page
 	 */
-	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg->page))
+	if (sg->length + sg->offset <= PAGE_SIZE && !PageSlab(sg_page(sg)))
 		ibuf->use_sendmsg = 0;
 	else
 		ibuf->use_sendmsg = 1;
@@ -716,7 +715,7 @@ static int iscsi_scsi_data_in(struct iscsi_conn *conn)
 	for (i = tcp_ctask->sg_count; i < scsi_sg_count(sc); i++) {
 		char *dest;
 
-		dest = kmap_atomic(sg[i].page, KM_SOFTIRQ0);
+		dest = kmap_atomic(sg_page(&sg[i]), KM_SOFTIRQ0);
 		rc = iscsi_ctask_copy(tcp_conn, ctask, dest + sg[i].offset,
 				      sg[i].length, offset);
 		kunmap_atomic(dest, KM_SOFTIRQ0);
@@ -1103,9 +1102,9 @@ iscsi_send(struct iscsi_conn *conn, struct iscsi_buf *buf, int size, int flags)
 	 * slab case.
 	 */
 	if (buf->use_sendmsg)
-		res = sock_no_sendpage(sk, buf->sg.page, offset, size, flags);
+		res = sock_no_sendpage(sk, sg_page(&buf->sg), offset, size, flags);
 	else
-		res = tcp_conn->sendpage(sk, buf->sg.page, offset, size, flags);
+		res = tcp_conn->sendpage(sk, sg_page(&buf->sg), offset, size, flags);
 
 	if (res >= 0) {
 		conn->txdata_octets += res;
diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 10d1aff..0a848e8 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -658,7 +658,7 @@ mega_build_cmd(adapter_t *adapter, Scsi_Cmnd *cmd, int *busy)
 			struct scatterlist *sg;
 
 			sg = scsi_sglist(cmd);
-			buf = kmap_atomic(sg->page, KM_IRQ0) + sg->offset;
+			buf = kmap_atomic(sg_page(sg), KM_IRQ0) + sg->offset;
 
 			memset(buf, 0, cmd->cmnd[4]);
 			kunmap_atomic(buf - sg->offset, KM_IRQ0);
@@ -1542,9 +1542,9 @@ mega_cmd_done(adapter_t *adapter, u8 completed[], int nstatus, int status)
 		if( cmd->cmnd[0] == INQUIRY && !islogical ) {
 
 			sgl = scsi_sglist(cmd);
-			if( sgl->page ) {
+			if( sg_page(sgl) ) {
 				c = *(unsigned char *)
-					page_address((&sgl[0])->page) +
+					page_address((sg_page(&sgl[0]))) +
 					(&sgl[0])->offset; 
 			} else {
 				printk(KERN_WARNING
diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index e4e4c6a..376263c 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1584,9 +1584,9 @@ megaraid_mbox_build_cmd(adapter_t *adapter, struct scsi_cmnd *scp, int *busy)
 			caddr_t			vaddr;
 
 			sgl = scsi_sglist(scp);
-			if (sgl->page) {
+			if (sg_page(sgl)) {
 				vaddr = (caddr_t)
-					(page_address((&sgl[0])->page)
+					(page_address(sg_page(&sgl[0]))
 					 + (&sgl[0])->offset);
 
 				memset(vaddr, 0, scp->cmnd[4]);
@@ -2328,9 +2328,9 @@ megaraid_mbox_dpc(unsigned long devp)
 				&& IS_RAID_CH(raid_dev, scb->dev_channel)) {
 
 			sgl = scsi_sglist(scp);
-			if (sgl->page) {
+			if (sg_page(sgl)) {
 				c = *(unsigned char *)
-					(page_address((&sgl[0])->page) +
+					(page_address(sg_page(&sgl[0])) +
 					 (&sgl[0])->offset);
 			} else {
 				con_log(CL_ANN, (KERN_WARNING
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 331b789..1c5c4b6 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -542,7 +542,7 @@ static int osst_verify_frame(struct osst_tape * STp, int frame_seq_number, int q
 	if (STp->raw) {
 		if (STp->buffer->syscall_result) {
 			for (i=0; i < STp->buffer->sg_segs; i++)
-				memset(page_address(STp->buffer->sg[i].page),
+				memset(page_address(sg_page(&STp->buffer->sg[i])),
 				       0, STp->buffer->sg[i].length);
 			strcpy(STp->buffer->b_data, "READ ERROR ON FRAME");
                 } else
@@ -4437,7 +4437,7 @@ static int os_scsi_tape_open(struct inode * inode, struct file * filp)
 		for (i = 0, b_size = 0; 
 		     (i < STp->buffer->sg_segs) && ((b_size + STp->buffer->sg[i].length) <= OS_DATA_SIZE); 
 		     b_size += STp->buffer->sg[i++].length);
-		STp->buffer->aux = (os_aux_t *) (page_address(STp->buffer->sg[i].page) + OS_DATA_SIZE - b_size);
+		STp->buffer->aux = (os_aux_t *) (page_address(sg_page(&STp->buffer->sg[i])) + OS_DATA_SIZE - b_size);
 #if DEBUG
 		printk(OSST_DEB_MSG "%s:D: b_data points to %p in segment 0 at %p\n", name,
 			STp->buffer->b_data, page_address(STp->buffer->sg[0].page));
@@ -5252,25 +5252,26 @@ static int enlarge_buffer(struct osst_buffer *STbuffer, int need_dma)
 	/* Try to allocate the first segment up to OS_DATA_SIZE and the others
 	   big enough to reach the goal (code assumes no segments in place) */
 	for (b_size = OS_DATA_SIZE, order = OSST_FIRST_ORDER; b_size >= PAGE_SIZE; order--, b_size /= 2) {
-		STbuffer->sg[0].page = alloc_pages(priority, order);
+		struct page *page = alloc_pages(priority, order);
+
 		STbuffer->sg[0].offset = 0;
-		if (STbuffer->sg[0].page != NULL) {
+		if (page != NULL) {
+		    sg_set_page(&STbuffer->sg[0], page);
 		    STbuffer->sg[0].length = b_size;
-		    STbuffer->b_data = page_address(STbuffer->sg[0].page);
+		    STbuffer->b_data = page_address(page);
 		    break;
 		}
 	}
-	if (STbuffer->sg[0].page == NULL) {
+	if (sg_page(&STbuffer->sg[0]) == NULL) {
 		printk(KERN_NOTICE "osst :I: Can't allocate tape buffer main segment.\n");
 		return 0;
 	}
 	/* Got initial segment of 'bsize,order', continue with same size if possible, except for AUX */
 	for (segs=STbuffer->sg_segs=1, got=b_size;
 	     segs < max_segs && got < OS_FRAME_SIZE; ) {
-		STbuffer->sg[segs].page =
-				alloc_pages(priority, (OS_FRAME_SIZE - got <= PAGE_SIZE) ? 0 : order);
+		struct page *page = alloc_pages(priority, (OS_FRAME_SIZE - got <= PAGE_SIZE) ? 0 : order);
 		STbuffer->sg[segs].offset = 0;
-		if (STbuffer->sg[segs].page == NULL) {
+		if (page == NULL) {
 			if (OS_FRAME_SIZE - got <= (max_segs - segs) * b_size / 2 && order) {
 				b_size /= 2;  /* Large enough for the rest of the buffers */
 				order--;
@@ -5284,6 +5285,7 @@ static int enlarge_buffer(struct osst_buffer *STbuffer, int need_dma)
 			normalize_buffer(STbuffer);
 			return 0;
 		}
+		sg_set_page(&STbuffer->sg[segs], page);
 		STbuffer->sg[segs].length = (OS_FRAME_SIZE - got <= PAGE_SIZE / 2) ? (OS_FRAME_SIZE - got) : b_size;
 		got += STbuffer->sg[segs].length;
 		STbuffer->buffer_size = got;
@@ -5316,7 +5318,7 @@ static void normalize_buffer(struct osst_buffer *STbuffer)
 		     b_size < STbuffer->sg[i].length;
 		     b_size *= 2, order++);
 
-		__free_pages(STbuffer->sg[i].page, order);
+		__free_pages(sg_page(&STbuffer->sg[i]), order);
 		STbuffer->buffer_size -= STbuffer->sg[i].length;
 	}
 #if DEBUG
@@ -5344,7 +5346,7 @@ static int append_to_buffer(const char __user *ubp, struct osst_buffer *st_bp, i
 	for ( ; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length - offset < do_count ?
 		      st_bp->sg[i].length - offset : do_count;
-		res = copy_from_user(page_address(st_bp->sg[i].page) + offset, ubp, cnt);
+		res = copy_from_user(page_address(sg_page(&st_bp->sg[i])) + offset, ubp, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -5377,7 +5379,7 @@ static int from_buffer(struct osst_buffer *st_bp, char __user *ubp, int do_count
 	for ( ; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length - offset < do_count ?
 		      st_bp->sg[i].length - offset : do_count;
-		res = copy_to_user(ubp, page_address(st_bp->sg[i].page) + offset, cnt);
+		res = copy_to_user(ubp, page_address(sg_page(&st_bp->sg[i])) + offset, cnt);
 		if (res)
 			return (-EFAULT);
 		do_count -= cnt;
@@ -5410,7 +5412,7 @@ static int osst_zero_buffer_tail(struct osst_buffer *st_bp)
 	     i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length - offset < do_count ?
 		      st_bp->sg[i].length - offset : do_count ;
-		memset(page_address(st_bp->sg[i].page) + offset, 0, cnt);
+		memset(page_address(sg_page(&st_bp->sg[i])) + offset, 0, cnt);
 		do_count -= cnt;
 		offset = 0;
 	}
@@ -5430,7 +5432,7 @@ static int osst_copy_to_buffer(struct osst_buffer *st_bp, unsigned char *ptr)
 	for (i = 0; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length < do_count ?
 		      st_bp->sg[i].length : do_count ;
-		memcpy(page_address(st_bp->sg[i].page), ptr, cnt);
+		memcpy(page_address(sg_page(&st_bp->sg[i])), ptr, cnt);
 		do_count -= cnt;
 		ptr      += cnt;
 	}
@@ -5451,7 +5453,7 @@ static int osst_copy_from_buffer(struct osst_buffer *st_bp, unsigned char *ptr)
 	for (i = 0; i < st_bp->sg_segs && do_count > 0; i++) {
 		cnt = st_bp->sg[i].length < do_count ?
 		      st_bp->sg[i].length : do_count ;
-		memcpy(ptr, page_address(st_bp->sg[i].page), cnt);
+		memcpy(ptr, page_address(sg_page(&st_bp->sg[i])), cnt);
 		do_count -= cnt;
 		ptr      += cnt;
 	}
diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 190e2a7..26c41b0 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -443,7 +443,7 @@ SYM53C500_intr(int irq, void *dev_id)
 
 			scsi_for_each_sg(curSC, sg, scsi_sg_count(curSC), i) {
 				SYM53C500_pio_write(fast_pio, port_base,
-						    page_address(sg->page) + sg->offset,
+				    page_address(sg_page(sg)) + sg->offset,
 						    sg->length);
 			}
 			REG0(port_base);
@@ -463,8 +463,8 @@ SYM53C500_intr(int irq, void *dev_id)
 
 			scsi_for_each_sg(curSC, sg, scsi_sg_count(curSC), i) {
 				SYM53C500_pio_read(fast_pio, port_base,
-						   page_address(sg->page) + sg->offset,
-						   sg->length);
+					page_address(sg_page(sg)) + sg->offset,
+					sg->length);
 			}
 			REG0(port_base);
 		}
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index 67b6d76..07f31e5 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -609,7 +609,7 @@ static int ppa_completion(struct scsi_cmnd *cmd)
 				cmd->SCp.this_residual =
 				    cmd->SCp.buffer->length;
 				cmd->SCp.ptr =
-				    page_address(cmd->SCp.buffer->page) +
+				    page_address(sg_page(cmd->SCp.buffer)) +
 				    cmd->SCp.buffer->offset;
 			}
 		}
@@ -756,7 +756,7 @@ static int ppa_engine(ppa_struct *dev, struct scsi_cmnd *cmd)
 			/* if many buffers are available, start filling the first */
 			cmd->SCp.buffer = (struct scatterlist *) cmd->request_buffer;
 			cmd->SCp.this_residual = cmd->SCp.buffer->length;
-			cmd->SCp.ptr = page_address(cmd->SCp.buffer->page) +
+			cmd->SCp.ptr = page_address(sg_page(cmd->SCp.buffer)) +
 			    cmd->SCp.buffer->offset;
 		} else {
 			/* else fill the only available buffer */
diff --git a/drivers/scsi/qlogicfas408.c b/drivers/scsi/qlogicfas408.c
index 2bfbf26..feff3f7 100644
--- a/drivers/scsi/qlogicfas408.c
+++ b/drivers/scsi/qlogicfas408.c
@@ -317,7 +317,7 @@ static unsigned int ql_pcmd(struct scsi_cmnd *cmd)
 				return ((priv->qabort == 1 ?
 					 DID_ABORT : DID_RESET) << 16);
 			}
-			buf = page_address(sg->page) + sg->offset;
+			buf = page_address(sg_page(sg)) + sg->offset;
 			if (ql_pdma(priv, phase, buf, sg->length))
 				break;
 		}
diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 72ee4c9..46cae5a 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -625,7 +625,7 @@ static int fill_from_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	scsi_for_each_sg(scp, sg, scp->use_sg, k) {
 		if (active) {
 			kaddr = (unsigned char *)
-				kmap_atomic(sg->page, KM_USER0);
+				kmap_atomic(sg_page(sg), KM_USER0);
 			if (NULL == kaddr)
 				return (DID_ERROR << 16);
 			kaddr_off = (unsigned char *)kaddr + sg->offset;
@@ -672,7 +672,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd * scp, unsigned char * arr,
 	sg = scsi_sglist(scp);
 	req_len = fin = 0;
 	for (k = 0; k < scp->use_sg; ++k, sg = sg_next(sg)) {
-		kaddr = (unsigned char *)kmap_atomic(sg->page, KM_USER0);
+		kaddr = (unsigned char *)kmap_atomic(sg_page(sg), KM_USER0);
 		if (NULL == kaddr)
 			return -1;
 		kaddr_off = (unsigned char *)kaddr + sg->offset;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index aac8a02..61fdaf0 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -295,7 +295,7 @@ static int scsi_req_map_sg(struct request *rq, struct scatterlist *sgl,
 	int i, err, nr_vecs = 0;
 
 	for_each_sg(sgl, sg, nsegs, i) {
-		page = sg->page;
+		page = sg_page(sg);
 		off = sg->offset;
 		len = sg->length;
  		data_len += len;
@@ -764,7 +764,7 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 		if (unlikely(!sgl))
 			goto enomem;
 
-		memset(sgl, 0, sizeof(*sgl) * sgp->size);
+		sg_init_table(sgl, sgp->size);
 
 		/*
 		 * first loop through, set initial index and return value
@@ -781,6 +781,13 @@ struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 			sg_chain(prev, SCSI_MAX_SG_SEGMENTS, sgl);
 
 		/*
+		 * if we have nothing left, mark the last segment as
+		 * end-of-list
+		 */
+		if (!left)
+			sg_mark_end(sgl, this);
+
+		/*
 		 * don't allow subsequent mempool allocs to sleep, it would
 		 * violate the mempool principle.
 		 */
@@ -2353,7 +2360,7 @@ void *scsi_kmap_atomic_sg(struct scatterlist *sgl, int sg_count,
 	*offset = *offset - len_complete + sg->offset;
 
 	/* Assumption: contiguous pages can be accessed as "page + i" */
-	page = nth_page(sg->page, (*offset >> PAGE_SHIFT));
+	page = nth_page(sg_page(sg), (*offset >> PAGE_SHIFT));
 	*offset &= ~PAGE_MASK;
 
 	/* Bytes in this sg-entry from *offset to the end of the page */
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 7238b2d..cc19710 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1169,7 +1169,7 @@ sg_vma_nopage(struct vm_area_struct *vma, unsigned long addr, int *type)
 		len = vma->vm_end - sa;
 		len = (len < sg->length) ? len : sg->length;
 		if (offset < len) {
-			page = virt_to_page(page_address(sg->page) + offset);
+			page = virt_to_page(page_address(sg_page(sg)) + offset);
 			get_page(page);	/* increment page count */
 			break;
 		}
@@ -1717,13 +1717,13 @@ st_map_user_pages(struct scatterlist *sgl, const unsigned int max_pages,
 		   goto out_unlock; */
         }
 
-	sgl[0].page = pages[0];
+	sg_set_page(sgl, pages[0]);
 	sgl[0].offset = uaddr & ~PAGE_MASK;
 	if (nr_pages > 1) {
 		sgl[0].length = PAGE_SIZE - sgl[0].offset;
 		count -= sgl[0].length;
 		for (i=1; i < nr_pages ; i++) {
-			sgl[i].page = pages[i]; 
+			sg_set_page(&sgl[i], pages[i]);
 			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
 			count -= PAGE_SIZE;
 		}
@@ -1754,7 +1754,7 @@ st_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_pages,
 	int i;
 
 	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
+		struct page *page = sg_page(&sgl[i]);
 
 		if (dirtied)
 			SetPageDirty(page);
@@ -1854,7 +1854,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 				scatter_elem_sz_prev = ret_sz;
 			}
 		}
-		sg->page = p;
+		sg_set_page(sg, p);
 		sg->length = (ret_sz > num) ? num : ret_sz;
 
 		SCSI_LOG_TIMEOUT(5, printk("sg_build_indirect: k=%d, num=%d, "
@@ -1907,14 +1907,14 @@ sg_write_xfer(Sg_request * srp)
 		onum = 1;
 
 	ksglen = sg->length;
-	p = page_address(sg->page);
+	p = page_address(sg_page(sg));
 	for (j = 0, k = 0; j < onum; ++j) {
 		res = sg_u_iovec(hp, iovec_count, j, 1, &usglen, &up);
 		if (res)
 			return res;
 
 		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg->page)) {
+		     p = page_address(sg_page(sg))) {
 			if (usglen <= 0)
 				break;
 			if (ksglen > usglen) {
@@ -1991,12 +1991,12 @@ sg_remove_scat(Sg_scatter_hold * schp)
 		} else {
 			int k;
 
-			for (k = 0; (k < schp->k_use_sg) && sg->page;
+			for (k = 0; (k < schp->k_use_sg) && sg_page(sg);
 			     ++k, sg = sg_next(sg)) {
 				SCSI_LOG_TIMEOUT(5, printk(
 				    "sg_remove_scat: k=%d, pg=0x%p, len=%d\n",
-				    k, sg->page, sg->length));
-				sg_page_free(sg->page, sg->length);
+				    k, sg_page(sg), sg->length));
+				sg_page_free(sg_page(sg), sg->length);
 			}
 		}
 		kfree(schp->buffer);
@@ -2038,7 +2038,7 @@ sg_read_xfer(Sg_request * srp)
 	} else
 		onum = 1;
 
-	p = page_address(sg->page);
+	p = page_address(sg_page(sg));
 	ksglen = sg->length;
 	for (j = 0, k = 0; j < onum; ++j) {
 		res = sg_u_iovec(hp, iovec_count, j, 0, &usglen, &up);
@@ -2046,7 +2046,7 @@ sg_read_xfer(Sg_request * srp)
 			return res;
 
 		for (; p; sg = sg_next(sg), ksglen = sg->length,
-		     p = page_address(sg->page)) {
+		     p = page_address(sg_page(sg))) {
 			if (usglen <= 0)
 				break;
 			if (ksglen > usglen) {
@@ -2092,15 +2092,15 @@ sg_read_oxfer(Sg_request * srp, char __user *outp, int num_read_xfer)
 	if ((!outp) || (num_read_xfer <= 0))
 		return 0;
 
-	for (k = 0; (k < schp->k_use_sg) && sg->page; ++k, sg = sg_next(sg)) {
+	for (k = 0; (k < schp->k_use_sg) && sg_page(sg); ++k, sg = sg_next(sg)) {
 		num = sg->length;
 		if (num > num_read_xfer) {
-			if (__copy_to_user(outp, page_address(sg->page),
+			if (__copy_to_user(outp, page_address(sg_page(sg)),
 					   num_read_xfer))
 				return -EFAULT;
 			break;
 		} else {
-			if (__copy_to_user(outp, page_address(sg->page),
+			if (__copy_to_user(outp, page_address(sg_page(sg)),
 					   num))
 				return -EFAULT;
 			num_read_xfer -= num;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 73c44cb..ce69b9e 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3797,7 +3797,7 @@ static void buf_to_sg(struct st_buffer *STbp, unsigned int length)
 	sg = &(STbp->sg[0]);
 	frp = STbp->frp;
 	for (i=count=0; count < length; i++) {
-		sg[i].page = frp[i].page;
+		sg_set_page(&sg[i], frp[i].page);
 		if (length - count > frp[i].length)
 			sg[i].length = frp[i].length;
 		else
@@ -4446,14 +4446,14 @@ static int sgl_map_user_pages(struct scatterlist *sgl, const unsigned int max_pa
         }
 
 	/* Populate the scatter/gather list */
-	sgl[0].page = pages[0]; 
+	sg_set_page(&sgl[0], pages[0]);
 	sgl[0].offset = uaddr & ~PAGE_MASK;
 	if (nr_pages > 1) {
 		sgl[0].length = PAGE_SIZE - sgl[0].offset;
 		count -= sgl[0].length;
 		for (i=1; i < nr_pages ; i++) {
+			sg_set_page(&sgl[i], pages[i]);;
 			sgl[i].offset = 0;
-			sgl[i].page = pages[i]; 
 			sgl[i].length = count < PAGE_SIZE ? count : PAGE_SIZE;
 			count -= PAGE_SIZE;
 		}
@@ -4483,7 +4483,7 @@ static int sgl_unmap_user_pages(struct scatterlist *sgl, const unsigned int nr_p
 	int i;
 
 	for (i=0; i < nr_pages; i++) {
-		struct page *page = sgl[i].page;
+		struct page *page = sg_page(&sgl[i]);
 
 		if (dirtied)
 			SetPageDirty(page);
diff --git a/drivers/scsi/tmscsim.c b/drivers/scsi/tmscsim.c
index 5c72ca3..4419304 100644
--- a/drivers/scsi/tmscsim.c
+++ b/drivers/scsi/tmscsim.c
@@ -430,10 +430,7 @@ static __inline__ void dc390_Going_remove (struct dc390_dcb* pDCB, struct dc390_
 
 static struct scatterlist* dc390_sg_build_single(struct scatterlist *sg, void *addr, unsigned int length)
 {
-	memset(sg, 0, sizeof(struct scatterlist));
-	sg->page	= virt_to_page(addr);
-	sg->length	= length;
-	sg->offset	= (unsigned long)addr & ~PAGE_MASK;
+	sg_init_one(sg, addr, length);
 	return sg;
 }
 
diff --git a/drivers/scsi/ultrastor.c b/drivers/scsi/ultrastor.c
index ea72bbe..6d1f0ed 100644
--- a/drivers/scsi/ultrastor.c
+++ b/drivers/scsi/ultrastor.c
@@ -681,7 +681,7 @@ static inline void build_sg_list(struct mscp *mscp, struct scsi_cmnd *SCpnt)
 
 	max = scsi_sg_count(SCpnt);
 	scsi_for_each_sg(SCpnt, sg, max, i) {
-		mscp->sglist[i].address = isa_page_to_bus(sg->page) + sg->offset;
+		mscp->sglist[i].address = isa_page_to_bus(sg_page(sg)) + sg->offset;
 		mscp->sglist[i].num_bytes = sg->length;
 		transfer_length += sg->length;
 	}
diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 255c611..03cd44f 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1123,7 +1123,7 @@ static int wd7000_queuecommand(struct scsi_cmnd *SCpnt,
 		any2scsi(scb->maxlen, nseg * sizeof(Sgb));
 
 		scsi_for_each_sg(SCpnt, sg, nseg, i) {
-			any2scsi(sgb[i].ptr, isa_page_to_bus(sg->page) + sg->offset);
+			any2scsi(sgb[i].ptr, isa_page_to_bus(sg_page(sg)) + sg->offset);
 			any2scsi(sgb[i].len, sg->length);
 		}
 	} else {
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index c021af3..3577453 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -438,12 +438,12 @@ int usb_sg_init (
 			io->urbs[i]->transfer_buffer = NULL;
 #else
 			io->urbs[i]->transfer_buffer =
-				page_address(sg[i].page) + sg[i].offset;
+				page_address(sg_page(&sg[i])) + sg[i].offset;
 #endif
 		} else {
 			/* hc may use _only_ transfer_buffer */
 			io->urbs [i]->transfer_buffer =
-				page_address (sg [i].page) + sg [i].offset;
+				page_address(sg_page(&sg[i])) + sg [i].offset;
 			len = sg [i].length;
 		}
 
diff --git a/drivers/usb/image/microtek.c b/drivers/usb/image/microtek.c
index e7d982a..4866baf 100644
--- a/drivers/usb/image/microtek.c
+++ b/drivers/usb/image/microtek.c
@@ -519,7 +519,7 @@ static void mts_do_sg (struct urb* transfer)
 	context->fragment++;
 	mts_int_submit_urb(transfer,
 			   context->data_pipe,
-			   page_address(sg[context->fragment].page) +
+			   page_address(sg_page(&sg[context->fragment])) +
 			   sg[context->fragment].offset,
 			   sg[context->fragment].length,
 			   context->fragment + 1 == scsi_sg_count(context->srb) ?
@@ -557,7 +557,7 @@ mts_build_transfer_context(struct scsi_cmnd *srb, struct mts_desc* desc)
 		return;
 	} else {
 		sg = scsi_sglist(srb);
-		desc->context.data = page_address(sg[0].page) + sg[0].offset;
+		desc->context.data = page_address(sg_page(&sg[0])) + sg[0].offset;
 		desc->context.data_length = sg[0].length;
 	}
 
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index e901d31..ca8cb34 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -360,9 +360,10 @@ static void free_sglist (struct scatterlist *sg, int nents)
 	if (!sg)
 		return;
 	for (i = 0; i < nents; i++) {
-		if (!sg [i].page)
+		struct page *page = sg_page(&sg[i]);
+		if (!page)
 			continue;
-		kfree (page_address (sg [i].page) + sg [i].offset);
+		kfree (page_address (page) + sg [i].offset);
 	}
 	kfree (sg);
 }
diff --git a/drivers/usb/storage/protocol.c b/drivers/usb/storage/protocol.c
index cc8f7c5..889622b 100644
--- a/drivers/usb/storage/protocol.c
+++ b/drivers/usb/storage/protocol.c
@@ -195,7 +195,7 @@ unsigned int usb_stor_access_xfer_buf(unsigned char *buffer,
 		 * the *offset and *index values for the next loop. */
 		cnt = 0;
 		while (cnt < buflen) {
-			struct page *page = sg->page +
+			struct page *page = sg_page(sg) +
 					((sg->offset + *offset) >> PAGE_SHIFT);
 			unsigned int poff =
 					(sg->offset + *offset) & (PAGE_SIZE-1);
diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index 1ae90ef..0a9882e 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -283,7 +283,7 @@ int virt_to_scatterlist(const void *addr, int size, struct scatterlist *sg,
 		pg = virt_to_page(addr);
 		offset = offset_in_page(addr);
 		if (sg) {
-			sg[i].page = pg;
+			sg_set_page(&sg[i], pg);
 			sg[i].offset = offset;
 		}
 		remainder_of_page = PAGE_CACHE_SIZE - offset;
@@ -713,10 +713,13 @@ ecryptfs_encrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 {
 	struct scatterlist src_sg, dst_sg;
 
-	src_sg.page = src_page;
+	sg_init_table(&src_sg, 1);
+	sg_init_table(&dst_sg, 1);
+
+	sg_set_page(&src_sg, src_page);
 	src_sg.offset = src_offset;
 	src_sg.length = size;
-	dst_sg.page = dst_page;
+	sg_set_page(&dst_sg, dst_page);
 	dst_sg.offset = dst_offset;
 	dst_sg.length = size;
 	return encrypt_scatterlist(crypt_stat, &dst_sg, &src_sg, size, iv);
@@ -742,10 +745,13 @@ ecryptfs_decrypt_page_offset(struct ecryptfs_crypt_stat *crypt_stat,
 {
 	struct scatterlist src_sg, dst_sg;
 
-	src_sg.page = src_page;
+	sg_init_table(&src_sg, 1);
+	sg_init_table(&dst_sg, 1);
+
+	sg_set_page(&src_sg, src_page);
 	src_sg.offset = src_offset;
 	src_sg.length = size;
-	dst_sg.page = dst_page;
+	sg_set_page(&dst_sg, dst_page);
 	dst_sg.offset = dst_offset;
 	dst_sg.length = size;
 	return decrypt_scatterlist(crypt_stat, &dst_sg, &src_sg, size, iv);
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 89d9710..263fed8 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1040,6 +1040,9 @@ decrypt_passphrase_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	};
 	int rc = 0;
 
+	sg_init_table(&dst_sg, 1);
+	sg_init_table(&src_sg, 1);
+
 	if (unlikely(ecryptfs_verbosity > 0)) {
 		ecryptfs_printk(
 			KERN_DEBUG, "Session key encryption key (size [%d]):\n",
diff --git a/fs/nfsd/nfs4recover.c b/fs/nfsd/nfs4recover.c
index ebd03cc..6f03918 100644
--- a/fs/nfsd/nfs4recover.c
+++ b/fs/nfsd/nfs4recover.c
@@ -88,7 +88,7 @@ nfs4_make_rec_clidname(char *dname, struct xdr_netobj *clname)
 {
 	struct xdr_netobj cksum;
 	struct hash_desc desc;
-	struct scatterlist sg[1];
+	struct scatterlist sg;
 	__be32 status = nfserr_resource;
 
 	dprintk("NFSD: nfs4_make_rec_clidname for %.*s\n",
@@ -102,11 +102,9 @@ nfs4_make_rec_clidname(char *dname, struct xdr_netobj *clname)
 	if (cksum.data == NULL)
  		goto out;
 
-	sg[0].page = virt_to_page(clname->data);
-	sg[0].offset = offset_in_page(clname->data);
-	sg[0].length = clname->len;
+	sg_init_one(&sg, clname->data, clname->len);
 
-	if (crypto_hash_digest(&desc, sg, sg->length, cksum.data))
+	if (crypto_hash_digest(&desc, &sg, sg.length, cksum.data))
 		goto out;
 
 	md5_to_hex(dname, cksum.data);
diff --git a/include/asm-alpha/scatterlist.h b/include/asm-alpha/scatterlist.h
index 9173654..b764706 100644
--- a/include/asm-alpha/scatterlist.h
+++ b/include/asm-alpha/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
   
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 
 	unsigned int length;
diff --git a/include/asm-arm/scatterlist.h b/include/asm-arm/scatterlist.h
index de2f65e..ab1d85d 100644
--- a/include/asm-arm/scatterlist.h
+++ b/include/asm-arm/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;		/* buffer page			 */
+	unsigned long	page_link;
 	unsigned int	offset;		/* buffer offset		 */
 	dma_addr_t	dma_address;	/* dma address			 */
 	unsigned int	length;		/* length			 */
diff --git a/include/asm-avr32/scatterlist.h b/include/asm-avr32/scatterlist.h
index c6d5ce3..1356f29 100644
--- a/include/asm-avr32/scatterlist.h
+++ b/include/asm-avr32/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page		*page;
+    unsigned long	page_link;
     unsigned int	offset;
     dma_addr_t		dma_address;
     unsigned int	length;
diff --git a/include/asm-blackfin/scatterlist.h b/include/asm-blackfin/scatterlist.h
index 60e07b9..384af54 100644
--- a/include/asm-blackfin/scatterlist.h
+++ b/include/asm-blackfin/scatterlist.h
@@ -4,7 +4,7 @@
 #include <linux/mm.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	dma_addr_t dma_address;
 	unsigned int length;
diff --git a/include/asm-cris/scatterlist.h b/include/asm-cris/scatterlist.h
index 4bdc44c..5a8a834 100644
--- a/include/asm-cris/scatterlist.h
+++ b/include/asm-cris/scatterlist.h
@@ -6,7 +6,7 @@ struct scatterlist {
 	unsigned int length;
 
 	/* The following is i386 highmem junk - not used by us */
-	struct page * page; /* Location for highmem page, if any */
+	unsigned long page_link;
 	unsigned int offset;/* for highmem, page offset */
 
 };
diff --git a/include/asm-frv/scatterlist.h b/include/asm-frv/scatterlist.h
index 8e827fa..53dade7 100644
--- a/include/asm-frv/scatterlist.h
+++ b/include/asm-frv/scatterlist.h
@@ -22,7 +22,7 @@
  * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
  */
 struct scatterlist {
-	struct page	*page;		/* Location for highmem page, if any */
+	unsigned long	page_link;
 	unsigned int	offset;		/* for highmem, page offset */
 
 	dma_addr_t	dma_address;
diff --git a/include/asm-h8300/scatterlist.h b/include/asm-h8300/scatterlist.h
index 985fdf5..7e41983 100644
--- a/include/asm-h8300/scatterlist.h
+++ b/include/asm-h8300/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/asm-ia64/scatterlist.h b/include/asm-ia64/scatterlist.h
index 7d5234d..2f76ce3 100644
--- a/include/asm-ia64/scatterlist.h
+++ b/include/asm-ia64/scatterlist.h
@@ -9,7 +9,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;	/* buffer length */
 
diff --git a/include/asm-m32r/scatterlist.h b/include/asm-m32r/scatterlist.h
index 352415f..33b4b4d 100644
--- a/include/asm-m32r/scatterlist.h
+++ b/include/asm-m32r/scatterlist.h
@@ -6,7 +6,7 @@
 struct scatterlist {
     char *  address;    /* Location data is to be transferred to, NULL for
                          * highmem page */
-    struct page * page; /* Location for highmem page, if any */
+    unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
 
     dma_addr_t dma_address;
diff --git a/include/asm-m68k/scatterlist.h b/include/asm-m68k/scatterlist.h
index 24887a2..e06bb89 100644
--- a/include/asm-m68k/scatterlist.h
+++ b/include/asm-m68k/scatterlist.h
@@ -4,7 +4,7 @@
 #include <linux/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;
 
diff --git a/include/asm-m68knommu/scatterlist.h b/include/asm-m68knommu/scatterlist.h
index 4da79d3..28bed41 100644
--- a/include/asm-m68knommu/scatterlist.h
+++ b/include/asm-m68knommu/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/asm-mips/scatterlist.h b/include/asm-mips/scatterlist.h
index 7af104c..787797c 100644
--- a/include/asm-mips/scatterlist.h
+++ b/include/asm-mips/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page *	page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/asm-parisc/scatterlist.h b/include/asm-parisc/scatterlist.h
index e7211c7..26da914 100644
--- a/include/asm-parisc/scatterlist.h
+++ b/include/asm-parisc/scatterlist.h
@@ -5,7 +5,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 
 	unsigned int length;
diff --git a/include/asm-powerpc/scatterlist.h b/include/asm-powerpc/scatterlist.h
index b075f61..b9f1dbc 100644
--- a/include/asm-powerpc/scatterlist.h
+++ b/include/asm-powerpc/scatterlist.h
@@ -14,7 +14,7 @@
 #include <asm/dma.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 	unsigned int length;
 
diff --git a/include/asm-s390/scatterlist.h b/include/asm-s390/scatterlist.h
index a43b3af..eb39486 100644
--- a/include/asm-s390/scatterlist.h
+++ b/include/asm-s390/scatterlist.h
@@ -2,7 +2,7 @@
 #define _ASMS390_SCATTERLIST_H
 
 struct scatterlist {
-    struct page *page;
+    unsigned long page_link;
     unsigned int offset;
     unsigned int length;
 };
diff --git a/include/asm-sh/scatterlist.h b/include/asm-sh/scatterlist.h
index b9ae53c..bc7c809 100644
--- a/include/asm-sh/scatterlist.h
+++ b/include/asm-sh/scatterlist.h
@@ -4,7 +4,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page * page; /* Location for highmem page, if any */
+    unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
     dma_addr_t dma_address;
     unsigned int length;
diff --git a/include/asm-sh64/scatterlist.h b/include/asm-sh64/scatterlist.h
index 1c723f2..0afd856 100644
--- a/include/asm-sh64/scatterlist.h
+++ b/include/asm-sh64/scatterlist.h
@@ -14,7 +14,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page * page; /* Location for highmem page, if any */
+    unsigned long page_link;
     unsigned int offset;/* for highmem, page offset */
     dma_addr_t dma_address;
     unsigned int length;
diff --git a/include/asm-sparc/scatterlist.h b/include/asm-sparc/scatterlist.h
index 4055af9..45b16f1 100644
--- a/include/asm-sparc/scatterlist.h
+++ b/include/asm-sparc/scatterlist.h
@@ -5,7 +5,7 @@
 #include <linux/types.h>
 
 struct scatterlist {
-	struct page *page;
+	unsigned long page_link;
 	unsigned int offset;
 
 	unsigned int length;
diff --git a/include/asm-sparc64/scatterlist.h b/include/asm-sparc64/scatterlist.h
index 703c5bb..6df23f0 100644
--- a/include/asm-sparc64/scatterlist.h
+++ b/include/asm-sparc64/scatterlist.h
@@ -6,7 +6,10 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+#ifdef CONFIG_DEBUG_SG
+	unsigned long	sg_magic;
+#endif
+	unsigned long	page_link;
 	unsigned int	offset;
 
 	unsigned int	length;
diff --git a/include/asm-v850/scatterlist.h b/include/asm-v850/scatterlist.h
index 56f4029..db91feb 100644
--- a/include/asm-v850/scatterlist.h
+++ b/include/asm-v850/scatterlist.h
@@ -17,7 +17,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page	*page;
+	unsigned long	page_link;
 	unsigned	offset;
 	dma_addr_t	dma_address;
 	unsigned	length;
diff --git a/include/asm-x86/dma-mapping_32.h b/include/asm-x86/dma-mapping_32.h
index 6a2d26c..e0d38d8 100644
--- a/include/asm-x86/dma-mapping_32.h
+++ b/include/asm-x86/dma-mapping_32.h
@@ -45,9 +45,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sglist, int nents,
 	WARN_ON(nents == 0 || sglist[0].length == 0);
 
 	for_each_sg(sglist, sg, nents, i) {
-		BUG_ON(!sg->page);
+		BUG_ON(!sg_page(sg));
 
-		sg->dma_address = page_to_phys(sg->page) + sg->offset;
+		sg->dma_address = page_to_phys(sg_page(sg)) + sg->offset;
 	}
 
 	flush_write_buffers();
diff --git a/include/asm-x86/scatterlist_32.h b/include/asm-x86/scatterlist_32.h
index bd5164a..0e7d997 100644
--- a/include/asm-x86/scatterlist_32.h
+++ b/include/asm-x86/scatterlist_32.h
@@ -4,7 +4,10 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page		*page;
+#ifdef CONFIG_DEBUG_SG
+    unsigned long	sg_magic;
+#endif
+    unsigned long	page_link;
     unsigned int	offset;
     dma_addr_t		dma_address;
     unsigned int	length;
diff --git a/include/asm-x86/scatterlist_64.h b/include/asm-x86/scatterlist_64.h
index ef3986b..1847c72 100644
--- a/include/asm-x86/scatterlist_64.h
+++ b/include/asm-x86/scatterlist_64.h
@@ -4,7 +4,10 @@
 #include <asm/types.h>
 
 struct scatterlist {
-    struct page		*page;
+#ifdef CONFIG_DEBUG_SG
+    unsigned long	sg_magic;
+#endif
+    unsigned long	page_link;
     unsigned int	offset;
     unsigned int	length;
     dma_addr_t		dma_address;
diff --git a/include/asm-xtensa/scatterlist.h b/include/asm-xtensa/scatterlist.h
index ca337a2..3b8aba5 100644
--- a/include/asm-xtensa/scatterlist.h
+++ b/include/asm-xtensa/scatterlist.h
@@ -14,7 +14,7 @@
 #include <asm/types.h>
 
 struct scatterlist {
-	struct page 	*page;
+	unsigned long	page_link;
 	unsigned int	offset;
 	dma_addr_t	dma_address;
 	unsigned int	length;
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2dc7464..3ab94c8 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -5,29 +5,72 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 
+/*
+ * Notes on SG table design.
+ *
+ * Architectures must provide an unsigned long page_link field in the
+ * scatterlist struct. We use that to place the page pointer AND encode
+ * information about the sg table as well. The two lower bits are reserved
+ * for this information.
+ *
+ * If bit 0 is set, then the page_link contains a pointer to the next sg
+ * table list. Otherwise the next entry is at sg + 1.
+ *
+ * If bit 1 is set, then this sg entry is the last element in a list.
+ *
+ * See sg_next().
+ *
+ */
+
+#define SG_MAGIC	0x87654321
+
+/**
+ * sg_set_page - Set sg entry to point at given page
+ * @sg:		 SG entry
+ * @page:	 The page
+ *
+ * Use this function to set an sg entry pointing at a page, never assign
+ * the page directly. We encode sg table information in the lower bits
+ * of the page pointer. See sg_page() for looking up the page belonging
+ * to an sg entry.
+ *
+ */
+static inline void sg_set_page(struct scatterlist *sg, struct page *page)
+{
+	unsigned long page_link = sg->page_link & 0x3;
+
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	sg->page_link = page_link | (unsigned long) page;
+}
+
+#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
+
+/**
+ * sg_set_buf - Set sg entry to point at given data
+ * @sg:		 SG entry
+ * @buf:	 Data
+ * @buflen:	 Data length
+ * 
+*/
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
-	sg->page = virt_to_page(buf);
+	sg_set_page(sg, virt_to_page(buf));
 	sg->offset = offset_in_page(buf);
 	sg->length = buflen;
 }
 
-static inline void sg_init_one(struct scatterlist *sg, const void *buf,
-			       unsigned int buflen)
-{
-	memset(sg, 0, sizeof(*sg));
-	sg_set_buf(sg, buf, buflen);
-}
-
 /*
  * We overload the LSB of the page pointer to indicate whether it's
  * a valid sg entry, or whether it points to the start of a new scatterlist.
  * Those low bits are there for everyone! (thanks mason :-)
  */
-#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
+#define sg_is_chain(sg)		((sg)->page_link & 0x01)
+#define sg_is_last(sg)		((sg)->page_link & 0x02)
 #define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
+	((struct scatterlist *) ((sg)->page_link & ~0x03))
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -37,14 +80,16 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
  * of a chained scatterlist, it could jump to the start of a new
  * scatterlist array.
  *
- * Note that the caller must ensure that there are further entries after
- * the current entry, this function will NOT return NULL for an end-of-list.
- *
  */
 static inline struct scatterlist *sg_next(struct scatterlist *sg)
 {
-	sg++;
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	if (sg_is_last(sg))
+		return NULL;
 
+	sg++;
 	if (unlikely(sg_is_chain(sg)))
 		sg = sg_chain_ptr(sg);
 
@@ -83,6 +128,10 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
 		ret = sg;
 
 #endif
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
+	BUG_ON(!sg_is_last(ret));
+#endif
 	return ret;
 }
 
@@ -101,7 +150,63 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
 #ifndef ARCH_HAS_SG_CHAIN
 	BUG();
 #endif
-	prv[prv_nents - 1].page = (struct page *) ((unsigned long) sgl | 0x01);
+	prv[prv_nents - 1].page_link = (unsigned long) sgl | 0x01;
+}
+
+/**
+ * sg_mark_end - Mark the end of the scatterlist
+ * @sgl:	Scatterlist
+ * @nents:	Number of entries in sgl
+ *
+ * Marks the last entry as the termination point for sg_next()
+ *
+ */
+static inline void sg_mark_end(struct scatterlist *sgl, unsigned int nents)
+{
+	sgl[nents - 1].page_link = 0x02;
+}
+
+/**
+ * sg_init_one - Initialize a single entry sg list
+ * @sg:		 SG entry
+ * @buf:	 Virtual address for IO
+ * @buflen:	 IO length
+ *
+ * Note: this should not be used on a single entry that is part of a larger
+ * table. Use sg_init_table() for that.
+ *
+ */
+static inline void sg_init_one(struct scatterlist *sg, const void *buf,
+			       unsigned int buflen)
+{
+	memset(sg, 0, sizeof(*sg));
+#ifdef CONFIG_DEBUG_SG
+	sg->sg_magic = SG_MAGIC;
+#endif
+	sg_mark_end(sg, 1);
+	sg_set_buf(sg, buf, buflen);
+}
+
+/**
+ * sg_init_table - Initialize SG table
+ * @sgl:	   The SG table
+ * @nents:	   Number of entries in table
+ *
+ * Note: If this is part of a chained sg table, sg_mark_end() should be
+ * used only on the last table part.
+ *
+ */
+static inline void sg_init_table(struct scatterlist *sgl, unsigned int nents)
+{
+	memset(sgl, 0, sizeof(*sgl) * nents);
+	sg_mark_end(sgl, nents);
+#ifdef CONFIG_DEBUG_SG
+	{
+		int i;
+		for (i = 0; i < nents; i++)
+			sgl[i].sg_magic = SG_MAGIC;
+	}
+#endif
 }
 
 #endif /* _LINUX_SCATTERLIST_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 7d16e64..183f42c 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -389,6 +389,16 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_SG
+	bool "Debug SG table operations"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on checks on scatter-gather tables. This can
+	  help find problems with drivers that do not properly initialize
+	  their sg tables.
+
+	  If unsure, say N.
+
 config FRAME_POINTER
 	bool "Compile the kernel with frame pointers"
 	depends on DEBUG_KERNEL && (X86 || CRIS || M68K || M68KNOMMU || FRV || UML || S390 || AVR32 || SUPERH || BFIN)
diff --git a/lib/swiotlb.c b/lib/swiotlb.c
index 752fd95..e58909e 100644
--- a/lib/swiotlb.c
+++ b/lib/swiotlb.c
@@ -35,7 +35,7 @@
 #define OFFSET(val,align) ((unsigned long)	\
 	                   ( (val) & ( (align) - 1)))
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
+#define SG_ENT_VIRT_ADDRESS(sg)	(page_address(sg_page((sg)) + (sg)->offset))
 #define SG_ENT_PHYS_ADDRESS(sg)	virt_to_bus(SG_ENT_VIRT_ADDRESS(sg))
 
 /*
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 70d9b5d..4e2c84f 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -2045,7 +2045,7 @@ skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len)
 	if (copy > 0) {
 		if (copy > len)
 			copy = len;
-		sg[elt].page = virt_to_page(skb->data + offset);
+		sg_set_page(&sg[elt], virt_to_page(skb->data + offset));
 		sg[elt].offset = (unsigned long)(skb->data + offset) % PAGE_SIZE;
 		sg[elt].length = copy;
 		elt++;
@@ -2065,7 +2065,7 @@ skb_to_sgvec(struct sk_buff *skb, struct scatterlist *sg, int offset, int len)
 
 			if (copy > len)
 				copy = len;
-			sg[elt].page = frag->page;
+			sg_set_page(&sg[elt], frag->page);
 			sg[elt].offset = frag->page_offset+offset-start;
 			sg[elt].length = copy;
 			elt++;
diff --git a/net/ieee80211/ieee80211_crypt_tkip.c b/net/ieee80211/ieee80211_crypt_tkip.c
index 6cc54ee..34d4c77 100644
--- a/net/ieee80211/ieee80211_crypt_tkip.c
+++ b/net/ieee80211/ieee80211_crypt_tkip.c
@@ -390,9 +390,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[3] = crc >> 24;
 
 	crypto_blkcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = len + 4;
+	sg_init_one(&sg, pos, len + 4);
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
 }
 
@@ -485,9 +483,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 12;
 
 	crypto_blkcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = plen + 4;
+	sg_init_one(&sg, pos, plen + 4);
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4)) {
 		if (net_ratelimit()) {
 			printk(KERN_DEBUG ": TKIP: failed to decrypt "
@@ -539,11 +535,12 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
 		printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
 		return -1;
 	}
-	sg[0].page = virt_to_page(hdr);
+	sg_init_table(sg, 2);
+	sg_set_page(&sg[0], virt_to_page(hdr));
 	sg[0].offset = offset_in_page(hdr);
 	sg[0].length = 16;
 
-	sg[1].page = virt_to_page(data);
+	sg_set_page(&sg[1], virt_to_page(data));
 	sg[1].offset = offset_in_page(data);
 	sg[1].length = data_len;
 
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index 8d18245..0af6103 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -170,9 +170,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[3] = crc >> 24;
 
 	crypto_blkcipher_setkey(wep->tx_tfm, key, klen);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = len + 4;
+	sg_init_one(&sg, pos, len + 4);
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
 }
 
@@ -212,9 +210,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	crypto_blkcipher_setkey(wep->rx_tfm, key, klen);
-	sg.page = virt_to_page(pos);
-	sg.offset = offset_in_page(pos);
-	sg.length = plen + 4;
+	sg_init_one(&sg, pos, plen + 4);
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4))
 		return -7;
 
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 6675261..cc806d6 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -138,9 +138,7 @@ void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	*icv = cpu_to_le32(~crc32_le(~0, data, data_len));
 
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg.page = virt_to_page(data);
-	sg.offset = offset_in_page(data);
-	sg.length = data_len + WEP_ICV_LEN;
+	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);
 }
 
@@ -204,9 +202,7 @@ int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	__le32 crc;
 
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg.page = virt_to_page(data);
-	sg.offset = offset_in_page(data);
-	sg.length = data_len + WEP_ICV_LEN;
+	sg_init_one(&sg, data, data_len + WEP_ICV_LEN);
 	crypto_blkcipher_decrypt(&desc, &sg, &sg, sg.length);
 
 	crc = cpu_to_le32(~crc32_le(~0, data, data_len));
diff --git a/net/sctp/auth.c b/net/sctp/auth.c
index 7818107..cbd64b2 100644
--- a/net/sctp/auth.c
+++ b/net/sctp/auth.c
@@ -726,7 +726,8 @@ void sctp_auth_calculate_hmac(const struct sctp_association *asoc,
 
 	/* set up scatter list */
 	end = skb_tail_pointer(skb);
-	sg.page = virt_to_page(auth);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(auth));
 	sg.offset = (unsigned long)(auth) % PAGE_SIZE;
 	sg.length = end - (unsigned char *)auth;
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index f983a36..d5a9785 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -1513,7 +1513,8 @@ static sctp_cookie_param_t *sctp_pack_cookie(const struct sctp_endpoint *ep,
 		struct hash_desc desc;
 
 		/* Sign the message.  */
-		sg.page = virt_to_page(&cookie->c);
+		sg_init_table(&sg, 1);
+		sg_set_page(&sg, virt_to_page(&cookie->c));
 		sg.offset = (unsigned long)(&cookie->c) % PAGE_SIZE;
 		sg.length = bodysize;
 		keylen = SCTP_SECRET_SIZE;
@@ -1585,7 +1586,8 @@ struct sctp_association *sctp_unpack_cookie(
 
 	/* Check the signature.  */
 	keylen = SCTP_SECRET_SIZE;
-	sg.page = virt_to_page(bear_cookie);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(bear_cookie));
 	sg.offset = (unsigned long)(bear_cookie) % PAGE_SIZE;
 	sg.length = bodysize;
 	key = (char *)ep->secret_key[ep->current_key];
diff --git a/net/sunrpc/auth_gss/gss_krb5_crypto.c b/net/sunrpc/auth_gss/gss_krb5_crypto.c
index bfb6a29..32be431 100644
--- a/net/sunrpc/auth_gss/gss_krb5_crypto.c
+++ b/net/sunrpc/auth_gss/gss_krb5_crypto.c
@@ -197,9 +197,9 @@ encryptor(struct scatterlist *sg, void *data)
 		int i = (page_pos + outbuf->page_base) >> PAGE_CACHE_SHIFT;
 		in_page = desc->pages[i];
 	} else {
-		in_page = sg->page;
+		in_page = sg_page(sg);
 	}
-	desc->infrags[desc->fragno].page = in_page;
+	sg_set_page(&desc->infrags[desc->fragno], in_page);
 	desc->fragno++;
 	desc->fraglen += sg->length;
 	desc->pos += sg->length;
@@ -215,11 +215,11 @@ encryptor(struct scatterlist *sg, void *data)
 	if (ret)
 		return ret;
 	if (fraglen) {
-		desc->outfrags[0].page = sg->page;
+		sg_set_page(&desc->outfrags[0], sg_page(sg));
 		desc->outfrags[0].offset = sg->offset + sg->length - fraglen;
 		desc->outfrags[0].length = fraglen;
 		desc->infrags[0] = desc->outfrags[0];
-		desc->infrags[0].page = in_page;
+		sg_set_page(&desc->infrags[0], in_page);
 		desc->fragno = 1;
 		desc->fraglen = fraglen;
 	} else {
@@ -287,7 +287,7 @@ decryptor(struct scatterlist *sg, void *data)
 	if (ret)
 		return ret;
 	if (fraglen) {
-		desc->frags[0].page = sg->page;
+		sg_set_page(&desc->frags[0], sg_page(sg));
 		desc->frags[0].offset = sg->offset + sg->length - fraglen;
 		desc->frags[0].length = fraglen;
 		desc->fragno = 1;
diff --git a/net/sunrpc/xdr.c b/net/sunrpc/xdr.c
index 6a59180..3d1f7cd 100644
--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1059,7 +1059,7 @@ xdr_process_buf(struct xdr_buf *buf, unsigned int offset, unsigned int len,
 		do {
 			if (thislen > page_len)
 				thislen = page_len;
-			sg->page = buf->pages[i];
+			sg_set_page(sg, buf->pages[i]);
 			sg->offset = page_offset;
 			sg->length = thislen;
 			ret = actor(sg, data);
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index 5ced62c..fb2220a 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -552,7 +552,7 @@ int skb_icv_walk(const struct sk_buff *skb, struct hash_desc *desc,
 		if (copy > len)
 			copy = len;
 
-		sg.page = virt_to_page(skb->data + offset);
+		sg_set_page(&sg, virt_to_page(skb->data + offset));
 		sg.offset = (unsigned long)(skb->data + offset) % PAGE_SIZE;
 		sg.length = copy;
 
@@ -577,7 +577,7 @@ int skb_icv_walk(const struct sk_buff *skb, struct hash_desc *desc,
 			if (copy > len)
 				copy = len;
 
-			sg.page = frag->page;
+			sg_set_page(&sg, frag->page);
 			sg.offset = frag->page_offset + offset-start;
 			sg.length = copy;
 

-- 
Jens Axboe

