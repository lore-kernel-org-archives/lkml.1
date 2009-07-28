Return-Path: <linux-kernel-owner+w=401wt.eu-S1753026AbZG1Xkj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026AbZG1Xkj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:40:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZG1Xki
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:40:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:39672 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752930AbZG1Xkh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:40:37 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX1+rCy5A46Wrx/4s8HeKS8W+qshb1P2M+Vul3Ei+JF
	5jPS3RCXKMmScR
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev-devel@lists.sourceforge.net, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH v2] viafb: fix rmmod bug
Date: Tue, 28 Jul 2009 23:42:24 +0000
Message-Id: <1248824544-3218-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <20090728143408.b1b6dba0.akpm@linux-foundation.org>
References: <20090728143408.b1b6dba0.akpm@linux-foundation.org>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: fix rmmod bug

This fixes a bug caused by changing pointers (viafb_mode, viafb_mode1)
assigned by module_param. It reduces driver complexity by not needlessly
changing these vars as they are only read once and removing now
superfluous code.

On unpatched kernels loading viafb with viafb_mode or viafb_mode1 option
used and afterwards unloading it results in:

kernel BUG at mm/slub.c:2926!
invalid opcode: 0000 [#1] PREEMPT
last sysfs file: /sys/devices/virtual/block/loop0/removable
Modules linked in: snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_pcm rtl8187 snd_timer eeprom_93cx6 mmc_block snd soundcore
via_sdmmc fb snd_page_alloc i2c_algo_bit i2c_viapro ehci_hcd uhci_hcd
cfbcopyarea mmc_core cfbimgblt cfbfillrect video output [last unloaded:
viafb]

Pid: 3355, comm: rmmod Not tainted (2.6.31-rc1 #0)
EIP: 0060:[<c106a759>] EFLAGS: 00010246 CPU: 0
EIP is at kfree+0x80/0xda
EAX: c17c2da0 EBX: dc7edbdc ECX: 0000010f EDX: 00000000
ESI: c102c700 EDI: dc7ed8fa EBP: d703ff2c ESP: d703ff20
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process rmmod (pid: 3355, ti=d703e000 task=db1412c0 task.ti=d703e000)
Stack:
 dc7edbdc 00000014 00000016 d703ff40 c102c700 dc7f45d4 dc7f45d4 00000880
<0> d703ff4c c103e571 00000000 d703ffac c103e751 66616976 da140062
db89ba80
<0> 00000328 d702edf8 db89ba80 d703ff9c c105d0f0 00000200 da14f898
00000014
Call Trace:
 [<c102c700>] ? destroy_params+0x1e/0x2b
 [<c103e571>] ? free_module+0xa2/0xd7
 [<c103e751>] ? sys_delete_module+0x1ab/0x1da
 [<c105d0f0>] ? do_munmap+0x20a/0x225
 [<c10029b4>] ? sysenter_do_call+0x12/0x26
Code: 10 76 7a 8d 87 00 00 00 40 c1 e8 0c c1 e0 05 03 05 1c 87 41 c1 66
83 38 00 79 03 8b 40 0c 8b 10 84 d2 78 12 66 f7 c2 00 c0 75 04 <0f> 0b
eb fe e8 6f 5a fe ff eb 47 8b 55 04 8b 58 0c 9c 5e fa 3b
EIP: [<c106a759>] kfree+0x80/0xda SS:ESP 0068:d703ff20

This is caused by the current code changing the pointers assigned by
module_param. During unload it tries to free the memory the pointers
point at which is now part of an internal structure.

The patch simply avoids changing the pointers. This is okay as they are
read only once during the initialization process.

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
v2: improved commit message
---
 hw.c       |    4 +-
 lcd.c      |   15 ++-------
 viafbdev.c |  101 ++++++++++++++++++++++++++++--------------------------------
 viafbdev.h |    3 +-
 4 files changed, 53 insertions(+), 70 deletions(-)

diff --git a/drivers/video/via/hw.c b/drivers/video/via/hw.c
index fcd53ce..c896000 100644
--- a/drivers/video/via/hw.c
+++ b/drivers/video/via/hw.c
@@ -2407,14 +2407,14 @@ int viafb_setmode(int vmode_index, int hor_res, int ver_res, int video_bpp,
 			viafb_dvi_set_mode(viafb_get_mode_index
 				     (viaparinfo->tmds_setting_info->h_active,
 				      viaparinfo->tmds_setting_info->
-				      v_active, 1),
+				      v_active),
 				     video_bpp1, viaparinfo->
 				     tmds_setting_info->iga_path);
 		} else {
 			viafb_dvi_set_mode(viafb_get_mode_index
 				     (viaparinfo->tmds_setting_info->h_active,
 				      viaparinfo->
-				      tmds_setting_info->v_active, 0),
+				      tmds_setting_info->v_active),
 				     video_bpp, viaparinfo->
 				     tmds_setting_info->iga_path);
 		}
