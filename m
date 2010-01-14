Return-Path: <linux-kernel-owner+w=401wt.eu-S1757569Ab0ANWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757569Ab0ANWhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 17:37:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754941Ab0ANW2c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 17:28:32 -0500
Received: from kroah.org ([198.145.64.141]:60550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab0ANW2a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 17:28:30 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Zhao Yakui <yakui.zhao@intel.com>, Eric Anholt <eric@anholt.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 16/52] drm/i915: Enable/disable the dithering for LVDS based on VBT setting
Date: Thu, 14 Jan 2010 14:26:55 -0800
Message-Id: <1263508051-7868-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <1263508051-7868-15-git-send-email-gregkh@suse.de>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Yakui <yakui.zhao@intel.com>

commit 898822ce9561ab9b58a7eb60580a162a83dadecd upstream.

Enable/disable the dithering for LVDS based on VBT setting. On the 965/g4x
platform the dithering flag is defined in LVDS register. And on the ironlake
the dithering flag is defined in pipeconf register.

Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/i915_reg.h      |    4 ++++
 drivers/gpu/drm/i915/intel_display.c |   15 ++++++++++++++-
 2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 1687edf..54e5907 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -968,6 +968,8 @@
 #define   LVDS_PORT_EN			(1 << 31)
 /* Selects pipe B for LVDS data.  Must be set on pre-965. */
 #define   LVDS_PIPEB_SELECT		(1 << 30)
+/* LVDS dithering flag on 965/g4x platform */
+#define   LVDS_ENABLE_DITHER		(1 << 25)
 /* Enable border for unscaled (or aspect-scaled) display */
 #define   LVDS_BORDER_ENABLE		(1 << 15)
 /*
@@ -1737,6 +1739,8 @@
 
 /* Display & cursor control */
 
+/* dithering flag on Ironlake */
+#define PIPE_ENABLE_DITHER	(1 << 4)
 /* Pipe A */
 #define PIPEADSL		0x70000
 #define PIPEACONF		0x70008
diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index f1de53b..2e7e521 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -3104,7 +3104,20 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
 		 * appropriately here, but we need to look more thoroughly into how
 		 * panels behave in the two modes.
 		 */
-
+		/* set the dithering flag */
+		if (IS_I965G(dev)) {
+			if (dev_priv->lvds_dither) {
+				if (IS_IGDNG(dev))
+					pipeconf |= PIPE_ENABLE_DITHER;
+				else
+					lvds |= LVDS_ENABLE_DITHER;
+			} else {
+				if (IS_IGDNG(dev))
+					pipeconf &= ~PIPE_ENABLE_DITHER;
+				else
+					lvds &= ~LVDS_ENABLE_DITHER;
+			}
+		}
 		I915_WRITE(lvds_reg, lvds);
 		I915_READ(lvds_reg);
 	}
-- 
1.6.6

