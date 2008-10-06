Return-Path: <linux-kernel-owner+w=401wt.eu-S1757271AbYJFXhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271AbYJFXhb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 19:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755347AbYJFXgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 19:36:53 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:55388 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbYJFXgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 19:36:50 -0400
Message-ID: <48EA9DB8.1000309@caviumnetworks.com>
Date: Mon, 06 Oct 2008 16:22:32 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
CC: "Paoletti, Tomaso" <Tomaso.Paoletti@caviumnetworks.com>
Subject: [PATCH 1/2] serial: Allow for replacable I/O functions in 8250 driver.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Oct 2008 23:22:33.0097 (UTC) FILETIME=[68DE8F90:01C9280A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cavium: generic 8250 serial driver changes

We are in the process of preparing kernel support for the Cavium
Networks OCTEON processor for inclusion in the main-line kernel
sources.  The main (perhaps only) place this affects the non-processor
specific parts of the kernel is in the 8250 serial driver.  The OCTEON
contains several on-chip UARTS that require processor specific register
access code.

It is our thought that rather than pollute the 8250 driver with yet
another one-off register access method, we would change the driver to
access the UART registers via function pointers setup at driver
initialization time.  A side benefit of this is that it makes it easy
to move some of the existing register access code back to platform
specific files.

Patch 1 makes the register access functions replaceable.

Patch 2 is a completely untested prototype that moves the UPIO_TSI
back to platform specific code.

This part tested on 2.6.27-rc8 on i686.

In order to use Cavium OCTEON specific serial i/o drivers, we first patch
the 8250 driver to use replaceable i/o functions.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Signed-off-by: Tomaso Paoletti <tpaoletti@caviumnetworks.com>
---
 drivers/serial/8250.c       |  185 +++++++++++++++++++++++++++++--------------
 include/linux/serial_8250.h |    2 +
 include/linux/serial_core.h |    2 +
 3 files changed, 131 insertions(+), 58 deletions(-)

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 9ccc563..02771d6 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -288,16 +288,16 @@ static const u8 au_io_out_map[] = {
 };
 
 /* sane hardware needs no mapping */
-static inline int map_8250_in_reg(struct uart_8250_port *up, int offset)
+static inline int map_8250_in_reg(struct uart_port *p, int offset)
 {
-	if (up->port.iotype != UPIO_AU)
+	if (p->iotype != UPIO_AU)
 		return offset;
 	return au_io_in_map[offset];
 }
 
-static inline int map_8250_out_reg(struct uart_8250_port *up, int offset)
+static inline int map_8250_out_reg(struct uart_port *p, int offset)
 {
-	if (up->port.iotype != UPIO_AU)
+	if (p->iotype != UPIO_AU)
 		return offset;
 	return au_io_out_map[offset];
 }
@@ -326,16 +326,16 @@ static const u8
 		[UART_SCR]	= 0x2c
 	};
 
-static inline int map_8250_in_reg(struct uart_8250_port *up, int offset)
+static inline int map_8250_in_reg(struct uart_port *p, int offset)
 {
-	if (up->port.iotype != UPIO_RM9000)
+	if (p->iotype != UPIO_RM9000)
 		return offset;
 	return regmap_in[offset];
 }
 
-static inline int map_8250_out_reg(struct uart_8250_port *up, int offset)
+static inline int map_8250_out_reg(struct uart_port *p, int offset)
 {
-	if (up->port.iotype != UPIO_RM9000)
+	if (p->iotype != UPIO_RM9000)
 		return offset;
 	return regmap_out[offset];
 }
@@ -348,108 +348,170 @@ static inline int map_8250_out_reg(struct uart_8250_port *up, int offset)
 
 #endif
 
-static unsigned int serial_in(struct uart_8250_port *up, int offset)
+static unsigned int hub6_serial_in_fn(struct uart_port *p, int offset)
 {
-	unsigned int tmp;
-	offset = map_8250_in_reg(up, offset) << up->port.regshift;
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	outb(p->hub6 - 1 + offset, p->iobase);
+	return inb(p->iobase + 1);
+}
 
