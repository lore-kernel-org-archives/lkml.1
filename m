Return-Path: <linux-kernel-owner+w=401wt.eu-S932515AbZHQLz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515AbZHQLz5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 07:55:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932180AbZHQLz4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 07:55:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:42568 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757882AbZHQLzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 07:55:52 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX18bmeVTxwMb/QsO2/w7cvHowV63EtuWqPlkRaCI7f
	wKGlfAatfGlYQ7
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 2/4] viafb: remove duplicated mode information
Date: Mon, 17 Aug 2009 11:58:08 +0000
Message-Id: <1250510290-3327-2-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1250510290-3327-1-git-send-email-FlorianSchandinat@gmx.de>
References: <1250510290-3327-1-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: remove duplicated mode information

This patch removes the mode information from viafbdev.c and uses the one
of viamode.c instead. This is possible because horizontal and vertical
address are the same as horizontal and vertical resolution. The  reduced
blanking modes in the table are no problem because they have a higher
index than the normal modes and therefore always the normal modes are
selected just as the old behaviour.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 viafbdev.c |   54 +++++-------------------------------------------------
 viafbdev.h |    6 +-----
 2 files changed, 6 insertions(+), 54 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index 72759b6..7eff26e 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -53,51 +53,6 @@ static void retrieve_device_setting(struct viafb_ioctl_setting
 static void viafb_set_video_device(u32 video_dev_info);
 static void viafb_get_video_device(u32 *video_dev_info);
 
-/* Mode information */
-static const struct viafb_modeinfo viafb_modentry[] = {
-	{480, 640, VIA_RES_480X640},
-	{640, 480, VIA_RES_640X480},
-	{800, 480, VIA_RES_800X480},
-	{800, 600, VIA_RES_800X600},
-	{1024, 768, VIA_RES_1024X768},
-	{1152, 864, VIA_RES_1152X864},
-	{1280, 1024, VIA_RES_1280X1024},
-	{1600, 1200, VIA_RES_1600X1200},
-	{1440, 1050, VIA_RES_1440X1050},
-	{1280, 768, VIA_RES_1280X768,},
-	{1280, 800, VIA_RES_1280X800},
-	{1280, 960, VIA_RES_1280X960},
-	{1920, 1440, VIA_RES_1920X1440},
-	{848, 480, VIA_RES_848X480},
-	{1400, 1050, VIA_RES_1400X1050},
-	{720, 480, VIA_RES_720X480},
-	{720, 576, VIA_RES_720X576},
-	{1024, 512, VIA_RES_1024X512},
-	{1024, 576, VIA_RES_1024X576},
-	{1024, 600, VIA_RES_1024X600},
-	{1280, 720, VIA_RES_1280X720},
-	{1920, 1080, VIA_RES_1920X1080},
-	{1366, 768, VIA_RES_1368X768},
-	{1680, 1050, VIA_RES_1680X1050},
-	{960, 600, VIA_RES_960X600},
-	{1000, 600, VIA_RES_1000X600},
-	{1024, 576, VIA_RES_1024X576},
-	{1024, 600, VIA_RES_1024X600},
-	{1088, 612, VIA_RES_1088X612},
-	{1152, 720, VIA_RES_1152X720},
-	{1200, 720, VIA_RES_1200X720},
-	{1280, 600, VIA_RES_1280X600},
-	{1360, 768, VIA_RES_1360X768},
-	{1440, 900, VIA_RES_1440X900},
-	{1600, 900, VIA_RES_1600X900},
-	{1600, 1024, VIA_RES_1600X1024},
-	{1792, 1344, VIA_RES_1792X1344},
-	{1856, 1392, VIA_RES_1856X1392},
-	{1920, 1200, VIA_RES_1920X1200},
-	{2048, 1536, VIA_RES_2048X1536},
-	{0, 0, VIA_RES_INVALID}
-};
-
 static struct fb_ops viafb_ops;
 
 
@@ -1239,12 +1194,13 @@ int viafb_get_mode_index(int hres, int vres)
 	u32 i;
 	DEBUG_MSG(KERN_INFO "viafb_get_mode_index!\n");
 
-	for (i = 0; viafb_modentry[i].mode_index != VIA_RES_INVALID; i++)
-		if (viafb_modentry[i].xres == hres &&
-			viafb_modentry[i].yres == vres)
+	for (i = 0; i < NUM_TOTAL_MODETABLE; i++)
+		if (CLE266Modes[i].mode_array &&
+			CLE266Modes[i].crtc[0].crtc.hor_addr == hres &&
+			CLE266Modes[i].crtc[0].crtc.ver_addr == vres)
 			break;
 
-	return viafb_modentry[i].mode_index;
+	return CLE266Modes[i].ModeIndex;
 }
 
 static void check_available_device_to_enable(int device_id)
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index ea0df4f..cd3dff7 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -70,11 +70,7 @@ struct viafb_par {
 	int video_on_lcd;
 
 };
-struct viafb_modeinfo {
-	u32 xres;
-	u32 yres;
-	int mode_index;
-};
+
 extern unsigned int viafb_second_virtual_yres;
 extern unsigned int viafb_second_virtual_xres;
 extern unsigned int viafb_second_offset;
-- 
1.6.3.2

