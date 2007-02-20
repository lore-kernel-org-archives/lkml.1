Return-Path: <linux-kernel-owner+w=401wt.eu-S965641AbXBTDTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965641AbXBTDTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:19:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965642AbXBTDTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:19:54 -0500
Received: from ozlabs.org ([203.10.76.45]:50848 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965641AbXBTDTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:19:52 -0500
To: Andrew Morton <akpm@osdl.org>
CC: <linux-kernel@vger.kernel.org>, <rmk@arm.linux.org.uk>,
       <linuxppc-dev@ozlabs.org>
From: David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 2/2] Use resource_size_t for serial port IO addresses
In-Reply-To: <20070220031717.GI17818@localhost.localdomain>
Message-Id: <20070220031951.5D53BDDD0E@ozlabs.org>
Date: Tue, 20 Feb 2007 14:19:51 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At present, various parts of the serial code use unsigned long to
define resource addresses.  This is a problem, because some 32-bit
platforms have physical addresses larger than 32-bits, and have mmio
serial uarts located above the 4GB point.

This patch changes the type of mapbase in both struct uart_port and
struct plat_serial8250_port to resource_size_t, which can be
configured to be 64 bits on such platforms.  The mapbase in
serial_struct can't safely be changed, because that structure is user
visible.

Signed-off-by: David Gibson <dwg@au1.ibm.com>
---

 drivers/serial/8250.c        |    5 +++--
 drivers/serial/8250_early.c  |   16 +++++++++-------
 drivers/serial/serial_core.c |    9 +++++----
 include/linux/serial_8250.h  |    2 +-
 include/linux/serial_core.h  |    2 +-
 5 files changed, 19 insertions(+), 15 deletions(-)

