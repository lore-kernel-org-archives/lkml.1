Return-Path: <linux-kernel-owner+w=401wt.eu-S1760456AbXKAL0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760456AbXKAL0N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 07:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756473AbXKALZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 07:25:58 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:2044 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756322AbXKALZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 07:25:57 -0400
X-Greylist: delayed 1819 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2007 07:25:57 EDT
Message-id: <14457172322573118772.slaby@karneval.cz>
Subject: [RFC 1/2] Char: tty, centralize works
From: Jiri Slaby <jirislaby@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <linux-kernel@vger.kernel.org>
Date: Thu,  1 Nov 2007 11:55:14 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

UNTESTED so far, I want to know you opinion.

--

tty, centralize works

Schedule only one work for all works, use set_bit/test_and_clear_bit as a
logic. This is because of patch which would add yet another work for
scheduled wakeups. Now it is sufficient to add 3 lines of code.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
commit 1ce760b56883d3c99b914266bca939f8d3ade1fd
tree 5767d113dd80da1ec5acf233fa47fee3398f74b3
parent f87566db6dd9613dde8de59380cd2f423166511e
author Jiri Slaby <jirislaby@gmail.com> Thu, 01 Nov 2007 10:55:42 +0100
committer Jiri Slaby <jirislaby@gmail.com> Thu, 01 Nov 2007 10:55:42 +0100

 drivers/char/tty_io.c |   37 +++++++++++++++++++++----------------
 include/linux/tty.h   |    4 +++-
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 13a5357..0eb979d 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -110,6 +110,9 @@
 #define TTY_PARANOIA_CHECK 1
 #define CHECK_TTY_COUNT 1
 
+#define TTY_WORK_HANGUP		1
+#define TTY_WORK_SAK		2
+
 struct ktermios tty_std_termios = {	/* for the benefit of tty drivers  */
 	.c_iflag = ICRNL | IXON,
 	.c_oflag = OPOST | ONLCR,
@@ -1331,7 +1334,7 @@ static void tty_reset_termios(struct tty_struct *tty)
 	
 /**
  *	do_tty_hangup		-	actual handler for hangup events
- *	@work: tty device
+ *	@tty: tty device
  *
  *	This can be called by the "eventd" kernel thread.  That is process
  *	synchronous but doesn't hold any locks, so we need to make sure we
@@ -1351,10 +1354,8 @@ static void tty_reset_termios(struct tty_struct *tty)
  *		  tasklist_lock to walk task list for hangup event
  *		    ->siglock to protect ->signal/->sighand
  */
-static void do_tty_hangup(struct work_struct *work)
+static void do_tty_hangup(struct tty_struct *tty)
 {
-	struct tty_struct *tty =
-		container_of(work, struct tty_struct, hangup_work);
 	struct file * cons_filp = NULL;
 	struct file *filp, *f = NULL;
 	struct task_struct *p;
@@ -1493,7 +1494,8 @@ void tty_hangup(struct tty_struct * tty)
 	
 	printk(KERN_DEBUG "%s hangup...\n", tty_name(tty, buf));
 #endif
-	schedule_work(&tty->hangup_work);
+	set_bit(TTY_WORK_HANGUP, tty->work_todo);
+	schedule_work(&tty->work);
 }
 
 EXPORT_SYMBOL(tty_hangup);
@@ -1514,7 +1516,7 @@ void tty_vhangup(struct tty_struct * tty)
 
 	printk(KERN_DEBUG "%s vhangup...\n", tty_name(tty, buf));
 #endif
-	do_tty_hangup(&tty->hangup_work);
+	do_tty_hangup(tty);
 }
 EXPORT_SYMBOL(tty_vhangup);
 
@@ -3573,13 +3575,6 @@ void __do_SAK(struct tty_struct *tty)
 #endif
 }
 
-static void do_SAK_work(struct work_struct *work)
-{
-	struct tty_struct *tty =
-		container_of(work, struct tty_struct, SAK_work);
-	__do_SAK(tty);
-}
-
 /*
  * The tq handling here is a little racy - tty->SAK_work may already be queued.
  * Fortunately we don't need to worry, because if ->SAK_work is already queued,
@@ -3590,11 +3585,22 @@ void do_SAK(struct tty_struct *tty)
 {
 	if (!tty)
 		return;
-	schedule_work(&tty->SAK_work);
+	set_bit(TTY_WORK_SAK, tty->work_todo);
+	schedule_work(&tty->work);
 }
 
 EXPORT_SYMBOL(do_SAK);
 
+static void tty_work(struct work_struct *work)
+{
+	struct tty_struct *tty = container_of(work, struct tty_struct, work);
+
+	if (test_and_clear_bit(TTY_WORK_HANGUP, tty->work_todo))
+		do_tty_hangup(tty);
+	if (test_and_clear_bit(TTY_WORK_SAK, tty->work_todo))
+		__do_SAK(tty);
+}
+
 /**
  *	flush_to_ldisc
  *	@work: tty structure passed from work queue.
@@ -3725,12 +3731,11 @@ static void initialize_tty_struct(struct tty_struct *tty)
 	mutex_init(&tty->termios_mutex);
 	init_waitqueue_head(&tty->write_wait);
 	init_waitqueue_head(&tty->read_wait);
-	INIT_WORK(&tty->hangup_work, do_tty_hangup);
+	INIT_WORK(&tty->work, tty_work);
 	mutex_init(&tty->atomic_read_lock);
 	mutex_init(&tty->atomic_write_lock);
 	spin_lock_init(&tty->read_lock);
 	INIT_LIST_HEAD(&tty->tty_files);
-	INIT_WORK(&tty->SAK_work, do_SAK_work);
 }
 
 /*
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 56164d7..a5828a0 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -13,6 +13,7 @@
 #include <linux/tty_driver.h>
 #include <linux/tty_ldisc.h>
 #include <linux/mutex.h>
+#include <linux/bitops.h>
 
 #include <asm/system.h>
 
@@ -208,7 +209,8 @@ struct tty_struct {
 	int alt_speed;		/* For magic substitution of 38400 bps */
 	wait_queue_head_t write_wait;
 	wait_queue_head_t read_wait;
-	struct work_struct hangup_work;
+	DECLARE_BITMAP(work_todo, 32);
+	struct work_struct work;
 	void *disc_data;
 	void *driver_data;
 	struct list_head tty_files;
