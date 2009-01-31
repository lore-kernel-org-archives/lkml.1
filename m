Return-Path: <linux-kernel-owner+w=401wt.eu-S1759499AbZAaD1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499AbZAaD1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 22:27:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756639AbZAaDZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 22:25:40 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:34941 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbZAaDZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 22:25:38 -0500
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>
Date: Fri, 30 Jan 2009 19:25:14 -0800
Subject: [patch 7/7] epoll keyed wakeups - make tty use keyed wakeups
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.16376.1233372320.7>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch introduces keyed event wakeups inside the TTY code.


Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


---
 drivers/char/tty_io.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-2.6.mod/drivers/char/tty_io.c
===================================================================
--- linux-2.6.mod.orig/drivers/char/tty_io.c	2009-01-30 12:31:25.000000000 -0800
+++ linux-2.6.mod/drivers/char/tty_io.c	2009-01-30 12:34:04.000000000 -0800
@@ -464,7 +464,7 @@ void tty_wakeup(struct tty_struct *tty)
 			tty_ldisc_deref(ld);
 		}
 	}
-	wake_up_interruptible(&tty->write_wait);
+	kwake_up_interruptible(&tty->write_wait, POLLOUT);
 }
 
 EXPORT_SYMBOL_GPL(tty_wakeup);
@@ -587,8 +587,8 @@ static void do_tty_hangup(struct work_st
 	 * FIXME: Once we trust the LDISC code better we can wait here for
 	 * ldisc completion and fix the driver call race
 	 */
-	wake_up_interruptible(&tty->write_wait);
-	wake_up_interruptible(&tty->read_wait);
+	kwake_up_interruptible(&tty->write_wait, POLLOUT);
+	kwake_up_interruptible(&tty->read_wait, POLLIN);
 	/*
 	 * Shutdown the current line discipline, and reset it to
 	 * N_TTY.
@@ -879,7 +879,7 @@ void stop_tty(struct tty_struct *tty)
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_START;
 		tty->ctrl_status |= TIOCPKT_STOP;
-		wake_up_interruptible(&tty->link->read_wait);
+		kwake_up_interruptible(&tty->link->read_wait, POLLIN);
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->ops->stop)
@@ -913,7 +913,7 @@ void start_tty(struct tty_struct *tty)
 	if (tty->link && tty->link->packet) {
 		tty->ctrl_status &= ~TIOCPKT_STOP;
 		tty->ctrl_status |= TIOCPKT_START;
-		wake_up_interruptible(&tty->link->read_wait);
+		kwake_up_interruptible(&tty->link->read_wait, POLLIN);
 	}
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 	if (tty->ops->start)
@@ -970,7 +970,7 @@ static ssize_t tty_read(struct file *fil
 void tty_write_unlock(struct tty_struct *tty)
 {
 	mutex_unlock(&tty->atomic_write_lock);
-	wake_up_interruptible(&tty->write_wait);
+	kwake_up_interruptible(&tty->write_wait, POLLOUT);
 }
 
 int tty_write_lock(struct tty_struct *tty, int ndelay)
@@ -1623,21 +1623,21 @@ void tty_release_dev(struct file *filp)
 
 		if (tty_closing) {
 			if (waitqueue_active(&tty->read_wait)) {
-				wake_up(&tty->read_wait);
+				kwake_up(&tty->read_wait, POLLIN);
 				do_sleep++;
 			}
 			if (waitqueue_active(&tty->write_wait)) {
-				wake_up(&tty->write_wait);
+				kwake_up(&tty->write_wait, POLLOUT);
 				do_sleep++;
 			}
 		}
 		if (o_tty_closing) {
 			if (waitqueue_active(&o_tty->read_wait)) {
-				wake_up(&o_tty->read_wait);
+				kwake_up(&o_tty->read_wait, POLLIN);
 				do_sleep++;
 			}
 			if (waitqueue_active(&o_tty->write_wait)) {
-				wake_up(&o_tty->write_wait);
+				kwake_up(&o_tty->write_wait, POLLOUT);
 				do_sleep++;
 			}
 		}

