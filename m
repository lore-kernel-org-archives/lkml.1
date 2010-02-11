Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898Ab0BKTlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:41:06 -0500
Received: from mail.gmx.net ([213.165.64.20]:52657 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756405Ab0BKTlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:41:02 -0500
X-Authenticated: #5115406
X-Provags-ID: V01U2FsdGVkX1/3+7NxXYL3/zrmWfRLQtxzjolVXRiwmaegnkIMpz
	/G44nWud5c1OPp
From: Thomas Weber <swirl@gmx.li>
Cc: Thomas Weber <swirl@gmx.li>, Tomi Valkeinen <tomi.valkeinen@nokia.com>,
       Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
       linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND][PATCHv2 4/4] OMAP: DSS2: Add Innolux 7" display for DEVKIT8000
Date: Thu, 11 Feb 2010 20:41:18 +0100
Message-Id: <1265917278-22011-1-git-send-email-swirl@gmx.li>
X-Mailer: git-send-email 1.6.4.4
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the 7 inch display for the DEVKIT8000.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 drivers/video/omap2/displays/Kconfig               |    8 ++-
 drivers/video/omap2/displays/Makefile              |    1 +
 .../video/omap2/displays/panel-innolux-at070tn83.c |  107 ++++++++++++++++++++
 3 files changed, 115 insertions(+), 1 deletions(-)
 create mode 100644 drivers/video/omap2/displays/panel-innolux-at070tn83.c

diff --git a/drivers/video/omap2/displays/Kconfig b/drivers/video/omap2/displays/Kconfig
index b12a59c..ca6b372 100644
--- a/drivers/video/omap2/displays/Kconfig
+++ b/drivers/video/omap2/displays/Kconfig
@@ -5,7 +5,7 @@ config PANEL_GENERIC
         tristate "Generic Panel"
         help
 	  Generic panel driver.
-	  Used for DVI output for Beagle and OMAP3 SDP.
+	  Used for DVI output for Beagle, Devkit8000 and OMAP3 SDP.
 
 config PANEL_SHARP_LS037V7DW01
         tristate "Sharp LS037V7DW01 LCD Panel"
@@ -13,6 +13,12 @@ config PANEL_SHARP_LS037V7DW01
         help
           LCD Panel used in TI's SDP3430 and EVM boards
 
+config PANEL_INNOLUX_AT070TN83
+	tristate "Innolux AT070TN83 LCD Panel"
+	depends on OMAP2_DSS
+	help
+	 LCD Panel used in TimLL's Devkit8000
+
 config PANEL_TAAL
         tristate "Taal DSI Panel"
         depends on OMAP2_DSS_DSI
diff --git a/drivers/video/omap2/displays/Makefile b/drivers/video/omap2/displays/Makefile
index 9556464..087b192 100644
--- a/drivers/video/omap2/displays/Makefile
+++ b/drivers/video/omap2/displays/Makefile
@@ -2,3 +2,4 @@ obj-$(CONFIG_PANEL_GENERIC) += panel-generic.o
 obj-$(CONFIG_PANEL_SHARP_LS037V7DW01) += panel-sharp-ls037v7dw01.o
 
 obj-$(CONFIG_PANEL_TAAL) += panel-taal.o
+obj-$(CONFIG_PANEL_INNOLUX_AT070TN83) += panel-innolux-at070tn83.o
diff --git a/drivers/video/omap2/displays/panel-innolux-at070tn83.c b/drivers/video/omap2/displays/panel-innolux-at070tn83.c
new file mode 100644
index 0000000..f1d7f69
--- /dev/null
+++ b/drivers/video/omap2/displays/panel-innolux-at070tn83.c
@@ -0,0 +1,107 @@
+/*
+ * LCD panel driver for Innolux AT70TN83
+ *
+ * Copyright (C) 2010 Thomas Weber <weber@corscience.de>
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
+#include <linux/module.h>
+#include <linux/delay.h>
+#include <linux/device.h>
+#include <linux/regulator/consumer.h>
+#include <linux/err.h>
+
+#include <plat/display.h>
+
+static struct omap_video_timings innolux_at_timings = {
+	.x_res 		= 800,
+	.y_res 		= 480,
+
+	.pixel_clock	= 40000,
+
+	.hsw		= 48,
+	.hfp		= 1,
+	.hbp		= 1,
+
+	.vsw		= 3,
+	.vfp		= 12,
+	.vbp		= 25,
+};
+
+static int innolux_at_panel_probe(struct omap_dss_device *dssdev)
+{
+	dssdev->panel.config = OMAP_DSS_LCD_TFT | OMAP_DSS_LCD_IVS |
+		OMAP_DSS_LCD_IHS;
+	dssdev->panel.acb = 0x28;
+	dssdev->panel.timings = innolux_at_timings;
+
+	return 0;
+}
+
+static void innolux_at_panel_remove(struct omap_dss_device *dssdev)
+{
+}
+
+static int innolux_at_panel_enable(struct omap_dss_device *dssdev)
+{
+	return 0;
+}
+
+static void innolux_at_panel_disable(struct omap_dss_device *dssdev)
+{
+
+	if (dssdev->platform_disable)
+		dssdev->platform_disable(dssdev);
+
+}
+
+static int innolux_at_panel_suspend(struct omap_dss_device *dssdev)
+{
+	innolux_at_panel_disable(dssdev);
+	return 0;
+}
+
+static int innolux_at_panel_resume(struct omap_dss_device *dssdev)
+{
+	return innolux_at_panel_enable(dssdev);
+}
+
+static struct omap_dss_driver innolux_at_driver = {
+	.probe		= innolux_at_panel_probe,
+	.remove		= innolux_at_panel_remove,
+
+	.enable		= innolux_at_panel_enable,
+	.disable	= innolux_at_panel_disable,
+	.suspend	= innolux_at_panel_suspend,
+	.resume		= innolux_at_panel_resume,
+
+	.driver         = {
+		.name   = "innolux_at_panel",
+		.owner  = THIS_MODULE,
+	},
+};
+
+static int __init innolux_at_panel_drv_init(void)
+{
+	return omap_dss_register_driver(&innolux_at_driver);
+}
+
+static void __exit innolux_at_panel_drv_exit(void)
+{
+	omap_dss_unregister_driver(&innolux_at_driver);
+}
+
+module_init(innolux_at_panel_drv_init);
+module_exit(innolux_at_panel_drv_exit);
+MODULE_LICENSE("GPL");
-- 
1.6.4.4

