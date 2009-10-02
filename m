Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZJBBdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZJBBdh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756284AbZJBBdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:33:31 -0400
Received: from kroah.org ([198.145.64.141]:33215 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756253AbZJBBdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:16 2009
Message-Id: <20091002012416.318878835@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [065/136] drm/i915: fix tiling on IGDNG
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-tiling-on-igdng.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 553bd149bb2de7848b2b84642876f27202421368 upstream.

It seems that on IGDNG the same swizzling setup always applys.
And front buffer tiling needs to set address swizzle in display
arb control too.

Fix plane tricle feed setting in v1 which should be disable bit,
and always setup address swizzle to let hardware care for buffer
tiling in all cases.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_gem_tiling.c |   15 +++++++--------
 drivers/gpu/drm/i915/i915_reg.h        |    4 ++++
 drivers/gpu/drm/i915/intel_display.c   |   10 ++++++++++
 3 files changed, 21 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/i915_gem_tiling.c
+++ b/drivers/gpu/drm/i915/i915_gem_tiling.c
@@ -234,7 +234,13 @@ i915_gem_detect_bit_6_swizzle(struct drm
 	uint32_t swizzle_y = I915_BIT_6_SWIZZLE_UNKNOWN;
 	bool need_disable;
 
-	if (!IS_I9XX(dev)) {
+	if (IS_IGDNG(dev)) {
+		/* On IGDNG whatever DRAM config, GPU always do
+		 * same swizzling setup.
+		 */
+		swizzle_x = I915_BIT_6_SWIZZLE_9_10;
+		swizzle_y = I915_BIT_6_SWIZZLE_9;
+	} else if (!IS_I9XX(dev)) {
 		/* As far as we know, the 865 doesn't have these bit 6
 		 * swizzling issues.
 		 */
@@ -317,13 +323,6 @@ i915_gem_detect_bit_6_swizzle(struct drm
 		}
 	}
 
-	/* FIXME: check with memory config on IGDNG */
-	if (IS_IGDNG(dev)) {
-		DRM_ERROR("disable tiling on IGDNG...\n");
-		swizzle_x = I915_BIT_6_SWIZZLE_UNKNOWN;
-		swizzle_y = I915_BIT_6_SWIZZLE_UNKNOWN;
-	}
-
 	dev_priv->mm.bit_6_swizzle_x = swizzle_x;
 	dev_priv->mm.bit_6_swizzle_y = swizzle_y;
 }
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1733,6 +1733,7 @@
 #define   DISPPLANE_NO_LINE_DOUBLE		0
 #define   DISPPLANE_STEREO_POLARITY_FIRST	0
 #define   DISPPLANE_STEREO_POLARITY_SECOND	(1<<18)
+#define   DISPPLANE_TRICKLE_FEED_DISABLE	(1<<14) /* IGDNG */
 #define   DISPPLANE_TILED			(1<<10)
 #define DSPAADDR		0x70184
 #define DSPASTRIDE		0x70188
@@ -1915,6 +1916,9 @@
 #define GTIIR   0x44018
 #define GTIER   0x4401c
 
+#define DISP_ARB_CTL	0x45000
+#define  DISP_TILE_SURFACE_SWIZZLING	(1<<13)
+
 /* PCH */
 
 /* south display engine interrupt */
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1008,6 +1008,10 @@ intel_pipe_set_base(struct drm_crtc *crt
 			dspcntr &= ~DISPPLANE_TILED;
 	}
 
+	if (IS_IGDNG(dev))
+		/* must disable */
+		dspcntr |= DISPPLANE_TRICKLE_FEED_DISABLE;
+
 	I915_WRITE(dspcntr_reg, dspcntr);
 
 	Start = obj_priv->gtt_offset;
@@ -2637,6 +2641,12 @@ static int intel_crtc_mode_set(struct dr
 
 	intel_wait_for_vblank(dev);
 
+	if (IS_IGDNG(dev)) {
+		/* enable address swizzle for tiling buffer */
+		temp = I915_READ(DISP_ARB_CTL);
+		I915_WRITE(DISP_ARB_CTL, temp | DISP_TILE_SURFACE_SWIZZLING);
+	}
+
 	I915_WRITE(dspcntr_reg, dspcntr);
 
 	/* Flush the plane changes */


