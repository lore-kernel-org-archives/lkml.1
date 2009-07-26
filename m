Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194AbZGZMGA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194AbZGZMGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 08:06:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbZGZMGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 08:06:00 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:47155 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbZGZMF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 08:05:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
Date: Sun, 26 Jul 2009 20:51:37 +0900
In-Reply-To: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Sat, 25 Jul 2009 16:32:51 +0100")
Message-ID: <87bpn7mzli.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> Good to know the initial fix works. To actually do it cleanly probably
> wants a way to pass a logical channel close through the tty layer which
> isn't I think too hard
>
> 	set a new TTY_OTHER_CLOSING in the pty code
> 	set TTY_OTHER_CLOSED in the flip_buffer_push code if we empty the
> 	buffer queue and TTY_OTHER_CLOSING is set.
>
> That would also avoid using tty->low_latency=1 in the pty layer which I
> worry may harm PPP gateway performance and the like.

I see. It sounds like good thing. The attached patch or something?
Anyway, I'm not familiar with the tty stuff obviously, so, I'm not sure
whether this patch is right or not.

If needed, I'll test the new patch.

Thanks.


Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 drivers/char/pty.c        |   19 ++++++++++++++++---
 drivers/char/tty_buffer.c |   28 ++++++++++++++++++++++++++--
 include/linux/tty.h       |   13 +++++++------
 3 files changed, 49 insertions(+), 11 deletions(-)

diff -puN drivers/char/pty.c~pty-fixes2 drivers/char/pty.c
--- linux-2.6/drivers/char/pty.c~pty-fixes2	2009-07-26 20:04:17.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/pty.c	2009-07-26 20:06:17.000000000 +0900
@@ -51,11 +51,19 @@ static void pty_close(struct tty_struct 
 	tty->packet = 0;
 	if (!tty->link)
 		return;
-	tty->link->packet = 0;
+
+	/*
+	 * This try to flush pending tty->buf. And after flushed all
+	 * pending tty->buf, TTY_OTHER_CLOSED will be set.
+	 */
+	set_bit(TTY_OTHER_CLOSING, &tty->link->flags);
 	tty_flip_buffer_push(tty->link);
+#if 0
+	tty->link->packet = 0;
 	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
 	wake_up_interruptible(&tty->link->read_wait);
 	wake_up_interruptible(&tty->link->write_wait);
+#endif
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
 #ifdef CONFIG_UNIX98_PTYS
@@ -199,17 +207,22 @@ static int pty_open(struct tty_struct *t
 		goto out;
 
 	retval = -EIO;
-	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
+	if (test_bit(TTY_OTHER_CLOSING, &tty->flags) ||
+	    test_bit(TTY_OTHER_CLOSED, &tty->flags))
 		goto out;
 	if (test_bit(TTY_PTY_LOCK, &tty->link->flags))
 		goto out;
 	if (tty->link->count != 1)
 		goto out;
 
+	spin_lock_irq(&tty->link->buf.lock);
+	clear_bit(TTY_OTHER_CLOSING, &tty->link->flags);
 	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
+	spin_unlock_irq(&tty->link->buf.lock);
+
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
-	tty->low_latency = 1;
+//	tty->low_latency = 1;
 out:
 	return retval;
 }
diff -puN drivers/char/tty_buffer.c~pty-fixes2 drivers/char/tty_buffer.c
--- linux-2.6/drivers/char/tty_buffer.c~pty-fixes2	2009-07-26 20:04:17.000000000 +0900
+++ linux-2.6-hirofumi/drivers/char/tty_buffer.c	2009-07-26 20:04:46.000000000 +0900
@@ -74,6 +74,20 @@ static struct tty_buffer *tty_buffer_all
 	return p;
 }
 
