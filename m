Return-Path: <linux-kernel-owner+w=401wt.eu-S1758018AbYEPOQF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758018AbYEPOQF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 10:16:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYEPOPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 10:15:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbYEPOPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 10:15:36 -0400
Date: Thu, 15 May 2008 14:30:48 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] 8250: fix break handling for Intel 82571
Message-ID: <20080515183039.GA8829@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel 82571 has a "Serial Over LAN" feature that doesn't properly implements
the receiving of break characters. When a break is received, it doesn't set
UART_LSR_DR and unless another character is received, the break won't be
received by the application.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

---
 drivers/serial/8250.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- linus-2.6.orig/drivers/serial/8250.c	2008-05-15 13:32:48.000000000 -0400
+++ linus-2.6/drivers/serial/8250.c	2008-05-15 13:48:59.000000000 -0400
@@ -1296,7 +1296,18 @@ receive_chars(struct uart_8250_port *up,
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
 
@@ -1345,7 +1356,7 @@ receive_chars(struct uart_8250_port *up,
 
 ignore_char:
 		lsr = serial_inp(up, UART_LSR);
-	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
+	} while ((lsr & (UART_LSR_DR | UART_LSR_BI)) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
 	tty_flip_buffer_push(tty);
 	spin_lock(&up->port.lock);
@@ -1428,7 +1439,7 @@ serial8250_handle_port(struct uart_8250_
 
 	DEBUG_INTR("status = %x...", status);
 
-	if (status & UART_LSR_DR)
+	if (status & (UART_LSR_DR | UART_LSR_BI))
 		receive_chars(up, &status);
 	check_modem_status(up);
 	if (status & UART_LSR_THRE)
