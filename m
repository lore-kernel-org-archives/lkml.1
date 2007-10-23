Return-Path: <linux-kernel-owner+w=401wt.eu-S1753272AbXJWL2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272AbXJWL2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 07:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXJWL2h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 07:28:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57780 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751491AbXJWL2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 07:28:35 -0400
Date: Tue, 23 Oct 2007 13:27:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
Message-ID: <20071023112738.GA13847@elte.hu>
References: <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk> <20071023103351.GA2795@elte.hu> <20071023105615.GI5059@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071023105615.GI5059@kernel.dk>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > Linus' latest tree, which has your SG-list enhancements included, 
> > certainly works fine here and does not have the problems of the 
> > first iteration.
> 
> That's good to hear :-)
> 
> I have a series of pending patches where I've collected fallout 
> patches from people and some from myself here:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=shortlog;h=sg
> 
> or pullable from
> 
> git://git.kernel.dk/inux-2.6-block.git sg

i've attached your fixes as a diff against linus-latest below - for 
those who'd like to have it in patch form.

	Ingo

diff --git a/arch/alpha/kernel/pci_iommu.c b/arch/alpha/kernel/pci_iommu.c
index ee07dce..2d00a08 100644
--- a/arch/alpha/kernel/pci_iommu.c
+++ b/arch/alpha/kernel/pci_iommu.c
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/slab.h>
 #include <linux/bootmem.h>
+#include <linux/scatterlist.h>
 #include <linux/log2.h>
 
 #include <asm/io.h>
diff --git a/arch/arm/common/dmabounce.c b/arch/arm/common/dmabounce.c
index 9d371e4..52fc6a8 100644
--- a/arch/arm/common/dmabounce.c
+++ b/arch/arm/common/dmabounce.c
@@ -29,6 +29,7 @@
 #include <linux/dma-mapping.h>
 #include <linux/dmapool.h>
 #include <linux/list.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cacheflush.h>
 
diff --git a/arch/mips/mm/dma-default.c b/arch/mips/mm/dma-default.c
index b0b034c..b1b4052 100644
--- a/arch/mips/mm/dma-default.c
+++ b/arch/mips/mm/dma-default.c
@@ -13,6 +13,7 @@
 #include <linux/mm.h>
 #include <linux/module.h>
 #include <linux/string.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cache.h>
 #include <asm/io.h>
diff --git a/arch/parisc/kernel/pci-dma.c b/arch/parisc/kernel/pci-dma.c
index 41f8e32..9448d4e 100644
--- a/arch/parisc/kernel/pci-dma.c
+++ b/arch/parisc/kernel/pci-dma.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/types.h>
+#include <linux/scatterlist.h>
 
 #include <asm/cacheflush.h>
 #include <asm/dma.h>    /* for DMA_CHUNK_SIZE */
diff --git a/arch/sparc64/kernel/iommu_common.c b/arch/sparc64/kernel/iommu_common.c
index 78e8277..b70324e 100644
--- a/arch/sparc64/kernel/iommu_common.c
+++ b/arch/sparc64/kernel/iommu_common.c
@@ -233,6 +233,11 @@ unsigned long prepare_sg(struct scatterlist *sg, int nents)
 	dma_sg->dma_address = dent_addr;
 	dma_sg->dma_length = dent_len;
 
