Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZAMLOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZAMLOq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 06:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754762AbZAMLOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 06:14:34 -0500
Received: from be1ssnxpe1.nxp.com ([57.67.164.69]:53552 "EHLO
	be1ssnxpe1.nxp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbZAMLOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 06:14:33 -0500
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Jan 2009 06:14:33 EST
Date: Tue, 13 Jan 2009 12:09:13 +0100
From: "Jonker M.D.S.X." <nlv14114@e3.nl-htc01.nxp.com>
Message-Id: <200901131109.n0DB9DRJ010712@pc67243907.ddns.nl-htc01.nxp.com>
To: linux-serial@vger.kernel.org
Subject: [PATCH] serial: pnx8xxx_uart: Fix break signal handling
Cc: linux-kernel@vger.kernel.org, m.d.s.x.jonker@gmail.com
MIME-Version: 1.0
X-NXP-HighTechCampus-MailScanner: Found to be clean
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.7400:2.4.4,1.2.40,4.0.164 definitions=2009-01-13_06:2009-01-08,2009-01-13,2009-01-13 signatures=0
X-Proofpoint-Virus-Version: vendor=fsecure engine=4.65.7400:2.4.4,1.2.40,4.0.164 definitions=2009-01-13_06:2009-01-08,2009-01-13,2009-01-13 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mischa Jonker <mischa.jonker@nxp.com>

When a break signal is detected, the next character should be ignored.
This was not implemented correctly for the pnx8xxx_uart driver.

Signed-off-by: Mischa Jonker <mischa.jonker@nxp.com>
---

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


