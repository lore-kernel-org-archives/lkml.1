Return-Path: <linux-kernel-owner+w=401wt.eu-S932547AbZKFWXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbZKFWXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 17:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932512AbZKFWXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 17:23:14 -0500
Received: from kroah.org ([198.145.64.141]:56925 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760199AbZKFWXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 17:23:08 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Nov  6 14:15:46 2009
Message-Id: <20091106221546.297423527@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 06 Nov 2009 14:14:53 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Eric Anholt <eric@anholt.net>
Subject: [55/99] drm/i915: Fix FDI M/N setting according with correct color depth
References: <20091106221358.309857998@mini.kroah.org>
Content-Disposition: inline; filename=drm-i915-fix-fdi-m-n-setting-according-with-correct-color-depth.patch
In-Reply-To: <20091106221850.GA15408@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 58a27471d00dc09945cbcfbbc5cbcdcd3c28211d upstream.

FDI M/N calculation hasn't taken the current pipe color depth into account,
but always set as 24bpp. This one checks current pipe color depth setting,
and change FDI M/N calculation a little to use bits_per_pixel first, then
convert to bytes_per_pixel later.

This fixes display corrupt issue on Arrandle LVDS with 1600x900 panel
in 18bpp dual-channel mode.

Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/i915_reg.h      |    5 +++++
 drivers/gpu/drm/i915/intel_display.c |   31 +++++++++++++++++++++++++++----
 2 files changed, 32 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -1616,6 +1616,11 @@
 #define   PIPE_START_VBLANK_INTERRUPT_STATUS	(1UL<<2) /* 965 or later */
 #define   PIPE_VBLANK_INTERRUPT_STATUS		(1UL<<1)
 #define   PIPE_OVERLAY_UPDATED_STATUS		(1UL<<0)
+#define   PIPE_BPC_MASK 			(7 << 5) /* Ironlake */
+#define   PIPE_8BPC				(0 << 5)
+#define   PIPE_10BPC				(1 << 5)
+#define   PIPE_6BPC				(2 << 5)
+#define   PIPE_12BPC				(3 << 5)
 
 #define DSPARB			0x70030
 #define   DSPARB_CSTART_MASK	(0x7f << 7)
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1764,7 +1764,7 @@ fdi_reduce_ratio(u32 *num, u32 *den)
 #define LINK_N 0x80000
 
 static void
-igdng_compute_m_n(int bytes_per_pixel, int nlanes,
+igdng_compute_m_n(int bits_per_pixel, int nlanes,
 		int pixel_clock, int link_clock,
 		struct fdi_m_n *m_n)
 {
@@ -1774,7 +1774,8 @@ igdng_compute_m_n(int bytes_per_pixel, i
 
 	temp = (u64) DATA_N * pixel_clock;
 	temp = div_u64(temp, link_clock);
-	m_n->gmch_m = div_u64(temp * bytes_per_pixel, nlanes);
+	m_n->gmch_m = div_u64(temp * bits_per_pixel, nlanes);
+	m_n->gmch_m >>= 3; /* convert to bytes_per_pixel */
 	m_n->gmch_n = DATA_N;
 	fdi_reduce_ratio(&m_n->gmch_m, &m_n->gmch_n);
 
@@ -2396,7 +2397,7 @@ static int intel_crtc_mode_set(struct dr
 
 	/* FDI link */
 	if (IS_IGDNG(dev)) {
-		int lane, link_bw;
+		int lane, link_bw, bpp;
 		/* eDP doesn't require FDI link, so just set DP M/N
 		   according to current link config */
 		if (is_edp) {
@@ -2415,7 +2416,29 @@ static int intel_crtc_mode_set(struct dr
 			lane = 4;
 			link_bw = 270000;
 		}
-		igdng_compute_m_n(3, lane, target_clock,
+
+		/* determine panel color depth */
+		temp = I915_READ(pipeconf_reg);
+
+		switch (temp & PIPE_BPC_MASK) {
+		case PIPE_8BPC:
+			bpp = 24;
+			break;
+		case PIPE_10BPC:
+			bpp = 30;
+			break;
+		case PIPE_6BPC:
+			bpp = 18;
+			break;
+		case PIPE_12BPC:
+			bpp = 36;
+			break;
+		default:
+			DRM_ERROR("unknown pipe bpc value\n");
+			bpp = 24;
+		}
+
+		igdng_compute_m_n(bpp, lane, target_clock,
 				  link_bw, &m_n);
 	}
 


