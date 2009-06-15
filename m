Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbZFOPjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbZFOPjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757416AbZFOPjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:39:36 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:63356 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757208AbZFOPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:39:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=ceKkKgs1hQhUoVtV69GgPji37331JQdjGpq2Qal8hZQJmKwV3CdGsQXjb759LmsiC2
         GHIApEqsBDL8VloQqlmktpQHva1zxhsnmdRsuEU88iCL67OfqXzu12COhHWJxQsXasCc
         DAF+j2ZG22dzvUL/fPJ47apRFuZijZam4lEsY=
Date: Mon, 15 Jun 2009 17:39:26 +0200
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: [PATCH] tty_ldisc: propagate errors from tty_ldisc_release
Message-ID: <20090615153925.GA27696@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ea6ee429b1f173e6905c3e6251649a6caf93d533 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Mon, 15 Jun 2009 17:26:35 +0200
Subject: [PATCH] tty_ldisc: propagate errors from tty_ldisc_release

This is probably better than just ignoring the errors.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 drivers/char/tty_ldisc.c |   26 ++++++++++++++++++++------
 include/linux/tty.h      |    2 +-
 2 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 39c8f86..1d39e2b 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -840,17 +840,24 @@ int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty)
  *	Called during the final close of a tty/pty pair in order to shut down
  *	the line discpline layer. On exit the ldisc assigned is N_TTY and the
  *	ldisc has not been opened.
+ *
+ *	Returns 0 on success, negative error code otherwise.
  */
 
-void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
+int tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 {
+	int err;
+
 	/*
 	 * Prevent flush_to_ldisc() from rescheduling the work for later.  Then
 	 * kill any delayed work. As this is the final close it does not
 	 * race with the set_ldisc code path.
 	 */
 
-	tty_ldisc_halt(tty);
+	err = tty_ldisc_halt(tty);
+	if (err < 0)
+		return err;
+
 	flush_scheduled_work();
 
 	/*
@@ -859,7 +866,16 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 * side is zero.
 	 */
 
-	tty_ldisc_wait_idle(tty);
+	err = tty_ldisc_wait_idle(tty);
+	if (err < 0)
+		return err;
+
+	/* This will need doing differently if we need to lock */
+	if (o_tty) {
+		err = tty_ldisc_release(o_tty, NULL);
+		if (err < 0)
+			return err;
+	}
 
 	/*
 	 * Shutdown the current line discipline, and reset it to N_TTY.
@@ -868,9 +884,7 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_ldisc_reinit(tty);
-	/* This will need doing differently if we need to lock */
-	if (o_tty)
-		tty_ldisc_release(o_tty, NULL);
+	return 0;
 }
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1488d8c..474abd6 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -461,7 +461,7 @@ extern int tty_register_ldisc(int disc, struct tty_ldisc_ops *new_ldisc);
 extern int tty_unregister_ldisc(int disc);
 extern int tty_set_ldisc(struct tty_struct *tty, int ldisc);
 extern int tty_ldisc_setup(struct tty_struct *tty, struct tty_struct *o_tty);
-extern void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty);
+extern int tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty);
 extern void tty_ldisc_init(struct tty_struct *tty);
 extern void tty_ldisc_begin(void);
 /* This last one is just for the tty layer internals and shouldn't be used elsewhere */
-- 
1.6.0.6

