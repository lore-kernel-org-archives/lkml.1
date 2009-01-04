Return-Path: <linux-kernel-owner+w=401wt.eu-S1759259AbZADLs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259AbZADLs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 06:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbZADLrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 06:47:19 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:55820 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZADLrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 06:47:10 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       linux-fbdev-devel@lists.sourceforge.net
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 4/7] fbdev: c2p - Cleanups
Date: Sun,  4 Jan 2009 12:47:01 +0100
Message-Id: <1231069624-13362-5-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1231069624-13362-4-git-send-email-geert@linux-m68k.org>
References: <1231069624-13362-1-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-2-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-3-git-send-email-geert@linux-m68k.org>
 <1231069624-13362-4-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  - Improve comments and naming
  - Convert macros to static inline functions
  - Remove superfluous `break' after `return'
  - Make sure we get a build-time error (undefined reference to
    'c2p_unsupported') in case of future misuse
  - Replace `unsigned long' by `u32' in comp(), as that's what all callers use
  - Use {get,put}_unaligned_be32() in store_planar{,_masked}()
  - Use void * for arbitrary pointers
  - Use a union to represent pixels/words, to avoid casts

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/video/c2p.c |  181 +++++++++++++++++++++++++++------------------------
 drivers/video/c2p.h |    6 +-
 2 files changed, 99 insertions(+), 88 deletions(-)

diff --git a/drivers/video/c2p.c b/drivers/video/c2p.c
index f102b57..c170fff 100644
--- a/drivers/video/c2p.c
+++ b/drivers/video/c2p.c
@@ -1,7 +1,7 @@
 /*
  *  Fast C2P (Chunky-to-Planar) Conversion
  *
- *  Copyright (C) 2003 Geert Uytterhoeven
+ *  Copyright (C) 2003-2008 Geert Uytterhoeven
  *
  *  NOTES:
  *    - This code was inspired by Scout's C2P tutorial
@@ -14,6 +14,9 @@
 
 #include <linux/module.h>
 #include <linux/string.h>
+
+#include <asm/unaligned.h>
+
 #include "c2p.h"
 
 
@@ -21,97 +24,100 @@
      *  Basic transpose step
      */
 
-#define _transp(d, i1, i2, shift, mask)				\
-	do {							\
-		u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;	\
-		d[i1] ^= t;					\
-		d[i2] ^= t << shift;				\
-	} while (0)
+static inline void _transp(u32 d[], unsigned int i1, unsigned int i2,
+			   unsigned int shift, u32 mask)
+{
+	u32 t = (d[i1] ^ (d[i2] >> shift)) & mask;
+
+	d[i1] ^= t;
+	d[i2] ^= t << shift;
+}
 
-static inline u32 get_mask(int n)
+extern void c2p_unsupported(void);
+
+static inline u32 get_mask(unsigned int n)
 {
 	switch (n) {
 	case 1:
 		return 0x55555555;
-		break;
 
 	case 2:
 		return 0x33333333;
-		break;
 
 	case 4:
 		return 0x0f0f0f0f;
-		break;
 
 	case 8:
 		return 0x00ff00ff;
-		break;
 
 	case 16:
 		return 0x0000ffff;
-		break;
 	}
+
+	c2p_unsupported();
 	return 0;
 }
 
