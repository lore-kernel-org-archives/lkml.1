Return-Path: <linux-kernel-owner+w=401wt.eu-S1752098AbZIKNfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbZIKNfV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 09:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751150AbZIKNfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 09:35:21 -0400
Received: from nox.protox.org ([88.191.38.29]:55411 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103AbZIKNfT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 09:35:19 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] drm/radeon/kms: convert r4xx to new init path
Date: Fri, 11 Sep 2009 15:35:22 +0200
Message-Id: <1252676122-1939-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This convert r4xx to new init path it also fix few bugs.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/r100.c          |  114 ++++++++-
 drivers/gpu/drm/radeon/r100d.h         |  471 ++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/r300.c          |   50 +++-
 drivers/gpu/drm/radeon/r300d.h         |   25 ++
 drivers/gpu/drm/radeon/r420.c          |  293 ++++++++++++++------
 drivers/gpu/drm/radeon/r420d.h         |  206 ++++++++++++++
 drivers/gpu/drm/radeon/radeon.h        |   32 ++-
 drivers/gpu/drm/radeon/radeon_asic.h   |   33 ++-
 drivers/gpu/drm/radeon/radeon_device.c |   19 +-
 drivers/gpu/drm/radeon/radeon_ring.c   |    2 +
 10 files changed, 1121 insertions(+), 124 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 4dd5ca5..47263d3 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -299,6 +299,17 @@ int r100_irq_set(struct radeon_device *rdev)
 	return 0;
 }
 
+void r100_irq_disable(struct radeon_device *rdev)
+{
+	u32 tmp;
+
+	WREG32(R_000040_GEN_INT_CNTL, 0);
+	/* Wait and acknowledge irq */
+	mdelay(1);
+	tmp = RREG32(R_000044_GEN_INT_STATUS);
+	WREG32(R_000044_GEN_INT_STATUS, tmp);
+}
+
 static inline uint32_t r100_irq_ack(struct radeon_device *rdev)
 {
 	uint32_t irqs = RREG32(RADEON_GEN_INT_STATUS);
@@ -396,14 +407,21 @@ int r100_wb_init(struct radeon_device *rdev)
 			return r;
 		}
 	}
-	WREG32(RADEON_SCRATCH_ADDR, rdev->wb.gpu_addr);
-	WREG32(RADEON_CP_RB_RPTR_ADDR, rdev->wb.gpu_addr + 1024);
-	WREG32(RADEON_SCRATCH_UMSK, 0xff);
+	WREG32(R_000774_SCRATCH_ADDR, rdev->wb.gpu_addr);
+	WREG32(R_00070C_CP_RB_RPTR_ADDR,
+		S_00070C_RB_RPTR_ADDR((rdev->wb.gpu_addr + 1024) >> 2));
+	WREG32(R_000770_SCRATCH_UMSK, 0xff);
 	return 0;
 }
 
