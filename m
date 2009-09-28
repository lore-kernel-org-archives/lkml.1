Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbZI1Qet@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbZI1Qet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 12:34:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751992AbZI1Qes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 12:34:48 -0400
Received: from nox.protox.org ([88.191.38.29]:34596 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751901AbZI1Qer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 12:34:47 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert RV515 to new init path and associated cleanup
Date: Mon, 28 Sep 2009 18:34:43 +0200
Message-Id: <1254155683-19832-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the rv515 asic support to new init path also add an explanation
in radeon.h about the new init path. There is also few cleanups
associated with this change (others asic calling rv515 helper
functions).

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/avivod.h      |    9 -
 drivers/gpu/drm/radeon/r520.c        |    9 +-
 drivers/gpu/drm/radeon/r600.c        |    4 +-
 drivers/gpu/drm/radeon/r600_cs.c     |    1 -
 drivers/gpu/drm/radeon/radeon.h      |   34 +++
 drivers/gpu/drm/radeon/radeon_asic.h |   37 ++--
 drivers/gpu/drm/radeon/rs600.c       |   20 +--
 drivers/gpu/drm/radeon/rs690.c       |    3 +-
 drivers/gpu/drm/radeon/rv515.c       |  364 +++++++++++++++++++++++---------
 drivers/gpu/drm/radeon/rv515d.h      |  385 +++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/radeon/rv770.c       |    4 +-
 11 files changed, 712 insertions(+), 158 deletions(-)

diff --git a/drivers/gpu/drm/radeon/avivod.h b/drivers/gpu/drm/radeon/avivod.h
index e2b92c4..d4e6e6e 100644
--- a/drivers/gpu/drm/radeon/avivod.h
+++ b/drivers/gpu/drm/radeon/avivod.h
@@ -57,13 +57,4 @@
 #define	VGA_RENDER_CONTROL				0x0300
 #define		VGA_VSTATUS_CNTL_MASK				0x00030000
 
-/* AVIVO disable VGA rendering */
-static inline void radeon_avivo_vga_render_disable(struct radeon_device *rdev)
-{
-	u32 vga_render;
-	vga_render = RREG32(VGA_RENDER_CONTROL);
-	vga_render &= ~VGA_VSTATUS_CNTL_MASK;
-	WREG32(VGA_RENDER_CONTROL, vga_render);
-}
-
 #endif
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index d4b0b9d..2723486 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -33,7 +33,6 @@
 void r100_hdp_reset(struct radeon_device *rdev);
 void r420_pipes_init(struct radeon_device *rdev);
 void rs600_mc_disable_clients(struct radeon_device *rdev);
-void rs600_disable_vga(struct radeon_device *rdev);
 int rv515_debugfs_pipes_info_init(struct radeon_device *rdev);
 int rv515_debugfs_ga_info_init(struct radeon_device *rdev);
 
@@ -148,7 +147,7 @@ void r520_gpu_init(struct radeon_device *rdev)
 	unsigned pipe_select_current, gb_pipe_select, tmp;
 
 	r100_hdp_reset(rdev);
-	rs600_disable_vga(rdev);
+	rv515_vga_render_disable(rdev);
 	/*
 	 * DST_PIPE_CONFIG		0x170C
 	 * GB_TILE_CONFIG		0x4018
@@ -237,3 +236,9 @@ void r520_bandwidth_update(struct radeon_device *rdev)
 {
 	rv515_bandwidth_avivo_update(rdev);
 }
+
+int r520_init(struct radeon_device *rdev)
+{
+	rv515_set_safe_registers(rdev);
+	return 0;
+}
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index c7233ad..6b7a40b 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -33,8 +33,8 @@
 #include "radeon.h"
 #include "radeon_mode.h"
 #include "r600d.h"
-#include "avivod.h"
 #include "atom.h"
+#include "avivod.h"
 
 #define PFP_UCODE_SIZE 576
 #define PM4_UCODE_SIZE 1792
@@ -342,7 +342,7 @@ static void r600_mc_resume(struct radeon_device *rdev)
 
 	/* we need to own VRAM, so turn off the VGA renderer here
 	 * to stop it overwriting our objects */
-	radeon_avivo_vga_render_disable(rdev);
+	rv515_vga_render_disable(rdev);
 }
 
 int r600_mc_init(struct radeon_device *rdev)
diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 06eab79..d28970d 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -28,7 +28,6 @@
 #include "drmP.h"
 #include "radeon.h"
 #include "r600d.h"
-#include "avivod.h"
 
 static int r600_cs_packet_next_reloc_mm(struct radeon_cs_parser *p,
 					struct radeon_cs_reloc **cs_reloc);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 7e34e43..116bedd 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -44,6 +44,24 @@
  *	- TESTING, TESTING, TESTING
  */
 
+/* Initialization path:
+ *  We expect that acceleration initialization might fail for various
+ *  reasons even thought we work hard to make it works on most
+ *  configurations. In order to still have a working userspace in such
+ *  situation the init path must succeed up to the memory controller
+ *  initialization point. Failure before this point are considered as
+ *  fatal error. Here is the init callchain :
+ *      radeon_device_init  perform common structure, mutex initialization
+ *      asic_init           setup the GPU memory layout and perform all
+ *                          one time initialization (failure in this
+ *                          function are considered fatal)
+ *      asic_startup        setup the GPU acceleration, in order to
+ *                          follow guideline the first thing this
+ *                          function should do is setting the GPU
+ *                          memory controller (only MC setup failure
+ *                          are considered as fatal)
+ */
+
 #include <asm/atomic.h>
 #include <linux/wait.h>
 #include <linux/list.h>
@@ -976,6 +994,7 @@ extern void radeon_clocks_fini(struct radeon_device *rdev);
 extern void radeon_scratch_init(struct radeon_device *rdev);
 extern void radeon_surface_init(struct radeon_device *rdev);
 extern int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data);
+extern void radeon_atom_set_clock_gating(struct radeon_device *rdev, int enable);
 
 /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
 struct r100_mc_save {
@@ -1007,6 +1026,9 @@ extern void r100_vram_init_sizes(struct radeon_device *rdev);
 extern void r100_wb_disable(struct radeon_device *rdev);
 extern void r100_wb_fini(struct radeon_device *rdev);
 extern int r100_wb_init(struct radeon_device *rdev);
+extern void r100_hdp_reset(struct radeon_device *rdev);
+extern int r100_rb2d_reset(struct radeon_device *rdev);
+extern int r100_cp_reset(struct radeon_device *rdev);
 
 /* r300,r350,rv350,rv370,rv380 */
 extern void r300_set_reg_safe(struct radeon_device *rdev);
@@ -1018,12 +1040,24 @@ extern int rv370_pcie_gart_enable(struct radeon_device *rdev);
 extern void rv370_pcie_gart_disable(struct radeon_device *rdev);
 
 /* r420,r423,rv410 */
+extern int r420_mc_init(struct radeon_device *rdev);
 extern u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg);
 extern void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v);
 extern int r420_debugfs_pipes_info_init(struct radeon_device *rdev);
+extern void r420_pipes_init(struct radeon_device *rdev);
 
 /* rv515 */
