Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZCYVql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZCYVql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbZCYVpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:45:21 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56431 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466AbZCYVpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:45:14 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
Subject: [PATCH 1/6] drm/i915: Fix lock order reversal in GTT pwrite path.
Date: Wed, 25 Mar 2009 14:45:05 -0700
Message-Id: <1238017510-26784-2-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238017510-26784-1-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the pagefault path determines that the lock order we use has to be
mmap_sem -> struct_mutex, we can't allow page faults to occur while the
struct_mutex is held.  To fix this in pwrite, we first try optimistically to
see if we can copy from user without faulting.  If it fails, fall back to
using get_user_pages to pin the user's memory, and map those pages
atomically when copying it to the GPU.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/i915/i915_gem.c |  166 ++++++++++++++++++++++++++++++++------
 1 files changed, 139 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 37427e4..35f8c7b 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -223,29 +223,34 @@ fast_user_write(struct io_mapping *mapping,
  */
 
 static inline int
-slow_user_write(struct io_mapping *mapping,
-		loff_t page_base, int page_offset,
-		char __user *user_data,
-		int length)
+slow_kernel_write(struct io_mapping *mapping,
+		  loff_t gtt_base, int gtt_offset,
+		  struct page *user_page, int user_offset,
+		  int length)
 {
-	char __iomem *vaddr;
+	char *src_vaddr, *dst_vaddr;
 	unsigned long unwritten;
 
-	vaddr = io_mapping_map_wc(mapping, page_base);
-	if (vaddr == NULL)
-		return -EFAULT;
-	unwritten = __copy_from_user(vaddr + page_offset,
-				     user_data, length);
-	io_mapping_unmap(vaddr);
+	dst_vaddr = io_mapping_map_atomic_wc(mapping, gtt_base);
+	src_vaddr = kmap_atomic(user_page, KM_USER1);
+	unwritten = __copy_from_user_inatomic_nocache(dst_vaddr + gtt_offset,
+						      src_vaddr + user_offset,
+						      length);
+	kunmap_atomic(src_vaddr, KM_USER1);
+	io_mapping_unmap_atomic(dst_vaddr);
 	if (unwritten)
 		return -EFAULT;
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
@@ -273,7 +278,6 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 
 	obj_priv = obj->driver_private;
 	offset = obj_priv->gtt_offset + args->offset;
-	obj_priv->dirty = 1;
 
 	while (remain > 0) {
 		/* Operation in this page
@@ -292,16 +296,11 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
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
+			goto fail;
 
 		remain -= page_length;
 		user_data += page_length;
@@ -315,6 +314,115 @@ fail:
 	return ret;
 }
 
+/**
+ * This is the fallback GTT pwrite path, which uses get_user_pages to pin
+ * the memory and maps it using kmap_atomic for copying.
+ *
+ * This code resulted in x11perf -rgb10text consuming about 10% more CPU
+ * than using i915_gem_gtt_pwrite_fast on a G45 (32-bit).
+ */
+static int
+i915_gem_gtt_pwrite_slow(struct drm_device *dev, struct drm_gem_object *obj,
+			 struct drm_i915_gem_pwrite *args,
+			 struct drm_file *file_priv)
+{
+	struct drm_i915_gem_object *obj_priv = obj->driver_private;
+	drm_i915_private_t *dev_priv = dev->dev_private;
+	ssize_t remain;
+	loff_t gtt_page_base, offset;
+	loff_t first_data_page, last_data_page, num_pages;
+	loff_t pinned_pages, i;
+	struct page **user_pages;
+	struct mm_struct *mm = current->mm;
+	int gtt_page_offset, data_page_offset, data_page_index, page_length;
+	int ret;
+	uint64_t data_ptr = args->data_ptr;
+
+	remain = args->size;
+
+	/* Pin the user pages containing the data.  We can't fault while
+	 * holding the struct mutex, and all of the pwrite implementations
+	 * want to hold it while dereferencing the user data.
+	 */
+	first_data_page = data_ptr / PAGE_SIZE;
+	last_data_page = (data_ptr + args->size - 1) / PAGE_SIZE;
+	num_pages = last_data_page - first_data_page + 1;
+
+	user_pages = kcalloc(num_pages, sizeof(struct page *), GFP_KERNEL);
+	if (user_pages == NULL)
+		return -ENOMEM;
+
+	down_read(&mm->mmap_sem);
+	pinned_pages = get_user_pages(current, mm, (uintptr_t)args->data_ptr,
+				      num_pages, 0, 0, user_pages, NULL);
+	up_read(&mm->mmap_sem);
+	if (pinned_pages < num_pages) {
+		ret = -EFAULT;
+		goto out_unpin_pages;
+	}
+
+	mutex_lock(&dev->struct_mutex);
+	ret = i915_gem_object_pin(obj, 0);
+	if (ret)
+		goto out_unlock;
+
+	ret = i915_gem_object_set_to_gtt_domain(obj, 1);
+	if (ret)
+		goto out_unpin_object;
+
+	obj_priv = obj->driver_private;
+	offset = obj_priv->gtt_offset + args->offset;
+
+	while (remain > 0) {
+		/* Operation in this page
+		 *
+		 * gtt_page_base = page offset within aperture
+		 * gtt_page_offset = offset within page in aperture
+		 * data_page_index = page number in get_user_pages return
+		 * data_page_offset = offset with data_page_index page.
+		 * page_length = bytes to copy for this page
+		 */
+		gtt_page_base = offset & PAGE_MASK;
+		gtt_page_offset = offset & ~PAGE_MASK;
+		data_page_index = data_ptr / PAGE_SIZE - first_data_page;
+		data_page_offset = data_ptr & ~PAGE_MASK;
+
+		page_length = remain;
+		if ((gtt_page_offset + page_length) > PAGE_SIZE)
+			page_length = PAGE_SIZE - gtt_page_offset;
+		if ((data_page_offset + page_length) > PAGE_SIZE)
+			page_length = PAGE_SIZE - data_page_offset;
+
+		ret = slow_kernel_write(dev_priv->mm.gtt_mapping,
+					gtt_page_base, gtt_page_offset,
+					user_pages[data_page_index],
+					data_page_offset,
+					page_length);
+
+		/* If we get a fault while copying data, then (presumably) our
+		 * source page isn't available.  Return the error and we'll
+		 * retry in the slow path.
+		 */
+		if (ret)
+			goto out_unpin_object;
+
+		remain -= page_length;
+		offset += page_length;
+		data_ptr += page_length;
+	}
+
+out_unpin_object:
+	i915_gem_object_unpin(obj);
+out_unlock:
+	mutex_unlock(&dev->struct_mutex);
+out_unpin_pages:
+	for (i = 0; i < pinned_pages; i++)
+		page_cache_release(user_pages[i]);
+	kfree(user_pages);
+
+	return ret;
+}
+
 static int
 i915_gem_shmem_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 		      struct drm_i915_gem_pwrite *args,
@@ -388,9 +496,13 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
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
1.6.2.1

