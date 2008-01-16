Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbYAPRJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbYAPRJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:09:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYAPRIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:08:51 -0500
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:33194 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYAPRIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:08:49 -0500
Message-Id: <20080116170914.709127164@ldl.fc.hp.com>
References: <20080116170541.511233227@ldl.fc.hp.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Jan 2008 10:05:42 -0700
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Cc: linux-serial@vger.kernel.org
Cc: Russell King <rmk+serial@arm.linux.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 1/2] 8250: add serial8250_register_port_at() for requesting specific ttyS lines
Content-Disposition: inline; filename=8250-register-at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add an interface for registering a new UART with a specific ttyS name.

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

Index: work5/include/linux/serial_8250.h
===================================================================
--- work5.orig/include/linux/serial_8250.h	2008-01-15 16:31:49.000000000 -0700
+++ work5/include/linux/serial_8250.h	2008-01-15 16:32:42.000000000 -0700
@@ -56,6 +56,7 @@
 struct uart_port;
 
 int serial8250_register_port(struct uart_port *);
+int serial8250_register_port_at(struct uart_port *, int line);
 void serial8250_unregister_port(int line);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
Index: work5/drivers/serial/8250.c
===================================================================
--- work5.orig/drivers/serial/8250.c	2008-01-15 16:31:49.000000000 -0700
+++ work5/drivers/serial/8250.c	2008-01-16 09:32:20.000000000 -0700
@@ -2785,6 +2785,25 @@
 	return NULL;
 }
 
+static int serial8250_add_port(struct uart_8250_port *uart, struct uart_port *port)
+{
+	uart_remove_one_port(&serial8250_reg, &uart->port);
+
+	uart->port.iobase   = port->iobase;
+	uart->port.membase  = port->membase;
+	uart->port.irq      = port->irq;
+	uart->port.uartclk  = port->uartclk;
+	uart->port.fifosize = port->fifosize;
+	uart->port.regshift = port->regshift;
+	uart->port.iotype   = port->iotype;
+	uart->port.flags    = port->flags | UPF_BOOT_AUTOCONF;
+	uart->port.mapbase  = port->mapbase;
+	if (port->dev)
+		uart->port.dev = port->dev;
+
+	return uart_add_one_port(&serial8250_reg, &uart->port);
+}
+
 /**
  *	serial8250_register_port - register a serial port
  *	@port: serial port template
@@ -2809,32 +2828,58 @@
 	mutex_lock(&serial_mutex);
 
 	uart = serial8250_find_match_or_unused(port);
-	if (uart) {
-		uart_remove_one_port(&serial8250_reg, &uart->port);
+	if (uart)
+		ret = serial8250_add_port(uart, port);
 
-		uart->port.iobase   = port->iobase;
-		uart->port.membase  = port->membase;
-		uart->port.irq      = port->irq;
-		uart->port.uartclk  = port->uartclk;
-		uart->port.fifosize = port->fifosize;
-		uart->port.regshift = port->regshift;
-		uart->port.iotype   = port->iotype;
-		uart->port.flags    = port->flags | UPF_BOOT_AUTOCONF;
-		uart->port.mapbase  = port->mapbase;
-		if (port->dev)
-			uart->port.dev = port->dev;
-
-		ret = uart_add_one_port(&serial8250_reg, &uart->port);
-		if (ret == 0)
-			ret = uart->port.line;
-	}
 	mutex_unlock(&serial_mutex);
 
+	if (ret == 0)
+		return uart->port.line;
 	return ret;
 }
 EXPORT_SYMBOL(serial8250_register_port);
 
 /**
+ *	serial8250_register_port_at - register a serial port at a specific line
+ *	@port: serial port template
+ *	@line: desired line
+ *
+ *	Same as serial8250_register_port(), except that we request a
+ *	specific ttyS name.  This is used for well-known ports like
+ *	COM1-COM4, which people expect to always be ttyS0-ttyS3.
+ *
+ *	This fails if the requested line is already in use, even though
+ *	other lines might still be available.  The caller can retry with
+ *	serial8250_register_port() if desired.
+ */
+int serial8250_register_port_at(struct uart_port *port, int line)
+{
+	struct uart_8250_port *uart;
+	int ret;
+
+	if (port->uartclk == 0)
+		return -EINVAL;
+
+	if (line >= nr_uarts)
+		return -ENOSPC;
+
+	mutex_lock(&serial_mutex);
+
+	uart = &serial8250_ports[line];
+	if (uart->port.type == PORT_UNKNOWN && uart->port.iobase == 0)
+		ret = serial8250_add_port(uart, port);
+	else
+		ret = -EBUSY;
+
+	mutex_unlock(&serial_mutex);
+
+	if (ret == 0)
+		return uart->port.line;
+	return ret;
+}
+EXPORT_SYMBOL(serial8250_register_port_at);
+
+/**
  *	serial8250_unregister_port - remove a 16x50 serial port at runtime
  *	@line: serial line number
  *

-- 
