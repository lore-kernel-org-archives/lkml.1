Return-Path: <linux-kernel-owner+w=401wt.eu-S1759528AbXG2CtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528AbXG2CtR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 22:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756116AbXG2CtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 22:49:07 -0400
Received: from vana.vc.cvut.cz ([147.32.240.58]:46317 "EHLO vana.vc.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755866AbXG2CtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 22:49:05 -0400
X-Greylist: delayed 1358 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jul 2007 22:49:05 EDT
Date: Sun, 29 Jul 2007 04:26:22 +0200
From: Petr Vandrovec <petr@vandrovec.name>
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] List VESA graphics videomodes when vesafb is present
Message-ID: <20070729022622.GA23141@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
  I had something like this in video.S for years, so it is probably time
to try to push it upstream...  Besides other problems it confirmed that
when I connect HDTV to my nVidia, BIOS decides that 640x480 is largest
possible resolution, as it is largest standard resolution smaller than
non-interlaced 1920x540, and apparently BIOS I have does not believe
that interlaced modes exist.
				Thanks,
					Petr Vandrovec


List VESA videomodes when vesafb is available

There is no CONFIG_VIDEO_VESA option, so code to retrieve VESA modes
(even text ones) was always disabled - it was introduced by conversion,
old video.S had #define CONFIG_VIDEO_VESA at the beginning.

Modify video-vesa.c to list graphics videomodes when vesafb is built in
and videomode is acceptable.

Because there is lot of videomodes in some VESA BIOSes, list them in three
columns (should be good for anybody - videocards with more than ~70 videomodes
cannot be used with some OSes, so vendors usually try to not cross more
than 60 videomodes reported by VESA).  Which unfortunately means that
card_name for "BIOS (scanned)" needs to be made shorter.

And display color depth for videomodes.  To avoid confusion depth
is shown only if non-text videomodes are present in the list.

---
commit 9453a2a4afee6cadb020838d0a35c2d11af25aa6
tree 5903315f7fd62db34f22107e63ec37a24bbf8075
parent 5de7fc0bf0e2e36a8dcf619e95576219dcc13d70
author Petr Vandrovec <petr@vandrovec.name> Sun, 22 Jul 2007 23:54:34 -0700
committer Petr Vandrovec <petr@vandrovec.name> Sun, 22 Jul 2007 23:54:34 -0700

 arch/i386/boot/video-bios.c |    3 ++-
 arch/i386/boot/video-vesa.c |   48 +++++++++++++++++++++++++++++++++++--------
 arch/i386/boot/video-vga.c  |   20 +++++++++---------
 arch/i386/boot/video.c      |   39 ++++++++++++++++++++++++++++++++---
 arch/i386/boot/video.h      |    3 ++-
 5 files changed, 89 insertions(+), 24 deletions(-)

diff --git a/arch/i386/boot/video-bios.c b/arch/i386/boot/video-bios.c
index afea46c..376ff71 100644
--- a/arch/i386/boot/video-bios.c
+++ b/arch/i386/boot/video-bios.c
@@ -104,6 +104,7 @@ static int bios_probe(void)
 
 		mi = GET_HEAP(struct mode_info, 1);
 		mi->mode = VIDEO_FIRST_BIOS+mode;
+		mi->depth = 0;	/* text */
 		mi->x = rdfs16(0x44a);
 		mi->y = rdfs8(0x484)+1;
 		nmodes++;
