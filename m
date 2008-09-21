Return-Path: <linux-kernel-owner+w=401wt.eu-S1752768AbYIUQOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768AbYIUQOc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2008 12:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbYIUQOY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Sep 2008 12:14:24 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:42288 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbYIUQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2008 12:14:23 -0400
Message-ID: <48D672DE.3010509@skyrush.com>
Date: Sun, 21 Sep 2008 10:14:22 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] Fix backspace on wrapped lines in console (virtual terminal)
References: <48D5240D.7070701@skyrush.com> <20080920173822.51794923@lxorguk.ukuu.org.uk> <48D58C6B.9000403@skyrush.com>
In-Reply-To: <48D58C6B.9000403@skyrush.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000802060400000207000001"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000802060400000207000001
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Joe Peterson wrote:
> xterm has a "private mode 45", which turns on reverseWrap, allowing
> backspace to wrap.  This is similar to mode 7 (supported on xterm and
> vt), which is DEVAWM (auto wrap mode).
> 
> I agree that hard-coding backspace/reverse wrap would likely be wrong
> (even though it looks like some terminal emulators I've seen, like
> "screen" add the feature), but would it be appropriate to add mode 45 to
> vt, allowing reverse wrap as an option?

I have worked up a new patch (attached) for review.  It adds the private
mode 45 I mentioned above, but defaults it to off, preserving the old
default of no backspace wrap to the previous line.  This matches xterm's
reverse-wrap behavior (and default settings), so the same escape
sequence can be used to control this mode in both xterm and console/vt.

						-Joe

--------------000802060400000207000001
Content-Type: text/plain;
 name="vt-fix-wrapped-backspace.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vt-fix-wrapped-backspace.patch"

Fix backspace in the virtual terminal when line is wrapped:

1) Add option for backspace to work when wrapped to next line by adding
   a new private mode 45 to enable reverse wrap (default: off).
   This matches xterm's behavior, which already supports private
   mode 45.

2) Correct the backspace behavior when the most recently typed
   character is in the rightmost column (i.e. in need_wrap state).
   Use high bit of need_wrap (now 2 bits) allow this backspace logic
   to work even when autowrap is off.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/vt.c b/drivers/char/vt.c
--- a/drivers/char/vt.c	2008-09-21 09:27:43.186681676 -0600
+++ b/drivers/char/vt.c	2008-09-21 09:15:30.826683557 -0600
@@ -1130,12 +1130,36 @@ static inline void cr(struct vc_data *vc
 
 static inline void bs(struct vc_data *vc)
 {
-	if (vc->vc_x) {
-		vc->vc_pos -= 2;
-		vc->vc_x--;
+	if (vc->vc_need_wrap) {
+		/*
+		 * If in need_wrap state (regardless of autowrap mode),
+		 * do not move cursor, but unset need_wrap.
+		 */
 		vc->vc_need_wrap = 0;
-		notify_write(vc, '\b');
+	} else {
+		if (vc->vc_x == 0) {
+			/*
+			 * If at leftmost column, move cursor to end
+			 * of previous line (only if reverse wrap is on).
+			 */
+			if (vc->vc_reverse_wrap) {
+				vc->vc_x = vc->vc_cols - 1;
+				if (vc->vc_y == vc->vc_top) {
+					scrdown(vc,
+						vc->vc_top, vc->vc_bottom, 1);
+					vc->vc_pos += vc->vc_size_row - 2;
+				} else if (vc->vc_y > 0) {
+					vc->vc_y--;
+					vc->vc_pos -= 2;
+				}
+			}
+		} else {
+			/* Normal case: just move cursor back */
+			vc->vc_x--;
+			vc->vc_pos -= 2;
+		}
 	}
+	notify_write(vc, '\b');
 }
 
 static inline void del(struct vc_data *vc)
@@ -1437,6 +1461,9 @@ static void set_mode(struct vc_data *vc,
 			case 25:		/* Cursor on/off */
 				vc->vc_deccm = on_off;
 				break;
+			case 45:		/* Reverse wrap on/off */
+				vc->vc_reverse_wrap = on_off;
+				break;
 			case 1000:
 				vc->vc_report_mouse = on_off ? 2 : 0;
 				break;
@@ -1621,6 +1648,7 @@ static void reset_terminal(struct vc_dat
 	vc->vc_decscnm		= 0;
 	vc->vc_decom		= 0;
 	vc->vc_decawm		= 1;
+	vc->vc_reverse_wrap	= 0;
 	vc->vc_deccm		= 1;
 	vc->vc_decim		= 0;
 
@@ -2320,9 +2348,9 @@ rescan_last_byte:
 			}
 
 			while (1) {
-				if (vc->vc_need_wrap || vc->vc_decim)
+				if ((vc->vc_need_wrap & 1) || vc->vc_decim)
 					FLUSH
-				if (vc->vc_need_wrap) {
+				if (vc->vc_need_wrap & 1) {
 					cr(vc);
 					lf(vc);
 				}
@@ -2337,7 +2365,12 @@ rescan_last_byte:
 					draw_from = vc->vc_pos;
 				}
 				if (vc->vc_x == vc->vc_cols - 1) {
-					vc->vc_need_wrap = vc->vc_decawm;
+					/*
+					 * Set high bit of need_wrap regardless
+					 * of autowrap mode (backspace logic
+					 * relies on this).
+					 */
+					vc->vc_need_wrap = 2 | vc->vc_decawm;
 					draw_to = vc->vc_pos + 2;
 				} else {
 					vc->vc_x++;
@@ -2496,12 +2529,12 @@ static void vt_console_print(struct cons
 	 * Problems caused when we have need_wrap set on '\n' character */
 	while (count--) {
 		c = *b++;
-		if (c == 10 || c == 13 || c == 8 || vc->vc_need_wrap) {
+		if (c == 10 || c == 13 || c == 8 || (vc->vc_need_wrap & 1)) {
 			if (cnt > 0) {
 				if (CON_IS_VISIBLE(vc))
 					vc->vc_sw->con_putcs(vc, start, cnt, vc->vc_y, vc->vc_x);
 				vc->vc_x += cnt;
-				if (vc->vc_need_wrap)
+				if (vc->vc_need_wrap & 1)
 					vc->vc_x--;
 				cnt = 0;
 			}
diff -Nurp a/include/linux/console_struct.h b/include/linux/console_struct.h
--- a/include/linux/console_struct.h	2008-09-21 09:15:16.136681289 -0600
+++ b/include/linux/console_struct.h	2008-09-21 09:15:30.956686803 -0600
@@ -71,6 +71,7 @@ struct vc_data {
 	unsigned int	vc_decscnm	: 1;	/* Screen Mode */
 	unsigned int	vc_decom	: 1;	/* Origin Mode */
 	unsigned int	vc_decawm	: 1;	/* Autowrap Mode */
+	unsigned int	vc_reverse_wrap	: 1;	/* Reverse wrap Mode */
 	unsigned int	vc_deccm	: 1;	/* Cursor Visible */
 	unsigned int	vc_decim	: 1;	/* Insert Mode */
 	unsigned int	vc_deccolm	: 1;	/* 80/132 Column Mode */
@@ -87,7 +88,7 @@ struct vc_data {
 	unsigned int	vc_s_reverse	: 1;
 	/* misc */
 	unsigned int	vc_ques		: 1;
-	unsigned int	vc_need_wrap	: 1;
+	unsigned int	vc_need_wrap	: 2;
 	unsigned int	vc_can_do_color	: 1;
 	unsigned int	vc_report_mouse : 2;
 	unsigned int	vc_kmalloced	: 1;

--------------000802060400000207000001--
