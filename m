Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab0BIO02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 09:26:28 -0500
Received: from mail.gmx.net ([213.165.64.20]:34912 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754517Ab0BIO0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 09:26:20 -0500
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX19AqDlFcRFAQA/ZBXLFM4VemLGtKCd0vMojFMCy86
	CHuhfsHLS64UGg
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [PATCH 3/3] viafb: make viafb_set_par more dual framebuffer compatible
Date: Tue,  9 Feb 2010 14:32:38 +0000
Message-Id: <1265725958-4641-3-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: git-send-email 1.6.3.2
In-Reply-To: <1265725958-4641-2-git-send-email-FlorianSchandinat@gmx.de>
References: <1265725958-4641-1-git-send-email-FlorianSchandinat@gmx.de>
 <1265725958-4641-2-git-send-email-FlorianSchandinat@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.46000000000000002
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

viafb: make viafb_set_par more dual framebuffer compatible

This patch is an attempt to make viafb_set_par work correctly with
more than one framebuffer. As modesetting is not (yet/easily)
possible for each individual IGA it uses the (normally to be avoided)
global variables viafbinfo{,1} to ensure that each function is called
with the correct values.
This patch (finally) allows usable dual framebuffer setups and should
not affect non dual fb ones. It works in some (most?) configurations
as sometimes the driver still gets device connections wrong. It can
be worth to try the devices in reverse order (in viafb_active_dev).
The user experience is still not very nice as:
- on the second fb you'll normally have a garbled picture as long as
  no application draws to it
  goal: auto on/off devices depending on reference counting
- as the whole machinery is always done you can see mode changes also
  in an unaffected framebuffer
  goal: split modesetting up for each individual IGA

Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
---
 drivers/video/via/viafbdev.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index b417259..b1569a7 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -160,11 +160,17 @@ static int viafb_set_par(struct fb_info *info)
 	DEBUG_MSG(KERN_INFO "viafb_set_par!\n");
 
 	viapar->depth = fb_get_color_depth(&info->var, &info->fix);
-	viafb_update_device_setting(info->var.xres, info->var.yres,
-			      info->var.bits_per_pixel, viafb_refresh, 0);
+	viafb_update_device_setting(viafbinfo->var.xres, viafbinfo->var.yres,
+		viafbinfo->var.bits_per_pixel, viafb_refresh, 0);
 
-	vmode_entry = viafb_get_mode(info->var.xres, info->var.yres);
-	if (viafb_SAMM_ON == 1) {
+	vmode_entry = viafb_get_mode(viafbinfo->var.xres, viafbinfo->var.yres);
+	if (viafb_dual_fb) {
+		vmode_entry1 = viafb_get_mode(viafbinfo1->var.xres,
+			viafbinfo1->var.yres);
+		viafb_update_device_setting(viafbinfo1->var.xres,
+			viafbinfo1->var.yres, viafbinfo1->var.bits_per_pixel,
+			viafb_refresh1, 1);
+	} else if (viafb_SAMM_ON == 1) {
 		DEBUG_MSG(KERN_INFO
 		"viafb_second_xres = %d, viafb_second_yres = %d, bpp = %d\n",
 			  viafb_second_xres, viafb_second_yres, viafb_bpp1);
@@ -177,7 +183,11 @@ static int viafb_set_par(struct fb_info *info)
 
 	if (vmode_entry) {
 		viafb_update_fix(info);
-		viafb_bpp = info->var.bits_per_pixel;
+		if (viafb_dual_fb && viapar->iga_path == IGA2)
+			viafb_bpp1 = info->var.bits_per_pixel;
+		else
+			viafb_bpp = info->var.bits_per_pixel;
+
 		if (info->var.accel_flags & FB_ACCELF_TEXT)
 			info->flags &= ~FBINFO_HWACCEL_DISABLED;
 		else
-- 
1.6.3.2

