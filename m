Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbXFFJHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbXFFJHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 05:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753921AbXFFJHj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 05:07:39 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:1581 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbXFFJHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 05:07:38 -0400
Date: Wed, 6 Jun 2007 10:07:34 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] zs.c: Drain the transmission line
Message-ID: <Pine.LNX.4.64N.0706051145260.15653@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 This is an update to the zs.c driver to make it wait for the transmission 
line to become idle before disabling the transmitter or resetting the 
chip.  This way the character that is on the way at the time one of these 
actions is about to be performed does not get corrupted.

 Plus a change to reset the index/data pointer first before issuing a chip 
reset just in case the state is wrong when control of the chip is taken 
the first time.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 These are almost obvious, but I have run-time tested them just in case.  
They make the switch from the initial (early printk) PROM-based console 
less disruptive.  The change to load_zsregs() also affects set_termios().

 Please apply,

  Maciej

patch-mips-2.6.21-20070502-zs-serial-drain-3
diff -up --recursive --new-file linux-mips-2.6.21-20070502.macro/drivers/serial/zs.c linux-mips-2.6.21-20070502/drivers/serial/zs.c
--- linux-mips-2.6.21-20070502.macro/drivers/serial/zs.c	2007-06-05 11:08:24.000000000 +0000
+++ linux-mips-2.6.21-20070502/drivers/serial/zs.c	2007-06-05 11:08:57.000000000 +0000
@@ -240,10 +240,24 @@ static int zs_transmit_drain(struct zs_p
 	return loops;
 }
 
+static int zs_line_drain(struct zs_port *zport, int irq)
+{
+	struct zs_scc *scc = zport->scc;
+	int loops = 10000;
+
+	while (!(read_zsreg(zport, R1) & ALL_SNT) && loops--) {
+		zs_spin_unlock_cond_irq(&scc->zlock, irq);
+		udelay(2);
+		zs_spin_lock_cond_irq(&scc->zlock, irq);
+	}
+	return loops;
+}
+
 
 static void load_zsregs(struct zs_port *zport, u8 *regs, int irq)
 {
-	zs_transmit_drain(zport, irq);
+	/* Let the current transmission finish.  */
+	zs_line_drain(zport, irq);
 	/* Load 'em up.  */
 	write_zsreg(zport, R3, regs[3] & ~RxENABLE);
 	write_zsreg(zport, R5, regs[5] & ~TxENAB);
@@ -814,6 +828,10 @@ static void zs_reset(struct zs_port *zpo
 	spin_lock_irqsave(&scc->zlock, flags);
 	irq = !irqs_disabled_flags(flags);
 	if (!scc->initialised) {
+		/* Reset the pointer first, just in case...  */
+		read_zsreg(zport, R0);
+		/* And let the current transmission finish.  */
+		zs_line_drain(zport, irq);
 		write_zsreg(zport, R9, FHWRES);
 		udelay(10);
 		write_zsreg(zport, R9, 0);