-	switch (up->port.iotype) {
-	case UPIO_HUB6:
-		outb(up->port.hub6 - 1 + offset, up->port.iobase);
-		return inb(up->port.iobase + 1);
+static void hub6_serial_out_fn(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	outb(p->hub6 - 1 + offset, p->iobase);
+	outb(value, p->iobase + 1);
+}
 
-	case UPIO_MEM:
-	case UPIO_DWAPB:
-		return readb(up->port.membase + offset);
+static unsigned int mem_serial_in_fn(struct uart_port *p, int offset)
+{
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	return readb(p->membase + offset);
+}
 
-	case UPIO_RM9000:
-	case UPIO_MEM32:
-		return readl(up->port.membase + offset);
+static void mem_serial_out_fn(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	writeb(value, p->membase + offset);
+}
+
+static void mem32_serial_out_fn(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	writel(value, p->membase + offset);
+}
+
+static unsigned int mem32_serial_in_fn(struct uart_port *p, int offset)
+{
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	return readl(p->membase + offset);
+}
 
 #ifdef CONFIG_SERIAL_8250_AU1X00
-	case UPIO_AU:
-		return __raw_readl(up->port.membase + offset);
+static unsigned int au_serial_in_fn(struct uart_port *p, int offset)
+{
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	return __raw_readl(p->membase + offset);
+}
+
+static void au_serial_out_fn(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	__raw_writel(value, p->membase + offset);
+}
 #endif
 
-	case UPIO_TSI:
-		if (offset == UART_IIR) {
-			tmp = readl(up->port.membase + (UART_IIR & ~3));
-			return (tmp >> 16) & 0xff; /* UART_IIR % 4 == 2 */
-		} else
-			return readb(up->port.membase + offset);
+static unsigned int tsi_serial_in_fn(struct uart_port *p, int offset)
+{
+	unsigned int tmp;
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	if (offset == UART_IIR) {
+		tmp = readl(p->membase + (UART_IIR & ~3));
+		return (tmp >> 16) & 0xff; /* UART_IIR % 4 == 2 */
+	} else
+		return readb(p->membase + offset);
+}
 
-	default:
-		return inb(up->port.iobase + offset);
-	}
+static void tsi_serial_out_fn(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	if (!((offset == UART_IER) && (value & UART_IER_UUE)))
+		writeb(value, p->membase + offset);
 }
 
-static void
-serial_out(struct uart_8250_port *up, int offset, int value)
+static void dwapb_serial_out_fn(struct uart_port *p, int offset, int value)
 {
-	/* Save the offset before it's remapped */
 	int save_offset = offset;
-	offset = map_8250_out_reg(up, offset) << up->port.regshift;
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	/* Save the LCR value so it can be re-written when a
+	 * Busy Detect interrupt occurs. */
+	if (save_offset == UART_LCR) {
+		struct uart_8250_port *up = (struct uart_8250_port *)p;
+		up->lcr = value;
+	}
+	writeb(value, p->membase + offset);
+	/* Read the IER to ensure any interrupt is cleared before
+	 * returning from ISR. */
+	if (save_offset == UART_TX || save_offset == UART_IER)
+		value = p->serial_in_fn(p, UART_IER);
+}
 
