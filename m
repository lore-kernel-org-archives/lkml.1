Return-Path: <linux-kernel-owner+w=401wt.eu-S1756522AbYAHJi0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbYAHJi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 04:38:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754731AbYAHJiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 04:38:19 -0500
Received: from ns2.suse.de ([195.135.220.15]:51665 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYAHJiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 04:38:17 -0500
Date: Tue, 8 Jan 2008 10:38:15 +0100
From: Nick Piggin <npiggin@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: airlied@linux.ie, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 1/3] drm: nopage
Message-ID: <20080108093815.GA14302@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave, this patch is against 2.6.24-rc6-mm1. You said git-drm had rewritten this area,
but the patch didn't have any rejects and seems to run fine here (although I'm not
exactly sure how to exercise drm too well).

Anyway, please apply.

--

drm: nopage

Convert drm from nopage to fault.
Remove redundant vma range checks.

Signed-off-by: Nick Piggin <npiggin@suse.de>
Cc: airlied@linux.ie
Cc: linux-kernel@vger.kernel.org
---
 drivers/char/drm/drm_vm.c |  131 +++++++++++++++++++++-------------------------
 1 file changed, 61 insertions(+), 70 deletions(-)

Index: linux-2.6/drivers/char/drm/drm_vm.c
===================================================================
--- linux-2.6.orig/drivers/char/drm/drm_vm.c
+++ linux-2.6/drivers/char/drm/drm_vm.c
@@ -70,7 +70,7 @@ static pgprot_t drm_io_prot(uint32_t map
 }
 
 /**
- * \c nopage method for AGP virtual memory.
+ * \c fault method for AGP virtual memory.
  *
  * \param vma virtual memory area.
  * \param address access address.
@@ -80,8 +80,8 @@ static pgprot_t drm_io_prot(uint32_t map
  * map, get the page, increment the use count and return it.
  */
 #if __OS_HAS_AGP
-static __inline__ struct page *drm_do_vm_nopage(struct vm_area_struct *vma,
-						unsigned long address)
+static __inline__ int drm_do_vm_fault(struct vm_area_struct *vma,
+						struct vm_fault *vmf)
 {
 	struct drm_file *priv = vma->vm_file->private_data;
 	struct drm_device *dev = priv->head->dev;
@@ -93,19 +93,24 @@ static __inline__ struct page *drm_do_vm
 	 * Find the right map
 	 */
 	if (!drm_core_has_AGP(dev))
-		goto vm_nopage_error;
+		goto vm_fault_error;
 
 	if (!dev->agp || !dev->agp->cant_use_aperture)
-		goto vm_nopage_error;
+		goto vm_fault_error;
 
 	if (drm_ht_find_item(&dev->map_hash, vma->vm_pgoff, &hash))
-		goto vm_nopage_error;
+		goto vm_fault_error;
 
 	r_list = drm_hash_entry(hash, struct drm_map_list, hash);
 	map = r_list->map;
 
 	if (map && map->type == _DRM_AGP) {
-		unsigned long offset = address - vma->vm_start;
+		/*
+		 * Using vm_pgoff as a selector forces us to use this unusual
+		 * addressing scheme.
+		 */
+		unsigned long offset = (unsigned long)vmf->virtual_address -
+								vma->vm_start;
 		unsigned long baddr = map->offset + offset;
 		struct drm_agp_mem *agpmem;
 		struct page *page;
@@ -127,7 +132,7 @@ static __inline__ struct page *drm_do_vm
 		}
 
 		if (!agpmem)
-			goto vm_nopage_error;
+			goto vm_fault_error;
 
 		/*
 		 * Get the page, inc the use count, and return it
@@ -135,27 +140,28 @@ static __inline__ struct page *drm_do_vm
 		offset = (baddr - agpmem->bound) >> PAGE_SHIFT;
 		page = virt_to_page(__va(agpmem->memory->memory[offset]));
 		get_page(page);
+		vmf->page = page;
 
 		DRM_DEBUG
 		    ("baddr = 0x%lx page = 0x%p, offset = 0x%lx, count=%d\n",
 		     baddr, __va(agpmem->memory->memory[offset]), offset,
 		     page_count(page));
 
-		return page;
+		return 0;
 	}
-      vm_nopage_error:
-	return NOPAGE_SIGBUS;	/* Disallow mremap */
+      vm_fault_error:
+	return VM_FAULT_SIGBUS;	/* Disallow mremap */
 }
 #else				/* __OS_HAS_AGP */
