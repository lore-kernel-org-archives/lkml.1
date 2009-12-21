Return-Path: <linux-kernel-owner+w=401wt.eu-S1753015AbZLUEha@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015AbZLUEha (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 23:37:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbZLUEh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 23:37:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6360 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752662AbZLUEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 23:37:29 -0500
From: Dave Airlie <airlied@gmail.com>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Dave Airlie <airlied@redhat.com>
Subject: [PATCH] stable - drm/radeon/kms: fix crtc vblank update for r600
Date: Mon, 21 Dec 2009 14:33:52 +1000
Message-Id: <1261370032-15420-1-git-send-email-airlied@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dave Airlie <airlied@redhat.com>

In 2.6.32.2 r600 had no IRQ support, however the patch in
500b758725314ab1b5316eb0caa5b0fa26740e6b to fix vblanks on avivo
cards, needs irqs.

So check for an R600 card and avoid this path if so.

This is a stable only patch for 2.6.32.2 as 2.6.33 has IRQs for r600.

Signed-off-by: Dave Airlie <airlied@redhat.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index c6777cb..19f93f2 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -249,13 +249,15 @@ void atombios_crtc_dpms(struct drm_crtc *crtc, int mode)
 		if (ASIC_IS_DCE3(rdev))
 			atombios_enable_crtc_memreq(crtc, 1);
 		atombios_blank_crtc(crtc, 0);
-		drm_vblank_post_modeset(dev, radeon_crtc->crtc_id);
+		if (rdev->family < CHIP_R600)
+			drm_vblank_post_modeset(dev, radeon_crtc->crtc_id);
 		radeon_crtc_load_lut(crtc);
 		break;
 	case DRM_MODE_DPMS_STANDBY:
 	case DRM_MODE_DPMS_SUSPEND:
 	case DRM_MODE_DPMS_OFF:
-		drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
+		if (rdev->family < CHIP_R600)
+			drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
 		atombios_blank_crtc(crtc, 1);
 		if (ASIC_IS_DCE3(rdev))
 			atombios_enable_crtc_memreq(crtc, 0);
-- 
1.6.5.2

