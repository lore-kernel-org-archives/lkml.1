Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299AbZJAQEc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299AbZJAQEc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:04:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755094AbZJAQES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:04:18 -0400
Received: from nox.protox.org ([88.191.38.29]:37899 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214AbZJAQEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:04:14 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH 3/5] drm/radeon/kms: Fix R600/RV770 startup path & reset
Date: Thu,  1 Oct 2009 18:02:13 +0200
Message-Id: <1254412935-9976-3-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1254412935-9976-2-git-send-email-jglisse@redhat.com>
References: <1254412935-9976-1-git-send-email-jglisse@redhat.com>
 <1254412935-9976-2-git-send-email-jglisse@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were calling reset unconditionaly in the startup path
this is bad we need to call GPU reset for a good reason
as after reset the GPU is in unknown states. To avoid any
more bad things to happen we now also unconditionaly
reinitialize the GPU after reset. This patch fix few issues
reported by different people regarding KMS & R6XX/RV7XX hw.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r600.c  |   99 ++++++++++++---------------------------
 drivers/gpu/drm/radeon/rv770.c |   72 +++--------------------------
 2 files changed, 39 insertions(+), 132 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index 11fa801..cf4be70 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -240,14 +240,9 @@ int r600_mc_wait_for_idle(struct radeon_device *rdev)
 	return -1;
 }
 
-static void r600_mc_resume(struct radeon_device *rdev)
+static void r600_mc_program(struct radeon_device *rdev)
 {
-	u32 d1vga_control, d2vga_control;
-	u32 vga_render_control, vga_hdp_control;
-	u32 d1crtc_control, d2crtc_control;
-	u32 new_d1grph_primary, new_d1grph_secondary;
-	u32 new_d2grph_primary, new_d2grph_secondary;
-	u64 old_vram_start;
+	struct rv515_mc_save save;
 	u32 tmp;
 	int i, j;
 
@@ -261,41 +256,12 @@ static void r600_mc_resume(struct radeon_device *rdev)
 	}
 	WREG32(HDP_REG_COHERENCY_FLUSH_CNTL, 0);
 
-	d1vga_control = RREG32(D1VGA_CONTROL);
-	d2vga_control = RREG32(D2VGA_CONTROL);
-	vga_render_control = RREG32(VGA_RENDER_CONTROL);
-	vga_hdp_control = RREG32(VGA_HDP_CONTROL);
-	d1crtc_control = RREG32(D1CRTC_CONTROL);
-	d2crtc_control = RREG32(D2CRTC_CONTROL);
-	old_vram_start = (u64)(RREG32(MC_VM_FB_LOCATION) & 0xFFFF) << 24;
-	new_d1grph_primary = RREG32(D1GRPH_PRIMARY_SURFACE_ADDRESS);
-	new_d1grph_secondary = RREG32(D1GRPH_SECONDARY_SURFACE_ADDRESS);
-	new_d1grph_primary += rdev->mc.vram_start - old_vram_start;
-	new_d1grph_secondary += rdev->mc.vram_start - old_vram_start;
-	new_d2grph_primary = RREG32(D2GRPH_PRIMARY_SURFACE_ADDRESS);
-	new_d2grph_secondary = RREG32(D2GRPH_SECONDARY_SURFACE_ADDRESS);
-	new_d2grph_primary += rdev->mc.vram_start - old_vram_start;
-	new_d2grph_secondary += rdev->mc.vram_start - old_vram_start;
-
-	/* Stop all video */
-	WREG32(D1VGA_CONTROL, 0);
-	WREG32(D2VGA_CONTROL, 0);
-	WREG32(VGA_RENDER_CONTROL, 0);
-	WREG32(D1CRTC_UPDATE_LOCK, 1);
-	WREG32(D2CRTC_UPDATE_LOCK, 1);
-	WREG32(D1CRTC_CONTROL, 0);
-	WREG32(D2CRTC_CONTROL, 0);
-	WREG32(D1CRTC_UPDATE_LOCK, 0);
-	WREG32(D2CRTC_UPDATE_LOCK, 0);
-
-	mdelay(1);
+	rv515_mc_stop(rdev, &save);
 	if (r600_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "[drm] MC not idle !\n");
+		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
 	}
-
-	/* Lockout access through VGA aperture*/
+	/* Lockout access through VGA aperture (doesn't exist before R600) */
 	WREG32(VGA_HDP_CONTROL, VGA_MEMORY_DISABLE);
-
 	/* Update configuration */
 	WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR, rdev->mc.vram_start >> 12);
 	WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR, (rdev->mc.vram_end - 1) >> 12);
