Return-Path: <linux-kernel-owner+w=401wt.eu-S1760310AbYCEEw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310AbYCEEw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 23:52:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758988AbYCEEwO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 23:52:14 -0500
Received: from gate.crashing.org ([63.228.1.57]:46129 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758866AbYCEEv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 23:51:56 -0500
Subject: [PATCH] drm: Fix for non-coherent DMA PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: airlied <airlied@linux.ie>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.sourceforge.net>
Content-Type: text/plain
Date: Wed, 05 Mar 2008 15:51:15 +1100
Message-Id: <1204692675.21545.156.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes bits of the DRM so to make the radeon DRI work on
non-cache coherent PCI DMA variants of the PowerPC processors.

It moves the few places that needs change to wrappers to that
other architectures with similar issues can easily add their
own changes to those wrappers, at least until we have more useful
generic kernel API.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---

This version of the patch removes the use of GFP_HIGHMEM on powerpc
as our implementation of some of the DMA mapping ops on non cache
coherent platforms don't work on highmem.

Index: linux-work/drivers/char/drm/ati_pcigart.c
===================================================================
--- linux-work.orig/drivers/char/drm/ati_pcigart.c	2008-02-18 10:09:27.000000000 +1100
+++ linux-work/drivers/char/drm/ati_pcigart.c	2008-03-05 15:42:02.000000000 +1100
@@ -214,6 +214,12 @@ int drm_ati_pcigart_init(struct drm_devi
 		}
 	}
 
+	if (gart_info->gart_table_location == DRM_ATI_GART_MAIN)
+		dma_sync_single_for_device(&dev->pdev->dev,
+					   bus_address,
+					   max_pages * sizeof(u32),
+					   PCI_DMA_TODEVICE);
+
 	ret = 1;
 
 #if defined(__i386__) || defined(__x86_64__)
Index: linux-work/drivers/char/drm/drm_scatter.c
===================================================================
--- linux-work.orig/drivers/char/drm/drm_scatter.c	2008-02-18 10:09:27.000000000 +1100
+++ linux-work/drivers/char/drm/drm_scatter.c	2008-03-05 15:48:55.000000000 +1100
@@ -36,6 +36,15 @@
 
 #define DEBUG_SCATTER 0
 
+static inline void *drm_vmalloc_dma(unsigned long size)
+{
+#if defined(__powerpc__) && defined(CONFIG_NOT_COHERENT_CACHE)
+	return __vmalloc(size, GFP_KERNEL, PAGE_KERNEL | _PAGE_NO_CACHE);
+#else
+	return vmalloc_32(size);
+#endif
+}
+
 void drm_sg_cleanup(struct drm_sg_mem * entry)
 {
 	struct page *page;
@@ -104,7 +113,7 @@ int drm_sg_alloc(struct drm_device *dev,
 	}
 	memset((void *)entry->busaddr, 0, pages * sizeof(*entry->busaddr));
 
-	entry->virtual = vmalloc_32(pages << PAGE_SHIFT);
+	entry->virtual = drm_vmalloc_dma(pages << PAGE_SHIFT);
 	if (!entry->virtual) {
 		drm_free(entry->busaddr,
 			 entry->pages * sizeof(*entry->busaddr), DRM_MEM_PAGES);
Index: linux-work/drivers/char/drm/drm_vm.c
===================================================================
--- linux-work.orig/drivers/char/drm/drm_vm.c	2008-02-21 13:34:16.000000000 +1100
+++ linux-work/drivers/char/drm/drm_vm.c	2008-03-05 15:42:02.000000000 +1100
@@ -54,13 +54,24 @@ static pgprot_t drm_io_prot(uint32_t map
 	pgprot_val(tmp) |= _PAGE_NO_CACHE;
 	if (map_type == _DRM_REGISTERS)
 		pgprot_val(tmp) |= _PAGE_GUARDED;
-#endif
-#if defined(__ia64__)
+#elif defined(__ia64__)
 	if (efi_range_is_wc(vma->vm_start, vma->vm_end -
 				    vma->vm_start))
 		tmp = pgprot_writecombine(tmp);
 	else
 		tmp = pgprot_noncached(tmp);
+#elif defined(__sparc__)
+	tmp = pgprot_noncached(tmp);
+#endif
+	return tmp;
+}
+
+static pgprot_t drm_dma_prot(uint32_t map_type, struct vm_area_struct *vma)
+{
+	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
+
+#if defined(__powerpc__) && defined(CONFIG_NOT_COHERENT_CACHE)
+	tmp |= _PAGE_NO_CACHE;
 #endif
 	return tmp;
 }
@@ -603,9 +614,6 @@ static int drm_mmap_locked(struct file *
 		offset = dev->driver->get_reg_ofs(dev);
 		vma->vm_flags |= VM_IO;	/* not in core dump */
 		vma->vm_page_prot = drm_io_prot(map->type, vma);
-#ifdef __sparc__
-		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
-#endif
 		if (io_remap_pfn_range(vma, vma->vm_start,
 				       (map->offset + offset) >> PAGE_SHIFT,
 				       vma->vm_end - vma->vm_start,
@@ -624,6 +632,7 @@ static int drm_mmap_locked(struct file *
 		    page_to_pfn(virt_to_page(map->handle)),
 		    vma->vm_end - vma->vm_start, vma->vm_page_prot))
 			return -EAGAIN;
+		vma->vm_page_prot = drm_dma_prot(map->type, vma);
 	/* fall through to _DRM_SHM */
 	case _DRM_SHM:
 		vma->vm_ops = &drm_vm_shm_ops;
@@ -636,6 +645,7 @@ static int drm_mmap_locked(struct file *
 		vma->vm_ops = &drm_vm_sg_ops;
 		vma->vm_private_data = (void *)map;
 		vma->vm_flags |= VM_RESERVED;
+		vma->vm_page_prot = drm_dma_prot(map->type, vma);
 		break;
 	default:
 		return -EINVAL;	/* This should never happen. */


