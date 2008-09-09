Return-Path: <linux-kernel-owner+w=401wt.eu-S1756730AbYIIUm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756730AbYIIUm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2008 16:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbYIIUmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Sep 2008 16:42:19 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:59552 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYIIUmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2008 16:42:18 -0400
Message-ID: <48C6DFA4.5040406@skyrush.com>
Date: Tue, 09 Sep 2008 14:42:12 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org>	<48AC3A16.4080209@skyrush.com>	<48B3F9F7.2050503@skyrush.com>	<48C54EC2.4060901@skyrush.com>	<20080908173250.2452c5b8.akpm@linux-foundation.org>	<20080909115536.1664d57a@lxorguk.ukuu.org.uk> <20080909104325.4653190b.akpm@linux-foundation.org>
In-Reply-To: <20080909104325.4653190b.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------020203010201020508090600"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020203010201020508090600
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Andrew Morton wrote:
> On Tue, 9 Sep 2008 11:55:36 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> lock_kernel can sleep.
> 
> That used to be the case, but the mutex_lock() version of the bkl got
> removed.  It may of course come back.
> 
>> Its not allowed...
>>
> 
> yup.

OK, attached is a new version of this patch:

	tty-fix-echo-tab-erase-and-locking.patch

I have removed lock_kernel() from n_tty.c completely (which is a nice
benefit).  As we discussed, this is now easier due to my echo patch
isolating the column state code.  In its place, I created two new mutex
locks: "output_lock" (protects column state and and driver buffer space
left) and "echo_lock" (protects the echo buffer).  I could have used
just one to protect all of this, but there was no need to make the lock
that wide-ranging (e.g., it's OK to add stuff to the echo buffer while
regular output is happening).

All echo buffer operations take the echo lock, and all process_out*
functions take output lock.  The one function that takes both locks is
process_echoes (this is the one that erroneously took both the echo spin
lock and the BKL before).  Note that the process_output functions are at
least sometimes (and maybe all of the time) locked by tty_write_lock (as
Alan mentioned), but this does not protect echo from interfering with
regular output.

Let me know what you think of this patch.  I am using it now, and it
appears to work well so far.

						Thanks again, Joe



--------------020203010201020508090600
Content-Type: text/plain;
 name="tty-fix-echo-tab-erase-and-locking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tty-fix-echo-tab-erase-and-locking.patch"

1) Fix tab erasure handling
2) Improve locking when working with the echo buffer
3) Remove the big kernel lock (BKL) from n_tty

Tab erasure handling is now more robust and able to handle non-zero
canon column cases more correctly.  This is done by making correct use
of what is known in the eraser function (read buffer contents) and what
is known at the time of processing the tab erasure (column state).

Also, better locking of the echo buffer will now prevent any attempts to
process partial multi-byte echo operations.  And since the echo buffer
code now isolates the tty column state code to the process_out* and
process_echoes functions, we can remove the big kernel lock (BKL)
and replace it with more modern mutex locks.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2008-09-09 14:03:06.492758079 -0600
+++ b/drivers/char/n_tty.c	2008-09-09 14:07:05.582759317 -0600
@@ -71,7 +71,7 @@
 #define ECHO_OP_START 0xff
 #define ECHO_OP_MOVE_BACK_COL 0x80
 #define ECHO_OP_SET_CANON_COL 0x81
