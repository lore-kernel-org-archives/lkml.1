Return-Path: <linux-kernel-owner+w=401wt.eu-S1759472AbYD0BMy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472AbYD0BMy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 21:12:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753143AbYD0BMq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 21:12:46 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54452 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031AbYD0BMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 21:12:45 -0400
Date: Sun, 27 Apr 2008 03:12:44 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: adaplas@gmail.com
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: [PATCH] vt: fix background color on line feed
Message-ID: <alpine.LNX.1.10.0804270257270.20150@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit c5180a555ced08a7e3011c16ef796e47569ae907
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Thu Apr 24 22:40:24 2008 +0200

vt: fix background color on line feed
    
A command that causes a line feed while a background color is active,
such as
    
	perl -e 'print "x" x 60, "\e[44m", "x" x 40, "\e[0m\n"'
and
	perl -e 'print "x" x 40, "\e[44m\n", "x" x 40, "\e[0m\n"'
    
causes the line that was started as a result of the line feed to be
completely filled with the currently active background color instead
of the default color.
    
Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
---
 drivers/char/vt.c              |    7 ++++---
 drivers/video/console/fbcon.c  |    8 ++++----
 drivers/video/console/mdacon.c |    2 +-
 drivers/video/console/sticon.c |    4 ++--
 drivers/video/console/vgacon.c |    4 ++--
 include/linux/console_struct.h |    1 +
 6 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 9b58b89..159c9e2 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -301,7 +301,7 @@ static void scrup(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
+	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_scrl_erase_char,
 		    vc->vc_size_row * nr);
 }
 
@@ -319,7 +319,7 @@ static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	step = vc->vc_cols * nr;
 	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(s, vc->vc_video_erase_char, 2 * step);
+	scr_memsetw(s, vc->vc_scrl_erase_char, 2 * step);
 }
 
 static void do_update_region(struct vc_data *vc, unsigned long start, int count)
@@ -400,7 +400,7 @@ static u8 build_attr(struct vc_data *vc, u8 _color, u8 _intensity, u8 _blink,
  *  Bit 7   : blink
  */
 	{
-	u8 a = vc->vc_color;
+	u8 a = _color;
 	if (!vc->vc_can_do_color)
 		return _intensity |
 		       (_italic ? 2 : 0) |
@@ -434,6 +434,7 @@ static void update_attr(struct vc_data *vc)
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
+	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, false, false) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 0222824..ca2a543 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1882,7 +1882,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 			break;
@@ -1954,7 +1954,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 		}
@@ -1973,7 +1973,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 			break;
@@ -2043,7 +2043,7 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_video_erase_char,
+				    vc->vc_scrl_erase_char,
 				    vc->vc_size_row * count);
 			return 1;
 		}
diff --git a/drivers/video/console/mdacon.c b/drivers/video/console/mdacon.c
index bd8d995..38a296b 100644
--- a/drivers/video/console/mdacon.c
+++ b/drivers/video/console/mdacon.c
@@ -531,7 +531,7 @@ static void mdacon_cursor(struct vc_data *c, int mode)
 
 static int mdacon_scroll(struct vc_data *c, int t, int b, int dir, int lines)
 {
-	u16 eattr = mda_convert_attr(c->vc_video_erase_char);
+	u16 eattr = mda_convert_attr(c->vc_scrl_erase_char);
 
 	if (!lines)
 		return 0;
diff --git a/drivers/video/console/sticon.c b/drivers/video/console/sticon.c
index 67a682d..a11cc2f 100644
--- a/drivers/video/console/sticon.c
+++ b/drivers/video/console/sticon.c
@@ -170,12 +170,12 @@ static int sticon_scroll(struct vc_data *conp, int t, int b, int dir, int count)
     switch (dir) {
     case SM_UP:
 	sti_bmove(sti, t + count, 0, t, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_video_erase_char);
+	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
 	break;
 
     case SM_DOWN:
 	sti_bmove(sti, t, 0, t + count, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_video_erase_char);
+	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
 	break;
     }
 
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index 6df29a6..bd1f57b 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1350,7 +1350,7 @@ static int vgacon_scroll(struct vc_data *c, int t, int b, int dir,
 		} else
 			c->vc_origin += delta;
 		scr_memsetw((u16 *) (c->vc_origin + c->vc_screenbuf_size -
-				     delta), c->vc_video_erase_char,
+				     delta), c->vc_scrl_erase_char,
 			    delta);
 	} else {
 		if (oldo - delta < vga_vram_base) {
@@ -1363,7 +1363,7 @@ static int vgacon_scroll(struct vc_data *c, int t, int b, int dir,
 		} else
 			c->vc_origin -= delta;
 		c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
-		scr_memsetw((u16 *) (c->vc_origin), c->vc_video_erase_char,
+		scr_memsetw((u16 *) (c->vc_origin), c->vc_scrl_erase_char,
 			    delta);
 	}
 	c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index d71f7c0..b03f80a 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -53,6 +53,7 @@ struct vc_data {
 	unsigned short	vc_hi_font_mask;	/* [#] Attribute set for upper 256 chars of font or 0 if not supported */
 	struct console_font vc_font;		/* Current VC font set */
 	unsigned short	vc_video_erase_char;	/* Background erase character */
+	unsigned short	vc_scrl_erase_char;	/* Erase character for scroll */
 	/* VT terminal data */
 	unsigned int	vc_state;		/* Escape sequence parser state */
 	unsigned int	vc_npar,vc_par[NPAR];	/* Parameters of current escape sequence */

