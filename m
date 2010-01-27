Return-Path: <linux-kernel-owner+w=401wt.eu-S1754061Ab0A0PZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab0A0PZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 10:25:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919Ab0A0PZ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 10:25:56 -0500
Received: from mga07.intel.com ([143.182.124.22]:55020 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752810Ab0A0PZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 10:25:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="237393545"
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Roman Jarosz <kedgedev@gmail.com>,
       A Rojas <nqn1976list@gmail.com>,
       "A. Boulan" <arnaud.boulan@libertysurf.fr>, michael@reinelt.co.at,
       jcnengel@googlemail.com, rientjes@google.com, earny@net4u.de,
       linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
       Chris Wilson <chris@chris-wilson.co.uk>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       stable@kernel.org
Subject: [PATCH] drm/i915: Selectively enable self-reclaim
Date: Wed, 27 Jan 2010 15:25:32 +0000
Message-Id: <1264605932-8540-1-git-send-email-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
References: <alpine.LFD.2.00.1001270327580.24253@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Having missed the ENOMEM return via i915_gem_fault(), there are probably
other paths that I also missed. By not enabling NORETRY by default these
paths can run the shrinker and take memory from the system (but not from
our own inactive lists because our shrinker can not run whilst we hold
the struct mutex) and this may allow the system to survive a little longer
whilst our drivers consume all available memory.

References:
  OOM killer unexpectedly called with kernel 2.6.32
  http://bugzilla.kernel.org/show_bug.cgi?id=14933

v2: Pass gfp into page mapping.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>
Cc: stable@kernel.org
---
 drivers/gpu/drm/drm_gem.c           |   13 ----
 drivers/gpu/drm/i915/i915_debugfs.c |    2 +-
 drivers/gpu/drm/i915/i915_drv.h     |    2 +-
 drivers/gpu/drm/i915/i915_gem.c     |  112 +++++++++++++++++++++++------------
 4 files changed, 77 insertions(+), 52 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index e9dbb48..8bf3770 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -142,19 +142,6 @@ drm_gem_object_alloc(struct drm_device *dev, size_t size)
 	if (IS_ERR(obj->filp))
 		goto free;
 
-	/* Basically we want to disable the OOM killer and handle ENOMEM
-	 * ourselves by sacrificing pages from cached buffers.
-	 * XXX shmem_file_[gs]et_gfp_mask()
-	 */
-	mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping,
-			     GFP_HIGHUSER |
-			     __GFP_COLD |
-			     __GFP_FS |
-			     __GFP_RECLAIMABLE |
-			     __GFP_NORETRY |
-			     __GFP_NOWARN |
-			     __GFP_NOMEMALLOC);
-
 	kref_init(&obj->refcount);
 	kref_init(&obj->handlecount);
 	obj->size = size;
diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i915_debugfs.c
index 9c9998c..a894ade 100644
--- a/drivers/gpu/drm/i915/i915_debugfs.c
+++ b/drivers/gpu/drm/i915/i915_debugfs.c
@@ -290,7 +290,7 @@ static int i915_batchbuffer_info(struct seq_file *m, void *data)
 	list_for_each_entry(obj_priv, &dev_priv->mm.active_list, list) {
 		obj = obj_priv->obj;
 		if (obj->read_domains & I915_GEM_DOMAIN_COMMAND) {
-		    ret = i915_gem_object_get_pages(obj);
+		    ret = i915_gem_object_get_pages(obj, 0);
 		    if (ret) {
 			    DRM_ERROR("Failed to get pages: %d\n", ret);
 			    spin_unlock(&dev_priv->mm.active_list_lock);
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 2c16694..aaf934d 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -872,7 +872,7 @@ int i915_gem_attach_phys_object(struct drm_device *dev,
 void i915_gem_detach_phys_object(struct drm_device *dev,
 				 struct drm_gem_object *obj);
 void i915_gem_free_all_phys_object(struct drm_device *dev);
-int i915_gem_object_get_pages(struct drm_gem_object *obj);
+int i915_gem_object_get_pages(struct drm_gem_object *obj, gfp_t gfpmask);
 void i915_gem_object_put_pages(struct drm_gem_object *obj);
 void i915_gem_release(struct drm_device * dev, struct drm_file *file_priv);
 void i915_gem_object_flush_write_domain(struct drm_gem_object *obj);
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 0c67924..f74a099 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -277,7 +277,7 @@ i915_gem_shmem_pread_fast(struct drm_device *dev, struct drm_gem_object *obj,
 
 	mutex_lock(&dev->struct_mutex);
 
-	ret = i915_gem_object_get_pages(obj);
+	ret = i915_gem_object_get_pages(obj, 0);
 	if (ret != 0)
 		goto fail_unlock;
 
@@ -321,40 +321,24 @@ fail_unlock:
 	return ret;
 }
 
-static inline gfp_t
-i915_gem_object_get_page_gfp_mask (struct drm_gem_object *obj)
-{
-	return mapping_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping);
-}
-
-static inline void
-i915_gem_object_set_page_gfp_mask (struct drm_gem_object *obj, gfp_t gfp)
-{
-	mapping_set_gfp_mask(obj->filp->f_path.dentry->d_inode->i_mapping, gfp);
-}
-
 static int
 i915_gem_object_get_pages_or_evict(struct drm_gem_object *obj)
 {
 	int ret;
 
-	ret = i915_gem_object_get_pages(obj);
+	ret = i915_gem_object_get_pages(obj, __GFP_NORETRY | __GFP_NOWARN);
 
 	/* If we've insufficient memory to map in the pages, attempt
 	 * to make some space by throwing out some old buffers.
 	 */
 	if (ret == -ENOMEM) {
 		struct drm_device *dev = obj->dev;
-		gfp_t gfp;
 
 		ret = i915_gem_evict_something(dev, obj->size);
 		if (ret)
 			return ret;
 
-		gfp = i915_gem_object_get_page_gfp_mask(obj);
-		i915_gem_object_set_page_gfp_mask(obj, gfp & ~__GFP_NORETRY);
-		ret = i915_gem_object_get_pages(obj);
-		i915_gem_object_set_page_gfp_mask (obj, gfp);
+		ret = i915_gem_object_get_pages(obj, 0);
 	}
 
 	return ret;
@@ -790,7 +774,7 @@ i915_gem_shmem_pwrite_fast(struct drm_device *dev, struct drm_gem_object *obj,
 
 	mutex_lock(&dev->struct_mutex);
 
-	ret = i915_gem_object_get_pages(obj);
+	ret = i915_gem_object_get_pages(obj, 0);
 	if (ret != 0)
 		goto fail_unlock;
 
@@ -2229,8 +2213,70 @@ i915_gem_evict_something(struct drm_device *dev, int min_size)
 	}
 }
 
+/* like read_mapping_page(), but takes a gfp mask for the allocation */
+static struct page *
+i915_gem_read_cache_page(struct address_space *mapping,
+			 pgoff_t index,
+			 gfp_t gfpmask)
+{
+	struct page *page;
+	int err;
+
+retry:
+	page = find_get_page(mapping, index);
+	if (!page) {
+		page = __page_cache_alloc(mapping_gfp_mask(mapping) | __GFP_COLD | gfpmask);
+		if (!page)
+			return ERR_PTR(-ENOMEM);
+
+		err = add_to_page_cache_lru(page, mapping, index, GFP_KERNEL);
+		if (unlikely(err)) {
+			page_cache_release(page);
+			if (err == -EEXIST)
+				goto retry;
+
+			/* Presumably ENOMEM for radix tree node */
+			return ERR_PTR(err);
+		}
+	} else {
+		if (PageUptodate(page)) {
+			mark_page_accessed(page);
+			return page;
+		}
+
+		lock_page(page);
+		if (!page->mapping) {
+			unlock_page(page);
+			page_cache_release(page);
+			goto retry;
+		}
+
+		if (PageUptodate(page)) {
+			mark_page_accessed(page);
+			unlock_page(page);
+			return page;
+		}
+	}
+
+	err = mapping->a_ops->readpage(NULL, page);
+	if (err < 0) {
+		unlock_page(page);
+		page_cache_release(page);
+		return ERR_PTR(err);
+	}
+	mark_page_accessed(page);
+	wait_on_page_locked(page);
+	if (!PageUptodate(page)) {
+		page_cache_release(page);
+		return ERR_PTR(-EIO);
+	}
+
+	return page;
+}
+
 int
-i915_gem_object_get_pages(struct drm_gem_object *obj)
+i915_gem_object_get_pages(struct drm_gem_object *obj,
+			  gfp_t gfpmask)
 {
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
 	int page_count, i;
@@ -2256,7 +2302,7 @@ i915_gem_object_get_pages(struct drm_gem_object *obj)
 	inode = obj->filp->f_path.dentry->d_inode;
 	mapping = inode->i_mapping;
 	for (i = 0; i < page_count; i++) {
-		page = read_mapping_page(mapping, i, NULL);
+		page = i915_gem_read_cache_page(mapping, i, gfpmask);
 		if (IS_ERR(page)) {
 			ret = PTR_ERR(page);
 			i915_gem_object_put_pages(obj);
@@ -2579,7 +2625,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
 	struct drm_mm_node *free_space;
-	bool retry_alloc = false;
+	gfp_t gfpmask =  __GFP_NORETRY | __GFP_NOWARN;
 	int ret;
 
 	if (obj_priv->madv != I915_MADV_WILLNEED) {
@@ -2623,15 +2669,7 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 	DRM_INFO("Binding object of size %zd at 0x%08x\n",
 		 obj->size, obj_priv->gtt_offset);
 #endif
-	if (retry_alloc) {
-		i915_gem_object_set_page_gfp_mask (obj,
-						   i915_gem_object_get_page_gfp_mask (obj) & ~__GFP_NORETRY);
-	}
-	ret = i915_gem_object_get_pages(obj);
-	if (retry_alloc) {
-		i915_gem_object_set_page_gfp_mask (obj,
-						   i915_gem_object_get_page_gfp_mask (obj) | __GFP_NORETRY);
-	}
+	ret = i915_gem_object_get_pages(obj, gfpmask);
 	if (ret) {
 		drm_mm_put_block(obj_priv->gtt_space);
 		obj_priv->gtt_space = NULL;
@@ -2641,9 +2679,9 @@ i915_gem_object_bind_to_gtt(struct drm_gem_object *obj, unsigned alignment)
 			ret = i915_gem_evict_something(dev, obj->size);
 			if (ret) {
 				/* now try to shrink everyone else */
-				if (! retry_alloc) {
-				    retry_alloc = true;
-				    goto search_free;
+				if (gfpmask) {
+					gfpmask = 0;
+					goto search_free;
 				}
 
 				return ret;
@@ -4946,7 +4984,7 @@ void i915_gem_detach_phys_object(struct drm_device *dev,
 	if (!obj_priv->phys_obj)
 		return;
 
-	ret = i915_gem_object_get_pages(obj);
+	ret = i915_gem_object_get_pages(obj, 0);
 	if (ret)
 		goto out;
 
@@ -5004,7 +5042,7 @@ i915_gem_attach_phys_object(struct drm_device *dev,
 	obj_priv->phys_obj = dev_priv->mm.phys_objs[id - 1];
 	obj_priv->phys_obj->cur_obj = obj;
 
-	ret = i915_gem_object_get_pages(obj);
+	ret = i915_gem_object_get_pages(obj, 0);
 	if (ret) {
 		DRM_ERROR("failed to get page list\n");
 		goto out;
-- 
1.6.6

