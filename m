Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbXEDOt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbXEDOt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 10:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbXEDOt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 10:49:29 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:36629
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755366AbXEDOt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 10:49:28 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <463B4988.9090005@microgate.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <200705041049.20989.oliver@neukum.org>
	 <5486cca80705040229g53933671m658bd028cadca155@mail.gmail.com>
	 <5486cca80705040233y70915a27yf7cbbc08a617e3ba@mail.gmail.com>
	 <463B46F4.6090906@microgate.com>  <463B4988.9090005@microgate.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 09:49:20 -0500
Message-Id: <1178290160.3913.2.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a patch against 2.6.21 which flushes the tty flip buffer
on ioctl(TCFLSH) for input.

--- a/drivers/char/tty_io.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/char/tty_io.c	2007-05-04 09:30:01.000000000 -0500
@@ -365,6 +365,28 @@ static void tty_buffer_free(struct tty_s
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
+	spin_unlock_irqrestore(&tty->buf.lock, flags);
+}
+
+/**
  *	tty_buffer_find		-	find a free tty buffer
  *	@tty: tty owning the buffer
  *	@size: characters wanted
@@ -1240,6 +1262,7 @@ void tty_ldisc_flush(struct tty_struct *
 			ld->flush_buffer(tty);
 		tty_ldisc_deref(ld);
 	}
+	tty_buffer_flush(tty);
 }
 
 EXPORT_SYMBOL_GPL(tty_ldisc_flush);
@@ -3336,6 +3359,15 @@ int tty_ioctl(struct inode * inode, stru
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


