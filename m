Return-Path: <linux-kernel-owner+w=401wt.eu-S1757377AbYJWBg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757377AbYJWBg4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 21:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751980AbYJWBgs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 21:36:48 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:35561 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195AbYJWBgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 21:36:47 -0400
Message-ID: <48FFD52E.70409@skyrush.com>
Date: Wed, 22 Oct 2008 19:36:46 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20081002)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] n-tty-fix-buffer-full-gridlock
References: <48F2E450.1070508@skyrush.com> <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
In-Reply-To: <20081022103259.2d04729a@lxorguk.ukuu.org.uk>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------040608010605080709060805"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040608010605080709060805
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit



--------------040608010605080709060805
Content-Type: text/plain;
 name="n-tty-fix-buffer-full-gridlock.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="n-tty-fix-buffer-full-gridlock.patch"

Fix possible gridlocks in ptys/ttys when input and output happens
in stopped state.

One major problem addressed here is when a tty receives considerable input
and a program produces output after the tty is stopped.  In this condition,
both input and output buffers will fill (e.g. in the ptys), causing a kind
of "gridlock" during which neither buffer can empty.  If the user then
tries to free the stopped state with ^Q or interrupt the process with ^C,
nothing will happen, and there is no way to break out of the condition from
within the tty (because the ^C or ^Q character is in a yet-to-be-processed
part of the input buffer).  This is fixed by expanding the case in which
n_tty_set_room() ensures receive_room is not zero, allowing special characters
to be handled (before, it only handled erase characters).  Note that this
patch does not address non-canonical mode, which might be worth considering,
depending on whether that would affect other tty types and situations.

Another similar issue addressed is when the tty will stop polling for input
due to the buffer hitting the size specified by WAKEUP_CHARS.  Again,
a ^C or ^Q will be stuck in a future part of the buffer.  This gridlock
will be eventually broken by enough single input characters to flush
blocks through (if that ever does happen), but this is fixed by adjusting
the n_tty_poll() logic similarly to what is done in n_tty_set_room(), except
we are on the master side of a pty in this case (and we check the slave).

Signed-off-by: Joe Peterson <joe@skyrush.com>
---

diff -Nurp a/drivers/char/n_tty.c b/drivers/char/n_tty.c
--- a/drivers/char/n_tty.c	2008-10-22 18:14:56.573340597 -0600
+++ b/drivers/char/n_tty.c	2008-10-22 18:24:18.573341142 -0600
@@ -114,13 +114,15 @@ static void n_tty_set_room(struct tty_st
 	int	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;
 
 	/*
-	 * If we are doing input canonicalization, and there are no
-	 * pending newlines, let characters through without limit, so
-	 * that erase characters will be handled.  Other excess
-	 * characters will be beeped.
+	 * If we are doing input canonicalization and the tty needs
+	 * to handle signals, xon/off, or erase characters (i.e. no
+	 * pending newlines), let characters through without limit,
+	 * so that these special characters will be handled.
+	 * Other excess characters will be beeped.
 	 */
 	if (left <= 0)
-		left = tty->icanon && !tty->canon_data;
+		left = tty->icanon &&
+		       (L_ISIG(tty) || I_IXON(tty) || !tty->canon_data) ? 1 : 0;
 	tty->receive_room = left;
 }
 
@@ -2053,7 +2055,14 @@ static unsigned int n_tty_poll(struct tt
 			tty->minimum_to_wake = 1;
 	}
 	if (tty->ops->write && !tty_is_writelocked(tty) &&
-			tty_chars_in_buffer(tty) < WAKEUP_CHARS &&
+			((tty->driver->type == TTY_DRIVER_TYPE_PTY &&
+			  tty->driver->subtype == PTY_TYPE_MASTER &&
+			  tty->link &&
+			  tty->link->icanon &&
+			  (L_ISIG(tty->link) ||
+			   I_IXON(tty->link) ||
+			   !tty->link->canon_data)) ||
+			 tty_chars_in_buffer(tty) < WAKEUP_CHARS) &&
 			tty_write_room(tty) > 0)
 		mask |= POLLOUT | POLLWRNORM;
 	return mask;

--------------040608010605080709060805--
