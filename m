Return-Path: <linux-kernel-owner+w=401wt.eu-S1753953Ab0A0JtL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab0A0JtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 04:49:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753820Ab0A0JtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 04:49:10 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:44043 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab0A0JtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 04:49:09 -0500
From: David John <davidjon@xenontk.org>
To: jbarnes@virtuousgeek.org, yakui.zhao@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Disable SR when more than one pipe is enabled
Date: Wed, 27 Jan 2010 15:19:08 +0530
Message-Id: <1264585748-16929-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: BlackWidow 0.1
In-Reply-To: <4B60080E.2000508@xenontk.org>
References: <4B60080E.2000508@xenontk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Self Refresh should be disabled on dual plane configs.
Otherwise, as the SR watermark is not calculated for
such configs, switching to non VGA mode causes FIFO
underrun and display flicker.

This fixes Korg Bug # 14897.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 45da78e..46d7c0c 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2519,6 +2519,10 @@ static void g4x_update_wm(struct drm_device *dev,  int planea_clock,
 		sr_entries = roundup(sr_entries / cacheline_size, 1);
 		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG("Setting FIFO watermarks - A: %d, B: %d, SR %d\n",
@@ -2562,6 +2566,10 @@ static void i965_update_wm(struct drm_device *dev, int planea_clock,
 			srwm = 1;
 		srwm &= 0x3f;
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG_KMS("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n",
@@ -2630,6 +2638,10 @@ static void i9xx_update_wm(struct drm_device *dev, int planea_clock,
 		if (srwm < 0)
 			srwm = 1;
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN | (srwm & 0x3f));
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG_KMS("Setting FIFO watermarks - A: %d, B: %d, C: %d, SR %d\n",
