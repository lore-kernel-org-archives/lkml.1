Return-Path: <linux-kernel-owner+w=401wt.eu-S1752524AbZIKLAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbZIKLAj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZIKLAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:00:39 -0400
Received: from nox.protox.org ([88.191.38.29]:49428 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751677AbZIKLAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:00:38 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: move mtrr range add and memory information
Date: Fri, 11 Sep 2009 13:00:43 +0200
Message-Id: <1252666843-1532-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move mtrr range and memory information printing to radeon_object_init,
this are memory information and initialization common to all GPU and
they better fit in this function. Will also prevent code duplication
with upcoming init path changes.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_device.c |    8 --------
 drivers/gpu/drm/radeon/radeon_object.c |    7 +++++++
 2 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 72f6262..07ef8b6 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -598,14 +598,6 @@ int radeon_device_init(struct radeon_device *rdev,
 		/* Get vram informations */
 		radeon_vram_info(rdev);
 
-		/* Add an MTRR for the VRAM */
-		rdev->mc.vram_mtrr = mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
-				MTRR_TYPE_WRCOMB, 1);
-		DRM_INFO("Detected VRAM RAM=%uM, BAR=%uM\n",
-				(unsigned)(rdev->mc.mc_vram_size >> 20),
-				(unsigned)(rdev->mc.aper_size >> 20));
-		DRM_INFO("RAM width %dbits %cDR\n",
-				rdev->mc.vram_width, rdev->mc.vram_is_ddr ? 'D' : 'S');
 		/* Initialize memory controller (also test AGP) */
 		r = radeon_mc_init(rdev);
 		if (r) {
diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index b85fb83..8992085 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -369,6 +369,13 @@ void radeon_object_force_delete(struct radeon_device *rdev)
 
 int radeon_object_init(struct radeon_device *rdev)
 {
+	/* Add an MTRR for the VRAM */
+	rdev->mc.vram_mtrr = mtrr_add(rdev->mc.aper_base, rdev->mc.aper_size,
+			MTRR_TYPE_WRCOMB, 1);
+	DRM_INFO("Detected VRAM RAM=%lluM, BAR=%lluM\n",
+		rdev->mc.mc_vram_size >> 20, rdev->mc.aper_size >> 20);
+	DRM_INFO("RAM width %dbits %cDR\n",
+			rdev->mc.vram_width, rdev->mc.vram_is_ddr ? 'D' : 'S');
 	return radeon_ttm_init(rdev);
 }
 
-- 
1.6.4.2

