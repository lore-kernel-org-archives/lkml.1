Return-Path: <linux-kernel-owner+w=401wt.eu-S1757531AbZCYVr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531AbZCYVr2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 17:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753890AbZCYVpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 17:45:24 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:56437 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754517AbZCYVpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 17:45:15 -0400
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: dri-devel@lists.sourceforge.net, Eric Anholt <eric@anholt.net>
Subject: [PATCH 5/6] drm/i915: Fix lock order reversal with cliprects and cmdbuf in non-DRI2 paths.
Date: Wed, 25 Mar 2009 14:45:09 -0700
Message-Id: <1238017510-26784-6-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1238017510-26784-5-git-send-email-eric@anholt.net>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
 <1238017510-26784-2-git-send-email-eric@anholt.net>
 <1238017510-26784-3-git-send-email-eric@anholt.net>
 <1238017510-26784-4-git-send-email-eric@anholt.net>
 <1238017510-26784-5-git-send-email-eric@anholt.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This introduces allocation in the batch submission path that wasn't there
previously, but these are compatibility paths so we care about simplicity
more than performance.

kernel.org bug #12419.

Signed-off-by: Eric Anholt <eric@anholt.net>
Reviewed-by: Keith Packard <keithp@keithp.com>
---
 drivers/gpu/drm/i915/i915_dma.c |  107 ++++++++++++++++++++++++++------------
 drivers/gpu/drm/i915/i915_drv.h |    2 +-
 drivers/gpu/drm/i915/i915_gem.c |   27 ++++++++--
 3 files changed, 97 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 6d21b9e..ae83fe0 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -356,7 +356,7 @@ static int validate_cmd(int cmd)
 	return ret;
 }
 
-static int i915_emit_cmds(struct drm_device * dev, int __user * buffer, int dwords)
+static int i915_emit_cmds(struct drm_device * dev, int *buffer, int dwords)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
 	int i;
