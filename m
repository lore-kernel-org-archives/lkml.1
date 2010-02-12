Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932215Ab0BLWjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:39:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:44560 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757835Ab0BLWji (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:39:38 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 2/7] drm: add KGDB/KDB support Add support for KDB entry/exit.
Date: Fri, 12 Feb 2010 16:36:23 -0600
Message-Id: <1266014188-29505-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
References: <1266014188-29505-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:39:24.0737 (UTC) FILETIME=[3A26AB10:01CAAC34]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jesse Barnes <jbarnes@virtuousgeek.org>

---
 drivers/gpu/drm/drm_fb_helper.c      |   79 ++++++++++++++++++++++++++++
 drivers/gpu/drm/i915/intel_display.c |   93 ++++++++++++++++++++++++++++++++++
 include/drm/drm_crtc_helper.h        |    2 +
 include/drm/drm_fb_helper.h          |    4 ++
 4 files changed, 178 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
index 0f9e905..ea06bf3 100644
--- a/drivers/gpu/drm/drm_fb_helper.c
+++ b/drivers/gpu/drm/drm_fb_helper.c
@@ -29,6 +29,7 @@
  */
 #include <linux/sysrq.h>
 #include <linux/fb.h>
+#include <linux/kgdb.h>
 #include "drmP.h"
 #include "drm_crtc.h"
 #include "drm_fb_helper.h"
@@ -233,6 +234,80 @@ int drm_fb_helper_parse_command_line(struct drm_device *dev)
 	return 0;
 }
 
