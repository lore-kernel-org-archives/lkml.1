Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYAXMmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYAXMmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 07:42:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844AbYAXMmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 07:42:06 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:52243 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752321AbYAXMmB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 07:42:01 -0500
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Victor <linux@maxim.org.za>, Remy Bohmer <linux@bohmer.net>,
       Chip Coldwell <coldwell@redhat.com>, Marc Pignat <marc.pignat@hevs.ch>,
       David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: [PATCH -mm v4 8/9] atmel_serial: Use container_of instead of direct cast
Date: Thu, 24 Jan 2008 13:41:50 +0100
Message-Id: <1201178511-12133-9-git-send-email-hskinnemoen@atmel.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
References: <1201178511-12133-1-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-2-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-3-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-4-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-5-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-6-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-7-git-send-email-hskinnemoen@atmel.com>
 <1201178511-12133-8-git-send-email-hskinnemoen@atmel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As pointed out by David Brownell, we really ought to be using
container_of when converting from "struct uart_port *" to "struct
atmel_uart_port *".

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
---
 drivers/serial/atmel_serial.c |   40 +++++++++++++++++++++++-----------------
 1 files changed, 23 insertions(+), 17 deletions(-)

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index e4f9449..2ff92b9 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -157,17 +157,23 @@ static struct atmel_uart_port atmel_ports[ATMEL_MAX_UART];
 static struct console atmel_console;
 #endif
 
+static inline struct atmel_uart_port *
+to_atmel_uart_port(struct uart_port *uart)
+{
+	return container_of(uart, struct atmel_uart_port, uart);
+}
+
 #ifdef CONFIG_SERIAL_ATMEL_PDC
 static bool atmel_use_dma_rx(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	return atmel_port->use_dma_rx;
 }
 
 static bool atmel_use_dma_tx(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	return atmel_port->use_dma_tx;
 }
@@ -330,7 +336,7 @@ static void
 atmel_buffer_rx_char(struct uart_port *port, unsigned int status,
 		     unsigned int ch)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	struct atmel_uart_char *c;
 
@@ -374,7 +380,7 @@ static void atmel_pdc_rxerr(struct uart_port *port, unsigned int status)
  */
 static void atmel_rx_chars(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int status, ch;
 
 	status = UART_GET_CSR(port);
@@ -454,7 +460,7 @@ static void atmel_tx_chars(struct uart_port *port)
 static void
 atmel_handle_receive(struct uart_port *port, unsigned int pending)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_use_dma_rx(port)) {
 		/*
@@ -495,7 +501,7 @@ atmel_handle_receive(struct uart_port *port, unsigned int pending)
 static void
 atmel_handle_transmit(struct uart_port *port, unsigned int pending)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_use_dma_tx(port)) {
 		/* PDC transmit */
@@ -519,7 +525,7 @@ static void
 atmel_handle_status(struct uart_port *port, unsigned int pending,
 		    unsigned int status)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC | ATMEL_US_DCDIC
 				| ATMEL_US_CTSIC)) {
@@ -555,7 +561,7 @@ static irqreturn_t atmel_interrupt(int irq, void *dev_id)
  */
 static void atmel_tx_dma(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *xmit = &port->info->xmit;
 	struct atmel_dma_buffer *pdc = &atmel_port->pdc_tx;
 	int count;
@@ -601,7 +607,7 @@ static void atmel_tx_dma(struct uart_port *port)
 
 static void atmel_rx_from_ring(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct circ_buf *ring = &atmel_port->rx_ring;
 	unsigned int flg;
 	unsigned int status;
@@ -669,7 +675,7 @@ static void atmel_rx_from_ring(struct uart_port *port)
 
 static void atmel_rx_from_dma(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	struct tty_struct *tty = port->info->tty;
 	struct atmel_dma_buffer *pdc;
 	int rx_idx = atmel_port->pdc_rx_idx;
@@ -743,7 +749,7 @@ static void atmel_rx_from_dma(struct uart_port *port)
 static void atmel_tasklet_func(unsigned long data)
 {
 	struct uart_port *port = (struct uart_port *)data;
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	unsigned int status;
 	unsigned int status_change;
 
@@ -788,7 +794,7 @@ static void atmel_tasklet_func(unsigned long data)
  */
 static int atmel_startup(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int retval;
 
 	/*
@@ -898,7 +904,7 @@ static int atmel_startup(struct uart_port *port)
  */
 static void atmel_shutdown(struct uart_port *port)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	/*
 	 * Ensure everything is stopped.
 	 */
@@ -955,7 +961,7 @@ static void atmel_shutdown(struct uart_port *port)
 static void atmel_serial_pm(struct uart_port *port, unsigned int state,
 			    unsigned int oldstate)
 {
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	switch (state) {
 	case 0:
@@ -1427,7 +1433,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 				pm_message_t state)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (device_may_wakeup(&pdev->dev)
 	    && !at91_suspend_entering_slow_clock())
@@ -1443,7 +1449,7 @@ static int atmel_serial_suspend(struct platform_device *pdev,
 static int atmel_serial_resume(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 
 	if (atmel_port->suspended) {
 		uart_resume_port(&atmel_uart, port);
@@ -1502,7 +1508,7 @@ err_alloc_ring:
 static int __devexit atmel_serial_remove(struct platform_device *pdev)
 {
 	struct uart_port *port = platform_get_drvdata(pdev);
-	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
+	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
 	int ret = 0;
 
 	device_init_wakeup(&pdev->dev, 0);
-- 
1.5.3.8

