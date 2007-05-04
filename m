Return-Path: <linux-kernel-owner+w=401wt.eu-S1422716AbXEDTtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716AbXEDTtl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 15:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161535AbXEDTtl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 15:49:41 -0400
Received: from adsl-70-250-156-241.dsl.austtx.swbell.net ([70.250.156.241]:49673
	"EHLO gw.microgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161295AbXEDTtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 15:49:39 -0400
Subject: Re: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial
	possible bug]
From: Paul Fulghum <paulkf@microgate.com>
To: Antonino Ingargiola <tritemio@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
References: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
	 <1178290160.3913.2.camel@amdx2.microgate.com>
	 <5486cca80705040904v786f13dh5614174fcc51c202@mail.gmail.com>
	 <5486cca80705040956g47f634ddp80d67038e8e3305a@mail.gmail.com>
	 <463B7534.6000207@microgate.com>
	 <5486cca80705041013pf481c2an9e639fc9285ba88e@mail.gmail.com>
	 <1178299247.3769.0.camel@amdx2.microgate.com>
	 <5486cca80705041025k46ccf716t8dcd1e6f29e2376e@mail.gmail.com>
	 <1178300493.3619.1.camel@amdx2.microgate.com>
	 <5486cca80705041146x5c5bda70s96ce74e389cc1635@mail.gmail.com>
	 <5486cca80705041206q3a077dedyedb5ac2fbf434ba8@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 04 May 2007 14:49:33 -0500
Message-Id: <1178308173.3743.14.camel@amdx2.microgate.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.3 (2.2.3-4.fc4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-05-04 at 21:06 +0200, Antonino Ingargiola wrote:

> Filling with echo console-screen.sh I've found that the blocking command is:
> 
>     unicode_start 2> /dev/null || true
> 
> or at least the echo before this command is the last shown.

I still don't know what is blocking.

It is possible some tty device is operating with an improperly
initialized tty structure. I vaguely remember some console code
creating its own minimally initialized 'dummy' tty structure.

This might be causing the new flush code to hang.

Try this patch which does not call the flush unless a line
discipline is attached to the tty. That should indicate
a normally initialized tty structure.

--- a/drivers/char/tty_io.c	2007-04-25 22:08:32.000000000 -0500
+++ b/drivers/char/tty_io.c	2007-05-04 12:15:18.000000000 -0500
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
@@ -1236,8 +1258,10 @@ void tty_ldisc_flush(struct tty_struct *
 {
 	struct tty_ldisc *ld = tty_ldisc_ref(tty);
 	if(ld) {
-		if(ld->flush_buffer)
+		if(ld->flush_buffer) {
 			ld->flush_buffer(tty);
+			tty_buffer_flush(tty);
+		}
 		tty_ldisc_deref(ld);
 	}
 }
@@ -3336,6 +3360,20 @@ int tty_ioctl(struct inode * inode, stru
 		case TIOCMBIC:
 		case TIOCMBIS:
 			return tty_tiocmset(tty, file, cmd, p);
+		case TCFLSH:
+			switch (arg) {
+			case TCIFLUSH:
+			case TCIOFLUSH:
+				/* flush tty buffer and allow ldisc to process ioctl */
+				ld = tty_ldisc_ref_wait(tty);
+				if (ld) {
+					if (ld->ioctl)
+						tty_buffer_flush(tty);
+					tty_ldisc_deref(ld);
+				}
+				break;
+			}
+			break;
 	}
 	if (tty->driver->ioctl) {
 		retval = (tty->driver->ioctl)(tty, file, cmd, arg);


