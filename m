Return-Path: <linux-kernel-owner+w=401wt.eu-S1757310AbZCYVq7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbZCYVq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:46:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbZCYVpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:45:23 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56436 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754424AbZCYVpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:45:15 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
Subject: [PATCH 6/6] drm/i915: Fix lock order reversal in GEM relocation entry copying.
Date: Wed, 25 Mar 2009 14:45:10 -0700
Message-Id: <1238017510-26784-7-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238017510-26784-6-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
 <1238017510-26784-2-git-send-email-eric@anholt.net>
 <1238017510-26784-3-git-send-email-eric@anholt.net>
 <1238017510-26784-4-git-send-email-eric@anholt.net>
 <1238017510-26784-5-git-send-email-eric@anholt.net>
 <1238017510-26784-6-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_gem.c |  187 +++++++++++++++++++++++++++-----------
 1 files changed, 133 insertions(+), 54 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 2bda151..f135c90 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2713,12 +2713,11 @@ i915_gem_object_set_cpu_read_domain_range(struct drm_gem_object *obj,
 static int
 i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 				 struct drm_file *file_priv,
-				 struct drm_i915_gem_exec_object *entry)
+				 struct drm_i915_gem_exec_object *entry,
+				 struct drm_i915_gem_relocation_entry *relocs)
 {
 	struct drm_device *dev = obj->dev;
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_i915_gem_relocation_entry reloc;
-	struct drm_i915_gem_relocation_entry __user *relocs;
 	struct drm_i915_gem_object *obj_priv = obj->driver_private;
 	int i, ret;
 	void __iomem *reloc_page;
@@ -2730,25 +2729,18 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 
 	entry->offset = obj_priv->gtt_offset;
 
-	relocs = (struct drm_i915_gem_relocation_entry __user *)
-		 (uintptr_t) entry->relocs_ptr;
 	/* Apply the relocations, using the GTT aperture to avoid cache
 	 * flushing requirements.
 	 */
 	for (i = 0; i < entry->relocation_count; i++) {
+		struct drm_i915_gem_relocation_entry *reloc= &relocs[i];
 		struct drm_gem_object *target_obj;
 		struct drm_i915_gem_object *target_obj_priv;
 		uint32_t reloc_val, reloc_offset;
 		uint32_t __iomem *reloc_entry;
 
-		ret = copy_from_user(&reloc, relocs + i, sizeof(reloc));
-		if (ret != 0) {
-			i915_gem_object_unpin(obj);
-			return ret;
-		}
-
 		target_obj = drm_gem_object_lookup(obj->dev, file_priv,
-						   reloc.target_handle);
+						   reloc->target_handle);
 		if (target_obj == NULL) {
 			i915_gem_object_unpin(obj);
 			return -EBADF;
@@ -2760,53 +2752,53 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 		 */
 		if (target_obj_priv->gtt_space == NULL) {
 			DRM_ERROR("No GTT space found for object %d\n",
-				  reloc.target_handle);
+				  reloc->target_handle);
 			drm_gem_object_unreference(target_obj);
 			i915_gem_object_unpin(obj);
 			return -EINVAL;
 		}
 
-		if (reloc.offset > obj->size - 4) {
+		if (reloc->offset > obj->size - 4) {
 			DRM_ERROR("Relocation beyond object bounds: "
 				  "obj %p target %d offset %d size %d.\n",
-				  obj, reloc.target_handle,
-				  (int) reloc.offset, (int) obj->size);
+				  obj, reloc->target_handle,
+				  (int) reloc->offset, (int) obj->size);
 			drm_gem_object_unreference(target_obj);
 			i915_gem_object_unpin(obj);
 			return -EINVAL;
 		}
-		if (reloc.offset & 3) {
+		if (reloc->offset & 3) {
 			DRM_ERROR("Relocation not 4-byte aligned: "
 				  "obj %p target %d offset %d.\n",
-				  obj, reloc.target_handle,
-				  (int) reloc.offset);
+				  obj, reloc->target_handle,
+				  (int) reloc->offset);
 			drm_gem_object_unreference(target_obj);
 			i915_gem_object_unpin(obj);
 			return -EINVAL;
 		}
 
-		if (reloc.write_domain & I915_GEM_DOMAIN_CPU ||
-		    reloc.read_domains & I915_GEM_DOMAIN_CPU) {
+		if (reloc->write_domain & I915_GEM_DOMAIN_CPU ||
+		    reloc->read_domains & I915_GEM_DOMAIN_CPU) {
 			DRM_ERROR("reloc with read/write CPU domains: "
 				  "obj %p target %d offset %d "
 				  "read %08x write %08x",
-				  obj, reloc.target_handle,
-				  (int) reloc.offset,
-				  reloc.read_domains,
-				  reloc.write_domain);
+				  obj, reloc->target_handle,
+				  (int) reloc->offset,
+				  reloc->read_domains,
+				  reloc->write_domain);
 			drm_gem_object_unreference(target_obj);
 			i915_gem_object_unpin(obj);
 			return -EINVAL;
 		}
 
-		if (reloc.write_domain && target_obj->pending_write_domain &&
-		    reloc.write_domain != target_obj->pending_write_domain) {
+		if (reloc->write_domain && target_obj->pending_write_domain &&
+		    reloc->write_domain != target_obj->pending_write_domain) {
 			DRM_ERROR("Write domain conflict: "
 				  "obj %p target %d offset %d "
 				  "new %08x old %08x\n",
-				  obj, reloc.target_handle,
-				  (int) reloc.offset,
-				  reloc.write_domain,
+				  obj, reloc->target_handle,
+				  (int) reloc->offset,
+				  reloc->write_domain,
 				  target_obj->pending_write_domain);
 			drm_gem_object_unreference(target_obj);
 			i915_gem_object_unpin(obj);
@@ -2819,22 +2811,22 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 			 "presumed %08x delta %08x\n",
 			 __func__,
 			 obj,
-			 (int) reloc.offset,
-			 (int) reloc.target_handle,
-			 (int) reloc.read_domains,
-			 (int) reloc.write_domain,
+			 (int) reloc->offset,
+			 (int) reloc->target_handle,
+			 (int) reloc->read_domains,
+			 (int) reloc->write_domain,
 			 (int) target_obj_priv->gtt_offset,
-			 (int) reloc.presumed_offset,
-			 reloc.delta);
+			 (int) reloc->presumed_offset,
+			 reloc->delta);
 #endif
 
-		target_obj->pending_read_domains |= reloc.read_domains;
-		target_obj->pending_write_domain |= reloc.write_domain;
+		target_obj->pending_read_domains |= reloc->read_domains;
+		target_obj->pending_write_domain |= reloc->write_domain;
 
 		/* If the relocation already has the right value in it, no
 		 * more work needs to be done.
 		 */
-		if (target_obj_priv->gtt_offset == reloc.presumed_offset) {
+		if (target_obj_priv->gtt_offset == reloc->presumed_offset) {
 			drm_gem_object_unreference(target_obj);
 			continue;
 		}
@@ -2849,32 +2841,26 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 		/* Map the page containing the relocation we're going to
 		 * perform.
 		 */
-		reloc_offset = obj_priv->gtt_offset + reloc.offset;
+		reloc_offset = obj_priv->gtt_offset + reloc->offset;
 		reloc_page = io_mapping_map_atomic_wc(dev_priv->mm.gtt_mapping,
 						      (reloc_offset &
 						       ~(PAGE_SIZE - 1)));
 		reloc_entry = (uint32_t __iomem *)(reloc_page +
 						   (reloc_offset & (PAGE_SIZE - 1)));
-		reloc_val = target_obj_priv->gtt_offset + reloc.delta;
+		reloc_val = target_obj_priv->gtt_offset + reloc->delta;
 
 #if WATCH_BUF
 		DRM_INFO("Applied relocation: %p@0x%08x %08x -> %08x\n",
-			  obj, (unsigned int) reloc.offset,
+			  obj, (unsigned int) reloc->offset,
 			  readl(reloc_entry), reloc_val);
 #endif
 		writel(reloc_val, reloc_entry);
 		io_mapping_unmap_atomic(reloc_page);
 
-		/* Write the updated presumed offset for this entry back out
-		 * to the user.
+		/* The updated presumed offset for this entry will be
+		 * copied back out to the user.
 		 */
-		reloc.presumed_offset = target_obj_priv->gtt_offset;
-		ret = copy_to_user(relocs + i, &reloc, sizeof(reloc));
-		if (ret != 0) {
-			drm_gem_object_unreference(target_obj);
-			i915_gem_object_unpin(obj);
-			return ret;
-		}
+		reloc->presumed_offset = target_obj_priv->gtt_offset;
 
 		drm_gem_object_unreference(target_obj);
 	}
@@ -2971,6 +2957,75 @@ i915_gem_ring_throttle(struct drm_device *dev, struct drm_file *file_priv)
 	return ret;
 }
 