-#define ECHO_OP_TAB_ERASE 0x82
+#define ECHO_OP_ERASE_TAB 0x82
 
 static inline unsigned char *alloc_buf(void)
 {
@@ -178,9 +178,11 @@ static void reset_buffer_flags(struct tt
 	spin_lock_irqsave(&tty->read_lock, flags);
 	tty->read_head = tty->read_tail = tty->read_cnt = 0;
 	spin_unlock_irqrestore(&tty->read_lock, flags);
-	spin_lock_irqsave(&tty->echo_lock, flags);
+
+	mutex_lock(&tty->echo_lock);
 	tty->echo_pos = tty->echo_cnt = tty->echo_overrun = 0;
-	spin_unlock_irqrestore(&tty->echo_lock, flags);
+	mutex_unlock(&tty->echo_lock);
+
 	tty->canon_head = tty->canon_data = tty->erasing = 0;
 	memset(&tty->read_flags, 0, sizeof tty->read_flags);
 	n_tty_set_room(tty);
@@ -272,14 +274,11 @@ static inline int is_continuation(unsign
  *	do_output_char			-	output one character
  *	@c: character (or partial unicode symbol)
  *	@tty: terminal device
- *	@space: space available in write buffer
+ *	@space: space available in tty driver write buffer
  *
  *	This is a helper function that handles one output character
  *	(including special characters like TAB, CR, LF, etc.),
  *	putting the results in the tty driver's write buffer.
- *	It is assumed that the calling function does the required
- *	locking and has already determined the space left in the tty
- *	driver's write buffer.
  *
  *	Note that Linux currently ignores TABDLY, CRDLY, VTDLY, FFDLY
  *	and NLDLY.  They simply aren't relevant in the world today.
@@ -287,6 +286,9 @@ static inline int is_continuation(unsign
  *
  *	Returns the number of bytes of buffer space used or -1 if
  *	no space left.
+ *
+ *	Should be called under the output lock to protect column state and
+ *	space left in the tty driver buffer.
  */
 
 static int do_output_char(unsigned char c, struct tty_struct *tty, int space)
@@ -356,23 +358,21 @@ static int do_output_char(unsigned char 
  *	Perform OPOST processing.  Returns -1 when the output device is
  *	full and the character must be retried.
  *
- *	Called from both the receive and transmit sides and can be called
- *	re-entrantly.  Relies on lock_kernel for tty->column state.
- *	Since we rely on lock_kernel to prevent the tty_write_room from
- *	changing after it is obtained, an alternate means to ensure this
- *	would need to be implemented if the locking mechanism changed.
+ *	Called from write_chan under the tty layer write lock.
+ *	Also takes the output lock to protect column state and
+ *	space left in the tty driver buffer.
  */
 
 static int process_output(unsigned char c, struct tty_struct *tty)
 {
 	int	space, retval;
 
-	lock_kernel();
+	mutex_lock(&tty->output_lock);
 
 	space = tty_write_room(tty);
 	retval = do_output_char(c, tty, space);
 
-	unlock_kernel();
+	mutex_unlock(&tty->output_lock);
 	if (retval < 0)
 		return -1;
 	else
@@ -391,10 +391,8 @@ static int process_output(unsigned char 
  *	symbols for the console driver and thus improve performance.
  *
  *	Called from write_chan under the tty layer write lock.
- *	Relies on lock_kernel for the tty->column state.
- *	Since we rely on lock_kernel to prevent the tty_write_room from
- *	changing after it is obtained, an alternate means to ensure this
- *	would need to be implemented if the locking mechanism changed.
+ *	Also takes the output lock to protect column state and
+ *	space left in the tty driver buffer.
  */
 
 static ssize_t process_output_block(struct tty_struct *tty,
@@ -404,12 +402,12 @@ static ssize_t process_output_block(stru
 	int 	i;
 	const unsigned char *cp;
 
-	lock_kernel();
+	mutex_lock(&tty->output_lock);
 
 	space = tty_write_room(tty);
 	if (!space)
 	{
-		unlock_kernel();
+		mutex_unlock(&tty->output_lock);
 		return 0;
 	}
 	if (nr > space)
@@ -448,7 +446,7 @@ static ssize_t process_output_block(stru
 break_out:
 	i = tty->ops->write(tty, buf, i);
 
-	unlock_kernel();
+	mutex_unlock(&tty->output_lock);
 	return i;
 }
 
@@ -474,14 +472,9 @@ break_out:
  *	are prioritized.  Also, when control characters are echoed with a
  *	prefixed "^", the pair is treated atomically and thus not separated.
  *
- *	Like the process_output functions, this relies on lock_kernel.
- *	If this lock is ever removed, we should make sure this function
- *	is locked against other code that currently uses echo_lock,
- *	and we should also lock against normal tty output done in
- *	write_chan (so the control pairs do not get separated).  Also,
- *	since we rely on lock_kernel to prevent the tty_write_room from
- *	changing after it is obtained, an alternate means to ensure this
- *	would need to be implemented if the locking mechanism changed.
+ *	Takes the output lock to protect column state and space left
+ *	in the tty driver buffer. 
+ *	Also takes the echo lock to protect the echo buffer.
  */
 
 static void process_echoes(struct tty_struct *tty)
@@ -493,7 +486,8 @@ static void process_echoes(struct tty_st
 	if (!tty->echo_cnt)
 		return;
 
-	lock_kernel();
+	mutex_lock(&tty->output_lock);
+	mutex_lock(&tty->echo_lock);
 
 	space = tty_write_room(tty);
 
@@ -518,44 +512,39 @@ static void process_echoes(struct tty_st
 			op = *opp;
 			
 			switch (op) {
-				unsigned char lbyte, hbyte;
-				unsigned short rdiff;
-				int num_bs;
-				unsigned int col;
+				unsigned int num_chars, num_bs;
 
-			case ECHO_OP_TAB_ERASE:
-				/* Extract rdiff value from next two bytes */
-				if (++opp == buf_end)
-					opp -= N_TTY_BUF_SIZE;
-				lbyte = *opp;
+			case ECHO_OP_ERASE_TAB:
 				if (++opp == buf_end)
 					opp -= N_TTY_BUF_SIZE;
-				hbyte = *opp;
-				rdiff = (hbyte << 8) | lbyte;
-				
-				col = tty->canon_column + rdiff;
-
-				/* should never happen */
-				if (tty->column > 0x80000000)
-					tty->column = 0;
-
-				num_bs = tty->column - col;
-				if (num_bs < 0)
-					num_bs = 0;
+				num_chars = *opp;
+
+				/*
+				 * Determine how many columns to go back
+				 * in order to erase the tab.
+				 * This depends on the number of columns
+				 * used by other characters within the tab
+				 * area.  If this (modulo 8) count is from
+				 * the start of input rather than from a
+				 * previous tab, we offset by canon column.
+				 * Otherwise, tab spacing is normal.
+				 */
+				if (!(num_chars & 0x80))
+					num_chars += tty->canon_column;
+				num_bs = 8 - (num_chars & 7);
+
 				if (num_bs > space) {
 					no_space_left = 1;
 					break;
 				}
-
-				/* Now backup to that column. */
-				while (tty->column > col) {
+				space -= num_bs;
+				while (num_bs--) {
 					tty_put_char(tty, '\b');
 					if (tty->column > 0)
 						tty->column--;
 				}
-				space -= num_bs;
-				cp += 4;
-				nr -= 4;
+				cp += 3;
+				nr -= 3;
 				break;
 
 			case ECHO_OP_SET_CANON_COL:
@@ -646,7 +635,8 @@ static void process_echoes(struct tty_st
 			tty->echo_overrun = 0;
 	}
 
-	unlock_kernel();
+	mutex_unlock(&tty->echo_lock);
+	mutex_unlock(&tty->output_lock);
 
 	if (tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
@@ -658,14 +648,13 @@ static void process_echoes(struct tty_st
  *	@tty: terminal device
  *
  *	Add a character or operation byte to the echo buffer.
+ *
+ *	Should be called under the echo lock to protect the echo buffer.
  */
 
 static void add_echo_byte(unsigned char c, struct tty_struct *tty)
 {
 	int	new_byte_pos;
-	unsigned long flags;
-
-	spin_lock_irqsave(&tty->echo_lock, flags);
 
 	if (tty->echo_cnt == N_TTY_BUF_SIZE) {
 		/* Circular buffer is already at capacity */
@@ -679,9 +668,9 @@ static void add_echo_byte(unsigned char 
 		{
 			if (tty->echo_buf[(tty->echo_pos + 1) &
 					  (N_TTY_BUF_SIZE - 1)] ==
-						ECHO_OP_TAB_ERASE) {
-				tty->echo_pos += 4;
-				tty->echo_cnt -= 3;
+						ECHO_OP_ERASE_TAB) {
+				tty->echo_pos += 3;
+				tty->echo_cnt -= 2;
 			} else {
 				tty->echo_pos += 2;
 				tty->echo_cnt -= 1;
@@ -699,8 +688,6 @@ static void add_echo_byte(unsigned char 
 	}
 
 	tty->echo_buf[new_byte_pos] = c;
-
-	spin_unlock_irqrestore(&tty->echo_lock, flags);
 }
 
 /**
@@ -708,12 +695,18 @@ static void add_echo_byte(unsigned char 
  *	@tty: terminal device
  *
  *	Add an operation to the echo buffer to move back one column.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_move_back_col(struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	add_echo_byte(ECHO_OP_START, tty);
 	add_echo_byte(ECHO_OP_MOVE_BACK_COL, tty);
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
@@ -722,28 +715,55 @@ static void echo_move_back_col(struct tt
  *
  *	Add an operation to the echo buffer to set the canon column
  *	to the current column.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_set_canon_col(struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	add_echo_byte(ECHO_OP_START, tty);
 	add_echo_byte(ECHO_OP_SET_CANON_COL, tty);
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
- *	echo_tab_erase	-	add operation to erase tabs
+ *	echo_erase_tab	-	add operation to erase a tab
+ *	@num_chars: number of character columns already used
+ *	@after_tab: true if num_chars starts after a previous tab
  *	@tty: terminal device
  *
- *	Add an operation to the echo buffer to set the canon column
- *	to the current column.
+ *	Add an operation to the echo buffer to erase a tab.
+ *
+ *	Called by the eraser function, which knows how many character
+ *	columns have been used since either a previous tab or the start
+ *	of input.  This information will be used later, along with
+ *	canon column (if applicable), to go back the correct number
+ *	of columns.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
-static void echo_tab_erase(unsigned short rdiff, struct tty_struct *tty)
+static void echo_erase_tab(unsigned int num_chars, int after_tab,
+			   struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	add_echo_byte(ECHO_OP_START, tty);
-	add_echo_byte(ECHO_OP_TAB_ERASE, tty);
-	add_echo_byte(rdiff & 0xff, tty);
-	add_echo_byte(rdiff >> 8, tty);
+	add_echo_byte(ECHO_OP_ERASE_TAB, tty);
+
+	/* We only need to know this modulo 8 (tab spacing) */
+	num_chars &= 7;
+
+	/* Set the high bit as a flag if num_chars is after a previous tab */
+	if (after_tab)
+		num_chars |= 0x80;
+	
+	add_echo_byte(num_chars, tty);
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
@@ -755,16 +775,22 @@ static void echo_tab_erase(unsigned shor
  *	L_ECHO(tty) is true. Called from the driver receive_buf path.
  *
  *	This variant does not treat control characters specially.
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_char_raw(unsigned char c, struct tty_struct *tty)
 {
+	mutex_lock(&tty->echo_lock);
+
 	if (c == ECHO_OP_START) {
 		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
 	} else {
 		add_echo_byte(c, tty);
 	}
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 /**
@@ -777,13 +803,24 @@ static void echo_char_raw(unsigned char 
  *
  *	This variant tags control characters to be possibly echoed as
  *	as "^X" (where X is the letter representing the control char).
+ *
+ *	Takes the echo lock to protect the echo buffer.
  */
 
 static void echo_char(unsigned char c, struct tty_struct *tty)
 {
-	if (iscntrl(c) && c != '\t')
+	mutex_lock(&tty->echo_lock);
+
+	if (c == ECHO_OP_START) {
+		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
-	echo_char_raw(c, tty);
+	} else {
+		if (iscntrl(c) && c != '\t')
+			add_echo_byte(ECHO_OP_START, tty);
+		add_echo_byte(c, tty);
+	}
+
+	mutex_unlock(&tty->echo_lock);
 }
 
 static inline void finish_erasing(struct tty_struct *tty)
@@ -885,28 +922,32 @@ static void eraser(unsigned char c, stru
 			} else if (kill_type == ERASE && !L_ECHOE(tty)) {
 				echo_char(ERASE_CHAR(tty), tty);
 			} else if (c == '\t') {
-				unsigned short rdiff = 0;
-				unsigned long tail = tty->canon_head;
+				unsigned int num_chars = 0;
+				int after_tab = 0;
+				unsigned long tail = tty->read_head;
 
 				/*
-				 * Find number of columns from canon_head
-				 * to read_head.  This will later be
-				 * added to the canon_column to determine
-				 * how far to erase up to the cur column.
+				 * Count the columns used for characters
+				 * since the start of input or after a
+				 * previous tab.
+				 * This info is used to go back the correct
+				 * number of columns.
 				 */
-				while (tail != tty->read_head) {
+				while (tail != tty->canon_head) {
+					tail = (tail-1) & (N_TTY_BUF_SIZE-1);
 					c = tty->read_buf[tail];
-					if (c == '\t')
-						rdiff = (rdiff | 7) + 1;
+					if (c == '\t') {
+						after_tab = 1;
+						break;
+					}
 					else if (iscntrl(c)) {
 						if (L_ECHOCTL(tty))
-							rdiff += 2;
-					} else if (!is_continuation(c, tty))
-						rdiff++;
-					tail = (tail+1) & (N_TTY_BUF_SIZE-1);
+							num_chars += 2;
+					} else if (!is_continuation(c, tty)) {
+						num_chars++;
+					}
 				}
-
-				echo_tab_erase(rdiff, tty);
+				echo_erase_tab(num_chars, after_tab, tty);
 			} else {
 				if (iscntrl(c) && L_ECHOCTL(tty)) {
 					echo_char_raw('\b', tty);
@@ -1836,10 +1877,13 @@ do_it_again:
  *	@buf: userspace buffer pointer
  *	@nr: size of I/O
  *
- *	Write function of the terminal device. This is serialized with
+ *	Write function of the terminal device.  This is serialized with
  *	respect to other write callers but not to termios changes, reads
- *	and other such events. We must be careful with N_TTY as the receive
- *	code will echo characters, thus calling driver write methods.
+ *	and other such events.  Since the receive code will echo characters,
+ *	thus calling driver write methods, the output processing functions
+ *	called here, as well as the echo processing function, also take the
+ *	output lock to protect the column state and space left in the
+ *	tty driver buffer.
  *
  *	This code must be sure never to sleep through a hangup.
  */
@@ -1977,4 +2021,3 @@ struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };
-
diff -Nurp a/drivers/char/tty_io.c b/drivers/char/tty_io.c
--- a/drivers/char/tty_io.c	2008-09-09 14:02:47.002757274 -0600
+++ b/drivers/char/tty_io.c	2008-09-09 14:07:05.592758393 -0600
@@ -1470,9 +1470,7 @@ out:
  *		Locks the line discipline as required
  *		Writes to the tty driver are serialized by the atomic_write_lock
  *	and are then processed in chunks to the device. The line discipline
- *	write method will not be involked in parallel for each device
- *		The line discipline write method is called under the big
- *	kernel lock for historical reasons. New code should not rely on this.
+ *	write method will not be involked in parallel for each device.
  */
 
 static ssize_t tty_write(struct file *file, const char __user *buf,
@@ -3343,9 +3341,10 @@ static void initialize_tty_struct(struct
 	INIT_WORK(&tty->hangup_work, do_tty_hangup);
 	mutex_init(&tty->atomic_read_lock);
 	mutex_init(&tty->atomic_write_lock);
+	mutex_init(&tty->output_lock);
+	mutex_init(&tty->echo_lock);
 	spin_lock_init(&tty->read_lock);
 	spin_lock_init(&tty->ctrl_lock);
-	spin_lock_init(&tty->echo_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
 	INIT_WORK(&tty->SAK_work, do_SAK_work);
 }
diff -Nurp a/include/linux/tty.h b/include/linux/tty.h
--- a/include/linux/tty.h	2008-09-09 14:02:47.082756223 -0600
+++ b/include/linux/tty.h	2008-09-09 14:07:05.612756690 -0600
@@ -267,10 +267,11 @@ struct tty_struct {
 	unsigned int canon_column;
 	struct mutex atomic_read_lock;
 	struct mutex atomic_write_lock;
+	struct mutex output_lock;
+	struct mutex echo_lock;
 	unsigned char *write_buf;
 	int write_cnt;
 	spinlock_t read_lock;
-	spinlock_t echo_lock;
 	/* If the tty has a pending do_SAK, queue it here - akpm */
 	struct work_struct SAK_work;
 	struct tty_port *port;

--------------020203010201020508090600--
