Return-Path: <linux-kernel-owner+w=401wt.eu-S1753161AbYDMR3Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161AbYDMR3Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:29:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbYDMR3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:29:17 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:54849 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751536AbYDMR3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:29:16 -0400
Date: Sun, 13 Apr 2008 18:24:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pty: prepare for tty->ops changes
Message-ID: <20080413182448.04334ab1@core>
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

We are about to change the tty layer to avoid keeping private copies of
all the methods in each tty. We have to update the pty layer first as it
currently patches the ioctl method according to the tty type. Use
multiple tty operations sets instead.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/pty.c linux-2.6.25-rc8-mm2/drivers/char/pty.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/pty.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/pty.c	2008-04-13 15:40:58.000000000 +0100
@@ -254,6 +254,18 @@
 static int legacy_count = CONFIG_LEGACY_PTY_COUNT;
 module_param(legacy_count, int, 0);
 
+static const struct tty_operations pty_ops_bsd = {
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+	.ioctl = pty_bsd_ioctl,
+};
+
 static void __init legacy_pty_init(void)
 {
 	if (legacy_count <= 0)
@@ -284,7 +296,6 @@
 	pty_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW;
 	pty_driver->other = pty_slave_driver;
 	tty_set_operations(pty_driver, &pty_ops);
-	pty_driver->ioctl = pty_bsd_ioctl;
 
 	pty_slave_driver->owner = THIS_MODULE;
 	pty_slave_driver->driver_name = "pty_slave";
@@ -377,6 +388,19 @@
 	return -ENOIOCTLCMD;
 }
 
+static const struct tty_operations pty_unix98_ops = {
+	.open = pty_open,
+	.close = pty_close,
+	.write = pty_write,
+	.write_room = pty_write_room,
+	.flush_buffer = pty_flush_buffer,
+	.chars_in_buffer = pty_chars_in_buffer,
+	.unthrottle = pty_unthrottle,
+	.set_termios = pty_set_termios,
+	.ioctl = pty_unix98_ioctl
+};
+
+
 static void __init unix98_pty_init(void)
 {
 	ptm_driver = alloc_tty_driver(NR_UNIX98_PTY_MAX);
@@ -403,8 +427,7 @@
 	ptm_driver->flags = TTY_DRIVER_RESET_TERMIOS | TTY_DRIVER_REAL_RAW |
 		TTY_DRIVER_DYNAMIC_DEV | TTY_DRIVER_DEVPTS_MEM;
 	ptm_driver->other = pts_driver;
-	tty_set_operations(ptm_driver, &pty_ops);
-	ptm_driver->ioctl = pty_unix98_ioctl;
+	tty_set_operations(ptm_driver, &pty_unix98_ops);
 
 	pts_driver->owner = THIS_MODULE;
 	pts_driver->driver_name = "pty_slave";
