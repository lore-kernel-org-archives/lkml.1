Return-Path: <linux-kernel-owner+w=401wt.eu-S1756224AbZKBQ70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbZKBQ70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 11:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756131AbZKBQ7Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 11:59:24 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40008 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756123AbZKBQ7U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 11:59:20 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 3/6] sdio_uart: Switch to the open/close helpers
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
       dhowells@redhat.com, nico@cam.org
Date: Mon, 02 Nov 2009 16:45:57 +0000
Message-ID: <20091102164552.11877.19074.stgit@localhost.localdomain>
In-Reply-To: <20091102164039.11877.88825.stgit@localhost.localdomain>
References: <20091102164039.11877.88825.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gets us proper tty semantics, removes some code and fixes up a few corner
case races (hangup during open etc)

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |  190 +++++++++++++++++++++++++-----------------
 1 files changed, 114 insertions(+), 76 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 97432c0..fd00453 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -559,13 +559,46 @@ static void sdio_uart_irq(struct sdio_func *func)
 	port->in_sdio_uart_irq = NULL;
 }
 
-static int sdio_uart_startup(struct sdio_uart_port *port)
+/**
+ *	uart_dtr_rts		-	 port helper to set uart signals
+ *	@tport: tty port to be updated
+ *	@onoff: set to turn on DTR/RTS
+ *
+ *	Called by the tty port helpers when the modem signals need to be
+ *	adjusted during an open, close and hangup.
+ */
+
+static void uart_dtr_rts(struct tty_port *tport, int onoff)
 {
-	unsigned long page;
-	int ret = -ENOMEM;
-	struct tty_struct *tty = tty_port_tty_get(&port->port);
+	struct sdio_uart_port *port =
+			container_of(tport, struct sdio_uart_port, port);
+	if (onoff == 0)
+		sdio_uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+	else
+		sdio_uart_set_mctrl(port, TIOCM_DTR | TIOCM_RTS);
+}
 
-	/* FIXME: What if it is NULL ?? */
+/**
+ *	sdio_uart_activate	-	start up hardware
+ *	@tport: tty port to activate
+ *	@tty: tty bound to this port
+ *
+ *	Activate a tty port. The port locking guarantees us this will be
+ *	run exactly once per set of opens, and if successful will see the
+ *	shutdown method run exactly once to match. Start up and shutdown are
+ *	protected from each other by the internal locking and will not run
+ *	at the same time even during a hangup event.
+ *
+ *	If we successfully start up the port we take an extra kref as we
+ *	will keep it around until shutdown when the kref is dropped.
+ */
+
+static int sdio_uart_activate(struct tty_port *tport, struct tty_struct *tty)
+{
+	struct sdio_uart_port *port =
+			container_of(tport, struct sdio_uart_port, port);
+	unsigned long page;
+	int ret;
 
 	/*
 	 * Set the TTY IO error marker - we will only clear this
@@ -576,7 +609,7 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 	/* Initialise and allocate the transmit buffer. */
 	page = __get_free_page(GFP_KERNEL);
 	if (!page)
-		goto err0;
+		return -ENOMEM;
 	port->xmit.buf = (unsigned char *)page;
 	circ_clear(&port->xmit);
 
@@ -630,7 +663,6 @@ static int sdio_uart_startup(struct sdio_uart_port *port)
 	sdio_uart_irq(port->func);
 
 	sdio_uart_release_func(port);
-	tty_kref_put(tty);
 	return 0;
 
 err3:
@@ -639,15 +671,25 @@ err2:
 	sdio_uart_release_func(port);
 err1:
 	free_page((unsigned long)port->xmit.buf);
-err0:
-	tty_kref_put(tty);
 	return ret;
 }
 
-static void sdio_uart_shutdown(struct sdio_uart_port *port)
+	
+/**
+ *	sdio_uart_shutdown	-	stop hardware
+ *	@tport: tty port to shut down
+ *
+ *	Deactivate a tty port. The port locking guarantees us this will be
+ *	run only if a successful matching activate already ran. The two are
+ *	protected from each other by the internal locking and will not run
+ *	at the same time even during a hangup event.
+ */
+
+static void sdio_uart_shutdown(struct tty_port *tport)
 {
+	struct sdio_uart_port *port =
+			container_of(tport, struct sdio_uart_port, port);
 	int ret;
-	struct tty_struct *tty;
 
 	ret = sdio_uart_claim_func(port);
 	if (ret)
@@ -655,14 +697,6 @@ static void sdio_uart_shutdown(struct sdio_uart_port *port)
 
 	sdio_uart_stop_rx(port);
 
-	/* TODO: wait here for TX FIFO to drain */
-
-	tty = tty_port_tty_get(&port->port);
-	/* Turn off DTR and RTS early. */
-	if (tty && (tty->termios->c_cflag & HUPCL))
-		sdio_uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
-	tty_kref_put(tty);
-
 	/* Disable interrupts from this port */
 	sdio_release_irq(port->func);
 	port->ier = 0;
@@ -687,74 +721,68 @@ skip:
 	free_page((unsigned long)port->xmit.buf);
 }
 