+void r100_wb_disable(struct radeon_device *rdev)
+{
+	WREG32(R_000770_SCRATCH_UMSK, 0);
+}
+
 void r100_wb_fini(struct radeon_device *rdev)
 {
+	r100_wb_disable(rdev);
 	if (rdev->wb.wb_obj) {
 		radeon_object_kunmap(rdev->wb.wb_obj);
 		radeon_object_unpin(rdev->wb.wb_obj);
@@ -1581,11 +1599,12 @@ static int r100_packet3_check(struct radeon_cs_parser *p,
 int r100_cs_parse(struct radeon_cs_parser *p)
 {
 	struct radeon_cs_packet pkt;
-	struct r100_cs_track track;
+	struct r100_cs_track *track;
 	int r;
 
-	r100_cs_track_clear(p->rdev, &track);
-	p->track = &track;
+	track = kzalloc(sizeof(*track), GFP_KERNEL);
+	r100_cs_track_clear(p->rdev, track);
+	p->track = track;
 	do {
 		r = r100_cs_packet_parse(p, &pkt, p->idx);
 		if (r) {
@@ -3085,3 +3104,86 @@ int r100_ib_test(struct radeon_device *rdev)
 	radeon_ib_free(rdev, &ib);
 	return r;
 }
+
+void r100_ib_fini(struct radeon_device *rdev)
+{
+	radeon_ib_pool_fini(rdev);
+}
+
+int r100_ib_init(struct radeon_device *rdev)
+{
+	int r;
+
+	r = radeon_ib_pool_init(rdev);
+	if (r) {
+		dev_err(rdev->dev, "failled initializing IB pool (%d).\n", r);
+		r100_ib_fini(rdev);
+		return r;
+	}
+	r = r100_ib_test(rdev);
+	if (r) {
+		dev_err(rdev->dev, "failled testing IB (%d).\n", r);
+		r100_ib_fini(rdev);
+		return r;
+	}
+	return 0;
+}
+
+void r100_mc_stop(struct radeon_device *rdev, struct r100_mc_save *save)
+{
+	/* Shutdown CP we shouldn't need to do that but better be safe than
+	 * sorry
+	 */
+	rdev->cp.ready = false;
+	WREG32(R_000740_CP_CSQ_CNTL, 0);
+
+	/* Save few CRTC registers */
+	save->GENMO_WT = RREG32(R_0003C0_GENMO_WT);
+	save->CRTC_EXT_CNTL = RREG32(R_000054_CRTC_EXT_CNTL);
+	save->CRTC_GEN_CNTL = RREG32(R_000050_CRTC_GEN_CNTL);
+	save->CUR_OFFSET = RREG32(R_000260_CUR_OFFSET);
+	if (!(rdev->flags & RADEON_SINGLE_CRTC)) {
+		save->CRTC2_GEN_CNTL = RREG32(R_0003F8_CRTC2_GEN_CNTL);
+		save->CUR2_OFFSET = RREG32(R_000360_CUR2_OFFSET);
+	}
+
+	/* Disable VGA aperture access */
+	WREG32(R_0003C0_GENMO_WT, C_0003C0_VGA_RAM_EN & save->GENMO_WT);
+	/* Disable cursor, overlay, crtc */
+	WREG32(R_000260_CUR_OFFSET, save->CUR_OFFSET | S_000260_CUR_LOCK(1));
+	WREG32(R_000054_CRTC_EXT_CNTL, save->CRTC_EXT_CNTL |
+					S_000054_CRTC_DISPLAY_DIS(1));
+	WREG32(R_000050_CRTC_GEN_CNTL,
+			(C_000050_CRTC_CUR_EN & save->CRTC_GEN_CNTL) |
+			S_000050_CRTC_DISP_REQ_EN_B(1));
+	WREG32(R_000420_OV0_SCALE_CNTL,
+		C_000420_OV0_OVERLAY_EN & RREG32(R_000420_OV0_SCALE_CNTL));
+	WREG32(R_000260_CUR_OFFSET, C_000260_CUR_LOCK & save->CUR_OFFSET);
+	if (!(rdev->flags & RADEON_SINGLE_CRTC)) {
+		WREG32(R_000360_CUR2_OFFSET, save->CUR2_OFFSET |
+						S_000360_CUR2_LOCK(1));
+		WREG32(R_0003F8_CRTC2_GEN_CNTL,
+			(C_0003F8_CRTC2_CUR_EN & save->CRTC2_GEN_CNTL) |
+			S_0003F8_CRTC2_DISPLAY_DIS(1) |
+			S_0003F8_CRTC2_DISP_REQ_EN_B(1));
+		WREG32(R_000360_CUR2_OFFSET,
+			C_000360_CUR2_LOCK & save->CUR2_OFFSET);
+	}
+}
+
+void r100_mc_resume(struct radeon_device *rdev, struct r100_mc_save *save)
+{
+	/* Update base address for crtc */
+	WREG32(R_00023C_DISPLAY_BASE_ADDR, rdev->mc.vram_location);
+	if (!(rdev->flags & RADEON_SINGLE_CRTC)) {
+		WREG32(R_00033C_CRTC2_DISPLAY_BASE_ADDR,
+				rdev->mc.vram_location);
+	}
+	/* Restore CRTC registers */
+	WREG32(R_0003C0_GENMO_WT, save->GENMO_WT);
+	WREG32(R_000054_CRTC_EXT_CNTL, save->CRTC_EXT_CNTL);
+	WREG32(R_000050_CRTC_GEN_CNTL, save->CRTC_GEN_CNTL);
+	if (!(rdev->flags & RADEON_SINGLE_CRTC)) {
+		WREG32(R_0003F8_CRTC2_GEN_CNTL, save->CRTC2_GEN_CNTL);
+	}
+}
diff --git a/drivers/gpu/drm/radeon/r100d.h b/drivers/gpu/drm/radeon/r100d.h
index 1d951ab..c4b257e 100644
--- a/drivers/gpu/drm/radeon/r100d.h
+++ b/drivers/gpu/drm/radeon/r100d.h
@@ -74,6 +74,477 @@
 #define CP_PACKET3_GET_OPCODE(h) (((h) >> 8) & 0xFF)
 
 /* Registers */
+#define R_000040_GEN_INT_CNTL                        0x000040
+#define   S_000040_CRTC_VBLANK(x)                      (((x) & 0x1) << 0)
+#define   G_000040_CRTC_VBLANK(x)                      (((x) >> 0) & 0x1)
+#define   C_000040_CRTC_VBLANK                         0xFFFFFFFE
+#define   S_000040_CRTC_VLINE(x)                       (((x) & 0x1) << 1)
+#define   G_000040_CRTC_VLINE(x)                       (((x) >> 1) & 0x1)
+#define   C_000040_CRTC_VLINE                          0xFFFFFFFD
+#define   S_000040_CRTC_VSYNC(x)                       (((x) & 0x1) << 2)
+#define   G_000040_CRTC_VSYNC(x)                       (((x) >> 2) & 0x1)
+#define   C_000040_CRTC_VSYNC                          0xFFFFFFFB
+#define   S_000040_SNAPSHOT(x)                         (((x) & 0x1) << 3)
+#define   G_000040_SNAPSHOT(x)                         (((x) >> 3) & 0x1)
+#define   C_000040_SNAPSHOT                            0xFFFFFFF7
+#define   S_000040_FP_DETECT(x)                        (((x) & 0x1) << 4)
+#define   G_000040_FP_DETECT(x)                        (((x) >> 4) & 0x1)
+#define   C_000040_FP_DETECT                           0xFFFFFFEF
+#define   S_000040_CRTC2_VLINE(x)                      (((x) & 0x1) << 5)
+#define   G_000040_CRTC2_VLINE(x)                      (((x) >> 5) & 0x1)
+#define   C_000040_CRTC2_VLINE                         0xFFFFFFDF
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
+#define R_000044_GEN_INT_STATUS                      0x000044
+#define   S_000044_CRTC_VBLANK_STAT(x)                 (((x) & 0x1) << 0)
+#define   G_000044_CRTC_VBLANK_STAT(x)                 (((x) >> 0) & 0x1)
+#define   C_000044_CRTC_VBLANK_STAT                    0xFFFFFFFE
+#define   S_000044_CRTC_VBLANK_STAT_AK(x)              (((x) & 0x1) << 0)
+#define   G_000044_CRTC_VBLANK_STAT_AK(x)              (((x) >> 0) & 0x1)
+#define   C_000044_CRTC_VBLANK_STAT_AK                 0xFFFFFFFE
+#define   S_000044_CRTC_VLINE_STAT(x)                  (((x) & 0x1) << 1)
+#define   G_000044_CRTC_VLINE_STAT(x)                  (((x) >> 1) & 0x1)
+#define   C_000044_CRTC_VLINE_STAT                     0xFFFFFFFD
+#define   S_000044_CRTC_VLINE_STAT_AK(x)               (((x) & 0x1) << 1)
+#define   G_000044_CRTC_VLINE_STAT_AK(x)               (((x) >> 1) & 0x1)
+#define   C_000044_CRTC_VLINE_STAT_AK                  0xFFFFFFFD
+#define   S_000044_CRTC_VSYNC_STAT(x)                  (((x) & 0x1) << 2)
+#define   G_000044_CRTC_VSYNC_STAT(x)                  (((x) >> 2) & 0x1)
+#define   C_000044_CRTC_VSYNC_STAT                     0xFFFFFFFB
+#define   S_000044_CRTC_VSYNC_STAT_AK(x)               (((x) & 0x1) << 2)
+#define   G_000044_CRTC_VSYNC_STAT_AK(x)               (((x) >> 2) & 0x1)
+#define   C_000044_CRTC_VSYNC_STAT_AK                  0xFFFFFFFB
+#define   S_000044_SNAPSHOT_STAT(x)                    (((x) & 0x1) << 3)
+#define   G_000044_SNAPSHOT_STAT(x)                    (((x) >> 3) & 0x1)
+#define   C_000044_SNAPSHOT_STAT                       0xFFFFFFF7
+#define   S_000044_SNAPSHOT_STAT_AK(x)                 (((x) & 0x1) << 3)
+#define   G_000044_SNAPSHOT_STAT_AK(x)                 (((x) >> 3) & 0x1)
+#define   C_000044_SNAPSHOT_STAT_AK                    0xFFFFFFF7
+#define   S_000044_FP_DETECT_STAT(x)                   (((x) & 0x1) << 4)
+#define   G_000044_FP_DETECT_STAT(x)                   (((x) >> 4) & 0x1)
+#define   C_000044_FP_DETECT_STAT                      0xFFFFFFEF
+#define   S_000044_FP_DETECT_STAT_AK(x)                (((x) & 0x1) << 4)
+#define   G_000044_FP_DETECT_STAT_AK(x)                (((x) >> 4) & 0x1)
+#define   C_000044_FP_DETECT_STAT_AK                   0xFFFFFFEF
+#define   S_000044_CRTC2_VLINE_STAT(x)                 (((x) & 0x1) << 5)
+#define   G_000044_CRTC2_VLINE_STAT(x)                 (((x) >> 5) & 0x1)
+#define   C_000044_CRTC2_VLINE_STAT                    0xFFFFFFDF
+#define   S_000044_CRTC2_VLINE_STAT_AK(x)              (((x) & 0x1) << 5)
+#define   G_000044_CRTC2_VLINE_STAT_AK(x)              (((x) >> 5) & 0x1)
+#define   C_000044_CRTC2_VLINE_STAT_AK                 0xFFFFFFDF
+#define   S_000044_CRTC2_VSYNC_STAT(x)                 (((x) & 0x1) << 6)
+#define   G_000044_CRTC2_VSYNC_STAT(x)                 (((x) >> 6) & 0x1)
+#define   C_000044_CRTC2_VSYNC_STAT                    0xFFFFFFBF
+#define   S_000044_CRTC2_VSYNC_STAT_AK(x)              (((x) & 0x1) << 6)
+#define   G_000044_CRTC2_VSYNC_STAT_AK(x)              (((x) >> 6) & 0x1)
+#define   C_000044_CRTC2_VSYNC_STAT_AK                 0xFFFFFFBF
+#define   S_000044_SNAPSHOT2_STAT(x)                   (((x) & 0x1) << 7)
+#define   G_000044_SNAPSHOT2_STAT(x)                   (((x) >> 7) & 0x1)
+#define   C_000044_SNAPSHOT2_STAT                      0xFFFFFF7F
+#define   S_000044_SNAPSHOT2_STAT_AK(x)                (((x) & 0x1) << 7)
+#define   G_000044_SNAPSHOT2_STAT_AK(x)                (((x) >> 7) & 0x1)
+#define   C_000044_SNAPSHOT2_STAT_AK                   0xFFFFFF7F
+#define   S_000044_CAP0_INT_ACTIVE(x)                  (((x) & 0x1) << 8)
+#define   G_000044_CAP0_INT_ACTIVE(x)                  (((x) >> 8) & 0x1)
+#define   C_000044_CAP0_INT_ACTIVE                     0xFFFFFEFF
+#define   S_000044_CRTC2_VBLANK_STAT(x)                (((x) & 0x1) << 9)
+#define   G_000044_CRTC2_VBLANK_STAT(x)                (((x) >> 9) & 0x1)
+#define   C_000044_CRTC2_VBLANK_STAT                   0xFFFFFDFF
+#define   S_000044_CRTC2_VBLANK_STAT_AK(x)             (((x) & 0x1) << 9)
+#define   G_000044_CRTC2_VBLANK_STAT_AK(x)             (((x) >> 9) & 0x1)
+#define   C_000044_CRTC2_VBLANK_STAT_AK                0xFFFFFDFF
+#define   S_000044_FP2_DETECT_STAT(x)                  (((x) & 0x1) << 10)
+#define   G_000044_FP2_DETECT_STAT(x)                  (((x) >> 10) & 0x1)
+#define   C_000044_FP2_DETECT_STAT                     0xFFFFFBFF
+#define   S_000044_FP2_DETECT_STAT_AK(x)               (((x) & 0x1) << 10)
+#define   G_000044_FP2_DETECT_STAT_AK(x)               (((x) >> 10) & 0x1)
+#define   C_000044_FP2_DETECT_STAT_AK                  0xFFFFFBFF
+#define   S_000044_VSYNC_DIFF_OVER_LIMIT_STAT(x)       (((x) & 0x1) << 11)
+#define   G_000044_VSYNC_DIFF_OVER_LIMIT_STAT(x)       (((x) >> 11) & 0x1)
+#define   C_000044_VSYNC_DIFF_OVER_LIMIT_STAT          0xFFFFF7FF
+#define   S_000044_VSYNC_DIFF_OVER_LIMIT_STAT_AK(x)    (((x) & 0x1) << 11)
+#define   G_000044_VSYNC_DIFF_OVER_LIMIT_STAT_AK(x)    (((x) >> 11) & 0x1)
+#define   C_000044_VSYNC_DIFF_OVER_LIMIT_STAT_AK       0xFFFFF7FF
+#define   S_000044_DMA_VIPH0_INT(x)                    (((x) & 0x1) << 12)
+#define   G_000044_DMA_VIPH0_INT(x)                    (((x) >> 12) & 0x1)
+#define   C_000044_DMA_VIPH0_INT                       0xFFFFEFFF
+#define   S_000044_DMA_VIPH0_INT_AK(x)                 (((x) & 0x1) << 12)
+#define   G_000044_DMA_VIPH0_INT_AK(x)                 (((x) >> 12) & 0x1)
+#define   C_000044_DMA_VIPH0_INT_AK                    0xFFFFEFFF
+#define   S_000044_DMA_VIPH1_INT(x)                    (((x) & 0x1) << 13)
+#define   G_000044_DMA_VIPH1_INT(x)                    (((x) >> 13) & 0x1)
+#define   C_000044_DMA_VIPH1_INT                       0xFFFFDFFF
+#define   S_000044_DMA_VIPH1_INT_AK(x)                 (((x) & 0x1) << 13)
+#define   G_000044_DMA_VIPH1_INT_AK(x)                 (((x) >> 13) & 0x1)
+#define   C_000044_DMA_VIPH1_INT_AK                    0xFFFFDFFF
+#define   S_000044_DMA_VIPH2_INT(x)                    (((x) & 0x1) << 14)
+#define   G_000044_DMA_VIPH2_INT(x)                    (((x) >> 14) & 0x1)
+#define   C_000044_DMA_VIPH2_INT                       0xFFFFBFFF
+#define   S_000044_DMA_VIPH2_INT_AK(x)                 (((x) & 0x1) << 14)
+#define   G_000044_DMA_VIPH2_INT_AK(x)                 (((x) >> 14) & 0x1)
+#define   C_000044_DMA_VIPH2_INT_AK                    0xFFFFBFFF
+#define   S_000044_DMA_VIPH3_INT(x)                    (((x) & 0x1) << 15)
+#define   G_000044_DMA_VIPH3_INT(x)                    (((x) >> 15) & 0x1)
+#define   C_000044_DMA_VIPH3_INT                       0xFFFF7FFF
+#define   S_000044_DMA_VIPH3_INT_AK(x)                 (((x) & 0x1) << 15)
+#define   G_000044_DMA_VIPH3_INT_AK(x)                 (((x) >> 15) & 0x1)
+#define   C_000044_DMA_VIPH3_INT_AK                    0xFFFF7FFF
+#define   S_000044_I2C_INT(x)                          (((x) & 0x1) << 17)
+#define   G_000044_I2C_INT(x)                          (((x) >> 17) & 0x1)
+#define   C_000044_I2C_INT                             0xFFFDFFFF
+#define   S_000044_I2C_INT_AK(x)                       (((x) & 0x1) << 17)
+#define   G_000044_I2C_INT_AK(x)                       (((x) >> 17) & 0x1)
+#define   C_000044_I2C_INT_AK                          0xFFFDFFFF
+#define   S_000044_GUI_IDLE_STAT(x)                    (((x) & 0x1) << 19)
+#define   G_000044_GUI_IDLE_STAT(x)                    (((x) >> 19) & 0x1)
+#define   C_000044_GUI_IDLE_STAT                       0xFFF7FFFF
+#define   S_000044_GUI_IDLE_STAT_AK(x)                 (((x) & 0x1) << 19)
+#define   G_000044_GUI_IDLE_STAT_AK(x)                 (((x) >> 19) & 0x1)
+#define   C_000044_GUI_IDLE_STAT_AK                    0xFFF7FFFF
+#define   S_000044_VIPH_INT(x)                         (((x) & 0x1) << 24)
+#define   G_000044_VIPH_INT(x)                         (((x) >> 24) & 0x1)
+#define   C_000044_VIPH_INT                            0xFEFFFFFF
+#define   S_000044_SW_INT(x)                           (((x) & 0x1) << 25)
+#define   G_000044_SW_INT(x)                           (((x) >> 25) & 0x1)
+#define   C_000044_SW_INT                              0xFDFFFFFF
+#define   S_000044_SW_INT_AK(x)                        (((x) & 0x1) << 25)
+#define   G_000044_SW_INT_AK(x)                        (((x) >> 25) & 0x1)
+#define   C_000044_SW_INT_AK                           0xFDFFFFFF
+#define   S_000044_SW_INT_SET(x)                       (((x) & 0x1) << 26)
+#define   G_000044_SW_INT_SET(x)                       (((x) >> 26) & 0x1)
+#define   C_000044_SW_INT_SET                          0xFBFFFFFF
+#define   S_000044_GEYSERVILLE_STAT(x)                 (((x) & 0x1) << 27)
+#define   G_000044_GEYSERVILLE_STAT(x)                 (((x) >> 27) & 0x1)
+#define   C_000044_GEYSERVILLE_STAT                    0xF7FFFFFF
+#define   S_000044_GEYSERVILLE_STAT_AK(x)              (((x) & 0x1) << 27)
+#define   G_000044_GEYSERVILLE_STAT_AK(x)              (((x) >> 27) & 0x1)
+#define   C_000044_GEYSERVILLE_STAT_AK                 0xF7FFFFFF
+#define   S_000044_HDCP_AUTHORIZED_INT_STAT(x)         (((x) & 0x1) << 28)
+#define   G_000044_HDCP_AUTHORIZED_INT_STAT(x)         (((x) >> 28) & 0x1)
+#define   C_000044_HDCP_AUTHORIZED_INT_STAT            0xEFFFFFFF
+#define   S_000044_HDCP_AUTHORIZED_INT_AK(x)           (((x) & 0x1) << 28)
+#define   G_000044_HDCP_AUTHORIZED_INT_AK(x)           (((x) >> 28) & 0x1)
+#define   C_000044_HDCP_AUTHORIZED_INT_AK              0xEFFFFFFF
+#define   S_000044_DVI_I2C_INT_STAT(x)                 (((x) & 0x1) << 29)
+#define   G_000044_DVI_I2C_INT_STAT(x)                 (((x) >> 29) & 0x1)
+#define   C_000044_DVI_I2C_INT_STAT                    0xDFFFFFFF
+#define   S_000044_DVI_I2C_INT_AK(x)                   (((x) & 0x1) << 29)
+#define   G_000044_DVI_I2C_INT_AK(x)                   (((x) >> 29) & 0x1)
+#define   C_000044_DVI_I2C_INT_AK                      0xDFFFFFFF
+#define   S_000044_GUIDMA_STAT(x)                      (((x) & 0x1) << 30)
+#define   G_000044_GUIDMA_STAT(x)                      (((x) >> 30) & 0x1)
+#define   C_000044_GUIDMA_STAT                         0xBFFFFFFF
+#define   S_000044_GUIDMA_AK(x)                        (((x) & 0x1) << 30)
+#define   G_000044_GUIDMA_AK(x)                        (((x) >> 30) & 0x1)
+#define   C_000044_GUIDMA_AK                           0xBFFFFFFF
+#define   S_000044_VIDDMA_STAT(x)                      (((x) & 0x1) << 31)
+#define   G_000044_VIDDMA_STAT(x)                      (((x) >> 31) & 0x1)
+#define   C_000044_VIDDMA_STAT                         0x7FFFFFFF
+#define   S_000044_VIDDMA_AK(x)                        (((x) & 0x1) << 31)
+#define   G_000044_VIDDMA_AK(x)                        (((x) >> 31) & 0x1)
+#define   C_000044_VIDDMA_AK                           0x7FFFFFFF
+#define R_000050_CRTC_GEN_CNTL                       0x000050
+#define   S_000050_CRTC_DBL_SCAN_EN(x)                 (((x) & 0x1) << 0)
+#define   G_000050_CRTC_DBL_SCAN_EN(x)                 (((x) >> 0) & 0x1)
+#define   C_000050_CRTC_DBL_SCAN_EN                    0xFFFFFFFE
+#define   S_000050_CRTC_INTERLACE_EN(x)                (((x) & 0x1) << 1)
+#define   G_000050_CRTC_INTERLACE_EN(x)                (((x) >> 1) & 0x1)
+#define   C_000050_CRTC_INTERLACE_EN                   0xFFFFFFFD
+#define   S_000050_CRTC_C_SYNC_EN(x)                   (((x) & 0x1) << 4)
+#define   G_000050_CRTC_C_SYNC_EN(x)                   (((x) >> 4) & 0x1)
+#define   C_000050_CRTC_C_SYNC_EN                      0xFFFFFFEF
+#define   S_000050_CRTC_PIX_WIDTH(x)                   (((x) & 0xF) << 8)
+#define   G_000050_CRTC_PIX_WIDTH(x)                   (((x) >> 8) & 0xF)
+#define   C_000050_CRTC_PIX_WIDTH                      0xFFFFF0FF
+#define   S_000050_CRTC_ICON_EN(x)                     (((x) & 0x1) << 15)
+#define   G_000050_CRTC_ICON_EN(x)                     (((x) >> 15) & 0x1)
+#define   C_000050_CRTC_ICON_EN                        0xFFFF7FFF
+#define   S_000050_CRTC_CUR_EN(x)                      (((x) & 0x1) << 16)
+#define   G_000050_CRTC_CUR_EN(x)                      (((x) >> 16) & 0x1)
+#define   C_000050_CRTC_CUR_EN                         0xFFFEFFFF
+#define   S_000050_CRTC_VSTAT_MODE(x)                  (((x) & 0x3) << 17)
+#define   G_000050_CRTC_VSTAT_MODE(x)                  (((x) >> 17) & 0x3)
+#define   C_000050_CRTC_VSTAT_MODE                     0xFFF9FFFF
+#define   S_000050_CRTC_CUR_MODE(x)                    (((x) & 0x7) << 20)
+#define   G_000050_CRTC_CUR_MODE(x)                    (((x) >> 20) & 0x7)
+#define   C_000050_CRTC_CUR_MODE                       0xFF8FFFFF
+#define   S_000050_CRTC_EXT_DISP_EN(x)                 (((x) & 0x1) << 24)
+#define   G_000050_CRTC_EXT_DISP_EN(x)                 (((x) >> 24) & 0x1)
+#define   C_000050_CRTC_EXT_DISP_EN                    0xFEFFFFFF
+#define   S_000050_CRTC_EN(x)                          (((x) & 0x1) << 25)
+#define   G_000050_CRTC_EN(x)                          (((x) >> 25) & 0x1)
+#define   C_000050_CRTC_EN                             0xFDFFFFFF
+#define   S_000050_CRTC_DISP_REQ_EN_B(x)               (((x) & 0x1) << 26)
+#define   G_000050_CRTC_DISP_REQ_EN_B(x)               (((x) >> 26) & 0x1)
+#define   C_000050_CRTC_DISP_REQ_EN_B                  0xFBFFFFFF
+#define R_000054_CRTC_EXT_CNTL                       0x000054
+#define   S_000054_CRTC_VGA_XOVERSCAN(x)               (((x) & 0x1) << 0)
+#define   G_000054_CRTC_VGA_XOVERSCAN(x)               (((x) >> 0) & 0x1)
+#define   C_000054_CRTC_VGA_XOVERSCAN                  0xFFFFFFFE
+#define   S_000054_VGA_BLINK_RATE(x)                   (((x) & 0x3) << 1)
+#define   G_000054_VGA_BLINK_RATE(x)                   (((x) >> 1) & 0x3)
+#define   C_000054_VGA_BLINK_RATE                      0xFFFFFFF9
+#define   S_000054_VGA_ATI_LINEAR(x)                   (((x) & 0x1) << 3)
+#define   G_000054_VGA_ATI_LINEAR(x)                   (((x) >> 3) & 0x1)
+#define   C_000054_VGA_ATI_LINEAR                      0xFFFFFFF7
+#define   S_000054_VGA_128KAP_PAGING(x)                (((x) & 0x1) << 4)
+#define   G_000054_VGA_128KAP_PAGING(x)                (((x) >> 4) & 0x1)
+#define   C_000054_VGA_128KAP_PAGING                   0xFFFFFFEF
+#define   S_000054_VGA_TEXT_132(x)                     (((x) & 0x1) << 5)
+#define   G_000054_VGA_TEXT_132(x)                     (((x) >> 5) & 0x1)
+#define   C_000054_VGA_TEXT_132                        0xFFFFFFDF
+#define   S_000054_VGA_XCRT_CNT_EN(x)                  (((x) & 0x1) << 6)
+#define   G_000054_VGA_XCRT_CNT_EN(x)                  (((x) >> 6) & 0x1)
+#define   C_000054_VGA_XCRT_CNT_EN                     0xFFFFFFBF
+#define   S_000054_CRTC_HSYNC_DIS(x)                   (((x) & 0x1) << 8)
+#define   G_000054_CRTC_HSYNC_DIS(x)                   (((x) >> 8) & 0x1)
+#define   C_000054_CRTC_HSYNC_DIS                      0xFFFFFEFF
+#define   S_000054_CRTC_VSYNC_DIS(x)                   (((x) & 0x1) << 9)
+#define   G_000054_CRTC_VSYNC_DIS(x)                   (((x) >> 9) & 0x1)
+#define   C_000054_CRTC_VSYNC_DIS                      0xFFFFFDFF
+#define   S_000054_CRTC_DISPLAY_DIS(x)                 (((x) & 0x1) << 10)
+#define   G_000054_CRTC_DISPLAY_DIS(x)                 (((x) >> 10) & 0x1)
+#define   C_000054_CRTC_DISPLAY_DIS                    0xFFFFFBFF
+#define   S_000054_CRTC_SYNC_TRISTATE(x)               (((x) & 0x1) << 11)
+#define   G_000054_CRTC_SYNC_TRISTATE(x)               (((x) >> 11) & 0x1)
+#define   C_000054_CRTC_SYNC_TRISTATE                  0xFFFFF7FF
+#define   S_000054_CRTC_HSYNC_TRISTATE(x)              (((x) & 0x1) << 12)
+#define   G_000054_CRTC_HSYNC_TRISTATE(x)              (((x) >> 12) & 0x1)
+#define   C_000054_CRTC_HSYNC_TRISTATE                 0xFFFFEFFF
+#define   S_000054_CRTC_VSYNC_TRISTATE(x)              (((x) & 0x1) << 13)
+#define   G_000054_CRTC_VSYNC_TRISTATE(x)              (((x) >> 13) & 0x1)
+#define   C_000054_CRTC_VSYNC_TRISTATE                 0xFFFFDFFF
+#define   S_000054_CRT_ON(x)                           (((x) & 0x1) << 15)
+#define   G_000054_CRT_ON(x)                           (((x) >> 15) & 0x1)
+#define   C_000054_CRT_ON                              0xFFFF7FFF
+#define   S_000054_VGA_CUR_B_TEST(x)                   (((x) & 0x1) << 17)
+#define   G_000054_VGA_CUR_B_TEST(x)                   (((x) >> 17) & 0x1)
+#define   C_000054_VGA_CUR_B_TEST                      0xFFFDFFFF
+#define   S_000054_VGA_PACK_DIS(x)                     (((x) & 0x1) << 18)
+#define   G_000054_VGA_PACK_DIS(x)                     (((x) >> 18) & 0x1)
+#define   C_000054_VGA_PACK_DIS                        0xFFFBFFFF
+#define   S_000054_VGA_MEM_PS_EN(x)                    (((x) & 0x1) << 19)
+#define   G_000054_VGA_MEM_PS_EN(x)                    (((x) >> 19) & 0x1)
+#define   C_000054_VGA_MEM_PS_EN                       0xFFF7FFFF
+#define   S_000054_VCRTC_IDX_MASTER(x)                 (((x) & 0x7F) << 24)
+#define   G_000054_VCRTC_IDX_MASTER(x)                 (((x) >> 24) & 0x7F)
+#define   C_000054_VCRTC_IDX_MASTER                    0x80FFFFFF
+#define R_00023C_DISPLAY_BASE_ADDR                   0x00023C
+#define   S_00023C_DISPLAY_BASE_ADDR(x)                (((x) & 0xFFFFFFFF) << 0)
+#define   G_00023C_DISPLAY_BASE_ADDR(x)                (((x) >> 0) & 0xFFFFFFFF)
+#define   C_00023C_DISPLAY_BASE_ADDR                   0x00000000
+#define R_000260_CUR_OFFSET                          0x000260
+#define   S_000260_CUR_OFFSET(x)                       (((x) & 0x7FFFFFF) << 0)
+#define   G_000260_CUR_OFFSET(x)                       (((x) >> 0) & 0x7FFFFFF)
+#define   C_000260_CUR_OFFSET                          0xF8000000
+#define   S_000260_CUR_LOCK(x)                         (((x) & 0x1) << 31)
+#define   G_000260_CUR_LOCK(x)                         (((x) >> 31) & 0x1)
+#define   C_000260_CUR_LOCK                            0x7FFFFFFF
+#define R_00033C_CRTC2_DISPLAY_BASE_ADDR             0x00033C
+#define   S_00033C_CRTC2_DISPLAY_BASE_ADDR(x)          (((x) & 0xFFFFFFFF) << 0)
+#define   G_00033C_CRTC2_DISPLAY_BASE_ADDR(x)          (((x) >> 0) & 0xFFFFFFFF)
+#define   C_00033C_CRTC2_DISPLAY_BASE_ADDR             0x00000000
+#define R_000360_CUR2_OFFSET                         0x000360
+#define   S_000360_CUR2_OFFSET(x)                      (((x) & 0x7FFFFFF) << 0)
+#define   G_000360_CUR2_OFFSET(x)                      (((x) >> 0) & 0x7FFFFFF)
+#define   C_000360_CUR2_OFFSET                         0xF8000000
+#define   S_000360_CUR2_LOCK(x)                        (((x) & 0x1) << 31)
+#define   G_000360_CUR2_LOCK(x)                        (((x) >> 31) & 0x1)
+#define   C_000360_CUR2_LOCK                           0x7FFFFFFF
+#define R_0003C0_GENMO_WT                            0x0003C0
+#define   S_0003C0_GENMO_MONO_ADDRESS_B(x)             (((x) & 0x1) << 0)
+#define   G_0003C0_GENMO_MONO_ADDRESS_B(x)             (((x) >> 0) & 0x1)
+#define   C_0003C0_GENMO_MONO_ADDRESS_B                0xFFFFFFFE
+#define   S_0003C0_VGA_RAM_EN(x)                       (((x) & 0x1) << 1)
+#define   G_0003C0_VGA_RAM_EN(x)                       (((x) >> 1) & 0x1)
+#define   C_0003C0_VGA_RAM_EN                          0xFFFFFFFD
+#define   S_0003C0_VGA_CKSEL(x)                        (((x) & 0x3) << 2)
+#define   G_0003C0_VGA_CKSEL(x)                        (((x) >> 2) & 0x3)
+#define   C_0003C0_VGA_CKSEL                           0xFFFFFFF3
+#define   S_0003C0_ODD_EVEN_MD_PGSEL(x)                (((x) & 0x1) << 5)
+#define   G_0003C0_ODD_EVEN_MD_PGSEL(x)                (((x) >> 5) & 0x1)
+#define   C_0003C0_ODD_EVEN_MD_PGSEL                   0xFFFFFFDF
+#define   S_0003C0_VGA_HSYNC_POL(x)                    (((x) & 0x1) << 6)
+#define   G_0003C0_VGA_HSYNC_POL(x)                    (((x) >> 6) & 0x1)
+#define   C_0003C0_VGA_HSYNC_POL                       0xFFFFFFBF
+#define   S_0003C0_VGA_VSYNC_POL(x)                    (((x) & 0x1) << 7)
+#define   G_0003C0_VGA_VSYNC_POL(x)                    (((x) >> 7) & 0x1)
+#define   C_0003C0_VGA_VSYNC_POL                       0xFFFFFF7F
+#define R_0003F8_CRTC2_GEN_CNTL                      0x0003F8
+#define   S_0003F8_CRTC2_DBL_SCAN_EN(x)                (((x) & 0x1) << 0)
+#define   G_0003F8_CRTC2_DBL_SCAN_EN(x)                (((x) >> 0) & 0x1)
+#define   C_0003F8_CRTC2_DBL_SCAN_EN                   0xFFFFFFFE
+#define   S_0003F8_CRTC2_INTERLACE_EN(x)               (((x) & 0x1) << 1)
+#define   G_0003F8_CRTC2_INTERLACE_EN(x)               (((x) >> 1) & 0x1)
+#define   C_0003F8_CRTC2_INTERLACE_EN                  0xFFFFFFFD
+#define   S_0003F8_CRTC2_SYNC_TRISTATE(x)              (((x) & 0x1) << 4)
+#define   G_0003F8_CRTC2_SYNC_TRISTATE(x)              (((x) >> 4) & 0x1)
+#define   C_0003F8_CRTC2_SYNC_TRISTATE                 0xFFFFFFEF
+#define   S_0003F8_CRTC2_HSYNC_TRISTATE(x)             (((x) & 0x1) << 5)
+#define   G_0003F8_CRTC2_HSYNC_TRISTATE(x)             (((x) >> 5) & 0x1)
+#define   C_0003F8_CRTC2_HSYNC_TRISTATE                0xFFFFFFDF
+#define   S_0003F8_CRTC2_VSYNC_TRISTATE(x)             (((x) & 0x1) << 6)
+#define   G_0003F8_CRTC2_VSYNC_TRISTATE(x)             (((x) >> 6) & 0x1)
+#define   C_0003F8_CRTC2_VSYNC_TRISTATE                0xFFFFFFBF
+#define   S_0003F8_CRT2_ON(x)                          (((x) & 0x1) << 7)
+#define   G_0003F8_CRT2_ON(x)                          (((x) >> 7) & 0x1)
+#define   C_0003F8_CRT2_ON                             0xFFFFFF7F
+#define   S_0003F8_CRTC2_PIX_WIDTH(x)                  (((x) & 0xF) << 8)
+#define   G_0003F8_CRTC2_PIX_WIDTH(x)                  (((x) >> 8) & 0xF)
+#define   C_0003F8_CRTC2_PIX_WIDTH                     0xFFFFF0FF
+#define   S_0003F8_CRTC2_ICON_EN(x)                    (((x) & 0x1) << 15)
+#define   G_0003F8_CRTC2_ICON_EN(x)                    (((x) >> 15) & 0x1)
+#define   C_0003F8_CRTC2_ICON_EN                       0xFFFF7FFF
+#define   S_0003F8_CRTC2_CUR_EN(x)                     (((x) & 0x1) << 16)
+#define   G_0003F8_CRTC2_CUR_EN(x)                     (((x) >> 16) & 0x1)
+#define   C_0003F8_CRTC2_CUR_EN                        0xFFFEFFFF
+#define   S_0003F8_CRTC2_CUR_MODE(x)                   (((x) & 0x7) << 20)
+#define   G_0003F8_CRTC2_CUR_MODE(x)                   (((x) >> 20) & 0x7)
+#define   C_0003F8_CRTC2_CUR_MODE                      0xFF8FFFFF
+#define   S_0003F8_CRTC2_DISPLAY_DIS(x)                (((x) & 0x1) << 23)
+#define   G_0003F8_CRTC2_DISPLAY_DIS(x)                (((x) >> 23) & 0x1)
+#define   C_0003F8_CRTC2_DISPLAY_DIS                   0xFF7FFFFF
+#define   S_0003F8_CRTC2_EN(x)                         (((x) & 0x1) << 25)
+#define   G_0003F8_CRTC2_EN(x)                         (((x) >> 25) & 0x1)
+#define   C_0003F8_CRTC2_EN                            0xFDFFFFFF
+#define   S_0003F8_CRTC2_DISP_REQ_EN_B(x)              (((x) & 0x1) << 26)
+#define   G_0003F8_CRTC2_DISP_REQ_EN_B(x)              (((x) >> 26) & 0x1)
+#define   C_0003F8_CRTC2_DISP_REQ_EN_B                 0xFBFFFFFF
+#define   S_0003F8_CRTC2_C_SYNC_EN(x)                  (((x) & 0x1) << 27)
+#define   G_0003F8_CRTC2_C_SYNC_EN(x)                  (((x) >> 27) & 0x1)
+#define   C_0003F8_CRTC2_C_SYNC_EN                     0xF7FFFFFF
+#define   S_0003F8_CRTC2_HSYNC_DIS(x)                  (((x) & 0x1) << 28)
+#define   G_0003F8_CRTC2_HSYNC_DIS(x)                  (((x) >> 28) & 0x1)
+#define   C_0003F8_CRTC2_HSYNC_DIS                     0xEFFFFFFF
+#define   S_0003F8_CRTC2_VSYNC_DIS(x)                  (((x) & 0x1) << 29)
+#define   G_0003F8_CRTC2_VSYNC_DIS(x)                  (((x) >> 29) & 0x1)
+#define   C_0003F8_CRTC2_VSYNC_DIS                     0xDFFFFFFF
+#define R_000420_OV0_SCALE_CNTL                      0x000420
+#define   S_000420_OV0_NO_READ_BEHIND_SCAN(x)          (((x) & 0x1) << 1)
+#define   G_000420_OV0_NO_READ_BEHIND_SCAN(x)          (((x) >> 1) & 0x1)
+#define   C_000420_OV0_NO_READ_BEHIND_SCAN             0xFFFFFFFD
+#define   S_000420_OV0_HORZ_PICK_NEAREST(x)            (((x) & 0x1) << 2)
+#define   G_000420_OV0_HORZ_PICK_NEAREST(x)            (((x) >> 2) & 0x1)
+#define   C_000420_OV0_HORZ_PICK_NEAREST               0xFFFFFFFB
+#define   S_000420_OV0_VERT_PICK_NEAREST(x)            (((x) & 0x1) << 3)
+#define   G_000420_OV0_VERT_PICK_NEAREST(x)            (((x) >> 3) & 0x1)
+#define   C_000420_OV0_VERT_PICK_NEAREST               0xFFFFFFF7
+#define   S_000420_OV0_SIGNED_UV(x)                    (((x) & 0x1) << 4)
+#define   G_000420_OV0_SIGNED_UV(x)                    (((x) >> 4) & 0x1)
+#define   C_000420_OV0_SIGNED_UV                       0xFFFFFFEF
+#define   S_000420_OV0_GAMMA_SEL(x)                    (((x) & 0x7) << 5)
+#define   G_000420_OV0_GAMMA_SEL(x)                    (((x) >> 5) & 0x7)
+#define   C_000420_OV0_GAMMA_SEL                       0xFFFFFF1F
+#define   S_000420_OV0_SURFACE_FORMAT(x)               (((x) & 0xF) << 8)
+#define   G_000420_OV0_SURFACE_FORMAT(x)               (((x) >> 8) & 0xF)
+#define   C_000420_OV0_SURFACE_FORMAT                  0xFFFFF0FF
+#define   S_000420_OV0_ADAPTIVE_DEINT(x)               (((x) & 0x1) << 12)
+#define   G_000420_OV0_ADAPTIVE_DEINT(x)               (((x) >> 12) & 0x1)
+#define   C_000420_OV0_ADAPTIVE_DEINT                  0xFFFFEFFF
+#define   S_000420_OV0_CRTC_SEL(x)                     (((x) & 0x1) << 14)
+#define   G_000420_OV0_CRTC_SEL(x)                     (((x) >> 14) & 0x1)
+#define   C_000420_OV0_CRTC_SEL                        0xFFFFBFFF
+#define   S_000420_OV0_BURST_PER_PLANE(x)              (((x) & 0x7F) << 16)
+#define   G_000420_OV0_BURST_PER_PLANE(x)              (((x) >> 16) & 0x7F)
+#define   C_000420_OV0_BURST_PER_PLANE                 0xFF80FFFF
+#define   S_000420_OV0_DOUBLE_BUFFER_REGS(x)           (((x) & 0x1) << 24)
+#define   G_000420_OV0_DOUBLE_BUFFER_REGS(x)           (((x) >> 24) & 0x1)
+#define   C_000420_OV0_DOUBLE_BUFFER_REGS              0xFEFFFFFF
+#define   S_000420_OV0_BANDWIDTH(x)                    (((x) & 0x1) << 26)
+#define   G_000420_OV0_BANDWIDTH(x)                    (((x) >> 26) & 0x1)
+#define   C_000420_OV0_BANDWIDTH                       0xFBFFFFFF
+#define   S_000420_OV0_LIN_TRANS_BYPASS(x)             (((x) & 0x1) << 28)
+#define   G_000420_OV0_LIN_TRANS_BYPASS(x)             (((x) >> 28) & 0x1)
+#define   C_000420_OV0_LIN_TRANS_BYPASS                0xEFFFFFFF
+#define   S_000420_OV0_INT_EMU(x)                      (((x) & 0x1) << 29)
+#define   G_000420_OV0_INT_EMU(x)                      (((x) >> 29) & 0x1)
+#define   C_000420_OV0_INT_EMU                         0xDFFFFFFF
+#define   S_000420_OV0_OVERLAY_EN(x)                   (((x) & 0x1) << 30)
+#define   G_000420_OV0_OVERLAY_EN(x)                   (((x) >> 30) & 0x1)
+#define   C_000420_OV0_OVERLAY_EN                      0xBFFFFFFF
+#define   S_000420_OV0_SOFT_RESET(x)                   (((x) & 0x1) << 31)
+#define   G_000420_OV0_SOFT_RESET(x)                   (((x) >> 31) & 0x1)
+#define   C_000420_OV0_SOFT_RESET                      0x7FFFFFFF
+#define R_00070C_CP_RB_RPTR_ADDR                     0x00070C
+#define   S_00070C_RB_RPTR_SWAP(x)                     (((x) & 0x3) << 0)
+#define   G_00070C_RB_RPTR_SWAP(x)                     (((x) >> 0) & 0x3)
+#define   C_00070C_RB_RPTR_SWAP                        0xFFFFFFFC
+#define   S_00070C_RB_RPTR_ADDR(x)                     (((x) & 0x3FFFFFFF) << 2)
+#define   G_00070C_RB_RPTR_ADDR(x)                     (((x) >> 2) & 0x3FFFFFFF)
+#define   C_00070C_RB_RPTR_ADDR                        0x00000003
+#define R_000740_CP_CSQ_CNTL                         0x000740
+#define   S_000740_CSQ_CNT_PRIMARY(x)                  (((x) & 0xFF) << 0)
+#define   G_000740_CSQ_CNT_PRIMARY(x)                  (((x) >> 0) & 0xFF)
+#define   C_000740_CSQ_CNT_PRIMARY                     0xFFFFFF00
+#define   S_000740_CSQ_CNT_INDIRECT(x)                 (((x) & 0xFF) << 8)
+#define   G_000740_CSQ_CNT_INDIRECT(x)                 (((x) >> 8) & 0xFF)
+#define   C_000740_CSQ_CNT_INDIRECT                    0xFFFF00FF
+#define   S_000740_CSQ_MODE(x)                         (((x) & 0xF) << 28)
+#define   G_000740_CSQ_MODE(x)                         (((x) >> 28) & 0xF)
+#define   C_000740_CSQ_MODE                            0x0FFFFFFF
+#define R_000770_SCRATCH_UMSK                        0x000770
+#define   S_000770_SCRATCH_UMSK(x)                     (((x) & 0x3F) << 0)
+#define   G_000770_SCRATCH_UMSK(x)                     (((x) >> 0) & 0x3F)
+#define   C_000770_SCRATCH_UMSK                        0xFFFFFFC0
+#define   S_000770_SCRATCH_SWAP(x)                     (((x) & 0x3) << 16)
+#define   G_000770_SCRATCH_SWAP(x)                     (((x) >> 16) & 0x3)
+#define   C_000770_SCRATCH_SWAP                        0xFFFCFFFF
+#define R_000774_SCRATCH_ADDR                        0x000774
+#define   S_000774_SCRATCH_ADDR(x)                     (((x) & 0x7FFFFFF) << 5)
+#define   G_000774_SCRATCH_ADDR(x)                     (((x) >> 5) & 0x7FFFFFF)
+#define   C_000774_SCRATCH_ADDR                        0x0000001F
 #define R_000E40_RBBM_STATUS                         0x000E40
 #define   S_000E40_CMDFIFO_AVAIL(x)                    (((x) & 0x7F) << 0)
 #define   G_000E40_CMDFIFO_AVAIL(x)                    (((x) >> 0) & 0x7F)
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 9c17b78..92f9cb7 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -1241,11 +1241,12 @@ static int r300_packet3_check(struct radeon_cs_parser *p,
 int r300_cs_parse(struct radeon_cs_parser *p)
 {
 	struct radeon_cs_packet pkt;
-	struct r100_cs_track track;
+	struct r100_cs_track *track;
 	int r;
 
-	r100_cs_track_clear(p->rdev, &track);
-	p->track = &track;
+	track = kzalloc(sizeof(*track), GFP_KERNEL);
+	r100_cs_track_clear(p->rdev, track);
+	p->track = track;
 	do {
 		r = r100_cs_packet_parse(p, &pkt, p->idx);
 		if (r) {
@@ -1275,9 +1276,50 @@ int r300_cs_parse(struct radeon_cs_parser *p)
 	return 0;
 }
 
-int r300_init(struct radeon_device *rdev)
+void r300_set_reg_safe(struct radeon_device *rdev)
 {
 	rdev->config.r300.reg_safe_bm = r300_reg_safe_bm;
 	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(r300_reg_safe_bm);
+}
+
+int r300_init(struct radeon_device *rdev)
+{
+	r300_set_reg_safe(rdev);
 	return 0;
 }
+
+void r300_mc_program(struct radeon_device *rdev)
+{
+	struct r100_mc_save save;
+	int r;
+
+	r = r100_debugfs_mc_info_init(rdev);
+	if (r) {
+		dev_err(rdev->dev, "Failed to create r100_mc debugfs file.\n");
+	}
+
+	/* Stops all mc clients */
+	r100_mc_stop(rdev, &save);
+	/* Shutdown PCI/PCIE GART */
+	radeon_gart_disable(rdev);
+	if (rdev->flags & RADEON_IS_AGP) {
+		WREG32(R_00014C_MC_AGP_LOCATION,
+			S_00014C_MC_AGP_START(rdev->mc.gtt_start >> 16) |
+			S_00014C_MC_AGP_TOP(rdev->mc.gtt_end >> 16));
+		WREG32(R_000170_AGP_BASE, lower_32_bits(rdev->mc.agp_base));
+		WREG32(R_00015C_AGP_BASE_2,
+			upper_32_bits(rdev->mc.agp_base) & 0xff);
+	} else {
+		WREG32(R_00014C_MC_AGP_LOCATION, 0x0FFFFFFF);
+		WREG32(R_000170_AGP_BASE, 0);
+		WREG32(R_00015C_AGP_BASE_2, 0);
+	}
+	/* Wait for mc idle */
+	if (r300_mc_wait_for_idle(rdev))
+		DRM_INFO("Failed to wait MC idle before programming MC.\n");
+	/* Program MC, should be a 32bits limited address space */
+	WREG32(R_000148_MC_FB_LOCATION,
+		S_000148_MC_FB_START(rdev->mc.vram_start >> 16) |
+		S_000148_MC_FB_TOP(rdev->mc.vram_end >> 16));
+	r100_mc_resume(rdev, &save);
+}
diff --git a/drivers/gpu/drm/radeon/r300d.h b/drivers/gpu/drm/radeon/r300d.h
index 63ec076..d4fa3eb 100644
--- a/drivers/gpu/drm/radeon/r300d.h
+++ b/drivers/gpu/drm/radeon/r300d.h
@@ -73,4 +73,29 @@
 #define CP_PACKET0_GET_ONE_REG_WR(h) (((h) >> 15) & 1)
 #define CP_PACKET3_GET_OPCODE(h) (((h) >> 8) & 0xFF)
 
+/* Registers */
+#define R_000148_MC_FB_LOCATION                      0x000148
+#define   S_000148_MC_FB_START(x)                      (((x) & 0xFFFF) << 0)
+#define   G_000148_MC_FB_START(x)                      (((x) >> 0) & 0xFFFF)
+#define   C_000148_MC_FB_START                         0xFFFF0000
+#define   S_000148_MC_FB_TOP(x)                        (((x) & 0xFFFF) << 16)
+#define   G_000148_MC_FB_TOP(x)                        (((x) >> 16) & 0xFFFF)
+#define   C_000148_MC_FB_TOP                           0x0000FFFF
+#define R_00014C_MC_AGP_LOCATION                     0x00014C
+#define   S_00014C_MC_AGP_START(x)                     (((x) & 0xFFFF) << 0)
+#define   G_00014C_MC_AGP_START(x)                     (((x) >> 0) & 0xFFFF)
+#define   C_00014C_MC_AGP_START                        0xFFFF0000
+#define   S_00014C_MC_AGP_TOP(x)                       (((x) & 0xFFFF) << 16)
+#define   G_00014C_MC_AGP_TOP(x)                       (((x) >> 16) & 0xFFFF)
+#define   C_00014C_MC_AGP_TOP                          0x0000FFFF
+#define R_00015C_AGP_BASE_2                          0x00015C
+#define   S_00015C_AGP_BASE_ADDR_2(x)                  (((x) & 0xF) << 0)
+#define   G_00015C_AGP_BASE_ADDR_2(x)                  (((x) >> 0) & 0xF)
+#define   C_00015C_AGP_BASE_ADDR_2                     0xFFFFFFF0
+#define R_000170_AGP_BASE                            0x000170
+#define   S_000170_AGP_BASE_ADDR(x)                    (((x) & 0xFFFFFFFF) << 0)
+#define   G_000170_AGP_BASE_ADDR(x)                    (((x) >> 0) & 0xFFFFFFFF)
+#define   C_000170_AGP_BASE_ADDR                       0x00000000
+
+
 #endif
diff --git a/drivers/gpu/drm/radeon/r420.c b/drivers/gpu/drm/radeon/r420.c
index 551d699..e57b9ba 100644
--- a/drivers/gpu/drm/radeon/r420.c
+++ b/drivers/gpu/drm/radeon/r420.c
@@ -29,48 +29,13 @@
 #include "drmP.h"
 #include "radeon_reg.h"
 #include "radeon.h"
+#include "atom.h"
 #include "r420d.h"
 
-/* r420,r423,rv410 depends on : */
-void r100_pci_gart_disable(struct radeon_device *rdev);
-void r100_hdp_reset(struct radeon_device *rdev);
-void r100_mc_setup(struct radeon_device *rdev);
-int r100_gui_wait_for_idle(struct radeon_device *rdev);
-void r100_mc_disable_clients(struct radeon_device *rdev);
-void r300_vram_info(struct radeon_device *rdev);
-int r300_mc_wait_for_idle(struct radeon_device *rdev);
-int rv370_pcie_gart_enable(struct radeon_device *rdev);
-void rv370_pcie_gart_disable(struct radeon_device *rdev);
-
-/* This files gather functions specifics to :
- * r420,r423,rv410
- *
- * Some of these functions might be used by newer ASICs.
- */
-void r420_gpu_init(struct radeon_device *rdev);
-int r420_debugfs_pipes_info_init(struct radeon_device *rdev);
-
-
-/*
- * MC
- */
 int r420_mc_init(struct radeon_device *rdev)
 {
 	int r;
 
-	if (r100_debugfs_rbbm_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
-	}
-	if (r420_debugfs_pipes_info_init(rdev)) {
-		DRM_ERROR("Failed to register debugfs file for pipes !\n");
-	}
-
-	r420_gpu_init(rdev);
-	r100_pci_gart_disable(rdev);
-	if (rdev->flags & RADEON_IS_PCIE) {
-		rv370_pcie_gart_disable(rdev);
-	}
-
 	/* Setup GPU memory space */
 	rdev->mc.vram_location = 0xFFFFFFFFUL;
 	rdev->mc.gtt_location = 0xFFFFFFFFUL;
@@ -88,38 +53,9 @@ int r420_mc_init(struct radeon_device *rdev)
 	if (r) {
 		return r;
 	}
-
-	/* Program GPU memory space */
-	r100_mc_disable_clients(rdev);
-	if (r300_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
-	}
-	r100_mc_setup(rdev);
 	return 0;
 }
 
-void r420_mc_fini(struct radeon_device *rdev)
-{
-	if (rdev->flags & RADEON_IS_PCIE) {
-		rv370_pcie_gart_disable(rdev);
-		radeon_gart_table_vram_free(rdev);
-	} else {
-		r100_pci_gart_disable(rdev);
-		radeon_gart_table_ram_free(rdev);
-	}
-	radeon_gart_fini(rdev);
-}
-
-
-/*
- * Global GPU functions
- */
-void r420_errata(struct radeon_device *rdev)
-{
-	rdev->pll_errata = 0;
-}
-
 void r420_pipes_init(struct radeon_device *rdev)
 {
 	unsigned tmp;
@@ -185,25 +121,216 @@ void r420_pipes_init(struct radeon_device *rdev)
 		 rdev->num_gb_pipes, rdev->num_z_pipes);
 }
 
-void r420_gpu_init(struct radeon_device *rdev)
+u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg)
 {
-	r100_hdp_reset(rdev);
+	u32 r;
+
+	WREG32(R_0001F8_MC_IND_INDEX, S_0001F8_MC_IND_ADDR(reg));
+	r = RREG32(R_0001FC_MC_IND_DATA);
+	return r;
+}
+
+void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v)
+{
+	WREG32(R_0001F8_MC_IND_INDEX, S_0001F8_MC_IND_ADDR(reg) |
+		S_0001F8_MC_IND_WR_EN(1));
+	WREG32(R_0001FC_MC_IND_DATA, v);
+}
+
+static void r420_debugfs(struct radeon_device *rdev)
+{
+	if (r100_debugfs_rbbm_init(rdev)) {
+		DRM_ERROR("Failed to register debugfs file for RBBM !\n");
+	}
+	if (r420_debugfs_pipes_info_init(rdev)) {
+		DRM_ERROR("Failed to register debugfs file for pipes !\n");
+	}
+}
+
+static void r420_clock_resume(struct radeon_device *rdev)
+{
+	u32 sclk_cntl;
+	sclk_cntl = RREG32_PLL(R_00000D_SCLK_CNTL);
+	sclk_cntl |= S_00000D_FORCE_CP(1) | S_00000D_FORCE_VIP(1);
+	if (rdev->family == CHIP_R420)
+		sclk_cntl |= S_00000D_FORCE_PX(1) | S_00000D_FORCE_TX(1);
+	WREG32_PLL(R_00000D_SCLK_CNTL, sclk_cntl);
+}
+
+int r420_resume(struct radeon_device *rdev)
+{
+	int r;
+
+	/* Resume clock before doing reset */
+	r420_clock_resume(rdev);
+	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
+	if (radeon_gpu_reset(rdev)) {
+		dev_warn(rdev->dev, "GPU reset failed ! (0xE40=0x%08X, 0x7C0=0x%08X)\n",
+			RREG32(R_000E40_RBBM_STATUS),
+			RREG32(R_0007C0_CP_STAT));
+	}
+	/* check if cards are posted or not */
+	if (rdev->is_atom_bios) {
+		atom_asic_init(rdev->mode_info.atom_context);
+	} else {
+		radeon_combios_asic_init(rdev->ddev);
+	}
+	/* Resume clock after posting */
+	r420_clock_resume(rdev);
+	r300_mc_program(rdev);
+	/* Initialize GART (initialize after TTM so we can allocate
+	 * memory through TTM but finalize after TTM) */
+	r = radeon_gart_enable(rdev);
+	if (r) {
+		dev_err(rdev->dev, "failled initializing GART (%d).\n", r);
+		return r;
+	}
 	r420_pipes_init(rdev);
-	if (r300_mc_wait_for_idle(rdev)) {
-		printk(KERN_WARNING "Failed to wait MC idle while "
-		       "programming pipes. Bad things might happen.\n");
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
+	if (r) {
+		dev_err(rdev->dev, "failled initializing WB (%d).\n", r);
 	}
+	r = r100_ib_init(rdev);
+	if (r) {
+		dev_err(rdev->dev, "failled initializing IB (%d).\n", r);
+		return r;
+	}
+	return 0;
 }
 
+int r420_suspend(struct radeon_device *rdev)
+{
+	r100_cp_disable(rdev);
+	r100_wb_disable(rdev);
+	r100_irq_disable(rdev);
+	radeon_gart_disable(rdev);
+	return 0;
+}
 
-/*
- * r420,r423,rv410 VRAM info
- */
-void r420_vram_info(struct radeon_device *rdev)
+void r420_fini(struct radeon_device *rdev)
 {
-	r300_vram_info(rdev);
+	r100_cp_fini(rdev);
+	r100_wb_fini(rdev);
+	r100_ib_fini(rdev);
+	radeon_gem_fini(rdev);
+	if (rdev->flags & RADEON_IS_PCIE) {
+		rv370_pcie_gart_disable(rdev);
+		radeon_gart_table_vram_free(rdev);
+	} else {
+		r100_pci_gart_disable(rdev);
+		radeon_gart_table_ram_free(rdev);
+	}
+	radeon_gart_fini(rdev);
+	radeon_agp_fini(rdev);
+	radeon_irq_kms_fini(rdev);
+	radeon_fence_driver_fini(rdev);
+	radeon_object_fini(rdev);
+	if (rdev->is_atom_bios) {
+		radeon_atombios_fini(rdev);
+	} else {
+		radeon_combios_fini(rdev);
+	}
+	kfree(rdev->bios);
+	rdev->bios = NULL;
 }
 
+int r420_init(struct radeon_device *rdev)
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
+		if (r) {
+			return r;
+		}
+	} else {
+		r = radeon_combios_init(rdev);
+		if (r) {
+			return r;
+		}
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
+		if (rdev->is_atom_bios) {
+			atom_asic_init(rdev->mode_info.atom_context);
+		} else {
+			radeon_combios_asic_init(rdev->ddev);
+		}
+	}
+	/* Initialize clocks */
+	radeon_get_clock_info(rdev->ddev);
+	/* Get vram informations */
+	r300_vram_info(rdev);
+	/* Initialize memory controller (also test AGP) */
+	r = r420_mc_init(rdev);
+	if (r) {
+		return r;
+	}
+	r420_debugfs(rdev);
+	/* Fence driver */
+	r = radeon_fence_driver_init(rdev);
+	if (r) {
+		return r;
+	}
+	r = radeon_irq_kms_init(rdev);
+	if (r) {
+		return r;
+	}
+	/* Memory manager */
+	r = radeon_object_init(rdev);
+	if (r) {
+		return r;
+	}
+	r300_set_reg_safe(rdev);
+	r = r420_resume(rdev);
+	if (r) {
+		/* Somethings want wront with the accel init stop accel */
+		dev_err(rdev->dev, "Disabling GPU acceleration\n");
+		r420_suspend(rdev);
+		r100_cp_fini(rdev);
+		r100_wb_fini(rdev);
+		r100_ib_fini(rdev);
+		if (rdev->flags & RADEON_IS_PCIE) {
+			rv370_pcie_gart_disable(rdev);
+			radeon_gart_table_vram_free(rdev);
+		} else {
+			r100_pci_gart_disable(rdev);
+			radeon_gart_table_ram_free(rdev);
+		}
+		radeon_gart_fini(rdev);
+		radeon_agp_fini(rdev);
+		radeon_irq_kms_fini(rdev);
+	}
+	return 0;
+}
 
 /*
  * Debugfs info
@@ -238,19 +365,3 @@ int r420_debugfs_pipes_info_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
-
-u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg)
-{
-	u32 r;
-
-	WREG32(R_0001F8_MC_IND_INDEX, S_0001F8_MC_IND_ADDR(reg));
-	r = RREG32(R_0001FC_MC_IND_DATA);
-	return r;
-}
-
-void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v)
-{
-	WREG32(R_0001F8_MC_IND_INDEX, S_0001F8_MC_IND_ADDR(reg) |
-		S_0001F8_MC_IND_WR_EN(1));
-	WREG32(R_0001FC_MC_IND_DATA, v);
-}
diff --git a/drivers/gpu/drm/radeon/r420d.h b/drivers/gpu/drm/radeon/r420d.h
index 8b946c1..a48a7db 100644
--- a/drivers/gpu/drm/radeon/r420d.h
+++ b/drivers/gpu/drm/radeon/r420d.h
@@ -39,5 +39,211 @@
 #define   S_0001FC_MC_IND_DATA(x)                      (((x) & 0xFFFFFFFF) << 0)
 #define   G_0001FC_MC_IND_DATA(x)                      (((x) >> 0) & 0xFFFFFFFF)
 #define   C_0001FC_MC_IND_DATA                         0x00000000
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
+/* CLK registers */
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
+#define   S_00000D_FORCE_PX(x)                         (((x) & 0x1) << 26)
+#define   G_00000D_FORCE_PX(x)                         (((x) >> 26) & 0x1)
+#define   C_00000D_FORCE_PX                            0xFBFFFFFF
+#define   S_00000D_FORCE_TX(x)                         (((x) & 0x1) << 27)
+#define   G_00000D_FORCE_TX(x)                         (((x) >> 27) & 0x1)
+#define   C_00000D_FORCE_TX                            0xF7FFFFFF
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
 
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 23ede0e..e314756 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -690,6 +690,7 @@ typedef uint32_t (*radeon_rreg_t)(struct radeon_device*, uint32_t);
 typedef void (*radeon_wreg_t)(struct radeon_device*, uint32_t, uint32_t);
 
 struct radeon_device {
+	struct device			*dev;
 	struct drm_device		*ddev;
 	struct pci_dev			*pdev;
 	/* ASIC */
@@ -936,16 +937,45 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 /* Common functions */
 int radeon_modeset_init(struct radeon_device *rdev);
 void radeon_modeset_fini(struct radeon_device *rdev);
+extern bool radeon_card_posted(struct radeon_device *rdev);
 
 /* r100,rv100,rs100,rv200,rs200,r200,rv250,rs300,rv280 */
-void r100_cp_disable(struct radeon_device *rdev);
+struct r100_mc_save {
+	u32	GENMO_WT;
+	u32	CRTC_EXT_CNTL;
+	u32	CRTC_GEN_CNTL;
+	u32	CRTC2_GEN_CNTL;
+	u32	CUR_OFFSET;
+	u32	CUR2_OFFSET;
+};
+extern void r100_cp_disable(struct radeon_device *rdev);
+extern int r100_cp_init(struct radeon_device *rdev, unsigned ring_size);
+extern void r100_cp_fini(struct radeon_device *rdev);
 void r100_pci_gart_tlb_flush(struct radeon_device *rdev);
 int r100_pci_gart_enable(struct radeon_device *rdev);
 void r100_pci_gart_disable(struct radeon_device *rdev);
 int r100_pci_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
+extern int r100_debugfs_mc_info_init(struct radeon_device *rdev);
+extern int r100_gui_wait_for_idle(struct radeon_device *rdev);
+extern void r100_ib_fini(struct radeon_device *rdev);
+extern int r100_ib_init(struct radeon_device *rdev);
+extern void r100_irq_disable(struct radeon_device *rdev);
+extern int r100_irq_set(struct radeon_device *rdev);
+extern void r100_mc_stop(struct radeon_device *rdev, struct r100_mc_save *save);
+extern void r100_mc_resume(struct radeon_device *rdev, struct r100_mc_save *save);
+extern void r100_wb_disable(struct radeon_device *rdev);
+extern void r100_wb_fini(struct radeon_device *rdev);
+extern int r100_wb_init(struct radeon_device *rdev);
+
+/* r300,r350,rv350,rv370,rv380 */
+extern void r300_set_reg_safe(struct radeon_device *rdev);
+extern void r300_mc_program(struct radeon_device *rdev);
+extern void r300_vram_info(struct radeon_device *rdev);
+extern void rv370_pcie_gart_disable(struct radeon_device *rdev);
 
 /* r420,r423,rv410 */
 u32 r420_mc_rreg(struct radeon_device *rdev, u32 reg);
 void r420_mc_wreg(struct radeon_device *rdev, u32 reg, u32 v);
+extern int r420_debugfs_pipes_info_init(struct radeon_device *rdev);
 
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index f9c8f9a..8f27be3 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -189,31 +189,34 @@ static struct radeon_asic r300_asic = {
 /*
  * r420,r423,rv410
  */
-void r420_errata(struct radeon_device *rdev);
-void r420_vram_info(struct radeon_device *rdev);
-int r420_mc_init(struct radeon_device *rdev);
-void r420_mc_fini(struct radeon_device *rdev);
+extern int r420_init(struct radeon_device *rdev);
+extern void r420_fini(struct radeon_device *rdev);
+extern int r420_suspend(struct radeon_device *rdev);
+extern int r420_resume(struct radeon_device *rdev);
 static struct radeon_asic r420_asic = {
-	.init = &r300_init,
-	.errata = &r420_errata,
-	.vram_info = &r420_vram_info,
+	.init = &r420_init,
+	.fini = &r420_fini,
+	.suspend = &r420_suspend,
+	.resume = &r420_resume,
+	.errata = NULL,
+	.vram_info = NULL,
 	.gpu_reset = &r300_gpu_reset,
-	.mc_init = &r420_mc_init,
-	.mc_fini = &r420_mc_fini,
-	.wb_init = &r100_wb_init,
-	.wb_fini = &r100_wb_fini,
+	.mc_init = NULL,
+	.mc_fini = NULL,
+	.wb_init = NULL,
+	.wb_fini = NULL,
 	.gart_enable = &r300_gart_enable,
 	.gart_disable = &rv370_pcie_gart_disable,
 	.gart_tlb_flush = &rv370_pcie_gart_tlb_flush,
 	.gart_set_page = &rv370_pcie_gart_set_page,
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
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 07ef8b6..ece097c 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -156,6 +156,10 @@ int radeon_mc_setup(struct radeon_device *rdev)
 		tmp = (tmp + rdev->mc.gtt_size - 1) & ~(rdev->mc.gtt_size - 1);
 		rdev->mc.gtt_location = tmp;
 	}
+	rdev->mc.vram_start = rdev->mc.vram_location;
+	rdev->mc.vram_end = rdev->mc.vram_location + rdev->mc.mc_vram_size - 1;
+	rdev->mc.gtt_start = rdev->mc.gtt_location;
+	rdev->mc.gtt_end = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
 	DRM_INFO("radeon: VRAM %uM\n", (unsigned)(rdev->mc.mc_vram_size >> 20));
 	DRM_INFO("radeon: VRAM from 0x%08X to 0x%08X\n",
 		 (unsigned)rdev->mc.vram_location,
@@ -171,7 +175,7 @@ int radeon_mc_setup(struct radeon_device *rdev)
 /*
  * GPU helpers function.
  */
-static bool radeon_card_posted(struct radeon_device *rdev)
+bool radeon_card_posted(struct radeon_device *rdev)
 {
 	uint32_t reg;
 
@@ -483,6 +487,7 @@ int radeon_device_init(struct radeon_device *rdev,
 
 	DRM_INFO("radeon: Initializing kernel modesetting.\n");
 	rdev->shutdown = false;
+	rdev->dev = &pdev->dev;
 	rdev->ddev = ddev;
 	rdev->pdev = pdev;
 	rdev->flags = flags;
@@ -497,6 +502,7 @@ int radeon_device_init(struct radeon_device *rdev,
 	mutex_init(&rdev->ib_pool.mutex);
 	mutex_init(&rdev->cp.mutex);
 	rwlock_init(&rdev->fence_drv.lock);
+	INIT_LIST_HEAD(&rdev->gem.objects);
 
 	if (radeon_agpmode == -1) {
 		rdev->flags &= ~RADEON_IS_AGP;
@@ -728,15 +734,14 @@ int radeon_suspend_kms(struct drm_device *dev, pm_message_t state)
 	if (!rdev->new_init_path) {
 		radeon_cp_disable(rdev);
 		radeon_gart_disable(rdev);
+		rdev->irq.sw_int = false;
+		radeon_irq_set(rdev);
 	} else {
 		radeon_suspend(rdev);
 	}
 	/* evict remaining vram memory */
 	radeon_object_evict_vram(rdev);
 
-	rdev->irq.sw_int = false;
-	radeon_irq_set(rdev);
-
 	pci_save_state(dev->pdev);
 	if (state.event == PM_EVENT_SUSPEND) {
 		/* Shut down the device */
@@ -763,10 +768,10 @@ int radeon_resume_kms(struct drm_device *dev)
 	}
 	pci_set_master(dev->pdev);
 	/* Reset gpu before posting otherwise ATOM will enter infinite loop */
-	if (radeon_gpu_reset(rdev)) {
-		/* FIXME: what do we want to do here ? */
-	}
 	if (!rdev->new_init_path) {
+		if (radeon_gpu_reset(rdev)) {
+			/* FIXME: what do we want to do here ? */
+		}
 		/* post card */
 		if (rdev->is_atom_bios) {
 			atom_asic_init(rdev->mode_info.atom_context);
diff --git a/drivers/gpu/drm/radeon/radeon_ring.c b/drivers/gpu/drm/radeon/radeon_ring.c
index aa9837a..168a555 100644
--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -151,6 +151,8 @@ int radeon_ib_pool_init(struct radeon_device *rdev)
 	int i;
 	int r = 0;
 
+	if (rdev->ib_pool.robj)
+		return 0;
 	/* Allocate 1M object buffer */
 	INIT_LIST_HEAD(&rdev->ib_pool.scheduled_ibs);
 	r = radeon_object_create(rdev, NULL,  RADEON_IB_POOL_SIZE*64*1024,
-- 
1.6.4.2

