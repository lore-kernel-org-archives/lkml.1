Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbZFVXTe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbZFVXTe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 19:19:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbZFVXTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 19:19:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:56006 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754028AbZFVXTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 19:19:18 -0400
From: Vikram Pandita <vikram.pandita@ti.com>
To: linux-serial@vger.kernel.org, linux-omap@vger.kernel.org,
       alan@lxorguk.ukuu.org.uk, maz@misterjones.org
Cc: linux-kernel@vger.kernel.org, Vikram Pandita <vikram.pandita@ti.com>
Subject: [PATCH v2] serial: 8250: add IRQ trigger support
Date: Mon, 22 Jun 2009 18:15:19 -0500
Message-Id: <1245712519-18259-1-git-send-email-vikram.pandita@ti.com>
X-Mailer: git-send-email 1.6.0.3.613.g9f8f13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is currently no provision for passing IRQ trigger flags for
serial IRQs with triggering requirements (such as GPIO IRQs)

This patch adds irqflags to plat_serial8250_port that can be passed
from board file to reqest_irq() of 8250 driver

Changes are backward compatible with boards passing UPF_SHARE_IRQ flag

Tested on Zoom2 board that has IRQF_TRIGGER_RISING requirement for 8250 irq

Signed-off-by: Vikram Pandita <vikram.pandita@ti.com>
---
 drivers/serial/8250.c       |   14 +++++++++-----
 drivers/serial/8250.h       |    1 +
 include/linux/serial_8250.h |    1 +
 include/linux/serial_core.h |    1 +
 4 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index bab115e..d18a4c0 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1674,7 +1674,7 @@ static int serial_link_irq_chain(struct uart_8250_port *up)
 		INIT_LIST_HEAD(&up->list);
 		i->head = &up->list;
 		spin_unlock_irq(&i->lock);
-
+		irq_flags |= up->port.irqflags;
 		ret = request_irq(up->port.irq, serial8250_interrupt,
 				  irq_flags, "serial", i);
 		if (ret < 0)
@@ -2023,7 +2023,7 @@ static int serial8250_startup(struct uart_port *port)
 		 * allow register changes to become visible.
 		 */
 		spin_lock_irqsave(&up->port.lock, flags);
-		if (up->port.flags & UPF_SHARE_IRQ)
+		if (up->port.irqflags & IRQF_SHARED)
 			disable_irq_nosync(up->port.irq);
 
 		wait_for_xmitr(up, UART_LSR_THRE);
@@ -2036,7 +2036,7 @@ static int serial8250_startup(struct uart_port *port)
 		iir = serial_in(up, UART_IIR);
 		serial_out(up, UART_IER, 0);
 
-		if (up->port.flags & UPF_SHARE_IRQ)
+		if (up->port.irqflags & IRQF_SHARED)
 			enable_irq(up->port.irq);
 		spin_unlock_irqrestore(&up->port.lock, flags);
 
@@ -2681,6 +2681,7 @@ static void __init serial8250_isa_init_ports(void)
 	     i++, up++) {
 		up->port.iobase   = old_serial_port[i].port;
 		up->port.irq      = irq_canonicalize(old_serial_port[i].irq);
+		up->port.irqflags = old_serial_port[i].irqflags;
 		up->port.uartclk  = old_serial_port[i].baud_base * 16;
 		up->port.flags    = old_serial_port[i].flags;
 		up->port.hub6     = old_serial_port[i].hub6;
@@ -2689,7 +2690,7 @@ static void __init serial8250_isa_init_ports(void)
 		up->port.regshift = old_serial_port[i].iomem_reg_shift;
 		set_io_from_upio(&up->port);
 		if (share_irqs)
-			up->port.flags |= UPF_SHARE_IRQ;
+			up->port.irqflags |= IRQF_SHARED;
 	}
 }
 
@@ -2879,6 +2880,7 @@ int __init early_serial_setup(struct uart_port *port)
 	p->iobase       = port->iobase;
 	p->membase      = port->membase;
 	p->irq          = port->irq;
+	p->irqflags     = port->irqflags;
 	p->uartclk      = port->uartclk;
 	p->fifosize     = port->fifosize;
 	p->regshift     = port->regshift;
@@ -2952,6 +2954,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.iobase		= p->iobase;
 		port.membase		= p->membase;
 		port.irq		= p->irq;
+		port.irqflags		= p->irqflags;
 		port.uartclk		= p->uartclk;
 		port.regshift		= p->regshift;
 		port.iotype		= p->iotype;
@@ -2964,7 +2967,7 @@ static int __devinit serial8250_probe(struct platform_device *dev)
 		port.serial_out		= p->serial_out;
 		port.dev		= &dev->dev;
 		if (share_irqs)
-			port.flags |= UPF_SHARE_IRQ;
+			port.irqflags |= IRQF_SHARED;
 		ret = serial8250_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
@@ -3106,6 +3109,7 @@ int serial8250_register_port(struct uart_port *port)
 		uart->port.iobase       = port->iobase;
 		uart->port.membase      = port->membase;
 		uart->port.irq          = port->irq;
+		uart->port.irqflags     = port->irqflags;
 		uart->port.uartclk      = port->uartclk;
 		uart->port.fifosize     = port->fifosize;
 		uart->port.regshift     = port->regshift;
diff --git a/drivers/serial/8250.h b/drivers/serial/8250.h
index 5202603..9b34b04 100644
--- a/drivers/serial/8250.h
+++ b/drivers/serial/8250.h
@@ -20,6 +20,7 @@ struct old_serial_port {
 	unsigned int baud_base;
 	unsigned int port;
 	unsigned int irq;
+	unsigned long irqflags;
 	unsigned int flags;
 	unsigned char hub6;
 	unsigned char io_type;
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index d4d2a78..fb46aba 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -22,6 +22,7 @@ struct plat_serial8250_port {
 	void __iomem	*membase;	/* ioremap cookie or NULL */
 	resource_size_t	mapbase;	/* resource base */
 	unsigned int	irq;		/* interrupt number */
+	unsigned long	irqflags;	/* request_irq flags */
 	unsigned int	uartclk;	/* UART clock rate */
 	void            *private_data;
 	unsigned char	regshift;	/* register shift */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 57a97e5..a8635ef 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -258,6 +258,7 @@ struct uart_port {
 	unsigned int		(*serial_in)(struct uart_port *, int);
 	void			(*serial_out)(struct uart_port *, int, int);
 	unsigned int		irq;			/* irq number */
+	unsigned long		irqflags;		/* irq flags  */
 	unsigned int		uartclk;		/* base uart clock */
 	unsigned int		fifosize;		/* tx fifo size */
 	unsigned char		x_char;			/* xon/xoff char */
-- 
1.6.0.3.613.g9f8f13

