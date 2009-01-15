Return-Path: <linux-kernel-owner+w=401wt.eu-S1765015AbZAONb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765015AbZAONb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 08:31:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764767AbZAONak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 08:30:40 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60782 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764750AbZAONai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 08:30:38 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/8] When a break signal is detected,
	the next character should be ignored.
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Thu, 15 Jan 2009 13:30:56 +0000
Message-ID: <20090115133050.21366.18907.stgit@localhost.localdomain>
In-Reply-To: <20090115132718.21366.56187.stgit@localhost.localdomain>
References: <20090115132718.21366.56187.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mischa Jonker <mischa.jonker@nxp.com>

This was not implemented correctly for the pnx8xxx_uart driver.

[From further discussion:
Correct, you can look to it as two separate bugs:
a) the next character is not ignored while it should;
b) the status bits 31-8 are copied to the 'ch' variable while they shouldn't.

Both bugs prevent correct break signal handling (and therefore correct
behaviour of the magic SysRq key). Bug b didn't cause too much trouble
earlier because in most situations the status bits are all zero; for
this case they unfortunately aren't.
]

Signed-off-by: Mischa Jonker <mischa.jonker@nxp.com>
Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/serial/pnx8xxx_uart.c |   23 ++++++++++++-----------
 1 files changed, 12 insertions(+), 11 deletions(-)


diff --git a/drivers/serial/pnx8xxx_uart.c b/drivers/serial/pnx8xxx_uart.c
index 22e30d2..1bb8f1b 100644
--- a/drivers/serial/pnx8xxx_uart.c
+++ b/drivers/serial/pnx8xxx_uart.c
@@ -187,7 +187,7 @@ static void pnx8xxx_rx_chars(struct pnx8xxx_port *sport)
 	status = FIFO_TO_SM(serial_in(sport, PNX8XXX_FIFO)) |
 		 ISTAT_TO_SM(serial_in(sport, PNX8XXX_ISTAT));
 	while (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFIFO)) {
-		ch = serial_in(sport, PNX8XXX_FIFO);
+		ch = serial_in(sport, PNX8XXX_FIFO) & 0xff;
 
 		sport->port.icount.rx++;
 
@@ -198,9 +198,16 @@ static void pnx8xxx_rx_chars(struct pnx8xxx_port *sport)
 		 * out of the main execution path
 		 */
 		if (status & (FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFE |
-					PNX8XXX_UART_FIFO_RXPAR) |
+					PNX8XXX_UART_FIFO_RXPAR |
+					PNX8XXX_UART_FIFO_RXBRK) |
 			      ISTAT_TO_SM(PNX8XXX_UART_INT_RXOVRN))) {
-			if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXPAR))
+			if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXBRK)) {
+				status &= ~(FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFE) |
+					FIFO_TO_SM(PNX8XXX_UART_FIFO_RXPAR));
+				sport->port.icount.brk++;
+				if (uart_handle_break(&sport->port))
+					goto ignore_char;
+			} else if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXPAR))
 				sport->port.icount.parity++;
 			else if (status & FIFO_TO_SM(PNX8XXX_UART_FIFO_RXFE))
 				sport->port.icount.frame++;
@@ -284,14 +291,8 @@ static irqreturn_t pnx8xxx_int(int irq, void *dev_id)
 	/* Get the interrupts */
 	status  = serial_in(sport, PNX8XXX_ISTAT) & serial_in(sport, PNX8XXX_IEN);
 
-	/* Break signal received */
-	if (status & PNX8XXX_UART_INT_BREAK) {
-		sport->port.icount.brk++;
-		uart_handle_break(&sport->port);
-	}
-
-	/* Byte received */
-	if (status & PNX8XXX_UART_INT_RX)
+	/* Byte or break signal received */
+	if (status & (PNX8XXX_UART_INT_RX | PNX8XXX_UART_INT_BREAK))
 		pnx8xxx_rx_chars(sport);
 
 	/* TX holding register empty - transmit a byte */

