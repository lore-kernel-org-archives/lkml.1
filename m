Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXDLRoq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXDLRoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 13:44:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbXDLRoq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 13:44:46 -0400
Received: from ojjektum.uhulinux.hu ([62.112.194.64]:37612 "EHLO
	ojjektum.uhulinux.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXDLRop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 13:44:45 -0400
Date: Thu, 12 Apr 2007 19:44:43 +0200
From: Egmont Koblinger <egmont@uhulinux.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console UTF-8 fixes
Message-ID: <20070412174443.GA26002@uhulinux.hu>
References: <20070410183659.7341eeec@the-village.bc.nu> <20070411182801.GC26382@uhulinux.hu> <461D2AB8.5080902@zytor.com> <20070412091120.GA15666@uhulinux.hu> <461E5212.8070807@zytor.com> <Pine.LNX.4.61.0704121840350.14441@yvahk01.tjqt.qr> <20070412165540.GB21576@uhulinux.hu> <461E653E.6020400@zytor.com> <20070412171606.GA24756@uhulinux.hu> <461E6DDC.7050202@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <461E6DDC.7050202@zytor.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2007 at 10:35:24AM -0700, H. Peter Anvin wrote:

> Yes, I didn't realize at the time that that was dead code.

:-))))

Version 4 of the patch follows. Dead code omitted from version 3.


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
+++ linux-2.6.20/drivers/char/vt.c	2007-04-12 19:38:51.000000000 +0200
@@ -1934,6 +1934,46 @@
 char con_buf[CON_BUF_SIZE];
 DECLARE_MUTEX(con_buf_sem);
 
+/* is_double_width() is based on the wcwidth() implementation by
+ * Markus Kuhn -- 2003-05-20 (Unicode 4.0)
+ * Latest version: http://www.cl.cam.ac.uk/~mgk25/ucs/wcwidth.c
+ */
+struct interval {
+	uint32_t first;
+	uint32_t last;
+};
+
+static int bisearch(uint32_t ucs, const struct interval *table, int max)
+{
+	int min = 0;
+	int mid;
+
+	if (ucs < table[0].first || ucs > table[max].last)
+		return 0;
+	while (max >= min) {
+		mid = (min + max) / 2;
+		if (ucs > table[mid].last)
+			min = mid + 1;
+		else if (ucs < table[mid].first)
+			max = mid - 1;
+		else
+			return 1;
+	}
+	return 0;
+}
+
+static int is_double_width(uint32_t ucs)
+{
+	static const struct interval double_width[] = {
+		{ 0x1100, 0x115F }, { 0x2329, 0x232A }, { 0x2E80, 0x303E },
+		{ 0x3040, 0xA4CF }, { 0xAC00, 0xD7A3 }, { 0xF900, 0xFAFF },
+		{ 0xFE30, 0xFE6F }, { 0xFF00, 0xFF60 }, { 0xFFE0, 0xFFE6 },
+		{ 0x20000, 0x2FFFD }, { 0x30000, 0x3FFFD }
+	};
+	return bisearch(ucs, double_width,
+		sizeof(double_width) / sizeof(*double_width) - 1);
+}
+
 /* acquires console_sem */
 static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
@@ -1950,6 +1990,10 @@
 	unsigned int currcons;
 	unsigned long draw_from = 0, draw_to = 0;
 	struct vc_data *vc;
+	unsigned char vc_attr;
+	uint8_t rescan;
+	uint8_t inverse;
+	uint8_t width;
 	u16 himask, charmask;
 	const unsigned char *orig_buf = NULL;
 	int orig_count;
@@ -2012,51 +2056,81 @@
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
+			static const uint32_t utf8_length_changes[] = { 0x0000007f, 0x000007ff, 0x0000ffff, 0x001fffff, 0x03ffffff, 0x7fffffff };
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
@@ -2078,56 +2152,81 @@
 			&& (c != 128+27);
 
 		if (vc->vc_state == ESnormal && ok) {
+			if (vc->vc_utf && !vc->vc_disp_ctrl) {
+				if (is_double_width(c)) {
+					width = 2;
+				}
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
