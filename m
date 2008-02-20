Return-Path: <linux-kernel-owner+w=401wt.eu-S934699AbYBTUuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934699AbYBTUuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759465AbYBTUuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:50:21 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57355 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753050AbYBTUuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:50:19 -0500
Date: Wed, 20 Feb 2008 20:41:17 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix tty speed handling on 8250
Message-ID: <20080220204117.2fb5c646@core>
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

We try and write the correct speed back but the serial midlayer already
mangles the speed on us and that means if we request B0 we report back
B9600 when we should not. For now we'll hack around this in the drivers
and serial code, pending a better long term solution.

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/serial/8250.c linux-2.6.25-rc2-mm1/drivers/serial/8250.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/serial/8250.c	2008-02-19 11:03:01.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/serial/8250.c	2008-02-20 16:31:16.000000000 +0000
@@ -2174,7 +2174,9 @@
 	}
 	serial8250_set_mctrl(&up->port, up->port.mctrl);
 	spin_unlock_irqrestore(&up->port.lock, flags);
-	tty_termios_encode_baud_rate(termios, baud, baud);
+	/* Don't rewrite B0 */
+	if (tty_termios_baud_rate(termios))
+		tty_termios_encode_baud_rate(termios, baud, baud);
 }
 
 static void
