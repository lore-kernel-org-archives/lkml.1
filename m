Return-Path: <linux-kernel-owner+w=401wt.eu-S1754490AbZI3Nf7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754490AbZI3Nf7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 09:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754103AbZI3Nf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 09:35:58 -0400
Received: from nox.protox.org ([88.191.38.29]:40123 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203AbZI3Nf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 09:35:57 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert R300 to new init path
Date: Wed, 30 Sep 2009 15:35:32 +0200
Message-Id: <1254317732-11014-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also cleanup register specific to R300.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r300.c        |  293 +++++++++++++++++++++------------
 drivers/gpu/drm/radeon/r300d.h       |  113 +++++++++++++
 drivers/gpu/drm/radeon/radeon.h      |   10 ++
 drivers/gpu/drm/radeon/radeon_asic.h |   75 ++++-----
 4 files changed, 345 insertions(+), 146 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index e491d40..18c81dc 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -34,42 +34,15 @@
 #include "r100_track.h"
 #include "r300d.h"
 #include "rv350d.h"
-
 #include "r300_reg_safe.h"
 
-/* r300,r350,rv350,rv370,rv380 depends on : */
-void r100_hdp_reset(struct radeon_device *rdev);
-int r100_cp_reset(struct radeon_device *rdev);
-int r100_rb2d_reset(struct radeon_device *rdev);
-int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
-int r100_pci_gart_enable(struct radeon_device *rdev);
-void r100_mc_setup(struct radeon_device *rdev);
-void r100_mc_disable_clients(struct radeon_device *rdev);
-int r100_gui_wait_for_idle(struct radeon_device *rdev);
-int r100_cs_packet_parse(struct radeon_cs_parser *p,
-			 struct radeon_cs_packet *pkt,
-			 unsigned idx);
-int r100_cs_packet_parse_vline(struct radeon_cs_parser *p);
-int r100_cs_parse_packet0(struct radeon_cs_parser *p,
-			  struct radeon_cs_packet *pkt,
-			  const unsigned *auth, unsigned n,
-			  radeon_packet0_check_t check);
-int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
-					 struct radeon_cs_packet *pkt,
-					 struct radeon_object *robj);
-
-/* This files gather functions specifics to:
- * r300,r350,rv350,rv370,rv380
- *
- * Some of these functions might be used by newer ASICs.
- */
-void r300_gpu_init(struct radeon_device *rdev);
-int rv370_debugfs_pcie_gart_info_init(struct radeon_device *rdev);
-
+/* This files gather functions specifics to: r300,r350,rv350,rv370,rv380 */
 
 /*
  * rv370,rv380 PCIE GART
  */
+static int rv370_debugfs_pcie_gart_info_init(struct radeon_device *rdev);
+
 void rv370_pcie_gart_tlb_flush(struct radeon_device *rdev)
 {
 	uint32_t tmp;
@@ -182,59 +155,6 @@ void rv370_pcie_gart_fini(struct radeon_device *rdev)
 	radeon_gart_fini(rdev);
 }
 
