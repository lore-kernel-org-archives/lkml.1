Return-Path: <linux-kernel-owner+w=401wt.eu-S965691AbXCGV5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965691AbXCGV5N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 16:57:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965692AbXCGV5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 16:57:13 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57919 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S965691AbXCGV5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 16:57:12 -0500
From: Pat Gefre <pfg@sgi.com>
Message-Id: <200703072157.l27Lv87s240185@fsgi900.americas.sgi.com>
Subject: [PATCH] 2.6 Altix : console fix for CONFIG_DEBUG_SHIRQ usage
To: linux-kernel@vger.kernel.org, akpm@osdl.org
Date: Wed, 7 Mar 2007 15:57:07 -0600 (CST)
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The sn console driver was snagged by the use of CONFIG_DEBUG_SHIRQ !

The request_irq() immediate call to the interrupt handler caused
another attempt to lock the port lock - deadlock.

This is a patch to fix that.

Signed-off-by: Patrick Gefre <pfg@sgi.com>



 sn_console.c |   52 +++++++++++++++++-----------------------------------
 1 file changed, 17 insertions(+), 35 deletions(-)


Index: linux-2.6/drivers/serial/sn_console.c
===================================================================
--- linux-2.6.orig/drivers/serial/sn_console.c	2007-03-07 11:59:57.853775134 -0600
+++ linux-2.6/drivers/serial/sn_console.c	2007-03-07 15:27:37.455224799 -0600
@@ -636,25 +636,6 @@
 }
 
 /**
- * sn_sal_connect_interrupt - Request interrupt, handled by sn_sal_interrupt
- * @port: Our sn_cons_port (which contains the uart port)
- *
- * returns the console irq if interrupt is successfully registered, else 0
- *
- */
-static int sn_sal_connect_interrupt(struct sn_cons_port *port)
-{
-	if (request_irq(SGI_UART_VECTOR, sn_sal_interrupt,
-			IRQF_DISABLED | IRQF_SHARED,
-			"SAL console driver", port) >= 0) {
-		return SGI_UART_VECTOR;
-	}
-
-	printk(KERN_INFO "sn_console: console proceeding in polled mode\n");
-	return 0;
-}
-
-/**
  * sn_sal_timer_poll - this function handles polled console mode
  * @data: A pointer to our sn_cons_port (which contains the uart port)
  *
@@ -746,30 +727,31 @@
  * mode.  We were previously in asynch/polling mode (using init_timer).
  *
  * We attempt to switch to interrupt mode here by calling
- * sn_sal_connect_interrupt.  If that works out, we enable receive interrupts.
+ * request_irq.  If that works out, we enable receive interrupts.
  */
 static void __init sn_sal_switch_to_interrupts(struct sn_cons_port *port)
 {
-	int irq;
 	unsigned long flags;
 
-	if (!port)
-		return;
-
-	DPRINTF("sn_console: switching to interrupt driven console\n");
-
-	spin_lock_irqsave(&port->sc_port.lock, flags);
+	if (port) {
+		DPRINTF("sn_console: switching to interrupt driven console\n");
 
-	irq = sn_sal_connect_interrupt(port);
+		if (request_irq(SGI_UART_VECTOR, sn_sal_interrupt,
+				IRQF_DISABLED | IRQF_SHARED,
+				"SAL console driver", port) >= 0) {
+			spin_lock_irqsave(&port->sc_port.lock, flags);
+			port->sc_port.irq = SGI_UART_VECTOR;
+			port->sc_ops = &intr_ops;
 
-	if (irq) {
-		port->sc_port.irq = irq;
-		port->sc_ops = &intr_ops;
-
-		/* turn on receive interrupts */
-		ia64_sn_console_intr_enable(SAL_CONSOLE_INTR_RECV);
+			/* turn on receive interrupts */
+			ia64_sn_console_intr_enable(SAL_CONSOLE_INTR_RECV);
+			spin_unlock_irqrestore(&port->sc_port.lock, flags);
+		}
+		else {
+			printk(KERN_INFO
+			    "sn_console: console proceeding in polled mode\n");
+		}
 	}
-	spin_unlock_irqrestore(&port->sc_port.lock, flags);
 }
 
 /*
