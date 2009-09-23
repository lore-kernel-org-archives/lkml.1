Return-Path: <linux-kernel-owner+w=401wt.eu-S1753041AbZIWQBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041AbZIWQBl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 12:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZIWQBi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 12:01:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbZIWQBc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 12:01:32 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Adam Jackson <ajax@redhat.com>
Subject: [PATCH 4/4] drm/edid: Fix standard timing parse for EDID <= 1.2
Date: Wed, 23 Sep 2009 12:01:32 -0400
Message-Id: <1253721692-26165-4-git-send-email-ajax@redhat.com>
In-Reply-To: <1253721692-26165-3-git-send-email-ajax@redhat.com>
References: <1253721692-26165-1-git-send-email-ajax@redhat.com>
 <1253721692-26165-2-git-send-email-ajax@redhat.com>
 <1253721692-26165-3-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aspect ratio code of 0 means 1:1 before EDID 1.3.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/gpu/drm/drm_edid.c |   17 ++++++++++++-----
 1 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index 8ed732a..9888c20 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -528,6 +528,7 @@ bad_std_timing(u8 a, u8 b)
  */
 struct drm_display_mode *drm_mode_std(struct drm_device *dev,
 				      struct std_timing *t,
+				      int revision,
 				      int timing_level)
 {
 	struct drm_display_mode *mode;
@@ -546,9 +547,12 @@ struct drm_display_mode *drm_mode_std(struct drm_device *dev,
 	/* vrefresh_rate = vfreq + 60 */
 	vrefresh_rate = vfreq + 60;
 	/* the vdisplay is calculated based on the aspect ratio */
-	if (aspect_ratio == 0)
-		vsize = (hsize * 10) / 16;
-	else if (aspect_ratio == 1)
+	if (aspect_ratio == 0) {
+		if (revision < 3)
+			vsize = hsize;
+		else
+			vsize = (hsize * 10) / 16;
+	} else if (aspect_ratio == 1)
 		vsize = (hsize * 3) / 4;
 	else if (aspect_ratio == 2)
 		vsize = (hsize * 4) / 5;
@@ -797,7 +801,7 @@ static int add_standard_modes(struct drm_connector *connector, struct edid *edid
 			continue;
 
 		newmode = drm_mode_std(dev, &edid->standard_timings[i],
-					timing_level);
+				       edid->revision, timing_level);
 		if (newmode) {
 			drm_mode_probed_add(connector, newmode);
 			modes++;
@@ -853,6 +857,7 @@ static int add_detailed_info(struct drm_connector *connector,
 
 					std = &data->data.timings[j];
 					newmode = drm_mode_std(dev, std,
+							       edid->revision,
 							       timing_level);
 					if (newmode) {
 						drm_mode_probed_add(connector, newmode);
@@ -981,7 +986,9 @@ static int add_detailed_info_eedid(struct drm_connector *connector,
 				struct drm_display_mode *newmode;
 
 				std = &data->data.timings[j];
-				newmode = drm_mode_std(dev, std, timing_level);
+				newmode = drm_mode_std(dev, std,
+						       edid->revision,
+						       timing_level);
 				if (newmode) {
 					drm_mode_probed_add(connector, newmode);
 					modes++;
-- 
1.6.4.2

