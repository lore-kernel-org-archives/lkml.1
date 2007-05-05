Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbXEEQQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbXEEQQo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755569AbXEEQQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:16:44 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:58733
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568AbXEEQQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:16:42 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <463BC223.2040304@microgate.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
	 <1178308173.3743.14.camel@amdx2.microgate.com>
	 <5486cca80705041421y4fcaec01l7acafed1cea4b509@mail.gmail.com>
	 <463BC223.2040304@microgate.com>
Content-Type: text/plain
Date: Sat, 05 May 2007 03:26:58 -0500
Message-Id: <1178353618.3472.1.camel@x2>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 17:30 -0600, Paul Fulghum wrote:
> OK, this behavior is so unexpected I must be missing
> something basic.

And so I was. Try this patch.

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


