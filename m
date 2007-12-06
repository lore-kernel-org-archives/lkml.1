Return-Path: <linux-kernel-owner+w=401wt.eu-S1755430AbXLFTWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430AbXLFTWO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 14:22:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbXLFTV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 14:21:59 -0500
Received: from shadow.wildlava.net ([67.40.138.81]:45444 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbXLFTV6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 14:21:58 -0500
Message-ID: <47584BD3.8080306@skyrush.com>
Date: Thu, 06 Dec 2007 12:21:55 -0700
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071127)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, alan@redhat.com
Subject: [PATCH] Enabling the echo of ctrl-C (and the like)
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------020602060601040708030900"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020602060601040708030900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Attached is a patch that turns on INTR/QUIT/SUSP echoing in the N_TTY
line discipline (e.g. ctrl-C will appear as "^C" if stty echoctl is set
and ctrl-C is set as INTR).

Linux seems to be the only unix-like OS (recently I've verified this on
Solaris, BSD, and Mac OS X) that does *not* behave this way, and I
really miss this as a good visual confirmation of the interrupt of a
program in the console or xterm.  I remember this fondly from many Unixs
I've used over the years as well.  Bringing this to Linux also seems
like a good way to make it yet more compliant with standard unix-like
behavior.

The fix is pretty trivial.  Let me know if you think this is a candidate
for inclusion in the kernel.

					Thanks, Joe

--------------020602060601040708030900
Content-Type: text/plain;
 name="echo-ctrl-c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="echo-ctrl-c.patch"

--- linux-2.6.22-gentoo-r9/drivers/char/n_tty.c	2007-07-08 17:32:17.000000000 -0600
+++ linux-2.6.22-gentoo-r9.new/drivers/char/n_tty.c	2007-12-06 07:16:56.000000000 -0700
@@ -760,7 +760,22 @@
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
-			isig(signal, tty, 0);
+			/*
+			 * Echo character, and then send the signal.
+			 * Note that we do not use isig() here because we want
+			 * the order to be:
+			 * 1) flush, 2) echo, 3) signal
+			 */
+			if (!L_NOFLSH(tty)) {
+				n_tty_flush_buffer(tty);
+				if (tty->driver->flush_buffer)
+					tty->driver->flush_buffer(tty);
+			}
+			if (L_ECHO(tty)) {
+				echo_char(c, tty);
+			}
+			if (tty->pgrp)
+				kill_pgrp(tty->pgrp, signal, 1);
 			return;
 		}
 	}

--------------020602060601040708030900--