@@ -370,8 +370,7 @@ static int i915_emit_cmds(struct drm_device * dev, int __user * buffer, int dwor
 	for (i = 0; i < dwords;) {
 		int cmd, sz;
 
-		if (DRM_COPY_FROM_USER_UNCHECKED(&cmd, &buffer[i], sizeof(cmd)))
-			return -EINVAL;
+		cmd = buffer[i];
 
 		if ((sz = validate_cmd(cmd)) == 0 || i + sz > dwords)
 			return -EINVAL;
@@ -379,11 +378,7 @@ static int i915_emit_cmds(struct drm_device * dev, int __user * buffer, int dwor
 		OUT_RING(cmd);
 
 		while (++i, --sz) {
-			if (DRM_COPY_FROM_USER_UNCHECKED(&cmd, &buffer[i],
-							 sizeof(cmd))) {
-				return -EINVAL;
-			}
-			OUT_RING(cmd);
+			OUT_RING(buffer[i]);
 		}
 	}
 
@@ -397,17 +392,13 @@ static int i915_emit_cmds(struct drm_device * dev, int __user * buffer, int dwor
 
 int
 i915_emit_box(struct drm_device *dev,
-	      struct drm_clip_rect __user *boxes,
+	      struct drm_clip_rect *boxes,
 	      int i, int DR1, int DR4)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_clip_rect box;
+	struct drm_clip_rect box = boxes[i];
 	RING_LOCALS;
 
-	if (DRM_COPY_FROM_USER_UNCHECKED(&box, &boxes[i], sizeof(box))) {
-		return -EFAULT;
-	}
-
 	if (box.y2 <= box.y1 || box.x2 <= box.x1 || box.y2 <= 0 || box.x2 <= 0) {
 		DRM_ERROR("Bad box %d,%d..%d,%d\n",
 			  box.x1, box.y1, box.x2, box.y2);
@@ -460,7 +451,9 @@ static void i915_emit_breadcrumb(struct drm_device *dev)
 }
 
 static int i915_dispatch_cmdbuffer(struct drm_device * dev,
-				   drm_i915_cmdbuffer_t * cmd)
+				   drm_i915_cmdbuffer_t *cmd,
+				   struct drm_clip_rect *cliprects,
+				   void *cmdbuf)
 {
 	int nbox = cmd->num_cliprects;
 	int i = 0, count, ret;
@@ -476,13 +469,13 @@ static int i915_dispatch_cmdbuffer(struct drm_device * dev,
 
 	for (i = 0; i < count; i++) {
 		if (i < nbox) {
-			ret = i915_emit_box(dev, cmd->cliprects, i,
+			ret = i915_emit_box(dev, cliprects, i,
 					    cmd->DR1, cmd->DR4);
 			if (ret)
 				return ret;
 		}
 
-		ret = i915_emit_cmds(dev, (int __user *)cmd->buf, cmd->sz / 4);
+		ret = i915_emit_cmds(dev, cmdbuf, cmd->sz / 4);
 		if (ret)
 			return ret;
 	}
@@ -492,10 +485,10 @@ static int i915_dispatch_cmdbuffer(struct drm_device * dev,
 }
 
 static int i915_dispatch_batchbuffer(struct drm_device * dev,
-				     drm_i915_batchbuffer_t * batch)
+				     drm_i915_batchbuffer_t * batch,
+				     struct drm_clip_rect *cliprects)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_clip_rect __user *boxes = batch->cliprects;
 	int nbox = batch->num_cliprects;
 	int i = 0, count;
 	RING_LOCALS;
@@ -511,7 +504,7 @@ static int i915_dispatch_batchbuffer(struct drm_device * dev,
 
 	for (i = 0; i < count; i++) {
 		if (i < nbox) {
-			int ret = i915_emit_box(dev, boxes, i,
+			int ret = i915_emit_box(dev, cliprects, i,
 						batch->DR1, batch->DR4);
 			if (ret)
 				return ret;
@@ -626,6 +619,7 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 	    master_priv->sarea_priv;
 	drm_i915_batchbuffer_t *batch = data;
 	int ret;
+	struct drm_clip_rect *cliprects = NULL;
 
 	if (!dev_priv->allow_batchbuffer) {
 		DRM_ERROR("Batchbuffer ioctl disabled\n");
@@ -637,17 +631,35 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 
 	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (batch->num_cliprects && DRM_VERIFYAREA_READ(batch->cliprects,
-						       batch->num_cliprects *
-						       sizeof(struct drm_clip_rect)))
-		return -EFAULT;
+	if (batch->num_cliprects < 0)
+		return -EINVAL;
+
+	if (batch->num_cliprects) {
+		cliprects = drm_calloc(batch->num_cliprects,
+				       sizeof(struct drm_clip_rect),
+				       DRM_MEM_DRIVER);
+		if (cliprects == NULL)
+			return -ENOMEM;
+
+		ret = copy_from_user(cliprects, batch->cliprects,
+				     batch->num_cliprects *
+				     sizeof(struct drm_clip_rect));
+		if (ret != 0)
+			goto fail_free;
+	}
 
 	mutex_lock(&dev->struct_mutex);
-	ret = i915_dispatch_batchbuffer(dev, batch);
+	ret = i915_dispatch_batchbuffer(dev, batch, cliprects);
 	mutex_unlock(&dev->struct_mutex);
 
 	if (sarea_priv)
 		sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
+
+fail_free:
+	drm_free(cliprects,
+		 batch->num_cliprects * sizeof(struct drm_clip_rect),
+		 DRM_MEM_DRIVER);
+
 	return ret;
 }
 
@@ -659,6 +671,8 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 	drm_i915_sarea_t *sarea_priv = (drm_i915_sarea_t *)
 	    master_priv->sarea_priv;
 	drm_i915_cmdbuffer_t *cmdbuf = data;
+	struct drm_clip_rect *cliprects = NULL;
+	void *batch_data;
 	int ret;
 
 	DRM_DEBUG("i915 cmdbuffer, buf %p sz %d cliprects %d\n",
@@ -666,25 +680,50 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 
 	RING_LOCK_TEST_WITH_RETURN(dev, file_priv);
 
-	if (cmdbuf->num_cliprects &&
-	    DRM_VERIFYAREA_READ(cmdbuf->cliprects,
-				cmdbuf->num_cliprects *
-				sizeof(struct drm_clip_rect))) {
-		DRM_ERROR("Fault accessing cliprects\n");
-		return -EFAULT;
+	if (cmdbuf->num_cliprects < 0)
+		return -EINVAL;
+
+	batch_data = drm_alloc(cmdbuf->sz, DRM_MEM_DRIVER);
+	if (batch_data == NULL)
+		return -ENOMEM;
+
+	ret = copy_from_user(batch_data, cmdbuf->buf, cmdbuf->sz);
+	if (ret != 0)
+		goto fail_batch_free;
+
+	if (cmdbuf->num_cliprects) {
+		cliprects = drm_calloc(cmdbuf->num_cliprects,
+				       sizeof(struct drm_clip_rect),
+				       DRM_MEM_DRIVER);
+		if (cliprects == NULL)
+			goto fail_batch_free;
+
+		ret = copy_from_user(cliprects, cmdbuf->cliprects,
+				     cmdbuf->num_cliprects *
+				     sizeof(struct drm_clip_rect));
+		if (ret != 0)
+			goto fail_clip_free;
 	}
 
 	mutex_lock(&dev->struct_mutex);
-	ret = i915_dispatch_cmdbuffer(dev, cmdbuf);
+	ret = i915_dispatch_cmdbuffer(dev, cmdbuf, cliprects, batch_data);
 	mutex_unlock(&dev->struct_mutex);
 	if (ret) {
 		DRM_ERROR("i915_dispatch_cmdbuffer failed\n");
-		return ret;
+		goto fail_batch_free;
 	}
 
 	if (sarea_priv)
 		sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
-	return 0;
+
+fail_batch_free:
+	drm_free(batch_data, cmdbuf->sz, DRM_MEM_DRIVER);
+fail_clip_free:
+	drm_free(cliprects,
+		 cmdbuf->num_cliprects * sizeof(struct drm_clip_rect),
+		 DRM_MEM_DRIVER);
+
+	return ret;
 }
 
 static int i915_flip_bufs(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index 75e3384..2c02ce6 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -520,7 +520,7 @@ extern int i915_driver_device_is_agp(struct drm_device * dev);
 extern long i915_compat_ioctl(struct file *filp, unsigned int cmd,
 			      unsigned long arg);
 extern int i915_emit_box(struct drm_device *dev,
-			 struct drm_clip_rect __user *boxes,
+			 struct drm_clip_rect *boxes,
 			 int i, int DR1, int DR4);
 
 /* i915_irq.c */
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 010af90..2bda151 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -2891,11 +2891,10 @@ i915_gem_object_pin_and_relocate(struct drm_gem_object *obj,
 static int
 i915_dispatch_gem_execbuffer(struct drm_device *dev,
 			      struct drm_i915_gem_execbuffer *exec,
+			      struct drm_clip_rect *cliprects,
 			      uint64_t exec_offset)
 {
 	drm_i915_private_t *dev_priv = dev->dev_private;
-	struct drm_clip_rect __user *boxes = (struct drm_clip_rect __user *)
-					     (uintptr_t) exec->cliprects_ptr;
 	int nbox = exec->num_cliprects;
 	int i = 0, count;
 	uint32_t	exec_start, exec_len;
@@ -2916,7 +2915,7 @@ i915_dispatch_gem_execbuffer(struct drm_device *dev,
 
 	for (i = 0; i < count; i++) {
 		if (i < nbox) {
-			int ret = i915_emit_box(dev, boxes, i,
+			int ret = i915_emit_box(dev, cliprects, i,
 						exec->DR1, exec->DR4);
 			if (ret)
 				return ret;
@@ -2983,6 +2982,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 	struct drm_gem_object **object_list = NULL;
 	struct drm_gem_object *batch_obj;
 	struct drm_i915_gem_object *obj_priv;
+	struct drm_clip_rect *cliprects = NULL;
 	int ret, i, pinned = 0;
 	uint64_t exec_offset;
 	uint32_t seqno, flush_domains;
@@ -3019,6 +3019,23 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 		goto pre_mutex_err;
 	}
 
+	if (args->num_cliprects != 0) {
+		cliprects = drm_calloc(args->num_cliprects, sizeof(*cliprects),
+				       DRM_MEM_DRIVER);
+		if (cliprects == NULL)
+			goto pre_mutex_err;
+
+		ret = copy_from_user(cliprects,
+				     (struct drm_clip_rect __user *)
+				     (uintptr_t) args->cliprects_ptr,
+				     sizeof(*cliprects) * args->num_cliprects);
+		if (ret != 0) {
+			DRM_ERROR("copy %d cliprects failed: %d\n",
+				  args->num_cliprects, ret);
+			goto pre_mutex_err;
+		}
+	}
+
 	mutex_lock(&dev->struct_mutex);
 
 	i915_verify_inactive(dev, __FILE__, __LINE__);
@@ -3155,7 +3172,7 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 #endif
 
 	/* Exec the batchbuffer */
-	ret = i915_dispatch_gem_execbuffer(dev, args, exec_offset);
+	ret = i915_dispatch_gem_execbuffer(dev, args, cliprects, exec_offset);
 	if (ret) {
 		DRM_ERROR("dispatch failed %d\n", ret);
 		goto err;
@@ -3224,6 +3241,8 @@ pre_mutex_err:
 		 DRM_MEM_DRIVER);
 	drm_free(exec_list, sizeof(*exec_list) * args->buffer_count,
 		 DRM_MEM_DRIVER);
+	drm_free(cliprects, sizeof(*cliprects) * args->num_cliprects,
+		 DRM_MEM_DRIVER);
 
 	return ret;
 }
-- 
1.6.2.1

