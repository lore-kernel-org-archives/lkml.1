Return-Path: <linux-kernel-owner+w=401wt.eu-S1757157AbZJBBvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157AbZJBBvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757126AbZJBBu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:50:56 -0400
Received: from kroah.org ([198.145.64.141]:33205 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755816AbZJBBdV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:33:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Oct  1 18:24:16 2009
Message-Id: <20091002012415.937799747@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 01 Oct 2009 18:16:51 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [063/136] drm/i915: Fix LVDS panel fitting on Arrandale
References: <20091002011548.335611824@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-lvds-panel-fitting-on-arrandale.patch
In-Reply-To: <20091002012911.GA18542@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 8dd81a381e8886129c0923f1fe22ff5ca36ae8da upstream.

Arrandale has new window based method for panel fitting.
This one enables full screen aspect scaling on LVDS. It fixes
standard mode display failure on LVDS for Arrandale.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    2 ++
 drivers/gpu/drm/i915/intel_display.c |   14 ++++++++++++++
 drivers/gpu/drm/i915/intel_lvds.c    |   11 ++++++++---
 3 files changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1867,6 +1867,8 @@
 #define  PF_ENABLE              (1<<31)
 #define PFA_WIN_SZ		0x68074
 #define PFB_WIN_SZ		0x68874
+#define PFA_WIN_POS		0x68070
+#define PFB_WIN_POS		0x68870
 
 /* legacy palette */
 #define LGC_PALETTE_A           0x4a000
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1154,6 +1154,7 @@ static void igdng_crtc_dpms(struct drm_c
 	int transconf_reg = (pipe == 0) ? TRANSACONF : TRANSBCONF;
 	int pf_ctl_reg = (pipe == 0) ? PFA_CTL_1 : PFB_CTL_1;
 	int pf_win_size = (pipe == 0) ? PFA_WIN_SZ : PFB_WIN_SZ;
+	int pf_win_pos = (pipe == 0) ? PFA_WIN_POS : PFB_WIN_POS;
 	int cpu_htot_reg = (pipe == 0) ? HTOTAL_A : HTOTAL_B;
 	int cpu_hblank_reg = (pipe == 0) ? HBLANK_A : HBLANK_B;
 	int cpu_hsync_reg = (pipe == 0) ? HSYNC_A : HSYNC_B;
@@ -1205,6 +1206,19 @@ static void igdng_crtc_dpms(struct drm_c
 			}
 		}
 
+		/* Enable panel fitting for LVDS */
+		if (intel_pipe_has_type(crtc, INTEL_OUTPUT_LVDS)) {
+			temp = I915_READ(pf_ctl_reg);
+			I915_WRITE(pf_ctl_reg, temp | PF_ENABLE);
+
+			/* currently full aspect */
+			I915_WRITE(pf_win_pos, 0);
+
+			I915_WRITE(pf_win_size,
+				   (dev_priv->panel_fixed_mode->hdisplay << 16) |
+				   (dev_priv->panel_fixed_mode->vdisplay));
+		}
+
 		/* Enable CPU pipe */
 		temp = I915_READ(pipeconf_reg);
 		if ((temp & PIPEACONF_ENABLE) == 0) {
--- a/drivers/gpu/drm/i915/intel_lvds.c
+++ b/drivers/gpu/drm/i915/intel_lvds.c
@@ -305,6 +305,10 @@ static bool intel_lvds_mode_fixup(struct
 		goto out;
 	}
 
+	/* full screen scale for now */
+	if (IS_IGDNG(dev))
+		goto out;
+
 	/* 965+ wants fuzzy fitting */
 	if (IS_I965G(dev))
 		pfit_control |= (intel_crtc->pipe << PFIT_PIPE_SHIFT) |
@@ -332,8 +336,10 @@ static bool intel_lvds_mode_fixup(struct
 	 * to register description and PRM.
 	 * Change the value here to see the borders for debugging
 	 */
-	I915_WRITE(BCLRPAT_A, 0);
-	I915_WRITE(BCLRPAT_B, 0);
+	if (!IS_IGDNG(dev)) {
+		I915_WRITE(BCLRPAT_A, 0);
+		I915_WRITE(BCLRPAT_B, 0);
+	}
 
 	switch (lvds_priv->fitting_mode) {
 	case DRM_MODE_SCALE_NO_SCALE:
@@ -582,7 +588,6 @@ static void intel_lvds_mode_set(struct d
 	 * settings.
 	 */
 
-	/* No panel fitting yet, fixme */
 	if (IS_IGDNG(dev))
 		return;
 


