Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbZJAIMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbZJAIMp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZJAIMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:12:44 -0400
Received: from nox.protox.org ([88.191.38.29]:60481 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755905AbZJAIMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:12:35 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert R100 to new init path (V2)
Date: Thu,  1 Oct 2009 10:12:06 +0200
Message-Id: <1254384726-5893-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New init path allow to simply asic initialization and make easier
to trace what happen on each different asic. We are removing most
callback. More cleanup should happen latter to remove even more
callback. Also cleanup register specific to R100,RV200,RV250.
Version 2 correct the placement on IGP of the VRAM inside GPU address
space to match the stollen RAM placement of IGP.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c        |  413 +++++++++++++++++++++-------------
 drivers/gpu/drm/radeon/r100d.h       |  107 +++++++++
 drivers/gpu/drm/radeon/r200.c        |    3 +-
 drivers/gpu/drm/radeon/radeon.h      |    3 +
 drivers/gpu/drm/radeon/radeon_asic.h |   50 ++---
 drivers/gpu/drm/radeon/rs100d.h      |   40 ++++
 drivers/gpu/drm/radeon/rv200d.h      |   36 +++
 drivers/gpu/drm/radeon/rv250d.h      |  123 ++++++++++
 8 files changed, 586 insertions(+), 189 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/rs100d.h
 create mode 100644 drivers/gpu/drm/radeon/rv200d.h
 create mode 100644 drivers/gpu/drm/radeon/rv250d.h

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index dc45ec1..0a47561 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -32,6 +32,9 @@
 #include "radeon_reg.h"
 #include "radeon.h"
 #include "r100d.h"
+#include "rs100d.h"
+#include "rv200d.h"
+#include "rv250d.h"
 
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
@@ -60,18 +63,7 @@ MODULE_FIRMWARE(FIRMWARE_R520);
 
 /* This files gather functions specifics to:
  * r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280
- *
- * Some of these functions might be used by newer ASICs.
  */
-int r200_init(struct radeon_device *rdev);
-void r100_hdp_reset(struct radeon_device *rdev);
-void r100_gpu_init(struct radeon_device *rdev);
-int r100_gui_wait_for_idle(struct radeon_device *rdev);
-int r100_mc_wait_for_idle(struct radeon_device *rdev);
-void r100_gpu_wait_for_vsync(struct radeon_device *rdev);
-void r100_gpu_wait_for_vsync2(struct radeon_device *rdev);
-int r100_debugfs_mc_info_init(struct radeon_device *rdev);
-
 
 /*
  * PCI GART
@@ -152,136 +144,6 @@ void r100_pci_gart_fini(struct radeon_device *rdev)
 	radeon_gart_fini(rdev);
 }
 
-
-/*
- * MC
- */
-void r100_mc_disable_clients(struct radeon_device *rdev)
-{
-	uint32_t ov0_scale_cntl, crtc_ext_cntl, crtc_gen_cntl, crtc2_gen_cntl;
-
-	/* FIXME: is this function correct for rs100,rs200,rs300 ? */
-	if (r100_gui_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait GUI idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-
-	/* stop display and memory access */
-	ov0_scale_cntl = RREG32(RADEON_OV0_SCALE_CNTL);
-	WREG32(RADEON_OV0_SCALE_CNTL, ov0_scale_cntl & ~RADEON_SCALER_ENABLE);
-	crtc_ext_cntl = RREG32(RADEON_CRTC_EXT_CNTL);
-	WREG32(RADEON_CRTC_EXT_CNTL, crtc_ext_cntl | RADEON_CRTC_DISPLAY_DIS);
-	crtc_gen_cntl = RREG32(RADEON_CRTC_GEN_CNTL);
-
-	r100_gpu_wait_for_vsync(rdev);
-
-	WREG32(RADEON_CRTC_GEN_CNTL,
-	       (crtc_gen_cntl & ~(RADEON_CRTC_CUR_EN | RADEON_CRTC_ICON_EN)) |
-	       RADEON_CRTC_DISP_REQ_EN_B | RADEON_CRTC_EXT_DISP_EN);
-
-	if (!(rdev->flags & RADEON_SINGLE_CRTC)) {
-		crtc2_gen_cntl = RREG32(RADEON_CRTC2_GEN_CNTL);
-
-		r100_gpu_wait_for_vsync2(rdev);
-		WREG32(RADEON_CRTC2_GEN_CNTL,
-		       (crtc2_gen_cntl &
-		        ~(RADEON_CRTC2_CUR_EN | RADEON_CRTC2_ICON_EN)) |
-		       RADEON_CRTC2_DISP_REQ_EN_B);
-	}
-
-	udelay(500);
-}
-
-void r100_mc_setup(struct radeon_device *rdev)
-{
-	uint32_t tmp;
-	int r;
-
-	r = r100_debugfs_mc_info_init(rdev);
-	if (r) {
-		DRM_ERROR("Failed to register debugfs file for R100 MC !\n");
-	}
-	/* Write VRAM size in case we are limiting it */
-	WREG32(RADEON_CONFIG_MEMSIZE, rdev->mc.real_vram_size);
-	/* Novell bug 204882 for RN50/M6/M7 with 8/16/32MB VRAM,
-	 * if the aperture is 64MB but we have 32MB VRAM
-	 * we report only 32MB VRAM but we have to set MC_FB_LOCATION
-	 * to 64MB, otherwise the gpu accidentially dies */
-	tmp = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
-	tmp = REG_SET(RADEON_MC_FB_TOP, tmp >> 16);
-	tmp |= REG_SET(RADEON_MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32(RADEON_MC_FB_LOCATION, tmp);
-
-	/* Enable bus mastering */
-	tmp = RREG32(RADEON_BUS_CNTL) & ~RADEON_BUS_MASTER_DIS;
-	WREG32(RADEON_BUS_CNTL, tmp);
-
-	if (rdev->flags & RADEON_IS_AGP) {
-		tmp = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
-		tmp = REG_SET(RADEON_MC_AGP_TOP, tmp >> 16);
-		tmp |= REG_SET(RADEON_MC_AGP_START, rdev->mc.gtt_location >> 16);
-		WREG32(RADEON_MC_AGP_LOCATION, tmp);
-		WREG32(RADEON_AGP_BASE, rdev->mc.agp_base);
-	} else {
-		WREG32(RADEON_MC_AGP_LOCATION, 0x0FFFFFFF);
-		WREG32(RADEON_AGP_BASE, 0);
-	}
-
-	tmp = RREG32(RADEON_HOST_PATH_CNTL) & RADEON_HDP_APER_CNTL;
-	tmp |= (7 << 28);
-	WREG32(RADEON_HOST_PATH_CNTL, tmp | RADEON_HDP_SOFT_RESET | RADEON_HDP_READ_BUFFER_INVALIDATE);
-	(void)RREG32(RADEON_HOST_PATH_CNTL);
-	WREG32(RADEON_HOST_PATH_CNTL, tmp);
-	(void)RREG32(RADEON_HOST_PATH_CNTL);
-}
-
-int r100_mc_init(struct radeon_device *rdev)
-{
-	int r;
-
-	if (r100_debugfs_rbbm_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-	}
-
-	r100_gpu_init(rdev);
-	/* Disable gart which also disable out of gart access */
-	r100_pci_gart_disable(rdev);
-
-	/* Setup GPU memory space */
-	rdev->mc.gtt_location = 0xFFFFFFFFUL;
-	if (rdev->flags & RADEON_IS_AGP) {
-		r = radeon_agp_init(rdev);
-		if (r) {
-			printk(KERN_WARNING "[drm] Disabling AGP\n");
-			rdev->flags &= ~RADEON_IS_AGP;
-			rdev->mc.gtt_size = radeon_gart_size * 1024 * 1024;
-		} else {
-			rdev->mc.gtt_location = rdev->mc.agp_base;
-		}
-	}
-	r = radeon_mc_setup(rdev);
-	if (r) {
-		return r;
-	}
-
-	r100_mc_disable_clients(rdev);
-	if (r100_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-
-	r100_mc_setup(rdev);
-	return 0;
-}
-
-void r100_mc_fini(struct radeon_device *rdev)
-{
-}
-
-
-/*
- * Interrupts
- */
 int r100_irq_set(struct radeon_device *rdev)
 {
 	uint32_t tmp = 0;
@@ -358,10 +220,6 @@ u32 r100_get_vblank_counter(struct radeon_device *rdev, int crtc)
 		return RREG32(RADEON_CRTC2_CRNT_FRAME);
 }
 
-
-/*
- * Fence emission
- */
 void r100_fence_ring_emit(struct radeon_device *rdev,
 			  struct radeon_fence *fence)
 {
@@ -377,10 +235,6 @@ void r100_fence_ring_emit(struct radeon_device *rdev,
 	radeon_ring_write(rdev, RADEON_SW_INT_FIRE);
 }
 
-
-/*
- * Writeback
- */
 int r100_wb_init(struct radeon_device *rdev)
 {
 	int r;
@@ -504,10 +358,6 @@ int r100_copy_blit(struct radeon_device *rdev,
 	return r;
 }
 
-
-/*
- * CP
- */
 static int r100_cp_wait_for_idle(struct radeon_device *rdev)
 {
 	unsigned i;
@@ -612,6 +462,7 @@ static int r100_cp_init_microcode(struct radeon_device *rdev)
 	}
 	return err;
 }
+
 static void r100_cp_load_microcode(struct radeon_device *rdev)
 {
 	const __be32 *fw_data;
@@ -1976,7 +1827,7 @@ void r100_pll_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 	r100_pll_errata_after_data(rdev);
 }
 
-int r100_init(struct radeon_device *rdev)
+void r100_set_safe_registers(struct radeon_device *rdev)
 {
 	if (ASIC_IS_RN50(rdev)) {
 		rdev->config.r100.reg_safe_bm = rn50_reg_safe_bm;
@@ -1985,9 +1836,8 @@ int r100_init(struct radeon_device *rdev)
 		rdev->config.r100.reg_safe_bm = r100_reg_safe_bm;
 		rdev->config.r100.reg_safe_bm_size = ARRAY_SIZE(r100_reg_safe_bm);
 	} else {
-		return r200_init(rdev);
+		r200_set_safe_registers(rdev);
 	}
-	return 0;
 }
 
 /*
@@ -3152,8 +3002,255 @@ void r100_mc_resume(struct radeon_device *rdev, struct r100_mc_save *save)
 
 void r100_vga_render_disable(struct radeon_device *rdev)
 {
-    u32 tmp;
+	u32 tmp;
 
-    tmp = RREG8(R_0003C2_GENMO_WT);
+	tmp = RREG8(R_0003C2_GENMO_WT);
 	WREG8(R_0003C2_GENMO_WT, C_0003C2_VGA_RAM_EN & tmp);
 }
+
+static void r100_debugfs(struct radeon_device *rdev)
+{
+	int r;
+
+	r = r100_debugfs_mc_info_init(rdev);
+	if (r)
+		dev_warn(rdev->dev, "Failed to create r100_mc debugfs file.\n");
+}
+
+static void r100_mc_program(struct radeon_device *rdev)
+{
+	struct r100_mc_save save;
+
+	/* Stops all mc clients */
+	r100_mc_stop(rdev, &save);
+	if (rdev->flags & RADEON_IS_AGP) {
+		WREG32(R_00014C_MC_AGP_LOCATION,
+			S_00014C_MC_AGP_START(rdev->mc.gtt_start >> 16) |
+			S_00014C_MC_AGP_TOP(rdev->mc.gtt_end >> 16));
+		WREG32(R_000170_AGP_BASE, lower_32_bits(rdev->mc.agp_base));
+		if (rdev->family > CHIP_RV200)
+			WREG32(R_00015C_AGP_BASE_2,
+				upper_32_bits(rdev->mc.agp_base) & 0xff);
+	} else {
+		WREG32(R_00014C_MC_AGP_LOCATION, 0x0FFFFFFF);
+		WREG32(R_000170_AGP_BASE, 0);
+		if (rdev->family > CHIP_RV200)
+			WREG32(R_00015C_AGP_BASE_2, 0);
+	}
+	/* Wait for mc idle */
+	if (r100_mc_wait_for_idle(rdev))
+		dev_warn(rdev->dev, "Wait for MC idle timeout.\n");
+	/* Program MC, should be a 32bits limited address space */
+	WREG32(R_000148_MC_FB_LOCATION,
+		S_000148_MC_FB_START(rdev->mc.vram_start >> 16) |
+		S_000148_MC_FB_TOP(rdev->mc.vram_end >> 16));
+	r100_mc_resume(rdev, &save);
+}
+
+void r100_clock_startup(struct radeon_device *rdev)
+{
+	u32 tmp;
+
+	if (radeon_dynclks != -1 && radeon_dynclks)
+		radeon_legacy_set_clock_gating(rdev, 1);
+	/* We need to force on some of the block */
+	tmp = RREG32_PLL(R_00000D_SCLK_CNTL);
+	tmp |= S_00000D_FORCE_CP(1) | S_00000D_FORCE_VIP(1);
+	if ((rdev->family == CHIP_RV250) || (rdev->family == CHIP_RV280))
+		tmp |= S_00000D_FORCE_DISP1(1) | S_00000D_FORCE_DISP2(1);
+	WREG32_PLL(R_00000D_SCLK_CNTL, tmp);
+}
+
+static int r100_startup(struct radeon_device *rdev)
+{
+	int r;
+
+	r100_mc_program(rdev);
+	/* Resume clock */
+	r100_clock_startup(rdev);
+	/* Initialize GPU configuration (# pipes, ...) */
+	r100_gpu_init(rdev);
+	/* Initialize GART (initialize after TTM so we can allocate
+	 * memory through TTM but finalize after TTM) */
+	if (rdev->flags & RADEON_IS_PCI) {
+		r = r100_pci_gart_enable(rdev);
+		if (r)
+			return r;
+	}
+	/* Enable IRQ */
+	rdev->irq.sw_int = true;
+	r100_irq_set(rdev);
+	/* 1M ring buffer */
+	r = r100_cp_init(rdev, 1024 * 1024);
+	if (r) {
+		dev_err(rdev->dev, "failled initializing CP (%d).\n", r);
+		return r;
+	}
+	r = r100_wb_init(rdev);
+	if (r)
+		dev_err(rdev->dev, "failled initializing WB (%d).\n", r);
+	r = r100_ib_init(rdev);
+	if (r) {
+		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		return r;
+	}
+	return 0;
+}
+
+int r100_resume(struct radeon_device *rdev)
+{
+	/* Make sur GART are not working */
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_disable(rdev);
+	/* Resume clock before doing reset */
+	r100_clock_startup(rdev);
+	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
+	if (radeon_gpu_reset(rdev)) {
+		dev_warn(rdev->dev, "GPU reset failed ! (0xE40=0x%08X, 0x7C0=0x%08X)\n",
+			RREG32(R_000E40_RBBM_STATUS),
+			RREG32(R_0007C0_CP_STAT));
+	}
+	/* post */
+	radeon_combios_asic_init(rdev->ddev);
+	/* Resume clock after posting */
+	r100_clock_startup(rdev);
+	return r100_startup(rdev);
+}
+
+int r100_suspend(struct radeon_device *rdev)
+{
+	r100_cp_disable(rdev);
+	r100_wb_disable(rdev);
+	r100_irq_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_disable(rdev);
+	return 0;
+}
+
+void r100_fini(struct radeon_device *rdev)
+{
+	r100_suspend(rdev);
+	r100_cp_fini(rdev);
+	r100_wb_fini(rdev);
+	r100_ib_fini(rdev);
+	radeon_gem_fini(rdev);
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_fini(rdev);
+	radeon_irq_kms_fini(rdev);
+	radeon_fence_driver_fini(rdev);
+	radeon_object_fini(rdev);
+	radeon_atombios_fini(rdev);
+	kfree(rdev->bios);
+	rdev->bios = NULL;
+}
+
+int r100_mc_init(struct radeon_device *rdev)
+{
+	int r;
+	u32 tmp;
+
+	/* Setup GPU memory space */
+	rdev->mc.vram_location = 0xFFFFFFFFUL;
+	rdev->mc.gtt_location = 0xFFFFFFFFUL;
+	if (rdev->flags & RADEON_IS_IGP) {
+		tmp = G_00015C_MC_FB_START(RREG32(R_00015C_NB_TOM));
+		rdev->mc.vram_location = tmp << 16;
+	}
+	if (rdev->flags & RADEON_IS_AGP) {
+		r = radeon_agp_init(rdev);
+		if (r) {
+			printk(KERN_WARNING "[drm] Disabling AGP\n");
+			rdev->flags &= ~RADEON_IS_AGP;
+			rdev->mc.gtt_size = radeon_gart_size * 1024 * 1024;
+		} else {
+			rdev->mc.gtt_location = rdev->mc.agp_base;
+		}
+	}
+	r = radeon_mc_setup(rdev);
+	if (r)
+		return r;
+	return 0;
+}
+
+int r100_init(struct radeon_device *rdev)
+{
+	int r;
+
+	rdev->new_init_path = true;
+	/* Register debugfs file specific to this group of asics */
+	r100_debugfs(rdev);
+	/* Disable VGA */
+	r100_vga_render_disable(rdev);
+	/* Initialize scratch registers */
+	radeon_scratch_init(rdev);
+	/* Initialize surface registers */
+	radeon_surface_init(rdev);
+	/* TODO: disable VGA need to use VGA request */
+	/* BIOS*/
+	if (!radeon_get_bios(rdev)) {
+		if (ASIC_IS_AVIVO(rdev))
+			return -EINVAL;
+	}
+	if (rdev->is_atom_bios) {
+		dev_err(rdev->dev, "Expecting combios for RS400/RS480 GPU\n");
+		return -EINVAL;
+	} else {
+		r = radeon_combios_init(rdev);
+		if (r)
+			return r;
+	}
+	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
+	if (radeon_gpu_reset(rdev)) {
+		dev_warn(rdev->dev,
+			"GPU reset failed ! (0xE40=0x%08X, 0x7C0=0x%08X)\n",
+			RREG32(R_000E40_RBBM_STATUS),
+			RREG32(R_0007C0_CP_STAT));
+	}
+	/* check if cards are posted or not */
+	if (!radeon_card_posted(rdev) && rdev->bios) {
+		DRM_INFO("GPU not posted. posting now...\n");
+		radeon_combios_asic_init(rdev->ddev);
+	}
+	/* Set asic errata */
+	r100_errata(rdev);
+	/* Initialize clocks */
+	radeon_get_clock_info(rdev->ddev);
+	/* Get vram informations */
+	r100_vram_info(rdev);
+	/* Initialize memory controller (also test AGP) */
+	r = r100_mc_init(rdev);
+	if (r)
+		return r;
+	/* Fence driver */
+	r = radeon_fence_driver_init(rdev);
+	if (r)
+		return r;
+	r = radeon_irq_kms_init(rdev);
+	if (r)
+		return r;
+	/* Memory manager */
+	r = radeon_object_init(rdev);
+	if (r)
+		return r;
+	if (rdev->flags & RADEON_IS_PCI) {
+		r = r100_pci_gart_init(rdev);
+		if (r)
+			return r;
+	}
+	r100_set_safe_registers(rdev);
+	rdev->accel_working = true;
+	r = r100_startup(rdev);
+	if (r) {
+		/* Somethings want wront with the accel init stop accel */
+		dev_err(rdev->dev, "Disabling GPU acceleration\n");
+		r100_suspend(rdev);
+		r100_cp_fini(rdev);
+		r100_wb_fini(rdev);
+		r100_ib_fini(rdev);
+		if (rdev->flags & RADEON_IS_PCI)
+			r100_pci_gart_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
+	}
+	return 0;
+}
diff --git a/drivers/gpu/drm/radeon/r100d.h b/drivers/gpu/drm/radeon/r100d.h
index 1595a5d..df29a63 100644
--- a/drivers/gpu/drm/radeon/r100d.h
+++ b/drivers/gpu/drm/radeon/r100d.h
@@ -381,6 +381,24 @@
 #define   S_000054_VCRTC_IDX_MASTER(x)                 (((x) & 0x7F) << 24)
 #define   G_000054_VCRTC_IDX_MASTER(x)                 (((x) >> 24) & 0x7F)
 #define   C_000054_VCRTC_IDX_MASTER                    0x80FFFFFF
+#define R_000148_MC_FB_LOCATION                      0x000148
+#define   S_000148_MC_FB_START(x)                      (((x) & 0xFFFF) << 0)
+#define   G_000148_MC_FB_START(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_000148_MC_FB_START                         0xFFFF0000
+#define   S_000148_MC_FB_TOP(x)                        (((x) & 0xFFFF) << 16)
+#define   G_000148_MC_FB_TOP(x)                        (((x) >> 16) & 0xFFFF)
+#define   C_000148_MC_FB_TOP                           0x0000FFFF
+#define R_00014C_MC_AGP_LOCATION                     0x00014C
+#define   S_00014C_MC_AGP_START(x)                     (((x) & 0xFFFF) << 0)
+#define   G_00014C_MC_AGP_START(x)                     (((x) >> 0) & 0xFFFF)
+#define   C_00014C_MC_AGP_START                        0xFFFF0000
+#define   S_00014C_MC_AGP_TOP(x)                       (((x) & 0xFFFF) << 16)
+#define   G_00014C_MC_AGP_TOP(x)                       (((x) >> 16) & 0xFFFF)
+#define   C_00014C_MC_AGP_TOP                          0x0000FFFF
+#define R_000170_AGP_BASE                            0x000170
+#define   S_000170_AGP_BASE_ADDR(x)                    (((x) & 0xFFFFFFFF) << 0)
+#define   G_000170_AGP_BASE_ADDR(x)                    (((x) >> 0) & 0xFFFFFFFF)
+#define   C_000170_AGP_BASE_ADDR                       0x00000000
 #define R_00023C_DISPLAY_BASE_ADDR                   0x00023C
 #define   S_00023C_DISPLAY_BASE_ADDR(x)                (((x) & 0xFFFFFFFF) << 0)
 #define   G_00023C_DISPLAY_BASE_ADDR(x)                (((x) >> 0) & 0xFFFFFFFF)
@@ -545,6 +563,46 @@
 #define   S_000774_SCRATCH_ADDR(x)                     (((x) & 0x7FFFFFF) << 5)
 #define   G_000774_SCRATCH_ADDR(x)                     (((x) >> 5) & 0x7FFFFFF)
 #define   C_000774_SCRATCH_ADDR                        0x0000001F
+#define R_0007C0_CP_STAT                             0x0007C0
+#define   S_0007C0_MRU_BUSY(x)                         (((x) & 0x1) << 0)
+#define   G_0007C0_MRU_BUSY(x)                         (((x) >> 0) & 0x1)
+#define   C_0007C0_MRU_BUSY                            0xFFFFFFFE
+#define   S_0007C0_MWU_BUSY(x)                         (((x) & 0x1) << 1)
+#define   G_0007C0_MWU_BUSY(x)                         (((x) >> 1) & 0x1)
+#define   C_0007C0_MWU_BUSY                            0xFFFFFFFD
+#define   S_0007C0_RSIU_BUSY(x)                        (((x) & 0x1) << 2)
+#define   G_0007C0_RSIU_BUSY(x)                        (((x) >> 2) & 0x1)
+#define   C_0007C0_RSIU_BUSY                           0xFFFFFFFB
+#define   S_0007C0_RCIU_BUSY(x)                        (((x) & 0x1) << 3)
+#define   G_0007C0_RCIU_BUSY(x)                        (((x) >> 3) & 0x1)
+#define   C_0007C0_RCIU_BUSY                           0xFFFFFFF7
+#define   S_0007C0_CSF_PRIMARY_BUSY(x)                 (((x) & 0x1) << 9)
+#define   G_0007C0_CSF_PRIMARY_BUSY(x)                 (((x) >> 9) & 0x1)
+#define   C_0007C0_CSF_PRIMARY_BUSY                    0xFFFFFDFF
+#define   S_0007C0_CSF_INDIRECT_BUSY(x)                (((x) & 0x1) << 10)
+#define   G_0007C0_CSF_INDIRECT_BUSY(x)                (((x) >> 10) & 0x1)
+#define   C_0007C0_CSF_INDIRECT_BUSY                   0xFFFFFBFF
+#define   S_0007C0_CSQ_PRIMARY_BUSY(x)                 (((x) & 0x1) << 11)
+#define   G_0007C0_CSQ_PRIMARY_BUSY(x)                 (((x) >> 11) & 0x1)
+#define   C_0007C0_CSQ_PRIMARY_BUSY                    0xFFFFF7FF
+#define   S_0007C0_CSQ_INDIRECT_BUSY(x)                (((x) & 0x1) << 12)
+#define   G_0007C0_CSQ_INDIRECT_BUSY(x)                (((x) >> 12) & 0x1)
+#define   C_0007C0_CSQ_INDIRECT_BUSY                   0xFFFFEFFF
+#define   S_0007C0_CSI_BUSY(x)                         (((x) & 0x1) << 13)
+#define   G_0007C0_CSI_BUSY(x)                         (((x) >> 13) & 0x1)
+#define   C_0007C0_CSI_BUSY                            0xFFFFDFFF
+#define   S_0007C0_GUIDMA_BUSY(x)                      (((x) & 0x1) << 28)
+#define   G_0007C0_GUIDMA_BUSY(x)                      (((x) >> 28) & 0x1)
+#define   C_0007C0_GUIDMA_BUSY                         0xEFFFFFFF
+#define   S_0007C0_VIDDMA_BUSY(x)                      (((x) & 0x1) << 29)
+#define   G_0007C0_VIDDMA_BUSY(x)                      (((x) >> 29) & 0x1)
+#define   C_0007C0_VIDDMA_BUSY                         0xDFFFFFFF
+#define   S_0007C0_CMDSTRM_BUSY(x)                     (((x) & 0x1) << 30)
+#define   G_0007C0_CMDSTRM_BUSY(x)                     (((x) >> 30) & 0x1)
+#define   C_0007C0_CMDSTRM_BUSY                        0xBFFFFFFF
+#define   S_0007C0_CP_BUSY(x)                          (((x) & 0x1) << 31)
+#define   G_0007C0_CP_BUSY(x)                          (((x) >> 31) & 0x1)
+#define   C_0007C0_CP_BUSY                             0x7FFFFFFF
 #define R_000E40_RBBM_STATUS                         0x000E40
 #define   S_000E40_CMDFIFO_AVAIL(x)                    (((x) & 0x7F) << 0)
 #define   G_000E40_CMDFIFO_AVAIL(x)                    (((x) >> 0) & 0x7F)
@@ -604,4 +662,53 @@
 #define   G_000E40_GUI_ACTIVE(x)                       (((x) >> 31) & 0x1)
 #define   C_000E40_GUI_ACTIVE                          0x7FFFFFFF
 
+
+#define R_00000D_SCLK_CNTL                           0x00000D
+#define   S_00000D_SCLK_SRC_SEL(x)                     (((x) & 0x7) << 0)
+#define   G_00000D_SCLK_SRC_SEL(x)                     (((x) >> 0) & 0x7)
+#define   C_00000D_SCLK_SRC_SEL                        0xFFFFFFF8
+#define   S_00000D_TCLK_SRC_SEL(x)                     (((x) & 0x7) << 8)
+#define   G_00000D_TCLK_SRC_SEL(x)                     (((x) >> 8) & 0x7)
+#define   C_00000D_TCLK_SRC_SEL                        0xFFFFF8FF
+#define   S_00000D_FORCE_CP(x)                         (((x) & 0x1) << 16)
+#define   G_00000D_FORCE_CP(x)                         (((x) >> 16) & 0x1)
+#define   C_00000D_FORCE_CP                            0xFFFEFFFF
+#define   S_00000D_FORCE_HDP(x)                        (((x) & 0x1) << 17)
+#define   G_00000D_FORCE_HDP(x)                        (((x) >> 17) & 0x1)
+#define   C_00000D_FORCE_HDP                           0xFFFDFFFF
+#define   S_00000D_FORCE_DISP(x)                       (((x) & 0x1) << 18)
+#define   G_00000D_FORCE_DISP(x)                       (((x) >> 18) & 0x1)
+#define   C_00000D_FORCE_DISP                          0xFFFBFFFF
+#define   S_00000D_FORCE_TOP(x)                        (((x) & 0x1) << 19)
+#define   G_00000D_FORCE_TOP(x)                        (((x) >> 19) & 0x1)
+#define   C_00000D_FORCE_TOP                           0xFFF7FFFF
+#define   S_00000D_FORCE_E2(x)                         (((x) & 0x1) << 20)
+#define   G_00000D_FORCE_E2(x)                         (((x) >> 20) & 0x1)
+#define   C_00000D_FORCE_E2                            0xFFEFFFFF
+#define   S_00000D_FORCE_SE(x)                         (((x) & 0x1) << 21)
+#define   G_00000D_FORCE_SE(x)                         (((x) >> 21) & 0x1)
+#define   C_00000D_FORCE_SE                            0xFFDFFFFF
+#define   S_00000D_FORCE_IDCT(x)                       (((x) & 0x1) << 22)
+#define   G_00000D_FORCE_IDCT(x)                       (((x) >> 22) & 0x1)
+#define   C_00000D_FORCE_IDCT                          0xFFBFFFFF
+#define   S_00000D_FORCE_VIP(x)                        (((x) & 0x1) << 23)
+#define   G_00000D_FORCE_VIP(x)                        (((x) >> 23) & 0x1)
+#define   C_00000D_FORCE_VIP                           0xFF7FFFFF
+#define   S_00000D_FORCE_RE(x)                         (((x) & 0x1) << 24)
+#define   G_00000D_FORCE_RE(x)                         (((x) >> 24) & 0x1)
+#define   C_00000D_FORCE_RE                            0xFEFFFFFF
+#define   S_00000D_FORCE_PB(x)                         (((x) & 0x1) << 25)
+#define   G_00000D_FORCE_PB(x)                         (((x) >> 25) & 0x1)
+#define   C_00000D_FORCE_PB                            0xFDFFFFFF
+#define   S_00000D_FORCE_TAM(x)                        (((x) & 0x1) << 26)
+#define   G_00000D_FORCE_TAM(x)                        (((x) >> 26) & 0x1)
+#define   C_00000D_FORCE_TAM                           0xFBFFFFFF
+#define   S_00000D_FORCE_TDM(x)                        (((x) & 0x1) << 27)
+#define   G_00000D_FORCE_TDM(x)                        (((x) >> 27) & 0x1)
+#define   C_00000D_FORCE_TDM                           0xF7FFFFFF
+#define   S_00000D_FORCE_RB(x)                         (((x) & 0x1) << 28)
+#define   G_00000D_FORCE_RB(x)                         (((x) >> 28) & 0x1)
+#define   C_00000D_FORCE_RB                            0xEFFFFFFF
+
+
 #endif
diff --git a/drivers/gpu/drm/radeon/r200.c b/drivers/gpu/drm/radeon/r200.c
index cf7fea5..eb740fc 100644
--- a/drivers/gpu/drm/radeon/r200.c
+++ b/drivers/gpu/drm/radeon/r200.c
@@ -447,9 +447,8 @@ int r200_packet0_check(struct radeon_cs_parser *p,
 	return 0;
 }
 
-int r200_init(struct radeon_device *rdev)
+void r200_set_safe_registers(struct radeon_device *rdev)
 {
 	rdev->config.r100.reg_safe_bm = r200_reg_safe_bm;
 	rdev->config.r100.reg_safe_bm_size = ARRAY_SIZE(r200_reg_safe_bm);
-	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index da08f09..2f084e1 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1042,6 +1042,9 @@ extern int r100_cs_packet_parse(struct radeon_cs_parser *p,
 				struct radeon_cs_packet *pkt,
 				unsigned idx);
 
+/* rv200,rv250,rv280 */
+extern void r200_set_safe_registers(struct radeon_device *rdev);
+
 /* r300,r350,rv350,rv370,rv380 */
 extern void r300_set_reg_safe(struct radeon_device *rdev);
 extern void r300_mc_program(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 12321a0..3ad9164 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -41,27 +41,16 @@ void radeon_atom_set_clock_gating(struct radeon_device *rdev, int enable);
 /*
  * r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280
  */
-int r100_init(struct radeon_device *rdev);
-int r200_init(struct radeon_device *rdev);
+extern int r100_init(struct radeon_device *rdev);
+extern void r100_fini(struct radeon_device *rdev);
+extern int r100_suspend(struct radeon_device *rdev);
+extern int r100_resume(struct radeon_device *rdev);
 uint32_t r100_mm_rreg(struct radeon_device *rdev, uint32_t reg);
 void r100_mm_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
-void r100_errata(struct radeon_device *rdev);
-void r100_vram_info(struct radeon_device *rdev);
 int r100_gpu_reset(struct radeon_device *rdev);
-int r100_mc_init(struct radeon_device *rdev);
-void r100_mc_fini(struct radeon_device *rdev);
 u32 r100_get_vblank_counter(struct radeon_device *rdev, int crtc);
-int r100_wb_init(struct radeon_device *rdev);
-void r100_wb_fini(struct radeon_device *rdev);
-int r100_pci_gart_init(struct radeon_device *rdev);
-void r100_pci_gart_fini(struct radeon_device *rdev);
-int r100_pci_gart_enable(struct radeon_device *rdev);
-void r100_pci_gart_disable(struct radeon_device *rdev);
 void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
 int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
-int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
-void r100_cp_fini(struct radeon_device *rdev);
-void r100_cp_disable(struct radeon_device *rdev);
 void r100_cp_commit(struct radeon_device *rdev);
 void r100_ring_start(struct radeon_device *rdev);
 int r100_irq_set(struct radeon_device *rdev);
@@ -87,27 +76,30 @@ int r100_ring_test(struct radeon_device *rdev);
 
 static struct radeon_asic r100_asic = {
 	.init = &r100_init,
-	.errata = &r100_errata,
-	.vram_info = &r100_vram_info,
+	.fini = &r100_fini,
+	.suspend = &r100_suspend,
+	.resume = &r100_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &r100_gpu_reset,
-	.mc_init = &r100_mc_init,
-	.mc_fini = &r100_mc_fini,
-	.wb_init = &r100_wb_init,
-	.wb_fini = &r100_wb_fini,
-	.gart_init = &r100_pci_gart_init,
-	.gart_fini = &r100_pci_gart_fini,
-	.gart_enable = &r100_pci_gart_enable,
-	.gart_disable = &r100_pci_gart_disable,
+	.mc_init = NULL,
+	.mc_fini = NULL,
+	.wb_init = NULL,
+	.wb_fini = NULL,
+	.gart_init = NULL,
+	.gart_fini = NULL,
+	.gart_enable = NULL,
+	.gart_disable = NULL,
 	.gart_tlb_flush = &r100_pci_gart_tlb_flush,
 	.gart_set_page = &r100_pci_gart_set_page,
-	.cp_init = &r100_cp_init,
-	.cp_fini = &r100_cp_fini,
-	.cp_disable = &r100_cp_disable,
+	.cp_init = NULL,
+	.cp_fini = NULL,
+	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r100_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = &r100_ib_test,
+	.ib_test = NULL,
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.get_vblank_counter = &r100_get_vblank_counter,
diff --git a/drivers/gpu/drm/radeon/rs100d.h b/drivers/gpu/drm/radeon/rs100d.h
new file mode 100644
index 0000000..48a913a
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rs100d.h
@@ -0,0 +1,40 @@
+/*
+ * Copyright 2008 Advanced Micro Devices, Inc.
+ * Copyright 2008 Red Hat Inc.
+ * Copyright 2009 Jerome Glisse.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Dave Airlie
+ *          Alex Deucher
+ *          Jerome Glisse
+ */
+#ifndef __RS100D_H__
+#define __RS100D_H__
+
+/* Registers */
+#define R_00015C_NB_TOM                              0x00015C
+#define   S_00015C_MC_FB_START(x)                      (((x) & 0xFFFF) << 0)
+#define   G_00015C_MC_FB_START(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_00015C_MC_FB_START                         0xFFFF0000
+#define   S_00015C_MC_FB_TOP(x)                        (((x) & 0xFFFF) << 16)
+#define   G_00015C_MC_FB_TOP(x)                        (((x) >> 16) & 0xFFFF)
+#define   C_00015C_MC_FB_TOP                           0x0000FFFF
+
+#endif
diff --git a/drivers/gpu/drm/radeon/rv200d.h b/drivers/gpu/drm/radeon/rv200d.h
new file mode 100644
index 0000000..c5b3983
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rv200d.h
@@ -0,0 +1,36 @@
+/*
+ * Copyright 2008 Advanced Micro Devices, Inc.
+ * Copyright 2008 Red Hat Inc.
+ * Copyright 2009 Jerome Glisse.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Dave Airlie
+ *          Alex Deucher
+ *          Jerome Glisse
+ */
+#ifndef __RV200D_H__
+#define __RV200D_H__
+
+#define R_00015C_AGP_BASE_2                          0x00015C
+#define   S_00015C_AGP_BASE_ADDR_2(x)                  (((x) & 0xF) << 0)
+#define   G_00015C_AGP_BASE_ADDR_2(x)                  (((x) >> 0) & 0xF)
+#define   C_00015C_AGP_BASE_ADDR_2                     0xFFFFFFF0
+
+#endif
diff --git a/drivers/gpu/drm/radeon/rv250d.h b/drivers/gpu/drm/radeon/rv250d.h
new file mode 100644
index 0000000..e5a70b0
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rv250d.h
@@ -0,0 +1,123 @@
+/*
+ * Copyright 2008 Advanced Micro Devices, Inc.
+ * Copyright 2008 Red Hat Inc.
+ * Copyright 2009 Jerome Glisse.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ *
+ * Authors: Dave Airlie
+ *          Alex Deucher
+ *          Jerome Glisse
+ */
+#ifndef __RV250D_H__
+#define __RV250D_H__
+
+#define R_00000D_SCLK_CNTL_M6                        0x00000D
+#define   S_00000D_SCLK_SRC_SEL(x)                     (((x) & 0x7) << 0)
+#define   G_00000D_SCLK_SRC_SEL(x)                     (((x) >> 0) & 0x7)
+#define   C_00000D_SCLK_SRC_SEL                        0xFFFFFFF8
+#define   S_00000D_CP_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 3)
+#define   G_00000D_CP_MAX_DYN_STOP_LAT(x)              (((x) >> 3) & 0x1)
+#define   C_00000D_CP_MAX_DYN_STOP_LAT                 0xFFFFFFF7
+#define   S_00000D_HDP_MAX_DYN_STOP_LAT(x)             (((x) & 0x1) << 4)
+#define   G_00000D_HDP_MAX_DYN_STOP_LAT(x)             (((x) >> 4) & 0x1)
+#define   C_00000D_HDP_MAX_DYN_STOP_LAT                0xFFFFFFEF
+#define   S_00000D_TV_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 5)
+#define   G_00000D_TV_MAX_DYN_STOP_LAT(x)              (((x) >> 5) & 0x1)
+#define   C_00000D_TV_MAX_DYN_STOP_LAT                 0xFFFFFFDF
+#define   S_00000D_E2_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 6)
+#define   G_00000D_E2_MAX_DYN_STOP_LAT(x)              (((x) >> 6) & 0x1)
+#define   C_00000D_E2_MAX_DYN_STOP_LAT                 0xFFFFFFBF
+#define   S_00000D_SE_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 7)
+#define   G_00000D_SE_MAX_DYN_STOP_LAT(x)              (((x) >> 7) & 0x1)
+#define   C_00000D_SE_MAX_DYN_STOP_LAT                 0xFFFFFF7F
+#define   S_00000D_IDCT_MAX_DYN_STOP_LAT(x)            (((x) & 0x1) << 8)
+#define   G_00000D_IDCT_MAX_DYN_STOP_LAT(x)            (((x) >> 8) & 0x1)
+#define   C_00000D_IDCT_MAX_DYN_STOP_LAT               0xFFFFFEFF
+#define   S_00000D_VIP_MAX_DYN_STOP_LAT(x)             (((x) & 0x1) << 9)
+#define   G_00000D_VIP_MAX_DYN_STOP_LAT(x)             (((x) >> 9) & 0x1)
+#define   C_00000D_VIP_MAX_DYN_STOP_LAT                0xFFFFFDFF
+#define   S_00000D_RE_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 10)
+#define   G_00000D_RE_MAX_DYN_STOP_LAT(x)              (((x) >> 10) & 0x1)
+#define   C_00000D_RE_MAX_DYN_STOP_LAT                 0xFFFFFBFF
+#define   S_00000D_PB_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 11)
+#define   G_00000D_PB_MAX_DYN_STOP_LAT(x)              (((x) >> 11) & 0x1)
+#define   C_00000D_PB_MAX_DYN_STOP_LAT                 0xFFFFF7FF
+#define   S_00000D_TAM_MAX_DYN_STOP_LAT(x)             (((x) & 0x1) << 12)
+#define   G_00000D_TAM_MAX_DYN_STOP_LAT(x)             (((x) >> 12) & 0x1)
+#define   C_00000D_TAM_MAX_DYN_STOP_LAT                0xFFFFEFFF
+#define   S_00000D_TDM_MAX_DYN_STOP_LAT(x)             (((x) & 0x1) << 13)
+#define   G_00000D_TDM_MAX_DYN_STOP_LAT(x)             (((x) >> 13) & 0x1)
+#define   C_00000D_TDM_MAX_DYN_STOP_LAT                0xFFFFDFFF
+#define   S_00000D_RB_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 14)
+#define   G_00000D_RB_MAX_DYN_STOP_LAT(x)              (((x) >> 14) & 0x1)
+#define   C_00000D_RB_MAX_DYN_STOP_LAT                 0xFFFFBFFF
+#define   S_00000D_FORCE_DISP2(x)                      (((x) & 0x1) << 15)
+#define   G_00000D_FORCE_DISP2(x)                      (((x) >> 15) & 0x1)
+#define   C_00000D_FORCE_DISP2                         0xFFFF7FFF
+#define   S_00000D_FORCE_CP(x)                         (((x) & 0x1) << 16)
+#define   G_00000D_FORCE_CP(x)                         (((x) >> 16) & 0x1)
+#define   C_00000D_FORCE_CP                            0xFFFEFFFF
+#define   S_00000D_FORCE_HDP(x)                        (((x) & 0x1) << 17)
+#define   G_00000D_FORCE_HDP(x)                        (((x) >> 17) & 0x1)
+#define   C_00000D_FORCE_HDP                           0xFFFDFFFF
+#define   S_00000D_FORCE_DISP1(x)                      (((x) & 0x1) << 18)
+#define   G_00000D_FORCE_DISP1(x)                      (((x) >> 18) & 0x1)
+#define   C_00000D_FORCE_DISP1                         0xFFFBFFFF
+#define   S_00000D_FORCE_TOP(x)                        (((x) & 0x1) << 19)
+#define   G_00000D_FORCE_TOP(x)                        (((x) >> 19) & 0x1)
+#define   C_00000D_FORCE_TOP                           0xFFF7FFFF
+#define   S_00000D_FORCE_E2(x)                         (((x) & 0x1) << 20)
+#define   G_00000D_FORCE_E2(x)                         (((x) >> 20) & 0x1)
+#define   C_00000D_FORCE_E2                            0xFFEFFFFF
+#define   S_00000D_FORCE_SE(x)                         (((x) & 0x1) << 21)
+#define   G_00000D_FORCE_SE(x)                         (((x) >> 21) & 0x1)
+#define   C_00000D_FORCE_SE                            0xFFDFFFFF
+#define   S_00000D_FORCE_IDCT(x)                       (((x) & 0x1) << 22)
+#define   G_00000D_FORCE_IDCT(x)                       (((x) >> 22) & 0x1)
+#define   C_00000D_FORCE_IDCT                          0xFFBFFFFF
+#define   S_00000D_FORCE_VIP(x)                        (((x) & 0x1) << 23)
+#define   G_00000D_FORCE_VIP(x)                        (((x) >> 23) & 0x1)
+#define   C_00000D_FORCE_VIP                           0xFF7FFFFF
+#define   S_00000D_FORCE_RE(x)                         (((x) & 0x1) << 24)
+#define   G_00000D_FORCE_RE(x)                         (((x) >> 24) & 0x1)
+#define   C_00000D_FORCE_RE                            0xFEFFFFFF
+#define   S_00000D_FORCE_PB(x)                         (((x) & 0x1) << 25)
+#define   G_00000D_FORCE_PB(x)                         (((x) >> 25) & 0x1)
+#define   C_00000D_FORCE_PB                            0xFDFFFFFF
+#define   S_00000D_FORCE_TAM(x)                        (((x) & 0x1) << 26)
+#define   G_00000D_FORCE_TAM(x)                        (((x) >> 26) & 0x1)
+#define   C_00000D_FORCE_TAM                           0xFBFFFFFF
+#define   S_00000D_FORCE_TDM(x)                        (((x) & 0x1) << 27)
+#define   G_00000D_FORCE_TDM(x)                        (((x) >> 27) & 0x1)
+#define   C_00000D_FORCE_TDM                           0xF7FFFFFF
+#define   S_00000D_FORCE_RB(x)                         (((x) & 0x1) << 28)
+#define   G_00000D_FORCE_RB(x)                         (((x) >> 28) & 0x1)
+#define   C_00000D_FORCE_RB                            0xEFFFFFFF
+#define   S_00000D_FORCE_TV_SCLK(x)                    (((x) & 0x1) << 29)
+#define   G_00000D_FORCE_TV_SCLK(x)                    (((x) >> 29) & 0x1)
+#define   C_00000D_FORCE_TV_SCLK                       0xDFFFFFFF
+#define   S_00000D_FORCE_SUBPIC(x)                     (((x) & 0x1) << 30)
+#define   G_00000D_FORCE_SUBPIC(x)                     (((x) >> 30) & 0x1)
+#define   C_00000D_FORCE_SUBPIC                        0xBFFFFFFF
+#define   S_00000D_FORCE_OV0(x)                        (((x) & 0x1) << 31)
+#define   G_00000D_FORCE_OV0(x)                        (((x) >> 31) & 0x1)
+#define   C_00000D_FORCE_OV0                           0x7FFFFFFF
+
+#endif
-- 
1.6.4.4

