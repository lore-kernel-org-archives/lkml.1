Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZIXL5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZIXL5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 07:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbZIXL5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 07:57:37 -0400
Received: from smtp.nokia.com ([192.100.122.230]:17798 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZIXL4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 07:56:49 -0400
From: Tomi Valkeinen <tomi.valkeinen@nokia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-omap@vger.kernel.org, Tomi Valkeinen <tomi.valkeinen@nokia.com>
Subject: [PATCH 13/19] OMAP: DSS2: SDI driver
Date: Thu, 24 Sep 2009 14:56:18 +0300
Message-Id: <1253793384-31158-14-git-send-email-tomi.valkeinen@nokia.com>
X-Mailer: git-send-email 1.6.4
In-Reply-To: <1253793384-31158-13-git-send-email-tomi.valkeinen@nokia.com>
References: <1253793384-31158-1-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-2-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-3-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-4-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-5-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-6-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-7-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-8-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-9-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-10-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-11-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-12-git-send-email-tomi.valkeinen@nokia.com>
 <1253793384-31158-13-git-send-email-tomi.valkeinen@nokia.com>
X-OriginalArrivalTime: 24 Sep 2009 11:56:45.0873 (UTC) FILETIME=[17083210:01CA3D0E]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SDI (Serial Display Interface) implements TI Flatlink 3G display
interface.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@nokia.com>
---
 drivers/video/omap2/dss/sdi.c |  261 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 261 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/omap2/dss/sdi.c

diff --git a/drivers/video/omap2/dss/sdi.c b/drivers/video/omap2/dss/sdi.c
new file mode 100644
index 0000000..a9c727e
--- /dev/null
+++ b/drivers/video/omap2/dss/sdi.c
@@ -0,0 +1,261 @@
+/*
+ * linux/drivers/video/omap2/dss/sdi.c
+ *
+ * Copyright (C) 2009 Nokia Corporation
+ * Author: Tomi Valkeinen <tomi.valkeinen@nokia.com>
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
+#define DSS_SUBSYS_NAME "SDI"
+
+#include <linux/kernel.h>
+#include <linux/clk.h>
+#include <linux/delay.h>
+#include <linux/err.h>
+
+#include <mach/board.h>
+#include <mach/display.h>
+#include "dss.h"
+
+static struct {
+	bool skip_init;
+	bool update_enabled;
+} sdi;
+
+static void sdi_basic_init(void)
+{
+	dispc_set_parallel_interface_mode(OMAP_DSS_PARALLELMODE_BYPASS);
+
+	dispc_set_lcd_display_type(OMAP_DSS_LCD_DISPLAY_TFT);
+	dispc_set_tft_data_lines(24);
+	dispc_lcd_enable_signal_polarity(1);
+}
+
+static int sdi_display_enable(struct omap_dss_device *dssdev)
+{
+	struct omap_video_timings *t = &dssdev->panel.timings;
+	struct dispc_clock_info cinfo;
+	u16 lck_div, pck_div;
+	unsigned long fck;
+	unsigned long pck;
+	int r;
+
+	r = omap_dss_start_device(dssdev);
+	if (r) {
+		DSSERR("failed to start device\n");
+		goto err0;
+	}
+
+	if (dssdev->state != OMAP_DSS_DISPLAY_DISABLED) {
+		DSSERR("dssdev already enabled\n");
+		r = -EINVAL;
+		goto err1;
+	}
+
+	/* In case of skip_init sdi_init has already enabled the clocks */
+	if (!sdi.skip_init)
+		dss_clk_enable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	sdi_basic_init();
+
+	/* 15.5.9.1.2 */
+	dssdev->panel.config |= OMAP_DSS_LCD_RF | OMAP_DSS_LCD_ONOFF;
+
+	dispc_set_pol_freq(dssdev->panel.config, dssdev->panel.acbi,
+			dssdev->panel.acb);
+
+	if (!sdi.skip_init)
+		r = dispc_calc_clock_div(1, t->pixel_clock * 1000,
+				&cinfo);
+	else
+		r = dispc_get_clock_div(&cinfo);
+
+	if (r)
+		goto err2;
+
+	fck = cinfo.fck;
+	lck_div = cinfo.lck_div;
+	pck_div = cinfo.pck_div;
+
+	pck = fck / lck_div / pck_div / 1000;
+
+	if (pck != t->pixel_clock) {
+		DSSWARN("Could not find exact pixel clock. Requested %d kHz, "
+				"got %lu kHz\n",
+				t->pixel_clock, pck);
+
+		t->pixel_clock = pck;
+	}
+
+
+	dispc_set_lcd_timings(t);
+
+	r = dispc_set_clock_div(&cinfo);
+	if (r)
+		goto err2;
+
+	if (!sdi.skip_init) {
+		dss_sdi_init(dssdev->phy.sdi.datapairs);
+		dss_sdi_enable();
+		mdelay(2);
+	}
+
+	dispc_enable_lcd_out(1);
+
+	if (dssdev->driver->enable) {
+		r = dssdev->driver->enable(dssdev);
+		if (r)
+			goto err3;
+	}
+
+	dssdev->state = OMAP_DSS_DISPLAY_ACTIVE;
+
+	sdi.skip_init = 0;
+
+	return 0;
+err3:
+	dispc_enable_lcd_out(0);
+err2:
+	dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
+err1:
+	omap_dss_stop_device(dssdev);
+err0:
+	return r;
+}
+
+static int sdi_display_resume(struct omap_dss_device *dssdev);
+
+static void sdi_display_disable(struct omap_dss_device *dssdev)
+{
+	if (dssdev->state == OMAP_DSS_DISPLAY_DISABLED)
+		return;
+
+	if (dssdev->state == OMAP_DSS_DISPLAY_SUSPENDED)
+		sdi_display_resume(dssdev);
+
+	if (dssdev->driver->disable)
+		dssdev->driver->disable(dssdev);
+
+	dispc_enable_lcd_out(0);
+
+	dss_sdi_disable();
+
+	dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	dssdev->state = OMAP_DSS_DISPLAY_DISABLED;
+
+	omap_dss_stop_device(dssdev);
+}
+
+static int sdi_display_suspend(struct omap_dss_device *dssdev)
+{
+	if (dssdev->state != OMAP_DSS_DISPLAY_ACTIVE)
+		return -EINVAL;
+
+	if (dssdev->driver->suspend)
+		dssdev->driver->suspend(dssdev);
+
+	dispc_enable_lcd_out(0);
+
+	dss_sdi_disable();
+
+	dss_clk_disable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	dssdev->state = OMAP_DSS_DISPLAY_SUSPENDED;
+
+	return 0;
+}
+
+static int sdi_display_resume(struct omap_dss_device *dssdev)
+{
+	if (dssdev->state != OMAP_DSS_DISPLAY_SUSPENDED)
+		return -EINVAL;
+
+	dss_clk_enable(DSS_CLK_ICK | DSS_CLK_FCK1);
+
+	dss_sdi_enable();
+	mdelay(2);
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
+static int sdi_display_set_update_mode(struct omap_dss_device *dssdev,
+		enum omap_dss_update_mode mode)
+{
+	if (mode == OMAP_DSS_UPDATE_MANUAL)
+		return -EINVAL;
+
+	if (mode == OMAP_DSS_UPDATE_DISABLED) {
+		dispc_enable_lcd_out(0);
+		sdi.update_enabled = 0;
+	} else {
+		dispc_enable_lcd_out(1);
+		sdi.update_enabled = 1;
+	}
+
+	return 0;
+}
+
+static enum omap_dss_update_mode sdi_display_get_update_mode(
+		struct omap_dss_device *dssdev)
+{
+	return sdi.update_enabled ? OMAP_DSS_UPDATE_AUTO :
+		OMAP_DSS_UPDATE_DISABLED;
+}
+
+static void sdi_get_timings(struct omap_dss_device *dssdev,
+			struct omap_video_timings *timings)
+{
+	*timings = dssdev->panel.timings;
+}
+
+int sdi_init_display(struct omap_dss_device *dssdev)
+{
+	DSSDBG("SDI init\n");
+
+	dssdev->enable = sdi_display_enable;
+	dssdev->disable = sdi_display_disable;
+	dssdev->suspend = sdi_display_suspend;
+	dssdev->resume = sdi_display_resume;
+	dssdev->set_update_mode = sdi_display_set_update_mode;
+	dssdev->get_update_mode = sdi_display_get_update_mode;
+	dssdev->get_timings = sdi_get_timings;
+
+	return 0;
+}
+
+int sdi_init(bool skip_init)
+{
+	/* we store this for first display enable, then clear it */
+	sdi.skip_init = skip_init;
+
+	/*
+	 * Enable clocks already here, otherwise there would be a toggle
+	 * of them until sdi_display_enable is called.
+	 */
+	if (skip_init)
+		dss_clk_enable(DSS_CLK_ICK | DSS_CLK_FCK1);
+	return 0;
+}
+
+void sdi_exit(void)
+{
+}
-- 
1.6.4

