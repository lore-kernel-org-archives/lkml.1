Return-Path: <linux-kernel-owner+w=401wt.eu-S1755334AbZLTQXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334AbZLTQXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 11:23:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753523AbZLTQXP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 11:23:15 -0500
Received: from mail.fem.tu-ilmenau.de ([141.24.101.79]:52835 "EHLO
	mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbZLTQXP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 11:23:15 -0500
From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
To: linux-kernel@vger.kernel.org
Subject: [stable] Regression in 2.6.32.2: radeon KMS hangs system
Date: Sun, 20 Dec 2009 17:23:10 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.32-fglrx; KDE/4.3.4; x86_64; ; )
Cc: stable@kernel.org, dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-Id: <200912201723.10385.johannes.hirte@fem.tu-ilmenau.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 2.6.32.2 the system hangs completely with black screen when modprobing 
radeon with modeset=1. I was able to connect via ssh, but after entering the 
password nothing happend. I didn't got a prompt. Only SysRq worked. I've 
tracked it down to the following patch:

>From 500b758725314ab1b5316eb0caa5b0fa26740e6b Mon Sep 17 00:00:00 2001
From: Alex Deucher <alexdeucher@gmail.com>
Date: Wed, 2 Dec 2009 11:46:52 -0500
Subject: drm/radeon/kms: handle vblanks properly with dpms on

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
+       struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 
        switch (mode) {
        case DRM_MODE_DPMS_ON:
@@ -248,20 +249,19 @@ void atombios_crtc_dpms(struct drm_crtc 
                if (ASIC_IS_DCE3(rdev))
                        atombios_enable_crtc_memreq(crtc, 1);
                atombios_blank_crtc(crtc, 0);
+               drm_vblank_post_modeset(dev, radeon_crtc->crtc_id);
+               radeon_crtc_load_lut(crtc);
                break;
        case DRM_MODE_DPMS_STANDBY:
        case DRM_MODE_DPMS_SUSPEND:
        case DRM_MODE_DPMS_OFF:
+               drm_vblank_pre_modeset(dev, radeon_crtc->crtc_id);
                atombios_blank_crtc(crtc, 1);
                if (ASIC_IS_DCE3(rdev))
                        atombios_enable_crtc_memreq(crtc, 0);
                atombios_enable_crtc(crtc, 0);
                break;
        }
-
-       if (mode != DRM_MODE_DPMS_OFF) {
-               radeon_crtc_load_lut(crtc);
-       }
 }
 
 static void


After reverting this patch, modesetting works again. It's a Radeon HD3650 AGP 
(RV635) on a Tyan Tiger K8W S2875ANRF (AMD 8151 AGP tunnel). Display is an 
Acer X223W connected on DVI.


regards,
  Johannes
