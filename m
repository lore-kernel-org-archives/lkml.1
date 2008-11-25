Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbYKYVMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbYKYVMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:12:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753260AbYKYVLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:11:34 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52581 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321AbYKYVLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:11:20 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 25 Nov 2008 22:11:08 +0100
Message-Id: <1227647470-4816-3-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227647470-4816-2-git-send-email-giometti@linux.it>
References: <>
 <1227647470-4816-1-git-send-email-giometti@linux.it>
 <1227647470-4816-2-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] ldisc n_tty: export all N_TTY ldisc methods.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/char/n_tty.c |   54 +++++++++++++++++++++++++++++--------------------
 include/linux/tty.h  |   17 ++++++++++++++-
 2 files changed, 48 insertions(+), 23 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 596c717..ac30f1e 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -26,7 +26,7 @@
  *
  * 2002/03/18   Implemented n_tty_wakeup to send SIGIO POLL_OUTs to
  *		waiting writing processes-Sapan Bhatia <sapan@corewars.org>.
- *		Also fixed a bug in BLOCKING mode where write_chan returns
+ *		Also fixed a bug in BLOCKING mode where n_tty_write returns
  *		EAGAIN
  */
 
@@ -43,10 +43,10 @@
 #include <linux/mm.h>
 #include <linux/string.h>
 #include <linux/slab.h>
-#include <linux/poll.h>
 #include <linux/bitops.h>
 #include <linux/audit.h>
 #include <linux/file.h>
+#include <linux/module.h>
 
 #include <asm/uaccess.h>
 #include <asm/system.h>
@@ -187,7 +187,7 @@ static void reset_buffer_flags(struct tty_struct *tty)
  *	lock_kernel() still.
  */
  
-static void n_tty_flush_buffer(struct tty_struct * tty)
+void n_tty_flush_buffer(struct tty_struct * tty)
 {
 	/* clear everything and unthrottle the driver */
 	reset_buffer_flags(tty);
@@ -200,6 +200,7 @@ static void n_tty_flush_buffer(struct tty_struct * tty)
 		wake_up_interruptible(&tty->link->read_wait);
 	}
 }
+EXPORT_SYMBOL(n_tty_flush_buffer);
 
 /**
  *	n_tty_chars_in_buffer	-	report available bytes
@@ -209,7 +210,7 @@ static void n_tty_flush_buffer(struct tty_struct * tty)
  *	at this instant in time. 
  */
  
-static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
+ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 {
 	unsigned long flags;
 	ssize_t n = 0;
@@ -225,6 +226,7 @@ static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 	spin_unlock_irqrestore(&tty->read_lock, flags);
 	return n;
 }
+EXPORT_SYMBOL(n_tty_chars_in_buffer);
 
 /**
  *	is_utf8_continuation	-	utf8 multibyte check
@@ -337,7 +339,7 @@ static int opost(unsigned char c, struct tty_struct *tty)
  *	the simple cases normally found and helps to generate blocks of
  *	symbols for the console driver and thus improve performance.
  *
- *	Called from write_chan under the tty layer write lock.
+ *	Called from n_tty_write under the tty layer write lock.
  */
  
 static ssize_t opost_block(struct tty_struct * tty,
@@ -883,7 +885,7 @@ send_signal:
  *	IO must be woken up
  */
 
-static void n_tty_write_wakeup(struct tty_struct *tty)
+void n_tty_write_wakeup(struct tty_struct *tty)
 {
 	if (tty->fasync)
 	{
@@ -892,6 +894,7 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
 	}
 	return;
 }
+EXPORT_SYMBOL(n_tty_write_wakeup);
 
 /**
  *	n_tty_receive_buf	-	data receive
@@ -906,7 +909,7 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
  
-static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
 	const unsigned char *p;
@@ -984,6 +987,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->driver->throttle(tty);
 	}
 }
+EXPORT_SYMBOL(n_tty_receive_buf);
 
 int is_ignored(int sig)
 {
@@ -1003,7 +1007,7 @@ int is_ignored(int sig)
  *	when the ldisc is closed.
  */
  
-static void n_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
+void n_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
 {
 	if (!tty)
 		return;
@@ -1067,6 +1071,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
 	}
 	n_tty_set_room(tty);
 }
+EXPORT_SYMBOL(n_tty_set_termios);
 
 /**
  *	n_tty_close		-	close the ldisc for this tty
@@ -1078,7 +1083,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
  *	ldisc methods are in progress.
  */
  
-static void n_tty_close(struct tty_struct *tty)
+void n_tty_close(struct tty_struct *tty)
 {
 	n_tty_flush_buffer(tty);
 	if (tty->read_buf) {
@@ -1086,6 +1091,7 @@ static void n_tty_close(struct tty_struct *tty)
 		tty->read_buf = NULL;
 	}
 }
+EXPORT_SYMBOL(n_tty_close);
 
 /**
  *	n_tty_open		-	open an ldisc
@@ -1097,7 +1103,7 @@ static void n_tty_close(struct tty_struct *tty)
  *	until a close.
  */
 
-static int n_tty_open(struct tty_struct *tty)
+int n_tty_open(struct tty_struct *tty)
 {
 	if (!tty)
 		return -EINVAL;
@@ -1116,6 +1122,7 @@ static int n_tty_open(struct tty_struct *tty)
 	tty->closing = 0;
 	return 0;
 }
