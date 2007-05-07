Return-Path: <linux-kernel-owner+w=401wt.eu-S966961AbXEGVG7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966961AbXEGVG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2007 17:06:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966630AbXEGVG6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 May 2007 17:06:58 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:52963
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966588AbXEGVG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2007 17:06:57 -0400
Subject: [PATCH] tty flush flip buffer on ldisc input queue flush
From: Paul Fulghum <paulkf@microgate.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Antonino Ingargiola <tritemio@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Mon, 07 May 2007 16:05:57 -0500
Message-Id: <1178571957.3665.8.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Flush the tty flip buffer when the line discipline
input queue is flushed, including the user call
tcflush(TCIFLUSH/TCIOFLUSH). This prevents unexpected
stale data after a user application calls tcflush().

Cc: Alan Cox <alan@lxorguk.org.uk>
Cc: Antonino Ingargiola <tritemio@gmail.com>
Signed-off-by: Paul Fulghum <paulkf@microgate.com>

--- a/drivers/char/tty_io.c	2007-05-04 05:46:55.000000000 -0500
+++ b/drivers/char/tty_io.c	2007-05-05 03:23:46.000000000 -0500
@@ -365,6 +365,29 @@ static void tty_buffer_free(struct tty_s
 }
 
 /**
+ *	tty_buffer_flush		-	flush full tty buffers
+ *	@tty: tty to flush
+ *
+ *	flush all the buffers containing receive data
+ *
+ *	Locking: none
+ */
+
+static void tty_buffer_flush(struct tty_struct *tty)
+{
+	struct tty_buffer *thead;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->buf.lock, flags);
+	while((thead = tty->buf.head) != NULL) {
+		tty->buf.head = thead->next;
+		tty_buffer_free(tty, thead);
+	}
+	tty->buf.tail = NULL;
+	spin_unlock_irqrestore(&tty->buf.lock, flags);
+}
+
+/**
  *	tty_buffer_find		-	find a free tty buffer
  *	@tty: tty owning the buffer
  *	@size: characters wanted
@@ -1240,6 +1263,7 @@ void tty_ldisc_flush(struct tty_struct *
 			ld->flush_buffer(tty);
 		tty_ldisc_deref(ld);
 	}
+	tty_buffer_flush(tty);
 }
 
 EXPORT_SYMBOL_GPL(tty_ldisc_flush);
@@ -3336,6 +3360,15 @@ int tty_ioctl(struct inode * inode, stru
 		case TIOCMBIC:
 		case TIOCMBIS:
 			return tty_tiocmset(tty, file, cmd, p);
+		case TCFLSH:
+			switch (arg) {
+			case TCIFLUSH:
+			case TCIOFLUSH:
+				/* flush tty buffer and allow ldisc to process ioctl */
+				tty_buffer_flush(tty);
+				break;
+			}
+			break;
 	}
 	if (tty->driver->ioctl) {
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);