+struct rv515_mc_save {
+	u32 d1vga_control;
+	u32 d2vga_control;
+	u32 vga_render_control;
+	u32 vga_hdp_control;
+	u32 d1crtc_control;
+	u32 d2crtc_control;
+};
 extern void rv515_bandwidth_avivo_update(struct radeon_device *rdev);
+extern void rv515_vga_render_disable(struct radeon_device *rdev);
+extern void rv515_set_safe_registers(struct radeon_device *rdev);
 
 /* rs690, rs740 */
 extern void rs690_line_buffer_adjust(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 5f2a9e6..ccbf525 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -413,40 +413,42 @@ static struct radeon_asic rs690_asic = {
  * rv515
  */
 int rv515_init(struct radeon_device *rdev);
-void rv515_errata(struct radeon_device *rdev);
-void rv515_vram_info(struct radeon_device *rdev);
+void rv515_fini(struct radeon_device *rdev);
 int rv515_gpu_reset(struct radeon_device *rdev);
-int rv515_mc_init(struct radeon_device *rdev);
-void rv515_mc_fini(struct radeon_device *rdev);
 uint32_t rv515_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rv515_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void rv515_ring_start(struct radeon_device *rdev);
 uint32_t rv515_pcie_rreg(struct radeon_device *rdev, uint32_t reg);
 void rv515_pcie_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void rv515_bandwidth_update(struct radeon_device *rdev);
+int rv515_resume(struct radeon_device *rdev);
+int rv515_suspend(struct radeon_device *rdev);
 static struct radeon_asic rv515_asic = {
 	.init = &rv515_init,
-	.errata = &rv515_errata,
-	.vram_info = &rv515_vram_info,
+	.fini = &rv515_fini,
+	.suspend = &rv515_suspend,
+	.resume = &rv515_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &rv515_gpu_reset,
-	.mc_init = &rv515_mc_init,
-	.mc_fini = &rv515_mc_fini,
-	.wb_init = &r100_wb_init,
-	.wb_fini = &r100_wb_fini,
+	.mc_init = NULL,
+	.mc_fini = NULL,
+	.wb_init = NULL,
+	.wb_fini = NULL,
 	.gart_init = &rv370_pcie_gart_init,
 	.gart_fini = &rv370_pcie_gart_fini,
-	.gart_enable = &rv370_pcie_gart_enable,
-	.gart_disable = &rv370_pcie_gart_disable,
+	.gart_enable = NULL,
+	.gart_disable = NULL,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
-	.cp_init = &r100_cp_init,
-	.cp_fini = &r100_cp_fini,
-	.cp_disable = &r100_cp_disable,
+	.cp_init = NULL,
+	.cp_fini = NULL,
+	.cp_disable = NULL,
 	.cp_commit = &r100_cp_commit,
 	.ring_start = &rv515_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = &r100_ib_test,
+	.ib_test = NULL,
 	.irq_set = &rs600_irq_set,
 	.irq_process = &rs600_irq_process,
 	.get_vblank_counter = &rs600_get_vblank_counter,
@@ -468,13 +470,14 @@ static struct radeon_asic rv515_asic = {
 /*
  * r520,rv530,rv560,rv570,r580
  */
+int r520_init(struct radeon_device *rdev);
 void r520_errata(struct radeon_device *rdev);
 void r520_vram_info(struct radeon_device *rdev);
 int r520_mc_init(struct radeon_device *rdev);
 void r520_mc_fini(struct radeon_device *rdev);
 void r520_bandwidth_update(struct radeon_device *rdev);
 static struct radeon_asic r520_asic = {
-	.init = &rv515_init,
+	.init = &r520_init,
 	.errata = &r520_errata,
 	.vram_info = &r520_vram_info,
 	.gpu_reset = &rv515_gpu_reset,
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 0e791e2..4a4fe1c 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -28,7 +28,6 @@
 #include "drmP.h"
 #include "radeon_reg.h"
 #include "radeon.h"
-#include "avivod.h"
 
 #include "rs600_reg_safe.h"
 
@@ -45,7 +44,6 @@ void r420_pipes_init(struct radeon_device *rdev);
  */
 void rs600_gpu_init(struct radeon_device *rdev);
 int rs600_mc_wait_for_idle(struct radeon_device *rdev);
-void rs600_disable_vga(struct radeon_device *rdev);
 
 
 /*
@@ -198,7 +196,7 @@ void rs600_mc_disable_clients(struct radeon_device *rdev)
 		       "programming pipes. Bad things might happen.\n");
 	}
 
-	radeon_avivo_vga_render_disable(rdev);
+	rv515_vga_render_disable(rdev);
 
 	tmp = RREG32(AVIVO_D1VGA_CONTROL);
 	WREG32(AVIVO_D1VGA_CONTROL, tmp & ~AVIVO_DVGA_CONTROL_MODE_ENABLE);
@@ -346,20 +344,6 @@ u32 rs600_get_vblank_counter(struct radeon_device *rdev, int crtc)
 /*
  * Global GPU functions
  */
-void rs600_disable_vga(struct radeon_device *rdev)
-{
-	unsigned tmp;
-
-	WREG32(0x330, 0);
-	WREG32(0x338, 0);
-	tmp = RREG32(0x300);
-	tmp &= ~(3 << 16);
-	WREG32(0x300, tmp);
-	WREG32(0x308, (1 << 8));
-	WREG32(0x310, rdev->mc.vram_location);
-	WREG32(0x594, 0);
-}
-
 int rs600_mc_wait_for_idle(struct radeon_device *rdev)
 {
 	unsigned i;
@@ -385,7 +369,7 @@ void rs600_gpu_init(struct radeon_device *rdev)
 {
 	/* FIXME: HDP same place on rs600 ? */
 	r100_hdp_reset(rdev);
-	rs600_disable_vga(rdev);
+	rv515_vga_render_disable(rdev);
 	/* FIXME: is this correct ? */
 	r420_pipes_init(rdev);
 	if (rs600_mc_wait_for_idle(rdev)) {
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 0f585ca..7a0098d 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -40,7 +40,6 @@ void rs400_gart_disable(struct radeon_device *rdev);
 int rs400_gart_enable(struct radeon_device *rdev);
 void rs400_gart_adjust_size(struct radeon_device *rdev);
 void rs600_mc_disable_clients(struct radeon_device *rdev);
-void rs600_disable_vga(struct radeon_device *rdev);
 
 /* This files gather functions specifics to :
  * rs690,rs740
@@ -125,7 +124,7 @@ void rs690_gpu_init(struct radeon_device *rdev)
 {
 	/* FIXME: HDP same place on rs690 ? */
 	r100_hdp_reset(rdev);
-	rs600_disable_vga(rdev);
+	rv515_vga_render_disable(rdev);
 	/* FIXME: is this correct ? */
 	r420_pipes_init(rdev);
 	if (rs690_mc_wait_for_idle(rdev)) {
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index fd79974..a837ddc 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -29,37 +29,17 @@
 #include "drmP.h"
 #include "rv515d.h"
 #include "radeon.h"
-
+#include "atom.h"
 #include "rv515_reg_safe.h"
-/* rv515 depends on : */
-void r100_hdp_reset(struct radeon_device *rdev);
-int r100_cp_reset(struct radeon_device *rdev);
-int r100_rb2d_reset(struct radeon_device *rdev);
-int r100_gui_wait_for_idle(struct radeon_device *rdev);
-int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
-void r420_pipes_init(struct radeon_device *rdev);
-void rs600_mc_disable_clients(struct radeon_device *rdev);
-void rs600_disable_vga(struct radeon_device *rdev);
-
-/* This files gather functions specifics to:
- * rv515
- *
- * Some of these functions might be used by newer ASICs.
- */
+
+/* This files gather functions specifics to: rv515 */
 int rv515_debugfs_pipes_info_init(struct radeon_device *rdev);
 int rv515_debugfs_ga_info_init(struct radeon_device *rdev);
 void rv515_gpu_init(struct radeon_device *rdev);
 int rv515_mc_wait_for_idle(struct radeon_device *rdev);
 
-
-/*
- * MC
- */
-int rv515_mc_init(struct radeon_device *rdev)
+static void rv515_debugfs(struct radeon_device *rdev)
 {
-	uint32_t tmp;
-	int r;
-
 	if (r100_debugfs_rbbm_init(rdev)) {
 		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
 	}
@@ -69,67 +49,8 @@ int rv515_mc_init(struct radeon_device *rdev)
 	if (rv515_debugfs_ga_info_init(rdev)) {
 		DRM_ERROR("Failed to register debugfs file for pipes !\n");
 	}
-
-	rv515_gpu_init(rdev);
-	rv370_pcie_gart_disable(rdev);
-
-	/* Setup GPU memory space */
-	rdev->mc.vram_location = 0xFFFFFFFFUL;
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
-	/* Program GPU memory space */
-	rs600_mc_disable_clients(rdev);
-	if (rv515_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-	/* Write VRAM size in case we are limiting it */
-	WREG32(RADEON_CONFIG_MEMSIZE, rdev->mc.real_vram_size);
-	tmp = REG_SET(MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32(0x134, tmp);
-	tmp = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
-	tmp = REG_SET(MC_FB_TOP, tmp >> 16);
-	tmp |= REG_SET(MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32_MC(MC_FB_LOCATION, tmp);
-	WREG32(HDP_FB_LOCATION, rdev->mc.vram_location >> 16);
-	WREG32(0x310, rdev->mc.vram_location);
-	if (rdev->flags & RADEON_IS_AGP) {
-		tmp = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
-		tmp = REG_SET(MC_AGP_TOP, tmp >> 16);
-		tmp |= REG_SET(MC_AGP_START, rdev->mc.gtt_location >> 16);
-		WREG32_MC(MC_AGP_LOCATION, tmp);
-		WREG32_MC(MC_AGP_BASE, rdev->mc.agp_base);
-		WREG32_MC(MC_AGP_BASE_2, 0);
-	} else {
-		WREG32_MC(MC_AGP_LOCATION, 0x0FFFFFFF);
-		WREG32_MC(MC_AGP_BASE, 0);
-		WREG32_MC(MC_AGP_BASE_2, 0);
-	}
-	return 0;
-}
-
-void rv515_mc_fini(struct radeon_device *rdev)
-{
 }
 
-
-/*
- * Global GPU functions
- */
 void rv515_ring_start(struct radeon_device *rdev)
 {
 	int r;
@@ -198,11 +119,6 @@ void rv515_ring_start(struct radeon_device *rdev)
 	radeon_ring_unlock_commit(rdev);
 }
 
-void rv515_errata(struct radeon_device *rdev)
-{
-	rdev->pll_errata = 0;
-}
-
 int rv515_mc_wait_for_idle(struct radeon_device *rdev)
 {
 	unsigned i;
@@ -219,6 +135,12 @@ int rv515_mc_wait_for_idle(struct radeon_device *rdev)
 	return -1;
 }
 
+void rv515_vga_render_disable(struct radeon_device *rdev)
+{
+	WREG32(R_000300_VGA_RENDER_CONTROL,
+		RREG32(R_000300_VGA_RENDER_CONTROL) & C_000300_VGA_VSTATUS_CNTL);
+}
+
 void rv515_gpu_init(struct radeon_device *rdev)
 {
 	unsigned pipe_select_current, gb_pipe_select, tmp;
@@ -231,7 +153,7 @@ void rv515_gpu_init(struct radeon_device *rdev)
 		       "reseting GPU. Bad things might happen.\n");
 	}
 
-	rs600_disable_vga(rdev);
+	rv515_vga_render_disable(rdev);
 
 	r420_pipes_init(rdev);
 	gb_pipe_select = RREG32(0x402C);
@@ -335,10 +257,6 @@ int rv515_gpu_reset(struct radeon_device *rdev)
 	return 0;
 }
 
-
-/*
- * VRAM info
- */
 static void rv515_vram_get_type(struct radeon_device *rdev)
 {
 	uint32_t tmp;
@@ -374,10 +292,6 @@ void rv515_vram_info(struct radeon_device *rdev)
 	rdev->pm.sclk.full = rfixed_div(rdev->pm.sclk, a);
 }
 
-
-/*
- * Indirect registers accessor
- */
 uint32_t rv515_mc_rreg(struct radeon_device *rdev, uint32_t reg)
 {
 	uint32_t r;
@@ -395,9 +309,6 @@ void rv515_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 	WREG32(MC_IND_INDEX, 0);
 }
 
-/*
- * Debugfs info
- */
 #if defined(CONFIG_DEBUG_FS)
 static int rv515_debugfs_pipes_info(struct seq_file *m, void *data)
 {
@@ -459,13 +370,258 @@ int rv515_debugfs_ga_info_init(struct radeon_device *rdev)
 #endif
 }
 
-/*
- * Asic initialization
- */
-int rv515_init(struct radeon_device *rdev)
+void rv515_mc_stop(struct radeon_device *rdev, struct rv515_mc_save *save)
+{
+	save->d1vga_control = RREG32(R_000330_D1VGA_CONTROL);
+	save->d2vga_control = RREG32(R_000338_D2VGA_CONTROL);
+	save->vga_render_control = RREG32(R_000300_VGA_RENDER_CONTROL);
+	save->vga_hdp_control = RREG32(R_000328_VGA_HDP_CONTROL);
+	save->d1crtc_control = RREG32(R_006080_D1CRTC_CONTROL);
+	save->d2crtc_control = RREG32(R_006880_D2CRTC_CONTROL);
+
+	/* Stop all video */
+	WREG32(R_000330_D1VGA_CONTROL, 0);
+	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
+	WREG32(R_000300_VGA_RENDER_CONTROL, 0);
+	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 1);
+	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 1);
+	WREG32(R_006080_D1CRTC_CONTROL, 0);
+	WREG32(R_006880_D2CRTC_CONTROL, 0);
+	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 0);
+	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
+}
+
+void rv515_mc_resume(struct radeon_device *rdev, struct rv515_mc_save *save)
+{
+	WREG32(R_006110_D1GRPH_PRIMARY_SURFACE_ADDRESS, rdev->mc.vram_start);
+	WREG32(R_006118_D1GRPH_SECONDARY_SURFACE_ADDRESS, rdev->mc.vram_start);
+	WREG32(R_006910_D2GRPH_PRIMARY_SURFACE_ADDRESS, rdev->mc.vram_start);
+	WREG32(R_006918_D2GRPH_SECONDARY_SURFACE_ADDRESS, rdev->mc.vram_start);
+	WREG32(R_000310_VGA_MEMORY_BASE_ADDRESS, rdev->mc.vram_start);
+	/* Unlock host access */
+	WREG32(R_000328_VGA_HDP_CONTROL, save->vga_hdp_control);
+	mdelay(1);
+	/* Restore video state */
+	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 1);
+	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 1);
+	WREG32(R_006080_D1CRTC_CONTROL, save->d1crtc_control);
+	WREG32(R_006880_D2CRTC_CONTROL, save->d2crtc_control);
+	WREG32(R_0060E8_D1CRTC_UPDATE_LOCK, 0);
+	WREG32(R_0068E8_D2CRTC_UPDATE_LOCK, 0);
+	WREG32(R_000330_D1VGA_CONTROL, save->d1vga_control);
+	WREG32(R_000338_D2VGA_CONTROL, save->d2vga_control);
+	WREG32(R_000300_VGA_RENDER_CONTROL, save->vga_render_control);
+}
+
+void rv515_mc_program(struct radeon_device *rdev)
+{
+	struct rv515_mc_save save;
+
+	/* Stops all mc clients */
+	rv515_mc_stop(rdev, &save);
+
+	/* Wait for mc idle */
+	if (rv515_mc_wait_for_idle(rdev))
+		dev_warn(rdev->dev, "Wait MC idle timeout before updating MC.\n");
+	/* Write VRAM size in case we are limiting it */
+	WREG32(R_0000F8_CONFIG_MEMSIZE, rdev->mc.real_vram_size);
+	/* Program MC, should be a 32bits limited address space */
+	WREG32_MC(R_000001_MC_FB_LOCATION,
+			S_000001_MC_FB_START(rdev->mc.vram_start >> 16) |
+			S_000001_MC_FB_TOP(rdev->mc.vram_end >> 16));
+	WREG32(R_000134_HDP_FB_LOCATION,
+		S_000134_HDP_FB_START(rdev->mc.vram_start >> 16));
+	if (rdev->flags & RADEON_IS_AGP) {
+		WREG32_MC(R_000002_MC_AGP_LOCATION,
+			S_000002_MC_AGP_START(rdev->mc.gtt_start >> 16) |
+			S_000002_MC_AGP_TOP(rdev->mc.gtt_end >> 16));
+		WREG32_MC(R_000003_MC_AGP_BASE, lower_32_bits(rdev->mc.agp_base));
+		WREG32_MC(R_000004_MC_AGP_BASE_2,
+			S_000004_AGP_BASE_ADDR_2(upper_32_bits(rdev->mc.agp_base)));
+	} else {
+		WREG32_MC(R_000002_MC_AGP_LOCATION, 0xFFFFFFFF);
+		WREG32_MC(R_000003_MC_AGP_BASE, 0);
+		WREG32_MC(R_000004_MC_AGP_BASE_2, 0);
+	}
+
+	rv515_mc_resume(rdev, &save);
+}
+
+void rv515_clock_startup(struct radeon_device *rdev)
+{
+	if (radeon_dynclks != -1 && radeon_dynclks)
+		radeon_atom_set_clock_gating(rdev, 1);
+	/* We need to force on some of the block */
+	WREG32_PLL(R_00000F_CP_DYN_CNTL,
+		RREG32_PLL(R_00000F_CP_DYN_CNTL) | S_00000F_CP_FORCEON(1));
+	WREG32_PLL(R_000011_E2_DYN_CNTL,
+		RREG32_PLL(R_000011_E2_DYN_CNTL) | S_000011_E2_FORCEON(1));
+	WREG32_PLL(R_000013_IDCT_DYN_CNTL,
+		RREG32_PLL(R_000013_IDCT_DYN_CNTL) | S_000013_IDCT_FORCEON(1));
+}
+
+static int rv515_startup(struct radeon_device *rdev)
+{
+	int r;
+
+	rv515_mc_program(rdev);
+	/* Resume clock */
+	rv515_clock_startup(rdev);
+	/* Initialize GPU configuration (# pipes, ...) */
+	rv515_gpu_init(rdev);
+	/* Initialize GART (initialize after TTM so we can allocate
+	 * memory through TTM but finalize after TTM) */
+	if (rdev->flags & RADEON_IS_PCIE) {
+		r = rv370_pcie_gart_enable(rdev);
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
+int rv515_resume(struct radeon_device *rdev)
+{
+	/* Make sur GART are not working */
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_disable(rdev);
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
+	return rv515_startup(rdev);
+}
+
+int rv515_suspend(struct radeon_device *rdev)
+{
+	r100_cp_disable(rdev);
+	r100_wb_disable(rdev);
+	r100_irq_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_disable(rdev);
+	return 0;
+}
+
+void rv515_set_safe_registers(struct radeon_device *rdev)
 {
 	rdev->config.r300.reg_safe_bm = rv515_reg_safe_bm;
 	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(rv515_reg_safe_bm);
+}
+
+void rv515_fini(struct radeon_device *rdev)
+{
+	rv515_suspend(rdev);
+	r100_cp_fini(rdev);
+	r100_wb_fini(rdev);
+	r100_ib_fini(rdev);
+	radeon_gem_fini(rdev);
+    rv370_pcie_gart_fini(rdev);
+	radeon_agp_fini(rdev);
+	radeon_irq_kms_fini(rdev);
+	radeon_fence_driver_fini(rdev);
+	radeon_object_fini(rdev);
+	radeon_atombios_fini(rdev);
+	kfree(rdev->bios);
+	rdev->bios = NULL;
+}
+
+int rv515_init(struct radeon_device *rdev)
+{
+	int r;
+
+	rdev->new_init_path = true;
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
+	rv515_vram_info(rdev);
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
+	r = rv370_pcie_gart_init(rdev);
+	if (r)
+		return r;
+	rv515_set_safe_registers(rdev);
+	rdev->accel_working = true;
+	r = rv515_startup(rdev);
+	if (r) {
+		/* Somethings want wront with the accel init stop accel */
+		dev_err(rdev->dev, "Disabling GPU acceleration\n");
+		rv515_suspend(rdev);
+		r100_cp_fini(rdev);
+		r100_wb_fini(rdev);
+		r100_ib_fini(rdev);
+		rv370_pcie_gart_fini(rdev);
+		radeon_agp_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
+	}
 	return 0;
 }
 
diff --git a/drivers/gpu/drm/radeon/rv515d.h b/drivers/gpu/drm/radeon/rv515d.h
index a65e17e..fc216e4 100644
--- a/drivers/gpu/drm/radeon/rv515d.h
+++ b/drivers/gpu/drm/radeon/rv515d.h
@@ -216,5 +216,388 @@
 #define CP_PACKET0_GET_ONE_REG_WR(h) (((h) >> 15) & 1)
 #define CP_PACKET3_GET_OPCODE(h) (((h) >> 8) & 0xFF)
 
-#endif
+/* Registers */
+#define R_0000F8_CONFIG_MEMSIZE                      0x0000F8
+#define   S_0000F8_CONFIG_MEMSIZE(x)                   (((x) & 0xFFFFFFFF) << 0)
+#define   G_0000F8_CONFIG_MEMSIZE(x)                   (((x) >> 0) & 0xFFFFFFFF)
+#define   C_0000F8_CONFIG_MEMSIZE                      0x00000000
+#define R_000134_HDP_FB_LOCATION                     0x000134
+#define   S_000134_HDP_FB_START(x)                     (((x) & 0xFFFF) << 0)
+#define   G_000134_HDP_FB_START(x)                     (((x) >> 0) & 0xFFFF)
+#define   C_000134_HDP_FB_START                        0xFFFF0000
+#define R_000300_VGA_RENDER_CONTROL                  0x000300
+#define   S_000300_VGA_BLINK_RATE(x)                   (((x) & 0x1F) << 0)
+#define   G_000300_VGA_BLINK_RATE(x)                   (((x) >> 0) & 0x1F)
+#define   C_000300_VGA_BLINK_RATE                      0xFFFFFFE0
+#define   S_000300_VGA_BLINK_MODE(x)                   (((x) & 0x3) << 5)
+#define   G_000300_VGA_BLINK_MODE(x)                   (((x) >> 5) & 0x3)
+#define   C_000300_VGA_BLINK_MODE                      0xFFFFFF9F
+#define   S_000300_VGA_CURSOR_BLINK_INVERT(x)          (((x) & 0x1) << 7)
+#define   G_000300_VGA_CURSOR_BLINK_INVERT(x)          (((x) >> 7) & 0x1)
+#define   C_000300_VGA_CURSOR_BLINK_INVERT             0xFFFFFF7F
+#define   S_000300_VGA_EXTD_ADDR_COUNT_ENABLE(x)       (((x) & 0x1) << 8)
+#define   G_000300_VGA_EXTD_ADDR_COUNT_ENABLE(x)       (((x) >> 8) & 0x1)
+#define   C_000300_VGA_EXTD_ADDR_COUNT_ENABLE          0xFFFFFEFF
+#define   S_000300_VGA_VSTATUS_CNTL(x)                 (((x) & 0x3) << 16)
+#define   G_000300_VGA_VSTATUS_CNTL(x)                 (((x) >> 16) & 0x3)
+#define   C_000300_VGA_VSTATUS_CNTL                    0xFFFCFFFF
+#define   S_000300_VGA_LOCK_8DOT(x)                    (((x) & 0x1) << 24)
+#define   G_000300_VGA_LOCK_8DOT(x)                    (((x) >> 24) & 0x1)
+#define   C_000300_VGA_LOCK_8DOT                       0xFEFFFFFF
+#define   S_000300_VGAREG_LINECMP_COMPATIBILITY_SEL(x) (((x) & 0x1) << 25)
+#define   G_000300_VGAREG_LINECMP_COMPATIBILITY_SEL(x) (((x) >> 25) & 0x1)
+#define   C_000300_VGAREG_LINECMP_COMPATIBILITY_SEL    0xFDFFFFFF
+#define R_000310_VGA_MEMORY_BASE_ADDRESS             0x000310
+#define   S_000310_VGA_MEMORY_BASE_ADDRESS(x)          (((x) & 0xFFFFFFFF) << 0)
+#define   G_000310_VGA_MEMORY_BASE_ADDRESS(x)          (((x) >> 0) & 0xFFFFFFFF)
+#define   C_000310_VGA_MEMORY_BASE_ADDRESS             0x00000000
+#define R_000328_VGA_HDP_CONTROL                     0x000328
+#define   S_000328_VGA_MEM_PAGE_SELECT_EN(x)           (((x) & 0x1) << 0)
+#define   G_000328_VGA_MEM_PAGE_SELECT_EN(x)           (((x) >> 0) & 0x1)
+#define   C_000328_VGA_MEM_PAGE_SELECT_EN              0xFFFFFFFE
+#define   S_000328_VGA_RBBM_LOCK_DISABLE(x)            (((x) & 0x1) << 8)
+#define   G_000328_VGA_RBBM_LOCK_DISABLE(x)            (((x) >> 8) & 0x1)
+#define   C_000328_VGA_RBBM_LOCK_DISABLE               0xFFFFFEFF
+#define   S_000328_VGA_SOFT_RESET(x)                   (((x) & 0x1) << 16)
+#define   G_000328_VGA_SOFT_RESET(x)                   (((x) >> 16) & 0x1)
+#define   C_000328_VGA_SOFT_RESET                      0xFFFEFFFF
+#define   S_000328_VGA_TEST_RESET_CONTROL(x)           (((x) & 0x1) << 24)
+#define   G_000328_VGA_TEST_RESET_CONTROL(x)           (((x) >> 24) & 0x1)
+#define   C_000328_VGA_TEST_RESET_CONTROL              0xFEFFFFFF
+#define R_000330_D1VGA_CONTROL                       0x000330
+#define   S_000330_D1VGA_MODE_ENABLE(x)                (((x) & 0x1) << 0)
+#define   G_000330_D1VGA_MODE_ENABLE(x)                (((x) >> 0) & 0x1)
+#define   C_000330_D1VGA_MODE_ENABLE                   0xFFFFFFFE
+#define   S_000330_D1VGA_TIMING_SELECT(x)              (((x) & 0x1) << 8)
+#define   G_000330_D1VGA_TIMING_SELECT(x)              (((x) >> 8) & 0x1)
+#define   C_000330_D1VGA_TIMING_SELECT                 0xFFFFFEFF
+#define   S_000330_D1VGA_SYNC_POLARITY_SELECT(x)       (((x) & 0x1) << 9)
+#define   G_000330_D1VGA_SYNC_POLARITY_SELECT(x)       (((x) >> 9) & 0x1)
+#define   C_000330_D1VGA_SYNC_POLARITY_SELECT          0xFFFFFDFF
+#define   S_000330_D1VGA_OVERSCAN_TIMING_SELECT(x)     (((x) & 0x1) << 10)
+#define   G_000330_D1VGA_OVERSCAN_TIMING_SELECT(x)     (((x) >> 10) & 0x1)
+#define   C_000330_D1VGA_OVERSCAN_TIMING_SELECT        0xFFFFFBFF
+#define   S_000330_D1VGA_OVERSCAN_COLOR_EN(x)          (((x) & 0x1) << 16)
+#define   G_000330_D1VGA_OVERSCAN_COLOR_EN(x)          (((x) >> 16) & 0x1)
+#define   C_000330_D1VGA_OVERSCAN_COLOR_EN             0xFFFEFFFF
+#define   S_000330_D1VGA_ROTATE(x)                     (((x) & 0x3) << 24)
+#define   G_000330_D1VGA_ROTATE(x)                     (((x) >> 24) & 0x3)
+#define   C_000330_D1VGA_ROTATE                        0xFCFFFFFF
+#define R_000338_D2VGA_CONTROL                       0x000338
+#define   S_000338_D2VGA_MODE_ENABLE(x)                (((x) & 0x1) << 0)
+#define   G_000338_D2VGA_MODE_ENABLE(x)                (((x) >> 0) & 0x1)
+#define   C_000338_D2VGA_MODE_ENABLE                   0xFFFFFFFE
+#define   S_000338_D2VGA_TIMING_SELECT(x)              (((x) & 0x1) << 8)
+#define   G_000338_D2VGA_TIMING_SELECT(x)              (((x) >> 8) & 0x1)
+#define   C_000338_D2VGA_TIMING_SELECT                 0xFFFFFEFF
+#define   S_000338_D2VGA_SYNC_POLARITY_SELECT(x)       (((x) & 0x1) << 9)
+#define   G_000338_D2VGA_SYNC_POLARITY_SELECT(x)       (((x) >> 9) & 0x1)
+#define   C_000338_D2VGA_SYNC_POLARITY_SELECT          0xFFFFFDFF
+#define   S_000338_D2VGA_OVERSCAN_TIMING_SELECT(x)     (((x) & 0x1) << 10)
+#define   G_000338_D2VGA_OVERSCAN_TIMING_SELECT(x)     (((x) >> 10) & 0x1)
+#define   C_000338_D2VGA_OVERSCAN_TIMING_SELECT        0xFFFFFBFF
+#define   S_000338_D2VGA_OVERSCAN_COLOR_EN(x)          (((x) & 0x1) << 16)
+#define   G_000338_D2VGA_OVERSCAN_COLOR_EN(x)          (((x) >> 16) & 0x1)
+#define   C_000338_D2VGA_OVERSCAN_COLOR_EN             0xFFFEFFFF
+#define   S_000338_D2VGA_ROTATE(x)                     (((x) & 0x3) << 24)
+#define   G_000338_D2VGA_ROTATE(x)                     (((x) >> 24) & 0x3)
+#define   C_000338_D2VGA_ROTATE                        0xFCFFFFFF
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
+#define   S_000E40_RBBM_HIBUSY(x)                      (((x) & 0x1) << 28)
+#define   G_000E40_RBBM_HIBUSY(x)                      (((x) >> 28) & 0x1)
+#define   C_000E40_RBBM_HIBUSY                         0xEFFFFFFF
+#define   S_000E40_SKID_CFBUSY(x)                      (((x) & 0x1) << 29)
+#define   G_000E40_SKID_CFBUSY(x)                      (((x) >> 29) & 0x1)
+#define   C_000E40_SKID_CFBUSY                         0xDFFFFFFF
+#define   S_000E40_VAP_VF_BUSY(x)                      (((x) & 0x1) << 30)
+#define   G_000E40_VAP_VF_BUSY(x)                      (((x) >> 30) & 0x1)
+#define   C_000E40_VAP_VF_BUSY                         0xBFFFFFFF
+#define   S_000E40_GUI_ACTIVE(x)                       (((x) & 0x1) << 31)
+#define   G_000E40_GUI_ACTIVE(x)                       (((x) >> 31) & 0x1)
+#define   C_000E40_GUI_ACTIVE                          0x7FFFFFFF
+#define R_006080_D1CRTC_CONTROL                      0x006080
+#define   S_006080_D1CRTC_MASTER_EN(x)                 (((x) & 0x1) << 0)
+#define   G_006080_D1CRTC_MASTER_EN(x)                 (((x) >> 0) & 0x1)
+#define   C_006080_D1CRTC_MASTER_EN                    0xFFFFFFFE
+#define   S_006080_D1CRTC_SYNC_RESET_SEL(x)            (((x) & 0x1) << 4)
+#define   G_006080_D1CRTC_SYNC_RESET_SEL(x)            (((x) >> 4) & 0x1)
+#define   C_006080_D1CRTC_SYNC_RESET_SEL               0xFFFFFFEF
+#define   S_006080_D1CRTC_DISABLE_POINT_CNTL(x)        (((x) & 0x3) << 8)
+#define   G_006080_D1CRTC_DISABLE_POINT_CNTL(x)        (((x) >> 8) & 0x3)
+#define   C_006080_D1CRTC_DISABLE_POINT_CNTL           0xFFFFFCFF
+#define   S_006080_D1CRTC_CURRENT_MASTER_EN_STATE(x)   (((x) & 0x1) << 16)
+#define   G_006080_D1CRTC_CURRENT_MASTER_EN_STATE(x)   (((x) >> 16) & 0x1)
+#define   C_006080_D1CRTC_CURRENT_MASTER_EN_STATE      0xFFFEFFFF
+#define   S_006080_D1CRTC_DISP_READ_REQUEST_DISABLE(x) (((x) & 0x1) << 24)
+#define   G_006080_D1CRTC_DISP_READ_REQUEST_DISABLE(x) (((x) >> 24) & 0x1)
+#define   C_006080_D1CRTC_DISP_READ_REQUEST_DISABLE    0xFEFFFFFF
+#define R_0060E8_D1CRTC_UPDATE_LOCK                  0x0060E8
+#define   S_0060E8_D1CRTC_UPDATE_LOCK(x)               (((x) & 0x1) << 0)
+#define   G_0060E8_D1CRTC_UPDATE_LOCK(x)               (((x) >> 0) & 0x1)
+#define   C_0060E8_D1CRTC_UPDATE_LOCK                  0xFFFFFFFE
+#define R_006110_D1GRPH_PRIMARY_SURFACE_ADDRESS      0x006110
+#define   S_006110_D1GRPH_PRIMARY_SURFACE_ADDRESS(x)   (((x) & 0xFFFFFFFF) << 0)
+#define   G_006110_D1GRPH_PRIMARY_SURFACE_ADDRESS(x)   (((x) >> 0) & 0xFFFFFFFF)
+#define   C_006110_D1GRPH_PRIMARY_SURFACE_ADDRESS      0x00000000
+#define R_006118_D1GRPH_SECONDARY_SURFACE_ADDRESS    0x006118
+#define   S_006118_D1GRPH_SECONDARY_SURFACE_ADDRESS(x) (((x) & 0xFFFFFFFF) << 0)
+#define   G_006118_D1GRPH_SECONDARY_SURFACE_ADDRESS(x) (((x) >> 0) & 0xFFFFFFFF)
+#define   C_006118_D1GRPH_SECONDARY_SURFACE_ADDRESS    0x00000000
+#define R_006880_D2CRTC_CONTROL                      0x006880
+#define   S_006880_D2CRTC_MASTER_EN(x)                 (((x) & 0x1) << 0)
+#define   G_006880_D2CRTC_MASTER_EN(x)                 (((x) >> 0) & 0x1)
+#define   C_006880_D2CRTC_MASTER_EN                    0xFFFFFFFE
+#define   S_006880_D2CRTC_SYNC_RESET_SEL(x)            (((x) & 0x1) << 4)
+#define   G_006880_D2CRTC_SYNC_RESET_SEL(x)            (((x) >> 4) & 0x1)
+#define   C_006880_D2CRTC_SYNC_RESET_SEL               0xFFFFFFEF
+#define   S_006880_D2CRTC_DISABLE_POINT_CNTL(x)        (((x) & 0x3) << 8)
+#define   G_006880_D2CRTC_DISABLE_POINT_CNTL(x)        (((x) >> 8) & 0x3)
+#define   C_006880_D2CRTC_DISABLE_POINT_CNTL           0xFFFFFCFF
+#define   S_006880_D2CRTC_CURRENT_MASTER_EN_STATE(x)   (((x) & 0x1) << 16)
+#define   G_006880_D2CRTC_CURRENT_MASTER_EN_STATE(x)   (((x) >> 16) & 0x1)
+#define   C_006880_D2CRTC_CURRENT_MASTER_EN_STATE      0xFFFEFFFF
+#define   S_006880_D2CRTC_DISP_READ_REQUEST_DISABLE(x) (((x) & 0x1) << 24)
+#define   G_006880_D2CRTC_DISP_READ_REQUEST_DISABLE(x) (((x) >> 24) & 0x1)
+#define   C_006880_D2CRTC_DISP_READ_REQUEST_DISABLE    0xFEFFFFFF
+#define R_0068E8_D2CRTC_UPDATE_LOCK                  0x0068E8
+#define   S_0068E8_D2CRTC_UPDATE_LOCK(x)               (((x) & 0x1) << 0)
+#define   G_0068E8_D2CRTC_UPDATE_LOCK(x)               (((x) >> 0) & 0x1)
+#define   C_0068E8_D2CRTC_UPDATE_LOCK                  0xFFFFFFFE
+#define R_006910_D2GRPH_PRIMARY_SURFACE_ADDRESS      0x006910
+#define   S_006910_D2GRPH_PRIMARY_SURFACE_ADDRESS(x)   (((x) & 0xFFFFFFFF) << 0)
+#define   G_006910_D2GRPH_PRIMARY_SURFACE_ADDRESS(x)   (((x) >> 0) & 0xFFFFFFFF)
+#define   C_006910_D2GRPH_PRIMARY_SURFACE_ADDRESS      0x00000000
+#define R_006918_D2GRPH_SECONDARY_SURFACE_ADDRESS    0x006918
+#define   S_006918_D2GRPH_SECONDARY_SURFACE_ADDRESS(x) (((x) & 0xFFFFFFFF) << 0)
+#define   G_006918_D2GRPH_SECONDARY_SURFACE_ADDRESS(x) (((x) >> 0) & 0xFFFFFFFF)
+#define   C_006918_D2GRPH_SECONDARY_SURFACE_ADDRESS    0x00000000
+
+
+#define R_000001_MC_FB_LOCATION                      0x000001
+#define   S_000001_MC_FB_START(x)                      (((x) & 0xFFFF) << 0)
+#define   G_000001_MC_FB_START(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_000001_MC_FB_START                         0xFFFF0000
+#define   S_000001_MC_FB_TOP(x)                        (((x) & 0xFFFF) << 16)
+#define   G_000001_MC_FB_TOP(x)                        (((x) >> 16) & 0xFFFF)
+#define   C_000001_MC_FB_TOP                           0x0000FFFF
+#define R_000002_MC_AGP_LOCATION                     0x000002
+#define   S_000002_MC_AGP_START(x)                     (((x) & 0xFFFF) << 0)
+#define   G_000002_MC_AGP_START(x)                     (((x) >> 0) & 0xFFFF)
+#define   C_000002_MC_AGP_START                        0xFFFF0000
+#define   S_000002_MC_AGP_TOP(x)                       (((x) & 0xFFFF) << 16)
+#define   G_000002_MC_AGP_TOP(x)                       (((x) >> 16) & 0xFFFF)
+#define   C_000002_MC_AGP_TOP                          0x0000FFFF
+#define R_000003_MC_AGP_BASE                         0x000003
+#define   S_000003_AGP_BASE_ADDR(x)                    (((x) & 0xFFFFFFFF) << 0)
+#define   G_000003_AGP_BASE_ADDR(x)                    (((x) >> 0) & 0xFFFFFFFF)
+#define   C_000003_AGP_BASE_ADDR                       0x00000000
+#define R_000004_MC_AGP_BASE_2                       0x000004
+#define   S_000004_AGP_BASE_ADDR_2(x)                  (((x) & 0xF) << 0)
+#define   G_000004_AGP_BASE_ADDR_2(x)                  (((x) >> 0) & 0xF)
+#define   C_000004_AGP_BASE_ADDR_2                     0xFFFFFFF0
 
+
+#define R_00000F_CP_DYN_CNTL                         0x00000F
+#define   S_00000F_CP_FORCEON(x)                       (((x) & 0x1) << 0)
+#define   G_00000F_CP_FORCEON(x)                       (((x) >> 0) & 0x1)
+#define   C_00000F_CP_FORCEON                          0xFFFFFFFE
+#define   S_00000F_CP_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 1)
+#define   G_00000F_CP_MAX_DYN_STOP_LAT(x)              (((x) >> 1) & 0x1)
+#define   C_00000F_CP_MAX_DYN_STOP_LAT                 0xFFFFFFFD
+#define   S_00000F_CP_CLOCK_STATUS(x)                  (((x) & 0x1) << 2)
+#define   G_00000F_CP_CLOCK_STATUS(x)                  (((x) >> 2) & 0x1)
+#define   C_00000F_CP_CLOCK_STATUS                     0xFFFFFFFB
+#define   S_00000F_CP_PROG_SHUTOFF(x)                  (((x) & 0x1) << 3)
+#define   G_00000F_CP_PROG_SHUTOFF(x)                  (((x) >> 3) & 0x1)
+#define   C_00000F_CP_PROG_SHUTOFF                     0xFFFFFFF7
+#define   S_00000F_CP_PROG_DELAY_VALUE(x)              (((x) & 0xFF) << 4)
+#define   G_00000F_CP_PROG_DELAY_VALUE(x)              (((x) >> 4) & 0xFF)
+#define   C_00000F_CP_PROG_DELAY_VALUE                 0xFFFFF00F
+#define   S_00000F_CP_LOWER_POWER_IDLE(x)              (((x) & 0xFF) << 12)
+#define   G_00000F_CP_LOWER_POWER_IDLE(x)              (((x) >> 12) & 0xFF)
+#define   C_00000F_CP_LOWER_POWER_IDLE                 0xFFF00FFF
+#define   S_00000F_CP_LOWER_POWER_IGNORE(x)            (((x) & 0x1) << 20)
+#define   G_00000F_CP_LOWER_POWER_IGNORE(x)            (((x) >> 20) & 0x1)
+#define   C_00000F_CP_LOWER_POWER_IGNORE               0xFFEFFFFF
+#define   S_00000F_CP_NORMAL_POWER_IGNORE(x)           (((x) & 0x1) << 21)
+#define   G_00000F_CP_NORMAL_POWER_IGNORE(x)           (((x) >> 21) & 0x1)
+#define   C_00000F_CP_NORMAL_POWER_IGNORE              0xFFDFFFFF
+#define   S_00000F_SPARE(x)                            (((x) & 0x3) << 22)
+#define   G_00000F_SPARE(x)                            (((x) >> 22) & 0x3)
+#define   C_00000F_SPARE                               0xFF3FFFFF
+#define   S_00000F_CP_NORMAL_POWER_BUSY(x)             (((x) & 0xFF) << 24)
+#define   G_00000F_CP_NORMAL_POWER_BUSY(x)             (((x) >> 24) & 0xFF)
+#define   C_00000F_CP_NORMAL_POWER_BUSY                0x00FFFFFF
+#define R_000011_E2_DYN_CNTL                         0x000011
+#define   S_000011_E2_FORCEON(x)                       (((x) & 0x1) << 0)
+#define   G_000011_E2_FORCEON(x)                       (((x) >> 0) & 0x1)
+#define   C_000011_E2_FORCEON                          0xFFFFFFFE
+#define   S_000011_E2_MAX_DYN_STOP_LAT(x)              (((x) & 0x1) << 1)
+#define   G_000011_E2_MAX_DYN_STOP_LAT(x)              (((x) >> 1) & 0x1)
+#define   C_000011_E2_MAX_DYN_STOP_LAT                 0xFFFFFFFD
+#define   S_000011_E2_CLOCK_STATUS(x)                  (((x) & 0x1) << 2)
+#define   G_000011_E2_CLOCK_STATUS(x)                  (((x) >> 2) & 0x1)
+#define   C_000011_E2_CLOCK_STATUS                     0xFFFFFFFB
+#define   S_000011_E2_PROG_SHUTOFF(x)                  (((x) & 0x1) << 3)
+#define   G_000011_E2_PROG_SHUTOFF(x)                  (((x) >> 3) & 0x1)
+#define   C_000011_E2_PROG_SHUTOFF                     0xFFFFFFF7
+#define   S_000011_E2_PROG_DELAY_VALUE(x)              (((x) & 0xFF) << 4)
+#define   G_000011_E2_PROG_DELAY_VALUE(x)              (((x) >> 4) & 0xFF)
+#define   C_000011_E2_PROG_DELAY_VALUE                 0xFFFFF00F
+#define   S_000011_E2_LOWER_POWER_IDLE(x)              (((x) & 0xFF) << 12)
+#define   G_000011_E2_LOWER_POWER_IDLE(x)              (((x) >> 12) & 0xFF)
+#define   C_000011_E2_LOWER_POWER_IDLE                 0xFFF00FFF
+#define   S_000011_E2_LOWER_POWER_IGNORE(x)            (((x) & 0x1) << 20)
+#define   G_000011_E2_LOWER_POWER_IGNORE(x)            (((x) >> 20) & 0x1)
+#define   C_000011_E2_LOWER_POWER_IGNORE               0xFFEFFFFF
+#define   S_000011_E2_NORMAL_POWER_IGNORE(x)           (((x) & 0x1) << 21)
+#define   G_000011_E2_NORMAL_POWER_IGNORE(x)           (((x) >> 21) & 0x1)
+#define   C_000011_E2_NORMAL_POWER_IGNORE              0xFFDFFFFF
+#define   S_000011_SPARE(x)                            (((x) & 0x3) << 22)
+#define   G_000011_SPARE(x)                            (((x) >> 22) & 0x3)
+#define   C_000011_SPARE                               0xFF3FFFFF
+#define   S_000011_E2_NORMAL_POWER_BUSY(x)             (((x) & 0xFF) << 24)
+#define   G_000011_E2_NORMAL_POWER_BUSY(x)             (((x) >> 24) & 0xFF)
+#define   C_000011_E2_NORMAL_POWER_BUSY                0x00FFFFFF
+#define R_000013_IDCT_DYN_CNTL                       0x000013
+#define   S_000013_IDCT_FORCEON(x)                     (((x) & 0x1) << 0)
+#define   G_000013_IDCT_FORCEON(x)                     (((x) >> 0) & 0x1)
+#define   C_000013_IDCT_FORCEON                        0xFFFFFFFE
+#define   S_000013_IDCT_MAX_DYN_STOP_LAT(x)            (((x) & 0x1) << 1)
+#define   G_000013_IDCT_MAX_DYN_STOP_LAT(x)            (((x) >> 1) & 0x1)
+#define   C_000013_IDCT_MAX_DYN_STOP_LAT               0xFFFFFFFD
+#define   S_000013_IDCT_CLOCK_STATUS(x)                (((x) & 0x1) << 2)
+#define   G_000013_IDCT_CLOCK_STATUS(x)                (((x) >> 2) & 0x1)
+#define   C_000013_IDCT_CLOCK_STATUS                   0xFFFFFFFB
+#define   S_000013_IDCT_PROG_SHUTOFF(x)                (((x) & 0x1) << 3)
+#define   G_000013_IDCT_PROG_SHUTOFF(x)                (((x) >> 3) & 0x1)
+#define   C_000013_IDCT_PROG_SHUTOFF                   0xFFFFFFF7
+#define   S_000013_IDCT_PROG_DELAY_VALUE(x)            (((x) & 0xFF) << 4)
+#define   G_000013_IDCT_PROG_DELAY_VALUE(x)            (((x) >> 4) & 0xFF)
+#define   C_000013_IDCT_PROG_DELAY_VALUE               0xFFFFF00F
+#define   S_000013_IDCT_LOWER_POWER_IDLE(x)            (((x) & 0xFF) << 12)
+#define   G_000013_IDCT_LOWER_POWER_IDLE(x)            (((x) >> 12) & 0xFF)
+#define   C_000013_IDCT_LOWER_POWER_IDLE               0xFFF00FFF
+#define   S_000013_IDCT_LOWER_POWER_IGNORE(x)          (((x) & 0x1) << 20)
+#define   G_000013_IDCT_LOWER_POWER_IGNORE(x)          (((x) >> 20) & 0x1)
+#define   C_000013_IDCT_LOWER_POWER_IGNORE             0xFFEFFFFF
+#define   S_000013_IDCT_NORMAL_POWER_IGNORE(x)         (((x) & 0x1) << 21)
+#define   G_000013_IDCT_NORMAL_POWER_IGNORE(x)         (((x) >> 21) & 0x1)
+#define   C_000013_IDCT_NORMAL_POWER_IGNORE            0xFFDFFFFF
+#define   S_000013_SPARE(x)                            (((x) & 0x3) << 22)
+#define   G_000013_SPARE(x)                            (((x) >> 22) & 0x3)
+#define   C_000013_SPARE                               0xFF3FFFFF
+#define   S_000013_IDCT_NORMAL_POWER_BUSY(x)           (((x) & 0xFF) << 24)
+#define   G_000013_IDCT_NORMAL_POWER_BUSY(x)           (((x) >> 24) & 0xFF)
+#define   C_000013_IDCT_NORMAL_POWER_BUSY              0x00FFFFFF
+
+#endif
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index efca509..e0b97d1 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -31,8 +31,8 @@
 #include "radeon.h"
 #include "radeon_drm.h"
 #include "rv770d.h"
-#include "avivod.h"
 #include "atom.h"
+#include "avivod.h"
 
 #define R700_PFP_UCODE_SIZE 848
 #define R700_PM4_UCODE_SIZE 1360
@@ -231,7 +231,7 @@ static void rv770_mc_resume(struct radeon_device *rdev)
 
 	/* we need to own VRAM, so turn off the VGA renderer here
 	 * to stop it overwriting our objects */
-	radeon_avivo_vga_render_disable(rdev);
+	rv515_vga_render_disable(rdev);
 }
 
 
-- 
1.6.4.4

