Return-Path: <linux-kernel-owner+w=401wt.eu-S1754219AbYIWUkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219AbYIWUkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYIWUjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:39:53 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:46917 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbYIWUjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:39:53 -0400
Message-ID: <48D95414.7020505@skyrush.com>
Date: Tue, 23 Sep 2008 14:39:48 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hpa@zytor.com
Subject: Re: [PATCH] Fix backspace on wrapped lines in console (virtual terminal)
References: <48D5240D.7070701@skyrush.com> <20080920173822.51794923@lxorguk.ukuu.org.uk> <48D58C6B.9000403@skyrush.com> <48D672DE.3010509@skyrush.com>
In-Reply-To: <48D672DE.3010509@skyrush.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060009000907080105000707"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060009000907080105000707
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Joe Peterson wrote:
> I have worked up a new patch (attached) for review.

After discussing this with Thomas Dickey (maintainer of xterm), and
running vttest on both xterm and vt, I have generated an even newer
patch for review.  This replaces previous patches in this thread.

xterm only "fixes" the backspace behavior if both reverse wrap and
autowrap modes are enabled.  Although the "fix" is required for accurate
erasure of characters on wrapped lines (and therefore is really nice
when using Linux), the vttest results are not what it expects test 1
(cursor movement).  I do not have a VTxxx to test, but I assume vttest
is true to the hardware.

It makes sense, therefore, to retain the older behavior in vt unless
reverse wrap (which did not exist in the hardware) is enabled.  This
makes the patch true to vttest (and presumably the hardware) as well the
same as xterm in this respect.

							Thanks, Joe

P.S.  If anyone has a VTxxx, it would be interesting to know what
happens with autowrap mode on when backspace is hit after a character is
typed in the rightmost column.  If the cursor moves back, and the 2nd to
last character is then erased, this means the VTxxx behavior will match
the patched vt and xterm (when reverse wrap is not on - i.e. using
standard modes).


--------------060009000907080105000707
Content-Type: text/plain;
 name="vt-add-reverse-wrap-mode.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="vt-add-reverse-wrap-mode.patch"

head vt-add-reverse-wrap-mode.patch.old
Add option for backspace to work when wrapped to next line by adding
a new private mode 45 to enable reverse wrap (default: off).
This matches xterm's behavior, which already supports private
mode 45.  In addition, when this new mode is active, fix backspace
behavior when the most recently typed character is in the rightmost
column (i.e. in need_wrap state).  This enables correct erasure in
wrapped lines and also matches xterm behavior.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/vt.c b/drivers/char/vt.c
--- a/drivers/char/vt.c	2008-09-21 09:27:43.186681676 -0600
+++ b/drivers/char/vt.c	2008-09-23 13:52:44.000000000 -0600
@@ -1130,12 +1130,26 @@ static inline void cr(struct vc_data *vc
 
 static inline void bs(struct vc_data *vc)
 {
-	if (vc->vc_x) {
-		vc->vc_pos -= 2;
-		vc->vc_x--;
-		vc->vc_need_wrap = 0;
-		notify_write(vc, '\b');
+	if (!vc->vc_need_wrap || !vc->vc_reverse_wrap || !vc->vc_decawm) {
+		if (vc->vc_x == 0) {
+			if (vc->vc_reverse_wrap && vc->vc_decawm) {
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
+			vc->vc_x--;
+			vc->vc_pos -= 2;
+		}
 	}
+	vc->vc_need_wrap = 0;
+	notify_write(vc, '\b');
 }
 
 static inline void del(struct vc_data *vc)
@@ -1437,6 +1451,9 @@ static void set_mode(struct vc_data *vc,
 			case 25:		/* Cursor on/off */
 				vc->vc_deccm = on_off;
 				break;
+			case 45:		/* Reverse wrap on/off */
+				vc->vc_reverse_wrap = on_off;
+				break;
 			case 1000:
 				vc->vc_report_mouse = on_off ? 2 : 0;
 				break;
@@ -1621,6 +1638,7 @@ static void reset_terminal(struct vc_dat
 	vc->vc_decscnm		= 0;
 	vc->vc_decom		= 0;
 	vc->vc_decawm		= 1;
+	vc->vc_reverse_wrap	= 0;
 	vc->vc_deccm		= 1;
 	vc->vc_decim		= 0;
 
diff -Nurp a/include/linux/console_struct.h b/include/linux/console_struct.h
--- a/include/linux/console_struct.h	2008-09-21 09:15:16.136681289 -0600
+++ b/include/linux/console_struct.h	2008-09-23 10:23:56.000000000 -0600
@@ -71,6 +71,7 @@ struct vc_data {
 	unsigned int	vc_decscnm	: 1;	/* Screen Mode */
 	unsigned int	vc_decom	: 1;	/* Origin Mode */
 	unsigned int	vc_decawm	: 1;	/* Autowrap Mode */
+	unsigned int	vc_reverse_wrap	: 1;	/* Reverse wrap Mode */
 	unsigned int	vc_deccm	: 1;	/* Cursor Visible */
 	unsigned int	vc_decim	: 1;	/* Insert Mode */
 	unsigned int	vc_deccolm	: 1;	/* 80/132 Column Mode */

--------------060009000907080105000707--
