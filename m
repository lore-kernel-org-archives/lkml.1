Return-Path: <linux-kernel-owner+w=401wt.eu-S1754859AbYJJBNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859AbYJJBNh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 21:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753648AbYJJBN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 21:13:29 -0400
Received: from sunrise.pg.gda.pl ([153.19.40.230]:38249 "EHLO
	sunrise.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbYJJBN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 21:13:28 -0400
Date: Fri, 10 Oct 2008 03:12:34 +0200
From: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
To: Adam =?UTF-8?B?VGxhxYJrYQ==?= <atlka@pg.gda.pl>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
Subject: [PATCH 0/1] SIGWINCH problem with terminal apps still alive
Message-ID: <20081010031234.4030b176@merlin.oi.pg.gda.pl>
In-Reply-To: <20081007222857.11f92ca0@merlin.oi.pg.gda.pl>
References: <20081006140708.7911f101@merlin.oi.pg.gda.pl>
	<20081006141306.6a1f0a15@lxorguk.ukuu.org.uk>
	<20081006202834.5b6c5092@merlin.oi.pg.gda.pl>
	<20081006231434.7aaa41ee@lxorguk.ukuu.org.uk>
	<20081007222857.11f92ca0@merlin.oi.pg.gda.pl>
Organization: =?UTF-8?B?R2RhxYRzaw==?= University of Technology
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=MP_6s.3wylyRul.fFvOScF0ahg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_6s.3wylyRul.fFvOScF0ahg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Welcome,

now we have 2.6.26.6 kernel and still terminal resize leads to
undesired effects. It is very inconvenient to wait for 2.6.27 for
corrections.

As Alan Cox previously said mutexes generally work but as we can
observe in case of kill_pgrp() call inside mutex lock we got
race because of rescheduling so lock is not working here.
Rearanging code so the variable change is placed before kill_pgrp()
call removes mentioned race situaction.  =20

Signed-off-by: Adam Tla/lka <atlka@pg.gda.pl>

I strongly suggest to patch actual 2.6.26.x kernel to remove this very
nasty pts behaviour.

Regards

--=20
Adam Tla=C5=82ka       mailto:atlka@pg.gda.pl    ^v^ ^v^ ^v^

--MP_6s.3wylyRul.fFvOScF0ahg
Content-Type: text/x-patch; name=2.6.26.6_tty_io.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=2.6.26.6_tty_io.patch

--- drivers/char/tty_io_orig.c	2008-10-10 02:30:18.000000000 +0200
+++ drivers/char/tty_io.c	2008-10-10 02:33:38.000000000 +0200
@@ -3014,6 +3014,9 @@ static int tiocswinsz(struct tty_struct 
 		}
 	}
 #endif
+	tty->winsize = tmp_ws;
+	real_tty->winsize = tmp_ws;
+
 	/* Get the PID values and reference them so we can
 	   avoid holding the tty ctrl lock while sending signals */
 	spin_lock_irqsave(&tty->ctrl_lock, flags);
@@ -3028,9 +3031,6 @@ static int tiocswinsz(struct tty_struct 
 
 	put_pid(pgrp);
 	put_pid(rpgrp);
-
-	tty->winsize = tmp_ws;
-	real_tty->winsize = tmp_ws;
 done:
 	mutex_unlock(&tty->termios_mutex);
 	return 0;

--MP_6s.3wylyRul.fFvOScF0ahg
Content-Type: text/x-patch; name=2.6.26.6_vt.patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=2.6.26.6_vt.patch

--- drivers/char/vt_orig.c	2008-10-10 02:12:40.000000000 +0200
+++ drivers/char/vt.c	2008-10-10 02:31:28.000000000 +0200
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
 

--MP_6s.3wylyRul.fFvOScF0ahg--
