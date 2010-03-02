Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341Ab0CBXjE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:39:04 -0500
Received: from kroah.org ([198.145.64.141]:51636 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756393Ab0CBXhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:37:09 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, stable <stable@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 31/36] tty: Fix the ldisc hangup race
Date: Tue,  2 Mar 2010 15:36:38 -0800
Message-Id: <1267573003-782-31-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <20100302230956.GC32287@kroah.com>
References: <20100302230956.GC32287@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

This was noticed by Matthias Urlichs and he proposed a fix. This patch
does the fixing a different way to avoid introducing several new race
conditions into the code.

The problem case is TTY_DRIVER_RESET_TERMIOS = 0. In that case while we
abort the ldisc change, the hangup processing has not cleaned up and restarted
the ldisc either.

We can't restart the ldisc stuff in the set_ldisc as we don't know what
the hangup did and may touch stuff we shouldn't as we are no longer
supposed to influence the tty at that point in case it has been re-opened
before we get rescheduled.

Instead do it the simple way. Always re-init the ldisc on the hangup, but
use TTY_DRIVER_RESET_TERMIOS to indicate that we should force N_TTY.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_ldisc.c |   50 +++++++++++++++++++++++++++------------------
 1 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 3f653f7..500e740 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -706,12 +706,13 @@ static void tty_reset_termios(struct tty_struct *tty)
 /**
  *	tty_ldisc_reinit	-	reinitialise the tty ldisc
  *	@tty: tty to reinit
+ *	@ldisc: line discipline to reinitialize
  *
- *	Switch the tty back to N_TTY line discipline and leave the
- *	ldisc state closed
+ *	Switch the tty to a line discipline and leave the ldisc
+ *	state closed
  */
 
-static void tty_ldisc_reinit(struct tty_struct *tty)
+static void tty_ldisc_reinit(struct tty_struct *tty, int ldisc)
 {
 	struct tty_ldisc *ld;
 
@@ -721,10 +722,10 @@ static void tty_ldisc_reinit(struct tty_struct *tty)
 	/*
 	 *	Switch the line discipline back
 	 */
-	ld = tty_ldisc_get(N_TTY);
+	ld = tty_ldisc_get(ldisc);
 	BUG_ON(IS_ERR(ld));
 	tty_ldisc_assign(tty, ld);
-	tty_set_termios_ldisc(tty, N_TTY);
+	tty_set_termios_ldisc(tty, ldisc);
 }
 
 /**
@@ -745,6 +746,8 @@ static void tty_ldisc_reinit(struct tty_struct *tty)
 void tty_ldisc_hangup(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld;
+	int reset = tty->driver->flags & TTY_DRIVER_RESET_TERMIOS;
+	int err = 0;
 
 	/*
 	 * FIXME! What are the locking issues here? This may me overdoing
@@ -772,25 +775,32 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	wake_up_interruptible_poll(&tty->read_wait, POLLIN);
 	/*
 	 * Shutdown the current line discipline, and reset it to
-	 * N_TTY.
+	 * N_TTY if need be.
+	 *
+	 * Avoid racing set_ldisc or tty_ldisc_release
 	 */
-	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
-		/* Avoid racing set_ldisc or tty_ldisc_release */
-		mutex_lock(&tty->ldisc_mutex);
-		tty_ldisc_halt(tty);
-		if (tty->ldisc) {	/* Not yet closed */
-			/* Switch back to N_TTY */
-			tty_ldisc_reinit(tty);
-			/* At this point we have a closed ldisc and we want to
-			   reopen it. We could defer this to the next open but
-			   it means auditing a lot of other paths so this is
-			   a FIXME */
+	mutex_lock(&tty->ldisc_mutex);
+	tty_ldisc_halt(tty);
+	/* At this point we have a closed ldisc and we want to
+	   reopen it. We could defer this to the next open but
+	   it means auditing a lot of other paths so this is
+	   a FIXME */
+	if (tty->ldisc) {	/* Not yet closed */
+		if (reset == 0) {
+			tty_ldisc_reinit(tty, tty->termios->c_line);
+			err = tty_ldisc_open(tty, tty->ldisc);
+		}
+		/* If the re-open fails or we reset then go to N_TTY. The
+		   N_TTY open cannot fail */
+		if (reset || err) {
+			tty_ldisc_reinit(tty, N_TTY);
 			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
-			tty_ldisc_enable(tty);
 		}
-		mutex_unlock(&tty->ldisc_mutex);
-		tty_reset_termios(tty);
+		tty_ldisc_enable(tty);
 	}
+	mutex_unlock(&tty->ldisc_mutex);
+	if (reset)
+		tty_reset_termios(tty);
 }
 
 /**
-- 
1.7.0.1

