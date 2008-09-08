Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbYIHQL6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbYIHQL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 12:11:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752389AbYIHQLu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 12:11:50 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:33529 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080AbYIHQLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 12:11:49 -0400
Message-ID: <48C54EC2.4060901@skyrush.com>
Date: Mon, 08 Sep 2008 10:11:46 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080727)
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] TTY: Fix loss of echoed characters (2nd follow-on PATCH
 attached)
References: <200807252257.m6PMvieO003213@imap1.linux-foundation.org> <48AC3A16.4080209@skyrush.com> <48B3F9F7.2050503@skyrush.com>
In-Reply-To: <48B3F9F7.2050503@skyrush.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------080305070203090000080803"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080305070203090000080803
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here is another follow-on patch.  It gets applied after and probably
should be consolidated (for final submission) with the following two:

	tty-fix-loss-of-echoed-characters.patch
	tty-minor-code-efficiency-and-style-cleanup.patch

This one fixes handling of some tab erasure cases and also improves
locking for the echo buffer.

						Thanks, Joe

--------------080305070203090000080803
Content-Type: text/plain;
 name="tty-fix-echo-tab-erase-and-locking.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="tty-fix-echo-tab-erase-and-locking.patch"

1) Fix tab erasure handling
2) Improve locking when working with the echo buffer

Tab erasure handling is now more robust and able to handle non-zero
canon column cases more correctly.  This is done by making correct use
of what is known in the eraser function (read buffer contents) and what
is known at the time of processing the tab erasure (column state).

Also, better locking of the echo buffer will now prevent any attempts to
process partial multi-byte echo operations.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

--- linux/drivers/char/n_tty.c.orig	2008-08-25 16:43:40.000000000 -0600
+++ linux/drivers/char/n_tty.c	2008-09-08 08:34:10.000000000 -0600
@@ -71,7 +71,7 @@
 #define ECHO_OP_START 0xff
 #define ECHO_OP_MOVE_BACK_COL 0x80
 #define ECHO_OP_SET_CANON_COL 0x81
-#define ECHO_OP_TAB_ERASE 0x82
+#define ECHO_OP_ERASE_TAB 0x82
 
 static inline unsigned char *alloc_buf(void)
 {
@@ -474,14 +474,11 @@ break_out:
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
+ *	This locks against other functions that alter the echo buffer.
+ *	And like the process_output functions, it also relies on lock_kernel.
+ *	If lock_kernel is ever removed, we need to provide an alternate means
+ *	to protect the tty->column state as well as to prevent the splitting
+ *	of control character pairs by other output.
  */
 
 static void process_echoes(struct tty_struct *tty)
@@ -489,10 +486,12 @@ static void process_echoes(struct tty_st
 	int	space, nr;
 	unsigned char c;
 	unsigned char *cp, *buf_end;
+	unsigned long flags;
 
 	if (!tty->echo_cnt)
 		return;
 
+	spin_lock_irqsave(&tty->echo_lock, flags);
 	lock_kernel();
 
 	space = tty_write_room(tty);
@@ -518,44 +517,39 @@ static void process_echoes(struct tty_st
 			op = *opp;
 			
 			switch (op) {
-				unsigned char lbyte, hbyte;
-				unsigned short rdiff;
-				int num_bs;
-				unsigned int col;
+				unsigned int num_chars, num_bs;
 
-			case ECHO_OP_TAB_ERASE:
-				/* Extract rdiff value from next two bytes */
+			case ECHO_OP_ERASE_TAB:
 				if (++opp == buf_end)
 					opp -= N_TTY_BUF_SIZE;
-				lbyte = *opp;
-				if (++opp == buf_end)
-					opp -= N_TTY_BUF_SIZE;
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
@@ -647,6 +641,7 @@ static void process_echoes(struct tty_st
 	}
 
 	unlock_kernel();
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
 
 	if (tty->ops->flush_chars)
 		tty->ops->flush_chars(tty);
@@ -663,9 +658,6 @@ static void process_echoes(struct tty_st
 static void add_echo_byte(unsigned char c, struct tty_struct *tty)
 {
 	int	new_byte_pos;
-	unsigned long flags;
-
-	spin_lock_irqsave(&tty->echo_lock, flags);
 
 	if (tty->echo_cnt == N_TTY_BUF_SIZE) {
 		/* Circular buffer is already at capacity */
@@ -679,9 +671,9 @@ static void add_echo_byte(unsigned char 
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
@@ -699,8 +691,6 @@ static void add_echo_byte(unsigned char 
 	}
 
 	tty->echo_buf[new_byte_pos] = c;
-
-	spin_unlock_irqrestore(&tty->echo_lock, flags);
 }
 
 /**
@@ -712,8 +702,14 @@ static void add_echo_byte(unsigned char 
 
 static void echo_move_back_col(struct tty_struct *tty)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->echo_lock, flags);
+
 	add_echo_byte(ECHO_OP_START, tty);
 	add_echo_byte(ECHO_OP_MOVE_BACK_COL, tty);
+
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
 }
 
 /**
@@ -726,24 +722,51 @@ static void echo_move_back_col(struct tt
 
 static void echo_set_canon_col(struct tty_struct *tty)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->echo_lock, flags);
+
 	add_echo_byte(ECHO_OP_START, tty);
 	add_echo_byte(ECHO_OP_SET_CANON_COL, tty);
+
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
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
  */
 
-static void echo_tab_erase(unsigned short rdiff, struct tty_struct *tty)
+static void echo_erase_tab(unsigned int num_chars, int after_tab,
+			   struct tty_struct *tty)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->echo_lock, flags);
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
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
 }
 
 /**
@@ -759,12 +782,18 @@ static void echo_tab_erase(unsigned shor
 
 static void echo_char_raw(unsigned char c, struct tty_struct *tty)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->echo_lock, flags);
+
 	if (c == ECHO_OP_START) {
 		add_echo_byte(ECHO_OP_START, tty);
 		add_echo_byte(ECHO_OP_START, tty);
 	} else {
 		add_echo_byte(c, tty);
 	}
+
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
 }
 
 /**
@@ -781,9 +810,20 @@ static void echo_char_raw(unsigned char 
 
 static void echo_char(unsigned char c, struct tty_struct *tty)
 {
-	if (iscntrl(c) && c != '\t')
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->echo_lock, flags);
+
+	if (c == ECHO_OP_START) {
 		add_echo_byte(ECHO_OP_START, tty);
-	echo_char_raw(c, tty);
+		add_echo_byte(ECHO_OP_START, tty);
+	} else {
+		if (iscntrl(c) && c != '\t')
+			add_echo_byte(ECHO_OP_START, tty);
+		add_echo_byte(c, tty);
+	}
+
+	spin_unlock_irqrestore(&tty->echo_lock, flags);
 }
 
 static inline void finish_erasing(struct tty_struct *tty)
@@ -885,28 +925,32 @@ static void eraser(unsigned char c, stru
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

--------------080305070203090000080803--
