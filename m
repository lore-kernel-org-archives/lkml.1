Return-Path: <linux-kernel-owner+w=401wt.eu-S965637AbXBTDTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965637AbXBTDTx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 22:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965642AbXBTDTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 22:19:53 -0500
Received: from ozlabs.org ([203.10.76.45]:50844 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965637AbXBTDTw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 22:19:52 -0500
To: Andrew Morton <akpm@osdl.org>
CC: <linux-kernel@vger.kernel.org>, <rmk@arm.linux.org.uk>,
       <linuxppc-dev@ozlabs.org>
From: David Gibson <david@gibson.dropbear.id.au>
Subject: [PATCH 1/2] Define FIXED_PORT flag for serial_core
In-Reply-To: <20070220031717.GI17818@localhost.localdomain>
Message-Id: <20070220031951.56492DDD09@ozlabs.org>
Date: Tue, 20 Feb 2007 14:19:51 +1100 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At present, the serial core always allows setserial in userspace to
change the port address, irq and base clock of any serial port.  That
makes sense for legacy ISA ports, but not for (say) embedded ns16550
compatible serial ports at peculiar addresses.  In these cases, the
kernel code configuring the ports must know exactly where they are,
and their clocking arrangements (which can be unusual on embedded
boards).  It doesn't make sense for userspace to change these
settings.

Therefore, this patch defines a UPF_FIXED_PORT flag for the uart_port
structure.  If this flag is set when the serial port is configured,
any attempts to alter the port's type, io address, irq or base clock
with setserial are ignored.

In addition this patch uses the new flag for on-chip serial ports
probed in arch/powerpc/kernel/legacy_serial.c, and for other
hard-wired serial ports probed by drivers/serial/of_serial.c.

Signed-off-by: David Gibson <dwg@au1.ibm.com>
---

 arch/powerpc/kernel/legacy_serial.c |    3 ++-
 drivers/serial/of_serial.c          |    3 ++-
 drivers/serial/serial_core.c        |   22 +++++++++++++---------
 include/linux/serial_core.h         |    1 +
 4 files changed, 18 insertions(+), 11 deletions(-)

Index: working-2.6/drivers/serial/serial_core.c
===================================================================
--- working-2.6.orig/drivers/serial/serial_core.c	2007-02-19 11:05:32.000000000 +1100
+++ working-2.6/drivers/serial/serial_core.c	2007-02-20 11:38:08.000000000 +1100
@@ -672,19 +672,21 @@ static int uart_set_info(struct uart_sta
 	 */
 	mutex_lock(&state->mutex);
 
-	change_irq  = new_serial.irq != port->irq;
+	change_irq  = !(port->flags & UPF_FIXED_PORT)
+		&& new_serial.irq != port->irq;
 
 	/*
 	 * Since changing the 'type' of the port changes its resource
 	 * allocations, we should treat type changes the same as
 	 * IO port changes.
 	 */
-	change_port = new_port != port->iobase ||
-		      (unsigned long)new_serial.iomem_base != port->mapbase ||
-		      new_serial.hub6 != port->hub6 ||
-		      new_serial.io_type != port->iotype ||
-		      new_serial.iomem_reg_shift != port->regshift ||
-		      new_serial.type != port->type;
+	change_port = !(port->flags & UPF_FIXED_PORT)
+		&& (new_port != port->iobase ||
+		    (unsigned long)new_serial.iomem_base != port->mapbase ||
+		    new_serial.hub6 != port->hub6 ||
+		    new_serial.io_type != port->iotype ||
+		    new_serial.iomem_reg_shift != port->regshift ||
+		    new_serial.type != port->type);
 
 	old_flags = port->flags;
 	new_flags = new_serial.flags;
@@ -796,8 +798,10 @@ static int uart_set_info(struct uart_sta
 		}
 	}
 
-	port->irq              = new_serial.irq;
-	port->uartclk          = new_serial.baud_base * 16;
+	if (change_irq)
+		port->irq      = new_serial.irq;
+	if (! (port->flags & UPF_FIXED_PORT))
+		port->uartclk  = new_serial.baud_base * 16;
 	port->flags            = (port->flags & ~UPF_CHANGE_MASK) |
 				 (new_flags & UPF_CHANGE_MASK);
 	port->custom_divisor   = new_serial.custom_divisor;
Index: working-2.6/include/linux/serial_core.h
===================================================================
--- working-2.6.orig/include/linux/serial_core.h	2007-02-19 11:05:32.000000000 +1100
+++ working-2.6/include/linux/serial_core.h	2007-02-20 11:38:08.000000000 +1100
@@ -260,6 +260,7 @@ struct uart_port {
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
+#define UPF_FIXED_PORT		((__force upf_t) (1 << 29))
 #define UPF_DEAD		((__force upf_t) (1 << 30))
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
Index: working-2.6/arch/powerpc/kernel/legacy_serial.c
===================================================================
--- working-2.6.orig/arch/powerpc/kernel/legacy_serial.c	2007-02-15 10:05:18.000000000 +1100
+++ working-2.6/arch/powerpc/kernel/legacy_serial.c	2007-02-20 10:50:16.000000000 +1100
@@ -115,7 +115,8 @@ static int __init add_legacy_soc_port(st
 {
 	u64 addr;
 	const u32 *addrp;
-	upf_t flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ;
+	upf_t flags = UPF_BOOT_AUTOCONF | UPF_SKIP_TEST | UPF_SHARE_IRQ
+		| UPF_FIXED_PORT;
 	struct device_node *tsi = of_get_parent(np);
 
 	/* We only support ports that have a clock frequency properly
Index: working-2.6/drivers/serial/of_serial.c
===================================================================
--- working-2.6.orig/drivers/serial/of_serial.c	2007-02-20 11:38:16.000000000 +1100
+++ working-2.6/drivers/serial/of_serial.c	2007-02-20 11:38:30.000000000 +1100
@@ -48,7 +48,8 @@ static int __devinit of_platform_serial_
 	port->iotype = UPIO_MEM;
 	port->type = type;
 	port->uartclk = *clk;
-	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP;
+	port->flags = UPF_SHARE_IRQ | UPF_BOOT_AUTOCONF | UPF_IOREMAP
+		| UPF_FIXED_PORT;
 	port->dev = &ofdev->dev;
 	port->custom_divisor = *clk / (16 * (*spd));
 