+static int
+i915_gem_get_relocs_from_user(struct drm_i915_gem_exec_object *exec_list,
+			      uint32_t buffer_count,
+			      struct drm_i915_gem_relocation_entry **relocs)
+{
+	uint32_t reloc_count = 0, reloc_index = 0, i;
+	int ret;
+
+	*relocs = NULL;
+	for (i = 0; i < buffer_count; i++) {
+		if (reloc_count + exec_list[i].relocation_count < reloc_count)
+			return -EINVAL;
+		reloc_count += exec_list[i].relocation_count;
+	}
+
+	*relocs = drm_calloc(reloc_count, sizeof(**relocs), DRM_MEM_DRIVER);
+	if (*relocs == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < buffer_count; i++) {
+		struct drm_i915_gem_relocation_entry __user *user_relocs;
+
+		user_relocs = (void __user *)(uintptr_t)exec_list[i].relocs_ptr;
+
+		ret = copy_from_user(&(*relocs)[reloc_index],
+				     user_relocs,
+				     exec_list[i].relocation_count *
+				     sizeof(**relocs));
+		if (ret != 0) {
+			drm_free(*relocs, reloc_count * sizeof(**relocs),
+				 DRM_MEM_DRIVER);
+			*relocs = NULL;
+			return ret;
+		}
+
+		reloc_index += exec_list[i].relocation_count;
+	}
+
+	return ret;
+}
+
+static int
+i915_gem_put_relocs_to_user(struct drm_i915_gem_exec_object *exec_list,
+			    uint32_t buffer_count,
+			    struct drm_i915_gem_relocation_entry *relocs)
+{
+	uint32_t reloc_count = 0, i;
+	int ret;
+
+	for (i = 0; i < buffer_count; i++) {
+		struct drm_i915_gem_relocation_entry __user *user_relocs;
+
+		user_relocs = (void __user *)(uintptr_t)exec_list[i].relocs_ptr;
+
+		if (ret == 0) {
+			ret = copy_to_user(user_relocs,
+					   &relocs[reloc_count],
+					   exec_list[i].relocation_count *
+					   sizeof(*relocs));
+		}
+
+		reloc_count += exec_list[i].relocation_count;
+	}
+
+	drm_free(relocs, reloc_count * sizeof(*relocs), DRM_MEM_DRIVER);
+
+	return ret;
+}
+
 int
 i915_gem_execbuffer(struct drm_device *dev, void *data,
 		    struct drm_file *file_priv)
