Return-Path: <linux-kernel-owner+w=401wt.eu-S1755392AbYJMGCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392AbYJMGCK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 02:02:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYJMGB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 02:01:57 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:51282 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbYJMGB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 02:01:56 -0400
Message-ID: <48F2E450.1070508@skyrush.com>
Date: Mon, 13 Oct 2008 00:01:52 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix n_tty/pty input/output buffer full and other misc char
 handling
Content-Type: multipart/mixed;
 boundary="------------010008090401020706060805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010008090401020706060805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Alan,

As promised, here is a patch to apply after the latest combined echo
buffer patch I recently sent.  It fixes a few things, but most
importantly the handling of buffer full tests and cases in which filled
buffers in a stopped tty can create a "gridlock" condition in two cases
(read patch text for more details).  Note that the condition can easily
be seen by pasting lots of text into, e.g., "tr 'f' 'F'" after ^S is hit.

One question I have is this: should we also let characters through (so
that ^C, ^Q, etc. can have effect) in non-canonical mode?  This would
allow prevention of the gridlocks that still can be invoked when using
stty -icanon in, say, an xterm.  For now, I took the conservative route
in this patch, but let me know if a more permissive approach is better.

						Thanks, Joe

--------------010008090401020706060805
Content-Type: text/plain;
 name="tty-fix-buffer-full-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tty-fix-buffer-full-handling.patch"

Fix the handling of input characters when the tty buffer is full or nearly
full.  This includes tests that are done in n_tty_receive_char(), setting
of receive_room in n_tty_set_room(), handling of PARMRK, and the logic for
the returned value from pty_chars_in_buffer() in specific cases.  Also fix
process_output_block to detect continuation characters correctly and to handle
control characters even when O_OLCUC is enabled.

Problems with the buffer-full tests done in receive_char() caused characters to
be lost at times when the buffer(s) filled.  Also, these full conditions
would often only be detected with echo on, and PARMRK was not accounted for
properly in all cases.  One symptom of these problems, in addition to lost
characters, was early termination from unix commands like tr and cat when
^Q was used to break from a stopped tty with full buffers (note that breaking
out was often previously not possible, due to the issues discussed next).
Note space is always reserved at the end of the buffer for a newline (or
EOF/EOL) in canonical mode.

A major problem also addressed is when a tty receives considerable input
and a program produces output after the tty is stopped.  In this condition,
both input and output buffers will fill (e.g. in the ptys), causing a kind
of "gridlock" during which neither buffer can empty.  If the user then
tries to free the stopped state with ^Q or interrupt the process with ^C,
nothing will happen, and there is no way to break out of the condition from
within the tty (because the ^C or ^Q character is in a yet-to-be-processed
part of the input buffer).  This is fixed by expanding the case in which
n_tty_set_room() ensures receive_room is not zero, allowing special characters
to be handled (before, it only handled erase characters).  Note that this
patch does not address non-canonical mode, which might be worth considering,
depending on whether that would affect other tty types and situations.

Another similar issue addressed is when the tty will stop polling for input
due to the buffer hitting the size specified by WAKEUP_CHARS.  Again,
a ^C or ^Q will be stuck in a future part of the buffer.  This gridlock
will be eventually broken by enough single input characters to flush
blocks through (if that ever does happen), but adjusting the
pty_chars_in_buffer() logic similarly to what is done in n_tty_set_room()
fixes this.

In addition, this patch causes "bell" (^G) characters (invoked when the input
buffer is full) to be immediately output rather than filling the echo buffer
This is especially a problem when the tty is stopped and buffers fill, since
the bells would not achieve their purpose, and they would flush all at once
when the tty was restarted.


Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2008-10-07 18:31:09.990032960 -0600
+++ b/drivers/char/n_tty.c	2008-10-12 20:08:55.239843380 -0600
@@ -113,13 +113,15 @@ static void n_tty_set_room(struct tty_st
 	int	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;
 
 	/*
-	 * If we are doing input canonicalization, and there are no
-	 * pending newlines, let characters through without limit, so
-	 * that erase characters will be handled.  Other excess
-	 * characters will be beeped.
+	 * If we are doing input canonicalization and the tty needs
+	 * to handle signals, xon/off, or erase characters (i.e. no
+	 * pending newlines), let characters through without limit,
+	 * so that these special characters will be handled.
+	 * Other excess characters will be beeped.
 	 */
 	if (left <= 0)
-		left = tty->icanon && !tty->canon_data;
+		left = tty->icanon &&
+		       (L_ISIG(tty) || I_IXON(tty) || !tty->canon_data) ? 1 : 0;
 	tty->receive_room = left;
 }
 
