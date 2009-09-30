Return-Path: <linux-kernel-owner+w=401wt.eu-S1754980AbZI3RyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980AbZI3RyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 13:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbZI3RyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 13:54:17 -0400
Received: from nox.protox.org ([88.191.38.29]:35009 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754885AbZI3RyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 13:54:15 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Convert RS400/RS480 to new init path & fix legacy VGA (V2)
Date: Wed, 30 Sep 2009 19:53:48 +0200
Message-Id: <1254333228-1710-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also cleanup register specific to RS400/RS480. This patch also fix
legacy VGA register used to disable VGA access we were programming
wrong register. Now we should properly disable VGA on r100 up to
rs400 asics. Note that RS400/RS480 resume is broken, it hangs the
computer while reprogramming dynamic clock, doesn't work either
without that patch. We need to spend more time investigating this
issue. Version 2 of the patch remove dead code that was left
commented out in the previous version.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c        |   14 ++-
 drivers/gpu/drm/radeon/r100d.h       |   38 +++---
 drivers/gpu/drm/radeon/r300.c        |   16 ++-
 drivers/gpu/drm/radeon/r300d.h       |   92 ++++++++++++
 drivers/gpu/drm/radeon/r420.c        |    5 +
 drivers/gpu/drm/radeon/r420d.h       |   24 ++--
 drivers/gpu/drm/radeon/radeon.h      |    4 +
 drivers/gpu/drm/radeon/radeon_asic.h |   45 +++---
 drivers/gpu/drm/radeon/rs400.c       |  261 +++++++++++++++++++++++-----------
 drivers/gpu/drm/radeon/rs400d.h      |  153 ++++++++++++++++++++
 drivers/gpu/drm/radeon/rv350d.h      |   52 +++++++
 11 files changed, 560 insertions(+), 144 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/rs400d.h
 create mode 100644 drivers/gpu/drm/radeon/rv350d.h

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index d209914..dc45ec1 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -3100,7 +3100,7 @@ void r100_mc_stop(struct radeon_device *rdev, struct r100_mc_save *save)
 	WREG32(R_000740_CP_CSQ_CNTL, 0);
 
 	/* Save few CRTC registers */
-	save->GENMO_WT = RREG32(R_0003C0_GENMO_WT);
+	save->GENMO_WT = RREG8(R_0003C2_GENMO_WT);
 	save->CRTC_EXT_CNTL = RREG32(R_000054_CRTC_EXT_CNTL);
 	save->CRTC_GEN_CNTL = RREG32(R_000050_CRTC_GEN_CNTL);
 	save->CUR_OFFSET = RREG32(R_000260_CUR_OFFSET);
@@ -3110,7 +3110,7 @@ void r100_mc_stop(struct radeon_device *rdev, struct r100_mc_save *save)
 	}
 
 	/* Disable VGA aperture access */
-	WREG32(R_0003C0_GENMO_WT, C_0003C0_VGA_RAM_EN & save->GENMO_WT);
+	WREG8(R_0003C2_GENMO_WT, C_0003C2_VGA_RAM_EN & save->GENMO_WT);
 	/* Disable cursor, overlay, crtc */
 	WREG32(R_000260_CUR_OFFSET, save->CUR_OFFSET | S_000260_CUR_LOCK(1));
 	WREG32(R_000054_CRTC_EXT_CNTL, save->CRTC_EXT_CNTL |
@@ -3142,10 +3142,18 @@ void r100_mc_resume(struct radeon_device *rdev, struct r100_mc_save *save)
 				rdev->mc.vram_location);
 	}
 	/* Restore CRTC registers */
-	WREG32(R_0003C0_GENMO_WT, save->GENMO_WT);
+	WREG8(R_0003C2_GENMO_WT, save->GENMO_WT);
 	WREG32(R_000054_CRTC_EXT_CNTL, save->CRTC_EXT_CNTL);
 	WREG32(R_000050_CRTC_GEN_CNTL, save->CRTC_GEN_CNTL);
 	if (!(rdev->flags & RADEON_SINGLE_CRTC)) {
 		WREG32(R_0003F8_CRTC2_GEN_CNTL, save->CRTC2_GEN_CNTL);
 	}
 }
