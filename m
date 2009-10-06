Return-Path: <linux-kernel-owner+w=401wt.eu-S1757916AbZJFRFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916AbZJFRFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 13:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757635AbZJFRFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 13:05:30 -0400
Received: from nox.protox.org ([88.191.38.29]:39881 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757638AbZJFRF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 13:05:29 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 1/2] drm/radeon/kms: Fallback to non AGP when acceleration fails to initialize (v2)
Date: Tue,  6 Oct 2009 19:04:29 +0200
Message-Id: <1254848670-4880-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When GPU acceleration is not working with AGP try to fallback to non
AGP GART (either PCI or PCIE GART). This should make KMS failure on
AGP less painfull. We still need to find out what is wrong when AGP
fails but at least user have a lot of more chances to get a working
configuration with acceleration. This patch also cleanup R600/RV770
fallback path so they use same code as others asics. Version 2
factorize agp disabling logic to avoid code duplication and bugs.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r600.c          |   18 +----------
 drivers/gpu/drm/radeon/radeon_device.c |   51 ++++++++++++++++++++------------
 drivers/gpu/drm/radeon/rv770.c         |   18 +----------
 3 files changed, 34 insertions(+), 53 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 9f7eb08..2cef638 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -1560,15 +1560,8 @@ int r600_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	r = r600_mc_init(rdev);
-	if (r) {
-		if (rdev->flags & RADEON_IS_AGP) {
-			/* Retry with disabling AGP */
-			r600_fini(rdev);
-			rdev->flags &= ~RADEON_IS_AGP;
-			return r600_init(rdev);
-		}
+	if (r)
 		return r;
-	}
 	/* Memory manager */
 	r = radeon_object_init(rdev);
 	if (r)
@@ -1597,15 +1590,8 @@ int r600_init(struct radeon_device *rdev)
 
 	r = r600_startup(rdev);
 	if (r) {
-		if (rdev->flags & RADEON_IS_AGP) {
-			/* Retry with disabling AGP */
-			r600_fini(rdev);
-			rdev->flags &= ~RADEON_IS_AGP;
-			return r600_init(rdev);
-		}
 		r600_suspend(rdev);
 		r600_wb_fini(rdev);
-		radeon_ib_pool_fini(rdev);
 		radeon_ring_fini(rdev);
 		r600_pcie_gart_fini(rdev);
 		rdev->accel_working = false;
@@ -1637,10 +1623,8 @@ void r600_fini(struct radeon_device *rdev)
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
 	radeon_clocks_fini(rdev);
-#if __OS_HAS_AGP
 	if (rdev->flags & RADEON_IS_AGP)
 		radeon_agp_fini(rdev);
-#endif
 	radeon_object_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 2d07ccc..a6b80eb 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -476,6 +476,27 @@ void radeon_combios_fini(struct radeon_device *rdev)
 {
 }
 
+void radeon_agp_disable(struct radeon_device *rdev)
+{
+	rdev->flags &= ~RADEON_IS_AGP;
+	if (rdev->family >= CHIP_R600) {
+		DRM_INFO("Forcing AGP to PCIE mode\n");
+		rdev->flags |= RADEON_IS_PCIE;
+	} else if (rdev->family >= CHIP_RV515 ||
+			rdev->family == CHIP_RV380 ||
+			rdev->family == CHIP_RV410 ||
+			rdev->family == CHIP_R423) {
+		DRM_INFO("Forcing AGP to PCIE mode\n");
+		rdev->flags |= RADEON_IS_PCIE;
+		rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
+		rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
+	} else {
+		DRM_INFO("Forcing AGP to PCI mode\n");
+		rdev->flags |= RADEON_IS_PCI;
+		rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
+		rdev->asic->gart_set_page = &r100_pci_gart_set_page;
+	}
+}
 
 /*
  * Radeon device.
@@ -515,24 +536,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	}
 
 	if (radeon_agpmode == -1) {
-		rdev->flags &= ~RADEON_IS_AGP;
-		if (rdev->family >= CHIP_R600) {
-			DRM_INFO("Forcing AGP to PCIE mode\n");
-			rdev->flags |= RADEON_IS_PCIE;
-		} else if (rdev->family >= CHIP_RV515 ||
-			   rdev->family == CHIP_RV380 ||
-			   rdev->family == CHIP_RV410 ||
-			   rdev->family == CHIP_R423) {
-			DRM_INFO("Forcing AGP to PCIE mode\n");
-			rdev->flags |= RADEON_IS_PCIE;
-			rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
-			rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
-		} else {
-			DRM_INFO("Forcing AGP to PCI mode\n");
-			rdev->flags |= RADEON_IS_PCI;
-			rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
-			rdev->asic->gart_set_page = &r100_pci_gart_set_page;
-		}
+		radeon_agp_disable(rdev);
 	}
 
 	/* set DMA mask + need_dma32 flags.
@@ -565,8 +569,17 @@ int radeon_device_init(struct radeon_device *rdev,
 	DRM_INFO("register mmio size: %u\n", (unsigned)rdev->rmmio_size);
 
 	r = radeon_init(rdev);
-	if (r) {
+	if (r)
 		return r;
+	if (rdev->flags & RADEON_IS_AGP && !rdev->accel_working) {
+		/* Acceleration not working on AGP card try again
+		 * with fallback to PCI or PCIE GART
+		 */
+		radeon_fini(rdev);
+		radeon_agp_disable(rdev);
+		r = radeon_init(rdev);
+		if (r)
+			return r;
 	}
 	if (radeon_testing) {
 		radeon_test_moves(rdev);
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 295cf14..5c597df 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -923,15 +923,8 @@ int rv770_init(struct radeon_device *rdev)
 	if (r)
 		return r;
 	r = rv770_mc_init(rdev);
-	if (r) {
-		if (rdev->flags & RADEON_IS_AGP) {
-			/* Retry with disabling AGP */
-			rv770_fini(rdev);
-			rdev->flags &= ~RADEON_IS_AGP;
-			return rv770_init(rdev);
-		}
+	if (r)
 		return r;
-	}
 	/* Memory manager */
 	r = radeon_object_init(rdev);
 	if (r)
@@ -960,15 +953,8 @@ int rv770_init(struct radeon_device *rdev)
 
 	r = rv770_startup(rdev);
 	if (r) {
-		if (rdev->flags & RADEON_IS_AGP) {
-			/* Retry with disabling AGP */
-			rv770_fini(rdev);
-			rdev->flags &= ~RADEON_IS_AGP;
-			return rv770_init(rdev);
-		}
 		rv770_suspend(rdev);
 		r600_wb_fini(rdev);
-		radeon_ib_pool_fini(rdev);
 		radeon_ring_fini(rdev);
 		rv770_pcie_gart_fini(rdev);
 		rdev->accel_working = false;
@@ -999,10 +985,8 @@ void rv770_fini(struct radeon_device *rdev)
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
 	radeon_clocks_fini(rdev);
-#if __OS_HAS_AGP
 	if (rdev->flags & RADEON_IS_AGP)
 		radeon_agp_fini(rdev);
-#endif
 	radeon_object_fini(rdev);
 	radeon_atombios_fini(rdev);
 	kfree(rdev->bios);
-- 
1.6.4.4