+/* must hold tty->buf.lock */
+static void tty_check_other_closing(struct tty_struct *tty)
+{
+	if (test_bit(TTY_OTHER_CLOSING, &tty->flags)) {
+		printk("%s: tty %p, closed\n", __func__, tty);
+		tty->link->packet = 0;
+		set_bit(TTY_OTHER_CLOSED, &tty->flags);
+		wake_up_interruptible(&tty->read_wait);
+		wake_up_interruptible(&tty->write_wait);
+		/* Clear TTY_OTHER_CLOSING after set TTY_OTHER_CLOSED */
+		clear_bit(TTY_OTHER_CLOSING, &tty->flags);
+	}
+}
+
 /**
  *	tty_buffer_free		-	free a tty buffer
  *	@tty: tty owning the buffer
@@ -119,6 +133,7 @@ static void __tty_buffer_flush(struct tt
 		tty_buffer_free(tty, thead);
 	}
 	tty->buf.tail = NULL;
+	tty_check_other_closing(tty);
 }
 
 /**
@@ -407,8 +422,12 @@ static void flush_to_ldisc(struct work_s
 	unsigned char *flag_buf;
 
 	disc = tty_ldisc_ref(tty);
-	if (disc == NULL)	/*  !TTY_LDISC */
+	if (disc == NULL) {	/*  !TTY_LDISC */
+		spin_lock_irqsave(&tty->buf.lock, flags);
+		tty_check_other_closing(tty);
+		spin_unlock_irqrestore(&tty->buf.lock, flags);
 		return;
+	}
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
 	/* So we know a flush is running */
@@ -419,8 +438,11 @@ static void flush_to_ldisc(struct work_s
 		for (;;) {
 			int count = head->commit - head->read;
 			if (!count) {
-				if (head->next == NULL)
+				if (head->next == NULL) {
+					printk("%s: tty %p, next == NULL\n", __func__, tty);
+					tty_check_other_closing(tty);
 					break;
+				}
 				tbuf = head;
 				head = head->next;
 				tty_buffer_free(tty, tbuf);
@@ -448,9 +470,11 @@ static void flush_to_ldisc(struct work_s
 		/* Restore the queue head */
 		tty->buf.head = head;
 	}
+
 	/* We may have a deferred request to flush the input buffer,
 	   if so pull the chain under the lock and empty the queue */
 	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
+		printk("%s: tty %p, flushing\n", __func__, tty);
 		__tty_buffer_flush(tty);
 		clear_bit(TTY_FLUSHPENDING, &tty->flags);
 		wake_up(&tty->read_wait);
diff -puN include/linux/tty.h~pty-fixes2 include/linux/tty.h
--- linux-2.6/include/linux/tty.h~pty-fixes2	2009-07-26 20:04:17.000000000 +0900
+++ linux-2.6-hirofumi/include/linux/tty.h	2009-07-26 20:04:17.000000000 +0900
@@ -309,12 +309,13 @@ struct tty_struct {
  */
 #define TTY_THROTTLED 		0	/* Call unthrottle() at threshold min */
 #define TTY_IO_ERROR 		1	/* Cause an I/O error (may be no ldisc too) */
-#define TTY_OTHER_CLOSED 	2	/* Other side (if any) has closed */
-#define TTY_EXCLUSIVE 		3	/* Exclusive open mode */
-#define TTY_DEBUG 		4	/* Debugging */
-#define TTY_DO_WRITE_WAKEUP 	5	/* Call write_wakeup after queuing new */
-#define TTY_PUSH 		6	/* n_tty private */
-#define TTY_CLOSING 		7	/* ->close() in progress */
+#define TTY_OTHER_CLOSING 	2	/* Other side (if any) is closing */
+#define TTY_OTHER_CLOSED 	3	/* Other side (if any) has closed */
+#define TTY_EXCLUSIVE 		4	/* Exclusive open mode */
+#define TTY_DEBUG 		5	/* Debugging */
+#define TTY_DO_WRITE_WAKEUP 	6	/* Call write_wakeup after queuing new */
+#define TTY_PUSH 		7	/* n_tty private */
+#define TTY_CLOSING 		8	/* ->close() in progress */
 #define TTY_LDISC 		9	/* Line discipline attached */
 #define TTY_LDISC_CHANGING 	10	/* Line discipline changing */
 #define TTY_LDISC_OPEN	 	11	/* Line discipline is open */
_
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