+
+void r100_vga_render_disable(struct radeon_device *rdev)
+{
+    u32 tmp;
+
+    tmp = RREG8(R_0003C2_GENMO_WT);
+	WREG8(R_0003C2_GENMO_WT, C_0003C2_VGA_RAM_EN & tmp);
+}
diff --git a/drivers/gpu/drm/radeon/r100d.h b/drivers/gpu/drm/radeon/r100d.h
index c4b257e..1595a5d 100644
--- a/drivers/gpu/drm/radeon/r100d.h
+++ b/drivers/gpu/drm/radeon/r100d.h
@@ -403,25 +403,25 @@
 #define   S_000360_CUR2_LOCK(x)                        (((x) & 0x1) << 31)
 #define   G_000360_CUR2_LOCK(x)                        (((x) >> 31) & 0x1)
 #define   C_000360_CUR2_LOCK                           0x7FFFFFFF
-#define R_0003C0_GENMO_WT                            0x0003C0
-#define   S_0003C0_GENMO_MONO_ADDRESS_B(x)             (((x) & 0x1) << 0)
-#define   G_0003C0_GENMO_MONO_ADDRESS_B(x)             (((x) >> 0) & 0x1)
-#define   C_0003C0_GENMO_MONO_ADDRESS_B                0xFFFFFFFE
-#define   S_0003C0_VGA_RAM_EN(x)                       (((x) & 0x1) << 1)
-#define   G_0003C0_VGA_RAM_EN(x)                       (((x) >> 1) & 0x1)
-#define   C_0003C0_VGA_RAM_EN                          0xFFFFFFFD
-#define   S_0003C0_VGA_CKSEL(x)                        (((x) & 0x3) << 2)
-#define   G_0003C0_VGA_CKSEL(x)                        (((x) >> 2) & 0x3)
-#define   C_0003C0_VGA_CKSEL                           0xFFFFFFF3
-#define   S_0003C0_ODD_EVEN_MD_PGSEL(x)                (((x) & 0x1) << 5)
-#define   G_0003C0_ODD_EVEN_MD_PGSEL(x)                (((x) >> 5) & 0x1)
-#define   C_0003C0_ODD_EVEN_MD_PGSEL                   0xFFFFFFDF
-#define   S_0003C0_VGA_HSYNC_POL(x)                    (((x) & 0x1) << 6)
-#define   G_0003C0_VGA_HSYNC_POL(x)                    (((x) >> 6) & 0x1)
-#define   C_0003C0_VGA_HSYNC_POL                       0xFFFFFFBF
-#define   S_0003C0_VGA_VSYNC_POL(x)                    (((x) & 0x1) << 7)
-#define   G_0003C0_VGA_VSYNC_POL(x)                    (((x) >> 7) & 0x1)
-#define   C_0003C0_VGA_VSYNC_POL                       0xFFFFFF7F
+#define R_0003C2_GENMO_WT                            0x0003C0
+#define   S_0003C2_GENMO_MONO_ADDRESS_B(x)             (((x) & 0x1) << 0)
+#define   G_0003C2_GENMO_MONO_ADDRESS_B(x)             (((x) >> 0) & 0x1)
+#define   C_0003C2_GENMO_MONO_ADDRESS_B                0xFE
+#define   S_0003C2_VGA_RAM_EN(x)                       (((x) & 0x1) << 1)
+#define   G_0003C2_VGA_RAM_EN(x)                       (((x) >> 1) & 0x1)
+#define   C_0003C2_VGA_RAM_EN                          0xFD
+#define   S_0003C2_VGA_CKSEL(x)                        (((x) & 0x3) << 2)
+#define   G_0003C2_VGA_CKSEL(x)                        (((x) >> 2) & 0x3)
+#define   C_0003C2_VGA_CKSEL                           0xF3
+#define   S_0003C2_ODD_EVEN_MD_PGSEL(x)                (((x) & 0x1) << 5)
+#define   G_0003C2_ODD_EVEN_MD_PGSEL(x)                (((x) >> 5) & 0x1)
+#define   C_0003C2_ODD_EVEN_MD_PGSEL                   0xDF
+#define   S_0003C2_VGA_HSYNC_POL(x)                    (((x) & 0x1) << 6)
+#define   G_0003C2_VGA_HSYNC_POL(x)                    (((x) >> 6) & 0x1)
+#define   C_0003C2_VGA_HSYNC_POL                       0xBF
+#define   S_0003C2_VGA_VSYNC_POL(x)                    (((x) & 0x1) << 7)
+#define   G_0003C2_VGA_VSYNC_POL(x)                    (((x) >> 7) & 0x1)
+#define   C_0003C2_VGA_VSYNC_POL                       0x7F
 #define R_0003F8_CRTC2_GEN_CNTL                      0x0003F8
 #define   S_0003F8_CRTC2_DBL_SCAN_EN(x)                (((x) & 0x1) << 0)
 #define   G_0003F8_CRTC2_DBL_SCAN_EN(x)                (((x) >> 0) & 0x1)
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 1ebea8c..e491d40 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -33,6 +33,7 @@
 #include "radeon_drm.h"
 #include "r100_track.h"
 #include "r300d.h"
