Return-Path: <linux-kernel-owner+w=401wt.eu-S1753270AbYDMRZi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270AbYDMRZi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:25:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYDMRZb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:25:31 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54840 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751403AbYDMRZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:25:30 -0400
Date: Sun, 13 Apr 2008 18:20:59 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] consoles: switch to int put_char method
Message-ID: <20080413182059.70ce0733@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/viocons.c linux-2.6.25-rc8-mm2/drivers/char/viocons.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/viocons.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/viocons.c	2008-04-13 15:41:03.000000000 +0100
@@ -628,13 +628,13 @@
 /*
  * TTY put_char method
  */
-static void viotty_put_char(struct tty_struct *tty, unsigned char ch)
+static int viotty_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct port_info *pi;
 
 	pi = get_port_data(tty);
 	if (pi == NULL)
-		return;
+		return 0;
 
 	/* This will append '\r' as well if the char is '\n' */
 	if (viochar_is_console(pi))
@@ -642,6 +642,7 @@
 
 	if (viopath_isactive(pi->lp))
 		internal_write(pi, &ch, 1);
+	return 1;
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/vt.c linux-2.6.25-rc8-mm2/drivers/char/vt.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/vt.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/vt.c	2008-04-13 15:41:03.000000000 +0100
@@ -2641,11 +2641,11 @@
 	return retval;
 }
 
-static void con_put_char(struct tty_struct *tty, unsigned char ch)
+static int con_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	if (in_interrupt())
-		return;	/* n_r3964 calls put_char() from interrupt context */
-	do_con_write(tty, &ch, 1);
+		return 0;	/* n_r3964 calls put_char() from interrupt context */
+	return do_con_write(tty, &ch, 1);
 }
 
 static int con_write_room(struct tty_struct *tty)
