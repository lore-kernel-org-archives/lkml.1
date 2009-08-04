Return-Path: <linux-kernel-owner+w=401wt.eu-S932556AbZHDUih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932556AbZHDUih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 16:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932497AbZHDUig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 16:38:36 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:42134 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbZHDUie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 16:38:34 -0400
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Aug 2009 16:38:34 EDT
Message-ID: <4A789AA1.5070907@skyrush.com>
Date: Tue, 04 Aug 2009 14:31:29 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090616)
MIME-Version: 1.0
To: gregkh@suse.de, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] n_tty: honor opost flag for echoes
Content-Type: multipart/mixed;
 boundary="------------070008040202000607010804"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070008040202000607010804
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------070008040202000607010804
Content-Type: text/plain;
 name="n_tty-honor-opost-flag-for-echoes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n_tty-honor-opost-flag-for-echoes.patch"

Fixes the following bug:

      http://bugs.linuxbase.org/show_bug.cgi?id=2692

Causes processing of echoed characters (output from the echo buffer) to
honor the O_OPOST flag.  This re-establishes this behavior.

Note that this and the next patch ("n_tty: move echoctl check and
clean up logic") were verified together by the bug reporters, and
all tty tests now pass.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2009-08-04 12:37:02.085287117 -0600
+++ b/drivers/char/n_tty.c	2009-08-04 12:37:14.515286140 -0600
@@ -292,54 +292,56 @@ static int do_output_char(unsigned char 
 	if (!space)
 		return -1;
 
-	switch (c) {
-	case '\n':
-		if (O_ONLRET(tty))
-			tty->column = 0;
-		if (O_ONLCR(tty)) {
-			if (space < 2)
-				return -1;
-			tty->canon_column = tty->column = 0;
-			tty_put_char(tty, '\r');
-			tty_put_char(tty, c);
-			return 2;
-		}
-		tty->canon_column = tty->column;
-		break;
-	case '\r':
-		if (O_ONOCR(tty) && tty->column == 0)
-			return 0;
-		if (O_OCRNL(tty)) {
-			c = '\n';
+	if (O_OPOST(tty)) {
+		switch (c) {
+		case '\n':
 			if (O_ONLRET(tty))
+				tty->column = 0;
+			if (O_ONLCR(tty)) {
+				if (space < 2)
+					return -1;
 				tty->canon_column = tty->column = 0;
+				tty_put_char(tty, '\r');
+				tty_put_char(tty, c);
+				return 2;
+			}
+			tty->canon_column = tty->column;
 			break;
-		}
-		tty->canon_column = tty->column = 0;
-		break;
-	case '\t':
-		spaces = 8 - (tty->column & 7);
-		if (O_TABDLY(tty) == XTABS) {
-			if (space < spaces)
-				return -1;
+		case '\r':
+			if (O_ONOCR(tty) && tty->column == 0)
+				return 0;
+			if (O_OCRNL(tty)) {
+				c = '\n';
+				if (O_ONLRET(tty))
+					tty->canon_column = tty->column = 0;
+				break;
+			}
+			tty->canon_column = tty->column = 0;
+			break;
+		case '\t':
+			spaces = 8 - (tty->column & 7);
+			if (O_TABDLY(tty) == XTABS) {
+				if (space < spaces)
+					return -1;
+				tty->column += spaces;
+				tty->ops->write(tty, "        ", spaces);
+				return spaces;
+			}
 			tty->column += spaces;
-			tty->ops->write(tty, "        ", spaces);
-			return spaces;
-		}
-		tty->column += spaces;
-		break;
-	case '\b':
-		if (tty->column > 0)
-			tty->column--;
-		break;
-	default:
-		if (!iscntrl(c)) {
-			if (O_OLCUC(tty))
-				c = toupper(c);
-			if (!is_continuation(c, tty))
-				tty->column++;
+			break;
+		case '\b':
+			if (tty->column > 0)
+				tty->column--;
+			break;
+		default:
+			if (!iscntrl(c)) {
+				if (O_OLCUC(tty))
+					c = toupper(c);
+				if (!is_continuation(c, tty))
+					tty->column++;
+			}
+			break;
 		}
-		break;
 	}
 
 	tty_put_char(tty, c);
@@ -351,8 +353,9 @@ static int do_output_char(unsigned char 
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
  *
- *	Perform OPOST processing.  Returns -1 when the output device is
- *	full and the character must be retried.
+ *	Output a character (with OPOST processing if enabled).
+ *	Returns -1 if the output device is full and the character
+ *	must be retried.
  *
  *	Locking: output_lock to protect column state and space left
  *		 (also, this is called from n_tty_write under the
@@ -378,8 +381,11 @@ static int process_output(unsigned char 
 /**
  *	process_output_block		-	block post processor
  *	@tty: terminal device
- *	@inbuf: user buffer
- *	@nr: number of bytes
+ *	@buf: character buffer
+ *	@nr: number of bytes to output
+ *
+ *	Output a block of characters (with OPOST processing - assumed enabled).
+ *	Returns the number of characters output.
  *
  *	This path is used to speed up block console writes, among other
  *	things when processing blocks of output data. It handles only

--------------070008040202000607010804--
