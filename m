Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbXFSMe4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbXFSMe4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 08:34:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbXFSMer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 08:34:47 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:43811 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462AbXFSMer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 08:34:47 -0400
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Jun 2007 08:34:46 EDT
Date: Tue, 19 Jun 2007 14:13:02 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Behdad Esfahbod <behdad@behdad.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070619121302.GA4445@uhulinux.hu>
References: <20070417102207.GA5629@uhulinux.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070417102207.GA5629@uhulinux.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Recently my console UTF-8 patch went mainline. Here I send a very small
additinal patch that fixes two nasty issues and improves a third one,
namely:

1. My patch changed the behavior if a glyph is not found in the Unicode
   mapping table. Previously for Unicode values less than 256 or 512 the
   kernel tried to display the glyph from that position of the glyph table,
   which could lead to a different accented letter being displayed. I
   removed this fallback possibility and changed it to display the
   replacement symbol.

   As Behdad pointed out, some fonts (e.g. sun12x22 from the kbd package)
   lack Unicode mapping information, hence all you get is lots of question
   marks. Though theoretically it's actually a user-space bug (the font
   should be fixed), Behdad and I both believe that it'd be good to work
   around in the kernel by re-introducing the fallback solution for ASCII
   characters only. This sounds a quite reasonable decision, since all fonts
   ship the ASCII characters in the first 128 positions. This way users
   won't be surprised by lots of question marks just because s/he issued a
   not-so-perfectly parameterized setfont command. As this fallback is only
   re-introduced for code points below 128, you still won't see an accented
   letter replaced by another, but at least you'll always get the English
   letters right.

2. My patch introduced "question mark with inverted color attributes" as a
   last resort fallback glyph. Though it perfectly works on VGA console, on
   framebuffer you may end up with question marks that are highlighed but
   shouldn't be, and normal characters that are accidentally highlighed.
   This is caused by missing FLUSHes when changing the color attribute.

3. I've updated the table of double-width character based on Markus's
   updated version. Only ten new code poings (one interval) is added.


Please review and commit this patch... I'm afraid it might be too late, but
it would be nice to see it in 2.6.22 -- as this will be the first stable
release that introduces my work, and the first two issues addressed now are
regressions since 2.6.21.

Thanks,

Signed-off-by: Egmont Koblinger <egmont@uhulinux.hu>

diff -Naur linux-2.6.22-rc5.orig/drivers/char/vt.c linux-2.6.22-rc5/drivers/char/vt.c
--- linux-2.6.22-rc5.orig/drivers/char/vt.c	2007-06-17 04:09:12.000000000 +0200
+++ linux-2.6.22-rc5/drivers/char/vt.c	2007-06-19 13:49:55.000000000 +0200
@@ -1956,7 +1956,7 @@
 DEFINE_MUTEX(con_buf_mtx);
 
 /* is_double_width() is based on the wcwidth() implementation by
- * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
+ * Markus Kuhn -- 2007-05-26 (Unicode 5.0)
  * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
  */
 struct interval {
@@ -1988,8 +1988,8 @@
 	static const struct interval double_width[] = {
 		{ 0x1100, 0x115F }, { 0x2329, 0x232A }, { 0x2E80, 0x303E },
 		{ 0x3040, 0xA4CF }, { 0xAC00, 0xD7A3 }, { 0xF900, 0xFAFF },
-		{ 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
-		{ 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
+		{ 0xFE10, 0xFE19 }, { 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 },
+		{ 0xFFE0, 0xFFE6 }, { 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
 	};
 	return bisearch(ucs, double_width,
 		sizeof(double_width) / sizeof(*double_width) - 1);
@@ -2187,9 +2187,12 @@
 				    continue; /* nothing to display */
 				}
 				/* Glyph not found */
-				if (!(vc->vc_utf && !vc->vc_disp_ctrl) && !(c & ~charmask)) {
+				if ((!(vc->vc_utf && !vc->vc_disp_ctrl) || c < 128) && !(c & ~charmask)) {
 				    /* In legacy mode use the glyph we get by a 1:1 mapping.
-				       This would make absolutely no sense with Unicode in mind. */
+				       This would make absolutely no sense with Unicode in mind,
+				       but do this for ASCII characters since a font may lack
+				       Unicode mapping info and we don't want to end up with
+				       having question marks only. */
 				    tc = c;
 				} else {
 				    /* Display U+FFFD. If it's not found, display an inverse question mark. */
@@ -2213,6 +2216,7 @@
 				} else {
 					vc_attr = ((vc->vc_attr) & 0x88) | (((vc->vc_attr) & 0x70) >> 4) | (((vc->vc_attr) & 0x07) << 4);
 				}
+				FLUSH
 			}
 
 			while (1) {
@@ -2246,6 +2250,10 @@
 				if (tc < 0) tc = ' ';
 			}
 
+			if (inverse) {
+				FLUSH
+			}
+
 			if (rescan) {
 				rescan = 0;
 				inverse = 0;
