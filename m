Return-Path: <linux-kernel-owner+w=401wt.eu-S1755152AbYJFQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755152AbYJFQ7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 12:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbYJFQ7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 12:59:09 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34032 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802AbYJFQ7I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 12:59:08 -0400
From: "Castaneda Gonzalez, Axel" <x0055901@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 6 Oct 2008 11:58:58 -0500
Subject: [PATCH 01/02] [omapzoom]ARM-OMAP3-TV_detection_support
Thread-Topic: [PATCH 01/02] [omapzoom]ARM-OMAP3-TV_detection_support
Thread-Index: AcklwWqbeEiJi8/4SMSPYvsd10n4KQAAQsPwAAAvWTAAhEAssA==
Message-ID: <70ABD7B1D427A94DA659B4C84B0F5D4A50B6D411@dlee06.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Castaneda Gonzalez<x0055901@ti.com>

ARM: OMAP3: TV detection support

This patch provides TV detection support on omapzoom 
display driver.

User will be able to check if TV is connected to
SDP34030 or LDP S-Video port through the use of /sys/class/display_control/omap_disp_control/tv_state
sysfs entry.

Signed-off-by: Axel Castaneda Gonzalez<x0055901@ti.com>
---
 arch/arm/plat-omap/display.c              |   22 +++++++++++
 arch/arm/plat-omap/include/mach/display.h |    3 +
 drivers/video/omap/omap_disp_out.c        |   56 ++++++++++++++++++++++++++++++
 3 files changed, 80 insertions(+), 1 deletion(-)

Index: git-ti-omap34tree/arch/arm/plat-omap/display.c
===================================================================
--- git-ti-omap34tree.orig/arch/arm/plat-omap/display.c
+++ git-ti-omap34tree/arch/arm/plat-omap/display.c
@@ -3847,6 +3847,26 @@ int omap2_disp_lpr_disable(void)
 }
 #endif /* CONFIG_ARCH_OMAP34XX */
 
+/**
+ * omap2_enable_tv_detect - Enables TVDET pulse generation
+ */
+void omap2_enable_tv_detect(void){
+	/* TVDET Active High Setting */
+	venc_reg_merge(VENC_GEN_CTRL, 0x1 << 16, 0x1 << 16);
+	/* Enable TVDET pulse generation */
+	venc_reg_merge(VENC_GEN_CTRL, 0x1, 0x1);
+}
+EXPORT_SYMBOL(omap2_enable_tv_detect);
+
+/**
+ * omap2_disable_tv_detect - Disables TVDET pulse generation
+ */
+void omap2_disable_tv_detect(void){
+	/* Disable TVDET pulse generation */
+	venc_reg_merge(VENC_GEN_CTRL, 0x0, 0x1);
+}
+EXPORT_SYMBOL(omap2_disable_tv_detect);
+
 /* Start before devices */
 subsys_initcall(omap2_disp_init);      
 
Index: git-ti-omap34tree/arch/arm/plat-omap/include/mach/display.h
===================================================================
--- git-ti-omap34tree.orig/arch/arm/plat-omap/include/mach/display.h
+++ git-ti-omap34tree/arch/arm/plat-omap/include/mach/display.h
@@ -849,6 +849,9 @@ void omap2_disp_set_gfx_fifo_high_thresh
 extern void omap2_disp_put_all_clks(void);
 extern void omap2_disp_get_all_clks(void);
 
+/* TV detection*/
+void omap2_enable_tv_detect(void);
+void omap2_disable_tv_detect(void);
 /*------------------ end of exposed values and APIs -------------------------*/
 
 #endif /* __ASM_ARCH_OMAP2_DISP_H */
Index: git-ti-omap34tree/drivers/video/omap/omap_disp_out.c
===================================================================
--- git-ti-omap34tree.orig/drivers/video/omap/omap_disp_out.c
+++ git-ti-omap34tree/drivers/video/omap/omap_disp_out.c
@@ -139,6 +139,9 @@
 #endif
 #endif
 
+#define TV_INT_GPIO			33
+#define TV_DETECT_DELAY			40 /*Delay for TV detection logic*/
+
 #define CONFIG_OMAP2_LCD
 #define ENABLE_VDAC_DEDICATED		0x03
 #define ENABLE_VDAC_DEV_GRP             0x20	     
@@ -1147,6 +1150,9 @@ tv_init(void)
 	printk(KERN_DEBUG DRIVER
 	       "TV %dx%d interlaced\n", H4_TV_XRES, H4_TV_YRES);
 
+	omap_request_gpio(TV_INT_GPIO);
+	omap_set_gpio_direction(TV_INT_GPIO, 1);
+
 #if 0 /* To be added back once SRF is in place */
 	resource_request(tv_rhandle,T2_VDAC_1V80);
 	resource_release(tv_rhandle);
@@ -1164,6 +1170,7 @@ tv_exit(void)
 	omap2_disp_disable_output_dev(OMAP2_OUTPUT_TV);
 	power_tv(TV_OFF);
 	omap2_disp_put_all_clks();
+	omap_free_gpio(TV_INT_GPIO);
 	tv_in_use = 0;
 	return 0;
 }
@@ -1822,6 +1829,54 @@ tv_standard_store(struct device *dev, st
 	return count;
 	
 }
+
+static void enable_tv_detect(void){
+	omap2_disp_get_all_clks();
+	if (!tv_in_use) {
+		omap2_disp_set_tvref(TVREF_ON);
+#ifdef CONFIG_OMAP3_PM
+		resource_request(tv_rhandle, T2_VDAC_1V80);
+#else
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+			ENABLE_VDAC_DEDICATED, TWL4030_VDAC_DEDICATED);
+		twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER,
+			ENABLE_VDAC_DEV_GRP, TWL4030_VDAC_DEV_GRP);
+#endif
+	}
+	omap2_enable_tv_detect();
+}
+
+static void disable_tv_detect(void){
+	omap2_disable_tv_detect();
+	if (!tv_in_use) {
+		omap2_disp_set_tvref(TVREF_OFF);
+#ifdef CONFIG_OMAP3_PM
+	resource_release(tv_rhandle);
+#else
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x00,
+		TWL4030_VDAC_DEDICATED);
+	twl4030_i2c_write_u8(TWL4030_MODULE_PM_RECEIVER, 0x00,
+		TWL4030_VDAC_DEV_GRP);
+#endif
+       }
+	omap2_disp_put_all_clks();
+}
+
+static ssize_t
+tv_state_show(struct device *dev, struct device_attribute *attr, char *buf) {
+	int tv_state;
+	enable_tv_detect();
+	msleep(TV_DETECT_DELAY);
+	tv_state = omap_get_gpio_datain(TV_INT_GPIO);
+	disable_tv_detect();
+	return  sprintf(buf, "%d\n", tv_state);
+}
+
+static ssize_t
+tv_state_store(struct device *dev, struct device_attribute *attr,
+		const char *buffer, size_t count) {
+	return 0;
+}
 #endif
 
 #define DECLARE_ATTR(_name,_mode,_show,_store)                  \
@@ -1855,6 +1910,7 @@ static struct device_attribute bl_device
 #endif
 	#ifdef CONFIG_OMAP2_TV
 	DECLARE_ATTR(tv_standard,    0644, tv_standard_show, tv_standard_store),
+	DECLARE_ATTR(tv_state,   S_IRWXUGO, tv_state_show, tv_state_store),
 	#endif
 };