diff --git a/drivers/video/via/lcd.c b/drivers/video/via/lcd.c
index 6c7290a..78c6b33 100644
--- a/drivers/video/via/lcd.c
+++ b/drivers/video/via/lcd.c
@@ -580,10 +580,7 @@ static void load_lcd_k400_patch_tbl(int set_hres, int set_vres,
 	int reg_num = 0;
 	struct io_reg *lcd_patch_reg = NULL;
 
-	if (viaparinfo->lvds_setting_info->iga_path == IGA2)
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 1);
-	else
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 0);
+	vmode_index = viafb_get_mode_index(set_hres, set_vres);
 	switch (panel_id) {
 		/* LCD 800x600 */
 	case LCD_PANEL_ID1_800X600:
@@ -761,10 +758,7 @@ static void load_lcd_p880_patch_tbl(int set_hres, int set_vres,
 	int reg_num = 0;
 	struct io_reg *lcd_patch_reg = NULL;
 
-	if (viaparinfo->lvds_setting_info->iga_path == IGA2)
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 1);
-	else
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 0);
+	vmode_index = viafb_get_mode_index(set_hres, set_vres);
 
 	switch (panel_id) {
 	case LCD_PANEL_ID5_1400X1050:
@@ -832,10 +826,7 @@ static void load_lcd_patch_regs(int set_hres, int set_vres,
 {
 	int vmode_index;
 
-	if (viaparinfo->lvds_setting_info->iga_path == IGA2)
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 1);
-	else
-		vmode_index = viafb_get_mode_index(set_hres, set_vres, 0);
+	vmode_index = viafb_get_mode_index(set_hres, set_vres);
 
 	viafb_unlock_crt();
 
diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index a0fec29..72833f3 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -32,7 +32,6 @@ static u32 pseudo_pal[17];
 /* video mode */
 static char *viafb_mode = "640x480";
 static char *viafb_mode1 = "640x480";
-static int viafb_resMode = VIA_RES_640X480;
 
 /* Added for specifying active devices.*/
 char *viafb_active_dev = "";
@@ -56,47 +55,47 @@ static void viafb_get_video_device(u32 *video_dev_info);
 
 /* Mode information */
 static const struct viafb_modeinfo viafb_modentry[] = {
-	{480, 640, VIA_RES_480X640, "480x640"},
-	{640, 480, VIA_RES_640X480, "640x480"},
-	{800, 480, VIA_RES_800X480, "800x480"},
-	{800, 600, VIA_RES_800X600, "800x600"},
-	{1024, 768, VIA_RES_1024X768, "1024x768"},
-	{1152, 864, VIA_RES_1152X864, "1152x864"},
-	{1280, 1024, VIA_RES_1280X1024, "1280x1024"},
-	{1600, 1200, VIA_RES_1600X1200, "1600x1200"},
-	{1440, 1050, VIA_RES_1440X1050, "1440x1050"},
-	{1280, 768, VIA_RES_1280X768, "1280x768"},
-	{1280, 800, VIA_RES_1280X800, "1280x800"},
-	{1280, 960, VIA_RES_1280X960, "1280x960"},
-	{1920, 1440, VIA_RES_1920X1440, "1920x1440"},
-	{848, 480, VIA_RES_848X480, "848x480"},
-	{1400, 1050, VIA_RES_1400X1050, "1400x1050"},
-	{720, 480, VIA_RES_720X480, "720x480"},
-	{720, 576, VIA_RES_720X576, "720x576"},
-	{1024, 512, VIA_RES_1024X512, "1024x512"},
-	{1024, 576, VIA_RES_1024X576, "1024x576"},
-	{1024, 600, VIA_RES_1024X600, "1024x600"},
-	{1280, 720, VIA_RES_1280X720, "1280x720"},
-	{1920, 1080, VIA_RES_1920X1080, "1920x1080"},
-	{1366, 768, VIA_RES_1368X768, "1368x768"},
-	{1680, 1050, VIA_RES_1680X1050, "1680x1050"},
-	{960, 600, VIA_RES_960X600, "960x600"},
-	{1000, 600, VIA_RES_1000X600, "1000x600"},
-	{1024, 576, VIA_RES_1024X576, "1024x576"},
-	{1024, 600, VIA_RES_1024X600, "1024x600"},
-	{1088, 612, VIA_RES_1088X612, "1088x612"},
-	{1152, 720, VIA_RES_1152X720, "1152x720"},
-	{1200, 720, VIA_RES_1200X720, "1200x720"},
-	{1280, 600, VIA_RES_1280X600, "1280x600"},
-	{1360, 768, VIA_RES_1360X768, "1360x768"},
-	{1440, 900, VIA_RES_1440X900, "1440x900"},
-	{1600, 900, VIA_RES_1600X900, "1600x900"},
-	{1600, 1024, VIA_RES_1600X1024, "1600x1024"},
-	{1792, 1344, VIA_RES_1792X1344, "1792x1344"},
-	{1856, 1392, VIA_RES_1856X1392, "1856x1392"},
-	{1920, 1200, VIA_RES_1920X1200, "1920x1200"},
-	{2048, 1536, VIA_RES_2048X1536, "2048x1536"},
-	{0, 0, VIA_RES_INVALID, "640x480"}
+	{480, 640, VIA_RES_480X640},
+	{640, 480, VIA_RES_640X480},
+	{800, 480, VIA_RES_800X480},
+	{800, 600, VIA_RES_800X600},
+	{1024, 768, VIA_RES_1024X768},
+	{1152, 864, VIA_RES_1152X864},
+	{1280, 1024, VIA_RES_1280X1024},
+	{1600, 1200, VIA_RES_1600X1200},
+	{1440, 1050, VIA_RES_1440X1050},
+	{1280, 768, VIA_RES_1280X768,},
+	{1280, 800, VIA_RES_1280X800},
+	{1280, 960, VIA_RES_1280X960},
+	{1920, 1440, VIA_RES_1920X1440},
+	{848, 480, VIA_RES_848X480},
+	{1400, 1050, VIA_RES_1400X1050},
+	{720, 480, VIA_RES_720X480},
+	{720, 576, VIA_RES_720X576},
+	{1024, 512, VIA_RES_1024X512},
+	{1024, 576, VIA_RES_1024X576},
+	{1024, 600, VIA_RES_1024X600},
+	{1280, 720, VIA_RES_1280X720},
+	{1920, 1080, VIA_RES_1920X1080},
+	{1366, 768, VIA_RES_1368X768},
+	{1680, 1050, VIA_RES_1680X1050},
+	{960, 600, VIA_RES_960X600},
+	{1000, 600, VIA_RES_1000X600},
+	{1024, 576, VIA_RES_1024X576},
+	{1024, 600, VIA_RES_1024X600},
+	{1088, 612, VIA_RES_1088X612},
+	{1152, 720, VIA_RES_1152X720},
+	{1200, 720, VIA_RES_1200X720},
+	{1280, 600, VIA_RES_1280X600},
+	{1360, 768, VIA_RES_1360X768},
+	{1440, 900, VIA_RES_1440X900},
+	{1600, 900, VIA_RES_1600X900},
+	{1600, 1024, VIA_RES_1600X1024},
+	{1792, 1344, VIA_RES_1792X1344},
+	{1856, 1392, VIA_RES_1856X1392},
+	{1920, 1200, VIA_RES_1920X1200},
+	{2048, 1536, VIA_RES_2048X1536},
+	{0, 0, VIA_RES_INVALID}
 };
 
 static struct fb_ops viafb_ops;
@@ -177,7 +176,7 @@ static int viafb_check_var(struct fb_var_screeninfo *var,
 	if (var->vmode & FB_VMODE_INTERLACED || var->vmode & FB_VMODE_DOUBLE)
 		return -EINVAL;
 
-	vmode_index = viafb_get_mode_index(var->xres, var->yres, 0);
+	vmode_index = viafb_get_mode_index(var->xres, var->yres);
 	if (vmode_index == VIA_RES_INVALID) {
 		DEBUG_MSG(KERN_INFO
 			  "viafb: Mode %dx%dx%d not supported!!\n",
@@ -233,14 +232,14 @@ static int viafb_set_par(struct fb_info *info)
 	viafb_update_device_setting(info->var.xres, info->var.yres,
 			      info->var.bits_per_pixel, viafb_refresh, 0);
 
-	vmode_index = viafb_get_mode_index(info->var.xres, info->var.yres, 0);
+	vmode_index = viafb_get_mode_index(info->var.xres, info->var.yres);
 
 	if (viafb_SAMM_ON == 1) {
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
 			  viafb_second_xres, viafb_second_yres, viafb_bpp1);
 		vmode_index1 = viafb_get_mode_index(viafb_second_xres,
-			viafb_second_yres, 1);
+			viafb_second_yres);
 		DEBUG_MSG(KERN_INFO "->viafb_SAMM_ON: index=%d\n",
 			vmode_index1);
 
@@ -1262,7 +1261,7 @@ static int viafb_sync(struct fb_info *info)
 	return 0;
 }
 
-int viafb_get_mode_index(int hres, int vres, int flag)
+int viafb_get_mode_index(int hres, int vres)
 {
 	u32 i;
 	DEBUG_MSG(KERN_INFO "viafb_get_mode_index!\n");
@@ -1272,13 +1271,7 @@ int viafb_get_mode_index(int hres, int vres, int flag)
 			viafb_modentry[i].yres == vres)
 			break;
 
-	viafb_resMode = viafb_modentry[i].mode_index;
-	if (flag)
-		viafb_mode1 = viafb_modentry[i].mode_res;
-	else
-		viafb_mode = viafb_modentry[i].mode_res;
-
-	return viafb_resMode;
+	return viafb_modentry[i].mode_index;
 }
 
 static void check_available_device_to_enable(int device_id)
@@ -2199,7 +2192,7 @@ static int __devinit via_pci_probe(void)
 	strict_strtoul(tmpc, 0, &default_xres);
 	strict_strtoul(tmpm, 0, &default_yres);
 
-	vmode_index = viafb_get_mode_index(default_xres, default_yres, 0);
+	vmode_index = viafb_get_mode_index(default_xres, default_yres);
 	DEBUG_MSG(KERN_INFO "0->index=%d\n", vmode_index);
 
 	if (viafb_SAMM_ON == 1) {
diff --git a/drivers/video/via/viafbdev.h b/drivers/video/via/viafbdev.h
index a4158e8..227b000 100644
--- a/drivers/video/via/viafbdev.h
+++ b/drivers/video/via/viafbdev.h
@@ -81,7 +81,6 @@ struct viafb_modeinfo {
 	u32 xres;
 	u32 yres;
 	int mode_index;
-	char *mode_res;
 };
 extern unsigned int viafb_second_virtual_yres;
 extern unsigned int viafb_second_virtual_xres;
@@ -102,7 +101,7 @@ extern int strict_strtoul(const char *cp, unsigned int base,
 void viafb_memory_pitch_patch(struct fb_info *info);
 void viafb_fill_var_timing_info(struct fb_var_screeninfo *var, int refresh,
 			  int mode_index);
-int viafb_get_mode_index(int hres, int vres, int flag);
+int viafb_get_mode_index(int hres, int vres);
 u8 viafb_gpio_i2c_read_lvds(struct lvds_setting_information
 	*plvds_setting_info, struct lvds_chip_information
 	*plvds_chip_info, u8 index);
-- 
1.6.3.2

