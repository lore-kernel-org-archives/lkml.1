Return-Path: <linux-kernel-owner+w=401wt.eu-S1757919AbZJFP2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757919AbZJFP2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 11:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757829AbZJFP2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 11:28:44 -0400
Received: from nox.protox.org ([88.191.38.29]:44095 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757904AbZJFP2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 11:28:40 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 2/2] drm/radeon/kms: Fix AGP support for R600/RV770 family
Date: Tue,  6 Oct 2009 17:27:40 +0200
Message-Id: <1254842860-5492-2-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1254842860-5492-1-git-send-email-jglisse@redhat.com>
References: <1254842860-5492-1-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For AGP to work unmapped access must cover VRAM & AGP as
AGP is treated like VRAM by the GPU (ie physical address).
This patch properly setup the virtual memory system aperture
to cover AGP if AGP is enabled. It seems that there is memory
corruption after resume when using AGP (RV770 seems unaffected
thought).

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r600.c          |  117 +++++++++++++++++++++++++-------
 drivers/gpu/drm/radeon/r600d.h         |    1 +
 drivers/gpu/drm/radeon/radeon_device.c |    1 +
 drivers/gpu/drm/radeon/rv770.c         |   79 +++++++++++++++++-----
 4 files changed, 157 insertions(+), 41 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 2cef638..6b43a95 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -65,16 +65,11 @@ MODULE_FIRMWARE("radeon/RV710_me.bin");
 
 int r600_debugfs_mc_info_init(struct radeon_device *rdev);
 
-/* This files gather functions specifics to:
- * r600,rv610,rv630,rv620,rv635,rv670
- *
- * Some of these functions might be used by newer ASICs.
- */
+/* r600,rv610,rv630,rv620,rv635,rv670 */
 int r600_mc_wait_for_idle(struct radeon_device *rdev);
 void r600_gpu_init(struct radeon_device *rdev);
 void r600_fini(struct radeon_device *rdev);
 
-
 /*
  * R600 PCIE GART
  */
@@ -168,7 +163,7 @@ int r600_pcie_gart_enable(struct radeon_device *rdev)
 	WREG32(MC_VM_L1_TLB_MCB_RD_SEM_CNTL, tmp | ENABLE_SEMAPHORE_MODE);
 	WREG32(MC_VM_L1_TLB_MCB_WR_SEM_CNTL, tmp | ENABLE_SEMAPHORE_MODE);
 	WREG32(VM_CONTEXT0_PAGE_TABLE_START_ADDR, rdev->mc.gtt_start >> 12);
-	WREG32(VM_CONTEXT0_PAGE_TABLE_END_ADDR, (rdev->mc.gtt_end - 1) >> 12);
+	WREG32(VM_CONTEXT0_PAGE_TABLE_END_ADDR, rdev->mc.gtt_end >> 12);
 	WREG32(VM_CONTEXT0_PAGE_TABLE_BASE_ADDR, rdev->gart.table_addr >> 12);
 	WREG32(VM_CONTEXT0_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
 				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
@@ -225,6 +220,40 @@ void r600_pcie_gart_fini(struct radeon_device *rdev)
 	radeon_gart_fini(rdev);
 }
 
