Return-Path: <linux-kernel-owner+w=401wt.eu-S934902AbZLKXhH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934902AbZLKXhH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:37:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934338AbZLKXgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:36:10 -0500
Received: from kroah.org ([198.145.64.141]:50479 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934277AbZLKX3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 33/58] tty: sdio_uart: add modem functionality
Date: Fri, 11 Dec 2009 15:28:17 -0800
Message-Id: <1260574122-10676-33-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Add the POSIX block for carrier

Linux TIOCMIWAIT functionality is still lacking from the driver.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/mmc/card/sdio_uart.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)

diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index b999972..2a13db5 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -29,6 +29,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/sched.h>
 #include <linux/mutex.h>
 #include <linux/seq_file.h>
 #include <linux/serial_reg.h>
@@ -86,6 +87,7 @@ struct sdio_uart_port {
 	struct uart_icount	icount;
 	unsigned int		uartclk;
 	unsigned int		mctrl;
+	unsigned int		rx_mctrl;
 	unsigned int		read_status_mask;
 	unsigned int		ignore_status_mask;
 	unsigned char		x_char;
@@ -220,6 +222,8 @@ static unsigned int sdio_uart_get_mctrl(struct sdio_uart_port *port)
 	unsigned char status;
 	unsigned int ret;
 
+	/* FIXME: What stops this losing the delta bits and breaking
+	   sdio_uart_check_modem_status ? */
 	status = sdio_in(port, UART_MSR);
 
 	ret = 0;
@@ -503,8 +507,20 @@ static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 		port->icount.rng++;
 	if (status & UART_MSR_DDSR)
 		port->icount.dsr++;
-	if (status & UART_MSR_DDCD)
+	if (status & UART_MSR_DDCD) {
 		port->icount.dcd++;
+		/* DCD raise - wake for open */
+		if (status & UART_MSR_DCD)
+			wake_up_interruptible(&port->port.open_wait);
+		else {
+			/* DCD drop - hang up if tty attached */
+			tty = tty_port_tty_get(&port->port);
+			if (tty) {
+				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
+		}
+	}
 	if (status & UART_MSR_DCTS) {
 		port->icount.cts++;
 		tty = tty_port_tty_get(&port->port);
@@ -560,6 +576,20 @@ static void sdio_uart_irq(struct sdio_func *func)
 	port->in_sdio_uart_irq = NULL;
 }
 
+static int uart_carrier_raised(struct tty_port *tport)
+{
+	struct sdio_uart_port *port =
+			container_of(tport, struct sdio_uart_port, port);
+	unsigned int ret = sdio_uart_claim_func(port);
+	if (ret)	/* Missing hardware shoudn't block for carrier */
+		return 1;
+	ret = sdio_uart_get_mctrl(port);
+	sdio_uart_release_func(port);
+	if (ret & TIOCM_CAR)
+		return 1;
+	return 0;
+}
+
 /**
  *	uart_dtr_rts		-	 port helper to set uart signals
  *	@tport: tty port to be updated
@@ -1044,6 +1074,7 @@ static const struct file_operations sdio_uart_proc_fops = {
 
 static const struct tty_port_operations sdio_uart_port_ops = {
 	.dtr_rts = uart_dtr_rts,
+	.carrier_raised = uart_carrier_raised,
 	.shutdown = sdio_uart_shutdown,
 	.activate = sdio_uart_activate,
 };
-- 
1.6.5.5

