Return-Path: <linux-kernel-owner+w=401wt.eu-S1755581AbZLTRL7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbZLTRL7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 12:11:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbZLTRLx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 12:11:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:40357 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755499AbZLTRLv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 12:11:51 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18dLVwRRzcdLWkN0RIb7Q4ZsNYoGHof6D4EoYd1wh
	dKKpU2tzi+hDR4
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 5/5] viafb: some dvi cleanup
Date: Sun, 20 Dec 2009 17:16:49 +0000
Message-Id: <1261329409-3518-5-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1261329409-3518-4-git-send-email-FlorianSchandinat@gmx.de>
References: <1261329409-3518-1-git-send-email-FlorianSchandinat@gmx.de>
 <1261329409-3518-2-git-send-email-FlorianSchandinat@gmx.de>
 <1261329409-3518-3-git-send-email-FlorianSchandinat@gmx.de>
 <1261329409-3518-4-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: some dvi cleanup

This patch removes some unused variables, moves some dvi code around
and stores the detected maximum resolution for later use. The
vertical resolution is handled as the old code did it but I hope it
can be read from the hardware some day.
No runtime change expected.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/chip.h |    9 +---
 drivers/video/via/dvi.c  |  107 +++++++++++++++++++++-------------------------
 drivers/video/via/dvi.h  |    3 +-
 drivers/video/via/hw.c   |   11 +----
 4 files changed, 55 insertions(+), 75 deletions(-)

diff --git a/drivers/video/via/chip.h b/drivers/video/via/chip.h
index 52253d0..8c06bd3 100644
--- a/drivers/video/via/chip.h
+++ b/drivers/video/via/chip.h
@@ -107,7 +107,6 @@
 struct tmds_chip_information {
 	int tmds_chip_name;
 	int tmds_chip_slave_addr;
-	int dvi_panel_id;
 	int data_mode;
 	int output_interface;
 	int i2c_port;
@@ -142,13 +141,9 @@ struct tmds_setting_information {
 	int iga_path;
 	int h_active;
 	int v_active;
-	int bpp;
-	int refresh_rate;
-	int get_dvi_size_method;
 	int max_pixel_clock;
-	int dvi_panel_hres;
-	int dvi_panel_vres;
-	int native_size;
+	int max_hres;
+	int max_vres;
 };
 
 struct lvds_setting_information {
diff --git a/drivers/video/via/dvi.c b/drivers/video/via/dvi.c
index 9cb261c..0e0852e 100644
--- a/drivers/video/via/dvi.c
+++ b/drivers/video/via/dvi.c
@@ -23,9 +23,10 @@
 static void tmds_register_write(int index, u8 data);
 static int tmds_register_read(int index);
 static int tmds_register_read_bytes(int index, u8 *buff, int buff_len);
-static void dvi_get_panel_size_from_DDCv1(void);
-static void dvi_get_panel_size_from_DDCv2(void);
-static void dvi_get_panel_info(void);
+static void dvi_get_panel_size_from_DDCv1(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting);
+static void dvi_get_panel_size_from_DDCv2(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting);
 static int viafb_dvi_query_EDID(void);
 
 static int check_tmds_chip(int device_id_subaddr, int device_id)
@@ -36,23 +37,24 @@ static int check_tmds_chip(int device_id_subaddr, int device_id)
 		return FAIL;
 }
 
-void viafb_init_dvi_size(void)
+void viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting)
 {
 	DEBUG_MSG(KERN_INFO "viafb_init_dvi_size()\n");
-	DEBUG_MSG(KERN_INFO
-		"viaparinfo->tmds_setting_info->get_dvi_size_method %d\n",
-		  viaparinfo->tmds_setting_info->get_dvi_size_method);
 
-	switch (viaparinfo->tmds_setting_info->get_dvi_size_method) {
-	case GET_DVI_SIZE_BY_SYSTEM_BIOS:
+	viafb_dvi_sense();
+	switch (viafb_dvi_query_EDID()) {
+	case 1:
+		dvi_get_panel_size_from_DDCv1(tmds_chip, tmds_setting);
 		break;
-	case GET_DVI_SZIE_BY_HW_STRAPPING:
+	case 2:
+		dvi_get_panel_size_from_DDCv2(tmds_chip, tmds_setting);
 		break;
-	case GET_DVI_SIZE_BY_VGA_BIOS:
 	default:
-		dvi_get_panel_info();
+		printk(KERN_WARNING "viafb_init_dvi_size: DVI panel size undetected!\n");
 		break;
 	}
+
 	return;
 }
 
@@ -314,11 +316,9 @@ static int viafb_dvi_query_EDID(void)
 		return false;
 }
 
