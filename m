Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912Ab0BKTVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 14:21:38 -0500
Received: from mail.gmx.net ([213.165.64.20]:34000 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756901Ab0BKTVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 14:21:36 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19BoOZWYXtBxBz2tRfFRFMR+CffE3kTOGtnVaVW4K
	9tkQ5+rvG+zgYy
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 4/4] viafb: make some variables a bit less global
Date: Thu, 11 Feb 2010 19:28:00 +0000
Message-Id: <1265916480-6805-4-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1265916480-6805-3-git-send-email-FlorianSchandinat@gmx.de>
References: <1265916480-6805-1-git-send-email-FlorianSchandinat@gmx.de>
 <1265916480-6805-2-git-send-email-FlorianSchandinat@gmx.de>
 <1265916480-6805-3-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.47999999999999998
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: make some variables a bit less global

Move some variables closer to their usage.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/global.c   |    4 ----
 drivers/video/via/global.h   |    2 --
 drivers/video/via/hw.h       |    2 --
 drivers/video/via/viafbdev.c |    9 +++++++--
 drivers/video/via/viafbdev.h |    2 --
 5 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/drivers/video/via/global.c b/drivers/video/via/global.c
index 7fbc618..1ee511b 100644
--- a/drivers/video/via/global.c
+++ b/drivers/video/via/global.c
@@ -29,8 +29,6 @@ int viafb_refresh = 60;
 int viafb_refresh1 = 60;
 int viafb_lcd_dsp_method = LCD_EXPANDSION;
 int viafb_lcd_mode = LCD_OPENLDI;
-int viafb_bpp = 32;
-int viafb_bpp1 = 32;
 int viafb_CRT_ON = 1;
 int viafb_DVI_ON;
 int viafb_LCD_ON ;
@@ -41,8 +39,6 @@ int viafb_hotplug_Xres = 640;
 int viafb_hotplug_Yres = 480;
 int viafb_hotplug_bpp = 32;
 int viafb_hotplug_refresh = 60;
-unsigned int viafb_second_offset;
-int viafb_second_size;
 int viafb_primary_dev = None_Device;
 unsigned int viafb_second_xres = 640;
 unsigned int viafb_second_yres = 480;
diff --git a/drivers/video/via/global.h b/drivers/video/via/global.h
index 865b050..8d95d5f 100644
--- a/drivers/video/via/global.h
+++ b/drivers/video/via/global.h
@@ -67,8 +67,6 @@ extern int viafb_refresh;
 extern int viafb_refresh1;
 extern int viafb_lcd_dsp_method;
 extern int viafb_lcd_mode;
-extern int viafb_bpp;
-extern int viafb_bpp1;
 
 extern int viafb_CRT_ON;
 extern int viafb_hotplug_Xres;
diff --git a/drivers/video/via/hw.h b/drivers/video/via/hw.h
index dd54d3e..691fbd2 100644
--- a/drivers/video/via/hw.h
+++ b/drivers/video/via/hw.h
@@ -863,8 +863,6 @@ struct pci_device_id_info {
 };
 
 extern unsigned int viafb_second_virtual_xres;
-extern unsigned int viafb_second_offset;
-extern int viafb_second_size;
 extern int viafb_SAMM_ON;
 extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 902f8a1..bb0f616 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -26,13 +26,17 @@
 
 #include "global.h"
 
-static struct fb_var_screeninfo default_var;
 static char *viafb_name = "Via";
 static u32 pseudo_pal[17];
 
 /* video mode */
 static char *viafb_mode;
 static char *viafb_mode1;
+static int viafb_bpp = 32;
+static int viafb_bpp1 = 32;
+
+static unsigned int viafb_second_offset;
+static int viafb_second_size;
 
 static int viafb_accel = 1;
 
@@ -1849,10 +1853,11 @@ static int __devinit via_pci_probe(struct pci_dev *pdev,
 {
 	u32 default_xres, default_yres;
 	struct VideoModeTable *vmode_entry;
+	struct fb_var_screeninfo default_var;
 	u32 viafb_par_length;
 
 	DEBUG_MSG(KERN_INFO "VIAFB PCI Probe!!\n");
-
+	memset(&default_var, 0, sizeof(default_var));
 	viafb_par_length = ALIGN(sizeof(struct viafb_par), BITS_PER_LONG/8);
 
 	/* Allocate fb_info and ***_par here, also including some other needed
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index ecdaed8..61b5953 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -83,8 +83,6 @@ struct viafb_par {
 
 extern unsigned int viafb_second_virtual_yres;
 extern unsigned int viafb_second_virtual_xres;
-extern unsigned int viafb_second_offset;
-extern int viafb_second_size;
 extern int viafb_SAMM_ON;
 extern int viafb_dual_fb;
 extern int viafb_LCD2_ON;
-- 
1.6.3.2

