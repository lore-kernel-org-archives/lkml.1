Return-Path: <linux-kernel-owner+w=401wt.eu-S1752510AbYKLRQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbYKLRQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:16:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbYKLRP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:15:59 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:62946 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325AbYKLRP5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:15:57 -0500
Date: Thu, 13 Nov 2008 02:16:01 +0900 (JST)
Message-Id: <20081113.021601.30439144.anemo@mba.ocn.ne.jp>
To: hskinnemoen@atmel.com
Cc: linux@bohmer.net, marc.pignat@hevs.ch, linux-kernel@vger.kernel.org
Subject: atmel_serial might lose modem status change
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
X-Fingerprint: 6ACA 1623 39BD 9A94 9B1A  B746 CA77 FE94 2874 D52F
X-Pgp-Public-Key: http://wwwkeys.pgp.net/pks/lookup?op=get&search=0x2874D52F
X-Mailer: Mew version 5.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found a problem of handling of modem status of atmel_serial driver.

With the commit 1ecc26 ("atmel_serial: split the interrupt handler"),
handling of modem status signal was splitted into two parts.  The
atmel_tasklet_func() compares new status with irq_status_prev, but
irq_status_prev is not correct if signal status was changed while the
port is closed.

Here is a sequence to cause problem:

1. Remote side sets CTS (and DSR).
2. Local side close the port.
3. Local side clears RTS and DTR.
4. Remote side clears CTS and DSR.
5. Local side reopen the port.  hw_stopped becomes 1.
6. Local side sets RTS and DTR.
7. Remote side sets CTS and DSR.

Then CTS change interrupt can be received, but since CTS bit in
irq_status_prev and new status is same, uart_handle_cts_change() will
not be called (so hw_stopped will not be cleared, i.e. cannot send any
data).

I suppose irq_status_prev should be initialized at somewhere in open
sequence.  Is this fix correct?

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 4c535f7..9f3b697 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -877,6 +877,9 @@ static int atmel_startup(struct uart_port *port)
 		}
 	}
 
+	/* Save current CSR for comparison in atmel_tasklet_func() */
+	atmel_port->irq_status_prev = UART_GET_CSR(port);
+
 	/*
 	 * Finally, enable the serial port
 	 */

---
Atsushi Nemoto
