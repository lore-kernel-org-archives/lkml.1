Return-Path: <linux-kernel-owner+w=401wt.eu-S1760049AbXEaTeX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049AbXEaTeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:34:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbXEaTeQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:34:16 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:61249 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753185AbXEaTeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:34:15 -0400
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Victor <andrew@sanpeople.com>
Cc: Russell King <rmk@arm.linux.org.uk>, Ivan Kuten <ivan.kuten@promwad.com>,
       Nicolas Ferre <nicolas.ferre@rfo.atmel.com>,
       Patrice Vilchez <patrice.vilchez@rfo.atmel.com>,
       linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH] atmel_serial: Fix break handling
Date: Thu, 31 May 2007 21:31:31 +0200
Message-Id: <11806398911702-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.4.4.4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The RXBRK field in the AT91/AT32 USART status register has the
following definition according to e.g. the AT32AP7000 data sheet:

    RXBRK: Break Received/End of Break
    0: No Break received or End of Break detected since the last RSTSTA.
    1: Break Received or End of Break detected since the last RSTSTA.

Thus, for each break, the USART sets the RXBRK bit twice. This patch
modifies the driver to report the break event to the serial core only
once by keeping track of whether a break condition is currently
active. The break_active flag is reset as soon as a character is
received, so even if we miss the start-of-break interrupt this should
do the right thing.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
It's been almost a year since the last patch I sent attempting to fix
this. Sorry for not following up any sooner.

Anyway, here's a new attempt. It should work even if we miss some
interrupts, and it should not break break handling by ignoring the
return value from uart_handle_break() as Russell pointed out.

There may be cases which aren't handled well: If you send two breaks
with no characters in between and we miss an interrupt on the first
one, the driver probably gets a bit confused. I don't see any way to
fix this, but the driver should get un-confused upon reception of the
next character.

I've tested this with Magic SysRq on ATSTK1000: It works with this
patch but not without. Ivan Kuten reported in a different thread that
SysRq didn't work on AT91RM9200 and I very much doubt it works on
AT91SAM926x.

The break count in /proc/tty/driver/atmel_serial also makes more sense
with this patch applied; without it, the break count increments by two
every time I send a break.

 drivers/serial/atmel_serial.c |   32 ++++++++++++++++++++++++++++++--
 1 files changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index 3320bcd..4d6b3c5 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -114,6 +114,7 @@ struct atmel_uart_port {
 	struct uart_port	uart;		/* uart */
 	struct clk		*clk;		/* uart clock */
 	unsigned short		suspended;	/* is port suspended? */
+	int			break_active;	/* break being received */
 };
 
 static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
@@ -252,6 +253,7 @@ static void atmel_break_ctl(struct uart_port *port, int break_state)
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
+	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *) port;
 	struct tty_struct *tty = port->info->tty;
 	unsigned int status, ch, flg;
 
@@ -267,13 +269,29 @@ static void atmel_rx_chars(struct uart_port *port)
 		 * note that the error handling code is
 		 * out of the main execution path
 		 */
-		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME | ATMEL_US_OVRE | ATMEL_US_RXBRK))) {
+		if (unlikely(status & (ATMEL_US_PARE | ATMEL_US_FRAME
+				       | ATMEL_US_OVRE | ATMEL_US_RXBRK)
+			     || atmel_port->break_active)) {
 			UART_PUT_CR(port, ATMEL_US_RSTSTA);	/* clear error */
-			if (status & ATMEL_US_RXBRK) {
+			if (status & ATMEL_US_RXBRK
+			    && !atmel_port->break_active) {
 				status &= ~(ATMEL_US_PARE | ATMEL_US_FRAME);	/* ignore side-effect */
 				port->icount.brk++;
+				atmel_port->break_active = 1;
+				UART_PUT_IER(port, ATMEL_US_RXBRK);
 				if (uart_handle_break(port))
 					goto ignore_char;
+			} else {
+				/*
+				 * This is either the end-of-break
+				 * condition or we've received at
+				 * least one character without RXBRK
+				 * being set. In both cases, the next
+				 * RXBRK will indicate start-of-break.
+				 */
+				UART_PUT_IDR(port, ATMEL_US_RXBRK);
+				status &= ~ATMEL_US_RXBRK;
+				atmel_port->break_active = 0;
 			}
 			if (status & ATMEL_US_PARE)
 				port->icount.parity++;
@@ -352,6 +370,16 @@ static irqreturn_t atmel_interrupt(int irq, void *dev_id)
 		/* Interrupt receive */
 		if (pending & ATMEL_US_RXRDY)
 			atmel_rx_chars(port);
+		else if (pending & ATMEL_US_RXBRK) {
+			/*
+			 * End of break detected. If it came along
+			 * with a character, atmel_rx_chars will
+			 * handle it.
+			 */
+			UART_PUT_CR(port, ATMEL_US_RSTSTA);
+			UART_PUT_IDR(port, ATMEL_US_RXBRK);
+			atmel_port->break_active = 0;
+		}
 
 		// TODO: All reads to CSR will clear these interrupts!
 		if (pending & ATMEL_US_RIIC) port->icount.rng++;
-- 
1.4.4.4

