Return-Path: <linux-kernel-owner+w=401wt.eu-S934260AbZJGJJA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934260AbZJGJJA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 05:09:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934024AbZJGJI7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 05:08:59 -0400
Received: from nox.protox.org ([88.191.38.29]:33249 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476AbZJGJI6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 05:08:58 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: Fix RS600/RV515/R520/RS690 IRQ
Date: Wed,  7 Oct 2009 11:08:22 +0200
Message-Id: <1254906502-2456-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bad generated header file leaded to use wrong register
to check IRQ status and acknowledge them. Fix the header
and use proper registers.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/rs600.c  |    8 ++--
 drivers/gpu/drm/radeon/rs600d.h |   64 +++++++++++++++++++++++++++++++++++++++
 2 files changed, 68 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index 01f6834..10dfa78 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -206,10 +206,10 @@ int rs600_irq_set(struct radeon_device *rdev)
 
 static inline uint32_t rs600_irq_ack(struct radeon_device *rdev, u32 *r500_disp_int)
 {
-	uint32_t irqs = RREG32(R_000040_GEN_INT_CNTL);
-	uint32_t irq_mask = ~C_000040_SW_INT_EN;
+	uint32_t irqs = RREG32(R_000044_GEN_INT_STATUS);
+	uint32_t irq_mask = ~C_000044_SW_INT;
 
-	if (G_000040_DISPLAY_INT_STATUS(irqs)) {
+	if (G_000044_DISPLAY_INT_STAT(irqs)) {
 		*r500_disp_int = RREG32(R_007EDC_DISP_INTERRUPT_STATUS);
 		if (G_007EDC_LB_D1_VBLANK_INTERRUPT(*r500_disp_int)) {
 			WREG32(R_006534_D1MODE_VBLANK_STATUS,
@@ -224,7 +224,7 @@ static inline uint32_t rs600_irq_ack(struct radeon_device *rdev, u32 *r500_disp_
 	}
 
 	if (irqs) {
-		WREG32(R_000040_GEN_INT_CNTL, irqs);
+		WREG32(R_000044_GEN_INT_STATUS, irqs);
 	}
 	return irqs & irq_mask;
 }
diff --git a/drivers/gpu/drm/radeon/rs600d.h b/drivers/gpu/drm/radeon/rs600d.h
index 6dac524..8130892 100644
--- a/drivers/gpu/drm/radeon/rs600d.h
+++ b/drivers/gpu/drm/radeon/rs600d.h
@@ -87,6 +87,70 @@
 #define   S_000040_VIDDMA(x)                           (((x) & 0x1) << 31)
 #define   G_000040_VIDDMA(x)                           (((x) >> 31) & 0x1)
 #define   C_000040_VIDDMA                              0x7FFFFFFF
+#define R_000044_GEN_INT_STATUS                      0x000044
+#define   S_000044_DISPLAY_INT_STAT(x)                 (((x) & 0x1) << 0)
+#define   G_000044_DISPLAY_INT_STAT(x)                 (((x) >> 0) & 0x1)
+#define   C_000044_DISPLAY_INT_STAT                    0xFFFFFFFE
+#define   S_000044_VGA_INT_STAT(x)                     (((x) & 0x1) << 1)
+#define   G_000044_VGA_INT_STAT(x)                     (((x) >> 1) & 0x1)
+#define   C_000044_VGA_INT_STAT                        0xFFFFFFFD
+#define   S_000044_CAP0_INT_ACTIVE(x)                  (((x) & 0x1) << 8)
+#define   G_000044_CAP0_INT_ACTIVE(x)                  (((x) >> 8) & 0x1)
+#define   C_000044_CAP0_INT_ACTIVE                     0xFFFFFEFF
+#define   S_000044_DMA_VIPH0_INT(x)                    (((x) & 0x1) << 12)
+#define   G_000044_DMA_VIPH0_INT(x)                    (((x) >> 12) & 0x1)
+#define   C_000044_DMA_VIPH0_INT                       0xFFFFEFFF
+#define   S_000044_DMA_VIPH1_INT(x)                    (((x) & 0x1) << 13)
+#define   G_000044_DMA_VIPH1_INT(x)                    (((x) >> 13) & 0x1)
+#define   C_000044_DMA_VIPH1_INT                       0xFFFFDFFF
+#define   S_000044_DMA_VIPH2_INT(x)                    (((x) & 0x1) << 14)
+#define   G_000044_DMA_VIPH2_INT(x)                    (((x) >> 14) & 0x1)
+#define   C_000044_DMA_VIPH2_INT                       0xFFFFBFFF
+#define   S_000044_DMA_VIPH3_INT(x)                    (((x) & 0x1) << 15)
+#define   G_000044_DMA_VIPH3_INT(x)                    (((x) >> 15) & 0x1)
+#define   C_000044_DMA_VIPH3_INT                       0xFFFF7FFF
+#define   S_000044_MC_PROBE_FAULT_STAT(x)              (((x) & 0x1) << 16)
+#define   G_000044_MC_PROBE_FAULT_STAT(x)              (((x) >> 16) & 0x1)
+#define   C_000044_MC_PROBE_FAULT_STAT                 0xFFFEFFFF
+#define   S_000044_I2C_INT(x)                          (((x) & 0x1) << 17)
+#define   G_000044_I2C_INT(x)                          (((x) >> 17) & 0x1)
+#define   C_000044_I2C_INT                             0xFFFDFFFF
+#define   S_000044_SCRATCH_INT_STAT(x)                 (((x) & 0x1) << 18)
+#define   G_000044_SCRATCH_INT_STAT(x)                 (((x) >> 18) & 0x1)
+#define   C_000044_SCRATCH_INT_STAT                    0xFFFBFFFF
+#define   S_000044_GUI_IDLE_STAT(x)                    (((x) & 0x1) << 19)
+#define   G_000044_GUI_IDLE_STAT(x)                    (((x) >> 19) & 0x1)
+#define   C_000044_GUI_IDLE_STAT                       0xFFF7FFFF
+#define   S_000044_ATI_OVERDRIVE_INT_STAT(x)           (((x) & 0x1) << 20)
+#define   G_000044_ATI_OVERDRIVE_INT_STAT(x)           (((x) >> 20) & 0x1)
+#define   C_000044_ATI_OVERDRIVE_INT_STAT              0xFFEFFFFF
+#define   S_000044_MC_PROTECTION_FAULT_STAT(x)         (((x) & 0x1) << 21)
+#define   G_000044_MC_PROTECTION_FAULT_STAT(x)         (((x) >> 21) & 0x1)
+#define   C_000044_MC_PROTECTION_FAULT_STAT            0xFFDFFFFF
+#define   S_000044_RBBM_READ_INT_STAT(x)               (((x) & 0x1) << 22)
+#define   G_000044_RBBM_READ_INT_STAT(x)               (((x) >> 22) & 0x1)
+#define   C_000044_RBBM_READ_INT_STAT                  0xFFBFFFFF
+#define   S_000044_CB_CONTEXT_SWITCH_STAT(x)           (((x) & 0x1) << 23)
+#define   G_000044_CB_CONTEXT_SWITCH_STAT(x)           (((x) >> 23) & 0x1)
+#define   C_000044_CB_CONTEXT_SWITCH_STAT              0xFF7FFFFF
+#define   S_000044_VIPH_INT(x)                         (((x) & 0x1) << 24)
+#define   G_000044_VIPH_INT(x)                         (((x) >> 24) & 0x1)
+#define   C_000044_VIPH_INT                            0xFEFFFFFF
+#define   S_000044_SW_INT(x)                           (((x) & 0x1) << 25)
+#define   G_000044_SW_INT(x)                           (((x) >> 25) & 0x1)
+#define   C_000044_SW_INT                              0xFDFFFFFF
+#define   S_000044_SW_INT_SET(x)                       (((x) & 0x1) << 26)
+#define   G_000044_SW_INT_SET(x)                       (((x) >> 26) & 0x1)
+#define   C_000044_SW_INT_SET                          0xFBFFFFFF
+#define   S_000044_IDCT_INT_STAT(x)                    (((x) & 0x1) << 27)
+#define   G_000044_IDCT_INT_STAT(x)                    (((x) >> 27) & 0x1)
+#define   C_000044_IDCT_INT_STAT                       0xF7FFFFFF
+#define   S_000044_GUIDMA_STAT(x)                      (((x) & 0x1) << 30)
+#define   G_000044_GUIDMA_STAT(x)                      (((x) >> 30) & 0x1)
+#define   C_000044_GUIDMA_STAT                         0xBFFFFFFF
+#define   S_000044_VIDDMA_STAT(x)                      (((x) & 0x1) << 31)
+#define   G_000044_VIDDMA_STAT(x)                      (((x) >> 31) & 0x1)
+#define   C_000044_VIDDMA_STAT                         0x7FFFFFFF
 #define R_00004C_BUS_CNTL                            0x00004C
 #define   S_00004C_BUS_MASTER_DIS(x)                   (((x) & 0x1) << 14)
 #define   G_00004C_BUS_MASTER_DIS(x)                   (((x) >> 14) & 0x1)
-- 
1.6.4.4

