Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbZBRQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbZBRQii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 11:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752449AbZBRQi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 11:38:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44173 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751458AbZBRQi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 11:38:29 -0500
From: krh@bitplanet.net
To: eric@anholt.net
Cc: Wang Chen <wangchen@cn.fujitsu.com>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org,
       =?utf-8?q?Kristian=20H=C3=B8gsberg?= <krh@redhat.com>
Subject: [PATCH] drm: Take mmap_sem up front to avoid lock order violations.
Date: Wed, 18 Feb 2009 11:38:33 -0500
Message-Id: <1234975113-4941-1-git-send-email-krh@bitplanet.net>
In-Reply-To: <499BC08C.5000603@cn.fujitsu.com>
References: <499BC08C.5000603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kristian Høgsberg <krh@redhat.com>

A number of GEM operations (and legacy drm ones) want to copy data to
or from userspace while holding the struct_mutex lock.  However, the
fault handler calls us with the mmap_sem held and thus enforces the
opposite locking order.  This patch downs the mmap_sem up front for
those operations that access userspace data under the struct_mutex
lock to ensure the locking order is consistent.

Signed-off-by: Kristian Høgsberg <krh@redhat.com>
---

Here's a different and simpler attempt to fix the locking order
problem.  We can just down_read() the mmap_sem pre-emptively up-front,
and the locking order is respected.  It's simpler than the
mutex_trylock() game, avoids introducing a new mutex.

(forgot to add lkml, resending)

cheers,
Kristian

 drivers/gpu/drm/i915/i915_dma.c |    6 +++++-
 drivers/gpu/drm/i915/i915_gem.c |   20 +++++++++++++-------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 81f1cff..d8b58d9 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -642,9 +642,11 @@ static int i915_batchbuffer(struct drm_device *dev, void *data,
 						       sizeof(struct drm_clip_rect)))
 		return -EFAULT;
 
+	down_read(&current->mm->mmap_sem);
 	mutex_lock(&dev->struct_mutex);
 	ret = i915_dispatch_batchbuffer(dev, batch);
 	mutex_unlock(&dev->struct_mutex);
+	up_read(&current->mm->mmap_sem);
 
 	if (sarea_priv)
 		sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
@@ -674,14 +676,16 @@ static int i915_cmdbuffer(struct drm_device *dev, void *data,
 		return -EFAULT;
 	}
 
+	down_read(&current->mm->mmap_sem);
 	mutex_lock(&dev->struct_mutex);
 	ret = i915_dispatch_cmdbuffer(dev, cmdbuf);
 	mutex_unlock(&dev->struct_mutex);
+	up_read(&current->mm->mmap_sem);
+
 	if (ret) {
 		DRM_ERROR("i915_dispatch_cmdbuffer failed\n");
 		return ret;
 	}
-
 	if (sarea_priv)
 		sarea_priv->last_dispatch = READ_BREADCRUMB(dev_priv);
 	return 0;
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index d9cd42f..3dd8b6e 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -171,6 +171,7 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 		return -EINVAL;
 	}
 
+	down_read(&current->mm->mmap_sem);
 	mutex_lock(&dev->struct_mutex);
 
 	ret = i915_gem_object_set_cpu_read_domain_range(obj, args->offset,
@@ -196,6 +197,7 @@ i915_gem_pread_ioctl(struct drm_device *dev, void *data,
 
 	drm_gem_object_unreference(obj);
 	mutex_unlock(&dev->struct_mutex);
+	up_read(&current->mm->mmap_sem);
 
 	return 0;
 }
@@ -264,7 +266,7 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 	if (!access_ok(VERIFY_READ, user_data, remain))
 		return -EFAULT;
 
-
+	down_read(&current->mm->mmap_sem);
 	mutex_lock(&dev->struct_mutex);
 	ret = i915_gem_object_pin(obj, 0);
 	if (ret) {
@@ -315,6 +317,7 @@ i915_gem_gtt_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 fail:
 	i915_gem_object_unpin(obj);
 	mutex_unlock(&dev->struct_mutex);
+	up_read(&current->mm->mmap_sem);
 
 	return ret;
 }
@@ -328,6 +331,7 @@ i915_gem_shmem_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 	loff_t offset;
 	ssize_t written;
 
+	down_read(&current->mm->mmap_sem);
 	mutex_lock(&dev->struct_mutex);
 
 	ret = i915_gem_object_set_to_cpu_domain(obj, 1);
@@ -350,6 +354,7 @@ i915_gem_shmem_pwrite(struct drm_device *dev, struct drm_gem_object *obj,
 	}
 
 	mutex_unlock(&dev->struct_mutex);
+	up_read(&current->mm->mmap_sem);
 
 	return 0;
 }
@@ -2473,22 +2478,21 @@ i915_gem_execbuffer(struct drm_device *dev, void *data,
 		goto pre_mutex_err;
 	}
 
+	down_read(&current->mm->mmap_sem);
 	mutex_lock(&dev->struct_mutex);
 
 	i915_verify_inactive(dev, __FILE__, __LINE__);
 
 	if (dev_priv->mm.wedged) {
 		DRM_ERROR("Execbuf while wedged\n");
-		mutex_unlock(&dev->struct_mutex);
 		ret = -EIO;
-		goto pre_mutex_err;
+		goto mutex_err;
 	}
 
 	if (dev_priv->mm.suspended) {
 		DRM_ERROR("Execbuf while VT-switched.\n");
-		mutex_unlock(&dev->struct_mutex);
 		ret = -EBUSY;
-		goto pre_mutex_err;
+		goto mutex_err;
 	}
 
 	/* Look up object handles */
@@ -2641,8 +2645,6 @@ err:
 	for (i = 0; i < args->buffer_count; i++)
 		drm_gem_object_unreference(object_list[i]);
 
-	mutex_unlock(&dev->struct_mutex);
-
 	if (!ret) {
 		/* Copy the new buffer offsets back to the user's exec list. */
 		ret = copy_to_user((struct drm_i915_relocation_entry __user *)
@@ -2655,6 +2657,10 @@ err:
 				  args->buffer_count, ret);
 	}
 
+mutex_err:
+	mutex_unlock(&dev->struct_mutex);
+	up_read(&current->mm->mmap_sem);
+
 pre_mutex_err:
 	drm_free(object_list, sizeof(*object_list) * args->buffer_count,
 		 DRM_MEM_DRIVER);
-- 
1.6.1.3

