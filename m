Return-Path: <linux-kernel-owner+w=401wt.eu-S1759915AbZDRS6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759915AbZDRS6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 14:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759600AbZDRSxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 14:53:38 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:55746 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759678AbZDRSxg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 14:53:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:x-pgp-key:user-agent;
        b=marrwdWINl4scfLTOEpGfVRmy51C7wnep/WeOMX8QD/KMGC/9sFPwq0hhK8uYZ/plF
         Jndve0R4cMNZPggu7PvD+pT+VsZoVgy3QB7bOul5/sBfi8XlpFT54wuIni4MdaDqWUt1
         rCUTWzd0alX3ZtRhi9hT0Wo/CM1lIsYJWqQ/8=
Date: Sat, 18 Apr 2009 20:52:34 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH v2] fbdev: fix fillrect for 24bpp modes
Message-ID: <20090418185234.GA17853@tria>
Reply-To: spock@gentoo.org
References: <20090413170954.GA8403@tria> <20090417183617.ed7553cd.krzysztof.h1@poczta.fm> <20090417115048.0c5ca35d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <20090417115048.0c5ca35d.akpm@linux-foundation.org>
X-PGP-Key: http://dev.gentoo.org/~spock/spock.gpg
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The software fillrect routines do not work properly when the number of
pixels per machine word is not an integer.  To see that, run the following
command on a fbdev console with a 24bpp video mode, using a non-accelerated
driver such as (u)vesafb:

  reset ; echo -e '\e[41mtest\e[K'

The expected result is 'test' displayed on a line with red background.
Instead of that, 'test' has a red background, but the rest of the line
(rendered using fillrect()) contains a distored colorful pattern.

This patch fixes the problem by correctly computing rotation shifts.
It has been tested in a 24bpp mode on 32- and 64-bit little-endian
machines.

Signed-off-by: Michał Januszewski <spock@gentoo.org>
---
This version of the patch should work correctly with modes where
line_length*8 % bpp != 0.

It also replaces the right shift by (ffs(bits) - 1) with a division
by bits, as both operations are optimized into a shift by a constant
and the latter one increases code readability.

In case this still breaks in some modes, I would appreciate a full
list of parameters describing the problem, i.e. bpp, line_length
and the top left coordinate of the rectangle that is painted
incorrectly.

diff --git a/drivers/video/cfbfillrect.c b/drivers/video/cfbfillrect.c
index 64b3576..faa1a39 100644
--- a/drivers/video/cfbfillrect.c
+++ b/drivers/video/cfbfillrect.c
@@ -9,10 +9,6 @@
  *
  * NOTES:
  *
- *  The code for depths like 24 that don't have integer number of pixels per
- *  long is broken and needs to be fixed. For now I turned these types of
- *  mode off.
- *
  *  Also need to add code to deal with cards endians that are different than
  *  the native cpu endians. I also need to deal with MSB position in the word.
  *
@@ -139,7 +135,7 @@ bitfill_unaligned(struct fb_info *p, unsigned long __iomem *dst, int dst_idx,
 
 		// Trailing bits
 		if (last)
-			FB_WRITEL(comp(pat, FB_READL(dst), first), dst);
+			FB_WRITEL(comp(pat, FB_READL(dst), last), dst);
 	}
 }
 
