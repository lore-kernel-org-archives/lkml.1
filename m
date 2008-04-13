Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbYDMROM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbYDMROM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 13:14:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756438AbYDMRN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 13:13:58 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46926 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754594AbYDMRN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 13:13:57 -0400
Date: Sun, 13 Apr 2008 18:09:57 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: [PATCH] amiserial: Switch put char to return success/fail
Message-ID: <20080413180957.1100a711@core>
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

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc8-mm2/drivers/char/amiserial.c linux-2.6.25-rc8-mm2/drivers/char/amiserial.c
--- linux.vanilla-2.6.25-rc8-mm2/drivers/char/amiserial.c	2008-04-13 15:36:53.000000000 +0100
+++ linux-2.6.25-rc8-mm2/drivers/char/amiserial.c	2008-04-13 15:50:20.000000000 +0100
@@ -832,33 +832,34 @@
 	local_irq_restore(flags);
 }
 
-static void rs_put_char(struct tty_struct *tty, unsigned char ch)
+static int rs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct async_struct *info;
 	unsigned long flags;
 
 	if (!tty)
-		return;
+		return 0;
 
 	info = tty->driver_data;
 
 	if (serial_paranoia_check(info, tty->name, "rs_put_char"))
-		return;
+		return 0;
 
 	if (!info->xmit.buf)
-		return;
+		return 0;
 
 	local_irq_save(flags);
 	if (CIRC_SPACE(info->xmit.head,
 		       info->xmit.tail,
 		       SERIAL_XMIT_SIZE) == 0) {
 		local_irq_restore(flags);
-		return;
+		return 0;
 	}
 
 	info->xmit.buf[info->xmit.head++] = ch;
 	info->xmit.head &= SERIAL_XMIT_SIZE-1;
 	local_irq_restore(flags);
+	return 1;
 }
 
 static void rs_flush_chars(struct tty_struct *tty)
