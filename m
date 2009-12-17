Return-Path: <linux-kernel-owner+w=401wt.eu-S936198AbZLQEFu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936198AbZLQEFu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 23:05:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935683AbZLQEEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 23:04:46 -0500
Received: from kroah.org ([198.145.64.141]:55655 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935663AbZLQEEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 23:04:39 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 19:56:52 2009
Message-Id: <20091217035652.853830165@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 19:56:14 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>
Subject: [077/151] drm/radeon/kms: handle vblanks properly with dpms on
In-Reply-To: <20091217040208.GA26571@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Deucher <alexdeucher@gmail.com>

commit 500b758725314ab1b5316eb0caa5b0fa26740e6b upstream.

avivo chips

Copied from pre-avivo code.

Signed-off-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/atombios_crtc.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -241,6 +241,7 @@ void atombios_crtc_dpms(struct drm_crtc 
 {
 	struct drm_device *dev = crtc->dev;
 	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
@@ -248,20 +249,19 @@ void atombios_crtc_dpms(struct drm_crtc 
 		if (ASIC_IS_DCE3(rdev))
 			atombios_enable_crtc_memreq(crtc, 1);
 		atombios_blank_crtc(crtc, 0);
+		drm_vblank_post_modeset(dev, radeon_crtc->crtc_id);
+		radeon_crtc_load_lut(crtc);
 		break;
 	case DRM_MODE_DPMS_STANDBY:
 	case DRM_MODE_DPMS_SUSPEND:
 	case DRM_MODE_DPMS_OFF:
+		drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
 		atombios_blank_crtc(crtc, 1);
 		if (ASIC_IS_DCE3(rdev))
 			atombios_enable_crtc_memreq(crtc, 0);
 		atombios_enable_crtc(crtc, 0);
 		break;
 	}
-
-	if (mode != DRM_MODE_DPMS_OFF) {
-		radeon_crtc_load_lut(crtc);
-	}
 }
 
 static void