+#define to_fb_helper(ops) (container_of((ops), struct drm_fb_helper, kdb_ops))
+
+static int drm_fb_kdb_enter(struct dbg_kms_ops *ops)
+{
+	struct drm_fb_helper *helper = to_fb_helper(ops);
+	struct drm_crtc_helper_funcs *funcs;
+	int i;
+
+	if (list_empty(&kernel_fb_helper_list))
+		return false;
+
+	list_for_each_entry(helper, &kernel_fb_helper_list, kernel_fb_list) {
+		for (i = 0; i < helper->crtc_count; i++) {
+			struct drm_mode_set *mode_set =
+				&helper->crtc_info[i].mode_set;
+
+			if (!mode_set->crtc->enabled)
+				continue;
+
+			funcs =	mode_set->crtc->helper_private;
+			funcs->mode_set_base_atomic(mode_set->crtc,
+						    mode_set->fb,
+						    mode_set->x,
+						    mode_set->y);
+
+		}
+	}
+
+	return 0;
+}
+
+/* Find the real fb for a given fb helper CRTC */
+static struct drm_framebuffer *drm_mode_config_fb(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_crtc *c;
+
+	list_for_each_entry(c, &dev->mode_config.crtc_list, head) {
+		if (crtc->base.id == c->base.id)
+			return c->fb;
+	}
+
+	return NULL;
+}
+
+static int drm_fb_kdb_exit(struct dbg_kms_ops *ops)
+{
+	struct drm_fb_helper *helper = to_fb_helper(ops);
+	struct drm_crtc *crtc;
+	struct drm_crtc_helper_funcs *funcs;
+	struct drm_framebuffer *fb;
+	int i;
+
+	for (i = 0; i < helper->crtc_count; i++) {
+		struct drm_mode_set *mode_set = &helper->crtc_info[i].mode_set;
+		crtc = mode_set->crtc;
+		funcs = crtc->helper_private;
+		fb = drm_mode_config_fb(crtc);
+
+		if (!crtc->enabled)
+			continue;
+
+		if (!fb) {
+			DRM_ERROR("no fb to restore??\n");
+			continue;
+		}
+
+		funcs->mode_set_base_atomic(mode_set->crtc, fb, crtc->x,
+					    crtc->y);
+	}
+
+	return 0;
+}
+
 bool drm_fb_helper_force_kernel_mode(void)
 {
 	int i = 0;
@@ -923,6 +998,9 @@ int drm_fb_helper_single_fb_probe(struct drm_device *dev,
 	/* Switch back to kernel console on panic */
 	/* multi card linked list maybe */
 	if (list_empty(&kernel_fb_helper_list)) {
+		fb_helper->kdb_ops.activate_console = drm_fb_kdb_enter;
+		fb_helper->kdb_ops.restore_console = drm_fb_kdb_exit;
+		dbg_kms_ops_register(&fb_helper->kdb_ops);
 		printk(KERN_INFO "registered panic notifier\n");
 		atomic_notifier_chain_register(&panic_notifier_list,
 					       &paniced);
@@ -937,6 +1015,7 @@ void drm_fb_helper_free(struct drm_fb_helper *helper)
 {
 	list_del(&helper->kernel_fb_list);
 	if (list_empty(&kernel_fb_helper_list)) {
+		dbg_kms_ops_unregister(&helper->kdb_ops);
 		printk(KERN_INFO "unregistered panic notifier\n");
 		atomic_notifier_chain_unregister(&panic_notifier_list,
 						 &paniced);
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index b27202d..088b8bd 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1278,6 +1278,98 @@ intel_pin_and_fence_fb_obj(struct drm_device *dev, struct drm_gem_object *obj)
 	return 0;
 }
 
+/* Assume fb object is pinned & idle & fenced and just update base pointers */
+static int
+intel_pipe_set_base_atomic(struct drm_crtc *crtc, struct drm_framebuffer *fb,
+			   int x, int y)
+{
+	struct drm_device *dev = crtc->dev;
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
+	struct intel_framebuffer *intel_fb;
+	struct drm_i915_gem_object *obj_priv;
+	struct drm_gem_object *obj;
+	int plane = intel_crtc->plane;
+	unsigned long Start, Offset;
+	int dspbase = (plane == 0 ? DSPAADDR : DSPBADDR);
+	int dspsurf = (plane == 0 ? DSPASURF : DSPBSURF);
+	int dspstride = (plane == 0) ? DSPASTRIDE : DSPBSTRIDE;
+	int dsptileoff = (plane == 0 ? DSPATILEOFF : DSPBTILEOFF);
+	int dspcntr_reg = (plane == 0) ? DSPACNTR : DSPBCNTR;
+	u32 dspcntr;
+
+	switch (plane) {
+	case 0:
+	case 1:
+		break;
+	default:
+		DRM_ERROR("Can't update plane %d in SAREA\n", plane);
+		return -EINVAL;
+	}
+
+	intel_fb = to_intel_framebuffer(fb);
+	obj = intel_fb->obj;
+	obj_priv = obj->driver_private;
+
+	dspcntr = I915_READ(dspcntr_reg);
+	/* Mask out pixel format bits in case we change it */
+	dspcntr &= ~DISPPLANE_PIXFORMAT_MASK;
+	switch (fb->bits_per_pixel) {
+	case 8:
+		dspcntr |= DISPPLANE_8BPP;
+		break;
+	case 16:
+		if (fb->depth == 15)
+			dspcntr |= DISPPLANE_15_16BPP;
+		else
+			dspcntr |= DISPPLANE_16BPP;
+		break;
+	case 24:
+	case 32:
+		dspcntr |= DISPPLANE_32BPP_NO_ALPHA;
+		break;
+	default:
+		DRM_ERROR("Unknown color depth\n");
+		return -EINVAL;
+	}
+	if (IS_I965G(dev)) {
+		if (obj_priv->tiling_mode != I915_TILING_NONE)
+			dspcntr |= DISPPLANE_TILED;
+		else
+			dspcntr &= ~DISPPLANE_TILED;
+	}
+
+	if (IS_IRONLAKE(dev))
+		/* must disable */
+		dspcntr |= DISPPLANE_TRICKLE_FEED_DISABLE;
+
+	I915_WRITE(dspcntr_reg, dspcntr);
+
+	Start = obj_priv->gtt_offset;
+	Offset = y * fb->pitch + x * (fb->bits_per_pixel / 8);
+
+	DRM_DEBUG("Writing base %08lX %08lX %d %d\n", Start, Offset, x, y);
+	I915_WRITE(dspstride, fb->pitch);
+	if (IS_I965G(dev)) {
+		I915_WRITE(dspbase, Offset);
+		I915_READ(dspbase);
+		I915_WRITE(dspsurf, Start);
+		I915_READ(dspsurf);
+		I915_WRITE(dsptileoff, (y << 16) | x);
+	} else {
+		I915_WRITE(dspbase, Start + Offset);
+		I915_READ(dspbase);
+	}
+
+	if ((IS_I965G(dev) || plane == 0))
+		intel_update_fbc(crtc, &crtc->mode);
+
+	intel_wait_for_vblank(dev);
+	intel_increase_pllclock(crtc, true);
+
+	return 0;
+}
+
 static int
 intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		    struct drm_framebuffer *old_fb)
@@ -4257,6 +4349,7 @@ static const struct drm_crtc_helper_funcs intel_helper_funcs = {
 	.mode_fixup = intel_crtc_mode_fixup,
 	.mode_set = intel_crtc_mode_set,
 	.mode_set_base = intel_pipe_set_base,
+	.mode_set_base_atomic = intel_pipe_set_base_atomic,
 	.prepare = intel_crtc_prepare,
 	.commit = intel_crtc_commit,
 	.load_lut = intel_crtc_load_lut,
diff --git a/include/drm/drm_crtc_helper.h b/include/drm/drm_crtc_helper.h
index b29e201..4c12319 100644
--- a/include/drm/drm_crtc_helper.h
+++ b/include/drm/drm_crtc_helper.h
@@ -61,6 +61,8 @@ struct drm_crtc_helper_funcs {
 	/* Move the crtc on the current fb to the given position *optional* */
 	int (*mode_set_base)(struct drm_crtc *crtc, int x, int y,
 			     struct drm_framebuffer *old_fb);
+	int (*mode_set_base_atomic)(struct drm_crtc *crtc,
+				    struct drm_framebuffer *fb, int x, int y);
 
 	/* reload the current crtc LUT */
 	void (*load_lut)(struct drm_crtc *crtc);
diff --git a/include/drm/drm_fb_helper.h b/include/drm/drm_fb_helper.h
index 58c892a..1f2ab94 100644
--- a/include/drm/drm_fb_helper.h
+++ b/include/drm/drm_fb_helper.h
@@ -30,6 +30,8 @@
 #ifndef DRM_FB_HELPER_H
 #define DRM_FB_HELPER_H
 
+#include <linux/kgdb.h>
+
 struct drm_fb_helper_crtc {
 	uint32_t crtc_id;
 	struct drm_mode_set mode_set;
@@ -63,8 +65,10 @@ struct drm_fb_helper_connector {
 
 struct drm_fb_helper {
 	struct drm_framebuffer *fb;
+	struct drm_framebuffer *saved_fb;
 	struct drm_device *dev;
 	struct drm_display_mode *mode;
+	struct dbg_kms_ops kdb_ops;
 	int crtc_count;
 	struct drm_fb_helper_crtc *crtc_info;
 	struct drm_fb_helper_funcs *funcs;
-- 
1.6.4.rc1

