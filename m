Return-Path: <linux-kernel-owner+w=401wt.eu-S1754775AbZGFOj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775AbZGFOj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZGFOjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:39:51 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37774 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753420AbZGFOjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:39:51 -0400
Date: Mon, 6 Jul 2009 15:40:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.31-rc tty layer instabilities
Message-ID: <20090706154054.7755e07b@lxorguk.ukuu.org.uk>
In-Reply-To: <200907061343.n66DhDbC004009@pilspetsen.it.uu.se>
References: <200907061343.n66DhDbC004009@pilspetsen.it.uu.se>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With 2.6.31-rc1 I saw warnings like the following:

Somehow you got a closed ldisc being closed again which means the hangup
raced some other event.

> With 2.6.31-rc2 I instead see oopses:

I put in a NULL assignment to force any offenders to explode.

We've executed tty_ldisc_release on the port meaning we already took the
path through tty_release_dev() which is called when the final close() of
the tty occurs.

After this we've come via disassociate_ctty into a hangup (caused by us
being the controlling tty owner who exits).

> Jul  6 15:23:49 brewer kernel:  [<c0232c1c>] ? tty_ldisc_hangup+0xdc/0x1d0
> Jul  6 15:23:49 brewer kernel:  [<c022bbb5>] ? do_tty_hangup+0xc5/0x340
> Jul  6 15:23:49 brewer kernel:  [<c022c19f>] ? disassociate_ctty+0x3f/0x1d0

At this point we hold a kref to the tty still but the tty->ldisc is dead

In the normal case we would be fine as we kill off any pending hangup
processing in the close down. In this case we are not because the hangup
process was initiated after the last close

> This happens perhaps once every 5 or so reboots. I haven't yet seen
> any specific usage pattern that might be the trigger.

I suspect its simply a matter of timing randomness.

Does this help:

tty: defer ldisc kill

From: Alan Cox <alan@linux.intel.com>

A hangup event can commence after the tty close path completes. In that
situation we will crash as we freed the ldisc object. Instead free the ldisc
when the last kref is dropped.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_ldisc.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)


diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 913aa8d..97b3365 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -768,8 +768,16 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 	 * removed the irqlock.
 	 */
 	ld = tty_ldisc_ref(tty);
+	/* We may have no line discipline at this point. If we have no
+	   ldisc then either the ldisc is changing in which case the set_ldisc
+	   will continue after our hangup, see the HUPPED flag and exit, or
+	   we have a hangup on a device that is not open - eg a console going
+	   away on exit. In that case ld will be NULL and we mut leave it
+	   alone. In the case where we hold the ld handle we know the tty
+	   cannot progress to closed state until we call tty_ldisc_deref,
+	   and that protects us from closure under the hangup */
+
 	if (ld != NULL) {
-		/* We may have no line discipline at this point */
 		if (ld->ops->flush_buffer)
 			ld->ops->flush_buffer(tty);
 		tty_driver_flush_buffer(tty);
@@ -778,7 +786,6 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 			ld->ops->write_wakeup(tty);
 		if (ld->ops->hangup)
 			ld->ops->hangup(tty);
-		tty_ldisc_deref(ld);
 	}
 	/*
 	 * FIXME: Once we trust the LDISC code better we can wait here for
@@ -794,17 +801,27 @@ void tty_ldisc_hangup(struct tty_struct *tty)
 		/* Avoid racing set_ldisc */
 		mutex_lock(&tty->ldisc_mutex);
 		/* Switch back to N_TTY */
-		tty_ldisc_halt(tty);
-		tty_ldisc_wait_idle(tty);
-		tty_ldisc_reinit(tty);
-		/* At this point we have a closed ldisc and we want to
-		   reopen it. We could defer this to the next open but
-		   it means auditing a lot of other paths so this is a FIXME */
-		WARN_ON(tty_ldisc_open(tty, tty->ldisc));
-		tty_ldisc_enable(tty);
+		if (ld) {
+			/* Only rework the ldisc if we have one enabled */
+			tty_ldisc_halt(tty);
+			tty_ldisc_wait_idle(tty);
+			tty_ldisc_reinit(tty);
+			/* At this point we have a closed ldisc and we want to
+			   reopen it. We could defer this to the next open but
+			   it means auditing a lot of other paths so this is a
+			   FIXME */
+			WARN_ON(tty_ldisc_open(tty, tty->ldisc));
+			tty_ldisc_enable(tty);
+		}
 		mutex_unlock(&tty->ldisc_mutex);
+		/* Our ldisc ref protects this if live. Need to review
+		   the case of hangup v open further */
 		tty_reset_termios(tty);
 	}
+	if (ld)
+		tty_ldisc_deref(ld);
+	/* At this point any pending close/open that is blocked in
+	   tty_ldisc_wait_idle will be able to continue */
 }
 
 /**
