Return-Path: <linux-kernel-owner+w=401wt.eu-S934934AbZLKXfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934934AbZLKXfm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:35:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934904AbZLKXfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:35:16 -0500
Received: from kroah.org ([198.145.64.141]:50451 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934350AbZLKX3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:19 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 36/58] tty: riscom8: switch to the tty_port_open API
Date: Fri, 11 Dec 2009 15:28:20 -0800
Message-Id: <1260574122-10676-36-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/riscom8.c |   89 ++++++++++++++++++++++--------------------------
 1 files changed, 41 insertions(+), 48 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 3cfa22d..0a8d1e5 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -793,26 +793,21 @@ static void rc_change_speed(struct tty_struct *tty, struct riscom_board *bp,
 }
 
 /* Must be called with interrupts enabled */
-static int rc_setup_port(struct tty_struct *tty, struct riscom_board *bp,
-						struct riscom_port *port)
+static int rc_activate_port(struct tty_port *port, struct tty_struct *tty)
 {
+	struct riscom_port *rp = container_of(port, struct riscom_port, port);
+	struct riscom_board *bp = port_Board(rp);
 	unsigned long flags;
 
-	if (port->port.flags & ASYNC_INITIALIZED)
-		return 0;
-
-	if (tty_port_alloc_xmit_buf(&port->port) < 0)
+	if (tty_port_alloc_xmit_buf(port) < 0)
 		return -ENOMEM;
 
 	spin_lock_irqsave(&riscom_lock, flags);
 
 	clear_bit(TTY_IO_ERROR, &tty->flags);
-	if (port->port.count == 1)
-		bp->count++;
-	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	rc_change_speed(tty, bp, port);
-	port->port.flags |= ASYNC_INITIALIZED;
-
+	bp->count++;
+	rp->xmit_cnt = rp->xmit_head = rp->xmit_tail = 0;
+	rc_change_speed(tty, bp, rp);
 	spin_unlock_irqrestore(&riscom_lock, flags);
 	return 0;
 }
@@ -821,9 +816,6 @@ static int rc_setup_port(struct tty_struct *tty, struct riscom_board *bp,
 static void rc_shutdown_port(struct tty_struct *tty,
 			struct riscom_board *bp, struct riscom_port *port)
 {
-	if (!(port->port.flags & ASYNC_INITIALIZED))
-		return;
-
 #ifdef RC_REPORT_OVERRUN
 	printk(KERN_INFO "rc%d: port %d: Total %ld overruns were detected.\n",
 	       board_No(bp), port_No(port), port->overrun);
@@ -840,11 +832,6 @@ static void rc_shutdown_port(struct tty_struct *tty,
 	}
 #endif
 	tty_port_free_xmit_buf(&port->port);
-	if (C_HUPCL(tty)) {
-		/* Drop DTR */
-		bp->DTR |= (1u << port_No(port));
-		rc_out(bp, RC_DTR, bp->DTR);
-	}
 
 	/* Select port */
 	rc_out(bp, CD180_CAR, port_No(port));
@@ -856,7 +843,6 @@ static void rc_shutdown_port(struct tty_struct *tty,
 	rc_out(bp, CD180_IER, port->IER);
 
 	set_bit(TTY_IO_ERROR, &tty->flags);
-	port->port.flags &= ~ASYNC_INITIALIZED;
 
 	if (--bp->count < 0)  {
 		printk(KERN_INFO "rc%d: rc_shutdown_port: "
@@ -889,6 +875,20 @@ static int carrier_raised(struct tty_port *port)
 	return CD;
 }
 
+static void dtr_rts(struct tty_port *port, int onoff)
+{
+	struct riscom_port *p = container_of(port, struct riscom_port, port);
+	struct riscom_board *bp = port_Board(p);
+	unsigned long flags;
+
+	spin_lock_irqsave(&riscom_lock, flags);
+	bp->DTR &= ~(1u << port_No(p));
+	if (onoff == 0)
+		bp->DTR |= (1u << port_No(p));
+	rc_out(bp, RC_DTR, bp->DTR);
+	spin_unlock_irqrestore(&riscom_lock, flags);
+}
+
 static int rc_open(struct tty_struct *tty, struct file *filp)
 {
 	int board;
@@ -909,14 +909,7 @@ static int rc_open(struct tty_struct *tty, struct file *filp)
 	if (error)
 		return error;
 
-	port->port.count++;
-	tty->driver_data = port;
-	tty_port_tty_set(&port->port, tty);
-
-	error = rc_setup_port(tty, bp, port);
-	if (error == 0)
-		error = tty_port_block_til_ready(&port->port, tty, filp);
-	return error;
+	return tty_port_open(&port->port, tty, filp);
 }
 
 static void rc_flush_buffer(struct tty_struct *tty)
@@ -950,24 +943,23 @@ static void rc_close_port(struct tty_port *port)
 
 	spin_lock_irqsave(&riscom_lock, flags);
 	rp->IER &= ~IER_RXD;
-	if (port->flags & ASYNC_INITIALIZED) {
-		rp->IER &= ~IER_TXRDY;
-		rp->IER |= IER_TXEMPTY;
-		rc_out(bp, CD180_CAR, port_No(rp));
-		rc_out(bp, CD180_IER, rp->IER);
-		/*
-		 * Before we drop DTR, make sure the UART transmitter
-		 * has completely drained; this is especially
-		 * important if there is a transmit FIFO!
-		 */
-		timeout = jiffies + HZ;
-		while (rp->IER & IER_TXEMPTY) {
-			spin_unlock_irqrestore(&riscom_lock, flags);
-			msleep_interruptible(jiffies_to_msecs(rp->timeout));
-			spin_lock_irqsave(&riscom_lock, flags);
-			if (time_after(jiffies, timeout))
-				break;
-		}
+
+	rp->IER &= ~IER_TXRDY;
+	rp->IER |= IER_TXEMPTY;
+	rc_out(bp, CD180_CAR, port_No(rp));
+	rc_out(bp, CD180_IER, rp->IER);
+	/*
+	 * Before we drop DTR, make sure the UART transmitter
+	 * has completely drained; this is especially
+	 * important if there is a transmit FIFO!
+	 */
+	timeout = jiffies + HZ;
+	while (rp->IER & IER_TXEMPTY) {
+		spin_unlock_irqrestore(&riscom_lock, flags);
+		msleep_interruptible(jiffies_to_msecs(rp->timeout));
+		spin_lock_irqsave(&riscom_lock, flags);
+		if (time_after(jiffies, timeout))
+			break;
 	}
 	rc_shutdown_port(port->tty, bp, rp);
 	spin_unlock_irqrestore(&riscom_lock, flags);
@@ -1354,7 +1346,6 @@ static void rc_hangup(struct tty_struct *tty)
 	if (rc_paranoia_check(port, tty->name, "rc_hangup"))
 		return;
 
-	rc_shutdown_port(tty, port_Board(port), port);
 	tty_port_hangup(&port->port);
 }
 
@@ -1401,7 +1392,9 @@ static const struct tty_operations riscom_ops = {
 
 static const struct tty_port_operations riscom_port_ops = {
 	.carrier_raised = carrier_raised,
+	.dtr_rts = dtr_rts,
 	.shutdown = rc_close_port,
+	.activate = rc_activate_port,
 };
 
 
-- 
1.6.5.5

