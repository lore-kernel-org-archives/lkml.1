Return-Path: <linux-kernel-owner+w=401wt.eu-S933055AbXHHNih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055AbXHHNih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 09:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbXHHNi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 09:38:26 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46878 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751612AbXHHNiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 09:38:25 -0400
Date: Wed, 8 Aug 2007 14:45:32 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Laurent Pinchart <laurentp@cse-semaphore.com>, paulkf@microgate.com
Cc: linux-kernel@vger.kernel.org, paulkf@microgate.com
Subject: Re: Serial buffer memory leak
Message-ID: <20070808144532.5e3a1998@the-village.bc.nu>
In-Reply-To: <200708081158.06843.laurentp@cse-semaphore.com>
References: <200708081158.06843.laurentp@cse-semaphore.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm not familiar enough with the tty code to decide what the proper fix should 
> be. I'll try to write a patch if someone could point me in the right 
> direction.

Something like this perhaps ?

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/drivers/char/tty_io.c linux-2.6.23rc1-mm1/drivers/char/tty_io.c
--- linux.vanilla-2.6.23rc1-mm1/drivers/char/tty_io.c	2007-07-26 15:02:57.000000000 +0100
+++ linux-2.6.23rc1-mm1/drivers/char/tty_io.c	2007-08-08 11:39:29.791433672 +0100
@@ -369,25 +369,50 @@
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
  *	Locking: none
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
+	if (tty->buf.flushing)
+		tty->buf.flushpending = 1;
+	else
+		__tty_buffer_flush(tty);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 }
 
@@ -3594,6 +3619,7 @@
 		return;
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
+	tty->buf.flushing = 1;	/* So we know for tty_flush_buffers */
 	head = tty->buf.head;
 	if (head != NULL) {
 		tty->buf.head = NULL;
@@ -3607,6 +3633,11 @@
 				tty_buffer_free(tty, tbuf);
 				continue;
 			}
+			/* Ldisc or user is trying to flush the buffers
+			   we are feeding to the ldisc, stop feeding the 
+			   line discipline as we want to empty the queue */
+			if (tty->buf.flushpending)
+				break;
 			if (!tty->receive_room) {
 				schedule_delayed_work(&tty->buf.work, 1);
 				break;
@@ -3620,8 +3651,16 @@
 			disc->receive_buf(tty, char_buf, flag_buf, count);
 			spin_lock_irqsave(&tty->buf.lock, flags);
 		}
+		/* Restore the queue head */
 		tty->buf.head = head;
+		/* We may have a deferred request to flush the input buffer,
+		   if so do it now under the lock and empty the queue */
+		if (tty->buf.flushpending) {
+			__tty_buffer_flush(tty);
+			tty->buf.flushpending = 0;
+		}
 	}
+	tty->buf.flushing = 0;
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 
 	tty_ldisc_deref(disc);
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.23rc1-mm1/include/linux/tty.h linux-2.6.23rc1-mm1/include/linux/tty.h
--- linux.vanilla-2.6.23rc1-mm1/include/linux/tty.h	2007-07-26 15:02:04.000000000 +0100
+++ linux-2.6.23rc1-mm1/include/linux/tty.h	2007-08-08 11:44:32.000000000 +0100
@@ -80,13 +73,10 @@
 	struct tty_buffer *tail;	/* Active buffer */
 	struct tty_buffer *free;	/* Free queue head */
 	int memory_used;		/* Buffer space used excluding free queue */
+	unsigned int flushing:1;	/* flush_to_ldisc active */
+	unsigned int flushpending:1;	/* A request to clear the queue is pending */
 };
 /*
- * The pty uses char_buf and flag_buf as a contiguous buffer
- */
-#define PTY_BUF_SIZE	4*TTY_FLIPBUF_SIZE
-
-/*
  * When a break, frame error, or parity error happens, these codes are
  * stuffed into the flags buffer.
  */
