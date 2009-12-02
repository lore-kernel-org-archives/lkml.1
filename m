Return-Path: <linux-kernel-owner+w=401wt.eu-S1755389AbZLBRTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389AbZLBRTU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755236AbZLBRTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:19:19 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:42314 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754864AbZLBRTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:19:12 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Wed,  2 Dec 2009 18:18:43 +0100
Message-Id: <1259774329-29663-6-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1259774329-29663-5-git-send-email-giometti@linux.it>
References: <1259774329-29663-1-git-send-email-giometti@linux.it>
 <1259774329-29663-2-git-send-email-giometti@linux.it>
 <1259774329-29663-3-git-send-email-giometti@linux.it>
 <1259774329-29663-4-git-send-email-giometti@linux.it>
 <1259774329-29663-5-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 05/11] ldisc n_tty: export all N_TTY ldisc methods.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/char/n_tty.c |   31 +++++++++++++++++++++----------
 include/linux/tty.h  |   16 ++++++++++++++++
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index 2e50f4d..88733c5 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -48,6 +48,7 @@
 #include <linux/audit.h>
 #include <linux/file.h>
 #include <linux/uaccess.h>
+#include <linux/module.h>
 
 #include <asm/system.h>
 
@@ -193,7 +194,7 @@ static void reset_buffer_flags(struct tty_struct *tty)
  *	Locking: ctrl_lock, read_lock.
  */
 
-static void n_tty_flush_buffer(struct tty_struct *tty)
+void n_tty_flush_buffer(struct tty_struct *tty)
 {
 	unsigned long flags;
 	/* clear everything and unthrottle the driver */
@@ -209,6 +210,7 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 }
+EXPORT_SYMBOL_GPL(n_tty_flush_buffer);
 
 /**
  *	n_tty_chars_in_buffer	-	report available bytes
@@ -220,7 +222,7 @@ static void n_tty_flush_buffer(struct tty_struct *tty)
  *	Locking: read_lock
  */
 
-static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
+ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 {
 	unsigned long flags;
 	ssize_t n = 0;
@@ -236,6 +238,7 @@ static ssize_t n_tty_chars_in_buffer(struct tty_struct *tty)
 	spin_unlock_irqrestore(&tty->read_lock, flags);
 	return n;
 }
+EXPORT_SYMBOL_GPL(n_tty_chars_in_buffer);
 
 /**
  *	is_utf8_continuation	-	utf8 multibyte check
@@ -1329,11 +1332,12 @@ handle_newline:
  *	IO must be woken up
  */
 
-static void n_tty_write_wakeup(struct tty_struct *tty)
+void n_tty_write_wakeup(struct tty_struct *tty)
 {
 	if (tty->fasync && test_and_clear_bit(TTY_DO_WRITE_WAKEUP, &tty->flags))
 		kill_fasync(&tty->fasync, SIGIO, POLL_OUT);
 }
+EXPORT_SYMBOL_GPL(n_tty_write_wakeup);
 
 /**
  *	n_tty_receive_buf	-	data receive
@@ -1348,7 +1352,7 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
 
-static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			      char *fp, int count)
 {
 	const unsigned char *p;
@@ -1422,6 +1426,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
 		tty_throttle(tty);
 }
+EXPORT_SYMBOL_GPL(n_tty_receive_buf);
 
 int is_ignored(int sig)
 {
@@ -1443,7 +1448,7 @@ int is_ignored(int sig)
  *	Locking: Caller holds tty->termios_mutex
  */
 
-static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
+void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
 	int canon_change = 1;
 	BUG_ON(!tty);
@@ -1522,6 +1527,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
 }
+EXPORT_SYMBOL_GPL(n_tty_set_termios);
 
 /**
  *	n_tty_close		-	close the ldisc for this tty
@@ -1533,7 +1539,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
  *	ldisc methods are in progress.
  */
 