@@ -116,7 +117,7 @@ static int bios_probe(void)
 
 __videocard video_bios =
 {
-	.card_name	= "BIOS (scanned)",
+	.card_name	= "BIOS",
 	.probe		= bios_probe,
 	.set_mode	= bios_set_mode,
 	.unsafe		= 1,
diff --git a/arch/i386/boot/video-vesa.c b/arch/i386/boot/video-vesa.c
index e6aa9eb..af7019f 100644
--- a/arch/i386/boot/video-vesa.c
+++ b/arch/i386/boot/video-vesa.c
@@ -28,7 +28,7 @@ static void vesa_store_mode_params_graphics(void);
 
 static int vesa_probe(void)
 {
-#if defined(CONFIG_VIDEO_VESA) || defined(CONFIG_FIRMWARE_EDID)
+#if defined(CONFIG_VIDEO_SELECT) || defined(CONFIG_FIRMWARE_EDID)
 	u16 ax;
 	u16 mode;
 	addr_t mode_ptr;
@@ -47,8 +47,8 @@ static int vesa_probe(void)
 	    vginfo.signature != VESA_MAGIC ||
 	    vginfo.version < 0x0102)
 		return 0;	/* Not present */
-#endif /* CONFIG_VIDEO_VESA || CONFIG_FIRMWARE_EDID */
-#ifdef CONFIG_VIDEO_VESA
+#endif /* CONFIG_VIDEO_SELECT || CONFIG_FIRMWARE_EDID */
+#ifdef CONFIG_VIDEO_SELECT
 	set_fs(vginfo.video_mode_ptr.seg);
 	mode_ptr = vginfo.video_mode_ptr.off;
 
@@ -75,19 +75,49 @@ static int vesa_probe(void)
 			/* Text Mode, TTY BIOS supported,
 			   supported by hardware */
 			mi = GET_HEAP(struct mode_info, 1);
-			mi->mode = mode + VIDEO_FIRST_VESA;
-			mi->x    = vminfo.h_res;
-			mi->y    = vminfo.v_res;
+			mi->mode  = mode + VIDEO_FIRST_VESA;
+			mi->depth = 0; /* text */
+			mi->x     = vminfo.h_res;
+			mi->y     = vminfo.v_res;
 			nmodes++;
 		} else if ((vminfo.mode_attr & 0x99) == 0x99) {
 #ifdef CONFIG_FB
 			/* Graphics mode, color, linear frame buffer
-			   supported -- register the mode but hide from
+			   supported -- register the mode, and if there
+			   is no VESA framebuffer then hide from
 			   the menu.  Only do this if framebuffer is
 			   configured, however, otherwise the user will
 			   be left without a screen. */
 			mi = GET_HEAP(struct mode_info, 1);
-			mi->mode = mode + VIDEO_FIRST_VESA;
+			mi->mode = mode + VIDEO_FIRST_VESA;
+			mi->depth = 7;	/* ugly graphics */
+#ifdef CONFIG_FB_VESA
+			if ((vminfo.mode_attr & 0x02) &&   /* h_res & friends valid */
+			    (vminfo.memory_layout == 4 ||  /* packed pixel */
+			     vminfo.memory_layout == 6) && /* direct/true color */
+			    vminfo.memory_planes == 1) {   /* one memory plane */
+				switch (vminfo.bpp) {
+				case 8:
+				case 16:
+				case 24:
+				case 32:
+					mi->depth = vminfo.bpp / 8; /* 1-4 = 8-32 */
+					break;
+				case 15:
+					mi->depth = 5;	/* 5 = 15bpp */
+					break;
+				case 4:
+					mi->depth = 6;	/* 6 = 4bpp */
+					break;
+				default:
+					mi->depth = 7;	/* 7 = ugly */
+					break;
+				}
+				/* Assume standard character cell 8*16 */
+				mi->x = vminfo.h_res / (vminfo.char_width ? : 8);
+				mi->y = vminfo.v_res / (vminfo.char_height ? : 16);
+			} else
+#endif
 			mi->x = mi->y = 0;
 			nmodes++;
 #endif
@@ -97,7 +127,7 @@ static int vesa_probe(void)
 	return nmodes;
 #else
 	return 0;
-#endif /* CONFIG_VIDEO_VESA */
+#endif /* CONFIG_VIDEO_SELECT */
 }
 
 static int vesa_set_mode(struct mode_info *mode)
