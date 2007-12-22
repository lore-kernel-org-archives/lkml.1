Return-Path: <linux-kernel-owner+w=401wt.eu-S1753661AbXLVOUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661AbXLVOUO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 09:20:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbXLVOUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 09:20:01 -0500
Received: from shadow.wildlava.net ([67.40.138.81]:43978 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbXLVOUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 09:20:00 -0500
Message-ID: <476D1D0E.6000302@skyrush.com>
Date: Sat, 22 Dec 2007 07:19:58 -0700
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071127)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Fix IXANY and restart after signal (e.g. ctrl-C) in n_tty
 line discipline
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------030303070602000003040504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030303070602000003040504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Here is a patch that fixes a couple of issues with ttys in the stopped
state.  See patch below for more details.

Note that this patch assumes that my previous patch from last month
(called "tty-enable-the-echoing-of-c-in-the-n_tty-discipline.patch" in
the -mm tree) has been applied, since part of this patch is adjacent to
that code.

					Happy holidays!  Joe

--------------030303070602000003040504
Content-Type: text/plain;
 name="ixany-restart.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ixany-restart.patch"

Fix two N_TTY line discipline issues related to resuming a stopped TTY
(typically done with ctrl-S):

1) Fix handling of character that resumes a stopped TTY (with IXANY)

With "stty ixany", the TTY line discipline would lose the first character
after the stop, so typing, for example, "hi^Sthere" resulted in "hihere"
(the 't' would cause the resume after ^S, but it would then be thrown away
rather than processed as an input character).  This was inconsistent with
the behavior of other Unix systems.

2) Fix interrupt signal (e.g. ctrl-C) behavior in stopped TTYs

With "stty -ixany" (often the default), interrupt signals were ignored
in a stopped TTY until the TTY was resumed with the start char (typically
ctrl-Q), which was inconsistent with the behavior of other Unix systems.

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -puN a/drivers/char/n_tty.c~tty-fix-ixany-and-restart-after-signal-in-the-n_tty-discipline a/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c~tty-fix-ixany-and-restart-after-signal-in-the-n_tty-discipline	2007-12-20 11:35:05.000000000 -0700
+++ a/drivers/char/n_tty.c	2007-12-20 11:35:36.000000000 -0700
@@ -695,11 +695,8 @@ static inline void n_tty_receive_char(st
 		return;
 	}
 	
-	if (tty->stopped && !tty->flow_stopped &&
-	    I_IXON(tty) && I_IXANY(tty)) {
+	if (tty->stopped && !tty->flow_stopped && I_IXON(tty) && I_IXANY(tty))
 		start_tty(tty);
-		return;
-	}
 	
 	if (I_ISTRIP(tty))
 		c &= 0x7f;
@@ -769,6 +766,8 @@ static inline void n_tty_receive_char(st
 		signal = SIGTSTP;
 		if (c == SUSP_CHAR(tty)) {
 send_signal:
+			if (tty->stopped && !tty->flow_stopped && I_IXON(tty))
+				start_tty(tty);
 			/*
 			 * Echo character, and then send the signal.
 			 * Note that we do not use isig() here because we want

--------------030303070602000003040504--
