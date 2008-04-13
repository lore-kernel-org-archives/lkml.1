Return-Path: <linux-kernel-owner+w=401wt.eu-S1752962AbYDMRay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbYDMRay (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751842AbYDMRar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:30:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:40751 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751646AbYDMRaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:30:46 -0400
Date: Sun, 13 Apr 2008 18:26:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pc300: Update to tty_set_operations
Message-ID: <20080413182621.73a4e2a2@core>
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

This driver somehow escaped the tty operations changes way back when.
Update it so that we can switch to tty->ops shortly.

Signed-off-by: Alan Cox <alan@redhat.com>
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/net/wan/pc300_tty.c linux-2.6.25-rc8-mm2/drivers/net/wan/pc300_tty.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/net/wan/pc300_tty.c	2008-04-13 12:55:52.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/net/wan/pc300_tty.c	2008-04-13 15:41:35.000000000 +0100
@@ -178,6 +178,20 @@
 	CPC_TTY_UNLOCK(card,flags); 
 }
 
+
+static const struct tty_operations pc300_ops = {
+	.open = cpc_tty_open,
+	.close = cpc_tty_close,
+	.write = cpc_tty_write, 
+	.write_room = cpc_tty_write_room, 
+	.chars_in_buffer = cpc_tty_chars_in_buffer, 
+	.tiocmset = pc300_tiocmset,
+	.tiocmget = pc300_tiocmget,
+	.flush_buffer = cpc_tty_flush_buffer, 
+	.hangup = cpc_tty_hangup,
+};
+
+
 /*
  * PC300 TTY initialization routine
  *
@@ -225,15 +239,7 @@
 		serial_drv.flags = TTY_DRIVER_REAL_RAW;
 
 		/* interface routines from the upper tty layer to the tty driver */
-		serial_drv.open = cpc_tty_open;
-		serial_drv.close = cpc_tty_close;
-		serial_drv.write = cpc_tty_write; 
-		serial_drv.write_room = cpc_tty_write_room; 
-		serial_drv.chars_in_buffer = cpc_tty_chars_in_buffer; 
-		serial_drv.tiocmset = pc300_tiocmset;
-		serial_drv.tiocmget = pc300_tiocmget;
-		serial_drv.flush_buffer = cpc_tty_flush_buffer; 
-		serial_drv.hangup = cpc_tty_hangup;
+		tty_set_operations(&serial_drv, &pc300_ops);
 
 		/* register the TTY driver */
 		if (tty_register_driver(&serial_drv)) { 

