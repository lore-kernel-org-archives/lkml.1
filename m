Return-Path: <linux-kernel-owner+w=401wt.eu-S1754020AbZCJBep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020AbZCJBep (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbZCJBd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:33:58 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:34290 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZCJBdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:33:55 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>
Subject: [PATCH] drm/i915: Fix lock order reversal in GTT pwrite path.
Date: Mon,  9 Mar 2009 18:33:50 -0700
Message-Id: <1236648831-18230-2-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1236648831-18230-1-git-send-email-eric@anholt.net>
References: <1236648831-18230-1-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the pagefault path determines that the lock order we use has to be
mmap_sem -> struct_mutex, we can't allow page faults to occur while the
struct_mutex is held.  To fix this in pwrite, we first try optimistically to
see if we can copy from user without faulting.  If it fails, fall back to
allocating memory, copying, then taking the lock and copying it to the GPU.

Thanks to Linus for suggesting this (in retrospect) obvious way of doing it.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/i915/i915_gem.c |  131 +++++++++++++++++++++++++++++++--------
 1 files changed, 105 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index c94069b..2c85249 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -223,29 +223,30 @@ fast_user_write(struct io_mapping *mapping,
  */
 
 static inline int
-slow_user_write(struct io_mapping *mapping,
-		loff_t page_base, int page_offset,
-		char __user *user_data,
-		int length)
+slow_kernel_write(struct io_mapping *mapping,
+		  loff_t page_base, int page_offset,
+		  char *data,
+		  int length)
 {
 	char __iomem *vaddr;
-	unsigned long unwritten;
 
 	vaddr = io_mapping_map_wc(mapping, page_base);
 	if (vaddr == NULL)
-		return -EFAULT;
-	unwritten = __copy_from_user(vaddr + page_offset,
-				     user_data, length);
+		return -ENOMEM;
+	memcpy(vaddr + page_offset, data, length);
 	io_mapping_unmap(vaddr);
-	if (unwritten)
-		return -EFAULT;
+
 	return 0;
 }
 
+/**
+ * This is the fast pwrite path, where we copy the data directly from the
+ * user into the GTT, uncached.
+ */
 static int
-i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
-		    struct drm_i915_gem_pwrite *args,
-		    struct drm_file *file_priv)
+i915_gem_gtt_pwrite_fast(struct drm_device *dev, struct drm_gem_object *obj,
+			 struct drm_i915_gem_pwrite *args,
+			 struct drm_file *file_priv)
 {
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
 	drm_i915_private_t *dev_priv = dev->dev_private;
@@ -273,8 +274,8 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 
 	obj_priv = obj->driver_private;
 	offset = obj_priv->gtt_offset + args->offset;
-	obj_priv->dirty = 1;
 
+	pagefault_disable();
 	while (remain > 0) {
 		/* Operation in this page
 		 *
@@ -292,22 +293,19 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 				       page_offset, user_data, page_length);
 
 		/* If we get a fault while copying data, then (presumably) our
-		 * source page isn't available. In this case, use the
-		 * non-atomic function
+		 * source page isn't available.  Return the error and we'll
+		 * retry in the slow path.
 		 */
-		if (ret) {
-			ret = slow_user_write (dev_priv->mm.gtt_mapping,
-					       page_base, page_offset,
-					       user_data, page_length);
-			if (ret)
-				goto fail;
-		}
+		if (ret)
+			goto fail_pagefault;
 
 		remain -= page_length;
 		user_data += page_length;
 		offset += page_length;
 	}
 
+fail_pagefault:
+	pagefault_enable();
 fail:
 	i915_gem_object_unpin(obj);
 	mutex_unlock(&dev->struct_mutex);
@@ -315,6 +313,83 @@ fail:
 	return ret;
 }
 
+/**
+ * This is the fallback GTT pwrite path, which allocates temporary storage
+ * in kernel space to copy_from_user, so we can take pagefaults outside of the
+ * struct_mutex.
+ */
+static int
+i915_gem_gtt_pwrite_slow(struct drm_device *dev, struct drm_gem_object *obj,
+			 struct drm_i915_gem_pwrite *args,
+			 struct drm_file *file_priv)
+{
+	struct drm_i915_gem_object *obj_priv = obj->driver_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	ssize_t remain;
+	loff_t offset, page_base;
+	char __user *user_data;
+	char *data;
+	int page_offset, page_length;
+	int ret;
+
+	user_data = (char __user *) (uintptr_t) args->data_ptr;
+	remain = args->size;
+
+	data = drm_alloc(args->size, DRM_MEM_DRIVER);
+	if (data == NULL)
+		return -ENOMEM;
+
+	ret = copy_from_user(data, user_data, args->size);
+	if (ret != 0)
+		goto fail_free;
+
+	mutex_lock(&dev->struct_mutex);
+	ret = i915_gem_object_pin(obj, 0);
+	if (ret)
+		goto fail_unlock;
+
+	ret = i915_gem_object_set_to_gtt_domain(obj, 1);
+	if (ret)
+		goto fail_unpin;
+
+	obj_priv = obj->driver_private;
+	offset = obj_priv->gtt_offset + args->offset;
+	obj_priv->dirty = 1;
+
+	while (remain > 0) {
+		/* Operation in this page
+		 *
+		 * page_base = page offset within aperture
+		 * page_offset = offset within page
+		 * page_length = bytes to copy for this page
+		 */
+		page_base = (offset & ~(PAGE_SIZE-1));
+		page_offset = offset & (PAGE_SIZE-1);
+		page_length = remain;
+		if ((page_offset + remain) > PAGE_SIZE)
+			page_length = PAGE_SIZE - page_offset;
+
+		ret = slow_kernel_write(dev_priv->mm.gtt_mapping,
+					page_base, page_offset,
+					user_data, page_length);
+		if (ret)
+			goto fail_unpin;
+
+		remain -= page_length;
+		user_data += page_length;
+		offset += page_length;
+	}
+
+fail_unpin:
+	i915_gem_object_unpin(obj);
+fail_unlock:
+	mutex_unlock(&dev->struct_mutex);
+fail_free:
+	drm_free(data, args->size, DRM_MEM_DRIVER);
+
+	return ret;
+}
+
 static int
 i915_gem_shmem_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 		      struct drm_i915_gem_pwrite *args,
@@ -388,9 +463,13 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 	if (obj_priv->phys_obj)
 		ret = i915_gem_phys_pwrite(dev, obj, args, file_priv);
 	else if (obj_priv->tiling_mode == I915_TILING_NONE &&
-		 dev->gtt_total != 0)
-		ret = i915_gem_gtt_pwrite(dev, obj, args, file_priv);
-	else
+		 dev->gtt_total != 0) {
+		ret = i915_gem_gtt_pwrite_fast(dev, obj, args, file_priv);
+		if (ret == -EFAULT) {
+			ret = i915_gem_gtt_pwrite_slow(dev, obj, args,
+						       file_priv);
+		}
+	} else
 		ret = i915_gem_shmem_pwrite(dev, obj, args, file_priv);
 
 #if WATCH_PWRITE
-- 
1.5.6.5