@@ -315,31 +281,10 @@ static void r600_mc_resume(struct radeon_device *rdev)
 		WREG32(MC_VM_AGP_TOP, 0x0FFFFFFF);
 		WREG32(MC_VM_AGP_BOT, 0x0FFFFFFF);
 	}
-	WREG32(D1GRPH_PRIMARY_SURFACE_ADDRESS, new_d1grph_primary);
-	WREG32(D1GRPH_SECONDARY_SURFACE_ADDRESS, new_d1grph_secondary);
-	WREG32(D2GRPH_PRIMARY_SURFACE_ADDRESS, new_d2grph_primary);
-	WREG32(D2GRPH_SECONDARY_SURFACE_ADDRESS, new_d2grph_secondary);
-	WREG32(VGA_MEMORY_BASE_ADDRESS, rdev->mc.vram_start);
-
-	/* Unlock host access */
-	WREG32(VGA_HDP_CONTROL, vga_hdp_control);
-
-	mdelay(1);
 	if (r600_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "[drm] MC not idle !\n");
+		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
 	}
-
-	/* Restore video state */
-	WREG32(D1CRTC_UPDATE_LOCK, 1);
-	WREG32(D2CRTC_UPDATE_LOCK, 1);
-	WREG32(D1CRTC_CONTROL, d1crtc_control);
-	WREG32(D2CRTC_CONTROL, d2crtc_control);
-	WREG32(D1CRTC_UPDATE_LOCK, 0);
-	WREG32(D2CRTC_UPDATE_LOCK, 0);
-	WREG32(D1VGA_CONTROL, d1vga_control);
-	WREG32(D2VGA_CONTROL, d2vga_control);
-	WREG32(VGA_RENDER_CONTROL, vga_render_control);
-
+	rv515_mc_resume(rdev, &save);
 	/* we need to own VRAM, so turn off the VGA renderer here
 	 * to stop it overwriting our objects */
 	rv515_vga_render_disable(rdev);
@@ -463,6 +408,7 @@ int r600_mc_init(struct radeon_device *rdev)
  */
 int r600_gpu_soft_reset(struct radeon_device *rdev)
 {
+	struct rv515_mc_save save;
 	u32 grbm_busy_mask = S_008010_VC_BUSY(1) | S_008010_VGT_BUSY_NO_DMA(1) |
 				S_008010_VGT_BUSY(1) | S_008010_TA03_BUSY(1) |
 				S_008010_TC_BUSY(1) | S_008010_SX_BUSY(1) |
@@ -480,13 +426,21 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 			S_008014_CB0_BUSY(1) | S_008014_CB1_BUSY(1) |
 			S_008014_CB2_BUSY(1) | S_008014_CB3_BUSY(1);
 	u32 srbm_reset = 0;
+	u32 tmp;
 
+	dev_info(rdev->dev, "GPU softreset (R_008010_GRBM_STATUS=0x%08X "
+		"R_008014_GRBM_STATUS2=0x%08X)\n", RREG32(R_008010_GRBM_STATUS),
+		RREG32(R_008014_GRBM_STATUS2));
+	rv515_mc_stop(rdev, &save);
+	if (r600_mc_wait_for_idle(rdev)) {
+		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
+	}
 	/* Disable CP parsing/prefetching */
 	WREG32(R_0086D8_CP_ME_CNTL, S_0086D8_CP_ME_HALT(0xff));
 	/* Check if any of the rendering block is busy and reset it */
 	if ((RREG32(R_008010_GRBM_STATUS) & grbm_busy_mask) ||
 	    (RREG32(R_008014_GRBM_STATUS2) & grbm2_busy_mask)) {
-		WREG32(R_008020_GRBM_SOFT_RESET, S_008020_SOFT_RESET_CR(1) |
+		tmp = S_008020_SOFT_RESET_CR(1) |
 			S_008020_SOFT_RESET_DB(1) |
 			S_008020_SOFT_RESET_CB(1) |
 			S_008020_SOFT_RESET_PA(1) |
@@ -498,14 +452,18 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 			S_008020_SOFT_RESET_TC(1) |
 			S_008020_SOFT_RESET_TA(1) |
 			S_008020_SOFT_RESET_VC(1) |
-			S_008020_SOFT_RESET_VGT(1));
+			S_008020_SOFT_RESET_VGT(1);
+		dev_info(rdev->dev, "R_008020_GRBM_SOFT_RESET=0x%08X\n", tmp);
+		WREG32(R_008020_GRBM_SOFT_RESET, tmp);
 		(void)RREG32(R_008020_GRBM_SOFT_RESET);
 		udelay(50);
 		WREG32(R_008020_GRBM_SOFT_RESET, 0);
 		(void)RREG32(R_008020_GRBM_SOFT_RESET);
 	}
 	/* Reset CP (we always reset CP) */
-	WREG32(R_008020_GRBM_SOFT_RESET, S_008020_SOFT_RESET_CP(1));
+	tmp = S_008020_SOFT_RESET_CP(1);
+	dev_info(rdev->dev, "R_008020_GRBM_SOFT_RESET=0x%08X\n", tmp);
+	WREG32(R_008020_GRBM_SOFT_RESET, tmp);
 	(void)RREG32(R_008020_GRBM_SOFT_RESET);
 	udelay(50);
 	WREG32(R_008020_GRBM_SOFT_RESET, 0);
@@ -533,6 +491,7 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 		srbm_reset |= S_000E60_SOFT_RESET_RLC(1);
 	if (G_000E50_SEM_BUSY(RREG32(R_000E50_SRBM_STATUS)))
 		srbm_reset |= S_000E60_SOFT_RESET_SEM(1);
+	dev_info(rdev->dev, "R_000E60_SRBM_SOFT_RESET=0x%08X\n", srbm_reset);
 	WREG32(R_000E60_SRBM_SOFT_RESET, srbm_reset);
 	(void)RREG32(R_000E60_SRBM_SOFT_RESET);
 	udelay(50);
@@ -540,6 +499,11 @@ int r600_gpu_soft_reset(struct radeon_device *rdev)
 	(void)RREG32(R_000E60_SRBM_SOFT_RESET);
 	/* Wait a little for things to settle down */
 	udelay(50);
+	/* After reset we need to reinit the asic as GPU often endup in an
+	 * incoherent state.
+	 */
+	atom_asic_init(rdev->mode_info.atom_context);
+	rv515_mc_resume(rdev, &save);
 	return 0;
 }
 