-/* void dvi_get_panel_size_from_DDCv1(void)
- *
- *     - Get Panel Size Using EDID1 Table
- */
-static void dvi_get_panel_size_from_DDCv1(void)
+/* Get Panel Size Using EDID1 Table */
+static void dvi_get_panel_size_from_DDCv1(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting)
 {
 	int i, max_h = 0, tmp, restore;
 	unsigned char rData;
@@ -326,8 +326,8 @@ static void dvi_get_panel_size_from_DDCv1(void)
 
 	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv1 \n");
 
-	restore = viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr;
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = 0xA0;
+	restore = tmds_chip->tmds_chip_slave_addr;
+	tmds_chip->tmds_chip_slave_addr = 0xA0;
 
 	rData = tmds_register_read(0x23);
 	if (rData & 0x3C)
@@ -373,8 +373,8 @@ static void dvi_get_panel_size_from_DDCv1(void)
 				/* The first two byte must be zero. */
 				if (EDID_DATA[3] == 0xFD) {
 					/* To get max pixel clock. */
-					viaparinfo->tmds_setting_info->
-					max_pixel_clock = EDID_DATA[9] * 10;
+					tmds_setting->max_pixel_clock =
+						EDID_DATA[9] * 10;
 				}
 			}
 			break;
@@ -384,23 +384,31 @@ static void dvi_get_panel_size_from_DDCv1(void)
 		}
 	}
 
+	tmds_setting->max_hres = max_h;
 	switch (max_h) {
 	case 640:
+		tmds_setting->max_vres = 480;
 		break;
 	case 800:
+		tmds_setting->max_vres = 600;
 		break;
 	case 1024:
+		tmds_setting->max_vres = 768;
 		break;
 	case 1280:
+		tmds_setting->max_vres = 1024;
 		break;
 	case 1400:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1440:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1600:
+		tmds_setting->max_vres = 1200;
 		break;
 	case 1920:
-
+		tmds_setting->max_vres = 1080;
 		break;
 	default:
 		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d !\
@@ -409,72 +417,55 @@ static void dvi_get_panel_size_from_DDCv1(void)
 	}
 
 	DEBUG_MSG(KERN_INFO "DVI max pixelclock = %d\n",
-		  viaparinfo->tmds_setting_info->max_pixel_clock);
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = restore;
+		tmds_setting->max_pixel_clock);
+	tmds_chip->tmds_chip_slave_addr = restore;
 }
 
