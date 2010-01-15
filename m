Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757125Ab0AOLNW (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 06:13:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958Ab0AOLNT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 06:13:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39145 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756711Ab0AOLNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 06:13:17 -0500
Date: Fri, 15 Jan 2010 11:16:27 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ldisc switching on a HUPped pty hangs the caller
Message-ID: <20100115111627.1f7c52b3@lxorguk.ukuu.org.uk>
In-Reply-To: <1263532072.22171.24.camel@kiste>
References: <1263532072.22171.24.camel@kiste>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Give this a spin
tty: Fix the ldisc hangup race

From: Alan Cox <alan@linux.intel.com>

This was noticed by Matthias Urlichs and he proposed a fix. This patch
does the fixing a different way to avoid introducing several new race
conditions into the code.

The problem case is TTY_DRIVER_RESET_TERMIOS = 0. In that case while we
abort the ldisc change the hangup processing has not cleaned up and restarted
the ldisc either.

We can't restart the ldisc stuff in the set_ldisc as we don't know what
the hangup did and may touch stuff we shouldn't as we are no longer
supposed to influence the tty at that point in case it has been re-opened
before we get rescheduled.

Instead do it the simple way. Always re-init the ldisc on the hangup, but
use TTY_DRIVER_RESET_TERMIOS to indicate that we should force N_TTY.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_ldisc.c |   50 ++++++++++++++++++++++++++++------------------
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
