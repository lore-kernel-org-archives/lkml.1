Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZJAQES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZJAQES (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754881AbZJAQEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:04:14 -0400
Received: from nox.protox.org ([88.191.38.29]:37895 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754811AbZJAQEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:04:13 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 2/5] drm/radeon/kms: Fix R600 write back buffer
Date: Thu,  1 Oct 2009 18:02:12 +0200
Message-Id: <1254412935-9976-2-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1254412935-9976-1-git-send-email-jglisse@redhat.com>
References: <1254412935-9976-1-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This split write back buffer handling into 3 functions,
wb_fini for cleanup, wb_enable/wb_disable for enabling/disabling
write back used for suspend/resume. This should fix
potential issue of letting the write back active before
suspending. We need to allocate memory in wb_enable because
we can only allocate once GART is running.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r600.c   |   67 +++++++++++++++++++--------------------
 drivers/gpu/drm/radeon/radeon.h |    3 +-
 drivers/gpu/drm/radeon/rv770.c  |    8 ++--
 3 files changed, 39 insertions(+), 39 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 17fff7b..11fa801 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1350,32 +1350,47 @@ int r600_ring_test(struct radeon_device *rdev)
 	return r;
 }
 
-/*
- * Writeback
- */
-int r600_wb_init(struct radeon_device *rdev)
+void r600_wb_disable(struct radeon_device *rdev)
+{
+	WREG32(SCRATCH_UMSK, 0);
+	if (rdev->wb.wb_obj) {
+		radeon_object_kunmap(rdev->wb.wb_obj);
+		radeon_object_unpin(rdev->wb.wb_obj);
+	}
+}
+
+void r600_wb_fini(struct radeon_device *rdev)
+{
+	r600_wb_disable(rdev);
+	if (rdev->wb.wb_obj) {
+		radeon_object_unref(&rdev->wb.wb_obj);
+		rdev->wb.wb = NULL;
+		rdev->wb.wb_obj = NULL;
+	}
+}
+
+int r600_wb_enable(struct radeon_device *rdev)
 {
 	int r;
 
 	if (rdev->wb.wb_obj == NULL) {
-		r = radeon_object_create(rdev, NULL, 4096,
-					 true,
-					 RADEON_GEM_DOMAIN_GTT,
-					 false, &rdev->wb.wb_obj);
+		r = radeon_object_create(rdev, NULL, 4096, true,
+				RADEON_GEM_DOMAIN_GTT, false, &rdev->wb.wb_obj);
 		if (r) {
-			DRM_ERROR("radeon: failed to create WB buffer (%d).\n", r);
+			dev_warn(rdev->dev, "failed to create WB buffer (%d).\n", r);
 			return r;
 		}
-		r = radeon_object_pin(rdev->wb.wb_obj,
-				      RADEON_GEM_DOMAIN_GTT,
-				      &rdev->wb.gpu_addr);
+		r = radeon_object_pin(rdev->wb.wb_obj, RADEON_GEM_DOMAIN_GTT,
+				&rdev->wb.gpu_addr);
 		if (r) {
-			DRM_ERROR("radeon: failed to pin WB buffer (%d).\n", r);
+			dev_warn(rdev->dev, "failed to pin WB buffer (%d).\n", r);
+			r600_wb_fini(rdev);
 			return r;
 		}
 		r = radeon_object_kmap(rdev->wb.wb_obj, (void **)&rdev->wb.wb);
 		if (r) {
-			DRM_ERROR("radeon: failed to map WB buffer (%d).\n", r);
+			dev_warn(rdev->dev, "failed to map WB buffer (%d).\n", r);
+			r600_wb_fini(rdev);
 			return r;
 		}
 	}
@@ -1386,21 +1401,6 @@ int r600_wb_init(struct radeon_device *rdev)
 	return 0;
 }
 
-void r600_wb_fini(struct radeon_device *rdev)
-{
-	if (rdev->wb.wb_obj) {
-		radeon_object_kunmap(rdev->wb.wb_obj);
-		radeon_object_unpin(rdev->wb.wb_obj);
-		radeon_object_unref(&rdev->wb.wb_obj);
-		rdev->wb.wb = NULL;
-		rdev->wb.wb_obj = NULL;
-	}
-}
-
-
-/*
- * CS
- */
 void r600_fence_ring_emit(struct radeon_device *rdev,
 			  struct radeon_fence *fence)
 {
@@ -1500,9 +1500,8 @@ int r600_startup(struct radeon_device *rdev)
 	r = r600_cp_resume(rdev);
 	if (r)
 		return r;
-	r = r600_wb_init(rdev);
-	if (r)
-		return r;
+	/* write back buffer are not vital so don't worry about failure */
+	r600_wb_enable(rdev);
 	return 0;
 }
 
@@ -1539,13 +1538,12 @@ int r600_resume(struct radeon_device *rdev)
 	return r;
 }
 
-
 int r600_suspend(struct radeon_device *rdev)
 {
 	/* FIXME: we should wait for ring to be empty */
 	r600_cp_stop(rdev);
 	rdev->cp.ready = false;
-
+	r600_wb_disable(rdev);
 	r600_pcie_gart_disable(rdev);
 	/* unpin shaders bo */
 	radeon_object_unpin(rdev->r600_blit.shader_obj);
@@ -1668,6 +1666,7 @@ void r600_fini(struct radeon_device *rdev)
 
 	r600_blit_fini(rdev);
 	radeon_ring_fini(rdev);
+	r600_wb_fini(rdev);
 	r600_pcie_gart_fini(rdev);
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 89fffe7..3598adc 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1084,8 +1084,9 @@ extern int r600_pcie_gart_init(struct radeon_device *rdev);
 extern void r600_pcie_gart_tlb_flush(struct radeon_device *rdev);
 extern int r600_ib_test(struct radeon_device *rdev);
 extern int r600_ring_test(struct radeon_device *rdev);
-extern int r600_wb_init(struct radeon_device *rdev);
 extern void r600_wb_fini(struct radeon_device *rdev);
+extern int r600_wb_enable(struct radeon_device *rdev);
+extern void r600_wb_disable(struct radeon_device *rdev);
 extern void r600_scratch_init(struct radeon_device *rdev);
 extern int r600_blit_init(struct radeon_device *rdev);
 extern void r600_blit_fini(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 867d04b..af20a8d 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -884,9 +884,8 @@ static int rv770_startup(struct radeon_device *rdev)
 	r = r600_cp_resume(rdev);
 	if (r)
 		return r;
-	r = r600_wb_init(rdev);
-	if (r)
-		return r;
+	/* write back buffer are not vital so don't worry about failure */
+	r600_wb_enable(rdev);
 	return 0;
 }
 
@@ -929,8 +928,8 @@ int rv770_suspend(struct radeon_device *rdev)
 	/* FIXME: we should wait for ring to be empty */
 	r700_cp_stop(rdev);
 	rdev->cp.ready = false;
+	r600_wb_disable(rdev);
 	rv770_pcie_gart_disable(rdev);
-
 	/* unpin shaders bo */
         radeon_object_unpin(rdev->r600_blit.shader_obj);
 	return 0;
@@ -1048,6 +1047,7 @@ void rv770_fini(struct radeon_device *rdev)
 
 	r600_blit_fini(rdev);
 	radeon_ring_fini(rdev);
+	r600_wb_fini(rdev);
 	rv770_pcie_gart_fini(rdev);
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
-- 
1.6.4.4

