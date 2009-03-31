Return-Path: <linux-kernel-owner+w=401wt.eu-S1759974AbZCaW3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759974AbZCaW3A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 18:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756481AbZCaW2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 18:28:49 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:43271 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755237AbZCaW2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 18:28:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:reply-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=H00NcOG3m4sjZK83qf8qZdvyRt6G+Djpm+Xguu63PkhISebtvDjQu64iJdrpOLNo5l
         yK7Yr6b5yRmuAMjjXEMWjM5xfaUOuEtxrJr9kyQWOgPZ6TkGfxws7kN4ABqxjqENPF4o
         cB2Tx7mSzYh98EEEGRg4in/vIiey1/5UbxMM0=
Date: Wed, 1 Apr 2009 00:28:35 +0200
From: Michal Januszewski <spock@gentoo.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Ville =?utf-8?B?U3lyasOkbMOk?= <syrjala@sci.fi>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH] fbdev: fix color component field length documentation
Message-ID: <20090331222835.GA8482@tria>
Reply-To: spock@gentoo.org
References: <20090330220007.GC6540@spock.one.pl> <10f740e80903310018v7e12de88m696f07e40dc617e3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <10f740e80903310018v7e12de88m696f07e40dc617e3@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The documentation about the meaning of the color component bitfield lengths
in pseudocolor modes is inconsistent.  Fix it, so that it indicates the
correct interpretation everywhere, i.e. that 1 << length is the number
of palette entries.

Signed-off-by: Michal Januszewski <spock@gentoo.org>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Ville Syrjälä <syrjala@sci.fi>
Cc: Geert Uytterhoeven <geert.uytterhoeven@gmail.com>
---
This version of the patch incorporates Geert's comments about the
meaning of the offset field for pseudocolor modes.

diff --git a/drivers/video/skeletonfb.c b/drivers/video/skeletonfb.c
index df53365..63cf3bf 100644
--- a/drivers/video/skeletonfb.c
+++ b/drivers/video/skeletonfb.c
@@ -308,9 +308,11 @@ static int xxxfb_setcolreg(unsigned regno, unsigned red, unsigned green,
      *   color depth = SUM(var->{color}.length)
      *
      * Pseudocolor:
-     *    var->{color}.offset is 0
-     *    var->{color}.length contains width of DAC or the number of unique
-     *                        colors available (color depth)
+     *    var->{color}.offset is 0 unless the palette index takes less than
+     *                        bits_per_pixel bits and is stored in the upper
+     *                        bits of the pixel value
+     *    var->{color}.length is set so that 1 << length is the number of
+     *                        available palette entries
      *    pseudo_palette is not used
      *    RAMDAC[X] is programmed to (red, green, blue)
      *    color depth = var->{color}.length
diff --git a/drivers/video/vfb.c b/drivers/video/vfb.c
index 93fe08d..7d58c8a 100644
--- a/drivers/video/vfb.c
+++ b/drivers/video/vfb.c
@@ -318,13 +318,16 @@ static int vfb_setcolreg(u_int regno, u_int red, u_int green, u_int blue,
 	 *   {hardwarespecific} contains width of RAMDAC
 	 *   cmap[X] is programmed to (X << red.offset) | (X << green.offset) | (X << blue.offset)
 	 *   RAMDAC[X] is programmed to (red, green, blue)
-	 * 
+	 *
 	 * Pseudocolor:
-	 *    uses offset = 0 && length = RAMDAC register width.
-	 *    var->{color}.offset is 0
-	 *    var->{color}.length contains widht of DAC
+	 *    var->{color}.offset is 0 unless the palette index takes less than
+	 *                        bits_per_pixel bits and is stored in the upper
+	 *                        bits of the pixel value
+	 *    var->{color}.length is set so that 1 << length is the number of available
+	 *                        palette entries
 	 *    cmap is not used
 	 *    RAMDAC[X] is programmed to (red, green, blue)
+	 *
 	 * Truecolor:
 	 *    does not use DAC. Usually 3 are present.
 	 *    var->{color}.offset contains start of bitfield
diff --git a/include/linux/fb.h b/include/linux/fb.h
index 31527e1..0d52630 100644
--- a/include/linux/fb.h
+++ b/include/linux/fb.h
@@ -172,8 +172,12 @@ struct fb_fix_screeninfo {
 /* Interpretation of offset for color fields: All offsets are from the right,
  * inside a "pixel" value, which is exactly 'bits_per_pixel' wide (means: you
  * can use the offset as right argument to <<). A pixel afterwards is a bit
- * stream and is written to video memory as that unmodified. This implies
- * big-endian byte order if bits_per_pixel is greater than 8.
+ * stream and is written to video memory as that unmodified.
+ *
+ * For pseudocolor: offset and length should be the same for all color
+ * components. Offset specifies the position of the least significant bit
+ * of the pallette index in a pixel value. Length indicates the number
+ * of available palette entries (i.e. # of entries = 1 << length).
  */
 struct fb_bitfield {
 	__u32 offset;			/* beginning of bitfield	*/
