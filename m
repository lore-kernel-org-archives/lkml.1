Return-Path: <linux-kernel-owner+w=401wt.eu-S1759763AbYJEQbJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759763AbYJEQbJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:31:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbYJEQWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:22:53 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57975 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759028AbYJEQWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:22:51 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 64/76] tty: some ICANON magic is in the wrong places
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:22:52 +0100
Message-ID: <20081005162243.1997.28686.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the set up on ldisc change into the ldisc
Move the INQ/OUTQ cases into the driver not in shared ioctl code where it
gives bogus answers for other ldisc values

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/bluetooth/hci_ldisc.c |    2 +-
 drivers/char/n_hdlc.c         |    2 +-
 drivers/char/n_tty.c          |   53 +++++++++++++++++++++++++++++++++++++++--
 drivers/char/tty_ioctl.c      |   42 ++------------------------------
 include/linux/tty.h           |    2 +-
 5 files changed, 56 insertions(+), 45 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 8dfcf77..4426bb5 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -484,7 +484,7 @@ static int hci_uart_tty_ioctl(struct tty_struct *tty, struct file * file,
 		return -EUNATCH;
 
 	default:
-		err = n_tty_ioctl(tty, file, cmd, arg);
+		err = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
 	};
 
diff --git a/drivers/char/n_hdlc.c b/drivers/char/n_hdlc.c
index 69ec639..bacb3e2 100644
--- a/drivers/char/n_hdlc.c
+++ b/drivers/char/n_hdlc.c
@@ -764,7 +764,7 @@ static int n_hdlc_tty_ioctl(struct tty_struct *tty, struct file *file,
 		break;
 
 	default:
-		error = n_tty_ioctl (tty, file, cmd, arg);
+		error = n_tty_ioctl_helper(tty, file, cmd, arg);
 		break;
 	}
 	return error;
diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 708c2b1..b4f5dcc 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1011,8 +1011,20 @@ int is_ignored(int sig)
 
 static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	if (!tty)
-		return;
+	int canon_change = 1;
+	BUG_ON(!tty);
+
+	if (old)
+		canon_change = (old->c_lflag ^ tty->termios->c_lflag) & ICANON;
+	if (canon_change) {
+		memset(&tty->read_flags, 0, sizeof tty->read_flags);
+		tty->canon_head = tty->read_tail;
+		tty->canon_data = 0;
+		tty->erasing = 0;
+	}
+
+	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
+		wake_up_interruptible(&tty->read_wait);
 
 	tty->icanon = (L_ICANON(tty) != 0);
 	if (test_bit(TTY_HW_COOK_IN, &tty->flags)) {
@@ -1573,6 +1585,43 @@ static unsigned int normal_poll(struct tty_struct *tty, struct file *file,
 	return mask;
 }
 
+static unsigned long inq_canon(struct tty_struct *tty)
+{
+	int nr, head, tail;
+
+	if (!tty->canon_data || !tty->read_buf)
+		return 0;
+	head = tty->canon_head;
+	tail = tty->read_tail;
+	nr = (head - tail) & (N_TTY_BUF_SIZE-1);
+	/* Skip EOF-chars.. */
+	while (head != tail) {
+		if (test_bit(tail, tty->read_flags) &&
+		    tty->read_buf[tail] == __DISABLED_CHAR)
+			nr--;
+		tail = (tail+1) & (N_TTY_BUF_SIZE-1);
+	}
+	return nr;
+}
+
+static int n_tty_ioctl(struct tty_struct *tty, struct file *file,
+		       unsigned int cmd, unsigned long arg)
+{
+	int retval;
+
+	switch (cmd) {
+	case TIOCOUTQ:
+		return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
+	case TIOCINQ:
+		retval = tty->read_cnt;
+		if (L_ICANON(tty))
+			retval = inq_canon(tty);
+		return put_user(retval, (unsigned int __user *) arg);
+	default:
+		return n_tty_ioctl_helper(tty, file, cmd, arg);
+	}
+}
+
 struct tty_ldisc_ops tty_ldisc_N_TTY = {
 	.magic           = TTY_LDISC_MAGIC,
 	.name            = "n_tty",
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 14cc19c..a408c8e 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -489,7 +489,6 @@ EXPORT_SYMBOL(tty_termios_hw_change);
 
 static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 {
-	int canon_change;
 	struct ktermios old_termios;
 	struct tty_ldisc *ld;
 	unsigned long flags;
@@ -505,18 +504,6 @@ static void change_termios(struct tty_struct *tty, struct ktermios *new_termios)
 	old_termios = *tty->termios;
 	*tty->termios = *new_termios;
 	unset_locked_termios(tty->termios, &old_termios, tty->termios_locked);
-	canon_change = (old_termios.c_lflag ^ tty->termios->c_lflag) & ICANON;
-	if (canon_change) {
-		memset(&tty->read_flags, 0, sizeof tty->read_flags);
-		tty->canon_head = tty->read_tail;
-		tty->canon_data = 0;
-		tty->erasing = 0;
-	}
-
-	/* This bit should be in the ldisc code */
-	if (canon_change && !L_ICANON(tty) && tty->read_cnt)
-		/* Get characters left over from canonical mode. */
-		wake_up_interruptible(&tty->read_wait);
 
 	/* See if packet mode change of state. */
 	if (tty->link && tty->link->packet) {
@@ -677,24 +664,6 @@ static int set_termiox(struct tty_struct *tty, void __user *arg, int opt)
 
 #endif
 
-static unsigned long inq_canon(struct tty_struct *tty)
-{
-	int nr, head, tail;
-
-	if (!tty->canon_data || !tty->read_buf)
-		return 0;
-	head = tty->canon_head;
-	tail = tty->read_tail;
-	nr = (head - tail) & (N_TTY_BUF_SIZE-1);
-	/* Skip EOF-chars.. */
-	while (head != tail) {
-		if (test_bit(tail, tty->read_flags) &&
-		    tty->read_buf[tail] == __DISABLED_CHAR)
-			nr--;
-		tail = (tail+1) & (N_TTY_BUF_SIZE-1);
-	}
-	return nr;
-}
 
 #ifdef TIOCGETP
 /*
@@ -1110,7 +1079,7 @@ int tty_perform_flush(struct tty_struct *tty, unsigned long arg)
 }
 EXPORT_SYMBOL_GPL(tty_perform_flush);
 
-int n_tty_ioctl(struct tty_struct *tty, struct file *file,
+int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg)
 {
 	unsigned long flags;
@@ -1148,13 +1117,6 @@ int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		return 0;
 	case TCFLSH:
 		return tty_perform_flush(tty, arg);
-	case TIOCOUTQ:
-		return put_user(tty_chars_in_buffer(tty), (int __user *) arg);
-	case TIOCINQ:
-		retval = tty->read_cnt;
-		if (L_ICANON(tty))
-			retval = inq_canon(tty);
-		return put_user(retval, (unsigned int __user *) arg);
 	case TIOCPKT:
 	{
 		int pktmode;
@@ -1180,4 +1142,4 @@ int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		return tty_mode_ioctl(tty, file, cmd, arg);
 	}
 }
-EXPORT_SYMBOL(n_tty_ioctl);
+EXPORT_SYMBOL(n_tty_ioctl_helper);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 3c7c757..3b8121d 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -466,7 +466,7 @@ static inline void tty_audit_push_task(struct task_struct *tsk,
 #endif
 
 /* tty_ioctl.c */
-extern int n_tty_ioctl(struct tty_struct *tty, struct file *file,
+extern int n_tty_ioctl_helper(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
 
 /* serial.c */