+void r600_agp_enable(struct radeon_device *rdev)
+{
+	u32 tmp;
+	int i;
+
+	/* Setup L2 cache */
+	WREG32(VM_L2_CNTL, ENABLE_L2_CACHE | ENABLE_L2_FRAGMENT_PROCESSING |
+				ENABLE_L2_PTE_CACHE_LRU_UPDATE_BY_WRITE |
+				EFFECTIVE_L2_QUEUE_SIZE(7));
+	WREG32(VM_L2_CNTL2, 0);
+	WREG32(VM_L2_CNTL3, BANK_SELECT_0(0) | BANK_SELECT_1(1));
+	/* Setup TLB control */
+	tmp = ENABLE_L1_TLB | ENABLE_L1_FRAGMENT_PROCESSING |
+		SYSTEM_ACCESS_MODE_NOT_IN_SYS |
+		EFFECTIVE_L1_TLB_SIZE(5) | EFFECTIVE_L1_QUEUE_SIZE(5) |
+		ENABLE_WAIT_L2_QUERY;
+	WREG32(MC_VM_L1_TLB_MCB_RD_SYS_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCB_WR_SYS_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCB_RD_HDP_CNTL, tmp | ENABLE_L1_STRICT_ORDERING);
+	WREG32(MC_VM_L1_TLB_MCB_WR_HDP_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCD_RD_A_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCD_WR_A_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCD_RD_B_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCD_WR_B_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCB_RD_GFX_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCB_WR_GFX_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCB_RD_PDMA_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCB_WR_PDMA_CNTL, tmp);
+	WREG32(MC_VM_L1_TLB_MCB_RD_SEM_CNTL, tmp | ENABLE_SEMAPHORE_MODE);
+	WREG32(MC_VM_L1_TLB_MCB_WR_SEM_CNTL, tmp | ENABLE_SEMAPHORE_MODE);
+	for (i = 0; i < 7; i++)
+		WREG32(VM_CONTEXT0_CNTL + (i * 4), 0);
+}
+
 int r600_mc_wait_for_idle(struct radeon_device *rdev)
 {
 	unsigned i;
@@ -263,18 +292,34 @@ static void r600_mc_program(struct radeon_device *rdev)
 	/* Lockout access through VGA aperture (doesn't exist before R600) */
 	WREG32(VGA_HDP_CONTROL, VGA_MEMORY_DISABLE);
 	/* Update configuration */
-	WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR, rdev->mc.vram_start >> 12);
-	WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR, (rdev->mc.vram_end - 1) >> 12);
+	if (rdev->flags & RADEON_IS_AGP) {
+		if (rdev->mc.vram_start < rdev->mc.gtt_start) {
+			/* VRAM before AGP */
+			WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR,
+				rdev->mc.vram_start >> 12);
+			WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR,
+				rdev->mc.gtt_end >> 12);
+		} else {
+			/* VRAM after AGP */
+			WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR,
+				rdev->mc.gtt_start >> 12);
+			WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR,
+				rdev->mc.vram_end >> 12);
+		}
+	} else {
+		WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR, rdev->mc.vram_start >> 12);
+		WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR, rdev->mc.vram_end >> 12);
+	}
 	WREG32(MC_VM_SYSTEM_APERTURE_DEFAULT_ADDR, 0);
-	tmp = (((rdev->mc.vram_end - 1) >> 24) & 0xFFFF) << 16;
+	tmp = ((rdev->mc.vram_end >> 24) & 0xFFFF) << 16;
 	tmp |= ((rdev->mc.vram_start >> 24) & 0xFFFF);
 	WREG32(MC_VM_FB_LOCATION, tmp);
 	WREG32(HDP_NONSURFACE_BASE, (rdev->mc.vram_start >> 8));
 	WREG32(HDP_NONSURFACE_INFO, (2 << 7));
-	WREG32(HDP_NONSURFACE_SIZE, (rdev->mc.mc_vram_size - 1) | 0x3FF);
+	WREG32(HDP_NONSURFACE_SIZE, rdev->mc.mc_vram_size | 0x3FF);
 	if (rdev->flags & RADEON_IS_AGP) {
-		WREG32(MC_VM_AGP_TOP, (rdev->mc.gtt_end - 1) >> 16);
-		WREG32(MC_VM_AGP_BOT, rdev->mc.gtt_start >> 16);
+		WREG32(MC_VM_AGP_TOP, rdev->mc.gtt_end >> 22);
+		WREG32(MC_VM_AGP_BOT, rdev->mc.gtt_start >> 22);
 		WREG32(MC_VM_AGP_BASE, rdev->mc.agp_base >> 22);
 	} else {
 		WREG32(MC_VM_AGP_BASE, 0);
@@ -390,9 +435,9 @@ int r600_mc_init(struct radeon_device *rdev)
 		}
 	}
 	rdev->mc.vram_start = rdev->mc.vram_location;
-	rdev->mc.vram_end = rdev->mc.vram_location + rdev->mc.mc_vram_size;
+	rdev->mc.vram_end = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
 	rdev->mc.gtt_start = rdev->mc.gtt_location;
-	rdev->mc.gtt_end = rdev->mc.gtt_location + rdev->mc.gtt_size;
+	rdev->mc.gtt_end = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
 	/* FIXME: we should enforce default clock in case GPU is not in
 	 * default setup
 	 */
@@ -428,9 +473,13 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 	u32 srbm_reset = 0;
 	u32 tmp;
 
