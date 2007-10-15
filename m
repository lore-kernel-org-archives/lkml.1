Return-Path: <linux-kernel-owner+w=401wt.eu-S1762084AbXJOSfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762084AbXJOSfa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 14:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933812AbXJOSde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 14:33:34 -0400
Received: from mail.windriver.com ([147.11.1.11]:47538 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933803AbXJOSd3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 14:33:29 -0400
Message-ID: <4713B24D.7040705@windriver.com>
Date: Mon, 15 Oct 2007 13:32:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-serial@vger.kernel.org
Subject: [PATCH 4/21] KGDB: KGDB I/O driver for any 8250-compatible UARTs.
Content-Type: multipart/mixed;
 boundary="------------050707050900050809000601"
X-OriginalArrivalTime: 15 Oct 2007 18:33:29.0312 (UTC) FILETIME=[E1B23E00:01C80F59]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050707050900050809000601
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

--------------050707050900050809000601
Content-Type: text/x-patch;
 name="8250.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="8250.patch"

8250.patch

From: Jason Wessel <jason.wessel@windriver.com>
CC: linux-serial@vger.kernel.org
Subject: [PATCH] KGDB I/O driver for any 8250-compatible UARTs.

This patch some small hooks into the normal serial core so that a uart
can be unregistered to be exclusively used for KGDB.  These changes
allow for registering and unregistering a port with a struct
uart_port.


If KGDB_8250 is enabled, SERIAL_8250_NR_UARTS is set to the default of
4.  This is so that if kgdb via rs232 can always depend on that
constant in the 8250 driver for giving our table a size.  


Signed-off-by: Milind Dumbare <milind@linsyssoft.com>
Signed-off-by: Dmitry Antipov <antipov@ru.mvista.com>
Signed-off-by: Tom Rini <trini@kernel.crashing.org>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/serial/8250.c        |   19 +
 drivers/serial/8250_kgdb.c   |  518 +++++++++++++++++++++++++++++++++++++++++++
 drivers/serial/Kconfig       |    2 
 drivers/serial/Makefile      |    1 
 drivers/serial/serial_core.c |   24 +
 include/linux/serial_8250.h  |    1 
 lib/Kconfig.kgdb             |   61 ++++-
 7 files changed, 620 insertions(+), 6 deletions(-)
 create mode 100644 drivers/serial/8250_kgdb.c

--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2859,6 +2859,25 @@ void serial8250_unregister_port(int line
 }
 EXPORT_SYMBOL(serial8250_unregister_port);
 
+/**
+ *	serial8250_unregister_by_port - remove a 16x50 serial port
+ *	at runtime.
+ *	@port: A &struct uart_port that describes the port to remove.
+ *
+ *	Remove one serial port.  This may not be called from interrupt
+ *	context.  We hand the port back to the our control.
+ */
+void serial8250_unregister_by_port(struct uart_port *port)
+{
+	struct uart_8250_port *uart;
+
+	uart = serial8250_find_match_or_unused(port);
+
+	if (uart)
+		serial8250_unregister_port(uart->port.line);
+}
+EXPORT_SYMBOL(serial8250_unregister_by_port);
+
 static int __init serial8250_init(void)
 {
 	int ret, i;
--- /dev/null
+++ b/drivers/serial/8250_kgdb.c
@@ -0,0 +1,518 @@
+/*
+ * 8250 interface for kgdb.
+ *
+ * This is a merging of many different drivers, and all of the people have
+ * had an impact in some form or another:
+ *
+ * 2004-2005 (c) MontaVista Software, Inc.
+ * 2005-2006 (c) Wind River Systems, Inc.
+ *
+ * Amit Kale <amitkale@emsyssoft.com>, David Grothe <dave@gcom.com>,
+ * Scott Foehner <sfoehner@engr.sgi.com>, George Anzinger <george@mvista.com>,
+ * Robert Walsh <rjwalsh@durables.org>, wangdi <wangdi@clusterfs.com>,
+ * San Mehat, Tom Rini <trini@mvista.com>,
+ * Jason Wessel <jason.wessel@windriver.com>
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/interrupt.h>
+#include <linux/tty.h>
+#include <linux/serial.h>
+#include <linux/serial_reg.h>
+#include <linux/serialP.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <asm/serial.h>		/* For BASE_BAUD and SERIAL_PORT_DFNS */
+
+#include "8250.h"
+
+#define GDB_BUF_SIZE	512	/* power of 2, please */
+
+MODULE_DESCRIPTION("KGDB driver for the 8250");
+MODULE_LICENSE("GPL");
+/* These will conflict with early_param otherwise. */
+#ifdef CONFIG_KGDB_8250_MODULE
+static char config[256];
+module_param_string(kgdb8250, config, 256, 0);
+MODULE_PARM_DESC(kgdb8250,
+		 " kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>\n");
+static struct kgdb_io local_kgdb_io_ops;
+#endif				/* CONFIG_KGDB_8250_MODULE */
+
+/* Speed of the UART. */
+static int kgdb8250_baud;
+
+/* Flag for if we need to call request_mem_region */
+static int kgdb8250_needs_request_mem_region;
+
+static char kgdb8250_buf[GDB_BUF_SIZE];
+static atomic_t kgdb8250_buf_in_cnt;
+static int kgdb8250_buf_out_inx;
+
+/* Old-style serial definitions, if existant, and a counter. */
+#ifdef CONFIG_KGDB_SIMPLE_SERIAL
+static int should_copy_rs_table = 1;
+static struct serial_state old_rs_table[] __initdata = {
+#ifdef SERIAL_PORT_DFNS
+	SERIAL_PORT_DFNS
+#endif
+};
+#endif
+
+/* Our internal table of UARTS. */
+#define UART_NR	CONFIG_SERIAL_8250_NR_UARTS
+static struct uart_port kgdb8250_ports[UART_NR];
+
+static struct uart_port *current_port;
+
+/* Base of the UART. */
+static void *kgdb8250_addr;
+
+/* Forward declarations. */
+static int kgdb8250_uart_init(void);
+static int __init kgdb_init_io(void);
+static int __init kgdb8250_opt(char *str);
+
+/* These are much shorter calls to ioread8/iowrite8 that take into
+ * account our shifts, etc. */
+static inline unsigned int kgdb_ioread(u8 mask)
+{
+	return ioread8(kgdb8250_addr + (mask << current_port->regshift));
+}
+
+static inline void kgdb_iowrite(u8 val, u8 mask)
+{
+	iowrite8(val, kgdb8250_addr + (mask << current_port->regshift));
+}
+
+/*
+ * Wait until the interface can accept a char, then write it.
+ */
+static void kgdb_put_debug_char(u8 chr)
+{
+	while (!(kgdb_ioread(UART_LSR) & UART_LSR_THRE)) ;
+
+	kgdb_iowrite(chr, UART_TX);
+}
+
+/*
+ * Get a byte from the hardware data buffer and return it
+ */
+static int read_data_bfr(void)
+{
+	char it = kgdb_ioread(UART_LSR);
+
+	if (it & UART_LSR_DR)
+		return kgdb_ioread(UART_RX);
+
+	/*
+	 * If we have a framing error assume somebody messed with
+	 * our uart.  Reprogram it and send '-' both ways...
+	 */
+	if (it & 0xc) {
+		kgdb8250_uart_init();
+		kgdb_put_debug_char('-');
+		return '-';
+	}
+
+	return -1;
+}
+
+/*
+ * Get a char if available, return -1 if nothing available.
+ * Empty the receive buffer first, then look at the interface hardware.
+ */
+static int kgdb_get_debug_char(void)
+{
+	int retchr;
+
+	/* intr routine has q'd chars */
+	if (atomic_read(&kgdb8250_buf_in_cnt) != 0) {
+		retchr = kgdb8250_buf[kgdb8250_buf_out_inx++];
+		kgdb8250_buf_out_inx &= (GDB_BUF_SIZE - 1);
+		atomic_dec(&kgdb8250_buf_in_cnt);
+		return retchr;
+	}
+
+	do {
+		retchr = read_data_bfr();
+	} while (retchr < 0);
+
+	return retchr;
+}
+
+/*
+ * This is the receiver interrupt routine for the GDB stub.
+ * All that we need to do is verify that the interrupt happened on the
+ * line we're in charge of.  If this is true, schedule a breakpoint and
+ * return.
+ */
+static irqreturn_t
+kgdb8250_interrupt(int irq, void *dev_id)
+{
+	if (kgdb_ioread(UART_IIR) & UART_IIR_RDI) {
+		/* Throw away the data if another I/O routine is active. */
+		if (kgdb_io_ops.read_char != kgdb_get_debug_char &&
+				(kgdb_ioread(UART_LSR) & UART_LSR_DR))
+			kgdb_ioread(UART_RX);
+		else
+			breakpoint();
+	}
+
+	return IRQ_HANDLED;
+}
+
+/*
+ *  Initializes the UART.
+ *  Returns:
+ *	0 on success, 1 on failure.
+ */
+static int kgdb8250_uart_init(void)
+{
+	unsigned int ier;
+	unsigned int base_baud = current_port->uartclk ?
+		current_port->uartclk / 16 : BASE_BAUD;
+
+	/* test uart existance */
+	if (kgdb_ioread(UART_LSR) == 0xff)
+		return -1;
+
+	/* disable interrupts */
+	kgdb_iowrite(0, UART_IER);
+
+#if defined(CONFIG_ARCH_OMAP1510)
+	/* Workaround to enable 115200 baud on OMAP1510 internal ports */
+	if (cpu_is_omap1510() && is_omap_port((void *)kgdb8250_addr)) {
+		if (kgdb8250_baud == 115200) {
+			base_baud = 1;
+			kgdb8250_baud = 1;
+			kgdb_iowrite(1, UART_OMAP_OSC_12M_SEL);
+		} else
+			kgdb_iowrite(0, UART_OMAP_OSC_12M_SEL);
+	}
+#endif
+	/* set DLAB */
+	kgdb_iowrite(UART_LCR_DLAB, UART_LCR);
+
+	/* set baud */
+	kgdb_iowrite((base_baud / kgdb8250_baud) & 0xff, UART_DLL);
+	kgdb_iowrite((base_baud / kgdb8250_baud) >> 8, UART_DLM);
+
+	/* reset DLAB, set LCR */
+	kgdb_iowrite(UART_LCR_WLEN8, UART_LCR);
+
+	/* set DTR and RTS */
+	kgdb_iowrite(UART_MCR_OUT2 | UART_MCR_DTR | UART_MCR_RTS, UART_MCR);
+
+	/* setup fifo */
+	kgdb_iowrite(UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR
+		| UART_FCR_CLEAR_XMIT | UART_FCR_TRIGGER_8,
+		UART_FCR);
+
+	/* clear pending interrupts */
+	kgdb_ioread(UART_IIR);
+	kgdb_ioread(UART_RX);
+	kgdb_ioread(UART_LSR);
+	kgdb_ioread(UART_MSR);
+
+	/* turn on RX interrupt only */
+	kgdb_iowrite(UART_IER_RDI, UART_IER);
+
+	/*
+	 * Borrowed from the main 8250 driver.
+	 * Try writing and reading the UART_IER_UUE bit (b6).
+	 * If it works, this is probably one of the Xscale platform's
+	 * internal UARTs.
+	 * We're going to explicitly set the UUE bit to 0 before
+	 * trying to write and read a 1 just to make sure it's not
+	 * already a 1 and maybe locked there before we even start start.
+	 */
+	ier = kgdb_ioread(UART_IER);
+	kgdb_iowrite(ier & ~UART_IER_UUE, UART_IER);
+	if (!(kgdb_ioread(UART_IER) & UART_IER_UUE)) {
+		/*
+		 * OK it's in a known zero state, try writing and reading
+		 * without disturbing the current state of the other bits.
+		 */
+		kgdb_iowrite(ier | UART_IER_UUE, UART_IER);
+		if (kgdb_ioread(UART_IER) & UART_IER_UUE)
+			/*
+			 * It's an Xscale.
+			 */
+			ier |= UART_IER_UUE | UART_IER_RTOIE;
+	}
+	kgdb_iowrite(ier, UART_IER);
+	return 0;
+}
+
+/*
+ * Copy the old serial_state table to our uart_port table if we haven't
+ * had values specifically configured in.  We need to make sure this only
+ * happens once.
+ */
+static void __init kgdb8250_copy_rs_table(void)
+{
+#ifdef CONFIG_KGDB_SIMPLE_SERIAL
+	int i;
+
+	if (!should_copy_rs_table)
+		return;
+
+	for (i = 0; i < ARRAY_SIZE(old_rs_table); i++) {
+		kgdb8250_ports[i].iobase = old_rs_table[i].port;
+		kgdb8250_ports[i].irq = irq_canonicalize(old_rs_table[i].irq);
+		kgdb8250_ports[i].uartclk = old_rs_table[i].baud_base * 16;
+		kgdb8250_ports[i].membase = old_rs_table[i].iomem_base;
+		kgdb8250_ports[i].iotype = old_rs_table[i].io_type;
+		kgdb8250_ports[i].regshift = old_rs_table[i].iomem_reg_shift;
+		kgdb8250_ports[i].line = i;
+	}
+
+	should_copy_rs_table = 0;
+#endif
+}
+
+/*
+ * Hookup our IRQ line now that it is safe to do so, after we grab any
+ * memory regions we might need to.  If we haven't been initialized yet,
+ * go ahead and copy the old_rs_table in.
+ */
+static void __init kgdb8250_late_init(void)
+{
+	/* Try and copy the old_rs_table. */
+	kgdb8250_copy_rs_table();
+
+#if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
+	/* Take the port away from the main driver. */
+	serial8250_unregister_by_port(current_port);
+
+	/* Now reinit the port as the above has disabled things. */
+	kgdb8250_uart_init();
+#endif
+	/* We may need to call request_mem_region() first. */
+	if (kgdb8250_needs_request_mem_region)
+		request_mem_region(current_port->mapbase,
+				   8 << current_port->regshift, "kgdb");
+	if (request_irq(current_port->irq, kgdb8250_interrupt, IRQF_SHARED,
+			"GDB-stub", current_port) < 0)
+		printk(KERN_ERR "KGDB failed to request the serial IRQ (%d)\n",
+		       current_port->irq);
+}
+
+static __init int kgdb_init_io(void)
+{
+	/* Give us the basic table of uarts. */
+	kgdb8250_copy_rs_table();
+
+	/* We're either a module and parse a config string, or we have a
+	 * semi-static config. */
+#ifdef CONFIG_KGDB_8250_MODULE
+	if (strlen(config)) {
+		if (kgdb8250_opt(config))
+			return -EINVAL;
+	} else {
+		printk(KERN_ERR "kgdb8250: argument error, usage: "
+		       "kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>\n");
+		return -EINVAL;
+	}
+#elif defined(CONFIG_KGDB_SIMPLE_SERIAL)
+	kgdb8250_baud = CONFIG_KGDB_BAUDRATE;
+
+	/* Setup our pointer to the serial port now. */
+	current_port = &kgdb8250_ports[CONFIG_KGDB_PORT_NUM];
+#else
+	if (kgdb8250_opt(CONFIG_KGDB_8250_CONF_STRING))
+		return -EINVAL;
+#endif
+
+
+	/* Internal driver setup. */
+	switch (current_port->iotype) {
+	case UPIO_MEM:
+		if (current_port->mapbase)
+			kgdb8250_needs_request_mem_region = 1;
+		if (current_port->flags & UPF_IOREMAP) {
+			current_port->membase = ioremap(current_port->mapbase,
+						8 << current_port->regshift);
+			if (!current_port->membase)
+				return -EIO;	/* Failed. */
+		}
+		kgdb8250_addr = current_port->membase;
+		break;
+	case UPIO_PORT:
+	default:
+		kgdb8250_addr = ioport_map(current_port->iobase,
+					   8 << current_port->regshift);
+		if (!kgdb8250_addr)
+			return -EIO;	/* Failed. */
+	}
+
+	if (kgdb8250_uart_init() == -1) {
+		printk(KERN_ERR "kgdb8250: init failed\n");
+		return -EIO;
+	}
+#ifdef CONFIG_KGDB_8250_MODULE
+	/* Attach the kgdb irq. When this is built into the kernel, it
+	 * is called as a part of late_init sequence.
+	 */
+	kgdb8250_late_init();
+	if (kgdb_register_io_module(&local_kgdb_io_ops))
+		return -EINVAL;
+
+	printk(KERN_INFO "kgdb8250: debugging enabled\n");
+#endif				/* CONFIG_KGD_8250_MODULE */
+
+	return 0;
+}
+
+#ifdef CONFIG_KGDB_8250_MODULE
+/* If it is a module the kgdb_io_ops should be a static which
+ * is passed to the KGDB I/O initialization
+ */
+static struct kgdb_io local_kgdb_io_ops = {
+#else				/* ! CONFIG_KGDB_8250_MODULE */
+struct kgdb_io kgdb_io_ops = {
+#endif				/* ! CONFIG_KGD_8250_MODULE */
+	.read_char = kgdb_get_debug_char,
+	.write_char = kgdb_put_debug_char,
+	.init = kgdb_init_io,
+	.late_init = kgdb8250_late_init,
+};
+
+/**
+ * 	kgdb8250_add_port - Define a serial port for use with KGDB
+ * 	@i: The index of the port being added
+ * 	@serial_req: The &struct uart_port describing the port
+ *
+ * 	On platforms where we must register the serial device
+ * 	dynamically, this is the best option if a platform also normally
+ * 	calls early_serial_setup().
+ */
+void kgdb8250_add_port(int i, struct uart_port *serial_req)
+{
+#ifdef CONFIG_KGDB_SIMPLE_SERIAL
+	if (should_copy_rs_table)
+		printk(KERN_ERR "8250_kgdb: warning will over write serial"
+			   " port definitions at kgdb init time\n");
+#endif
+
+	/* Copy the whole thing over. */
+	if (current_port != &kgdb8250_ports[i])
+		memcpy(&kgdb8250_ports[i], serial_req,
+		sizeof(struct uart_port));
+}
+
+/**
+ * 	kgdb8250_add_platform_port - Define a serial port for use with KGDB
+ * 	@i: The index of the port being added
+ * 	@p: The &struct plat_serial8250_port describing the port
+ *
+ * 	On platforms where we must register the serial device
+ * 	dynamically, this is the best option if a platform normally
+ * 	handles uart setup with an array of &struct plat_serial8250_port.
+ */
+void __init kgdb8250_add_platform_port(int i, struct plat_serial8250_port *p)
+{
+	/* Make sure we've got the built-in data before we override. */
+	kgdb8250_copy_rs_table();
+
+	kgdb8250_ports[i].iobase = p->iobase;
+	kgdb8250_ports[i].membase = p->membase;
+	kgdb8250_ports[i].irq = p->irq;
+	kgdb8250_ports[i].uartclk = p->uartclk;
+	kgdb8250_ports[i].regshift = p->regshift;
+	kgdb8250_ports[i].iotype = p->iotype;
+	kgdb8250_ports[i].flags = p->flags;
+	kgdb8250_ports[i].mapbase = p->mapbase;
+}
+
+/*
+ * Syntax for this cmdline option is:
+ * kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>"
+ */
+static int __init kgdb8250_opt(char *str)
+{
+	/* We'll fill out and use the first slot. */
+	current_port = &kgdb8250_ports[0];
+
+	if (!strncmp(str, "io", 2)) {
+		current_port->iotype = UPIO_PORT;
+		str += 2;
+	} else if (!strncmp(str, "mmap", 4)) {
+		current_port->iotype = UPIO_MEM;
+		current_port->flags |= UPF_IOREMAP;
+		str += 4;
+	} else if (!strncmp(str, "mmio", 4)) {
+		current_port->iotype = UPIO_MEM;
+		current_port->flags &= ~UPF_IOREMAP;
+		str += 4;
+	} else
+		goto errout;
+
+	if (*str != ',')
+		goto errout;
+	str++;
+
+	if (current_port->iotype == UPIO_PORT)
+		current_port->iobase = simple_strtoul(str, &str, 16);
+	else {
+		if (current_port->flags & UPF_IOREMAP)
+			current_port->mapbase =
+				(unsigned long) simple_strtoul(str, &str, 16);
+		else
+			current_port->membase =
+				(void *) simple_strtoul(str, &str, 16);
+	}
+
+	if (*str != ',')
+		goto errout;
+	str++;
+
+	kgdb8250_baud = simple_strtoul(str, &str, 10);
+	if (!kgdb8250_baud)
+		goto errout;
+
+	if (*str != ',')
+		goto errout;
+	str++;
+
+	current_port->irq = simple_strtoul(str, &str, 10);
+
+#ifdef CONFIG_KGDB_SIMPLE_SERIAL
+	should_copy_rs_table = 0;
+#endif
+
+	return 0;
+
+errout:
+	printk(KERN_ERR "Invalid syntax for option kgdb8250=\n");
+	return 1;
+}
+
+#ifdef CONFIG_KGDB_8250_MODULE
+static void cleanup_kgdb8250(void)
+{
+	kgdb_unregister_io_module(&local_kgdb_io_ops);
+
+	/* Clean up the irq and memory */
+	free_irq(current_port->irq, current_port);
+
+	if (kgdb8250_needs_request_mem_region)
+		release_mem_region(current_port->mapbase,
+				   8 << current_port->regshift);
+	/* Hook up the serial port back to what it was previously
+	 * hooked up to.
+	 */
+#if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
+	/* Give the port back to the 8250 driver. */
+	serial8250_register_port(current_port);
+#endif
+}
+
+module_init(kgdb_init_io);
+module_exit(cleanup_kgdb8250);
+#else				/* ! CONFIG_KGDB_8250_MODULE */
+early_param("kgdb8250", kgdb8250_opt);
+#endif				/* ! CONFIG_KGDB_8250_MODULE */
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -121,7 +121,7 @@ config SERIAL_8250_CS
 
 config SERIAL_8250_NR_UARTS
 	int "Maximum number of 8250/16550 serial ports"
-	depends on SERIAL_8250
+	depends on SERIAL_8250 || KGDB_8250
 	default "4"
 	help
 	  Set this to the number of serial ports you want the driver
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_SERIAL_UARTLITE) += uartlit
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
+obj-$(CONFIG_KGDB_8250) += 8250_kgdb.o
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/kgdb.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -58,6 +59,12 @@ static struct lock_class_key port_lock_k
 #define uart_console(port)	(0)
 #endif
 
+#ifdef CONFIG_KGDB_CONSOLE
+#define uart_kgdb(port) (port->cons && !strcmp(port->cons->name, "kgdb"))
+#else
+#define uart_kgdb(port) (0)
+#endif
+
 static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
@@ -1675,6 +1682,9 @@ static int uart_line_info(char *buf, str
 			mmio ? (unsigned long long)port->mapbase
 		             : (unsigned long long) port->iobase,
 			port->irq);
+	if (port->iotype == UPIO_MEM)
+		ret += sprintf(buf+ret, " membase 0x%08lX",
+					   (unsigned long) port->membase);
 
 	if (port->type == PORT_UNKNOWN) {
 		strcat(buf, "\n");
@@ -2073,7 +2083,9 @@ uart_report_port(struct uart_driver *drv
 	case UPIO_TSI:
 	case UPIO_DWAPB:
 		snprintf(address, sizeof(address),
-			 "MMIO 0x%llx", (unsigned long long)port->mapbase);
+			 "MMIO 0x%llx mem 0x%p",
+			 (unsigned long long)port->mapbase,
+			 port->membase);
 		break;
 	default:
 		strlcpy(address, "*unknown*", sizeof(address));
@@ -2128,9 +2140,9 @@ uart_configure_port(struct uart_driver *
 
 		/*
 		 * Power down all ports by default, except the
-		 * console if we have one.
+		 * console (real or kgdb) if we have one.
 		 */
-		if (!uart_console(port))
+		if (!uart_console(port) && !uart_kgdb(port))
 			uart_change_pm(state, 3);
 	}
 }
@@ -2321,6 +2333,12 @@ int uart_add_one_port(struct uart_driver
 	 */
 	port->flags &= ~UPF_DEAD;
 
+#if defined(CONFIG_KGDB_8250)
+	/* Add any 8250-like ports we find later. */
+	if (port->type <= PORT_MAX_8250)
+		kgdb8250_add_port(port->line, port);
+#endif
+
  out:
 	mutex_unlock(&state->mutex);
 	mutex_unlock(&port_mutex);
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -57,6 +57,7 @@ struct uart_port;
 
 int serial8250_register_port(struct uart_port *);
 void serial8250_unregister_port(int line);
+void serial8250_unregister_by_port(struct uart_port *port);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
 
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -39,7 +39,7 @@ config KGDB_CONSOLE
 choice
 	prompt "Method for KGDB communication"
 	depends on KGDB
-	default KGDB_ONLY_MODULES
+	default KGDB_8250_NOMODULE
 	help
 	  There are a number of different ways in which you can communicate
 	  with KGDB.  The most common is via serial, with the 8250 driver
@@ -57,11 +57,68 @@ config KGDB_ONLY_MODULES
 	  Use only kernel modules to configure KGDB I/O after the
 	  kernel is booted.
 
+config KGDB_8250_NOMODULE
+	bool "KGDB: On generic serial port (8250)"
+	select KGDB_8250
+	select SERIAL_8250
+	help
+	  Uses generic serial port (8250) to communicate with the host
+	  GDB.  This is independent of the normal (SERIAL_8250) driver
+	  for this chipset.
 endchoice
 
+config KGDB_8250
+	tristate "KGDB: On generic serial port (8250)" if !KGDB_8250_NOMODULE
+	depends on m && KGDB_ONLY_MODULES
+	help
+	  Uses generic serial port (8250) to communicate with the host
+	  GDB.  This is independent of the normal (SERIAL_8250) driver
+	  for this chipset.
+
+config KGDB_SIMPLE_SERIAL
+	bool "Simple selection of KGDB serial port"
+	depends on KGDB_8250_NOMODULE
+	default y
+	help
+	  If you say Y here, you will only have to pick the baud rate
+	  and port number that you wish to use for KGDB.  Note that this
+	  only works on architectures that register known serial ports
+	  early on.  If you say N, you will have to provide, either here
+	  or on the command line, the type (I/O or MMIO), IRQ and
+	  address to use.  If in doubt, say Y.
+
+config KGDB_BAUDRATE
+	int "Debug serial port baud rate"
+	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL)
+	default "115200"
+	help
+	  gdb and the kernel stub need to agree on the baud rate to be
+	  used.  Standard rates from 9600 to 115200 are allowed, and this
+	  may be overridden via the commandline.
+
+config KGDB_PORT_NUM
+	int "Serial port number for KGDB"
+	range 0 1 if KGDB_MPSC
+	range 0 3
+	depends on (KGDB_8250 && KGDB_SIMPLE_SERIAL) || KGDB_MPSC
+	default "1"
+	help
+	  Pick the port number (0 based) for KGDB to use.
+
+config KGDB_8250_CONF_STRING
+	string "Configuration string for KGDB"
+	depends on KGDB_8250_NOMODULE && !KGDB_SIMPLE_SERIAL
+	default "io,2f8,115200,3" if X86
+	help
+	  The format of this string should be <io or mmio>,
+	  <address>,<baud rate>,<irq>.  For example, on an i386 box,
+	  to use the serial port located at 0x2f8, IRQ 3, at 115200 baud
+	  use:  io,2f8,115200,3
+
 config KGDB_ATTACH_WAIT
 	bool "KGDB: Wait for debugger to attach on an unknown exception"
-	default n
+	default y if KGDB_8250_NOMODULE
+	default n if !KGDB_8250_NOMODULE
 	help
 	  If a panic occurs, or any kind of exception, the kgdb will
 	  stop and wait for a debugger to attach.  This sets the

--------------050707050900050809000601--
