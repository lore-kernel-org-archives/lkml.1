Return-Path: <linux-kernel-owner+w=401wt.eu-S1758800AbZADLti@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758800AbZADLti (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:49:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756989AbZADLrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:22 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:38066 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599AbZADLrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 7/7] fbdev: c2p - Rename c2p to c2p_planar
Date: Sun,  4 Jan 2009 12:47:04 +0100
Message-Id: <1231069624-13362-8-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231069624-13362-7-git-send-email-geert@linux-m68k.org>
References: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-3-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-4-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-5-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-6-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-7-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/Makefile     |    2 +-
 drivers/video/amifb.c      |    6 +-
 drivers/video/c2p.c        |  155 -------------------------------------------
 drivers/video/c2p.h        |    6 +-
 drivers/video/c2p_planar.c |  156 ++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 163 insertions(+), 162 deletions(-)
 delete mode 100644 drivers/video/c2p.c
 create mode 100644 drivers/video/c2p_planar.c

diff --git a/drivers/video/Makefile b/drivers/video/Makefile
index 4fc29ea..be2b657 100644
--- a/drivers/video/Makefile
+++ b/drivers/video/Makefile
@@ -28,7 +28,7 @@ obj-$(CONFIG_FB_DDC)           += fb_ddc.o
 obj-$(CONFIG_FB_DEFERRED_IO)   += fb_defio.o
 
 # Hardware specific drivers go first
-obj-$(CONFIG_FB_AMIGA)            += amifb.o c2p.o
+obj-$(CONFIG_FB_AMIGA)            += amifb.o c2p_planar.o
 obj-$(CONFIG_FB_ARC)              += arcfb.o
 obj-$(CONFIG_FB_CLPS711X)         += clps711xfb.o
 obj-$(CONFIG_FB_CYBER2000)        += cyber2000fb.o
diff --git a/drivers/video/amifb.c b/drivers/video/amifb.c
index b8e9a86..100f236 100644
--- a/drivers/video/amifb.c
+++ b/drivers/video/amifb.c
@@ -2159,9 +2159,9 @@ static void amifb_imageblit(struct fb_info *info, const struct fb_image *image)
 			src += pitch;
 		}
 	} else {
-		c2p(info->screen_base, image->data, dx, dy, width, height,
-		    par->next_line, par->next_plane, image->width,
-		    info->var.bits_per_pixel);
+		c2p_planar(info->screen_base, image->data, dx, dy, width,
+			   height, par->next_line, par->next_plane,
+			   image->width, info->var.bits_per_pixel);
 	}
 }
 
