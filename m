Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbZAWWyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbZAWWyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 17:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757563AbZAWWyX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 17:54:23 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:63396 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757513AbZAWWyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 17:54:22 -0500
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: Eric Anholt <eric@anholt.net>
Subject: [PATCH] drm/i915: Set up an MTRR covering the GTT at driver load.
Date: Fri, 23 Jan 2009 14:54:17 -0800
Message-Id: <1232751258-32611-1-git-send-email-eric@anholt.net>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We'd love to just be using PAT, but even on chips with PAT it gets disabled
sometimes due to an errata.  It would probably be better to have pat_enabled
exported and only bother with this when !pat_enabled.
---
 drivers/gpu/drm/i915/i915_dma.c |   30 +++++++++++++++++++++++++-----
 drivers/gpu/drm/i915/i915_drv.h |    1 +
 drivers/gpu/drm/i915/i915_gem.c |    6 ------
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 439d271..c391568 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -968,10 +968,6 @@ static int i915_load_modeset_init(struct drm_device *dev)
 	if (ret)
 		goto kfree_devname;
 
-        dev_priv->mm.gtt_mapping =
-		io_mapping_create_wc(dev->agp->base,
-				     dev->agp->agp_info.aper_size * 1024*1024);
-
 	/* Allow hardware batchbuffers unless told otherwise.
 	 */
 	dev_priv->allow_batchbuffer = 1;
@@ -1083,6 +1079,24 @@ int i915_driver_load(struct drm_device *dev, unsigned long flags)
 		goto free_priv;
 	}
 
+        dev_priv->mm.gtt_mapping =
+		io_mapping_create_wc(dev->agp->base,
+				     dev->agp->agp_info.aper_size * 1024*1024);
+	/* Set up a WC MTRR for non-PAT systems.  This is more common than
+	 * one would think, because the kernel disables PAT on first
+	 * generation Core chips because WC PAT gets overridden by a UC
+	 * MTRR if present.  Even if a UC MTRR isn't present.
+	 */
+	dev_priv->mm.gtt_mtrr = -1;
+	dev_priv->mm.gtt_mtrr = mtrr_add(dev->agp->base,
+					 dev->agp->agp_info.aper_size *
+					 1024 * 1024,
+					 MTRR_TYPE_WRCOMB, 1);
+	if (dev_priv->mm.gtt_mtrr < 0) {
+		DRM_INFO("MTRR allocation failed\n.  Graphics "
+			 "performance may suffer.\n");
+	}
+
 #ifdef CONFIG_HIGHMEM64G
 	/* don't enable GEM on PAE - needs agp + set_memory_* interface fixes */
 	dev_priv->has_gem = 0;
@@ -1147,8 +1161,14 @@ int i915_driver_unload(struct drm_device *dev)
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	io_mapping_free(dev_priv->mm.gtt_mapping);
+	if (dev_priv->mm.gtt_mtrr >= 0) {
+		mtrr_del(dev_priv->mm.gtt_mtrr, dev->agp->base,
+			 dev->agp->agp_info.aper_size * 1024 * 1024);
+		dev_priv->mm.gtt_mtrr = -1;
+	}
+
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
-		io_mapping_free(dev_priv->mm.gtt_mapping);
 		drm_irq_uninstall(dev);
 	}
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index e135182..f471d21 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -284,6 +284,7 @@ typedef struct drm_i915_private {
 		struct drm_mm gtt_space;
 
 		struct io_mapping *gtt_mapping;
+		int gtt_mtrr;
 
 		/**
 		 * List of objects currently involved in rendering from the
diff --git a/drivers/gpu/drm/i915/i915_gem.c b/drivers/gpu/drm/i915/i915_gem.c
index 3741101..66a2dc1 100644
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@ -3229,10 +3229,6 @@ i915_gem_entervt_ioctl(struct drm_device *dev, void *data,
 		dev_priv->mm.wedged = 0;
 	}
 
-	dev_priv->mm.gtt_mapping = io_mapping_create_wc(dev->agp->base,
-							dev->agp->agp_info.aper_size
-							* 1024 * 1024);
-
 	mutex_lock(&dev->struct_mutex);
 	dev_priv->mm.suspended = 0;
 
@@ -3255,7 +3251,6 @@ int
 i915_gem_leavevt_ioctl(struct drm_device *dev, void *data,
 		       struct drm_file *file_priv)
 {
-	drm_i915_private_t *dev_priv = dev->dev_private;
 	int ret;
 
 	if (drm_core_check_feature(dev, DRIVER_MODESET))
@@ -3264,7 +3259,6 @@ i915_gem_leavevt_ioctl(struct drm_device *dev, void *data,
 	ret = i915_gem_idle(dev);
 	drm_irq_uninstall(dev);
 
-	io_mapping_free(dev_priv->mm.gtt_mapping);
 	return ret;
 }
 
-- 
1.5.6.5