Index: working-2.6/include/linux/serial_core.h
===================================================================
--- working-2.6.orig/include/linux/serial_core.h	2007-02-19 11:07:42.000000000 +1100
+++ working-2.6/include/linux/serial_core.h	2007-02-19 11:07:43.000000000 +1100
@@ -273,7 +273,7 @@ struct uart_port {
 	const struct uart_ops	*ops;
 	unsigned int		custom_divisor;
 	unsigned int		line;			/* port index */
-	unsigned long		mapbase;		/* for ioremap */
+	resource_size_t		mapbase;		/* for ioremap */
 	struct device		*dev;			/* parent device */
 	unsigned char		hub6;			/* this should be in the 8250 driver */
 	unsigned char		unused[3];
Index: working-2.6/drivers/serial/serial_core.c
===================================================================
--- working-2.6.orig/drivers/serial/serial_core.c	2007-02-19 11:07:42.000000000 +1100
+++ working-2.6/drivers/serial/serial_core.c	2007-02-19 11:07:43.000000000 +1100
@@ -633,7 +633,7 @@ static int uart_get_info(struct uart_sta
 	tmp.hub6	    = port->hub6;
 	tmp.io_type         = port->iotype;
 	tmp.iomem_reg_shift = port->regshift;
-	tmp.iomem_base      = (void *)port->mapbase;
+	tmp.iomem_base      = (void *)(unsigned long)port->mapbase;
 
 	if (copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
 		return -EFAULT;
@@ -1673,10 +1673,11 @@ static int uart_line_info(char *buf, str
 		return 0;
 
 	mmio = port->iotype >= UPIO_MEM;
-	ret = sprintf(buf, "%d: uart:%s %s%08lX irq:%d",
+	ret = sprintf(buf, "%d: uart:%s %s%08llX irq:%d",
 			port->line, uart_type(port),
 			mmio ? "mmio:0x" : "port:",
-			mmio ? port->mapbase : (unsigned long) port->iobase,
+			mmio ? (unsigned long long)port->mapbase
+		             : (unsigned long long) port->iobase,
 			port->irq);
 
 	if (port->type == PORT_UNKNOWN) {
@@ -2069,7 +2070,7 @@ uart_report_port(struct uart_driver *drv
 	case UPIO_AU:
 	case UPIO_TSI:
 		snprintf(address, sizeof(address),
-			 "MMIO 0x%lx", port->mapbase);
+			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
 		break;
 	default:
 		strlcpy(address, "*unknown*", sizeof(address));
Index: working-2.6/drivers/serial/8250_early.c
===================================================================
--- working-2.6.orig/drivers/serial/8250_early.c	2007-02-19 11:07:40.000000000 +1100
+++ working-2.6/drivers/serial/8250_early.c	2007-02-19 11:07:43.000000000 +1100
@@ -145,8 +145,9 @@ static int __init parse_options(struct e
 		port->mapbase = simple_strtoul(options + 5, &options, 0);
 		port->membase = ioremap(port->mapbase, mapsize);
 		if (!port->membase) {
-			printk(KERN_ERR "%s: Couldn't ioremap 0x%lx\n",
-				__FUNCTION__, port->mapbase);
+			printk(KERN_ERR "%s: Couldn't ioremap 0x%llx\n",
+				__FUNCTION__,
+			       (unsigned long long)port->mapbase);
 			return -ENOMEM;
 		}
 		mmio = 1;
@@ -168,9 +169,10 @@ static int __init parse_options(struct e
 			device->baud);
 	}
 
-	printk(KERN_INFO "Early serial console at %s 0x%lx (options '%s')\n",
+	printk(KERN_INFO "Early serial console at %s 0x%llx (options '%s')\n",
 		mmio ? "MMIO" : "I/O port",
-		mmio ? port->mapbase : (unsigned long) port->iobase,
+		mmio ? (unsigned long long) port->mapbase
+	             : (unsigned long long) port->iobase,
 		device->options);
 	return 0;
 }
@@ -236,10 +238,10 @@ static int __init early_uart_console_swi
 	mmio = (port->iotype == UPIO_MEM);
 	line = serial8250_start_console(port, device->options);
 	if (line < 0)
-		printk("No ttyS device at %s 0x%lx for console\n",
+		printk("No ttyS device at %s 0x%llx for console\n",
 			mmio ? "MMIO" : "I/O port",
-			mmio ? port->mapbase :
-			    (unsigned long) port->iobase);
+			mmio ? (unsigned long long) port->mapbase
+		             : (unsigned long long) port->iobase);
 
 	unregister_console(&early_uart_console);
 	if (mmio)
Index: working-2.6/include/linux/serial_8250.h
===================================================================
--- working-2.6.orig/include/linux/serial_8250.h	2007-02-19 11:07:40.000000000 +1100
+++ working-2.6/include/linux/serial_8250.h	2007-02-19 11:07:43.000000000 +1100
@@ -20,7 +20,7 @@
 struct plat_serial8250_port {
 	unsigned long	iobase;		/* io base address */
 	void __iomem	*membase;	/* ioremap cookie or NULL */
-	unsigned long	mapbase;	/* resource base */
+	resource_size_t	mapbase;	/* resource base */
 	unsigned int	irq;		/* interrupt number */
 	unsigned int	uartclk;	/* UART clock rate */
 	unsigned char	regshift;	/* register shift */
Index: working-2.6/drivers/serial/8250.c
===================================================================
--- working-2.6.orig/drivers/serial/8250.c	2007-02-19 11:07:40.000000000 +1100
+++ working-2.6/drivers/serial/8250.c	2007-02-19 11:07:43.000000000 +1100
@@ -2550,8 +2550,9 @@ static int __devinit serial8250_probe(st
 		ret = serial8250_register_port(&port);
 		if (ret < 0) {
 			dev_err(&dev->dev, "unable to register port at index %d "
-				"(IO%lx MEM%lx IRQ%d): %d\n", i,
-				p->iobase, p->mapbase, p->irq, ret);
+				"(IO%lx MEM%llx IRQ%d): %d\n", i,
+				p->iobase, (unsigned long long)p->mapbase,
+				p->irq, ret);
 		}
 	}
 	return 0;