+	if (dma_sg != sg) {
+		dma_sg = next_sg(dma_sg);
+		dma_sg->dma_length = 0;
+	}
+
 	return ((unsigned long) dent_addr +
 		(unsigned long) dent_len +
 		(IO_PAGE_SIZE - 1UL)) >> IO_PAGE_SHIFT;
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 61c2e39..de5ba47 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1351,11 +1351,21 @@ int blk_rq_map_sg(struct request_queue *q, struct request *rq,
 new_segment:
 			if (!sg)
 				sg = sglist;
-			else
+			else {
+				/*
+				 * If the driver previously mapped a shorter
+				 * list, we could see a termination bit
+				 * prematurely unless it fully inits the sg
+				 * table on each mapping. We KNOW that there
+				 * must be more entries here or the driver
+				 * would be buggy, so force clear the
+				 * termination bit to avoid doing a full
+				 * sg_init_table() in drivers for each command.
+				 */
+				sg->page_link &= ~0x02;
 				sg = sg_next(sg);
+			}
 
-			sg_dma_len(sg) = 0;
-			sg_dma_address(sg) = 0;
 			sg_set_page(sg, bvec->bv_page);
 			sg->length = nbytes;
 			sg->offset = bvec->bv_offset;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index ec55a17..6a6f2e0 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -47,6 +47,7 @@
 #include <linux/spinlock.h>
 #include <linux/kmod.h>
 #include <linux/pci.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/irq.h>
diff --git a/drivers/infiniband/hw/ehca/ehca_mrmw.c b/drivers/infiniband/hw/ehca/ehca_mrmw.c
index da88738..ead7230 100644
--- a/drivers/infiniband/hw/ehca/ehca_mrmw.c
+++ b/drivers/infiniband/hw/ehca/ehca_mrmw.c
@@ -1776,7 +1776,7 @@ static int ehca_set_pagebuf_user1(struct ehca_mr_pginfo *pginfo,
 	list_for_each_entry_continue(
 		chunk, (&(pginfo->u.usr.region->chunk_list)), list) {
 		for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
-			pgaddr = page_to_pfn(chunk->page_list[i].page)
+			pgaddr = page_to_pfn(sg_page(&chunk->page_list[i]))
 				<< PAGE_SHIFT ;
 			*kpage = phys_to_abs(pgaddr +
 					     (pginfo->next_hwpage *
@@ -1832,7 +1832,7 @@ static int ehca_check_kpages_per_ate(struct scatterlist *page_list,
 {
 	int t;
 	for (t = start_idx; t <= end_idx; t++) {
-		u64 pgaddr = page_to_pfn(page_list[t].page) << PAGE_SHIFT;
+		u64 pgaddr = page_to_pfn(sg_page(&page_list[t])) << PAGE_SHIFT;
 		ehca_gen_dbg("chunk_page=%lx value=%016lx", pgaddr,
 			     *(u64 *)abs_to_virt(phys_to_abs(pgaddr)));
 		if (pgaddr - PAGE_SIZE != *prev_pgaddr) {
@@ -1867,7 +1867,7 @@ static int ehca_set_pagebuf_user2(struct ehca_mr_pginfo *pginfo,
 		chunk, (&(pginfo->u.usr.region->chunk_list)), list) {
 		for (i = pginfo->u.usr.next_nmap; i < chunk->nmap; ) {
 			if (nr_kpages == kpages_per_hwpage) {
-				pgaddr = ( page_to_pfn(chunk->page_list[i].page)
+				pgaddr = ( page_to_pfn(sg_page(&chunk->page_list[i]))
 					   << PAGE_SHIFT );
 				*kpage = phys_to_abs(pgaddr);
 				if ( !(*kpage) ) {
diff --git a/drivers/parisc/ccio-dma.c b/drivers/parisc/ccio-dma.c
index b3c4dbf..7c60cbd 100644
--- a/drivers/parisc/ccio-dma.c
+++ b/drivers/parisc/ccio-dma.c
@@ -42,6 +42,7 @@
 #include <linux/reboot.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/cache.h>		/* for L1_CACHE_BYTES */
diff --git a/drivers/parisc/sba_iommu.c b/drivers/parisc/sba_iommu.c
index e5c3239..e527a0e 100644
--- a/drivers/parisc/sba_iommu.c
+++ b/drivers/parisc/sba_iommu.c
@@ -28,6 +28,7 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/pci.h>
+#include <linux/scatterlist.h>
 
 #include <asm/byteorder.h>
 #include <asm/io.h>
diff --git a/drivers/pci/intel-iommu.c b/drivers/pci/intel-iommu.c
index b3d7031..0c4ab3b 100644
--- a/drivers/pci/intel-iommu.c
+++ b/drivers/pci/intel-iommu.c
@@ -1962,7 +1962,7 @@ static void intel_free_coherent(struct device *hwdev, size_t size,
 	free_pages((unsigned long)vaddr, order);
 }
 
-#define SG_ENT_VIRT_ADDRESS(sg)	(page_address((sg)->page) + (sg)->offset)
+#define SG_ENT_VIRT_ADDRESS(sg)	(sg_virt((sg)))
 static void intel_unmap_sg(struct device *hwdev, struct scatterlist *sglist,
 	int nelems, int dir)
 {
@@ -2010,7 +2010,7 @@ static int intel_nontranslate_map_sg(struct device *hddev,
 	struct scatterlist *sg;
 
 	for_each_sg(sglist, sg, nelems, i) {
-		BUG_ON(!sg->page);
+		BUG_ON(!sg_page(sg));
 		sg->dma_address = virt_to_bus(SG_ENT_VIRT_ADDRESS(sg));
 		sg->dma_length = sg->length;
 	}
diff --git a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
index 7507067..fd5d0c1 100644
--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -559,6 +559,7 @@ zfcp_sg_list_alloc(struct zfcp_sg_list *sg_list, size_t size)
 		retval = -ENOMEM;
 		goto out;
 	}
+	sg_init_table(sg_list->sg, sg_list->count);
 
 	for (i = 0, sg = sg_list->sg; i < sg_list->count; i++, sg++) {
 		sg->length = min(size, PAGE_SIZE);
diff --git a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
index 57cac70..326e7ee 100644
--- a/drivers/s390/scsi/zfcp_def.h
+++ b/drivers/s390/scsi/zfcp_def.h
@@ -63,7 +63,7 @@
 static inline void *
 zfcp_sg_to_address(struct scatterlist *list)
 {
-	return (void *) (page_address(list->page) + list->offset);
+	return sg_virt(list);
 }
 
 /**
@@ -74,7 +74,7 @@ zfcp_sg_to_address(struct scatterlist *list)
 static inline void
 zfcp_address_to_sg(void *address, struct scatterlist *list)
 {
-	list->page = virt_to_page(address);
+	sg_set_page(list, virt_to_page(address));
 	list->offset = ((unsigned long) address) & (PAGE_SIZE - 1);
 }
 
diff --git a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
index a6475a2..9438d0b 100644
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -308,13 +308,15 @@ zfcp_erp_adisc(struct zfcp_port *port)
 	if (send_els == NULL)
 		goto nomem;
 
-	send_els->req = kzalloc(sizeof(struct scatterlist), GFP_ATOMIC);
+	send_els->req = kmalloc(sizeof(struct scatterlist), GFP_ATOMIC);
 	if (send_els->req == NULL)
 		goto nomem;
+	sg_init_table(send_els->req, 1);
 
-	send_els->resp = kzalloc(sizeof(struct scatterlist), GFP_ATOMIC);
+	send_els->resp = kmalloc(sizeof(struct scatterlist), GFP_ATOMIC);
 	if (send_els->resp == NULL)
 		goto nomem;
+	sg_init_table(send_els->resp, 1);
 
 	address = (void *) get_zeroed_page(GFP_ATOMIC);
 	if (address == NULL)
@@ -363,7 +365,7 @@ zfcp_erp_adisc(struct zfcp_port *port)
 	retval = -ENOMEM;
  freemem:
 	if (address != NULL)
-		__free_pages(send_els->req->page, 0);
+		__free_pages(sg_page(send_els->req), 0);
 	if (send_els != NULL) {
 		kfree(send_els->req);
 		kfree(send_els->resp);
@@ -437,7 +439,7 @@ zfcp_erp_adisc_handler(unsigned long data)
 
  out:
 	zfcp_port_put(port);
-	__free_pages(send_els->req->page, 0);
+	__free_pages(sg_page(send_els->req), 0);
 	kfree(send_els->req);
 	kfree(send_els->resp);
 	kfree(send_els);
diff --git a/drivers/scsi/ps3rom.c b/drivers/scsi/ps3rom.c
index 03f19b8..17b4a7c 100644
--- a/drivers/scsi/ps3rom.c
+++ b/drivers/scsi/ps3rom.c
@@ -147,7 +147,7 @@ static int fetch_to_dev_buffer(struct scsi_cmnd *cmd, void *buf)
 
 	req_len = fin = 0;
 	scsi_for_each_sg(cmd, sgpnt, scsi_sg_count(cmd), k) {
-		kaddr = kmap_atomic(sg_page(sgpnt->page), KM_IRQ0);
+		kaddr = kmap_atomic(sg_page(sgpnt), KM_IRQ0);
 		len = sgpnt->length;
 		if ((req_len + len) > buflen) {
 			len = buflen - req_len;
diff --git a/include/asm-arm/dma-mapping.h b/include/asm-arm/dma-mapping.h
index 1eb8aac..e99406a 100644
--- a/include/asm-arm/dma-mapping.h
+++ b/include/asm-arm/dma-mapping.h
@@ -5,7 +5,7 @@
 
 #include <linux/mm.h> /* need struct page */
 
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 
 /*
  * DMA-consistent mapping functions.  These allocate/free a region of
@@ -274,8 +274,8 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	for (i = 0; i < nents; i++, sg++) {
 		char *virt;
 
-		sg->dma_address = page_to_dma(dev, sg->page) + sg->offset;
-		virt = page_address(sg->page) + sg->offset;
+		sg->dma_address = page_to_dma(dev, sg_page(sg)) + sg->offset;
+		virt = sg_virt(sg);
 
 		if (!arch_is_coherent())
 			dma_cache_maint(virt, sg->length, dir);
@@ -371,7 +371,7 @@ dma_sync_sg_for_cpu(struct device *dev, struct scatterlist *sg, int nents,
 	int i;
 
 	for (i = 0; i < nents; i++, sg++) {
-		char *virt = page_address(sg->page) + sg->offset;
+		char *virt = sg_virt(sg);
 		if (!arch_is_coherent())
 			dma_cache_maint(virt, sg->length, dir);
 	}
@@ -384,7 +384,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg, int nents,
 	int i;
 
 	for (i = 0; i < nents; i++, sg++) {
-		char *virt = page_address(sg->page) + sg->offset;
+		char *virt = sg_virt(sg);
 		if (!arch_is_coherent())
 			dma_cache_maint(virt, sg->length, dir);
 	}
diff --git a/include/asm-avr32/dma-mapping.h b/include/asm-avr32/dma-mapping.h
index 81e3426..a713163 100644
--- a/include/asm-avr32/dma-mapping.h
+++ b/include/asm-avr32/dma-mapping.h
@@ -217,8 +217,8 @@ dma_map_sg(struct device *dev, struct scatterlist *sg, int nents,
 	for (i = 0; i < nents; i++) {
 		char *virt;
 
-		sg[i].dma_address = page_to_bus(sg[i].page) + sg[i].offset;
-		virt = page_address(sg[i].page) + sg[i].offset;
+		sg[i].dma_address = page_to_bus(sg_page(&sg[i])) + sg[i].offset;
+		virt = sg_virt(&sg[i]);
 		dma_cache_sync(dev, virt, sg[i].length, direction);
 	}
 
@@ -327,8 +327,7 @@ dma_sync_sg_for_device(struct device *dev, struct scatterlist *sg,
 	int i;
 
 	for (i = 0; i < nents; i++) {
-		dma_cache_sync(dev, page_address(sg[i].page) + sg[i].offset,
-			       sg[i].length, direction);
+		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, direction);
 	}
 }
 
diff --git a/include/asm-blackfin/scatterlist.h b/include/asm-blackfin/scatterlist.h
index 32128d5..04f4487 100644
--- a/include/asm-blackfin/scatterlist.h
+++ b/include/asm-blackfin/scatterlist.h
@@ -20,7 +20,6 @@ struct scatterlist {
  * returns, or alternatively stop on the first sg_dma_len(sg) which
  * is 0.
  */
-#define sg_address(sg) (page_address((sg)->page) + (sg)->offset)
 #define sg_dma_address(sg)      ((sg)->dma_address)
 #define sg_dma_len(sg)          ((sg)->length)
 
diff --git a/include/asm-frv/scatterlist.h b/include/asm-frv/scatterlist.h
index f7da007..99ba76e 100644
--- a/include/asm-frv/scatterlist.h
+++ b/include/asm-frv/scatterlist.h
@@ -4,19 +4,19 @@
 #include <asm/types.h>
 
 /*
- * Drivers must set either ->address or (preferred) ->page and ->offset
+ * Drivers must set either ->address or (preferred) page and ->offset
  * to indicate where data must be transferred to/from.
  *
- * Using ->page is recommended since it handles highmem data as well as
+ * Using page is recommended since it handles highmem data as well as
  * low mem. ->address is restricted to data which has a virtual mapping, and
- * it will go away in the future. Updating to ->page can be automated very
+ * it will go away in the future. Updating to page can be automated very
  * easily -- something like
  *
  * sg->address = some_ptr;
  *
  * can be rewritten as
  *
- * sg->page = virt_to_page(some_ptr);
+ * sg_set_page(virt_to_page(some_ptr));
  * sg->offset = (unsigned long) some_ptr & ~PAGE_MASK;
  *
  * and that's it. There's no excuse for not highmem enabling YOUR driver. /jens
diff --git a/include/asm-m68knommu/scatterlist.h b/include/asm-m68knommu/scatterlist.h
index 1094284..afc4788 100644
--- a/include/asm-m68knommu/scatterlist.h
+++ b/include/asm-m68knommu/scatterlist.h
@@ -14,7 +14,6 @@ struct scatterlist {
 	unsigned int	length;
 };
 
-#define sg_address(sg)		(page_address((sg)->page) + (sg)->offset)
 #define sg_dma_address(sg)      ((sg)->dma_address)
 #define sg_dma_len(sg)          ((sg)->length)
 
diff --git a/include/asm-parisc/scatterlist.h b/include/asm-parisc/scatterlist.h
index cd3cfdf..62269b3 100644
--- a/include/asm-parisc/scatterlist.h
+++ b/include/asm-parisc/scatterlist.h
@@ -18,7 +18,7 @@ struct scatterlist {
 	__u32      iova_length; /* bytes mapped */
 };
 
-#define sg_virt_addr(sg) ((unsigned long)(page_address(sg->page) + sg->offset))
+#define sg_virt_addr(sg) ((unsigned long)sg_virt(sg))
 #define sg_dma_address(sg) ((sg)->iova)
 #define sg_dma_len(sg)     ((sg)->iova_length)
 
diff --git a/include/asm-powerpc/dma-mapping.h b/include/asm-powerpc/dma-mapping.h
index 65be95d..ff52013 100644
--- a/include/asm-powerpc/dma-mapping.h
+++ b/include/asm-powerpc/dma-mapping.h
@@ -285,9 +285,9 @@ dma_map_sg(struct device *dev, struct scatterlist *sgl, int nents,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i) {
-		BUG_ON(!sg->page);
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
-		sg->dma_address = page_to_bus(sg->page) + sg->offset;
+		BUG_ON(!sg_page(sg));
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
+		sg->dma_address = page_to_bus(sg_page(sg)) + sg->offset;
 	}
 
 	return nents;
@@ -328,7 +328,7 @@ static inline void dma_sync_sg_for_cpu(struct device *dev,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i)
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
 static inline void dma_sync_sg_for_device(struct device *dev,
@@ -341,7 +341,7 @@ static inline void dma_sync_sg_for_device(struct device *dev,
 	BUG_ON(direction == DMA_NONE);
 
 	for_each_sg(sgl, sg, nents, i)
-		__dma_sync_page(sg->page, sg->offset, sg->length, direction);
+		__dma_sync_page(sg_page(sg), sg->offset, sg->length, direction);
 }
 
 static inline int dma_mapping_error(dma_addr_t dma_addr)
diff --git a/include/asm-sh/dma-mapping.h b/include/asm-sh/dma-mapping.h
index 84fefda..fcea067 100644
--- a/include/asm-sh/dma-mapping.h
+++ b/include/asm-sh/dma-mapping.h
@@ -2,7 +2,7 @@
 #define __ASM_SH_DMA_MAPPING_H
 
 #include <linux/mm.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <asm/cacheflush.h>
 #include <asm/io.h>
 
@@ -85,10 +85,9 @@ static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
 
 	for (i = 0; i < nents; i++) {
 #if !defined(CONFIG_PCI) || defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-		dma_cache_sync(dev, page_address(sg[i].page) + sg[i].offset,
-			       sg[i].length, dir);
+		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, dir);
 #endif
-		sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
+		sg[i].dma_address = sg_phys(&sg[i]);
 	}
 
 	return nents;
@@ -138,10 +137,9 @@ static inline void dma_sync_sg(struct device *dev, struct scatterlist *sg,
 
 	for (i = 0; i < nelems; i++) {
 #if !defined(CONFIG_PCI) || defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-		dma_cache_sync(dev, page_address(sg[i].page) + sg[i].offset,
-			       sg[i].length, dir);
+		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, dir);
 #endif
-		sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
+		sg[i].dma_address = sg_phys(&sg[i]);
 	}
 }
 
diff --git a/include/asm-sh64/dma-mapping.h b/include/asm-sh64/dma-mapping.h
index e661857..1438b76 100644
--- a/include/asm-sh64/dma-mapping.h
+++ b/include/asm-sh64/dma-mapping.h
@@ -2,7 +2,7 @@
 #define __ASM_SH_DMA_MAPPING_H
 
 #include <linux/mm.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <asm/io.h>
 
 struct pci_dev;
@@ -71,10 +71,9 @@ static inline int dma_map_sg(struct device *dev, struct scatterlist *sg,
 
 	for (i = 0; i < nents; i++) {
 #if !defined(CONFIG_PCI) || defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-		dma_cache_sync(dev, page_address(sg[i].page) + sg[i].offset,
-			       sg[i].length, dir);
+		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, dir);
 #endif
-		sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
+		sg[i].dma_address = sg_phys(&sg[i]);
 	}
 
 	return nents;
@@ -124,10 +123,9 @@ static inline void dma_sync_sg(struct device *dev, struct scatterlist *sg,
 
 	for (i = 0; i < nelems; i++) {
 #if !defined(CONFIG_PCI) || defined(CONFIG_SH_PCIDMA_NONCOHERENT)
-		dma_cache_sync(dev, page_address(sg[i].page) + sg[i].offset,
-			       sg[i].length, dir);
+		dma_cache_sync(dev, sg_virt(&sg[i]), sg[i].length, dir);
 #endif
-		sg[i].dma_address = page_to_phys(sg[i].page) + sg[i].offset;
+		sg[i].dma_address = sg_phys(&sg[i]);
 	}
 }
 
diff --git a/net/sctp/sm_make_chunk.c b/net/sctp/sm_make_chunk.c
index d5a9785..658476c 100644
--- a/net/sctp/sm_make_chunk.c
+++ b/net/sctp/sm_make_chunk.c
@@ -56,7 +56,7 @@
 #include <linux/ipv6.h>
 #include <linux/net.h>
 #include <linux/inet.h>
-#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crypto.h>
 #include <net/sock.h>
 
diff --git a/net/xfrm/xfrm_algo.c b/net/xfrm/xfrm_algo.c
index fb2220a..313d4be 100644
--- a/net/xfrm/xfrm_algo.c
+++ b/net/xfrm/xfrm_algo.c
@@ -13,6 +13,7 @@
 #include <linux/kernel.h>
 #include <linux/pfkeyv2.h>
 #include <linux/crypto.h>
+#include <linux/scatterlist.h>
 #include <net/xfrm.h>
 #if defined(CONFIG_INET_AH) || defined(CONFIG_INET_AH_MODULE) || defined(CONFIG_INET6_AH) || defined(CONFIG_INET6_AH_MODULE)
 #include <net/ah.h>
