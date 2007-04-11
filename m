Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbXDKS2H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbXDKS2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 14:28:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXDKS2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 14:28:06 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:47806 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753544AbXDKS2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 14:28:05 -0400
Date: Wed, 11 Apr 2007 20:28:01 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070411182801.GC26382@uhulinux.hu>
References: <20070406191245.GA11974@uhulinux.hu> <4616A2C7.3030000@zytor.com> <20070407092451.GA8779@uhulinux.hu> <Pine.LNX.4.61.0704071232560.22181@yvahk01.tjqt.qr> <20070407172603.GA25351@uhulinux.hu> <4617DBF7.5060009@zytor.com> <20070410094325.GB9143@uhulinux.hu> <461BB092.3070201@zytor.com> <20070410171924.GA18314@uhulinux.hu> <20070410183659.7341eeec@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070410183659.7341eeec@the-village.bc.nu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I send a reworked version of the patch.

Removed from the first version:
  - any sign of '.' as substitute glyph
  - don't ignore zero-width characters (except for a few zero-width spaces
    that are ignored in the current kernel too). However, I kept the code
    organized and commented so that someone can have the other behavior very
    easily (by removing a pair of comment signs).

Kept features, fixes:
  - lots of UTF-8 decoder fixes. Emit one U+FFFD for every standalone
    continuation byte and for every incomplete sequence, as Markus Kuhn
    recommends. Reject overlong sequences too.
  - D800..DFFF and FFFE..FFFF are substituted by FFFD too, since these are
    not valid Unicode code points.
  - no "random" replacement glyph (e.g. u with double acute instead of
    u with circumflex) in UTF-8 mode
  - if U+FFFD is not found in the font, the fallback replacement '?' (ascii
    question mark) is printed with inverse color attributes
  - U+200A was ignored so far as a zero-width space character. I think it
    was a mistake, it's not zero-width.
  - print an extra space for double-wide characters for the cursor to stand
    at the right place. Yet again the code is organized so that it is very
    easy to change to jump only one character cell, should someone prefer
    that behavior (which I still see no good reason to).

Signed-off-by: Egmont Koblinger <egmont@uhulinux.hu>

diff -Naur linux-2.6.20.orig/drivers/char/consolemap.c linux-2.6.20/drivers/char/consolemap.c
--- linux-2.6.20.orig/drivers/char/consolemap.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/drivers/char/consolemap.c	2007-04-11 18:45:45.000000000 +0200
@@ -626,10 +626,10 @@
   
 	/* Only 16-bit codes supported at this time */
 	if (ucs > 0xffff)
-		ucs = 0xfffd;		/* U+FFFD: REPLACEMENT CHARACTER */
-	else if (ucs < 0x20 || ucs >= 0xfffe)
+		return -4;		/* Not found */
+	else if (ucs < 0x20)
 		return -1;		/* Not a printable character */
-	else if (ucs == 0xfeff || (ucs >= 0x200a && ucs <= 0x200f))
+	else if (ucs == 0xfeff || (ucs >= 0x200b && ucs <= 0x200f))
 		return -2;			/* Zero-width space */
 	/*
 	 * UNI_DIRECT_BASE indicates the start of the region in the User Zone
diff -Naur linux-2.6.20.orig/drivers/char/vt.c linux-2.6.20/drivers/char/vt.c
--- linux-2.6.20.orig/drivers/char/vt.c	2007-02-04 19:44:54.000000000 +0100
+++ linux-2.6.20/drivers/char/vt.c	2007-04-11 19:29:19.000000000 +0200
@@ -70,6 +70,15 @@
  * malformed UTF sequences represented as sequences of replacement glyphs,
  * original codes or '?' as a last resort if replacement glyph is undefined
  * by Adam Tla/lka <atlka@pg.gda.pl>, Aug 2006
+ *
+ * More robust UTF-8 decoder. Make it work on malformed sequences as Markus Kuhn's
+ * UTF-8 decoder stress test suggests. Emit a U+FFFD on illegal sequences (including
+ * overlong representations) as well as for invalid Unicode code points.
+ * If U+FFFD is not available in the font, print an inverse question mark instead.
+ * Pad double-width characters with an extra space so that the cursor moves by two
+ * positions in these cases.
+ * 11 April 2007, Egmont Koblinger <egmont@uhulinux.hu>,
+ * using code from Markus Kuhn's wcwidth() implementation.
  */
 
 #include <linux/module.h>
