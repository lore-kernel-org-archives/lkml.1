Return-Path: <linux-kernel-owner+w=401wt.eu-S1761282AbYGAQ2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761282AbYGAQ2t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 12:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752618AbYGAQ2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 12:28:36 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:54133 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbYGAQ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 12:28:36 -0400
Message-ID: <486A5B02.5090205@skyrush.com>
Date: Tue, 01 Jul 2008 11:27:46 -0500
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080514)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Ctrl+C doesn't interrupt process waiting for I/O
References: <48661488.10304@gmail.com> <87fxqurqpz.fsf@denkblock.local>	<486A3B4A.2090005@skyrush.com> <877ic5irsu.fsf@denkblock.local>
In-Reply-To: <877ic5irsu.fsf@denkblock.local>
Content-Type: multipart/mixed;
 boundary="------------070509060009060209020207"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070509060009060209020207
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Elias Oltmanns wrote:
> Due to my tests, 2.6.24 responds much faster to Ctrl+C than 2.6.25 does.
> The patch above makes them *feel* alike again (no hard numbers, mind).
> However, I haven't checked anything as early as 2.6.21 or before so I
> don't know whether there may have been another regression since then.

OK, thanks for checking.  Can you try the patch below?  It is almost the
same as your patch, except it reverses the order of the isig and the echo.

This causes ^C echo to work for me in both console and xterm.  Back when
I did the original patch, I was concerned this ordering could result in
the ^C echoing late, but this may not be an issue.

Let me know if the patch below fixes the issue with interrupting
processes waiting for I/O.

				Thanks, Joe

--------------070509060009060209020207
Content-Type: text/x-patch;
 name="ctrl_c.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ctrl_c.patch"

--- linux/drivers/char/n_tty.c.orig	2008-07-01 10:48:05.000000000 -0500
+++ linux/drivers/char/n_tty.c	2008-07-01 11:20:07.000000000 -0500
@@ -759,20 +759,9 @@
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
-			/*
-			 * Echo character, and then send the signal.
-			 * Note that we do not use isig() here because we want
-			 * the order to be:
-			 * 1) flush, 2) echo, 3) signal
-			 */
-			if (!L_NOFLSH(tty)) {
-				n_tty_flush_buffer(tty);
-				tty_driver_flush_buffer(tty);
-			}
+			isig(signal, tty, 0);
 			if (L_ECHO(tty))
 				echo_char(c, tty);
-			if (tty->pgrp)
-				kill_pgrp(tty->pgrp, signal, 1);
 			return;
 		}
 	}

--------------070509060009060209020207--
