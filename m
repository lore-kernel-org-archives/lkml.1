Return-Path: <linux-kernel-owner+w=401wt.eu-S1758314AbZDUVNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758314AbZDUVNb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 17:13:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758186AbZDUVNE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 17:13:04 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:33757 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758227AbZDUVNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 17:13:02 -0400
X-Auth-Info: TvwMaf441ZNUNY4WdWkxOeRbh9OsSFG41797/5u0DdI=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: linux-fbdev-devel@lists.sourceforge.net,
       Anatolij Gustschin <agust@denx.de>
Subject: [PATCH] Add CONFIG_FB_PRE_INIT_FB option to VT and fbcon
Date: Tue, 21 Apr 2009 23:13:00 +0200
Message-Id: <1240348380-15674-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On many embedded systems there is a requirement while
booting to inherit display controller configuration and
frame buffer contents from the state set by the bootloader
(e.g. splash screen). Using frame buffer console later
by some application should be possible too.

VT and fbcon code clears and also partially overwrites
frame buffer content after registering FB driver.
This patch adds CONFIG_FB_PRE_INIT_FB option to VT/fbcon
to prevent overwriting the frame buffer content while
initialization and later after blanking interval expired.

CONFIG_FB_PRE_INIT_FB option is used by MB862xx frame
buffer driver currently.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
---
 drivers/char/vt.c             |   10 ++++++++++
 drivers/video/console/fbcon.c |    7 +++++++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 08151d4..dd357ff 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -172,7 +172,11 @@ int do_poke_blanked_console;
 int console_blanked;
 
 static int vesa_blank_mode; /* 0:none 1:suspendV 2:suspendH 3:powerdown */
+#ifdef CONFIG_FB_PRE_INIT_FB
+static int blankinterval;
+#else
 static int blankinterval = 10*60*HZ;
+#endif
 static int vesa_off_interval;
 
 static DECLARE_WORK(console_work, console_callback);
@@ -695,8 +699,10 @@ void redraw_screen(struct vc_data *vc, int is_switch)
 			update_attr(vc);
 			clear_buffer_attributes(vc);
 		}
+#ifndef CONFIG_FB_PRE_INIT_FB
 		if (update && vc->vc_mode != KD_GRAPHICS)
 			do_update_region(vc, vc->vc_origin, vc->vc_screenbuf_size / 2);
+#endif
 	}
 	set_cursor(vc);
 	if (is_switch) {
@@ -777,7 +783,11 @@ int vc_allocate(unsigned int currcons)	/* return 0 on success */
 		return -ENOMEM;
 	    }
 	    vc->vc_kmalloced = 1;
+#ifdef CONFIG_FB_PRE_INIT_FB
+	    vc_init(vc, vc->vc_rows, vc->vc_cols, 0);
+#else
 	    vc_init(vc, vc->vc_rows, vc->vc_cols, 1);
+#endif
 	    vcs_make_sysfs(currcons);
 	    atomic_notifier_call_chain(&vt_notifier_list, VT_ALLOCATE, &param);
 	}
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 471a9a6..40c0fa1 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1057,6 +1057,9 @@ static void fbcon_init(struct vc_data *vc, int init)
 	if (p->userfont)
 		charcnt = FNTCHARCNT(p->fontdata);
 
+#ifdef CONFIG_FB_PRE_INIT_FB
+	vc->vc_deccm = 0;
+#endif
 	vc->vc_can_do_color = (fb_get_color_depth(&info->var, &info->fix)!=1);
 	vc->vc_complement_mask = vc->vc_can_do_color ? 0x7700 : 0x0800;
 	if (charcnt == 256) {
@@ -3038,7 +3041,11 @@ static int fbcon_fb_registered(struct fb_info *info)
 		}
 
 		if (info_idx != -1)
+#ifdef CONFIG_FB_PRE_INIT_FB
+			ret = fbcon_takeover(0);
+#else
 			ret = fbcon_takeover(1);
+#endif
 	} else {
 		for (i = first_fb_vc; i <= last_fb_vc; i++) {
 			if (con2fb_map_boot[i] == idx)
-- 
1.5.6.3