-static void n_tty_close(struct tty_struct *tty)
+void n_tty_close(struct tty_struct *tty)
 {
 	n_tty_flush_buffer(tty);
 	if (tty->read_buf) {
@@ -1545,6 +1551,7 @@ static void n_tty_close(struct tty_struct *tty)
 		tty->echo_buf = NULL;
 	}
 }
+EXPORT_SYMBOL_GPL(n_tty_close);
 
 /**
  *	n_tty_open		-	open an ldisc
@@ -1556,7 +1563,7 @@ static void n_tty_close(struct tty_struct *tty)
  *	until a close.
  */
 
-static int n_tty_open(struct tty_struct *tty)
+int n_tty_open(struct tty_struct *tty)
 {
 	if (!tty)
 		return -EINVAL;
@@ -1580,6 +1587,7 @@ static int n_tty_open(struct tty_struct *tty)
 	tty->closing = 0;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(n_tty_open);
 
 static inline int input_available_p(struct tty_struct *tty, int amt)
 {
@@ -1695,7 +1703,7 @@ static int job_control(struct tty_struct *tty, struct file *file)
  *	This code must be sure never to sleep through a hangup.
  */
 
-static ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
+ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
 			 unsigned char __user *buf, size_t nr)
 {
 	unsigned char __user *b = buf;
@@ -1895,6 +1903,7 @@ do_it_again:
 	n_tty_set_room(tty);
 	return retval;
 }
+EXPORT_SYMBOL_GPL(n_tty_read);
 
 /**
  *	n_tty_write		-	write function for tty
@@ -1918,7 +1927,7 @@ do_it_again:
  *		  lock themselves)
  */
 
-static ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
+ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
 			   const unsigned char *buf, size_t nr)
 {
 	const unsigned char *b = buf;
@@ -1995,6 +2004,7 @@ break_out:
 		set_bit(TTY_DO_WRITE_WAKEUP, &tty->flags);
 	return (b - buf) ? b - buf : retval;
 }
+EXPORT_SYMBOL_GPL(n_tty_write);
 
 /**
  *	n_tty_poll		-	poll method for N_TTY
@@ -2010,7 +2020,7 @@ break_out:
  *	Called without the kernel lock held - fine
  */
 
-static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
+unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 							poll_table *wait)
 {
 	unsigned int mask = 0;
@@ -2037,6 +2047,7 @@ static unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;
 }
+EXPORT_SYMBOL_GPL(n_tty_poll);
 
 static unsigned long inq_canon(struct tty_struct *tty)
 {
diff --git a/include/linux/tty.h b/include/linux/tty.h
index f0f43d0..e5217db 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -13,6 +13,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
+#include <linux/poll.h>
 
 #include <asm/system.h>
 
@@ -482,6 +483,21 @@ extern void tty_ldisc_begin(void);
 /* This last one is just for the tty layer internals and shouldn't be used elsewhere */
 extern void tty_ldisc_enable(struct tty_struct *tty);
 
+extern void n_tty_flush_buffer(struct tty_struct *tty);
+extern ssize_t n_tty_chars_in_buffer(struct tty_struct *tty);
+extern void n_tty_write_wakeup(struct tty_struct *tty);
+extern void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
+			char *fp, int count);
+extern void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old);
+extern void n_tty_close(struct tty_struct *tty);
+extern int n_tty_open(struct tty_struct *tty);
+extern ssize_t n_tty_read(struct tty_struct *tty, struct file *file,
+			unsigned char __user *buf, size_t nr);
+extern ssize_t n_tty_write(struct tty_struct *tty, struct file *file,
+			const unsigned char *buf, size_t nr);
+extern unsigned int n_tty_poll(struct tty_struct *tty, struct file *file,
+			poll_table *wait);
+
 
 /* n_tty.c */
 extern struct tty_ldisc_ops tty_ldisc_N_TTY;
-- 
1.6.3.3

