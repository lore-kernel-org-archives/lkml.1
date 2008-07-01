Return-Path: <linux-kernel-owner+w=401wt.eu-S1760412AbYGAPiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760412AbYGAPiS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759876AbYGAPhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:37:52 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:34398 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759720AbYGAPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:37:50 -0400
X-IronPort-AV: E=Sophos;i="4.27,732,1204502400"; 
   d="scan'208";a="836889"
Message-ID: <486A4F72.6030005@eu.citrix.com>
Date: Tue, 01 Jul 2008 16:38:26 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 2 of 2] fbcon: simple text blinking implementation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Jul 2008 15:37:49.0017 (UTC) FILETIME=[6A97DC90:01C8DB90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am using the flashcursor function to scan the buffer for blinking text.
For the sake of efficiency I added a simple flag mechanism to disable the scan
when I am sure that there are not blinking characters on the screen.

Signed-off-by: stefano.stabellini@eu.citrix.com

---
 drivers/video/console/fbcon.c |   62 +++++++++++++++++++++++++++++++++-------
 1 files changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 97aff8d..163b37a 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -152,6 +152,8 @@ static int fbcon_has_sysfs;
 
 static const struct consw fb_con;
 
+static int blink_flag = 1;
+
 #define CM_SOFTBACK	(8)
 
 #define advance_row(p, delta) (unsigned short *)((unsigned long)(p) + (delta) * vc->vc_size_row)
@@ -402,24 +404,58 @@ static void fb_flashcursor(struct work_struct *work)
 	struct vc_data *vc = NULL;
 	int c;
 	int mode;
+	unsigned short *s;
+	int x = 0, y = 0;
+	static int show_blink = 1;
 
 	acquire_console_sem();
 	if (ops && ops->currcon != -1)
 		vc = vc_cons[ops->currcon].d;
 
 	if (!vc || !CON_IS_VISIBLE(vc) ||
- 	    registered_fb[con2fb_map[vc->vc_num]] != info ||
-	    vc->vc_deccm != 1) {
+	    registered_fb[con2fb_map[vc->vc_num]] != info) {
 		release_console_sem();
 		return;
 	}
 
 	p = &fb_display[vc->vc_num];
-	c = scr_readw((u16 *) vc->vc_pos);
-	mode = (!ops->cursor_flash || ops->cursor_state.enable) ?
-		CM_ERASE : CM_DRAW;
-	ops->cursor(vc, info, mode, softback_lines, get_color(vc, info, c, 1),
-		    get_color(vc, info, c, 0));
+	if (vc->vc_deccm == 1 && !(vc->vc_cursor_type & 0x10)) {
+		c = scr_readw((u16 *) vc->vc_pos);
+		mode = (!ops->cursor_flash || ops->cursor_state.enable) ?
+			CM_ERASE : CM_DRAW;
+		ops->cursor(vc, info, mode, softback_lines,
+				get_color(vc, info, c, 1),
+				get_color(vc, info, c, 0));
+	}
+
+	if (vc->vc_hi_font_mask || !blink_flag) {
+		release_console_sem();
+		return;
+	}
+	if (!softback_lines)
+		s = (u16 *) vc->vc_origin;
+	else
+		s = (u16 *) softback_curr;
+	while (y < vc->vc_rows) {
+		while (x < vc->vc_cols) {
+			c = scr_readw(s);
+			if (attr_blink(c)) {
+				blink_flag = 1;
+				if (!show_blink)
+					c = (c & 0xf4ff) | (attr_bgcol(12, c) << 8);
+				fbcon_putc(vc, c, y, x);
+			}
+			s++;
+			x++;
+		}
+		x = 0;
+		y++;
+		if (s == (u16 *) softback_end)
+			s = (u16 *) softback_buf;
+		if (s == (u16 *) softback_in)
+			s = (u16 *) vc->vc_origin;
+	}
+	show_blink = show_blink ? 0 : 1;
 	release_console_sem();
 }
 
@@ -1331,6 +1367,8 @@ static void fbcon_putcs(struct vc_data *vc, const unsigned short *s,
 	struct display *p = &fb_display[vc->vc_num];
 	struct fbcon_ops *ops = info->fbcon_par;
 
+	if (!vc->vc_hi_font_mask && (vc->vc_attr & 0x80))
+		blink_flag = 1;
 	if (!fbcon_is_inactive(vc, info))
 		ops->putcs(vc, info, s, count, real_y(p, ypos), xpos,
 			   get_color(vc, info, scr_readw(s), 1),
@@ -1350,6 +1388,7 @@ static void fbcon_clear_margins(struct vc_data *vc, int bottom_only)
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct fbcon_ops *ops = info->fbcon_par;
 
+	blink_flag = 1;
 	if (!fbcon_is_inactive(vc, info))
 		ops->clear_margins(vc, info, bottom_only);
 }
@@ -1364,10 +1403,7 @@ static void fbcon_cursor(struct vc_data *vc, int mode)
 	if (fbcon_is_inactive(vc, info) || vc->vc_deccm != 1)
 		return;
 
-	if (vc->vc_cursor_type & 0x10)
-		fbcon_del_cursor_timer(info);
-	else
-		fbcon_add_cursor_timer(info);
+	fbcon_add_cursor_timer(info);
 
 	ops->cursor_flash = (mode == CM_ERASE) ? 0 : 1;
 	if (mode & CM_SOFTBACK) {
@@ -1860,6 +1896,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 		return -EINVAL;
 
 	fbcon_cursor(vc, CM_ERASE);
+	blink_flag = 1;
 
 	/*
 	 * ++Geert: Only use ywrap/ypan if the console is in text mode
@@ -2074,6 +2111,8 @@ static void fbcon_bmove(struct vc_data *vc, int sy, int sx, int dy, int dx,
 	if (!width || !height)
 		return;
 
+	blink_flag = 1;
+
 	/*  Split blits that cross physical y_wrap case.
 	 *  Pathological case involves 4 blits, better to use recursive
 	 *  code rather than unrolled case
@@ -2811,6 +2850,7 @@ static int fbcon_scrolldelta(struct vc_data *vc, int lines)
 	struct display *disp = &fb_display[fg_console];
 	int offset, limit, scrollback_old;
 
+	blink_flag = 1;
 	if (softback_top) {
 		if (vc->vc_num != fg_console)
 			return 0;
