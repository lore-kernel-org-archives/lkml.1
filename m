Return-Path: <linux-kernel-owner+w=401wt.eu-S936728AbXJSUo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936728AbXJSUo1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbXJSUoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:44:17 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:40574 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934783AbXJSUoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:44:16 -0400
Date: Fri, 19 Oct 2007 21:44:08 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz.c: Fix locking issues
Message-ID: <Pine.LNX.4.64N.0710192139550.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 The ->start_tx(), ->stop_tx() and ->stop_rx() backends are called with 
the port's lock already taken.  Remove locking from within them and wrap 
around calls as necessary.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested with checkpatch.pl and at the run-time -- MIPS/Linux on a 
DECstation 5000/200.

 Please apply,

  Maciej

patch-mips-2.6.23-rc5-20070904-dz-lock-1
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/dz.c	2007-05-02 04:56:10.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/dz.c	2007-10-13 20:10:37.000000000 +0000
@@ -105,37 +105,28 @@ static void dz_stop_tx(struct uart_port 
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 	unsigned short tmp, mask = 1 << dport->port.line;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dport->port.lock, flags);
 	tmp = dz_in(dport, DZ_TCR);	/* read the TX flag */
 	tmp &= ~mask;			/* clear the TX flag */
 	dz_out(dport, DZ_TCR, tmp);
-	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 static void dz_start_tx(struct uart_port *uport)
 {
 	struct dz_port *dport = (struct dz_port *)uport;
 	unsigned short tmp, mask = 1 << dport->port.line;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dport->port.lock, flags);
 	tmp = dz_in(dport, DZ_TCR);	/* read the TX flag */
 	tmp |= mask;			/* set the TX flag */
 	dz_out(dport, DZ_TCR, tmp);
-	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 static void dz_stop_rx(struct uart_port *uport)
 {
 	struct dz_port *dport = (struct dz_port *)uport;
-	unsigned long flags;
 
-	spin_lock_irqsave(&dport->port.lock, flags);
 	dport->cflag &= ~DZ_CREAD;
 	dz_out(dport, DZ_LPR, dport->cflag | dport->port.line);
-	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 static void dz_enable_ms(struct uart_port *port)
@@ -265,7 +256,9 @@ static inline void dz_transmit_chars(str
 	}
 	/* If nothing to do or stopped or hardware stopped. */
 	if (uart_circ_empty(xmit) || uart_tx_stopped(&dport->port)) {
+		spin_lock(&dport->port.lock);
 		dz_stop_tx(&dport->port);
+		spin_unlock(&dport->port.lock);
 		return;
 	}
 
@@ -282,8 +275,11 @@ static inline void dz_transmit_chars(str
 		uart_write_wakeup(&dport->port);
 
 	/* Are we are done. */
-	if (uart_circ_empty(xmit))
+	if (uart_circ_empty(xmit)) {
+		spin_lock(&dport->port.lock);
 		dz_stop_tx(&dport->port);
+		spin_unlock(&dport->port.lock);
+	}
 }
 
 /*
@@ -414,7 +410,12 @@ static int dz_startup(struct uart_port *
  */
 static void dz_shutdown(struct uart_port *uport)
 {
-	dz_stop_tx(uport);
+	struct dz_port *dport = (struct dz_port *)uport;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dport->port.lock, flags);
+	dz_stop_tx(&dport->port);
+	spin_unlock_irqrestore(&dport->port.lock, flags);
 }
 
 /*
