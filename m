Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227Ab0BLWj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:39:59 -0500
Received: from mail.windriver.com ([147.11.1.11]:44598 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932159Ab0BLWjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:39:54 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Airlie <airlied@linux.ie>
Subject: [PATCH 7/7] RFC,HACK,EXPERIMENTAL,drm,i915 - atomic mutex HACKS
Date: Fri, 12 Feb 2010 16:36:28 -0600
Message-Id: <1266014188-29505-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:39:29.0533 (UTC) FILETIME=[3D027AD0:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some hacks to work around mutex crashes in the drm / i915
code.

For now, this is the only way to make the kms / kgdb path safe on an
SMP system.

Helper macros were added to allow kms code to declare debugger safe
mutexes which can be used so long as the debugger restores the state
before resuming.

NOTE: This patch is not scheduled to goto the mainline, but to point
out the remaing problems that exist and demonstrate KMS / KDB working
together.

CC: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: David Airlie <airlied@linux.ie>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/gpu/drm/drm_fb_helper.c      |   12 ++++++------
 drivers/gpu/drm/i915/intel_display.c |   17 ++++++++++++-----
 include/linux/kgdb.h                 |    8 ++++++++
 3 files changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 35ede53..713e101 100644
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
index 21e9597..700d4b1 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -991,6 +991,13 @@ intel_find_pll_g4x_dp(const intel_limit_t *limit, struct drm_crtc *crtc,
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
@@ -1415,17 +1422,17 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
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
 
 	ret = i915_gem_object_set_to_display_plane(obj);
 	if (ret != 0) {
 		i915_gem_object_unpin(obj);
-		mutex_unlock(&dev->struct_mutex);
+		dbg_safe_mutex_unlock(&dev->struct_mutex);
 		return ret;
 	}
 
@@ -1452,7 +1459,7 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	default:
 		DRM_ERROR("Unknown color depth\n");
 		i915_gem_object_unpin(obj);
-		mutex_unlock(&dev->struct_mutex);
+		dbg_safe_mutex_unlock(&dev->struct_mutex);
 		return -EINVAL;
 	}
 	if (IS_I965G(dev)) {
@@ -1496,7 +1503,7 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 	}
 	intel_increase_pllclock(crtc, true);
 
-	mutex_unlock(&dev->struct_mutex);
+	dbg_safe_mutex_unlock(&dev->struct_mutex);
 
 	if (!dev->primary->master)
 		return 0;
diff --git a/include/linux/kgdb.h b/include/linux/kgdb.h
index 81bb298..2d9b738 100644
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -306,6 +306,12 @@ struct dbg_kms_ops {
 extern struct dbg_kms_ops *dbg_kms_ops;
 extern int dbg_kms_ops_register(struct dbg_kms_ops *ops);
 extern int dbg_kms_ops_unregister(struct dbg_kms_ops *ops);
+#define dbg_safe_mutex_lock(x) \
+	if (!in_dbg_master()) \
+		mutex_lock(x)
+#define dbg_safe_mutex_unlock(x) \
+	if (!in_dbg_master()) \
+		mutex_unlock(x)
 #else /* ! CONFIG_KGDB */
 #define in_dbg_master() (0)
 
@@ -317,5 +323,7 @@ static inline int dbg_kms_ops_unregister(struct dbg_kms_ops *ops)
 {
 	return 0;
 }
+#define dbg_safe_mutex_lock(x) mutex_lock(x)
+#define dbg_safe_mutex_unlock(x) mutex_unlock(x)
 #endif /* ! CONFIG_KGDB */
 #endif /* _KGDB_H_ */
-- 
1.6.4.rc1

