Return-Path: <linux-kernel-owner+w=401wt.eu-S1755214AbZBRA75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214AbZBRA75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:59:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752086AbZBRA7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:59:49 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:35163 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbZBRA7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:59:48 -0500
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
Subject: [PATCH] drm: Fix lock order reversal between mmap_sem and struct_mutex.
Date: Tue, 17 Feb 2009 16:59:46 -0800
Message-Id: <1234918786-854-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The basic problem was
mmap_sem (do_mmap()) -> struct_mutex (drm_gem_mmap(), i915_gem_fault())
struct_mutex (i915_gem_execbuffer()) -> mmap_sem (copy_from/to_user())

We have plenty of places where we want to hold device state the same
(struct_mutex) while we move a non-trivial amount of data
(copy_from/to_user()), such as i915_gem_pwrite().  Solve this by moving the
easy things that needed struct_mutex with mmap_sem held to using a lock to
cover just those data structures (offset hash and offset manager), and do
trylock and reschedule in fault.

Signed-off-by: Eric Anholt <eric@anholt.net>
---
 drivers/gpu/drm/drm_gem.c       |    8 ++++----
 drivers/gpu/drm/i915/i915_gem.c |   15 ++++++++++++++-
 include/drm/drmP.h              |    1 +
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 88d3368..13a0184 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -97,6 +97,7 @@ drm_gem_init(struct drm_device *dev)
 
 	dev->mm_private = mm;
 
+	mutex_init(&mm->offset_mutex);
 	if (drm_ht_create(&mm->offset_hash, 19)) {
 		drm_free(mm, sizeof(struct drm_gem_mm), DRM_MEM_MM);
 		return -ENOMEM;
@@ -508,10 +509,9 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	unsigned long prot;
 	int ret = 0;
 
-	mutex_lock(&dev->struct_mutex);
-
+	mutex_lock(&mm->offset_mutex);
 	if (drm_ht_find_item(&mm->offset_hash, vma->vm_pgoff, &hash)) {
-		mutex_unlock(&dev->struct_mutex);
+		mutex_unlock(&mm->offset_mutex);
 		return drm_mmap(filp, vma);
 	}
 
@@ -556,7 +556,7 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
 	drm_vm_open_locked(vma);
 
 out_unlock:
-	mutex_unlock(&dev->struct_mutex);
+	mutex_unlock(&mm->offset_mutex);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index ac534c9..da9a2cb 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -573,8 +573,16 @@ int i915_gem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	page_offset = ((unsigned long)vmf->virtual_address - vma->vm_start) >>
 		PAGE_SHIFT;
 
+	/* Get the struct mutex before accessing GEM data structures, but
+	 * keep the struct_mutex -> mmap_sem lock ordering so that we don't
+	 * need to mangle pwrite/pread to allow mmap_sem -> struct_mutex.
+	 */
+	if (!mutex_trylock(&dev->struct_mutex)) {
+		need_resched();
+		return VM_FAULT_NOPAGE;
+	}
+
 	/* Now bind it into the GTT if needed */
-	mutex_lock(&dev->struct_mutex);
 	if (!obj_priv->gtt_space) {
 		ret = i915_gem_object_bind_to_gtt(obj, obj_priv->gtt_alignment);
 		if (ret) {
@@ -646,6 +654,7 @@ i915_gem_create_mmap_offset(struct drm_gem_object *obj)
 	map->size = obj->size;
 	map->handle = obj;
 
+	mutex_lock(&mm->offset_mutex);
 	/* Get a DRM GEM mmap offset allocated... */
 	list->file_offset_node = drm_mm_search_free(&mm->offset_manager,
 						    obj->size / PAGE_SIZE, 0, 0);
@@ -671,12 +680,14 @@ i915_gem_create_mmap_offset(struct drm_gem_object *obj)
 	/* By now we should be all set, any drm_mmap request on the offset
 	 * below will get to our mmap & fault handler */
 	obj_priv->mmap_offset = ((uint64_t) list->hash.key) << PAGE_SHIFT;
+	mutex_unlock(&mm->offset_mutex);
 
 	return 0;
 
 out_free_mm:
 	drm_mm_put_block(list->file_offset_node);
 out_free_list:
+	mutex_unlock(&mm->offset_mutex);
 	drm_free(list->map, sizeof(struct drm_map_list), DRM_MEM_DRIVER);
 
 	return ret;
@@ -690,6 +701,7 @@ i915_gem_free_mmap_offset(struct drm_gem_object *obj)
 	struct drm_gem_mm *mm = dev->mm_private;
 	struct drm_map_list *list;
 
+	mutex_lock(&mm->offset_mutex);
 	list = &obj->map_list;
 	drm_ht_remove_item(&mm->offset_hash, &list->hash);
 
@@ -704,6 +716,7 @@ i915_gem_free_mmap_offset(struct drm_gem_object *obj)
 	}
 
 	obj_priv->mmap_offset = 0;
+	mutex_unlock(&mm->offset_mutex);
 }
 
 /**
diff --git a/include/drm/drmP.h b/include/drm/drmP.h
index e5f4ae9..04f765b 100644
--- a/include/drm/drmP.h
+++ b/include/drm/drmP.h
@@ -570,6 +570,7 @@ struct drm_ati_pcigart_info {
 struct drm_gem_mm {
 	struct drm_mm offset_manager;	/**< Offset mgmt for buffer objects */
 	struct drm_open_hash offset_hash; /**< User token hash table for maps */
+	struct mutex offset_mutex; /**< covers offset_manager and offset_hash */
 };
 
 /**
-- 
1.5.6.5