@@ -1477,8 +1441,7 @@ int r600_startup(struct radeon_device *rdev)
 {
 	int r;
 
-	r600_gpu_reset(rdev);
-	r600_mc_resume(rdev);
+	r600_mc_program(rdev);
 	r = r600_pcie_gart_enable(rdev);
 	if (r)
 		return r;
@@ -1509,7 +1472,7 @@ int r600_resume(struct radeon_device *rdev)
 {
 	int r;
 
-	if (radeon_gpu_reset(rdev)) {
+	if (r600_gpu_reset(rdev)) {
 		/* FIXME: what do we want to do here ? */
 	}
 	/* post card */
diff --git a/drivers/gpu/drm/radeon/rv770.c b/drivers/gpu/drm/radeon/rv770.c
index af20a8d..a06e749 100644
--- a/drivers/gpu/drm/radeon/rv770.c
+++ b/drivers/gpu/drm/radeon/rv770.c
@@ -129,14 +129,9 @@ void rv770_pcie_gart_fini(struct radeon_device *rdev)
 /*
  * MC
  */
-static void rv770_mc_resume(struct radeon_device *rdev)
+static void rv770_mc_program(struct radeon_device *rdev)
 {
-	u32 d1vga_control, d2vga_control;
-	u32 vga_render_control, vga_hdp_control;
-	u32 d1crtc_control, d2crtc_control;
-	u32 new_d1grph_primary, new_d1grph_secondary;
-	u32 new_d2grph_primary, new_d2grph_secondary;
-	u64 old_vram_start;
+	struct rv515_mc_save save;
 	u32 tmp;
 	int i, j;
 
@@ -150,41 +145,12 @@ static void rv770_mc_resume(struct radeon_device *rdev)
 	}
 	WREG32(HDP_REG_COHERENCY_FLUSH_CNTL, 0);
 
-	d1vga_control = RREG32(D1VGA_CONTROL);
-	d2vga_control = RREG32(D2VGA_CONTROL);
-	vga_render_control = RREG32(VGA_RENDER_CONTROL);
-	vga_hdp_control = RREG32(VGA_HDP_CONTROL);
-	d1crtc_control = RREG32(D1CRTC_CONTROL);
-	d2crtc_control = RREG32(D2CRTC_CONTROL);
-	old_vram_start = (u64)(RREG32(MC_VM_FB_LOCATION) & 0xFFFF) << 24;
-	new_d1grph_primary = RREG32(D1GRPH_PRIMARY_SURFACE_ADDRESS);
-	new_d1grph_secondary = RREG32(D1GRPH_SECONDARY_SURFACE_ADDRESS);
-	new_d1grph_primary += rdev->mc.vram_start - old_vram_start;
-	new_d1grph_secondary += rdev->mc.vram_start - old_vram_start;
-	new_d2grph_primary = RREG32(D2GRPH_PRIMARY_SURFACE_ADDRESS);
-	new_d2grph_secondary = RREG32(D2GRPH_SECONDARY_SURFACE_ADDRESS);
-	new_d2grph_primary += rdev->mc.vram_start - old_vram_start;
-	new_d2grph_secondary += rdev->mc.vram_start - old_vram_start;
-
-	/* Stop all video */
-	WREG32(D1VGA_CONTROL, 0);
-	WREG32(D2VGA_CONTROL, 0);
-	WREG32(VGA_RENDER_CONTROL, 0);
-	WREG32(D1CRTC_UPDATE_LOCK, 1);
-	WREG32(D2CRTC_UPDATE_LOCK, 1);
-	WREG32(D1CRTC_CONTROL, 0);
-	WREG32(D2CRTC_CONTROL, 0);
-	WREG32(D1CRTC_UPDATE_LOCK, 0);
-	WREG32(D2CRTC_UPDATE_LOCK, 0);
-
-	mdelay(1);
+	rv515_mc_stop(rdev, &save);
 	if (r600_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "[drm] MC not idle !\n");
+		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
 	}
-
 	/* Lockout access through VGA aperture*/
 	WREG32(VGA_HDP_CONTROL, VGA_MEMORY_DISABLE);
-
 	/* Update configuration */
 	WREG32(MC_VM_SYSTEM_APERTURE_LOW_ADDR, rdev->mc.vram_start >> 12);
 	WREG32(MC_VM_SYSTEM_APERTURE_HIGH_ADDR, (rdev->mc.vram_end - 1) >> 12);
@@ -204,31 +170,10 @@ static void rv770_mc_resume(struct radeon_device *rdev)
 		WREG32(MC_VM_AGP_TOP, 0x0FFFFFFF);
 		WREG32(MC_VM_AGP_BOT, 0x0FFFFFFF);
 	}
-	WREG32(D1GRPH_PRIMARY_SURFACE_ADDRESS, new_d1grph_primary);
-	WREG32(D1GRPH_SECONDARY_SURFACE_ADDRESS, new_d1grph_secondary);
-	WREG32(D2GRPH_PRIMARY_SURFACE_ADDRESS, new_d2grph_primary);
-	WREG32(D2GRPH_SECONDARY_SURFACE_ADDRESS, new_d2grph_secondary);
-	WREG32(VGA_MEMORY_BASE_ADDRESS, rdev->mc.vram_start);
-
-	/* Unlock host access */
-	WREG32(VGA_HDP_CONTROL, vga_hdp_control);
-
-	mdelay(1);
 	if (r600_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "[drm] MC not idle !\n");
+		dev_warn(rdev->dev, "Wait for MC idle timedout !\n");
 	}
