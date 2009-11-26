Return-Path: <linux-kernel-owner+w=401wt.eu-S1760623AbZKZO6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623AbZKZO6n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 09:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760613AbZKZO6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 09:58:41 -0500
Received: from nox.protox.org ([88.191.38.29]:52575 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760270AbZKZO6k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 09:58:40 -0500
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Don't overwrite crtc_gen_cntl or crtc_gen_cntl2
Date: Thu, 26 Nov 2009 15:58:36 +0100
Message-Id: <1259247516-6576-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't overwritte  crtc_gen_cntl or crtc_gen_cntl2 or we may loose the
cursor. This especialy happen when changing video mode. Fix bugs:
https://bugzilla.redhat.com/show_bug.cgi?id=529146

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |   11 ++++-------
 1 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 8d0b7aa..8f6a8d1 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -642,12 +642,8 @@ static bool radeon_set_crtc_timing(struct drm_crtc *crtc, struct drm_display_mod
 		uint32_t crtc2_gen_cntl;
 		uint32_t disp2_merge_cntl;
 
-		/* check to see if TV DAC is enabled for another crtc and keep it enabled */
-		if (RREG32(RADEON_CRTC2_GEN_CNTL) & RADEON_CRTC2_CRT2_ON)
-			crtc2_gen_cntl = RADEON_CRTC2_CRT2_ON;
-		else
-			crtc2_gen_cntl = 0;
-
+		/* if TV DAC is enabled for another crtc and keep it enabled */
+		crtc2_gen_cntl = RREG32(RADEON_CRTC2_GEN_CNTL) & 0x00718080;
 		crtc2_gen_cntl |= ((format << 8)
 				   | RADEON_CRTC2_VSYNC_DIS
 				   | RADEON_CRTC2_HSYNC_DIS
@@ -676,7 +672,8 @@ static bool radeon_set_crtc_timing(struct drm_crtc *crtc, struct drm_display_mod
 		uint32_t crtc_ext_cntl;
 		uint32_t disp_merge_cntl;
 
-		crtc_gen_cntl = (RADEON_CRTC_EXT_DISP_EN
+		crtc_gen_cntl = RREG32(RADEON_CRTC_GEN_CNTL) & 0x00718000;
+		crtc_gen_cntl |= (RADEON_CRTC_EXT_DISP_EN
 				 | (format << 8)
 				 | RADEON_CRTC_DISP_REQ_EN_B
 				 | ((mode->flags & DRM_MODE_FLAG_DBLSCAN)
-- 
1.6.5.2

