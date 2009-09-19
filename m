Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZISVvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZISVvk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 17:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753886AbZISVkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 17:40:36 -0400
Received: from kroah.org ([198.145.64.141]:40443 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752944AbZISVkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 17:40:35 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 30/79] riscom8: split open and close methods up
Date: Sat, 19 Sep 2009 14:36:35 -0700
Message-Id: <1253396244-7885-30-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <20090919213345.GB7668@kroah.com>
References: <20090919213345.GB7668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Moving towards a tty_port method for open/close

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/riscom8.c |   47 ++++++++++++++++++++++++++---------------------
 1 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 171711a..9499991 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -921,20 +921,12 @@ static void rc_flush_buffer(struct tty_struct *tty)
 	tty_wakeup(tty);
 }
 
-static void rc_close(struct tty_struct *tty, struct file *filp)
+static void rc_close_port(struct tty_struct *tty, struct tty_port *port)
 {
-	struct riscom_port *port = tty->driver_data;
-	struct riscom_board *bp;
 	unsigned long flags;
+	struct riscom_port *rp = container_of(port, struct riscom_port, port);
+	struct riscom_board *bp = port_Board(rp);
 	unsigned long timeout;
-
-	if (!port || rc_paranoia_check(port, tty->name, "close"))
-		return;
-
-	bp = port_Board(port);
-	
-	if (tty_port_close_start(&port->port, tty, filp) == 0)
-		return;
 	
 	/*
 	 * At this point we stop accepting input.  To do this, we
@@ -944,29 +936,42 @@ static void rc_close(struct tty_struct *tty, struct file *filp)
 	 */
 
 	spin_lock_irqsave(&riscom_lock, flags);
-	port->IER &= ~IER_RXD;
-	if (port->port.flags & ASYNC_INITIALIZED) {
-		port->IER &= ~IER_TXRDY;
-		port->IER |= IER_TXEMPTY;
-		rc_out(bp, CD180_CAR, port_No(port));
-		rc_out(bp, CD180_IER, port->IER);
+	rp->IER &= ~IER_RXD;
+	if (port->flags & ASYNC_INITIALIZED) {
+		rp->IER &= ~IER_TXRDY;
+		rp->IER |= IER_TXEMPTY;
+		rc_out(bp, CD180_CAR, port_No(rp));
+		rc_out(bp, CD180_IER, rp->IER);
 		/*
 		 * Before we drop DTR, make sure the UART transmitter
 		 * has completely drained; this is especially
 		 * important if there is a transmit FIFO!
 		 */
 		timeout = jiffies + HZ;
-		while (port->IER & IER_TXEMPTY) {
+		while (rp->IER & IER_TXEMPTY) {
 			spin_unlock_irqrestore(&riscom_lock, flags);
-			msleep_interruptible(jiffies_to_msecs(port->timeout));
+			msleep_interruptible(jiffies_to_msecs(rp->timeout));
 			spin_lock_irqsave(&riscom_lock, flags);
 			if (time_after(jiffies, timeout))
 				break;
 		}
 	}
-	rc_shutdown_port(tty, bp, port);
-	rc_flush_buffer(tty);
+	rc_shutdown_port(tty, bp, rp);
 	spin_unlock_irqrestore(&riscom_lock, flags);
+}
+
+static void rc_close(struct tty_struct *tty, struct file *filp)
+{
+	struct riscom_port *port = tty->driver_data;
+
+	if (!port || rc_paranoia_check(port, tty->name, "close"))
+		return;
+
+	if (tty_port_close_start(&port->port, tty, filp) == 0)
+		return;
+
+	rc_close_port(tty, &port->port);
+	rc_flush_buffer(tty);
 
 	tty_port_close_end(&port->port, tty);
 }
-- 
1.6.4.2

