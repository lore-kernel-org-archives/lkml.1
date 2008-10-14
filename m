Return-Path: <linux-kernel-owner+w=401wt.eu-S1753122AbYJNPdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbYJNPdV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 11:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbYJNPdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 11:33:13 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38020 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbYJNPdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 11:33:12 -0400
Date: Tue, 14 Oct 2008 11:33:09 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Alexander V. Lukyanov" <lav@netis.ru>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: linux 2.6.26 vt back_color_erase
In-Reply-To: <20081014081649.GA5654@night.netis.ru>
Message-ID: <alpine.LNX.1.10.0810141125540.13038@fbirervta.pbzchgretzou.qr>
References: <20081003081147.GA16414@night.netis.ru> <20081010164953.GA27092@night.netis.ru> <alpine.LNX.1.10.0810101310400.21097@fbirervta.pbzchgretzou.qr> <20081013052437.GA27761@night.netis.ru> <20081013093924.648c892d@lxorguk.ukuu.org.uk>
 <20081014081649.GA5654@night.netis.ru>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tuesday 2008-10-14 04:16, Alexander V. Lukyanov wrote:

>On Mon, Oct 13, 2008 at 09:39:24AM +0100, Alan Cox wrote:
>> > Probably color ls -l is just broken and should be fixed. Why was it
>> > necessary to change the console color semantics that was there for years?
>> 
>> Submit a patch that reverts the change. I would agree it needs reverting.
>
>Here is the patch to restore status quo.

Tested-by: Jan Engelhardt <jengelh@medozas.de>
Acked-by: Jan Engelhardt <jengelh@medozas.de>

I think this should be documented somewhere though
(perhaps right in the scrup() function in vt.c)
so that no one else tries to change it.

	/*
	 * A linewrap in itself does not cause the next line to be 
	 * erased with video_erase_char. Only when the terminal scrolls 
	 * (possibly as part of a linewrap), this is done.
	 * Other terminal emulators like xterm do the same.
	 * Note that applications rely on this erase-on-scroll behavior.
	 */