-	dev_info(rdev->dev, "GPU softreset (R_008010_GRBM_STATUS=0x%08X "
-		"R_008014_GRBM_STATUS2=0x%08X)\n", RREG32(R_008010_GRBM_STATUS),
+	dev_info(rdev->dev, "GPU softreset \n");
+	dev_info(rdev->dev, "  R_008010_GRBM_STATUS=0x%08X\n",
+		RREG32(R_008010_GRBM_STATUS));
+	dev_info(rdev->dev, "  R_008014_GRBM_STATUS2=0x%08X\n",
 		RREG32(R_008014_GRBM_STATUS2));
+	dev_info(rdev->dev, "  R_000E50_SRBM_STATUS=0x%08X\n",
+		RREG32(R_000E50_SRBM_STATUS));
 	rv515_mc_stop(rdev, &save);
 	if (r600_mc_wait_for_idle(rdev)) {
 		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
@@ -453,7 +502,7 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 			S_008020_SOFT_RESET_TA(1) |
 			S_008020_SOFT_RESET_VC(1) |
 			S_008020_SOFT_RESET_VGT(1);
-		dev_info(rdev->dev, "R_008020_GRBM_SOFT_RESET=0x%08X\n", tmp);
+		dev_info(rdev->dev, "  R_008020_GRBM_SOFT_RESET=0x%08X\n", tmp);
 		WREG32(R_008020_GRBM_SOFT_RESET, tmp);
 		(void)RREG32(R_008020_GRBM_SOFT_RESET);
 		udelay(50);
@@ -491,7 +540,14 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 		srbm_reset |= S_000E60_SOFT_RESET_RLC(1);
 	if (G_000E50_SEM_BUSY(RREG32(R_000E50_SRBM_STATUS)))
 		srbm_reset |= S_000E60_SOFT_RESET_SEM(1);
-	dev_info(rdev->dev, "R_000E60_SRBM_SOFT_RESET=0x%08X\n", srbm_reset);
+	if (G_000E50_BIF_BUSY(RREG32(R_000E50_SRBM_STATUS)))
+		srbm_reset |= S_000E60_SOFT_RESET_BIF(1);
+	dev_info(rdev->dev, "  R_000E60_SRBM_SOFT_RESET=0x%08X\n", srbm_reset);
+	WREG32(R_000E60_SRBM_SOFT_RESET, srbm_reset);
+	(void)RREG32(R_000E60_SRBM_SOFT_RESET);
+	udelay(50);
+	WREG32(R_000E60_SRBM_SOFT_RESET, 0);
+	(void)RREG32(R_000E60_SRBM_SOFT_RESET);
 	WREG32(R_000E60_SRBM_SOFT_RESET, srbm_reset);
 	(void)RREG32(R_000E60_SRBM_SOFT_RESET);
 	udelay(50);
@@ -499,6 +555,12 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 	(void)RREG32(R_000E60_SRBM_SOFT_RESET);
 	/* Wait a little for things to settle down */
 	udelay(50);
+	dev_info(rdev->dev, "  R_008010_GRBM_STATUS=0x%08X\n",
+		RREG32(R_008010_GRBM_STATUS));
+	dev_info(rdev->dev, "  R_008014_GRBM_STATUS2=0x%08X\n",
+		RREG32(R_008014_GRBM_STATUS2));
+	dev_info(rdev->dev, "  R_000E50_SRBM_STATUS=0x%08X\n",
+		RREG32(R_000E50_SRBM_STATUS));
 	/* After reset we need to reinit the asic as GPU often endup in an
 	 * incoherent state.
 	 */
@@ -1442,9 +1504,13 @@ int r600_startup(struct radeon_device *rdev)
 	int r;
 
 	r600_mc_program(rdev);
-	r = r600_pcie_gart_enable(rdev);
-	if (r)
-		return r;
+	if (rdev->flags & RADEON_IS_AGP) {
+		r600_agp_enable(rdev);
+	} else {
+		r = r600_pcie_gart_enable(rdev);
+		if (r)
+			return r;
+	}
 	r600_gpu_init(rdev);
 
 	r = radeon_object_pin(rdev->r600_blit.shader_obj, RADEON_GEM_DOMAIN_VRAM,
@@ -1472,9 +1538,10 @@ int r600_resume(struct radeon_device *rdev)
 {
 	int r;
 
-	if (r600_gpu_reset(rdev)) {
-		/* FIXME: what do we want to do here ? */
-	}
+	/* Do not reset GPU before posting, on r600 hw unlike on r500 hw,
+	 * posting will perform necessary task to bring back GPU into good
+	 * shape.
+	 */
 	/* post card */
 	atom_asic_init(rdev->mode_info.atom_context);
 	/* Initialize clocks */
diff --git a/drivers/gpu/drm/radeon/r600d.h b/drivers/gpu/drm/radeon/r600d.h
index 723295f..5084595 100644
--- a/drivers/gpu/drm/radeon/r600d.h
+++ b/drivers/gpu/drm/radeon/r600d.h
@@ -642,6 +642,7 @@
 #define		G_000E50_MCDW_BUSY(x)			(((x) >> 13) & 1)
 #define		G_000E50_SEM_BUSY(x)			(((x) >> 14) & 1)
 #define		G_000E50_RLC_BUSY(x)			(((x) >> 15) & 1)
+#define		G_000E50_BIF_BUSY(x)			(((x) >> 29) & 1)
 #define	R_000E60_SRBM_SOFT_RESET			0x0E60
 #define		S_000E60_SOFT_RESET_BIF(x)		(((x) & 1) << 1)
 #define		S_000E60_SOFT_RESET_CG(x)		(((x) & 1) << 2)
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index ec02006..8f4deb3 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -571,6 +571,7 @@ int radeon_device_init(struct radeon_device *rdev,
 		/* Acceleration not working on AGP card try again
 		 * with fallback to PCI or PCIE GART
 		 */
+		radeon_gpu_reset(rdev);
 		radeon_fini(rdev);
 		rdev->flags &= ~RADEON_IS_AGP;
 		if (rdev->family >= CHIP_RV515 ||
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 5c597df..595ac63 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -75,7 +75,7 @@ int rv770_pcie_gart_enable(struct radeon_device *rdev)
 	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB3_CNTL, tmp);
 	WREG32(VM_CONTEXT0_PAGE_TABLE_START_ADDR, rdev->mc.gtt_start >> 12);
-	WREG32(VM_CONTEXT0_PAGE_TABLE_END_ADDR, (rdev->mc.gtt_end - 1) >> 12);
+	WREG32(VM_CONTEXT0_PAGE_TABLE_END_ADDR, rdev->mc.gtt_end >> 12);
 	WREG32(VM_CONTEXT0_PAGE_TABLE_BASE_ADDR, rdev->gart.table_addr >> 12);
 	WREG32(VM_CONTEXT0_CNTL, ENABLE_CONTEXT | PAGE_TABLE_DEPTH(0) |
 				RANGE_PROTECTION_FAULT_ENABLE_DEFAULT);
@@ -126,9 +126,33 @@ void rv770_pcie_gart_fini(struct radeon_device *rdev)
 }
 
 
-/*
- * MC
- */
+void rv770_agp_enable(struct radeon_device *rdev)
+{
+	u32 tmp;
+	int i;
+
+	/* Setup L2 cache */
+	WREG32(VM_L2_CNTL, ENABLE_L2_CACHE | ENABLE_L2_FRAGMENT_PROCESSING |
+				ENABLE_L2_PTE_CACHE_LRU_UPDATE_BY_WRITE |
+				EFFECTIVE_L2_QUEUE_SIZE(7));
+	WREG32(VM_L2_CNTL2, 0);
+	WREG32(VM_L2_CNTL3, BANK_SELECT(0) | CACHE_UPDATE_MODE(2));
+	/* Setup TLB control */
+	tmp = ENABLE_L1_TLB | ENABLE_L1_FRAGMENT_PROCESSING |
+		SYSTEM_ACCESS_MODE_NOT_IN_SYS |
+		SYSTEM_APERTURE_UNMAPPED_ACCESS_PASS_THRU |
+		EFFECTIVE_L1_TLB_SIZE(5) | EFFECTIVE_L1_QUEUE_SIZE(5);
+	WREG32(MC_VM_MD_L1_TLB0_CNTL, tmp);
+	WREG32(MC_VM_MD_L1_TLB1_CNTL, tmp);
+	WREG32(MC_VM_MD_L1_TLB2_CNTL, tmp);
+	WREG32(MC_VM_MB_L1_TLB0_CNTL, tmp);
+	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
+	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
+	WREG32(MC_VM_MB_L1_TLB3_CNTL, tmp);
+	for (i = 0; i < 7; i++)
+		WREG32(VM_CONTEXT0_CNTL + (i * 4), 0);
+}
+
 static void rv770_mc_program(struct radeon_device *rdev)
 {
 	struct rv515_mc_save save;
@@ -152,17 +176,35 @@ static void rv770_mc_program(struct radeon_device *rdev)
 	/* Lockout access through VGA aperture*/
 	WREG32(VGA_HDP_CONTROL, VGA_MEMORY_DISABLE);
 	/* Update configuration */
-	WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR, rdev->mc.vram_start >> 12);
-	WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR, (rdev->mc.vram_end - 1) >> 12);
+	if (rdev->flags & RADEON_IS_AGP) {
+		if (rdev->mc.vram_start < rdev->mc.gtt_start) {
+			/* VRAM before AGP */
+			WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR,
+				rdev->mc.vram_start >> 12);
+			WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR,
+				rdev->mc.gtt_end >> 12);
+		} else {
+			/* VRAM after AGP */
+			WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR,
+				rdev->mc.gtt_start >> 12);
+			WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR,
+				rdev->mc.vram_end >> 12);
+		}
+	} else {
+		WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR,
+			rdev->mc.vram_start >> 12);
+		WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR,
+			rdev->mc.vram_end >> 12);
+	}
 	WREG32(MC_VM_SYSTEM_APERTURE_DEFAULT_ADDR, 0);
