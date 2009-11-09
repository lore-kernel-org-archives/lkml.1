Return-Path: <linux-kernel-owner+w=401wt.eu-S1755190AbZKILq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190AbZKILq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 06:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbZKILq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 06:46:27 -0500
Received: from smtp.nokia.com ([192.100.105.134]:41557 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946AbZKILqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 06:46:15 -0500
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 10/19] OMAP: DSS2: DPI driver
Date: Mon,  9 Nov 2009 13:45:17 +0200
Message-Id: <1257767126-12059-11-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1257767126-12059-10-git-send-email-tomi.valkeinen@nokia.com>
References: <1257767126-12059-1-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-2-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-3-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-4-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-5-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-6-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-7-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-8-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-9-git-send-email-tomi.valkeinen@nokia.com>
 <1257767126-12059-10-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 09 Nov 2009 11:46:06.0419 (UTC) FILETIME=[38E3C230:01CA6132]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This implements MIPI DPI interface.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
---
 drivers/video/omap2/dss/dpi.c |  399 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 399 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/omap2/dss/dpi.c

diff --git a/drivers/video/omap2/dss/dpi.c b/drivers/video/omap2/dss/dpi.c
new file mode 100644
index 0000000..2d71031
--- /dev/null
+++ b/drivers/video/omap2/dss/dpi.c
@@ -0,0 +1,399 @@
+/*
+ * linux/drivers/video/omap2/dss/dpi.c
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Tomi Valkeinen <tomi.valkeinen@nokia.com>
+ *
+ * Some code and ideas taken from drivers/video/omap/ driver
+ * by Imre Deak.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define DSS_SUBSYS_NAME "DPI"
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/errno.h>
+
+#include <plat/display.h>
+#include <plat/cpu.h>
+
+#include "dss.h"
+
+static struct {
+	int update_enabled;
+} dpi;
+
+#ifdef CONFIG_OMAP2_DSS_USE_DSI_PLL
+static int dpi_set_dsi_clk(bool is_tft, unsigned long pck_req,
+		unsigned long *fck, int *lck_div, int *pck_div)
+{
+	struct dsi_clock_info dsi_cinfo;
+	struct dispc_clock_info dispc_cinfo;
+	int r;
+
+	r = dsi_pll_calc_clock_div_pck(is_tft, pck_req, &dsi_cinfo,
+			&dispc_cinfo);
+	if (r)
+		return r;
+
+	r = dsi_pll_set_clock_div(&dsi_cinfo);
+	if (r)
+		return r;
+
+	dss_select_clk_source(0, 1);
+
+	r = dispc_set_clock_div(&dispc_cinfo);
+	if (r)
+		return r;
+
+	*fck = dsi_cinfo.dsi1_pll_fclk;
+	*lck_div = dispc_cinfo.lck_div;
+	*pck_div = dispc_cinfo.pck_div;
+
+	return 0;
+}
+#else
+static int dpi_set_dispc_clk(bool is_tft, unsigned long pck_req,
+		unsigned long *fck, int *lck_div, int *pck_div)
+{
+	struct dss_clock_info dss_cinfo;
+	struct dispc_clock_info dispc_cinfo;
+	int r;
+
+	r = dss_calc_clock_div(is_tft, pck_req, &dss_cinfo, &dispc_cinfo);
+	if (r)
+		return r;
+
+	r = dss_set_clock_div(&dss_cinfo);
+	if (r)
+		return r;
+
+	r = dispc_set_clock_div(&dispc_cinfo);
+	if (r)
+		return r;
+
+	*fck = dss_cinfo.fck;
+	*lck_div = dispc_cinfo.lck_div;
+	*pck_div = dispc_cinfo.pck_div;
+
+	return 0;
+}
+#endif
+
+static int dpi_set_mode(struct omap_dss_device *dssdev)
+{
+	struct omap_video_timings *t = &dssdev->panel.timings;
+	int lck_div, pck_div;
+	unsigned long fck;
+	unsigned long pck;
+	bool is_tft;
+	int r = 0;
+
+	dss_clk_enable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	dispc_set_pol_freq(dssdev->panel.config, dssdev->panel.acbi,
+			dssdev->panel.acb);
+
+	is_tft = (dssdev->panel.config & OMAP_DSS_LCD_TFT) != 0;
+
+#ifdef CONFIG_OMAP2_DSS_USE_DSI_PLL
+	r = dpi_set_dsi_clk(is_tft, t->pixel_clock * 1000,
+			&fck, &lck_div, &pck_div);
+#else
+	r = dpi_set_dispc_clk(is_tft, t->pixel_clock * 1000,
+			&fck, &lck_div, &pck_div);
+#endif
+	if (r)
+		goto err0;
+
+	pck = fck / lck_div / pck_div / 1000;
+
+	if (pck != t->pixel_clock) {
+		DSSWARN("Could not find exact pixel clock. "
+				"Requested %d kHz, got %lu kHz\n",
+				t->pixel_clock, pck);
+
+		t->pixel_clock = pck;
+	}
+
+	dispc_set_lcd_timings(t);
+
+err0:
+	dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
+	return r;
+}
+
+static int dpi_basic_init(struct omap_dss_device *dssdev)
+{
+	bool is_tft;
+
+	is_tft = (dssdev->panel.config & OMAP_DSS_LCD_TFT) != 0;
+
+	dispc_set_parallel_interface_mode(OMAP_DSS_PARALLELMODE_BYPASS);
+	dispc_set_lcd_display_type(is_tft ? OMAP_DSS_LCD_DISPLAY_TFT :
+			OMAP_DSS_LCD_DISPLAY_STN);
+	dispc_set_tft_data_lines(dssdev->phy.dpi.data_lines);
+
+	return 0;
+}
+
+static int dpi_display_enable(struct omap_dss_device *dssdev)
+{
+	int r;
+
+	r = omap_dss_start_device(dssdev);
+	if (r) {
+		DSSERR("failed to start device\n");
+		goto err0;
+	}
+
+	if (dssdev->state != OMAP_DSS_DISPLAY_DISABLED) {
+		DSSERR("display already enabled\n");
+		r = -EINVAL;
+		goto err1;
+	}
+
+	dss_clk_enable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	r = dpi_basic_init(dssdev);
+	if (r)
+		goto err2;
+
+#ifdef CONFIG_OMAP2_DSS_USE_DSI_PLL
+	dss_clk_enable(DSS_CLK_FCK2);
+	r = dsi_pll_init(dssdev, 0, 1);
+	if (r)
+		goto err3;
+#endif
+	r = dpi_set_mode(dssdev);
+	if (r)
+		goto err4;
+
+	mdelay(2);
+
+	dispc_enable_lcd_out(1);
+
+	r = dssdev->driver->enable(dssdev);
+	if (r)
+		goto err5;
+
+	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
+
+	return 0;
+
+err5:
+	dispc_enable_lcd_out(0);
+err4:
+#ifdef CONFIG_OMAP2_DSS_USE_DSI_PLL
+	dsi_pll_uninit();
+err3:
+	dss_clk_disable(DSS_CLK_FCK2);
+#endif
+err2:
+	dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
+err1:
+	omap_dss_stop_device(dssdev);
+err0:
+	return r;
+}
+
+static int dpi_display_resume(struct omap_dss_device *dssdev);
+
+static void dpi_display_disable(struct omap_dss_device *dssdev)
+{
+	if (dssdev->state == OMAP_DSS_DISPLAY_DISABLED)
+		return;
+
+	if (dssdev->state == OMAP_DSS_DISPLAY_SUSPENDED)
+		dpi_display_resume(dssdev);
+
+	dssdev->driver->disable(dssdev);
+
+	dispc_enable_lcd_out(0);
+
+#ifdef CONFIG_OMAP2_DSS_USE_DSI_PLL
+	dss_select_clk_source(0, 0);
+	dsi_pll_uninit();
+	dss_clk_disable(DSS_CLK_FCK2);
+#endif
+
+	dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
+
+	omap_dss_stop_device(dssdev);
+}
+
+static int dpi_display_suspend(struct omap_dss_device *dssdev)
+{
+	if (dssdev->state != OMAP_DSS_DISPLAY_ACTIVE)
+		return -EINVAL;
+
+	DSSDBG("dpi_display_suspend\n");
+
+	if (dssdev->driver->suspend)
+		dssdev->driver->suspend(dssdev);
+
+	dispc_enable_lcd_out(0);
+
+	dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	dssdev->state = OMAP_DSS_DISPLAY_SUSPENDED;
+
+	return 0;
+}
+
+static int dpi_display_resume(struct omap_dss_device *dssdev)
+{
+	if (dssdev->state != OMAP_DSS_DISPLAY_SUSPENDED)
+		return -EINVAL;
+
+	DSSDBG("dpi_display_resume\n");
+
+	dss_clk_enable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	dispc_enable_lcd_out(1);
+
+	if (dssdev->driver->resume)
+		dssdev->driver->resume(dssdev);
+
+	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
+
+	return 0;
+}
+
+static void dpi_set_timings(struct omap_dss_device *dssdev,
+			struct omap_video_timings *timings)
+{
+	DSSDBG("dpi_set_timings\n");
+	dssdev->panel.timings = *timings;
+	if (dssdev->state == OMAP_DSS_DISPLAY_ACTIVE) {
+		dpi_set_mode(dssdev);
+		dispc_go(OMAP_DSS_CHANNEL_LCD);
+	}
+}
+
+static int dpi_check_timings(struct omap_dss_device *dssdev,
+			struct omap_video_timings *timings)
+{
+	bool is_tft;
+	int r;
+	int lck_div, pck_div;
+	unsigned long fck;
+	unsigned long pck;
+
+	if (!dispc_lcd_timings_ok(timings))
+		return -EINVAL;
+
+	if (timings->pixel_clock == 0)
+		return -EINVAL;
+
+	is_tft = (dssdev->panel.config & OMAP_DSS_LCD_TFT) != 0;
+
+#ifdef CONFIG_OMAP2_DSS_USE_DSI_PLL
+	{
+		struct dsi_clock_info dsi_cinfo;
+		struct dispc_clock_info dispc_cinfo;
+		r = dsi_pll_calc_clock_div_pck(is_tft,
+				timings->pixel_clock * 1000,
+				&dsi_cinfo, &dispc_cinfo);
+
+		if (r)
+			return r;
+
+		fck = dsi_cinfo.dsi1_pll_fclk;
+		lck_div = dispc_cinfo.lck_div;
+		pck_div = dispc_cinfo.pck_div;
+	}
+#else
+	{
+		struct dss_clock_info dss_cinfo;
+		struct dispc_clock_info dispc_cinfo;
+		r = dss_calc_clock_div(is_tft, timings->pixel_clock * 1000,
+				&dss_cinfo, &dispc_cinfo);
+
+		if (r)
+			return r;
+
+		fck = dss_cinfo.fck;
+		lck_div = dispc_cinfo.lck_div;
+		pck_div = dispc_cinfo.pck_div;
+	}
+#endif
+
+	pck = fck / lck_div / pck_div / 1000;
+
+	timings->pixel_clock = pck;
+
+	return 0;
+}
+
+static void dpi_get_timings(struct omap_dss_device *dssdev,
+			struct omap_video_timings *timings)
+{
+	*timings = dssdev->panel.timings;
+}
+
+static int dpi_display_set_update_mode(struct omap_dss_device *dssdev,
+		enum omap_dss_update_mode mode)
+{
+	if (mode == OMAP_DSS_UPDATE_MANUAL)
+		return -EINVAL;
+
+	if (mode == OMAP_DSS_UPDATE_DISABLED) {
+		dispc_enable_lcd_out(0);
+		dpi.update_enabled = 0;
+	} else {
+		dispc_enable_lcd_out(1);
+		dpi.update_enabled = 1;
+	}
+
+	return 0;
+}
+
+static enum omap_dss_update_mode dpi_display_get_update_mode(
+		struct omap_dss_device *dssdev)
+{
+	return dpi.update_enabled ? OMAP_DSS_UPDATE_AUTO :
+		OMAP_DSS_UPDATE_DISABLED;
+}
+
+int dpi_init_display(struct omap_dss_device *dssdev)
+{
+	DSSDBG("init_display\n");
+
+	dssdev->enable = dpi_display_enable;
+	dssdev->disable = dpi_display_disable;
+	dssdev->suspend = dpi_display_suspend;
+	dssdev->resume = dpi_display_resume;
+	dssdev->set_timings = dpi_set_timings;
+	dssdev->check_timings = dpi_check_timings;
+	dssdev->get_timings = dpi_get_timings;
+	dssdev->set_update_mode = dpi_display_set_update_mode;
+	dssdev->get_update_mode = dpi_display_get_update_mode;
+
+	return 0;
+}
+
+int dpi_init(void)
+{
+	return 0;
+}
+
+void dpi_exit(void)
+{
+}
+
-- 
1.6.5.1

