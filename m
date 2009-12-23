Return-Path: <linux-kernel-owner+w=401wt.eu-S1757366AbZLWVoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757366AbZLWVoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:44:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757259AbZLWVno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:43:44 -0500
Received: from mail.windriver.com ([147.11.1.11]:48159 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757115AbZLWVnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:43:41 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH 36/37] drm,i915 - atomic mutex hacks
Date: Wed, 23 Dec 2009 15:43:03 -0600
Message-Id: <1261604584-5796-4-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261604584-5796-3-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-33-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-1-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-2-git-send-email-jason.wessel@windriver.com>
 <1261604584-5796-3-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:43:17.0966 (UTC) FILETIME=[F054EEE0:01CA8418]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some hacks to work around mutex crashes in the drm / i915
code.

For now, this is the only way to make the kms / kgdb path safe on an
SMP system.

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/drm_fb_helper.c      |   18 ++++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |   21 +++++++++++++++++++++
 2 files changed, 39 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index b390fd8..ac9ca4a 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -400,8 +400,14 @@ static void drm_fb_helper_on(struct fb_info *info)
 			    !crtc->enabled)
 				continue;
 
+#ifdef CONFIG_KGDB
+			if (atomic_read(&kgdb_active) == -1)
+#endif
 			mutex_lock(&dev->mode_config.mutex);
 			crtc_funcs->dpms(crtc, DRM_MODE_DPMS_ON);
+#ifdef CONFIG_KGDB
+			if (atomic_read(&kgdb_active) == -1)
+#endif
 			mutex_unlock(&dev->mode_config.mutex);
 
 			/* Found a CRTC on this fb, now find encoders */
@@ -410,8 +416,14 @@ static void drm_fb_helper_on(struct fb_info *info)
 					struct drm_encoder_helper_funcs *encoder_funcs;
 
 					encoder_funcs = encoder->helper_private;
+#ifdef CONFIG_KGDB
+					if (atomic_read(&kgdb_active) == -1)
+#endif
 					mutex_lock(&dev->mode_config.mutex);
 					encoder_funcs->dpms(encoder, DRM_MODE_DPMS_ON);
+#ifdef CONFIG_KGDB
+					if (atomic_read(&kgdb_active) == -1)
+#endif
 					mutex_unlock(&dev->mode_config.mutex);
 				}
 			}
@@ -828,8 +840,14 @@ int drm_fb_helper_pan_display(struct fb_var_screeninfo *var,
 		modeset->y = var->yoffset;
 
 		if (modeset->num_connectors) {
+#ifdef CONFIG_KGDB
+			if (atomic_read(&kgdb_active) == -1)
+#endif
 			mutex_lock(&dev->mode_config.mutex);
 			ret = crtc->funcs->set_config(modeset);
+#ifdef CONFIG_KGDB
+			if (atomic_read(&kgdb_active) == -1)
+#endif
 			mutex_unlock(&dev->mode_config.mutex);
 			if (!ret) {
 				info->var.xoffset = var->xoffset;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 71816db..669f9b4 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -949,6 +949,12 @@ intel_find_pll_g4x_dp(const intel_limit_t *limit, struct drm_crtc *crtc,
 void
 intel_wait_for_vblank(struct drm_device *dev)
 {
+#ifdef CONFIG_KGDB
+	if (atomic_read(&kgdb_active) != -1) {
+		mdelay(20);
+		return;
+	}
+#endif /* CONFIG_KGDB */
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
 	msleep(20);
 }
@@ -1371,9 +1377,15 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	obj = intel_fb->obj;
 	obj_priv = obj->driver_private;
 
+#ifdef CONFIG_KGDB
+	if (atomic_read(&kgdb_active) == -1)
+#endif
 	mutex_lock(&dev->struct_mutex);
 	ret = intel_pin_and_fence_fb_obj(dev, obj);
 	if (ret != 0) {
+#ifdef CONFIG_KGDB
+		if (atomic_read(&kgdb_active) == -1)
+#endif
 		mutex_unlock(&dev->struct_mutex);
 		return ret;
 	}
@@ -1381,6 +1393,9 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	ret = i915_gem_object_set_to_gtt_domain(obj, 1);
 	if (ret != 0) {
 		i915_gem_object_unpin(obj);
+#ifdef CONFIG_KGDB
+		if (atomic_read(&kgdb_active) == -1)
+#endif
 		mutex_unlock(&dev->struct_mutex);
 		return ret;
 	}
@@ -1408,6 +1423,9 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	default:
 		DRM_ERROR("Unknown color depth\n");
 		i915_gem_object_unpin(obj);
+#ifdef CONFIG_KGDB
+	if (atomic_read(&kgdb_active) == -1)
+#endif
 		mutex_unlock(&dev->struct_mutex);
 		return -EINVAL;
 	}
@@ -1452,6 +1470,9 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	}
 	intel_increase_pllclock(crtc, true);
 
+#ifdef CONFIG_KGDB
+	if (atomic_read(&kgdb_active) == -1)
+#endif
 	mutex_unlock(&dev->struct_mutex);
 
 	if (!dev->primary->master)
-- 
1.6.4.rc1

