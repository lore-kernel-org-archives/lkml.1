Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbZBIDTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbZBIDTS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 22:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753576AbZBIDTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 22:19:03 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:46100 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988AbZBIDTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 22:19:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=oKrcbyqHGl7DaA55d8ZyFzi6p7xSKXvlh9onX8TvDWzpQqYJtbHGaRaDwUdbQKpI4n
         3gveeJRbr9mi4zVlCMr9mRuzUhJ610F4DlxRWwo/cF1KPYqjKGF+urkv4nZdVbFBtk/d
         VCa3QoM1xbw9HM2oUEYlyZoudSqff1jVBq6gQ=
MIME-Version: 1.0
Date: Mon, 9 Feb 2009 11:19:00 +0800
Message-ID: <f17812d70902081919s4fd3b00fj82ce1b481f37f4ee@mail.gmail.com>
Subject: [PATCH] pxa: remove machine class specific stuffs from serial driver
From: Eric Miao <eric.y.miao@gmail.com>
To: linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The only things prevent drivers/serial/pxa.c from being generic enough
are:

  1. IER_UUE which can be safely replaced by UART_IER_UUE as defined in
     serial_reg.h for PXA

  2. __PREG() and FFUART/BTUART/STUART definitions to decide the UART
     port name

And removed the un-necessary #include of <mach/...> and <asm/...> headers.

Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 drivers/serial/pxa.c |   30 ++++++++++--------------------
 1 files changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/serial/pxa.c b/drivers/serial/pxa.c
index f6e3b86..a48a8a1 100644
--- a/drivers/serial/pxa.c
+++ b/drivers/serial/pxa.c
@@ -43,13 +43,7 @@
 #include <linux/tty_flip.h>
 #include <linux/serial_core.h>
 #include <linux/clk.h>
-
-#include <asm/io.h>
-#include <mach/hardware.h>
-#include <asm/irq.h>
-#include <mach/pxa-regs.h>
-#include <mach/regs-uart.h>
-
+#include <linux/io.h>

 struct uart_pxa_port {
 	struct uart_port        port;
@@ -491,7 +485,7 @@ serial_pxa_set_termios(struct uart_port *port,
struct ktermios *termios,
 	 * Ensure the port will be enabled.
 	 * This is required especially for serial console.
 	 */
-	up->ier |= IER_UUE;
+	up->ier |= UART_IER_UUE;

 	/*
 	 * Update the per-port timeout.
@@ -784,19 +778,15 @@ static int serial_pxa_probe(struct platform_device *dev)
 	sport->port.flags = UPF_IOREMAP | UPF_BOOT_AUTOCONF;
 	sport->port.uartclk = clk_get_rate(sport->clk);

-	/*
-	 * Is it worth keeping this?
-	 */
-	if (mmres->start == __PREG(FFUART))
-		sport->name = "FFUART";
-	else if (mmres->start == __PREG(BTUART))
-		sport->name = "BTUART";
-	else if (mmres->start == __PREG(STUART))
-		sport->name = "STUART";
-	else if (mmres->start == __PREG(HWUART))
-		sport->name = "HWUART";
-	else
+	switch (dev->id) {
+	case 0: sport->name = "FFUART"; break;
+	case 1: sport->name = "BTUART"; break;
+	case 2: sport->name = "STUART"; break;
+	case 3: sport->name = "HWUART"; break;
+	default:
 		sport->name = "???";
+		break;
+	}

 	sport->port.membase = ioremap(mmres->start, mmres->end - mmres->start + 1);
 	if (!sport->port.membase) {
-- 
1.6.0.4
