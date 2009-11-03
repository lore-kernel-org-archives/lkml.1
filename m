Return-Path: <linux-kernel-owner+w=401wt.eu-S1753853AbZKCOdI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853AbZKCOdI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 09:33:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753810AbZKCOdF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 09:33:05 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55434 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752614AbZKCOdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 09:33:04 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 11/11] sdio_uart: add modem functionality
To: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, nico@cam.org
Date: Tue, 03 Nov 2009 14:19:40 +0000
Message-ID: <20091103141903.31032.28460.stgit@localhost.localdomain>
In-Reply-To: <20091103141525.31032.45206.stgit@localhost.localdomain>
References: <20091103141525.31032.45206.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the POSIX block for carrier

Linux TIOCMIWAIT functionality is still lacking from the driver.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/mmc/card/sdio_uart.c |   33 ++++++++++++++++++++++++++++++++-
 1 files changed, 32 insertions(+), 1 deletions(-)


diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 0a3acfb..e72e2f2 100644
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
@@ -214,6 +216,8 @@ static unsigned int sdio_uart_get_mctrl(struct sdio_uart_port *port)
 	unsigned char status;
 	unsigned int ret;
 
+	/* FIXME: What stops this losing the delta bits and breaking
+	   sdio_uart_check_modem_status ? */
 	status = sdio_in(port, UART_MSR);
 
 	ret = 0;
@@ -495,8 +499,20 @@ static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
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
@@ -552,6 +568,20 @@ static void sdio_uart_irq(struct sdio_func *func)
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
@@ -1011,6 +1041,7 @@ static const struct file_operations sdio_uart_proc_fops = {
 
 static const struct tty_port_operations sdio_uart_port_ops = {
 	.dtr_rts = uart_dtr_rts,
+	.carrier_raised = uart_carrier_raised,
 	.shutdown = sdio_uart_shutdown,
 	.activate = sdio_uart_activate,
 };

