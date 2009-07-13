Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbZGMTEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbZGMTEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 15:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZGMTEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 15:04:22 -0400
Received: from nox.protox.org ([88.191.38.29]:42907 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbZGMTER (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 15:04:17 -0400
From: Jerome Glisse <jglisse@redhat.com>
To: airlied@gmail.com
Cc: dri-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: [PATCH] radeon: fix bandwidth computation on avivo hardware
Date: Mon, 13 Jul 2009 21:04:08 +0200
Message-Id: <1247511848-5956-1-git-send-email-jglisse@redhat.com>
X-Mailer: git-send-email 1.6.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix bandwidth computation and crtc priority in memory controller
so that crtc memory request are fullfill in time to avoid display
artifact.

Signed-off-by: Jerome Glisse <jglisse@redhat.com>
---
 drivers/gpu/drm/radeon/atombios_crtc.c          |  276 ++++-----
 drivers/gpu/drm/radeon/r100.c                   |  483 ++++++++++++++
 drivers/gpu/drm/radeon/r300.c                   |    1 +
 drivers/gpu/drm/radeon/r520.c                   |   14 +
 drivers/gpu/drm/radeon/radeon.h                 |   39 ++-
 drivers/gpu/drm/radeon/radeon_asic.h            |   13 +
 drivers/gpu/drm/radeon/radeon_device.c          |   10 +-
 drivers/gpu/drm/radeon/radeon_display.c         |   68 ++-
 drivers/gpu/drm/radeon/radeon_encoders.c        |  369 +-----------
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c     |  661 ++++++--------------
 drivers/gpu/drm/radeon/radeon_legacy_encoders.c |  188 +------
 drivers/gpu/drm/radeon/radeon_mode.h            |   48 +-
 drivers/gpu/drm/radeon/radeon_share.h           |   39 ++
 drivers/gpu/drm/radeon/rs400.c                  |    1 +
 drivers/gpu/drm/radeon/rs600.c                  |    5 +
 drivers/gpu/drm/radeon/rs690.c                  |  472 ++++++++++++++
 drivers/gpu/drm/radeon/rs690r.h                 |   99 +++
 drivers/gpu/drm/radeon/rv515.c                  |  774 +++++++++++++++++++----
 drivers/gpu/drm/radeon/rv515r.h                 |  170 +++++
 19 files changed, 2377 insertions(+), 1353 deletions(-)
 create mode 100644 drivers/gpu/drm/radeon/radeon_share.h
 create mode 100644 drivers/gpu/drm/radeon/rs690r.h
 create mode 100644 drivers/gpu/drm/radeon/rv515r.h

diff --git a/drivers/gpu/drm/radeon/atombios_crtc.c b/drivers/gpu/drm/radeon/atombios_crtc.c
index c0080cc..459fb67 100644
--- a/drivers/gpu/drm/radeon/atombios_crtc.c
+++ b/drivers/gpu/drm/radeon/atombios_crtc.c
@@ -31,6 +31,132 @@
 #include "atom.h"
 #include "atom-bits.h"
 
+static void atombios_overscan_setup(struct drm_crtc *crtc,
+				    struct drm_display_mode *mode,
+				    struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = crtc->dev;
+	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	SET_CRTC_OVERSCAN_PS_ALLOCATION args;
+	int index = GetIndexIntoMasterTable(COMMAND, SetCRTC_OverScan);
+	int a1, a2;
+
+	memset(&args, 0, sizeof(args));
+
+	args.usOverscanRight = 0;
+	args.usOverscanLeft = 0;
+	args.usOverscanBottom = 0;
+	args.usOverscanTop = 0;
+	args.ucCRTC = radeon_crtc->crtc_id;
+
+	switch (radeon_crtc->rmx_type) {
+	case RMX_CENTER:
+		args.usOverscanTop = (adjusted_mode->crtc_vdisplay - mode->crtc_vdisplay) / 2;
+		args.usOverscanBottom = (adjusted_mode->crtc_vdisplay - mode->crtc_vdisplay) / 2;
+		args.usOverscanLeft = (adjusted_mode->crtc_hdisplay - mode->crtc_hdisplay) / 2;
+		args.usOverscanRight = (adjusted_mode->crtc_hdisplay - mode->crtc_hdisplay) / 2;
+		atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+		break;
+	case RMX_ASPECT:
+		a1 = mode->crtc_vdisplay * adjusted_mode->crtc_hdisplay;
+		a2 = adjusted_mode->crtc_vdisplay * mode->crtc_hdisplay;
+
+		if (a1 > a2) {
+			args.usOverscanLeft = (adjusted_mode->crtc_hdisplay - (a2 / mode->crtc_vdisplay)) / 2;
+			args.usOverscanRight = (adjusted_mode->crtc_hdisplay - (a2 / mode->crtc_vdisplay)) / 2;
+		} else if (a2 > a1) {
+			args.usOverscanLeft = (adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2;
+			args.usOverscanRight = (adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2;
+		}
+		atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+		break;
+	case RMX_FULL:
+	default:
+		args.usOverscanRight = 0;
+		args.usOverscanLeft = 0;
+		args.usOverscanBottom = 0;
+		args.usOverscanTop = 0;
+		atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+		break;
+	}
+}
+
+static void atombios_scaler_setup(struct drm_crtc *crtc)
+{
+	struct drm_device *dev = crtc->dev;
+	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	ENABLE_SCALER_PS_ALLOCATION args;
+	int index = GetIndexIntoMasterTable(COMMAND, EnableScaler);
+	/* fixme - fill in enc_priv for atom dac */
+	enum radeon_tv_std tv_std = TV_STD_NTSC;
+
+	if (!ASIC_IS_AVIVO(rdev) && radeon_crtc->crtc_id)
+		return;
+
+	memset(&args, 0, sizeof(args));
+
+	args.ucScaler = radeon_crtc->crtc_id;
+
+	if (radeon_crtc->devices & (ATOM_DEVICE_TV_SUPPORT)) {
+		switch (tv_std) {
+		case TV_STD_NTSC:
+		default:
+			args.ucTVStandard = ATOM_TV_NTSC;
+			break;
+		case TV_STD_PAL:
+			args.ucTVStandard = ATOM_TV_PAL;
+			break;
+		case TV_STD_PAL_M:
+			args.ucTVStandard = ATOM_TV_PALM;
+			break;
+		case TV_STD_PAL_60:
+			args.ucTVStandard = ATOM_TV_PAL60;
+			break;
+		case TV_STD_NTSC_J:
+			args.ucTVStandard = ATOM_TV_NTSCJ;
+			break;
+		case TV_STD_SCART_PAL:
+			args.ucTVStandard = ATOM_TV_PAL; /* ??? */
+			break;
+		case TV_STD_SECAM:
+			args.ucTVStandard = ATOM_TV_SECAM;
+			break;
+		case TV_STD_PAL_CN:
+			args.ucTVStandard = ATOM_TV_PALCN;
+			break;
+		}
+		args.ucEnable = SCALER_ENABLE_MULTITAP_MODE;
+	} else if (radeon_crtc->devices & (ATOM_DEVICE_CV_SUPPORT)) {
+		args.ucTVStandard = ATOM_TV_CV;
+		args.ucEnable = SCALER_ENABLE_MULTITAP_MODE;
+	} else {
+		switch (radeon_crtc->rmx_type) {
+		case RMX_FULL:
+			args.ucEnable = ATOM_SCALER_EXPANSION;
+			break;
+		case RMX_CENTER:
+			args.ucEnable = ATOM_SCALER_CENTER;
+			break;
+		case RMX_ASPECT:
+			args.ucEnable = ATOM_SCALER_EXPANSION;
+			break;
+		default:
+			if (ASIC_IS_AVIVO(rdev))
+				args.ucEnable = ATOM_SCALER_DISABLE;
+			else
+				args.ucEnable = ATOM_SCALER_CENTER;
+			break;
+		}
+	}
+	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
+	if (radeon_crtc->devices & (ATOM_DEVICE_CV_SUPPORT | ATOM_DEVICE_TV_SUPPORT)
+	    && rdev->family >= CHIP_RV515 && rdev->family <= CHIP_RV570) {
+		atom_rv515_force_tv_scaler(rdev);
+	}
+}
+
 static void atombios_lock_crtc(struct drm_crtc *crtc, int lock)
 {
 	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
@@ -509,6 +635,9 @@ int atombios_crtc_mode_set(struct drm_crtc *crtc,
 		radeon_crtc_set_base(crtc, x, y, old_fb);
 		radeon_legacy_atom_set_surface(crtc);
 	}
+	atombios_overscan_setup(crtc, mode, adjusted_mode);
+	atombios_scaler_setup(crtc);
+	radeon_bandwidth_update(rdev);
 	return 0;
 }
 
@@ -516,6 +645,8 @@ static bool atombios_crtc_mode_fixup(struct drm_crtc *crtc,
 				     struct drm_display_mode *mode,
 				     struct drm_display_mode *adjusted_mode)
 {
+	if (!radeon_crtc_scaling_mode_fixup(crtc, mode, adjusted_mode))
+		return false;
 	return true;
 }
 
@@ -548,148 +679,3 @@ void radeon_atombios_init_crtc(struct drm_device *dev,
 		    AVIVO_D2CRTC_H_TOTAL - AVIVO_D1CRTC_H_TOTAL;
 	drm_crtc_helper_add(&radeon_crtc->base, &atombios_helper_funcs);
 }
-
-void radeon_init_disp_bw_avivo(struct drm_device *dev,
-			       struct drm_display_mode *mode1,
-			       uint32_t pixel_bytes1,
-			       struct drm_display_mode *mode2,
-			       uint32_t pixel_bytes2)
-{
-	struct radeon_device *rdev = dev->dev_private;
-	fixed20_12 min_mem_eff;
-	fixed20_12 peak_disp_bw, mem_bw, pix_clk, pix_clk2, temp_ff;
-	fixed20_12 sclk_ff, mclk_ff;
-	uint32_t dc_lb_memory_split, temp;
-
-	min_mem_eff.full = rfixed_const_8(0);
-	if (rdev->disp_priority == 2) {
-		uint32_t mc_init_misc_lat_timer = 0;
-		if (rdev->family == CHIP_RV515)
-			mc_init_misc_lat_timer =
-			    RREG32_MC(RV515_MC_INIT_MISC_LAT_TIMER);
-		else if (rdev->family == CHIP_RS690)
-			mc_init_misc_lat_timer =
-			    RREG32_MC(RS690_MC_INIT_MISC_LAT_TIMER);
-
-		mc_init_misc_lat_timer &=
-		    ~(R300_MC_DISP1R_INIT_LAT_MASK <<
-		      R300_MC_DISP1R_INIT_LAT_SHIFT);
-		mc_init_misc_lat_timer &=
-		    ~(R300_MC_DISP0R_INIT_LAT_MASK <<
-		      R300_MC_DISP0R_INIT_LAT_SHIFT);
-
-		if (mode2)
-			mc_init_misc_lat_timer |=
-			    (1 << R300_MC_DISP1R_INIT_LAT_SHIFT);
-		if (mode1)
-			mc_init_misc_lat_timer |=
-			    (1 << R300_MC_DISP0R_INIT_LAT_SHIFT);
-
-		if (rdev->family == CHIP_RV515)
-			WREG32_MC(RV515_MC_INIT_MISC_LAT_TIMER,
-				  mc_init_misc_lat_timer);
-		else if (rdev->family == CHIP_RS690)
-			WREG32_MC(RS690_MC_INIT_MISC_LAT_TIMER,
-				  mc_init_misc_lat_timer);
-	}
-
-	/*
-	 * determine is there is enough bw for current mode
-	 */
-	temp_ff.full = rfixed_const(100);
-	mclk_ff.full = rfixed_const(rdev->clock.default_mclk);
-	mclk_ff.full = rfixed_div(mclk_ff, temp_ff);
-	sclk_ff.full = rfixed_const(rdev->clock.default_sclk);
-	sclk_ff.full = rfixed_div(sclk_ff, temp_ff);
-
-	temp = (rdev->mc.vram_width / 8) * (rdev->mc.vram_is_ddr ? 2 : 1);
-	temp_ff.full = rfixed_const(temp);
-	mem_bw.full = rfixed_mul(mclk_ff, temp_ff);
-	mem_bw.full = rfixed_mul(mem_bw, min_mem_eff);
-
-	pix_clk.full = 0;
-	pix_clk2.full = 0;
-	peak_disp_bw.full = 0;
-	if (mode1) {
-		temp_ff.full = rfixed_const(1000);
-		pix_clk.full = rfixed_const(mode1->clock);	/* convert to fixed point */
-		pix_clk.full = rfixed_div(pix_clk, temp_ff);
-		temp_ff.full = rfixed_const(pixel_bytes1);
-		peak_disp_bw.full += rfixed_mul(pix_clk, temp_ff);
-	}
-	if (mode2) {
-		temp_ff.full = rfixed_const(1000);
-		pix_clk2.full = rfixed_const(mode2->clock);	/* convert to fixed point */
-		pix_clk2.full = rfixed_div(pix_clk2, temp_ff);
-		temp_ff.full = rfixed_const(pixel_bytes2);
-		peak_disp_bw.full += rfixed_mul(pix_clk2, temp_ff);
-	}
-
-	if (peak_disp_bw.full >= mem_bw.full) {
-		DRM_ERROR
-		    ("You may not have enough display bandwidth for current mode\n"
-		     "If you have flickering problem, try to lower resolution, refresh rate, or color depth\n");
-		printk("peak disp bw %d, mem_bw %d\n",
-		       rfixed_trunc(peak_disp_bw), rfixed_trunc(mem_bw));
-	}
-
-	/*
-	 * Line Buffer Setup
-	 * There is a single line buffer shared by both display controllers.
-	 * DC_LB_MEMORY_SPLIT controls how that line buffer is shared between the display
-	 * controllers.  The paritioning can either be done manually or via one of four
-	 * preset allocations specified in bits 1:0:
-	 * 0 - line buffer is divided in half and shared between each display controller
-	 * 1 - D1 gets 3/4 of the line buffer, D2 gets 1/4
-	 * 2 - D1 gets the whole buffer
-	 * 3 - D1 gets 1/4 of the line buffer, D2 gets 3/4
-	 * Setting bit 2 of DC_LB_MEMORY_SPLIT controls switches to manual allocation mode.
-	 * In manual allocation mode, D1 always starts at 0, D1 end/2 is specified in bits
-	 * 14:4; D2 allocation follows D1.
-	 */
-
-	/* is auto or manual better ? */
-	dc_lb_memory_split =
-	    RREG32(AVIVO_DC_LB_MEMORY_SPLIT) & ~AVIVO_DC_LB_MEMORY_SPLIT_MASK;
-	dc_lb_memory_split &= ~AVIVO_DC_LB_MEMORY_SPLIT_SHIFT_MODE;
-#if 1
-	/* auto */
-	if (mode1 && mode2) {
-		if (mode1->hdisplay > mode2->hdisplay) {
-			if (mode1->hdisplay > 2560)
-				dc_lb_memory_split |=
-				    AVIVO_DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q;
-			else
-				dc_lb_memory_split |=
-				    AVIVO_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
-		} else if (mode2->hdisplay > mode1->hdisplay) {
-			if (mode2->hdisplay > 2560)
-				dc_lb_memory_split |=
-				    AVIVO_DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
-			else
-				dc_lb_memory_split |=
-				    AVIVO_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
-		} else
-			dc_lb_memory_split |=
-			    AVIVO_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
-	} else if (mode1) {
-		dc_lb_memory_split |= AVIVO_DC_LB_MEMORY_SPLIT_D1_ONLY;
-	} else if (mode2) {
-		dc_lb_memory_split |= AVIVO_DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
-	}
-#else
-	/* manual */
-	dc_lb_memory_split |= AVIVO_DC_LB_MEMORY_SPLIT_SHIFT_MODE;
-	dc_lb_memory_split &=
-	    ~(AVIVO_DC_LB_DISP1_END_ADR_MASK <<
-	      AVIVO_DC_LB_DISP1_END_ADR_SHIFT);
-	if (mode1) {
-		dc_lb_memory_split |=
-		    ((((mode1->hdisplay / 2) + 64) & AVIVO_DC_LB_DISP1_END_ADR_MASK)
-		     << AVIVO_DC_LB_DISP1_END_ADR_SHIFT);
-	} else if (mode2) {
-		dc_lb_memory_split |= (0 << AVIVO_DC_LB_DISP1_END_ADR_SHIFT);
-	}
-#endif
-	WREG32(AVIVO_DC_LB_MEMORY_SPLIT, dc_lb_memory_split);
-}
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 0d05909..86fe3c9 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -1707,3 +1707,486 @@ int r100_debugfs_mc_info_init(struct radeon_device *rdev)
 	return 0;
 #endif
 }
+
+void r100_bandwidth_update(struct radeon_device *rdev)
+{
+	fixed20_12 trcd_ff, trp_ff, tras_ff, trbs_ff, tcas_ff;
+	fixed20_12 sclk_ff, mclk_ff, sclk_eff_ff, sclk_delay_ff;
+	fixed20_12 peak_disp_bw, mem_bw, pix_clk, pix_clk2, temp_ff, crit_point_ff;
+	uint32_t temp, data, mem_trcd, mem_trp, mem_tras;
+	fixed20_12 memtcas_ff[8] = {
+		fixed_init(1),
+		fixed_init(2),
+		fixed_init(3),
+		fixed_init(0),
+		fixed_init_half(1),
+		fixed_init_half(2),
+		fixed_init(0),
+	};
+	fixed20_12 memtcas_rs480_ff[8] = {
+		fixed_init(0),
+		fixed_init(1),
+		fixed_init(2),
+		fixed_init(3),
+		fixed_init(0),
+		fixed_init_half(1),
+		fixed_init_half(2),
+		fixed_init_half(3),
+	};
+	fixed20_12 memtcas2_ff[8] = {
+		fixed_init(0),
+		fixed_init(1),
+		fixed_init(2),
+		fixed_init(3),
+		fixed_init(4),
+		fixed_init(5),
+		fixed_init(6),
+		fixed_init(7),
+	};
+	fixed20_12 memtrbs[8] = {
+		fixed_init(1),
+		fixed_init_half(1),
+		fixed_init(2),
+		fixed_init_half(2),
+		fixed_init(3),
+		fixed_init_half(3),
+		fixed_init(4),
+		fixed_init_half(4)
+	};
+	fixed20_12 memtrbs_r4xx[8] = {
+		fixed_init(4),
+		fixed_init(5),
+		fixed_init(6),
+		fixed_init(7),
+		fixed_init(8),
+		fixed_init(9),
+		fixed_init(10),
+		fixed_init(11)
+	};
+	fixed20_12 min_mem_eff;
+	fixed20_12 mc_latency_sclk, mc_latency_mclk, k1;
+	fixed20_12 cur_latency_mclk, cur_latency_sclk;
+	fixed20_12 disp_latency, disp_latency_overhead, disp_drain_rate,
+		disp_drain_rate2, read_return_rate;
+	fixed20_12 time_disp1_drop_priority;
+	int c;
+	int cur_size = 16;       /* in octawords */
+	int critical_point = 0, critical_point2;
+/* 	uint32_t read_return_rate, time_disp1_drop_priority; */
+	int stop_req, max_stop_req;
+	struct drm_display_mode *mode1 = NULL;
+	struct drm_display_mode *mode2 = NULL;
+	uint32_t pixel_bytes1 = 0;
+	uint32_t pixel_bytes2 = 0;
+
+	if (rdev->mode_info.crtcs[0]->base.enabled) {
+		mode1 = &rdev->mode_info.crtcs[0]->base.mode;
+		pixel_bytes1 = rdev->mode_info.crtcs[0]->base.fb->bits_per_pixel / 8;
+	}
+	if (rdev->mode_info.crtcs[1]->base.enabled) {
+		mode2 = &rdev->mode_info.crtcs[1]->base.mode;
+		pixel_bytes2 = rdev->mode_info.crtcs[1]->base.fb->bits_per_pixel / 8;
+	}
+
+	min_mem_eff.full = rfixed_const_8(0);
+	/* get modes */
+	if ((rdev->disp_priority == 2) && ASIC_IS_R300(rdev)) {
+		uint32_t mc_init_misc_lat_timer = RREG32(R300_MC_INIT_MISC_LAT_TIMER);
+		mc_init_misc_lat_timer &= ~(R300_MC_DISP1R_INIT_LAT_MASK << R300_MC_DISP1R_INIT_LAT_SHIFT);
+		mc_init_misc_lat_timer &= ~(R300_MC_DISP0R_INIT_LAT_MASK << R300_MC_DISP0R_INIT_LAT_SHIFT);
+		/* check crtc enables */
+		if (mode2)
+			mc_init_misc_lat_timer |= (1 << R300_MC_DISP1R_INIT_LAT_SHIFT);
+		if (mode1)
+			mc_init_misc_lat_timer |= (1 << R300_MC_DISP0R_INIT_LAT_SHIFT);
+		WREG32(R300_MC_INIT_MISC_LAT_TIMER, mc_init_misc_lat_timer);
+	}
+
+	/*
+	 * determine is there is enough bw for current mode
+	 */
+	mclk_ff.full = rfixed_const(rdev->clock.default_mclk);
+	temp_ff.full = rfixed_const(100);
+	mclk_ff.full = rfixed_div(mclk_ff, temp_ff);
+	sclk_ff.full = rfixed_const(rdev->clock.default_sclk);
+	sclk_ff.full = rfixed_div(sclk_ff, temp_ff);
+
+	temp = (rdev->mc.vram_width / 8) * (rdev->mc.vram_is_ddr ? 2 : 1);
+	temp_ff.full = rfixed_const(temp);
+	mem_bw.full = rfixed_mul(mclk_ff, temp_ff);
+
+	pix_clk.full = 0;
+	pix_clk2.full = 0;
+	peak_disp_bw.full = 0;
+	if (mode1) {
+		temp_ff.full = rfixed_const(1000);
+		pix_clk.full = rfixed_const(mode1->clock); /* convert to fixed point */
+		pix_clk.full = rfixed_div(pix_clk, temp_ff);
+		temp_ff.full = rfixed_const(pixel_bytes1);
+		peak_disp_bw.full += rfixed_mul(pix_clk, temp_ff);
+	}
+	if (mode2) {
+		temp_ff.full = rfixed_const(1000);
+		pix_clk2.full = rfixed_const(mode2->clock); /* convert to fixed point */
+		pix_clk2.full = rfixed_div(pix_clk2, temp_ff);
+		temp_ff.full = rfixed_const(pixel_bytes2);
+		peak_disp_bw.full += rfixed_mul(pix_clk2, temp_ff);
+	}
+
+	mem_bw.full = rfixed_mul(mem_bw, min_mem_eff);
+	if (peak_disp_bw.full >= mem_bw.full) {
+		DRM_ERROR("You may not have enough display bandwidth for current mode\n"
+			  "If you have flickering problem, try to lower resolution, refresh rate, or color depth\n");
+	}
+
+	/*  Get values from the EXT_MEM_CNTL register...converting its contents. */
+	temp = RREG32(RADEON_MEM_TIMING_CNTL);
+	if ((rdev->family == CHIP_RV100) || (rdev->flags & RADEON_IS_IGP)) { /* RV100, M6, IGPs */
+		mem_trcd = ((temp >> 2) & 0x3) + 1;
+		mem_trp  = ((temp & 0x3)) + 1;
+		mem_tras = ((temp & 0x70) >> 4) + 1;
+	} else if (rdev->family == CHIP_R300 ||
+		   rdev->family == CHIP_R350) { /* r300, r350 */
+		mem_trcd = (temp & 0x7) + 1;
+		mem_trp = ((temp >> 8) & 0x7) + 1;
+		mem_tras = ((temp >> 11) & 0xf) + 4;
+	} else if (rdev->family == CHIP_RV350 ||
+		   rdev->family <= CHIP_RV380) {
+		/* rv3x0 */
+		mem_trcd = (temp & 0x7) + 3;
+		mem_trp = ((temp >> 8) & 0x7) + 3;
+		mem_tras = ((temp >> 11) & 0xf) + 6;
+	} else if (rdev->family == CHIP_R420 ||
+		   rdev->family == CHIP_R423 ||
+		   rdev->family == CHIP_RV410) {
+		/* r4xx */
+		mem_trcd = (temp & 0xf) + 3;
+		if (mem_trcd > 15)
+			mem_trcd = 15;
+		mem_trp = ((temp >> 8) & 0xf) + 3;
+		if (mem_trp > 15)
+			mem_trp = 15;
+		mem_tras = ((temp >> 12) & 0x1f) + 6;
+		if (mem_tras > 31)
+			mem_tras = 31;
+	} else { /* RV200, R200 */
+		mem_trcd = (temp & 0x7) + 1;
+		mem_trp = ((temp >> 8) & 0x7) + 1;
+		mem_tras = ((temp >> 12) & 0xf) + 4;
+	}
+	/* convert to FF */
+	trcd_ff.full = rfixed_const(mem_trcd);
+	trp_ff.full = rfixed_const(mem_trp);
+	tras_ff.full = rfixed_const(mem_tras);
+
+	/* Get values from the MEM_SDRAM_MODE_REG register...converting its */
+	temp = RREG32(RADEON_MEM_SDRAM_MODE_REG);
+	data = (temp & (7 << 20)) >> 20;
+	if ((rdev->family == CHIP_RV100) || rdev->flags & RADEON_IS_IGP) {
+		if (rdev->family == CHIP_RS480) /* don't think rs400 */
+			tcas_ff = memtcas_rs480_ff[data];
+		else
+			tcas_ff = memtcas_ff[data];
+	} else
+		tcas_ff = memtcas2_ff[data];
+
+	if (rdev->family == CHIP_RS400 ||
+	    rdev->family == CHIP_RS480) {
+		/* extra cas latency stored in bits 23-25 0-4 clocks */
+		data = (temp >> 23) & 0x7;
+		if (data < 5)
+			tcas_ff.full += rfixed_const(data);
+	}
+
+	if (ASIC_IS_R300(rdev) && !(rdev->flags & RADEON_IS_IGP)) {
+		/* on the R300, Tcas is included in Trbs.
+		 */
+		temp = RREG32(RADEON_MEM_CNTL);
+		data = (R300_MEM_NUM_CHANNELS_MASK & temp);
+		if (data == 1) {
+			if (R300_MEM_USE_CD_CH_ONLY & temp) {
+				temp = RREG32(R300_MC_IND_INDEX);
+				temp &= ~R300_MC_IND_ADDR_MASK;
+				temp |= R300_MC_READ_CNTL_CD_mcind;
+				WREG32(R300_MC_IND_INDEX, temp);
+				temp = RREG32(R300_MC_IND_DATA);
+				data = (R300_MEM_RBS_POSITION_C_MASK & temp);
+			} else {
+				temp = RREG32(R300_MC_READ_CNTL_AB);
+				data = (R300_MEM_RBS_POSITION_A_MASK & temp);
+			}
+		} else {
+			temp = RREG32(R300_MC_READ_CNTL_AB);
+			data = (R300_MEM_RBS_POSITION_A_MASK & temp);
+		}
+		if (rdev->family == CHIP_RV410 ||
+		    rdev->family == CHIP_R420 ||
+		    rdev->family == CHIP_R423)
+			trbs_ff = memtrbs_r4xx[data];
+		else
+			trbs_ff = memtrbs[data];
+		tcas_ff.full += trbs_ff.full;
+	}
+
+	sclk_eff_ff.full = sclk_ff.full;
+
+	if (rdev->flags & RADEON_IS_AGP) {
+		fixed20_12 agpmode_ff;
+		agpmode_ff.full = rfixed_const(radeon_agpmode);
+		temp_ff.full = rfixed_const_666(16);
+		sclk_eff_ff.full -= rfixed_mul(agpmode_ff, temp_ff);
+	}
+	/* TODO PCIE lanes may affect this - agpmode == 16?? */
+
+	if (ASIC_IS_R300(rdev)) {
+		sclk_delay_ff.full = rfixed_const(250);
+	} else {
+		if ((rdev->family == CHIP_RV100) ||
+		    rdev->flags & RADEON_IS_IGP) {
+			if (rdev->mc.vram_is_ddr)
+				sclk_delay_ff.full = rfixed_const(41);
+			else
+				sclk_delay_ff.full = rfixed_const(33);
+		} else {
+			if (rdev->mc.vram_width == 128)
+				sclk_delay_ff.full = rfixed_const(57);
+			else
+				sclk_delay_ff.full = rfixed_const(41);
+		}
+	}
+
+	mc_latency_sclk.full = rfixed_div(sclk_delay_ff, sclk_eff_ff);
+
+	if (rdev->mc.vram_is_ddr) {
+		if (rdev->mc.vram_width == 32) {
+			k1.full = rfixed_const(40);
+			c  = 3;
+		} else {
+			k1.full = rfixed_const(20);
+			c  = 1;
+		}
+	} else {
+		k1.full = rfixed_const(40);
+		c  = 3;
+	}
+
+	temp_ff.full = rfixed_const(2);
+	mc_latency_mclk.full = rfixed_mul(trcd_ff, temp_ff);
+	temp_ff.full = rfixed_const(c);
+	mc_latency_mclk.full += rfixed_mul(tcas_ff, temp_ff);
+	temp_ff.full = rfixed_const(4);
+	mc_latency_mclk.full += rfixed_mul(tras_ff, temp_ff);
+	mc_latency_mclk.full += rfixed_mul(trp_ff, temp_ff);
+	mc_latency_mclk.full += k1.full;
+
+	mc_latency_mclk.full = rfixed_div(mc_latency_mclk, mclk_ff);
+	mc_latency_mclk.full += rfixed_div(temp_ff, sclk_eff_ff);
+
+	/*
+	  HW cursor time assuming worst case of full size colour cursor.
+	*/
+	temp_ff.full = rfixed_const((2 * (cur_size - (rdev->mc.vram_is_ddr + 1))));
+	temp_ff.full += trcd_ff.full;
+	if (temp_ff.full < tras_ff.full)
+		temp_ff.full = tras_ff.full;
+	cur_latency_mclk.full = rfixed_div(temp_ff, mclk_ff);
+
+	temp_ff.full = rfixed_const(cur_size);
+	cur_latency_sclk.full = rfixed_div(temp_ff, sclk_eff_ff);
+	/*
+	  Find the total latency for the display data.
+	*/
+	disp_latency_overhead.full = rfixed_const(80);
+	disp_latency_overhead.full = rfixed_div(disp_latency_overhead, sclk_ff);
+	mc_latency_mclk.full += disp_latency_overhead.full + cur_latency_mclk.full;
+	mc_latency_sclk.full += disp_latency_overhead.full + cur_latency_sclk.full;
+
+	if (mc_latency_mclk.full > mc_latency_sclk.full)
+		disp_latency.full = mc_latency_mclk.full;
+	else
+		disp_latency.full = mc_latency_sclk.full;
+
+	/* setup Max GRPH_STOP_REQ default value */
+	if (ASIC_IS_RV100(rdev))
+		max_stop_req = 0x5c;
+	else
+		max_stop_req = 0x7c;
+
+	if (mode1) {
+		/*  CRTC1
+		    Set GRPH_BUFFER_CNTL register using h/w defined optimal values.
+		    GRPH_STOP_REQ <= MIN[ 0x7C, (CRTC_H_DISP + 1) * (bit depth) / 0x10 ]
+		*/
+		stop_req = mode1->hdisplay * pixel_bytes1 / 16;
+
+		if (stop_req > max_stop_req)
+			stop_req = max_stop_req;
+
+		/*
+		  Find the drain rate of the display buffer.
+		*/
+		temp_ff.full = rfixed_const((16/pixel_bytes1));
+		disp_drain_rate.full = rfixed_div(pix_clk, temp_ff);
+
+		/*
+		  Find the critical point of the display buffer.
+		*/
+		crit_point_ff.full = rfixed_mul(disp_drain_rate, disp_latency);
+		crit_point_ff.full += rfixed_const_half(0);
+
+		critical_point = rfixed_trunc(crit_point_ff);
+
+		if (rdev->disp_priority == 2) {
+			critical_point = 0;
+		}
+
+		/*
+		  The critical point should never be above max_stop_req-4.  Setting
+		  GRPH_CRITICAL_CNTL = 0 will thus force high priority all the time.
+		*/
+		if (max_stop_req - critical_point < 4)
+			critical_point = 0;
+
+		if (critical_point == 0 && mode2 && rdev->family == CHIP_R300) {
+			/* some R300 cards have problem with this set to 0, when CRTC2 is enabled.*/
+			critical_point = 0x10;
+		}
+
+		temp = RREG32(RADEON_GRPH_BUFFER_CNTL);
+		temp &= ~(RADEON_GRPH_STOP_REQ_MASK);
+		temp |= (stop_req << RADEON_GRPH_STOP_REQ_SHIFT);
+		temp &= ~(RADEON_GRPH_START_REQ_MASK);
+		if ((rdev->family == CHIP_R350) &&
+		    (stop_req > 0x15)) {
+			stop_req -= 0x10;
+		}
+		temp |= (stop_req << RADEON_GRPH_START_REQ_SHIFT);
+		temp |= RADEON_GRPH_BUFFER_SIZE;
+		temp &= ~(RADEON_GRPH_CRITICAL_CNTL   |
+			  RADEON_GRPH_CRITICAL_AT_SOF |
+			  RADEON_GRPH_STOP_CNTL);
+		/*
+		  Write the result into the register.
+		*/
+		WREG32(RADEON_GRPH_BUFFER_CNTL, ((temp & ~RADEON_GRPH_CRITICAL_POINT_MASK) |
+						       (critical_point << RADEON_GRPH_CRITICAL_POINT_SHIFT)));
+
+#if 0
+		if ((rdev->family == CHIP_RS400) ||
+		    (rdev->family == CHIP_RS480)) {
+			/* attempt to program RS400 disp regs correctly ??? */
+			temp = RREG32(RS400_DISP1_REG_CNTL);
+			temp &= ~(RS400_DISP1_START_REQ_LEVEL_MASK |
+				  RS400_DISP1_STOP_REQ_LEVEL_MASK);
+			WREG32(RS400_DISP1_REQ_CNTL1, (temp |
+						       (critical_point << RS400_DISP1_START_REQ_LEVEL_SHIFT) |
+						       (critical_point << RS400_DISP1_STOP_REQ_LEVEL_SHIFT)));
+			temp = RREG32(RS400_DMIF_MEM_CNTL1);
+			temp &= ~(RS400_DISP1_CRITICAL_POINT_START_MASK |
+				  RS400_DISP1_CRITICAL_POINT_STOP_MASK);
+			WREG32(RS400_DMIF_MEM_CNTL1, (temp |
+						      (critical_point << RS400_DISP1_CRITICAL_POINT_START_SHIFT) |
+						      (critical_point << RS400_DISP1_CRITICAL_POINT_STOP_SHIFT)));
+		}
+#endif
+
+		DRM_DEBUG("GRPH_BUFFER_CNTL from to %x\n",
+			  /* 	  (unsigned int)info->SavedReg->grph_buffer_cntl, */
+			  (unsigned int)RREG32(RADEON_GRPH_BUFFER_CNTL));
+	}
+
+	if (mode2) {
+		u32 grph2_cntl;
+		stop_req = mode2->hdisplay * pixel_bytes2 / 16;
+
+		if (stop_req > max_stop_req)
+			stop_req = max_stop_req;
+
+		/*
+		  Find the drain rate of the display buffer.
+		*/
+		temp_ff.full = rfixed_const((16/pixel_bytes2));
+		disp_drain_rate2.full = rfixed_div(pix_clk2, temp_ff);
+
+		grph2_cntl = RREG32(RADEON_GRPH2_BUFFER_CNTL);
+		grph2_cntl &= ~(RADEON_GRPH_STOP_REQ_MASK);
+		grph2_cntl |= (stop_req << RADEON_GRPH_STOP_REQ_SHIFT);
+		grph2_cntl &= ~(RADEON_GRPH_START_REQ_MASK);
+		if ((rdev->family == CHIP_R350) &&
+		    (stop_req > 0x15)) {
+			stop_req -= 0x10;
+		}
+		grph2_cntl |= (stop_req << RADEON_GRPH_START_REQ_SHIFT);
+		grph2_cntl |= RADEON_GRPH_BUFFER_SIZE;
+		grph2_cntl &= ~(RADEON_GRPH_CRITICAL_CNTL   |
+			  RADEON_GRPH_CRITICAL_AT_SOF |
+			  RADEON_GRPH_STOP_CNTL);
+
+		if ((rdev->family == CHIP_RS100) ||
+		    (rdev->family == CHIP_RS200))
+			critical_point2 = 0;
+		else {
+			temp = (rdev->mc.vram_width * rdev->mc.vram_is_ddr + 1)/128;
+			temp_ff.full = rfixed_const(temp);
+			temp_ff.full = rfixed_mul(mclk_ff, temp_ff);
+			if (sclk_ff.full < temp_ff.full)
+				temp_ff.full = sclk_ff.full;
+
+			read_return_rate.full = temp_ff.full;
+
+			if (mode1) {
+				temp_ff.full = read_return_rate.full - disp_drain_rate.full;
+				time_disp1_drop_priority.full = rfixed_div(crit_point_ff, temp_ff);
+			} else {
+				time_disp1_drop_priority.full = 0;
+			}
+			crit_point_ff.full = disp_latency.full + time_disp1_drop_priority.full + disp_latency.full;
+			crit_point_ff.full = rfixed_mul(crit_point_ff, disp_drain_rate2);
+			crit_point_ff.full += rfixed_const_half(0);
+
+			critical_point2 = rfixed_trunc(crit_point_ff);
+
+			if (rdev->disp_priority == 2) {
+				critical_point2 = 0;
+			}
+
+			if (max_stop_req - critical_point2 < 4)
+				critical_point2 = 0;
+
+		}
+
+		if (critical_point2 == 0 && rdev->family == CHIP_R300) {
+			/* some R300 cards have problem with this set to 0 */
+			critical_point2 = 0x10;
+		}
+
+		WREG32(RADEON_GRPH2_BUFFER_CNTL, ((grph2_cntl & ~RADEON_GRPH_CRITICAL_POINT_MASK) |
+						  (critical_point2 << RADEON_GRPH_CRITICAL_POINT_SHIFT)));
+
+		if ((rdev->family == CHIP_RS400) ||
+		    (rdev->family == CHIP_RS480)) {
+#if 0
+			/* attempt to program RS400 disp2 regs correctly ??? */
+			temp = RREG32(RS400_DISP2_REQ_CNTL1);
+			temp &= ~(RS400_DISP2_START_REQ_LEVEL_MASK |
+				  RS400_DISP2_STOP_REQ_LEVEL_MASK);
+			WREG32(RS400_DISP2_REQ_CNTL1, (temp |
+						       (critical_point2 << RS400_DISP1_START_REQ_LEVEL_SHIFT) |
+						       (critical_point2 << RS400_DISP1_STOP_REQ_LEVEL_SHIFT)));
+			temp = RREG32(RS400_DISP2_REQ_CNTL2);
+			temp &= ~(RS400_DISP2_CRITICAL_POINT_START_MASK |
+				  RS400_DISP2_CRITICAL_POINT_STOP_MASK);
+			WREG32(RS400_DISP2_REQ_CNTL2, (temp |
+						       (critical_point2 << RS400_DISP2_CRITICAL_POINT_START_SHIFT) |
+						       (critical_point2 << RS400_DISP2_CRITICAL_POINT_STOP_SHIFT)));
+#endif
+			WREG32(RS400_DISP2_REQ_CNTL1, 0x105DC1CC);
+			WREG32(RS400_DISP2_REQ_CNTL2, 0x2749D000);
+			WREG32(RS400_DMIF_MEM_CNTL1,  0x29CA71DC);
+			WREG32(RS400_DISP1_REQ_CNTL1, 0x28FBC3AC);
+		}
+
+		DRM_DEBUG("GRPH2_BUFFER_CNTL from to %x\n",
+			  (unsigned int)RREG32(RADEON_GRPH2_BUFFER_CNTL));
+	}
+}
diff --git a/drivers/gpu/drm/radeon/r300.c b/drivers/gpu/drm/radeon/r300.c
index 0e0e094..60832ec 100644
--- a/drivers/gpu/drm/radeon/r300.c
+++ b/drivers/gpu/drm/radeon/r300.c
@@ -30,6 +30,7 @@
 #include "drm.h"
 #include "radeon_reg.h"
 #include "radeon.h"
+#include "radeon_share.h"
 
 /* r300,r350,rv350,rv370,rv380 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/r520.c b/drivers/gpu/drm/radeon/r520.c
index b6bd375..0a981e2 100644
--- a/drivers/gpu/drm/radeon/r520.c
+++ b/drivers/gpu/drm/radeon/r520.c
@@ -28,6 +28,7 @@
 #include "drmP.h"
 #include "radeon_reg.h"
 #include "radeon.h"
+#include "radeon_share.h"
 
 /* r520,rv530,rv560,rv570,r580 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
@@ -226,7 +227,20 @@ static void r520_vram_get_type(struct radeon_device *rdev)
 
 void r520_vram_info(struct radeon_device *rdev)
 {
+	fixed20_12 a;
+
 	r520_vram_get_type(rdev);
 
 	r100_vram_init_sizes(rdev);
+	/* FIXME: we should enforce default clock in case GPU is not in
+	 * default setup
+	 */
+	a.full = rfixed_const(100);
+	rdev->pm.sclk.full = rfixed_const(rdev->clock.default_sclk);
+	rdev->pm.sclk.full = rfixed_div(rdev->pm.sclk, a);
+}
+
+void r520_bandwidth_update(struct radeon_device *rdev)
+{
+	rv515_bandwidth_avivo_update(rdev);
 }
diff --git a/drivers/gpu/drm/radeon/radeon.h b/drivers/gpu/drm/radeon/radeon.h
index 7f00718..c902997 100644
--- a/drivers/gpu/drm/radeon/radeon.h
+++ b/drivers/gpu/drm/radeon/radeon.h
@@ -113,6 +113,7 @@ enum radeon_family {
 	CHIP_RV770,
 	CHIP_RV730,
 	CHIP_RV710,
+	CHIP_RS880,
 	CHIP_LAST,
 };
 
@@ -474,6 +475,39 @@ struct radeon_wb {
 	uint64_t		gpu_addr;
 };
 
+/**
+ * struct radeon_pm - power management datas
+ * @max_bandwidth:      maximum bandwidth the gpu has (MByte/s)
+ * @igp_sideport_mclk:  sideport memory clock Mhz (rs690,rs740,rs780,rs880)
+ * @igp_system_mclk:    system clock Mhz (rs690,rs740,rs780,rs880)
+ * @igp_ht_link_clk:    ht link clock Mhz (rs690,rs740,rs780,rs880)
+ * @igp_ht_link_width:  ht link width in bits (rs690,rs740,rs780,rs880)
+ * @k8_bandwidth:       k8 bandwidth the gpu has (MByte/s) (IGP)
+ * @sideport_bandwidth: sideport bandwidth the gpu has (MByte/s) (IGP)
+ * @ht_bandwidth:       ht bandwidth the gpu has (MByte/s) (IGP)
+ * @core_bandwidth:     core GPU bandwidth the gpu has (MByte/s) (IGP)
+ * @sclk:          	GPU clock Mhz (core bandwith depends of this clock)
+ * @needed_bandwidth:   current bandwidth needs
+ *
+ * It keeps track of various data needed to take powermanagement decision.
+ * Bandwith need is used to determine minimun clock of the GPU and memory.
+ * Equation between gpu/memory clock and available bandwidth is hw dependent
+ * (type of memory, bus size, efficiency, ...)
+ */
+struct radeon_pm {
+	fixed20_12		max_bandwidth;
+	fixed20_12		igp_sideport_mclk;
+	fixed20_12		igp_system_mclk;
+	fixed20_12		igp_ht_link_clk;
+	fixed20_12		igp_ht_link_width;
+	fixed20_12		k8_bandwidth;
+	fixed20_12		sideport_bandwidth;
+	fixed20_12		ht_bandwidth;
+	fixed20_12		core_bandwidth;
+	fixed20_12		sclk;
+	fixed20_12		needed_bandwidth;
+};
+
 
 /*
  * Benchmarking
@@ -535,14 +569,13 @@ struct radeon_asic {
 	void (*set_memory_clock)(struct radeon_device *rdev, uint32_t mem_clock);
 	void (*set_pcie_lanes)(struct radeon_device *rdev, int lanes);
 	void (*set_clock_gating)(struct radeon_device *rdev, int enable);
+	void (*bandwidth_update)(struct radeon_device *rdev);
 };
 
 union radeon_asic_config {
 	struct r300_asic	r300;
 };
 
-/* r100 */
-void r100_vram_init_sizes(struct radeon_device *rdev);
 
 /*
  * IOCTL.
@@ -621,6 +654,7 @@ struct radeon_device {
 	struct radeon_irq		irq;
 	struct radeon_asic		*asic;
 	struct radeon_gem		gem;
+	struct radeon_pm		pm;
 	struct mutex			cs_mutex;
 	struct radeon_wb		wb;
 	bool				gpu_lockup;
@@ -801,5 +835,6 @@ static inline void radeon_ring_write(struct radeon_device *rdev, uint32_t v)
 #define radeon_set_memory_clock(rdev, e) (rdev)->asic->set_engine_clock((rdev), (e))
 #define radeon_set_pcie_lanes(rdev, l) (rdev)->asic->set_pcie_lanes((rdev), (l))
 #define radeon_set_clock_gating(rdev, e) (rdev)->asic->set_clock_gating((rdev), (e))
+#define radeon_bandwidth_update(rdev) (rdev)->asic->bandwidth_update((rdev))
 
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_asic.h b/drivers/gpu/drm/radeon/radeon_asic.h
index e2e5673..8054d12 100644
--- a/drivers/gpu/drm/radeon/radeon_asic.h
+++ b/drivers/gpu/drm/radeon/radeon_asic.h
@@ -71,6 +71,7 @@ int r100_copy_blit(struct radeon_device *rdev,
 		   uint64_t dst_offset,
 		   unsigned num_pages,
 		   struct radeon_fence *fence);
+void r100_bandwidth_update(struct radeon_device *rdev);
 
 static struct radeon_asic r100_asic = {
 	.init = &r100_init,
@@ -100,6 +101,7 @@ static struct radeon_asic r100_asic = {
 	.set_memory_clock = NULL,
 	.set_pcie_lanes = NULL,
 	.set_clock_gating = &radeon_legacy_set_clock_gating,
+	.bandwidth_update = &r100_bandwidth_update,
 };
 
 
@@ -156,6 +158,7 @@ static struct radeon_asic r300_asic = {
 	.set_memory_clock = NULL,
 	.set_pcie_lanes = &rv370_set_pcie_lanes,
 	.set_clock_gating = &radeon_legacy_set_clock_gating,
+	.bandwidth_update = &r100_bandwidth_update,
 };
 
 /*
@@ -193,6 +196,7 @@ static struct radeon_asic r420_asic = {
 	.set_memory_clock = &radeon_atom_set_memory_clock,
 	.set_pcie_lanes = &rv370_set_pcie_lanes,
 	.set_clock_gating = &radeon_atom_set_clock_gating,
+	.bandwidth_update = &r100_bandwidth_update,
 };
 
 
@@ -237,6 +241,7 @@ static struct radeon_asic rs400_asic = {
 	.set_memory_clock = NULL,
 	.set_pcie_lanes = NULL,
 	.set_clock_gating = &radeon_legacy_set_clock_gating,
+	.bandwidth_update = &r100_bandwidth_update,
 };
 
 
@@ -254,6 +259,7 @@ void rs600_gart_tlb_flush(struct radeon_device *rdev);
 int rs600_gart_set_page(struct radeon_device *rdev, int i, uint64_t addr);
 uint32_t rs600_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rs600_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
+void rs600_bandwidth_update(struct radeon_device *rdev);
 static struct radeon_asic rs600_asic = {
 	.init = &r300_init,
 	.errata = &rs600_errata,
@@ -282,6 +288,7 @@ static struct radeon_asic rs600_asic = {
 	.set_memory_clock = &radeon_atom_set_memory_clock,
 	.set_pcie_lanes = NULL,
 	.set_clock_gating = &radeon_atom_set_clock_gating,
+	.bandwidth_update = &rs600_bandwidth_update,
 };
 
 
@@ -294,6 +301,7 @@ int rs690_mc_init(struct radeon_device *rdev);
 void rs690_mc_fini(struct radeon_device *rdev);
 uint32_t rs690_mc_rreg(struct radeon_device *rdev, uint32_t reg);
 void rs690_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
+void rs690_bandwidth_update(struct radeon_device *rdev);
 static struct radeon_asic rs690_asic = {
 	.init = &r300_init,
 	.errata = &rs690_errata,
@@ -322,6 +330,7 @@ static struct radeon_asic rs690_asic = {
 	.set_memory_clock = &radeon_atom_set_memory_clock,
 	.set_pcie_lanes = NULL,
 	.set_clock_gating = &radeon_atom_set_clock_gating,
+	.bandwidth_update = &rs690_bandwidth_update,
 };
 
 
@@ -339,6 +348,7 @@ void rv515_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
 void rv515_ring_start(struct radeon_device *rdev);
 uint32_t rv515_pcie_rreg(struct radeon_device *rdev, uint32_t reg);
 void rv515_pcie_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v);
+void rv515_bandwidth_update(struct radeon_device *rdev);
 static struct radeon_asic rv515_asic = {
 	.init = &rv515_init,
 	.errata = &rv515_errata,
@@ -367,6 +377,7 @@ static struct radeon_asic rv515_asic = {
 	.set_memory_clock = &radeon_atom_set_memory_clock,
 	.set_pcie_lanes = &rv370_set_pcie_lanes,
 	.set_clock_gating = &radeon_atom_set_clock_gating,
+	.bandwidth_update = &rv515_bandwidth_update,
 };
 
 
@@ -377,6 +388,7 @@ void r520_errata(struct radeon_device *rdev);
 void r520_vram_info(struct radeon_device *rdev);
 int r520_mc_init(struct radeon_device *rdev);
 void r520_mc_fini(struct radeon_device *rdev);
+void r520_bandwidth_update(struct radeon_device *rdev);
 static struct radeon_asic r520_asic = {
 	.init = &rv515_init,
 	.errata = &r520_errata,
@@ -405,6 +417,7 @@ static struct radeon_asic r520_asic = {
 	.set_memory_clock = &radeon_atom_set_memory_clock,
 	.set_pcie_lanes = &rv370_set_pcie_lanes,
 	.set_clock_gating = &radeon_atom_set_clock_gating,
+	.bandwidth_update = &r520_bandwidth_update,
 };
 
 /*
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index cdef6eb..d340bb4 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -559,6 +559,11 @@ int radeon_device_init(struct radeon_device *rdev,
 			radeon_combios_asic_init(rdev->ddev);
 		}
 	}
+	/* Initialize clocks */
+	r = radeon_clocks_init(rdev);
+	if (r) {
+		return r;
+	}
 	/* Get vram informations */
 	radeon_vram_info(rdev);
 
@@ -570,11 +575,6 @@ int radeon_device_init(struct radeon_device *rdev,
 		 (unsigned)rdev->mc.aper_size >> 20);
 	DRM_INFO("RAM width %dbits %cDR\n",
 		 rdev->mc.vram_width, rdev->mc.vram_is_ddr ? 'D' : 'S');
-	/* Initialize clocks */
-	r = radeon_clocks_init(rdev);
-	if (r) {
-		return r;
-	}
 	/* Initialize memory controller (also test AGP) */
 	r = radeon_mc_init(rdev);
 	if (r) {
diff --git a/drivers/gpu/drm/radeon/radeon_display.c b/drivers/gpu/drm/radeon/radeon_display.c
index 3efcf1a..90c185e 100644
--- a/drivers/gpu/drm/radeon/radeon_display.c
+++ b/drivers/gpu/drm/radeon/radeon_display.c
@@ -187,6 +187,7 @@ static void radeon_crtc_init(struct drm_device *dev, int index)
 
 	drm_mode_crtc_set_gamma_size(&radeon_crtc->base, 256);
 	radeon_crtc->crtc_id = index;
+	rdev->mode_info.crtcs[index] = radeon_crtc;
 
 	radeon_crtc->mode_set.crtc = &radeon_crtc->base;
 	radeon_crtc->mode_set.connectors = (struct drm_connector **)(radeon_crtc + 1);
@@ -657,36 +658,51 @@ void radeon_modeset_fini(struct radeon_device *rdev)
 	}
 }
 
-void radeon_init_disp_bandwidth(struct drm_device *dev)
+bool radeon_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
+				struct drm_display_mode *mode,
+				struct drm_display_mode *adjusted_mode)
 {
-	struct radeon_device *rdev = dev->dev_private;
-	struct drm_display_mode *modes[2];
-	int pixel_bytes[2];
-	struct drm_crtc *crtc;
-
-	pixel_bytes[0] = pixel_bytes[1] = 0;
-	modes[0] = modes[1] = NULL;
-
-	list_for_each_entry(crtc, &dev->mode_config.crtc_list, head) {
-		struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	struct drm_device *dev = crtc->dev;
+	struct drm_encoder *encoder;
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	struct radeon_encoder *radeon_encoder;
+	bool first = true;
 
-		if (crtc->enabled && crtc->fb) {
-			modes[radeon_crtc->crtc_id] = &crtc->mode;
-			pixel_bytes[radeon_crtc->crtc_id] = crtc->fb->bits_per_pixel / 8;
+	list_for_each_entry(encoder, &dev->mode_config.encoder_list, head) {
+		radeon_encoder = to_radeon_encoder(encoder);
+		if (encoder->crtc != crtc)
+			continue;
+		if (first) {
+			radeon_crtc->rmx_type = radeon_encoder->rmx_type;
+			radeon_crtc->devices = radeon_encoder->devices;
+			memcpy(&radeon_crtc->native_mode,
+				&radeon_encoder->native_mode,
+				sizeof(struct radeon_native_mode));
+			first = false;
+		} else {
+			if (radeon_crtc->rmx_type != radeon_encoder->rmx_type) {
+				/* WARNING: Right now this can't happen but
+				 * in the future we need to check that scaling
+				 * are consistent accross different encoder
+				 * (ie all encoder can work with the same
+				 *  scaling).
+				 */
+				DRM_ERROR("Scaling not consistent accross encoder.\n");
+				return false;
+			}
 		}
 	}
-
-	if (ASIC_IS_AVIVO(rdev)) {
-		radeon_init_disp_bw_avivo(dev,
-					  modes[0],
-					  pixel_bytes[0],
-					  modes[1],
-					  pixel_bytes[1]);
+	if (radeon_crtc->rmx_type != RMX_OFF) {
+		fixed20_12 a, b;
+		a.full = rfixed_const(crtc->mode.vdisplay);
+		b.full = rfixed_const(radeon_crtc->native_mode.panel_xres);
+		radeon_crtc->vsc.full = rfixed_div(a, b);
+		a.full = rfixed_const(crtc->mode.hdisplay);
+		b.full = rfixed_const(radeon_crtc->native_mode.panel_yres);
+		radeon_crtc->hsc.full = rfixed_div(a, b);
 	} else {
-		radeon_init_disp_bw_legacy(dev,
-					   modes[0],
-					   pixel_bytes[0],
-					   modes[1],
-					   pixel_bytes[1]);
+		radeon_crtc->vsc.full = rfixed_const(1);
+		radeon_crtc->hsc.full = rfixed_const(1);
 	}
+	return true;
 }
diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
index ea15284..0a92706 100644
--- a/drivers/gpu/drm/radeon/radeon_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_encoders.c
@@ -154,7 +154,6 @@ void radeon_rmx_mode_fixup(struct drm_encoder *encoder,
 
 	if (mode->hdisplay < native_mode->panel_xres ||
 	    mode->vdisplay < native_mode->panel_yres) {
-		radeon_encoder->flags |= RADEON_USE_RMX;
 		if (ASIC_IS_AVIVO(rdev)) {
 			adjusted_mode->hdisplay = native_mode->panel_xres;
 			adjusted_mode->vdisplay = native_mode->panel_yres;
@@ -197,15 +196,13 @@ void radeon_rmx_mode_fixup(struct drm_encoder *encoder,
 	}
 }
 
+
 static bool radeon_atom_mode_fixup(struct drm_encoder *encoder,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *adjusted_mode)
 {
-
 	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
 
-	radeon_encoder->flags &= ~RADEON_USE_RMX;
-
 	drm_mode_set_crtcinfo(adjusted_mode, 0);
 
 	if (radeon_encoder->rmx_type != RMX_OFF)
@@ -808,234 +805,6 @@ atombios_dig_transmitter_setup(struct drm_encoder *encoder, int action)
 
 }
 
-static void atom_rv515_force_tv_scaler(struct radeon_device *rdev)
-{
-
-	WREG32(0x659C, 0x0);
-	WREG32(0x6594, 0x705);
-	WREG32(0x65A4, 0x10001);
-	WREG32(0x65D8, 0x0);
-	WREG32(0x65B0, 0x0);
-	WREG32(0x65C0, 0x0);
-	WREG32(0x65D4, 0x0);
-	WREG32(0x6578, 0x0);
-	WREG32(0x657C, 0x841880A8);
-	WREG32(0x6578, 0x1);
-	WREG32(0x657C, 0x84208680);
-	WREG32(0x6578, 0x2);
-	WREG32(0x657C, 0xBFF880B0);
-	WREG32(0x6578, 0x100);
-	WREG32(0x657C, 0x83D88088);
-	WREG32(0x6578, 0x101);
-	WREG32(0x657C, 0x84608680);
-	WREG32(0x6578, 0x102);
-	WREG32(0x657C, 0xBFF080D0);
-	WREG32(0x6578, 0x200);
-	WREG32(0x657C, 0x83988068);
-	WREG32(0x6578, 0x201);
-	WREG32(0x657C, 0x84A08680);
-	WREG32(0x6578, 0x202);
-	WREG32(0x657C, 0xBFF080F8);
-	WREG32(0x6578, 0x300);
-	WREG32(0x657C, 0x83588058);
-	WREG32(0x6578, 0x301);
-	WREG32(0x657C, 0x84E08660);
-	WREG32(0x6578, 0x302);
-	WREG32(0x657C, 0xBFF88120);
-	WREG32(0x6578, 0x400);
-	WREG32(0x657C, 0x83188040);
-	WREG32(0x6578, 0x401);
-	WREG32(0x657C, 0x85008660);
-	WREG32(0x6578, 0x402);
-	WREG32(0x657C, 0xBFF88150);
-	WREG32(0x6578, 0x500);
-	WREG32(0x657C, 0x82D88030);
-	WREG32(0x6578, 0x501);
-	WREG32(0x657C, 0x85408640);
-	WREG32(0x6578, 0x502);
-	WREG32(0x657C, 0xBFF88180);
-	WREG32(0x6578, 0x600);
-	WREG32(0x657C, 0x82A08018);
-	WREG32(0x6578, 0x601);
-	WREG32(0x657C, 0x85808620);
-	WREG32(0x6578, 0x602);
-	WREG32(0x657C, 0xBFF081B8);
-	WREG32(0x6578, 0x700);
-	WREG32(0x657C, 0x82608010);
-	WREG32(0x6578, 0x701);
-	WREG32(0x657C, 0x85A08600);
-	WREG32(0x6578, 0x702);
-	WREG32(0x657C, 0x800081F0);
-	WREG32(0x6578, 0x800);
-	WREG32(0x657C, 0x8228BFF8);
-	WREG32(0x6578, 0x801);
-	WREG32(0x657C, 0x85E085E0);
-	WREG32(0x6578, 0x802);
-	WREG32(0x657C, 0xBFF88228);
-	WREG32(0x6578, 0x10000);
-	WREG32(0x657C, 0x82A8BF00);
-	WREG32(0x6578, 0x10001);
-	WREG32(0x657C, 0x82A08CC0);
-	WREG32(0x6578, 0x10002);
-	WREG32(0x657C, 0x8008BEF8);
-	WREG32(0x6578, 0x10100);
-	WREG32(0x657C, 0x81F0BF28);
-	WREG32(0x6578, 0x10101);
-	WREG32(0x657C, 0x83608CA0);
-	WREG32(0x6578, 0x10102);
-	WREG32(0x657C, 0x8018BED0);
-	WREG32(0x6578, 0x10200);
-	WREG32(0x657C, 0x8148BF38);
-	WREG32(0x6578, 0x10201);
-	WREG32(0x657C, 0x84408C80);
-	WREG32(0x6578, 0x10202);
-	WREG32(0x657C, 0x8008BEB8);
-	WREG32(0x6578, 0x10300);
-	WREG32(0x657C, 0x80B0BF78);
-	WREG32(0x6578, 0x10301);
-	WREG32(0x657C, 0x85008C20);
-	WREG32(0x6578, 0x10302);
-	WREG32(0x657C, 0x8020BEA0);
-	WREG32(0x6578, 0x10400);
-	WREG32(0x657C, 0x8028BF90);
-	WREG32(0x6578, 0x10401);
-	WREG32(0x657C, 0x85E08BC0);
-	WREG32(0x6578, 0x10402);
-	WREG32(0x657C, 0x8018BE90);
-	WREG32(0x6578, 0x10500);
-	WREG32(0x657C, 0xBFB8BFB0);
-	WREG32(0x6578, 0x10501);
-	WREG32(0x657C, 0x86C08B40);
-	WREG32(0x6578, 0x10502);
-	WREG32(0x657C, 0x8010BE90);
-	WREG32(0x6578, 0x10600);
-	WREG32(0x657C, 0xBF58BFC8);
-	WREG32(0x6578, 0x10601);
-	WREG32(0x657C, 0x87A08AA0);
-	WREG32(0x6578, 0x10602);
-	WREG32(0x657C, 0x8010BE98);
-	WREG32(0x6578, 0x10700);
-	WREG32(0x657C, 0xBF10BFF0);
-	WREG32(0x6578, 0x10701);
-	WREG32(0x657C, 0x886089E0);
-	WREG32(0x6578, 0x10702);
-	WREG32(0x657C, 0x8018BEB0);
-	WREG32(0x6578, 0x10800);
-	WREG32(0x657C, 0xBED8BFE8);
-	WREG32(0x6578, 0x10801);
-	WREG32(0x657C, 0x89408940);
-	WREG32(0x6578, 0x10802);
-	WREG32(0x657C, 0xBFE8BED8);
-	WREG32(0x6578, 0x20000);
-	WREG32(0x657C, 0x80008000);
-	WREG32(0x6578, 0x20001);
-	WREG32(0x657C, 0x90008000);
-	WREG32(0x6578, 0x20002);
-	WREG32(0x657C, 0x80008000);
-	WREG32(0x6578, 0x20003);
-	WREG32(0x657C, 0x80008000);
-	WREG32(0x6578, 0x20100);
-	WREG32(0x657C, 0x80108000);
-	WREG32(0x6578, 0x20101);
-	WREG32(0x657C, 0x8FE0BF70);
-	WREG32(0x6578, 0x20102);
-	WREG32(0x657C, 0xBFE880C0);
-	WREG32(0x6578, 0x20103);
-	WREG32(0x657C, 0x80008000);
-	WREG32(0x6578, 0x20200);
-	WREG32(0x657C, 0x8018BFF8);
-	WREG32(0x6578, 0x20201);
-	WREG32(0x657C, 0x8F80BF08);
-	WREG32(0x6578, 0x20202);
-	WREG32(0x657C, 0xBFD081A0);
-	WREG32(0x6578, 0x20203);
-	WREG32(0x657C, 0xBFF88000);
-	WREG32(0x6578, 0x20300);
-	WREG32(0x657C, 0x80188000);
-	WREG32(0x6578, 0x20301);
-	WREG32(0x657C, 0x8EE0BEC0);
-	WREG32(0x6578, 0x20302);
-	WREG32(0x657C, 0xBFB082A0);
-	WREG32(0x6578, 0x20303);
-	WREG32(0x657C, 0x80008000);
-	WREG32(0x6578, 0x20400);
-	WREG32(0x657C, 0x80188000);
-	WREG32(0x6578, 0x20401);
-	WREG32(0x657C, 0x8E00BEA0);
-	WREG32(0x6578, 0x20402);
-	WREG32(0x657C, 0xBF8883C0);
-	WREG32(0x6578, 0x20403);
-	WREG32(0x657C, 0x80008000);
-	WREG32(0x6578, 0x20500);
-	WREG32(0x657C, 0x80188000);
-	WREG32(0x6578, 0x20501);
-	WREG32(0x657C, 0x8D00BE90);
-	WREG32(0x6578, 0x20502);
-	WREG32(0x657C, 0xBF588500);
-	WREG32(0x6578, 0x20503);
-	WREG32(0x657C, 0x80008008);
-	WREG32(0x6578, 0x20600);
-	WREG32(0x657C, 0x80188000);
-	WREG32(0x6578, 0x20601);
-	WREG32(0x657C, 0x8BC0BE98);
-	WREG32(0x6578, 0x20602);
-	WREG32(0x657C, 0xBF308660);
-	WREG32(0x6578, 0x20603);
-	WREG32(0x657C, 0x80008008);
-	WREG32(0x6578, 0x20700);
-	WREG32(0x657C, 0x80108000);
-	WREG32(0x6578, 0x20701);
-	WREG32(0x657C, 0x8A80BEB0);
-	WREG32(0x6578, 0x20702);
-	WREG32(0x657C, 0xBF0087C0);
-	WREG32(0x6578, 0x20703);
-	WREG32(0x657C, 0x80008008);
-	WREG32(0x6578, 0x20800);
-	WREG32(0x657C, 0x80108000);
-	WREG32(0x6578, 0x20801);
-	WREG32(0x657C, 0x8920BED0);
-	WREG32(0x6578, 0x20802);
-	WREG32(0x657C, 0xBED08920);
-	WREG32(0x6578, 0x20803);
-	WREG32(0x657C, 0x80008010);
-	WREG32(0x6578, 0x30000);
-	WREG32(0x657C, 0x90008000);
-	WREG32(0x6578, 0x30001);
-	WREG32(0x657C, 0x80008000);
-	WREG32(0x6578, 0x30100);
-	WREG32(0x657C, 0x8FE0BF90);
-	WREG32(0x6578, 0x30101);
-	WREG32(0x657C, 0xBFF880A0);
-	WREG32(0x6578, 0x30200);
-	WREG32(0x657C, 0x8F60BF40);
-	WREG32(0x6578, 0x30201);
-	WREG32(0x657C, 0xBFE88180);
-	WREG32(0x6578, 0x30300);
-	WREG32(0x657C, 0x8EC0BF00);
-	WREG32(0x6578, 0x30301);
-	WREG32(0x657C, 0xBFC88280);
-	WREG32(0x6578, 0x30400);
-	WREG32(0x657C, 0x8DE0BEE0);
-	WREG32(0x6578, 0x30401);
-	WREG32(0x657C, 0xBFA083A0);
-	WREG32(0x6578, 0x30500);
-	WREG32(0x657C, 0x8CE0BED0);
-	WREG32(0x6578, 0x30501);
-	WREG32(0x657C, 0xBF7884E0);
-	WREG32(0x6578, 0x30600);
-	WREG32(0x657C, 0x8BA0BED8);
-	WREG32(0x6578, 0x30601);
-	WREG32(0x657C, 0xBF508640);
-	WREG32(0x6578, 0x30700);
-	WREG32(0x657C, 0x8A60BEE8);
-	WREG32(0x6578, 0x30701);
-	WREG32(0x657C, 0xBF2087A0);
-	WREG32(0x6578, 0x30800);
-	WREG32(0x657C, 0x8900BF00);
-	WREG32(0x6578, 0x30801);
-	WREG32(0x657C, 0xBF008900);
-}
-
 static void
 atombios_yuv_setup(struct drm_encoder *encoder, bool enable)
 {
@@ -1074,129 +843,6 @@ atombios_yuv_setup(struct drm_encoder *encoder, bool enable)
 }
 
 static void
-atombios_overscan_setup(struct drm_encoder *encoder,
-			struct drm_display_mode *mode,
-			struct drm_display_mode *adjusted_mode)
-{
-	struct drm_device *dev = encoder->dev;
-	struct radeon_device *rdev = dev->dev_private;
-	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
-	struct radeon_crtc *radeon_crtc = to_radeon_crtc(encoder->crtc);
-	SET_CRTC_OVERSCAN_PS_ALLOCATION args;
-	int index = GetIndexIntoMasterTable(COMMAND, SetCRTC_OverScan);
-
-	memset(&args, 0, sizeof(args));
-
-	args.usOverscanRight = 0;
-	args.usOverscanLeft = 0;
-	args.usOverscanBottom = 0;
-	args.usOverscanTop = 0;
-	args.ucCRTC = radeon_crtc->crtc_id;
-
-	if (radeon_encoder->flags & RADEON_USE_RMX) {
-		if (radeon_encoder->rmx_type == RMX_FULL) {
-			args.usOverscanRight = 0;
-			args.usOverscanLeft = 0;
-			args.usOverscanBottom = 0;
-			args.usOverscanTop = 0;
-		} else if (radeon_encoder->rmx_type == RMX_CENTER) {
-			args.usOverscanTop = (adjusted_mode->crtc_vdisplay - mode->crtc_vdisplay) / 2;
-			args.usOverscanBottom = (adjusted_mode->crtc_vdisplay - mode->crtc_vdisplay) / 2;
-			args.usOverscanLeft = (adjusted_mode->crtc_hdisplay - mode->crtc_hdisplay) / 2;
-			args.usOverscanRight = (adjusted_mode->crtc_hdisplay - mode->crtc_hdisplay) / 2;
-		} else if (radeon_encoder->rmx_type == RMX_ASPECT) {
-			int a1 = mode->crtc_vdisplay * adjusted_mode->crtc_hdisplay;
-			int a2 = adjusted_mode->crtc_vdisplay * mode->crtc_hdisplay;
-
-			if (a1 > a2) {
-				args.usOverscanLeft = (adjusted_mode->crtc_hdisplay - (a2 / mode->crtc_vdisplay)) / 2;
-				args.usOverscanRight = (adjusted_mode->crtc_hdisplay - (a2 / mode->crtc_vdisplay)) / 2;
-			} else if (a2 > a1) {
-				args.usOverscanLeft = (adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2;
-				args.usOverscanRight = (adjusted_mode->crtc_vdisplay - (a1 / mode->crtc_hdisplay)) / 2;
-			}
-		}
-	}
-
-	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
-
-}
-
-static void
-atombios_scaler_setup(struct drm_encoder *encoder)
-{
-	struct drm_device *dev = encoder->dev;
-	struct radeon_device *rdev = dev->dev_private;
-	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
-	struct radeon_crtc *radeon_crtc = to_radeon_crtc(encoder->crtc);
-	ENABLE_SCALER_PS_ALLOCATION args;
-	int index = GetIndexIntoMasterTable(COMMAND, EnableScaler);
-	/* fixme - fill in enc_priv for atom dac */
-	enum radeon_tv_std tv_std = TV_STD_NTSC;
-
-	if (!ASIC_IS_AVIVO(rdev) && radeon_crtc->crtc_id)
-		return;
-
-	memset(&args, 0, sizeof(args));
-
-	args.ucScaler = radeon_crtc->crtc_id;
-
-	if (radeon_encoder->devices & (ATOM_DEVICE_TV_SUPPORT)) {
-		switch (tv_std) {
-		case TV_STD_NTSC:
-		default:
-			args.ucTVStandard = ATOM_TV_NTSC;
-			break;
-		case TV_STD_PAL:
-			args.ucTVStandard = ATOM_TV_PAL;
-			break;
-		case TV_STD_PAL_M:
-			args.ucTVStandard = ATOM_TV_PALM;
-			break;
-		case TV_STD_PAL_60:
-			args.ucTVStandard = ATOM_TV_PAL60;
-			break;
-		case TV_STD_NTSC_J:
-			args.ucTVStandard = ATOM_TV_NTSCJ;
-			break;
-		case TV_STD_SCART_PAL:
-			args.ucTVStandard = ATOM_TV_PAL; /* ??? */
-			break;
-		case TV_STD_SECAM:
-			args.ucTVStandard = ATOM_TV_SECAM;
-			break;
-		case TV_STD_PAL_CN:
-			args.ucTVStandard = ATOM_TV_PALCN;
-			break;
-		}
-		args.ucEnable = SCALER_ENABLE_MULTITAP_MODE;
-	} else if (radeon_encoder->devices & (ATOM_DEVICE_CV_SUPPORT)) {
-		args.ucTVStandard = ATOM_TV_CV;
-		args.ucEnable = SCALER_ENABLE_MULTITAP_MODE;
-	} else if (radeon_encoder->flags & RADEON_USE_RMX) {
-		if (radeon_encoder->rmx_type == RMX_FULL)
-			args.ucEnable = ATOM_SCALER_EXPANSION;
-		else if (radeon_encoder->rmx_type == RMX_CENTER)
-			args.ucEnable = ATOM_SCALER_CENTER;
-		else if (radeon_encoder->rmx_type == RMX_ASPECT)
-			args.ucEnable = ATOM_SCALER_EXPANSION;
-	} else {
-		if (ASIC_IS_AVIVO(rdev))
-			args.ucEnable = ATOM_SCALER_DISABLE;
-		else
-			args.ucEnable = ATOM_SCALER_CENTER;
-	}
-
-	atom_execute_table(rdev->mode_info.atom_context, index, (uint32_t *)&args);
-
-	if (radeon_encoder->devices & (ATOM_DEVICE_CV_SUPPORT | ATOM_DEVICE_TV_SUPPORT)
-	    && rdev->family >= CHIP_RV515 && rdev->family <= CHIP_RV570) {
-		atom_rv515_force_tv_scaler(rdev);
-	}
-
-}
-
-static void
 radeon_atom_encoder_dpms(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
@@ -1448,8 +1094,6 @@ radeon_atom_encoder_mode_set(struct drm_encoder *encoder,
 	radeon_encoder->pixel_clock = adjusted_mode->clock;
 
 	radeon_atombios_encoder_crtc_scratch_regs(encoder, radeon_crtc->crtc_id);
-	atombios_overscan_setup(encoder, mode, adjusted_mode);
-	atombios_scaler_setup(encoder);
 	atombios_set_encoder_crtc_source(encoder);
 
 	if (ASIC_IS_AVIVO(rdev)) {
@@ -1667,6 +1311,7 @@ radeon_add_atom_encoder(struct drm_device *dev, uint32_t encoder_id, uint32_t su
 
 	radeon_encoder->encoder_id = encoder_id;
 	radeon_encoder->devices = supported_device;
+	radeon_encoder->rmx_type = RMX_OFF;
 
 	switch (radeon_encoder->encoder_id) {
 	case ENCODER_OBJECT_ID_INTERNAL_LVDS:
@@ -1700,14 +1345,8 @@ radeon_add_atom_encoder(struct drm_device *dev, uint32_t encoder_id, uint32_t su
 	case ENCODER_OBJECT_ID_INTERNAL_KLDSCP_LVTMA:
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY1:
 	case ENCODER_OBJECT_ID_INTERNAL_UNIPHY2:
-		if (radeon_encoder->devices & (ATOM_DEVICE_LCD_SUPPORT)) {
-			radeon_encoder->rmx_type = RMX_FULL;
-			drm_encoder_init(dev, encoder, &radeon_atom_enc_funcs, DRM_MODE_ENCODER_LVDS);
-			radeon_encoder->enc_priv = radeon_atombios_get_lvds_info(radeon_encoder);
-		} else {
-			drm_encoder_init(dev, encoder, &radeon_atom_enc_funcs, DRM_MODE_ENCODER_TMDS);
-			radeon_encoder->enc_priv = radeon_atombios_set_dig_info(radeon_encoder);
-		}
+		drm_encoder_init(dev, encoder, &radeon_atom_enc_funcs, DRM_MODE_ENCODER_TMDS);
+		radeon_encoder->enc_priv = radeon_atombios_set_dig_info(radeon_encoder);
 		drm_encoder_helper_add(encoder, &radeon_atom_dig_helper_funcs);
 		break;
 	}
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
index 14c1a51..06bda2f 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_crtc.c
@@ -29,6 +29,171 @@
 #include "radeon_fixed.h"
 #include "radeon.h"
 
+static void radeon_legacy_rmx_mode_set(struct drm_crtc *crtc,
+				       struct drm_display_mode *mode,
+				       struct drm_display_mode *adjusted_mode)
+{
+	struct drm_device *dev = crtc->dev;
+	struct radeon_device *rdev = dev->dev_private;
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	int xres = mode->hdisplay;
+	int yres = mode->vdisplay;
+	bool hscale = true, vscale = true;
+	int hsync_wid;
+	int vsync_wid;
+	int hsync_start;
+	int blank_width;
+	u32 scale, inc, crtc_more_cntl;
+	u32 fp_horz_stretch, fp_vert_stretch, fp_horz_vert_active;
+	u32 fp_h_sync_strt_wid, fp_crtc_h_total_disp;
+	u32 fp_v_sync_strt_wid, fp_crtc_v_total_disp;
+	struct radeon_native_mode *native_mode = &radeon_crtc->native_mode;
+
+	fp_vert_stretch = RREG32(RADEON_FP_VERT_STRETCH) &
+		(RADEON_VERT_STRETCH_RESERVED |
+		 RADEON_VERT_AUTO_RATIO_INC);
+	fp_horz_stretch = RREG32(RADEON_FP_HORZ_STRETCH) &
+		(RADEON_HORZ_FP_LOOP_STRETCH |
+		 RADEON_HORZ_AUTO_RATIO_INC);
+
+	crtc_more_cntl = 0;
+	if ((rdev->family == CHIP_RS100) ||
+	    (rdev->family == CHIP_RS200)) {
+		/* This is to workaround the asic bug for RMX, some versions
+		   of BIOS dosen't have this register initialized correctly. */
+		crtc_more_cntl |= RADEON_CRTC_H_CUTOFF_ACTIVE_EN;
+	}
+
+
+	fp_crtc_h_total_disp = ((((mode->crtc_htotal / 8) - 1) & 0x3ff)
+				| ((((mode->crtc_hdisplay / 8) - 1) & 0x1ff) << 16));
+
+	hsync_wid = (mode->crtc_hsync_end - mode->crtc_hsync_start) / 8;
+	if (!hsync_wid)
+		hsync_wid = 1;
+	hsync_start = mode->crtc_hsync_start - 8;
+
+	fp_h_sync_strt_wid = ((hsync_start & 0x1fff)
+			      | ((hsync_wid & 0x3f) << 16)
+			      | ((mode->flags & DRM_MODE_FLAG_NHSYNC)
+				 ? RADEON_CRTC_H_SYNC_POL
+				 : 0));
+
+	fp_crtc_v_total_disp = (((mode->crtc_vtotal - 1) & 0xffff)
+				| ((mode->crtc_vdisplay - 1) << 16));
+
+	vsync_wid = mode->crtc_vsync_end - mode->crtc_vsync_start;
+	if (!vsync_wid)
+		vsync_wid = 1;
+
+	fp_v_sync_strt_wid = (((mode->crtc_vsync_start - 1) & 0xfff)
+			      | ((vsync_wid & 0x1f) << 16)
+			      | ((mode->flags & DRM_MODE_FLAG_NVSYNC)
+				 ? RADEON_CRTC_V_SYNC_POL
+				 : 0));
+
+	fp_horz_vert_active = 0;
+
+	if (native_mode->panel_xres == 0 ||
+	    native_mode->panel_yres == 0) {
+		hscale = false;
+		vscale = false;
+	} else {
+		if (xres > native_mode->panel_xres)
+			xres = native_mode->panel_xres;
+		if (yres > native_mode->panel_yres)
+			yres = native_mode->panel_yres;
+
+		if (xres == native_mode->panel_xres)
+			hscale = false;
+		if (yres == native_mode->panel_yres)
+			vscale = false;
+	}
+
+	switch (radeon_crtc->rmx_type) {
+	case RMX_FULL:
+	case RMX_ASPECT:
+		if (!hscale)
+			fp_horz_stretch |= ((xres/8-1) << 16);
+		else {
+			inc = (fp_horz_stretch & RADEON_HORZ_AUTO_RATIO_INC) ? 1 : 0;
+			scale = ((xres + inc) * RADEON_HORZ_STRETCH_RATIO_MAX)
+				/ native_mode->panel_xres + 1;
+			fp_horz_stretch |= (((scale) & RADEON_HORZ_STRETCH_RATIO_MASK) |
+					RADEON_HORZ_STRETCH_BLEND |
+					RADEON_HORZ_STRETCH_ENABLE |
+					((native_mode->panel_xres/8-1) << 16));
+		}
+
+		if (!vscale)
+			fp_vert_stretch |= ((yres-1) << 12);
+		else {
+			inc = (fp_vert_stretch & RADEON_VERT_AUTO_RATIO_INC) ? 1 : 0;
+			scale = ((yres + inc) * RADEON_VERT_STRETCH_RATIO_MAX)
+				/ native_mode->panel_yres + 1;
+			fp_vert_stretch |= (((scale) & RADEON_VERT_STRETCH_RATIO_MASK) |
+					RADEON_VERT_STRETCH_ENABLE |
+					RADEON_VERT_STRETCH_BLEND |
+					((native_mode->panel_yres-1) << 12));
+		}
+		break;
+	case RMX_CENTER:
+		fp_horz_stretch |= ((xres/8-1) << 16);
+		fp_vert_stretch |= ((yres-1) << 12);
+
+		crtc_more_cntl |= (RADEON_CRTC_AUTO_HORZ_CENTER_EN |
+				RADEON_CRTC_AUTO_VERT_CENTER_EN);
+
+		blank_width = (mode->crtc_hblank_end - mode->crtc_hblank_start) / 8;
+		if (blank_width > 110)
+			blank_width = 110;
+
+		fp_crtc_h_total_disp = (((blank_width) & 0x3ff)
+				| ((((mode->crtc_hdisplay / 8) - 1) & 0x1ff) << 16));
+
+		hsync_wid = (mode->crtc_hsync_end - mode->crtc_hsync_start) / 8;
+		if (!hsync_wid)
+			hsync_wid = 1;
+
+		fp_h_sync_strt_wid = ((((mode->crtc_hsync_start - mode->crtc_hblank_start) / 8) & 0x1fff)
+				| ((hsync_wid & 0x3f) << 16)
+				| ((mode->flags & DRM_MODE_FLAG_NHSYNC)
+					? RADEON_CRTC_H_SYNC_POL
+					: 0));
+
+		fp_crtc_v_total_disp = (((mode->crtc_vblank_end - mode->crtc_vblank_start) & 0xffff)
+				| ((mode->crtc_vdisplay - 1) << 16));
+
+		vsync_wid = mode->crtc_vsync_end - mode->crtc_vsync_start;
+		if (!vsync_wid)
+			vsync_wid = 1;
+
+		fp_v_sync_strt_wid = ((((mode->crtc_vsync_start - mode->crtc_vblank_start) & 0xfff)
+					| ((vsync_wid & 0x1f) << 16)
+					| ((mode->flags & DRM_MODE_FLAG_NVSYNC)
+						? RADEON_CRTC_V_SYNC_POL
+						: 0)));
+
+		fp_horz_vert_active = (((native_mode->panel_yres) & 0xfff) |
+				(((native_mode->panel_xres / 8) & 0x1ff) << 16));
+		break;
+	case RMX_OFF:
+	default:
+		fp_horz_stretch |= ((xres/8-1) << 16);
+		fp_vert_stretch |= ((yres-1) << 12);
+		break;
+	}
+
+	WREG32(RADEON_FP_HORZ_STRETCH,      fp_horz_stretch);
+	WREG32(RADEON_FP_VERT_STRETCH,      fp_vert_stretch);
+	WREG32(RADEON_CRTC_MORE_CNTL,       crtc_more_cntl);
+	WREG32(RADEON_FP_HORZ_VERT_ACTIVE,  fp_horz_vert_active);
+	WREG32(RADEON_FP_H_SYNC_STRT_WID,   fp_h_sync_strt_wid);
+	WREG32(RADEON_FP_V_SYNC_STRT_WID,   fp_v_sync_strt_wid);
+	WREG32(RADEON_FP_CRTC_H_TOTAL_DISP, fp_crtc_h_total_disp);
+	WREG32(RADEON_FP_CRTC_V_TOTAL_DISP, fp_crtc_v_total_disp);
+}
+
 void radeon_restore_common_regs(struct drm_device *dev)
 {
 	/* don't need this yet */
@@ -754,6 +919,8 @@ static bool radeon_crtc_mode_fixup(struct drm_crtc *crtc,
 				   struct drm_display_mode *mode,
 				   struct drm_display_mode *adjusted_mode)
 {
+	if (!radeon_crtc_scaling_mode_fixup(crtc, mode, adjusted_mode))
+		return false;
 	return true;
 }
 
@@ -762,16 +929,25 @@ static int radeon_crtc_mode_set(struct drm_crtc *crtc,
 				 struct drm_display_mode *adjusted_mode,
 				 int x, int y, struct drm_framebuffer *old_fb)
 {
-
-	DRM_DEBUG("\n");
+	struct radeon_crtc *radeon_crtc = to_radeon_crtc(crtc);
+	struct drm_device *dev = crtc->dev;
+	struct radeon_device *rdev = dev->dev_private;
 
 	/* TODO TV */
-
 	radeon_crtc_set_base(crtc, x, y, old_fb);
 	radeon_set_crtc_timing(crtc, adjusted_mode);
 	radeon_set_pll(crtc, adjusted_mode);
-	radeon_init_disp_bandwidth(crtc->dev);
-
+	radeon_bandwidth_update(rdev);
+	if (radeon_crtc->crtc_id == 0) {
+		radeon_legacy_rmx_mode_set(crtc, mode, adjusted_mode);
+	} else {
+		if (radeon_crtc->rmx_type != RMX_OFF) {
+			/* FIXME: only first crtc has rmx what should we
+			 * do ?
+			 */
+			DRM_ERROR("Mode need scaling but only first crtc can do that.\n");
+		}
+	}
 	return 0;
 }
 
@@ -802,478 +978,3 @@ void radeon_legacy_init_crtc(struct drm_device *dev,
 		radeon_crtc->crtc_offset = RADEON_CRTC2_H_TOTAL_DISP - RADEON_CRTC_H_TOTAL_DISP;
 	drm_crtc_helper_add(&radeon_crtc->base, &legacy_helper_funcs);
 }
-
-void radeon_init_disp_bw_legacy(struct drm_device *dev,
-				struct drm_display_mode *mode1,
-				uint32_t pixel_bytes1,
-				struct drm_display_mode *mode2,
-				uint32_t pixel_bytes2)
-{
-	struct radeon_device *rdev = dev->dev_private;
-	fixed20_12 trcd_ff, trp_ff, tras_ff, trbs_ff, tcas_ff;
-	fixed20_12 sclk_ff, mclk_ff, sclk_eff_ff, sclk_delay_ff;
-	fixed20_12 peak_disp_bw, mem_bw, pix_clk, pix_clk2, temp_ff, crit_point_ff;
-	uint32_t temp, data, mem_trcd, mem_trp, mem_tras;
-	fixed20_12 memtcas_ff[8] = {
-		fixed_init(1),
-		fixed_init(2),
-		fixed_init(3),
-		fixed_init(0),
-		fixed_init_half(1),
-		fixed_init_half(2),
-		fixed_init(0),
-	};
-	fixed20_12 memtcas_rs480_ff[8] = {
-		fixed_init(0),
-		fixed_init(1),
-		fixed_init(2),
-		fixed_init(3),
-		fixed_init(0),
-		fixed_init_half(1),
-		fixed_init_half(2),
-		fixed_init_half(3),
-	};
-	fixed20_12 memtcas2_ff[8] = {
-		fixed_init(0),
-		fixed_init(1),
-		fixed_init(2),
-		fixed_init(3),
-		fixed_init(4),
-		fixed_init(5),
-		fixed_init(6),
-		fixed_init(7),
-	};
-	fixed20_12 memtrbs[8] = {
-		fixed_init(1),
-		fixed_init_half(1),
-		fixed_init(2),
-		fixed_init_half(2),
-		fixed_init(3),
-		fixed_init_half(3),
-		fixed_init(4),
-		fixed_init_half(4)
-	};
-	fixed20_12 memtrbs_r4xx[8] = {
-		fixed_init(4),
-		fixed_init(5),
-		fixed_init(6),
-		fixed_init(7),
-		fixed_init(8),
-		fixed_init(9),
-		fixed_init(10),
-		fixed_init(11)
-	};
-	fixed20_12 min_mem_eff;
-	fixed20_12 mc_latency_sclk, mc_latency_mclk, k1;
-	fixed20_12 cur_latency_mclk, cur_latency_sclk;
-	fixed20_12 disp_latency, disp_latency_overhead, disp_drain_rate,
-		disp_drain_rate2, read_return_rate;
-	fixed20_12 time_disp1_drop_priority;
-	int c;
-	int cur_size = 16;       /* in octawords */
-	int critical_point = 0, critical_point2;
-/* 	uint32_t read_return_rate, time_disp1_drop_priority; */
-	int stop_req, max_stop_req;
-
-	min_mem_eff.full = rfixed_const_8(0);
-	/* get modes */
-	if ((rdev->disp_priority == 2) && ASIC_IS_R300(rdev)) {
-		uint32_t mc_init_misc_lat_timer = RREG32(R300_MC_INIT_MISC_LAT_TIMER);
-		mc_init_misc_lat_timer &= ~(R300_MC_DISP1R_INIT_LAT_MASK << R300_MC_DISP1R_INIT_LAT_SHIFT);
-		mc_init_misc_lat_timer &= ~(R300_MC_DISP0R_INIT_LAT_MASK << R300_MC_DISP0R_INIT_LAT_SHIFT);
-		/* check crtc enables */
-		if (mode2)
-			mc_init_misc_lat_timer |= (1 << R300_MC_DISP1R_INIT_LAT_SHIFT);
-		if (mode1)
-			mc_init_misc_lat_timer |= (1 << R300_MC_DISP0R_INIT_LAT_SHIFT);
-		WREG32(R300_MC_INIT_MISC_LAT_TIMER, mc_init_misc_lat_timer);
-	}
-
-	/*
-	 * determine is there is enough bw for current mode
-	 */
-	mclk_ff.full = rfixed_const(rdev->clock.default_mclk);
-	temp_ff.full = rfixed_const(100);
-	mclk_ff.full = rfixed_div(mclk_ff, temp_ff);
-	sclk_ff.full = rfixed_const(rdev->clock.default_sclk);
-	sclk_ff.full = rfixed_div(sclk_ff, temp_ff);
-
-	temp = (rdev->mc.vram_width / 8) * (rdev->mc.vram_is_ddr ? 2 : 1);
-	temp_ff.full = rfixed_const(temp);
-	mem_bw.full = rfixed_mul(mclk_ff, temp_ff);
-
-	pix_clk.full = 0;
-	pix_clk2.full = 0;
-	peak_disp_bw.full = 0;
-	if (mode1) {
-		temp_ff.full = rfixed_const(1000);
-		pix_clk.full = rfixed_const(mode1->clock); /* convert to fixed point */
-		pix_clk.full = rfixed_div(pix_clk, temp_ff);
-		temp_ff.full = rfixed_const(pixel_bytes1);
-		peak_disp_bw.full += rfixed_mul(pix_clk, temp_ff);
-	}
-	if (mode2) {
-		temp_ff.full = rfixed_const(1000);
-		pix_clk2.full = rfixed_const(mode2->clock); /* convert to fixed point */
-		pix_clk2.full = rfixed_div(pix_clk2, temp_ff);
-		temp_ff.full = rfixed_const(pixel_bytes2);
-		peak_disp_bw.full += rfixed_mul(pix_clk2, temp_ff);
-	}
-
-	mem_bw.full = rfixed_mul(mem_bw, min_mem_eff);
-	if (peak_disp_bw.full >= mem_bw.full) {
-		DRM_ERROR("You may not have enough display bandwidth for current mode\n"
-			  "If you have flickering problem, try to lower resolution, refresh rate, or color depth\n");
-	}
-
-	/*  Get values from the EXT_MEM_CNTL register...converting its contents. */
-	temp = RREG32(RADEON_MEM_TIMING_CNTL);
-	if ((rdev->family == CHIP_RV100) || (rdev->flags & RADEON_IS_IGP)) { /* RV100, M6, IGPs */
-		mem_trcd = ((temp >> 2) & 0x3) + 1;
-		mem_trp  = ((temp & 0x3)) + 1;
-		mem_tras = ((temp & 0x70) >> 4) + 1;
-	} else if (rdev->family == CHIP_R300 ||
-		   rdev->family == CHIP_R350) { /* r300, r350 */
-		mem_trcd = (temp & 0x7) + 1;
-		mem_trp = ((temp >> 8) & 0x7) + 1;
-		mem_tras = ((temp >> 11) & 0xf) + 4;
-	} else if (rdev->family == CHIP_RV350 ||
-		   rdev->family <= CHIP_RV380) {
-		/* rv3x0 */
-		mem_trcd = (temp & 0x7) + 3;
-		mem_trp = ((temp >> 8) & 0x7) + 3;
-		mem_tras = ((temp >> 11) & 0xf) + 6;
-	} else if (rdev->family == CHIP_R420 ||
-		   rdev->family == CHIP_R423 ||
-		   rdev->family == CHIP_RV410) {
-		/* r4xx */
-		mem_trcd = (temp & 0xf) + 3;
-		if (mem_trcd > 15)
-			mem_trcd = 15;
-		mem_trp = ((temp >> 8) & 0xf) + 3;
-		if (mem_trp > 15)
-			mem_trp = 15;
-		mem_tras = ((temp >> 12) & 0x1f) + 6;
-		if (mem_tras > 31)
-			mem_tras = 31;
-	} else { /* RV200, R200 */
-		mem_trcd = (temp & 0x7) + 1;
-		mem_trp = ((temp >> 8) & 0x7) + 1;
-		mem_tras = ((temp >> 12) & 0xf) + 4;
-	}
-	/* convert to FF */
-	trcd_ff.full = rfixed_const(mem_trcd);
-	trp_ff.full = rfixed_const(mem_trp);
-	tras_ff.full = rfixed_const(mem_tras);
-
-	/* Get values from the MEM_SDRAM_MODE_REG register...converting its */
-	temp = RREG32(RADEON_MEM_SDRAM_MODE_REG);
-	data = (temp & (7 << 20)) >> 20;
-	if ((rdev->family == CHIP_RV100) || rdev->flags & RADEON_IS_IGP) {
-		if (rdev->family == CHIP_RS480) /* don't think rs400 */
-			tcas_ff = memtcas_rs480_ff[data];
-		else
-			tcas_ff = memtcas_ff[data];
-	} else
-		tcas_ff = memtcas2_ff[data];
-
-	if (rdev->family == CHIP_RS400 ||
-	    rdev->family == CHIP_RS480) {
-		/* extra cas latency stored in bits 23-25 0-4 clocks */
-		data = (temp >> 23) & 0x7;
-		if (data < 5)
-			tcas_ff.full += rfixed_const(data);
-	}
-
-	if (ASIC_IS_R300(rdev) && !(rdev->flags & RADEON_IS_IGP)) {
-		/* on the R300, Tcas is included in Trbs.
-		 */
-		temp = RREG32(RADEON_MEM_CNTL);
-		data = (R300_MEM_NUM_CHANNELS_MASK & temp);
-		if (data == 1) {
-			if (R300_MEM_USE_CD_CH_ONLY & temp) {
-				temp = RREG32(R300_MC_IND_INDEX);
-				temp &= ~R300_MC_IND_ADDR_MASK;
-				temp |= R300_MC_READ_CNTL_CD_mcind;
-				WREG32(R300_MC_IND_INDEX, temp);
-				temp = RREG32(R300_MC_IND_DATA);
-				data = (R300_MEM_RBS_POSITION_C_MASK & temp);
-			} else {
-				temp = RREG32(R300_MC_READ_CNTL_AB);
-				data = (R300_MEM_RBS_POSITION_A_MASK & temp);
-			}
-		} else {
-			temp = RREG32(R300_MC_READ_CNTL_AB);
-			data = (R300_MEM_RBS_POSITION_A_MASK & temp);
-		}
-		if (rdev->family == CHIP_RV410 ||
-		    rdev->family == CHIP_R420 ||
-		    rdev->family == CHIP_R423)
-			trbs_ff = memtrbs_r4xx[data];
-		else
-			trbs_ff = memtrbs[data];
-		tcas_ff.full += trbs_ff.full;
-	}
-
-	sclk_eff_ff.full = sclk_ff.full;
-
-	if (rdev->flags & RADEON_IS_AGP) {
-		fixed20_12 agpmode_ff;
-		agpmode_ff.full = rfixed_const(radeon_agpmode);
-		temp_ff.full = rfixed_const_666(16);
-		sclk_eff_ff.full -= rfixed_mul(agpmode_ff, temp_ff);
-	}
-	/* TODO PCIE lanes may affect this - agpmode == 16?? */
-
-	if (ASIC_IS_R300(rdev)) {
-		sclk_delay_ff.full = rfixed_const(250);
-	} else {
-		if ((rdev->family == CHIP_RV100) ||
-		    rdev->flags & RADEON_IS_IGP) {
-			if (rdev->mc.vram_is_ddr)
-				sclk_delay_ff.full = rfixed_const(41);
-			else
-				sclk_delay_ff.full = rfixed_const(33);
-		} else {
-			if (rdev->mc.vram_width == 128)
-				sclk_delay_ff.full = rfixed_const(57);
-			else
-				sclk_delay_ff.full = rfixed_const(41);
-		}
-	}
-
-	mc_latency_sclk.full = rfixed_div(sclk_delay_ff, sclk_eff_ff);
-
-	if (rdev->mc.vram_is_ddr) {
-		if (rdev->mc.vram_width == 32) {
-			k1.full = rfixed_const(40);
-			c  = 3;
-		} else {
-			k1.full = rfixed_const(20);
-			c  = 1;
-		}
-	} else {
-		k1.full = rfixed_const(40);
-		c  = 3;
-	}
-
-	temp_ff.full = rfixed_const(2);
-	mc_latency_mclk.full = rfixed_mul(trcd_ff, temp_ff);
-	temp_ff.full = rfixed_const(c);
-	mc_latency_mclk.full += rfixed_mul(tcas_ff, temp_ff);
-	temp_ff.full = rfixed_const(4);
-	mc_latency_mclk.full += rfixed_mul(tras_ff, temp_ff);
-	mc_latency_mclk.full += rfixed_mul(trp_ff, temp_ff);
-	mc_latency_mclk.full += k1.full;
-
-	mc_latency_mclk.full = rfixed_div(mc_latency_mclk, mclk_ff);
-	mc_latency_mclk.full += rfixed_div(temp_ff, sclk_eff_ff);
-
-	/*
-	  HW cursor time assuming worst case of full size colour cursor.
-	*/
-	temp_ff.full = rfixed_const((2 * (cur_size - (rdev->mc.vram_is_ddr + 1))));
-	temp_ff.full += trcd_ff.full;
-	if (temp_ff.full < tras_ff.full)
-		temp_ff.full = tras_ff.full;
-	cur_latency_mclk.full = rfixed_div(temp_ff, mclk_ff);
-
-	temp_ff.full = rfixed_const(cur_size);
-	cur_latency_sclk.full = rfixed_div(temp_ff, sclk_eff_ff);
-	/*
-	  Find the total latency for the display data.
-	*/
-	disp_latency_overhead.full = rfixed_const(80);
-	disp_latency_overhead.full = rfixed_div(disp_latency_overhead, sclk_ff);
-	mc_latency_mclk.full += disp_latency_overhead.full + cur_latency_mclk.full;
-	mc_latency_sclk.full += disp_latency_overhead.full + cur_latency_sclk.full;
-
-	if (mc_latency_mclk.full > mc_latency_sclk.full)
-		disp_latency.full = mc_latency_mclk.full;
-	else
-		disp_latency.full = mc_latency_sclk.full;
-
-	/* setup Max GRPH_STOP_REQ default value */
-	if (ASIC_IS_RV100(rdev))
-		max_stop_req = 0x5c;
-	else
-		max_stop_req = 0x7c;
-
-	if (mode1) {
-		/*  CRTC1
-		    Set GRPH_BUFFER_CNTL register using h/w defined optimal values.
-		    GRPH_STOP_REQ <= MIN[ 0x7C, (CRTC_H_DISP + 1) * (bit depth) / 0x10 ]
-		*/
-		stop_req = mode1->hdisplay * pixel_bytes1 / 16;
-
-		if (stop_req > max_stop_req)
-			stop_req = max_stop_req;
-
-		/*
-		  Find the drain rate of the display buffer.
-		*/
-		temp_ff.full = rfixed_const((16/pixel_bytes1));
-		disp_drain_rate.full = rfixed_div(pix_clk, temp_ff);
-
-		/*
-		  Find the critical point of the display buffer.
-		*/
-		crit_point_ff.full = rfixed_mul(disp_drain_rate, disp_latency);
-		crit_point_ff.full += rfixed_const_half(0);
-
-		critical_point = rfixed_trunc(crit_point_ff);
-
-		if (rdev->disp_priority == 2) {
-			critical_point = 0;
-		}
-
-		/*
-		  The critical point should never be above max_stop_req-4.  Setting
-		  GRPH_CRITICAL_CNTL = 0 will thus force high priority all the time.
-		*/
-		if (max_stop_req - critical_point < 4)
-			critical_point = 0;
-
-		if (critical_point == 0 && mode2 && rdev->family == CHIP_R300) {
-			/* some R300 cards have problem with this set to 0, when CRTC2 is enabled.*/
-			critical_point = 0x10;
-		}
-
-		temp = RREG32(RADEON_GRPH_BUFFER_CNTL);
-		temp &= ~(RADEON_GRPH_STOP_REQ_MASK);
-		temp |= (stop_req << RADEON_GRPH_STOP_REQ_SHIFT);
-		temp &= ~(RADEON_GRPH_START_REQ_MASK);
-		if ((rdev->family == CHIP_R350) &&
-		    (stop_req > 0x15)) {
-			stop_req -= 0x10;
-		}
-		temp |= (stop_req << RADEON_GRPH_START_REQ_SHIFT);
-		temp |= RADEON_GRPH_BUFFER_SIZE;
-		temp &= ~(RADEON_GRPH_CRITICAL_CNTL   |
-			  RADEON_GRPH_CRITICAL_AT_SOF |
-			  RADEON_GRPH_STOP_CNTL);
-		/*
-		  Write the result into the register.
-		*/
-		WREG32(RADEON_GRPH_BUFFER_CNTL, ((temp & ~RADEON_GRPH_CRITICAL_POINT_MASK) |
-						       (critical_point << RADEON_GRPH_CRITICAL_POINT_SHIFT)));
-
-#if 0
-		if ((rdev->family == CHIP_RS400) ||
-		    (rdev->family == CHIP_RS480)) {
-			/* attempt to program RS400 disp regs correctly ??? */
-			temp = RREG32(RS400_DISP1_REG_CNTL);
-			temp &= ~(RS400_DISP1_START_REQ_LEVEL_MASK |
-				  RS400_DISP1_STOP_REQ_LEVEL_MASK);
-			WREG32(RS400_DISP1_REQ_CNTL1, (temp |
-						       (critical_point << RS400_DISP1_START_REQ_LEVEL_SHIFT) |
-						       (critical_point << RS400_DISP1_STOP_REQ_LEVEL_SHIFT)));
-			temp = RREG32(RS400_DMIF_MEM_CNTL1);
-			temp &= ~(RS400_DISP1_CRITICAL_POINT_START_MASK |
-				  RS400_DISP1_CRITICAL_POINT_STOP_MASK);
-			WREG32(RS400_DMIF_MEM_CNTL1, (temp |
-						      (critical_point << RS400_DISP1_CRITICAL_POINT_START_SHIFT) |
-						      (critical_point << RS400_DISP1_CRITICAL_POINT_STOP_SHIFT)));
-		}
-#endif
-
-		DRM_DEBUG("GRPH_BUFFER_CNTL from to %x\n",
-			  /* 	  (unsigned int)info->SavedReg->grph_buffer_cntl, */
-			  (unsigned int)RREG32(RADEON_GRPH_BUFFER_CNTL));
-	}
-
-	if (mode2) {
-		u32 grph2_cntl;
-		stop_req = mode2->hdisplay * pixel_bytes2 / 16;
-
-		if (stop_req > max_stop_req)
-			stop_req = max_stop_req;
-
-		/*
-		  Find the drain rate of the display buffer.
-		*/
-		temp_ff.full = rfixed_const((16/pixel_bytes2));
-		disp_drain_rate2.full = rfixed_div(pix_clk2, temp_ff);
-
-		grph2_cntl = RREG32(RADEON_GRPH2_BUFFER_CNTL);
-		grph2_cntl &= ~(RADEON_GRPH_STOP_REQ_MASK);
-		grph2_cntl |= (stop_req << RADEON_GRPH_STOP_REQ_SHIFT);
-		grph2_cntl &= ~(RADEON_GRPH_START_REQ_MASK);
-		if ((rdev->family == CHIP_R350) &&
-		    (stop_req > 0x15)) {
-			stop_req -= 0x10;
-		}
-		grph2_cntl |= (stop_req << RADEON_GRPH_START_REQ_SHIFT);
-		grph2_cntl |= RADEON_GRPH_BUFFER_SIZE;
-		grph2_cntl &= ~(RADEON_GRPH_CRITICAL_CNTL   |
-			  RADEON_GRPH_CRITICAL_AT_SOF |
-			  RADEON_GRPH_STOP_CNTL);
-
-		if ((rdev->family == CHIP_RS100) ||
-		    (rdev->family == CHIP_RS200))
-			critical_point2 = 0;
-		else {
-			temp = (rdev->mc.vram_width * rdev->mc.vram_is_ddr + 1)/128;
-			temp_ff.full = rfixed_const(temp);
-			temp_ff.full = rfixed_mul(mclk_ff, temp_ff);
-			if (sclk_ff.full < temp_ff.full)
-				temp_ff.full = sclk_ff.full;
-
-			read_return_rate.full = temp_ff.full;
-
-			if (mode1) {
-				temp_ff.full = read_return_rate.full - disp_drain_rate.full;
-				time_disp1_drop_priority.full = rfixed_div(crit_point_ff, temp_ff);
-			} else {
-				time_disp1_drop_priority.full = 0;
-			}
-			crit_point_ff.full = disp_latency.full + time_disp1_drop_priority.full + disp_latency.full;
-			crit_point_ff.full = rfixed_mul(crit_point_ff, disp_drain_rate2);
-			crit_point_ff.full += rfixed_const_half(0);
-
-			critical_point2 = rfixed_trunc(crit_point_ff);
-
-			if (rdev->disp_priority == 2) {
-				critical_point2 = 0;
-			}
-
-			if (max_stop_req - critical_point2 < 4)
-				critical_point2 = 0;
-
-		}
-
-		if (critical_point2 == 0 && rdev->family == CHIP_R300) {
-			/* some R300 cards have problem with this set to 0 */
-			critical_point2 = 0x10;
-		}
-
-		WREG32(RADEON_GRPH2_BUFFER_CNTL, ((grph2_cntl & ~RADEON_GRPH_CRITICAL_POINT_MASK) |
-						  (critical_point2 << RADEON_GRPH_CRITICAL_POINT_SHIFT)));
-
-		if ((rdev->family == CHIP_RS400) ||
-		    (rdev->family == CHIP_RS480)) {
-#if 0
-			/* attempt to program RS400 disp2 regs correctly ??? */
-			temp = RREG32(RS400_DISP2_REQ_CNTL1);
-			temp &= ~(RS400_DISP2_START_REQ_LEVEL_MASK |
-				  RS400_DISP2_STOP_REQ_LEVEL_MASK);
-			WREG32(RS400_DISP2_REQ_CNTL1, (temp |
-						       (critical_point2 << RS400_DISP1_START_REQ_LEVEL_SHIFT) |
-						       (critical_point2 << RS400_DISP1_STOP_REQ_LEVEL_SHIFT)));
-			temp = RREG32(RS400_DISP2_REQ_CNTL2);
-			temp &= ~(RS400_DISP2_CRITICAL_POINT_START_MASK |
-				  RS400_DISP2_CRITICAL_POINT_STOP_MASK);
-			WREG32(RS400_DISP2_REQ_CNTL2, (temp |
-						       (critical_point2 << RS400_DISP2_CRITICAL_POINT_START_SHIFT) |
-						       (critical_point2 << RS400_DISP2_CRITICAL_POINT_STOP_SHIFT)));
-#endif
-			WREG32(RS400_DISP2_REQ_CNTL1, 0x105DC1CC);
-			WREG32(RS400_DISP2_REQ_CNTL2, 0x2749D000);
-			WREG32(RS400_DMIF_MEM_CNTL1,  0x29CA71DC);
-			WREG32(RS400_DISP1_REQ_CNTL1, 0x28FBC3AC);
-		}
-
-		DRM_DEBUG("GRPH2_BUFFER_CNTL from to %x\n",
-			  (unsigned int)RREG32(RADEON_GRPH2_BUFFER_CNTL));
-	}
-}
diff --git a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
index 2c2f42d..34d0f58 100644
--- a/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
+++ b/drivers/gpu/drm/radeon/radeon_legacy_encoders.c
@@ -30,170 +30,6 @@
 #include "atom.h"
 
 
-static void radeon_legacy_rmx_mode_set(struct drm_encoder *encoder,
-				       struct drm_display_mode *mode,
-				       struct drm_display_mode *adjusted_mode)
-{
-	struct drm_device *dev = encoder->dev;
-	struct radeon_device *rdev = dev->dev_private;
-	struct radeon_encoder *radeon_encoder = to_radeon_encoder(encoder);
-	int    xres = mode->hdisplay;
-	int    yres = mode->vdisplay;
-	bool   hscale = true, vscale = true;
-	int    hsync_wid;
-	int    vsync_wid;
-	int    hsync_start;
-	uint32_t scale, inc;
-	uint32_t fp_horz_stretch, fp_vert_stretch, crtc_more_cntl, fp_horz_vert_active;
-	uint32_t fp_h_sync_strt_wid, fp_v_sync_strt_wid, fp_crtc_h_total_disp, fp_crtc_v_total_disp;
-	struct radeon_native_mode *native_mode = &radeon_encoder->native_mode;
-
-	DRM_DEBUG("\n");
-
-	fp_vert_stretch = RREG32(RADEON_FP_VERT_STRETCH) &
-		(RADEON_VERT_STRETCH_RESERVED |
-		 RADEON_VERT_AUTO_RATIO_INC);
-	fp_horz_stretch = RREG32(RADEON_FP_HORZ_STRETCH) &
-		(RADEON_HORZ_FP_LOOP_STRETCH |
-		 RADEON_HORZ_AUTO_RATIO_INC);
-
-	crtc_more_cntl = 0;
-	if ((rdev->family == CHIP_RS100) ||
-	    (rdev->family == CHIP_RS200)) {
-		/* This is to workaround the asic bug for RMX, some versions
-		   of BIOS dosen't have this register initialized correctly. */
-		crtc_more_cntl |= RADEON_CRTC_H_CUTOFF_ACTIVE_EN;
-	}
-
-
-	fp_crtc_h_total_disp = ((((mode->crtc_htotal / 8) - 1) & 0x3ff)
-				| ((((mode->crtc_hdisplay / 8) - 1) & 0x1ff) << 16));
-
-	hsync_wid = (mode->crtc_hsync_end - mode->crtc_hsync_start) / 8;
-	if (!hsync_wid)
-		hsync_wid = 1;
-	hsync_start = mode->crtc_hsync_start - 8;
-
-	fp_h_sync_strt_wid = ((hsync_start & 0x1fff)
-			      | ((hsync_wid & 0x3f) << 16)
-			      | ((mode->flags & DRM_MODE_FLAG_NHSYNC)
-				 ? RADEON_CRTC_H_SYNC_POL
-				 : 0));
-
-	fp_crtc_v_total_disp = (((mode->crtc_vtotal - 1) & 0xffff)
-				| ((mode->crtc_vdisplay - 1) << 16));
-
-	vsync_wid = mode->crtc_vsync_end - mode->crtc_vsync_start;
-	if (!vsync_wid)
-		vsync_wid = 1;
-
-	fp_v_sync_strt_wid = (((mode->crtc_vsync_start - 1) & 0xfff)
-			      | ((vsync_wid & 0x1f) << 16)
-			      | ((mode->flags & DRM_MODE_FLAG_NVSYNC)
-				 ? RADEON_CRTC_V_SYNC_POL
-				 : 0));
-
-	fp_horz_vert_active = 0;
-
-	if (native_mode->panel_xres == 0 ||
-	    native_mode->panel_yres == 0) {
-		hscale = false;
-		vscale = false;
-	} else {
-		if (xres > native_mode->panel_xres)
-			xres = native_mode->panel_xres;
-		if (yres > native_mode->panel_yres)
-			yres = native_mode->panel_yres;
-
-		if (xres == native_mode->panel_xres)
-			hscale = false;
-		if (yres == native_mode->panel_yres)
-			vscale = false;
-	}
-
-	if (radeon_encoder->flags & RADEON_USE_RMX) {
-		if (radeon_encoder->rmx_type != RMX_CENTER) {
-			if (!hscale)
-				fp_horz_stretch |= ((xres/8-1) << 16);
-			else {
-				inc = (fp_horz_stretch & RADEON_HORZ_AUTO_RATIO_INC) ? 1 : 0;
-				scale = ((xres + inc) * RADEON_HORZ_STRETCH_RATIO_MAX)
-					/ native_mode->panel_xres + 1;
-				fp_horz_stretch |= (((scale) & RADEON_HORZ_STRETCH_RATIO_MASK) |
-						    RADEON_HORZ_STRETCH_BLEND |
-						    RADEON_HORZ_STRETCH_ENABLE |
-						    ((native_mode->panel_xres/8-1) << 16));
-			}
-
-			if (!vscale)
-				fp_vert_stretch |= ((yres-1) << 12);
-			else {
-				inc = (fp_vert_stretch & RADEON_VERT_AUTO_RATIO_INC) ? 1 : 0;
-				scale = ((yres + inc) * RADEON_VERT_STRETCH_RATIO_MAX)
-					/ native_mode->panel_yres + 1;
-				fp_vert_stretch |= (((scale) & RADEON_VERT_STRETCH_RATIO_MASK) |
-						    RADEON_VERT_STRETCH_ENABLE |
-						    RADEON_VERT_STRETCH_BLEND |
-						    ((native_mode->panel_yres-1) << 12));
-			}
-		} else if (radeon_encoder->rmx_type == RMX_CENTER) {
-			int    blank_width;
-
-			fp_horz_stretch |= ((xres/8-1) << 16);
-			fp_vert_stretch |= ((yres-1) << 12);
-
-			crtc_more_cntl |= (RADEON_CRTC_AUTO_HORZ_CENTER_EN |
-					   RADEON_CRTC_AUTO_VERT_CENTER_EN);
-
-			blank_width = (mode->crtc_hblank_end - mode->crtc_hblank_start) / 8;
-			if (blank_width > 110)
-				blank_width = 110;
-
-			fp_crtc_h_total_disp = (((blank_width) & 0x3ff)
-						| ((((mode->crtc_hdisplay / 8) - 1) & 0x1ff) << 16));
-
-			hsync_wid = (mode->crtc_hsync_end - mode->crtc_hsync_start) / 8;
-			if (!hsync_wid)
-				hsync_wid = 1;
-
-			fp_h_sync_strt_wid = ((((mode->crtc_hsync_start - mode->crtc_hblank_start) / 8) & 0x1fff)
-					      | ((hsync_wid & 0x3f) << 16)
-					      | ((mode->flags & DRM_MODE_FLAG_NHSYNC)
-						 ? RADEON_CRTC_H_SYNC_POL
-						 : 0));
-
-			fp_crtc_v_total_disp = (((mode->crtc_vblank_end - mode->crtc_vblank_start) & 0xffff)
-						| ((mode->crtc_vdisplay - 1) << 16));
-
-			vsync_wid = mode->crtc_vsync_end - mode->crtc_vsync_start;
-			if (!vsync_wid)
-				vsync_wid = 1;
-
-			fp_v_sync_strt_wid = ((((mode->crtc_vsync_start - mode->crtc_vblank_start) & 0xfff)
-					       | ((vsync_wid & 0x1f) << 16)
-					       | ((mode->flags & DRM_MODE_FLAG_NVSYNC)
-						  ? RADEON_CRTC_V_SYNC_POL
-						  : 0)));
-
-			fp_horz_vert_active = (((native_mode->panel_yres) & 0xfff) |
-					       (((native_mode->panel_xres / 8) & 0x1ff) << 16));
-		}
-	} else {
-		fp_horz_stretch |= ((xres/8-1) << 16);
-		fp_vert_stretch |= ((yres-1) << 12);
-	}
-
-	WREG32(RADEON_FP_HORZ_STRETCH,      fp_horz_stretch);
-	WREG32(RADEON_FP_VERT_STRETCH,      fp_vert_stretch);
-	WREG32(RADEON_CRTC_MORE_CNTL,       crtc_more_cntl);
-	WREG32(RADEON_FP_HORZ_VERT_ACTIVE,  fp_horz_vert_active);
-	WREG32(RADEON_FP_H_SYNC_STRT_WID,   fp_h_sync_strt_wid);
-	WREG32(RADEON_FP_V_SYNC_STRT_WID,   fp_v_sync_strt_wid);
-	WREG32(RADEON_FP_CRTC_H_TOTAL_DISP, fp_crtc_h_total_disp);
-	WREG32(RADEON_FP_CRTC_V_TOTAL_DISP, fp_crtc_v_total_disp);
-
-}
-
 static void radeon_legacy_lvds_dpms(struct drm_encoder *encoder, int mode)
 {
 	struct drm_device *dev = encoder->dev;
@@ -287,9 +123,6 @@ static void radeon_legacy_lvds_mode_set(struct drm_encoder *encoder,
 
 	DRM_DEBUG("\n");
 
-	if (radeon_crtc->crtc_id == 0)
-		radeon_legacy_rmx_mode_set(encoder, mode, adjusted_mode);
-
 	lvds_pll_cntl = RREG32(RADEON_LVDS_PLL_CNTL);
 	lvds_pll_cntl &= ~RADEON_LVDS_PLL_EN;
 
@@ -318,7 +151,7 @@ static void radeon_legacy_lvds_mode_set(struct drm_encoder *encoder,
 
 	if (radeon_crtc->crtc_id == 0) {
 		if (ASIC_IS_R300(rdev)) {
-			if (radeon_encoder->flags & RADEON_USE_RMX)
+			if (radeon_encoder->rmx_type != RMX_OFF)
 				lvds_pll_cntl |= R300_LVDS_SRC_SEL_RMX;
 		} else
 			lvds_gen_cntl &= ~RADEON_LVDS_SEL_CRTC2;
@@ -350,8 +183,6 @@ static bool radeon_legacy_lvds_mode_fixup(struct drm_encoder *encoder,
 
 	drm_mode_set_crtcinfo(adjusted_mode, 0);
 
-	radeon_encoder->flags &= ~RADEON_USE_RMX;
-
 	if (radeon_encoder->rmx_type != RMX_OFF)
 		radeon_rmx_mode_fixup(encoder, mode, adjusted_mode);
 
@@ -455,9 +286,6 @@ static void radeon_legacy_primary_dac_mode_set(struct drm_encoder *encoder,
 
 	DRM_DEBUG("\n");
 
-	if (radeon_crtc->crtc_id == 0)
-		radeon_legacy_rmx_mode_set(encoder, mode, adjusted_mode);
-
 	if (radeon_crtc->crtc_id == 0) {
 		if (rdev->family == CHIP_R200 || ASIC_IS_R300(rdev)) {
 			disp_output_cntl = RREG32(RADEON_DISP_OUTPUT_CNTL) &
@@ -653,9 +481,6 @@ static void radeon_legacy_tmds_int_mode_set(struct drm_encoder *encoder,
 
 	DRM_DEBUG("\n");
 
-	if (radeon_crtc->crtc_id == 0)
-		radeon_legacy_rmx_mode_set(encoder, mode, adjusted_mode);
-
 	tmp = tmds_pll_cntl = RREG32(RADEON_TMDS_PLL_CNTL);
 	tmp &= 0xfffff;
 	if (rdev->family == CHIP_RV280) {
@@ -711,7 +536,7 @@ static void radeon_legacy_tmds_int_mode_set(struct drm_encoder *encoder,
     if (radeon_crtc->crtc_id == 0) {
 	    if (ASIC_IS_R300(rdev) || rdev->family == CHIP_R200) {
 		    fp_gen_cntl &= ~R200_FP_SOURCE_SEL_MASK;
-		    if (radeon_encoder->flags & RADEON_USE_RMX)
+		    if (radeon_encoder->rmx_type != RMX_OFF)
 			    fp_gen_cntl |= R200_FP_SOURCE_SEL_RMX;
 		    else
 			    fp_gen_cntl |= R200_FP_SOURCE_SEL_CRTC1;
@@ -820,9 +645,6 @@ static void radeon_legacy_tmds_ext_mode_set(struct drm_encoder *encoder,
 
 	DRM_DEBUG("\n");
 
-	if (radeon_crtc->crtc_id == 0)
-		radeon_legacy_rmx_mode_set(encoder, mode, adjusted_mode);
-
 	if (rdev->is_atom_bios) {
 		radeon_encoder->pixel_clock = adjusted_mode->clock;
 		atombios_external_tmds_setup(encoder, ATOM_ENABLE);
@@ -856,7 +678,7 @@ static void radeon_legacy_tmds_ext_mode_set(struct drm_encoder *encoder,
 	if (radeon_crtc->crtc_id == 0) {
 		if ((rdev->family == CHIP_R200) || ASIC_IS_R300(rdev)) {
 			fp2_gen_cntl &= ~R200_FP2_SOURCE_SEL_MASK;
-			if (radeon_encoder->flags & RADEON_USE_RMX)
+			if (radeon_encoder->rmx_type != RMX_OFF)
 				fp2_gen_cntl |= R200_FP2_SOURCE_SEL_RMX;
 			else
 				fp2_gen_cntl |= R200_FP2_SOURCE_SEL_CRTC1;
@@ -1014,9 +836,6 @@ static void radeon_legacy_tv_dac_mode_set(struct drm_encoder *encoder,
 
 	DRM_DEBUG("\n");
 
-	if (radeon_crtc->crtc_id == 0)
-		radeon_legacy_rmx_mode_set(encoder, mode, adjusted_mode);
-
 	if (rdev->family != CHIP_R200) {
 		tv_dac_cntl = RREG32(RADEON_TV_DAC_CNTL);
 		if (rdev->family == CHIP_R420 ||
@@ -1243,6 +1062,7 @@ radeon_add_legacy_encoder(struct drm_device *dev, uint32_t encoder_id, uint32_t
 
 	radeon_encoder->encoder_id = encoder_id;
 	radeon_encoder->devices = supported_device;
+	radeon_encoder->rmx_type = RMX_OFF;
 
 	switch (radeon_encoder->encoder_id) {
 	case ENCODER_OBJECT_ID_INTERNAL_LVDS:
diff --git a/drivers/gpu/drm/radeon/radeon_mode.h b/drivers/gpu/drm/radeon/radeon_mode.h
index 86f766e..a1ecf17 100644
--- a/drivers/gpu/drm/radeon/radeon_mode.h
+++ b/drivers/gpu/drm/radeon/radeon_mode.h
@@ -36,6 +36,9 @@
 #include <linux/i2c.h>
 #include <linux/i2c-id.h>
 #include <linux/i2c-algo-bit.h>
+#include "radeon_fixed.h"
+
+struct radeon_device;
 
 #define to_radeon_crtc(x) container_of(x, struct radeon_crtc, base)
 #define to_radeon_connector(x) container_of(x, struct radeon_connector, base)
@@ -170,6 +173,18 @@ struct radeon_mode_info {
 	struct atom_context *atom_context;
 	enum radeon_connector_table connector_table;
 	bool mode_config_initialized;
+	struct radeon_crtc *crtcs[2];
+};
+
+struct radeon_native_mode {
+	/* preferred mode */
+	uint32_t panel_xres, panel_yres;
+	uint32_t hoverplus, hsync_width;
+	uint32_t hblank;
+	uint32_t voverplus, vsync_width;
+	uint32_t vblank;
+	uint32_t dotclock;
+	uint32_t flags;
 };
 
 struct radeon_crtc {
@@ -186,19 +201,11 @@ struct radeon_crtc {
 	int cursor_width;
 	int cursor_height;
 	uint32_t legacy_display_base_addr;
-};
-
-#define RADEON_USE_RMX 1
-
-struct radeon_native_mode {
-	/* preferred mode */
-	uint32_t panel_xres, panel_yres;
-	uint32_t hoverplus, hsync_width;
-	uint32_t hblank;
-	uint32_t voverplus, vsync_width;
-	uint32_t vblank;
-	uint32_t dotclock;
-	uint32_t flags;
+	enum radeon_rmx_type rmx_type;
+	uint32_t devices;
+	fixed20_12 vsc;
+	fixed20_12 hsc;
+	struct radeon_native_mode native_mode;
 };
 
 struct radeon_encoder_primary_dac {
@@ -384,16 +391,9 @@ void radeon_enc_destroy(struct drm_encoder *encoder);
 void radeon_copy_fb(struct drm_device *dev, struct drm_gem_object *dst_obj);
 void radeon_combios_asic_init(struct drm_device *dev);
 extern int radeon_static_clocks_init(struct drm_device *dev);
-void radeon_init_disp_bw_legacy(struct drm_device *dev,
-				struct drm_display_mode *mode1,
-				uint32_t pixel_bytes1,
-				struct drm_display_mode *mode2,
-				uint32_t pixel_bytes2);
-void radeon_init_disp_bw_avivo(struct drm_device *dev,
-			       struct drm_display_mode *mode1,
-			       uint32_t pixel_bytes1,
-			       struct drm_display_mode *mode2,
-			       uint32_t pixel_bytes2);
-void radeon_init_disp_bandwidth(struct drm_device *dev);
+bool radeon_crtc_scaling_mode_fixup(struct drm_crtc *crtc,
+					struct drm_display_mode *mode,
+					struct drm_display_mode *adjusted_mode);
+void atom_rv515_force_tv_scaler(struct radeon_device *rdev);
 
 #endif
diff --git a/drivers/gpu/drm/radeon/radeon_share.h b/drivers/gpu/drm/radeon/radeon_share.h
new file mode 100644
index 0000000..63a7735
--- /dev/null
+++ b/drivers/gpu/drm/radeon/radeon_share.h
@@ -0,0 +1,39 @@
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
+#ifndef __RADEON_SHARE_H__
+#define __RADEON_SHARE_H__
+
+void r100_vram_init_sizes(struct radeon_device *rdev);
+
+void rs690_line_buffer_adjust(struct radeon_device *rdev,
+			      struct drm_display_mode *mode1,
+			      struct drm_display_mode *mode2);
+
+void rv515_bandwidth_avivo_update(struct radeon_device *rdev);
+
+#endif
diff --git a/drivers/gpu/drm/radeon/rs400.c b/drivers/gpu/drm/radeon/rs400.c
index daf24e8..96a3c84 100644
--- a/drivers/gpu/drm/radeon/rs400.c
+++ b/drivers/gpu/drm/radeon/rs400.c
@@ -29,6 +29,7 @@
 #include <drm/drmP.h>
 #include "radeon_reg.h"
 #include "radeon.h"
+#include "radeon_share.h"
 
 /* rs400,rs480 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
diff --git a/drivers/gpu/drm/radeon/rs600.c b/drivers/gpu/drm/radeon/rs600.c
index ab0c967..bccdce7 100644
--- a/drivers/gpu/drm/radeon/rs600.c
+++ b/drivers/gpu/drm/radeon/rs600.c
@@ -301,6 +301,11 @@ void rs600_vram_info(struct radeon_device *rdev)
 	rdev->mc.vram_width = 128;
 }
 
+void rs600_bandwidth_update(struct radeon_device *rdev)
+{
+	/* FIXME: implement, should this be like rs690 ? */
+}
+
 
 /*
  * Indirect registers accessor
diff --git a/drivers/gpu/drm/radeon/rs690.c b/drivers/gpu/drm/radeon/rs690.c
index 79ba850..6b0b6b4 100644
--- a/drivers/gpu/drm/radeon/rs690.c
+++ b/drivers/gpu/drm/radeon/rs690.c
@@ -28,6 +28,9 @@
 #include "drmP.h"
 #include "radeon_reg.h"
 #include "radeon.h"
+#include "rs690r.h"
+#include "atom.h"
+#include "atom-bits.h"
 
 /* rs690,rs740 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
@@ -138,9 +141,82 @@ void rs690_gpu_init(struct radeon_device *rdev)
 /*
  * VRAM info.
  */
+void rs690_pm_info(struct radeon_device *rdev)
+{
+	int index = GetIndexIntoMasterTable(DATA, IntegratedSystemInfo);
+	struct _ATOM_INTEGRATED_SYSTEM_INFO *info;
+	struct _ATOM_INTEGRATED_SYSTEM_INFO_V2 *info_v2;
+	void *ptr;
+	uint16_t data_offset;
+	uint8_t frev, crev;
+	fixed20_12 tmp;
+
+	atom_parse_data_header(rdev->mode_info.atom_context, index, NULL,
+			       &frev, &crev, &data_offset);
+	ptr = rdev->mode_info.atom_context->bios + data_offset;
+	info = (struct _ATOM_INTEGRATED_SYSTEM_INFO *)ptr;
+	info_v2 = (struct _ATOM_INTEGRATED_SYSTEM_INFO_V2 *)ptr;
+	/* Get various system informations from bios */
+	switch (crev) {
+	case 1:
+		tmp.full = rfixed_const(100);
+		rdev->pm.igp_sideport_mclk.full = rfixed_const(info->ulBootUpMemoryClock);
+		rdev->pm.igp_sideport_mclk.full = rfixed_div(rdev->pm.igp_sideport_mclk, tmp);
+		rdev->pm.igp_system_mclk.full = rfixed_const(le16_to_cpu(info->usK8MemoryClock));
+		rdev->pm.igp_ht_link_clk.full = rfixed_const(le16_to_cpu(info->usFSBClock));
+		rdev->pm.igp_ht_link_width.full = rfixed_const(info->ucHTLinkWidth);
+		break;
+	case 2:
+		tmp.full = rfixed_const(100);
+		rdev->pm.igp_sideport_mclk.full = rfixed_const(info_v2->ulBootUpSidePortClock);
+		rdev->pm.igp_sideport_mclk.full = rfixed_div(rdev->pm.igp_sideport_mclk, tmp);
+		rdev->pm.igp_system_mclk.full = rfixed_const(info_v2->ulBootUpUMAClock);
+		rdev->pm.igp_system_mclk.full = rfixed_div(rdev->pm.igp_system_mclk, tmp);
+		rdev->pm.igp_ht_link_clk.full = rfixed_const(info_v2->ulHTLinkFreq);
+		rdev->pm.igp_ht_link_clk.full = rfixed_div(rdev->pm.igp_ht_link_clk, tmp);
+		rdev->pm.igp_ht_link_width.full = rfixed_const(le16_to_cpu(info_v2->usMinHTLinkWidth));
+		break;
+	default:
+		tmp.full = rfixed_const(100);
+		/* We assume the slower possible clock ie worst case */
+		/* DDR 333Mhz */
+		rdev->pm.igp_sideport_mclk.full = rfixed_const(333);
+		/* FIXME: system clock ? */
+		rdev->pm.igp_system_mclk.full = rfixed_const(100);
+		rdev->pm.igp_system_mclk.full = rfixed_div(rdev->pm.igp_system_mclk, tmp);
+		rdev->pm.igp_ht_link_clk.full = rfixed_const(200);
+		rdev->pm.igp_ht_link_width.full = rfixed_const(8);
+		DRM_ERROR("No integrated system info for your GPU, using safe default\n");
+		break;
+	}
+	/* Compute various bandwidth */
+	/* k8_bandwidth = (memory_clk / 2) * 2 * 8 * 0.5 = memory_clk * 4  */
+	tmp.full = rfixed_const(4);
+	rdev->pm.k8_bandwidth.full = rfixed_mul(rdev->pm.igp_system_mclk, tmp);
+	/* ht_bandwidth = ht_clk * 2 * ht_width / 8 * 0.8
+	 *              = ht_clk * ht_width / 5
+	 */
+	tmp.full = rfixed_const(5);
+	rdev->pm.ht_bandwidth.full = rfixed_mul(rdev->pm.igp_ht_link_clk,
+						rdev->pm.igp_ht_link_width);
+	rdev->pm.ht_bandwidth.full = rfixed_div(rdev->pm.ht_bandwidth, tmp);
+	if (tmp.full < rdev->pm.max_bandwidth.full) {
+		/* HT link is a limiting factor */
+		rdev->pm.max_bandwidth.full = tmp.full;
+	}
+	/* sideport_bandwidth = (sideport_clk / 2) * 2 * 2 * 0.7
+	 *                    = (sideport_clk * 14) / 10
+	 */
+	tmp.full = rfixed_const(14);
+	rdev->pm.sideport_bandwidth.full = rfixed_mul(rdev->pm.igp_sideport_mclk, tmp);
+	tmp.full = rfixed_const(10);
+	rdev->pm.sideport_bandwidth.full = rfixed_div(rdev->pm.sideport_bandwidth, tmp);
+}
+
 void rs690_vram_info(struct radeon_device *rdev)
 {
 	uint32_t tmp;
+	fixed20_12 a;
 
 	rs400_gart_adjust_size(rdev);
 	/* DDR for all card after R300 & IGP */
@@ -156,8 +232,404 @@ void rs690_vram_info(struct radeon_device *rdev)
 
 	rdev->mc.aper_base = drm_get_resource_start(rdev->ddev, 0);
 	rdev->mc.aper_size = drm_get_resource_len(rdev->ddev, 0);
+	rs690_pm_info(rdev);
+	/* FIXME: we should enforce default clock in case GPU is not in
+	 * default setup
+	 */
+	a.full = rfixed_const(100);
+	rdev->pm.sclk.full = rfixed_const(rdev->clock.default_sclk);
+	rdev->pm.sclk.full = rfixed_div(rdev->pm.sclk, a);
+	a.full = rfixed_const(16);
+	/* core_bandwidth = sclk(Mhz) * 16 */
+	rdev->pm.core_bandwidth.full = rfixed_div(rdev->pm.sclk, a);
+}
+
+void rs690_line_buffer_adjust(struct radeon_device *rdev,
+			      struct drm_display_mode *mode1,
+			      struct drm_display_mode *mode2)
+{
+	u32 tmp;
+
+	/*
+	 * Line Buffer Setup
+	 * There is a single line buffer shared by both display controllers.
+	 * DC_LB_MEMORY_SPLIT controls how that line buffer is shared between
+	 * the display controllers.  The paritioning can either be done
+	 * manually or via one of four preset allocations specified in bits 1:0:
+	 *  0 - line buffer is divided in half and shared between crtc
+	 *  1 - D1 gets 3/4 of the line buffer, D2 gets 1/4
+	 *  2 - D1 gets the whole buffer
+	 *  3 - D1 gets 1/4 of the line buffer, D2 gets 3/4
+	 * Setting bit 2 of DC_LB_MEMORY_SPLIT controls switches to manual
+	 * allocation mode. In manual allocation mode, D1 always starts at 0,
+	 * D1 end/2 is specified in bits 14:4; D2 allocation follows D1.
+	 */
+	tmp = RREG32(DC_LB_MEMORY_SPLIT) & ~DC_LB_MEMORY_SPLIT_MASK;
+	tmp &= ~DC_LB_MEMORY_SPLIT_SHIFT_MODE;
+	/* auto */
+	if (mode1 && mode2) {
+		if (mode1->hdisplay > mode2->hdisplay) {
+			if (mode1->hdisplay > 2560)
+				tmp |= DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q;
+			else
+				tmp |= DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
+		} else if (mode2->hdisplay > mode1->hdisplay) {
+			if (mode2->hdisplay > 2560)
+				tmp |= DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
+			else
+				tmp |= DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
+		} else
+			tmp |= AVIVO_DC_LB_MEMORY_SPLIT_D1HALF_D2HALF;
+	} else if (mode1) {
+		tmp |= DC_LB_MEMORY_SPLIT_D1_ONLY;
+	} else if (mode2) {
+		tmp |= DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q;
+	}
+	WREG32(DC_LB_MEMORY_SPLIT, tmp);
 }
 
+struct rs690_watermark {
+	u32        lb_request_fifo_depth;
+	fixed20_12 num_line_pair;
+	fixed20_12 estimated_width;
+	fixed20_12 worst_case_latency;
+	fixed20_12 consumption_rate;
+	fixed20_12 active_time;
+	fixed20_12 dbpp;
+	fixed20_12 priority_mark_max;
+	fixed20_12 priority_mark;
+	fixed20_12 sclk;
+};
+
+void rs690_crtc_bandwidth_compute(struct radeon_device *rdev,
+				  struct radeon_crtc *crtc,
+				  struct rs690_watermark *wm)
+{
+	struct drm_display_mode *mode = &crtc->base.mode;
+	fixed20_12 a, b, c;
+	fixed20_12 pclk, request_fifo_depth, tolerable_latency, estimated_width;
+	fixed20_12 consumption_time, line_time, chunk_time, read_delay_latency;
+	/* FIXME: detect IGP with sideport memory, i don't think there is any
+	 * such product available
+	 */
+	bool sideport = false;
+
+	if (!crtc->base.enabled) {
+		/* FIXME: wouldn't it better to set priority mark to maximum */
+		wm->lb_request_fifo_depth = 4;
+		return;
+	}
+
+	if (crtc->vsc.full > rfixed_const(2))
+		wm->num_line_pair.full = rfixed_const(2);
+	else
+		wm->num_line_pair.full = rfixed_const(1);
+
+	b.full = rfixed_const(mode->crtc_hdisplay);
+	c.full = rfixed_const(256);
+	a.full = rfixed_mul(wm->num_line_pair, b);
+	request_fifo_depth.full = rfixed_div(a, c);
+	if (a.full < rfixed_const(4)) {
+		wm->lb_request_fifo_depth = 4;
+	} else {
+		wm->lb_request_fifo_depth = rfixed_trunc(request_fifo_depth);
+	}
+
+	/* Determine consumption rate
+	 *  pclk = pixel clock period(ns) = 1000 / (mode.clock / 1000)
+	 *  vtaps = number of vertical taps,
+	 *  vsc = vertical scaling ratio, defined as source/destination
+	 *  hsc = horizontal scaling ration, defined as source/destination
+	 */
+	a.full = rfixed_const(mode->clock);
+	b.full = rfixed_const(1000);
+	a.full = rfixed_div(a, b);
+	pclk.full = rfixed_div(b, a);
+	if (crtc->rmx_type != RMX_OFF) {
+		b.full = rfixed_const(2);
+		if (crtc->vsc.full > b.full)
+			b.full = crtc->vsc.full;
+		b.full = rfixed_mul(b, crtc->hsc);
+		c.full = rfixed_const(2);
+		b.full = rfixed_div(b, c);
+		consumption_time.full = rfixed_div(pclk, b);
+	} else {
+		consumption_time.full = pclk.full;
+	}
+	a.full = rfixed_const(1);
+	wm->consumption_rate.full = rfixed_div(a, consumption_time);
+
+
+	/* Determine line time
+	 *  LineTime = total time for one line of displayhtotal
+	 *  LineTime = total number of horizontal pixels
+	 *  pclk = pixel clock period(ns)
+	 */
+	a.full = rfixed_const(crtc->base.mode.crtc_htotal);
+	line_time.full = rfixed_mul(a, pclk);
+
+	/* Determine active time
+	 *  ActiveTime = time of active region of display within one line,
+	 *  hactive = total number of horizontal active pixels
+	 *  htotal = total number of horizontal pixels
+	 */
+	a.full = rfixed_const(crtc->base.mode.crtc_htotal);
+	b.full = rfixed_const(crtc->base.mode.crtc_hdisplay);
+	wm->active_time.full = rfixed_mul(line_time, b);
+	wm->active_time.full = rfixed_div(wm->active_time, a);
+
+	/* Maximun bandwidth is the minimun bandwidth of all component */
+	rdev->pm.max_bandwidth = rdev->pm.core_bandwidth;
+	if (sideport) {
+		if (rdev->pm.max_bandwidth.full > rdev->pm.sideport_bandwidth.full &&
+			rdev->pm.sideport_bandwidth.full)
+			rdev->pm.max_bandwidth = rdev->pm.sideport_bandwidth;
+		read_delay_latency.full = rfixed_const(370 * 800 * 1000);
+		read_delay_latency.full = rfixed_div(read_delay_latency,
+			rdev->pm.igp_sideport_mclk);
+	} else {
+		if (rdev->pm.max_bandwidth.full > rdev->pm.k8_bandwidth.full &&
+			rdev->pm.k8_bandwidth.full)
+			rdev->pm.max_bandwidth = rdev->pm.k8_bandwidth;
+		if (rdev->pm.max_bandwidth.full > rdev->pm.ht_bandwidth.full &&
+			rdev->pm.ht_bandwidth.full)
+			rdev->pm.max_bandwidth = rdev->pm.ht_bandwidth;
+		read_delay_latency.full = rfixed_const(5000);
+	}
+
+	/* sclk = system clocks(ns) = 1000 / max_bandwidth / 16 */
+	a.full = rfixed_const(16);
+	rdev->pm.sclk.full = rfixed_mul(rdev->pm.max_bandwidth, a);
+	a.full = rfixed_const(1000);
+	rdev->pm.sclk.full = rfixed_div(a, rdev->pm.sclk);
+	/* Determine chunk time
+	 * ChunkTime = the time it takes the DCP to send one chunk of data
+	 * to the LB which consists of pipeline delay and inter chunk gap
+	 * sclk = system clock(ns)
+	 */
+	a.full = rfixed_const(256 * 13);
+	chunk_time.full = rfixed_mul(rdev->pm.sclk, a);
+	a.full = rfixed_const(10);
+	chunk_time.full = rfixed_div(chunk_time, a);
+
+	/* Determine the worst case latency
+	 * NumLinePair = Number of line pairs to request(1=2 lines, 2=4 lines)
+	 * WorstCaseLatency = worst case time from urgent to when the MC starts
+	 *                    to return data
+	 * READ_DELAY_IDLE_MAX = constant of 1us
+	 * ChunkTime = time it takes the DCP to send one chunk of data to the LB
+	 *             which consists of pipeline delay and inter chunk gap
+	 */
+	if (rfixed_trunc(wm->num_line_pair) > 1) {
+		a.full = rfixed_const(3);
+		wm->worst_case_latency.full = rfixed_mul(a, chunk_time);
+		wm->worst_case_latency.full += read_delay_latency.full;
+	} else {
+		a.full = rfixed_const(2);
+		wm->worst_case_latency.full = rfixed_mul(a, chunk_time);
+		wm->worst_case_latency.full += read_delay_latency.full;
+	}
+
+	/* Determine the tolerable latency
+	 * TolerableLatency = Any given request has only 1 line time
+	 *                    for the data to be returned
+	 * LBRequestFifoDepth = Number of chunk requests the LB can
+	 *                      put into the request FIFO for a display
+	 *  LineTime = total time for one line of display
+	 *  ChunkTime = the time it takes the DCP to send one chunk
+	 *              of data to the LB which consists of
+	 *  pipeline delay and inter chunk gap
+	 */
+	if ((2+wm->lb_request_fifo_depth) >= rfixed_trunc(request_fifo_depth)) {
+		tolerable_latency.full = line_time.full;
+	} else {
+		tolerable_latency.full = rfixed_const(wm->lb_request_fifo_depth - 2);
+		tolerable_latency.full = request_fifo_depth.full - tolerable_latency.full;
+		tolerable_latency.full = rfixed_mul(tolerable_latency, chunk_time);
+		tolerable_latency.full = line_time.full - tolerable_latency.full;
+	}
+	/* We assume worst case 32bits (4 bytes) */
+	wm->dbpp.full = rfixed_const(4 * 8);
+
+	/* Determine the maximum priority mark
+	 *  width = viewport width in pixels
+	 */
+	a.full = rfixed_const(16);
+	wm->priority_mark_max.full = rfixed_const(crtc->base.mode.crtc_hdisplay);
+	wm->priority_mark_max.full = rfixed_div(wm->priority_mark_max, a);
+
+	/* Determine estimated width */
+	estimated_width.full = tolerable_latency.full - wm->worst_case_latency.full;
+	estimated_width.full = rfixed_div(estimated_width, consumption_time);
+	if (rfixed_trunc(estimated_width) > crtc->base.mode.crtc_hdisplay) {
+		wm->priority_mark.full = rfixed_const(10);
+	} else {
+		a.full = rfixed_const(16);
+		wm->priority_mark.full = rfixed_div(estimated_width, a);
+		wm->priority_mark.full = wm->priority_mark_max.full - wm->priority_mark.full;
+	}
+}
+
+void rs690_bandwidth_update(struct radeon_device *rdev)
+{
+	struct drm_display_mode *mode0 = NULL;
+	struct drm_display_mode *mode1 = NULL;
+	struct rs690_watermark wm0;
+	struct rs690_watermark wm1;
+	u32 tmp;
+	fixed20_12 priority_mark02, priority_mark12, fill_rate;
+	fixed20_12 a, b;
+
+	if (rdev->mode_info.crtcs[0]->base.enabled)
+		mode0 = &rdev->mode_info.crtcs[0]->base.mode;
+	if (rdev->mode_info.crtcs[1]->base.enabled)
+		mode1 = &rdev->mode_info.crtcs[1]->base.mode;
+	/*
+	 * Set display0/1 priority up in the memory controller for
+	 * modes if the user specifies HIGH for displaypriority
+	 * option.
+	 */
+	if (rdev->disp_priority == 2) {
+		tmp = RREG32_MC(MC_INIT_MISC_LAT_TIMER);
+		tmp &= ~MC_DISP1R_INIT_LAT_MASK;
+		tmp &= ~MC_DISP0R_INIT_LAT_MASK;
+		if (mode1)
+			tmp |= (1 << MC_DISP1R_INIT_LAT_SHIFT);
+		if (mode0)
+			tmp |= (1 << MC_DISP0R_INIT_LAT_SHIFT);
+		WREG32_MC(MC_INIT_MISC_LAT_TIMER, tmp);
+	}
+	rs690_line_buffer_adjust(rdev, mode0, mode1);
+
+	if ((rdev->family == CHIP_RS690) || (rdev->family == CHIP_RS740))
+		WREG32(DCP_CONTROL, 0);
+	if ((rdev->family == CHIP_RS780) || (rdev->family == CHIP_RS880))
+		WREG32(DCP_CONTROL, 2);
+
+	rs690_crtc_bandwidth_compute(rdev, rdev->mode_info.crtcs[0], &wm0);
+	rs690_crtc_bandwidth_compute(rdev, rdev->mode_info.crtcs[1], &wm1);
+
+	tmp = (wm0.lb_request_fifo_depth - 1);
+	tmp |= (wm1.lb_request_fifo_depth - 1) << 16;
+	WREG32(LB_MAX_REQ_OUTSTANDING, tmp);
+
+	if (mode0 && mode1) {
+		if (rfixed_trunc(wm0.dbpp) > 64)
+			a.full = rfixed_mul(wm0.dbpp, wm0.num_line_pair);
+		else
+			a.full = wm0.num_line_pair.full;
+		if (rfixed_trunc(wm1.dbpp) > 64)
+			b.full = rfixed_mul(wm1.dbpp, wm1.num_line_pair);
+		else
+			b.full = wm1.num_line_pair.full;
+		a.full += b.full;
+		fill_rate.full = rfixed_div(wm0.sclk, a);
+		if (wm0.consumption_rate.full > fill_rate.full) {
+			b.full = wm0.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm0.active_time);
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			a.full = a.full + b.full;
+			b.full = rfixed_const(16 * 1000);
+			priority_mark02.full = rfixed_div(a, b);
+		} else {
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			b.full = rfixed_const(16 * 1000);
+			priority_mark02.full = rfixed_div(a, b);
+		}
+		if (wm1.consumption_rate.full > fill_rate.full) {
+			b.full = wm1.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm1.active_time);
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			a.full = a.full + b.full;
+			b.full = rfixed_const(16 * 1000);
+			priority_mark12.full = rfixed_div(a, b);
+		} else {
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			b.full = rfixed_const(16 * 1000);
+			priority_mark12.full = rfixed_div(a, b);
+		}
+		if (wm0.priority_mark.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark.full;
+		if (rfixed_trunc(priority_mark02) < 0)
+			priority_mark02.full = 0;
+		if (wm0.priority_mark_max.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark_max.full;
+		if (wm1.priority_mark.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark.full;
+		if (rfixed_trunc(priority_mark12) < 0)
+			priority_mark12.full = 0;
+		if (wm1.priority_mark_max.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark_max.full;
+		WREG32(D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
+		WREG32(D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
+	} else if (mode0) {
+		if (rfixed_trunc(wm0.dbpp) > 64)
+			a.full = rfixed_mul(wm0.dbpp, wm0.num_line_pair);
+		else
+			a.full = wm0.num_line_pair.full;
+		fill_rate.full = rfixed_div(wm0.sclk, a);
+		if (wm0.consumption_rate.full > fill_rate.full) {
+			b.full = wm0.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm0.active_time);
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			a.full = a.full + b.full;
+			b.full = rfixed_const(16 * 1000);
+			priority_mark02.full = rfixed_div(a, b);
+		} else {
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			b.full = rfixed_const(16 * 1000);
+			priority_mark02.full = rfixed_div(a, b);
+		}
+		if (wm0.priority_mark.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark.full;
+		if (rfixed_trunc(priority_mark02) < 0)
+			priority_mark02.full = 0;
+		if (wm0.priority_mark_max.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark_max.full;
+		WREG32(D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D2MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
+		WREG32(D2MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
+	} else {
+		if (rfixed_trunc(wm1.dbpp) > 64)
+			a.full = rfixed_mul(wm1.dbpp, wm1.num_line_pair);
+		else
+			a.full = wm1.num_line_pair.full;
+		fill_rate.full = rfixed_div(wm1.sclk, a);
+		if (wm1.consumption_rate.full > fill_rate.full) {
+			b.full = wm1.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm1.active_time);
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			a.full = a.full + b.full;
+			b.full = rfixed_const(16 * 1000);
+			priority_mark12.full = rfixed_div(a, b);
+		} else {
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			b.full = rfixed_const(16 * 1000);
+			priority_mark12.full = rfixed_div(a, b);
+		}
+		if (wm1.priority_mark.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark.full;
+		if (rfixed_trunc(priority_mark12) < 0)
+			priority_mark12.full = 0;
+		if (wm1.priority_mark_max.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark_max.full;
+		WREG32(D1MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
+		WREG32(D1MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
+		WREG32(D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
+		WREG32(D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
+	}
+}
 
 /*
  * Indirect registers accessor
diff --git a/drivers/gpu/drm/radeon/rs690r.h b/drivers/gpu/drm/radeon/rs690r.h
new file mode 100644
index 0000000..c0d9faa
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rs690r.h
@@ -0,0 +1,99 @@
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
+#ifndef RS690R_H
+#define RS690R_H
+
+/* RS690/RS740 registers */
+#define MC_INDEX			0x0078
+#	define MC_INDEX_MASK			0x1FF
+#	define MC_INDEX_WR_EN			(1 << 9)
+#	define MC_INDEX_WR_ACK			0x7F
+#define MC_DATA				0x007C
+#define HDP_FB_LOCATION			0x0134
+#define DC_LB_MEMORY_SPLIT		0x6520
+#define		DC_LB_MEMORY_SPLIT_MASK			0x00000003
+#define		DC_LB_MEMORY_SPLIT_SHIFT		0
+#define		DC_LB_MEMORY_SPLIT_D1HALF_D2HALF	0
+#define		DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q		1
+#define		DC_LB_MEMORY_SPLIT_D1_ONLY		2
+#define		DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q		3
+#define		DC_LB_MEMORY_SPLIT_SHIFT_MODE		(1 << 2)
+#define		DC_LB_DISP1_END_ADR_SHIFT		4
+#define		DC_LB_DISP1_END_ADR_MASK		0x00007FF0
+#define D1MODE_PRIORITY_A_CNT		0x6548
+#define		MODE_PRIORITY_MARK_MASK			0x00007FFF
+#define		MODE_PRIORITY_OFF			(1 << 16)
+#define		MODE_PRIORITY_ALWAYS_ON			(1 << 20)
+#define		MODE_PRIORITY_FORCE_MASK		(1 << 24)
+#define D1MODE_PRIORITY_B_CNT		0x654C
+#define LB_MAX_REQ_OUTSTANDING		0x6D58
+#define		LB_D1_MAX_REQ_OUTSTANDING_MASK		0x0000000F
+#define		LB_D1_MAX_REQ_OUTSTANDING_SHIFT		0
+#define		LB_D2_MAX_REQ_OUTSTANDING_MASK		0x000F0000
+#define		LB_D2_MAX_REQ_OUTSTANDING_SHIFT		16
+#define DCP_CONTROL			0x6C9C
+#define D2MODE_PRIORITY_A_CNT		0x6D48
+#define D2MODE_PRIORITY_B_CNT		0x6D4C
+
+/* MC indirect registers */
+#define MC_STATUS_IDLE				(1 << 0)
+#define MC_MISC_CNTL			0x18
+#define		DISABLE_GTW			(1 << 1)
+#define		GART_INDEX_REG_EN		(1 << 12)
+#define		BLOCK_GFX_D3_EN			(1 << 14)
+#define GART_FEATURE_ID			0x2B
+#define		HANG_EN				(1 << 11)
+#define		TLB_ENABLE			(1 << 18)
+#define		P2P_ENABLE			(1 << 19)
+#define		GTW_LAC_EN			(1 << 25)
+#define		LEVEL2_GART			(0 << 30)
+#define		LEVEL1_GART			(1 << 30)
+#define		PDC_EN				(1 << 31)
+#define GART_BASE			0x2C
+#define GART_CACHE_CNTRL		0x2E
+#	define GART_CACHE_INVALIDATE		(1 << 0)
+#define MC_STATUS			0x90
+#define MCCFG_FB_LOCATION		0x100
+#define		MC_FB_START_MASK		0x0000FFFF
+#define		MC_FB_START_SHIFT		0
+#define		MC_FB_TOP_MASK			0xFFFF0000
+#define		MC_FB_TOP_SHIFT			16
+#define MCCFG_AGP_LOCATION		0x101
+#define		MC_AGP_START_MASK		0x0000FFFF
+#define		MC_AGP_START_SHIFT		0
+#define		MC_AGP_TOP_MASK			0xFFFF0000
+#define		MC_AGP_TOP_SHIFT		16
+#define MCCFG_AGP_BASE			0x102
+#define MCCFG_AGP_BASE_2		0x103
+#define MC_INIT_MISC_LAT_TIMER		0x104
+#define		MC_DISP0R_INIT_LAT_SHIFT	8
+#define		MC_DISP0R_INIT_LAT_MASK		0x00000F00
+#define		MC_DISP1R_INIT_LAT_SHIFT	12
+#define		MC_DISP1R_INIT_LAT_MASK		0x0000F000
+
+#endif
diff --git a/drivers/gpu/drm/radeon/rv515.c b/drivers/gpu/drm/radeon/rv515.c
index 677929e..d89d549 100644
--- a/drivers/gpu/drm/radeon/rv515.c
+++ b/drivers/gpu/drm/radeon/rv515.c
@@ -27,8 +27,9 @@
  */
 #include <linux/seq_file.h>
 #include "drmP.h"
-#include "radeon_reg.h"
+#include "rv515r.h"
 #include "radeon.h"
+#include "radeon_share.h"
 
 /* rv515 depends on : */
 void r100_hdp_reset(struct radeon_device *rdev);
@@ -100,25 +101,25 @@ int rv515_mc_init(struct radeon_device *rdev)
 	}
 	/* Write VRAM size in case we are limiting it */
 	WREG32(RADEON_CONFIG_MEMSIZE, rdev->mc.vram_size);
-	tmp = REG_SET(RV515_MC_FB_START, rdev->mc.vram_location >> 16);
+	tmp = REG_SET(MC_FB_START, rdev->mc.vram_location >> 16);
 	WREG32(0x134, tmp);
 	tmp = rdev->mc.vram_location + rdev->mc.vram_size - 1;
-	tmp = REG_SET(RV515_MC_FB_TOP, tmp >> 16);
-	tmp |= REG_SET(RV515_MC_FB_START, rdev->mc.vram_location >> 16);
-	WREG32_MC(RV515_MC_FB_LOCATION, tmp);
-	WREG32(RS690_HDP_FB_LOCATION, rdev->mc.vram_location >> 16);
+	tmp = REG_SET(MC_FB_TOP, tmp >> 16);
+	tmp |= REG_SET(MC_FB_START, rdev->mc.vram_location >> 16);
+	WREG32_MC(MC_FB_LOCATION, tmp);
+	WREG32(HDP_FB_LOCATION, rdev->mc.vram_location >> 16);
 	WREG32(0x310, rdev->mc.vram_location);
 	if (rdev->flags & RADEON_IS_AGP) {
 		tmp = rdev->mc.gtt_location + rdev->mc.gtt_size - 1;
-		tmp = REG_SET(RV515_MC_AGP_TOP, tmp >> 16);
-		tmp |= REG_SET(RV515_MC_AGP_START, rdev->mc.gtt_location >> 16);
-		WREG32_MC(RV515_MC_AGP_LOCATION, tmp);
-		WREG32_MC(RV515_MC_AGP_BASE, rdev->mc.agp_base);
-		WREG32_MC(RV515_MC_AGP_BASE_2, 0);
+		tmp = REG_SET(MC_AGP_TOP, tmp >> 16);
+		tmp |= REG_SET(MC_AGP_START, rdev->mc.gtt_location >> 16);
+		WREG32_MC(MC_AGP_LOCATION, tmp);
+		WREG32_MC(MC_AGP_BASE, rdev->mc.agp_base);
+		WREG32_MC(MC_AGP_BASE_2, 0);
 	} else {
-		WREG32_MC(RV515_MC_AGP_LOCATION, 0x0FFFFFFF);
-		WREG32_MC(RV515_MC_AGP_BASE, 0);
-		WREG32_MC(RV515_MC_AGP_BASE_2, 0);
+		WREG32_MC(MC_AGP_LOCATION, 0x0FFFFFFF);
+		WREG32_MC(MC_AGP_BASE, 0);
+		WREG32_MC(MC_AGP_BASE_2, 0);
 	}
 	return 0;
 }
@@ -136,95 +137,67 @@ void rv515_mc_fini(struct radeon_device *rdev)
  */
 void rv515_ring_start(struct radeon_device *rdev)
 {
-	unsigned gb_tile_config;
 	int r;
 
-	/* Sub pixel 1/12 so we can have 4K rendering according to doc */
-	gb_tile_config = R300_ENABLE_TILING | R300_TILE_SIZE_16;
-	switch (rdev->num_gb_pipes) {
-	case 2:
-		gb_tile_config |= R300_PIPE_COUNT_R300;
-		break;
-	case 3:
-		gb_tile_config |= R300_PIPE_COUNT_R420_3P;
-		break;
-	case 4:
-		gb_tile_config |= R300_PIPE_COUNT_R420;
-		break;
-	case 1:
-	default:
-		gb_tile_config |= R300_PIPE_COUNT_RV350;
-		break;
-	}
-
 	r = radeon_ring_lock(rdev, 64);
 	if (r) {
 		return;
 	}
-	radeon_ring_write(rdev, PACKET0(RADEON_ISYNC_CNTL, 0));
-	radeon_ring_write(rdev,
-			  RADEON_ISYNC_ANY2D_IDLE3D |
-			  RADEON_ISYNC_ANY3D_IDLE2D |
-			  RADEON_ISYNC_WAIT_IDLEGUI |
-			  RADEON_ISYNC_CPSCRATCH_IDLEGUI);
-	radeon_ring_write(rdev, PACKET0(R300_GB_TILE_CONFIG, 0));
-	radeon_ring_write(rdev, gb_tile_config);
-	radeon_ring_write(rdev, PACKET0(RADEON_WAIT_UNTIL, 0));
+	radeon_ring_write(rdev, PACKET0(ISYNC_CNTL, 0));
 	radeon_ring_write(rdev,
-			  RADEON_WAIT_2D_IDLECLEAN |
-			  RADEON_WAIT_3D_IDLECLEAN);
+			  ISYNC_ANY2D_IDLE3D |
+			  ISYNC_ANY3D_IDLE2D |
+			  ISYNC_WAIT_IDLEGUI |
+			  ISYNC_CPSCRATCH_IDLEGUI);
+	radeon_ring_write(rdev, PACKET0(WAIT_UNTIL, 0));
+	radeon_ring_write(rdev, WAIT_2D_IDLECLEAN | WAIT_3D_IDLECLEAN);
 	radeon_ring_write(rdev, PACKET0(0x170C, 0));
 	radeon_ring_write(rdev, 1 << 31);
-	radeon_ring_write(rdev, PACKET0(R300_GB_SELECT, 0));
+	radeon_ring_write(rdev, PACKET0(GB_SELECT, 0));
 	radeon_ring_write(rdev, 0);
-	radeon_ring_write(rdev, PACKET0(R300_GB_ENABLE, 0));
+	radeon_ring_write(rdev, PACKET0(GB_ENABLE, 0));
 	radeon_ring_write(rdev, 0);
 	radeon_ring_write(rdev, PACKET0(0x42C8, 0));
 	radeon_ring_write(rdev, (1 << rdev->num_gb_pipes) - 1);
-	radeon_ring_write(rdev, PACKET0(R500_VAP_INDEX_OFFSET, 0));
+	radeon_ring_write(rdev, PACKET0(VAP_INDEX_OFFSET, 0));
 	radeon_ring_write(rdev, 0);
-	radeon_ring_write(rdev, PACKET0(R300_RB3D_DSTCACHE_CTLSTAT, 0));
-	radeon_ring_write(rdev, R300_RB3D_DC_FLUSH | R300_RB3D_DC_FREE);
-	radeon_ring_write(rdev, PACKET0(R300_RB3D_ZCACHE_CTLSTAT, 0));
-	radeon_ring_write(rdev, R300_ZC_FLUSH | R300_ZC_FREE);
-	radeon_ring_write(rdev, PACKET0(RADEON_WAIT_UNTIL, 0));
-	radeon_ring_write(rdev,
-			  RADEON_WAIT_2D_IDLECLEAN |
-			  RADEON_WAIT_3D_IDLECLEAN);
-	radeon_ring_write(rdev, PACKET0(R300_GB_AA_CONFIG, 0));
+	radeon_ring_write(rdev, PACKET0(RB3D_DSTCACHE_CTLSTAT, 0));
+	radeon_ring_write(rdev, RB3D_DC_FLUSH | RB3D_DC_FREE);
+	radeon_ring_write(rdev, PACKET0(ZB_ZCACHE_CTLSTAT, 0));
+	radeon_ring_write(rdev, ZC_FLUSH | ZC_FREE);
+	radeon_ring_write(rdev, PACKET0(WAIT_UNTIL, 0));
+	radeon_ring_write(rdev, WAIT_2D_IDLECLEAN | WAIT_3D_IDLECLEAN);
+	radeon_ring_write(rdev, PACKET0(GB_AA_CONFIG, 0));
 	radeon_ring_write(rdev, 0);
-	radeon_ring_write(rdev, PACKET0(R300_RB3D_DSTCACHE_CTLSTAT, 0));
-	radeon_ring_write(rdev, R300_RB3D_DC_FLUSH | R300_RB3D_DC_FREE);
-	radeon_ring_write(rdev, PACKET0(R300_RB3D_ZCACHE_CTLSTAT, 0));
-	radeon_ring_write(rdev, R300_ZC_FLUSH | R300_ZC_FREE);
-	radeon_ring_write(rdev, PACKET0(R300_GB_MSPOS0, 0));
-	radeon_ring_write(rdev,
-			  ((6 << R300_MS_X0_SHIFT) |
-			   (6 << R300_MS_Y0_SHIFT) |
-			   (6 << R300_MS_X1_SHIFT) |
-			   (6 << R300_MS_Y1_SHIFT) |
-			   (6 << R300_MS_X2_SHIFT) |
-			   (6 << R300_MS_Y2_SHIFT) |
-			   (6 << R300_MSBD0_Y_SHIFT) |
-			   (6 << R300_MSBD0_X_SHIFT)));
-	radeon_ring_write(rdev, PACKET0(R300_GB_MSPOS1, 0));
-	radeon_ring_write(rdev,
-			  ((6 << R300_MS_X3_SHIFT) |
-			   (6 << R300_MS_Y3_SHIFT) |
-			   (6 << R300_MS_X4_SHIFT) |
-			   (6 << R300_MS_Y4_SHIFT) |
-			   (6 << R300_MS_X5_SHIFT) |
-			   (6 << R300_MS_Y5_SHIFT) |
-			   (6 << R300_MSBD1_SHIFT)));
-	radeon_ring_write(rdev, PACKET0(R300_GA_ENHANCE, 0));
-	radeon_ring_write(rdev, R300_GA_DEADLOCK_CNTL | R300_GA_FASTSYNC_CNTL);
-	radeon_ring_write(rdev, PACKET0(R300_GA_POLY_MODE, 0));
+	radeon_ring_write(rdev, PACKET0(RB3D_DSTCACHE_CTLSTAT, 0));
+	radeon_ring_write(rdev, RB3D_DC_FLUSH | RB3D_DC_FREE);
+	radeon_ring_write(rdev, PACKET0(ZB_ZCACHE_CTLSTAT, 0));
+	radeon_ring_write(rdev, ZC_FLUSH | ZC_FREE);
+	radeon_ring_write(rdev, PACKET0(GB_MSPOS0, 0));
 	radeon_ring_write(rdev,
-			  R300_FRONT_PTYPE_TRIANGE | R300_BACK_PTYPE_TRIANGE);
-	radeon_ring_write(rdev, PACKET0(R300_GA_ROUND_MODE, 0));
+			  ((6 << MS_X0_SHIFT) |
+			   (6 << MS_Y0_SHIFT) |
+			   (6 << MS_X1_SHIFT) |
+			   (6 << MS_Y1_SHIFT) |
+			   (6 << MS_X2_SHIFT) |
+			   (6 << MS_Y2_SHIFT) |
+			   (6 << MSBD0_Y_SHIFT) |
+			   (6 << MSBD0_X_SHIFT)));
+	radeon_ring_write(rdev, PACKET0(GB_MSPOS1, 0));
 	radeon_ring_write(rdev,
-			  R300_GEOMETRY_ROUND_NEAREST |
-			  R300_COLOR_ROUND_NEAREST);
+			  ((6 << MS_X3_SHIFT) |
+			   (6 << MS_Y3_SHIFT) |
+			   (6 << MS_X4_SHIFT) |
+			   (6 << MS_Y4_SHIFT) |
+			   (6 << MS_X5_SHIFT) |
+			   (6 << MS_Y5_SHIFT) |
+			   (6 << MSBD1_SHIFT)));
+	radeon_ring_write(rdev, PACKET0(GA_ENHANCE, 0));
+	radeon_ring_write(rdev, GA_DEADLOCK_CNTL | GA_FASTSYNC_CNTL);
+	radeon_ring_write(rdev, PACKET0(GA_POLY_MODE, 0));
+	radeon_ring_write(rdev, FRONT_PTYPE_TRIANGE | BACK_PTYPE_TRIANGE);
+	radeon_ring_write(rdev, PACKET0(GA_ROUND_MODE, 0));
+	radeon_ring_write(rdev, GEOMETRY_ROUND_NEAREST | COLOR_ROUND_NEAREST);
 	radeon_ring_write(rdev, PACKET0(0x20C8, 0));
 	radeon_ring_write(rdev, 0);
 	radeon_ring_unlock_commit(rdev);
@@ -242,8 +215,8 @@ int rv515_mc_wait_for_idle(struct radeon_device *rdev)
 
 	for (i = 0; i < rdev->usec_timeout; i++) {
 		/* read MC_STATUS */
-		tmp = RREG32_MC(RV515_MC_STATUS);
-		if (tmp & RV515_MC_STATUS_IDLE) {
+		tmp = RREG32_MC(MC_STATUS);
+		if (tmp & MC_STATUS_IDLE) {
 			return 0;
 		}
 		DRM_UDELAY(1);
@@ -291,33 +264,33 @@ int rv515_ga_reset(struct radeon_device *rdev)
 	reinit_cp = rdev->cp.ready;
 	rdev->cp.ready = false;
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		WREG32(RADEON_CP_CSQ_MODE, 0);
-		WREG32(RADEON_CP_CSQ_CNTL, 0);
-		WREG32(RADEON_RBBM_SOFT_RESET, 0x32005);
-		(void)RREG32(RADEON_RBBM_SOFT_RESET);
+		WREG32(CP_CSQ_MODE, 0);
+		WREG32(CP_CSQ_CNTL, 0);
+		WREG32(RBBM_SOFT_RESET, 0x32005);
+		(void)RREG32(RBBM_SOFT_RESET);
 		udelay(200);
-		WREG32(RADEON_RBBM_SOFT_RESET, 0);
+		WREG32(RBBM_SOFT_RESET, 0);
 		/* Wait to prevent race in RBBM_STATUS */
 		mdelay(1);
-		tmp = RREG32(RADEON_RBBM_STATUS);
+		tmp = RREG32(RBBM_STATUS);
 		if (tmp & ((1 << 20) | (1 << 26))) {
 			DRM_ERROR("VAP & CP still busy (RBBM_STATUS=0x%08X)\n", tmp);
 			/* GA still busy soft reset it */
 			WREG32(0x429C, 0x200);
-			WREG32(R300_VAP_PVS_STATE_FLUSH_REG, 0);
+			WREG32(VAP_PVS_STATE_FLUSH_REG, 0);
 			WREG32(0x43E0, 0);
 			WREG32(0x43E4, 0);
 			WREG32(0x24AC, 0);
 		}
 		/* Wait to prevent race in RBBM_STATUS */
 		mdelay(1);
-		tmp = RREG32(RADEON_RBBM_STATUS);
+		tmp = RREG32(RBBM_STATUS);
 		if (!(tmp & ((1 << 20) | (1 << 26)))) {
 			break;
 		}
 	}
 	for (i = 0; i < rdev->usec_timeout; i++) {
-		tmp = RREG32(RADEON_RBBM_STATUS);
+		tmp = RREG32(RBBM_STATUS);
 		if (!(tmp & ((1 << 20) | (1 << 26)))) {
 			DRM_INFO("GA reset succeed (RBBM_STATUS=0x%08X)\n",
 				 tmp);
@@ -331,7 +304,7 @@ int rv515_ga_reset(struct radeon_device *rdev)
 		}
 		DRM_UDELAY(1);
 	}
-	tmp = RREG32(RADEON_RBBM_STATUS);
+	tmp = RREG32(RBBM_STATUS);
 	DRM_ERROR("Failed to reset GA ! (RBBM_STATUS=0x%08X)\n", tmp);
 	return -1;
 }
@@ -341,7 +314,7 @@ int rv515_gpu_reset(struct radeon_device *rdev)
 	uint32_t status;
 
 	/* reset order likely matter */
-	status = RREG32(RADEON_RBBM_STATUS);
+	status = RREG32(RBBM_STATUS);
 	/* reset HDP */
 	r100_hdp_reset(rdev);
 	/* reset rb2d */
@@ -353,12 +326,12 @@ int rv515_gpu_reset(struct radeon_device *rdev)
 		rv515_ga_reset(rdev);
 	}
 	/* reset CP */
-	status = RREG32(RADEON_RBBM_STATUS);
+	status = RREG32(RBBM_STATUS);
 	if (status & (1 << 16)) {
 		r100_cp_reset(rdev);
 	}
 	/* Check if GPU is idle */
-	status = RREG32(RADEON_RBBM_STATUS);
+	status = RREG32(RBBM_STATUS);
 	if (status & (1 << 31)) {
 		DRM_ERROR("Failed to reset GPU (RBBM_STATUS=0x%08X)\n", status);
 		return -1;
@@ -377,8 +350,7 @@ static void rv515_vram_get_type(struct radeon_device *rdev)
 
 	rdev->mc.vram_width = 128;
 	rdev->mc.vram_is_ddr = true;
-	tmp = RREG32_MC(RV515_MC_CNTL);
-	tmp &= RV515_MEM_NUM_CHANNELS_MASK;
+	tmp = RREG32_MC(RV515_MC_CNTL) & MEM_NUM_CHANNELS_MASK;
 	switch (tmp) {
 	case 0:
 		rdev->mc.vram_width = 64;
@@ -394,9 +366,19 @@ static void rv515_vram_get_type(struct radeon_device *rdev)
 
 void rv515_vram_info(struct radeon_device *rdev)
 {
+	fixed20_12 a;
+
 	rv515_vram_get_type(rdev);
-	
-	r100_vram_init_sizes(rdev);
+	rdev->mc.vram_size = RREG32(CONFIG_MEMSIZE);
+
+	rdev->mc.aper_base = drm_get_resource_start(rdev->ddev, 0);
+	rdev->mc.aper_size = drm_get_resource_len(rdev->ddev, 0);
+	/* FIXME: we should enforce default clock in case GPU is not in
+	 * default setup
+	 */
+	a.full = rfixed_const(100);
+	rdev->pm.sclk.full = rfixed_const(rdev->clock.default_sclk);
+	rdev->pm.sclk.full = rfixed_div(rdev->pm.sclk, a);
 }
 
 
@@ -407,35 +389,35 @@ uint32_t rv515_mc_rreg(struct radeon_device *rdev, uint32_t reg)
 {
 	uint32_t r;
 
-	WREG32(R520_MC_IND_INDEX, 0x7f0000 | (reg & 0xffff));
-	r = RREG32(R520_MC_IND_DATA);
-	WREG32(R520_MC_IND_INDEX, 0);
+	WREG32(MC_IND_INDEX, 0x7f0000 | (reg & 0xffff));
+	r = RREG32(MC_IND_DATA);
+	WREG32(MC_IND_INDEX, 0);
 	return r;
 }
 
 void rv515_mc_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 {
-	WREG32(R520_MC_IND_INDEX, 0xff0000 | ((reg) & 0xffff));
-	WREG32(R520_MC_IND_DATA, (v));
-	WREG32(R520_MC_IND_INDEX, 0);
+	WREG32(MC_IND_INDEX, 0xff0000 | ((reg) & 0xffff));
+	WREG32(MC_IND_DATA, (v));
+	WREG32(MC_IND_INDEX, 0);
 }
 
 uint32_t rv515_pcie_rreg(struct radeon_device *rdev, uint32_t reg)
 {
 	uint32_t r;
 
-	WREG32(RADEON_PCIE_INDEX, ((reg) & 0x7ff));
-	(void)RREG32(RADEON_PCIE_INDEX);
-	r = RREG32(RADEON_PCIE_DATA);
+	WREG32(PCIE_INDEX, ((reg) & 0x7ff));
+	(void)RREG32(PCIE_INDEX);
+	r = RREG32(PCIE_DATA);
 	return r;
 }
 
 void rv515_pcie_wreg(struct radeon_device *rdev, uint32_t reg, uint32_t v)
 {
-	WREG32(RADEON_PCIE_INDEX, ((reg) & 0x7ff));
-	(void)RREG32(RADEON_PCIE_INDEX);
-	WREG32(RADEON_PCIE_DATA, (v));
-	(void)RREG32(RADEON_PCIE_DATA);
+	WREG32(PCIE_INDEX, ((reg) & 0x7ff));
+	(void)RREG32(PCIE_INDEX);
+	WREG32(PCIE_DATA, (v));
+	(void)RREG32(PCIE_DATA);
 }
 
 
@@ -450,13 +432,13 @@ static int rv515_debugfs_pipes_info(struct seq_file *m, void *data)
 	struct radeon_device *rdev = dev->dev_private;
 	uint32_t tmp;
 
-	tmp = RREG32(R400_GB_PIPE_SELECT);
+	tmp = RREG32(GB_PIPE_SELECT);
 	seq_printf(m, "GB_PIPE_SELECT 0x%08x\n", tmp);
-	tmp = RREG32(R500_SU_REG_DEST);
+	tmp = RREG32(SU_REG_DEST);
 	seq_printf(m, "SU_REG_DEST 0x%08x\n", tmp);
-	tmp = RREG32(R300_GB_TILE_CONFIG);
+	tmp = RREG32(GB_TILE_CONFIG);
 	seq_printf(m, "GB_TILE_CONFIG 0x%08x\n", tmp);
-	tmp = RREG32(R300_DST_PIPE_CONFIG);
+	tmp = RREG32(DST_PIPE_CONFIG);
 	seq_printf(m, "DST_PIPE_CONFIG 0x%08x\n", tmp);
 	return 0;
 }
@@ -571,3 +553,551 @@ int rv515_init(struct radeon_device *rdev)
 	rdev->config.r300.reg_safe_bm_size = ARRAY_SIZE(r500_reg_safe_bm);
 	return 0;
 }
+
+void atom_rv515_force_tv_scaler(struct radeon_device *rdev)
+{
+
+	WREG32(0x659C, 0x0);
+	WREG32(0x6594, 0x705);
+	WREG32(0x65A4, 0x10001);
+	WREG32(0x65D8, 0x0);
+	WREG32(0x65B0, 0x0);
+	WREG32(0x65C0, 0x0);
+	WREG32(0x65D4, 0x0);
+	WREG32(0x6578, 0x0);
+	WREG32(0x657C, 0x841880A8);
+	WREG32(0x6578, 0x1);
+	WREG32(0x657C, 0x84208680);
+	WREG32(0x6578, 0x2);
+	WREG32(0x657C, 0xBFF880B0);
+	WREG32(0x6578, 0x100);
+	WREG32(0x657C, 0x83D88088);
+	WREG32(0x6578, 0x101);
+	WREG32(0x657C, 0x84608680);
+	WREG32(0x6578, 0x102);
+	WREG32(0x657C, 0xBFF080D0);
+	WREG32(0x6578, 0x200);
+	WREG32(0x657C, 0x83988068);
+	WREG32(0x6578, 0x201);
+	WREG32(0x657C, 0x84A08680);
+	WREG32(0x6578, 0x202);
+	WREG32(0x657C, 0xBFF080F8);
+	WREG32(0x6578, 0x300);
+	WREG32(0x657C, 0x83588058);
+	WREG32(0x6578, 0x301);
+	WREG32(0x657C, 0x84E08660);
+	WREG32(0x6578, 0x302);
+	WREG32(0x657C, 0xBFF88120);
+	WREG32(0x6578, 0x400);
+	WREG32(0x657C, 0x83188040);
+	WREG32(0x6578, 0x401);
+	WREG32(0x657C, 0x85008660);
+	WREG32(0x6578, 0x402);
+	WREG32(0x657C, 0xBFF88150);
+	WREG32(0x6578, 0x500);
+	WREG32(0x657C, 0x82D88030);
+	WREG32(0x6578, 0x501);
+	WREG32(0x657C, 0x85408640);
+	WREG32(0x6578, 0x502);
+	WREG32(0x657C, 0xBFF88180);
+	WREG32(0x6578, 0x600);
+	WREG32(0x657C, 0x82A08018);
+	WREG32(0x6578, 0x601);
+	WREG32(0x657C, 0x85808620);
+	WREG32(0x6578, 0x602);
+	WREG32(0x657C, 0xBFF081B8);
+	WREG32(0x6578, 0x700);
+	WREG32(0x657C, 0x82608010);
+	WREG32(0x6578, 0x701);
+	WREG32(0x657C, 0x85A08600);
+	WREG32(0x6578, 0x702);
+	WREG32(0x657C, 0x800081F0);
+	WREG32(0x6578, 0x800);
+	WREG32(0x657C, 0x8228BFF8);
+	WREG32(0x6578, 0x801);
+	WREG32(0x657C, 0x85E085E0);
+	WREG32(0x6578, 0x802);
+	WREG32(0x657C, 0xBFF88228);
+	WREG32(0x6578, 0x10000);
+	WREG32(0x657C, 0x82A8BF00);
+	WREG32(0x6578, 0x10001);
+	WREG32(0x657C, 0x82A08CC0);
+	WREG32(0x6578, 0x10002);
+	WREG32(0x657C, 0x8008BEF8);
+	WREG32(0x6578, 0x10100);
+	WREG32(0x657C, 0x81F0BF28);
+	WREG32(0x6578, 0x10101);
+	WREG32(0x657C, 0x83608CA0);
+	WREG32(0x6578, 0x10102);
+	WREG32(0x657C, 0x8018BED0);
+	WREG32(0x6578, 0x10200);
+	WREG32(0x657C, 0x8148BF38);
+	WREG32(0x6578, 0x10201);
+	WREG32(0x657C, 0x84408C80);
+	WREG32(0x6578, 0x10202);
+	WREG32(0x657C, 0x8008BEB8);
+	WREG32(0x6578, 0x10300);
+	WREG32(0x657C, 0x80B0BF78);
+	WREG32(0x6578, 0x10301);
+	WREG32(0x657C, 0x85008C20);
+	WREG32(0x6578, 0x10302);
+	WREG32(0x657C, 0x8020BEA0);
+	WREG32(0x6578, 0x10400);
+	WREG32(0x657C, 0x8028BF90);
+	WREG32(0x6578, 0x10401);
+	WREG32(0x657C, 0x85E08BC0);
+	WREG32(0x6578, 0x10402);
+	WREG32(0x657C, 0x8018BE90);
+	WREG32(0x6578, 0x10500);
+	WREG32(0x657C, 0xBFB8BFB0);
+	WREG32(0x6578, 0x10501);
+	WREG32(0x657C, 0x86C08B40);
+	WREG32(0x6578, 0x10502);
+	WREG32(0x657C, 0x8010BE90);
+	WREG32(0x6578, 0x10600);
+	WREG32(0x657C, 0xBF58BFC8);
+	WREG32(0x6578, 0x10601);
+	WREG32(0x657C, 0x87A08AA0);
+	WREG32(0x6578, 0x10602);
+	WREG32(0x657C, 0x8010BE98);
+	WREG32(0x6578, 0x10700);
+	WREG32(0x657C, 0xBF10BFF0);
+	WREG32(0x6578, 0x10701);
+	WREG32(0x657C, 0x886089E0);
+	WREG32(0x6578, 0x10702);
+	WREG32(0x657C, 0x8018BEB0);
+	WREG32(0x6578, 0x10800);
+	WREG32(0x657C, 0xBED8BFE8);
+	WREG32(0x6578, 0x10801);
+	WREG32(0x657C, 0x89408940);
+	WREG32(0x6578, 0x10802);
+	WREG32(0x657C, 0xBFE8BED8);
+	WREG32(0x6578, 0x20000);
+	WREG32(0x657C, 0x80008000);
+	WREG32(0x6578, 0x20001);
+	WREG32(0x657C, 0x90008000);
+	WREG32(0x6578, 0x20002);
+	WREG32(0x657C, 0x80008000);
+	WREG32(0x6578, 0x20003);
+	WREG32(0x657C, 0x80008000);
+	WREG32(0x6578, 0x20100);
+	WREG32(0x657C, 0x80108000);
+	WREG32(0x6578, 0x20101);
+	WREG32(0x657C, 0x8FE0BF70);
+	WREG32(0x6578, 0x20102);
+	WREG32(0x657C, 0xBFE880C0);
+	WREG32(0x6578, 0x20103);
+	WREG32(0x657C, 0x80008000);
+	WREG32(0x6578, 0x20200);
+	WREG32(0x657C, 0x8018BFF8);
+	WREG32(0x6578, 0x20201);
+	WREG32(0x657C, 0x8F80BF08);
+	WREG32(0x6578, 0x20202);
+	WREG32(0x657C, 0xBFD081A0);
+	WREG32(0x6578, 0x20203);
+	WREG32(0x657C, 0xBFF88000);
+	WREG32(0x6578, 0x20300);
+	WREG32(0x657C, 0x80188000);
+	WREG32(0x6578, 0x20301);
+	WREG32(0x657C, 0x8EE0BEC0);
+	WREG32(0x6578, 0x20302);
+	WREG32(0x657C, 0xBFB082A0);
+	WREG32(0x6578, 0x20303);
+	WREG32(0x657C, 0x80008000);
+	WREG32(0x6578, 0x20400);
+	WREG32(0x657C, 0x80188000);
+	WREG32(0x6578, 0x20401);
+	WREG32(0x657C, 0x8E00BEA0);
+	WREG32(0x6578, 0x20402);
+	WREG32(0x657C, 0xBF8883C0);
+	WREG32(0x6578, 0x20403);
+	WREG32(0x657C, 0x80008000);
+	WREG32(0x6578, 0x20500);
+	WREG32(0x657C, 0x80188000);
+	WREG32(0x6578, 0x20501);
+	WREG32(0x657C, 0x8D00BE90);
+	WREG32(0x6578, 0x20502);
+	WREG32(0x657C, 0xBF588500);
+	WREG32(0x6578, 0x20503);
+	WREG32(0x657C, 0x80008008);
+	WREG32(0x6578, 0x20600);
+	WREG32(0x657C, 0x80188000);
+	WREG32(0x6578, 0x20601);
+	WREG32(0x657C, 0x8BC0BE98);
+	WREG32(0x6578, 0x20602);
+	WREG32(0x657C, 0xBF308660);
+	WREG32(0x6578, 0x20603);
+	WREG32(0x657C, 0x80008008);
+	WREG32(0x6578, 0x20700);
+	WREG32(0x657C, 0x80108000);
+	WREG32(0x6578, 0x20701);
+	WREG32(0x657C, 0x8A80BEB0);
+	WREG32(0x6578, 0x20702);
+	WREG32(0x657C, 0xBF0087C0);
+	WREG32(0x6578, 0x20703);
+	WREG32(0x657C, 0x80008008);
+	WREG32(0x6578, 0x20800);
+	WREG32(0x657C, 0x80108000);
+	WREG32(0x6578, 0x20801);
+	WREG32(0x657C, 0x8920BED0);
+	WREG32(0x6578, 0x20802);
+	WREG32(0x657C, 0xBED08920);
+	WREG32(0x6578, 0x20803);
+	WREG32(0x657C, 0x80008010);
+	WREG32(0x6578, 0x30000);
+	WREG32(0x657C, 0x90008000);
+	WREG32(0x6578, 0x30001);
+	WREG32(0x657C, 0x80008000);
+	WREG32(0x6578, 0x30100);
+	WREG32(0x657C, 0x8FE0BF90);
+	WREG32(0x6578, 0x30101);
+	WREG32(0x657C, 0xBFF880A0);
+	WREG32(0x6578, 0x30200);
+	WREG32(0x657C, 0x8F60BF40);
+	WREG32(0x6578, 0x30201);
+	WREG32(0x657C, 0xBFE88180);
+	WREG32(0x6578, 0x30300);
+	WREG32(0x657C, 0x8EC0BF00);
+	WREG32(0x6578, 0x30301);
+	WREG32(0x657C, 0xBFC88280);
+	WREG32(0x6578, 0x30400);
+	WREG32(0x657C, 0x8DE0BEE0);
+	WREG32(0x6578, 0x30401);
+	WREG32(0x657C, 0xBFA083A0);
+	WREG32(0x6578, 0x30500);
+	WREG32(0x657C, 0x8CE0BED0);
+	WREG32(0x6578, 0x30501);
+	WREG32(0x657C, 0xBF7884E0);
+	WREG32(0x6578, 0x30600);
+	WREG32(0x657C, 0x8BA0BED8);
+	WREG32(0x6578, 0x30601);
+	WREG32(0x657C, 0xBF508640);
+	WREG32(0x6578, 0x30700);
+	WREG32(0x657C, 0x8A60BEE8);
+	WREG32(0x6578, 0x30701);
+	WREG32(0x657C, 0xBF2087A0);
+	WREG32(0x6578, 0x30800);
+	WREG32(0x657C, 0x8900BF00);
+	WREG32(0x6578, 0x30801);
+	WREG32(0x657C, 0xBF008900);
+}
+
+struct rv515_watermark {
+	u32        lb_request_fifo_depth;
+	fixed20_12 num_line_pair;
+	fixed20_12 estimated_width;
+	fixed20_12 worst_case_latency;
+	fixed20_12 consumption_rate;
+	fixed20_12 active_time;
+	fixed20_12 dbpp;
+	fixed20_12 priority_mark_max;
+	fixed20_12 priority_mark;
+	fixed20_12 sclk;
+};
+
+void rv515_crtc_bandwidth_compute(struct radeon_device *rdev,
+				  struct radeon_crtc *crtc,
+				  struct rv515_watermark *wm)
+{
+	struct drm_display_mode *mode = &crtc->base.mode;
+	fixed20_12 a, b, c;
+	fixed20_12 pclk, request_fifo_depth, tolerable_latency, estimated_width;
+	fixed20_12 consumption_time, line_time, chunk_time, read_delay_latency;
+
+	if (!crtc->base.enabled) {
+		/* FIXME: wouldn't it better to set priority mark to maximum */
+		wm->lb_request_fifo_depth = 4;
+		return;
+	}
+
+	if (crtc->vsc.full > rfixed_const(2))
+		wm->num_line_pair.full = rfixed_const(2);
+	else
+		wm->num_line_pair.full = rfixed_const(1);
+
+	b.full = rfixed_const(mode->crtc_hdisplay);
+	c.full = rfixed_const(256);
+	a.full = rfixed_mul(wm->num_line_pair, b);
+	request_fifo_depth.full = rfixed_div(a, c);
+	if (a.full < rfixed_const(4)) {
+		wm->lb_request_fifo_depth = 4;
+	} else {
+		wm->lb_request_fifo_depth = rfixed_trunc(request_fifo_depth);
+	}
+
+	/* Determine consumption rate
+	 *  pclk = pixel clock period(ns) = 1000 / (mode.clock / 1000)
+	 *  vtaps = number of vertical taps,
+	 *  vsc = vertical scaling ratio, defined as source/destination
+	 *  hsc = horizontal scaling ration, defined as source/destination
+	 */
+	a.full = rfixed_const(mode->clock);
+	b.full = rfixed_const(1000);
+	a.full = rfixed_div(a, b);
+	pclk.full = rfixed_div(b, a);
+	if (crtc->rmx_type != RMX_OFF) {
+		b.full = rfixed_const(2);
+		if (crtc->vsc.full > b.full)
+			b.full = crtc->vsc.full;
+		b.full = rfixed_mul(b, crtc->hsc);
+		c.full = rfixed_const(2);
+		b.full = rfixed_div(b, c);
+		consumption_time.full = rfixed_div(pclk, b);
+	} else {
+		consumption_time.full = pclk.full;
+	}
+	a.full = rfixed_const(1);
+	wm->consumption_rate.full = rfixed_div(a, consumption_time);
+
+
+	/* Determine line time
+	 *  LineTime = total time for one line of displayhtotal
+	 *  LineTime = total number of horizontal pixels
+	 *  pclk = pixel clock period(ns)
+	 */
+	a.full = rfixed_const(crtc->base.mode.crtc_htotal);
+	line_time.full = rfixed_mul(a, pclk);
+
+	/* Determine active time
+	 *  ActiveTime = time of active region of display within one line,
+	 *  hactive = total number of horizontal active pixels
+	 *  htotal = total number of horizontal pixels
+	 */
+	a.full = rfixed_const(crtc->base.mode.crtc_htotal);
+	b.full = rfixed_const(crtc->base.mode.crtc_hdisplay);
+	wm->active_time.full = rfixed_mul(line_time, b);
+	wm->active_time.full = rfixed_div(wm->active_time, a);
+
+	/* Determine chunk time
+	 * ChunkTime = the time it takes the DCP to send one chunk of data
+	 * to the LB which consists of pipeline delay and inter chunk gap
+	 * sclk = system clock(Mhz)
+	 */
+	a.full = rfixed_const(600 * 1000);
+	chunk_time.full = rfixed_div(a, rdev->pm.sclk);
+	read_delay_latency.full = rfixed_const(1000);
+
+	/* Determine the worst case latency
+	 * NumLinePair = Number of line pairs to request(1=2 lines, 2=4 lines)
+	 * WorstCaseLatency = worst case time from urgent to when the MC starts
+	 *                    to return data
+	 * READ_DELAY_IDLE_MAX = constant of 1us
+	 * ChunkTime = time it takes the DCP to send one chunk of data to the LB
+	 *             which consists of pipeline delay and inter chunk gap
+	 */
+	if (rfixed_trunc(wm->num_line_pair) > 1) {
+		a.full = rfixed_const(3);
+		wm->worst_case_latency.full = rfixed_mul(a, chunk_time);
+		wm->worst_case_latency.full += read_delay_latency.full;
+	} else {
+		wm->worst_case_latency.full = chunk_time.full + read_delay_latency.full;
+	}
+
+	/* Determine the tolerable latency
+	 * TolerableLatency = Any given request has only 1 line time
+	 *                    for the data to be returned
+	 * LBRequestFifoDepth = Number of chunk requests the LB can
+	 *                      put into the request FIFO for a display
+	 *  LineTime = total time for one line of display
+	 *  ChunkTime = the time it takes the DCP to send one chunk
+	 *              of data to the LB which consists of
+	 *  pipeline delay and inter chunk gap
+	 */
+	if ((2+wm->lb_request_fifo_depth) >= rfixed_trunc(request_fifo_depth)) {
+		tolerable_latency.full = line_time.full;
+	} else {
+		tolerable_latency.full = rfixed_const(wm->lb_request_fifo_depth - 2);
+		tolerable_latency.full = request_fifo_depth.full - tolerable_latency.full;
+		tolerable_latency.full = rfixed_mul(tolerable_latency, chunk_time);
+		tolerable_latency.full = line_time.full - tolerable_latency.full;
+	}
+	/* We assume worst case 32bits (4 bytes) */
+	wm->dbpp.full = rfixed_const(2 * 16);
+
+	/* Determine the maximum priority mark
+	 *  width = viewport width in pixels
+	 */
+	a.full = rfixed_const(16);
+	wm->priority_mark_max.full = rfixed_const(crtc->base.mode.crtc_hdisplay);
+	wm->priority_mark_max.full = rfixed_div(wm->priority_mark_max, a);
+
+	/* Determine estimated width */
+	estimated_width.full = tolerable_latency.full - wm->worst_case_latency.full;
+	estimated_width.full = rfixed_div(estimated_width, consumption_time);
+	if (rfixed_trunc(estimated_width) > crtc->base.mode.crtc_hdisplay) {
+		wm->priority_mark.full = rfixed_const(10);
+	} else {
+		a.full = rfixed_const(16);
+		wm->priority_mark.full = rfixed_div(estimated_width, a);
+		wm->priority_mark.full = wm->priority_mark_max.full - wm->priority_mark.full;
+	}
+}
+
+void rv515_bandwidth_avivo_update(struct radeon_device *rdev)
+{
+	struct drm_display_mode *mode0 = NULL;
+	struct drm_display_mode *mode1 = NULL;
+	struct rv515_watermark wm0;
+	struct rv515_watermark wm1;
+	u32 tmp;
+	fixed20_12 priority_mark02, priority_mark12, fill_rate;
+	fixed20_12 a, b;
+
+	if (rdev->mode_info.crtcs[0]->base.enabled)
+		mode0 = &rdev->mode_info.crtcs[0]->base.mode;
+	if (rdev->mode_info.crtcs[1]->base.enabled)
+		mode1 = &rdev->mode_info.crtcs[1]->base.mode;
+	rs690_line_buffer_adjust(rdev, mode0, mode1);
+
+	rv515_crtc_bandwidth_compute(rdev, rdev->mode_info.crtcs[0], &wm0);
+	rv515_crtc_bandwidth_compute(rdev, rdev->mode_info.crtcs[1], &wm1);
+
+	tmp = wm0.lb_request_fifo_depth;
+	tmp |= wm1.lb_request_fifo_depth << 16;
+	WREG32(LB_MAX_REQ_OUTSTANDING, tmp);
+
+	if (mode0 && mode1) {
+		if (rfixed_trunc(wm0.dbpp) > 64)
+			a.full = rfixed_div(wm0.dbpp, wm0.num_line_pair);
+		else
+			a.full = wm0.num_line_pair.full;
+		if (rfixed_trunc(wm1.dbpp) > 64)
+			b.full = rfixed_div(wm1.dbpp, wm1.num_line_pair);
+		else
+			b.full = wm1.num_line_pair.full;
+		a.full += b.full;
+		fill_rate.full = rfixed_div(wm0.sclk, a);
+		if (wm0.consumption_rate.full > fill_rate.full) {
+			b.full = wm0.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm0.active_time);
+			a.full = rfixed_const(16);
+			b.full = rfixed_div(b, a);
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			priority_mark02.full = a.full + b.full;
+		} else {
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			b.full = rfixed_const(16 * 1000);
+			priority_mark02.full = rfixed_div(a, b);
+		}
+		if (wm1.consumption_rate.full > fill_rate.full) {
+			b.full = wm1.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm1.active_time);
+			a.full = rfixed_const(16);
+			b.full = rfixed_div(b, a);
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			priority_mark12.full = a.full + b.full;
+		} else {
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			b.full = rfixed_const(16 * 1000);
+			priority_mark12.full = rfixed_div(a, b);
+		}
+		if (wm0.priority_mark.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark.full;
+		if (rfixed_trunc(priority_mark02) < 0)
+			priority_mark02.full = 0;
+		if (wm0.priority_mark_max.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark_max.full;
+		if (wm1.priority_mark.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark.full;
+		if (rfixed_trunc(priority_mark12) < 0)
+			priority_mark12.full = 0;
+		if (wm1.priority_mark_max.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark_max.full;
+		WREG32(D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
+		WREG32(D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
+	} else if (mode0) {
+		if (rfixed_trunc(wm0.dbpp) > 64)
+			a.full = rfixed_div(wm0.dbpp, wm0.num_line_pair);
+		else
+			a.full = wm0.num_line_pair.full;
+		fill_rate.full = rfixed_div(wm0.sclk, a);
+		if (wm0.consumption_rate.full > fill_rate.full) {
+			b.full = wm0.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm0.active_time);
+			a.full = rfixed_const(16);
+			b.full = rfixed_div(b, a);
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			priority_mark02.full = a.full + b.full;
+		} else {
+			a.full = rfixed_mul(wm0.worst_case_latency,
+						wm0.consumption_rate);
+			b.full = rfixed_const(16);
+			priority_mark02.full = rfixed_div(a, b);
+		}
+		if (wm0.priority_mark.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark.full;
+		if (rfixed_trunc(priority_mark02) < 0)
+			priority_mark02.full = 0;
+		if (wm0.priority_mark_max.full > priority_mark02.full)
+			priority_mark02.full = wm0.priority_mark_max.full;
+		WREG32(D1MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D1MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark02));
+		WREG32(D2MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
+		WREG32(D2MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
+	} else {
+		if (rfixed_trunc(wm1.dbpp) > 64)
+			a.full = rfixed_div(wm1.dbpp, wm1.num_line_pair);
+		else
+			a.full = wm1.num_line_pair.full;
+		fill_rate.full = rfixed_div(wm1.sclk, a);
+		if (wm1.consumption_rate.full > fill_rate.full) {
+			b.full = wm1.consumption_rate.full - fill_rate.full;
+			b.full = rfixed_mul(b, wm1.active_time);
+			a.full = rfixed_const(16);
+			b.full = rfixed_div(b, a);
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			priority_mark12.full = a.full + b.full;
+		} else {
+			a.full = rfixed_mul(wm1.worst_case_latency,
+						wm1.consumption_rate);
+			b.full = rfixed_const(16 * 1000);
+			priority_mark12.full = rfixed_div(a, b);
+		}
+		if (wm1.priority_mark.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark.full;
+		if (rfixed_trunc(priority_mark12) < 0)
+			priority_mark12.full = 0;
+		if (wm1.priority_mark_max.full > priority_mark12.full)
+			priority_mark12.full = wm1.priority_mark_max.full;
+		WREG32(D1MODE_PRIORITY_A_CNT, MODE_PRIORITY_OFF);
+		WREG32(D1MODE_PRIORITY_B_CNT, MODE_PRIORITY_OFF);
+		WREG32(D2MODE_PRIORITY_A_CNT, rfixed_trunc(priority_mark12));
+		WREG32(D2MODE_PRIORITY_B_CNT, rfixed_trunc(priority_mark12));
+	}
+}
+
+void rv515_bandwidth_update(struct radeon_device *rdev)
+{
+	uint32_t tmp;
+	struct drm_display_mode *mode0 = NULL;
+	struct drm_display_mode *mode1 = NULL;
+
+	if (rdev->mode_info.crtcs[0]->base.enabled)
+		mode0 = &rdev->mode_info.crtcs[0]->base.mode;
+	if (rdev->mode_info.crtcs[1]->base.enabled)
+		mode1 = &rdev->mode_info.crtcs[1]->base.mode;
+	/*
+	 * Set display0/1 priority up in the memory controller for
+	 * modes if the user specifies HIGH for displaypriority
+	 * option.
+	 */
+	if (rdev->disp_priority == 2) {
+		tmp = RREG32_MC(MC_MISC_LAT_TIMER);
+		tmp &= ~MC_DISP1R_INIT_LAT_MASK;
+		tmp &= ~MC_DISP0R_INIT_LAT_MASK;
+		if (mode1)
+			tmp |= (1 << MC_DISP1R_INIT_LAT_SHIFT);
+		if (mode0)
+			tmp |= (1 << MC_DISP0R_INIT_LAT_SHIFT);
+		WREG32_MC(MC_MISC_LAT_TIMER, tmp);
+	}
+	rv515_bandwidth_avivo_update(rdev);
+}
diff --git a/drivers/gpu/drm/radeon/rv515r.h b/drivers/gpu/drm/radeon/rv515r.h
new file mode 100644
index 0000000..f3cf840
--- /dev/null
+++ b/drivers/gpu/drm/radeon/rv515r.h
@@ -0,0 +1,170 @@
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
+#ifndef RV515R_H
+#define RV515R_H
+
+/* RV515 registers */
+#define PCIE_INDEX			0x0030
+#define PCIE_DATA			0x0034
+#define	MC_IND_INDEX			0x0070
+#define		MC_IND_WR_EN				(1 << 24)
+#define	MC_IND_DATA			0x0074
+#define	RBBM_SOFT_RESET			0x00F0
+#define	CONFIG_MEMSIZE			0x00F8
+#define HDP_FB_LOCATION			0x0134
+#define	CP_CSQ_CNTL			0x0740
+#define	CP_CSQ_MODE			0x0744
+#define	CP_CSQ_ADDR			0x07F0
+#define	CP_CSQ_DATA			0x07F4
+#define	CP_CSQ_STAT			0x07F8
+#define	CP_CSQ2_STAT			0x07FC
+#define	RBBM_STATUS			0x0E40
+#define	DST_PIPE_CONFIG			0x170C
+#define	WAIT_UNTIL			0x1720
+#define		WAIT_2D_IDLE				(1 << 14)
+#define		WAIT_3D_IDLE				(1 << 15)
+#define		WAIT_2D_IDLECLEAN			(1 << 16)
+#define		WAIT_3D_IDLECLEAN			(1 << 17)
+#define	ISYNC_CNTL			0x1724
+#define		ISYNC_ANY2D_IDLE3D			(1 << 0)
+#define		ISYNC_ANY3D_IDLE2D			(1 << 1)
+#define		ISYNC_TRIG2D_IDLE3D			(1 << 2)
+#define		ISYNC_TRIG3D_IDLE2D			(1 << 3)
+#define		ISYNC_WAIT_IDLEGUI			(1 << 4)
+#define		ISYNC_CPSCRATCH_IDLEGUI			(1 << 5)
+#define	VAP_INDEX_OFFSET		0x208C
+#define	VAP_PVS_STATE_FLUSH_REG		0x2284
+#define	GB_ENABLE			0x4008
+#define	GB_MSPOS0			0x4010
+#define		MS_X0_SHIFT				0
+#define		MS_Y0_SHIFT				4
+#define		MS_X1_SHIFT				8
+#define		MS_Y1_SHIFT				12
+#define		MS_X2_SHIFT				16
+#define		MS_Y2_SHIFT				20
+#define		MSBD0_Y_SHIFT				24
+#define		MSBD0_X_SHIFT				28
+#define	GB_MSPOS1			0x4014
+#define		MS_X3_SHIFT				0
+#define		MS_Y3_SHIFT				4
+#define		MS_X4_SHIFT				8
+#define		MS_Y4_SHIFT				12
+#define		MS_X5_SHIFT				16
+#define		MS_Y5_SHIFT				20
+#define		MSBD1_SHIFT				24
+#define GB_TILE_CONFIG			0x4018
+#define		ENABLE_TILING				(1 << 0)
+#define		PIPE_COUNT_MASK				0x0000000E
+#define		PIPE_COUNT_SHIFT			1
+#define		TILE_SIZE_8				(0 << 4)
+#define		TILE_SIZE_16				(1 << 4)
+#define		TILE_SIZE_32				(2 << 4)
+#define		SUBPIXEL_1_12				(0 << 16)
+#define		SUBPIXEL_1_16				(1 << 16)
+#define	GB_SELECT			0x401C
+#define	GB_AA_CONFIG			0x4020
+#define	GB_PIPE_SELECT			0x402C
+#define	GA_ENHANCE			0x4274
+#define		GA_DEADLOCK_CNTL			(1 << 0)
+#define		GA_FASTSYNC_CNTL			(1 << 1)
+#define	GA_POLY_MODE			0x4288
+#define		FRONT_PTYPE_POINT			(0 << 4)
+#define		FRONT_PTYPE_LINE			(1 << 4)
+#define		FRONT_PTYPE_TRIANGE			(2 << 4)
+#define		BACK_PTYPE_POINT			(0 << 7)
+#define		BACK_PTYPE_LINE				(1 << 7)
+#define		BACK_PTYPE_TRIANGE			(2 << 7)
+#define	GA_ROUND_MODE			0x428C
+#define		GEOMETRY_ROUND_TRUNC			(0 << 0)
+#define		GEOMETRY_ROUND_NEAREST			(1 << 0)
+#define		COLOR_ROUND_TRUNC			(0 << 2)
+#define		COLOR_ROUND_NEAREST			(1 << 2)
+#define	SU_REG_DEST			0x42C8
+#define	RB3D_DSTCACHE_CTLSTAT		0x4E4C
+#define		RB3D_DC_FLUSH				(2 << 0)
+#define		RB3D_DC_FREE				(2 << 2)
+#define		RB3D_DC_FINISH				(1 << 4)
+#define ZB_ZCACHE_CTLSTAT		0x4F18
+#define		ZC_FLUSH				(1 << 0)
+#define		ZC_FREE					(1 << 1)
+#define DC_LB_MEMORY_SPLIT		0x6520
+#define		DC_LB_MEMORY_SPLIT_MASK			0x00000003
+#define		DC_LB_MEMORY_SPLIT_SHIFT		0
+#define		DC_LB_MEMORY_SPLIT_D1HALF_D2HALF	0
+#define		DC_LB_MEMORY_SPLIT_D1_3Q_D2_1Q		1
+#define		DC_LB_MEMORY_SPLIT_D1_ONLY		2
+#define		DC_LB_MEMORY_SPLIT_D1_1Q_D2_3Q		3
+#define		DC_LB_MEMORY_SPLIT_SHIFT_MODE		(1 << 2)
+#define		DC_LB_DISP1_END_ADR_SHIFT		4
+#define		DC_LB_DISP1_END_ADR_MASK		0x00007FF0
+#define D1MODE_PRIORITY_A_CNT		0x6548
+#define		MODE_PRIORITY_MARK_MASK			0x00007FFF
+#define		MODE_PRIORITY_OFF			(1 << 16)
+#define		MODE_PRIORITY_ALWAYS_ON			(1 << 20)
+#define		MODE_PRIORITY_FORCE_MASK		(1 << 24)
+#define D1MODE_PRIORITY_B_CNT		0x654C
+#define LB_MAX_REQ_OUTSTANDING		0x6D58
+#define		LB_D1_MAX_REQ_OUTSTANDING_MASK		0x0000000F
+#define		LB_D1_MAX_REQ_OUTSTANDING_SHIFT		0
+#define		LB_D2_MAX_REQ_OUTSTANDING_MASK		0x000F0000
+#define		LB_D2_MAX_REQ_OUTSTANDING_SHIFT		16
+#define D2MODE_PRIORITY_A_CNT		0x6D48
+#define D2MODE_PRIORITY_B_CNT		0x6D4C
+
+/* ix[MC] registers */
+#define MC_FB_LOCATION			0x01
+#define		MC_FB_START_MASK			0x0000FFFF
+#define		MC_FB_START_SHIFT			0
+#define		MC_FB_TOP_MASK				0xFFFF0000
+#define		MC_FB_TOP_SHIFT				16
+#define MC_AGP_LOCATION			0x02
+#define		MC_AGP_START_MASK			0x0000FFFF
+#define		MC_AGP_START_SHIFT			0
+#define		MC_AGP_TOP_MASK				0xFFFF0000
+#define		MC_AGP_TOP_SHIFT			16
+#define MC_AGP_BASE			0x03
+#define MC_AGP_BASE_2			0x04
+#define	MC_CNTL				0x5
+#define		MEM_NUM_CHANNELS_MASK			0x00000003
+#define	MC_STATUS			0x08
+#define		MC_STATUS_IDLE				(1 << 4)
+#define	MC_MISC_LAT_TIMER		0x09
+#define		MC_CPR_INIT_LAT_MASK			0x0000000F
+#define		MC_VF_INIT_LAT_MASK			0x000000F0
+#define		MC_DISP0R_INIT_LAT_MASK			0x00000F00
+#define		MC_DISP0R_INIT_LAT_SHIFT		8
+#define		MC_DISP1R_INIT_LAT_MASK			0x0000F000
+#define		MC_DISP1R_INIT_LAT_SHIFT		12
+#define		MC_FIXED_INIT_LAT_MASK			0x000F0000
+#define		MC_E2R_INIT_LAT_MASK			0x00F00000
+#define		SAME_PAGE_PRIO_MASK			0x0F000000
+#define		MC_GLOBW_INIT_LAT_MASK			0xF0000000
+
+
+#endif
+
-- 
1.6.2.2

