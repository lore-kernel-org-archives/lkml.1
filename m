Return-Path: <linux-kernel-owner+w=401wt.eu-S932265AbXJSUST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932265AbXJSUST (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759589AbXJSUSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:18:11 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:59495 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758914AbXJSUSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:18:09 -0400
Date: Fri, 19 Oct 2007 21:18:03 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz.c: Always check if it is safe to console_putchar()
Message-ID: <Pine.LNX.4.64N.0710192059530.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Polled transmission is tricky enough with the DZ11 design.  While "loop" 
is set to a high value, conceptually you are not allowed to transmit 
without checking whether the device offers the right transmission line 
(yes, it is the device that selects the line -- the driver has no control 
over it other than disabling the transmitter offered if it is the wrong 
one), so the loop has to be run at least once.

 Well, the '1977 or PDP11 view of how serial lines should be handled...  
Except that the serial interface used to be quite an impressive board back 
then rather than chip.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested with checkpatch.pl and at the run-time -- MIPS/Linux on a 
DECstation 5000/200.

 Please apply,

  Maciej

patch-mips-2.6.18-20060920-dz-putchar-0
diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/drivers/serial/dz.c linux-mips-2.6.18-20060920/drivers/serial/dz.c
--- linux-mips-2.6.18-20060920.macro/drivers/serial/dz.c	2006-11-23 05:17:01.000000000 +0000
+++ linux-mips-2.6.18-20060920/drivers/serial/dz.c	2007-01-14 00:07:02.000000000 +0000
@@ -686,7 +686,7 @@ static void dz_console_putchar(struct ua
 	iob();
 	spin_unlock_irqrestore(&dport->port.lock, flags);
 
-	while (loops--) {
+	do {
 		trdy = dz_in(dport, DZ_CSR);
 		if (!(trdy & DZ_TRDY))
 			continue;
@@ -697,7 +697,7 @@ static void dz_console_putchar(struct ua
 		dz_out(dport, DZ_TCR, mask);
 		iob();
 		udelay(2);
-	}
+	} while (loops--);
 
 	if (loops)				/* Cannot send otherwise. */
 		dz_out(dport, DZ_TDR, ch);
