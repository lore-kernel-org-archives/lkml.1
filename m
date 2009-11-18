Return-Path: <linux-kernel-owner+w=401wt.eu-S1757399AbZKROfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399AbZKROfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757385AbZKROfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:35:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35721 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757241AbZKROfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:35:36 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 02/11] sdio_uart: use tty_port
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:19:11 +0000
Message-ID: <20091118141905.3582.23056.stgit@localhost.localdomain>
In-Reply-To: <20091118141802.3582.47363.stgit@localhost.localdomain>
References: <20091118141802.3582.47363.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a tty_port object to the sdio uart. For the moment just begin using the
tty field of the port, as this is the critical one to clean up.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |   41 +++++++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 18 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index b8e7c5a..c2759db 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -73,6 +73,7 @@ struct uart_icount {
 };
 
 struct sdio_uart_port {
+	struct tty_port		port;
 	struct kref		kref;
 	struct tty_struct	*tty;
 	unsigned int		index;
@@ -172,7 +173,7 @@ static void sdio_uart_port_remove(struct sdio_uart_port *port)
 	port->func = NULL;
 	mutex_unlock(&port->func_lock);
 	if (port->opened)
-		tty_hangup(port->tty);
+		tty_hangup(port->port.tty);
 	mutex_unlock(&port->open_lock);
 	sdio_release_irq(func);
 	sdio_disable_func(func);
@@ -391,7 +392,7 @@ static void sdio_uart_stop_rx(struct sdio_uart_port *port)
 static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 				    unsigned int *status)
 {
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = port->port.tty;
 	unsigned int ch, flag;
 	int max_count = 256;
 
@@ -446,6 +447,7 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 {
 	struct circ_buf *xmit = &port->xmit;
 	int count;
+	struct tty_struct *tty = port->port.tty;
 
 	if (port->x_char) {
 		sdio_out(port, UART_TX, port->x_char);
@@ -453,7 +455,7 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 		port->x_char = 0;
 		return;
 	}
-	if (circ_empty(xmit) || port->tty->stopped || port->tty->hw_stopped) {
+	if (circ_empty(xmit) || tty->stopped || tty->hw_stopped) {
 		sdio_uart_stop_tx(port);
 		return;
 	}
@@ -468,7 +470,7 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 	} while (--count > 0);
 
 	if (circ_chars_pending(xmit) < WAKEUP_CHARS)
-		tty_wakeup(port->tty);
+		tty_wakeup(tty);
 
 	if (circ_empty(xmit))
 		sdio_uart_stop_tx(port);
@@ -477,6 +479,7 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 {
 	int status;
+	struct tty_struct *tty = port->port.tty;
 
 	status = sdio_in(port, UART_MSR);
 
@@ -491,17 +494,17 @@ static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 		port->icount.dcd++;
 	if (status & UART_MSR_DCTS) {
 		port->icount.cts++;
-		if (port->tty->termios->c_cflag & CRTSCTS) {
+		if (tty->termios->c_cflag & CRTSCTS) {
 			int cts = (status & UART_MSR_CTS);
-			if (port->tty->hw_stopped) {
+			if (tty->hw_stopped) {
 				if (cts) {
-					port->tty->hw_stopped = 0;
+					tty->hw_stopped = 0;
 					sdio_uart_start_tx(port);
-					tty_wakeup(port->tty);
+					tty_wakeup(tty);
 				}
 			} else {
 				if (!cts) {
-					port->tty->hw_stopped = 1;
+					tty->hw_stopped = 1;
 					sdio_uart_stop_tx(port);
 				}
 			}
@@ -546,12 +549,13 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 {
 	unsigned long page;
 	int ret;
+	struct tty_struct *tty = port->port.tty;
 
 	/*
 	 * Set the TTY IO error marker - we will only clear this
 	 * once we have successfully opened the port.
 	 */
-	set_bit(TTY_IO_ERROR, &port->tty->flags);
+	set_bit(TTY_IO_ERROR, &tty->flags);
 
 	/* Initialise and allocate the transmit buffer. */
 	page = __get_free_page(GFP_KERNEL);
@@ -595,14 +599,14 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 	port->ier = UART_IER_RLSI | UART_IER_RDI | UART_IER_RTOIE | UART_IER_UUE;
 	port->mctrl = TIOCM_OUT2;
 
-	sdio_uart_change_speed(port, port->tty->termios, NULL);
+	sdio_uart_change_speed(port, tty->termios, NULL);
 
-	if (port->tty->termios->c_cflag & CBAUD)
+	if (tty->termios->c_cflag & CBAUD)
 		sdio_uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
 
-	if (port->tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios->c_cflag & CRTSCTS)
 		if (!(sdio_uart_get_mctrl(port) & TIOCM_CTS))
-			port->tty->hw_stopped = 1;
+			tty->hw_stopped = 1;
 
 	clear_bit(TTY_IO_ERROR, &port->tty->flags);
 
@@ -634,7 +638,7 @@ static void sdio_uart_shutdown(struct sdio_uart_port *port)
 	/* TODO: wait here for TX FIFO to drain */
 
 	/* Turn off DTR and RTS early. */
-	if (port->tty->termios->c_cflag & HUPCL)
+	if (port->port.tty->termios->c_cflag & HUPCL)
 		sdio_uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 
 	/* Disable interrupts from this port */
@@ -684,11 +688,11 @@ static int sdio_uart_open(struct tty_struct *tty, struct file *filp)
 
 	if (!port->opened) {
 		tty->driver_data = port;
-		port->tty = tty;
+		port->port.tty = tty;
 		ret = sdio_uart_startup(port);
 		if (ret) {
 			tty->driver_data = NULL;
-			port->tty = NULL;
+			port->port.tty = NULL;
 			mutex_unlock(&port->open_lock);
 			sdio_uart_port_put(port);
 			return ret;
@@ -723,7 +727,7 @@ static void sdio_uart_close(struct tty_struct *tty, struct file * filp)
 		tty->closing = 1;
 		sdio_uart_shutdown(port);
 		tty_ldisc_flush(tty);
-		port->tty = NULL;
+		port->port.tty = NULL;
 		tty->driver_data = NULL;
 		tty->closing = 0;
 	}
@@ -1068,6 +1072,7 @@ static int sdio_uart_probe(struct sdio_func *func,
 
 	port->func = func;
 	sdio_set_drvdata(func, port);
+	tty_port_init(&port->port);
 
 	ret = sdio_uart_add_port(port);
 	if (ret) {

