Return-Path: <linux-kernel-owner+w=401wt.eu-S1752500AbZG0RMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbZG0RMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 13:12:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750900AbZG0RMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 13:12:30 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:36390 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbZG0RM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 13:12:29 -0400
Date: Mon, 27 Jul 2009 22:42:14 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ray Lee <ray-lk@madrabbit.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kdesu broken
Message-ID: <20090727171213.GB4233@skywalker>
References: <20090725163251.50e6f546@lxorguk.ukuu.org.uk> <87bpn7mzli.fsf@devron.myhome.or.jp> <20090727115723.1e8de60e@lxorguk.ukuu.org.uk> <873a8iqqgv.fsf@devron.myhome.or.jp> <20090727142303.41096bf5@lxorguk.ukuu.org.uk> <877hxujkuv.fsf@devron.myhome.or.jp> <20090727145805.690afe5d@lxorguk.ukuu.org.uk> <87fxci6ub9.fsf@devron.myhome.or.jp> <20090727161424.GA4233@skywalker> <20090727174252.2d987830@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090727174252.2d987830@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 27, 2009 at 05:42:52PM +0100, Alan Cox wrote:
> 
> > > -			if (count > tty->receive_room) {
> > > +			if (count > tty->receive_room)
> > >  				count = tty->receive_room;
> > > -				done = 0;
> > > -			}
> > >  			char_buf = head->char_buf_ptr + head->read;
> > >  			flag_buf = head->flag_buf_ptr + head->read;
> > >  			head->read += count;
> > > _
> > 
> > 
> > I still have the "compile in emacs" bug. So this patch along with
> > http://article.gmane.org/gmane.linux.kernel/869824 doesn't fix the
> > bug for me.
> 
> Can you stick some printk calls in and debug it further then because at
> with the fixes Ogawa provided I'm finding it impossible to reproduce even
> on an 8 way x86.
> 
> What hardware are you using ?

My T60p lenovo laptop. If you can send me a debug prink patch i can redo the
test with the patches. I don't know what data i should start collecting so
that it make sense. This is the patch i tried

diff -ru /home/opensource/sources/linux-2.6/drivers/char/n_tty.c /home/opensource/build/linux-2.6-distro/drivers/char/n_tty.c
--- /home/opensource/sources/linux-2.6/drivers/char/n_tty.c	2009-07-17 10:07:40.210991073 +0530
+++ /home/opensource/build/linux-2.6-distro/drivers/char/n_tty.c	2009-07-27 18:56:14.518330502 +0530
@@ -1777,7 +1777,8 @@
 			tty->minimum_to_wake = (minimum - (b - buf));
 
 		if (!input_available_p(tty, 0)) {
-			if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
+			if (test_bit(TTY_EOF, &tty->flags)) {
+				/* PTY pair closed and all data consumed */
 				retval = -EIO;
 				break;
 			}
diff -ru /home/opensource/sources/linux-2.6/drivers/char/pty.c /home/opensource/build/linux-2.6-distro/drivers/char/pty.c
--- /home/opensource/sources/linux-2.6/drivers/char/pty.c	2009-07-26 22:45:50.354419907 +0530
+++ /home/opensource/build/linux-2.6-distro/drivers/char/pty.c	2009-07-27 21:29:26.217922778 +0530
@@ -38,6 +38,9 @@
 
 static void pty_close(struct tty_struct *tty, struct file *filp)
 {
+	struct tty_struct *pair;
+	unsigned long flags;
+
 	BUG_ON(!tty);
 	if (tty->driver->subtype == PTY_TYPE_MASTER)
 		WARN_ON(tty->count > 1);
@@ -47,13 +50,23 @@
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
+	tty_flip_buffer_push(pair);
+	wake_up_interruptible(&pair->read_wait);
+	wake_up_interruptible(&pair->write_wait);
 	if (tty->driver->subtype == PTY_TYPE_MASTER) {
 		set_bit(TTY_OTHER_CLOSED, &tty->flags);
 #ifdef CONFIG_UNIX98_PTYS
@@ -180,7 +193,6 @@
 
 	if (!to)
 		return;
-	/* tty_buffer_flush(to); FIXME */
 	if (to->packet) {
 		spin_lock_irqsave(&tty->ctrl_lock, flags);
 		tty->ctrl_status |= TIOCPKT_FLUSHWRITE;
@@ -191,23 +203,30 @@
 
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
 
diff -ru /home/opensource/sources/linux-2.6/drivers/char/tty_buffer.c /home/opensource/build/linux-2.6-distro/drivers/char/tty_buffer.c
--- /home/opensource/sources/linux-2.6/drivers/char/tty_buffer.c	2009-04-28 21:21:06.964692375 +0530
+++ /home/opensource/build/linux-2.6-distro/drivers/char/tty_buffer.c	2009-07-27 21:29:26.229922140 +0530
@@ -119,6 +119,12 @@
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
@@ -405,6 +411,7 @@
 	struct tty_buffer *tbuf, *head;
 	char *char_buf;
 	unsigned char *flag_buf;
+	int done = 1;
 
 	disc = tty_ldisc_ref(tty);
 	if (disc == NULL)	/*  !TTY_LDISC */
@@ -433,6 +440,7 @@
 				break;
 			if (!tty->receive_room) {
 				schedule_delayed_work(&tty->buf.work, 1);
+				done = 0;
 				break;
 			}
 			if (count > tty->receive_room)
@@ -454,6 +462,10 @@
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