@@ -2983,9 +3038,10 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 	struct drm_gem_object *batch_obj;
 	struct drm_i915_gem_object *obj_priv;
 	struct drm_clip_rect *cliprects = NULL;
-	int ret, i, pinned = 0;
+	struct drm_i915_gem_relocation_entry *relocs;
+	int ret, ret2, i, pinned = 0;
 	uint64_t exec_offset;
-	uint32_t seqno, flush_domains;
+	uint32_t seqno, flush_domains, reloc_index;
 	int pin_tries;
 
 #if WATCH_EXEC
@@ -3036,6 +3092,11 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 		}
 	}
 
+	ret = i915_gem_get_relocs_from_user(exec_list, args->buffer_count,
+					    &relocs);
+	if (ret != 0)
+		goto pre_mutex_err;
+
 	mutex_lock(&dev->struct_mutex);
 
 	i915_verify_inactive(dev, __FILE__, __LINE__);
@@ -3078,15 +3139,19 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 	/* Pin and relocate */
 	for (pin_tries = 0; ; pin_tries++) {
 		ret = 0;
+		reloc_index = 0;
+
 		for (i = 0; i < args->buffer_count; i++) {
 			object_list[i]->pending_read_domains = 0;
 			object_list[i]->pending_write_domain = 0;
 			ret = i915_gem_object_pin_and_relocate(object_list[i],
 							       file_priv,
-							       &exec_list[i]);
+							       &exec_list[i],
+							       &relocs[reloc_index]);
 			if (ret)
 				break;
 			pinned = i + 1;
+			reloc_index += exec_list[i].relocation_count;
 		}
 		/* success */
 		if (ret == 0)
@@ -3236,6 +3301,20 @@ err:
 				  args->buffer_count, ret);
 	}
 
+	/* Copy the updated relocations out regardless of current error
+	 * state.  Failure to update the relocs would mean that the next
+	 * time userland calls execbuf, it would do so with presumed offset
+	 * state that didn't match the actual object state.
+	 */
+	ret2 = i915_gem_put_relocs_to_user(exec_list, args->buffer_count,
+					   relocs);
+	if (ret2 != 0) {
+		DRM_ERROR("Failed to copy relocations back out: %d\n", ret2);
+
+		if (ret == 0)
+			ret = ret2;
+	}
+
 pre_mutex_err:
 	drm_free(object_list, sizeof(*object_list) * args->buffer_count,
 		 DRM_MEM_DRIVER);
-- 
1.6.2.1

