Return-Path: <linux-kernel-owner+w=401wt.eu-S1757526AbZFXLgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526AbZFXLgi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:36:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbZFXLgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:36:14 -0400
Received: from smtp.nokia.com ([192.100.122.233]:25429 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752209AbZFXLgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:36:12 -0400
From: Imre Deak <imre.deak@nokia.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Antonino Daplas <adaplas@gmail.com>, Tony Lindgren <tony@atomide.com>,
       Tomi Valkeinen <Tomi.Valkeinen@nokia.com>
Subject: [PATCH 03/20] omapfb: Add support for the Amstrad Delta LCD
Date: Wed, 24 Jun 2009 14:33:28 +0300
Message-Id: <f2b49525146391a3d01b944bf4ebce045cb503d4.1245842329.git.imre.deak@nokia.com>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
References: <1245843225-1036-1-git-send-email-imre.deak@nokia.com>
 <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
 <5cf7e298c3b70ad6e07d34034cc901689445e978.1245842329.git.imre.deak@nokia.com>
In-Reply-To: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
References: <34904fad6190ff9d35eb942460ece639f4b7d58f.1245842329.git.imre.deak@nokia.com>
X-OriginalArrivalTime: 24 Jun 2009 11:35:54.0404 (UTC) FILETIME=[EF182E40:01C9F4BF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jonathan McDowell <noodles@earth.li>

This is an updated version of the LCD driver for the Amstrad Delta to
take into account the recent changes to the omapfb infrastructure. The
Delta features a 480x320 12 bit DSTN panel.

Signed-off-by: Jonathan McDowell <noodles@earth.li>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Imre Deak <imre.deak@nokia.com>
Acked-by: Krzysztof Helt <krzysztof.h1@wp.pl>
---
 drivers/video/omap/Makefile        |    1 +
 drivers/video/omap/lcd_ams_delta.c |  137 ++++++++++++++++++++++++++++++++++++
 2 files changed, 138 insertions(+), 0 deletions(-)
 create mode 100644 drivers/video/omap/lcd_ams_delta.c

diff --git a/drivers/video/omap/Makefile b/drivers/video/omap/Makefile
index d86d54a..2bf94ad 100644
--- a/drivers/video/omap/Makefile
+++ b/drivers/video/omap/Makefile
@@ -15,6 +15,7 @@ objs-$(CONFIG_ARCH_OMAP2)$(CONFIG_FB_OMAP_LCDC_EXTERNAL) += rfbi.o
 objs-y$(CONFIG_FB_OMAP_LCDC_HWA742) += hwa742.o
 objs-y$(CONFIG_FB_OMAP_LCDC_BLIZZARD) += blizzard.o
 
+objs-y$(CONFIG_MACH_AMS_DELTA) += lcd_ams_delta.o
 objs-y$(CONFIG_MACH_OMAP_H4) += lcd_h4.o
 objs-y$(CONFIG_MACH_OMAP_H3) += lcd_h3.o
 objs-y$(CONFIG_MACH_OMAP_PALMTE) += lcd_palmte.o
diff --git a/drivers/video/omap/lcd_ams_delta.c b/drivers/video/omap/lcd_ams_delta.c
new file mode 100644
index 0000000..1f74399
--- /dev/null
+++ b/drivers/video/omap/lcd_ams_delta.c
@@ -0,0 +1,137 @@
+/*
+ * Based on drivers/video/omap/lcd_inn1510.c
+ *
+ * LCD panel support for the Amstrad E3 (Delta) videophone.
+ *
+ * Copyright (C) 2006 Jonathan McDowell <noodles@earth.li>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2 of the License, or (at your
+ * option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License along
+ * with this program; if not, write to the Free Software Foundation, Inc.,
+ * 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/delay.h>
+
+#include <mach/board-ams-delta.h>
+#include <mach/hardware.h>
+#include <mach/omapfb.h>
+
+#define AMS_DELTA_DEFAULT_CONTRAST	112
+
+static int ams_delta_panel_init(struct lcd_panel *panel,
+		struct omapfb_device *fbdev)
+{
+	return 0;
+}
+
+static void ams_delta_panel_cleanup(struct lcd_panel *panel)
+{
+}
+
+static int ams_delta_panel_enable(struct lcd_panel *panel)
+{
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_NDISP,
+			AMS_DELTA_LATCH2_LCD_NDISP);
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_VBLEN,
+			AMS_DELTA_LATCH2_LCD_VBLEN);
+
+	omap_writeb(1, OMAP_PWL_CLK_ENABLE);
+	omap_writeb(AMS_DELTA_DEFAULT_CONTRAST, OMAP_PWL_ENABLE);
+
+	return 0;
+}
+
+static void ams_delta_panel_disable(struct lcd_panel *panel)
+{
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_VBLEN, 0);
+	ams_delta_latch2_write(AMS_DELTA_LATCH2_LCD_NDISP, 0);
+}
+
+static unsigned long ams_delta_panel_get_caps(struct lcd_panel *panel)
+{
+	return 0;
+}
+
+static struct lcd_panel ams_delta_panel = {
+	.name		= "ams-delta",
+	.config		= 0,
+
+	.bpp		= 12,
+	.data_lines	= 16,
+	.x_res		= 480,
+	.y_res		= 320,
+	.pixel_clock	= 4687,
+	.hsw		= 3,
+	.hfp		= 1,
+	.hbp		= 1,
+	.vsw		= 1,
+	.vfp		= 0,
+	.vbp		= 0,
+	.pcd		= 0,
+	.acb		= 37,
+
+	.init		= ams_delta_panel_init,
+	.cleanup	= ams_delta_panel_cleanup,
+	.enable		= ams_delta_panel_enable,
+	.disable	= ams_delta_panel_disable,
+	.get_caps	= ams_delta_panel_get_caps,
+};
+
+static int ams_delta_panel_probe(struct platform_device *pdev)
+{
+	omapfb_register_panel(&ams_delta_panel);
+	return 0;
+}
+
+static int ams_delta_panel_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static int ams_delta_panel_suspend(struct platform_device *pdev,
+		pm_message_t mesg)
+{
+	return 0;
+}
+
+static int ams_delta_panel_resume(struct platform_device *pdev)
+{
+	return 0;
+}
+
+struct platform_driver ams_delta_panel_driver = {
+	.probe		= ams_delta_panel_probe,
+	.remove		= ams_delta_panel_remove,
+	.suspend	= ams_delta_panel_suspend,
+	.resume		= ams_delta_panel_resume,
+	.driver		= {
+		.name	= "lcd_ams_delta",
+		.owner	= THIS_MODULE,
+	},
+};
+
+static int ams_delta_panel_drv_init(void)
+{
+	return platform_driver_register(&ams_delta_panel_driver);
+}
+
+static void ams_delta_panel_drv_cleanup(void)
+{
+	platform_driver_unregister(&ams_delta_panel_driver);
+}
+
+module_init(ams_delta_panel_drv_init);
+module_exit(ams_delta_panel_drv_cleanup);
-- 
1.6.3.2

