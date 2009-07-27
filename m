Return-Path: <linux-kernel-owner+w=401wt.eu-S1754114AbZG0NW0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbZG0NW0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 09:22:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753881AbZG0NW0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 09:22:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50992 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753796AbZG0NWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 09:22:25 -0400
Date: Mon, 27 Jul 2009 14:23:03 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] kdesu broken
Message-ID: <20090727142303.41096bf5@lxorguk.ukuu.org.uk>
In-Reply-To: <873a8iqqgv.fsf@devron.myhome.or.jp>
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
	<20090727115723.1e8de60e@lxorguk.ukuu.org.uk>
	<873a8iqqgv.fsf@devron.myhome.or.jp>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I worried "pair->packet = 0" when I'm thinking this. I guess it would be
> changed more early than before. Is it ok?

I think so, and we can get stuck otherwise.


Tested patch:

commit 70325fd1d4341896c17b6f1f1965370b5258d0b1
Author: Alan Cox <alan@linux.intel.com>
Date:   Mon Jul 27 14:18:52 2009 +0100

    pty: ensure writes hit the reader before close
    
    Implement TTY_EOF/EOFPENDING flags so that we can propogate the close of the
    pty through the buffering correctly. The new flag state is locked but the
    tty buffer lock as it relates to buffers, and also because the buffer
    lock is already held in the hot path.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

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
index 810ee25..19a7ced 100644
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
@@ -405,6 +411,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	struct tty_buffer *tbuf, *head;
 	char *char_buf;
 	unsigned char *flag_buf;
+	int done = 1;
 
 	disc = tty_ldisc_ref(tty);
 	if (disc == NULL)	/*  !TTY_LDISC */
@@ -433,10 +440,13 @@ static void flush_to_ldisc(struct work_struct *work)
 				break;
 			if (!tty->receive_room) {
 				schedule_delayed_work(&tty->buf.work, 1);
+				done = 0;
 				break;
 			}
-			if (count > tty->receive_room)
+			if (count > tty->receive_room) {
 				count = tty->receive_room;
+				done = 0;
+			}
 			char_buf = head->char_buf_ptr + head->read;
 			flag_buf = head->flag_buf_ptr + head->read;
 			head->read += count;
@@ -454,6 +464,10 @@ static void flush_to_ldisc(struct work_struct *work)
 		__tty_buffer_flush(tty);
 		clear_bit(TTY_FLUSHPENDING, &tty->flags);
 		wake_up(&tty->read_wait);
+	} else if (done && test_bit(TTY_EOFPENDING, &tty->flags)) {
+		/* The last bits hit the ldisc so set EOF */
+		wake_up(&tty->read_wait);
+		set_bit(TTY_EOF, &tty->flags);
 	}
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