-static __inline__ struct page *drm_do_vm_nopage(struct vm_area_struct *vma,
-						unsigned long address)
+static __inline__ int drm_do_vm_fault(struct vm_area_struct *vma,
+						struct vm_fault *vmf)
 {
-	return NOPAGE_SIGBUS;
+	return VM_FAULT_SIGBUS;
 }
 #endif				/* __OS_HAS_AGP */
 
 /**
- * \c nopage method for shared virtual memory.
+ * \c fault method for shared virtual memory.
  *
  * \param vma virtual memory area.
  * \param address access address.
@@ -164,28 +170,27 @@ static __inline__ struct page *drm_do_vm
  * Get the mapping, find the real physical page to map, get the page, and
  * return it.
  */
-static __inline__ struct page *drm_do_vm_shm_nopage(struct vm_area_struct *vma,
-						    unsigned long address)
+static __inline__ int drm_do_vm_shm_fault(struct vm_area_struct *vma,
+						    struct vm_fault *vmf)
 {
 	struct drm_map *map = (struct drm_map *) vma->vm_private_data;
 	unsigned long offset;
 	unsigned long i;
 	struct page *page;
 
-	if (address > vma->vm_end)
-		return NOPAGE_SIGBUS;	/* Disallow mremap */
 	if (!map)
-		return NOPAGE_SIGBUS;	/* Nothing allocated */
+		return VM_FAULT_SIGBUS;	/* Nothing allocated */
 
-	offset = address - vma->vm_start;
+	offset = (unsigned long)vmf->virtual_address - vma->vm_start;
 	i = (unsigned long)map->handle + offset;
 	page = vmalloc_to_page((void *)i);
 	if (!page)
-		return NOPAGE_SIGBUS;
+		return VM_FAULT_SIGBUS;
 	get_page(page);
+	vmf->page = page;
 
-	DRM_DEBUG("shm_nopage 0x%lx\n", address);
-	return page;
+	DRM_DEBUG("shm_fault 0x%lx\n", offset);
+	return 0;
 }
 
 /**
@@ -270,7 +275,7 @@ static void drm_vm_shm_close(struct vm_a
 }
 
 /**
- * \c nopage method for DMA virtual memory.
+ * \c fault method for DMA virtual memory.
  *
  * \param vma virtual memory area.
  * \param address access address.
@@ -278,8 +283,8 @@ static void drm_vm_shm_close(struct vm_a
  *
  * Determine the page number from the page offset and get it from drm_device_dma::pagelist.
  */
-static __inline__ struct page *drm_do_vm_dma_nopage(struct vm_area_struct *vma,
-						    unsigned long address)
+static __inline__ int drm_do_vm_dma_fault(struct vm_area_struct *vma,
+						    struct vm_fault *vmf)
 {
 	struct drm_file *priv = vma->vm_file->private_data;
 	struct drm_device *dev = priv->head->dev;
@@ -289,24 +294,23 @@ static __inline__ struct page *drm_do_vm
 	struct page *page;
 
 	if (!dma)
-		return NOPAGE_SIGBUS;	/* Error */
-	if (address > vma->vm_end)
-		return NOPAGE_SIGBUS;	/* Disallow mremap */
+		return VM_FAULT_SIGBUS;	/* Error */
 	if (!dma->pagelist)
-		return NOPAGE_SIGBUS;	/* Nothing allocated */
+		return VM_FAULT_SIGBUS;	/* Nothing allocated */
 
-	offset = address - vma->vm_start;	/* vm_[pg]off[set] should be 0 */
-	page_nr = offset >> PAGE_SHIFT;
+	offset = (unsigned long)vmf->virtual_address - vma->vm_start;	/* vm_[pg]off[set] should be 0 */
+	page_nr = offset >> PAGE_SHIFT; /* page_nr could just be vmf->pgoff */
 	page = virt_to_page((dma->pagelist[page_nr] + (offset & (~PAGE_MASK))));
 
 	get_page(page);
+	vmf->page = page;
 
-	DRM_DEBUG("dma_nopage 0x%lx (page %lu)\n", address, page_nr);
-	return page;
+	DRM_DEBUG("dma_fault 0x%lx (page %lu)\n", offset, page_nr);
+	return 0;
 }
 
 /**
- * \c nopage method for scatter-gather virtual memory.
+ * \c fault method for scatter-gather virtual memory.
  *
  * \param vma virtual memory area.
  * \param address access address.
@@ -314,8 +318,8 @@ static __inline__ struct page *drm_do_vm
  *
  * Determine the map offset from the page offset and get it from drm_sg_mem::pagelist.
  */