-#define transp_nx1(d, n)					\
-	do {							\
-		u32 mask = get_mask(n);				\
-		/* First block */				\
-		_transp(d, 0, 1, n, mask);			\
-		/* Second block */				\
-		_transp(d, 2, 3, n, mask);			\
-		/* Third block */				\
-		_transp(d, 4, 5, n, mask);			\
-		/* Fourth block */				\
-		_transp(d, 6, 7, n, mask);			\
-	} while (0)
-
-#define transp_nx2(d, n)					\
-	do {							\
-		u32 mask = get_mask(n);				\
-		/* First block */				\
-		_transp(d, 0, 2, n, mask);			\
-		_transp(d, 1, 3, n, mask);			\
-		/* Second block */				\
-		_transp(d, 4, 6, n, mask);			\
-		_transp(d, 5, 7, n, mask);			\
-	} while (0)
-
-#define transp_nx4(d, n)					\
-	do {							\
-		u32 mask = get_mask(n);				\
-		_transp(d, 0, 4, n, mask);			\
-		_transp(d, 1, 5, n, mask);			\
-		_transp(d, 2, 6, n, mask);			\
-		_transp(d, 3, 7, n, mask);			\
-	} while (0)
-
-#define transp(d, n, m)	transp_nx ## m(d, n)
+static inline void transp8(u32 d[], unsigned int n, unsigned int m)
+{
+	u32 mask = get_mask(n);
+
+	switch (m) {
+	case 1:
+		/* First n x 1 block */
+		_transp(d, 0, 1, n, mask);
+		/* Second n x 1 block */
+		_transp(d, 2, 3, n, mask);
+		/* Third n x 1 block */
+		_transp(d, 4, 5, n, mask);
+		/* Fourth n x 1 block */
+		_transp(d, 6, 7, n, mask);
+		return;
+
+	case 2:
+		/* First n x 2 block */
+		_transp(d, 0, 2, n, mask);
+		_transp(d, 1, 3, n, mask);
+		/* Second n x 2 block */
+		_transp(d, 4, 6, n, mask);
+		_transp(d, 5, 7, n, mask);
+		return;
+
+	case 4:
+		/* Single n x 4 block */
+		_transp(d, 0, 4, n, mask);
+		_transp(d, 1, 5, n, mask);
+		_transp(d, 2, 6, n, mask);
+		_transp(d, 3, 7, n, mask);
+		return;
+	}
+
+	c2p_unsupported();
+}
 
 
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
-	transp(d, 16, 4);
-	transp(d, 8, 2);
-	transp(d, 4, 1);
-	transp(d, 2, 4);
-	transp(d, 1, 2);
+	transp8(d, 16, 4);
+	transp8(d, 8, 2);
+	transp8(d, 4, 1);
+	transp8(d, 2, 4);
+	transp8(d, 1, 2);
 }
 
 
     /*
-     *  Array containing the permution indices of the planar data after c2p
+     *  Array containing the permutation indices of the planar data after c2p
      */
 
