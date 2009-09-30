Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbZI3UJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbZI3UJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754265AbZI3UJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:09:35 -0400
Received: from nox.protox.org ([88.191.38.29]:43618 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZI3UJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:09:33 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert RS600 to new init path
Date: Wed, 30 Sep 2009 22:09:06 +0200
Message-Id: <1254341346-11367-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New init path allow to simply asic initialization and make easier
to trace what happen on each different asic. We are removing most
callback. Do a massive RS600 register cleanup to clarify RS600
register, we are still bit fuzy on some register and waiting for
more informations. I don't have hw to test, so this patch is a
best effort to not break anythings and to try to improve things.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon_asic.h |   44 ++--
 drivers/gpu/drm/radeon/rs600.c       |  466 ++++++++++++++++++++--------------
 drivers/gpu/drm/radeon/rs600d.h      |  406 +++++++++++++++++++++++++++++
 3 files changed, 696 insertions(+), 220 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/rs600d.h

diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 3ad9164..7bc86a6 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -290,18 +290,13 @@ static struct radeon_asic rs400_asic = {
 /*
  * rs600.
  */
-int rs600_init(struct radeon_device *rdev);
-void rs600_errata(struct radeon_device *rdev);
-void rs600_vram_info(struct radeon_device *rdev);
-int rs600_mc_init(struct radeon_device *rdev);
-void rs600_mc_fini(struct radeon_device *rdev);
+extern int rs600_init(struct radeon_device *rdev);
+extern void rs600_fini(struct radeon_device *rdev);
+extern int rs600_suspend(struct radeon_device *rdev);
+extern int rs600_resume(struct radeon_device *rdev);
 int rs600_irq_set(struct radeon_device *rdev);
 int rs600_irq_process(struct radeon_device *rdev);
 u32 rs600_get_vblank_counter(struct radeon_device *rdev, int crtc);
-int rs600_gart_init(struct radeon_device *rdev);
-void rs600_gart_fini(struct radeon_device *rdev);
-int rs600_gart_enable(struct radeon_device *rdev);
-void rs600_gart_disable(struct radeon_device *rdev);
 void rs600_gart_tlb_flush(struct radeon_device *rdev);
 int rs600_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 uint32_t rs600_mc_rreg(struct radeon_device *rdev, uint32_t reg);
@@ -309,27 +304,30 @@ void rs600_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void rs600_bandwidth_update(struct radeon_device *rdev);
 static struct radeon_asic rs600_asic = {
 	.init = &rs600_init,
-	.errata = &rs600_errata,
-	.vram_info = &rs600_vram_info,
+	.fini = &rs600_fini,
+	.suspend = &rs600_suspend,
+	.resume = &rs600_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = &rs600_mc_init,
-	.mc_fini = &rs600_mc_fini,
-	.wb_init = &r100_wb_init,
-	.wb_fini = &r100_wb_fini,
-	.gart_init = &rs600_gart_init,
-	.gart_fini = &rs600_gart_fini,
-	.gart_enable = &rs600_gart_enable,
-	.gart_disable = &rs600_gart_disable,
+	.mc_init = NULL,
+	.mc_fini = NULL,
+	.wb_init = NULL,
+	.wb_fini = NULL,
+	.gart_init = NULL,
+	.gart_fini = NULL,
+	.gart_enable = NULL,
+	.gart_disable = NULL,
 	.gart_tlb_flush = &rs600_gart_tlb_flush,
 	.gart_set_page = &rs600_gart_set_page,
-	.cp_init = &r100_cp_init,
-	.cp_fini = &r100_cp_fini,
-	.cp_disable = &r100_cp_disable,
+	.cp_init = NULL,
+	.cp_fini = NULL,
+	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &r300_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = &r100_ib_test,
+	.ib_test = NULL,
 	.irq_set = &rs600_irq_set,
 	.irq_process = &rs600_irq_process,
 	.get_vblank_counter = &rs600_get_vblank_counter,
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index fa8e451..9e4fdc1 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -25,27 +25,26 @@
  *          Alex Deucher
  *          Jerome Glisse
  */
+/* RS600 / Radeon X1250/X1270 integrated GPU
+ *
+ * This file gather function specific to RS600 which is the IGP of
+ * the X1250/X1270 family supporting intel CPU (while RS690/RS740
+ * is the X1250/X1270 supporting AMD CPU). The display engine are
+ * the avivo one, bios is an atombios, 3D block are the one of the
+ * R4XX family. The GART is different from the RS400 one and is very
+ * close to the one of the R600 family (R600 likely being an evolution
+ * of the RS600 GART block).
+ */
 #include "drmP.h"
-#include "radeon_reg.h"
 #include "radeon.h"
+#include "atom.h"
+#include "rs600d.h"
 
 #include "rs600_reg_safe.h"
 
-/* rs600 depends on : */
-void r100_hdp_reset(struct radeon_device *rdev);
-int r100_gui_wait_for_idle(struct radeon_device *rdev);
-int r300_mc_wait_for_idle(struct radeon_device *rdev);
-void r420_pipes_init(struct radeon_device *rdev);
-
-/* This files gather functions specifics to :
- * rs600
- *
- * Some of these functions might be used by newer ASICs.
- */
 void rs600_gpu_init(struct radeon_device *rdev);
 int rs600_mc_wait_for_idle(struct radeon_device *rdev);
 
-
 /*
  * GART.
  */
@@ -53,18 +52,18 @@ void rs600_gart_tlb_flush(struct radeon_device *rdev)
 {
 	uint32_t tmp;
 
-	tmp = RREG32_MC(RS600_MC_PT0_CNTL);
-	tmp &= ~(RS600_INVALIDATE_ALL_L1_TLBS | RS600_INVALIDATE_L2_CACHE);
-	WREG32_MC(RS600_MC_PT0_CNTL, tmp);
+	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
+	tmp &= C_000100_INVALIDATE_ALL_L1_TLBS & C_000100_INVALIDATE_L2_CACHE;
+	WREG32_MC(R_000100_MC_PT0_CNTL, tmp);
 
-	tmp = RREG32_MC(RS600_MC_PT0_CNTL);
-	tmp |= RS600_INVALIDATE_ALL_L1_TLBS | RS600_INVALIDATE_L2_CACHE;
-	WREG32_MC(RS600_MC_PT0_CNTL, tmp);
+	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
+	tmp |= S_000100_INVALIDATE_ALL_L1_TLBS(1) & S_000100_INVALIDATE_L2_CACHE(1);
+	WREG32_MC(R_000100_MC_PT0_CNTL, tmp);
 
-	tmp = RREG32_MC(RS600_MC_PT0_CNTL);
-	tmp &= ~(RS600_INVALIDATE_ALL_L1_TLBS | RS600_INVALIDATE_L2_CACHE);
-	WREG32_MC(RS600_MC_PT0_CNTL, tmp);
-	tmp = RREG32_MC(RS600_MC_PT0_CNTL);
+	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
+	tmp &= C_000100_INVALIDATE_ALL_L1_TLBS & C_000100_INVALIDATE_L2_CACHE;
+	WREG32_MC(R_000100_MC_PT0_CNTL, tmp);
+	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
 }
 
 int rs600_gart_init(struct radeon_device *rdev)
@@ -86,7 +85,7 @@ int rs600_gart_init(struct radeon_device *rdev)
 
 int rs600_gart_enable(struct radeon_device *rdev)
 {
-	uint32_t tmp;
+	u32 tmp;
 	int r, i;
 
 	if (rdev->gart.table.vram.robj == NULL) {
@@ -96,46 +95,50 @@ int rs600_gart_enable(struct radeon_device *rdev)
 	r = radeon_gart_table_vram_pin(rdev);
 	if (r)
 		return r;
+	/* Enable bus master */
+	tmp = RREG32(R_00004C_BUS_CNTL) & C_00004C_BUS_MASTER_DIS;
+	WREG32(R_00004C_BUS_CNTL, tmp);
 	/* FIXME: setup default page */
-	WREG32_MC(RS600_MC_PT0_CNTL,
-		 (RS600_EFFECTIVE_L2_CACHE_SIZE(6) |
-		  RS600_EFFECTIVE_L2_QUEUE_SIZE(6)));
+	WREG32_MC(R_000100_MC_PT0_CNTL,
+		 (S_000100_EFFECTIVE_L2_CACHE_SIZE(6) |
+		  S_000100_EFFECTIVE_L2_QUEUE_SIZE(6)));
 	for (i = 0; i < 19; i++) {
-		WREG32_MC(RS600_MC_PT0_CLIENT0_CNTL + i,
-			 (RS600_ENABLE_TRANSLATION_MODE_OVERRIDE |
-			  RS600_SYSTEM_ACCESS_MODE_IN_SYS |
-			  RS600_SYSTEM_APERTURE_UNMAPPED_ACCESS_DEFAULT_PAGE |
-			  RS600_EFFECTIVE_L1_CACHE_SIZE(3) |
-			  RS600_ENABLE_FRAGMENT_PROCESSING |
-			  RS600_EFFECTIVE_L1_QUEUE_SIZE(3)));
+		WREG32_MC(R_00016C_MC_PT0_CLIENT0_CNTL + i,
+			S_00016C_ENABLE_TRANSLATION_MODE_OVERRIDE(1) |
+			S_00016C_SYSTEM_ACCESS_MODE_MASK(
+				V_00016C_SYSTEM_ACCESS_MODE_IN_SYS) |
+			S_00016C_SYSTEM_APERTURE_UNMAPPED_ACCESS(
+				V_00016C_SYSTEM_APERTURE_UNMAPPED_DEFAULT_PAGE) |
+			S_00016C_EFFECTIVE_L1_CACHE_SIZE(1) |
+			S_00016C_ENABLE_FRAGMENT_PROCESSING(1) |
+			S_00016C_EFFECTIVE_L1_QUEUE_SIZE(1));
 	}
 
 	/* System context map to GART space */
-	WREG32_MC(RS600_MC_PT0_SYSTEM_APERTURE_LOW_ADDR, rdev->mc.gtt_location);
-	tmp = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
-	WREG32_MC(RS600_MC_PT0_SYSTEM_APERTURE_HIGH_ADDR, tmp);
+	WREG32_MC(R_000112_MC_PT0_SYSTEM_APERTURE_LOW_ADDR, rdev->mc.gtt_start);
+	WREG32_MC(R_000114_MC_PT0_SYSTEM_APERTURE_HIGH_ADDR, rdev->mc.gtt_end);
 
 	/* enable first context */
-	WREG32_MC(RS600_MC_PT0_CONTEXT0_FLAT_START_ADDR, rdev->mc.gtt_location);
-	tmp = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
-	WREG32_MC(RS600_MC_PT0_CONTEXT0_FLAT_END_ADDR, tmp);
-	WREG32_MC(RS600_MC_PT0_CONTEXT0_CNTL,
-		 (RS600_ENABLE_PAGE_TABLE | RS600_PAGE_TABLE_TYPE_FLAT));
+	WREG32_MC(R_00013C_MC_PT0_CONTEXT0_FLAT_START_ADDR, rdev->mc.gtt_start);
+	WREG32_MC(R_00014C_MC_PT0_CONTEXT0_FLAT_END_ADDR, rdev->mc.gtt_end);
+	WREG32_MC(R_000102_MC_PT0_CONTEXT0_CNTL,
+			S_000102_ENABLE_PAGE_TABLE(1) |
+			S_000102_PAGE_TABLE_DEPTH(V_000102_PAGE_TABLE_FLAT));
 	/* disable all other contexts */
 	for (i = 1; i < 8; i++) {
-		WREG32_MC(RS600_MC_PT0_CONTEXT0_CNTL + i, 0);
+		WREG32_MC(R_000102_MC_PT0_CONTEXT0_CNTL + i, 0);
 	}
 
 	/* setup the page table */
-	WREG32_MC(RS600_MC_PT0_CONTEXT0_FLAT_BASE_ADDR,
-		 rdev->gart.table_addr);
-	WREG32_MC(RS600_MC_PT0_CONTEXT0_DEFAULT_READ_ADDR, 0);
+	WREG32_MC(R_00012C_MC_PT0_CONTEXT0_FLAT_BASE_ADDR,
+			rdev->gart.table_addr);
+	WREG32_MC(R_00011C_MC_PT0_CONTEXT0_DEFAULT_READ_ADDR, 0);
 
 	/* enable page tables */
-	tmp = RREG32_MC(RS600_MC_PT0_CNTL);
-	WREG32_MC(RS600_MC_PT0_CNTL, (tmp | RS600_ENABLE_PT));
-	tmp = RREG32_MC(RS600_MC_CNTL1);
-	WREG32_MC(RS600_MC_CNTL1, (tmp | RS600_ENABLE_PAGE_TABLES));
+	tmp = RREG32_MC(R_000100_MC_PT0_CNTL);
+	WREG32_MC(R_000100_MC_PT0_CNTL, (tmp | S_000100_ENABLE_PT(1)));
+	tmp = RREG32_MC(R_000009_MC_CNTL1);
+	WREG32_MC(R_000009_MC_CNTL1, (tmp | S_000009_ENABLE_PAGE_TABLES(1)));
 	rs600_gart_tlb_flush(rdev);
 	rdev->gart.ready = true;
 	return 0;
@@ -146,10 +149,9 @@ void rs600_gart_disable(struct radeon_device *rdev)
 	uint32_t tmp;
 
 	/* FIXME: disable out of gart access */
-	WREG32_MC(RS600_MC_PT0_CNTL, 0);
-	tmp = RREG32_MC(RS600_MC_CNTL1);
-	tmp &= ~RS600_ENABLE_PAGE_TABLES;
-	WREG32_MC(RS600_MC_CNTL1, tmp);
+	WREG32_MC(R_000100_MC_PT0_CNTL, 0);
+	tmp = RREG32_MC(R_000009_MC_CNTL1);
+	WREG32_MC(R_000009_MC_CNTL1, tmp & C_000009_ENABLE_PAGE_TABLES);
 	if (rdev->gart.table.vram.robj) {
 		radeon_object_kunmap(rdev->gart.table.vram.robj);
 		radeon_object_unpin(rdev->gart.table.vram.robj);
@@ -183,125 +185,46 @@ int rs600_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr)
 	return 0;
 }
 
-
-/*
- * MC.
- */
-void rs600_mc_disable_clients(struct radeon_device *rdev)
-{
-	unsigned tmp;
-
-	if (r100_gui_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait GUI idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-
-	rv515_vga_render_disable(rdev);
-
-	tmp = RREG32(AVIVO_D1VGA_CONTROL);
-	WREG32(AVIVO_D1VGA_CONTROL, tmp & ~AVIVO_DVGA_CONTROL_MODE_ENABLE);
-	tmp = RREG32(AVIVO_D2VGA_CONTROL);
-	WREG32(AVIVO_D2VGA_CONTROL, tmp & ~AVIVO_DVGA_CONTROL_MODE_ENABLE);
-
-	tmp = RREG32(AVIVO_D1CRTC_CONTROL);
-	WREG32(AVIVO_D1CRTC_CONTROL, tmp & ~AVIVO_CRTC_EN);
-	tmp = RREG32(AVIVO_D2CRTC_CONTROL);
-	WREG32(AVIVO_D2CRTC_CONTROL, tmp & ~AVIVO_CRTC_EN);
-
-	/* make sure all previous write got through */
-	tmp = RREG32(AVIVO_D2CRTC_CONTROL);
-
-	mdelay(1);
-}
-
-int rs600_mc_init(struct radeon_device *rdev)
-{
-	uint32_t tmp;
-	int r;
-
-	if (r100_debugfs_rbbm_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-	}
-
-	rs600_gpu_init(rdev);
-	rs600_gart_disable(rdev);
-
-	/* Setup GPU memory space */
-	rdev->mc.vram_location = 0xFFFFFFFFUL;
-	rdev->mc.gtt_location = 0xFFFFFFFFUL;
-	r = radeon_mc_setup(rdev);
-	if (r) {
-		return r;
-	}
-
-	/* Program GPU memory space */
-	/* Enable bus master */
-	tmp = RREG32(RADEON_BUS_CNTL) & ~RS600_BUS_MASTER_DIS;
-	WREG32(RADEON_BUS_CNTL, tmp);
-	/* FIXME: What does AGP means for such chipset ? */
-	WREG32_MC(RS600_MC_AGP_LOCATION, 0x0FFFFFFF);
-	/* FIXME: are this AGP reg in indirect MC range ? */
-	WREG32_MC(RS600_MC_AGP_BASE, 0);
-	WREG32_MC(RS600_MC_AGP_BASE_2, 0);
-	rs600_mc_disable_clients(rdev);
-	if (rs600_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-	tmp = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
-	tmp = REG_SET(RS600_MC_FB_TOP, tmp >> 16);
-	tmp |= REG_SET(RS600_MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32_MC(RS600_MC_FB_LOCATION, tmp);
-	WREG32(RS690_HDP_FB_LOCATION, rdev->mc.vram_location >> 16);
-	return 0;
-}
-
-void rs600_mc_fini(struct radeon_device *rdev)
-{
-}
-
-
-/*
- * Interrupts
- */
 int rs600_irq_set(struct radeon_device *rdev)
 {
 	uint32_t tmp = 0;
 	uint32_t mode_int = 0;
 
 	if (rdev->irq.sw_int) {
-		tmp |= RADEON_SW_INT_ENABLE;
+		tmp |= S_000040_SW_INT_EN(1);
 	}
 	if (rdev->irq.crtc_vblank_int[0]) {
-		mode_int |= AVIVO_D1MODE_INT_MASK;
+		mode_int |= S_006540_D1MODE_VBLANK_INT_MASK(1);
 	}
 	if (rdev->irq.crtc_vblank_int[1]) {
-		mode_int |= AVIVO_D2MODE_INT_MASK;
+		mode_int |= S_006540_D2MODE_VBLANK_INT_MASK(1);
 	}
-	WREG32(RADEON_GEN_INT_CNTL, tmp);
-	WREG32(AVIVO_DxMODE_INT_MASK, mode_int);
+	WREG32(R_000040_GEN_INT_CNTL, tmp);
+	WREG32(R_006540_DxMODE_INT_MASK, mode_int);
 	return 0;
 }
 
 static inline uint32_t rs600_irq_ack(struct radeon_device *rdev, u32 *r500_disp_int)
 {
-	uint32_t irqs = RREG32(RADEON_GEN_INT_STATUS);
-	uint32_t irq_mask = RADEON_SW_INT_TEST;
-
-	if (irqs & AVIVO_DISPLAY_INT_STATUS) {
-		*r500_disp_int = RREG32(AVIVO_DISP_INTERRUPT_STATUS);
-		if (*r500_disp_int & AVIVO_D1_VBLANK_INTERRUPT) {
-			WREG32(AVIVO_D1MODE_VBLANK_STATUS, AVIVO_VBLANK_ACK);
+	uint32_t irqs = RREG32(R_000040_GEN_INT_CNTL);
+	uint32_t irq_mask = ~C_000040_SW_INT_EN;
+
+	if (G_000040_DISPLAY_INT_STATUS(irqs)) {
+		*r500_disp_int = RREG32(R_007EDC_DISP_INTERRUPT_STATUS);
+		if (G_007EDC_LB_D1_VBLANK_INTERRUPT(*r500_disp_int)) {
+			WREG32(R_006534_D1MODE_VBLANK_STATUS,
+				S_006534_D1MODE_VBLANK_ACK(1));
 		}
-		if (*r500_disp_int & AVIVO_D2_VBLANK_INTERRUPT) {
-			WREG32(AVIVO_D2MODE_VBLANK_STATUS, AVIVO_VBLANK_ACK);
+		if (G_007EDC_LB_D2_VBLANK_INTERRUPT(*r500_disp_int)) {
+			WREG32(R_006D34_D2MODE_VBLANK_STATUS,
+				S_006D34_D2MODE_VBLANK_ACK(1));
 		}
 	} else {
 		*r500_disp_int = 0;
 	}
 
 	if (irqs) {
-		WREG32(RADEON_GEN_INT_STATUS, irqs);
+		WREG32(R_000040_GEN_INT_CNTL, irqs);
 	}
 	return irqs & irq_mask;
 }
@@ -317,16 +240,13 @@ int rs600_irq_process(struct radeon_device *rdev)
 	}
 	while (status || r500_disp_int) {
 		/* SW interrupt */
-		if (status & RADEON_SW_INT_TEST) {
+		if (G_000040_SW_INT_EN(status))
 			radeon_fence_process(rdev);
-		}
 		/* Vertical blank interrupts */
-		if (r500_disp_int & AVIVO_D1_VBLANK_INTERRUPT) {
+		if (G_007EDC_LB_D1_VBLANK_INTERRUPT(r500_disp_int))
 			drm_handle_vblank(rdev->ddev, 0);
-		}
-		if (r500_disp_int & AVIVO_D2_VBLANK_INTERRUPT) {
+		if (G_007EDC_LB_D2_VBLANK_INTERRUPT(r500_disp_int))
 			drm_handle_vblank(rdev->ddev, 1);
-		}
 		status = rs600_irq_ack(rdev, &r500_disp_int);
 	}
 	return IRQ_HANDLED;
@@ -335,53 +255,34 @@ int rs600_irq_process(struct radeon_device *rdev)
 u32 rs600_get_vblank_counter(struct radeon_device *rdev, int crtc)
 {
 	if (crtc == 0)
-		return RREG32(AVIVO_D1CRTC_FRAME_COUNT);
+		return RREG32(R_0060A4_D1CRTC_STATUS_FRAME_COUNT);
 	else
-		return RREG32(AVIVO_D2CRTC_FRAME_COUNT);
+		return RREG32(R_0068A4_D2CRTC_STATUS_FRAME_COUNT);
 }
 
-
-/*
- * Global GPU functions
- */
 int rs600_mc_wait_for_idle(struct radeon_device *rdev)
 {
 	unsigned i;
-	uint32_t tmp;
 
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		/* read MC_STATUS */
-		tmp = RREG32_MC(RS600_MC_STATUS);
-		if (tmp & RS600_MC_STATUS_IDLE) {
+		if (G_000000_MC_IDLE(RREG32_MC(R_000000_MC_STATUS)))
 			return 0;
-		}
-		DRM_UDELAY(1);
+		udelay(1);
 	}
 	return -1;
 }
 
-void rs600_errata(struct radeon_device *rdev)
-{
-	rdev->pll_errata = 0;
-}
-
 void rs600_gpu_init(struct radeon_device *rdev)
 {
 	/* FIXME: HDP same place on rs600 ? */
 	r100_hdp_reset(rdev);
-	rv515_vga_render_disable(rdev);
 	/* FIXME: is this correct ? */
 	r420_pipes_init(rdev);
-	if (rs600_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
+	/* Wait for mc idle */
+	if (rs600_mc_wait_for_idle(rdev))
+		dev_warn(rdev->dev, "Wait MC idle timeout before updating MC.\n");
 }
 
-
-/*
- * VRAM info.
- */
 void rs600_vram_info(struct radeon_device *rdev)
 {
 	/* FIXME: to do or is these values sane ? */
@@ -394,26 +295,24 @@ void rs600_bandwidth_update(struct radeon_device *rdev)
 	/* FIXME: implement, should this be like rs690 ? */
 }
 
-
-/*
- * Indirect registers accessor
- */
 uint32_t rs600_mc_rreg(struct radeon_device *rdev, uint32_t reg)
 {
-	uint32_t r;
-
-	WREG32(RS600_MC_INDEX,
-	       ((reg & RS600_MC_ADDR_MASK) | RS600_MC_IND_CITF_ARB0));
-	r = RREG32(RS600_MC_DATA);
-	return r;
+	WREG32(R_000070_MC_IND_INDEX, S_000070_MC_IND_ADDR(reg) |
+		S_000070_MC_IND_CITF_ARB0(1));
+	return RREG32(R_000074_MC_IND_DATA);
 }
 
 void rs600_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 {
-	WREG32(RS600_MC_INDEX,
-		RS600_MC_IND_WR_EN | RS600_MC_IND_CITF_ARB0 |
-		((reg) & RS600_MC_ADDR_MASK));
-	WREG32(RS600_MC_DATA, v);
+	WREG32(R_000070_MC_IND_INDEX, S_000070_MC_IND_ADDR(reg) |
+		S_000070_MC_IND_CITF_ARB0(1) | S_000070_MC_IND_WR_EN(1));
+	WREG32(R_000074_MC_IND_DATA, v);
+}
+
+void rs600_debugfs(struct radeon_device *rdev)
+{
+	if (r100_debugfs_rbbm_init(rdev))
+		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
 }
 
 void rs600_set_safe_registers(struct radeon_device *rdev)
@@ -422,8 +321,181 @@ void rs600_set_safe_registers(struct radeon_device *rdev)
 	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(rs600_reg_safe_bm);
 }
 
+static void rs600_mc_program(struct radeon_device *rdev)
+{
+	struct rv515_mc_save save;
+
+	/* Stops all mc clients */
+	rv515_mc_stop(rdev, &save);
+
+	/* Wait for mc idle */
+	if (rs600_mc_wait_for_idle(rdev))
+		dev_warn(rdev->dev, "Wait MC idle timeout before updating MC.\n");
+
+	/* FIXME: What does AGP means for such chipset ? */
+	WREG32_MC(R_000005_MC_AGP_LOCATION, 0x0FFFFFFF);
+	WREG32_MC(R_000006_AGP_BASE, 0);
+	WREG32_MC(R_000007_AGP_BASE_2, 0);
+	/* Program MC */
+	WREG32_MC(R_000004_MC_FB_LOCATION,
+			S_000004_MC_FB_START(rdev->mc.vram_start >> 16) |
+			S_000004_MC_FB_TOP(rdev->mc.vram_end >> 16));
+	WREG32(R_000134_HDP_FB_LOCATION,
+		S_000134_HDP_FB_START(rdev->mc.vram_start >> 16));
+
+	rv515_mc_resume(rdev, &save);
+}
+
+static int rs600_startup(struct radeon_device *rdev)
+{
+	int r;
+
+	rs600_mc_program(rdev);
+	/* Resume clock */
+	rv515_clock_startup(rdev);
+	/* Initialize GPU configuration (# pipes, ...) */
+	rs600_gpu_init(rdev);
+	/* Initialize GART (initialize after TTM so we can allocate
+	 * memory through TTM but finalize after TTM) */
+	r = rs600_gart_enable(rdev);
+	if (r)
+		return r;
+	/* Enable IRQ */
+	rdev->irq.sw_int = true;
+	rs600_irq_set(rdev);
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
+int rs600_resume(struct radeon_device *rdev)
+{
+	/* Make sur GART are not working */
+	rs600_gart_disable(rdev);
+	/* Resume clock before doing reset */
+	rv515_clock_startup(rdev);
+	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
+	if (radeon_gpu_reset(rdev)) {
+		dev_warn(rdev->dev, "GPU reset failed ! (0xE40=0x%08X, 0x7C0=0x%08X)\n",
+			RREG32(R_000E40_RBBM_STATUS),
+			RREG32(R_0007C0_CP_STAT));
+	}
+	/* post */
+	atom_asic_init(rdev->mode_info.atom_context);
+	/* Resume clock after posting */
+	rv515_clock_startup(rdev);
+	return rs600_startup(rdev);
+}
+
+int rs600_suspend(struct radeon_device *rdev)
+{
+	r100_cp_disable(rdev);
+	r100_wb_disable(rdev);
+	r100_irq_disable(rdev);
+	rs600_gart_disable(rdev);
+	return 0;
+}
+
+void rs600_fini(struct radeon_device *rdev)
+{
+	rs600_suspend(rdev);
+	r100_cp_fini(rdev);
+	r100_wb_fini(rdev);
+	r100_ib_fini(rdev);
+	radeon_gem_fini(rdev);
+	rs600_gart_fini(rdev);
+	radeon_irq_kms_fini(rdev);
+	radeon_fence_driver_fini(rdev);
+	radeon_object_fini(rdev);
+	radeon_atombios_fini(rdev);
+	kfree(rdev->bios);
+	rdev->bios = NULL;
+}
+
 int rs600_init(struct radeon_device *rdev)
 {
-    rs600_set_safe_registers(rdev);
+	int r;
+
+	rdev->new_init_path = true;
+	/* Disable VGA */
+	rv515_vga_render_disable(rdev);
+	/* Initialize scratch registers */
+	radeon_scratch_init(rdev);
+	/* Initialize surface registers */
+	radeon_surface_init(rdev);
+	/* BIOS */
+	if (!radeon_get_bios(rdev)) {
+		if (ASIC_IS_AVIVO(rdev))
+			return -EINVAL;
+	}
+	if (rdev->is_atom_bios) {
+		r = radeon_atombios_init(rdev);
+		if (r)
+			return r;
+	} else {
+		dev_err(rdev->dev, "Expecting atombios for RS600 GPU\n");
+		return -EINVAL;
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
+		atom_asic_init(rdev->mode_info.atom_context);
+	}
+	/* Initialize clocks */
+	radeon_get_clock_info(rdev->ddev);
+	/* Get vram informations */
+	rs600_vram_info(rdev);
+	/* Initialize memory controller (also test AGP) */
+	r = r420_mc_init(rdev);
+	if (r)
+		return r;
+	rs600_debugfs(rdev);
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
+	r = rs600_gart_init(rdev);
+	if (r)
+		return r;
+	rs600_set_safe_registers(rdev);
+	rdev->accel_working = true;
+	r = rs600_startup(rdev);
+	if (r) {
+		/* Somethings want wront with the accel init stop accel */
+		dev_err(rdev->dev, "Disabling GPU acceleration\n");
+		rs600_suspend(rdev);
+		r100_cp_fini(rdev);
+		r100_wb_fini(rdev);
+		r100_ib_fini(rdev);
+		rs600_gart_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
+	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/rs600d.h b/drivers/gpu/drm/radeon/rs600d.h
new file mode 100644
index 0000000..6dac524
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rs600d.h
@@ -0,0 +1,406 @@
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
+#ifndef __RS600D_H__
+#define __RS600D_H__
+
+/* Registers */
+#define R_000040_GEN_INT_CNTL                        0x000040
+#define   S_000040_DISPLAY_INT_STATUS(x)               (((x) & 0x1) << 0)
+#define   G_000040_DISPLAY_INT_STATUS(x)               (((x) >> 0) & 0x1)
+#define   C_000040_DISPLAY_INT_STATUS                  0xFFFFFFFE
+#define   S_000040_DMA_VIPH0_INT_EN(x)                 (((x) & 0x1) << 12)
+#define   G_000040_DMA_VIPH0_INT_EN(x)                 (((x) >> 12) & 0x1)
+#define   C_000040_DMA_VIPH0_INT_EN                    0xFFFFEFFF
+#define   S_000040_CRTC2_VSYNC(x)                      (((x) & 0x1) << 6)
+#define   G_000040_CRTC2_VSYNC(x)                      (((x) >> 6) & 0x1)
+#define   C_000040_CRTC2_VSYNC                         0xFFFFFFBF
+#define   S_000040_SNAPSHOT2(x)                        (((x) & 0x1) << 7)
+#define   G_000040_SNAPSHOT2(x)                        (((x) >> 7) & 0x1)
+#define   C_000040_SNAPSHOT2                           0xFFFFFF7F
+#define   S_000040_CRTC2_VBLANK(x)                     (((x) & 0x1) << 9)
+#define   G_000040_CRTC2_VBLANK(x)                     (((x) >> 9) & 0x1)
+#define   C_000040_CRTC2_VBLANK                        0xFFFFFDFF
+#define   S_000040_FP2_DETECT(x)                       (((x) & 0x1) << 10)
+#define   G_000040_FP2_DETECT(x)                       (((x) >> 10) & 0x1)
+#define   C_000040_FP2_DETECT                          0xFFFFFBFF
+#define   S_000040_VSYNC_DIFF_OVER_LIMIT(x)            (((x) & 0x1) << 11)
+#define   G_000040_VSYNC_DIFF_OVER_LIMIT(x)            (((x) >> 11) & 0x1)
+#define   C_000040_VSYNC_DIFF_OVER_LIMIT               0xFFFFF7FF
+#define   S_000040_DMA_VIPH1_INT_EN(x)                 (((x) & 0x1) << 13)
+#define   G_000040_DMA_VIPH1_INT_EN(x)                 (((x) >> 13) & 0x1)
+#define   C_000040_DMA_VIPH1_INT_EN                    0xFFFFDFFF
+#define   S_000040_DMA_VIPH2_INT_EN(x)                 (((x) & 0x1) << 14)
+#define   G_000040_DMA_VIPH2_INT_EN(x)                 (((x) >> 14) & 0x1)
+#define   C_000040_DMA_VIPH2_INT_EN                    0xFFFFBFFF
+#define   S_000040_DMA_VIPH3_INT_EN(x)                 (((x) & 0x1) << 15)
+#define   G_000040_DMA_VIPH3_INT_EN(x)                 (((x) >> 15) & 0x1)
+#define   C_000040_DMA_VIPH3_INT_EN                    0xFFFF7FFF
+#define   S_000040_I2C_INT_EN(x)                       (((x) & 0x1) << 17)
+#define   G_000040_I2C_INT_EN(x)                       (((x) >> 17) & 0x1)
+#define   C_000040_I2C_INT_EN                          0xFFFDFFFF
+#define   S_000040_GUI_IDLE(x)                         (((x) & 0x1) << 19)
+#define   G_000040_GUI_IDLE(x)                         (((x) >> 19) & 0x1)
+#define   C_000040_GUI_IDLE                            0xFFF7FFFF
+#define   S_000040_VIPH_INT_EN(x)                      (((x) & 0x1) << 24)
+#define   G_000040_VIPH_INT_EN(x)                      (((x) >> 24) & 0x1)
+#define   C_000040_VIPH_INT_EN                         0xFEFFFFFF
+#define   S_000040_SW_INT_EN(x)                        (((x) & 0x1) << 25)
+#define   G_000040_SW_INT_EN(x)                        (((x) >> 25) & 0x1)
+#define   C_000040_SW_INT_EN                           0xFDFFFFFF
+#define   S_000040_GEYSERVILLE(x)                      (((x) & 0x1) << 27)
+#define   G_000040_GEYSERVILLE(x)                      (((x) >> 27) & 0x1)
+#define   C_000040_GEYSERVILLE                         0xF7FFFFFF
+#define   S_000040_HDCP_AUTHORIZED_INT(x)              (((x) & 0x1) << 28)
+#define   G_000040_HDCP_AUTHORIZED_INT(x)              (((x) >> 28) & 0x1)
+#define   C_000040_HDCP_AUTHORIZED_INT                 0xEFFFFFFF
+#define   S_000040_DVI_I2C_INT(x)                      (((x) & 0x1) << 29)
+#define   G_000040_DVI_I2C_INT(x)                      (((x) >> 29) & 0x1)
+#define   C_000040_DVI_I2C_INT                         0xDFFFFFFF
+#define   S_000040_GUIDMA(x)                           (((x) & 0x1) << 30)
+#define   G_000040_GUIDMA(x)                           (((x) >> 30) & 0x1)
+#define   C_000040_GUIDMA                              0xBFFFFFFF
+#define   S_000040_VIDDMA(x)                           (((x) & 0x1) << 31)
+#define   G_000040_VIDDMA(x)                           (((x) >> 31) & 0x1)
+#define   C_000040_VIDDMA                              0x7FFFFFFF
+#define R_00004C_BUS_CNTL                            0x00004C
+#define   S_00004C_BUS_MASTER_DIS(x)                   (((x) & 0x1) << 14)
+#define   G_00004C_BUS_MASTER_DIS(x)                   (((x) >> 14) & 0x1)
+#define   C_00004C_BUS_MASTER_DIS                      0xFFFFBFFF
+#define   S_00004C_BUS_MSI_REARM(x)                    (((x) & 0x1) << 20)
+#define   G_00004C_BUS_MSI_REARM(x)                    (((x) >> 20) & 0x1)
+#define   C_00004C_BUS_MSI_REARM                       0xFFEFFFFF
+#define R_000070_MC_IND_INDEX                        0x000070
+#define   S_000070_MC_IND_ADDR(x)                      (((x) & 0xFFFF) << 0)
+#define   G_000070_MC_IND_ADDR(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_000070_MC_IND_ADDR                         0xFFFF0000
+#define   S_000070_MC_IND_SEQ_RBS_0(x)                 (((x) & 0x1) << 16)
+#define   G_000070_MC_IND_SEQ_RBS_0(x)                 (((x) >> 16) & 0x1)
+#define   C_000070_MC_IND_SEQ_RBS_0                    0xFFFEFFFF
+#define   S_000070_MC_IND_SEQ_RBS_1(x)                 (((x) & 0x1) << 17)
+#define   G_000070_MC_IND_SEQ_RBS_1(x)                 (((x) >> 17) & 0x1)
+#define   C_000070_MC_IND_SEQ_RBS_1                    0xFFFDFFFF
+#define   S_000070_MC_IND_SEQ_RBS_2(x)                 (((x) & 0x1) << 18)
+#define   G_000070_MC_IND_SEQ_RBS_2(x)                 (((x) >> 18) & 0x1)
+#define   C_000070_MC_IND_SEQ_RBS_2                    0xFFFBFFFF
+#define   S_000070_MC_IND_SEQ_RBS_3(x)                 (((x) & 0x1) << 19)
+#define   G_000070_MC_IND_SEQ_RBS_3(x)                 (((x) >> 19) & 0x1)
+#define   C_000070_MC_IND_SEQ_RBS_3                    0xFFF7FFFF
+#define   S_000070_MC_IND_AIC_RBS(x)                   (((x) & 0x1) << 20)
+#define   G_000070_MC_IND_AIC_RBS(x)                   (((x) >> 20) & 0x1)
+#define   C_000070_MC_IND_AIC_RBS                      0xFFEFFFFF
+#define   S_000070_MC_IND_CITF_ARB0(x)                 (((x) & 0x1) << 21)
+#define   G_000070_MC_IND_CITF_ARB0(x)                 (((x) >> 21) & 0x1)
+#define   C_000070_MC_IND_CITF_ARB0                    0xFFDFFFFF
+#define   S_000070_MC_IND_CITF_ARB1(x)                 (((x) & 0x1) << 22)
+#define   G_000070_MC_IND_CITF_ARB1(x)                 (((x) >> 22) & 0x1)
+#define   C_000070_MC_IND_CITF_ARB1                    0xFFBFFFFF
+#define   S_000070_MC_IND_WR_EN(x)                     (((x) & 0x1) << 23)
+#define   G_000070_MC_IND_WR_EN(x)                     (((x) >> 23) & 0x1)
+#define   C_000070_MC_IND_WR_EN                        0xFF7FFFFF
+#define   S_000070_MC_IND_RD_INV(x)                    (((x) & 0x1) << 24)
+#define   G_000070_MC_IND_RD_INV(x)                    (((x) >> 24) & 0x1)
+#define   C_000070_MC_IND_RD_INV                       0xFEFFFFFF
+#define R_000074_MC_IND_DATA                         0x000074
+#define   S_000074_MC_IND_DATA(x)                      (((x) & 0xFFFFFFFF) << 0)
+#define   G_000074_MC_IND_DATA(x)                      (((x) >> 0) & 0xFFFFFFFF)
+#define   C_000074_MC_IND_DATA                         0x00000000
+#define R_000134_HDP_FB_LOCATION                     0x000134
+#define   S_000134_HDP_FB_START(x)                     (((x) & 0xFFFF) << 0)
+#define   G_000134_HDP_FB_START(x)                     (((x) >> 0) & 0xFFFF)
+#define   C_000134_HDP_FB_START                        0xFFFF0000
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
+#define   S_0007C0_CSF_INDIRECT2_BUSY(x)               (((x) & 0x1) << 14)
+#define   G_0007C0_CSF_INDIRECT2_BUSY(x)               (((x) >> 14) & 0x1)
+#define   C_0007C0_CSF_INDIRECT2_BUSY                  0xFFFFBFFF
+#define   S_0007C0_CSQ_INDIRECT2_BUSY(x)               (((x) & 0x1) << 15)
+#define   G_0007C0_CSQ_INDIRECT2_BUSY(x)               (((x) >> 15) & 0x1)
+#define   C_0007C0_CSQ_INDIRECT2_BUSY                  0xFFFF7FFF
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
+#define R_000E40_RBBM_STATUS                         0x000E40
+#define   S_000E40_CMDFIFO_AVAIL(x)                    (((x) & 0x7F) << 0)
+#define   G_000E40_CMDFIFO_AVAIL(x)                    (((x) >> 0) & 0x7F)
+#define   C_000E40_CMDFIFO_AVAIL                       0xFFFFFF80
+#define   S_000E40_HIRQ_ON_RBB(x)                      (((x) & 0x1) << 8)
+#define   G_000E40_HIRQ_ON_RBB(x)                      (((x) >> 8) & 0x1)
+#define   C_000E40_HIRQ_ON_RBB                         0xFFFFFEFF
+#define   S_000E40_CPRQ_ON_RBB(x)                      (((x) & 0x1) << 9)
+#define   G_000E40_CPRQ_ON_RBB(x)                      (((x) >> 9) & 0x1)
+#define   C_000E40_CPRQ_ON_RBB                         0xFFFFFDFF
+#define   S_000E40_CFRQ_ON_RBB(x)                      (((x) & 0x1) << 10)
+#define   G_000E40_CFRQ_ON_RBB(x)                      (((x) >> 10) & 0x1)
+#define   C_000E40_CFRQ_ON_RBB                         0xFFFFFBFF
+#define   S_000E40_HIRQ_IN_RTBUF(x)                    (((x) & 0x1) << 11)
+#define   G_000E40_HIRQ_IN_RTBUF(x)                    (((x) >> 11) & 0x1)
+#define   C_000E40_HIRQ_IN_RTBUF                       0xFFFFF7FF
+#define   S_000E40_CPRQ_IN_RTBUF(x)                    (((x) & 0x1) << 12)
+#define   G_000E40_CPRQ_IN_RTBUF(x)                    (((x) >> 12) & 0x1)
+#define   C_000E40_CPRQ_IN_RTBUF                       0xFFFFEFFF
+#define   S_000E40_CFRQ_IN_RTBUF(x)                    (((x) & 0x1) << 13)
+#define   G_000E40_CFRQ_IN_RTBUF(x)                    (((x) >> 13) & 0x1)
+#define   C_000E40_CFRQ_IN_RTBUF                       0xFFFFDFFF
+#define   S_000E40_CF_PIPE_BUSY(x)                     (((x) & 0x1) << 14)
+#define   G_000E40_CF_PIPE_BUSY(x)                     (((x) >> 14) & 0x1)
+#define   C_000E40_CF_PIPE_BUSY                        0xFFFFBFFF
+#define   S_000E40_ENG_EV_BUSY(x)                      (((x) & 0x1) << 15)
+#define   G_000E40_ENG_EV_BUSY(x)                      (((x) >> 15) & 0x1)
+#define   C_000E40_ENG_EV_BUSY                         0xFFFF7FFF
+#define   S_000E40_CP_CMDSTRM_BUSY(x)                  (((x) & 0x1) << 16)
+#define   G_000E40_CP_CMDSTRM_BUSY(x)                  (((x) >> 16) & 0x1)
+#define   C_000E40_CP_CMDSTRM_BUSY                     0xFFFEFFFF
+#define   S_000E40_E2_BUSY(x)                          (((x) & 0x1) << 17)
+#define   G_000E40_E2_BUSY(x)                          (((x) >> 17) & 0x1)
+#define   C_000E40_E2_BUSY                             0xFFFDFFFF
+#define   S_000E40_RB2D_BUSY(x)                        (((x) & 0x1) << 18)
+#define   G_000E40_RB2D_BUSY(x)                        (((x) >> 18) & 0x1)
+#define   C_000E40_RB2D_BUSY                           0xFFFBFFFF
+#define   S_000E40_RB3D_BUSY(x)                        (((x) & 0x1) << 19)
+#define   G_000E40_RB3D_BUSY(x)                        (((x) >> 19) & 0x1)
+#define   C_000E40_RB3D_BUSY                           0xFFF7FFFF
+#define   S_000E40_VAP_BUSY(x)                         (((x) & 0x1) << 20)
+#define   G_000E40_VAP_BUSY(x)                         (((x) >> 20) & 0x1)
+#define   C_000E40_VAP_BUSY                            0xFFEFFFFF
+#define   S_000E40_RE_BUSY(x)                          (((x) & 0x1) << 21)
+#define   G_000E40_RE_BUSY(x)                          (((x) >> 21) & 0x1)
+#define   C_000E40_RE_BUSY                             0xFFDFFFFF
+#define   S_000E40_TAM_BUSY(x)                         (((x) & 0x1) << 22)
+#define   G_000E40_TAM_BUSY(x)                         (((x) >> 22) & 0x1)
+#define   C_000E40_TAM_BUSY                            0xFFBFFFFF
+#define   S_000E40_TDM_BUSY(x)                         (((x) & 0x1) << 23)
+#define   G_000E40_TDM_BUSY(x)                         (((x) >> 23) & 0x1)
+#define   C_000E40_TDM_BUSY                            0xFF7FFFFF
+#define   S_000E40_PB_BUSY(x)                          (((x) & 0x1) << 24)
+#define   G_000E40_PB_BUSY(x)                          (((x) >> 24) & 0x1)
+#define   C_000E40_PB_BUSY                             0xFEFFFFFF
+#define   S_000E40_TIM_BUSY(x)                         (((x) & 0x1) << 25)
+#define   G_000E40_TIM_BUSY(x)                         (((x) >> 25) & 0x1)
+#define   C_000E40_TIM_BUSY                            0xFDFFFFFF
+#define   S_000E40_GA_BUSY(x)                          (((x) & 0x1) << 26)
+#define   G_000E40_GA_BUSY(x)                          (((x) >> 26) & 0x1)
+#define   C_000E40_GA_BUSY                             0xFBFFFFFF
+#define   S_000E40_CBA2D_BUSY(x)                       (((x) & 0x1) << 27)
+#define   G_000E40_CBA2D_BUSY(x)                       (((x) >> 27) & 0x1)
+#define   C_000E40_CBA2D_BUSY                          0xF7FFFFFF
+#define   S_000E40_GUI_ACTIVE(x)                       (((x) & 0x1) << 31)
+#define   G_000E40_GUI_ACTIVE(x)                       (((x) >> 31) & 0x1)
+#define   C_000E40_GUI_ACTIVE                          0x7FFFFFFF
+#define R_0060A4_D1CRTC_STATUS_FRAME_COUNT           0x0060A4
+#define   S_0060A4_D1CRTC_FRAME_COUNT(x)               (((x) & 0xFFFFFF) << 0)
+#define   G_0060A4_D1CRTC_FRAME_COUNT(x)               (((x) >> 0) & 0xFFFFFF)
+#define   C_0060A4_D1CRTC_FRAME_COUNT                  0xFF000000
+#define R_006534_D1MODE_VBLANK_STATUS                0x006534
+#define   S_006534_D1MODE_VBLANK_OCCURRED(x)           (((x) & 0x1) << 0)
+#define   G_006534_D1MODE_VBLANK_OCCURRED(x)           (((x) >> 0) & 0x1)
+#define   C_006534_D1MODE_VBLANK_OCCURRED              0xFFFFFFFE
+#define   S_006534_D1MODE_VBLANK_ACK(x)                (((x) & 0x1) << 4)
+#define   G_006534_D1MODE_VBLANK_ACK(x)                (((x) >> 4) & 0x1)
+#define   C_006534_D1MODE_VBLANK_ACK                   0xFFFFFFEF
+#define   S_006534_D1MODE_VBLANK_STAT(x)               (((x) & 0x1) << 12)
+#define   G_006534_D1MODE_VBLANK_STAT(x)               (((x) >> 12) & 0x1)
+#define   C_006534_D1MODE_VBLANK_STAT                  0xFFFFEFFF
+#define   S_006534_D1MODE_VBLANK_INTERRUPT(x)          (((x) & 0x1) << 16)
+#define   G_006534_D1MODE_VBLANK_INTERRUPT(x)          (((x) >> 16) & 0x1)
+#define   C_006534_D1MODE_VBLANK_INTERRUPT             0xFFFEFFFF
+#define R_006540_DxMODE_INT_MASK                     0x006540
+#define   S_006540_D1MODE_VBLANK_INT_MASK(x)           (((x) & 0x1) << 0)
+#define   G_006540_D1MODE_VBLANK_INT_MASK(x)           (((x) >> 0) & 0x1)
+#define   C_006540_D1MODE_VBLANK_INT_MASK              0xFFFFFFFE
+#define   S_006540_D1MODE_VLINE_INT_MASK(x)            (((x) & 0x1) << 4)
+#define   G_006540_D1MODE_VLINE_INT_MASK(x)            (((x) >> 4) & 0x1)
+#define   C_006540_D1MODE_VLINE_INT_MASK               0xFFFFFFEF
+#define   S_006540_D2MODE_VBLANK_INT_MASK(x)           (((x) & 0x1) << 8)
+#define   G_006540_D2MODE_VBLANK_INT_MASK(x)           (((x) >> 8) & 0x1)
+#define   C_006540_D2MODE_VBLANK_INT_MASK              0xFFFFFEFF
+#define   S_006540_D2MODE_VLINE_INT_MASK(x)            (((x) & 0x1) << 12)
+#define   G_006540_D2MODE_VLINE_INT_MASK(x)            (((x) >> 12) & 0x1)
+#define   C_006540_D2MODE_VLINE_INT_MASK               0xFFFFEFFF
+#define   S_006540_D1MODE_VBLANK_CP_SEL(x)             (((x) & 0x1) << 30)
+#define   G_006540_D1MODE_VBLANK_CP_SEL(x)             (((x) >> 30) & 0x1)
+#define   C_006540_D1MODE_VBLANK_CP_SEL                0xBFFFFFFF
+#define   S_006540_D2MODE_VBLANK_CP_SEL(x)             (((x) & 0x1) << 31)
+#define   G_006540_D2MODE_VBLANK_CP_SEL(x)             (((x) >> 31) & 0x1)
+#define   C_006540_D2MODE_VBLANK_CP_SEL                0x7FFFFFFF
+#define R_0068A4_D2CRTC_STATUS_FRAME_COUNT           0x0068A4
+#define   S_0068A4_D2CRTC_FRAME_COUNT(x)               (((x) & 0xFFFFFF) << 0)
+#define   G_0068A4_D2CRTC_FRAME_COUNT(x)               (((x) >> 0) & 0xFFFFFF)
+#define   C_0068A4_D2CRTC_FRAME_COUNT                  0xFF000000
+#define R_006D34_D2MODE_VBLANK_STATUS                0x006D34
+#define   S_006D34_D2MODE_VBLANK_OCCURRED(x)           (((x) & 0x1) << 0)
+#define   G_006D34_D2MODE_VBLANK_OCCURRED(x)           (((x) >> 0) & 0x1)
+#define   C_006D34_D2MODE_VBLANK_OCCURRED              0xFFFFFFFE
+#define   S_006D34_D2MODE_VBLANK_ACK(x)                (((x) & 0x1) << 4)
+#define   G_006D34_D2MODE_VBLANK_ACK(x)                (((x) >> 4) & 0x1)
+#define   C_006D34_D2MODE_VBLANK_ACK                   0xFFFFFFEF
+#define   S_006D34_D2MODE_VBLANK_STAT(x)               (((x) & 0x1) << 12)
+#define   G_006D34_D2MODE_VBLANK_STAT(x)               (((x) >> 12) & 0x1)
+#define   C_006D34_D2MODE_VBLANK_STAT                  0xFFFFEFFF
+#define   S_006D34_D2MODE_VBLANK_INTERRUPT(x)          (((x) & 0x1) << 16)
+#define   G_006D34_D2MODE_VBLANK_INTERRUPT(x)          (((x) >> 16) & 0x1)
+#define   C_006D34_D2MODE_VBLANK_INTERRUPT             0xFFFEFFFF
+#define R_007EDC_DISP_INTERRUPT_STATUS               0x007EDC
+#define   S_007EDC_LB_D1_VBLANK_INTERRUPT(x)           (((x) & 0x1) << 4)
+#define   G_007EDC_LB_D1_VBLANK_INTERRUPT(x)           (((x) >> 4) & 0x1)
+#define   C_007EDC_LB_D1_VBLANK_INTERRUPT              0xFFFFFFEF
+#define   S_007EDC_LB_D2_VBLANK_INTERRUPT(x)           (((x) & 0x1) << 5)
+#define   G_007EDC_LB_D2_VBLANK_INTERRUPT(x)           (((x) >> 5) & 0x1)
+#define   C_007EDC_LB_D2_VBLANK_INTERRUPT              0xFFFFFFDF
+
+
+/* MC registers */
+#define R_000000_MC_STATUS                           0x000000
+#define   S_000000_MC_IDLE(x)                          (((x) & 0x1) << 0)
+#define   G_000000_MC_IDLE(x)                          (((x) >> 0) & 0x1)
+#define   C_000000_MC_IDLE                             0xFFFFFFFE
+#define R_000004_MC_FB_LOCATION                      0x000004
+#define   S_000004_MC_FB_START(x)                      (((x) & 0xFFFF) << 0)
+#define   G_000004_MC_FB_START(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_000004_MC_FB_START                         0xFFFF0000
+#define   S_000004_MC_FB_TOP(x)                        (((x) & 0xFFFF) << 16)
+#define   G_000004_MC_FB_TOP(x)                        (((x) >> 16) & 0xFFFF)
+#define   C_000004_MC_FB_TOP                           0x0000FFFF
+#define R_000005_MC_AGP_LOCATION                     0x000005
+#define   S_000005_MC_AGP_START(x)                     (((x) & 0xFFFF) << 0)
+#define   G_000005_MC_AGP_START(x)                     (((x) >> 0) & 0xFFFF)
+#define   C_000005_MC_AGP_START                        0xFFFF0000
+#define   S_000005_MC_AGP_TOP(x)                       (((x) & 0xFFFF) << 16)
+#define   G_000005_MC_AGP_TOP(x)                       (((x) >> 16) & 0xFFFF)
+#define   C_000005_MC_AGP_TOP                          0x0000FFFF
+#define R_000006_AGP_BASE                            0x000006
+#define   S_000006_AGP_BASE_ADDR(x)                    (((x) & 0xFFFFFFFF) << 0)
+#define   G_000006_AGP_BASE_ADDR(x)                    (((x) >> 0) & 0xFFFFFFFF)
+#define   C_000006_AGP_BASE_ADDR                       0x00000000
+#define R_000007_AGP_BASE_2                          0x000007
+#define   S_000007_AGP_BASE_ADDR_2(x)                  (((x) & 0xF) << 0)
+#define   G_000007_AGP_BASE_ADDR_2(x)                  (((x) >> 0) & 0xF)
+#define   C_000007_AGP_BASE_ADDR_2                     0xFFFFFFF0
+#define R_000009_MC_CNTL1                            0x000009
+#define   S_000009_ENABLE_PAGE_TABLES(x)               (((x) & 0x1) << 26)
+#define   G_000009_ENABLE_PAGE_TABLES(x)               (((x) >> 26) & 0x1)
+#define   C_000009_ENABLE_PAGE_TABLES                  0xFBFFFFFF
+/* FIXME don't know the various field size need feedback from AMD */
+#define R_000100_MC_PT0_CNTL                         0x000100
+#define   S_000100_ENABLE_PT(x)                        (((x) & 0x1) << 0)
+#define   G_000100_ENABLE_PT(x)                        (((x) >> 0) & 0x1)
+#define   C_000100_ENABLE_PT                           0xFFFFFFFE
+#define   S_000100_EFFECTIVE_L2_CACHE_SIZE(x)          (((x) & 0x7) << 15)
+#define   G_000100_EFFECTIVE_L2_CACHE_SIZE(x)          (((x) >> 15) & 0x7)
+#define   C_000100_EFFECTIVE_L2_CACHE_SIZE             0xFFFC7FFF
+#define   S_000100_EFFECTIVE_L2_QUEUE_SIZE(x)          (((x) & 0x7) << 21)
+#define   G_000100_EFFECTIVE_L2_QUEUE_SIZE(x)          (((x) >> 21) & 0x7)
+#define   C_000100_EFFECTIVE_L2_QUEUE_SIZE             0xFF1FFFFF
+#define   S_000100_INVALIDATE_ALL_L1_TLBS(x)           (((x) & 0x1) << 28)
+#define   G_000100_INVALIDATE_ALL_L1_TLBS(x)           (((x) >> 28) & 0x1)
+#define   C_000100_INVALIDATE_ALL_L1_TLBS              0xEFFFFFFF
+#define   S_000100_INVALIDATE_L2_CACHE(x)              (((x) & 0x1) << 29)
+#define   G_000100_INVALIDATE_L2_CACHE(x)              (((x) >> 29) & 0x1)
+#define   C_000100_INVALIDATE_L2_CACHE                 0xDFFFFFFF
+#define R_000102_MC_PT0_CONTEXT0_CNTL                0x000102
+#define   S_000102_ENABLE_PAGE_TABLE(x)                (((x) & 0x1) << 0)
+#define   G_000102_ENABLE_PAGE_TABLE(x)                (((x) >> 0) & 0x1)
+#define   C_000102_ENABLE_PAGE_TABLE                   0xFFFFFFFE
+#define   S_000102_PAGE_TABLE_DEPTH(x)                 (((x) & 0x3) << 1)
+#define   G_000102_PAGE_TABLE_DEPTH(x)                 (((x) >> 1) & 0x3)
+#define   C_000102_PAGE_TABLE_DEPTH                    0xFFFFFFF9
+#define   V_000102_PAGE_TABLE_FLAT                     0
+/* R600 documentation suggest that this should be a number of pages */
+#define R_000112_MC_PT0_SYSTEM_APERTURE_LOW_ADDR     0x000112
+#define R_000114_MC_PT0_SYSTEM_APERTURE_HIGH_ADDR    0x000114
+#define R_00011C_MC_PT0_CONTEXT0_DEFAULT_READ_ADDR   0x00011C
+#define R_00012C_MC_PT0_CONTEXT0_FLAT_BASE_ADDR      0x00012C
+#define R_00013C_MC_PT0_CONTEXT0_FLAT_START_ADDR     0x00013C
+#define R_00014C_MC_PT0_CONTEXT0_FLAT_END_ADDR       0x00014C
+#define R_00016C_MC_PT0_CLIENT0_CNTL                 0x00016C
+#define   S_00016C_ENABLE_TRANSLATION_MODE_OVERRIDE(x) (((x) & 0x1) << 0)
+#define   G_00016C_ENABLE_TRANSLATION_MODE_OVERRIDE(x) (((x) >> 0) & 0x1)
+#define   C_00016C_ENABLE_TRANSLATION_MODE_OVERRIDE    0xFFFFFFFE
+#define   S_00016C_TRANSLATION_MODE_OVERRIDE(x)        (((x) & 0x1) << 1)
+#define   G_00016C_TRANSLATION_MODE_OVERRIDE(x)        (((x) >> 1) & 0x1)
+#define   C_00016C_TRANSLATION_MODE_OVERRIDE           0xFFFFFFFD
+#define   S_00016C_SYSTEM_ACCESS_MODE_MASK(x)          (((x) & 0x3) << 8)
+#define   G_00016C_SYSTEM_ACCESS_MODE_MASK(x)          (((x) >> 8) & 0x3)
+#define   C_00016C_SYSTEM_ACCESS_MODE_MASK             0xFFFFFCFF
+#define   V_00016C_SYSTEM_ACCESS_MODE_PA_ONLY          0
+#define   V_00016C_SYSTEM_ACCESS_MODE_USE_SYS_MAP      1
+#define   V_00016C_SYSTEM_ACCESS_MODE_IN_SYS           2
+#define   V_00016C_SYSTEM_ACCESS_MODE_NOT_IN_SYS       3
+#define   S_00016C_SYSTEM_APERTURE_UNMAPPED_ACCESS(x)  (((x) & 0x1) << 10)
+#define   G_00016C_SYSTEM_APERTURE_UNMAPPED_ACCESS(x)  (((x) >> 10) & 0x1)
+#define   C_00016C_SYSTEM_APERTURE_UNMAPPED_ACCESS     0xFFFFFBFF
+#define   V_00016C_SYSTEM_APERTURE_UNMAPPED_PASSTHROUGH  0
+#define   V_00016C_SYSTEM_APERTURE_UNMAPPED_DEFAULT_PAGE 1
+#define   S_00016C_EFFECTIVE_L1_CACHE_SIZE(x)          (((x) & 0x7) << 11)
+#define   G_00016C_EFFECTIVE_L1_CACHE_SIZE(x)          (((x) >> 11) & 0x7)
+#define   C_00016C_EFFECTIVE_L1_CACHE_SIZE             0xFFFFC7FF
+#define   S_00016C_ENABLE_FRAGMENT_PROCESSING(x)       (((x) & 0x1) << 14)
+#define   G_00016C_ENABLE_FRAGMENT_PROCESSING(x)       (((x) >> 14) & 0x1)
+#define   C_00016C_ENABLE_FRAGMENT_PROCESSING          0xFFFFBFFF
+#define   S_00016C_EFFECTIVE_L1_QUEUE_SIZE(x)          (((x) & 0x7) << 15)
+#define   G_00016C_EFFECTIVE_L1_QUEUE_SIZE(x)          (((x) >> 15) & 0x7)
+#define   C_00016C_EFFECTIVE_L1_QUEUE_SIZE             0xFFFC7FFF
+#define   S_00016C_INVALIDATE_L1_TLB(x)                (((x) & 0x1) << 20)
+#define   G_00016C_INVALIDATE_L1_TLB(x)                (((x) >> 20) & 0x1)
+#define   C_00016C_INVALIDATE_L1_TLB                   0xFFEFFFFF
+
+#endif
-- 
1.6.4.4

