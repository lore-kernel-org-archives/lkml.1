Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287AbZG0K4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287AbZG0K4p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 06:56:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750962AbZG0K4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 06:56:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59806 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750779AbZG0K4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 06:56:43 -0400
Date: Mon, 27 Jul 2009 11:57:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Regression] kdesu broken
Message-ID: <20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
In-Reply-To: <87bpn7mzli.fsf@devron.myhome.or.jp>
References: <200907240145.31935.rjw@sisk.pl>
	<2c0942db0907231721q124dc8f9mdbe64ed33c69ffbf@mail.gmail.com>
	<200907241721.45943.rjw@sisk.pl>
	<20090724164058.21a054e6@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0907240930120.3960@localhost.localdomain>
	<87ws5xjo2x.fsf@devron.myhome.or.jp>
	<20090725150510.35e8854d@lxorguk.ukuu.org.uk>
	<87ab2sx15g.fsf@devron.myhome.or.jp>
	<20090725163251.50e6f546@lxorguk.ukuu.org.uk>
	<87bpn7mzli.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I see. It sounds like good thing. The attached patch or something?
> Anyway, I'm not familiar with the tty stuff obviously, so, I'm not sure
> whether this patch is right or not.

It turns out to be a little bit trickier than I thought because of open
v close v flush_to_ldisc races (some of the open/close ones being long
standing).

We now use tty->buf.lock to keep EOF/EOFPENDING/OTHER_CLOSED all in order
together. That has no real cost as we already hold the buf.lock in the hot
path which is flush_to_ldisc.

Anyway this is my current thoughts (not yet given a testing)


diff --git a/drivers/char/n_tty.c b/drivers/char/n_tty.c
index ff47907..acae995 100644
--- a/drivers/char/n_tty.c
+++ b/drivers/char/n_tty.c
@@ -1777,7 +1777,8 @@ do_it_again:
 			tty->minimum_to_wake = (minimum - (b - buf));
 
 		if (!input_available_p(tty, 0)) {
-			if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
+			if (test_bit(TTY_EOF, &tty->flags)) {
+				/* PTY pair closed and all data consumed */
 				retval = -EIO;
 				break;
 			}
diff --git a/drivers/char/pty.c b/drivers/char/pty.c
index 6e6942c..de10cc0 100644
--- a/drivers/char/pty.c
+++ b/drivers/char/pty.c
@@ -38,6 +38,9 @@ static struct tty_driver *pts_driver;
 
 static void pty_close(struct tty_struct *tty, struct file *filp)
 {
+	struct tty_struct *pair;
+	unsigned long flags;
+
 	BUG_ON(!tty);
 	if (tty->driver->subtype == PTY_TYPE_MASTER)
 		WARN_ON(tty->count > 1);
@@ -47,13 +50,22 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
 	}
 	wake_up_interruptible(&tty->read_wait);
 	wake_up_interruptible(&tty->write_wait);
+	
 	tty->packet = 0;
-	if (!tty->link)
+	pair = tty->link;
+	if (!pair)
 		return;
-	tty->link->packet = 0;
-	set_bit(TTY_OTHER_CLOSED, &tty->link->flags);
-	wake_up_interruptible(&tty->link->read_wait);
-	wake_up_interruptible(&tty->link->write_wait);
+
+	spin_lock_irqsave(&pair->buf.lock, flags);
+	pair->packet = 0;
+	/* Indicate that the other end is now closed, set the
+	   ENDPENDING marker so that the true end can be processed by
+	   the line discipline */
+	set_bit(TTY_EOFPENDING, &pair->flags);
+	set_bit(TTY_OTHER_CLOSED, &pair->flags);
+	spin_unlock_irqrestore(&pair->buf.lock, flags);
+	wake_up_interruptible(&pair->read_wait);
+	wake_up_interruptible(&pair->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
 #ifdef CONFIG_UNIX98_PTYS
@@ -180,7 +192,6 @@ static void pty_flush_buffer(struct tty_struct *tty)
 
 	if (!to)
 		return;
-	/* tty_buffer_flush(to); FIXME */
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
@@ -191,23 +202,30 @@ static void pty_flush_buffer(struct tty_struct *tty)
 
 static int pty_open(struct tty_struct *tty, struct file *filp)
 {
-	int	retval = -ENODEV;
+	int	retval = -EIO;
+	unsigned long flags;
+	struct tty_struct *pair;
 
-	if (!tty || !tty->link)
-		goto out;
+	if (tty == NULL || (pair = tty->link) == NULL)
+		return -ENODEV;
 
-	retval = -EIO;
 	if (test_bit(TTY_OTHER_CLOSED, &tty->flags))
+		return -EIO;
+	spin_lock_irqsave(&pair->buf.lock, flags);
+	if (test_bit(TTY_PTY_LOCK, &pair->flags))
 		goto out;
-	if (test_bit(TTY_PTY_LOCK, &tty->link->flags))
-		goto out;
-	if (tty->link->count != 1)
+	if (pair->count != 1)
 		goto out;
 
-	clear_bit(TTY_OTHER_CLOSED, &tty->link->flags);
+	clear_bit(TTY_OTHER_CLOSED, &pair->flags);
+	/* The buf.lock stops this racing a flush_to_ldisc from
+	   the other end */
+	clear_bit(TTY_EOFPENDING, &pair->flags);
+	clear_bit(TTY_EOF, &pair->flags);
 	set_bit(TTY_THROTTLED, &tty->flags);
 	retval = 0;
 out:
+	spin_unlock_irqrestore(&pair->buf.lock, flags);
 	return retval;
 }
 
diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 810ee25..448cd1d 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -119,6 +119,12 @@ static void __tty_buffer_flush(struct tty_struct *tty)
 		tty_buffer_free(tty, thead);
 	}
 	tty->buf.tail = NULL;
+	/* We can EOF a pty/tty pair with a flush as well as by consuming
+	   all the data left over */
+	if (test_bit(TTY_EOFPENDING, &tty->flags)) {
+		set_bit(TTY_EOF, &tty->flags);
+		wake_up(&tty->read_wait);
+	}
 }
 
 /**
@@ -455,6 +461,10 @@ static void flush_to_ldisc(struct work_struct *work)
 		clear_bit(TTY_FLUSHPENDING, &tty->flags);
 		wake_up(&tty->read_wait);
 	}
+	if (tty->buf.head == NULL && test_bit(TTY_EOFPENDING, &tty->flags)) {
+		wake_up(&tty->read_wait);
+		set_bit(TTY_EOF, &tty->flags);
+	}
 	clear_bit(TTY_FLUSHING, &tty->flags);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 85aa525..427d107 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -321,6 +321,8 @@ struct tty_struct {
 #define TTY_LDISC 		9	/* Line discipline attached */
 #define TTY_LDISC_CHANGING 	10	/* Line discipline changing */
 #define TTY_LDISC_OPEN	 	11	/* Line discipline is open */
+#define TTY_EOF			12	/* TTY/PTY pair at EOF */
+#define TTY_EOFPENDING		13	/* TTY/PTY pair EOF when data emptied */
 #define TTY_HW_COOK_OUT 	14	/* Hardware can do output cooking */
 #define TTY_HW_COOK_IN 		15	/* Hardware can do input cooking */
 #define TTY_PTY_LOCK 		16	/* pty private */
