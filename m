Return-Path: <linux-kernel-owner+w=401wt.eu-S1757607Ab0ANWiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757607Ab0ANWiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756625Ab0ANWiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:38:18 -0500
Received: from kroah.org ([198.145.64.141]:60540 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853Ab0ANW2b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:31 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 17/52] drm/i915: Make the BPC in FDI rx/transcoder be consistent with that in pipeconf on Ironlake
Date: Thu, 14 Jan 2010 14:26:56 -0800
Message-Id: <1263508051-7868-17-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-16-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
 <1263508051-7868-1-git-send-email-gregkh@suse.de>
 <1263508051-7868-2-git-send-email-gregkh@suse.de>
 <1263508051-7868-3-git-send-email-gregkh@suse.de>
 <1263508051-7868-4-git-send-email-gregkh@suse.de>
 <1263508051-7868-5-git-send-email-gregkh@suse.de>
 <1263508051-7868-6-git-send-email-gregkh@suse.de>
 <1263508051-7868-7-git-send-email-gregkh@suse.de>
 <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263508051-7868-16-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

commit 8faf3b317471179c02db339aa80955a2e88c036d upstream.

Make the BPC in FDI rx/transcoder be consistent with that in pipeconf on Ironlake.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/intel_display.c |   26 +++++++++++++++++++++++++-
 1 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 2e7e521..d02016d 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -1473,6 +1473,10 @@ static void igdng_crtc_dpms(struct drm_crtc *crtc, int mode)
 	int trans_vsync_reg = (pipe == 0) ? TRANS_VSYNC_A : TRANS_VSYNC_B;
 	u32 temp;
 	int tries = 5, j, n;
+	u32 pipe_bpc;
+
+	temp = I915_READ(pipeconf_reg);
+	pipe_bpc = temp & PIPE_BPC_MASK;
 
 	/* XXX: When our outputs are all unaware of DPMS modes other than off
 	 * and on, we should map those modes to DRM_MODE_DPMS_OFF in the CRTC.
@@ -1504,6 +1508,12 @@ static void igdng_crtc_dpms(struct drm_crtc *crtc, int mode)
 
 			/* enable PCH FDI RX PLL, wait warmup plus DMI latency */
 			temp = I915_READ(fdi_rx_reg);
+			/*
+			 * make the BPC in FDI Rx be consistent with that in
+			 * pipeconf reg.
+			 */
+			temp &= ~(0x7 << 16);
+			temp |= (pipe_bpc << 11);
 			I915_WRITE(fdi_rx_reg, temp | FDI_RX_PLL_ENABLE |
 					FDI_SEL_PCDCLK |
 					FDI_DP_PORT_WIDTH_X4); /* default 4 lanes */
@@ -1644,6 +1654,12 @@ static void igdng_crtc_dpms(struct drm_crtc *crtc, int mode)
 
 			/* enable PCH transcoder */
 			temp = I915_READ(transconf_reg);
+			/*
+			 * make the BPC in transcoder be consistent with
+			 * that in pipeconf reg.
+			 */
+			temp &= ~PIPE_BPC_MASK;
+			temp |= pipe_bpc;
 			I915_WRITE(transconf_reg, temp | TRANS_ENABLE);
 			I915_READ(transconf_reg);
 
@@ -1722,6 +1738,9 @@ static void igdng_crtc_dpms(struct drm_crtc *crtc, int mode)
 		I915_READ(fdi_tx_reg);
 
 		temp = I915_READ(fdi_rx_reg);
+		/* BPC in FDI rx is consistent with that in pipeconf */
+		temp &= ~(0x07 << 16);
+		temp |= (pipe_bpc << 11);
 		I915_WRITE(fdi_rx_reg, temp & ~FDI_RX_ENABLE);
 		I915_READ(fdi_rx_reg);
 
@@ -1765,7 +1784,12 @@ static void igdng_crtc_dpms(struct drm_crtc *crtc, int mode)
 				}
 			}
 		}
-
+		temp = I915_READ(transconf_reg);
+		/* BPC in transcoder is consistent with that in pipeconf */
+		temp &= ~PIPE_BPC_MASK;
+		temp |= pipe_bpc;
+		I915_WRITE(transconf_reg, temp);
+		I915_READ(transconf_reg);
 		udelay(100);
 
 		/* disable PCH DPLL */
-- 
1.6.6

