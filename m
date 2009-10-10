Return-Path: <linux-kernel-owner+w=401wt.eu-S1762106AbZJJUlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762106AbZJJUlq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 16:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762069AbZJJUlq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 16:41:46 -0400
Received: from thunk.org ([69.25.196.29]:59422 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762065AbZJJUlp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 16:41:45 -0400
Date: Sat, 10 Oct 2009 16:41:06 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091010204106.GA8251@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org> <20091008103620.5e5aae66@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008103620.5e5aae66@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 10:36:20AM -0700, Jesse Barnes wrote:
> On Fri, 02 Oct 2009 18:40:27 -0400
> "Theodore Ts'o" <tytso@mit.edu> wrote:
> 
> > Hi, 
> > 
> > In recent kernels, my X display (running with a KMS-enabled X server)
> > has been very jittery and with lots of glitching and tearing --- sorry
> > if this isn't the correct technical term, not sure what it is --- on
> > my T400 Lenovo laptop.   It seems related to what is on the desktop,
> > and moving the mouse does seem to affect the rate and percentage of
> > the screen which jitters --- which is enough to be very distracting,
> > although I can still read the contents of the windows where the screen
> > is tearing/glitching/flashing.
> > 
> > I bisected it down to this commit:
> 
> Can you give this patch a try?  It seems to work for Keith at least,
> and it sounds like he was seeing the same problem.

Nope, unfortunately, it's not helping on my T400 laptop.  I'm still
getting huge amounts of glitching and tearing with this patch applied
against -rc3.

What I'm using for now to fix up my system is this patch.

     	       	       	      	    	   - Ted


commit 4e3166295914308c5a5910a93dec5596c94c5128
Author: Theodore Ts'o <tytso@mit.edu>
Date:   Fri Oct 2 21:35:06 2009 -0400

    Revert "drm/i915: framebuffer compression for GM45+"
    
    This reverts commit 74dff282237ea8c0a5df1afd8526eac4b6cee063.

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 45d507e..560ddea 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1126,47 +1126,34 @@ static void i915_setup_compression(struct drm_device *dev, int size)
 		return;
 	}
 
