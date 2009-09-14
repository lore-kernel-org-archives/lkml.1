Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbZINS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbZINS22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755590AbZINS21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 14:28:27 -0400
Received: from nox.protox.org ([88.191.38.29]:36094 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756AbZINS2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 14:28:24 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: clear confusion in GART init/deinit path
Date: Mon, 14 Sep 2009 18:29:49 +0200
Message-Id: <1252945789-1621-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GART static one time initialization was mixed up with GART
enabling/disabling which could happen several time for instance
during suspend/resume cycles. This patch splits all GART
handling into 4 differents function. gart_init is for one
time initialization, gart_deinit is called upon module unload
to free resources allocated by gart_init, gart_enable enable
the GART and is intented to be call after first initialization
and at each resume cycle or reset cycle. Finaly gart_disable
stop the GART and is intended to be call at suspend time or
when unloading the module.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c          |   40 ++++++------
 drivers/gpu/drm/radeon/r300.c          |  108 +++++++++++++------------------
 drivers/gpu/drm/radeon/r420.c          |   57 +++++++++++------
 drivers/gpu/drm/radeon/r520.c          |    5 --
 drivers/gpu/drm/radeon/r600.c          |   53 +++++++++++-----
 drivers/gpu/drm/radeon/radeon.h        |   11 +++
 drivers/gpu/drm/radeon/radeon_asic.h   |   38 +++++++++---
 drivers/gpu/drm/radeon/radeon_device.c |   36 +++++++++--
 drivers/gpu/drm/radeon/radeon_gart.c   |    9 +++-
 drivers/gpu/drm/radeon/rs400.c         |   53 +++++++++++-----
 drivers/gpu/drm/radeon/rs600.c         |   41 +++++++++---
 drivers/gpu/drm/radeon/rs690.c         |    3 -
 drivers/gpu/drm/radeon/rv515.c         |    5 --
 drivers/gpu/drm/radeon/rv770.c         |   37 +++++++-----
 14 files changed, 306 insertions(+), 190 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 47263d3..fa0fdc1 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -84,23 +84,28 @@ void r100_pci_gart_tlb_flush(struct radeon_device *rdev)
 	 * could end up in wrong address. */
 }
 
-int r100_pci_gart_enable(struct radeon_device *rdev)
+int r100_pci_gart_init(struct radeon_device *rdev)
 {
-	uint32_t tmp;
 	int r;
 
+	if (rdev->gart.table.ram.ptr) {
+		WARN(1, "R100 PCI GART already initialized.\n");
+		return 0;
+	}
 	/* Initialize common gart structure */
 	r = radeon_gart_init(rdev);
-	if (r) {
+	if (r)
 		return r;
-	}
-	if (rdev->gart.table.ram.ptr == NULL) {
-		rdev->gart.table_size = rdev->gart.num_gpu_pages * 4;
-		r = radeon_gart_table_ram_alloc(rdev);
-		if (r) {
-			return r;
-		}
-	}
+	rdev->gart.table_size = rdev->gart.num_gpu_pages * 4;
+	rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
+	rdev->asic->gart_set_page = &r100_pci_gart_set_page;
+	return radeon_gart_table_ram_alloc(rdev);
+}
+
+int r100_pci_gart_enable(struct radeon_device *rdev)
+{
+	uint32_t tmp;
+
 	/* discard memory request outside of configured range */
 	tmp = RREG32(RADEON_AIC_CNTL) | RADEON_DIS_OUT_OF_PCI_GART_ACCESS;
 	WREG32(RADEON_AIC_CNTL, tmp);
@@ -140,13 +145,11 @@ int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr)
 	return 0;
 }
 
-int r100_gart_enable(struct radeon_device *rdev)
+void r100_pci_gart_fini(struct radeon_device *rdev)
 {
-	if (rdev->flags & RADEON_IS_AGP) {
-		r100_pci_gart_disable(rdev);
-		return 0;
-	}
-	return r100_pci_gart_enable(rdev);
+	r100_pci_gart_disable(rdev);
+	radeon_gart_table_ram_free(rdev);
+	radeon_gart_fini(rdev);
 }
 
 
@@ -273,9 +276,6 @@ int r100_mc_init(struct radeon_device *rdev)
 
 void r100_mc_fini(struct radeon_device *rdev)
 {
-	r100_pci_gart_disable(rdev);
-	radeon_gart_table_ram_free(rdev);
-	radeon_gart_fini(rdev);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index ced3322..bb151ec 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -42,7 +42,6 @@ int r100_cp_reset(struct radeon_device *rdev);
 int r100_rb2d_reset(struct radeon_device *rdev);
 int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
 int r100_pci_gart_enable(struct radeon_device *rdev);
-void r100_pci_gart_disable(struct radeon_device *rdev);
 void r100_mc_setup(struct radeon_device *rdev);
 void r100_mc_disable_clients(struct radeon_device *rdev);
 int r100_gui_wait_for_idle(struct radeon_device *rdev);
@@ -86,26 +85,57 @@ void rv370_pcie_gart_tlb_flush(struct radeon_device *rdev)
 	mb();
 }
 
