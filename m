Return-Path: <linux-kernel-owner+w=401wt.eu-S1765522AbXJORg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765522AbXJORg0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 13:36:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbXJORgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 13:36:09 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:58760 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158AbXJORgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 13:36:08 -0400
Date: Mon, 15 Oct 2007 18:36:00 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Antonino Daplas <adaplas@pol.net>,
       linux-fbdev-devel@lists.sourceforge.net
cc: Jay Estabrook <Jay.Estabrook@hp.com>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] tgafb: Fix an out-of-range shift in mono imageblit
Message-ID: <Pine.LNX.4.64N.0710151812540.16262@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 The pixel mask calculation in tgafb_mono_imageblit() uses a variable 
left-shift on a 32-bit data type by up to 32.  Shifting by the width of a 
data type or more produces an unpredictable result according to the C 
standard.

 Rather than widening the data type this fix makes sure the count is 
between 0 and 31.  The reason is not to penalise 32-bit platforms with 
operation on a "long long" type for a marginal case that is meant not to 
happen (blitting an image of a zero width).

 The reason it has escaped for so long is the Alpha, being purely 64-bit, 
:-) does not mask the shift out to 32 bits.  This is a valid 
implementation -- producing the correct result certainly falls within 
"unpredictable behaviour".  It does trigger on MIPS though and it is the 
recent merge of the TC support which only enabled the driver for use on 
anything other than the Alpha.  For MIPS when the width is 32 the mask 
ends up being 0 rather than 0xffffffff as it should be and the frame 
buffer is not updated.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Checked with checkpatch.pl and at the run time with an 8-bit TC frame 
buffer on a MIPS host.  It fixes scrolling corruption.

 Please apply.

  Maciej

patch-mips-2.6.23-rc5-20070904-tgafb-mono_imageblit-width-0
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/video/tgafb.c linux-mips-2.6.23-rc5-20070904/drivers/video/tgafb.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/video/tgafb.c	2007-09-04 04:55:46.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/video/tgafb.c	2007-10-14 20:32:13.000000000 +0000
@@ -5,7 +5,7 @@
  *	Copyright (C) 1997 Geert Uytterhoeven
  *	Copyright (C) 1999,2000 Martin Lucina, Tom Zerucha
  *	Copyright (C) 2002 Richard Henderson
- *	Copyright (C) 2006 Maciej W. Rozycki
+ *	Copyright (C) 2006, 2007  Maciej W. Rozycki
  *
  *  This file is subject to the terms and conditions of the GNU General Public
  *  License. See the file COPYING in the main directory of this archive for
@@ -13,6 +13,7 @@
  */
 
 #include <linux/bitrev.h>
+#include <linux/compiler.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/errno.h>
@@ -654,6 +655,9 @@ tgafb_mono_imageblit(struct fb_info *inf
 	line_length = info->fix.line_length;
 	rincr = (width + 7) / 8;
 
+	/* A shift below cannot cope with.  */
+	if (unlikely(width == 0))
+		return;
 	/* Crop the image to the screen.  */
 	if (dx > vxres || dy > vyres)
 		return;
@@ -709,9 +713,10 @@ tgafb_mono_imageblit(struct fb_info *inf
 		unsigned long bwidth;
 
 		/* Handle common case of imaging a single character, in
-		   a font less than 32 pixels wide.  */
+		   a font less than or 32 pixels wide.  */
 
-		pixelmask = (1 << width) - 1;
+		/* Avoid a shift by 32; width > 0 implied.  */
+		pixelmask = (2ul << (width - 1)) - 1;
 		pixelmask <<= shift;
 		__raw_writel(pixelmask, regs_base + TGA_PIXELMASK_REG);
 		wmb();
