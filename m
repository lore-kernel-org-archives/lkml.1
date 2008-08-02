Return-Path: <linux-kernel-owner+w=401wt.eu-S1755289AbYHBMu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289AbYHBMu1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 08:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752806AbYHBMuO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 08:50:14 -0400
Received: from gustav.zipernowsky.hu ([193.225.20.248]:60106 "EHLO
	gustav.zipernowsky.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbYHBMuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 08:50:13 -0400
MIME-Version: 1.0
Date: Sat, 02 Aug 2008 14:15:19 +0200
From: Oliver Pinter <oliver@zipernowsky.hu>
To: Aristeu Rozanski <arozansk@redhat.com>, stable@kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Oliver Pinter <oliver.pntr@gmail.com>, linux-kernel@vger.kernel.org
Subject: [RFC, 2.6.26.2-rc1] 8250: fix break handling for Intel 82571
Reply-To: oliver.pntr@gmail.com
Message-ID: <1d4319c1f50ad90092a972689d90a707@zipernowsky.hu>
User-Agent: RoundCube Webmail/0.1
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 7500b1f602aad75901774a67a687ee985d85893f Mon Sep 17 00:00:00 2001
From: Aristeu Rozanski <arozansk@redhat.com>
Date: Wed, 23 Jul 2008 21:29:45 -0700
Subject: [PATCH] 8250: fix break handling for Intel 82571

[ Upstream commit 7500b1f602aad75901774a67a687ee985d85893f ]

Intel 82571 has a "Serial Over LAN" feature that doesn't properly
implements the receiving of break characters.  When a break is received,
it doesn't set UART_LSR_DR and unless another character is received, the
break won't be received by the application.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Acked-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
CC: Oliver Pinter <oliver.pntr@gmail.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 27f34a9..a97f1ae 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1293,7 +1293,18 @@ receive_chars(struct uart_8250_port *up, unsigned
int *status)
 	char flag;
 
 	do {
-		ch = serial_inp(up, UART_RX);
+		if (likely(lsr & UART_LSR_DR))
+			ch = serial_inp(up, UART_RX);
+		else
+			/*
+			 * Intel 82571 has a Serial Over Lan device that will
+			 * set UART_LSR_BI without setting UART_LSR_DR when
+			 * it receives a break. To avoid reading from the
+			 * receive buffer without UART_LSR_DR bit set, we
+			 * just force the read character to be 0
+			 */
+			ch = 0;
+
 		flag = TTY_NORMAL;
 		up->port.icount.rx++;
 
@@ -1342,7 +1353,7 @@ receive_chars(struct uart_8250_port *up, unsigned int
*status)
 
 ignore_char:
 		lsr = serial_inp(up, UART_LSR);
-	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
+	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
 	tty_flip_buffer_push(tty);
 	spin_lock(&up->port.lock);
@@ -1425,7 +1436,7 @@ serial8250_handle_port(struct uart_8250_port *up)
 
 	DEBUG_INTR("status = %x...", status);
 
-	if (status & UART_LSR_DR)
+	if (status & (UART_LSR_DR | UART_LSR_BI))
 		receive_chars(up, &status);
 	check_modem_status(up);
 	if (status & UART_LSR_THRE)