-	tmp = (((rdev->mc.vram_end - 1) >> 24) & 0xFFFF) << 16;
+	tmp = ((rdev->mc.vram_end >> 24) & 0xFFFF) << 16;
 	tmp |= ((rdev->mc.vram_start >> 24) & 0xFFFF);
 	WREG32(MC_VM_FB_LOCATION, tmp);
 	WREG32(HDP_NONSURFACE_BASE, (rdev->mc.vram_start >> 8));
 	WREG32(HDP_NONSURFACE_INFO, (2 << 7));
 	WREG32(HDP_NONSURFACE_SIZE, (rdev->mc.mc_vram_size - 1) | 0x3FF);
 	if (rdev->flags & RADEON_IS_AGP) {
-		WREG32(MC_VM_AGP_TOP, (rdev->mc.gtt_end - 1) >> 16);
+		WREG32(MC_VM_AGP_TOP, rdev->mc.gtt_end >> 16);
 		WREG32(MC_VM_AGP_BOT, rdev->mc.gtt_start >> 16);
 		WREG32(MC_VM_AGP_BASE, rdev->mc.agp_base >> 22);
 	} else {
@@ -785,9 +827,9 @@ int rv770_mc_init(struct radeon_device *rdev)
 		rdev->mc.gtt_size = radeon_gart_size * 1024 * 1024;
 	}
 	rdev->mc.vram_start = rdev->mc.vram_location;
