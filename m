Return-Path: <linux-kernel-owner+w=401wt.eu-S1763844AbZLQB1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763844AbZLQB1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763856AbZLQB0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:26:54 -0500
Received: from kroah.org ([198.145.64.141]:41482 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763705AbZLQBVA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:21:00 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:08 2009
Message-Id: <20091217011608.173172682@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [78/90] drm/i915: Fix LVDS stability issue on Ironlake
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 1b3c7a47f993bf9ab6c4c7cc3bbf5588052b58f4 upstream.

In disable sequence, all output ports on PCH have to be disabled
before PCH transcoder, but LVDS port was left always enabled. This
one fixes that by disable LVDS port properly during pipe disable
process, and resolved stability issue seen on Ironlake. Also move
panel fitting disable time just after pipe disable to align with
the spec.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   60 +++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 19 deletions(-)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1182,6 +1182,15 @@ static void igdng_crtc_dpms(struct drm_c
 	case DRM_MODE_DPMS_STANDBY:
 	case DRM_MODE_DPMS_SUSPEND:
 		DRM_DEBUG("crtc %d dpms on\n", pipe);
+
+		if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
+			temp = I915_READ(PCH_LVDS);
+			if ((temp & LVDS_PORT_EN) == 0) {
+				I915_WRITE(PCH_LVDS, temp | LVDS_PORT_EN);
+				POSTING_READ(PCH_LVDS);
+			}
+		}
+
 		if (HAS_eDP) {
 			/* enable eDP PLL */
 			igdng_enable_pll_edp(crtc);
@@ -1366,8 +1375,6 @@ static void igdng_crtc_dpms(struct drm_c
 	case DRM_MODE_DPMS_OFF:
 		DRM_DEBUG("crtc %d dpms off\n", pipe);
 
-		i915_disable_vga(dev);
-
 		/* Disable display plane */
 		temp = I915_READ(dspcntr_reg);
 		if ((temp & DISPLAY_PLANE_ENABLE) != 0) {
@@ -1377,6 +1384,8 @@ static void igdng_crtc_dpms(struct drm_c
 			I915_READ(dspbase_reg);
 		}
 
+		i915_disable_vga(dev);
+
 		/* disable cpu pipe, disable after all planes disabled */
 		temp = I915_READ(pipeconf_reg);
 		if ((temp & PIPEACONF_ENABLE) != 0) {
@@ -1397,9 +1406,15 @@ static void igdng_crtc_dpms(struct drm_c
 		} else
 			DRM_DEBUG("crtc %d is disabled\n", pipe);
 
-		if (HAS_eDP) {
-			igdng_disable_pll_edp(crtc);
+		udelay(100);
+
+		/* Disable PF */
+		temp = I915_READ(pf_ctl_reg);
+		if ((temp & PF_ENABLE) != 0) {
+			I915_WRITE(pf_ctl_reg, temp & ~PF_ENABLE);
+			I915_READ(pf_ctl_reg);
 		}
+		I915_WRITE(pf_win_size, 0);
 
 		/* disable CPU FDI tx and PCH FDI rx */
 		temp = I915_READ(fdi_tx_reg);
@@ -1425,6 +1440,13 @@ static void igdng_crtc_dpms(struct drm_c
 
 		udelay(100);
 
+		if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
+			temp = I915_READ(PCH_LVDS);
+			I915_WRITE(PCH_LVDS, temp & ~LVDS_PORT_EN);
+			I915_READ(PCH_LVDS);
+			udelay(100);
+		}
+
 		/* disable PCH transcoder */
 		temp = I915_READ(transconf_reg);
 		if ((temp & TRANS_ENABLE) != 0) {
@@ -1444,6 +1466,8 @@ static void igdng_crtc_dpms(struct drm_c
 			}
 		}
 
+		udelay(100);
+
 		/* disable PCH DPLL */
 		temp = I915_READ(pch_dpll_reg);
 		if ((temp & DPLL_VCO_ENABLE) != 0) {
@@ -1451,14 +1475,20 @@ static void igdng_crtc_dpms(struct drm_c
 			I915_READ(pch_dpll_reg);
 		}
 
-		temp = I915_READ(fdi_rx_reg);
-		if ((temp & FDI_RX_PLL_ENABLE) != 0) {
-			temp &= ~FDI_SEL_PCDCLK;
-			temp &= ~FDI_RX_PLL_ENABLE;
-			I915_WRITE(fdi_rx_reg, temp);
-			I915_READ(fdi_rx_reg);
+		if (HAS_eDP) {
+			igdng_disable_pll_edp(crtc);
 		}
 
+		temp = I915_READ(fdi_rx_reg);
+		temp &= ~FDI_SEL_PCDCLK;
+		I915_WRITE(fdi_rx_reg, temp);
+		I915_READ(fdi_rx_reg);
+
+		temp = I915_READ(fdi_rx_reg);
+		temp &= ~FDI_RX_PLL_ENABLE;
+		I915_WRITE(fdi_rx_reg, temp);
+		I915_READ(fdi_rx_reg);
+
 		/* Disable CPU FDI TX PLL */
 		temp = I915_READ(fdi_tx_reg);
 		if ((temp & FDI_TX_PLL_ENABLE) != 0) {
@@ -1467,16 +1497,8 @@ static void igdng_crtc_dpms(struct drm_c
 			udelay(100);
 		}
 
-		/* Disable PF */
-		temp = I915_READ(pf_ctl_reg);
-		if ((temp & PF_ENABLE) != 0) {
-			I915_WRITE(pf_ctl_reg, temp & ~PF_ENABLE);
-			I915_READ(pf_ctl_reg);
-		}
-		I915_WRITE(pf_win_size, 0);
-
 		/* Wait for the clocks to turn off. */
-		udelay(150);
+		udelay(100);
 		break;
 	}
 }


