Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbZGGPjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbZGGPjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 11:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758127AbZGGPjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 11:39:35 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39018 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758472AbZGGPjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 11:39:33 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 1/2] pty: Rework the pty layer to use the normal buffering
	logic
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Tue, 07 Jul 2009 16:39:41 +0100
Message-ID: <20090707153923.3642.3500.stgit@localhost.localdomain>
In-Reply-To: <20090707153625.3642.70750.stgit@localhost.localdomain>
References: <20090707153625.3642.70750.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This fixes the ppp problems and various other issues with call locking
caused by one side of a pty called in one locking context trying to match
another with differing rules on the other side. We also get a big slack
space to work with that means we can bury the flow control deadlock case
for any conceivable real world situation.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/pty.c |  156 ++++++++++++++++++++--------------------------------
 1 files changed, 60 insertions(+), 96 deletions(-)


diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index daebe1b..5448320 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -75,114 +75,88 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
  */
 static void pty_unthrottle(struct tty_struct *tty)
 {
-	struct tty_struct *o_tty = tty->link;
-
-	if (!o_tty)
-		return;
-
-	tty_wakeup(o_tty);
+	tty_wakeup(tty->link);
 	set_bit(TTY_THROTTLED, &tty->flags);
 }
 
-/*
- * WSH 05/24/97: modified to
- *   (1) use space in tty->flip instead of a shared temp buffer
- *	 The flip buffers aren't being used for a pty, so there's lots
- *	 of space available.  The buffer is protected by a per-pty
- *	 semaphore that should almost never come under contention.
- *   (2) avoid redundant copying for cases where count >> receive_room
- * N.B. Calls from user space may now return an error code instead of
- * a count.
+/**
+ *	pty_space	-	report space left for writing
+ *	@to: tty we are writing into
  *
- * FIXME: Our pty_write method is called with our ldisc lock held but
- * not our partners. We can't just wait on the other one blindly without
- * risking deadlocks. At some point when everything has settled down we need
- * to look into making pty_write at least able to sleep over an ldisc change.
+ *	The tty buffers allow 64K but we sneak a peak and clip at 8K this
+ *	allows a lot of overspill room for echo and other fun messes to
+ *	be handled properly
+ */
+
+static int pty_space(struct tty_struct *to)
+{
+	int n = 8192 - to->buf.memory_used;
+	if (n < 0)
+		return 0;
+	return n;
+}
+
+/**
+ *	pty_write		-	write to a pty
+ *	@tty: the tty we write from
+ *	@buf: kernel buffer of data
+ *	@count: bytes to write
  *
- * The return on no ldisc is a bit counter intuitive but the logic works
- * like this. During an ldisc change the other end will flush its buffers. We
- * thus return the full length which is identical to the case where we had
- * proper locking and happened to queue the bytes just before the flush during
- * the ldisc change.
+ *	Our "hardware" write method. Data is coming from the ldisc which
+ *	may be in a non sleeping state. We simply throw this at the other
+ *	end of the link as if we were an IRQ handler receiving stuff for
+ *	the other side of the pty/tty pair.
  */
+
 static int pty_write(struct tty_struct *tty, const unsigned char *buf,
 								int count)
 {
 	struct tty_struct *to = tty->link;
-	struct tty_ldisc *ld;
-	int c = count;
-
-	if (!to || tty->stopped)
+	int c;
+	
+	if (tty->stopped)
 		return 0;
-	ld = tty_ldisc_ref(to);
-
-	if (ld) {
-		c = to->receive_room;
-		if (c > count)
-			c = count;
-		ld->ops->receive_buf(to, buf, NULL, c);
-		tty_ldisc_deref(ld);
+	
+	/* This isn't locked but our 8K is quite sloppy so no
+	   big deal */
+
+	c = pty_space(to);
+	if (c > count)
+		c = count;
+	if (c > 0) {
+		/* Stuff the data into the input queue of the other end */
+		c = tty_insert_flip_string(to, buf, c);
+		/* And shovel */
+		tty_flip_buffer_push(to);
+		tty_wakeup(tty);
 	}
 	return c;
 }
 
+/**
+ *	pty_write_room	-	write space
+ *	@tty: tty we are writing from
+ *
+ *	Report how many bytes the ldisc can send into the queue for
+ *	the other device.
+ */
+
 static int pty_write_room(struct tty_struct *tty)
 {
-	struct tty_struct *to = tty->link;
-
-	if (!to || tty->stopped)
-		return 0;
-
-	return to->receive_room;
+	return pty_space(tty->link);
 }
 
-/*
- *	WSH 05/24/97:  Modified for asymmetric MASTER/SLAVE behavior
- *	The chars_in_buffer() value is used by the ldisc select() function
- *	to hold off writing when chars_in_buffer > WAKEUP_CHARS (== 256).
- *	The pty driver chars_in_buffer() Master/Slave must behave differently:
- *
- *      The Master side needs to allow typed-ahead commands to accumulate
- *      while being canonicalized, so we report "our buffer" as empty until
- *	some threshold is reached, and then report the count. (Any count >
- *	WAKEUP_CHARS is regarded by select() as "full".)  To avoid deadlock
- *	the count returned must be 0 if no canonical data is available to be
- *	read. (The N_TTY ldisc.chars_in_buffer now knows this.)
+/**
+ *	pty_chars_in_buffer	-	characters currently in our tx queue
+ *	@tty: our tty
  *
- *	The Slave side passes all characters in raw mode to the Master side's
- *	buffer where they can be read immediately, so in this case we can
- *	return the true count in the buffer.
+ *	Report how much we have in the transmit queue. As everything is
+ *	instantly at the other end this is easy to implement.
  */
+
 static int pty_chars_in_buffer(struct tty_struct *tty)
 {
-	struct tty_struct *to = tty->link;
-	struct tty_ldisc *ld;
-	int count = 0;
-
-	/* We should get the line discipline lock for "tty->link" */
-	if (!to)
-		return 0;
-	/* We cannot take a sleeping reference here without deadlocking with
-	   an ldisc change - but it doesn't really matter */
-	ld = tty_ldisc_ref(to);
-	if (ld == NULL)
-		return 0;
-
-	/* The ldisc must report 0 if no characters available to be read */
-	if (ld->ops->chars_in_buffer)
-		count = ld->ops->chars_in_buffer(to);
-
-	tty_ldisc_deref(ld);
-
-	if (tty->driver->subtype == PTY_TYPE_SLAVE)
-		return count;
-
-	/* Master side driver ... if the other side's read buffer is less than
-	 * half full, return 0 to allow writers to proceed; otherwise return
-	 * the count.  This leaves a comfortable margin to avoid overflow,
-	 * and still allows half a buffer's worth of typed-ahead commands.
-	 */
-	return (count < N_TTY_BUF_SIZE/2) ? 0 : count;
+	return 0;
 }
 
 /* Set the lock flag on a pty */
@@ -202,20 +176,10 @@ static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
 	unsigned long flags;
-	struct tty_ldisc *ld;
 
 	if (!to)
 		return;
-	ld = tty_ldisc_ref(to);
-
-	/* The other end is changing discipline */
-	if (!ld)
-		return;
-
-	if (ld->ops->flush_buffer)
-		to->ldisc->ops->flush_buffer(to);
-	tty_ldisc_deref(ld);
-
+	/* tty_buffer_flush(to); FIXME */
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;

