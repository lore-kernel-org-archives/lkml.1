Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYJWHPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYJWHPe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 03:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYJWHP0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 03:15:26 -0400
Received: from home.keithp.com ([63.227.221.253]:47692 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872AbYJWHPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 03:15:25 -0400
From: Keith Packard <keithp@keithp.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Dave Airlie <airlied@linux.ie>,
       Yinghai Lu <yinghai@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Keith Packard <keithp@keithp.com>
Subject: [PATCH] [drm/i915] Use io-mapping interfaces instead of a variety of mapping kludges
Date: Thu, 23 Oct 2008 00:14:47 -0700
Message-Id: <1224746087-13991-3-git-send-email-keithp@keithp.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1224746087-13991-2-git-send-email-keithp@keithp.com>
References: <20081022093615.GF12453@elte.hu>
 <1224746087-13991-1-git-send-email-keithp@keithp.com>
 <1224746087-13991-2-git-send-email-keithp@keithp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch the i915 device aperture mapping to the io-mapping interface, taking
advantage of the cleaner API to extend it across all of the mapping uses,
including both pwrite and relocation updates.

This dramatically improves performance on 64-bit kernels which were using
the same slow path as 32-bit non-HIGHMEM kernels prior to this patch.

Signed-off-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_drv.h |    3 +
 drivers/gpu/drm/i915/i915_gem.c |   81 ++++++++++++++++-----------------------
 2 files changed, 36 insertions(+), 48 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index f20ffe1..8ca5fbc 100644
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
 
+		struct io_mapping *io_mapping;
+
 		/**
 		 * List of objects currently involved in rendering from the
 		 * ringbuffer.
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 9255088..d38b052 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -177,14 +177,14 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 		    struct drm_file *file_priv)
 {
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	ssize_t remain;
-	loff_t offset;
+	loff_t offset, base;
 	char __user *user_data;
 	char __iomem *vaddr;
 	char *vaddr_atomic;
-	int i, o, l;
+	int o, l;
 	int ret = 0;
-	unsigned long pfn;
 	unsigned long unwritten;
 
 	user_data = (char __user *) (uintptr_t) args->data_ptr;
@@ -211,42 +211,38 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 	while (remain > 0) {
 		/* Operation in this page
 		 *
-		 * i = page number
+		 * base = page offset within aperture
 		 * o = offset within page
 		 * l = bytes to copy
 		 */
-		i = offset >> PAGE_SHIFT;
+		base = (offset & ~(PAGE_SIZE-1));
 		o = offset & (PAGE_SIZE-1);
 		l = remain;
 		if ((o + l) > PAGE_SIZE)
 			l = PAGE_SIZE - o;
 
-		pfn = (dev->agp->base >> PAGE_SHIFT) + i;
-
-#ifdef CONFIG_HIGHMEM
 		/* This is a workaround for the low performance of iounmap
 		 * (approximate 10% cpu cost on normal 3D workloads).
-		 * kmap_atomic on HIGHMEM kernels happens to let us map card
-		 * memory without taking IPIs.  When the vmap rework lands
-		 * we should be able to dump this hack.
+		 * io_mapping_map_atomic_wc maps card memory
+		 * without taking IPIs.
 		 */
-		vaddr_atomic = kmap_atomic_pfn(pfn, KM_USER0);
-#if WATCH_PWRITE
-		DRM_INFO("pwrite i %d o %d l %d pfn %ld vaddr %p\n",
-			 i, o, l, pfn, vaddr_atomic);
-#endif
+		vaddr_atomic = io_mapping_map_atomic_wc(dev_priv->mm.io_mapping,
+							base);
 		unwritten = __copy_from_user_inatomic_nocache(vaddr_atomic + o,
 							      user_data, l);
-		kunmap_atomic(vaddr_atomic, KM_USER0);
-
+		io_mapping_unmap_atomic(vaddr_atomic);
+			
+		/* If we get a fault while copying data, then (presumably) our
+		 * source page isn't available. In this case, use the
+		 * non-atomic __copy_from_user function
+		 */
 		if (unwritten)
-#endif /* CONFIG_HIGHMEM */
 		{
-			vaddr = ioremap_wc(pfn << PAGE_SHIFT, PAGE_SIZE);
+			vaddr = io_mapping_map_wc(dev_priv->mm.io_mapping, base);
 #if WATCH_PWRITE
-			DRM_INFO("pwrite slow i %d o %d l %d "
-				 "pfn %ld vaddr %p\n",
-				 i, o, l, pfn, vaddr);
+			DRM_INFO("pwrite slow base %ld o %d l %d "
+				 "vaddr %p\n",
+				 base, o, l, vaddr);
 #endif
 			if (vaddr == NULL) {
 				ret = -EFAULT;
@@ -256,7 +252,7 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 #if WATCH_PWRITE
 			DRM_INFO("unwritten %ld\n", unwritten);
 #endif
-			iounmap(vaddr);
+			io_mapping_unmap(vaddr);
 			if (unwritten) {
 				ret = -EFAULT;
 				goto fail;
@@ -1489,12 +1485,12 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
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
@@ -1617,26 +1613,11 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
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
+		reloc_page = io_mapping_map_atomic_wc(dev_priv->mm.io_mapping,
+						      (reloc_offset & 
+						       ~(PAGE_SIZE - 1)));
 		reloc_entry = (uint32_t __iomem *)(reloc_page +
-					   (reloc_offset & (PAGE_SIZE - 1)));
+						   (reloc_offset & (PAGE_SIZE - 1)));
 		reloc_val = target_obj_priv->gtt_offset + reloc.delta;
 
 #if WATCH_BUF
@@ -1645,6 +1626,7 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 			  readl(reloc_entry), reloc_val);
 #endif
 		writel(reloc_val, reloc_entry);
+		io_mapping_unmap_atomic(reloc_page);
 
 		/* Write the updated presumed offset for this entry back out
 		 * to the user.
@@ -1660,9 +1642,6 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 		drm_gem_object_unreference(target_obj);
 	}
 
-	if (reloc_page != NULL)
-		iounmap(reloc_page);
-
 #if WATCH_BUF
 	if (0)
 		i915_gem_dump_object(obj, 128, __func__, ~0);
@@ -2504,6 +2483,10 @@ i915_gem_entervt_ioctl(struct drm_device *dev, void *data,
 	if (ret != 0)
 		return ret;
 
+	dev_priv->mm.io_mapping = io_mapping_create_wc(dev->agp->base,
+						       dev->agp->agp_info.aper_size
+						       * 1024 * 1024);
+
 	mutex_lock(&dev->struct_mutex);
 	BUG_ON(!list_empty(&dev_priv->mm.active_list));
 	BUG_ON(!list_empty(&dev_priv->mm.flushing_list));
@@ -2521,11 +2504,13 @@ int
 i915_gem_leavevt_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv)
 {
+	drm_i915_private_t *dev_priv = dev->dev_private;
 	int ret;
 
 	ret = i915_gem_idle(dev);
 	drm_irq_uninstall(dev);
 
+	io_mapping_free(dev_priv->mm.io_mapping);
 	return ret;
 }
 
-- 
1.5.6.5