+EXPORT_SYMBOL(n_tty_open);
 
 static inline int input_available_p(struct tty_struct *tty, int amt)
 {
@@ -1134,7 +1141,7 @@ static inline int input_available_p(struct tty_struct *tty, int amt)
  *	@b: user data
  *	@nr: size of data
  *
- *	Helper function to speed up read_chan.  It is only called when
+ *	Helper function to speed up n_tty_read.  It is only called when
  *	ICANON is off; it copies characters straight from the tty queue to
  *	user space directly.  It can be profitably called twice; once to
  *	drain the space from the tail pointer to the (physical) end of the
@@ -1195,7 +1202,7 @@ static int job_control(struct tty_struct *tty, struct file *file)
 	if (file->f_op->write != redirected_tty_write &&
 	    current->signal->tty == tty) {
 		if (!tty->pgrp)
-			printk("read_chan: no tty->pgrp!\n");
+			printk("n_tty_read: no tty->pgrp!\n");
 		else if (task_pgrp(current) != tty->pgrp) {
 			if (is_ignored(SIGTTIN) ||
 			    is_current_pgrp_orphaned())
@@ -1210,7 +1217,7 @@ static int job_control(struct tty_struct *tty, struct file *file)
  
 
 /**
- *	read_chan		-	read function for tty
+ *	n_tty_read		-	read function for tty
  *	@tty: tty device
  *	@file: file object
  *	@buf: userspace buffer pointer
@@ -1224,7 +1231,7 @@ static int job_control(struct tty_struct *tty, struct file *file)
  *	This code must be sure never to sleep through a hangup.
  */
  
-static ssize_t read_chan(struct tty_struct *tty, struct file *file,
+ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			 unsigned char __user *buf, size_t nr)
 {
 	unsigned char __user *b = buf;
@@ -1239,7 +1246,7 @@ static ssize_t read_chan(struct tty_struct *tty, struct file *file,
 do_it_again:
 
 	if (!tty->read_buf) {
-		printk("n_tty_read_chan: called with read_buf == NULL?!?\n");
+		printk("n_tty_read: called with read_buf == NULL?!?\n");
 		return -EIO;
 	}
 
@@ -1422,9 +1429,10 @@ do_it_again:
 
 	return retval;
 }
+EXPORT_SYMBOL(n_tty_read);
 
 /**
- *	write_chan		-	write function for tty
+ *	n_tty_write		-	write function for tty
  *	@tty: tty device
  *	@file: file object
  *	@buf: userspace buffer pointer
@@ -1438,7 +1446,7 @@ do_it_again:
  *	This code must be sure never to sleep through a hangup.
  */
  
-static ssize_t write_chan(struct tty_struct * tty, struct file * file,
+ssize_t n_tty_write(struct tty_struct * tty, struct file * file,
 			  const unsigned char * buf, size_t nr)
 {
 	const unsigned char *b = buf;
@@ -1510,9 +1518,10 @@ break_out:
 	remove_wait_queue(&tty->write_wait, &wait);
 	return (b - buf) ? b - buf : retval;
 }
+EXPORT_SYMBOL(n_tty_write);
 
 /**
- *	normal_poll		-	poll method for N_TTY
+ *	n_tty_poll		-	poll method for N_TTY
  *	@tty: terminal device
  *	@file: file accessing it
  *	@wait: poll table
@@ -1530,7 +1539,7 @@ break_out:
  *	a read wakeup to fix this bug.
  */
  
-static unsigned int normal_poll(struct tty_struct * tty, struct file * file, poll_table *wait)
+unsigned int n_tty_poll(struct tty_struct * tty, struct file * file, poll_table *wait)
 {
 	unsigned int mask = 0;
 
@@ -1556,6 +1565,7 @@ static unsigned int normal_poll(struct tty_struct * tty, struct file * file, pol
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
+EXPORT_SYMBOL(n_tty_poll);
 
 struct tty_ldisc tty_ldisc_N_TTY = {
 	.magic           = TTY_LDISC_MAGIC,
@@ -1564,11 +1574,11 @@ struct tty_ldisc tty_ldisc_N_TTY = {
 	.close           = n_tty_close,
 	.flush_buffer    = n_tty_flush_buffer,
 	.chars_in_buffer = n_tty_chars_in_buffer,
-	.read            = read_chan,
-	.write           = write_chan,
+	.read            = n_tty_read,
+	.write           = n_tty_write,
 	.ioctl           = n_tty_ioctl,
 	.set_termios     = n_tty_set_termios,
-	.poll            = normal_poll,
+	.poll            = n_tty_poll,
 	.receive_buf     = n_tty_receive_buf,
 	.write_wakeup    = n_tty_write_wakeup
 };
diff --git a/include/linux/tty.h b/include/linux/tty.h
index defd2ab..019c10b 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -13,6 +13,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>
 
 #include <asm/system.h>
 
@@ -383,7 +384,21 @@ static inline void tty_audit_opening(void)
 #endif
 
 /* tty_ioctl.c */
-extern int n_tty_ioctl(struct tty_struct * tty, struct file * file,
+extern void n_tty_flush_buffer(struct tty_struct * tty);
+extern ssize_t n_tty_chars_in_buffer(struct tty_struct *tty);
+extern void n_tty_write_wakeup(struct tty_struct *tty);
+extern void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+			char *fp, int count);
+extern void n_tty_set_termios(struct tty_struct *tty, struct ktermios * old);
+extern void n_tty_close(struct tty_struct *tty);
+extern int n_tty_open(struct tty_struct *tty);
+extern ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
+			unsigned char __user *buf, size_t nr);
+extern ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
+			const unsigned char *buf, size_t nr);
+extern unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
+			poll_table *wait);
+extern int n_tty_ioctl(struct tty_struct *tty, struct file *file,
 		       unsigned int cmd, unsigned long arg);
 
 /* serial.c */
-- 
1.5.4.3

