Return-Path: <linux-kernel-owner+w=401wt.eu-S1758599AbZBTPeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599AbZBTPeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 10:34:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZBTPe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 10:34:28 -0500
Received: from mba.ocn.ne.jp ([122.1.235.107]:62563 "EHLO smtp.mba.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695AbZBTPe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 10:34:27 -0500
From: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, ralf@linux-mips.org, alan@lxorguk.ukuu.org.uk
Subject: [PATCH] serial_txx9: use container_of instead of direct cast
Date: Sat, 21 Feb 2009 00:34:28 +0900
Message-Id: <1235144068-17792-1-git-send-email-anemo@mba.ocn.ne.jp>
X-Mailer: git-send-email 1.5.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
---
 drivers/serial/serial_txx9.c |   39 ++++++++++++++++++++++-----------------
 1 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/serial/serial_txx9.c b/drivers/serial/serial_txx9.c
index 54dd16d..bed3e41 100644
--- a/drivers/serial/serial_txx9.c
+++ b/drivers/serial/serial_txx9.c
@@ -221,21 +221,26 @@ sio_quot_set(struct uart_txx9_port *up, int quot)
 		sio_out(up, TXX9_SIBGR, 0xff | TXX9_SIBGR_BCLK_T6);
 }
 
+static struct uart_txx9_port *to_uart_txx9_port(struct uart_port *port)
+{
+	return container_of(port, struct uart_txx9_port, port);
+}
+
 static void serial_txx9_stop_tx(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	sio_mask(up, TXX9_SIDICR, TXX9_SIDICR_TIE);
 }
 
 static void serial_txx9_start_tx(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	sio_set(up, TXX9_SIDICR, TXX9_SIDICR_TIE);
 }
 
 static void serial_txx9_stop_rx(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	up->port.read_status_mask &= ~TXX9_SIDISR_RDIS;
 }
 
@@ -246,7 +251,7 @@ static void serial_txx9_enable_ms(struct uart_port *port)
 
 static void serial_txx9_initialize(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned int tmout = 10000;
 
 	sio_out(up, TXX9_SIFCR, TXX9_SIFCR_SWRST);
@@ -414,7 +419,7 @@ static irqreturn_t serial_txx9_interrupt(int irq, void *dev_id)
 
 static unsigned int serial_txx9_tx_empty(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 	unsigned int ret;
 
@@ -427,7 +432,7 @@ static unsigned int serial_txx9_tx_empty(struct uart_port *port)
 
 static unsigned int serial_txx9_get_mctrl(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned int ret;
 
 	/* no modem control lines */
@@ -440,7 +445,7 @@ static unsigned int serial_txx9_get_mctrl(struct uart_port *port)
 
 static void serial_txx9_set_mctrl(struct uart_port *port, unsigned int mctrl)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	if (mctrl & TIOCM_RTS)
 		sio_mask(up, TXX9_SIFLCR, TXX9_SIFLCR_RTSSC);
@@ -450,7 +455,7 @@ static void serial_txx9_set_mctrl(struct uart_port *port, unsigned int mctrl)
 
 static void serial_txx9_break_ctl(struct uart_port *port, int break_state)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 
 	spin_lock_irqsave(&up->port.lock, flags);
@@ -494,7 +499,7 @@ static int serial_txx9_get_poll_char(struct uart_port *port)
 {
 	unsigned int ier;
 	unsigned char c;
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	/*
 	 *	First save the IER then disable the interrupts
@@ -520,7 +525,7 @@ static int serial_txx9_get_poll_char(struct uart_port *port)
 static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
 {
 	unsigned int ier;
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	/*
 	 *	First save the IER then disable the interrupts
@@ -551,7 +556,7 @@ static void serial_txx9_put_poll_char(struct uart_port *port, unsigned char c)
 
 static int serial_txx9_startup(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 	int retval;
 
@@ -596,7 +601,7 @@ static int serial_txx9_startup(struct uart_port *port)
 
 static void serial_txx9_shutdown(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned long flags;
 
 	/*
@@ -636,7 +641,7 @@ static void
 serial_txx9_set_termios(struct uart_port *port, struct ktermios *termios,
 		       struct ktermios *old)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	unsigned int cval, fcr = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
@@ -814,19 +819,19 @@ static void serial_txx9_release_resource(struct uart_txx9_port *up)
 
 static void serial_txx9_release_port(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	serial_txx9_release_resource(up);
 }
 
 static int serial_txx9_request_port(struct uart_port *port)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	return serial_txx9_request_resource(up);
 }
 
 static void serial_txx9_config_port(struct uart_port *port, int uflags)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 	int ret;
 
 	/*
@@ -897,7 +902,7 @@ static void __init serial_txx9_register_ports(struct uart_driver *drv,
 
 static void serial_txx9_console_putchar(struct uart_port *port, int ch)
 {
-	struct uart_txx9_port *up = (struct uart_txx9_port *)port;
+	struct uart_txx9_port *up = to_uart_txx9_port(port);
 
 	wait_for_xmitr(up);
 	sio_out(up, TXX9_SITFIFO, ch);
-- 
1.5.6.3

