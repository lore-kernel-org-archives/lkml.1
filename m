Return-Path: <linux-kernel-owner+w=401wt.eu-S1755962AbYJPK2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962AbYJPK2R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbYJPK2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:28:08 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:49785 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbYJPK2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:28:06 -0400
Date: Thu, 16 Oct 2008 12:27:41 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/5] SIGWINCH problem with terminal apps still alive
Message-ID: <20081016122741.3b89f6f3@merlin.oi.pg.gda.pl>
In-Reply-To: <20081014161157.0194c5c6@merlin.oi.pg.gda.pl>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
	<20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
	<20081012152200.4a8f14c4@lxorguk.ukuu.org.uk>
	<20081012195957.50feada3@merlin.oi.pg.gda.pl>
	<20081012190312.0bd04ab8@lxorguk.ukuu.org.uk>
	<20081012210140.15cecf78@merlin.oi.pg.gda.pl>
	<20081012212244.117852e0@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131155280.5750@be1.lrz>
	<20081013110125.5e3e5fa6@lxorguk.ukuu.org.uk>
	<alpine.LSU.0.999.0810131359310.6408@be1.lrz>
	<20081014145104.24aa96d0@merlin.oi.pg.gda.pl>
	<20081014161157.0194c5c6@merlin.oi.pg.gda.pl>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_2DvHB8sPLW.ufB+R7dBqkMW
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_2DvHB8sPLW.ufB+R7dBqkMW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

actual pty ioctl(,TIOCSWINSZ,) handling is broken IMHO.
I we do that action on normal tty (console for example)
some resize is done or not and resulting size variables are updated
and signal generated. In case of pty ioctl() on slave side it just sets
pty size variables, generates SIGWINCH, but terminal is not changed so
a terminal app will go crazy now. I propose changes which lead to more
consistent handling:

1. set in non pty master/slave case: no changes
2. set in pty master case: we update all sizes and do SIGWINCH on slave
side
3. set in pty slave  case: we update only master variable and do
SIGWINCH on master side
4. read: master reads master variable  while slave reads slave variable

Now if xterm resizes itself then a program on slave gets its signal
but if this program sets terminal sizes by ioctl then only xterm gets
the SIGWINCH signal and could read desired sizes by ioctl and then
resize itself and set valid sizes on slave side by another ioctl() call.
If it not supports this method then there will be no changes on slave
side. I think that it is more proper so on the slave side we will see
always actual values and if terminal resizes we will get SIGWINCH.=20

Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>
=20
Regards

--=20
Adam Tla=C5=82ka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gda=C5=84sk University of Technology, Poland

--MP_2DvHB8sPLW.ufB+R7dBqkMW
Content-Type: text/x-patch; name=2.6.27_tty_io_5.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=2.6.27_tty_io_5.patch

--- drivers/char/tty_io_orig.c	2008-10-10 05:37:30.000000000 +0200
+++ drivers/char/tty_io.c	2008-10-16 11:25:53.000000000 +0200
@@ -2490,17 +2490,17 @@ static int tiocsti(struct tty_struct *tt
  *
  *	Copies the kernel idea of the window size into the user buffer.
  *
- *	Locking: tty->termios_mutex is taken to ensure the winsize data
+ *	Locking: real_tty->termios_mutex is taken to ensure the winsize data
  *		is consistent.
  */
 
-static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
+static int tiocgwinsz(struct tty_struct *tty, struct tty_struct *real_tty, struct winsize __user *arg)
 {
 	int err;
 
-	mutex_lock(&tty->termios_mutex);
+	mutex_lock(&real_tty->termios_mutex);
 	err = copy_to_user(arg, &tty->winsize, sizeof(*arg));
-	mutex_unlock(&tty->termios_mutex);
+	mutex_unlock(&real_tty->termios_mutex);
 
 	return err ? -EFAULT: 0;
 }
@@ -2519,32 +2519,31 @@ static int tiocgwinsz(struct tty_struct 
 int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
 					struct winsize *ws)
 {
-	struct pid *pgrp, *rpgrp;
+	struct pid *pgrp;
 	unsigned long flags;
 
-	/* For a PTY we need to lock the tty side */
+	/* for a PTY we need to lock the tty side */
 	mutex_lock(&real_tty->termios_mutex);
-	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
-		goto done;
-	/* Get the PID values and reference them so we can
-	   avoid holding the tty ctrl lock while sending signals */
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	pgrp = get_pid(tty->pgrp);
-	rpgrp = get_pid(real_tty->pgrp);
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
-
-	if (pgrp)
-		kill_pgrp(pgrp, SIGWINCH, 1);
-	if (rpgrp != pgrp && rpgrp)
-		kill_pgrp(rpgrp, SIGWINCH, 1);
-
-	put_pid(pgrp);
-	put_pid(rpgrp);
-
+	flags = memcmp(ws, &real_tty->winsize, sizeof(*ws));
+	if (tty != real_tty){ /* master side */
+		tty->winsize = *ws;
+		tty = real_tty;
+	} else if (tty->driver->type == TTY_DRIVER_TYPE_PTY){
+		tty = tty->link;
+	}
 	tty->winsize = *ws;
-	real_tty->winsize = *ws;
-done:
 	mutex_unlock(&real_tty->termios_mutex);
+	if (flags){
+		/* Get the PID values and reference them so we can
+		 avoid holding the tty ctrl lock while sending signals */
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		pgrp =  get_pid(tty->pgrp);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		if (pgrp){
+			kill_pgrp(pgrp, SIGWINCH, 1);
+			put_pid(pgrp);
+		}
+	}
 	return 0;
 }
 
@@ -2570,9 +2569,12 @@ static int tiocswinsz(struct tty_struct 
 	if (copy_from_user(&tmp_ws, arg, sizeof(*arg)))
 		return -EFAULT;
 
-	if (tty->ops->resize)
+	if (tty->ops->resize){
+		if ((tty == real_tty)
+		    && (tty->driver->type == TTY_DRIVER_TYPE_PTY))
+			tty = tty->link;
 		return tty->ops->resize(tty, real_tty, &tmp_ws);
-	else
+	} else
 		return tty_do_resize(tty, real_tty, &tmp_ws);
 }
 
@@ -2996,7 +2998,7 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCSTI:
 		return tiocsti(tty, p);
 	case TIOCGWINSZ:
-		return tiocgwinsz(tty, p);
+		return tiocgwinsz(tty, real_tty, p);
 	case TIOCSWINSZ:
 		return tiocswinsz(tty, real_tty, p);
 	case TIOCCONS:

--MP_2DvHB8sPLW.ufB+R7dBqkMW--
