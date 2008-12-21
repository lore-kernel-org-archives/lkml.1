Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbYLUPDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbYLUPDu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbYLUPCM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:02:12 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:53583 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbYLUPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:02:00 -0500
Message-Id: <20081221150123.044798946@mail.of.borg>
References: <20081221150059.844577615@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 21 Dec 2008 16:01:04 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 5/6] fbdev: c2p/atafb - Add support for Atari interleaved bitplanes
Content-Disposition: inline; filename=c2p-iplan2p.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The c2p() for normal bitplanes is not suitable for interleaved bitplanes with
2 bytes of interleave, causing a garbled penguin logo. Add c2p_iplan2().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/Makefile     |    2 
 drivers/video/atafb.c      |   15 ----
 drivers/video/c2p.h        |    5 +
 drivers/video/c2p_core.h   |   39 +++++++++++
 drivers/video/c2p_iplan2.c |  153 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 200 insertions(+), 14 deletions(-)

--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -72,7 +72,7 @@ obj-$(CONFIG_FB_TCX)              += tcx
 obj-$(CONFIG_FB_LEO)              += leo.o sbuslib.o
 obj-$(CONFIG_FB_SGIVW)            += sgivwfb.o
 obj-$(CONFIG_FB_ACORN)            += acornfb.o
-obj-$(CONFIG_FB_ATARI)            += atafb.o c2p.o atafb_mfb.o \
+obj-$(CONFIG_FB_ATARI)            += atafb.o c2p_iplan2.o atafb_mfb.o \
                                      atafb_iplan2p2.o atafb_iplan2p4.o atafb_iplan2p8.o
 obj-$(CONFIG_FB_MAC)              += macfb.o
 obj-$(CONFIG_FB_HECUBA)           += hecubafb.o
--- a/drivers/video/atafb.c
+++ b/drivers/video/atafb.c
@@ -122,7 +122,6 @@ static struct atafb_par {
 	void *screen_base;
 	int yres_virtual;
 	u_long next_line;
-	u_long next_plane;
 #if defined ATAFB_TT || defined ATAFB_STE
 	union {
 		struct {
@@ -1392,14 +1391,7 @@ set_screen_base:
 	par->screen_base = screen_base + var->yoffset * linelen;
 	par->hw.falcon.xoffset = 0;
 
-	// FIXME!!! sort of works, no crash
-	//par->next_line = linelen;
-	//par->next_plane = yres_virtual * linelen;
 	par->next_line = linelen;
-	par->next_plane = 2;
-	// crashes
-	//par->next_plane = linelen;
-	//par->next_line  = yres_virtual * linelen;
 
 	return 0;
 }
@@ -2662,10 +2654,9 @@ static void atafb_imageblit(struct fb_in
 			src += pitch;
 		}
 	} else {
-		// only used for logo; broken
-		c2p(info->screen_base, image->data, dx, dy, width, height,
-		    par->next_line, par->next_plane, image->width,
-		    info->var.bits_per_pixel);
+		c2p_iplan2(info->screen_base, image->data, dx, dy, width,
+			   height, par->next_line, image->width,
+			   info->var.bits_per_pixel);
 	}
 }
 
--- a/drivers/video/c2p.h
+++ b/drivers/video/c2p.h
@@ -1,7 +1,7 @@
 /*
  *  Fast C2P (Chunky-to-Planar) Conversion
  *
- *  Copyright (C) 2003 Geert Uytterhoeven
+ *  Copyright (C) 2003-2008 Geert Uytterhoeven
  *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License. See the file COPYING in the main directory of this archive
@@ -14,3 +14,6 @@ extern void c2p(void *dst, const void *s
 	        u32 height, u32 dst_nextline, u32 dst_nextplane,
 		u32 src_nextline, u32 bpp);
 
+extern void c2p_iplan2(void *dst, const void *src, u32 dx, u32 dy, u32 width,
+		       u32 height, u32 dst_nextline, u32 src_nextline,
+		       u32 bpp);
--- a/drivers/video/c2p_core.h
+++ b/drivers/video/c2p_core.h
@@ -90,6 +90,45 @@ static inline u32 get_mask(int n)
 
 
     /*
+     *  Transpose operations on 4 32-bit words
+     */
+
+#define transp4_nx1(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* First block */				\
+		_transp(d, 0, 1, n, mask);			\
+		/* Second block */				\
+		_transp(d, 2, 3, n, mask);			\
+	} while (0)
+
+#define transp4_nx2(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* Single block */				\
+		_transp(d, 0, 2, n, mask);			\
+		_transp(d, 1, 3, n, mask);			\
+	} while (0)
+
+#define transp4(d, n, m)	transp4_nx ## m(d, n)
+
+
+    /*
+     *  Transpose operations on 4 32-bit words (reverse order)
+     */
+
+#define transp4x_nx2(d, n)					\
+	do {							\
+		u32 mask = get_mask(n);				\
+		/* Single block */				\
+		_transp(d, 2, 0, n, mask);			\
+		_transp(d, 3, 1, n, mask);			\
+	} while (0)
+
+#define transp4x(d, n, m)	transp4x_nx ## m(d, n)
+
+
+    /*
      *  Compose two values, using a bitmask as decision value
      *  This is equivalent to (a & mask) | (b & ~mask)
      */