@@ -281,7 +277,7 @@ bitfill_unaligned_rev(struct fb_info *p, unsigned long __iomem *dst,
 
 void cfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 {
-	unsigned long pat, fg;
+	unsigned long pat, pat2, fg;
 	unsigned long width = rect->width, height = rect->height;
 	int bits = BITS_PER_LONG, bytes = bits >> 3;
 	u32 bpp = p->var.bits_per_pixel;
@@ -297,7 +293,7 @@ void cfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 	else
 		fg = rect->color;
 
-	pat = pixel_to_pat( bpp, fg);
+	pat = pixel_to_pat(bpp, fg);
 
 	dst = (unsigned long __iomem *)((unsigned long)p->screen_base & ~(bytes-1));
 	dst_idx = ((unsigned long)p->screen_base & (bytes - 1))*8;
@@ -333,17 +329,16 @@ void cfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 			dst_idx += p->fix.line_length*8;
 		}
 	} else {
-		int right;
-		int r;
-		int rot = (left-dst_idx) % bpp;
+		int right, r;
 		void (*fill_op)(struct fb_info *p, unsigned long __iomem *dst,
 				int dst_idx, unsigned long pat, int left,
 				int right, unsigned n, int bits) = NULL;
-
-		/* rotate pattern to correct start position */
-		pat = pat << rot | pat >> (bpp-rot);
-
-		right = bpp-left;
+#ifdef __LITTLE_ENDIAN
+		right = left;
+		left = bpp - right;
+#else
+		right = bpp - left;
+#endif
 		switch (rect->rop) {
 		case ROP_XOR:
 			fill_op = bitfill_unaligned_rev;
@@ -357,12 +352,17 @@ void cfb_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 			break;
 		}
 		while (height--) {
-			dst += dst_idx >> (ffs(bits) - 1);
+			dst += dst_idx / bits;
 			dst_idx &= (bits - 1);
-			fill_op(p, dst, dst_idx, pat, left, right,
+			r = dst_idx % bpp;
+			/* rotate pattern to the correct start position */
+#ifdef __LITTLE_ENDIAN
+			pat2 = pat << r | pat >> (bpp-r);
+#else
+			pat2 = pat << (bpp-r) | pat >> r;
+#endif
+			fill_op(p, dst, dst_idx, pat2, left, right,
 				width*bpp, bits);
-			r = (p->fix.line_length*8) % bpp;
-			pat = pat << (bpp-r) | pat >> r;
 			dst_idx += p->fix.line_length*8;
 		}
 	}
diff --git a/drivers/video/fb_draw.h b/drivers/video/fb_draw.h
index 1db6221..fa9626e 100644
--- a/drivers/video/fb_draw.h
+++ b/drivers/video/fb_draw.h
@@ -33,11 +33,11 @@ pixel_to_pat( u32 bpp, u32 pixel)
 	case 8:
 		return 0x0101010101010101ul*pixel;
 	case 12:
-		return 0x0001001001001001ul*pixel;
+		return 0x1001001001001001ul*pixel;
 	case 16:
 		return 0x0001000100010001ul*pixel;
 	case 24:
-		return 0x0000000001000001ul*pixel;
+		return 0x0001000001000001ul*pixel;
 	case 32:
 		return 0x0000000100000001ul*pixel;
 	default:
@@ -58,11 +58,11 @@ pixel_to_pat( u32 bpp, u32 pixel)
 	case 8:
 		return 0x01010101ul*pixel;
 	case 12:
-		return 0x00001001ul*pixel;
+		return 0x01001001ul*pixel;
 	case 16:
 		return 0x00010001ul*pixel;
 	case 24:
-		return 0x00000001ul*pixel;
+		return 0x01000001ul*pixel;
 	case 32:
 		return 0x00000001ul*pixel;
 	default:
diff --git a/drivers/video/sysfillrect.c b/drivers/video/sysfillrect.c
index f94d6b6..ff256a4 100644
--- a/drivers/video/sysfillrect.c
+++ b/drivers/video/sysfillrect.c
@@ -124,7 +124,7 @@ bitfill_unaligned(struct fb_info *p, unsigned long *dst, int dst_idx,
 
 		/* Trailing bits */
 		if (last)
-			*dst = comp(pat, *dst, first);
+			*dst = comp(pat, *dst, last);
 	}
 }
 
@@ -242,7 +242,7 @@ bitfill_unaligned_rev(struct fb_info *p, unsigned long *dst, int dst_idx,
 
 void sys_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 {
-	unsigned long pat, fg;
+	unsigned long pat, pat2, fg;
 	unsigned long width = rect->width, height = rect->height;
 	int bits = BITS_PER_LONG, bytes = bits >> 3;
 	u32 bpp = p->var.bits_per_pixel;
@@ -292,17 +292,16 @@ void sys_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 			dst_idx += p->fix.line_length*8;
 		}
 	} else {
-		int right;
-		int r;
-		int rot = (left-dst_idx) % bpp;
+		int right, r;
 		void (*fill_op)(struct fb_info *p, unsigned long *dst,
 				int dst_idx, unsigned long pat, int left,
 				int right, unsigned n, int bits) = NULL;
-
-		/* rotate pattern to correct start position */
-		pat = pat << rot | pat >> (bpp-rot);
-
-		right = bpp-left;
+#ifdef __LITTLE_ENDIAN
+		right = left;
+		left = bpp - right;
+#else
+		right = bpp - left;
+#endif
 		switch (rect->rop) {
 		case ROP_XOR:
 			fill_op = bitfill_unaligned_rev;
@@ -317,12 +316,17 @@ void sys_fillrect(struct fb_info *p, const struct fb_fillrect *rect)
 			break;
 		}
 		while (height--) {
-			dst += dst_idx >> (ffs(bits) - 1);
+			dst += dst_idx / bits;
 			dst_idx &= (bits - 1);
-			fill_op(p, dst, dst_idx, pat, left, right,
+			r = dst_idx % bpp;
+			/* rotate pattern to the correct start position */
+#ifdef __LITTLE_ENDIAN
+			pat2 = pat << r | pat >> (bpp-r);
+#else
+			pat2 = pat << (bpp-r) | pat >> r;
+#endif
+			fill_op(p, dst, dst_idx, pat2, left, right,
 				width*bpp, bits);
-			r = (p->fix.line_length*8) % bpp;
-			pat = pat << (bpp-r) | pat >> r;
 			dst_idx += p->fix.line_length*8;
 		}
 	}