diff --git a/drivers/video/c2p.c b/drivers/video/c2p.c
deleted file mode 100644
index 1238c8b..0000000
--- a/drivers/video/c2p.c
+++ /dev/null
@@ -1,155 +0,0 @@
-/*
- *  Fast C2P (Chunky-to-Planar) Conversion
- *
- *  Copyright (C) 2003-2008 Geert Uytterhoeven
- *
- *  This file is subject to the terms and conditions of the GNU General Public
- *  License. See the file COPYING in the main directory of this archive
- *  for more details.
- */
-
-#include <linux/module.h>
-#include <linux/string.h>
-
-#include <asm/unaligned.h>
-
-#include "c2p.h"
-#include "c2p_core.h"
-
-
-    /*
-     *  Perform a full C2P step on 32 8-bit pixels, stored in 8 32-bit words
-     *  containing
-     *    - 32 8-bit chunky pixels on input
-     *    - permutated planar data (1 plane per 32-bit word) on output
-     */
-
-static void c2p_32x8(u32 d[8])
-{
-	transp8(d, 16, 4);
-	transp8(d, 8, 2);
-	transp8(d, 4, 1);
-	transp8(d, 2, 4);
-	transp8(d, 1, 2);
-}
-
-
-    /*
-     *  Array containing the permutation indices of the planar data after c2p
-     */
-
-static const int perm_c2p_32x8[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
-
-
-    /*
-     *  Store a full block of planar data after c2p conversion
-     */
-
-static inline void store_planar(void *dst, u32 dst_inc, u32 bpp, u32 d[8])
-{
-	int i;
-
-	for (i = 0; i < bpp; i++, dst += dst_inc)
-		put_unaligned_be32(d[perm_c2p_32x8[i]], dst);
-}
-
-
-    /*
-     *  Store a partial block of planar data after c2p conversion
-     */
-
-static inline void store_planar_masked(void *dst, u32 dst_inc, u32 bpp,
-				       u32 d[8], u32 mask)
-{
-	int i;
-
-	for (i = 0; i < bpp; i++, dst += dst_inc)
-		put_unaligned_be32(comp(d[perm_c2p_32x8[i]],
-					get_unaligned_be32(dst), mask),
-				   dst);
-}
-
-
-    /*
-     *  c2p - Copy 8-bit chunky image data to a planar frame buffer
-     *  @dst: Starting address of the planar frame buffer
-     *  @dx: Horizontal destination offset (in pixels)
-     *  @dy: Vertical destination offset (in pixels)
-     *  @width: Image width (in pixels)
-     *  @height: Image height (in pixels)
-     *  @dst_nextline: Frame buffer offset to the next line (in bytes)
-     *  @dst_nextplane: Frame buffer offset to the next plane (in bytes)
-     *  @src_nextline: Image offset to the next line (in bytes)
-     *  @bpp: Bits per pixel of the planar frame buffer (1-8)
-     */
-
-void c2p(void *dst, const void *src, u32 dx, u32 dy, u32 width, u32 height,
-	 u32 dst_nextline, u32 dst_nextplane, u32 src_nextline, u32 bpp)
-{
-	union {
-		u8 pixels[32];
-		u32 words[8];
-	} d;
-	u32 dst_idx, first, last, w;
-	const u8 *c;
-	void *p;
-
-	dst += dy*dst_nextline+(dx & ~31);
-	dst_idx = dx % 32;
-	first = 0xffffffffU >> dst_idx;
-	last = ~(0xffffffffU >> ((dst_idx+width) % 32));
-	while (height--) {
-		c = src;
-		p = dst;
-		w = width;
-		if (dst_idx+width <= 32) {
-			/* Single destination word */
-			first &= last;
-			memset(d.pixels, 0, sizeof(d));
-			memcpy(d.pixels+dst_idx, c, width);
-			c += width;
-			c2p_32x8(d.words);
-			store_planar_masked(p, dst_nextplane, bpp, d.words,
-					    first);
-			p += 4;
-		} else {
-			/* Multiple destination words */
-			w = width;
-			/* Leading bits */
-			if (dst_idx) {
-				w = 32 - dst_idx;
-				memset(d.pixels, 0, dst_idx);
-				memcpy(d.pixels+dst_idx, c, w);
-				c += w;
-				c2p_32x8(d.words);
-				store_planar_masked(p, dst_nextplane, bpp,
-						    d.words, first);
-				p += 4;
-				w = width-w;
-			}
-			/* Main chunk */
-			while (w >= 32) {
-				memcpy(d.pixels, c, 32);
-				c += 32;
-				c2p_32x8(d.words);
-				store_planar(p, dst_nextplane, bpp, d.words);
-				p += 4;
-				w -= 32;
-			}
-			/* Trailing bits */
-			w %= 32;
-			if (w > 0) {
-				memcpy(d.pixels, c, w);
-				memset(d.pixels+w, 0, 32-w);
-				c2p_32x8(d.words);
-				store_planar_masked(p, dst_nextplane, bpp,
-						    d.words, last);
-			}
-		}
-		src += src_nextline;
-		dst += dst_nextline;
-	}
-}
-EXPORT_SYMBOL_GPL(c2p);
-
-MODULE_LICENSE("GPL");
diff --git a/drivers/video/c2p.h b/drivers/video/c2p.h
index 5364129..6c38d40 100644
--- a/drivers/video/c2p.h
+++ b/drivers/video/c2p.h
@@ -10,9 +10,9 @@
 
 #include <linux/types.h>
 
-extern void c2p(void *dst, const void *src, u32 dx, u32 dy, u32 width,
-		u32 height, u32 dst_nextline, u32 dst_nextplane,
-		u32 src_nextline, u32 bpp);
+extern void c2p_planar(void *dst, const void *src, u32 dx, u32 dy, u32 width,
+		       u32 height, u32 dst_nextline, u32 dst_nextplane,
+		       u32 src_nextline, u32 bpp);
 
 extern void c2p_iplan2(void *dst, const void *src, u32 dx, u32 dy, u32 width,
 		       u32 height, u32 dst_nextline, u32 src_nextline,
diff --git a/drivers/video/c2p_planar.c b/drivers/video/c2p_planar.c
new file mode 100644
index 0000000..ec7ac85
--- /dev/null
+++ b/drivers/video/c2p_planar.c
@@ -0,0 +1,156 @@
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
+     *  Perform a full C2P step on 32 8-bit pixels, stored in 8 32-bit words
+     *  containing
+     *    - 32 8-bit chunky pixels on input
+     *    - permutated planar data (1 plane per 32-bit word) on output
+     */
+
+static void c2p_32x8(u32 d[8])
+{
+	transp8(d, 16, 4);
+	transp8(d, 8, 2);
+	transp8(d, 4, 1);
+	transp8(d, 2, 4);
+	transp8(d, 1, 2);
+}
+
+
+    /*
+     *  Array containing the permutation indices of the planar data after c2p
+     */
+
+static const int perm_c2p_32x8[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
+
+
+    /*
+     *  Store a full block of planar data after c2p conversion
+     */
+
+static inline void store_planar(void *dst, u32 dst_inc, u32 bpp, u32 d[8])
+{
+	int i;
+
+	for (i = 0; i < bpp; i++, dst += dst_inc)
+		put_unaligned_be32(d[perm_c2p_32x8[i]], dst);
+}
+
+
+    /*
+     *  Store a partial block of planar data after c2p conversion
+     */
+
+static inline void store_planar_masked(void *dst, u32 dst_inc, u32 bpp,
+				       u32 d[8], u32 mask)
+{
+	int i;
+
+	for (i = 0; i < bpp; i++, dst += dst_inc)
+		put_unaligned_be32(comp(d[perm_c2p_32x8[i]],
+					get_unaligned_be32(dst), mask),
+				   dst);
+}
+
+
+    /*
+     *  c2p_planar - Copy 8-bit chunky image data to a planar frame buffer
+     *  @dst: Starting address of the planar frame buffer
+     *  @dx: Horizontal destination offset (in pixels)
+     *  @dy: Vertical destination offset (in pixels)
+     *  @width: Image width (in pixels)
+     *  @height: Image height (in pixels)
+     *  @dst_nextline: Frame buffer offset to the next line (in bytes)
+     *  @dst_nextplane: Frame buffer offset to the next plane (in bytes)
+     *  @src_nextline: Image offset to the next line (in bytes)
+     *  @bpp: Bits per pixel of the planar frame buffer (1-8)
+     */
+
+void c2p_planar(void *dst, const void *src, u32 dx, u32 dy, u32 width,
+		u32 height, u32 dst_nextline, u32 dst_nextplane,
+		u32 src_nextline, u32 bpp)
+{
+	union {
+		u8 pixels[32];
+		u32 words[8];
+	} d;
+	u32 dst_idx, first, last, w;
+	const u8 *c;
+	void *p;
+
+	dst += dy*dst_nextline+(dx & ~31);
+	dst_idx = dx % 32;
+	first = 0xffffffffU >> dst_idx;
+	last = ~(0xffffffffU >> ((dst_idx+width) % 32));
+	while (height--) {
+		c = src;
+		p = dst;
+		w = width;
+		if (dst_idx+width <= 32) {
+			/* Single destination word */
+			first &= last;
+			memset(d.pixels, 0, sizeof(d));
+			memcpy(d.pixels+dst_idx, c, width);
+			c += width;
+			c2p_32x8(d.words);
+			store_planar_masked(p, dst_nextplane, bpp, d.words,
+					    first);
+			p += 4;
+		} else {
+			/* Multiple destination words */
+			w = width;
+			/* Leading bits */
+			if (dst_idx) {
+				w = 32 - dst_idx;
+				memset(d.pixels, 0, dst_idx);
+				memcpy(d.pixels+dst_idx, c, w);
+				c += w;
+				c2p_32x8(d.words);
+				store_planar_masked(p, dst_nextplane, bpp,
+						    d.words, first);
+				p += 4;
+				w = width-w;
+			}
+			/* Main chunk */
+			while (w >= 32) {
+				memcpy(d.pixels, c, 32);
+				c += 32;
+				c2p_32x8(d.words);
+				store_planar(p, dst_nextplane, bpp, d.words);
+				p += 4;
+				w -= 32;
+			}
+			/* Trailing bits */
+			w %= 32;
+			if (w > 0) {
+				memcpy(d.pixels, c, w);
+				memset(d.pixels+w, 0, 32-w);
+				c2p_32x8(d.words);
+				store_planar_masked(p, dst_nextplane, bpp,
+						    d.words, last);
+			}
+		}
+		src += src_nextline;
+		dst += dst_nextline;
+	}
+}
+EXPORT_SYMBOL_GPL(c2p_planar);
+
+MODULE_LICENSE("GPL");
-- 
1.5.6.5

