Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934927Ab0CMBYz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:24:55 -0500
Received: from kroah.org ([198.145.64.141]:60762 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934922Ab0CMAUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:20:13 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:15:10 2010
Message-Id: <20100313001509.980265580@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:12:33 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Cox <alan@linux.intel.com>
Subject: [patch 055/123] tty: Fix the ldisc hangup race
In-Reply-To: <20100313001618.GA9811@kroah.com>
In-Reply-To: <20100313001618.GA9811@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let me know.

-----------------

From: Alan Cox <alan@linux.intel.com>

commit 638b9648ab51c9c549ff5735d3de519ef6199df3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/tty_ldisc.c |   50 ++++++++++++++++++++++++++++-------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -706,12 +706,13 @@ static void tty_reset_termios(struct tty
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
 
@@ -721,10 +722,10 @@ static void tty_ldisc_reinit(struct tty_
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
@@ -745,6 +746,8 @@ static void tty_ldisc_reinit(struct tty_
 void tty_ldisc_hangup(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld;
+	int reset = tty->driver->flags & TTY_DRIVER_RESET_TERMIOS;
+	int err = 0;
 
 	/*
 	 * FIXME! What are the locking issues here? This may me overdoing
@@ -772,25 +775,32 @@ void tty_ldisc_hangup(struct tty_struct
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