-static int sdio_uart_open(struct tty_struct *tty, struct file *filp)
+/**
+ *	sdio_uart_install	-	install method
+ *	@driver: the driver in use (sdio_uart in our case)
+ *	@tty: the tty being bound
+ *
+ *	Look up and bind the tty and the driver together. Initialize
+ *	any needed private data (in our case the termios)
+ */
+
+static int sdio_uart_install(struct tty_driver *driver, struct tty_struct *tty)
 {
-	struct sdio_uart_port *port;
-	int ret;
+	int idx = tty->index;
+	struct sdio_uart_port *port = sdio_uart_port_get(idx);
+	int ret = tty_init_termios(tty);
+
+	if (ret == 0) {
+		tty_driver_kref_get(driver);
+		tty->count++;
+		/* This is the ref sdio_uart_port get provided */
+		tty->driver_data = port;
+		driver->ttys[idx] = tty;
+	} else
+		sdio_uart_port_put(port);
+	return ret;
+		
+}
 
-	port = sdio_uart_port_get(tty->index);
-	if (!port)
-		return -ENODEV;
+/**
+ *	sdio_uart_cleanup	-	called on the last tty kref drop
+ *	@tty: the tty being destroyed
+ *
+ *	Called asynchronously when the last reference to the tty is dropped.
+ *	We cannot destroy the tty->driver_data port kref until this point
+ */
 
-	mutex_lock(&port->port.mutex);
+static void sdio_uart_cleanup(struct tty_struct *tty)
+{
+	struct sdio_uart_port *port = tty->driver_data;
+	tty->driver_data = NULL;	/* Bug trap */
+	sdio_uart_port_put(port);
+}
 
-	/*
-	 * Make sure not to mess up with a dead port
-	 * which has not been closed yet.
-	 */
-	if (tty->driver_data && tty->driver_data != port) {
-		mutex_unlock(&port->port.mutex);
-		sdio_uart_port_put(port);
-		return -EBUSY;
-	}
+/*
+ *	Open/close/hangup is now entirely boilerplate
+ */
 
-	if (!port->opened) {
-		tty->driver_data = port;
-		tty_port_tty_set(&port->port, tty);
-		ret = sdio_uart_startup(port);
-		if (ret) {
-			tty->driver_data = NULL;
-			tty_port_tty_set(&port->port, NULL);
-			mutex_unlock(&port->port.mutex);
-			sdio_uart_port_put(port);
-			return ret;
-		}
-	}
-	port->opened++;
-	mutex_unlock(&port->port.mutex);
-	return 0;
+static int sdio_uart_open(struct tty_struct *tty, struct file *filp)
+{
+	struct sdio_uart_port *port = tty->driver_data;
+	return tty_port_open(&port->port, tty, filp);
 }
 
 static void sdio_uart_close(struct tty_struct *tty, struct file * filp)
 {
 	struct sdio_uart_port *port = tty->driver_data;
+	tty_port_close(&port->port, tty, filp);
+}
 
-	if (!port)
-		return;
-
-	mutex_lock(&port->port.mutex);
-	BUG_ON(!port->opened);
-
-	/*
-	 * This is messy.  The tty layer calls us even when open()
-	 * returned an error.  Ignore this close request if tty->count
-	 * is larger than port->count.
-	 */
-	if (tty->count > port->opened) {
-		mutex_unlock(&port->port.mutex);
-		return;
-	}
-
-	if (--port->opened == 0) {
-		tty->closing = 1;
-		sdio_uart_shutdown(port);
-		tty_ldisc_flush(tty);
-		tty_port_tty_set(&port->port, NULL);
-		tty->driver_data = NULL;
-		tty->closing = 0;
-	}
-	mutex_unlock(&port->port.mutex);
-	sdio_uart_port_put(port);
+static void sdio_uart_hangup(struct tty_struct *tty)
+{
+	struct sdio_uart_port *port = tty->driver_data;
+	tty_port_hangup(&port->port);
 }
 
 static int sdio_uart_write(struct tty_struct * tty, const unsigned char *buf,
@@ -1020,6 +1048,12 @@ static const struct file_operations sdio_uart_proc_fops = {
 	.release	= single_release,
 };
 
+static const struct tty_port_operations sdio_uart_port_ops = {
+	.dtr_rts = uart_dtr_rts,
+	.shutdown = sdio_uart_shutdown,
+	.activate = sdio_uart_activate,
+};
+	
 static const struct tty_operations sdio_uart_ops = {
 	.open			= sdio_uart_open,
 	.close			= sdio_uart_close,
@@ -1030,9 +1064,12 @@ static const struct tty_operations sdio_uart_ops = {
 	.throttle		= sdio_uart_throttle,
 	.unthrottle		= sdio_uart_unthrottle,
 	.set_termios		= sdio_uart_set_termios,
+	.hangup			= sdio_uart_hangup,
 	.break_ctl		= sdio_uart_break_ctl,
 	.tiocmget		= sdio_uart_tiocmget,
 	.tiocmset		= sdio_uart_tiocmset,
+	.install		= sdio_uart_install,
+	.cleanup		= sdio_uart_cleanup,
 	.proc_fops		= &sdio_uart_proc_fops,
 };
 
@@ -1095,6 +1132,7 @@ static int sdio_uart_probe(struct sdio_func *func,
 	port->func = func;
 	sdio_set_drvdata(func, port);
 	tty_port_init(&port->port);
+	port->port.ops = &sdio_uart_port_ops;
 
 	ret = sdio_uart_add_port(port);
 	if (ret) {

