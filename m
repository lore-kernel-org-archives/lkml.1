Return-Path: <linux-kernel-owner+w=401wt.eu-S1754322AbZLTMKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754322AbZLTMKp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 07:10:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbZLTMKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 07:10:44 -0500
Received: from wsp.xs4all.nl ([80.101.25.214]:44008 "EHLO wsprwl.xs4all.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753332AbZLTMKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 07:10:43 -0500
X-Greylist: delayed 510 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Dec 2009 07:10:43 EST
Message-ID: <4B2E1241.9070503@xs4all.nl>
Date: Sun, 20 Dec 2009 13:02:09 +0100
From: Ruud Linders <kernelml@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Thunderbird/3.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Stable version 2.6.32.2 broke my KMS Radeon setup
Content-Type: multipart/mixed;
 boundary="------------010600080900090403070004"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010600080900090403070004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


Hello,

After upgrading from 2.6.32.1 to 2.6.32.2 my radeon KMS broke. Broke
meaning after kernel boot at the moment radeon module is loaded, I get a
blank screen, monitor goes in powersave mode and machine stops booting
(ping-able but can't login via ssh and nothing in the logs after
Sysrq-S-U-B reboot).

Upgraded userspace  (drm/mesa/xf86-video-ati) to git version from
19-december but no change.

Note this happens on 2 different systems, both connected via DVI-D to an
LCD monitor:
  Chipset: "ATI RV730XT [Radeon HD 4670]" (ChipID = 0x9490)
and
  Chipset: "ATI Radeon HD 3200 Graphics" (ChipID = 0x9610)

So I started looking at the diff between 2.6.32.1 & 2.6.32.2, backing
out attached change makes everything work again. Anything else I can
provide to debug/fix this, let me know.

Ruud


--------------010600080900090403070004
Content-Type: text/plain;
 name="DIFF"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="DIFF"

--- atombios_crtc.c	2009-12-20 12:28:42.921933107 +0100
+++ atombios_crtc.c.NEW	2009-12-20 12:28:36.223818764 +0100
@@ -241,6 +241,7 @@
 {
 	struct drm_device *dev = crtc->dev;
 	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
 
 	switch (mode) {
 	case DRM_MODE_DPMS_ON:
@@ -248,20 +249,19 @@
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

--------------010600080900090403070004--