-
-	/* Restore video state */
-	WREG32(D1CRTC_UPDATE_LOCK, 1);
-	WREG32(D2CRTC_UPDATE_LOCK, 1);
-	WREG32(D1CRTC_CONTROL, d1crtc_control);
-	WREG32(D2CRTC_CONTROL, d2crtc_control);
-	WREG32(D1CRTC_UPDATE_LOCK, 0);
-	WREG32(D2CRTC_UPDATE_LOCK, 0);
-	WREG32(D1VGA_CONTROL, d1vga_control);
-	WREG32(D2VGA_CONTROL, d2vga_control);
-	WREG32(VGA_RENDER_CONTROL, vga_render_control);
-
+	rv515_mc_resume(rdev, &save);
 	/* we need to own VRAM, so turn off the VGA renderer here
 	 * to stop it overwriting our objects */
 	rv515_vga_render_disable(rdev);
@@ -861,8 +806,7 @@ static int rv770_startup(struct radeon_device *rdev)
 {
 	int r;
 
-	radeon_gpu_reset(rdev);
-	rv770_mc_resume(rdev);
+	rv770_mc_program(rdev);
 	r = rv770_pcie_gart_enable(rdev);
 	if (r)
 		return r;
@@ -893,7 +837,7 @@ int rv770_resume(struct radeon_device *rdev)
 {
 	int r;
 
-	if (radeon_gpu_reset(rdev)) {
+	if (rv770_gpu_reset(rdev)) {
 		/* FIXME: what do we want to do here ? */
 	}
 	/* post card */
-- 
1.6.4.4

