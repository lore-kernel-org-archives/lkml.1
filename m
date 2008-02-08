Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbYBHPgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbYBHPgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 10:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756440AbYBHPgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 10:36:06 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:52218 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756341AbYBHPgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 10:36:04 -0500
Date: Fri, 8 Feb 2008 15:29:02 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x25_asy: Fix ref count rule violation
Message-ID: <20080208152902.41eabc23@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x25_asy does not take an ldisc reference before calling the flush method.
Fix it to use the helper function we provide.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.24-mm1/drivers/net/wan/x25_asy.c linux-2.6.24-mm1/drivers/net/wan/x25_asy.c
--- linux.vanilla-2.6.24-mm1/drivers/net/wan/x25_asy.c	2008-02-06 14:13:27.000000000 +0000
+++ linux-2.6.24-mm1/drivers/net/wan/x25_asy.c	2008-02-06 14:34:55.000000000 +0000
@@ -554,6 +554,7 @@
 static int x25_asy_open_tty(struct tty_struct *tty)
 {
 	struct x25_asy *sl = (struct x25_asy *) tty->disc_data;
+	struct tty_ldisc *ld;
 	int err;
 
 	/* First make sure we're not already connected. */
@@ -572,9 +573,7 @@
 	if (tty->driver->flush_buffer)  {
 		tty->driver->flush_buffer(tty);
 	}
-	if (tty->ldisc.flush_buffer)  {
-		tty->ldisc.flush_buffer(tty);
-	}
+	tty_ldisc_flush(tty);
 
 	/* Restore default settings */
 	sl->dev->type = ARPHRD_X25;
