Return-Path: <linux-kernel-owner+w=401wt.eu-S1752939AbYJNQ77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbYJNQ77 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 12:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYJNQ7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 12:59:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44419 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251AbYJNQ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 12:59:49 -0400
Date: Tue, 14 Oct 2008 09:59:33 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Jan Engelhardt <jengelh@computergmbh.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Antonino A. Daplas" <adaplas@pol.net>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [REVERT Request] VT Breakage
In-Reply-To: <20081014115632.600a7506@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LFD.2.00.0810140936360.3288@nehalem.linux-foundation.org>
References: <20081014115632.600a7506@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 14 Oct 2008, Alan Cox wrote:
>
> In April someone merged
> 
> commit c9e587abfdec2c2aaa55fab83bcb4972e2f84f9b
> Author: Jan Engelhardt <jengelh@computergmbh.de>
> Date:   Tue Apr 29 00:59:46 2008 -0700
> 
>     vt: fix background color on line feed
> 
> 
> Unfortunately it's wrong and its been causing breakages because various
> apps like ncurses expect our previous (and correct) behaviour.
> 
> Can you therefore revert it (seems saner than sending you a patch -R)

Actually, you'd need to send a tested patch (or rather, at least test the 
trial patch I'm including here). Because it's not a trivial revert at all, 
we've had various fbcon fixups since that depend on that commit.

See at least commits

 - afa9b649 "fbcon: prevent cursor disappearance after switching to 512 
   character font"

 - d850a2fa "vt/fbcon: fix background color on line feed"

 - 7fe3915a "vt/fbcon: update scrl_erase_char after 256/512-glyph font 
   switch"

and while I suspect that reverting them all in that order (ie

  git revert -n afa9b649
  git revert -n d850a2fa
  git revert -n 7fe3915a
  git revert -n c9e587ab

should work (with a trivial fixup), I need somebody to test the result.

Here's the patch as best as I can do. It compiles, but I have not tested 
it, nor seen any of the failure cases, so I really don't want to commit it 
as-is.

So please check this patch. Also, can somebody please verify what the 
_correct_ vt100 behavior is? The test-case was in the original commit, but 
quite frankly, it doesn't work on my text console like it does on xterm 
_or_ 'termina' for me, _with_ the patch in place. So I suspect a revert is 
good, but I want to have this tested/explained more.

		Linus

----
 drivers/char/vt.c              |    7 +++----
 drivers/video/console/fbcon.c  |   39 ++++++++++-----------------------------
 drivers/video/console/mdacon.c |    2 +-
 drivers/video/console/sticon.c |    4 ++--
 drivers/video/console/vgacon.c |    4 ++--
 include/linux/console_struct.h |    1 -
 6 files changed, 18 insertions(+), 39 deletions(-)

diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 57029fe..4ab5df9 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -301,7 +301,7 @@ static void scrup(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_scrl_erase_char,
+	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
 		    vc->vc_size_row * nr);
 }
 
@@ -319,7 +319,7 @@ static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b, int nr)
 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
 	step = vc->vc_cols * nr;
 	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(s, vc->vc_scrl_erase_char, 2 * step);
+	scr_memsetw(s, vc->vc_video_erase_char, 2 * step);
 }
 
 static void do_update_region(struct vc_data *vc, unsigned long start, int count)
@@ -400,7 +400,7 @@ static u8 build_attr(struct vc_data *vc, u8 _color, u8 _intensity, u8 _blink,
  *  Bit 7   : blink
  */
 	{
-	u8 a = _color;
+	u8 a = vc->vc_color;
 	if (!vc->vc_can_do_color)
 		return _intensity |
 		       (_italic ? 2 : 0) |
@@ -434,7 +434,6 @@ static void update_attr(struct vc_data *vc)
 	              vc->vc_blink, vc->vc_underline,
 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
-	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, vc->vc_decscnm, false) << 8) | ' ';
 }
 
 /* Note: inverting the screen twice should revert to the original state */
diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 9cbff84..da91bb1 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -1855,8 +1855,6 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
 	struct display *p = &fb_display[vc->vc_num];
 	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
-	unsigned short saved_ec;
-	int ret;
 
 	if (fbcon_is_inactive(vc, info))
 		return -EINVAL;
@@ -1869,11 +1867,6 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 	 *           whole screen (prevents flicker).
 	 */
 
-	saved_ec = vc->vc_video_erase_char;
-	vc->vc_video_erase_char = vc->vc_scrl_erase_char;
-
-	ret = 0;
-
 	switch (dir) {
 	case SM_UP:
 		if (count > vc->vc_rows)	/* Maximum realistic size */
@@ -1890,9 +1883,9 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
-			ret = 1;
+			return 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
@@ -1962,10 +1955,9 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							(b - count)),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
-			ret = 1;
-			break;
+			return 1;
 		}
 		break;
 
