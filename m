Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbZHMUNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbZHMUNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbZHMUNX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:13:23 -0400
Received: from kroah.org ([198.145.64.141]:41676 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755879AbZHMT7W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 15:59:22 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Thu Aug 13 12:51:26 2009
Message-Id: <20090813195126.779209273@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Thu, 13 Aug 2009 12:49:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>
Subject: [patch 15/74] drm/i915: apply G45 vblank count code to all G4x chips and fix max_frame_count
References: <20090813194935.985368088@mini.kroah.org>
Content-Disposition: inline; filename=0002-drm-i915-apply-G45-vblank-count-code-to-all-G4x-chip.patch
In-Reply-To: <20090813195705.GA22393@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesse Barnes <jbarnes@virtuousgeek.org>

(cherry picked from commit 42c2798b35b95c471877133e19ccc3cab00e9b65)

All G4x and newer chips use the new style frame count register, with a
full 32 bit frame count.  Update the code to reflect this.

Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Eric Anholt <eric@anholt.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/gpu/drm/i915/i915_dma.c |    5 ++++-
 drivers/gpu/drm/i915/i915_irq.c |    2 --
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -1153,8 +1153,11 @@ int i915_driver_load(struct drm_device *
 #endif
 
 	dev->driver->get_vblank_counter = i915_get_vblank_counter;
-	if (IS_GM45(dev))
+	dev->max_vblank_count = 0xffffff; /* only 24 bits of frame count */
+	if (IS_G4X(dev)) {
+		dev->max_vblank_count = 0xffffffff; /* full 32 bit counter */
 		dev->driver->get_vblank_counter = gm45_get_vblank_counter;
+	}
 
 	i915_gem_load(dev);
 
--- a/drivers/gpu/drm/i915/i915_irq.c
+++ b/drivers/gpu/drm/i915/i915_irq.c
@@ -572,8 +572,6 @@ int i915_driver_irq_postinstall(struct d
 
 	dev_priv->vblank_pipe = DRM_I915_VBLANK_PIPE_A | DRM_I915_VBLANK_PIPE_B;
 
-	dev->max_vblank_count = 0xffffff; /* only 24 bits of frame count */
-
 	/* Unmask the interrupts that we always want on. */
 	dev_priv->irq_mask_reg = ~I915_INTERRUPT_ENABLE_FIX;
 


