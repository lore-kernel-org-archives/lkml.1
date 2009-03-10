Return-Path: <linux-kernel-owner+w=401wt.eu-S1753638AbZCJBe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753638AbZCJBe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 21:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752294AbZCJBd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 21:33:57 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:34289 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422AbZCJBdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 21:33:55 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>
Subject: [PATCH] drm/i915: Fix lock order reversal in shmem pwrite path.
Date: Mon,  9 Mar 2009 18:33:51 -0700
Message-Id: <1236648831-18230-3-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1236648831-18230-2-git-send-email-eric@anholt.net>
References: <1236648831-18230-1-git-send-email-eric@anholt.net>
 <1236648831-18230-2-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Like the GTT pwrite path fix, this uses pagefault_enable/disable and a
fallback to allocating and copying the memory in outside of the lock.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/i915/i915_drv.h |    1 +
 drivers/gpu/drm/i915/i915_gem.c |  117 ++++++++++++++++++++++++++++++++++++--
 2 files changed, 111 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index d6cc986..385ca8d 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -405,6 +405,7 @@ struct drm_i915_gem_object {
 	DRM_AGP_MEM *agp_mem;
 
 	struct page **page_list;
+	int page_list_refcount;
 
 	/**
 	 * Current offset of the object in GTT space.
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 2c85249..3a96e0c 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -239,6 +239,23 @@ slow_kernel_write(struct io_mapping *mapping,
 	return 0;
 }
 
+static inline int
+slow_shmem_write(struct page **page_list,
+		 loff_t page_base, int page_offset,
+		 char *data,
+		 int length)
+{
+	char __iomem *vaddr;
+
+	vaddr = kmap_atomic(page_list[page_base >> PAGE_SHIFT], KM_USER0);
+	if (vaddr == NULL)
+		return -ENOMEM;
+	memcpy(vaddr + page_offset, data, length);
+	kunmap_atomic(vaddr, KM_USER0);
+
+	return 0;
+}
+
 /**
  * This is the fast pwrite path, where we copy the data directly from the
  * user into the GTT, uncached.
@@ -391,9 +408,9 @@ fail_free:
 }
 
 static int
-i915_gem_shmem_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
-		      struct drm_i915_gem_pwrite *args,
-		      struct drm_file *file_priv)
+i915_gem_shmem_pwrite_fast(struct drm_device *dev, struct drm_gem_object *obj,
+			   struct drm_i915_gem_pwrite *args,
+			   struct drm_file *file_priv)
 {
 	int ret;
 	loff_t offset;
@@ -409,9 +426,11 @@ i915_gem_shmem_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 
 	offset = args->offset;
 
+	pagefault_disable();
 	written = vfs_write(obj->filp,
 			    (char __user *)(uintptr_t) args->data_ptr,
 			    args->size, &offset);
+	pagefault_enable();
 	if (written != args->size) {
 		mutex_unlock(&dev->struct_mutex);
 		if (written < 0)
@@ -426,6 +445,83 @@ i915_gem_shmem_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 }
 
 /**
+ * This is the fallback GTT pwrite path, which allocates temporary storage
+ * in kernel space to copy_from_user, so we can take pagefaults outside of the
+ * struct_mutex.
+ */
+static int
+i915_gem_shmem_pwrite_slow(struct drm_device *dev, struct drm_gem_object *obj,
+			   struct drm_i915_gem_pwrite *args,
+			   struct drm_file *file_priv)
+{
+	struct drm_i915_gem_object *obj_priv = obj->driver_private;
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
+
+	ret = i915_gem_object_get_page_list(obj);
+	if (ret != 0)
+		goto fail_unlock;
+
+	ret = i915_gem_object_set_to_cpu_domain(obj, 1);
+	if (ret != 0)
+		goto fail_put_pages;
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
+		ret = slow_shmem_write(obj_priv->page_list,
+				       page_base, page_offset,
+				       user_data, page_length);
+		if (ret)
+			goto fail_put_pages;
+
+		remain -= page_length;
+		user_data += page_length;
+		offset += page_length;
+	}
+
+fail_put_pages:
+	i915_gem_object_free_page_list(obj);
+fail_unlock:
+	mutex_unlock(&dev->struct_mutex);
+fail_free:
+	drm_free(data, args->size, DRM_MEM_DRIVER);
+
+	return ret;
+}
+
+/**
  * Writes data to the object referenced by handle.
  *
  * On error, the contents of the buffer that were to be modified are undefined.
@@ -469,8 +565,13 @@ i915_gem_pwrite_ioctl(struct drm_device *dev, void *data,
 			ret = i915_gem_gtt_pwrite_slow(dev, obj, args,
 						       file_priv);
 		}
-	} else
-		ret = i915_gem_shmem_pwrite(dev, obj, args, file_priv);
+	} else {
+		ret = i915_gem_shmem_pwrite_fast(dev, obj, args, file_priv);
+		if (ret == -EFAULT) {
+			ret = i915_gem_shmem_pwrite_slow(dev, obj, args,
+							 file_priv);
+		}
+	}
 
 #if WATCH_PWRITE
 	if (ret)
@@ -901,9 +1002,10 @@ i915_gem_object_free_page_list(struct drm_gem_object *obj)
 	int page_count = obj->size / PAGE_SIZE;
 	int i;
 
-	if (obj_priv->page_list == NULL)
+	if (--obj_priv->page_list_refcount != 0)
 		return;
 
+	BUG_ON(obj_priv->page_list_refcount < 0);
 
 	for (i = 0; i < page_count; i++)
 		if (obj_priv->page_list[i] != NULL) {
@@ -1497,7 +1599,7 @@ i915_gem_object_get_page_list(struct drm_gem_object *obj)
 	struct page *page;
 	int ret;
 
-	if (obj_priv->page_list)
+	if (obj_priv->page_list_refcount++ != 0)
 		return 0;
 
 	/* Get the list of pages out of our struct file.  They'll be pinned
@@ -1509,6 +1611,7 @@ i915_gem_object_get_page_list(struct drm_gem_object *obj)
 					 DRM_MEM_DRIVER);
 	if (obj_priv->page_list == NULL) {
 		DRM_ERROR("Faled to allocate page list\n");
+		obj_priv->page_list_refcount--;
 		return -ENOMEM;
 	}
 
-- 
1.5.6.5