-int rv370_pcie_gart_enable(struct radeon_device *rdev)
+int rv370_pcie_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr)
+{
+	void __iomem *ptr = (void *)rdev->gart.table.vram.ptr;
+
+	if (i < 0 || i > rdev->gart.num_gpu_pages) {
+		return -EINVAL;
+	}
+	addr = (lower_32_bits(addr) >> 8) |
+	       ((upper_32_bits(addr) & 0xff) << 24) |
+	       0xc;
+	/* on x86 we want this to be CPU endian, on powerpc
+	 * on powerpc without HW swappers, it'll get swapped on way
+	 * into VRAM - so no need for cpu_to_le32 on VRAM tables */
+	writel(addr, ((void __iomem *)ptr) + (i * 4));
+	return 0;
+}
+
+int rv370_pcie_gart_init(struct radeon_device *rdev)
 {
-	uint32_t table_addr;
-	uint32_t tmp;
 	int r;
 
+	if (rdev->gart.table.vram.robj) {
+		WARN(1, "RV370 PCIE GART already initialized.\n");
+		return 0;
+	}
 	/* Initialize common gart structure */
 	r = radeon_gart_init(rdev);
-	if (r) {
+	if (r)
 		return r;
-	}
 	r = rv370_debugfs_pcie_gart_info_init(rdev);
-	if (r) {
+	if (r)
 		DRM_ERROR("Failed to register debugfs file for PCIE gart !\n");
-	}
 	rdev->gart.table_size = rdev->gart.num_gpu_pages * 4;
-	r = radeon_gart_table_vram_alloc(rdev);
-	if (r) {
-		return r;
+	rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
+	rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
+	return radeon_gart_table_vram_alloc(rdev);
+}
+
+int rv370_pcie_gart_enable(struct radeon_device *rdev)
+{
+	uint32_t table_addr;
+	uint32_t tmp;
+	int r;
+
+	if (rdev->gart.table.vram.robj == NULL) {
+		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		return -EINVAL;
 	}
+	r = radeon_gart_table_vram_pin(rdev);
+	if (r)
+		return r;
 	/* discard memory request outside of configured range */
 	tmp = RADEON_PCIE_TX_GART_UNMAPPED_ACCESS_DISCARD;
 	WREG32_PCIE(RADEON_PCIE_TX_GART_CNTL, tmp);
@@ -145,51 +175,13 @@ void rv370_pcie_gart_disable(struct radeon_device *rdev)
 	}
 }
 
-int rv370_pcie_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr)
-{
-	void __iomem *ptr = (void *)rdev->gart.table.vram.ptr;
-
-	if (i < 0 || i > rdev->gart.num_gpu_pages) {
-		return -EINVAL;
-	}
-	addr = (lower_32_bits(addr) >> 8) |
-	       ((upper_32_bits(addr) & 0xff) << 24) |
-	       0xc;
-	/* on x86 we want this to be CPU endian, on powerpc
-	 * on powerpc without HW swappers, it'll get swapped on way
-	 * into VRAM - so no need for cpu_to_le32 on VRAM tables */
-	writel(addr, ((void __iomem *)ptr) + (i * 4));
-	return 0;
-}
-
-int r300_gart_enable(struct radeon_device *rdev)
+void rv370_pcie_gart_fini(struct radeon_device *rdev)
 {
-#if __OS_HAS_AGP
-	if (rdev->flags & RADEON_IS_AGP) {
-		if (rdev->family > CHIP_RV350) {
-			rv370_pcie_gart_disable(rdev);
-		} else {
-			r100_pci_gart_disable(rdev);
-		}
-		return 0;
-	}
-#endif
-	if (rdev->flags & RADEON_IS_PCIE) {
-		rdev->asic->gart_disable = &rv370_pcie_gart_disable;
-		rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
-		rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
-		return rv370_pcie_gart_enable(rdev);
-	}
-	if (rdev->flags & RADEON_IS_PCI) {
-		rdev->asic->gart_disable = &r100_pci_gart_disable;
-		rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
-		rdev->asic->gart_set_page = &r100_pci_gart_set_page;
-		return r100_pci_gart_enable(rdev);
-	}
-	return r100_pci_gart_enable(rdev);
+	rv370_pcie_gart_disable(rdev);
+	radeon_gart_table_vram_free(rdev);
+	radeon_gart_fini(rdev);
 }
 
-
 /*
  * MC
  */
@@ -237,14 +229,6 @@ int r300_mc_init(struct radeon_device *rdev)
 
 void r300_mc_fini(struct radeon_device *rdev)
 {
-	if (rdev->flags & RADEON_IS_PCIE) {
-		rv370_pcie_gart_disable(rdev);
-		radeon_gart_table_vram_free(rdev);
-	} else {
-		r100_pci_gart_disable(rdev);
-		radeon_gart_table_ram_free(rdev);
-	}
-	radeon_gart_fini(rdev);
 }
 
 
@@ -1299,8 +1283,6 @@ void r300_mc_program(struct radeon_device *rdev)
 
 	/* Stops all mc clients */
 	r100_mc_stop(rdev, &save);
