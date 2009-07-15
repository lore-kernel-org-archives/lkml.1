Return-Path: <linux-kernel-owner+w=401wt.eu-S1753363AbZGOJAO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbZGOJAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 05:00:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752605AbZGOJAO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 05:00:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39707 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752366AbZGOJAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 05:00:12 -0400
Date: Wed, 15 Jul 2009 10:01:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Pete Clements <clem@clem.clem-digital.net>
Cc: linux-kernel@vger.kernel.org (linux-kernel)
Subject: Re: Oops tty layer -- 31-rc3 and 31-rc2-git10
Message-ID: <20090715100113.44bbe88c@lxorguk.ukuu.org.uk>
In-Reply-To: <200907142347.n6ENl23S001626@clem.clem-digital.net>
References: <200907142347.n6ENl23S001626@clem.clem-digital.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jul 2009 19:47:02 -0400 (EDT)
Pete Clements <clem@clem.clem-digital.net> wrote:

> Fyi:
> Getting the following oops on shutdown with 31-rc2-git10 and 31-rc3.
> (x86 UP)

Yep - testing a fix in -next at the moment.

--


tty: fix close/hangup race

From: Alan Cox <alan@linux.intel.com>

We can get a situation where a hangup occurs during or after a close. In
that case the ldisc gets disposed of by the close and the hangup then
explodes.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_ldisc.c |   25 +++++++++++++++----------
 1 files changed, 15 insertions(+), 10 deletions(-)


diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 913aa8d..5018e08 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -791,17 +791,20 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 * N_TTY.
 	 */
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
-		/* Avoid racing set_ldisc */
+		/* Avoid racing set_ldisc or tty_ldisc_release */
 		mutex_lock(&tty->ldisc_mutex);
-		/* Switch back to N_TTY */
-		tty_ldisc_halt(tty);
-		tty_ldisc_wait_idle(tty);
-		tty_ldisc_reinit(tty);
-		/* At this point we have a closed ldisc and we want to
-		   reopen it. We could defer this to the next open but
-		   it means auditing a lot of other paths so this is a FIXME */
-		WARN_ON(tty_ldisc_open(tty, tty->ldisc));
-		tty_ldisc_enable(tty);
+		if (tty->ldisc) {	/* Not yet closed */
+			/* Switch back to N_TTY */
+			tty_ldisc_halt(tty);
+			tty_ldisc_wait_idle(tty);
+			tty_ldisc_reinit(tty);
+			/* At this point we have a closed ldisc and we want to
+			   reopen it. We could defer this to the next open but
+			   it means auditing a lot of other paths so this is
+			   a FIXME */
+			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
+			tty_ldisc_enable(tty);
+		}
 		mutex_unlock(&tty->ldisc_mutex);
 		tty_reset_termios(tty);
 	}
@@ -866,6 +869,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 
 	tty_ldisc_wait_idle(tty);
 
+	mutex_lock(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
 	 */
@@ -876,6 +880,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 
 	/* Ensure the next open requests the N_TTY ldisc */
 	tty_set_termios_ldisc(tty, N_TTY);
+	mutex_unlock(&tty->ldisc_mutex);
 
 	/* This will need doing differently if we need to lock */
 	if (o_tty)
