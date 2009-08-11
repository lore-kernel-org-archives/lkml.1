Return-Path: <linux-kernel-owner+w=401wt.eu-S1754907AbZHKSQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754907AbZHKSQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 14:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbZHKSQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 14:16:41 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:38369 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441AbZHKSQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 14:16:40 -0400
Message-ID: <4A81B587.8070902@skyrush.com>
Date: Tue, 11 Aug 2009 12:16:39 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090722)
MIME-Version: 1.0
To: Artur Skawina <art.08.09@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gregkh@suse.de
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Moving tty->stopped logic to ldisc (pty: fix data loss when stopped
 (^S/^Q))
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------040405070500050403010609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040405070500050403010609
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

[Please include my email address in replies]

Hi all,

This is in regard to the problem that the recent patch ("pty: fix data
loss when stopped (^S/^Q)") fixes.  The issue is something I've been
looking at recently as well after noticing (I noticed it first as loss
of echoes, since I was re-testing what my echo buffer code originally
fixed).

Like mentioned in the other thread on this topic, the thought also
occurred to me that the "tty stopped" logic should be in the ldisc
rather in the driver code (console, pty, etc.).  Also, upon digging
further into the issue, even though the fix applied does resume previous
behavior, there are some remaining issues that it does not address and
that have existed for a while:

1) If the tty->stopped state changes during a write (either regular or
echo output), the pty can end up throwing character away.  This is a
small window of opportunity, but there nonetheless.

2) Since the N_TTY ldisc relies on a reliable amount of "write room"
during output operations (to both avoid similar loss of chars and to
ensure certain char groupings, like "^C", stay together atomically)
other calls to ttyp->ops->write outside the ldisc (e.g.
tty_write_message in tty_io.c or send_prio_char in tty_ioctl.c) that
happen in the middle of an ldisc write are problematic since they could
cause a reduction of write room without the knowledge of N_TTY.

I have attached a patch for comment which removes the checks for
tty->stopped from pty.c and vt.c (covering the pty and console cases)
and moves these checks to the ldisc (only N_TTY for now).  I also use
the output lock (a finer-grained lock than the write lock that can be
used in both write and receive paths) to protect the write room in the
cases outside the ldisc state above.  Ultimately, we'd want to either
make these locks only happen if ldisc=N_TTY or have all ldiscs use it, I
would think (comments?).

						-Thanks, Joe

--------------040405070500050403010609
Content-Type: text/plain;
 name="tty_move_tty_stopped_logic_to_ldisc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tty_move_tty_stopped_logic_to_ldisc.patch"

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2009-08-11 11:28:46.352996327 -0600
+++ b/drivers/char/n_tty.c	2009-08-11 11:30:05.152996397 -0600
@@ -366,6 +366,9 @@ static int process_output(unsigned char 
 {
 	int	space, retval;
 
+	if (tty->stopped)
+		return -1;
+
 	mutex_lock(&tty->output_lock);
 
 	space = tty_write_room(tty);
@@ -404,6 +407,9 @@ static ssize_t process_output_block(stru
 	int 	i;
 	const unsigned char *cp;
 
+	if (tty->stopped)
+		return 0;
+
 	mutex_lock(&tty->output_lock);
 
 	space = tty_write_room(tty);
@@ -487,7 +493,7 @@ static void process_echoes(struct tty_st
 	unsigned char c;
 	unsigned char *cp, *buf_end;
 
-	if (!tty->echo_cnt)
+	if (!tty->echo_cnt || tty->stopped)
 		return;
 
 	mutex_lock(&tty->output_lock);
@@ -1965,7 +1971,11 @@ static ssize_t n_tty_write(struct tty_st
 				tty->ops->flush_chars(tty);
 		} else {
 			while (nr > 0) {
+				if (tty->stopped)
+					break;
+				mutex_lock(&tty->output_lock);
 				c = tty->ops->write(tty, b, nr);
+				mutex_unlock(&tty->output_lock);
 				if (c < 0) {
 					retval = c;
 					goto break_out;
diff -Nurp a/drivers/char/pty.c b/drivers/char/pty.c
--- a/drivers/char/pty.c	2009-08-11 11:33:03.603031387 -0600
+++ b/drivers/char/pty.c	2009-08-11 11:33:15.702997374 -0600
@@ -115,9 +115,6 @@ static int pty_write(struct tty_struct *
 	struct tty_struct *to = tty->link;
 	int c;
 
-	if (tty->stopped)
-		return 0;
-
 	/* This isn't locked but our 8K is quite sloppy so no
 	   big deal */
 
@@ -144,8 +141,6 @@ static int pty_write(struct tty_struct *
 
 static int pty_write_room(struct tty_struct *tty)
 {
-	if (tty->stopped)
-		return 0;
 	return pty_space(tty->link);
 }
 
diff -Nurp a/drivers/char/tty_io.c b/drivers/char/tty_io.c
--- a/drivers/char/tty_io.c	2009-08-11 11:29:16.312996885 -0600
+++ b/drivers/char/tty_io.c	2009-08-11 11:30:05.242984105 -0600
@@ -1020,8 +1020,11 @@ void tty_write_message(struct tty_struct
 	lock_kernel();
 	if (tty) {
 		mutex_lock(&tty->atomic_write_lock);
-		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags))
+		if (tty->ops->write && !test_bit(TTY_CLOSING, &tty->flags)) {
+			mutex_lock(&tty->output_lock);
 			tty->ops->write(tty, msg, strlen(msg));
+			mutex_unlock(&tty->output_lock);
+		}
 		tty_write_unlock(tty);
 	}
 	unlock_kernel();
diff -Nurp a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
--- a/drivers/char/tty_ioctl.c	2009-08-11 11:29:20.582997095 -0600
+++ b/drivers/char/tty_ioctl.c	2009-08-11 11:30:05.252996746 -0600
@@ -893,7 +893,9 @@ static int send_prio_char(struct tty_str
 
 	if (was_stopped)
 		start_tty(tty);
+	mutex_lock(&tty->output_lock);
 	tty->ops->write(tty, &ch, 1);
+	mutex_unlock(&tty->output_lock);
 	if (was_stopped)
 		stop_tty(tty);
 	tty_write_unlock(tty);
diff -Nurp a/drivers/char/vt.c b/drivers/char/vt.c
--- a/drivers/char/vt.c	2009-08-11 11:29:04.212996397 -0600
+++ b/drivers/char/vt.c	2009-08-11 11:30:05.202991508 -0600
@@ -2149,7 +2149,7 @@ static int do_con_write(struct tty_struc
 
 	param.vc = vc;
 
-	while (!tty->stopped && count) {
+	while (count) {
 		int orig = *buf;
 		c = orig;
 		buf++;
@@ -2673,8 +2673,6 @@ static int con_put_char(struct tty_struc
 
 static int con_write_room(struct tty_struct *tty)
 {
-	if (tty->stopped)
-		return 0;
 	return 32768;		/* No limit, really; we're not buffering */
 }
 

--------------040405070500050403010609--
