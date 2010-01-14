Return-Path: <linux-kernel-owner+w=401wt.eu-S932255Ab0ANPB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932255Ab0ANPB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234Ab0ANPBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:01:50 -0500
Received: from mail.windriver.com ([147.11.1.11]:47924 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932217Ab0ANPBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:47 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH 36/40] drm,i915 - atomic mutex hacks
Date: Thu, 14 Jan 2010 08:59:32 -0600
Message-Id: <1263481176-1897-37-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:21.0788 (UTC) FILETIME=[6F0EB3C0:01CA952A]
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
 drivers/gpu/drm/drm_fb_helper.c      |   12 ++++++------
 drivers/gpu/drm/i915/intel_display.c |   17 ++++++++++++-----
 2 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 1097a47..e00301f 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -396,9 +396,9 @@ static void drm_fb_helper_on(struct fb_info *info)
 			    !crtc->enabled)
 				continue;
 
-			mutex_lock(&dev->mode_config.mutex);
+			dbg_safe_mutex_lock(&dev->mode_config.mutex);
 			crtc_funcs->dpms(crtc, DRM_MODE_DPMS_ON);
-			mutex_unlock(&dev->mode_config.mutex);
+			dbg_safe_mutex_unlock(&dev->mode_config.mutex);
 
 			/* Found a CRTC on this fb, now find encoders */
 			list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
@@ -406,9 +406,9 @@ static void drm_fb_helper_on(struct fb_info *info)
 					struct drm_encoder_helper_funcs *encoder_funcs;
 
 					encoder_funcs = encoder->helper_private;
-					mutex_lock(&dev->mode_config.mutex);
+					dbg_safe_mutex_lock(&dev->mode_config.mutex);
 					encoder_funcs->dpms(encoder, DRM_MODE_DPMS_ON);
-					mutex_unlock(&dev->mode_config.mutex);
+					dbg_safe_mutex_unlock(&dev->mode_config.mutex);
 				}
 			}
 		}
@@ -819,9 +819,9 @@ int drm_fb_helper_pan_display(struct fb_var_screeninfo *var,
 		modeset->y = var->yoffset;
 
 		if (modeset->num_connectors) {
-			mutex_lock(&dev->mode_config.mutex);
+			dbg_safe_mutex_lock(&dev->mode_config.mutex);
 			ret = crtc->funcs->set_config(modeset);
-			mutex_unlock(&dev->mode_config.mutex);
+			dbg_safe_mutex_unlock(&dev->mode_config.mutex);
 			if (!ret) {
 				info->var.xoffset = var->xoffset;
 				info->var.yoffset = var->yoffset;
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 11beb0f..0378840 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -929,6 +929,13 @@ intel_find_pll_g4x_dp(const intel_limit_t *limit, struct drm_crtc *crtc,
 void
 intel_wait_for_vblank(struct drm_device *dev)
 {
+	if (in_dbg_master()) {
+		/* When in the kernel debugger we cannot sleep */
+		preempt_disable();
+		mdelay(20);
+		preempt_enable();
+		return;
+	}
 	/* Wait for 20ms, i.e. one cycle at 50hz. */
 	msleep(20);
 }
@@ -1351,17 +1358,17 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	obj = intel_fb->obj;
 	obj_priv = obj->driver_private;
 
-	mutex_lock(&dev->struct_mutex);
+	dbg_safe_mutex_lock(&dev->struct_mutex);
 	ret = intel_pin_and_fence_fb_obj(dev, obj);
 	if (ret != 0) {
-		mutex_unlock(&dev->struct_mutex);
+		dbg_safe_mutex_unlock(&dev->struct_mutex);
 		return ret;
 	}
 
 	ret = i915_gem_object_set_to_gtt_domain(obj, 1);
 	if (ret != 0) {
 		i915_gem_object_unpin(obj);
-		mutex_unlock(&dev->struct_mutex);
+		dbg_safe_mutex_unlock(&dev->struct_mutex);
 		return ret;
 	}
 
@@ -1388,7 +1395,7 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	default:
 		DRM_ERROR("Unknown color depth\n");
 		i915_gem_object_unpin(obj);
-		mutex_unlock(&dev->struct_mutex);
+		dbg_safe_mutex_unlock(&dev->struct_mutex);
 		return -EINVAL;
 	}
 	if (IS_I965G(dev)) {
@@ -1432,7 +1439,7 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	}
 	intel_increase_pllclock(crtc, true);
 
-	mutex_unlock(&dev->struct_mutex);
+	dbg_safe_mutex_unlock(&dev->struct_mutex);
 
 	if (!dev->primary->master)
 		return 0;
-- 
1.6.3.1.9.g95405b

