Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbZI1SjY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbZI1SjY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 14:39:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752729AbZI1SjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 14:39:23 -0400
Received: from nox.protox.org ([88.191.38.29]:48932 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751837AbZI1SjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 14:39:22 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert R520 to new init path and associated cleanup
Date: Mon, 28 Sep 2009 20:39:19 +0200
Message-Id: <1254163159-2323-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert the r520 asic support to new init path, change are smaller than
previous one as most of the architecture is now in place and more code
sharing can happen btw various asics.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r520.c        |  267 ++++++++++++++++++++-------------
 drivers/gpu/drm/radeon/r520d.h       |  187 ++++++++++++++++++++++++
 drivers/gpu/drm/radeon/radeon.h      |    5 +
 drivers/gpu/drm/radeon/radeon_asic.h |   43 +++---
 drivers/gpu/drm/radeon/rv515.c       |    2 +-
 5 files changed, 376 insertions(+), 128 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/r520d.h

diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 2723486..0bf13fc 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -26,107 +26,13 @@
  *          Jerome Glisse
  */
 #include "drmP.h"
-#include "radeon_reg.h"
 #include "radeon.h"
+#include "atom.h"
+#include "r520d.h"
 
-/* r520,rv530,rv560,rv570,r580 depends on : */
-void r100_hdp_reset(struct radeon_device *rdev);
-void r420_pipes_init(struct radeon_device *rdev);
-void rs600_mc_disable_clients(struct radeon_device *rdev);
-int rv515_debugfs_pipes_info_init(struct radeon_device *rdev);
-int rv515_debugfs_ga_info_init(struct radeon_device *rdev);
+/* This files gather functions specifics to: r520,rv530,rv560,rv570,r580 */
 
-/* This files gather functions specifics to:
- * r520,rv530,rv560,rv570,r580
- *
- * Some of these functions might be used by newer ASICs.
- */
-void r520_gpu_init(struct radeon_device *rdev);
-int r520_mc_wait_for_idle(struct radeon_device *rdev);
-
-
-/*
- * MC
- */
-int r520_mc_init(struct radeon_device *rdev)
-{
-	uint32_t tmp;
-	int r;
-
-	if (r100_debugfs_rbbm_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-	}
-	if (rv515_debugfs_pipes_info_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for pipes !\n");
-	}
-	if (rv515_debugfs_ga_info_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for pipes !\n");
-	}
-
-	r520_gpu_init(rdev);
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
-	if (r520_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-	/* Write VRAM size in case we are limiting it */
-	WREG32(RADEON_CONFIG_MEMSIZE, rdev->mc.real_vram_size);
-	tmp = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
-	tmp = REG_SET(R520_MC_FB_TOP, tmp >> 16);
-	tmp |= REG_SET(R520_MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32_MC(R520_MC_FB_LOCATION, tmp);
-	WREG32(RS690_HDP_FB_LOCATION, rdev->mc.vram_location >> 16);
-	WREG32(0x310, rdev->mc.vram_location);
-	if (rdev->flags & RADEON_IS_AGP) {
-		tmp = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
-		tmp = REG_SET(R520_MC_AGP_TOP, tmp >> 16);
-		tmp |= REG_SET(R520_MC_AGP_START, rdev->mc.gtt_location >> 16);
-		WREG32_MC(R520_MC_AGP_LOCATION, tmp);
-		WREG32_MC(R520_MC_AGP_BASE, rdev->mc.agp_base);
-		WREG32_MC(R520_MC_AGP_BASE_2, 0);
-	} else {
-		WREG32_MC(R520_MC_AGP_LOCATION, 0x0FFFFFFF);
-		WREG32_MC(R520_MC_AGP_BASE, 0);
-		WREG32_MC(R520_MC_AGP_BASE_2, 0);
-	}
-	return 0;
-}
-
-void r520_mc_fini(struct radeon_device *rdev)
-{
-}
-
-
-/*
- * Global GPU functions
- */
-void r520_errata(struct radeon_device *rdev)
-{
-	rdev->pll_errata = 0;
-}
-
-int r520_mc_wait_for_idle(struct radeon_device *rdev)
+static int r520_mc_wait_for_idle(struct radeon_device *rdev)
 {
 	unsigned i;
 	uint32_t tmp;
@@ -142,7 +48,7 @@ int r520_mc_wait_for_idle(struct radeon_device *rdev)
 	return -1;
 }
 
-void r520_gpu_init(struct radeon_device *rdev)
+static void r520_gpu_init(struct radeon_device *rdev)
 {
 	unsigned pipe_select_current, gb_pipe_select, tmp;
 
@@ -185,10 +91,6 @@ void r520_gpu_init(struct radeon_device *rdev)
 	}
 }
 
-
-/*
- * VRAM info
- */
 static void r520_vram_get_type(struct radeon_device *rdev)
 {
 	uint32_t tmp;
@@ -232,13 +134,168 @@ void r520_vram_info(struct radeon_device *rdev)
 	rdev->pm.sclk.full = rfixed_div(rdev->pm.sclk, a);
 }
 
-void r520_bandwidth_update(struct radeon_device *rdev)
+void r520_mc_program(struct radeon_device *rdev)
+{
+	struct rv515_mc_save save;
+
+	/* Stops all mc clients */
+	rv515_mc_stop(rdev, &save);
+
+	/* Wait for mc idle */
+	if (r520_mc_wait_for_idle(rdev))
+		dev_warn(rdev->dev, "Wait MC idle timeout before updating MC.\n");
+	/* Write VRAM size in case we are limiting it */
+	WREG32(R_0000F8_CONFIG_MEMSIZE, rdev->mc.real_vram_size);
+	/* Program MC, should be a 32bits limited address space */
+	WREG32_MC(R_000004_MC_FB_LOCATION,
+			S_000004_MC_FB_START(rdev->mc.vram_start >> 16) |
+			S_000004_MC_FB_TOP(rdev->mc.vram_end >> 16));
+	WREG32(R_000134_HDP_FB_LOCATION,
+		S_000134_HDP_FB_START(rdev->mc.vram_start >> 16));
+	if (rdev->flags & RADEON_IS_AGP) {
+		WREG32_MC(R_000005_MC_AGP_LOCATION,
+			S_000005_MC_AGP_START(rdev->mc.gtt_start >> 16) |
+			S_000005_MC_AGP_TOP(rdev->mc.gtt_end >> 16));
+		WREG32_MC(R_000006_AGP_BASE, lower_32_bits(rdev->mc.agp_base));
+		WREG32_MC(R_000007_AGP_BASE_2,
+			S_000007_AGP_BASE_ADDR_2(upper_32_bits(rdev->mc.agp_base)));
+	} else {
+		WREG32_MC(R_000005_MC_AGP_LOCATION, 0xFFFFFFFF);
+		WREG32_MC(R_000006_AGP_BASE, 0);
+		WREG32_MC(R_000007_AGP_BASE_2, 0);
+	}
+
+	rv515_mc_resume(rdev, &save);
+}
+
+static int r520_startup(struct radeon_device *rdev)
+{
+	int r;
+
+	r520_mc_program(rdev);
+	/* Resume clock */
+	rv515_clock_startup(rdev);
+	/* Initialize GPU configuration (# pipes, ...) */
+	r520_gpu_init(rdev);
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
+int r520_resume(struct radeon_device *rdev)
 {
-	rv515_bandwidth_avivo_update(rdev);
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
+	return r520_startup(rdev);
 }
 
 int r520_init(struct radeon_device *rdev)
 {
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
+	r520_vram_info(rdev);
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
 	rv515_set_safe_registers(rdev);
+	rdev->accel_working = true;
+	r = r520_startup(rdev);
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
diff --git a/drivers/gpu/drm/radeon/r520d.h b/drivers/gpu/drm/radeon/r520d.h
new file mode 100644
index 0000000..61af61f
--- /dev/null
+++ b/drivers/gpu/drm/radeon/r520d.h
@@ -0,0 +1,187 @@
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
+#ifndef __R520D_H__
+#define __R520D_H__
+
+/* Registers */
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
+
+
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
+
+#endif
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 116bedd..7b0965f 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1058,6 +1058,11 @@ struct rv515_mc_save {
 extern void rv515_bandwidth_avivo_update(struct radeon_device *rdev);
 extern void rv515_vga_render_disable(struct radeon_device *rdev);
 extern void rv515_set_safe_registers(struct radeon_device *rdev);
+extern void rv515_mc_stop(struct radeon_device *rdev, struct rv515_mc_save *save);
+extern void rv515_mc_resume(struct radeon_device *rdev, struct rv515_mc_save *save);
+extern void rv515_clock_startup(struct radeon_device *rdev);
+extern void rv515_debugfs(struct radeon_device *rdev);
+extern int rv515_suspend(struct radeon_device *rdev);
 
 /* rs690, rs740 */
 extern void rs690_line_buffer_adjust(struct radeon_device *rdev,
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index ccbf525..bce0cb0 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -471,34 +471,33 @@ static struct radeon_asic rv515_asic = {
  * r520,rv530,rv560,rv570,r580
  */
 int r520_init(struct radeon_device *rdev);
-void r520_errata(struct radeon_device *rdev);
-void r520_vram_info(struct radeon_device *rdev);
-int r520_mc_init(struct radeon_device *rdev);
-void r520_mc_fini(struct radeon_device *rdev);
-void r520_bandwidth_update(struct radeon_device *rdev);
+int r520_resume(struct radeon_device *rdev);
 static struct radeon_asic r520_asic = {
 	.init = &r520_init,
-	.errata = &r520_errata,
-	.vram_info = &r520_vram_info,
+	.fini = &rv515_fini,
+	.suspend = &rv515_suspend,
+	.resume = &r520_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &rv515_gpu_reset,
-	.mc_init = &r520_mc_init,
-	.mc_fini = &r520_mc_fini,
-	.wb_init = &r100_wb_init,
-	.wb_fini = &r100_wb_fini,
-	.gart_init = &rv370_pcie_gart_init,
-	.gart_fini = &rv370_pcie_gart_fini,
-	.gart_enable = &rv370_pcie_gart_enable,
-	.gart_disable = &rv370_pcie_gart_disable,
+	.mc_init = NULL,
+	.mc_fini = NULL,
+	.wb_init = NULL,
+	.wb_fini = NULL,
+	.gart_init = NULL,
+	.gart_fini = NULL,
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
@@ -513,7 +512,7 @@ static struct radeon_asic r520_asic = {
 	.set_clock_gating = &radeon_atom_set_clock_gating,
 	.set_surface_reg = r100_set_surface_reg,
 	.clear_surface_reg = r100_clear_surface_reg,
-	.bandwidth_update = &r520_bandwidth_update,
+	.bandwidth_update = &rv515_bandwidth_update,
 };
 
 /*
@@ -588,7 +587,7 @@ static struct radeon_asic r600_asic = {
 	.set_clock_gating = &radeon_atom_set_clock_gating,
 	.set_surface_reg = r600_set_surface_reg,
 	.clear_surface_reg = r600_clear_surface_reg,
-	.bandwidth_update = &r520_bandwidth_update,
+	.bandwidth_update = &rv515_bandwidth_update,
 };
 
 /*
@@ -637,7 +636,7 @@ static struct radeon_asic rv770_asic = {
 	.set_clock_gating = &radeon_atom_set_clock_gating,
 	.set_surface_reg = r600_set_surface_reg,
 	.clear_surface_reg = r600_clear_surface_reg,
-	.bandwidth_update = &r520_bandwidth_update,
+	.bandwidth_update = &rv515_bandwidth_update,
 };
 
 #endif
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index a837ddc..e53b5ca 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -38,7 +38,7 @@ int rv515_debugfs_ga_info_init(struct radeon_device *rdev);
 void rv515_gpu_init(struct radeon_device *rdev);
 int rv515_mc_wait_for_idle(struct radeon_device *rdev);
 
-static void rv515_debugfs(struct radeon_device *rdev)
+void rv515_debugfs(struct radeon_device *rdev)
 {
 	if (r100_debugfs_rbbm_init(rdev)) {
 		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-- 
1.6.4.4

