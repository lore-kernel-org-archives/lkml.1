Return-Path: <linux-kernel-owner+w=401wt.eu-S933161AbXHXKJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933161AbXHXKJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 06:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764827AbXHXKJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 06:09:23 -0400
Received: from [77.60.199.90] ([77.60.199.90]:60125 "HELO nl.ultrawaves.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with SMTP
	id S1764753AbXHXKJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 06:09:23 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Aug 2007 06:09:22 EDT
Message-ID: <46CEACC0.5000908@lammerts.org>
Date: Fri, 24 Aug 2007 12:02:40 +0200
From: Eric Lammerts <eric@lammerts.org>
User-Agent: Mozilla Thunderbird 1.0.2 (X11/20050317)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: p.hardwick@option.com, greg@kroah.com, akpm@linux-foundation.org
Subject: [PATCH] nozomi DTR/RTS
Content-Type: multipart/mixed;
 boundary="------------010709070201030800000200"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010709070201030800000200
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,
I noticed that DTR toggling doesn't work with the nozomi driver 
(TIOCMBIS/TIOCMBIC ioctls have no effect). This is a nuisance because 
that makes it hard to get the modem back in command mode.

Attached patch adds a tty_ops->tiocmset function that makes it work.

Should we also rip out the TIOCMBIS/TIOCMBIC handling in ntty_ioctl()? 
It doesn't seem to be used anyway.

Patch is against 2.6.23-rc3-mm1, but not tested with that. I tested it 
with 2.6.18.4 and the pharscape.org driver.

Eric

--------------010709070201030800000200
Content-Type: text/plain;
 name="nozomi-dtr-patch-2.6.23-rc3-mm1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nozomi-dtr-patch-2.6.23-rc3-mm1"

--- linux-2.6.23-rc3-mm1/drivers/char/nozomi.c.orig	2007-08-24 05:39:06.000000000 -0400
+++ linux-2.6.23-rc3-mm1/drivers/char/nozomi.c	2007-08-24 05:41:07.000000000 -0400
@@ -1930,12 +1930,16 @@
 }
 
 /* Sets io controls parameters */
-static int ntty_tiocmset(struct tty_struct *tty, struct file *file, u32 arg)
+static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
+	unsigned int set, unsigned int clear)
 {
 	struct port *port = (struct port *)tty->driver_data;
 
-	set_rts(port->tty_index, (arg & TIOCM_RTS) ? 1 : 0);
-	set_dtr(port->tty_index, (arg & TIOCM_DTR) ? 1 : 0);
+	if(set & TIOCM_RTS) set_rts(port->tty_index, 1);
+	else if(clear & TIOCM_RTS) set_rts(port->tty_index, 0);
+	
+	if(set & TIOCM_DTR) set_dtr(port->tty_index, 1);
+	else if(clear & TIOCM_DTR) set_dtr(port->tty_index, 0);
 
 	return 0;
 }
@@ -2039,7 +2043,7 @@
 		spin_unlock_irqrestore(&dc->spin_mutex, flags);
 		break;
 	case TIOCMSET:
-		rval = ntty_tiocmset(tty, file, arg);
+		rval = ntty_tiocmset(tty, file, arg, ~arg);
 		break;
 	case TIOCMBIC:
 		if (get_user(mask, (unsigned long __user *)arg))
@@ -2152,6 +2156,7 @@
 	.set_termios = ntty_set_termios,
 	.chars_in_buffer = ntty_chars_in_buffer,
 	.put_char = ntty_put_char,
+	.tiocmset = ntty_tiocmset,
 };
 
 /* Initializes the tty */

--------------010709070201030800000200--