-static __inline__ struct page *drm_do_vm_sg_nopage(struct vm_area_struct *vma,
-						   unsigned long address)
+static __inline__ int drm_do_vm_sg_fault(struct vm_area_struct *vma,
+						   struct vm_fault *vmf)
 {
 	struct drm_map *map = (struct drm_map *) vma->vm_private_data;
 	struct drm_file *priv = vma->vm_file->private_data;
@@ -327,77 +331,64 @@ static __inline__ struct page *drm_do_vm
 	struct page *page;
 
 	if (!entry)
-		return NOPAGE_SIGBUS;	/* Error */
-	if (address > vma->vm_end)
-		return NOPAGE_SIGBUS;	/* Disallow mremap */
+		return VM_FAULT_SIGBUS;	/* Error */
 	if (!entry->pagelist)
-		return NOPAGE_SIGBUS;	/* Nothing allocated */
+		return VM_FAULT_SIGBUS;	/* Nothing allocated */
 
-	offset = address - vma->vm_start;
+	offset = (unsigned long)vmf->virtual_address - vma->vm_start;
 	map_offset = map->offset - (unsigned long)dev->sg->virtual;
 	page_offset = (offset >> PAGE_SHIFT) + (map_offset >> PAGE_SHIFT);
 	page = entry->pagelist[page_offset];
 	get_page(page);
+	vmf->page = page;
 
-	return page;
+	return 0;
 }
 
-static struct page *drm_vm_nopage(struct vm_area_struct *vma,
-				  unsigned long address, int *type)
+static int drm_vm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return drm_do_vm_nopage(vma, address);
+	return drm_do_vm_fault(vma, vmf);
 }
 
-static struct page *drm_vm_shm_nopage(struct vm_area_struct *vma,
-				      unsigned long address, int *type)
+static int drm_vm_shm_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return drm_do_vm_shm_nopage(vma, address);
+	return drm_do_vm_shm_fault(vma, vmf);
 }
 
-static struct page *drm_vm_dma_nopage(struct vm_area_struct *vma,
-				      unsigned long address, int *type)
+static int drm_vm_dma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return drm_do_vm_dma_nopage(vma, address);
+	return drm_do_vm_dma_fault(vma, vmf);
 }
 
-static struct page *drm_vm_sg_nopage(struct vm_area_struct *vma,
-				     unsigned long address, int *type)
+static int drm_vm_sg_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
-	if (type)
-		*type = VM_FAULT_MINOR;
-	return drm_do_vm_sg_nopage(vma, address);
+	return drm_do_vm_sg_fault(vma, vmf);
 }
 
 /** AGP virtual memory operations */
 static struct vm_operations_struct drm_vm_ops = {
-	.nopage = drm_vm_nopage,
+	.fault = drm_vm_fault,
 	.open = drm_vm_open,
 	.close = drm_vm_close,
 };
 
 /** Shared virtual memory operations */
 static struct vm_operations_struct drm_vm_shm_ops = {
-	.nopage = drm_vm_shm_nopage,
+	.fault = drm_vm_shm_fault,
 	.open = drm_vm_open,
 	.close = drm_vm_shm_close,
 };
 
 /** DMA virtual memory operations */
 static struct vm_operations_struct drm_vm_dma_ops = {
-	.nopage = drm_vm_dma_nopage,
+	.fault = drm_vm_dma_fault,
 	.open = drm_vm_open,
 	.close = drm_vm_close,
 };
 
 /** Scatter-gather virtual memory operations */
 static struct vm_operations_struct drm_vm_sg_ops = {
-	.nopage = drm_vm_sg_nopage,
+	.fault = drm_vm_sg_fault,
 	.open = drm_vm_open,
 	.close = drm_vm_close,
 };
@@ -610,7 +601,7 @@ static int drm_mmap_locked(struct file *
 			/*
 			 * On some platforms we can't talk to bus dma address from the CPU, so for
 			 * memory of type DRM_AGP, we'll deal with sorting out the real physical
-			 * pages and mappings in nopage()
+			 * pages and mappings in fault()
 			 */
 #if defined(__powerpc__)
 			pgprot_val(vma->vm_page_prot) |= _PAGE_NO_CACHE;
@@ -640,7 +631,7 @@ static int drm_mmap_locked(struct file *
 		break;
 	case _DRM_CONSISTENT:
 		/* Consistent memory is really like shared memory. But
-		 * it's allocated in a different way, so avoid nopage */
+		 * it's allocated in a different way, so avoid fault */
 		if (remap_pfn_range(vma, vma->vm_start,
 		    page_to_pfn(virt_to_page(map->handle)),
 		    vma->vm_end - vma->vm_start, vma->vm_page_prot))
