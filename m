Return-Path: <linux-kernel-owner+w=401wt.eu-S934063AbYBTUb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063AbYBTUb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbYBTUbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:31:07 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35505 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764769AbYBTUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:31:05 -0500
Date: Wed, 20 Feb 2008 20:21:54 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] nozomi: Prepare for BKL pushdown
Message-ID: <20080220202154.3af6f609@core>
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

We leave the BKL around the rts/dtr handler because there is *no* locking
of any kind on this in the driver. It's not "right" with this change but
it's the same wrong as before..

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/nozomi.c linux-2.6.25-rc2-mm1/drivers/char/nozomi.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/nozomi.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/nozomi.c	2008-02-20 11:45:57.000000000 +0000
@@ -1716,6 +1716,7 @@
 static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear)
 {
+	lock_kernel();		/* FIXME: Add internal locking */
 	if (set & TIOCM_RTS)
 		set_rts(tty, 1);
 	else if (clear & TIOCM_RTS)
@@ -1725,7 +1726,7 @@
 		set_dtr(tty, 1);
 	else if (clear & TIOCM_DTR)
 		set_dtr(tty, 0);
-
+	unlock_kernel();
 	return 0;
 }
 