@@ -1982,9 +1974,9 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
-			ret = 1;
+			return 1;
 			break;
 
 		case SCROLL_WRAP_MOVE:
@@ -2052,15 +2044,12 @@ static int fbcon_scroll(struct vc_data *vc, int t, int b, int dir,
 			scr_memsetw((unsigned short *) (vc->vc_origin +
 							vc->vc_size_row *
 							t),
-				    vc->vc_scrl_erase_char,
+				    vc->vc_video_erase_char,
 				    vc->vc_size_row * count);
-			ret = 1;
-			break;
+			return 1;
 		}
-		break;
 	}
-	vc->vc_video_erase_char = saved_ec;
-	return ret;
+	return 0;
 }
 
 
@@ -2522,9 +2511,6 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h,
 			c = vc->vc_video_erase_char;
 			vc->vc_video_erase_char =
 			    ((c & 0xfe00) >> 1) | (c & 0xff);
-			c = vc->vc_scrl_erase_char;
-			vc->vc_scrl_erase_char =
-			    ((c & 0xFE00) >> 1) | (c & 0xFF);
 			vc->vc_attr >>= 1;
 		}
 	} else if (!vc->vc_hi_font_mask && cnt == 512) {
@@ -2555,14 +2541,9 @@ static int fbcon_do_set_font(struct vc_data *vc, int w, int h,
 			if (vc->vc_can_do_color) {
 				vc->vc_video_erase_char =
 				    ((c & 0xff00) << 1) | (c & 0xff);
-				c = vc->vc_scrl_erase_char;
-				vc->vc_scrl_erase_char =
-				    ((c & 0xFF00) << 1) | (c & 0xFF);
 				vc->vc_attr <<= 1;
-			} else {
+			} else
 				vc->vc_video_erase_char = c & ~0x100;
-				vc->vc_scrl_erase_char = c & ~0x100;
-			}
 		}
 
 	}
diff --git a/drivers/video/console/mdacon.c b/drivers/video/console/mdacon.c
index 9901064..dd3eaaa 100644
--- a/drivers/video/console/mdacon.c
+++ b/drivers/video/console/mdacon.c
@@ -533,7 +533,7 @@ static void mdacon_cursor(struct vc_data *c, int mode)
 
 static int mdacon_scroll(struct vc_data *c, int t, int b, int dir, int lines)
 {
-	u16 eattr = mda_convert_attr(c->vc_scrl_erase_char);
+	u16 eattr = mda_convert_attr(c->vc_video_erase_char);
 
 	if (!lines)
 		return 0;
diff --git a/drivers/video/console/sticon.c b/drivers/video/console/sticon.c
index 4055dbd..491c1c1 100644
--- a/drivers/video/console/sticon.c
+++ b/drivers/video/console/sticon.c
@@ -170,12 +170,12 @@ static int sticon_scroll(struct vc_data *conp, int t, int b, int dir, int count)
     switch (dir) {
     case SM_UP:
 	sti_bmove(sti, t + count, 0, t, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
+	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_video_erase_char);
 	break;
 
     case SM_DOWN:
 	sti_bmove(sti, t, 0, t + count, 0, b - t - count, conp->vc_cols);
-	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
+	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_video_erase_char);
 	break;
     }
 
diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index bd1f57b..6df29a6 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -1350,7 +1350,7 @@ static int vgacon_scroll(struct vc_data *c, int t, int b, int dir,
 		} else
 			c->vc_origin += delta;
 		scr_memsetw((u16 *) (c->vc_origin + c->vc_screenbuf_size -
-				     delta), c->vc_scrl_erase_char,
+				     delta), c->vc_video_erase_char,
 			    delta);
 	} else {
 		if (oldo - delta < vga_vram_base) {
@@ -1363,7 +1363,7 @@ static int vgacon_scroll(struct vc_data *c, int t, int b, int dir,
 		} else
 			c->vc_origin -= delta;
 		c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
-		scr_memsetw((u16 *) (c->vc_origin), c->vc_scrl_erase_char,
+		scr_memsetw((u16 *) (c->vc_origin), c->vc_video_erase_char,
 			    delta);
 	}
 	c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
diff --git a/include/linux/console_struct.h b/include/linux/console_struct.h
index b03f80a..d71f7c0 100644
--- a/include/linux/console_struct.h
+++ b/include/linux/console_struct.h
@@ -53,7 +53,6 @@ struct vc_data {
 	unsigned short	vc_hi_font_mask;	/* [#] Attribute set for upper 256 chars of font or 0 if not supported */
 	struct console_font vc_font;		/* Current VC font set */
 	unsigned short	vc_video_erase_char;	/* Background erase character */
-	unsigned short	vc_scrl_erase_char;	/* Erase character for scroll */
 	/* VT terminal data */
 	unsigned int	vc_state;		/* Escape sequence parser state */
 	unsigned int	vc_npar,vc_par[NPAR];	/* Parameters of current escape sequence */