--- /dev/null
+++ b/drivers/video/c2p_iplan2.c
@@ -0,0 +1,153 @@
+/*
+ *  Fast C2P (Chunky-to-Planar) Conversion
+ *
+ *  Copyright (C) 2003-2008 Geert Uytterhoeven
+ *
+ *  NOTES:
+ *    - This code was inspired by Scout's C2P tutorial
+ *    - It assumes to run on a big endian system
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive
+ *  for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include "c2p.h"
+#include "c2p_core.h"
+
+
+    /*
+     *  Perform a full C2P step on 16 8-bit pixels, stored in 4 32-bit words
+     *  containing
+     *    - 16 8-bit chunky pixels on input
+     *    - permutated planar data (2 planes per 32-bit word) on output
+     */
+
+static void c2p_16x8(u32 d[4])
+{
+	transp4(d, 8, 2);
+	transp4(d, 1, 2);
+	transp4x(d, 16, 2);
+	transp4x(d, 2, 2);
+	transp4(d, 4, 1);
+}
+
+
+    /*
+     *  Array containing the permutation indices of the planar data after c2p
+     */
+
+static const int perm_c2p_16x8[4] = { 1, 3, 0, 2 };
+
+
+    /*
+     *  Store a full block of iplan2 data after c2p conversion
+     */
+
+static inline void store_iplan2(void *dst, u32 bpp, u32 d[4])
+{
+	int i;
+
+	for (i = 0; i < bpp/2; i++, dst += 4)
+		*(u32 *)dst = d[perm_c2p_16x8[i]];
+}
+
+
+    /*
+     *  Store a partial block of iplan2 data after c2p conversion
+     */
+
+static inline void store_iplan2_masked(void *dst, u32 bpp, u32 d[4], u32 mask)
+{
+	int i;
+
+	for (i = 0; i < bpp/2; i++, dst += 4)
+		*(u32 *)dst = comp(d[perm_c2p_16x8[i]], *(u32 *)dst, mask);
+}
+
+
+    /*
+     *  c2p_iplan2 - Copy 8-bit chunky image data to an interleaved planar
+     *  frame buffer with 2 bytes of interleave
+     *  @dst: Starting address of the planar frame buffer
+     *  @dx: Horizontal destination offset (in pixels)
+     *  @dy: Vertical destination offset (in pixels)
+     *  @width: Image width (in pixels)
+     *  @height: Image height (in pixels)
+     *  @dst_nextline: Frame buffer offset to the next line (in bytes)
+     *  @src_nextline: Image offset to the next line (in bytes)
+     *  @bpp: Bits per pixel of the planar frame buffer (2, 4, or 8)
+     */
+
+void c2p_iplan2(void *dst, const void *src, u32 dx, u32 dy, u32 width,
+		u32 height, u32 dst_nextline, u32 src_nextline, u32 bpp)
+{
+	union {
+		u8 pixels[16];
+		u32 words[4];
+	} d;
+	u32 dst_idx, first, last, w;
+	const u8 *c;
+	void *p;
+
+	dst += dy*dst_nextline+(dx & ~15)*bpp;
+	dst_idx = dx % 16;
+	first = 0xffffU >> dst_idx;
+	first |= first << 16;
+	last = 0xffffU ^ (0xffffU >> ((dst_idx+width) % 16));
+	last |= last << 16;
+	while (height--) {
+		c = src;
+		p = dst;
+		w = width;
+		if (dst_idx+width <= 16) {
+			/* Single destination word */
+			first &= last;
+			memset(d.pixels, 0, sizeof(d));
+			memcpy(d.pixels+dst_idx, c, width);
+			c += width;
+			c2p_16x8(d.words);
+			store_iplan2_masked(p, bpp, d.words, first);
+			p += bpp*2;
+		} else {
+			/* Multiple destination words */
+			w = width;
+			/* Leading bits */
+			if (dst_idx) {
+				w = 16 - dst_idx;
+				memset(d.pixels, 0, dst_idx);
+				memcpy(d.pixels+dst_idx, c, w);
+				c += w;
+				c2p_16x8(d.words);
+				store_iplan2_masked(p, bpp, d.words, first);
+				p += bpp*2;
+				w = width-w;
+			}
+			/* Main chunk */
+			while (w >= 16) {
+				memcpy(d.pixels, c, 16);
+				c += 16;
+				c2p_16x8(d.words);
+				store_iplan2(p, bpp, d.words);
+				p += bpp*2;
+				w -= 16;
+			}
+			/* Trailing bits */
+			w %= 16;
+			if (w > 0) {
+				memcpy(d.pixels, c, w);
+				memset(d.pixels+w, 0, 16-w);
+				c2p_16x8(d.words);
+				store_iplan2_masked(p, bpp, d.words, last);
+			}
+		}
+		src += src_nextline;
+		dst += dst_nextline;
+	}
+}
+EXPORT_SYMBOL_GPL(c2p_iplan2);
+
+MODULE_LICENSE("GPL");

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

