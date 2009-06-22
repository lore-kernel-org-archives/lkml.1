Return-Path: <linux-kernel-owner+w=401wt.eu-S1757328AbZFVQYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbZFVQYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754419AbZFVQYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:24:25 -0400
Received: from nox.protox.org ([88.191.38.29]:59992 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752761AbZFVQYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:24:23 -0400
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 12:24:23 EDT
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 1/2] radeon: fix radeon kms framebuffer device
Date: Mon, 22 Jun 2009 18:15:58 +0200
Message-Id: <1245687358-10481-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

smem.start is a physical address which kernel can remap to access
video memory of the fb buffer. We now pin the fb buffer into vram
by doing so we are loosing vram but fbdev need to be reworked to
allow change in framebuffer address.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    4 ----
 drivers/gpu/drm/radeon/radeon_fb.c     |   27 +++++++++++++++++++--------
 drivers/gpu/drm/radeon/radeon_object.c |   30 ------------------------------
 3 files changed, 19 insertions(+), 42 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index f30aa72..3f48a57 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -496,7 +496,6 @@ int radeon_device_init(struct radeon_device *rdev,
 	radeon_errata(rdev);
 	/* Initialize scratch registers */
 	radeon_scratch_init(rdev);
-
 	/* TODO: disable VGA need to use VGA request */
 	/* BIOS*/
 	if (!radeon_get_bios(rdev)) {
@@ -604,9 +603,6 @@ int radeon_device_init(struct radeon_device *rdev,
 	if (r) {
 		return r;
 	}
-	if (rdev->fbdev_rfb && rdev->fbdev_rfb->obj) {
-		rdev->fbdev_robj = rdev->fbdev_rfb->obj->driver_private;
-	}
 	if (!ret) {
 		DRM_INFO("radeon: kernel modesetting successfully initialized.\n");
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_fb.c b/drivers/gpu/drm/radeon/radeon_fb.c
index fa86d39..0998708 100644
--- a/drivers/gpu/drm/radeon/radeon_fb.c
+++ b/drivers/gpu/drm/radeon/radeon_fb.c
@@ -478,14 +478,16 @@ int radeonfb_create(struct radeon_device *rdev,
 {
 	struct fb_info *info;
 	struct radeon_fb_device *rfbdev;
-	struct drm_framebuffer *fb;
+	struct drm_framebuffer *fb = NULL;
 	struct radeon_framebuffer *rfb;
 	struct drm_mode_fb_cmd mode_cmd;
 	struct drm_gem_object *gobj = NULL;
 	struct radeon_object *robj = NULL;
 	struct device *device = &rdev->pdev->dev;
 	int size, aligned_size, ret;
+	u64 fb_gpuaddr;
 	void *fbptr = NULL;
+	unsigned long tmp;
 
 	mode_cmd.width = surface_width;
 	mode_cmd.height = surface_height;
@@ -498,11 +500,12 @@ int radeonfb_create(struct radeon_device *rdev,
 	aligned_size = ALIGN(size, PAGE_SIZE);
 
 	ret = radeon_gem_object_create(rdev, aligned_size, 0,
-				       RADEON_GEM_DOMAIN_VRAM,
-				       false, ttm_bo_type_kernel,
-				       false, &gobj);
+			RADEON_GEM_DOMAIN_VRAM,
+			false, ttm_bo_type_kernel,
+			false, &gobj);
 	if (ret) {
-		printk(KERN_ERR "failed to allocate framebuffer\n");
+		printk(KERN_ERR "failed to allocate framebuffer (%d %d)\n",
+		       surface_width, surface_height);
 		ret = -ENOMEM;
 		goto out;
 	}
@@ -515,12 +518,19 @@ int radeonfb_create(struct radeon_device *rdev,
 		ret = -ENOMEM;
 		goto out_unref;
 	}
+	ret = radeon_object_pin(robj, RADEON_GEM_DOMAIN_VRAM, &fb_gpuaddr);
+	if (ret) {
+		printk(KERN_ERR "failed to pin framebuffer\n");
+		ret = -ENOMEM;
+		goto out_unref;
+	}
 
 	list_add(&fb->filp_head, &rdev->ddev->mode_config.fb_kernel_list);
 
 	rfb = to_radeon_framebuffer(fb);
 	*rfb_p = rfb;
 	rdev->fbdev_rfb = rfb;
+	rdev->fbdev_robj = robj;
 
 	info = framebuffer_alloc(sizeof(struct radeon_fb_device), device);
 	if (info == NULL) {
@@ -546,8 +556,8 @@ int radeonfb_create(struct radeon_device *rdev,
 	info->flags = FBINFO_DEFAULT;
 	info->fbops = &radeonfb_ops;
 	info->fix.line_length = fb->pitch;
-	info->screen_base = fbptr;
-	info->fix.smem_start = (unsigned long)fbptr;
+	tmp = fb_gpuaddr - rdev->mc.vram_location;
+	info->fix.smem_start = rdev->mc.aper_base + tmp;
 	info->fix.smem_len = size;
 	info->screen_base = fbptr;
 	info->screen_size = size;
@@ -644,7 +654,7 @@ out_unref:
 	if (robj) {
 		radeon_object_kunmap(robj);
 	}
-	if (ret) {
+	if (fb && ret) {
 		list_del(&fb->filp_head);
 		drm_gem_object_unreference(gobj);
 		drm_framebuffer_cleanup(fb);
@@ -813,6 +823,7 @@ int radeonfb_remove(struct drm_device *dev, struct drm_framebuffer *fb)
 		robj = rfb->obj->driver_private;
 		unregister_framebuffer(info);
 		radeon_object_kunmap(robj);
+		radeon_object_unpin(robj);
 		framebuffer_release(info);
 	}
 
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 983e8df..bac0d06 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -223,7 +223,6 @@ int radeon_object_pin(struct radeon_object *robj, uint32_t domain,
 {
 	uint32_t flags;
 	uint32_t tmp;
-	void *fbptr;
 	int r;
 
 	flags = radeon_object_flags_from_domain(domain);
@@ -242,10 +241,6 @@ int radeon_object_pin(struct radeon_object *robj, uint32_t domain,
 		DRM_ERROR("radeon: failed to reserve object for pinning it.\n");
 		return r;
 	}
-	if (robj->rdev->fbdev_robj == robj) {
-		mutex_lock(&robj->rdev->fbdev_info->lock);
-		radeon_object_kunmap(robj);
-	}
 	tmp = robj->tobj.mem.placement;
 	ttm_flag_masked(&tmp, flags, TTM_PL_MASK_MEM);
 	robj->tobj.proposed_placement = tmp | TTM_PL_FLAG_NO_EVICT | TTM_PL_MASK_CACHING;
@@ -261,23 +256,12 @@ int radeon_object_pin(struct radeon_object *robj, uint32_t domain,
 		DRM_ERROR("radeon: failed to pin object.\n");
 	}
 	radeon_object_unreserve(robj);
-	if (robj->rdev->fbdev_robj == robj) {
-		if (!r) {
-			r = radeon_object_kmap(robj, &fbptr);
-		}
-		if (!r) {
-			robj->rdev->fbdev_info->screen_base = fbptr;
-			robj->rdev->fbdev_info->fix.smem_start = (unsigned long)fbptr;
-		}
-		mutex_unlock(&robj->rdev->fbdev_info->lock);
-	}
 	return r;
 }
 
 void radeon_object_unpin(struct radeon_object *robj)
 {
 	uint32_t flags;
-	void *fbptr;
 	int r;
 
 	spin_lock(&robj->tobj.lock);
@@ -297,10 +281,6 @@ void radeon_object_unpin(struct radeon_object *robj)
 		DRM_ERROR("radeon: failed to reserve object for unpinning it.\n");
 		return;
 	}
-	if (robj->rdev->fbdev_robj == robj) {
-		mutex_lock(&robj->rdev->fbdev_info->lock);
-		radeon_object_kunmap(robj);
-	}
 	flags = robj->tobj.mem.placement;
 	robj->tobj.proposed_placement = flags & ~TTM_PL_FLAG_NO_EVICT;
 	r = ttm_buffer_object_validate(&robj->tobj,
@@ -310,16 +290,6 @@ void radeon_object_unpin(struct radeon_object *robj)
 		DRM_ERROR("radeon: failed to unpin buffer.\n");
 	}
 	radeon_object_unreserve(robj);
-	if (robj->rdev->fbdev_robj == robj) {
-		if (!r) {
-			r = radeon_object_kmap(robj, &fbptr);
-		}
-		if (!r) {
-			robj->rdev->fbdev_info->screen_base = fbptr;
-			robj->rdev->fbdev_info->fix.smem_start = (unsigned long)fbptr;
-		}
-		mutex_unlock(&robj->rdev->fbdev_info->lock);
-	}
 }
 
 int radeon_object_wait(struct radeon_object *robj)
-- 
1.6.2.2

