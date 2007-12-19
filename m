Return-Path: <linux-kernel-owner+w=401wt.eu-S1754587AbXLSMf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754587AbXLSMf0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 07:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXLSMfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 07:35:16 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:56714 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751318AbXLSMfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:35:14 -0500
Date: Wed, 19 Dec 2007 13:34:11 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Message-ID: <20071219133411.24d146e7@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 16:23:11 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Preempt-RT now absolutely requires my (4th) IRQ_NODELAY patch, because
> the spinlock now is always inside the code, and not only in
> theexception path, and thus without my NO_DELAY patch we have a panic
> during boot.

Hmm...perhaps we can eliminate the locking in the status handler
too...? Does anyone see a problem with this patch?

diff --git a/drivers/serial/atmel_serial.c b/drivers/serial/atmel_serial.c
index bce5d2a..fac37dc 100644
--- a/drivers/serial/atmel_serial.c
+++ b/drivers/serial/atmel_serial.c
@@ -152,6 +152,7 @@ struct atmel_uart_port {
 	struct tasklet_struct	tasklet;
 	unsigned int		irq_pending;
 	unsigned int		irq_status;
+	unsigned int		irq_status_prev;
 
 	struct circ_buf		rx_ring;
 };
@@ -585,12 +586,19 @@ atmel_handle_status(struct uart_port *port, unsigned int pending,
 {
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
 
-	spin_lock(&port->lock);
-
-	atmel_port->irq_pending	|= pending;
+	/*
+	 * Try to avoid locking here since it may cause problems on
+	 * -rt. This may cause bits to re-appear in irq_pending due to
+	 * a race with atmel_tasklet_func(), but since the previous
+	 * status is tracked explicitly, this will only mean that the
+	 * tasklet will do a bit more work than strictly necessary.
+	 *
+	 * We must make sure that status is written before pending,
+	 * hence the barrier.
+	 */
 	atmel_port->irq_status	= status;
-
-	spin_unlock(&port->lock);
+	smp_mb();
+	atmel_port->irq_pending	|= pending;
 
 	tasklet_schedule(&atmel_port->tasklet);
 }
@@ -750,33 +758,32 @@ static void atmel_tasklet_func(unsigned long data)
 {
 	struct uart_port *port = (struct uart_port *)data;
 	struct atmel_uart_port *atmel_port = (struct atmel_uart_port *)port;
-	unsigned long flags;
 	unsigned int status;
+	unsigned int status_change;
 	unsigned int pending;
 
-	spin_lock_irqsave(&port->lock, flags);
+	pending = xchg(&atmel_port->irq_pending, 0);
 
-	if (atmel_port->irq_pending) {
-		pending = atmel_port->irq_pending;
+	if (pending) {
+		/* must read/update pending before reading status */
+		smp_mb();
 		status = atmel_port->irq_status;
-		atmel_port->irq_pending = 0;
-
-		spin_unlock_irqrestore(&port->lock, flags);
+		status_change = status ^ atmel_port->irq_status_prev;
 
 		/* TODO: All reads to CSR will clear these interrupts! */
-		if (pending & ATMEL_US_RIIC)
+		if (status_change & ATMEL_US_RI)
 			port->icount.rng++;
-		if (pending & ATMEL_US_DSRIC)
+		if (status_change & ATMEL_US_DSR)
 			port->icount.dsr++;
-		if (pending & ATMEL_US_DCDIC)
+		if (status_change & ATMEL_US_DCD)
 			uart_handle_dcd_change(port, !(status & ATMEL_US_DCD));
-		if (pending & ATMEL_US_CTSIC)
+		if (status_change & ATMEL_US_CTS)
 			uart_handle_cts_change(port, !(status & ATMEL_US_CTS));
-		if (pending & (ATMEL_US_RIIC | ATMEL_US_DSRIC
-					| ATMEL_US_DCDIC | ATMEL_US_CTSIC))
+		if (status_change & (ATMEL_US_RI | ATMEL_US_DSR
+					| ATMEL_US_DCD | ATMEL_US_CTS))
 			wake_up_interruptible(&port->info->delta_msr_wait);
-	} else {
-		spin_unlock_irqrestore(&port->lock, flags);
+
+		atmel_port->irq_status_prev = status;
 	}
 
 	if (atmel_use_dma_rx(port))