diff --git a/arch/i386/boot/video-vga.c b/arch/i386/boot/video-vga.c
index 700d09a..7191bee 100644
--- a/arch/i386/boot/video-vga.c
+++ b/arch/i386/boot/video-vga.c
@@ -18,22 +18,22 @@
 #include "video.h"
 
 static struct mode_info vga_modes[] = {
-	{ VIDEO_80x25,  80, 25 },
-	{ VIDEO_8POINT, 80, 50 },
-	{ VIDEO_80x43,  80, 43 },
-	{ VIDEO_80x28,  80, 28 },
-	{ VIDEO_80x30,  80, 30 },
-	{ VIDEO_80x34,  80, 34 },
-	{ VIDEO_80x60,  80, 60 },
+	{ VIDEO_80x25,  0, 80, 25 },
+	{ VIDEO_8POINT, 0, 80, 50 },
+	{ VIDEO_80x43,  0, 80, 43 },
+	{ VIDEO_80x28,  0, 80, 28 },
+	{ VIDEO_80x30,  0, 80, 30 },
+	{ VIDEO_80x34,  0, 80, 34 },
+	{ VIDEO_80x60,  0, 80, 60 },
 };
 
 static struct mode_info ega_modes[] = {
-	{ VIDEO_80x25,  80, 25 },
-	{ VIDEO_8POINT, 80, 43 },
+	{ VIDEO_80x25,  0, 80, 25 },
+	{ VIDEO_8POINT, 0, 80, 43 },
 };
 
 static struct mode_info cga_modes[] = {
-	{ VIDEO_80x25,  80, 25 },
+	{ VIDEO_80x25,  0, 80, 25 },
 };
 
 __videocard video_vga;
diff --git a/arch/i386/boot/video.c b/arch/i386/boot/video.c
index 958130e..8286b5f 100644
--- a/arch/i386/boot/video.c
+++ b/arch/i386/boot/video.c
@@ -33,6 +33,11 @@ int force_x, force_y;	/* Don't query the BIOS for cols/rows */
 int do_restore = 0;	/* Screen contents changed during mode flip */
 int graphic_mode;	/* Graphic mode with linear frame buffer */
 
+static const char depth_text[8][4] = {
+	"/TX", "/8",  "/16", "/24",
+	"/32", "/15", "/4",  "/GR"
+};
+
 static void store_cursor_position(void)
 {
 	u16 curpos;
@@ -287,9 +292,28 @@ static void display_menu(void)
 	struct mode_info *mi;
 	char ch;
 	int i;
+	int nmodes;
+	int modes_per_line;
+	int col;
+	int depths = 0;
+
+	nmodes = 0;
+	for (card = video_cards; card < video_cards_end; card++) {
+		mi = card->modes;
+		for (i = 0; i < card->nmodes; i++, mi++)
+			depths |= mi->depth;
+		nmodes += card->nmodes;
+	}
+
+	modes_per_line = 1;
+	if (nmodes >= 20)
+		modes_per_line = 3;
 
-	puts("Mode:    COLSxROWS:\n");
+	for (col = 0; col < modes_per_line; col++)
+		puts("Mode:    COLSxROWS:       ");
+	putchar('\n');
 
+	col = 0;
 	ch = '0';
 	for (card = video_cards; card < video_cards_end; card++) {
 		mi = card->modes;
@@ -301,8 +325,15 @@ static void display_menu(void)
 			if (!visible)
 				continue; /* Hidden mode */
 
-			printf("%c  %04X  %3dx%-3d  %s\n",
-			       ch, mode_id, mi->x, mi->y, card->card_name);
+			printf("%c  %04X %3dx%-3d%-4s%-7s",
+		    	       ch, mode_id, mi->x, mi->y,
+			       depths ? depth_text[mi->depth] : "",
+			       card->card_name);
+			col++;
+			if (col >= modes_per_line) {
+				putchar('\n');
+				col = 0;
+			}
 
 			if (ch == '9')
 				ch = 'a';
@@ -312,6 +343,8 @@ static void display_menu(void)
 				ch++;
 		}
 	}
+	if (col)
+		putchar('\n');
 }
 
 #define H(x)	((x)-'a'+10)
diff --git a/arch/i386/boot/video.h b/arch/i386/boot/video.h
index b92447d..941e981 100644
--- a/arch/i386/boot/video.h
+++ b/arch/i386/boot/video.h
@@ -82,7 +82,8 @@ void store_screen(void);
  */
 
 struct mode_info {
-	u16 mode;		/* Mode number (vga= style) */
+	u16 mode:12;		/* Mode number (vga= style) */
+	u16 depth:4;
 	u8  x, y;		/* Width, height */
 };
 