-static const int perm_c2p_8bpp[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
+static const int perm_c2p_32x8[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
 
 
     /*
@@ -119,8 +125,7 @@ static const int perm_c2p_8bpp[8] = { 7, 5, 3, 1, 6, 4, 2, 0 };
      *  This is equivalent to (a & mask) | (b & ~mask)
      */
 
-static inline unsigned long comp(unsigned long a, unsigned long b,
-				 unsigned long mask)
+static inline u32 comp(u32 a, u32 b, u32 mask)
 {
 	return ((a ^ b) & mask) ^ b;
 }
@@ -130,12 +135,12 @@ static inline unsigned long comp(unsigned long a, unsigned long b,
      *  Store a full block of planar data after c2p conversion
      */
 
-static inline void store_planar(char *dst, u32 dst_inc, u32 bpp, u32 d[8])
+static inline void store_planar(void *dst, u32 dst_inc, u32 bpp, u32 d[8])
 {
 	int i;
 
 	for (i = 0; i < bpp; i++, dst += dst_inc)
-		*(u32 *)dst = d[perm_c2p_8bpp[i]];
+		put_unaligned_be32(d[perm_c2p_32x8[i]], dst);
 }
 
 
@@ -143,13 +148,15 @@ static inline void store_planar(char *dst, u32 dst_inc, u32 bpp, u32 d[8])
      *  Store a partial block of planar data after c2p conversion
      */
 
-static inline void store_planar_masked(char *dst, u32 dst_inc, u32 bpp,
+static inline void store_planar_masked(void *dst, u32 dst_inc, u32 bpp,
 				       u32 d[8], u32 mask)
 {
 	int i;
 
 	for (i = 0; i < bpp; i++, dst += dst_inc)
-		*(u32 *)dst = comp(d[perm_c2p_8bpp[i]], *(u32 *)dst, mask);
+		put_unaligned_be32(comp(d[perm_c2p_32x8[i]],
+					get_unaligned_be32(dst), mask),
+				   dst);
 }
 
 
@@ -166,18 +173,21 @@ static inline void store_planar_masked(char *dst, u32 dst_inc, u32 bpp,
      *  @bpp: Bits per pixel of the planar frame buffer (1-8)
      */
 
-void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
+void c2p(void *dst, const void *src, u32 dx, u32 dy, u32 width, u32 height,
 	 u32 dst_nextline, u32 dst_nextplane, u32 src_nextline, u32 bpp)
 {
-	int dst_idx;
-	u32 d[8], first, last, w;
+	union {
+		u8 pixels[32];
+		u32 words[8];
+	} d;
+	u32 dst_idx, first, last, w;
 	const u8 *c;
-	u8 *p;
+	void *p;
 
 	dst += dy*dst_nextline+(dx & ~31);
 	dst_idx = dx % 32;
-	first = ~0UL >> dst_idx;
-	last = ~(~0UL >> ((dst_idx+width) % 32));
+	first = 0xffffffffU >> dst_idx;
+	last = ~(0xffffffffU >> ((dst_idx+width) % 32));
 	while (height--) {
 		c = src;
 		p = dst;
@@ -185,11 +195,12 @@ void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
 		if (dst_idx+width <= 32) {
 			/* Single destination word */
 			first &= last;
-			memset(d, 0, sizeof(d));
-			memcpy((u8 *)d+dst_idx, c, width);
+			memset(d.pixels, 0, sizeof(d));
+			memcpy(d.pixels+dst_idx, c, width);
 			c += width;
-			c2p_8bpp(d);
-			store_planar_masked(p, dst_nextplane, bpp, d, first);
+			c2p_32x8(d.words);
+			store_planar_masked(p, dst_nextplane, bpp, d.words,
+					    first);
 			p += 4;
 		} else {
 			/* Multiple destination words */
@@ -197,32 +208,32 @@ void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
 			/* Leading bits */
 			if (dst_idx) {
 				w = 32 - dst_idx;
-				memset(d, 0, dst_idx);
-				memcpy((u8 *)d+dst_idx, c, w);
+				memset(d.pixels, 0, dst_idx);
+				memcpy(d.pixels+dst_idx, c, w);
 				c += w;
-				c2p_8bpp(d);
-				store_planar_masked(p, dst_nextplane, bpp, d,
-						    first);
+				c2p_32x8(d.words);
+				store_planar_masked(p, dst_nextplane, bpp,
+						    d.words, first);
 				p += 4;
 				w = width-w;
 			}
 			/* Main chunk */
 			while (w >= 32) {
-				memcpy(d, c, 32);
+				memcpy(d.pixels, c, 32);
 				c += 32;
-				c2p_8bpp(d);
-				store_planar(p, dst_nextplane, bpp, d);
+				c2p_32x8(d.words);
+				store_planar(p, dst_nextplane, bpp, d.words);
 				p += 4;
 				w -= 32;
 			}
 			/* Trailing bits */
 			w %= 32;
 			if (w > 0) {
-				memcpy(d, c, w);
-				memset((u8 *)d+w, 0, 32-w);
-				c2p_8bpp(d);
-				store_planar_masked(p, dst_nextplane, bpp, d,
-						    last);
+				memcpy(d.pixels, c, w);
+				memset(d.pixels+w, 0, 32-w);
+				c2p_32x8(d.words);
+				store_planar_masked(p, dst_nextplane, bpp,
+						    d.words, last);
 			}
 		}
 		src += src_nextline;
diff --git a/drivers/video/c2p.h b/drivers/video/c2p.h
index c77cbf1..daafd87 100644
--- a/drivers/video/c2p.h
+++ b/drivers/video/c2p.h
@@ -10,7 +10,7 @@
 
 #include <linux/types.h>
 
-extern void c2p(u8 *dst, const u8 *src, u32 dx, u32 dy, u32 width, u32 height,
-		u32 dst_nextline, u32 dst_nextplane, u32 src_nextline,
-		u32 bpp);
+extern void c2p(void *dst, const void *src, u32 dx, u32 dy, u32 width,
+		u32 height, u32 dst_nextline, u32 dst_nextplane,
+		u32 src_nextline, u32 bpp);
 
-- 
1.5.6.5

