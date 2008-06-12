Return-Path: <linux-kernel-owner+w=401wt.eu-S1761232AbYFLWos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761232AbYFLWos (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 18:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760900AbYFLWoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 18:44:25 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:61203 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760878AbYFLWoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 18:44:24 -0400
Date: Thu, 12 Jun 2008 23:43:36 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-serial@vger.kernel.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] serial: Z85C30: Avoid a hang at console switch-over
Message-ID: <Pine.LNX.4.55.0806122024410.23634@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Changes to the generic console support code that happened a while ago
introduced a scenario where the initial console is used in parallel with
the final console during a brief period when switching between the two is
in progress.  During that time a message about the switch-over is printed.

 With some combinations of chips, firmware and drivers, such as the Zilog
Z85C30 SCC used with the DECstation, a hang may happen because the
firmware used for the initial console may not expect the state of the chip
after it has been initialised by the driver.  This is not a bug in the
firmware, as some registers it would have to examine are write-only.

 This is a workaround for the Z85C30 which reuses the power-management 
callback to keep the transmitter of the line associated with the console 
enabled.  It reflects the consensus reached in a discussion a while ago.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-mips-2.6.23-rc5-20070904-zs-pm-4
diff -up --recursive --new-file linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/zs.c linux-mips-2.6.23-rc5-20070904/drivers/serial/zs.c
--- linux-mips-2.6.23-rc5-20070904.macro/drivers/serial/zs.c	2007-09-04 04:55:44.000000000 +0000
+++ linux-mips-2.6.23-rc5-20070904/drivers/serial/zs.c	2007-09-22 20:25:10.000000000 +0000
@@ -787,7 +787,6 @@ static int zs_startup(struct uart_port *
 	zport->regs[1] &= ~RxINT_MASK;
 	zport->regs[1] |= RxINT_ALL | TxINT_ENAB | EXT_INT_ENAB;
 	zport->regs[3] |= RxENABLE;
-	zport->regs[5] |= TxENAB;
 	zport->regs[15] |= BRKIE;
 	write_zsreg(zport, R1, zport->regs[1]);
 	write_zsreg(zport, R3, zport->regs[3]);
@@ -814,7 +813,6 @@ static void zs_shutdown(struct uart_port
 
 	spin_lock_irqsave(&scc->zlock, flags);
 
-	zport->regs[5] &= ~TxENAB;
 	zport->regs[3] &= ~RxENABLE;
 	write_zsreg(zport, R5, zport->regs[5]);
 	write_zsreg(zport, R3, zport->regs[3]);
@@ -959,6 +957,23 @@ static void zs_set_termios(struct uart_p
 	spin_unlock_irqrestore(&scc->zlock, flags);
 }
 
+/*
+ * Hack alert!
+ * Required solely so that the initial PROM-based console
+ * works undisturbed in parallel with this one.
+ */
+static void zs_pm(struct uart_port *uport, unsigned int state,
+		  unsigned int oldstate)
+{
+	struct zs_port *zport = to_zport(uport);
+
+	if (state < 3)
+		zport->regs[5] |= TxENAB;
+	else
+		zport->regs[5] &= ~TxENAB;
+	write_zsreg(zport, R5, zport->regs[5]);
+}
+
 
 static const char *zs_type(struct uart_port *uport)
 {
@@ -1041,6 +1056,7 @@ static struct uart_ops zs_ops = {
 	.startup	= zs_startup,
 	.shutdown	= zs_shutdown,
 	.set_termios	= zs_set_termios,
+	.pm		= zs_pm,
 	.type		= zs_type,
 	.release_port	= zs_release_port,
 	.request_port	= zs_request_port,
@@ -1190,6 +1206,7 @@ static int __init zs_console_setup(struc
 		return ret;
 
 	zs_reset(zport);
+	zs_pm(uport, 0, -1);
 
 	if (options)
 		uart_parse_options(options, &baud, &parity, &bits, &flow);
