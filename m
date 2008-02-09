Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYBINij@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYBINij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:38:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYBINfh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:60471 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757506AbYBINf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:35:28 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-serial@vger.kernel.org,
       Jan Kiszka <jan.kiszka@web.de>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH][7/8] kgdb: exclusive use kgdb8250 uart I/O driver
Date: Sat,  9 Feb 2008 07:35:13 -0600
Message-Id: <1202564114-18587-8-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-7-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-6-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-7-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:58.0634 (UTC) FILETIME=[906E6AA0:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

This patch some small hooks into the normal serial core so that a uart
can be unregistered to be exclusively used for KGDB.  These changes
allow for registering and unregistering a port with a struct
uart_port. From that point on KGDB does raw accesses to the serial
IO ports it has taken over.

CC: linux-serial@vger.kernel.org
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/DocBook/kgdb.tmpl |   44 ++++
 drivers/serial/8250.c           |   30 +++
 drivers/serial/8250_kgdb.c      |  489 +++++++++++++++++++++++++++++++++++++++
 drivers/serial/Kconfig          |    2 +-
 drivers/serial/Makefile         |    1 +
 drivers/serial/serial_core.c    |   18 ++-
 include/linux/serial_8250.h     |    2 +
 lib/Kconfig.kgdb                |   21 ++
 8 files changed, 603 insertions(+), 4 deletions(-)
 create mode 100644 drivers/serial/8250_kgdb.c

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index c423411..111a2a0 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -92,6 +92,50 @@
   <chapter id="BootingTheKernel">
     <title>Booting the kernel</title>
     <para>
+    The Kernel command line option <constant>kgdbwait</constant> makes kgdb
+    wait for gdb connection during booting of a kernel.  If the
+    <symbol>CONFIG_KGDB_8250</symbol> driver is used (or if applicable,
+    another serial driver) this breakpoint will happen very early on, before
+    console output.
+    </para>
+    <para>
+    The serial port configuration must be passed via the
+    option <constant>kgdb8250=&lt;io|mmio&gt;,&lt;address&gt;[/&lt;regshift&gt;],&lt;baud
+    rate&gt;,&lt;irq&gt;</constant>.  The values <constant>io</constant> or
+    <constant>mmio</constant> refer to if the address being passed next needs
+    to be memory mapped (<constant>mmio</constant>) or not.  The
+    <constant>address</constant> must be passed in hex and is the hardware
+    address and will be remapped if passed as <constant>mmio</constant>. An
+    optional <constant>regshift</constant> value can be given to express
+    address spreading of the 8250 registers. <constant>regshift</constant>
+    just as the succeeding <constant>baud rate</constant> and
+    <constant>irq</constant> values are base-10. The supported values for
+    <constant>baud rate</constant> are <constant>9600</constant>,
+    <constant>19200</constant>, <constant>38400</constant>,
+    <constant>57600</constant>, and <constant>115200</constant>.
+    </para>
+    <para>
+    To specify the values of the serial port at boot:
+    </para>
+    <para>
+    <constant>kgdb8250=io,3f8,115200,3</constant>
+    </para>
+    <para>
+    On IA64 this could also be:
+    </para>
+    <para>
+    <constant>kgdb8250=mmio,0xff5e0000,115200,74</constant>
+    </para>
+    <para>
+    If the debugger is not needed early, the alternative configuration format
+    <constant>kgdb8250=ttyS&lt;n&gt;,&lt;baud rate&gt;</constant> can be used.
+    The required parameters are then obtained from the standard 8250 driver.
+    Example:
+    </para>
+    <para>
+    <constant>kgdb8250=ttyS0,115200</constant>
+    </para>
+    <para>
     All drivers can be reconfigured at run time, if
     <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol> are
     enabled, by echo'ing a new config string to
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 77f7a7f..2b37370 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2580,6 +2580,7 @@ int serial8250_find_port(struct uart_port *p)
 	}
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(serial8250_find_port);
 
 #define SERIAL8250_CONSOLE	&serial8250_console
 #else