-	switch (up->port.iotype) {
+static unsigned int io_serial_in_fn(struct uart_port *p, int offset)
+{
+	offset = map_8250_in_reg(p, offset) << p->regshift;
+	return inb(p->iobase + offset);
+}
+
+static void io_serial_out_fn(struct uart_port *p, int offset, int value)
+{
+	offset = map_8250_out_reg(p, offset) << p->regshift;
+	outb(value, p->iobase + offset);
+}
+
+static void set_io_fns_from_upio(struct uart_port *p)
+{
+	switch (p->iotype) {
 	case UPIO_HUB6:
-		outb(up->port.hub6 - 1 + offset, up->port.iobase);
-		outb(value, up->port.iobase + 1);
+		p->serial_in_fn = hub6_serial_in_fn;
+		p->serial_out_fn = hub6_serial_out_fn;
 		break;
 
 	case UPIO_MEM:
-		writeb(value, up->port.membase + offset);
+		p->serial_in_fn = mem_serial_in_fn;
+		p->serial_out_fn = mem_serial_out_fn;
 		break;
 
 	case UPIO_RM9000:
 	case UPIO_MEM32:
-		writel(value, up->port.membase + offset);
+		p->serial_in_fn = mem32_serial_in_fn;
+		p->serial_out_fn = mem32_serial_out_fn;
 		break;
 
 #ifdef CONFIG_SERIAL_8250_AU1X00
 	case UPIO_AU:
-		__raw_writel(value, up->port.membase + offset);
+		p->serial_in_fn = au_serial_in_fn;
+		p->serial_out_fn = au_serial_out_fn;
 		break;
 #endif
 	case UPIO_TSI:
-		if (!((offset == UART_IER) && (value & UART_IER_UUE)))
-			writeb(value, up->port.membase + offset);
+		p->serial_in_fn = tsi_serial_in_fn;
+		p->serial_out_fn = tsi_serial_out_fn;
 		break;
 
 	case UPIO_DWAPB:
-		/* Save the LCR value so it can be re-written when a
-		 * Busy Detect interrupt occurs. */
-		if (save_offset == UART_LCR)
-			up->lcr = value;
-		writeb(value, up->port.membase + offset);
-		/* Read the IER to ensure any interrupt is cleared before
-		 * returning from ISR. */
-		if (save_offset == UART_TX || save_offset == UART_IER)
-			value = serial_in(up, UART_IER);
+		p->serial_in_fn = mem_serial_in_fn;
+		p->serial_out_fn = dwapb_serial_out_fn;
 		break;
 
 	default:
-		outb(value, up->port.iobase + offset);
+		p->serial_in_fn = io_serial_in_fn;
+		p->serial_out_fn = io_serial_out_fn;
+		break;
 	}
 }
 
 static void
 serial_out_sync(struct uart_8250_port *up, int offset, int value)
 {
-	switch (up->port.iotype) {
+	struct uart_port *p = &up->port;
+	switch (p->iotype) {
 	case UPIO_MEM:
 	case UPIO_MEM32:
 #ifdef CONFIG_SERIAL_8250_AU1X00
 	case UPIO_AU:
 #endif
 	case UPIO_DWAPB:
-		serial_out(up, offset, value);
-		serial_in(up, UART_LCR);	/* safe, no side-effects */
+		p->serial_out_fn(p, offset, value);
+		p->serial_in_fn(p, UART_LCR);	/* safe, no side-effects */
 		break;
 	default:
-		serial_out(up, offset, value);
+		p->serial_out_fn(p, offset, value);
 	}
 }
 
+#define serial_in(up, offset)		\
+	(up->port.serial_in_fn(&(up)->port, (offset)))
+#define serial_out(up, offset, value)	\
+	(up->port.serial_out_fn(&(up)->port, (offset), (value)))
 /*
  * We used to support using pause I/O for certain machines.  We
  * haven't supported this for a while, but just in case it's badly
@@ -2511,6 +2573,7 @@ static void __init serial8250_isa_init_ports(void)
 		up->port.membase  = old_serial_port[i].iomem_base;
 		up->port.iotype   = old_serial_port[i].io_type;
 		up->port.regshift = old_serial_port[i].iomem_reg_shift;
+		set_io_fns_from_upio(&up->port);
 		if (share_irqs)
 			up->port.flags |= UPF_SHARE_IRQ;
 	}
@@ -2912,6 +2975,12 @@ int serial8250_register_port(struct uart_port *port)
 		uart->port.private_data = port->private_data;
 		if (port->dev)
 			uart->port.dev = port->dev;
+		set_io_fns_from_upio(&uart->port);
+		/* Possibly override default I/O functions.  */
+		if (port->serial_in_fn)
+			uart->port.serial_in_fn = port->serial_in_fn;
+		if (port->serial_out_fn)
+			uart->port.serial_out_fn = port->serial_out_fn;
 
 		ret = uart_add_one_port(&serial8250_reg, &uart->port);
 		if (ret == 0)
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 3d37c94..eb08b04 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -28,6 +28,8 @@ struct plat_serial8250_port {
 	unsigned char	iotype;		/* UPIO_* */
 	unsigned char	hub6;
 	upf_t		flags;		/* UPF_* flags */
+	unsigned int	(*serial_in_fn)(struct uart_port *, int);
+	void		(*serial_out_fn)(struct uart_port *, int, int);
 };
 
 /*
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 3b2f6c0..3a4afcf 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -243,6 +243,8 @@ struct uart_port {
 	spinlock_t		lock;			/* port lock */
 	unsigned int		iobase;			/* in/out[bwl] */
 	unsigned char __iomem	*membase;		/* read/write[bwl] */
+	unsigned int		(*serial_in_fn)(struct uart_port *, int);
+	void			(*serial_out_fn)(struct uart_port *, int, int);
 	unsigned int		irq;			/* irq number */
 	unsigned int		uartclk;		/* base uart clock */
 	unsigned int		fifosize;		/* tx fifo size */