+#include "rv350d.h"
 
 #include "r300_reg_safe.h"
 
@@ -63,7 +64,6 @@ int r100_cs_track_check_pkt3_indx_buffer(struct radeon_cs_parser *p,
  * Some of these functions might be used by newer ASICs.
  */
 void r300_gpu_init(struct radeon_device *rdev);
-int r300_mc_wait_for_idle(struct radeon_device *rdev);
 int rv370_debugfs_pcie_gart_info_init(struct radeon_device *rdev);
 
 
@@ -1265,3 +1265,17 @@ void r300_mc_program(struct radeon_device *rdev)
 		S_000148_MC_FB_TOP(rdev->mc.vram_end >> 16));
 	r100_mc_resume(rdev, &save);
 }
+
+void r300_clock_startup(struct radeon_device *rdev)
+{
+	u32 tmp;
+
+	if (radeon_dynclks != -1 && radeon_dynclks)
+		radeon_legacy_set_clock_gating(rdev, 1);
+	/* We need to force on some of the block */
+	tmp = RREG32_PLL(R_00000D_SCLK_CNTL);
+	tmp |= S_00000D_FORCE_CP(1) | S_00000D_FORCE_VIP(1);
+	if ((rdev->family == CHIP_RV350) || (rdev->family == CHIP_RV380))
+		tmp |= S_00000D_FORCE_VAP(1);
+	WREG32_PLL(R_00000D_SCLK_CNTL, tmp);
+}
diff --git a/drivers/gpu/drm/radeon/r300d.h b/drivers/gpu/drm/radeon/r300d.h
index d4fa3eb..a6d54da 100644
--- a/drivers/gpu/drm/radeon/r300d.h
+++ b/drivers/gpu/drm/radeon/r300d.h
@@ -98,4 +98,96 @@
 #define   C_000170_AGP_BASE_ADDR                       0x00000000
 
 
