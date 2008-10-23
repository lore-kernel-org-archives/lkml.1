Return-Path: <linux-kernel-owner+w=401wt.eu-S1756776AbYJWBf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756776AbYJWBf1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753613AbYJWBfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:35:18 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35556 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752181AbYJWBfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:35:17 -0400
Message-ID: <48FFD4D4.3020704@skyrush.com>
Date: Wed, 22 Oct 2008 19:35:16 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] n-tty-fix-buffer-full-checks
References: <48F2E450.1070508@skyrush.com> <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------090009080500050708020609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090009080500050708020609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit


--------------090009080500050708020609
Content-Type: text/plain;
 name="n-tty-fix-buffer-full-checks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n-tty-fix-buffer-full-checks.patch"

Fix the handling of input characters when the tty buffer is full or nearly
full.  This includes tests that are done in n_tty_receive_char() and handling
of PARMRK.

Problems with the buffer-full tests done in receive_char() caused characters to
be lost at times when the buffer(s) filled.  Also, these full conditions
would often only be detected with echo on, and PARMRK was not accounted for
properly in all cases.  One symptom of these problems, in addition to lost
characters, was early termination from unix commands like tr and cat when
^Q was used to break from a stopped tty with full buffers (note that breaking
out was often previously not possible, due to the pty getting in "gridlock",
which will be addressed in another patch).  Note space is always reserved
at the end of the buffer for a newline (or EOF/EOL) in canonical mode.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2008-10-22 18:12:33.963339566 -0600
+++ b/drivers/char/n_tty.c	2008-10-22 18:14:38.083337970 -0600
@@ -1107,6 +1107,7 @@ static inline void n_tty_receive_parity_
 static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 {
 	unsigned long flags;
+	int parmrk;
 
 	if (tty->raw) {
 		put_tty_queue(c, tty);
@@ -1144,21 +1145,24 @@ static inline void n_tty_receive_char(st
 	 */
 	if (!test_bit(c, tty->process_char_map) || tty->lnext) {
 		tty->lnext = 0;
-		if (L_ECHO(tty)) {
-			finish_erasing(tty);
-			if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-				/* beep if no space */
+		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
+		if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
+			/* beep if no space */
+			if (L_ECHO(tty)) {
 				echo_char_raw('\a', tty);
 				process_echoes(tty);
-				return;
 			}
+			return;
+		}
+		if (L_ECHO(tty)) {
+			finish_erasing(tty);
 			/* Record the column of first canon char. */
 			if (tty->canon_head == tty->read_head)
 				echo_set_canon_col(tty);
 			echo_char(c, tty);
 			process_echoes(tty);
 		}
-		if (I_PARMRK(tty) && c == (unsigned char) '\377')
+		if (parmrk)
 			put_tty_queue(c, tty);
 		put_tty_queue(c, tty);
 		return;
@@ -1250,15 +1254,22 @@ send_signal:
 			return;
 		}
 		if (c == '\n') {
-			if (L_ECHO(tty) || L_ECHONL(tty)) {
-				if (tty->read_cnt >= N_TTY_BUF_SIZE-1)
+			if (tty->read_cnt >= N_TTY_BUF_SIZE) {
+				if (L_ECHO(tty)) {
 					echo_char_raw('\a', tty);
+					process_echoes(tty);
+				}
+				return;
+			}
+			if (L_ECHO(tty) || L_ECHONL(tty)) {
 				echo_char_raw('\n', tty);
 				process_echoes(tty);
 			}
 			goto handle_newline;
 		}
 		if (c == EOF_CHAR(tty)) {
+			if (tty->read_cnt >= N_TTY_BUF_SIZE)
+				return;
 			if (tty->canon_head != tty->read_head)
 				set_bit(TTY_PUSH, &tty->flags);
 			c = __DISABLED_CHAR;
@@ -1266,12 +1277,19 @@ send_signal:
 		}
 		if ((c == EOL_CHAR(tty)) ||
 		    (c == EOL2_CHAR(tty) && L_IEXTEN(tty))) {
+			parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty))
+				 ? 1 : 0;
+			if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk)) {
+				if (L_ECHO(tty)) {
+					echo_char_raw('\a', tty);
+					process_echoes(tty);
+				}
+				return;
+			}
 			/*
 			 * XXX are EOL_CHAR and EOL2_CHAR echoed?!?
 			 */
 			if (L_ECHO(tty)) {
-				if (tty->read_cnt >= N_TTY_BUF_SIZE-1)
-					echo_char_raw('\a', tty);
 				/* Record the column of first canon char. */
 				if (tty->canon_head == tty->read_head)
 					echo_set_canon_col(tty);
@@ -1282,7 +1300,7 @@ send_signal:
 			 * XXX does PARMRK doubling happen for
 			 * EOL_CHAR and EOL2_CHAR?
 			 */
-			if (I_PARMRK(tty) && c == (unsigned char) '\377')
+			if (parmrk)
 				put_tty_queue(c, tty);
 
 handle_newline:
@@ -1299,14 +1317,17 @@ handle_newline:
 		}
 	}
 
-	if (L_ECHO(tty)) {
-		finish_erasing(tty);
-		if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-			/* beep if no space */
+	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
+	if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
+		/* beep if no space */
+		if (L_ECHO(tty)) {
 			echo_char_raw('\a', tty);
 			process_echoes(tty);
-			return;
 		}
+		return;
+	}
+	if (L_ECHO(tty)) {
+		finish_erasing(tty);
 		if (c == '\n')
 			echo_char_raw('\n', tty);
 		else {
@@ -1318,7 +1339,7 @@ handle_newline:
 		process_echoes(tty);
 	}
 
-	if (I_PARMRK(tty) && c == (unsigned char) '\377')
+	if (parmrk)
 		put_tty_queue(c, tty);
 
 	put_tty_queue(c, tty);

--------------090009080500050708020609--