@@ -1934,6 +1943,99 @@
 char con_buf[CON_BUF_SIZE];
 DECLARE_MUTEX(con_buf_sem);
 
+/* is_{zero,double}_width() are based on the wcwidth() implementation by
+ * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
+ * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
+ */
+struct interval {
+  int first;
+  int last;
+};
+
+static int bisearch(long ucs, const struct interval *table, int max) {
+  int min = 0;
+  int mid;
+
+  if (ucs < table[0].first || ucs > table[max].last)
+    return 0;
+  while (max >= min) {
+    mid = (min + max) / 2;
+    if (ucs > table[mid].last)
+      min = mid + 1;
+    else if (ucs < table[mid].first)
+      max = mid - 1;
+    else
+      return 1;
+  }
+
+  return 0;
+}
+
+static int is_zero_width(long ucs)
+{
+  static const struct interval zero_width[] = {
+    { 0x0300, 0x0357 }, { 0x035D, 0x036F }, { 0x0483, 0x0486 },
+    { 0x0488, 0x0489 }, { 0x0591, 0x05A1 }, { 0x05A3, 0x05B9 },
+    { 0x05BB, 0x05BD }, { 0x05BF, 0x05BF }, { 0x05C1, 0x05C2 },
+    { 0x05C4, 0x05C4 }, { 0x0600, 0x0603 }, { 0x0610, 0x0615 },
+    { 0x064B, 0x0658 }, { 0x0670, 0x0670 }, { 0x06D6, 0x06E4 },
+    { 0x06E7, 0x06E8 }, { 0x06EA, 0x06ED }, { 0x070F, 0x070F },
+    { 0x0711, 0x0711 }, { 0x0730, 0x074A }, { 0x07A6, 0x07B0 },
+    { 0x0901, 0x0902 }, { 0x093C, 0x093C }, { 0x0941, 0x0948 },
+    { 0x094D, 0x094D }, { 0x0951, 0x0954 }, { 0x0962, 0x0963 },
+    { 0x0981, 0x0981 }, { 0x09BC, 0x09BC }, { 0x09C1, 0x09C4 },
+    { 0x09CD, 0x09CD }, { 0x09E2, 0x09E3 }, { 0x0A01, 0x0A02 },
+    { 0x0A3C, 0x0A3C }, { 0x0A41, 0x0A42 }, { 0x0A47, 0x0A48 },
+    { 0x0A4B, 0x0A4D }, { 0x0A70, 0x0A71 }, { 0x0A81, 0x0A82 },
+    { 0x0ABC, 0x0ABC }, { 0x0AC1, 0x0AC5 }, { 0x0AC7, 0x0AC8 },
+    { 0x0ACD, 0x0ACD }, { 0x0AE2, 0x0AE3 }, { 0x0B01, 0x0B01 },
+    { 0x0B3C, 0x0B3C }, { 0x0B3F, 0x0B3F }, { 0x0B41, 0x0B43 },
+    { 0x0B4D, 0x0B4D }, { 0x0B56, 0x0B56 }, { 0x0B82, 0x0B82 },
+    { 0x0BC0, 0x0BC0 }, { 0x0BCD, 0x0BCD }, { 0x0C3E, 0x0C40 },
+    { 0x0C46, 0x0C48 }, { 0x0C4A, 0x0C4D }, { 0x0C55, 0x0C56 },
+    { 0x0CBC, 0x0CBC }, { 0x0CBF, 0x0CBF }, { 0x0CC6, 0x0CC6 },
+    { 0x0CCC, 0x0CCD }, { 0x0D41, 0x0D43 }, { 0x0D4D, 0x0D4D },
+    { 0x0DCA, 0x0DCA }, { 0x0DD2, 0x0DD4 }, { 0x0DD6, 0x0DD6 },
+    { 0x0E31, 0x0E31 }, { 0x0E34, 0x0E3A }, { 0x0E47, 0x0E4E },
+    { 0x0EB1, 0x0EB1 }, { 0x0EB4, 0x0EB9 }, { 0x0EBB, 0x0EBC },
+    { 0x0EC8, 0x0ECD }, { 0x0F18, 0x0F19 }, { 0x0F35, 0x0F35 },
+    { 0x0F37, 0x0F37 }, { 0x0F39, 0x0F39 }, { 0x0F71, 0x0F7E },
+    { 0x0F80, 0x0F84 }, { 0x0F86, 0x0F87 }, { 0x0F90, 0x0F97 },
+    { 0x0F99, 0x0FBC }, { 0x0FC6, 0x0FC6 }, { 0x102D, 0x1030 },
+    { 0x1032, 0x1032 }, { 0x1036, 0x1037 }, { 0x1039, 0x1039 },
+    { 0x1058, 0x1059 }, { 0x1160, 0x11FF }, { 0x1712, 0x1714 },
+    { 0x1732, 0x1734 }, { 0x1752, 0x1753 }, { 0x1772, 0x1773 },
+    { 0x17B4, 0x17B5 }, { 0x17B7, 0x17BD }, { 0x17C6, 0x17C6 },
+    { 0x17C9, 0x17D3 }, { 0x17DD, 0x17DD }, { 0x180B, 0x180D },
+    { 0x18A9, 0x18A9 }, { 0x1920, 0x1922 }, { 0x1927, 0x1928 },
+    { 0x1932, 0x1932 }, { 0x1939, 0x193B }, { 0x200B, 0x200F },
+    { 0x202A, 0x202E }, { 0x2060, 0x2063 }, { 0x206A, 0x206F },
+    { 0x20D0, 0x20EA }, { 0x302A, 0x302F }, { 0x3099, 0x309A },
+    { 0xFB1E, 0xFB1E }, { 0xFE00, 0xFE0F }, { 0xFE20, 0xFE23 },
+    { 0xFEFF, 0xFEFF }, { 0xFFF9, 0xFFFB }, { 0x1D167, 0x1D169 },
+    { 0x1D173, 0x1D182 }, { 0x1D185, 0x1D18B }, { 0x1D1AA, 0x1D1AD },
+    { 0xE0001, 0xE0001 }, { 0xE0020, 0xE007F }, { 0xE0100, 0xE01EF }
+  };
+  if (ucs < zero_width[0].first)
+    return 0;
+  return bisearch(ucs, zero_width,
+                  sizeof(zero_width) / sizeof(struct interval) - 1);
+}
+
+static int is_double_width(long ucs)
+{
+  static const struct interval double_width[] = {
+    { 0x1100, 0x115F }, { 0x2329, 0x232A }, { 0x2E80, 0x303E },
+    { 0x3040, 0xA4CF }, { 0xAC00, 0xD7A3 }, { 0xF900, 0xFAFF },
+    { 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
+    { 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
+  };
+  if (ucs < double_width[0].first)
+    return 0;
+  return bisearch(ucs, double_width,
+                  sizeof(double_width) / sizeof(struct interval) - 1);
+}
+
 /* acquires console_sem */
 static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
@@ -1950,6 +2052,10 @@
 	unsigned int currcons;
 	unsigned long draw_from = 0, draw_to = 0;
 	struct vc_data *vc;
+	unsigned char vc_attr;
+	int rescan;
+	int inverse;
+	int width;
 	u16 himask, charmask;
 	const unsigned char *orig_buf = NULL;
 	int orig_count;
@@ -2012,51 +2118,81 @@
 		buf++;
 		n++;
 		count--;
+		rescan = 0;
+		inverse = 0;
+		width = 1;
 
 		/* Do no translation at all in control states */
 		if (vc->vc_state != ESnormal) {
 			tc = c;
 		} else if (vc->vc_utf && !vc->vc_disp_ctrl) {
-		    /* Combine UTF-8 into Unicode */
-		    /* Malformed sequences as sequences of replacement glyphs */
+		    /* Combine UTF-8 into Unicode in vc_utf_char */
+		    /* vc_utf_count is the number of continuation bytes still expected to arrive */
+		    /* vc_npar is the number of continuation bytes arrived so far */
 rescan_last_byte:
-		    if(c > 0x7f) {
+		    if ((c & 0xc0) == 0x80) {
+			/* Continuation byte received */
+			static const int utf8_length_changes[] = { 0x0000007f, 0x000007ff, 0x0000ffff, 0x001fffff, 0x03ffffff, 0x7fffffff };
 			if (vc->vc_utf_count) {
-			       if ((c & 0xc0) == 0x80) {
-				       vc->vc_utf_char = (vc->vc_utf_char << 6) | (c & 0x3f);
-       				       if (--vc->vc_utf_count) {
-					       vc->vc_npar++;
-				   	       continue;
-       				       }
-				       tc = c = vc->vc_utf_char;
-			       } else
-				       goto replacement_glyph;
-			} else {
-				vc->vc_npar = 0;
-				if ((c & 0xe0) == 0xc0) {
-				    vc->vc_utf_count = 1;
-				    vc->vc_utf_char = (c & 0x1f);
-				} else if ((c & 0xf0) == 0xe0) {
-				    vc->vc_utf_count = 2;
-				    vc->vc_utf_char = (c & 0x0f);
-				} else if ((c & 0xf8) == 0xf0) {
-				    vc->vc_utf_count = 3;
-				    vc->vc_utf_char = (c & 0x07);
-				} else if ((c & 0xfc) == 0xf8) {
-				    vc->vc_utf_count = 4;
-				    vc->vc_utf_char = (c & 0x03);
-				} else if ((c & 0xfe) == 0xfc) {
-				    vc->vc_utf_count = 5;
-				    vc->vc_utf_char = (c & 0x01);
-				} else
-	    			    goto replacement_glyph;
+			    vc->vc_utf_char = (vc->vc_utf_char << 6) | (c & 0x3f);
+			    vc->vc_npar++;
+			    if (--vc->vc_utf_count) {
+				/* Still need some bytes */
 				continue;
-			      }
+			    }
+			    /* Got a whole character */
+			    c = vc->vc_utf_char;
+			    /* Reject overlong sequences */
+			    if (c <= utf8_length_changes[vc->vc_npar - 1] || c > utf8_length_changes[vc->vc_npar]) {
+				c = 0xfffd;
+			    }
+			} else {
+			    /* Unexpected continuation byte */
+			    vc->vc_utf_count = 0;
+			    c = 0xfffd;
+			}
 		    } else {
-		      if (vc->vc_utf_count)
-	  		      goto replacement_glyph;
-		      tc = c;
+			/* Single ASCII byte or first byte of a sequence received */
+			if (vc->vc_utf_count) {
+			    /* Continuation byte expected */
+			    rescan = 1;
+			    vc->vc_utf_count = 0;
+			    c = 0xfffd;
+			} else if (c > 0x7f) {
+			    /* First byte of a multibyte sequence received */
+			    vc->vc_npar = 0;
+			    if ((c & 0xe0) == 0xc0) {
+				vc->vc_utf_count = 1;
+				vc->vc_utf_char = (c & 0x1f);
+			    } else if ((c & 0xf0) == 0xe0) {
+				vc->vc_utf_count = 2;
+				vc->vc_utf_char = (c & 0x0f);
+			    } else if ((c & 0xf8) == 0xf0) {
+				vc->vc_utf_count = 3;
+				vc->vc_utf_char = (c & 0x07);
+			    } else if ((c & 0xfc) == 0xf8) {
+				vc->vc_utf_count = 4;
+				vc->vc_utf_char = (c & 0x03);
+			    } else if ((c & 0xfe) == 0xfc) {
+				vc->vc_utf_count = 5;
+				vc->vc_utf_char = (c & 0x01);
+			    } else {
+				/* 254 and 255 are invalid */
+				c = 0xfffd;
+			    }
+			    if (vc->vc_utf_count) {
+				/* Still need some bytes */
+				continue;
+			    }
+			}
+			/* Nothing to do if an ASCII byte was received */
 		    }
+		    /* End of UTF-8 decoding. */
+		    /* c is the received character, or U+FFFD for invalid sequences. */
+		    /* Replace invalid Unicode code points with U+FFFD too */
+		    if ((c >= 0xd800 && c <= 0xdfff) || c == 0xfffe || c == 0xffff)
+			c = 0xfffd;
+		    tc = c;
 		} else {	/* no utf or alternate charset mode */
 		  tc = vc->vc_translate[vc->vc_toggle_meta ? (c | 0x80) : c];
 		}
@@ -2078,56 +2214,88 @@
 			&& (c != 128+27);
 
 		if (vc->vc_state == ESnormal && ok) {
+			if (vc->vc_utf && !vc->vc_disp_ctrl) {
+				if (is_double_width(c)) {
+					width = 2;
+				}
+				/* Uncomment this if you'd prefer zero-width characters to be silently dropped
+				   instead of printing the replacement glyph */
+				/*
+				else if (is_zero_width(c)) {
+					continue;
+				}
+				*/
+			}
 			/* Now try to find out how to display it */
 			tc = conv_uni_to_pc(vc, tc);
 			if (tc & ~charmask) {
-				if ( tc == -4 ) {
-                                /* If we got -4 (not found) then see if we have
-                                   defined a replacement character (U+FFFD) */
-replacement_glyph:
-                                	tc = conv_uni_to_pc(vc, 0xfffd);
-					if (!(tc & ~charmask))
-						goto display_glyph;
-                        	} else if ( tc != -3 )
-                                	continue; /* nothing to display */
-                                /* no hash table or no replacement --
-				 * hope for the best */
-				if ( c & ~charmask )
-					tc = '?';
-				else
-					tc = c;
+				if (tc == -1 || tc == -2) {
+				    continue; /* nothing to display */
+				}
+				/* Glyph not found */
+				if (!(vc->vc_utf && !vc->vc_disp_ctrl) && !(c & ~charmask)) {
+				    /* In legacy mode use the glyph we get by a 1:1 mapping.
+				       This would make absolutely no sense with Unicode in mind. */
+				    tc = c;
+				} else {
+				    /* Display U+FFFD. If it's not found, display an inverse question mark. */
+				    tc = conv_uni_to_pc(vc, 0xfffd);
+				    if (tc < 0) {
+					inverse = 1;
+					tc = conv_uni_to_pc(vc, '?');
+					if (tc < 0) tc = '?';
+				    }
+				}
 			}
 
-display_glyph:
-			if (vc->vc_need_wrap || vc->vc_decim)
-				FLUSH
-			if (vc->vc_need_wrap) {
-				cr(vc);
-				lf(vc);
-			}
-			if (vc->vc_decim)
-				insert_char(vc, 1);
-			scr_writew(himask ?
-				     ((vc->vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) + (tc & 0xff) :
-				     (vc->vc_attr << 8) + tc,
-				   (u16 *) vc->vc_pos);
-			if (DO_UPDATE(vc) && draw_x < 0) {
-				draw_x = vc->vc_x;
-				draw_from = vc->vc_pos;
-			}
-			if (vc->vc_x == vc->vc_cols - 1) {
-				vc->vc_need_wrap = vc->vc_decawm;
-				draw_to = vc->vc_pos + 2;
+			if (!inverse) {
+				vc_attr = vc->vc_attr;
 			} else {
-				vc->vc_x++;
-				draw_to = (vc->vc_pos += 2);
+				/* invert vc_attr */
+				if (!vc->vc_can_do_color) {
+					vc_attr = (vc->vc_attr) ^ 0x08;
+				} else if (vc->vc_hi_font_mask == 0x100) {
+					vc_attr = ((vc->vc_attr) & 0x11) | (((vc->vc_attr) & 0xe0) >> 4) | (((vc->vc_attr) & 0x0e) << 4);
+				} else {
+					vc_attr = ((vc->vc_attr) & 0x88) | (((vc->vc_attr) & 0x70) >> 4) | (((vc->vc_attr) & 0x07) << 4);
+				}
 			}
-			if (vc->vc_utf_count) {
-				if (vc->vc_npar) {
-					vc->vc_npar--;
-					goto display_glyph;
+
+			while (1) {
+				if (vc->vc_need_wrap || vc->vc_decim)
+					FLUSH
+				if (vc->vc_need_wrap) {
+					cr(vc);
+					lf(vc);
+				}
+				if (vc->vc_decim)
+					insert_char(vc, 1);
+				scr_writew(himask ?
+					     ((vc_attr << 8) & ~himask) + ((tc & 0x100) ? himask : 0) + (tc & 0xff) :
+					     (vc_attr << 8) + tc,
+					   (u16 *) vc->vc_pos);
+				if (DO_UPDATE(vc) && draw_x < 0) {
+					draw_x = vc->vc_x;
+					draw_from = vc->vc_pos;
+				}
+				if (vc->vc_x == vc->vc_cols - 1) {
+					vc->vc_need_wrap = vc->vc_decawm;
+					draw_to = vc->vc_pos + 2;
+				} else {
+					vc->vc_x++;
+					draw_to = (vc->vc_pos += 2);
 				}
-				vc->vc_utf_count = 0;
+
+				if (!--width) break;
+
+				tc = conv_uni_to_pc(vc, ' '); /* A space is printed in the second column */
+				if (tc < 0) tc = ' ';
+			}
+
+			if (rescan) {
+				rescan = 0;
+				inverse = 0;
+				width = 1;
 				c = orig;
 				goto rescan_last_byte;
 			}
