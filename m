Return-Path: <linux-kernel-owner+w=401wt.eu-S1753753AbYJFMOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbYJFMOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYJFMOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:14:22 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:37426 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbYJFMOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:14:21 -0400
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Oct 2008 08:14:21 EDT
Date: Mon, 6 Oct 2008 14:07:08 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org
Subject: [PATCH 0/0] SIGWINCH problem with terminal apps
Message-ID: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_Tf+wQz.2IOjvc_o2_H0NYIP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_Tf+wQz.2IOjvc_o2_H0NYIP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Welcome,

I've observed then very often a X11 terminal app is not getting proper
window sizes afer terminal resize operation. This could be seen with
mc, jed, vim or other curses and not curses aware apps.

I wrote a simple program which just does nothing but uses SIGWINCH
handler so I can observe values reported by ioctl(1,TIOCGWINS,&ws) call
inside my signal handler. What is interesting that from time to time it
obtain unchanged values. It means values which were valid just before
terminal resize.

In drivers/char/vt.c and drivers/char/tty_io.c variables
vc->vc_tty->winsize and tty->winsize , real_tty->winsize are updated
after kill_pgrp(pgrp, SIGWINCH, 1) calls. I am not very familiar with
mutex design and how it corresponds to kill_pgrp() kernel function but
it seems that locking is not working here as we expect. An app can read
tty winsize data through ioctl() call in SIGWINCH handler and obtain
uchanged values.

So as a quick solution I made patches which move mentioned updates
before kill_pgrp() calls. As I tested modified kernel there is no
observed effect now. So I send patchs.

There are some places where kill_pgrp() call is used and some variable
is changed after it. It should be considered if this code is always
working properly or some race scheduler condition exists.

Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>

--=20
Adam Tla=C5=82ka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^
System  & Network Administration Group       - - - ~~~~~~
Computer Center, Gda=C5=84sk University of Technology, Poland

--MP_Tf+wQz.2IOjvc_o2_H0NYIP
Content-Type: text/x-patch; name=2.6.26.2_tty_io.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=2.6.26.2_tty_io.patch

--- drivers/char/tty_io_orig.c	2008-10-06 11:03:39.000000000 +0200
+++ drivers/char/tty_io.c	2008-10-06 11:20:54.000000000 +0200
@@ -3021,6 +3021,9 @@ static int tiocswinsz(struct tty_struct 
 	rpgrp = get_pid(real_tty->pgrp);
 	spin_unlock_irqrestore(&tty->ctrl_lock, flags);
 
+	tty->winsize = tmp_ws;
+	real_tty->winsize = tmp_ws;
+
 	if (pgrp)
 		kill_pgrp(pgrp, SIGWINCH, 1);
 	if (rpgrp != pgrp && rpgrp)
@@ -3028,9 +3031,6 @@ static int tiocswinsz(struct tty_struct 
 
 	put_pid(pgrp);
 	put_pid(rpgrp);
-
-	tty->winsize = tmp_ws;
-	real_tty->winsize = tmp_ws;
 done:
 	mutex_unlock(&tty->termios_mutex);
 	return 0;

--MP_Tf+wQz.2IOjvc_o2_H0NYIP
Content-Type: text/x-patch; name=2.6.26.2_vt.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=2.6.26.2_vt.patch

--- drivers/char/vt_orig.c	2008-10-06 11:01:26.000000000 +0200
+++ drivers/char/vt.c	2008-10-06 11:59:48.000000000 +0200
@@ -921,11 +921,11 @@ int vc_resize(struct vc_data *vc, unsign
 		if ((ws.ws_row != cws->ws_row || ws.ws_col != cws->ws_col))
 			pgrp = get_pid(vc->vc_tty->pgrp);
 		spin_unlock_irq(&vc->vc_tty->ctrl_lock);
+		*cws = ws;
 		if (pgrp) {
 			kill_pgrp(vc->vc_tty->pgrp, SIGWINCH, 1);
 			put_pid(pgrp);
 		}
-		*cws = ws;
 		mutex_unlock(&vc->vc_tty->termios_mutex);
 	}
 

--MP_Tf+wQz.2IOjvc_o2_H0NYIP--