-/*
- * MC
- */
-int r300_mc_init(struct radeon_device *rdev)
-{
-	int r;
-
-	if (r100_debugfs_rbbm_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-	}
-
-	r300_gpu_init(rdev);
-	r100_pci_gart_disable(rdev);
-	if (rdev->flags & RADEON_IS_PCIE) {
-		rv370_pcie_gart_disable(rdev);
-	}
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
-	r100_mc_disable_clients(rdev);
-	if (r300_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-	r100_mc_setup(rdev);
-	return 0;
-}
-
-void r300_mc_fini(struct radeon_device *rdev)
-{
-}
-
-
-/*
- * Fence emission
- */
 void r300_fence_ring_emit(struct radeon_device *rdev,
 			  struct radeon_fence *fence)
 {
@@ -260,10 +180,6 @@ void r300_fence_ring_emit(struct radeon_device *rdev,
 	radeon_ring_write(rdev, RADEON_SW_INT_FIRE);
 }
 
-
-/*
- * Global GPU functions
- */
 int r300_copy_dma(struct radeon_device *rdev,
 		  uint64_t src_offset,
 		  uint64_t dst_offset,
@@ -582,11 +498,6 @@ void r300_vram_info(struct radeon_device *rdev)
 	r100_vram_init_sizes(rdev);
 }
 
-
-/*
- * PCIE Lanes
- */
-
 void rv370_set_pcie_lanes(struct radeon_device *rdev, int lanes)
 {
 	uint32_t link_width_cntl, mask;
@@ -646,10 +557,6 @@ void rv370_set_pcie_lanes(struct radeon_device *rdev, int lanes)
 
 }
 
-
-/*
- * Debugfs info
- */
 #if defined(CONFIG_DEBUG_FS)
 static int rv370_debugfs_pcie_gart_info(struct seq_file *m, void *data)
 {
@@ -680,7 +587,7 @@ static struct drm_info_list rv370_pcie_gart_info_list[] = {
 };
 #endif
 
-int rv370_debugfs_pcie_gart_info_init(struct radeon_device *rdev)
+static int rv370_debugfs_pcie_gart_info_init(struct radeon_device *rdev)
 {
 #if defined(CONFIG_DEBUG_FS)
 	return radeon_debugfs_add_files(rdev, rv370_pcie_gart_info_list, 1);
@@ -689,10 +596,6 @@ int rv370_debugfs_pcie_gart_info_init(struct radeon_device *rdev)
 #endif
 }
 
-
-/*
- * CS functions
- */
 static int r300_packet0_check(struct radeon_cs_parser *p,
 		struct radeon_cs_packet *pkt,
 		unsigned idx, unsigned reg)
@@ -1226,12 +1129,6 @@ void r300_set_reg_safe(struct radeon_device *rdev)
 	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(r300_reg_safe_bm);
 }
 
-int r300_init(struct radeon_device *rdev)
-{
-	r300_set_reg_safe(rdev);
-	return 0;
-}
-
 void r300_mc_program(struct radeon_device *rdev)
 {
 	struct r100_mc_save save;
@@ -1279,3 +1176,185 @@ void r300_clock_startup(struct radeon_device *rdev)
 		tmp |= S_00000D_FORCE_VAP(1);
 	WREG32_PLL(R_00000D_SCLK_CNTL, tmp);
 }
+
+static int r300_startup(struct radeon_device *rdev)
+{
+	int r;
+
+	r300_mc_program(rdev);
+	/* Resume clock */
+	r300_clock_startup(rdev);
+	/* Initialize GPU configuration (# pipes, ...) */
+	r300_gpu_init(rdev);
+	/* Initialize GART (initialize after TTM so we can allocate
+	 * memory through TTM but finalize after TTM) */
+	if (rdev->flags & RADEON_IS_PCIE) {
+		r = rv370_pcie_gart_enable(rdev);
+		if (r)
+			return r;
+	}
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
+int r300_resume(struct radeon_device *rdev)
+{
+	/* Make sur GART are not working */
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_disable(rdev);
+	/* Resume clock before doing reset */
+	r300_clock_startup(rdev);
+	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
+	if (radeon_gpu_reset(rdev)) {
+		dev_warn(rdev->dev, "GPU reset failed ! (0xE40=0x%08X, 0x7C0=0x%08X)\n",
+			RREG32(R_000E40_RBBM_STATUS),
+			RREG32(R_0007C0_CP_STAT));
+	}
+	/* post */
+	radeon_combios_asic_init(rdev->ddev);
+	/* Resume clock after posting */
+	r300_clock_startup(rdev);
+	return r300_startup(rdev);
+}
+
+int r300_suspend(struct radeon_device *rdev)
+{
+	r100_cp_disable(rdev);
+	r100_wb_disable(rdev);
+	r100_irq_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_disable(rdev);
+	return 0;
+}
+
+void r300_fini(struct radeon_device *rdev)
+{
+	r300_suspend(rdev);
+	r100_cp_fini(rdev);
+	r100_wb_fini(rdev);
+	r100_ib_fini(rdev);
+	radeon_gem_fini(rdev);
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_fini(rdev);
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
+int r300_init(struct radeon_device *rdev)
+{
+	int r;
+
+	rdev->new_init_path = true;
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
+	r300_errata(rdev);
+	/* Initialize clocks */
+	radeon_get_clock_info(rdev->ddev);
+	/* Get vram informations */
+	r300_vram_info(rdev);
+	/* Initialize memory controller (also test AGP) */
+	r = r420_mc_init(rdev);
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
+	if (rdev->flags & RADEON_IS_PCIE) {
+		r = rv370_pcie_gart_init(rdev);
+		if (r)
+			return r;
+	}
+	if (rdev->flags & RADEON_IS_PCI) {
+		r = r100_pci_gart_init(rdev);
+		if (r)
+			return r;
+	}
+	r300_set_reg_safe(rdev);
+	rdev->accel_working = true;
+	r = r300_startup(rdev);
+	if (r) {
+		/* Somethings want wront with the accel init stop accel */
+		dev_err(rdev->dev, "Disabling GPU acceleration\n");
+		r300_suspend(rdev);
+		r100_cp_fini(rdev);
+		r100_wb_fini(rdev);
+		r100_ib_fini(rdev);
+		if (rdev->flags & RADEON_IS_PCIE)
+			rv370_pcie_gart_fini(rdev);
+		if (rdev->flags & RADEON_IS_PCI)
+			r100_pci_gart_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
+	}
+	return 0;
+}
diff --git a/drivers/gpu/drm/radeon/r300d.h b/drivers/gpu/drm/radeon/r300d.h
index a6d54da..4c73114 100644
--- a/drivers/gpu/drm/radeon/r300d.h
+++ b/drivers/gpu/drm/radeon/r300d.h
@@ -96,6 +96,119 @@
 #define   S_000170_AGP_BASE_ADDR(x)                    (((x) & 0xFFFFFFFF) << 0)
 #define   G_000170_AGP_BASE_ADDR(x)                    (((x) >> 0) & 0xFFFFFFFF)
 #define   C_000170_AGP_BASE_ADDR                       0x00000000
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
 
 
 #define R_00000D_SCLK_CNTL                           0x00000D
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 88bd538..da08f09 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -1031,6 +1031,16 @@ extern void r100_hdp_reset(struct radeon_device *rdev);
 extern int r100_rb2d_reset(struct radeon_device *rdev);
 extern int r100_cp_reset(struct radeon_device *rdev);
 extern void r100_vga_render_disable(struct radeon_device *rdev);
+extern int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
+						struct radeon_cs_packet *pkt,
+						struct radeon_object *robj);
+extern int r100_cs_parse_packet0(struct radeon_cs_parser *p,
+				struct radeon_cs_packet *pkt,
+				const unsigned *auth, unsigned n,
+				radeon_packet0_check_t check);
+extern int r100_cs_packet_parse(struct radeon_cs_parser *p,
+				struct radeon_cs_packet *pkt,
+				unsigned idx);
 
 /* r300,r350,rv350,rv370,rv380 */
 extern void r300_set_reg_safe(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index b8bdefb..12321a0 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -129,54 +129,51 @@ static struct radeon_asic r100_asic = {
 /*
  * r300,r350,rv350,rv380
  */
-int r300_init(struct radeon_device *rdev);
-void r300_errata(struct radeon_device *rdev);
-void r300_vram_info(struct radeon_device *rdev);
-int r300_gpu_reset(struct radeon_device *rdev);
-int r300_mc_init(struct radeon_device *rdev);
-void r300_mc_fini(struct radeon_device *rdev);
-void r300_ring_start(struct radeon_device *rdev);
-void r300_fence_ring_emit(struct radeon_device *rdev,
-			  struct radeon_fence *fence);
-int r300_cs_parse(struct radeon_cs_parser *p);
-int rv370_pcie_gart_init(struct radeon_device *rdev);
-void rv370_pcie_gart_fini(struct radeon_device *rdev);
-int rv370_pcie_gart_enable(struct radeon_device *rdev);
-void rv370_pcie_gart_disable(struct radeon_device *rdev);
-void rv370_pcie_gart_tlb_flush(struct radeon_device *rdev);
-int rv370_pcie_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
-uint32_t rv370_pcie_rreg(struct radeon_device *rdev, uint32_t reg);
-void rv370_pcie_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
-void rv370_set_pcie_lanes(struct radeon_device *rdev, int lanes);
-int r300_copy_dma(struct radeon_device *rdev,
-		  uint64_t src_offset,
-		  uint64_t dst_offset,
-		  unsigned num_pages,
-		  struct radeon_fence *fence);
-
+extern int r300_init(struct radeon_device *rdev);
+extern void r300_fini(struct radeon_device *rdev);
+extern int r300_suspend(struct radeon_device *rdev);
+extern int r300_resume(struct radeon_device *rdev);
+extern int r300_gpu_reset(struct radeon_device *rdev);
+extern void r300_ring_start(struct radeon_device *rdev);
+extern void r300_fence_ring_emit(struct radeon_device *rdev,
+				struct radeon_fence *fence);
+extern int r300_cs_parse(struct radeon_cs_parser *p);
+extern void rv370_pcie_gart_tlb_flush(struct radeon_device *rdev);
+extern int rv370_pcie_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
+extern uint32_t rv370_pcie_rreg(struct radeon_device *rdev, uint32_t reg);
+extern void rv370_pcie_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
+extern void rv370_set_pcie_lanes(struct radeon_device *rdev, int lanes);
+extern int r300_copy_dma(struct radeon_device *rdev,
+			uint64_t src_offset,
+			uint64_t dst_offset,
+			unsigned num_pages,
+			struct radeon_fence *fence);
 static struct radeon_asic r300_asic = {
 	.init = &r300_init,
-	.errata = &r300_errata,
-	.vram_info = &r300_vram_info,
+	.fini = &r300_fini,
+	.suspend = &r300_suspend,
+	.resume = &r300_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = &r300_mc_init,
-	.mc_fini = &r300_mc_fini,
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
 	.ring_start = &r300_ring_start,
 	.ring_test = &r100_ring_test,
 	.ring_ib_execute = &r100_ring_ib_execute,
-	.ib_test = &r100_ib_test,
+	.ib_test = NULL,
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.get_vblank_counter = &r100_get_vblank_counter,
-- 
1.6.4.4

