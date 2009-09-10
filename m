Return-Path: <linux-kernel-owner+w=401wt.eu-S1755401AbZIJLrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401AbZIJLrF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 07:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbZIJLrE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 07:47:04 -0400
Received: from nox.protox.org ([88.191.38.29]:46663 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbZIJLrE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 07:47:04 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: R3XX/R4XX AGP asic use PCI GART not PCIE GART
Date: Thu, 10 Sep 2009 13:47:09 +0200
Message-Id: <1252583229-13754-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

R3XX/R4XX AGP asic use the old PCI GART block, not the new PCIE GART.
Make sure we pick the right GART when disabling AGP.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r300.c          |    6 ++++++
 drivers/gpu/drm/radeon/r420.c          |    9 +++++++--
 drivers/gpu/drm/radeon/radeon.h        |    4 ++++
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index a5f82f7..9c17b78 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -181,6 +181,12 @@ int r300_gart_enable(struct radeon_device *rdev)
 		rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
 		return rv370_pcie_gart_enable(rdev);
 	}
+	if (rdev->flags & RADEON_IS_PCI) {
+		rdev->asic->gart_disable = &r100_pci_gart_disable;
+		rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
+		rdev->asic->gart_set_page = &r100_pci_gart_set_page;
+		return r100_pci_gart_enable(rdev);
+	}
 	return r100_pci_gart_enable(rdev);
 }
 
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 96303f0..551d699 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -101,8 +101,13 @@ int r420_mc_init(struct radeon_device *rdev)
 
 void r420_mc_fini(struct radeon_device *rdev)
 {
-	rv370_pcie_gart_disable(rdev);
-	radeon_gart_table_vram_free(rdev);
+	if (rdev->flags & RADEON_IS_PCIE) {
+		rv370_pcie_gart_disable(rdev);
+		radeon_gart_table_vram_free(rdev);
+	} else {
+		r100_pci_gart_disable(rdev);
+		radeon_gart_table_ram_free(rdev);
+	}
 	radeon_gart_fini(rdev);
 }
 
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index fa84c77..d6ff4e0 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -935,6 +935,10 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 
 /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
 void r100_cp_disable(struct radeon_device *rdev);
+void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
+int r100_pci_gart_enable(struct radeon_device *rdev);
+void r100_pci_gart_disable(struct radeon_device *rdev);
+int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 
 /* r420,r423,rv410 */
 u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg);
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 05e1af0..bf69394 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -503,7 +503,7 @@ int radeon_device_init(struct radeon_device *rdev,
 
 	if (radeon_agpmode == -1) {
 		rdev->flags &= ~RADEON_IS_AGP;
-		if (rdev->family > CHIP_RV515 ||
+		if (rdev->family >= CHIP_RV515 ||
 		    rdev->family == CHIP_RV380 ||
 		    rdev->family == CHIP_RV410 ||
 		    rdev->family == CHIP_R423) {
-- 
1.6.4.2

