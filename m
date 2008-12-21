Return-Path: <linux-kernel-owner+w=401wt.eu-S1755524AbYLUPDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbYLUPDf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYLUPCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:02:10 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:59448 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYLUPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:02:00 -0500
Message-Id: <20081221150122.473385775@mail.of.borg>
References: <20081221150059.844577615@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 21 Dec 2008 16:01:02 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 3/6] fbdev: c2p - Cleanups
Content-Disposition: inline; filename=c2p-prepare.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Improve comments and naming
  - Use void * for arbitrary pointers
  - Use a union to represent pixels/words, to avoid casts

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/c2p.c |   80 +++++++++++++++++++++++++++-------------------------
 drivers/video/c2p.h |    6 +--
 2 files changed, 45 insertions(+), 41 deletions(-)

--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -54,7 +54,7 @@ static inline u32 get_mask(int n)
     return 0;
 }
 
-#define transp_nx1(d, n)				\
+#define transp8_nx1(d, n)				\
     do {						\
 	u32 mask = get_mask(n);				\
 	/* First block */				\
@@ -67,7 +67,7 @@ static inline u32 get_mask(int n)
 	_transp(d, 6, 7, n, mask);			\
     } while (0)
 
-#define transp_nx2(d, n)				\
+#define transp8_nx2(d, n)				\
     do {						\
 	u32 mask = get_mask(n);				\
 	/* First block */				\
@@ -78,40 +78,41 @@ static inline u32 get_mask(int n)
 	_transp(d, 5, 7, n, mask);			\
     } while (0)
 
-#define transp_nx4(d, n)				\
+#define transp8_nx4(d, n)				\
     do {						\
 	u32 mask = get_mask(n);				\
+	/* Single block */				\
 	_transp(d, 0, 4, n, mask);			\
 	_transp(d, 1, 5, n, mask);			\
 	_transp(d, 2, 6, n, mask);			\
 	_transp(d, 3, 7, n, mask);			\
     } while (0)
 
-#define transp(d, n, m)	transp_nx ## m(d, n)
+#define transp8(d, n, m)	transp8_nx ## m(d, n)
 
 
     /*
      *  Perform a full C2P step on 32 8-bit pixels, stored in 8 32-bit words
      *  containing
      *    - 32 8-bit chunky pixels on input
-     *    - permuted planar data on output
+     *    - permutated planar data (1 plane per 32-bit word) on output
      */
 
-static void c2p_8bpp(u32 d[8])
+static void c2p_32x8(u32 d[8])
 {
-    transp(d, 16, 4);
-    transp(d, 8, 2);
-    transp(d, 4, 1);
-    transp(d, 2, 4);
-    transp(d, 1, 2);
+    transp8(d, 16, 4);
+    transp8(d, 8, 2);
+    transp8(d, 4, 1);
+    transp8(d, 2, 4);
+    transp8(d, 1, 2);
 }
 
 
     /*
-     *  Array containing the permution indices of the planar data after c2p
+     *  Array containing the permutation indices of the planar data after c2p
      */
 
