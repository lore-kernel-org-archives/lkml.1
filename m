Return-Path: <linux-kernel-owner+w=401wt.eu-S1758550AbYJEQcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550AbYJEQcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:32:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759282AbYJEQYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:24:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34329 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759275AbYJEQX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:23:59 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 68/76] tty: Minor tidyups and document fixes for n_tty
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:23:59 +0100
Message-ID: <20081005162333.1997.72957.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove/fix some bogus NULL checks, comment some locking etc

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/n_tty.c |   48 +++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index b4f5dcc..c0285b9 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -99,6 +99,7 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 
 static void n_tty_set_room(struct tty_struct *tty)
 {
+	/* tty->read_cnt is not read locked ? */
 	int	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;
 
 	/*
@@ -121,6 +122,16 @@ static void put_tty_queue_nolock(unsigned char c, struct tty_struct *tty)
 	}
 }
 
+/**
+ *	put_tty_queue		-	add character to tty
+ *	@c: character
+ *	@tty: tty device
+ *
+ *	Add a character to the tty read_buf queue. This is done under the
+ *	read_lock to serialize character addition and also to protect us
+ *	against parallel reads or flushes
+ */
+
 static void put_tty_queue(unsigned char c, struct tty_struct *tty)
 {
 	unsigned long flags;
@@ -137,14 +148,11 @@ static void put_tty_queue(unsigned char c, struct tty_struct *tty)
  *	check_unthrottle	-	allow new receive data
  *	@tty; tty device
  *
- *	Check whether to call the driver.unthrottle function.
- *	We test the TTY_THROTTLED bit first so that it always
- *	indicates the current state. The decision about whether
- *	it is worth allowing more input has been taken by the caller.
+ *	Check whether to call the driver unthrottle functions
+ *
  *	Can sleep, may be called under the atomic_read_lock mutex but
  *	this is not guaranteed.
  */
-
 static void check_unthrottle(struct tty_struct *tty)
 {
 	if (tty->count)
@@ -158,6 +166,8 @@ static void check_unthrottle(struct tty_struct *tty)
  *	Reset the read buffer counters, clear the flags,
  *	and make sure the driver is unthrottled. Called
  *	from n_tty_open() and n_tty_flush_buffer().
+ *
+ *	Locking: tty_read_lock for read fields.
  */
 static void reset_buffer_flags(struct tty_struct *tty)
 {
@@ -181,7 +191,7 @@ static void reset_buffer_flags(struct tty_struct *tty)
  *	at hangup) or when the N_TTY line discipline internally has to
  *	clean the pending queue (for example some signals).
  *
- *	Locking: ctrl_lock
+ *	Locking: ctrl_lock, read_lock.
  */
 
 static void n_tty_flush_buffer(struct tty_struct *tty)
@@ -207,6 +217,8 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
  *
  *	Report the number of characters buffered to be delivered to user
  *	at this instant in time.
+ *
+ *	Locking: read_lock
  */
 
 static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
@@ -410,6 +422,8 @@ break_out:
  *
  *	Echo user input back onto the screen. This must be called only when
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
+ *
+ *	Relies on BKL for tty column locking
  */
 
 static void echo_char(unsigned char c, struct tty_struct *tty)
@@ -422,6 +436,12 @@ static void echo_char(unsigned char c, struct tty_struct *tty)
 		opost(c, tty);
 }
 
+/**
+ *	finsh_erasing		-	complete erase
+ *	@tty: tty doing the erase
+ *
+ *	Relies on BKL for tty column locking
+ */
 static inline void finish_erasing(struct tty_struct *tty)
 {
 	if (tty->erasing) {
@@ -439,6 +459,8 @@ static inline void finish_erasing(struct tty_struct *tty)
  *	Perform erase and necessary output when an erase character is
  *	present in the stream from the driver layer. Handles the complexities
  *	of UTF-8 multibyte symbols.
+ *
+ *	Locking: read_lock for tty buffers, BKL for column/erasing state
  */
 
 static void eraser(unsigned char c, struct tty_struct *tty)
@@ -447,6 +469,7 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 	int head, seen_alnums, cnt;
 	unsigned long flags;
 
+	/* FIXME: locking needed ? */
 	if (tty->read_head == tty->canon_head) {
 		/* opost('\a', tty); */		/* what do you think? */
 		return;
@@ -481,6 +504,7 @@ static void eraser(unsigned char c, struct tty_struct *tty)
 	}
 
 	seen_alnums = 0;
+	/* FIXME: Locking ?? */
 	while (tty->read_head != tty->canon_head) {
 		head = tty->read_head;
 
@@ -583,6 +607,8 @@ static void eraser(unsigned char c, struct tty_struct *tty)
  *	may caus terminal flushing to take place according to the termios
  *	settings and character used. Called from the driver receive_buf
  *	path so serialized.
+ *
+ *	Locking: ctrl_lock, read_lock (both via flush buffer)
  */
 
 static inline void isig(int sig, struct tty_struct *tty, int flush)
@@ -1007,6 +1033,8 @@ int is_ignored(int sig)
  *	and is protected from re-entry by the tty layer. The user is
  *	guaranteed that this function will not be re-entered or in progress
  *	when the ldisc is closed.
+ *
+ *	Locking: Caller holds tty->termios_mutex
  */
 
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
@@ -1266,10 +1294,7 @@ static ssize_t read_chan(struct tty_struct *tty, struct file *file,
 
 do_it_again:
 
-	if (!tty->read_buf) {
-		printk(KERN_ERR "n_tty_read_chan: read_buf == NULL?!?\n");
-		return -EIO;
-	}
+	BUG_ON(!tty->read_buf);
 
 	c = job_control(tty, file);
 	if (c < 0)
@@ -1589,7 +1614,7 @@ static unsigned long inq_canon(struct tty_struct *tty)
 {
 	int nr, head, tail;
 
-	if (!tty->canon_data || !tty->read_buf)
+	if (!tty->canon_data)
 		return 0;
 	head = tty->canon_head;
 	tail = tty->read_tail;
@@ -1613,6 +1638,7 @@ static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCOUTQ:
 		return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
 	case TIOCINQ:
+		/* FIXME: Locking */
 		retval = tty->read_cnt;
 		if (L_ICANON(tty))
 			retval = inq_canon(tty);