-	/* Shutdown PCI/PCIE GART */
-	radeon_gart_disable(rdev);
 	if (rdev->flags & RADEON_IS_AGP) {
 		WREG32(R_00014C_MC_AGP_LOCATION,
 			S_00014C_MC_AGP_START(rdev->mc.gtt_start >> 16) |
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index e57b9ba..33a25a4 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -161,6 +161,11 @@ int r420_resume(struct radeon_device *rdev)
 {
 	int r;
 
+	/* Make sur GART are not working */
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_disable(rdev);
 	/* Resume clock before doing reset */
 	r420_clock_resume(rdev);
 	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
@@ -180,10 +185,15 @@ int r420_resume(struct radeon_device *rdev)
 	r300_mc_program(rdev);
 	/* Initialize GART (initialize after TTM so we can allocate
 	 * memory through TTM but finalize after TTM) */
-	r = radeon_gart_enable(rdev);
-	if (r) {
-		dev_err(rdev->dev, "failled initializing GART (%d).\n", r);
-		return r;
+	if (rdev->flags & RADEON_IS_PCIE) {
+		r = rv370_pcie_gart_enable(rdev);
+		if (r)
+			return r;
+	}
+	if (rdev->flags & RADEON_IS_PCI) {
+		r = r100_pci_gart_enable(rdev);
+		if (r)
+			return r;
 	}
 	r420_pipes_init(rdev);
 	/* Enable IRQ */
@@ -212,7 +222,10 @@ int r420_suspend(struct radeon_device *rdev)
 	r100_cp_disable(rdev);
 	r100_wb_disable(rdev);
 	r100_irq_disable(rdev);
-	radeon_gart_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_disable(rdev);
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_disable(rdev);
 	return 0;
 }
 
@@ -222,14 +235,10 @@ void r420_fini(struct radeon_device *rdev)
 	r100_wb_fini(rdev);
 	r100_ib_fini(rdev);
 	radeon_gem_fini(rdev);
-	if (rdev->flags & RADEON_IS_PCIE) {
-		rv370_pcie_gart_disable(rdev);
-		radeon_gart_table_vram_free(rdev);
-	} else {
-		r100_pci_gart_disable(rdev);
-		radeon_gart_table_ram_free(rdev);
-	}
-	radeon_gart_fini(rdev);
+	if (rdev->flags & RADEON_IS_PCIE)
+		rv370_pcie_gart_fini(rdev);
+	if (rdev->flags & RADEON_IS_PCI)
+		r100_pci_gart_fini(rdev);
 	radeon_agp_fini(rdev);
 	radeon_irq_kms_fini(rdev);
 	radeon_fence_driver_fini(rdev);
@@ -309,6 +318,16 @@ int r420_init(struct radeon_device *rdev)
 	if (r) {
 		return r;
 	}
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
 	r300_set_reg_safe(rdev);
 	r = r420_resume(rdev);
 	if (r) {
@@ -318,14 +337,10 @@ int r420_init(struct radeon_device *rdev)
 		r100_cp_fini(rdev);
 		r100_wb_fini(rdev);
 		r100_ib_fini(rdev);
-		if (rdev->flags & RADEON_IS_PCIE) {
-			rv370_pcie_gart_disable(rdev);
-			radeon_gart_table_vram_free(rdev);
-		} else {
-			r100_pci_gart_disable(rdev);
-			radeon_gart_table_ram_free(rdev);
-		}
-		radeon_gart_fini(rdev);
+		if (rdev->flags & RADEON_IS_PCIE)
+			rv370_pcie_gart_fini(rdev);
+		if (rdev->flags & RADEON_IS_PCI)
+			r100_pci_gart_fini(rdev);
 		radeon_agp_fini(rdev);
 		radeon_irq_kms_fini(rdev);
 	}
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index 0e1686d..d4b0b9d 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -31,8 +31,6 @@
 
 /* r520,rv530,rv560,rv570,r580 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
-int rv370_pcie_gart_enable(struct radeon_device *rdev);
-void rv370_pcie_gart_disable(struct radeon_device *rdev);
 void r420_pipes_init(struct radeon_device *rdev);
 void rs600_mc_disable_clients(struct radeon_device *rdev);
 void rs600_disable_vga(struct radeon_device *rdev);
@@ -118,9 +116,6 @@ int r520_mc_init(struct radeon_device *rdev)
 
 void r520_mc_fini(struct radeon_device *rdev)
 {
-	rv370_pcie_gart_disable(rdev);
-	radeon_gart_table_vram_free(rdev);
-	radeon_gart_fini(rdev);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 1bc2567..65699e9 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -113,21 +113,34 @@ void r600_pcie_gart_tlb_flush(struct radeon_device *rdev)
 	}
 }
 
-int r600_pcie_gart_enable(struct radeon_device *rdev)
+int r600_pcie_gart_init(struct radeon_device *rdev)
 {
-	u32 tmp;
-	int r, i;
+	int r;
 
+	if (rdev->gart.table.vram.robj) {
+		WARN(1, "R600 PCIE GART already initialized.\n");
+		return 0;
+	}
 	/* Initialize common gart structure */
 	r = radeon_gart_init(rdev);
-	if (r) {
+	if (r)
 		return r;
-	}
 	rdev->gart.table_size = rdev->gart.num_gpu_pages * 8;
-	r = radeon_gart_table_vram_alloc(rdev);
-	if (r) {
-		return r;
+	return radeon_gart_table_vram_alloc(rdev);
+}
+
+int r600_pcie_gart_enable(struct radeon_device *rdev)
+{
+	u32 tmp;
+	int r, i;
+
+	if (rdev->gart.table.vram.robj == NULL) {
+		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		return -EINVAL;
 	}
+	r = radeon_gart_table_vram_pin(rdev);
+	if (r)
+		return r;
 	for (i = 0; i < rdev->gart.num_gpu_pages; i++)
 		r600_gart_clear_page(rdev, i);
 	/* Setup L2 cache */
@@ -175,10 +188,6 @@ void r600_pcie_gart_disable(struct radeon_device *rdev)
 	u32 tmp;
 	int i;
 
-	/* Clear ptes*/
-	for (i = 0; i < rdev->gart.num_gpu_pages; i++)
-		r600_gart_clear_page(rdev, i);
-	r600_pcie_gart_tlb_flush(rdev);
 	/* Disable all tables */
 	for (i = 0; i < 7; i++)
 		WREG32(VM_CONTEXT0_CNTL + (i * 4), 0);
@@ -204,6 +213,17 @@ void r600_pcie_gart_disable(struct radeon_device *rdev)
 	WREG32(MC_VM_L1_TLB_MCB_WR_SYS_CNTL, tmp);
 	WREG32(MC_VM_L1_TLB_MCB_RD_HDP_CNTL, tmp);
 	WREG32(MC_VM_L1_TLB_MCB_WR_HDP_CNTL, tmp);
+	if (rdev->gart.table.vram.robj) {
+		radeon_object_kunmap(rdev->gart.table.vram.robj);
+		radeon_object_unpin(rdev->gart.table.vram.robj);
+	}
+}
+
+void r600_pcie_gart_fini(struct radeon_device *rdev)
+{
+	r600_pcie_gart_disable(rdev);
+	radeon_gart_table_vram_free(rdev);
+	radeon_gart_fini(rdev);
 }
 
 int r600_mc_wait_for_idle(struct radeon_device *rdev)
@@ -1472,6 +1492,7 @@ int r600_suspend(struct radeon_device *rdev)
 {
 	/* FIXME: we should wait for ring to be empty */
 	r600_cp_stop(rdev);
+	r600_pcie_gart_disable(rdev);
 	return 0;
 }
 
@@ -1548,6 +1569,10 @@ int r600_init(struct radeon_device *rdev)
 		}
 	}
 
+	r = r600_pcie_gart_init(rdev);
+	if (r)
+		return r;
+
 	r = r600_resume(rdev);
 	if (r) {
 		if (rdev->flags & RADEON_IS_AGP) {
@@ -1583,9 +1608,7 @@ void r600_fini(struct radeon_device *rdev)
 
 	r600_blit_fini(rdev);
 	radeon_ring_fini(rdev);
-	r600_pcie_gart_disable(rdev);
-	radeon_gart_table_vram_free(rdev);
-	radeon_gart_fini(rdev);
+	r600_pcie_gart_fini(rdev);
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
 	radeon_clocks_fini(rdev);
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 8cec5bf..99292be 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -596,6 +596,8 @@ struct radeon_asic {
 	void (*mc_fini)(struct radeon_device *rdev);
 	int (*wb_init)(struct radeon_device *rdev);
 	void (*wb_fini)(struct radeon_device *rdev);
+	int (*gart_init)(struct radeon_device *rdev);
+	void (*gart_fini)(struct radeon_device *rdev);
 	int (*gart_enable)(struct radeon_device *rdev);
 	void (*gart_disable)(struct radeon_device *rdev);
 	void (*gart_tlb_flush)(struct radeon_device *rdev);
@@ -950,6 +952,8 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_mc_fini(rdev) (rdev)->asic->mc_fini((rdev))
 #define radeon_wb_init(rdev) (rdev)->asic->wb_init((rdev))
 #define radeon_wb_fini(rdev) (rdev)->asic->wb_fini((rdev))
+#define radeon_gpu_gart_init(rdev) (rdev)->asic->gart_init((rdev))
+#define radeon_gpu_gart_fini(rdev) (rdev)->asic->gart_fini((rdev))
 #define radeon_gart_enable(rdev) (rdev)->asic->gart_enable((rdev))
 #define radeon_gart_disable(rdev) (rdev)->asic->gart_disable((rdev))
 #define radeon_gart_tlb_flush(rdev) (rdev)->asic->gart_tlb_flush((rdev))
@@ -978,6 +982,7 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_bandwidth_update(rdev) (rdev)->asic->bandwidth_update((rdev))
 
 /* Common functions */
+extern int radeon_gart_table_vram_pin(struct radeon_device *rdev);
 extern int radeon_modeset_init(struct radeon_device *rdev);
 extern void radeon_modeset_fini(struct radeon_device *rdev);
 extern bool radeon_card_posted(struct radeon_device *rdev);
@@ -1000,6 +1005,8 @@ extern void r100_cp_disable(struct radeon_device *rdev);
 extern int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
 extern void r100_cp_fini(struct radeon_device *rdev);
 extern void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
+extern int r100_pci_gart_init(struct radeon_device *rdev);
+extern void r100_pci_gart_fini(struct radeon_device *rdev);
 extern int r100_pci_gart_enable(struct radeon_device *rdev);
 extern void r100_pci_gart_disable(struct radeon_device *rdev);
 extern int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
@@ -1020,6 +1027,9 @@ extern int r100_wb_init(struct radeon_device *rdev);
 extern void r300_set_reg_safe(struct radeon_device *rdev);
 extern void r300_mc_program(struct radeon_device *rdev);
 extern void r300_vram_info(struct radeon_device *rdev);
+extern int rv370_pcie_gart_init(struct radeon_device *rdev);
+extern void rv370_pcie_gart_fini(struct radeon_device *rdev);
+extern int rv370_pcie_gart_enable(struct radeon_device *rdev);
 extern void rv370_pcie_gart_disable(struct radeon_device *rdev);
 
 /* r420,r423,rv410 */
@@ -1043,6 +1053,7 @@ extern int r600_cp_resume(struct radeon_device *rdev);
 extern int r600_count_pipe_bits(uint32_t val);
 extern int r600_gart_clear_page(struct radeon_device *rdev, int i);
 extern int r600_mc_wait_for_idle(struct radeon_device *rdev);
+extern int r600_pcie_gart_init(struct radeon_device *rdev);
 extern void r600_pcie_gart_tlb_flush(struct radeon_device *rdev);
 extern int r600_ib_test(struct radeon_device *rdev);
 extern int r600_ring_test(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index 8f27be3..5f2a9e6 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -53,7 +53,9 @@ void r100_mc_fini(struct radeon_device *rdev);
 u32 r100_get_vblank_counter(struct radeon_device *rdev, int crtc);
 int r100_wb_init(struct radeon_device *rdev);
 void r100_wb_fini(struct radeon_device *rdev);
-int r100_gart_enable(struct radeon_device *rdev);
+int r100_pci_gart_init(struct radeon_device *rdev);
+void r100_pci_gart_fini(struct radeon_device *rdev);
+int r100_pci_gart_enable(struct radeon_device *rdev);
 void r100_pci_gart_disable(struct radeon_device *rdev);
 void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
 int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
@@ -92,7 +94,9 @@ static struct radeon_asic r100_asic = {
 	.mc_fini = &r100_mc_fini,
 	.wb_init = &r100_wb_init,
 	.wb_fini = &r100_wb_fini,
-	.gart_enable = &r100_gart_enable,
+	.gart_init = &r100_pci_gart_init,
+	.gart_fini = &r100_pci_gart_fini,
+	.gart_enable = &r100_pci_gart_enable,
 	.gart_disable = &r100_pci_gart_disable,
 	.gart_tlb_flush = &r100_pci_gart_tlb_flush,
 	.gart_set_page = &r100_pci_gart_set_page,
@@ -135,7 +139,9 @@ void r300_ring_start(struct radeon_device *rdev);
 void r300_fence_ring_emit(struct radeon_device *rdev,
 			  struct radeon_fence *fence);
 int r300_cs_parse(struct radeon_cs_parser *p);
-int r300_gart_enable(struct radeon_device *rdev);
+int rv370_pcie_gart_init(struct radeon_device *rdev);
+void rv370_pcie_gart_fini(struct radeon_device *rdev);
+int rv370_pcie_gart_enable(struct radeon_device *rdev);
 void rv370_pcie_gart_disable(struct radeon_device *rdev);
 void rv370_pcie_gart_tlb_flush(struct radeon_device *rdev);
 int rv370_pcie_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
@@ -157,7 +163,9 @@ static struct radeon_asic r300_asic = {
 	.mc_fini = &r300_mc_fini,
 	.wb_init = &r100_wb_init,
 	.wb_fini = &r100_wb_fini,
-	.gart_enable = &r300_gart_enable,
+	.gart_init = &r100_pci_gart_init,
+	.gart_fini = &r100_pci_gart_fini,
+	.gart_enable = &r100_pci_gart_enable,
 	.gart_disable = &r100_pci_gart_disable,
 	.gart_tlb_flush = &r100_pci_gart_tlb_flush,
 	.gart_set_page = &r100_pci_gart_set_page,
@@ -205,8 +213,8 @@ static struct radeon_asic r420_asic = {
 	.mc_fini = NULL,
 	.wb_init = NULL,
 	.wb_fini = NULL,
-	.gart_enable = &r300_gart_enable,
-	.gart_disable = &rv370_pcie_gart_disable,
+	.gart_enable = NULL,
+	.gart_disable = NULL,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
 	.cp_init = NULL,
@@ -242,6 +250,8 @@ void rs400_errata(struct radeon_device *rdev);
 void rs400_vram_info(struct radeon_device *rdev);
 int rs400_mc_init(struct radeon_device *rdev);
 void rs400_mc_fini(struct radeon_device *rdev);
+int rs400_gart_init(struct radeon_device *rdev);
+void rs400_gart_fini(struct radeon_device *rdev);
 int rs400_gart_enable(struct radeon_device *rdev);
 void rs400_gart_disable(struct radeon_device *rdev);
 void rs400_gart_tlb_flush(struct radeon_device *rdev);
@@ -257,6 +267,8 @@ static struct radeon_asic rs400_asic = {
 	.mc_fini = &rs400_mc_fini,
 	.wb_init = &r100_wb_init,
 	.wb_fini = &r100_wb_fini,
+	.gart_init = &rs400_gart_init,
+	.gart_fini = &rs400_gart_fini,
 	.gart_enable = &rs400_gart_enable,
 	.gart_disable = &rs400_gart_disable,
 	.gart_tlb_flush = &rs400_gart_tlb_flush,
@@ -298,6 +310,8 @@ void rs600_mc_fini(struct radeon_device *rdev);
 int rs600_irq_set(struct radeon_device *rdev);
 int rs600_irq_process(struct radeon_device *rdev);
 u32 rs600_get_vblank_counter(struct radeon_device *rdev, int crtc);
+int rs600_gart_init(struct radeon_device *rdev);
+void rs600_gart_fini(struct radeon_device *rdev);
 int rs600_gart_enable(struct radeon_device *rdev);
 void rs600_gart_disable(struct radeon_device *rdev);
 void rs600_gart_tlb_flush(struct radeon_device *rdev);
@@ -314,6 +328,8 @@ static struct radeon_asic rs600_asic = {
 	.mc_fini = &rs600_mc_fini,
 	.wb_init = &r100_wb_init,
 	.wb_fini = &r100_wb_fini,
+	.gart_init = &rs600_gart_init,
+	.gart_fini = &rs600_gart_fini,
 	.gart_enable = &rs600_gart_enable,
 	.gart_disable = &rs600_gart_disable,
 	.gart_tlb_flush = &rs600_gart_tlb_flush,
@@ -361,6 +377,8 @@ static struct radeon_asic rs690_asic = {
 	.mc_fini = &rs690_mc_fini,
 	.wb_init = &r100_wb_init,
 	.wb_fini = &r100_wb_fini,
+	.gart_init = &rs400_gart_init,
+	.gart_fini = &rs400_gart_fini,
 	.gart_enable = &rs400_gart_enable,
 	.gart_disable = &rs400_gart_disable,
 	.gart_tlb_flush = &rs400_gart_tlb_flush,
@@ -415,7 +433,9 @@ static struct radeon_asic rv515_asic = {
 	.mc_fini = &rv515_mc_fini,
 	.wb_init = &r100_wb_init,
 	.wb_fini = &r100_wb_fini,
-	.gart_enable = &r300_gart_enable,
+	.gart_init = &rv370_pcie_gart_init,
+	.gart_fini = &rv370_pcie_gart_fini,
+	.gart_enable = &rv370_pcie_gart_enable,
 	.gart_disable = &rv370_pcie_gart_disable,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
@@ -462,7 +482,9 @@ static struct radeon_asic r520_asic = {
 	.mc_fini = &r520_mc_fini,
 	.wb_init = &r100_wb_init,
 	.wb_fini = &r100_wb_fini,
-	.gart_enable = &r300_gart_enable,
+	.gart_init = &rv370_pcie_gart_init,
+	.gart_fini = &rv370_pcie_gart_fini,
+	.gart_enable = &rv370_pcie_gart_enable,
 	.gart_disable = &rv370_pcie_gart_disable,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index ece097c..7b6d0b1 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -320,6 +320,14 @@ int radeon_asic_init(struct radeon_device *rdev)
 	case CHIP_RV350:
 	case CHIP_RV380:
 		rdev->asic = &r300_asic;
+		if (rdev->flags & RADEON_IS_PCIE) {
+			rdev->asic->gart_init = &rv370_pcie_gart_init;
+			rdev->asic->gart_fini = &rv370_pcie_gart_fini;
+			rdev->asic->gart_enable = &rv370_pcie_gart_enable;
+			rdev->asic->gart_disable = &rv370_pcie_gart_disable;
+			rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
+			rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
+		}
 		break;
 	case CHIP_R420:
 	case CHIP_R423:
@@ -504,6 +512,12 @@ int radeon_device_init(struct radeon_device *rdev,
 	rwlock_init(&rdev->fence_drv.lock);
 	INIT_LIST_HEAD(&rdev->gem.objects);
 
+	/* Set asic functions */
+	r = radeon_asic_init(rdev);
+	if (r) {
+		return r;
+	}
+
 	if (radeon_agpmode == -1) {
 		rdev->flags &= ~RADEON_IS_AGP;
 		if (rdev->family >= CHIP_RV515 ||
@@ -512,18 +526,24 @@ int radeon_device_init(struct radeon_device *rdev,
 		    rdev->family == CHIP_R423) {
 			DRM_INFO("Forcing AGP to PCIE mode\n");
 			rdev->flags |= RADEON_IS_PCIE;
+			rdev->asic->gart_init = &rv370_pcie_gart_init;
+			rdev->asic->gart_fini = &rv370_pcie_gart_fini;
+			rdev->asic->gart_enable = &rv370_pcie_gart_enable;
+			rdev->asic->gart_disable = &rv370_pcie_gart_disable;
+			rdev->asic->gart_tlb_flush = &rv370_pcie_gart_tlb_flush;
+			rdev->asic->gart_set_page = &rv370_pcie_gart_set_page;
 		} else {
 			DRM_INFO("Forcing AGP to PCI mode\n");
 			rdev->flags |= RADEON_IS_PCI;
+			rdev->asic->gart_init = &r100_pci_gart_init;
+			rdev->asic->gart_fini = &r100_pci_gart_fini;
+			rdev->asic->gart_enable = &r100_pci_gart_enable;
+			rdev->asic->gart_disable = &r100_pci_gart_disable;
+			rdev->asic->gart_tlb_flush = &r100_pci_gart_tlb_flush;
+			rdev->asic->gart_set_page = &r100_pci_gart_set_page;
 		}
 	}
 
-	/* Set asic functions */
-	r = radeon_asic_init(rdev);
-	if (r) {
-		return r;
-	}
-
 	/* set DMA mask + need_dma32 flags.
 	 * PCIE - can handle 40-bits.
 	 * IGP - can handle 40-bits (in theory)
@@ -623,6 +643,9 @@ int radeon_device_init(struct radeon_device *rdev,
 		if (r) {
 			return r;
 		}
+		r = radeon_gpu_gart_init(rdev);
+		if (r)
+			return r;
 		/* Initialize GART (initialize after TTM so we can allocate
 		 * memory through TTM but finalize after TTM) */
 		r = radeon_gart_enable(rdev);
@@ -675,6 +698,7 @@ void radeon_device_fini(struct radeon_device *rdev)
 		radeon_ib_pool_fini(rdev);
 		radeon_cp_fini(rdev);
 		radeon_wb_fini(rdev);
+		radeon_gpu_gart_fini(rdev);
 		radeon_gem_fini(rdev);
 		radeon_mc_fini(rdev);
 #if __OS_HAS_AGP
diff --git a/drivers/gpu/drm/radeon/radeon_gart.c b/drivers/gpu/drm/radeon/radeon_gart.c
index 2977539..a931af0 100644
--- a/drivers/gpu/drm/radeon/radeon_gart.c
+++ b/drivers/gpu/drm/radeon/radeon_gart.c
@@ -75,7 +75,6 @@ void radeon_gart_table_ram_free(struct radeon_device *rdev)
 
 int radeon_gart_table_vram_alloc(struct radeon_device *rdev)
 {
-	uint64_t gpu_addr;
 	int r;
 
 	if (rdev->gart.table.vram.robj == NULL) {
@@ -88,6 +87,14 @@ int radeon_gart_table_vram_alloc(struct radeon_device *rdev)
 			return r;
 		}
 	}
+	return 0;
+}
+
+int radeon_gart_table_vram_pin(struct radeon_device *rdev)
+{
+	uint64_t gpu_addr;
+	int r;
+
 	r = radeon_object_pin(rdev->gart.table.vram.robj,
 			      RADEON_GEM_DOMAIN_VRAM, &gpu_addr);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index e1e4ce4..a3fbdad 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -92,20 +92,41 @@ void rs400_gart_tlb_flush(struct radeon_device *rdev)
 	WREG32_MC(RS480_GART_CACHE_CNTRL, 0);
 }
 
-int rs400_gart_enable(struct radeon_device *rdev)
+int rs400_gart_init(struct radeon_device *rdev)
 {
-	uint32_t size_reg;
-	uint32_t tmp;
 	int r;
 
+	if (rdev->gart.table.ram.ptr) {
+		WARN(1, "RS400 GART already initialized.\n");
+		return 0;
+	}
+	/* Check gart size */
+	switch(rdev->mc.gtt_size / (1024 * 1024)) {
+	case 32:
+	case 64:
+	case 128:
+	case 256:
+	case 512:
+	case 1024:
+	case 2048:
+		break;
+	default:
+		return -EINVAL;
+	}
 	/* Initialize common gart structure */
 	r = radeon_gart_init(rdev);
-	if (r) {
+	if (r)
 		return r;
-	}
-	if (rs400_debugfs_pcie_gart_info_init(rdev)) {
+	if (rs400_debugfs_pcie_gart_info_init(rdev))
 		DRM_ERROR("Failed to register debugfs file for RS400 GART !\n");
-	}
+	rdev->gart.table_size = rdev->gart.num_gpu_pages * 4;
+	return radeon_gart_table_ram_alloc(rdev);
+}
+
+int rs400_gart_enable(struct radeon_device *rdev)
+{
+	uint32_t size_reg;
+	uint32_t tmp;
 
 	tmp = RREG32_MC(RS690_AIC_CTRL_SCRATCH);
 	tmp |= RS690_DIS_OUT_OF_PCI_GART_ACCESS;
@@ -136,13 +157,6 @@ int rs400_gart_enable(struct radeon_device *rdev)
 	default:
 		return -EINVAL;
 	}
-	if (rdev->gart.table.ram.ptr == NULL) {
-		rdev->gart.table_size = rdev->gart.num_gpu_pages * 4;
-		r = radeon_gart_table_ram_alloc(rdev);
-		if (r) {
-			return r;
-		}
-	}
 	/* It should be fine to program it to max value */
 	if (rdev->family == CHIP_RS690 || (rdev->family == CHIP_RS740)) {
 		WREG32_MC(RS690_MCCFG_AGP_BASE, 0xFFFFFFFF);
@@ -201,6 +215,13 @@ void rs400_gart_disable(struct radeon_device *rdev)
 	WREG32_MC(RS480_AGP_ADDRESS_SPACE_SIZE, 0);
 }
 
+void rs400_gart_fini(struct radeon_device *rdev)
+{
+	rs400_gart_disable(rdev);
+	radeon_gart_table_ram_free(rdev);
+	radeon_gart_fini(rdev);
+}
+
 int rs400_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr)
 {
 	uint32_t entry;
@@ -255,14 +276,12 @@ int rs400_mc_init(struct radeon_device *rdev)
 	(void)RREG32(RADEON_HOST_PATH_CNTL);
 	WREG32(RADEON_HOST_PATH_CNTL, tmp);
 	(void)RREG32(RADEON_HOST_PATH_CNTL);
+
 	return 0;
 }
 
 void rs400_mc_fini(struct radeon_device *rdev)
 {
-	rs400_gart_disable(rdev);
-	radeon_gart_table_ram_free(rdev);
-	radeon_gart_fini(rdev);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 1b8d62f..c31bd84 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -68,22 +68,35 @@ void rs600_gart_tlb_flush(struct radeon_device *rdev)
 	tmp = RREG32_MC(RS600_MC_PT0_CNTL);
 }
 
-int rs600_gart_enable(struct radeon_device *rdev)
+int rs600_gart_init(struct radeon_device *rdev)
 {
-	uint32_t tmp;
-	int i;
 	int r;
 
+	if (rdev->gart.table.vram.robj) {
+		WARN(1, "RS600 GART already initialized.\n");
+		return 0;
+	}
 	/* Initialize common gart structure */
 	r = radeon_gart_init(rdev);
 	if (r) {
 		return r;
 	}
 	rdev->gart.table_size = rdev->gart.num_gpu_pages * 8;
-	r = radeon_gart_table_vram_alloc(rdev);
-	if (r) {
-		return r;
+	return radeon_gart_table_vram_alloc(rdev);
+}
+
+int rs600_gart_enable(struct radeon_device *rdev)
+{
+	uint32_t tmp;
+	int r, i;
+
+	if (rdev->gart.table.vram.robj == NULL) {
+		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		return -EINVAL;
 	}
+	r = radeon_gart_table_vram_pin(rdev);
+	if (r)
+		return r;
 	/* FIXME: setup default page */
 	WREG32_MC(RS600_MC_PT0_CNTL,
 		 (RS600_EFFECTIVE_L2_CACHE_SIZE(6) |
@@ -138,8 +151,17 @@ void rs600_gart_disable(struct radeon_device *rdev)
 	tmp = RREG32_MC(RS600_MC_CNTL1);
 	tmp &= ~RS600_ENABLE_PAGE_TABLES;
 	WREG32_MC(RS600_MC_CNTL1, tmp);
-	radeon_object_kunmap(rdev->gart.table.vram.robj);
-	radeon_object_unpin(rdev->gart.table.vram.robj);
+	if (rdev->gart.table.vram.robj) {
+		radeon_object_kunmap(rdev->gart.table.vram.robj);
+		radeon_object_unpin(rdev->gart.table.vram.robj);
+	}
+}
+
+void rs600_gart_fini(struct radeon_device *rdev)
+{
+	rs600_gart_disable(rdev);
+	radeon_gart_table_vram_free(rdev);
+	radeon_gart_fini(rdev);
 }
 
 #define R600_PTE_VALID     (1 << 0)
@@ -235,9 +257,6 @@ int rs600_mc_init(struct radeon_device *rdev)
 
 void rs600_mc_fini(struct radeon_device *rdev)
 {
-	rs600_gart_disable(rdev);
-	radeon_gart_table_vram_free(rdev);
-	radeon_gart_fini(rdev);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 839595b..0f585ca 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -94,9 +94,6 @@ int rs690_mc_init(struct radeon_device *rdev)
 
 void rs690_mc_fini(struct radeon_device *rdev)
 {
-	rs400_gart_disable(rdev);
-	radeon_gart_table_ram_free(rdev);
-	radeon_gart_fini(rdev);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 03d4902..fd79974 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -37,8 +37,6 @@ int r100_cp_reset(struct radeon_device *rdev);
 int r100_rb2d_reset(struct radeon_device *rdev);
 int r100_gui_wait_for_idle(struct radeon_device *rdev);
 int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
-int rv370_pcie_gart_enable(struct radeon_device *rdev);
-void rv370_pcie_gart_disable(struct radeon_device *rdev);
 void r420_pipes_init(struct radeon_device *rdev);
 void rs600_mc_disable_clients(struct radeon_device *rdev);
 void rs600_disable_vga(struct radeon_device *rdev);
@@ -126,9 +124,6 @@ int rv515_mc_init(struct radeon_device *rdev)
 
 void rv515_mc_fini(struct radeon_device *rdev)
 {
-	rv370_pcie_gart_disable(rdev);
-	radeon_gart_table_vram_free(rdev);
-	radeon_gart_fini(rdev);
 }
 
 
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index 5ba5204..4f2098b 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -48,16 +48,13 @@ int rv770_pcie_gart_enable(struct radeon_device *rdev)
 	u32 tmp;
 	int r, i;
 
-	/* Initialize common gart structure */
-	r = radeon_gart_init(rdev);
-	if (r) {
-		return r;
+	if (rdev->gart.table.vram.robj == NULL) {
+		dev_err(rdev->dev, "No VRAM object for PCIE GART.\n");
+		return -EINVAL;
 	}
-	rdev->gart.table_size = rdev->gart.num_gpu_pages * 8;
-	r = radeon_gart_table_vram_alloc(rdev);
-	if (r) {
+	r = radeon_gart_table_vram_pin(rdev);
+	if (r)
 		return r;
-	}
 	for (i = 0; i < rdev->gart.num_gpu_pages; i++)
 		r600_gart_clear_page(rdev, i);
 	/* Setup L2 cache */
@@ -98,10 +95,6 @@ void rv770_pcie_gart_disable(struct radeon_device *rdev)
 	u32 tmp;
 	int i;
 
-	/* Clear ptes*/
-	for (i = 0; i < rdev->gart.num_gpu_pages; i++)
-		r600_gart_clear_page(rdev, i);
-	r600_pcie_gart_tlb_flush(rdev);
 	/* Disable all tables */
 	for (i = 0; i < 7; i++)
 		WREG32(VM_CONTEXT0_CNTL + (i * 4), 0);
@@ -120,6 +113,17 @@ void rv770_pcie_gart_disable(struct radeon_device *rdev)
 	WREG32(MC_VM_MB_L1_TLB1_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB2_CNTL, tmp);
 	WREG32(MC_VM_MB_L1_TLB3_CNTL, tmp);
+	if (rdev->gart.table.vram.robj) {
+		radeon_object_kunmap(rdev->gart.table.vram.robj);
+		radeon_object_unpin(rdev->gart.table.vram.robj);
+	}
+}
+
+void rv770_pcie_gart_fini(struct radeon_device *rdev)
+{
+	rv770_pcie_gart_disable(rdev);
+	radeon_gart_table_vram_free(rdev);
+	radeon_gart_fini(rdev);
 }
 
 
@@ -871,6 +875,7 @@ int rv770_suspend(struct radeon_device *rdev)
 {
 	/* FIXME: we should wait for ring to be empty */
 	r700_cp_stop(rdev);
+	rv770_pcie_gart_disable(rdev);
 	return 0;
 }
 
@@ -944,6 +949,10 @@ int rv770_init(struct radeon_device *rdev)
 		}
 	}
 
+	r = r600_pcie_gart_init(rdev);
+	if (r)
+		return r;
+
 	r = rv770_resume(rdev);
 	if (r) {
 		if (rdev->flags & RADEON_IS_AGP) {
@@ -976,9 +985,7 @@ void rv770_fini(struct radeon_device *rdev)
 {
 	r600_blit_fini(rdev);
 	radeon_ring_fini(rdev);
-	rv770_pcie_gart_disable(rdev);
-	radeon_gart_table_vram_free(rdev);
-	radeon_gart_fini(rdev);
+	rv770_pcie_gart_fini(rdev);
 	radeon_gem_fini(rdev);
 	radeon_fence_driver_fini(rdev);
 	radeon_clocks_fini(rdev);
-- 
1.6.4.3

