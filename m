Return-Path: <linux-kernel-owner+w=401wt.eu-S1755339AbZJAQEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339AbZJAQEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbZJAQEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:04:46 -0400
Received: from nox.protox.org ([88.191.38.29]:37907 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbZJAQEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:04:16 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 5/5] drm/radeon/kms: R600/RV770 remove dead code and print message for wrong BIOS
Date: Thu,  1 Oct 2009 18:02:15 +0200
Message-Id: <1254412935-9976-5-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1254412935-9976-4-git-send-email-jglisse@redhat.com>
References: <1254412935-9976-1-git-send-email-jglisse@redhat.com>
 <1254412935-9976-2-git-send-email-jglisse@redhat.com>
 <1254412935-9976-3-git-send-email-jglisse@redhat.com>
 <1254412935-9976-4-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

R600 & RV770 family are all using atombios so remove dead code and
print an error message if we fail to find a valid atombios.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r600.c  |   15 +++++----------
 drivers/gpu/drm/radeon/rv770.c |   16 +++++-----------
 2 files changed, 10 insertions(+), 21 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index e74e7a7..9f7eb08 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1476,11 +1476,7 @@ int r600_resume(struct radeon_device *rdev)
 		/* FIXME: what do we want to do here ? */
 	}
 	/* post card */
-	if (rdev->is_atom_bios) {
-		atom_asic_init(rdev->mode_info.atom_context);
-	} else {
-		radeon_combios_asic_init(rdev->ddev);
-	}
+	atom_asic_init(rdev->mode_info.atom_context);
 	/* Initialize clocks */
 	r = radeon_clocks_init(rdev);
 	if (r) {
@@ -1539,8 +1535,10 @@ int r600_init(struct radeon_device *rdev)
 			return -EINVAL;
 	}
 	/* Must be an ATOMBIOS */
-	if (!rdev->is_atom_bios)
+	if (!rdev->is_atom_bios) {
+		dev_err(rdev->dev, "Expecting atombios for R600 GPU\n");
 		return -EINVAL;
+	}
 	r = radeon_atombios_init(rdev);
 	if (r)
 		return r;
@@ -1644,10 +1642,7 @@ void r600_fini(struct radeon_device *rdev)
 		radeon_agp_fini(rdev);
 #endif
 	radeon_object_fini(rdev);
-	if (rdev->is_atom_bios)
-		radeon_atombios_fini(rdev);
-	else
-		radeon_combios_fini(rdev);
+	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
 	radeon_dummy_page_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index a04e6ee..295cf14 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -841,11 +841,7 @@ int rv770_resume(struct radeon_device *rdev)
 		/* FIXME: what do we want to do here ? */
 	}
 	/* post card */
-	if (rdev->is_atom_bios) {
-		atom_asic_init(rdev->mode_info.atom_context);
-	} else {
-		radeon_combios_asic_init(rdev->ddev);
-	}
+	atom_asic_init(rdev->mode_info.atom_context);
 	/* Initialize clocks */
 	r = radeon_clocks_init(rdev);
 	if (r) {
@@ -902,8 +898,10 @@ int rv770_init(struct radeon_device *rdev)
 			return -EINVAL;
 	}
 	/* Must be an ATOMBIOS */
-	if (!rdev->is_atom_bios)
+	if (!rdev->is_atom_bios) {
+		dev_err(rdev->dev, "Expecting atombios for R600 GPU\n");
 		return -EINVAL;
+	}
 	r = radeon_atombios_init(rdev);
 	if (r)
 		return r;
@@ -1006,11 +1004,7 @@ void rv770_fini(struct radeon_device *rdev)
 		radeon_agp_fini(rdev);
 #endif
 	radeon_object_fini(rdev);
-	if (rdev->is_atom_bios) {
-		radeon_atombios_fini(rdev);
-	} else {
-		radeon_combios_fini(rdev);
-	}
+	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
 	rdev->bios = NULL;
 	radeon_dummy_page_fini(rdev);
-- 
1.6.4.4

