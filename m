Return-Path: <linux-kernel-owner+w=401wt.eu-S933906AbYBTUmX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933906AbYBTUmX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:42:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYBTUmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:42:03 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41238 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754188AbYBTUmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:42:01 -0500
Date: Wed, 20 Feb 2008 20:32:58 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] viocons: BKL locking
Message-ID: <20080220203258.4b33f890@core>
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

For some weird reason I can't ascertain (translation "I think its
broken") the viocons driver calls directly into the n_tty ldisc code even
if another ldisc is in use. It'll probably break if you do that but I'm
just fixing the locking and adding a comment that its horked.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/viocons.c linux-2.6.25-rc2-mm1/drivers/char/viocons.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/viocons.c	2008-02-19 11:01:44.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/viocons.c	2008-02-20 11:49:24.000000000 +0000
@@ -704,8 +704,11 @@
 	case KDSKBLED:
 		return 0;
 	}
-
-	return n_tty_ioctl(tty, file, cmd, arg);
+	/* FIXME: WTF is this being called for ??? */
+	lock_kernel();
+	ret =  n_tty_ioctl(tty, file, cmd, arg);
+	unlock_kernel();
+	return ret;
 }
 
 /*
