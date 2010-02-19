Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab0BSRSx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 12:18:53 -0500
Received: from kroah.org ([198.145.64.141]:57379 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753925Ab0BSRAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 12:00:11 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Feb 19 08:32:33 2010
Message-Id: <20100219163233.011634662@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 19 Feb 2010 08:29:05 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David John <davidjon@xenontk.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [12/93] drm/i915: Disable SR when more than one pipe is enabled
In-Reply-To: <20100219165717.GA15002@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David John <davidjon@xenontk.org>

commit 33c5fd121eabbccc9103daf6cda36941eb3c349f upstream.

Self Refresh should be disabled on dual plane configs.  Otherwise, as
the SR watermark is not calculated for such configs, switching to non
VGA mode causes FIFO underrun and display flicker.

This fixes Korg Bug #14897.

Signed-off-by: David John <davidjon@xenontk.org>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/i915/intel_display.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -2538,6 +2538,10 @@ static void g4x_update_wm(struct drm_dev
 		sr_entries = roundup(sr_entries / cacheline_size, 1);
 		DRM_DEBUG("self-refresh entries: %d\n", sr_entries);
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG("Setting FIFO watermarks - A: %d, B: %d, SR %d\n",
@@ -2581,6 +2585,10 @@ static void i965_update_wm(struct drm_de
 			srwm = 1;
 		srwm &= 0x3f;
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN);
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG_KMS("Setting FIFO watermarks - A: 8, B: 8, C: 8, SR %d\n",
@@ -2649,6 +2657,10 @@ static void i9xx_update_wm(struct drm_de
 		if (srwm < 0)
 			srwm = 1;
 		I915_WRITE(FW_BLC_SELF, FW_BLC_SELF_EN | (srwm & 0x3f));
+	} else {
+		/* Turn off self refresh if both pipes are enabled */
+		I915_WRITE(FW_BLC_SELF, I915_READ(FW_BLC_SELF)
+					& ~FW_BLC_SELF_EN);
 	}
 
 	DRM_DEBUG("Setting FIFO watermarks - A: %d, B: %d, C: %d, SR %d\n",