-	rdev->mc.vram_end = rdev->mc.vram_location + rdev->mc.mc_vram_size;
+	rdev->mc.vram_end = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
 	rdev->mc.gtt_start = rdev->mc.gtt_location;
-	rdev->mc.gtt_end = rdev->mc.gtt_location + rdev->mc.gtt_size;
+	rdev->mc.gtt_end = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
 	/* FIXME: we should enforce default clock in case GPU is not in
 	 * default setup
 	 */
@@ -807,9 +849,13 @@ static int rv770_startup(struct radeon_device *rdev)
 	int r;
 
 	rv770_mc_program(rdev);
-	r = rv770_pcie_gart_enable(rdev);
-	if (r)
-		return r;
+	if (rdev->flags & RADEON_IS_AGP) {
+		rv770_agp_enable(rdev);
+	} else {
+		r = rv770_pcie_gart_enable(rdev);
+		if (r)
+			return r;
+	}
 	rv770_gpu_init(rdev);
 
 	r = radeon_object_pin(rdev->r600_blit.shader_obj, RADEON_GEM_DOMAIN_VRAM,
@@ -837,9 +883,10 @@ int rv770_resume(struct radeon_device *rdev)
 {
 	int r;
 
-	if (rv770_gpu_reset(rdev)) {
-		/* FIXME: what do we want to do here ? */
-	}
+	/* Do not reset GPU before posting, on rv770 hw unlike on r500 hw,
+	 * posting will perform necessary task to bring back GPU into good
+	 * shape.
+	 */
 	/* post card */
 	atom_asic_init(rdev->mode_info.atom_context);
 	/* Initialize clocks */
-- 
1.6.4.4

