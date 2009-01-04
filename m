Return-Path: <linux-kernel-owner+w=401wt.eu-S1758946AbZADLtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758946AbZADLtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:49:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756736AbZADLrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:20 -0500
Received: from wilson.telenet-ops.be ([195.130.132.42]:46934 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751643AbZADLrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 6/7] fbdev: c2p/atafb - Add support for Atari interleaved bitplanes
Date: Sun,  4 Jan 2009 12:47:03 +0100
Message-Id: <1231069624-13362-7-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231069624-13362-6-git-send-email-geert@linux-m68k.org>
References: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-3-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-4-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-5-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-6-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The c2p() for normal bitplanes is not suitable for interleaved bitplanes with
2 bytes of interleave, causing a garbled penguin logo. Add c2p_iplan2().

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/Makefile     |    2 +-
 drivers/video/atafb.c      |   15 +----
 drivers/video/c2p.h        |    5 +-
 drivers/video/c2p_core.h   |   47 ++++++++++++++
 drivers/video/c2p_iplan2.c |  153 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 208 insertions(+), 14 deletions(-)
 create mode 100644 drivers/video/c2p_iplan2.c

diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index e39e33e..4fc29ea 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -72,7 +72,7 @@ obj-$(CONFIG_FB_TCX)              += tcx.o sbuslib.o
 obj-$(CONFIG_FB_LEO)              += leo.o sbuslib.o
 obj-$(CONFIG_FB_SGIVW)            += sgivwfb.o
 obj-$(CONFIG_FB_ACORN)            += acornfb.o
-obj-$(CONFIG_FB_ATARI)            += atafb.o c2p.o atafb_mfb.o \
+obj-$(CONFIG_FB_ATARI)            += atafb.o c2p_iplan2.o atafb_mfb.o \
                                      atafb_iplan2p2.o atafb_iplan2p4.o atafb_iplan2p8.o
 obj-$(CONFIG_FB_MAC)              += macfb.o
 obj-$(CONFIG_FB_HECUBA)           += hecubafb.o
diff --git a/drivers/video/atafb.c b/drivers/video/atafb.c
index f932c13..477ce55 100644
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
@@ -2662,10 +2654,9 @@ static void atafb_imageblit(struct fb_info *info, const struct fb_image *image)
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
 
diff --git a/drivers/video/c2p.h b/drivers/video/c2p.h
index daafd87..5364129 100644
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
@@ -14,3 +14,6 @@ extern void c2p(void *dst, const void *src, u32 dx, u32 dy, u32 width,
 		u32 height, u32 dst_nextline, u32 dst_nextplane,
 		u32 src_nextline, u32 bpp);
 
+extern void c2p_iplan2(void *dst, const void *src, u32 dx, u32 dy, u32 width,
+		       u32 height, u32 dst_nextline, u32 src_nextline,
+		       u32 bpp);
diff --git a/drivers/video/c2p_core.h b/drivers/video/c2p_core.h
index 3573cf7..e1035a8 100644
--- a/drivers/video/c2p_core.h
+++ b/drivers/video/c2p_core.h
@@ -96,6 +96,53 @@ static inline void transp8(u32 d[], unsigned int n, unsigned int m)
 
 
     /*
+     *  Transpose operations on 4 32-bit words
+     */
+
+static inline void transp4(u32 d[], unsigned int n, unsigned int m)
+{
+	u32 mask = get_mask(n);
+
+	switch (m) {
+	case 1:
+		/* First n x 1 block */
+		_transp(d, 0, 1, n, mask);
+		/* Second n x 1 block */
+		_transp(d, 2, 3, n, mask);
+		return;
+
+	case 2:
+		/* Single n x 2 block */
+		_transp(d, 0, 2, n, mask);
+		_transp(d, 1, 3, n, mask);
+		return;
+	}
+
+	c2p_unsupported();
+}
+
+
+    /*
+     *  Transpose operations on 4 32-bit words (reverse order)
+     */
+
+static inline void transp4x(u32 d[], unsigned int n, unsigned int m)
+{
+	u32 mask = get_mask(n);
+
+	switch (m) {
+	case 2:
+		/* Single n x 2 block */
+		_transp(d, 2, 0, n, mask);
+		_transp(d, 3, 1, n, mask);
+		return;
+	}
+
+	c2p_unsupported();
+}
+
+
+    /*
      *  Compose two values, using a bitmask as decision value
      *  This is equivalent to (a & mask) | (b & ~mask)
      */
diff --git a/drivers/video/c2p_iplan2.c b/drivers/video/c2p_iplan2.c
new file mode 100644
index 0000000..19156dc
--- /dev/null
+++ b/drivers/video/c2p_iplan2.c
@@ -0,0 +1,153 @@
+/*
+ *  Fast C2P (Chunky-to-Planar) Conversion
+ *
+ *  Copyright (C) 2003-2008 Geert Uytterhoeven
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License. See the file COPYING in the main directory of this archive
+ *  for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/string.h>
+
+#include <asm/unaligned.h>
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
+		put_unaligned_be32(d[perm_c2p_16x8[i]], dst);
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
+		put_unaligned_be32(comp(d[perm_c2p_16x8[i]],
+					get_unaligned_be32(dst), mask),
+				   dst);
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
1.5.6.5

