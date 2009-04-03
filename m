Return-Path: <linux-kernel-owner+w=401wt.eu-S1764251AbZDCLSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764251AbZDCLSk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763749AbZDCLSN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:18:13 -0400
Received: from relay.parallels.com ([195.214.232.42]:35842 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762705AbZDCLSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:18:11 -0400
X-Greylist: delayed 458 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Apr 2009 07:18:11 EDT
From: "Denis V. Lunev" <den@openvz.org>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, "Denis V. Lunev" <den@openvz.org>,
       Eric Miao <ymiao3@marvell.com>, Russell King <rmk@arm.linux.org.uk>
Subject: [PATCH 1/1] arm: KGDB support for PXA
Date: Fri, 3 Apr 2009 15:09:41 +0400
Message-ID: <1238756981-11905-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.6.0.6
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Actually, in order to support KGDB over serial console one must
implement two callbacks for character polling. Clone them from
8250 driver with a bit of tuning.

Checked on PXA300 own board.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: Eric Miao <ymiao3@marvell.com>
CC: Russell King <rmk@arm.linux.org.uk>
---
 drivers/serial/pxa.c |   55 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 55 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/pxa.c b/drivers/serial/pxa.c
index f6e3b86..9d4b27b 100644
--- a/drivers/serial/pxa.c
+++ b/drivers/serial/pxa.c
@@ -666,6 +666,57 @@ serial_pxa_console_write(struct console *co, const char *s, unsigned int count)
 	clk_disable(up->clk);
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static int serial_pxa_get_poll_char(struct uart_port *port)
+{
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+	unsigned char lsr = serial_in(up, UART_LSR);
+
+	while (!(lsr & UART_LSR_DR))
+		lsr = serial_in(up, UART_LSR);
+
+	return serial_in(up, UART_RX);
+}
+
+
+static void serial_pxa_put_poll_char(struct uart_port *port,
+			 unsigned char c)
+{
+	unsigned int ier;
+	struct uart_pxa_port *up = (struct uart_pxa_port *)port;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = serial_in(up, UART_IER);
+	serial_out(up, UART_IER, UART_IER_UUE);
+
+	wait_for_xmitr(up);
+	/*
+	 *	Send the character out.
+	 *	If a LF, also do CR...
+	 */
+	serial_out(up, UART_TX, c);
+	if (c == 10) {
+		wait_for_xmitr(up);
+		serial_out(up, UART_TX, 13);
+	}
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(up);
+	serial_out(up, UART_IER, ier);
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 static int __init
 serial_pxa_console_setup(struct console *co, char *options)
 {
@@ -720,6 +771,10 @@ struct uart_ops serial_pxa_pops = {
 	.request_port	= serial_pxa_request_port,
 	.config_port	= serial_pxa_config_port,
 	.verify_port	= serial_pxa_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = serial_pxa_get_poll_char,
+	.poll_put_char = serial_pxa_put_poll_char,
+#endif
 };
 
 static struct uart_driver serial_pxa_reg = {
-- 
1.6.0.6

