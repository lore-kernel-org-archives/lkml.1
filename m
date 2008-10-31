Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYJaCjP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYJaCjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 22:39:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYJaCi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 22:38:56 -0400
Received: from home.keithp.com ([63.227.221.253]:60289 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753267AbYJaCiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 22:38:54 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Keith Packard <keithp@keithp.com>,
       Eric Anholt <eric@anholt.net>
Message-Id: <1225392985-6832-3-git-send-email-eric@anholt.net>
In-Reply-To: <1225392985-6832-2-git-send-email-eric@anholt.net>
References: <1225392985-6832-1-git-send-email-eric@anholt.net>
	 <1225392985-6832-2-git-send-email-eric@anholt.net>
Subject: [PATCH] i915: Use io-mapping interfaces instead of a variety of
	mapping kludges
Date: Thu, 30 Oct 2008 19:38:48 -0700
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Keith Packard <keithp@keithp.com>

Switch the i915 device aperture mapping to the io-mapping interface, taking
advantage of the cleaner API to extend it across all of the mapping uses,
including both pwrite and relocation updates.

This dramatically improves performance on 64-bit kernels which were using
the same slow path as 32-bit non-HIGHMEM kernels prior to this patch.

Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/i915/i915_drv.h |    3 +
 drivers/gpu/drm/i915/i915_gem.c |  174 ++++++++++++++++++---------------------
 2 files changed, 83 insertions(+), 94 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index cc8a9f3..572dcd0 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -31,6 +31,7 @@
 #define _I915_DRV_H_
 
 #include "i915_reg.h"
+#include <linux/io-mapping.h>
 
 /* General customization:
  */
@@ -246,6 +247,8 @@ typedef struct drm_i915_private {
 	struct {
 		struct drm_mm gtt_space;
 
+		struct io_mapping *gtt_mapping;
+
 		/**
 		 * List of objects currently involved in rendering from the
 		 * ringbuffer.
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index c1733ac..b0ec73f 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -193,35 +193,50 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 	return 0;
 }
 
-/*
- * Try to write quickly with an atomic kmap. Return true on success.
- *
- * If this fails (which includes a partial write), we'll redo the whole
- * thing with the slow version.
- *
- * This is a workaround for the low performance of iounmap (approximate
- * 10% cpu cost on normal 3D workloads).  kmap_atomic on HIGHMEM kernels
- * happens to let us map card memory without taking IPIs.  When the vmap
- * rework lands we should be able to dump this hack.
+/* This is the fast write path which cannot handle
+ * page faults in the source data
  */
-static inline int fast_user_write(unsigned long pfn, char __user *user_data,
-				  int l, int o)
+
+static inline int
+fast_user_write(struct io_mapping *mapping,
+		loff_t page_base, int page_offset,
+		char __user *user_data,
+		int length)
 {
-#ifdef CONFIG_HIGHMEM
-	unsigned long unwritten;
 	char *vaddr_atomic;
+	unsigned long unwritten;
 
-	vaddr_atomic = kmap_atomic_pfn(pfn, KM_USER0);
-#if WATCH_PWRITE
-	DRM_INFO("pwrite i %d o %d l %d pfn %ld vaddr %p\n",
-		 i, o, l, pfn, vaddr_atomic);
-#endif
-	unwritten = __copy_from_user_inatomic_nocache(vaddr_atomic + o, user_data, l);
-	kunmap_atomic(vaddr_atomic, KM_USER0);
-	return !unwritten;
-#else
+	vaddr_atomic = io_mapping_map_atomic_wc(mapping, page_base);
+	unwritten = __copy_from_user_inatomic_nocache(vaddr_atomic + page_offset,
+						      user_data, length);
+	io_mapping_unmap_atomic(vaddr_atomic);
+	if (unwritten)
+		return -EFAULT;
+	return 0;
+}
+
+/* Here's the write path which can sleep for
+ * page faults
+ */
+
+static inline int
+slow_user_write(struct io_mapping *mapping,
+		loff_t page_base, int page_offset,
+		char __user *user_data,
+		int length)
+{
+	char __iomem *vaddr;
+	unsigned long unwritten;
+
+	vaddr = io_mapping_map_wc(mapping, page_base);
+	if (vaddr == NULL)
+		return -EFAULT;
+	unwritten = __copy_from_user(vaddr + page_offset,
+				     user_data, length);
+	io_mapping_unmap(vaddr);
+	if (unwritten)
+		return -EFAULT;
 	return 0;
-#endif
 }
 
 static int
@@ -230,10 +245,12 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 		    struct drm_file *file_priv)
 {
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	ssize_t remain;
-	loff_t offset;
+	loff_t offset, page_base;
 	char __user *user_data;
-	int ret = 0;
+	int page_offset, page_length;
+	int ret;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
 	remain = args->size;
@@ -257,57 +274,37 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 	obj_priv->dirty = 1;
 
 	while (remain > 0) {
-		unsigned long pfn;
-		int i, o, l;
-
 		/* Operation in this page
 		 *
-		 * i = page number
-		 * o = offset within page
-		 * l = bytes to copy
+		 * page_base = page offset within aperture
+		 * page_offset = offset within page
+		 * page_length = bytes to copy for this page
 		 */
-		i = offset >> PAGE_SHIFT;
-		o = offset & (PAGE_SIZE-1);
-		l = remain;
-		if ((o + l) > PAGE_SIZE)
-			l = PAGE_SIZE - o;
-
-		pfn = (dev->agp->base >> PAGE_SHIFT) + i;
-
-		if (!fast_user_write(pfn, user_data, l, o)) {
-			unsigned long unwritten;
-			char __iomem *vaddr;
-
-			vaddr = ioremap_wc(pfn << PAGE_SHIFT, PAGE_SIZE);
-#if WATCH_PWRITE
-			DRM_INFO("pwrite slow i %d o %d l %d "
-				 "pfn %ld vaddr %p\n",
-				 i, o, l, pfn, vaddr);
-#endif
-			if (vaddr == NULL) {
-				ret = -EFAULT;
-				goto fail;
-			}
-			unwritten = __copy_from_user(vaddr + o, user_data, l);
-#if WATCH_PWRITE
-			DRM_INFO("unwritten %ld\n", unwritten);
-#endif
-			iounmap(vaddr);
-			if (unwritten) {
-				ret = -EFAULT;
+		page_base = (offset & ~(PAGE_SIZE-1));
+		page_offset = offset & (PAGE_SIZE-1);
+		page_length = remain;
+		if ((page_offset + remain) > PAGE_SIZE)
+			page_length = PAGE_SIZE - page_offset;
+
+		ret = fast_user_write (dev_priv->mm.gtt_mapping, page_base,
+				       page_offset, user_data, page_length);
+
+		/* If we get a fault while copying data, then (presumably) our
+		 * source page isn't available. In this case, use the
+		 * non-atomic function
+		 */
+		if (ret) {
+			ret = slow_user_write (dev_priv->mm.gtt_mapping,
+					       page_base, page_offset,
+					       user_data, page_length);
+			if (ret)
 				goto fail;
-			}
 		}
 
-		remain -= l;
-		user_data += l;
-		offset += l;
+		remain -= page_length;
+		user_data += page_length;
+		offset += page_length;
 	}
-#if WATCH_PWRITE && 1
-	i915_gem_clflush_object(obj);
-	i915_gem_dump_object(obj, args->offset + args->size, __func__, ~0);
-	i915_gem_clflush_object(obj);
-#endif
 
 fail:
 	i915_gem_object_unpin(obj);
@@ -1525,12 +1522,12 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 				 struct drm_i915_gem_exec_object *entry)
 {
 	struct drm_device *dev = obj->dev;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_gem_relocation_entry reloc;
 	struct drm_i915_gem_relocation_entry __user *relocs;
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
 	int i, ret;
-	uint32_t last_reloc_offset = -1;
-	void __iomem *reloc_page = NULL;
+	void __iomem *reloc_page;
 
 	/* Choose the GTT offset for our buffer and put it there. */
 	ret = i915_gem_object_pin(obj, (uint32_t) entry->alignment);
@@ -1653,26 +1650,11 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 		 * perform.
 		 */
 		reloc_offset = obj_priv->gtt_offset + reloc.offset;
-		if (reloc_page == NULL ||
-		    (last_reloc_offset & ~(PAGE_SIZE - 1)) !=
-		    (reloc_offset & ~(PAGE_SIZE - 1))) {
-			if (reloc_page != NULL)
-				iounmap(reloc_page);
-
-			reloc_page = ioremap_wc(dev->agp->base +
-						(reloc_offset &
-						 ~(PAGE_SIZE - 1)),
-						PAGE_SIZE);
-			last_reloc_offset = reloc_offset;
-			if (reloc_page == NULL) {
-				drm_gem_object_unreference(target_obj);
-				i915_gem_object_unpin(obj);
-				return -ENOMEM;
-			}
-		}
-
+		reloc_page = io_mapping_map_atomic_wc(dev_priv->mm.gtt_mapping,
+						      (reloc_offset &
+						       ~(PAGE_SIZE - 1)));
 		reloc_entry = (uint32_t __iomem *)(reloc_page +
-					   (reloc_offset & (PAGE_SIZE - 1)));
+						   (reloc_offset & (PAGE_SIZE - 1)));
 		reloc_val = target_obj_priv->gtt_offset + reloc.delta;
 
 #if WATCH_BUF
@@ -1681,6 +1663,7 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 			  readl(reloc_entry), reloc_val);
 #endif
 		writel(reloc_val, reloc_entry);
+		io_mapping_unmap_atomic(reloc_page);
 
 		/* Write the updated presumed offset for this entry back out
 		 * to the user.
@@ -1696,9 +1679,6 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 		drm_gem_object_unreference(target_obj);
 	}
 
-	if (reloc_page != NULL)
-		iounmap(reloc_page);
-
 #if WATCH_BUF
 	if (0)
 		i915_gem_dump_object(obj, 128, __func__, ~0);
@@ -2540,6 +2520,10 @@ i915_gem_entervt_ioctl(struct drm_device *dev, void *data,
 	if (ret != 0)
 		return ret;
 
+	dev_priv->mm.gtt_mapping = io_mapping_create_wc(dev->agp->base,
+							dev->agp->agp_info.aper_size
+							* 1024 * 1024);
+
 	mutex_lock(&dev->struct_mutex);
 	BUG_ON(!list_empty(&dev_priv->mm.active_list));
 	BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
@@ -2557,11 +2541,13 @@ int
 i915_gem_leavevt_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv)
 {
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	int ret;
 
 	ret = i915_gem_idle(dev);
 	drm_irq_uninstall(dev);
 
+	io_mapping_free(dev_priv->mm.gtt_mapping);
 	return ret;
 }
 
-- 
1.5.6.5


