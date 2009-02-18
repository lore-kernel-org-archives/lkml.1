Return-Path: <linux-kernel-owner+w=401wt.eu-S1753532AbZBRNgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbZBRNgx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 08:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbZBRNgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 08:36:44 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:53886 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbZBRNgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 08:36:43 -0500
Date: Wed, 18 Feb 2009 22:36:41 +0900 (JST)
Message-Id: <20090218.223641.128619445.anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org, jason.wessel@windriver.com
Subject: [PATCH resend] kgdb: kgdboc console poll hooks for serial_txx9 uart
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

Implement the serial polling hooks for the serial_txx9 uart for use
with kgdboc.

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Acked-by: Jason Wessel <jason.wessel@windriver.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
---
This patch once got SOB from Jason on Jul 2008 and (perhaps) merged
into kgdb-next branch, but lost somewhere then.
I resend it now with Jason's Acked-by.

 drivers/serial/serial_txx9.c |  113 ++++++++++++++++++++++++++++++++++--------
 1 files changed, 92 insertions(+), 21 deletions(-)

diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 8fcb4c5..6f18215 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -461,6 +461,94 @@ static void serial_txx9_break_ctl(struct uart_port *port, int break_state)
 	spin_unlock_irqrestore(&up->port.lock, flags);
 }
 
+#if defined(CONFIG_SERIAL_TXX9_CONSOLE) || (CONFIG_CONSOLE_POLL)
+/*
+ *	Wait for transmitter & holding register to empty
+ */
+static void wait_for_xmitr(struct uart_txx9_port *up)
+{
+	unsigned int tmout = 10000;
+
+	/* Wait up to 10ms for the character(s) to be sent. */
+	while (--tmout &&
+	       !(sio_in(up, TXX9_SICISR) & TXX9_SICISR_TXALS))
+		udelay(1);
+
+	/* Wait up to 1s for flow control if necessary */
+	if (up->port.flags & UPF_CONS_FLOW) {
+		tmout = 1000000;
+		while (--tmout &&
+		       (sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS))
+			udelay(1);
+	}
+}
+#endif
+
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static int serial_txx9_get_poll_char(struct uart_port *port)
+{
+	unsigned int ier;
+	unsigned char c;
+	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = sio_in(up, TXX9_SIDICR);
+	sio_out(up, TXX9_SIDICR, 0);
+
+	while (sio_in(up, TXX9_SIDISR) & TXX9_SIDISR_UVALID)
+		;
+
+	c = sio_in(up, TXX9_SIRFIFO);
+
+	/*
+	 *	Finally, clear RX interrupt status
+	 *	and restore the IER
+	 */
+	sio_mask(up, TXX9_SIDISR, TXX9_SIDISR_RDIS);
+	sio_out(up, TXX9_SIDICR, ier);
+	return c;
+}
+
+
+static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
+{
+	unsigned int ier;
+	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = sio_in(up, TXX9_SIDICR);
+	sio_out(up, TXX9_SIDICR, 0);
+
+	wait_for_xmitr(up);
+	/*
+	 *	Send the character out.
+	 *	If a LF, also do CR...
+	 */
+	sio_out(up, TXX9_SITFIFO, c);
+	if (c == 10) {
+		wait_for_xmitr(up);
+		sio_out(up, TXX9_SITFIFO, 13);
+	}
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(up);
+	sio_out(up, TXX9_SIDICR, ier);
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 static int serial_txx9_startup(struct uart_port *port)
 {
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
@@ -781,6 +869,10 @@ static struct uart_ops serial_txx9_pops = {
 	.release_port	= serial_txx9_release_port,
 	.request_port	= serial_txx9_request_port,
 	.config_port	= serial_txx9_config_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char	= serial_txx9_get_poll_char,
+	.poll_put_char	= serial_txx9_put_poll_char,
+#endif
 };
 
 static struct uart_txx9_port serial_txx9_ports[UART_NR];
@@ -803,27 +895,6 @@ static void __init serial_txx9_register_ports(struct uart_driver *drv,
 
 #ifdef CONFIG_SERIAL_TXX9_CONSOLE
 
-/*
- *	Wait for transmitter & holding register to empty
- */
-static inline void wait_for_xmitr(struct uart_txx9_port *up)
-{
-	unsigned int tmout = 10000;
-
-	/* Wait up to 10ms for the character(s) to be sent. */
-	while (--tmout &&
-	       !(sio_in(up, TXX9_SICISR) & TXX9_SICISR_TXALS))
-		udelay(1);
-
-	/* Wait up to 1s for flow control if necessary */
-	if (up->port.flags & UPF_CONS_FLOW) {
-		tmout = 1000000;
-		while (--tmout &&
-		       (sio_in(up, TXX9_SICISR) & TXX9_SICISR_CTSS))
-			udelay(1);
-	}
-}
-
 static void serial_txx9_console_putchar(struct uart_port *port, int ch)
 {
 	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
-- 
