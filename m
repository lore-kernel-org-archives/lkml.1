Return-Path: <linux-kernel-owner+w=401wt.eu-S1755659AbYJLMdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659AbYJLMdi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 08:33:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752082AbYJLMd3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 08:33:29 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:58305 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbYJLMd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 08:33:28 -0400
Date: Sun, 12 Oct 2008 14:32:31 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: 7eggert@gmx.de, linux-kernel@vger.kernel.org, torvalds@osdl.org
Subject: Re: [PATCH 0/2] SIGWINCH problem with terminal apps still alive
Message-ID: <20081012143231.6ef9e590@merlin.oi.pg.gda.pl>
In-Reply-To: <20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
References: <bjXel-4CU-17@gated-at.bofh.it>
	<bjYap-5Q0-25@gated-at.bofh.it>
	<bk30i-3Gx-1@gated-at.bofh.it>
	<bk6AV-8ms-7@gated-at.bofh.it>
	<bkrvO-1HF-49@gated-at.bofh.it>
	<blePJ-6rI-3@gated-at.bofh.it>
	<blmDC-7ZU-7@gated-at.bofh.it>
	<E1Kof4h-0005Q3-Ns@be1.7eggert.dyndns.org>
	<20081011185821.0dab4c81@lxorguk.ukuu.org.uk>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_nuxd7J7BqqtnvLiWW+y+8Wl
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_nuxd7J7BqqtnvLiWW+y+8Wl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Welcome,

generally speaking terminal resize could be made from vc or other
terminal device module code, from terminal ioctl on tty master
or tty slave. As we read the code we will see that the problem is to
use a proper mutex. Also we should use a one variable in which we set
terminal sizes. So in case of tty master and slave we have tty and
real_tty structures. TIOCSWINSZ and TIOCGWINSZ ioctls could be
called on tty and real_tty at the same time. To avoid race condition
we should use a mutex. But this must be the same mutex in all cases
- tty or real_tty. For the best we should also use the same
winsize variable. Proposed previously code change only simplifies
the code and eliminates SIGWINCH signal race but an app could read
terminal sizes at any time so this patch not closes all race
possibilities. So I propose a patch in which we have some code
movements and always use real_tty->termios_mutex and also
real_tty->winsize. In no pty case tty =3D=3D real_tty so it works properly
as before and in pty situaction we use the same mutex and variable so
it removes all race conditions according to access to winsize now.

Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>

Regards

--=20
Adam Tla=C5=82ka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gda=C5=84sk University of Technology, Poland

--MP_nuxd7J7BqqtnvLiWW+y+8Wl
Content-Type: text/x-patch; name=2.6.27_tty_io_2.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=2.6.27_tty_io_2.patch

--- drivers/char/tty_io_orig.c	2008-10-10 05:37:30.000000000 +0200
+++ drivers/char/tty_io.c	2008-10-12 13:37:11.000000000 +0200
@@ -2524,27 +2524,26 @@ int tty_do_resize(struct tty_struct *tty
 
 	/* For a PTY we need to lock the tty side */
 	mutex_lock(&real_tty->termios_mutex);
-	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
-		goto done;
-	/* Get the PID values and reference them so we can
-	   avoid holding the tty ctrl lock while sending signals */
-	spin_lock_irqsave(&tty->ctrl_lock, flags);
-	pgrp = get_pid(tty->pgrp);
-	rpgrp = get_pid(real_tty->pgrp);
-	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
+	flags = memcmp(ws, &real_tty->winsize, sizeof(*ws));
+	real_tty->winsize = *ws;
+	mutex_unlock(&real_tty->termios_mutex);
+	if (flags){
+		/* Get the PID values and reference them so we can
+		 avoid holding the tty ctrl lock while sending signals */
+		spin_lock_irqsave(&tty->ctrl_lock, flags);
+		pgrp = get_pid(tty->pgrp);
+		rpgrp = get_pid(real_tty->pgrp);
+		spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 
-	if (pgrp)
-		kill_pgrp(pgrp, SIGWINCH, 1);
-	if (rpgrp != pgrp && rpgrp)
-		kill_pgrp(rpgrp, SIGWINCH, 1);
+		if (pgrp)
+			kill_pgrp(pgrp, SIGWINCH, 1);
+		if (rpgrp != pgrp && rpgrp)
+			kill_pgrp(rpgrp, SIGWINCH, 1);
 
-	put_pid(pgrp);
-	put_pid(rpgrp);
+		put_pid(pgrp);
+		put_pid(rpgrp);
+	}
 
-	tty->winsize = *ws;
-	real_tty->winsize = *ws;
-done:
-	mutex_unlock(&real_tty->termios_mutex);
 	return 0;
 }
 
@@ -2996,7 +2995,7 @@ long tty_ioctl(struct file *file, unsign
 	case TIOCSTI:
 		return tiocsti(tty, p);
 	case TIOCGWINSZ:
-		return tiocgwinsz(tty, p);
+		return tiocgwinsz(real_tty, p);
 	case TIOCSWINSZ:
 		return tiocswinsz(tty, real_tty, p);
 	case TIOCCONS:

--MP_nuxd7J7BqqtnvLiWW+y+8Wl--