@@ -2863,6 +2864,35 @@ void serial8250_unregister_port(int line)
 }
 EXPORT_SYMBOL(serial8250_unregister_port);
 
+/**
+ *  serial8250_get_port_def - Get port definition for a specific line
+ *  @port: generic uart_port output for a specific serial line
+ *  @line: specific serial line index
+ *
+ *  Return 0 if the port existed
+ *  Return -errno on failure
+ */
+int serial8250_get_port_def(struct uart_port *port, int line)
+{
+	struct uart_port *port8250 = &serial8250_ports[line].port;
+
+	if (!port8250->iobase && !port8250->membase)
+		return -ENODEV;
+
+	port->iobase   = port8250->iobase;
+	port->membase  = port8250->membase;
+	port->irq      = port8250->irq;
+	port->uartclk  = port8250->uartclk;
+	port->fifosize = port8250->fifosize;
+	port->regshift = port8250->regshift;
+	port->iotype   = port8250->iotype;
+	port->flags    = port8250->flags;
+	port->mapbase  = port8250->mapbase;
+	port->dev      = port8250->dev;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(serial8250_get_port_def);
+
 static int __init serial8250_init(void)
 {
 	int ret, i;
diff --git a/drivers/serial/8250_kgdb.c b/drivers/serial/8250_kgdb.c
new file mode 100644
index 0000000..ef0ebcf
--- /dev/null
+++ b/drivers/serial/8250_kgdb.c
@@ -0,0 +1,489 @@
+/*
+ * 8250 serial I/O driver for KGDB.
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
+ *
+ * Refactoring and cleanup for initial merge:
+ * 2008 (c) Jan Kiszka <jan.kiszka@web.de>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
+ */
+
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/kgdb.h>
+#include <linux/interrupt.h>
+#include <linux/serial_reg.h>
+#include <linux/ioport.h>
+#include <linux/io.h>
+#include <linux/ctype.h>
+#include <asm/serial.h>		/* for BASE_BAUD */
+
+MODULE_DESCRIPTION("KGDB driver for the 8250");
+MODULE_LICENSE("GPL");
+
+#define KGD8250_MAX_CONFIG_STR	64
+static char config[KGD8250_MAX_CONFIG_STR];
+static struct kparam_string kps = {
+	.string = config,
+	.maxlen = KGD8250_MAX_CONFIG_STR,
+};
+
+static int kgdb8250_baud;
+static void *kgdb8250_addr;
+static int kgdb8250_irq = -1;
+static struct uart_port kgdb8250_port;
+
+/* UART port we might have stolen from the 8250 driver */
+static int hijacked_line;
+
+static int late_init_passed;
+static int fully_initialized;
+static int buffered_char = -1;
+
+static struct kgdb_io kgdb8250_io_ops;	/* initialized later */
+
+static int kgdb8250_uart_init(void);
+
+static inline unsigned int kgdb8250_ioread(u8 mask)
+{
+	return ioread8(kgdb8250_addr + (mask << kgdb8250_port.regshift));
+}
+
+static inline void kgdb8250_iowrite(u8 val, u8 mask)
+{
+	iowrite8(val, kgdb8250_addr + (mask << kgdb8250_port.regshift));
+}
+
+/*
+ * Wait until the interface can accept a char, then write it.
+ */
+static void kgdb8250_put_debug_char(u8 chr)
+{
+	while (!(kgdb8250_ioread(UART_LSR) & UART_LSR_THRE))
+		cpu_relax();
+
+	kgdb8250_iowrite(chr, UART_TX);
+}
+
+/*
+ * Get a byte from the hardware data buffer and return it.
+ */
+static int kgdb8250_get_debug_char(void)
+{
+	unsigned int lsr;
+
+	while (1) {
+		/* Did the interrupt handler catch something before us? */
+		if (buffered_char >= 0)
+			return xchg(&buffered_char, -1);
+
+		lsr = kgdb8250_ioread(UART_LSR);
+		if (lsr & UART_LSR_DR)
+			return kgdb8250_ioread(UART_RX);
+
+		/*
+		 * If we have a framing error assume somebody messed with
+		 * our uart.  Reprogram it and send '-' both ways...
+		 */
+		if (lsr & (UART_LSR_PE | UART_LSR_FE)) {
+			kgdb8250_uart_init();
+			kgdb8250_put_debug_char('-');
+			return '-';
+		}
+
+		cpu_relax();
+	}
+}
+
+/*
+ * This is the receiver interrupt routine for the GDB stub.
+ * All that we need to do is verify that the interrupt happened on the
+ * line we're in charge of.  If this is true, schedule a breakpoint and
+ * return.
+ */
+static irqreturn_t kgdb8250_interrupt(int irq, void *dev_id)
+{
+	unsigned int iir = kgdb8250_ioread(UART_IIR);
+	char c;
+
+	if (iir & UART_IIR_NO_INT)
+		return IRQ_NONE;
+
+	if ((iir & UART_IIR_ID) == UART_IIR_RDI) {
+		c = kgdb8250_ioread(UART_RX);
+		if (c != 0x03)
+			buffered_char = c;
+		if (c == 0x03 || !kgdb_connected)
+			breakpoint();
+	}
+	return IRQ_HANDLED;
+}
+
+/*
+ *  Initializes the UART.
+ *  Returns:
+ *	0 on success, -errno on failure.
+ */
+static int kgdb8250_uart_init(void)
+{
+	unsigned int ier;
+	unsigned int base_baud = kgdb8250_port.uartclk ?
+		kgdb8250_port.uartclk / 16 : BASE_BAUD;
+
+	/* Test UART existance. */
+	if (kgdb8250_ioread(UART_LSR) == 0xff)
+		return -EIO;
+
+	/* Disable interrupts. */
+	kgdb8250_iowrite(0, UART_IER);
+
+#ifdef CONFIG_ARCH_OMAP1510
+	/* Workaround to enable 115200 baud on OMAP1510 internal ports */
+	if (cpu_is_omap1510() && is_omap_port((void *)kgdb8250_addr)) {
+		if (kgdb8250_baud == 115200) {
+			base_baud = 1;
+			kgdb8250_baud = 1;
+			kgdb8250_iowrite(1, UART_OMAP_OSC_12M_SEL);
+		} else
+			kgdb8250_iowrite(0, UART_OMAP_OSC_12M_SEL);
+	}
+#endif
+
+	/* Line settings 8n1, no FIFO, DTR+RTS on. */
+	kgdb8250_iowrite(UART_LCR_WLEN8, UART_LCR);
+	kgdb8250_iowrite(0, UART_FCR);
+	kgdb8250_iowrite(UART_MCR_OUT2 | UART_MCR_DTR |
+			 UART_MCR_RTS, UART_MCR);
+
+	/* Set baud rate. */
+	kgdb8250_iowrite(UART_LCR_WLEN8 | UART_LCR_DLAB, UART_LCR);
+	kgdb8250_iowrite((base_baud / kgdb8250_baud) & 0xff, UART_DLL);
+	kgdb8250_iowrite((base_baud / kgdb8250_baud) >> 8, UART_DLM);
+	kgdb8250_iowrite(UART_LCR_WLEN8, UART_LCR);
+
+	/* Clear pending interrupts. */
+	(void) kgdb8250_ioread(UART_IIR);
+	(void) kgdb8250_ioread(UART_RX);
+	(void) kgdb8250_ioread(UART_LSR);
+	(void) kgdb8250_ioread(UART_MSR);
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
+	ier = kgdb8250_ioread(UART_IER);
+	kgdb8250_iowrite(ier & ~UART_IER_UUE, UART_IER);
+	if (!(kgdb8250_ioread(UART_IER) & UART_IER_UUE)) {
+		/*
+		 * OK it's in a known zero state, try writing and reading
+		 * without disturbing the current state of the other bits.
+		 */
+		kgdb8250_iowrite(ier | UART_IER_UUE, UART_IER);
+		if (kgdb8250_ioread(UART_IER) & UART_IER_UUE)
+			/* It's an Xscale. */
+			ier |= UART_IER_UUE | UART_IER_RTOIE;
+	}
+	kgdb8250_iowrite(ier, UART_IER);
+
+	return 0;
+}
+
+/*
+ * Syntax for this cmdline option is:
+ *   <io|mmio>,<address>[/<regshift>],<baud rate>,<irq> or
+ *   ttyS<n>,<baud rate>
+ */
+static int kgdb8250_parse_config(char *str)
+{
+	int line, err;
+
+	/* Save the option string in case we fail and can retry later. */
+	strncpy(config, str, KGD8250_MAX_CONFIG_STR-1);
+
+	/* Empty config or leading white space (like LF) means "disabled" */
+	if (!strlen(config) || isspace(config[0]))
+		return 0;
+
+	if (!strncmp(str, "io", 2)) {
+		kgdb8250_port.iotype = UPIO_PORT;
+		str += 2;
+	} else if (!strncmp(str, "mmio", 4)) {
+		kgdb8250_port.iotype = UPIO_MEM;
+		kgdb8250_port.flags = UPF_IOREMAP;
+		str += 4;
+	} else if (!strncmp(str, "ttyS", 4)) {
+		str += 4;
+		if (*str < '0' || *str > '9')
+			return -EINVAL;
+		line = simple_strtoul(str, &str, 10);
+		if (line >= CONFIG_SERIAL_8250_NR_UARTS)
+			return -EINVAL;
+
+		err = serial8250_get_port_def(&kgdb8250_port, line);
+		if (err) {
+			if (late_init_passed)
+				return err;
+			printk(KERN_WARNING "kgdb8250: ttyS%d init delayed, "
+			       "use io/mmio syntax for early init.\n",
+			       line);
+			return 0;
+		}
+
+		if (*str != ',')
+			return -EINVAL;
+		str++;
+
+		kgdb8250_baud = simple_strtoul(str, &str, 10);
+		if (!kgdb8250_baud)
+			return -EINVAL;
+
+		if (*str == ',')
+			return -EINVAL;
+
+		goto finish;
+	} else
+		return -EINVAL;
+
+	if (*str != ',')
+		return -EINVAL;
+	str++;
+
+	if (kgdb8250_port.iotype == UPIO_PORT)
+		kgdb8250_port.iobase = simple_strtoul(str, &str, 16);
+	else
+		kgdb8250_port.mapbase =
+			(unsigned long)simple_strtoul(str, &str, 16);
+
+	if (*str == '/') {
+		str++;
+		kgdb8250_port.regshift = simple_strtoul(str, &str, 10);
+	}
+
+	if (*str != ',')
+		return -EINVAL;
+	str++;
+
+	kgdb8250_baud = simple_strtoul(str, &str, 10);
+	if (!kgdb8250_baud)
+		return -EINVAL;
+
+	if (*str != ',')
+		return -EINVAL;
+	str++;
+
+	kgdb8250_port.irq = simple_strtoul(str, &str, 10);
+
+finish:
+	err = kgdb_register_io_module(&kgdb8250_io_ops);
+	if (err)
+		kgdb8250_addr = 0;
+
+	return err;
+}
+
+static int kgdb8250_early_init(void)
+{
+	/* Internal driver setup. */
+	switch (kgdb8250_port.iotype) {
+	case UPIO_MEM:
+		if (kgdb8250_port.flags & UPF_IOREMAP)
+			kgdb8250_port.membase = ioremap(kgdb8250_port.mapbase,
+						8 << kgdb8250_port.regshift);
+		kgdb8250_addr = kgdb8250_port.membase;
+		break;
+	case UPIO_PORT:
+	default:
+		kgdb8250_addr = ioport_map(kgdb8250_port.iobase,
+					   8 << kgdb8250_port.regshift);
+	}
+	if (!kgdb8250_addr)
+		return -EIO;
+
+	if (kgdb8250_uart_init() < 0) {
+		printk(KERN_ERR "kgdb8250: UART initialization failed\n");
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static int kgdb8250_late_init(void)
+{
+	int err;
+
+	if (fully_initialized)
+		return 0;
+
+	late_init_passed = 1;
+
+	/*
+	 * If we didn't initialize yet or if an earlier attempt failed,
+	 * evaluate the configuration and register with KGDB.
+	 */
+	if (!kgdb8250_addr) {
+		err = kgdb8250_parse_config(config);
+		if (err || !kgdb8250_addr)
+			return err;
+	}
+
+	/* Take the port away from the main driver. */
+	hijacked_line = serial8250_find_port(&kgdb8250_port);
+	if (hijacked_line >= 0)
+		serial8250_unregister_port(hijacked_line);
+
+	/* Now reinit the port as the above has disabled things. */
+	kgdb8250_uart_init();
+
+	/* Request memory/io regions that we use. */
+	if (kgdb8250_port.iotype == UPIO_MEM) {
+		if (!request_mem_region(kgdb8250_port.mapbase,
+					8 << kgdb8250_port.regshift, "kgdb"))
+			goto rollback;
+	} else {
+		if (!request_region(kgdb8250_port.iobase,
+				    8 << kgdb8250_port.regshift, "kgdb"))
+			goto rollback;
+	}
+
+	if (request_irq(kgdb8250_port.irq, kgdb8250_interrupt, IRQF_SHARED,
+			"kgdb", &kgdb8250_port) == 0) {
+		/* Turn on RX interrupt only. */
+		kgdb8250_iowrite(UART_IER_RDI, UART_IER);
+
+		kgdb8250_irq = kgdb8250_port.irq;
+	} else {
+		/*
+		 * The IRQ line is not mandatory for KGDB to provide at least
+		 * basic services. So report the error and continue.
+		 */
+		printk(KERN_ERR "kgdb8250: failed to request the IRQ (%d)\n",
+		       kgdb8250_irq);
+		kgdb8250_irq = -1;
+	}
+
+	fully_initialized = 1;
+	return 0;
+
+rollback:
+	if (hijacked_line >= 0)
+		serial8250_register_port(&kgdb8250_port);
+
+	printk(KERN_CRIT "kgdb: Unable to reserve mandatory hardware "
+			 "resources.\n");
+	return -EBUSY;
+}
+
+static void kgdb8250_cleanup(void)
+{
+	void *ioaddr = kgdb8250_addr;
+
+	if (!kgdb8250_addr)
+		return;
+
+	/* Disable and unregister interrupt. */
+	kgdb8250_iowrite(0, UART_IER);
+	(void) kgdb8250_ioread(UART_RX);
+
+	if (kgdb8250_irq >= 0)
+		free_irq(kgdb8250_irq, &kgdb8250_port);
+
+	/* Deregister from KGDB core. */
+	kgdb_unregister_io_module(&kgdb8250_io_ops);
+	kgdb8250_addr = 0;
+
+	if (!fully_initialized)
+		return;
+
+	fully_initialized = 0;
+
+	if (kgdb8250_port.iotype == UPIO_MEM) {
+		if (kgdb8250_port.flags & UPF_IOREMAP)
+			iounmap(kgdb8250_port.membase);
+		release_mem_region(kgdb8250_port.mapbase,
+				   8 << kgdb8250_port.regshift);
+	} else {
+		ioport_unmap(ioaddr);
+		release_region(kgdb8250_port.iobase,
+			       8 << kgdb8250_port.regshift);
+	}
+
+	/* Give the port back to the 8250 driver. */
+	if (hijacked_line >= 0)
+		serial8250_register_port(&kgdb8250_port);
+}
+
+static int kgdb8250_set_config(const char *kmessage, struct kernel_param *kp)
+{
+	int err;
+
+	if (strlen(kmessage) >= KGD8250_MAX_CONFIG_STR) {
+		printk(KERN_ERR "%s: config string too long.\n", kp->name);
+		return -ENOSPC;
+	}
+
+	if (kgdb_connected) {
+		printk(KERN_ERR "kgd8250: Cannot reconfigure while KGDB is "
+				"connected.\n");
+		return -EBUSY;
+	}
+
+	if (kgdb8250_addr)
+		kgdb8250_cleanup();
+
+	err = kgdb8250_parse_config((char *)kmessage);
+
+	if (err || !late_init_passed)
+		return err;
+
+	/* Call the botton-half initialization as we are re-configuring. */
+	return kgdb8250_late_init();
+}
+
+static void kgdb8250_pre_exception_handler(void)
+{
+	if (!kgdb_connected)
+		try_module_get(THIS_MODULE);
+}
+
+static void kgdb8250_post_exception_handler(void)
+{
+	if (!kgdb_connected)
+		module_put(THIS_MODULE);
+}
+
+static struct kgdb_io kgdb8250_io_ops = {
+	.name = "kgdb8250",
+	.read_char = kgdb8250_get_debug_char,
+	.write_char = kgdb8250_put_debug_char,
+	.init = kgdb8250_early_init,
+	.pre_exception = kgdb8250_pre_exception_handler,
+	.post_exception = kgdb8250_post_exception_handler,
+};
+
+module_init(kgdb8250_late_init);
+module_exit(kgdb8250_cleanup);
+
+module_param_call(kgdb8250, kgdb8250_set_config, param_get_string, &kps, 0644);
+MODULE_PARM_DESC(kgdb8250, "ttyS<n>,<baud rate>");
+
+#ifdef CONFIG_KGDB_8250
+early_param("kgdb8250", kgdb8250_parse_config);
+#endif
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index b82595c..7ef9145 100644
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
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 640cfe4..6ee1b36 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -66,4 +66,5 @@ obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
+obj-$(CONFIG_KGDB_8250) += 8250_kgdb.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 0f5a179..d333fc4 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/kgdb.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -58,6 +59,12 @@ static struct lock_class_key port_lock_key;
 #define uart_console(port)	(0)
 #endif
 
+#ifdef CONFIG_KGDB_CONSOLE
+#define uart_kgdb(port) (port->cons && !strcmp(port->cons->name, "kgdb"))
+#else
+#define uart_kgdb(port) (0)
+#endif
+
 static void uart_change_speed(struct uart_state *state,
 					struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
@@ -1678,6 +1685,9 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 			mmio ? (unsigned long long)port->mapbase
 			     : (unsigned long long) port->iobase,
 			port->irq);
+	if (port->iotype == UPIO_MEM)
+		ret += sprintf(buf+ret, " membase 0x%08lX",
+					   (unsigned long) port->membase);
 
 	if (port->type == PORT_UNKNOWN) {
 		strcat(buf, "\n");
@@ -2111,7 +2121,9 @@ uart_report_port(struct uart_driver *drv, struct uart_port *port)
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
@@ -2175,9 +2187,9 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 
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
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 00b65c0..fc4bac7 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -58,8 +58,10 @@ struct uart_port;
 
 int serial8250_register_port(struct uart_port *);
 void serial8250_unregister_port(int line);
+void serial8250_unregister_by_port(struct uart_port *port);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
+int serial8250_get_port_def(struct uart_port *port, int line);
 
 extern int early_serial_setup(struct uart_port *port);
 
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index e6fb7e3..3d5c2f8 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -30,3 +30,24 @@ config KGDB_CONSOLE
 
 comment "KGDB I/O drivers"
 	depends on KGDB
+
+config KGDB_8250
+	tristate "8250/16550 and compatible serial support"
+	depends on KGDB
+	select SERIAL_8250
+	default y
+	help
+	  Uses a 8250/16550 compatible serial ports to communicate with the
+	  host GDB.  This is independent of the normal driver (SERIAL_8250)
+	  for this chipset.  The port is configured via kgdb8250=<config>,
+	  passed as kernel or module parameter, respectively.  The
+	  configuration comes in two flavors:
+
+	  <io|mmio>,<address>[/<regshift>],<baud rate>,<irq>
+	    or
+	  ttyS<n>,<baud rate>
+
+	  When built into the kernel, this driver allows debugging of
+	  the early boot process.  Note that, as long as the debugger is
+	  attached via this driver,  the configured serial port cannot be
+	  used by the standard 8250 driver or serial earlyprintk/earlycon.
-- 
1.5.4