-	cfb_base = i915_gtt_to_phys(dev, compressed_fb->start);
-	if (!cfb_base) {
-		DRM_ERROR("failed to get stolen phys addr, disabling FBC\n");
-		drm_mm_put_block(compressed_fb);
+	compressed_llb = drm_mm_search_free(&dev_priv->vram, 4096, 4096, 0);
+	if (!compressed_llb) {
+		i915_warn_stolen(dev);
+		return;
 	}
 
-	if (!IS_GM45(dev)) {
-		compressed_llb = drm_mm_search_free(&dev_priv->vram, 4096,
-						    4096, 0);
-		if (!compressed_llb) {
-			i915_warn_stolen(dev);
-			return;
-		}
-
-		compressed_llb = drm_mm_get_block(compressed_llb, 4096, 4096);
-		if (!compressed_llb) {
-			i915_warn_stolen(dev);
-			return;
-		}
-
-		ll_base = i915_gtt_to_phys(dev, compressed_llb->start);
-		if (!ll_base) {
-			DRM_ERROR("failed to get stolen phys addr, disabling FBC\n");
-			drm_mm_put_block(compressed_fb);
-			drm_mm_put_block(compressed_llb);
-		}
+	compressed_llb = drm_mm_get_block(compressed_llb, 4096, 4096);
+	if (!compressed_llb) {
+		i915_warn_stolen(dev);
+		return;
 	}
 
 	dev_priv->cfb_size = size;
 
-	if (IS_GM45(dev)) {
-		g4x_disable_fbc(dev);
-		I915_WRITE(DPFC_CB_BASE, compressed_fb->start);
-	} else {
-		i8xx_disable_fbc(dev);
-		I915_WRITE(FBC_CFB_BASE, cfb_base);
-		I915_WRITE(FBC_LL_BASE, ll_base);
+	cfb_base = i915_gtt_to_phys(dev, compressed_fb->start);
+	ll_base = i915_gtt_to_phys(dev, compressed_llb->start);
+	if (!cfb_base || !ll_base) {
+		DRM_ERROR("failed to get stolen phys addr, disabling FBC\n");
+		drm_mm_put_block(compressed_fb);
+		drm_mm_put_block(compressed_llb);
 	}
 
+	i8xx_disable_fbc(dev);
+
 	DRM_DEBUG("FBC base 0x%08lx, ll base 0x%08lx, size %dM\n", cfb_base,
 		  ll_base, size >> 20);
+	I915_WRITE(FBC_CFB_BASE, cfb_base);
+	I915_WRITE(FBC_LL_BASE, ll_base);
 }
 
 /* true = enable decode, false = disable decoder */
@@ -1227,7 +1214,7 @@ static int i915_load_modeset_init(struct drm_device *dev,
 		goto out;
 
 	/* Try to set up FBC with a reasonable compressed buffer size */
-	if (IS_MOBILE(dev) && (IS_I9XX(dev) || IS_I965G(dev) || IS_GM45(dev)) &&
+	if (IS_MOBILE(dev) && (IS_I9XX(dev) || IS_I965G(dev)) &&
 	    i915_powersave) {
 		int cfb_size;
 
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index b24b2d1..56208ea 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -828,7 +828,6 @@ extern void intel_modeset_init(struct drm_device *dev);
 extern void intel_modeset_cleanup(struct drm_device *dev);
 extern int intel_modeset_vga_set_state(struct drm_device *dev, bool state);
 extern void i8xx_disable_fbc(struct drm_device *dev);
-extern void g4x_disable_fbc(struct drm_device *dev);
 
 /**
  * Lock test for when it's just for synchronization of ring access.
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 0466ddb..b762706 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -352,33 +352,6 @@
 
 #define FBC_LL_SIZE		(1536)
 
-/* Framebuffer compression for GM45+ */
-#define DPFC_CB_BASE		0x3200
-#define DPFC_CONTROL		0x3208
-#define   DPFC_CTL_EN		(1<<31)
-#define   DPFC_CTL_PLANEA	(0<<30)
-#define   DPFC_CTL_PLANEB	(1<<30)
-#define   DPFC_CTL_FENCE_EN	(1<<29)
-#define   DPFC_SR_EN		(1<<10)
-#define   DPFC_CTL_LIMIT_1X	(0<<6)
-#define   DPFC_CTL_LIMIT_2X	(1<<6)
-#define   DPFC_CTL_LIMIT_4X	(2<<6)
-#define DPFC_RECOMP_CTL		0x320c
-#define   DPFC_RECOMP_STALL_EN	(1<<27)
-#define   DPFC_RECOMP_STALL_WM_SHIFT (16)
-#define   DPFC_RECOMP_STALL_WM_MASK (0x07ff0000)
-#define   DPFC_RECOMP_TIMER_COUNT_SHIFT (0)
-#define   DPFC_RECOMP_TIMER_COUNT_MASK (0x0000003f)
-#define DPFC_STATUS		0x3210
-#define   DPFC_INVAL_SEG_SHIFT  (16)
-#define   DPFC_INVAL_SEG_MASK	(0x07ff0000)
-#define   DPFC_COMP_SEG_SHIFT	(0)
-#define   DPFC_COMP_SEG_MASK	(0x000003ff)
-#define DPFC_STATUS2		0x3214
-#define DPFC_FENCE_YOFF		0x3218
-#define DPFC_CHICKEN		0x3224
-#define   DPFC_HT_MODIFY	(1<<31)
-
 /*
  * GPIO regs
  */
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 93ff6c0..b9633da 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1030,65 +1030,6 @@ static bool i8xx_fbc_enabled(struct drm_crtc *crtc)
 	return I915_READ(FBC_CONTROL) & FBC_CTL_EN;
 }
 
-static void g4x_enable_fbc(struct drm_crtc *crtc, unsigned long interval)
-{
-	struct drm_device *dev = crtc->dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	struct drm_framebuffer *fb = crtc->fb;
-	struct intel_framebuffer *intel_fb = to_intel_framebuffer(fb);
-	struct drm_i915_gem_object *obj_priv = intel_fb->obj->driver_private;
-	struct intel_crtc *intel_crtc = to_intel_crtc(crtc);
-	int plane = (intel_crtc->plane == 0 ? DPFC_CTL_PLANEA :
-		     DPFC_CTL_PLANEB);
-	unsigned long stall_watermark = 200;
-	u32 dpfc_ctl;
-
-	dev_priv->cfb_pitch = (dev_priv->cfb_pitch / 64) - 1;
-	dev_priv->cfb_fence = obj_priv->fence_reg;
-	dev_priv->cfb_plane = intel_crtc->plane;
-
-	dpfc_ctl = plane | DPFC_SR_EN | DPFC_CTL_LIMIT_1X;
-	if (obj_priv->tiling_mode != I915_TILING_NONE) {
-		dpfc_ctl |= DPFC_CTL_FENCE_EN | dev_priv->cfb_fence;
-		I915_WRITE(DPFC_CHICKEN, DPFC_HT_MODIFY);
-	} else {
-		I915_WRITE(DPFC_CHICKEN, ~DPFC_HT_MODIFY);
-	}
-
-	I915_WRITE(DPFC_CONTROL, dpfc_ctl);
-	I915_WRITE(DPFC_RECOMP_CTL, DPFC_RECOMP_STALL_EN |
-		   (stall_watermark << DPFC_RECOMP_STALL_WM_SHIFT) |
-		   (interval << DPFC_RECOMP_TIMER_COUNT_SHIFT));
-	I915_WRITE(DPFC_FENCE_YOFF, crtc->y);
-
-	/* enable it... */
-	I915_WRITE(DPFC_CONTROL, I915_READ(DPFC_CONTROL) | DPFC_CTL_EN);
-
-	DRM_DEBUG("enabled fbc on plane %d\n", intel_crtc->plane);
-}
-
-void g4x_disable_fbc(struct drm_device *dev)
-{
-	struct drm_i915_private *dev_priv = dev->dev_private;
-	u32 dpfc_ctl;
-
-	/* Disable compression */
-	dpfc_ctl = I915_READ(DPFC_CONTROL);
-	dpfc_ctl &= ~DPFC_CTL_EN;
-	I915_WRITE(DPFC_CONTROL, dpfc_ctl);
-	intel_wait_for_vblank(dev);
-
-	DRM_DEBUG("disabled FBC\n");
-}
-
-static bool g4x_fbc_enabled(struct drm_crtc *crtc)
-{
-	struct drm_device *dev = crtc->dev;
-	struct drm_i915_private *dev_priv = dev->dev_private;
-
-	return I915_READ(DPFC_CONTROL) & DPFC_CTL_EN;
-}
-
 /**
  * intel_update_fbc - enable/disable FBC as needed
  * @crtc: CRTC to point the compressor at
@@ -1156,7 +1097,7 @@ static void intel_update_fbc(struct drm_crtc *crtc,
 		DRM_DEBUG("mode too large for compression, disabling\n");
 		goto out_disable;
 	}
-	if ((IS_I915GM(dev) || IS_I945GM(dev)) && plane != 0) {
+	if (IS_I9XX(dev) && plane != 0) {
 		DRM_DEBUG("plane not 0, disabling compression\n");
 		goto out_disable;
 	}
@@ -1324,7 +1265,7 @@ intel_pipe_set_base(struct drm_crtc *crtc, int x, int y,
 		I915_READ(dspbase);
 	}
 
-	if ((IS_I965G(dev) || plane == 0))
+	if (I915_HAS_FBC(dev) && (IS_I965G(dev) || plane == 0))
 		intel_update_fbc(crtc, &crtc->mode);
 
 	intel_wait_for_vblank(dev);
@@ -1833,8 +1774,7 @@ static void i9xx_crtc_dpms(struct drm_crtc *crtc, int mode)
 
 		intel_crtc_load_lut(crtc);
 
-		if ((IS_I965G(dev) || plane == 0))
-			intel_update_fbc(crtc, &crtc->mode);
+		intel_update_fbc(crtc, &crtc->mode);
 
 		/* Give the overlay scaler a chance to enable if it's on this pipe */
 		//intel_crtc_dpms_video(crtc, true); TODO
@@ -3048,8 +2988,7 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
 	/* Flush the plane changes */
 	ret = intel_pipe_set_base(crtc, x, y, old_fb);
 
-	if ((IS_I965G(dev) || plane == 0))
-		intel_update_fbc(crtc, &crtc->mode);
+	intel_update_fbc(crtc, &crtc->mode);
 
 	intel_update_watermarks(dev);
 
@@ -3182,7 +3121,7 @@ static int intel_crtc_cursor_set(struct drm_crtc *crtc,
 		drm_gem_object_unreference(intel_crtc->cursor_bo);
 	}
 
-	if ((IS_I965G(dev) || plane == 0))
+	if (I915_HAS_FBC(dev) && (IS_I965G(dev) || plane == 0))
 		intel_update_fbc(crtc, &crtc->mode);
 
 	mutex_unlock(&dev->struct_mutex);
@@ -4169,16 +4108,12 @@ static void intel_init_display(struct drm_device *dev)
 
 	/* Only mobile has FBC, leave pointers NULL for other chips */
 	if (IS_MOBILE(dev)) {
-		if (IS_GM45(dev)) {
-			dev_priv->display.fbc_enabled = g4x_fbc_enabled;
-			dev_priv->display.enable_fbc = g4x_enable_fbc;
-			dev_priv->display.disable_fbc = g4x_disable_fbc;
-		} else if (IS_I965GM(dev) || IS_I945GM(dev) || IS_I915GM(dev)) {
+		/* 855GM needs testing */
+		if (IS_I965GM(dev) || IS_I945GM(dev) || IS_I915GM(dev)) {
 			dev_priv->display.fbc_enabled = i8xx_fbc_enabled;
 			dev_priv->display.enable_fbc = i8xx_enable_fbc;
 			dev_priv->display.disable_fbc = i8xx_disable_fbc;
 		}
-		/* 855GM needs testing */
 	}
 
 	/* Returns the core display clock speed */
