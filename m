Return-Path: <linux-kernel-owner+w=401wt.eu-S936010AbXHHPZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936010AbXHHPZv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 11:25:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935724AbXHHPZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 11:25:06 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50808 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935615AbXHHPZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 11:25:03 -0400
Date: Wed, 8 Aug 2007 16:32:17 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Paul Fulghum <paulkf@microgate.com>,
       Laurent Pinchart <laurentp@cse-semaphore.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Serial buffer memory leak
Message-ID: <20070808163217.2f59fe84@the-village.bc.nu>
In-Reply-To: <20070808161606.32a40793@the-village.bc.nu>
References: <200708081158.06843.laurentp@cse-semaphore.com>
	<20070808144532.5e3a1998@the-village.bc.nu>
	<1186582307.3394.3.camel@x2.microgate.com>
	<200708081628.36897.laurentp@cse-semaphore.com>
	<1186584775.3508.13.camel@x2.microgate.com>
	<20070808161606.32a40793@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Aug 2007 16:16:06 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > tty_buffer_flush() needs to wait for buf.flushpending to clear.

> Should probably make the flushpending an atomic bit op to avoid taking
> and retaking the lock.

Ok try this for size folks. Use tty->flags bits for the flush status.
Wait for the flag to clear again before returning
Fix the doc error noted
Fix flush of empty queue leaving stale flushpending


Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/char/tty_io.c linux-2.6.23rc1-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.23rc1-mm1/drivers/char/tty_io.c	2007-07-26 15:02:57.000000000 +0100
+++ linux-2.6.23rc1-mm1/drivers/char/tty_io.c	2007-08-08 16:01:36.843558336 +0100
@@ -369,25 +369,54 @@
 }
 
 /**
- *	tty_buffer_flush		-	flush full tty buffers
+ *	__tty_buffer_flush		-	flush full tty buffers
  *	@tty: tty to flush
  *
- *	flush all the buffers containing receive data
+ *	flush all the buffers containing receive data. Caller must
+ *	hold the buffer lock and must have ensured no parallel flush to
+ *	ldisc is running.
  *
- *	Locking: none
+ *	Locking: Caller must hold tty->buf.lock
  */
 
-static void tty_buffer_flush(struct tty_struct *tty)
+static void __tty_buffer_flush(struct tty_struct *tty)
 {
 	struct tty_buffer *thead;
-	unsigned long flags;
 
-	spin_lock_irqsave(&tty->buf.lock, flags);
 	while((thead = tty->buf.head) != NULL) {
 		tty->buf.head = thead->next;
 		tty_buffer_free(tty, thead);
 	}
 	tty->buf.tail = NULL;
+}
+
+/**
+ *	tty_buffer_flush		-	flush full tty buffers
+ *	@tty: tty to flush
+ *
+ *	flush all the buffers containing receive data. If the buffer is
+ *	being processed by flush_to_ldisc then we defer the processing
+ *	to that function
+ *
+ *	Locking: none
+ */
+ 
+static void tty_buffer_flush(struct tty_struct *tty)
+{
+	unsigned long flags;
+	spin_lock_irqsave(&tty->buf.lock, flags);
+	
+	/* If the data is being pushed to the tty layer then we can't
+	   process it here. Instead set a flag and the flush_to_ldisc
+	   path will process the flush request before it exits */
+	if (test_bit(TTY_FLUSHING, &tty->flags)) {
+		set_bit(TTY_FLUSHPENDING, &tty->flags);
+		spin_unlock_irqrestore(&tty->buf.lock, flags);
+		wait_event(tty->read_wait, test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
+ 		return;
+	}
+	else
+		__tty_buffer_flush(tty);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 }
 
@@ -3594,6 +3622,7 @@
 		return;
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
+	set_bit(TTY_FLUSHING, &tty->flags);	/* So we know a flush is running */
 	head = tty->buf.head;
 	if (head != NULL) {
 		tty->buf.head = NULL;
@@ -3607,6 +3636,11 @@
 				tty_buffer_free(tty, tbuf);
 				continue;
 			}
+			/* Ldisc or user is trying to flush the buffers
+			   we are feeding to the ldisc, stop feeding the 
+			   line discipline as we want to empty the queue */
+			if (test_bit(TTY_FLUSHPENDING, &tty->flags))
+				break;
 			if (!tty->receive_room) {
 				schedule_delayed_work(&tty->buf.work, 1);
 				break;
@@ -3620,8 +3654,16 @@
 			disc->receive_buf(tty, char_buf, flag_buf, count);
 			spin_lock_irqsave(&tty->buf.lock, flags);
 		}
+		/* Restore the queue head */
 		tty->buf.head = head;
 	}
+	/* We may have a deferred request to flush the input buffer,
+	   if so pull the chain under the lock and empty the queue */
+	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
+		__tty_buffer_flush(tty);
+		clear_bit(TTY_FLUSHPENDING, &tty->flags);
+	}
+	clear_bit(TTY_FLUSHING, &tty->flags);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 
 	tty_ldisc_deref(disc);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/tty.h linux-2.6.23rc1-mm1/include/linux/tty.h
--- linux.vanilla-2.6.23rc1-mm1/include/linux/tty.h	2007-07-26 15:02:04.000000000 +0100
+++ linux-2.6.23rc1-mm1/include/linux/tty.h	2007-08-08 16:00:28.089010616 +0100
@@ -274,6 +262,8 @@
 #define TTY_PTY_LOCK 		16	/* pty private */
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
+#define TTY_FLUSHING		19	/* Flushing to ldisc in progress */
+#define TTY_FLUSHPENDING	20	/* Queued buffer flush pending */
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
 
