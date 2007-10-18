Return-Path: <linux-kernel-owner+w=401wt.eu-S1762107AbXJRIWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762107AbXJRIWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 04:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbXJRIW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 04:22:26 -0400
Received: from brick.kernel.dk ([87.55.233.238]:19341 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755102AbXJRIWW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:22:22 -0400
Date: Thu, 18 Oct 2007 10:21:45 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: David Miller <davem@davemloft.net>
Cc: torvalds@linux-foundation.org, fujita.tomonori@lab.ntt.co.jp,
       mingo@elte.hu, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       alan@lxorguk.ukuu.org.uk, tomof@acm.org
Subject: Re: [bug] ata subsystem related crash with latest -git
Message-ID: <20071018082145.GK5063@kernel.dk>
References: <alpine.LFD.0.999.0710171342550.26902@woody.linux-foundation.org> <20071018080048O.fujita.tomonori@lab.ntt.co.jp> <alpine.LFD.0.999.0710171801000.26902@woody.linux-foundation.org> <20071017.181907.63126798.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071017.181907.63126798.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17 2007, David Miller wrote:
> From: Linus Torvalds <torvalds@linux-foundation.org>
> Date: Wed, 17 Oct 2007 18:07:19 -0700 (PDT)
> 
> > sg_next() - as it stands now - never actually looks at the SG that its 
> > argument points to: it explicitly *only* looks at the next one.
> > 
> > That's the bug. If sg_next() looked at the actual *current* sg entry, we 
> > wouldn't have any issues to begin with, and that's what I'm arguing we 
> > should do in the longer run (where "longer run" is defined as "when Jens 
> > does it asap").
> 
> What the thing really wants is some kind of indication of state,
> without having to bloat up the scatterlist structure.
> 
> I believe that we have enough of a limited set of accessors to
> sg->page that we can more aggressively encode things in the lower
> bits.
> 
> I'm thinking of encoding the low two bits of sg->page as
> follows:
> 
> 1) bits == 0
> 
>    then the SG list is linear and sg_next() is sg++
> 
> 2) bits == 1
> 
>    the nest SG is an indirect chunk, sg_next() is
>    therefore something like:
> 
> 	next = *((struct scatterlist **)(sg + 1));
> 
> 3) bits == 2
> 
>    this is the last entry in the scatterlist, sg_next() is NULL
> 
> So for the cases of ARCH_HAS_SG_CHAIN not being set (ie. back
> compatible), we can do no bit encoding in page->flags and just do
> sg_next() == sg++, as is done now.
> 
> When doing SG chaining, in each non-linear chunk we have to allocate
> one more pointer past the end of the scatterlist array (instead of a
> full extra scatterlist entry for the indirect pointer encode).  Next,
> all sg->page accesses have to be guarded to clear the state bits
> out first.
> 
> I don't know, maybe it would work, and would make the loop termination
> issues easier to handle properly.

I like it. Basically the only real change is using bit 2 as a
termination point, so we avoid going beyond the end of the sgtable.
Here's a starting point, it actually booted for me in the first go
(boggle). Only x86 so far, archs will need to be converted. And lots
more drivers I'm sure, I only fixed up the ones that botched my compile.

So just consider this a directional patch.

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
index 3935469..d02783c 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -1354,10 +1354,11 @@ new_segment:
 			else
 				sg = sg_next(sg);
 
-			memset(sg, 0, sizeof(*sg));
-			sg->page = bvec->bv_page;
+			sg_set_page(sg, bvec->bv_page);
 			sg->length = nbytes;
 			sg->offset = bvec->bv_offset;
