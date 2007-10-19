Return-Path: <linux-kernel-owner+w=401wt.eu-S936169AbXJSUYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936169AbXJSUYd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 16:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758290AbXJSUYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 16:24:24 -0400
Received: from cerber.ds.pg.gda.pl ([153.19.208.18]:41858 "EHLO
	cerber.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756827AbXJSUYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 16:24:23 -0400
Date: Fri, 19 Oct 2007 21:24:16 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-mips@linux-mips.org, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] dz.c: Don't panic() when request_irq() fails
Message-ID: <Pine.LNX.4.64N.0710192119360.13279@blysk.ds.pg.gda.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 Well, panic() is a little bit undue if request_irq() fails; there is 
probably no need to justify it any further.  Handle the case gracefully, 
by unregistering the driver.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
 Tested with checkpatch.pl and at the run-time -- MIPS/Linux on a
DECstation 5000/200.

 Please apply,

  Maciej

patch-mips-2.6.18-20060920-dz-init-0
diff -up --recursive --new-file linux-mips-2.6.18-20060920.macro/drivers/serial/dz.c linux-mips-2.6.18-20060920/drivers/serial/dz.c
--- linux-mips-2.6.18-20060920.macro/drivers/serial/dz.c	2006-11-23 05:17:01.000000000 +0000
+++ linux-mips-2.6.18-20060920/drivers/serial/dz.c	2007-01-14 00:39:20.000000000 +0000
@@ -795,18 +795,28 @@ static int __init dz_init(void)
 	dz_reset(&dz_ports[0]);
 #endif
 
-	if (request_irq(dz_ports[0].port.irq, dz_interrupt,
-			IRQF_DISABLED, "DZ", &dz_ports[0]))
-		panic("Unable to register DZ interrupt");
-
 	ret = uart_register_driver(&dz_reg);
 	if (ret != 0)
-		return ret;
+		goto out;
+
+	ret = request_irq(dz_ports[0].port.irq, dz_interrupt, IRQF_DISABLED,
+			  "DZ", &dz_ports[0]);
+	if (ret != 0) {
+		printk(KERN_ERR "dz: Cannot get IRQ %d!\n",
+		       dz_ports[0].port.irq);
+		goto out_unregister;
+	}
 
 	for (i = 0; i < DZ_NB_PORT; i++)
 		uart_add_one_port(&dz_reg, &dz_ports[i].port);
 
 	return ret;
+
+out_unregister:
+	uart_unregister_driver(&dz_reg);
+
+out:
+	return ret;
 }
 
 module_init(dz_init);
