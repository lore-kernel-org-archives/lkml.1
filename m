Return-Path: <linux-kernel-owner+w=401wt.eu-S1755702AbZJAHjw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702AbZJAHjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 03:39:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755663AbZJAHjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 03:39:51 -0400
Received: from nox.protox.org ([88.191.38.29]:49693 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZJAHju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 03:39:50 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert RS690/RS740 to new init path (V2).
Date: Thu,  1 Oct 2009 09:39:24 +0200
Message-Id: <1254382764-1634-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also cleanup register specific to RS690/RS740. Version 2 add
missing header file for register, remove unecessary call to AGP
function and fix an indentation bug.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon.h      |   10 +
 drivers/gpu/drm/radeon/radeon_asic.h |   41 ++--
 drivers/gpu/drm/radeon/rs600.c       |    7 +-
 drivers/gpu/drm/radeon/rs690.c       |  356 +++++++++++++++++++++------------
 drivers/gpu/drm/radeon/rs690d.h      |  307 +++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/rs690r.h      |   99 ----------
 6 files changed, 571 insertions(+), 249 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/rs690d.h
 delete mode 100644 drivers/gpu/drm/radeon/rs690r.h

diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 7b0965f..1b797d2 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1064,6 +1064,16 @@ extern void rv515_clock_startup(struct radeon_device *rdev);
 extern void rv515_debugfs(struct radeon_device *rdev);
 extern int rv515_suspend(struct radeon_device *rdev);
 
+/* rs400 */
+extern int rs400_gart_init(struct radeon_device *rdev);
+extern int rs400_gart_enable(struct radeon_device *rdev);
+extern void rs400_gart_adjust_size(struct radeon_device *rdev);
+extern void rs400_gart_disable(struct radeon_device *rdev);
+extern void rs400_gart_fini(struct radeon_device *rdev);
+
+/* rs600 */
+extern void rs600_set_safe_registers(struct radeon_device *rdev);
+
 /* rs690, rs740 */
 extern void rs690_line_buffer_adjust(struct radeon_device *rdev,
 					struct drm_display_mode *mode1,
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index bce0cb0..ae6d342 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -361,36 +361,39 @@ static struct radeon_asic rs600_asic = {
 /*
  * rs690,rs740
  */
-void rs690_errata(struct radeon_device *rdev);
-void rs690_vram_info(struct radeon_device *rdev);
-int rs690_mc_init(struct radeon_device *rdev);
-void rs690_mc_fini(struct radeon_device *rdev);
+int rs690_init(struct radeon_device *rdev);
+void rs690_fini(struct radeon_device *rdev);
+int rs690_resume(struct radeon_device *rdev);
+int rs690_suspend(struct radeon_device *rdev);
 uint32_t rs690_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rs690_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void rs690_bandwidth_update(struct radeon_device *rdev);
 static struct radeon_asic rs690_asic = {
-	.init = &rs600_init,
-	.errata = &rs690_errata,
-	.vram_info = &rs690_vram_info,
+	.init = &rs690_init,
+	.fini = &rs690_fini,
+	.suspend = &rs690_suspend,
+	.resume = &rs690_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = &rs690_mc_init,
-	.mc_fini = &rs690_mc_fini,
-	.wb_init = &r100_wb_init,
-	.wb_fini = &r100_wb_fini,
-	.gart_init = &rs400_gart_init,
-	.gart_fini = &rs400_gart_fini,
-	.gart_enable = &rs400_gart_enable,
-	.gart_disable = &rs400_gart_disable,
+	.mc_init = NULL,
+	.mc_fini = NULL,
+	.wb_init = NULL,
+	.wb_fini = NULL,
+	.gart_init = NULL,
+	.gart_fini = NULL,
+	.gart_enable = NULL,
+	.gart_disable = NULL,
 	.gart_tlb_flush = &rs400_gart_tlb_flush,
 	.gart_set_page = &rs400_gart_set_page,
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
index 4a4fe1c..fa8e451 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -416,9 +416,14 @@ void rs600_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 	WREG32(RS600_MC_DATA, v);
 }
 
-int rs600_init(struct radeon_device *rdev)
+void rs600_set_safe_registers(struct radeon_device *rdev)
 {
 	rdev->config.r300.reg_safe_bm = rs600_reg_safe_bm;
 	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(rs600_reg_safe_bm);
+}
+
+int rs600_init(struct radeon_device *rdev)
+{
+    rs600_set_safe_registers(rdev);
 	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 7a0098d..0028db5 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -26,105 +26,29 @@
  *          Jerome Glisse
  */
 #include "drmP.h"
-#include "radeon_reg.h"
 #include "radeon.h"
-#include "rs690r.h"
 #include "atom.h"
-#include "atom-bits.h"
-
-/* rs690,rs740 depends on : */
-void r100_hdp_reset(struct radeon_device *rdev);
-int r300_mc_wait_for_idle(struct radeon_device *rdev);
-void r420_pipes_init(struct radeon_device *rdev);
-void rs400_gart_disable(struct radeon_device *rdev);
-int rs400_gart_enable(struct radeon_device *rdev);
-void rs400_gart_adjust_size(struct radeon_device *rdev);
-void rs600_mc_disable_clients(struct radeon_device *rdev);
-
-/* This files gather functions specifics to :
- * rs690,rs740
- *
- * Some of these functions might be used by newer ASICs.
- */
-void rs690_gpu_init(struct radeon_device *rdev);
-int rs690_mc_wait_for_idle(struct radeon_device *rdev);
-
-
-/*
- * MC functions.
- */
-int rs690_mc_init(struct radeon_device *rdev)
-{
-	uint32_t tmp;
-	int r;
-
-	if (r100_debugfs_rbbm_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-	}
-
-	rs690_gpu_init(rdev);
-	rs400_gart_disable(rdev);
-
-	/* Setup GPU memory space */
-	rdev->mc.gtt_location = rdev->mc.mc_vram_size;
-	rdev->mc.gtt_location += (rdev->mc.gtt_size - 1);
-	rdev->mc.gtt_location &= ~(rdev->mc.gtt_size - 1);
-	rdev->mc.vram_location = 0xFFFFFFFFUL;
-	r = radeon_mc_setup(rdev);
-	if (r) {
-		return r;
-	}
-
-	/* Program GPU memory space */
-	rs600_mc_disable_clients(rdev);
-	if (rs690_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-	tmp = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
-	tmp = REG_SET(RS690_MC_FB_TOP, tmp >> 16);
-	tmp |= REG_SET(RS690_MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32_MC(RS690_MCCFG_FB_LOCATION, tmp);
-	/* FIXME: Does this reg exist on RS480,RS740 ? */
-	WREG32(0x310, rdev->mc.vram_location);
-	WREG32(RS690_HDP_FB_LOCATION, rdev->mc.vram_location >> 16);
-	return 0;
-}
-
-void rs690_mc_fini(struct radeon_device *rdev)
-{
-}
-
+#include "rs690d.h"
 
-/*
- * Global GPU functions
- */
-int rs690_mc_wait_for_idle(struct radeon_device *rdev)
+static int rs690_mc_wait_for_idle(struct radeon_device *rdev)
 {
 	unsigned i;
 	uint32_t tmp;
 
 	for (i = 0; i < rdev->usec_timeout; i++) {
 		/* read MC_STATUS */
-		tmp = RREG32_MC(RS690_MC_STATUS);
-		if (tmp & RS690_MC_STATUS_IDLE) {
+		tmp = RREG32_MC(R_000090_MC_SYSTEM_STATUS);
+		if (G_000090_MC_SYSTEM_IDLE(tmp))
 			return 0;
-		}
-		DRM_UDELAY(1);
+		udelay(1);
 	}
 	return -1;
 }
 
-void rs690_errata(struct radeon_device *rdev)
-{
-	rdev->pll_errata = 0;
-}
-
-void rs690_gpu_init(struct radeon_device *rdev)
+static void rs690_gpu_init(struct radeon_device *rdev)
 {
 	/* FIXME: HDP same place on rs690 ? */
 	r100_hdp_reset(rdev);
-	rv515_vga_render_disable(rdev);
 	/* FIXME: is this correct ? */
 	r420_pipes_init(rdev);
 	if (rs690_mc_wait_for_idle(rdev)) {
@@ -133,10 +57,6 @@ void rs690_gpu_init(struct radeon_device *rdev)
 	}
 }
 
-
-/*
- * VRAM info.
- */
 void rs690_pm_info(struct radeon_device *rdev)
 {
 	int index = GetIndexIntoMasterTable(DATA, IntegratedSystemInfo);
@@ -250,39 +170,39 @@ void rs690_line_buffer_adjust(struct radeon_device *rdev,
 	/*
 	 * Line Buffer Setup
 	 * There is a single line buffer shared by both display controllers.
-	 * DC_LB_MEMORY_SPLIT controls how that line buffer is shared between
+	 * R_006520_DC_LB_MEMORY_SPLIT controls how that line buffer is shared between
 	 * the display controllers.  The paritioning can either be done
 	 * manually or via one of four preset allocations specified in bits 1:0:
 	 *  0 - line buffer is divided in half and shared between crtc
 	 *  1 - D1 gets 3/4 of the line buffer, D2 gets 1/4
 	 *  2 - D1 gets the whole buffer
 	 *  3 - D1 gets 1/4 of the line buffer, D2 gets 3/4
-	 * Setting bit 2 of DC_LB_MEMORY_SPLIT controls switches to manual
+	 * Setting bit 2 of R_006520_DC_LB_MEMORY_SPLIT controls switches to manual
 	 * allocation mode. In manual allocation mode, D1 always starts at 0,
 	 * D1 end/2 is specified in bits 14:4; D2 allocation follows D1.
 	 */
-	tmp = RREG32(DC_LB_MEMORY_SPLIT) & ~DC_LB_MEMORY_SPLIT_MASK;
-	tmp &= ~DC_LB_MEMORY_SPLIT_SHIFT_MODE;
+	tmp = RREG32(R_006520_DC_LB_MEMORY_SPLIT) & C_006520_DC_LB_MEMORY_SPLIT;
+	tmp &= ~C_006520_DC_LB_MEMORY_SPLIT_MODE;
 	/* auto */
 	if (mode1 && mode2) {
 		if (mode1->hdisplay > mode2->hdisplay) {
 			if (mode1->hdisplay > 2560)
-				tmp |= DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q;
+				tmp |= V_006520_DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q;
 			else
-				tmp |= DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
+				tmp |= V_006520_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
 		} else if (mode2->hdisplay > mode1->hdisplay) {
 			if (mode2->hdisplay > 2560)
-				tmp |= DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
+				tmp |= V_006520_DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
 			else
-				tmp |= DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
+				tmp |= V_006520_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
 		} else
-			tmp |= AVIVO_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
+			tmp |= V_006520_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
 	} else if (mode1) {
-		tmp |= DC_LB_MEMORY_SPLIT_D1_ONLY;
+		tmp |= V_006520_DC_LB_MEMORY_SPLIT_D1_ONLY;
 	} else if (mode2) {
-		tmp |= DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
+		tmp |= V_006520_DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
 	}
-	WREG32(DC_LB_MEMORY_SPLIT, tmp);
+	WREG32(R_006520_DC_LB_MEMORY_SPLIT, tmp);
 }
 
 struct rs690_watermark {
@@ -487,28 +407,28 @@ void rs690_bandwidth_update(struct radeon_device *rdev)
 	 * option.
 	 */
 	if (rdev->disp_priority == 2) {
-		tmp = RREG32_MC(MC_INIT_MISC_LAT_TIMER);
-		tmp &= ~MC_DISP1R_INIT_LAT_MASK;
-		tmp &= ~MC_DISP0R_INIT_LAT_MASK;
-		if (mode1)
-			tmp |= (1 << MC_DISP1R_INIT_LAT_SHIFT);
+		tmp = RREG32_MC(R_000104_MC_INIT_MISC_LAT_TIMER);
+		tmp &= C_000104_MC_DISP0R_INIT_LAT;
+		tmp &= C_000104_MC_DISP1R_INIT_LAT;
 		if (mode0)
-			tmp |= (1 << MC_DISP0R_INIT_LAT_SHIFT);
-		WREG32_MC(MC_INIT_MISC_LAT_TIMER, tmp);
+			tmp |= S_000104_MC_DISP0R_INIT_LAT(1);
+		if (mode1)
+			tmp |= S_000104_MC_DISP1R_INIT_LAT(1);
+		WREG32_MC(R_000104_MC_INIT_MISC_LAT_TIMER, tmp);
 	}
 	rs690_line_buffer_adjust(rdev, mode0, mode1);
 
 	if ((rdev->family == CHIP_RS690) || (rdev->family == CHIP_RS740))
-		WREG32(DCP_CONTROL, 0);
+		WREG32(R_006C9C_DCP_CONTROL, 0);
 	if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
-		WREG32(DCP_CONTROL, 2);
+		WREG32(R_006C9C_DCP_CONTROL, 2);
 
 	rs690_crtc_bandwidth_compute(rdev, rdev->mode_info.crtcs[0], &wm0);
 	rs690_crtc_bandwidth_compute(rdev, rdev->mode_info.crtcs[1], &wm1);
 
 	tmp = (wm0.lb_request_fifo_depth - 1);
 	tmp |= (wm1.lb_request_fifo_depth - 1) << 16;
-	WREG32(LB_MAX_REQ_OUTSTANDING, tmp);
+	WREG32(R_006D58_LB_MAX_REQ_OUTSTANDING, tmp);
 
 	if (mode0 && mode1) {
 		if (rfixed_trunc(wm0.dbpp) > 64)
@@ -561,10 +481,10 @@ void rs690_bandwidth_update(struct radeon_device *rdev)
 			priority_mark12.full = 0;
 		if (wm1.priority_mark_max.full > priority_mark12.full)
 			priority_mark12.full = wm1.priority_mark_max.full;
-		WREG32(D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
-		WREG32(D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
-		WREG32(D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
-		WREG32(D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
+		WREG32(R_006548_D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
+		WREG32(R_00654C_D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
+		WREG32(R_006D48_D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
+		WREG32(R_006D4C_D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
 	} else if (mode0) {
 		if (rfixed_trunc(wm0.dbpp) > 64)
 			a.full = rfixed_mul(wm0.dbpp, wm0.num_line_pair);
@@ -591,10 +511,12 @@ void rs690_bandwidth_update(struct radeon_device *rdev)
 			priority_mark02.full = 0;
 		if (wm0.priority_mark_max.full > priority_mark02.full)
 			priority_mark02.full = wm0.priority_mark_max.full;
-		WREG32(D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
-		WREG32(D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
-		WREG32(D2MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
-		WREG32(D2MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
+		WREG32(R_006548_D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
+		WREG32(R_00654C_D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
+		WREG32(R_006D48_D2MODE_PRIORITY_A_CNT,
+			S_006D48_D2MODE_PRIORITY_A_OFF(1));
+		WREG32(R_006D4C_D2MODE_PRIORITY_B_CNT,
+			S_006D4C_D2MODE_PRIORITY_B_OFF(1));
 	} else {
 		if (rfixed_trunc(wm1.dbpp) > 64)
 			a.full = rfixed_mul(wm1.dbpp, wm1.num_line_pair);
@@ -621,30 +543,204 @@ void rs690_bandwidth_update(struct radeon_device *rdev)
 			priority_mark12.full = 0;
 		if (wm1.priority_mark_max.full > priority_mark12.full)
 			priority_mark12.full = wm1.priority_mark_max.full;
-		WREG32(D1MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
-		WREG32(D1MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
-		WREG32(D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
-		WREG32(D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
+		WREG32(R_006548_D1MODE_PRIORITY_A_CNT,
+			S_006548_D1MODE_PRIORITY_A_OFF(1));
+		WREG32(R_00654C_D1MODE_PRIORITY_B_CNT,
+			S_00654C_D1MODE_PRIORITY_B_OFF(1));
+		WREG32(R_006D48_D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
+		WREG32(R_006D4C_D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
 	}
 }
 
-/*
- * Indirect registers accessor
- */
 uint32_t rs690_mc_rreg(struct radeon_device *rdev, uint32_t reg)
 {
 	uint32_t r;
 
-	WREG32(RS690_MC_INDEX, (reg & RS690_MC_INDEX_MASK));
-	r = RREG32(RS690_MC_DATA);
-	WREG32(RS690_MC_INDEX, RS690_MC_INDEX_MASK);
+	WREG32(R_000078_MC_INDEX, S_000078_MC_IND_ADDR(reg));
+	r = RREG32(R_00007C_MC_DATA);
+	WREG32(R_000078_MC_INDEX, ~C_000078_MC_IND_ADDR);
 	return r;
 }
 
 void rs690_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 {
-	WREG32(RS690_MC_INDEX,
-	       RS690_MC_INDEX_WR_EN | ((reg) & RS690_MC_INDEX_MASK));
-	WREG32(RS690_MC_DATA, v);
-	WREG32(RS690_MC_INDEX, RS690_MC_INDEX_WR_ACK);
+	WREG32(R_000078_MC_INDEX, S_000078_MC_IND_ADDR(reg) |
+		S_000078_MC_IND_WR_EN(1));
+	WREG32(R_00007C_MC_DATA, v);
+	WREG32(R_000078_MC_INDEX, 0x7F);
+}
+
+void rs690_mc_program(struct radeon_device *rdev)
+{
+	struct rv515_mc_save save;
+
+	/* Stops all mc clients */
+	rv515_mc_stop(rdev, &save);
+
+	/* Wait for mc idle */
+	if (rs690_mc_wait_for_idle(rdev))
+		dev_warn(rdev->dev, "Wait MC idle timeout before updating MC.\n");
+	/* Program MC, should be a 32bits limited address space */
+	WREG32_MC(R_000100_MCCFG_FB_LOCATION,
+			S_000100_MC_FB_START(rdev->mc.vram_start >> 16) |
+			S_000100_MC_FB_TOP(rdev->mc.vram_end >> 16));
+	WREG32(R_000134_HDP_FB_LOCATION,
+		S_000134_HDP_FB_START(rdev->mc.vram_start >> 16));
+
+	rv515_mc_resume(rdev, &save);
+}
+
+static int rs690_startup(struct radeon_device *rdev)
+{
+	int r;
+
+	rs690_mc_program(rdev);
+	/* Resume clock */
+	rv515_clock_startup(rdev);
+	/* Initialize GPU configuration (# pipes, ...) */
+	rs690_gpu_init(rdev);
+	/* Initialize GART (initialize after TTM so we can allocate
+	 * memory through TTM but finalize after TTM) */
+	r = rs400_gart_enable(rdev);
+	if (r)
+		return r;
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
+int rs690_resume(struct radeon_device *rdev)
+{
+	/* Make sur GART are not working */
+	rs400_gart_disable(rdev);
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
+	return rs690_startup(rdev);
+}
+
+int rs690_suspend(struct radeon_device *rdev)
+{
+	r100_cp_disable(rdev);
+	r100_wb_disable(rdev);
+	r100_irq_disable(rdev);
+	rs400_gart_disable(rdev);
+	return 0;
+}
+
+void rs690_fini(struct radeon_device *rdev)
+{
+	rs690_suspend(rdev);
+	r100_cp_fini(rdev);
+	r100_wb_fini(rdev);
+	r100_ib_fini(rdev);
+	radeon_gem_fini(rdev);
+	rs400_gart_fini(rdev);
+	radeon_irq_kms_fini(rdev);
+	radeon_fence_driver_fini(rdev);
+	radeon_object_fini(rdev);
+	radeon_atombios_fini(rdev);
+	kfree(rdev->bios);
+	rdev->bios = NULL;
+}
+
+int rs690_init(struct radeon_device *rdev)
+{
+	int r;
+
+	rdev->new_init_path = true;
+	/* Disable VGA */
+	rv515_vga_render_disable(rdev);
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
+		r = radeon_atombios_init(rdev);
+		if (r)
+			return r;
+	} else {
+		dev_err(rdev->dev, "Expecting atombios for RV515 GPU\n");
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
+	rs690_vram_info(rdev);
+	/* Initialize memory controller (also test AGP) */
+	r = r420_mc_init(rdev);
+	if (r)
+		return r;
+	rv515_debugfs(rdev);
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
+	r = rs400_gart_init(rdev);
+	if (r)
+		return r;
+	rs600_set_safe_registers(rdev);
+	rdev->accel_working = true;
+	r = rs690_startup(rdev);
+	if (r) {
+		/* Somethings want wront with the accel init stop accel */
+		dev_err(rdev->dev, "Disabling GPU acceleration\n");
+		rs690_suspend(rdev);
+		r100_cp_fini(rdev);
+		r100_wb_fini(rdev);
+		r100_ib_fini(rdev);
+		rs400_gart_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
+	}
+	return 0;
 }
diff --git a/drivers/gpu/drm/radeon/rs690d.h b/drivers/gpu/drm/radeon/rs690d.h
new file mode 100644
index 0000000..62d31e7
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rs690d.h
@@ -0,0 +1,307 @@
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
+#ifndef __RS690D_H__
+#define __RS690D_H__
+
+/* Registers */
+#define R_000078_MC_INDEX                            0x000078
+#define   S_000078_MC_IND_ADDR(x)                      (((x) & 0x1FF) << 0)
+#define   G_000078_MC_IND_ADDR(x)                      (((x) >> 0) & 0x1FF)
+#define   C_000078_MC_IND_ADDR                         0xFFFFFE00
+#define   S_000078_MC_IND_WR_EN(x)                     (((x) & 0x1) << 9)
+#define   G_000078_MC_IND_WR_EN(x)                     (((x) >> 9) & 0x1)
+#define   C_000078_MC_IND_WR_EN                        0xFFFFFDFF
+#define R_00007C_MC_DATA                             0x00007C
+#define   S_00007C_MC_DATA(x)                          (((x) & 0xFFFFFFFF) << 0)
+#define   G_00007C_MC_DATA(x)                          (((x) >> 0) & 0xFFFFFFFF)
+#define   C_00007C_MC_DATA                             0x00000000
+#define R_0000F8_CONFIG_MEMSIZE                      0x0000F8
+#define   S_0000F8_CONFIG_MEMSIZE(x)                   (((x) & 0xFFFFFFFF) << 0)
+#define   G_0000F8_CONFIG_MEMSIZE(x)                   (((x) >> 0) & 0xFFFFFFFF)
+#define   C_0000F8_CONFIG_MEMSIZE                      0x00000000
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
+#define R_006520_DC_LB_MEMORY_SPLIT                  0x006520
+#define   S_006520_DC_LB_MEMORY_SPLIT(x)               (((x) & 0x3) << 0)
+#define   G_006520_DC_LB_MEMORY_SPLIT(x)               (((x) >> 0) & 0x3)
+#define   C_006520_DC_LB_MEMORY_SPLIT                  0xFFFFFFFC
+#define   S_006520_DC_LB_MEMORY_SPLIT_MODE(x)          (((x) & 0x1) << 2)
+#define   G_006520_DC_LB_MEMORY_SPLIT_MODE(x)          (((x) >> 2) & 0x1)
+#define   C_006520_DC_LB_MEMORY_SPLIT_MODE             0xFFFFFFFB
+#define   V_006520_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF    0
+#define   V_006520_DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q      1
+#define   V_006520_DC_LB_MEMORY_SPLIT_D1_ONLY          2
+#define   V_006520_DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q      3
+#define   S_006520_DC_LB_DISP1_END_ADR(x)              (((x) & 0x7FF) << 4)
+#define   G_006520_DC_LB_DISP1_END_ADR(x)              (((x) >> 4) & 0x7FF)
+#define   C_006520_DC_LB_DISP1_END_ADR                 0xFFFF800F
+#define R_006548_D1MODE_PRIORITY_A_CNT               0x006548
+#define   S_006548_D1MODE_PRIORITY_MARK_A(x)           (((x) & 0x7FFF) << 0)
+#define   G_006548_D1MODE_PRIORITY_MARK_A(x)           (((x) >> 0) & 0x7FFF)
+#define   C_006548_D1MODE_PRIORITY_MARK_A              0xFFFF8000
+#define   S_006548_D1MODE_PRIORITY_A_OFF(x)            (((x) & 0x1) << 16)
+#define   G_006548_D1MODE_PRIORITY_A_OFF(x)            (((x) >> 16) & 0x1)
+#define   C_006548_D1MODE_PRIORITY_A_OFF               0xFFFEFFFF
+#define   S_006548_D1MODE_PRIORITY_A_FORCE_MASK(x)     (((x) & 0x1) << 24)
+#define   G_006548_D1MODE_PRIORITY_A_FORCE_MASK(x)     (((x) >> 24) & 0x1)
+#define   C_006548_D1MODE_PRIORITY_A_FORCE_MASK        0xFEFFFFFF
+#define R_00654C_D1MODE_PRIORITY_B_CNT               0x00654C
+#define   S_00654C_D1MODE_PRIORITY_MARK_B(x)           (((x) & 0x7FFF) << 0)
+#define   G_00654C_D1MODE_PRIORITY_MARK_B(x)           (((x) >> 0) & 0x7FFF)
+#define   C_00654C_D1MODE_PRIORITY_MARK_B              0xFFFF8000
+#define   S_00654C_D1MODE_PRIORITY_B_OFF(x)            (((x) & 0x1) << 16)
+#define   G_00654C_D1MODE_PRIORITY_B_OFF(x)            (((x) >> 16) & 0x1)
+#define   C_00654C_D1MODE_PRIORITY_B_OFF               0xFFFEFFFF
+#define   S_00654C_D1MODE_PRIORITY_B_ALWAYS_ON(x)      (((x) & 0x1) << 20)
+#define   G_00654C_D1MODE_PRIORITY_B_ALWAYS_ON(x)      (((x) >> 20) & 0x1)
+#define   C_00654C_D1MODE_PRIORITY_B_ALWAYS_ON         0xFFEFFFFF
+#define   S_00654C_D1MODE_PRIORITY_B_FORCE_MASK(x)     (((x) & 0x1) << 24)
+#define   G_00654C_D1MODE_PRIORITY_B_FORCE_MASK(x)     (((x) >> 24) & 0x1)
+#define   C_00654C_D1MODE_PRIORITY_B_FORCE_MASK        0xFEFFFFFF
+#define R_006C9C_DCP_CONTROL                         0x006C9C
+#define R_006D48_D2MODE_PRIORITY_A_CNT               0x006D48
+#define   S_006D48_D2MODE_PRIORITY_MARK_A(x)           (((x) & 0x7FFF) << 0)
+#define   G_006D48_D2MODE_PRIORITY_MARK_A(x)           (((x) >> 0) & 0x7FFF)
+#define   C_006D48_D2MODE_PRIORITY_MARK_A              0xFFFF8000
+#define   S_006D48_D2MODE_PRIORITY_A_OFF(x)            (((x) & 0x1) << 16)
+#define   G_006D48_D2MODE_PRIORITY_A_OFF(x)            (((x) >> 16) & 0x1)
+#define   C_006D48_D2MODE_PRIORITY_A_OFF               0xFFFEFFFF
+#define   S_006D48_D2MODE_PRIORITY_A_ALWAYS_ON(x)      (((x) & 0x1) << 20)
+#define   G_006D48_D2MODE_PRIORITY_A_ALWAYS_ON(x)      (((x) >> 20) & 0x1)
+#define   C_006D48_D2MODE_PRIORITY_A_ALWAYS_ON         0xFFEFFFFF
+#define   S_006D48_D2MODE_PRIORITY_A_FORCE_MASK(x)     (((x) & 0x1) << 24)
+#define   G_006D48_D2MODE_PRIORITY_A_FORCE_MASK(x)     (((x) >> 24) & 0x1)
+#define   C_006D48_D2MODE_PRIORITY_A_FORCE_MASK        0xFEFFFFFF
+#define R_006D4C_D2MODE_PRIORITY_B_CNT               0x006D4C
+#define   S_006D4C_D2MODE_PRIORITY_MARK_B(x)           (((x) & 0x7FFF) << 0)
+#define   G_006D4C_D2MODE_PRIORITY_MARK_B(x)           (((x) >> 0) & 0x7FFF)
+#define   C_006D4C_D2MODE_PRIORITY_MARK_B              0xFFFF8000
+#define   S_006D4C_D2MODE_PRIORITY_B_OFF(x)            (((x) & 0x1) << 16)
+#define   G_006D4C_D2MODE_PRIORITY_B_OFF(x)            (((x) >> 16) & 0x1)
+#define   C_006D4C_D2MODE_PRIORITY_B_OFF               0xFFFEFFFF
+#define   S_006D4C_D2MODE_PRIORITY_B_ALWAYS_ON(x)      (((x) & 0x1) << 20)
+#define   G_006D4C_D2MODE_PRIORITY_B_ALWAYS_ON(x)      (((x) >> 20) & 0x1)
+#define   C_006D4C_D2MODE_PRIORITY_B_ALWAYS_ON         0xFFEFFFFF
+#define   S_006D4C_D2MODE_PRIORITY_B_FORCE_MASK(x)     (((x) & 0x1) << 24)
+#define   G_006D4C_D2MODE_PRIORITY_B_FORCE_MASK(x)     (((x) >> 24) & 0x1)
+#define   C_006D4C_D2MODE_PRIORITY_B_FORCE_MASK        0xFEFFFFFF
+#define R_006D58_LB_MAX_REQ_OUTSTANDING              0x006D58
+#define   S_006D58_LB_D1_MAX_REQ_OUTSTANDING(x)        (((x) & 0xF) << 0)
+#define   G_006D58_LB_D1_MAX_REQ_OUTSTANDING(x)        (((x) >> 0) & 0xF)
+#define   C_006D58_LB_D1_MAX_REQ_OUTSTANDING           0xFFFFFFF0
+#define   S_006D58_LB_D2_MAX_REQ_OUTSTANDING(x)        (((x) & 0xF) << 16)
+#define   G_006D58_LB_D2_MAX_REQ_OUTSTANDING(x)        (((x) >> 16) & 0xF)
+#define   C_006D58_LB_D2_MAX_REQ_OUTSTANDING           0xFFF0FFFF
+
+
+#define R_000090_MC_SYSTEM_STATUS                    0x000090
+#define   S_000090_MC_SYSTEM_IDLE(x)                   (((x) & 0x1) << 0)
+#define   G_000090_MC_SYSTEM_IDLE(x)                   (((x) >> 0) & 0x1)
+#define   C_000090_MC_SYSTEM_IDLE                      0xFFFFFFFE
+#define   S_000090_MC_SEQUENCER_IDLE(x)                (((x) & 0x1) << 1)
+#define   G_000090_MC_SEQUENCER_IDLE(x)                (((x) >> 1) & 0x1)
+#define   C_000090_MC_SEQUENCER_IDLE                   0xFFFFFFFD
+#define   S_000090_MC_ARBITER_IDLE(x)                  (((x) & 0x1) << 2)
+#define   G_000090_MC_ARBITER_IDLE(x)                  (((x) >> 2) & 0x1)
+#define   C_000090_MC_ARBITER_IDLE                     0xFFFFFFFB
+#define   S_000090_MC_SELECT_PM(x)                     (((x) & 0x1) << 3)
+#define   G_000090_MC_SELECT_PM(x)                     (((x) >> 3) & 0x1)
+#define   C_000090_MC_SELECT_PM                        0xFFFFFFF7
+#define   S_000090_RESERVED4(x)                        (((x) & 0xF) << 4)
+#define   G_000090_RESERVED4(x)                        (((x) >> 4) & 0xF)
+#define   C_000090_RESERVED4                           0xFFFFFF0F
+#define   S_000090_RESERVED8(x)                        (((x) & 0xF) << 8)
+#define   G_000090_RESERVED8(x)                        (((x) >> 8) & 0xF)
+#define   C_000090_RESERVED8                           0xFFFFF0FF
+#define   S_000090_RESERVED12(x)                       (((x) & 0xF) << 12)
+#define   G_000090_RESERVED12(x)                       (((x) >> 12) & 0xF)
+#define   C_000090_RESERVED12                          0xFFFF0FFF
+#define   S_000090_MCA_INIT_EXECUTED(x)                (((x) & 0x1) << 16)
+#define   G_000090_MCA_INIT_EXECUTED(x)                (((x) >> 16) & 0x1)
+#define   C_000090_MCA_INIT_EXECUTED                   0xFFFEFFFF
+#define   S_000090_MCA_IDLE(x)                         (((x) & 0x1) << 17)
+#define   G_000090_MCA_IDLE(x)                         (((x) >> 17) & 0x1)
+#define   C_000090_MCA_IDLE                            0xFFFDFFFF
+#define   S_000090_MCA_SEQ_IDLE(x)                     (((x) & 0x1) << 18)
+#define   G_000090_MCA_SEQ_IDLE(x)                     (((x) >> 18) & 0x1)
+#define   C_000090_MCA_SEQ_IDLE                        0xFFFBFFFF
+#define   S_000090_MCA_ARB_IDLE(x)                     (((x) & 0x1) << 19)
+#define   G_000090_MCA_ARB_IDLE(x)                     (((x) >> 19) & 0x1)
+#define   C_000090_MCA_ARB_IDLE                        0xFFF7FFFF
+#define   S_000090_RESERVED20(x)                       (((x) & 0xFFF) << 20)
+#define   G_000090_RESERVED20(x)                       (((x) >> 20) & 0xFFF)
+#define   C_000090_RESERVED20                          0x000FFFFF
+#define R_000100_MCCFG_FB_LOCATION                   0x000100
+#define   S_000100_MC_FB_START(x)                      (((x) & 0xFFFF) << 0)
+#define   G_000100_MC_FB_START(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_000100_MC_FB_START                         0xFFFF0000
+#define   S_000100_MC_FB_TOP(x)                        (((x) & 0xFFFF) << 16)
+#define   G_000100_MC_FB_TOP(x)                        (((x) >> 16) & 0xFFFF)
+#define   C_000100_MC_FB_TOP                           0x0000FFFF
+#define R_000104_MC_INIT_MISC_LAT_TIMER              0x000104
+#define   S_000104_MC_CPR_INIT_LAT(x)                  (((x) & 0xF) << 0)
+#define   G_000104_MC_CPR_INIT_LAT(x)                  (((x) >> 0) & 0xF)
+#define   C_000104_MC_CPR_INIT_LAT                     0xFFFFFFF0
+#define   S_000104_MC_VF_INIT_LAT(x)                   (((x) & 0xF) << 4)
+#define   G_000104_MC_VF_INIT_LAT(x)                   (((x) >> 4) & 0xF)
+#define   C_000104_MC_VF_INIT_LAT                      0xFFFFFF0F
+#define   S_000104_MC_DISP0R_INIT_LAT(x)               (((x) & 0xF) << 8)
+#define   G_000104_MC_DISP0R_INIT_LAT(x)               (((x) >> 8) & 0xF)
+#define   C_000104_MC_DISP0R_INIT_LAT                  0xFFFFF0FF
+#define   S_000104_MC_DISP1R_INIT_LAT(x)               (((x) & 0xF) << 12)
+#define   G_000104_MC_DISP1R_INIT_LAT(x)               (((x) >> 12) & 0xF)
+#define   C_000104_MC_DISP1R_INIT_LAT                  0xFFFF0FFF
+#define   S_000104_MC_FIXED_INIT_LAT(x)                (((x) & 0xF) << 16)
+#define   G_000104_MC_FIXED_INIT_LAT(x)                (((x) >> 16) & 0xF)
+#define   C_000104_MC_FIXED_INIT_LAT                   0xFFF0FFFF
+#define   S_000104_MC_E2R_INIT_LAT(x)                  (((x) & 0xF) << 20)
+#define   G_000104_MC_E2R_INIT_LAT(x)                  (((x) >> 20) & 0xF)
+#define   C_000104_MC_E2R_INIT_LAT                     0xFF0FFFFF
+#define   S_000104_SAME_PAGE_PRIO(x)                   (((x) & 0xF) << 24)
+#define   G_000104_SAME_PAGE_PRIO(x)                   (((x) >> 24) & 0xF)
+#define   C_000104_SAME_PAGE_PRIO                      0xF0FFFFFF
+#define   S_000104_MC_GLOBW_INIT_LAT(x)                (((x) & 0xF) << 28)
+#define   G_000104_MC_GLOBW_INIT_LAT(x)                (((x) >> 28) & 0xF)
+#define   C_000104_MC_GLOBW_INIT_LAT                   0x0FFFFFFF
+
+#endif
diff --git a/drivers/gpu/drm/radeon/rs690r.h b/drivers/gpu/drm/radeon/rs690r.h
deleted file mode 100644
index c0d9faa..0000000
--- a/drivers/gpu/drm/radeon/rs690r.h
+++ /dev/null
@@ -1,99 +0,0 @@
-/*
- * Copyright 2008 Advanced Micro Devices, Inc.
- * Copyright 2008 Red Hat Inc.
- * Copyright 2009 Jerome Glisse.
- *
- * Permission is hereby granted, free of charge, to any person obtaining a
- * copy of this software and associated documentation files (the "Software"),
- * to deal in the Software without restriction, including without limitation
- * the rights to use, copy, modify, merge, publish, distribute, sublicense,
- * and/or sell copies of the Software, and to permit persons to whom the
- * Software is furnished to do so, subject to the following conditions:
- *
- * The above copyright notice and this permission notice shall be included in
- * all copies or substantial portions of the Software.
- *
- * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
- * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
- * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
- * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
- * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
- * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
- * OTHER DEALINGS IN THE SOFTWARE.
- *
- * Authors: Dave Airlie
- *          Alex Deucher
- *          Jerome Glisse
- */
-#ifndef RS690R_H
-#define RS690R_H
-
-/* RS690/RS740 registers */
-#define MC_INDEX			0x0078
-#	define MC_INDEX_MASK			0x1FF
-#	define MC_INDEX_WR_EN			(1 << 9)
-#	define MC_INDEX_WR_ACK			0x7F
-#define MC_DATA				0x007C
-#define HDP_FB_LOCATION			0x0134
-#define DC_LB_MEMORY_SPLIT		0x6520
-#define		DC_LB_MEMORY_SPLIT_MASK			0x00000003
-#define		DC_LB_MEMORY_SPLIT_SHIFT		0
-#define		DC_LB_MEMORY_SPLIT_D1HALF_D2HALF	0
-#define		DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q		1
-#define		DC_LB_MEMORY_SPLIT_D1_ONLY		2
-#define		DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q		3
-#define		DC_LB_MEMORY_SPLIT_SHIFT_MODE		(1 << 2)
-#define		DC_LB_DISP1_END_ADR_SHIFT		4
-#define		DC_LB_DISP1_END_ADR_MASK		0x00007FF0
-#define D1MODE_PRIORITY_A_CNT		0x6548
-#define		MODE_PRIORITY_MARK_MASK			0x00007FFF
-#define		MODE_PRIORITY_OFF			(1 << 16)
-#define		MODE_PRIORITY_ALWAYS_ON			(1 << 20)
-#define		MODE_PRIORITY_FORCE_MASK		(1 << 24)
-#define D1MODE_PRIORITY_B_CNT		0x654C
-#define LB_MAX_REQ_OUTSTANDING		0x6D58
-#define		LB_D1_MAX_REQ_OUTSTANDING_MASK		0x0000000F
-#define		LB_D1_MAX_REQ_OUTSTANDING_SHIFT		0
-#define		LB_D2_MAX_REQ_OUTSTANDING_MASK		0x000F0000
-#define		LB_D2_MAX_REQ_OUTSTANDING_SHIFT		16
-#define DCP_CONTROL			0x6C9C
-#define D2MODE_PRIORITY_A_CNT		0x6D48
-#define D2MODE_PRIORITY_B_CNT		0x6D4C
-
-/* MC indirect registers */
-#define MC_STATUS_IDLE				(1 << 0)
-#define MC_MISC_CNTL			0x18
-#define		DISABLE_GTW			(1 << 1)
-#define		GART_INDEX_REG_EN		(1 << 12)
-#define		BLOCK_GFX_D3_EN			(1 << 14)
-#define GART_FEATURE_ID			0x2B
-#define		HANG_EN				(1 << 11)
-#define		TLB_ENABLE			(1 << 18)
-#define		P2P_ENABLE			(1 << 19)
-#define		GTW_LAC_EN			(1 << 25)
-#define		LEVEL2_GART			(0 << 30)
-#define		LEVEL1_GART			(1 << 30)
-#define		PDC_EN				(1 << 31)
-#define GART_BASE			0x2C
-#define GART_CACHE_CNTRL		0x2E
-#	define GART_CACHE_INVALIDATE		(1 << 0)
-#define MC_STATUS			0x90
-#define MCCFG_FB_LOCATION		0x100
-#define		MC_FB_START_MASK		0x0000FFFF
-#define		MC_FB_START_SHIFT		0
-#define		MC_FB_TOP_MASK			0xFFFF0000
-#define		MC_FB_TOP_SHIFT			16
-#define MCCFG_AGP_LOCATION		0x101
-#define		MC_AGP_START_MASK		0x0000FFFF
-#define		MC_AGP_START_SHIFT		0
-#define		MC_AGP_TOP_MASK			0xFFFF0000
-#define		MC_AGP_TOP_SHIFT		16
-#define MCCFG_AGP_BASE			0x102
-#define MCCFG_AGP_BASE_2		0x103
-#define MC_INIT_MISC_LAT_TIMER		0x104
-#define		MC_DISP0R_INIT_LAT_SHIFT	8
-#define		MC_DISP0R_INIT_LAT_MASK		0x00000F00
-#define		MC_DISP1R_INIT_LAT_SHIFT	12
-#define		MC_DISP1R_INIT_LAT_MASK		0x0000F000
-
-#endif
-- 
1.6.4.4