+			sg_dma_len(sg) = 0;
+			sg_dma_address(sg) = 0;
 			nsegs++;
 		}
 		bvprv = bvec;
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
index aac8a02..4ee32e5 100644
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
diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index c021af3..98c455d 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -443,7 +443,7 @@ int usb_sg_init (
 		} else {
 			/* hc may use _only_ transfer_buffer */
 			io->urbs [i]->transfer_buffer =
-				page_address (sg [i].page) + sg [i].offset;
+				page_address(sg_page(&sg[i])) + sg [i].offset;
 			len = sg [i].length;
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
diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
index 2dc7464..cbc2b57 100644
--- a/include/linux/scatterlist.h
+++ b/include/linux/scatterlist.h
@@ -5,10 +5,24 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 
+#define SG_MAGIC	0x87654321
+
+static inline void sg_set_page(struct scatterlist *sg, struct page *page)
+{
+	unsigned long page_link = sg->page_link & 0x3;
+
+	sg->page_link = page_link | (unsigned long) page;
+}
+
+#define sg_page(sg)	((struct page *) ((sg)->page_link & ~0x3))
+
 static inline void sg_set_buf(struct scatterlist *sg, const void *buf,
 			      unsigned int buflen)
 {
-	sg->page = virt_to_page(buf);
+#ifdef CONFIG_DEBUG_SG
+	sg->sg_magic = SG_MAGIC;
+#endif
+	sg_set_page(sg, virt_to_page(buf));
 	sg->offset = offset_in_page(buf);
 	sg->length = buflen;
 }
@@ -25,9 +39,9 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
  * a valid sg entry, or whether it points to the start of a new scatterlist.
  * Those low bits are there for everyone! (thanks mason :-)
  */
-#define sg_is_chain(sg)		((unsigned long) (sg)->page & 0x01)
-#define sg_chain_ptr(sg)	\
-	((struct scatterlist *) ((unsigned long) (sg)->page & ~0x01))
+#define sg_is_chain(sg)		((sg)->page_link & 0x01)
+#define sg_is_last(sg)		((sg)->page_link & 0x02)
+#define sg_chain_ptr(sg)	((struct scatterlist *) ((sg)->page_link & ~0x01))
 
 /**
  * sg_next - return the next scatterlist entry in a list
@@ -43,10 +57,15 @@ static inline void sg_init_one(struct scatterlist *sg, const void *buf,
  */
 static inline struct scatterlist *sg_next(struct scatterlist *sg)
 {
-	sg++;
-
-	if (unlikely(sg_is_chain(sg)))
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sg->sg_magic != SG_MAGIC);
+#endif
+	if (sg_is_last(sg))
+		sg = NULL;
+	else if (sg_is_chain(sg))
 		sg = sg_chain_ptr(sg);
+	else
+		sg++;
 
 	return sg;
 }
@@ -83,6 +102,9 @@ static inline struct scatterlist *sg_last(struct scatterlist *sgl,
 		ret = sg;
 
 #endif
+#ifdef CONFIG_DEBUG_SG
+	BUG_ON(sgl[0].sg_magic != SG_MAGIC);
+#endif
 	return ret;
 }
 
@@ -101,7 +123,41 @@ static inline void sg_chain(struct scatterlist *prv, unsigned int prv_nents,
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
+ * sg_init_table - Initialize an sg table
+ * @sgl:	Scatterlist
+ * @nents:	Number of entries in sgl
+ *
+ * Marks the last entry as the termination point for sg_next()
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
index 7d16e64..c17aace 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -389,6 +389,17 @@ config DEBUG_LIST
 
 	  If unsure, say N.
 
+config DEBUG_SG
+	bool "Debug SG table operations"
+	depends on DEBUG_KERNEL
+	help
+	  Enable this to turn on checks on scatter-gather tables. This can
+	  help find problems with drivers that do not properly initialize
+	  their sg tables. Runtime overhead is very small, but it does
+	  increase an sg entry by sizeof(unsigned long).
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
diff --git a/net/ieee80211/ieee80211_crypt_wep.c b/net/ieee80211/ieee80211_crypt_wep.c
index 8d18245..1a77877 100644
--- a/net/ieee80211/ieee80211_crypt_wep.c
+++ b/net/ieee80211/ieee80211_crypt_wep.c
@@ -170,7 +170,8 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	icv[3] = crc >> 24;
 
 	crypto_blkcipher_setkey(wep->tx_tfm, key, klen);
-	sg.page = virt_to_page(pos);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(pos));
 	sg.offset = offset_in_page(pos);
 	sg.length = len + 4;
 	return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
@@ -212,7 +213,8 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	crypto_blkcipher_setkey(wep->rx_tfm, key, klen);
-	sg.page = virt_to_page(pos);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(pos));
 	sg.offset = offset_in_page(pos);
 	sg.length = plen + 4;
 	if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4))
diff --git a/net/mac80211/wep.c b/net/mac80211/wep.c
index 6675261..9857961 100644
--- a/net/mac80211/wep.c
+++ b/net/mac80211/wep.c
@@ -138,7 +138,8 @@ void ieee80211_wep_encrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	*icv = cpu_to_le32(~crc32_le(~0, data, data_len));
 
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg.page = virt_to_page(data);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(data));
 	sg.offset = offset_in_page(data);
 	sg.length = data_len + WEP_ICV_LEN;
 	crypto_blkcipher_encrypt(&desc, &sg, &sg, sg.length);
@@ -204,7 +205,8 @@ int ieee80211_wep_decrypt_data(struct crypto_blkcipher *tfm, u8 *rc4key,
 	__le32 crc;
 
 	crypto_blkcipher_setkey(tfm, rc4key, klen);
-	sg.page = virt_to_page(data);
+	sg_init_table(&sg, 1);
+	sg_set_page(&sg, virt_to_page(data));
 	sg.offset = offset_in_page(data);
 	sg.length = data_len + WEP_ICV_LEN;
 	crypto_blkcipher_decrypt(&desc, &sg, &sg, sg.length);
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