@@ -339,10 +341,12 @@ static int do_output_char(unsigned char 
 			tty->column--;
 		break;
 	default:
-		if (O_OLCUC(tty))
-			c = toupper(c);
-		if (!iscntrl(c) && !is_continuation(c, tty))
-			tty->column++;
+		if (!iscntrl(c)) {
+			if (O_OLCUC(tty))
+				c = toupper(c);
+			if (!is_continuation(c, tty))
+				tty->column++;
+		}
 		break;
 	}
 
@@ -414,7 +418,9 @@ static ssize_t process_output_block(stru
 		nr = space;
 
 	for (i = 0, cp = buf; i < nr; i++, cp++) {
-		switch (*cp) {
+		unsigned char c = *cp;
+		
+		switch (c) {
 		case '\n':
 			if (O_ONLRET(tty))
 				tty->column = 0;
@@ -436,10 +442,12 @@ static ssize_t process_output_block(stru
 				tty->column--;
 			break;
 		default:
-			if (O_OLCUC(tty))
-				goto break_out;
-			if (!iscntrl(*cp))
-				tty->column++;
+			if (!iscntrl(c)) {
+				if (O_OLCUC(tty))
+					goto break_out;
+				if (!is_continuation(c, tty))
+					tty->column++;
+			}
 			break;
 		}
 	}
@@ -848,7 +856,7 @@ static void eraser(unsigned char c, stru
 	unsigned long flags;
 
 	if (tty->read_head == tty->canon_head) {
-		/* echo_char_raw('\a', tty); */ /* what do you think? */
+		/* process_output('\a', tty); */ /* what do you think? */
 		return;
 	}
 	if (c == ERASE_CHAR(tty))
@@ -1081,6 +1089,7 @@ static inline void n_tty_receive_parity_
 static inline void n_tty_receive_char(struct tty_struct *tty, unsigned char c)
 {
 	unsigned long flags;
+	int parmrk;
 
 	if (tty->raw) {
 		put_tty_queue(c, tty);
@@ -1119,21 +1128,22 @@ static inline void n_tty_receive_char(st
 	 */
 	if (!test_bit(c, tty->process_char_map) || tty->lnext) {
 		tty->lnext = 0;
+		parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
+		if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
+			/* beep if no space */
+			if (L_ECHO(tty))
+				process_output('\a', tty);
+			return;
+		}
 		if (L_ECHO(tty)) {
 			finish_erasing(tty);
-			if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-				/* beep if no space */
-				echo_char_raw('\a', tty);
-				process_echoes(tty);
-				return;
-			}
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
@@ -1225,15 +1235,20 @@ send_signal:
 			return;
 		}
 		if (c == '\n') {
+			if (tty->read_cnt >= N_TTY_BUF_SIZE) {
+				if (L_ECHO(tty))
+					process_output('\a', tty);
+				return;
+			}
 			if (L_ECHO(tty) || L_ECHONL(tty)) {
-				if (tty->read_cnt >= N_TTY_BUF_SIZE-1)
-					echo_char_raw('\a', tty);
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
@@ -1241,12 +1256,17 @@ send_signal:
 		}
 		if ((c == EOL_CHAR(tty)) ||
 		    (c == EOL2_CHAR(tty) && L_IEXTEN(tty))) {
+			parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty))
+				 ? 1 : 0;
+			if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk)) {
+				if (L_ECHO(tty))
+					process_output('\a', tty);
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
@@ -1257,7 +1277,7 @@ send_signal:
 			 * XXX does PARMRK doubling happen for
 			 * EOL_CHAR and EOL2_CHAR?
 			 */
-			if (I_PARMRK(tty) && c == (unsigned char) '\377')
+			if (parmrk)
 				put_tty_queue(c, tty);
 
 handle_newline:
@@ -1274,14 +1294,15 @@ handle_newline:
 		}
 	}
 
+	parmrk = (c == (unsigned char) '\377' && I_PARMRK(tty)) ? 1 : 0;
+	if (tty->read_cnt >= (N_TTY_BUF_SIZE - parmrk - 1)) {
+		/* beep if no space */
+		if (L_ECHO(tty))
+			process_output('\a', tty);
+		return;
+	}
 	if (L_ECHO(tty)) {
 		finish_erasing(tty);
-		if (tty->read_cnt >= N_TTY_BUF_SIZE-1) {
-			/* beep if no space */
-			echo_char_raw('\a', tty);
-			process_echoes(tty);
-			return;
-		}
 		if (c == '\n')
 			echo_char_raw('\n', tty);
 		else {
@@ -1293,7 +1314,7 @@ handle_newline:
 		process_echoes(tty);
 	}
 
-	if (I_PARMRK(tty) && c == (unsigned char) '\377')
+	if (parmrk)
 		put_tty_queue(c, tty);
 
 	put_tty_queue(c, tty);
diff -Nurp a/drivers/char/pty.c b/drivers/char/pty.c
--- a/drivers/char/pty.c	2008-10-07 18:30:41.238264230 -0600
+++ b/drivers/char/pty.c	2008-10-12 22:27:33.630288980 -0600
@@ -130,15 +130,19 @@ static int pty_write_room(struct tty_str
  *	WSH 05/24/97:  Modified for asymmetric MASTER/SLAVE behavior
  *	The chars_in_buffer() value is used by the ldisc select() function 
  *	to hold off writing when chars_in_buffer > WAKEUP_CHARS (== 256).
- *	The pty driver chars_in_buffer() Master/Slave must behave differently:
+ *	The pty driver chars_in_buffer() Master/Slave must behave differently.
+ *
+ *	JGP 10/12/2008:  Modified this further to allow special characters
+ *	in canonical mode to get through.
+ *
+ *	The Master side needs to allow typed-ahead commands to accumulate
+ *	while being canonicalized, so we report "our buffer" as empty until
+ *	some threshold is reached or if we need to allow special characters
+ *	through, or else report the count.  (Any count > WAKEUP_CHARS is
+ *	regarded by select() as "full".)  To avoid deadlock, the count
+ *	returned must be 0 if no canonical data is available to be 
+ *	read.  (The N_TTY ldisc.chars_in_buffer now knows this.)
  *
- *      The Master side needs to allow typed-ahead commands to accumulate
- *      while being canonicalized, so we report "our buffer" as empty until
- *	some threshold is reached, and then report the count. (Any count >
- *	WAKEUP_CHARS is regarded by select() as "full".)  To avoid deadlock 
- *	the count returned must be 0 if no canonical data is available to be 
- *	read. (The N_TTY ldisc.chars_in_buffer now knows this.)
- *  
  *	The Slave side passes all characters in raw mode to the Master side's
  *	buffer where they can be read immediately, so in this case we can
  *	return the true count in the buffer.
@@ -152,16 +156,24 @@ static int pty_chars_in_buffer(struct tt
 	if (!to || !to->ldisc.ops->chars_in_buffer)
 		return 0;
 
-	/* The ldisc must report 0 if no characters available to be read */
-	count = to->ldisc.ops->chars_in_buffer(to);
-
-	if (tty->driver->subtype == PTY_TYPE_SLAVE) return count;
-
-	/* Master side driver ... if the other side's read buffer is less than 
-	 * half full, return 0 to allow writers to proceed; otherwise return
-	 * the count.  This leaves a comfortable margin to avoid overflow, 
-	 * and still allows half a buffer's worth of typed-ahead commands.
+	/* Slave side driver ... return true count */
+	if (tty->driver->subtype == PTY_TYPE_SLAVE)
+		return to->ldisc.ops->chars_in_buffer(to);
+
+	/* Master side driver ... if we are doing input canonicalization and
+	 * the tty needs to handle signals, xon/off, or erase characters
+	 * (i.e. no pending newlines), return 0 to allow writers to proceed.
+	 * Do the same if the other side's read buffer is less than half full.
+	 * Otherwise, return the count.  So in canonical mode, this allows
+	 * special characters positioned later in the buffer to be handled,
+	 * and in non-canonical mode, this leaves a comfortable margin to
+	 * avoid overflow and still provides half a buffer's worth of
+	 * type-ahead space.
 	 */
+	if (to->icanon && (L_ISIG(to) || I_IXON(to) || !to->canon_data))
+		return 0;
+
+	count = to->ldisc.ops->chars_in_buffer(to);
 	return ((count < N_TTY_BUF_SIZE/2) ? 0 : count);
 }
 

--------------010008090401020706060805--