-/* void dvi_get_panel_size_from_DDCv2(void)
- *
- *     - Get Panel Size Using EDID2 Table
- */
-static void dvi_get_panel_size_from_DDCv2(void)
+/* Get Panel Size Using EDID2 Table */
+static void dvi_get_panel_size_from_DDCv2(struct tmds_chip_information
+	*tmds_chip, struct tmds_setting_information *tmds_setting)
 {
-	int HSize = 0, restore;
+	int restore;
 	unsigned char R_Buffer[2];
 
 	DEBUG_MSG(KERN_INFO "\n dvi_get_panel_size_from_DDCv2 \n");
 
-	restore = viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr;
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = 0xA2;
+	restore = tmds_chip->tmds_chip_slave_addr;
+	tmds_chip->tmds_chip_slave_addr = 0xA2;
 
 	/* Horizontal: 0x76, 0x77 */
 	tmds_register_read_bytes(0x76, R_Buffer, 2);
-	HSize = R_Buffer[0];
-	HSize += R_Buffer[1] << 8;
+	tmds_setting->max_hres = R_Buffer[0] + (R_Buffer[1] << 8);
 
-	switch (HSize) {
+	switch (tmds_setting->max_hres) {
 	case 640:
+		tmds_setting->max_vres = 480;
 		break;
 	case 800:
+		tmds_setting->max_vres = 600;
 		break;
 	case 1024:
+		tmds_setting->max_vres = 768;
 		break;
 	case 1280:
+		tmds_setting->max_vres = 1024;
 		break;
 	case 1400:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1440:
+		tmds_setting->max_vres = 1050;
 		break;
 	case 1600:
+		tmds_setting->max_vres = 1200;
 		break;
 	default:
 		DEBUG_MSG(KERN_INFO "Unknown panel size max resolution = %d!\
-					set default panel size.\n", HSize);
+			set default panel size.\n", tmds_setting->max_hres);
 		break;
 	}
 
-	viaparinfo->chip_info->tmds_chip_info.tmds_chip_slave_addr = restore;
-}
-
-/* unsigned char dvi_get_panel_info(void)
- *
- *     - Get Panel Size
- */
-static void dvi_get_panel_info(void)
-{
-	DEBUG_MSG(KERN_INFO "dvi_get_panel_info! \n");
-
-	viafb_dvi_sense();
-	switch (viafb_dvi_query_EDID()) {
-	case 1:
-		dvi_get_panel_size_from_DDCv1();
-		break;
-	case 2:
-		dvi_get_panel_size_from_DDCv2();
-		break;
-	default:
-		break;
-	}
+	tmds_chip->tmds_chip_slave_addr = restore;
 }
 
 /* If Disable DVI, turn off pad */
diff --git a/drivers/video/via/dvi.h b/drivers/video/via/dvi.h
index 5ca2ffc..0dffcfd 100644
--- a/drivers/video/via/dvi.h
+++ b/drivers/video/via/dvi.h
@@ -57,7 +57,8 @@ int viafb_dvi_sense(void);
 void viafb_dvi_disable(void);
 void viafb_dvi_enable(void);
 int viafb_tmds_trasmitter_identify(void);
-void viafb_init_dvi_size(void);
+void viafb_init_dvi_size(struct tmds_chip_information *tmds_chip,
+	struct tmds_setting_information *tmds_setting);
 void viafb_dvi_set_mode(struct VideoModeTable *videoMode, int mode_bpp,
 	int set_iga);
 
diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index 726fbd1..1aa3bb2 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -1911,9 +1911,6 @@ void viafb_update_device_setting(int hres, int vres,
 
 		viaparinfo->tmds_setting_info->h_active = hres;
 		viaparinfo->tmds_setting_info->v_active = vres;
-		viaparinfo->tmds_setting_info->bpp = bpp;
-		viaparinfo->tmds_setting_info->refresh_rate =
-			vmode_refresh;
 
 		viaparinfo->lvds_setting_info->h_active = hres;
 		viaparinfo->lvds_setting_info->v_active = vres;
@@ -1930,9 +1927,6 @@ void viafb_update_device_setting(int hres, int vres,
 		if (viaparinfo->tmds_setting_info->iga_path == IGA2) {
 			viaparinfo->tmds_setting_info->h_active = hres;
 			viaparinfo->tmds_setting_info->v_active = vres;
-			viaparinfo->tmds_setting_info->bpp = bpp;
-			viaparinfo->tmds_setting_info->refresh_rate =
-				vmode_refresh;
 		}
 
 		if (viaparinfo->lvds_setting_info->iga_path == IGA2) {
@@ -2031,9 +2025,8 @@ static void init_tmds_chip_info(void)
 
 	DEBUG_MSG(KERN_INFO "TMDS Chip = %d\n",
 		  viaparinfo->chip_info->tmds_chip_info.tmds_chip_name);
-	viaparinfo->tmds_setting_info->get_dvi_size_method =
-		GET_DVI_SIZE_BY_VGA_BIOS;
-	viafb_init_dvi_size();
+	viafb_init_dvi_size(&viaparinfo->shared->chip_info.tmds_chip_info,
+		&viaparinfo->shared->tmds_setting_info);
 }
 
 static void init_lvds_chip_info(void)
-- 
1.6.3.2