>diff -ru linux-2.6.27/drivers/char/vt.c linux-2.6.27+/drivers/char/vt.c
>--- linux-2.6.27/drivers/char/vt.c	2008-10-10 02:13:53.000000000 +0400
>+++ linux-2.6.27+/drivers/char/vt.c	2008-10-14 10:09:10.000000000 +0400
>@@ -301,7 +301,7 @@
> 	d = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
> 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
> 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
>-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_scrl_erase_char,
>+	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
> 		    vc->vc_size_row * nr);
> }
> 
>@@ -319,7 +319,7 @@
> 	s = (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
> 	step = vc->vc_cols * nr;
> 	scr_memmovew(s + step, s, (b - t - nr) * vc->vc_size_row);
>-	scr_memsetw(s, vc->vc_scrl_erase_char, 2 * step);
>+	scr_memsetw(s, vc->vc_video_erase_char, 2 * step);
> }
> 
> static void do_update_region(struct vc_data *vc, unsigned long start, int count)
>@@ -434,7 +434,6 @@
> 	              vc->vc_blink, vc->vc_underline,
> 	              vc->vc_reverse ^ vc->vc_decscnm, vc->vc_italic);
> 	vc->vc_video_erase_char = (build_attr(vc, vc->vc_color, 1, vc->vc_blink, 0, vc->vc_decscnm, 0) << 8) | ' ';
>-	vc->vc_scrl_erase_char = (build_attr(vc, vc->vc_def_color, 1, false, false, vc->vc_decscnm, false) << 8) | ' ';
> }
> 
> /* Note: inverting the screen twice should revert to the original state */
>diff -ru linux-2.6.27/drivers/video/console/fbcon.c linux-2.6.27+/drivers/video/console/fbcon.c
>--- linux-2.6.27/drivers/video/console/fbcon.c	2008-10-10 02:13:53.000000000 +0400
>+++ linux-2.6.27+/drivers/video/console/fbcon.c	2008-10-14 10:18:32.000000000 +0400
>@@ -1855,7 +1855,6 @@
> 	struct fb_info *info = registered_fb[con2fb_map[vc->vc_num]];
> 	struct display *p = &fb_display[vc->vc_num];
> 	int scroll_partial = info->flags & FBINFO_PARTIAL_PAN_OK;
>-	unsigned short saved_ec;
> 	int ret;
> 
> 	if (fbcon_is_inactive(vc, info))
>@@ -1869,9 +1868,6 @@
> 	 *           whole screen (prevents flicker).
> 	 */
> 
>-	saved_ec = vc->vc_video_erase_char;
>-	vc->vc_video_erase_char = vc->vc_scrl_erase_char;
>-
> 	ret = 0;
> 
> 	switch (dir) {
>@@ -1890,7 +1886,7 @@
> 			scr_memsetw((unsigned short *) (vc->vc_origin +
> 							vc->vc_size_row *
> 							(b - count)),
>-				    vc->vc_scrl_erase_char,
>+				    vc->vc_video_erase_char,
> 				    vc->vc_size_row * count);
> 			ret = 1;
> 			break;
>@@ -1962,7 +1958,7 @@
> 			scr_memsetw((unsigned short *) (vc->vc_origin +
> 							vc->vc_size_row *
> 							(b - count)),
>-				    vc->vc_scrl_erase_char,
>+				    vc->vc_video_erase_char,
> 				    vc->vc_size_row * count);
> 			ret = 1;
> 			break;
>@@ -1982,7 +1978,7 @@
> 			scr_memsetw((unsigned short *) (vc->vc_origin +
> 							vc->vc_size_row *
> 							t),
>-				    vc->vc_scrl_erase_char,
>+				    vc->vc_video_erase_char,
> 				    vc->vc_size_row * count);
> 			ret = 1;
> 			break;
>@@ -2052,14 +2048,13 @@
> 			scr_memsetw((unsigned short *) (vc->vc_origin +
> 							vc->vc_size_row *
> 							t),
>-				    vc->vc_scrl_erase_char,
>+				    vc->vc_video_erase_char,
> 				    vc->vc_size_row * count);
> 			ret = 1;
> 			break;
> 		}
> 		break;
> 	}
>-	vc->vc_video_erase_char = saved_ec;
> 	return ret;
> }
> 
>@@ -2522,9 +2517,6 @@
> 			c = vc->vc_video_erase_char;
> 			vc->vc_video_erase_char =
> 			    ((c & 0xfe00) >> 1) | (c & 0xff);
>-			c = vc->vc_scrl_erase_char;
>-			vc->vc_scrl_erase_char =
>-			    ((c & 0xFE00) >> 1) | (c & 0xFF);
> 			vc->vc_attr >>= 1;
> 		}
> 	} else if (!vc->vc_hi_font_mask && cnt == 512) {
>@@ -2555,13 +2547,9 @@
> 			if (vc->vc_can_do_color) {
> 				vc->vc_video_erase_char =
> 				    ((c & 0xff00) << 1) | (c & 0xff);
>-				c = vc->vc_scrl_erase_char;
>-				vc->vc_scrl_erase_char =
>-				    ((c & 0xFF00) << 1) | (c & 0xFF);
> 				vc->vc_attr <<= 1;
> 			} else {
> 				vc->vc_video_erase_char = c & ~0x100;
>-				vc->vc_scrl_erase_char = c & ~0x100;
> 			}
> 		}
> 
>diff -ru linux-2.6.27/drivers/video/console/mdacon.c linux-2.6.27+/drivers/video/console/mdacon.c
>--- linux-2.6.27/drivers/video/console/mdacon.c	2008-10-10 02:13:53.000000000 +0400
>+++ linux-2.6.27+/drivers/video/console/mdacon.c	2008-10-14 10:18:06.000000000 +0400
>@@ -533,7 +533,7 @@
> 
> static int mdacon_scroll(struct vc_data *c, int t, int b, int dir, int lines)
> {
>-	u16 eattr = mda_convert_attr(c->vc_scrl_erase_char);
>+	u16 eattr = mda_convert_attr(c->vc_video_erase_char);
> 
> 	if (!lines)
> 		return 0;
>diff -ru linux-2.6.27/drivers/video/console/sticon.c linux-2.6.27+/drivers/video/console/sticon.c
>--- linux-2.6.27/drivers/video/console/sticon.c	2008-10-10 02:13:53.000000000 +0400
>+++ linux-2.6.27+/drivers/video/console/sticon.c	2008-10-14 10:17:55.000000000 +0400
>@@ -170,12 +170,12 @@
>     switch (dir) {
>     case SM_UP:
> 	sti_bmove(sti, t + count, 0, t, 0, b - t - count, conp->vc_cols);
>-	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
>+	sti_clear(sti, b - count, 0, count, conp->vc_cols, conp->vc_video_erase_char);
> 	break;
> 
>     case SM_DOWN:
> 	sti_bmove(sti, t, 0, t + count, 0, b - t - count, conp->vc_cols);
>-	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_scrl_erase_char);
>+	sti_clear(sti, t, 0, count, conp->vc_cols, conp->vc_video_erase_char);
> 	break;
>     }
> 
>diff -ru linux-2.6.27/drivers/video/console/vgacon.c linux-2.6.27+/drivers/video/console/vgacon.c
>--- linux-2.6.27/drivers/video/console/vgacon.c	2008-10-10 02:13:53.000000000 +0400
>+++ linux-2.6.27+/drivers/video/console/vgacon.c	2008-10-14 10:17:38.000000000 +0400
>@@ -1350,7 +1350,7 @@
> 		} else
> 			c->vc_origin += delta;
> 		scr_memsetw((u16 *) (c->vc_origin + c->vc_screenbuf_size -
>-				     delta), c->vc_scrl_erase_char,
>+				     delta), c->vc_video_erase_char,
> 			    delta);
> 	} else {
> 		if (oldo - delta < vga_vram_base) {
>@@ -1363,7 +1363,7 @@
> 		} else
> 			c->vc_origin -= delta;
> 		c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
>-		scr_memsetw((u16 *) (c->vc_origin), c->vc_scrl_erase_char,
>+		scr_memsetw((u16 *) (c->vc_origin), c->vc_video_erase_char,
> 			    delta);
> 	}
> 	c->vc_scr_end = c->vc_origin + c->vc_screenbuf_size;
>diff -ru linux-2.6.27/include/linux/console_struct.h linux-2.6.27+/include/linux/console_struct.h
>--- linux-2.6.27/include/linux/console_struct.h	2008-10-10 02:13:53.000000000 +0400
>+++ linux-2.6.27+/include/linux/console_struct.h	2008-10-14 10:07:42.000000000 +0400
>@@ -53,7 +53,6 @@
> 	unsigned short	vc_hi_font_mask;	/* [#] Attribute set for upper 256 chars of font or 0 if not supported */
> 	struct console_font vc_font;		/* Current VC font set */
> 	unsigned short	vc_video_erase_char;	/* Background erase character */
>-	unsigned short	vc_scrl_erase_char;	/* Erase character for scroll */
> 	/* VT terminal data */
> 	unsigned int	vc_state;		/* Escape sequence parser state */
> 	unsigned int	vc_npar,vc_par[NPAR];	/* Parameters of current escape sequence */
>
>-- 
>   Alexander.
>

