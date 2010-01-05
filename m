Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780Ab0AEAl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780Ab0AEAl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:41:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476Ab0AEAf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:57 -0500
Received: from kroah.org ([198.145.64.141]:42381 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab0AEAfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:55 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Dave Airlie <airlied@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 72/97] drm/radeon/kms: fix crtc vblank update for r600
Date: Mon,  4 Jan 2010 16:33:25 -0800
Message-Id: <1262651630-7354-72-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
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
1.6.6

