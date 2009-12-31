Return-Path: <linux-kernel-owner+w=401wt.eu-S1751474AbZLaGbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbZLaGbM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 01:31:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751330AbZLaGbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 01:31:10 -0500
Received: from smtpauth.net4india.com ([202.71.129.41]:49274 "EHLO
	smtpauth.net4india.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZLaGbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 01:31:10 -0500
From: David John <davidjon@xenontk.org>
To: airlied@gmail.com
Cc: linux-kernel@vger.kernel.org, eric@anholt.net, jbarnes@virtuousgeek.org
Subject: [PATCH v2] drm: Keep disabled outputs disabled after suspend / resume
Date: Thu, 31 Dec 2009 12:00:46 +0530
Message-Id: <1262241046-3740-1-BlackWidow-davidjon@xenontk.org>
X-Mailer: BlackWidow
In-Reply-To: <4B3C24BC.3040906@xenontk.org>
References: <4B3C24BC.3040906@xenontk.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current DRM code, an output that has been powered off
from userspace will automatically power back on when resuming
from suspend. This patch fixes this behaviour.

Tested only with the Intel i915 driver on an Intel GM45 Express
chipset.

Signed-off-by: David John <davidjon@xenontk.org>

diff --git a/drivers/gpu/drm/drm_crtc_helper.c b/drivers/gpu/drm/drm_crtc_helper.c
index 4231d6d..aba79c4 100644
--- a/drivers/gpu/drm/drm_crtc_helper.c
+++ b/drivers/gpu/drm/drm_crtc_helper.c
@@ -216,7 +216,7 @@ bool drm_helper_crtc_in_use(struct drm_crtc *crtc)
 EXPORT_SYMBOL(drm_helper_crtc_in_use);
 
 /**
- * drm_disable_unused_functions - disable unused objects
+ * drm_helper_disable_unused_functions - disable unused objects
  * @dev: DRM device
  *
  * LOCKING:
@@ -1162,6 +1162,9 @@ EXPORT_SYMBOL(drm_helper_mode_fill_fb_struct);
 int drm_helper_resume_force_mode(struct drm_device *dev)
 {
 	struct drm_crtc *crtc;
+	struct drm_encoder *encoder;
+	struct drm_encoder_helper_funcs *encoder_funcs;
+	struct drm_crtc_helper_funcs *crtc_funcs;
 	int ret;
 
 	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
@@ -1174,6 +1177,25 @@ int drm_helper_resume_force_mode(struct drm_device *dev)
 
 		if (ret == false)
 			DRM_ERROR("failed to set mode on crtc %p\n", crtc);
+
+		/* Turn off outputs that were already powered off */
+		if (drm_helper_choose_crtc_dpms(crtc)) {
+			list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
+
+				if(encoder->crtc != crtc)
+					continue;
+
+				encoder_funcs = encoder->helper_private;
+				if (encoder_funcs->dpms)
+					(*encoder_funcs->dpms) (encoder,
+								drm_helper_choose_encoder_dpms(encoder));
+
+				crtc_funcs = crtc->helper_private;
+				if (crtc_funcs->dpms)
+					(*crtc_funcs->dpms) (crtc,
+							     drm_helper_choose_crtc_dpms(crtc));
+			}
+		}
 	}
 	/* disable the unused connectors while restoring the modesetting */
 	drm_helper_disable_unused_functions(dev);
