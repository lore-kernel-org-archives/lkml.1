Return-Path: <linux-kernel-owner+w=401wt.eu-S1760102AbYHZTNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760102AbYHZTNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:13:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYHZTNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:13:37 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44336 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754012AbYHZTNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:13:36 -0400
Date: Tue, 26 Aug 2008 19:55:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: torvalds@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tty: Fix termios tty window resize race with pty/tty
 pair
Message-ID: <20080826195558.309f8163@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kanru Chen posted a patch versus the old code which deals with the case
where you resize the pty side of a pty/tty pair. In that situation the
termios data is updated for both pty and tty but the locks are not held
for the right side.

This implements the fix differently against the updated tty code. Patch
by self but the hard bit (noticing and fixing the bug) is thanks to Kanru
Chen.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/tty_io.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index a27160b..daeb8f7 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -2498,7 +2498,7 @@ static int tiocgwinsz(struct tty_struct *tty, struct winsize __user *arg)
 /**
  *	tty_do_resize		-	resize event
  *	@tty: tty being resized
- *	@real_tty: real tty (if using a pty/tty pair)
+ *	@real_tty: real tty (not the same as tty if using a pty/tty pair)
  *	@rows: rows (character)
  *	@cols: cols (character)
  *
@@ -2512,7 +2512,8 @@ int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
 	struct pid *pgrp, *rpgrp;
 	unsigned long flags;
 
-	mutex_lock(&tty->termios_mutex);
+	/* For a PTY we need to lock the tty side */
+	mutex_lock(&real_tty->termios_mutex);
 	if (!memcmp(ws, &tty->winsize, sizeof(*ws)))
 		goto done;
 	/* Get the PID values and reference them so we can
@@ -2533,7 +2534,7 @@ int tty_do_resize(struct tty_struct *tty, struct tty_struct *real_tty,
 	tty->winsize = *ws;
 	real_tty->winsize = *ws;
 done:
-	mutex_unlock(&tty->termios_mutex);
+	mutex_unlock(&real_tty->termios_mutex);
 	return 0;
 }
 