-static const int perm_c2p_8bpp[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
+static const int perm_c2p_32x8[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
 
 
     /*
@@ -130,12 +131,12 @@ static inline unsigned long comp(unsigne
      *  Store a full block of planar data after c2p conversion
      */
 
-static inline void store_planar(char *dst, u32 dst_inc, u32 bpp, u32 d[8])
+static inline void store_planar(void *dst, u32 dst_inc, u32 bpp, u32 d[8])
 {
     int i;
 
     for (i = 0; i < bpp; i++, dst += dst_inc)
-	*(u32 *)dst = d[perm_c2p_8bpp[i]];
+	*(u32 *)dst = d[perm_c2p_32x8[i]];
 }
 
 
@@ -143,13 +144,13 @@ static inline void store_planar(char *ds
      *  Store a partial block of planar data after c2p conversion
      */
 
-static inline void store_planar_masked(char *dst, u32 dst_inc, u32 bpp,
+static inline void store_planar_masked(void *dst, u32 dst_inc, u32 bpp,
 				       u32 d[8], u32 mask)
 {
     int i;
 
     for (i = 0; i < bpp; i++, dst += dst_inc)
-	*(u32 *)dst = comp(d[perm_c2p_8bpp[i]], *(u32 *)dst, mask);
+	*(u32 *)dst = comp(d[perm_c2p_32x8[i]], *(u32 *)dst, mask);
 }
 
 
@@ -166,18 +167,21 @@ static inline void store_planar_masked(c
      *  @bpp: Bits per pixel of the planar frame buffer (1-8)
      */
 
-void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
+void c2p(void *dst, const void *src, u32 dx, u32 dy, u32 width, u32 height,
 	 u32 dst_nextline, u32 dst_nextplane, u32 src_nextline, u32 bpp)
 {
-    int dst_idx;
-    u32 d[8], first, last, w;
+    union {
+	u8 pixels[32];
+	u32 words[8];
+    } d;
+    u32 dst_idx, first, last, w;
     const u8 *c;
-    u8 *p;
+    void *p;
 
     dst += dy*dst_nextline+(dx & ~31);
     dst_idx = dx % 32;
-    first = ~0UL >> dst_idx;
-    last = ~(~0UL >> ((dst_idx+width) % 32));
+    first = 0xffffffffU >> dst_idx;
+    last = ~(0xffffffffU >> ((dst_idx+width) % 32));
     while (height--) {
 	c = src;
 	p = dst;
@@ -185,11 +189,11 @@ void c2p(u8 *dst, const u8 *src, u32 dx,
 	if (dst_idx+width <= 32) {
 	    /* Single destination word */
 	    first &= last;
-	    memset(d, 0, sizeof(d));
-	    memcpy((u8 *)d+dst_idx, c, width);
+	    memset(d.pixels, 0, sizeof(d));
+	    memcpy(d.pixels+dst_idx, c, width);
 	    c += width;
-	    c2p_8bpp(d);
-	    store_planar_masked(p, dst_nextplane, bpp, d, first);
+	    c2p_32x8(d.words);
+	    store_planar_masked(p, dst_nextplane, bpp, d.words, first);
 	    p += 4;
 	} else {
 	    /* Multiple destination words */
@@ -197,30 +201,30 @@ void c2p(u8 *dst, const u8 *src, u32 dx,
 	    /* Leading bits */
 	    if (dst_idx) {
 		w = 32 - dst_idx;
-		memset(d, 0, dst_idx);
-		memcpy((u8 *)d+dst_idx, c, w);
+		memset(d.pixels, 0, dst_idx);
+		memcpy(d.pixels+dst_idx, c, w);
 		c += w;
-		c2p_8bpp(d);
-		store_planar_masked(p, dst_nextplane, bpp, d, first);
+		c2p_32x8(d.words);
+		store_planar_masked(p, dst_nextplane, bpp, d.words, first);
 		p += 4;
 		w = width-w;
 	    }
 	    /* Main chunk */
 	    while (w >= 32) {
-		memcpy(d, c, 32);
+		memcpy(d.pixels, c, 32);
 		c += 32;
-		c2p_8bpp(d);
-		store_planar(p, dst_nextplane, bpp, d);
+		c2p_32x8(d.words);
+		store_planar(p, dst_nextplane, bpp, d.words);
 		p += 4;
 		w -= 32;
 	    }
 	    /* Trailing bits */
 	    w %= 32;
 	    if (w > 0) {
-		memcpy(d, c, w);
-		memset((u8 *)d+w, 0, 32-w);
-		c2p_8bpp(d);
-		store_planar_masked(p, dst_nextplane, bpp, d, last);
+		memcpy(d.pixels, c, w);
+		memset(d.pixels+w, 0, 32-w);
+		c2p_32x8(d.words);
+		store_planar_masked(p, dst_nextplane, bpp, d.words, last);
 	    }
 	}
 	src += src_nextline;
--- a/drivers/video/c2p.h
+++ b/drivers/video/c2p.h
@@ -10,7 +10,7 @@
 
 #include <linux/types.h>
 
-extern void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
-		u32 dst_nextline, u32 dst_nextplane, u32 src_nextline,
-		u32 bpp);
+extern void c2p(void *dst, const void *src, u32 dx, u32 dy, u32 width,
+	        u32 height, u32 dst_nextline, u32 dst_nextplane,
+		u32 src_nextline, u32 bpp);
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

