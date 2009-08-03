Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbZHCQ0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbZHCQ0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZHCQ0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:26:33 -0400
Received: from mail.parknet.ad.jp ([210.171.162.6]:37579 "EHLO
	mail.officemail.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417AbZHCQ0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:26:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <greg@kroah.com>
Subject: Re: WARNING at: drivers/char/tty_ldisc.c
References: <20090802120120.GA3097@localdomain.by>
	<alpine.LFD.2.01.0908020940530.3352@localhost.localdomain>
	<20090802190514.GA3278@localdomain.by>
	<alpine.LFD.2.01.0908021254580.3352@localhost.localdomain>
	<87k51l9apo.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.01.0908021423490.3352@localhost.localdomain>
	<20090802234851.3fd1ac2c@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.01.0908021654010.3352@localhost.localdomain>
	<20090803103746.264c3acf@lxorguk.ukuu.org.uk>
Date: Tue, 04 Aug 2009 01:26:29 +0900
In-Reply-To: <20090803103746.264c3acf@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 3 Aug 2009 10:37:46 +0100")
Message-ID: <87vdl4kgne.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for MailServers 5.5.10/RELEASE, bases: 24052007 #308098, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> So I do get the feeling that it may be just old code that simply nobody 
>> has dared remove - it may have made more sense back when then it does 
>> now, and has just been carried around.
>
> Alas not: eg
>
> ->hangup
> uart_hangup
> uart_flush_buffer
> uart_shutdown
> 	drops carrier and dtr
> 	shuts down the port
> 	frees the IRQ handler
> 	kills off the transmit buffer & tasklet
>
> whether the resulting mess happens to still work with printk rather
> depends upon what ->ops->shutdown does. Even on x86 that will drop a
> remote console if the carrier is being used so you won't see printk
> messages after that point as you got a modem hangup.
>
> A re-open as a device isn't a problem (we cleared ASYNCB_INITIALIZED) -
> its the printk side that kills you, and someone is going to have to read
> all the embedded device consoles as they are both the most likely to
> break and most used 8(

I see. I guess it is explaining the following part

	if (cons_filp) {
		if (tty->ops->close)
			for (n = 0; n < closecount; n++)
				tty->ops->close(tty, cons_filp);
	} else if (tty->ops->hangup)
		(tty->ops->hangup)(tty);

the above seem to avoid serial hangup... Luckily, I found the patch of
it. But, even before the patch, it seems we didn't

	filp->f_op = &hung_up_tty_fops;

for console stuff. But, I'm still not found why we avoid to the above...

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

commit a972c49404c18ed15db2c1cce5f414293f73c8d9
Author: Linus Torvalds <torvalds@linuxfoundation.org>
Date:   Fri Nov 23 15:16:55 2007 -0500

    Import 2.1.125pre2

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index e8b116f..2a2f2de 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -390,7 +390,9 @@ void do_tty_hangup(void *data)
 {
 	struct tty_struct *tty = (struct tty_struct *) data;
 	struct file * filp;
+	struct file * cons_filp = NULL;
 	struct task_struct *p;
+	int    closecount = 0, n;
 
 	if (!tty)
 		return;
@@ -407,10 +409,13 @@ void do_tty_hangup(void *data)
 		if (!filp->f_dentry->d_inode)
 			continue;
 		if (filp->f_dentry->d_inode->i_rdev == CONSOLE_DEV ||
-		    filp->f_dentry->d_inode->i_rdev == SYSCONS_DEV)
+		    filp->f_dentry->d_inode->i_rdev == SYSCONS_DEV) {
+			cons_filp = filp;
 			continue;
+		}
 		if (filp->f_op != &tty_fops)
 			continue;
+		closecount++;
 		tty_fasync(-1, filp, 0);
 		filp->f_op = &hung_up_tty_fops;
 	}
@@ -470,7 +475,17 @@ void do_tty_hangup(void *data)
 	tty->session = 0;
 	tty->pgrp = -1;
 	tty->ctrl_status = 0;
-	if (tty->driver.hangup)
+	/*
+	 *	If one of the devices matches a console pointer, we
+	 *	cannot just call hangup() because that will cause
+	 *	tty->count and state->count to go out of sync.
+	 *	So we just call close() the right number of times.
+	 */
+	if (cons_filp) {
+		if (tty->driver.close)
+			for (n = 0; n < closecount; n++)
+				tty->driver.close(tty, cons_filp);
+	} else if (tty->driver.hangup)
 		(tty->driver.hangup)(tty);
 	unlock_kernel();
 }
@@ -1243,6 +1258,7 @@ retry_open:
 		if (!c)
                         return -ENODEV;
                 device = c->device(c);
+		filp->f_flags |= O_NONBLOCK; /* Don't let /dev/console block */
 		noctty = 1;
 	}
 #ifdef CONFIG_UNIX98_PTYS

