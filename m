Return-Path: <linux-kernel-owner+w=401wt.eu-S1752713AbZKCObY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbZKCObY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbZKCObW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:31:22 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55409 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750998AbZKCObU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:31:20 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 04/11] sdio_uart: refcount the tty objects
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, nico@cam.org
Date: Tue, 03 Nov 2009 14:17:53 +0000
Message-ID: <20091103141747.31032.70659.stgit@localhost.localdomain>
In-Reply-To: <20091103141525.31032.45206.stgit@localhost.localdomain>
References: <20091103141525.31032.45206.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty can go away underneath us, so we must refcount it. Do the naïve
implementation initially. We will worry about startup shortly.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |   58 ++++++++++++++++++++++++++++++------------
 1 files changed, 41 insertions(+), 17 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 671fe5e..51aeaf6 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -172,8 +172,13 @@ static void sdio_uart_port_remove(struct sdio_uart_port *port)
 	sdio_claim_host(func);
 	port->func = NULL;
 	mutex_unlock(&port->func_lock);
-	if (port->opened)
-		tty_hangup(port->port.tty);
+	if (port->opened) {
+		struct tty_struct *tty = tty_port_tty_get(&port->port);
+		/* tty_hangup is async so is this safe as is ?? */
+		if (tty)
+			tty_hangup(tty);
+		tty_kref_put(tty);
+	}
 	mutex_unlock(&port->open_lock);
 	sdio_release_irq(func);
 	sdio_disable_func(func);
@@ -392,7 +397,7 @@ static void sdio_uart_stop_rx(struct sdio_uart_port *port)
 static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 				    unsigned int *status)
 {
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
 	unsigned int ch, flag;
 	int max_count = 256;
 
@@ -429,25 +434,30 @@ static void sdio_uart_receive_chars(struct sdio_uart_port *port,
 		}
 
 		if ((*status & port->ignore_status_mask & ~UART_LSR_OE) == 0)
-			tty_insert_flip_char(tty, ch, flag);
+			if (tty)
+				tty_insert_flip_char(tty, ch, flag);
 
 		/*
 		 * Overrun is special.  Since it's reported immediately,
 		 * it doesn't affect the current character.
 		 */
 		if (*status & ~port->ignore_status_mask & UART_LSR_OE)
-			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
+			if (tty)
+				tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 
 		*status = sdio_in(port, UART_LSR);
 	} while ((*status & UART_LSR_DR) && (max_count-- > 0));
-	tty_flip_buffer_push(tty);
+	if (tty) {
+		tty_flip_buffer_push(tty);
+		tty_kref_put(tty);
+	}
 }
 
 static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 {
 	struct circ_buf *xmit = &port->xmit;
 	int count;
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty;
 
 	if (port->x_char) {
 		sdio_out(port, UART_TX, port->x_char);
@@ -455,7 +465,10 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 		port->x_char = 0;
 		return;
 	}
-	if (circ_empty(xmit) || tty->stopped || tty->hw_stopped) {
+
+	tty = tty_port_tty_get(&port->port);
+
+	if (tty == NULL || circ_empty(xmit) || tty->stopped || tty->hw_stopped) {
 		sdio_uart_stop_tx(port);
 		return;
 	}
@@ -474,12 +487,13 @@ static void sdio_uart_transmit_chars(struct sdio_uart_port *port)
 
 	if (circ_empty(xmit))
 		sdio_uart_stop_tx(port);
+	tty_kref_put(tty);
 }
 
 static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 {
 	int status;
-	struct tty_struct *tty = port->port.tty;
+	struct tty_struct *tty;
 
 	status = sdio_in(port, UART_MSR);
 
@@ -494,7 +508,8 @@ static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 		port->icount.dcd++;
 	if (status & UART_MSR_DCTS) {
 		port->icount.cts++;
-		if (tty->termios->c_cflag & CRTSCTS) {
+		tty = tty_port_tty_get(&port->port);
+		if (tty && (tty->termios->c_cflag & CRTSCTS)) {
 			int cts = (status & UART_MSR_CTS);
 			if (tty->hw_stopped) {
 				if (cts) {
@@ -509,6 +524,7 @@ static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 				}
 			}
 		}
+		tty_kref_put(tty);
 	}
 }
 
@@ -548,8 +564,10 @@ static void sdio_uart_irq(struct sdio_func *func)
 static int sdio_uart_startup(struct sdio_uart_port *port)
 {
 	unsigned long page;
-	int ret;
-	struct tty_struct *tty = port->port.tty;
+	int ret = -ENOMEM;
+	struct tty_struct *tty = tty_port_tty_get(&port->port);
+
+	/* FIXME: What if it is NULL ?? */
 
 	/*
 	 * Set the TTY IO error marker - we will only clear this
@@ -560,7 +578,7 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 	/* Initialise and allocate the transmit buffer. */
 	page = __get_free_page(GFP_KERNEL);
 	if (!page)
-		return -ENOMEM;
+		goto err0;
 	port->xmit.buf = (unsigned char *)page;
 	circ_clear(&port->xmit);
 
@@ -614,6 +632,7 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 	sdio_uart_irq(port->func);
 
 	sdio_uart_release_func(port);
+	tty_kref_put(tty);
 	return 0;
 
 err3:
@@ -622,12 +641,15 @@ err2:
 	sdio_uart_release_func(port);
 err1:
 	free_page((unsigned long)port->xmit.buf);
+err0:
+	tty_kref_put(tty);
 	return ret;
 }
 
 static void sdio_uart_shutdown(struct sdio_uart_port *port)
 {
 	int ret;
+	struct tty_struct *tty;
 
 	ret = sdio_uart_claim_func(port);
 	if (ret)
@@ -637,9 +659,11 @@ static void sdio_uart_shutdown(struct sdio_uart_port *port)
 
 	/* TODO: wait here for TX FIFO to drain */
 
+	tty = tty_port_tty_get(&port->port);
 	/* Turn off DTR and RTS early. */
-	if (port->port.tty->termios->c_cflag & HUPCL)
+	if (tty && (tty->termios->c_cflag & HUPCL))
 		sdio_uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+	tty_kref_put(tty);
 
 	/* Disable interrupts from this port */
 	sdio_release_irq(port->func);
@@ -688,11 +712,11 @@ static int sdio_uart_open(struct tty_struct *tty, struct file *filp)
 
 	if (!port->opened) {
 		tty->driver_data = port;
-		port->port.tty = tty;
+		tty_port_tty_set(&port->port, tty);
 		ret = sdio_uart_startup(port);
 		if (ret) {
 			tty->driver_data = NULL;
-			port->port.tty = NULL;
+			tty_port_tty_set(&port->port, NULL);
 			mutex_unlock(&port->open_lock);
 			sdio_uart_port_put(port);
 			return ret;
@@ -727,7 +751,7 @@ static void sdio_uart_close(struct tty_struct *tty, struct file * filp)
 		tty->closing = 1;
 		sdio_uart_shutdown(port);
 		tty_ldisc_flush(tty);
-		port->port.tty = NULL;
+		tty_port_tty_set(&port->port, NULL);
 		tty->driver_data = NULL;
 		tty->closing = 0;
 	}

