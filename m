Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbZI2Mc0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbZI2Mc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:32:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022AbZI2McZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:32:25 -0400
Received: from nox.protox.org ([88.191.38.29]:39125 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519AbZI2McY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:32:24 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert RS690/RS740 to new init path.
Date: Tue, 29 Sep 2009 14:32:19 +0200
Message-Id: <1254227539-8306-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also cleanup register specific to RS690/RS740.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/radeon.h      |   10 +
 drivers/gpu/drm/radeon/radeon_asic.h |   41 ++--
 drivers/gpu/drm/radeon/rs600.c       |    7 +-
 drivers/gpu/drm/radeon/rs690.c       |  358 +++++++++++++++++++++------------
 drivers/gpu/drm/radeon/rs690r.h      |   99 ----------
 5 files changed, 266 insertions(+), 249 deletions(-)
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
index 7a0098d..4a4406a 100644
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
@@ -621,30 +543,206 @@ void rs690_bandwidth_update(struct radeon_device *rdev)
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
+	rv515_suspend(rdev);
+	r100_cp_fini(rdev);
+	r100_wb_fini(rdev);
+	r100_ib_fini(rdev);
+	radeon_gem_fini(rdev);
+	rs400_gart_fini(rdev);
+	radeon_agp_fini(rdev);
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
+    /* Disable VGA */
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
+		radeon_agp_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
+	}
+	return 0;
 }
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

