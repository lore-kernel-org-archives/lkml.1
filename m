Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbXDKTD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbXDKTD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 15:03:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbXDKTD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 15:03:27 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:53747 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXDKTD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 15:03:26 -0400
Date: Wed, 11 Apr 2007 21:00:49 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Egmont Koblinger <egmont@uhulinux.hu>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
In-Reply-To: <20070411182801.GC26382@uhulinux.hu>
Message-ID: <Pine.LNX.4.61.0704112048240.20436@yvahk01.tjqt.qr>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com>
 <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr>
 <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com>
 <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com>
 <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu>
 <20070411182801.GC26382@uhulinux.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 11 2007 20:28, Egmont Koblinger wrote:

>I send a reworked version of the patch.
>
>Removed from the first version:
>  - any sign of '.' as substitute glyph
>  - don't ignore zero-width characters (except for a few zero-width spaces
>    that are ignored in the current kernel too). However, I kept the code
>    organized and commented so that someone can have the other behavior very
>    easily (by removing a pair of comment signs).
>
>Kept features, fixes:
>  - lots of UTF-8 decoder fixes. Emit one U+FFFD for every standalone
>    continuation byte and for every incomplete sequence, as Markus Kuhn
>    recommends. Reject overlong sequences too.
>  - D800..DFFF and FFFE..FFFF are substituted by FFFD too, since these are
>    not valid Unicode code points.
>  - no "random" replacement glyph (e.g. u with double acute instead of
>    u with circumflex) in UTF-8 mode
>  - if U+FFFD is not found in the font, the fallback replacement '?' (ascii
>    question mark) is printed with inverse color attributes
>  - U+200A was ignored so far as a zero-width space character. I think it
>    was a mistake, it's not zero-width.
>  - print an extra space for double-wide characters for the cursor to stand
>    at the right place. Yet again the code is organized so that it is very
>    easy to change to jump only one character cell, should someone prefer
>    that behavior (which I still see no good reason to).
>
>Signed-off-by: Egmont Koblinger <egmont@uhulinux.hu>
>
>@@ -1934,6 +1943,99 @@
> char con_buf[CON_BUF_SIZE];
> DECLARE_MUTEX(con_buf_sem);
> 
>+/* is_{zero,double}_width() are based on the wcwidth() implementation by
>+ * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
>+ * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
>+ */
>+struct interval {
>+  int first;
>+  int last;
>+};

CodingStyle? uint16_t instead of int?

>+static int is_zero_width(long ucs)
>+{
>+  static const struct interval zero_width[] = {
>+    { 0x0300, 0x0357 }, { 0x035D, 0x036F }, { 0x0483, 0x0486 },
[...]
>+    { 0xFB1E, 0xFB1E }, { 0xFE00, 0xFE0F }, { 0xFE20, 0xFE23 },
>+    { 0xFEFF, 0xFEFF }, { 0xFFF9, 0xFFFB }, { 0x1D167, 0x1D169 },
>+    { 0x1D173, 0x1D182 }, { 0x1D185, 0x1D18B }, { 0x1D1AA, 0x1D1AD },
>+    { 0xE0001, 0xE0001 }, { 0xE0020, 0xE007F }, { 0xE0100, 0xE01EF }
>+  };

Since Unicode above 0xFFFF is unsupported, could not these entries be killed?

>+static int is_double_width(long ucs)
>+{
>+  static const struct interval double_width[] = {
>+    { 0x1100, 0x115F }, { 0x2329, 0x232A }, { 0x2E80, 0x303E },
>+    { 0x3040, 0xA4CF }, { 0xAC00, 0xD7A3 }, { 0xF900, 0xFAFF },
>+    { 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
>+    { 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
>+  };

Similarly.

>@@ -1950,6 +2052,10 @@
> 	unsigned int currcons;
> 	unsigned long draw_from = 0, draw_to = 0;
> 	struct vc_data *vc;
>+	unsigned char vc_attr;
>+	int rescan;
unsigned int rescan:1;
>+	int inverse;
unsigned int inverse:1;
>+	int width;
unsigned int width; or even uint8_t.

> 	u16 himask, charmask;
> 	const unsigned char *orig_buf = NULL;
> 	int orig_count;

>@@ -2012,51 +2118,81 @@
> 		buf++;
> 		n++;
> 		count--;
>+		rescan = 0;
>+		inverse = 0;
>+		width = 1;
> 
> 		/* Do no translation at all in control states */
> 		if (vc->vc_state != ESnormal) {
> 			tc = c;
> 		} else if (vc->vc_utf && !vc->vc_disp_ctrl) {
>-		    /* Combine UTF-8 into Unicode */
>-		    /* Malformed sequences as sequences of replacement glyphs */
>+		    /* Combine UTF-8 into Unicode in vc_utf_char */
>+		    /* vc_utf_count is the number of continuation bytes still expected to arrive */
>+		    /* vc_npar is the number of continuation bytes arrived so far */
> rescan_last_byte:
>-		    if(c > 0x7f) {
>+		    if ((c & 0xc0) == 0x80) {
>+			/* Continuation byte received */
>+			static const int utf8_length_changes[] = { 0x0000007f, 0x000007ff, 0x0000ffff, 0x001fffff, 0x03ffffff, 0x7fffffff };

I would not mind unsigned.


Jan
-- 
