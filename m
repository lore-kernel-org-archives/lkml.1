Return-Path: <linux-kernel-owner+w=401wt.eu-S1752119AbYJNONE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119AbYJNONE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 10:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750952AbYJNOMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 10:12:54 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:64182 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796AbYJNOMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 10:12:53 -0400
Date: Tue, 14 Oct 2008 16:11:57 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Bodo Eggert <7eggert@gmx.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/4] SIGWINCH problem with terminal apps still alive
Message-ID: <20081014161157.0194c5c6@merlin.oi.pg.gda.pl>
In-Reply-To: <20081014145104.24aa96d0@merlin.oi.pg.gda.pl>
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
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_QauiScrIBQGvbmPobKkO+qD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_QauiScrIBQGvbmPobKkO+qD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Hello,
>=20
> I am sending sligtly corrected patch.
> In case of ioctl(,TIOCSWINSZ,) on pty side we should send signal to
> master side too. I've tested it on modified unix putty version
> and it works properly.
>=20
> Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>
>=20
> Maybe we could optimize code more and not call=20
> get_pid() and put_pid() if they are not needed - in case
> where there is no master/slave pair.

Not it is after small changes and proper path in patch.

Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>

Regards

--=20
Adam Tla=C5=82ka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gda=C5=84sk University of Technology, Poland

--MP_QauiScrIBQGvbmPobKkO+qD
Content-Type: text/x-patch; name=2.6.27_tty_io_4.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=2.6.27_tty_io_4.patch

--- drivers/char/tty_io_orig.c	2008-10-10 05:37:30.000000000 +0200
+++ drivers/char/tty_io.c	2008-10-14 15:58:54.000000000 +0200
@@ -2522,29 +2522,32 @@ int tty_do_resize(struct tty_struct *tty
 	struct pid *pgrp, *rpgrp;
 	unsigned long flags;
 
-	/* For a PTY we need to lock the tty side */
+        /* in case of resize ioctl on slave */
+	if ((tty == real_tty) && (tty->driver->type == TTY_DRIVER_TYPE_PTY))
+		tty = tty->link;
+	
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
-	tty->winsize = *ws;
+	flags = memcmp(ws, &real_tty->winsize, sizeof(*ws));
 	real_tty->winsize = *ws;
-done:
 	mutex_unlock(&real_tty->termios_mutex);
+	if (flags){
+		/* Get the PID values and reference them so we can
+		 avoid holding the tty ctrl lock while sending signals */
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		pgrp =  get_pid(tty->pgrp);
+		rpgrp = get_pid(real_tty->pgrp);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+		if (pgrp){
+			kill_pgrp(pgrp, SIGWINCH, 1);
+			put_pid(pgrp);
+		}
+		if (rpgrp != pgrp && rpgrp){
+			kill_pgrp(rpgrp, SIGWINCH, 1);
+			put_pid(rpgrp);
+		}
+	}
+	
 	return 0;
 }
 
@@ -2996,7 +2999,7 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCSTI:
 		return tiocsti(tty, p);
 	case TIOCGWINSZ:
-		return tiocgwinsz(tty, p);
+		return tiocgwinsz(real_tty, p);
 	case TIOCSWINSZ:
 		return tiocswinsz(tty, real_tty, p);
 	case TIOCCONS:

--MP_QauiScrIBQGvbmPobKkO+qD--
