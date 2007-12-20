Return-Path: <linux-kernel-owner+w=401wt.eu-S1761565AbXLTOtG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761565AbXLTOtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:49:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758548AbXLTOsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:48:50 -0500
Received: from wx-out-0506.google.com ([66.249.82.232]:38598 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758249AbXLTOst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:48:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NQFXqUzQ+GP1TADxXzIPleTN0mkG6pXpvRxmPhRvEulKDCcE4TZB3kQUj5Wxe9Mbyoft79RUuDt0GI0EiU8NzEJWR4VbSZWXnSYYCvsgPbI0y94fkpynKGwSC3CJG+rPRXcAZ8jDviYADl64kS2HBS1wR/rQ8sI82NmwzvjXhlM=
Message-ID: <87a5b0800712200648o7cc48af9ic38d7d568affdbc8@mail.gmail.com>
Date: Thu, 20 Dec 2007 14:48:45 +0000
From: "Will Newton" <will.newton@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Support specifying DW APB UARTSs in device platform_data
Cc: linux-serial@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows the private_data field to be specified in
platform_data for the standard 8250/16550 UART. This field is used by
DW APB type UARTs and without this patch it's only possible to set
this field when registering the port by hand. If private_data is not
set then the
driver will potentially oops with a NULL pointer dereference.


Signed-off-by: Will Newton <will.newton@gmail.com>

---
 drivers/serial/8250.c       |   40 +++++++++++++++++++++-------------------
 include/linux/serial_8250.h |    1 +
 2 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f94109c..c93ef20 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2662,16 +2662,17 @@ static int __devinit serial8250_probe(struct
platform_device *dev)
 	memset(&port, 0, sizeof(struct uart_port));

 	for (i = 0; p && p->flags != 0; p++, i++) {
-		port.iobase	= p->iobase;
-		port.membase	= p->membase;
-		port.irq	= p->irq;
-		port.uartclk	= p->uartclk;
-		port.regshift	= p->regshift;
-		port.iotype	= p->iotype;
-		port.flags	= p->flags;
-		port.mapbase	= p->mapbase;
-		port.hub6	= p->hub6;
-		port.dev	= &dev->dev;
+		port.iobase		= p->iobase;
+		port.membase		= p->membase;
+		port.irq		= p->irq;
+		port.uartclk		= p->uartclk;
+		port.regshift		= p->regshift;
+		port.iotype		= p->iotype;
+		port.flags		= p->flags;
+		port.mapbase		= p->mapbase;
+		port.hub6		= p->hub6;
+		port.private_data	= p->private_data;
+		port.dev		= &dev->dev;
 		if (share_irqs)
 			port.flags |= UPF_SHARE_IRQ;
 		ret = serial8250_register_port(&port);
@@ -2812,15 +2813,16 @@ int serial8250_register_port(struct uart_port *port)
 	if (uart) {
 		uart_remove_one_port(&serial8250_reg, &uart->port);

-		uart->port.iobase   = port->iobase;
-		uart->port.membase  = port->membase;
-		uart->port.irq      = port->irq;
-		uart->port.uartclk  = port->uartclk;
-		uart->port.fifosize = port->fifosize;
-		uart->port.regshift = port->regshift;
-		uart->port.iotype   = port->iotype;
-		uart->port.flags    = port->flags | UPF_BOOT_AUTOCONF;
-		uart->port.mapbase  = port->mapbase;
+		uart->port.iobase       = port->iobase;
+		uart->port.membase      = port->membase;
+		uart->port.irq          = port->irq;
+		uart->port.uartclk      = port->uartclk;
+		uart->port.fifosize     = port->fifosize;
+		uart->port.regshift     = port->regshift;
+		uart->port.iotype       = port->iotype;
+		uart->port.flags        = port->flags | UPF_BOOT_AUTOCONF;
+		uart->port.mapbase      = port->mapbase;
+		uart->port.private_data = port->private_data;
 		if (port->dev)
 			uart->port.dev = port->dev;

diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index afe0f6d..00b65c0 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -23,6 +23,7 @@ struct plat_serial8250_port {
 	resource_size_t	mapbase;	/* resource base */
 	unsigned int	irq;		/* interrupt number */
 	unsigned int	uartclk;	/* UART clock rate */
+	void            *private_data;
 	unsigned char	regshift;	/* register shift */
 	unsigned char	iotype;		/* UPIO_* */
 	unsigned char	hub6;
-- 
1.5.3.5