+#define R_00000D_SCLK_CNTL                           0x00000D
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
 #endif
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 49a2fdc..c5d3ba4 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -155,6 +155,9 @@ static void r420_debugfs(struct radeon_device *rdev)
 static void r420_clock_resume(struct radeon_device *rdev)
 {
 	u32 sclk_cntl;
+
+	if (radeon_dynclks != -1 && radeon_dynclks)
+		radeon_atom_set_clock_gating(rdev, 1);
 	sclk_cntl = RREG32_PLL(R_00000D_SCLK_CNTL);
 	sclk_cntl |= S_00000D_FORCE_CP(1) | S_00000D_FORCE_VIP(1);
 	if (rdev->family == CHIP_R420)
@@ -167,6 +170,8 @@ static int r420_startup(struct radeon_device *rdev)
 	int r;
 
 	r300_mc_program(rdev);
+	/* Resume clock */
+	r420_clock_resume(rdev);
 	/* Initialize GART (initialize after TTM so we can allocate
 	 * memory through TTM but finalize after TTM) */
 	if (rdev->flags & RADEON_IS_PCIE) {
diff --git a/drivers/gpu/drm/radeon/r420d.h b/drivers/gpu/drm/radeon/r420d.h
index a48a7db..fc78d31 100644
--- a/drivers/gpu/drm/radeon/r420d.h
+++ b/drivers/gpu/drm/radeon/r420d.h
@@ -212,9 +212,9 @@
 #define   S_00000D_FORCE_E2(x)                         (((x) & 0x1) << 20)
 #define   G_00000D_FORCE_E2(x)                         (((x) >> 20) & 0x1)
 #define   C_00000D_FORCE_E2                            0xFFEFFFFF
-#define   S_00000D_FORCE_SE(x)                         (((x) & 0x1) << 21)
-#define   G_00000D_FORCE_SE(x)                         (((x) >> 21) & 0x1)
-#define   C_00000D_FORCE_SE                            0xFFDFFFFF
+#define   S_00000D_FORCE_VAP(x)                        (((x) & 0x1) << 21)
+#define   G_00000D_FORCE_VAP(x)                        (((x) >> 21) & 0x1)
+#define   C_00000D_FORCE_VAP                           0xFFDFFFFF
 #define   S_00000D_FORCE_IDCT(x)                       (((x) & 0x1) << 22)
 #define   G_00000D_FORCE_IDCT(x)                       (((x) >> 22) & 0x1)
 #define   C_00000D_FORCE_IDCT                          0xFFBFFFFF
@@ -224,24 +224,24 @@
 #define   S_00000D_FORCE_RE(x)                         (((x) & 0x1) << 24)
 #define   G_00000D_FORCE_RE(x)                         (((x) >> 24) & 0x1)
 #define   C_00000D_FORCE_RE                            0xFEFFFFFF
-#define   S_00000D_FORCE_PB(x)                         (((x) & 0x1) << 25)
-#define   G_00000D_FORCE_PB(x)                         (((x) >> 25) & 0x1)
-#define   C_00000D_FORCE_PB                            0xFDFFFFFF
+#define   S_00000D_FORCE_SR(x)                         (((x) & 0x1) << 25)
+#define   G_00000D_FORCE_SR(x)                         (((x) >> 25) & 0x1)
+#define   C_00000D_FORCE_SR                            0xFDFFFFFF
 #define   S_00000D_FORCE_PX(x)                         (((x) & 0x1) << 26)
 #define   G_00000D_FORCE_PX(x)                         (((x) >> 26) & 0x1)
 #define   C_00000D_FORCE_PX                            0xFBFFFFFF
 #define   S_00000D_FORCE_TX(x)                         (((x) & 0x1) << 27)
 #define   G_00000D_FORCE_TX(x)                         (((x) >> 27) & 0x1)
 #define   C_00000D_FORCE_TX                            0xF7FFFFFF
-#define   S_00000D_FORCE_RB(x)                         (((x) & 0x1) << 28)
-#define   G_00000D_FORCE_RB(x)                         (((x) >> 28) & 0x1)
-#define   C_00000D_FORCE_RB                            0xEFFFFFFF
+#define   S_00000D_FORCE_US(x)                         (((x) & 0x1) << 28)
+#define   G_00000D_FORCE_US(x)                         (((x) >> 28) & 0x1)
+#define   C_00000D_FORCE_US                            0xEFFFFFFF
 #define   S_00000D_FORCE_TV_SCLK(x)                    (((x) & 0x1) << 29)
 #define   G_00000D_FORCE_TV_SCLK(x)                    (((x) >> 29) & 0x1)
 #define   C_00000D_FORCE_TV_SCLK                       0xDFFFFFFF
-#define   S_00000D_FORCE_SUBPIC(x)                     (((x) & 0x1) << 30)
-#define   G_00000D_FORCE_SUBPIC(x)                     (((x) >> 30) & 0x1)
-#define   C_00000D_FORCE_SUBPIC                        0xBFFFFFFF
+#define   S_00000D_FORCE_SU(x)                         (((x) & 0x1) << 30)
+#define   G_00000D_FORCE_SU(x)                         (((x) >> 30) & 0x1)
+#define   C_00000D_FORCE_SU                            0xBFFFFFFF
 #define   S_00000D_FORCE_OV0(x)                        (((x) & 0x1) << 31)
 #define   G_00000D_FORCE_OV0(x)                        (((x) >> 31) & 0x1)
 #define   C_00000D_FORCE_OV0                           0x7FFFFFFF
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 1b797d2..88bd538 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -994,6 +994,7 @@ extern void radeon_clocks_fini(struct radeon_device *rdev);
 extern void radeon_scratch_init(struct radeon_device *rdev);
 extern void radeon_surface_init(struct radeon_device *rdev);
 extern int radeon_cs_parser_init(struct radeon_cs_parser *p, void *data);
+extern void radeon_legacy_set_clock_gating(struct radeon_device *rdev, int enable);
 extern void radeon_atom_set_clock_gating(struct radeon_device *rdev, int enable);
 
 /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
@@ -1029,11 +1030,14 @@ extern int r100_wb_init(struct radeon_device *rdev);
 extern void r100_hdp_reset(struct radeon_device *rdev);
 extern int r100_rb2d_reset(struct radeon_device *rdev);
 extern int r100_cp_reset(struct radeon_device *rdev);
+extern void r100_vga_render_disable(struct radeon_device *rdev);
 
 /* r300,r350,rv350,rv370,rv380 */
 extern void r300_set_reg_safe(struct radeon_device *rdev);
 extern void r300_mc_program(struct radeon_device *rdev);
 extern void r300_vram_info(struct radeon_device *rdev);
+extern void r300_clock_startup(struct radeon_device *rdev);
+extern int r300_mc_wait_for_idle(struct radeon_device *rdev);
 extern int rv370_pcie_gart_init(struct radeon_device *rdev);
 extern void rv370_pcie_gart_fini(struct radeon_device *rdev);
 extern int rv370_pcie_gart_enable(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index ae6d342..b8bdefb 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -246,41 +246,40 @@ static struct radeon_asic r420_asic = {
 /*
  * rs400,rs480
  */
-void rs400_errata(struct radeon_device *rdev);
-void rs400_vram_info(struct radeon_device *rdev);
-int rs400_mc_init(struct radeon_device *rdev);
-void rs400_mc_fini(struct radeon_device *rdev);
-int rs400_gart_init(struct radeon_device *rdev);
-void rs400_gart_fini(struct radeon_device *rdev);
-int rs400_gart_enable(struct radeon_device *rdev);
-void rs400_gart_disable(struct radeon_device *rdev);
+extern int rs400_init(struct radeon_device *rdev);
+extern void rs400_fini(struct radeon_device *rdev);
+extern int rs400_suspend(struct radeon_device *rdev);
+extern int rs400_resume(struct radeon_device *rdev);
 void rs400_gart_tlb_flush(struct radeon_device *rdev);
 int rs400_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 uint32_t rs400_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rs400_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 static struct radeon_asic rs400_asic = {
-	.init = &r300_init,
-	.errata = &rs400_errata,
-	.vram_info = &rs400_vram_info,
+	.init = &rs400_init,
+	.fini = &rs400_fini,
+	.suspend = &rs400_suspend,
+	.resume = &rs400_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = &rs400_mc_init,
-	.mc_fini = &rs400_mc_fini,
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
 	.irq_set = &r100_irq_set,
 	.irq_process = &r100_irq_process,
 	.get_vblank_counter = &r100_get_vblank_counter,
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index a3fbdad..0233404 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -27,27 +27,12 @@
  */
 #include <linux/seq_file.h>
 #include <drm/drmP.h>
-#include "radeon_reg.h"
 #include "radeon.h"
+#include "rs400d.h"
 
-/* rs400,rs480 depends on : */
-void r100_hdp_reset(struct radeon_device *rdev);
-void r100_mc_disable_clients(struct radeon_device *rdev);
-int r300_mc_wait_for_idle(struct radeon_device *rdev);
-void r420_pipes_init(struct radeon_device *rdev);
+/* This files gather functions specifics to : rs400,rs480 */
+static int rs400_debugfs_pcie_gart_info_init(struct radeon_device *rdev);
 
-/* This files gather functions specifics to :
- * rs400,rs480
- *
- * Some of these functions might be used by newer ASICs.
- */
-void rs400_gpu_init(struct radeon_device *rdev);
-int rs400_debugfs_pcie_gart_info_init(struct radeon_device *rdev);
-
-
-/*
- * GART functions.
- */
 void rs400_gart_adjust_size(struct radeon_device *rdev)
 {
 	/* Check gart size */
@@ -238,61 +223,6 @@ int rs400_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr)
 	return 0;
 }
 
-
-/*
- * MC functions.
- */
-int rs400_mc_init(struct radeon_device *rdev)
-{
-	uint32_t tmp;
-	int r;
-
-	if (r100_debugfs_rbbm_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-	}
-
-	rs400_gpu_init(rdev);
-	rs400_gart_disable(rdev);
-	rdev->mc.gtt_location = rdev->mc.mc_vram_size;
-	rdev->mc.gtt_location += (rdev->mc.gtt_size - 1);
-	rdev->mc.gtt_location &= ~(rdev->mc.gtt_size - 1);
-	r = radeon_mc_setup(rdev);
-	if (r) {
-		return r;
-	}
-
-	r100_mc_disable_clients(rdev);
-	if (r300_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-
-	tmp = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
-	tmp = REG_SET(RADEON_MC_FB_TOP, tmp >> 16);
-	tmp |= REG_SET(RADEON_MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32(RADEON_MC_FB_LOCATION, tmp);
-	tmp = RREG32(RADEON_HOST_PATH_CNTL) | RADEON_HP_LIN_RD_CACHE_DIS;
-	WREG32(RADEON_HOST_PATH_CNTL, tmp | RADEON_HDP_SOFT_RESET | RADEON_HDP_READ_BUFFER_INVALIDATE);
-	(void)RREG32(RADEON_HOST_PATH_CNTL);
-	WREG32(RADEON_HOST_PATH_CNTL, tmp);
-	(void)RREG32(RADEON_HOST_PATH_CNTL);
-
-	return 0;
-}
-
-void rs400_mc_fini(struct radeon_device *rdev)
-{
-}
-
-
-/*
- * Global GPU functions
- */
-void rs400_errata(struct radeon_device *rdev)
-{
-	rdev->pll_errata = 0;
-}
-
 void rs400_gpu_init(struct radeon_device *rdev)
 {
 	/* FIXME: HDP same place on rs400 ? */
@@ -305,10 +235,6 @@ void rs400_gpu_init(struct radeon_device *rdev)
 	}
 }
 
-
-/*
- * VRAM info.
- */
 void rs400_vram_info(struct radeon_device *rdev)
 {
 	rs400_gart_adjust_size(rdev);
@@ -319,10 +245,6 @@ void rs400_vram_info(struct radeon_device *rdev)
 	r100_vram_init_sizes(rdev);
 }
 
-
-/*
- * Indirect registers accessor
- */
 uint32_t rs400_mc_rreg(struct radeon_device *rdev, uint32_t reg)
 {
 	uint32_t r;
@@ -340,10 +262,6 @@ void rs400_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 	WREG32(RS480_NB_MC_INDEX, 0xff);
 }
 
-
-/*
- * Debugfs info
- */
 #if defined(CONFIG_DEBUG_FS)
 static int rs400_debugfs_gart_info(struct seq_file *m, void *data)
 {
@@ -419,7 +337,7 @@ static struct drm_info_list rs400_gart_info_list[] = {
 };
 #endif
 
-int rs400_debugfs_pcie_gart_info_init(struct radeon_device *rdev)
+static int rs400_debugfs_pcie_gart_info_init(struct radeon_device *rdev)
 {
 #if defined(CONFIG_DEBUG_FS)
 	return radeon_debugfs_add_files(rdev, rs400_gart_info_list, 1);
@@ -427,3 +345,174 @@ int rs400_debugfs_pcie_gart_info_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
+
+void rs400_mc_program(struct radeon_device *rdev)
+{
+	struct r100_mc_save save;
+
+	/* Stops all mc clients */
+	r100_mc_stop(rdev, &save);
+
+	/* Wait for mc idle */
+	if (r300_mc_wait_for_idle(rdev))
+		dev_warn(rdev->dev, "Wait MC idle timeout before updating MC.\n");
+	WREG32(R_000148_MC_FB_LOCATION,
+		S_000148_MC_FB_START(rdev->mc.vram_start >> 16) |
+		S_000148_MC_FB_TOP(rdev->mc.vram_end >> 16));
+
+	r100_mc_resume(rdev, &save);
+}
+
+static int rs400_startup(struct radeon_device *rdev)
+{
+	int r;
+
+	rs400_mc_program(rdev);
+	/* Resume clock */
+	r300_clock_startup(rdev);
+	/* Initialize GPU configuration (# pipes, ...) */
+	rs400_gpu_init(rdev);
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
+int rs400_resume(struct radeon_device *rdev)
+{
+	/* Make sur GART are not working */
+	rs400_gart_disable(rdev);
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
+	return rs400_startup(rdev);
+}
+
+int rs400_suspend(struct radeon_device *rdev)
+{
+	r100_cp_disable(rdev);
+	r100_wb_disable(rdev);
+	r100_irq_disable(rdev);
+	rs400_gart_disable(rdev);
+	return 0;
+}
+
+void rs400_fini(struct radeon_device *rdev)
+{
+	rs400_suspend(rdev);
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
+int rs400_init(struct radeon_device *rdev)
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
+	/* Initialize clocks */
+	radeon_get_clock_info(rdev->ddev);
+	/* Get vram informations */
+	rs400_vram_info(rdev);
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
+	r = rs400_gart_init(rdev);
+	if (r)
+		return r;
+	r300_set_reg_safe(rdev);
+	rdev->accel_working = true;
+	r = rs400_startup(rdev);
+	if (r) {
+		/* Somethings want wront with the accel init stop accel */
+		dev_err(rdev->dev, "Disabling GPU acceleration\n");
+		rs400_suspend(rdev);
+		r100_cp_fini(rdev);
+		r100_wb_fini(rdev);
+		r100_ib_fini(rdev);
+		rs400_gart_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+		rdev->accel_working = false;
+	}
+	return 0;
+}
diff --git a/drivers/gpu/drm/radeon/rs400d.h b/drivers/gpu/drm/radeon/rs400d.h
new file mode 100644
index 0000000..f0a3e0d
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rs400d.h
@@ -0,0 +1,153 @@
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
+#ifndef __RS400D_H__
+#define __RS400D_H__
+
+/* Registers */
+#define R_000148_MC_FB_LOCATION                      0x000148
+#define   S_000148_MC_FB_START(x)                      (((x) & 0xFFFF) << 0)
+#define   G_000148_MC_FB_START(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_000148_MC_FB_START                         0xFFFF0000
+#define   S_000148_MC_FB_TOP(x)                        (((x) & 0xFFFF) << 16)
+#define   G_000148_MC_FB_TOP(x)                        (((x) >> 16) & 0xFFFF)
+#define   C_000148_MC_FB_TOP                           0x0000FFFF
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
+
+#endif
diff --git a/drivers/gpu/drm/radeon/rv350d.h b/drivers/gpu/drm/radeon/rv350d.h
new file mode 100644
index 0000000..c75c5ed
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rv350d.h
@@ -0,0 +1,52 @@
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
+#ifndef __RV350D_H__
+#define __RV350D_H__
+
+/* RV350, RV380 registers */
+/* #define R_00000D_SCLK_CNTL                           0x00000D */
+#define   S_00000D_FORCE_VAP(x)                        (((x) & 0x1) << 21)
+#define   G_00000D_FORCE_VAP(x)                        (((x) >> 21) & 0x1)
+#define   C_00000D_FORCE_VAP                           0xFFDFFFFF
+#define   S_00000D_FORCE_SR(x)                         (((x) & 0x1) << 25)
+#define   G_00000D_FORCE_SR(x)                         (((x) >> 25) & 0x1)
+#define   C_00000D_FORCE_SR                            0xFDFFFFFF
+#define   S_00000D_FORCE_PX(x)                         (((x) & 0x1) << 26)
+#define   G_00000D_FORCE_PX(x)                         (((x) >> 26) & 0x1)
+#define   C_00000D_FORCE_PX                            0xFBFFFFFF
+#define   S_00000D_FORCE_TX(x)                         (((x) & 0x1) << 27)
+#define   G_00000D_FORCE_TX(x)                         (((x) >> 27) & 0x1)
+#define   C_00000D_FORCE_TX                            0xF7FFFFFF
+#define   S_00000D_FORCE_US(x)                         (((x) & 0x1) << 28)
+#define   G_00000D_FORCE_US(x)                         (((x) >> 28) & 0x1)
+#define   C_00000D_FORCE_US                            0xEFFFFFFF
+#define   S_00000D_FORCE_SU(x)                         (((x) & 0x1) << 30)
+#define   G_00000D_FORCE_SU(x)                         (((x) >> 30) & 0x1)
+#define   C_00000D_FORCE_SU                            0xBFFFFFFF
+
+#endif
-- 
1.6.4.4

