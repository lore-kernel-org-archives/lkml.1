Return-Path: <linux-kernel-owner+w=401wt.eu-S1763325AbYBEXe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763325AbYBEXe2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 18:34:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760356AbYBEXeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 18:34:20 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:43302 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758824AbYBEXeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 18:34:18 -0500
Message-ID: <47A8F275.9090901@web.de>
Date: Wed, 06 Feb 2008 00:34:13 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>, Ingo Molnar <mingo@elte.hu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 1/3] KGDB: Major refactoring
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19j1EMb5mImyrOvARroRDNbPuBV42tm4RlHmsqO
	bNo5nSuwQ4q07zjoE+2LhRPNsCfy0Rn+rpWIYiv/I8dQ9BZHbd
	ZAwsnDb9Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As most changes are tightly coupled, this refactoring patch for
KGDB_8250 as well as the core and the new KGDBOC driver comes as a
single chunk. The changes are:
 - Reorganized configuration: I/O drivers can be independently
   configured as module or built-in
 - Dynamic reconfiguration for KGDB_8250 (just like for KGDBOC)
 - Reworked KGDB_8250 configuration string format
 - attachwait removed, arming the debugger via assigning an I/O driver
   implies "attachwait"
 - Cleaned up I/O driver managment of the core
 - Matured the various boot-up, configure, unconfigure code paths for
   both I/O drivers
 - IRQ vs. KGDB_CONSOLE-output SMP race fixed for KGDB_8250
 - Reduced and cleaned up hooks into serial_core/8250
 - Kconfig cleanups

What we no longer have:
 - Simple serial configuration for _early_ debugging, use the io/mem
   format instead or wait until the debugger is able to resolve "ttySx"
   during late-init

To-do:
 - KGDBOC does not yet cleanly interacts with the TTY subsystem to
   attach to some console

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 drivers/serial/8250.c        |   56 +--
 drivers/serial/8250_kgdb.c   |  731 +++++++++++++++++++------------------------
 drivers/serial/Kconfig       |    3 
 drivers/serial/kgdboc.c      |  118 ++----
 drivers/serial/serial_core.c |    6 
 include/linux/kgdb.h         |   20 -
 kernel/kgdb.c                |  373 +++++----------------
 lib/Kconfig.kgdb             |  153 +--------
 8 files changed, 520 insertions(+), 940 deletions(-)

Index: b/drivers/serial/8250_kgdb.c
===================================================================
--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -1,5 +1,5 @@
 /*
- * 8250 interface for kgdb.
+ * 8250 serial I/O driver for KGDB.
  *
  * This is a merging of many different drivers, and all of the people have
  * had an impact in some form or another:
@@ -12,143 +12,100 @@
  * Robert Walsh <rjwalsh@durables.org>, wangdi <wangdi@clusterfs.com>,
  * San Mehat, Tom Rini <trini@mvista.com>,
  * Jason Wessel <jason.wessel@windriver.com>
+ *
+ * Refactoring and cleanup for initial merge:
+ * 2008 (c) Jan Kiszka <jan.kiszka@web.de>
+ *
+ * This file is licensed under the terms of the GNU General Public License
+ * version 2. This program is licensed "as is" without any warranty of any
+ * kind, whether express or implied.
  */
 
 #include <linux/kernel.h>
 #include <linux/init.h>
 #include <linux/kgdb.h>
 #include <linux/interrupt.h>
-#include <linux/tty.h>
-#include <linux/serial.h>
 #include <linux/serial_reg.h>
-#include <linux/serialP.h>
 #include <linux/ioport.h>
 #include <linux/io.h>
-#include <asm/serial.h>		/* For BASE_BAUD and SERIAL_PORT_DFNS */
-
-#include "8250.h"
-
-#define GDB_BUF_SIZE	512	/* power of 2, please */
+#include <linux/ctype.h>
+#include <asm/serial.h>		/* for BASE_BAUD */
 
 MODULE_DESCRIPTION("KGDB driver for the 8250");
 MODULE_LICENSE("GPL");
-/* These will conflict with early_param otherwise. */
-#ifdef CONFIG_KGDB_8250_MODULE
-static char config[256];
-module_param_string(kgdb8250, config, 256, 0);
-MODULE_PARM_DESC(kgdb8250,
-		 " kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>\n");
-static struct kgdb_io local_kgdb_io_ops;
-#endif				/* CONFIG_KGDB_8250_MODULE */
-
-#ifdef CONFIG_KGDB_BAUDRATE
-static int kgdb8250_baud = CONFIG_KGDB_BAUDRATE;
-#else
-static int kgdb8250_baud;
-#endif
-#ifdef CONFIG_KGDB_PORT_NUM
-static int kgdb8250_line = CONFIG_KGDB_PORT_NUM;
-#else
-static int kgdb8250_line = -1;
-#endif
-
-/* Flag for if we need to call request_mem_region */
-static int kgdb8250_needs_request_mem_region;
 
-static char kgdb8250_buf[GDB_BUF_SIZE];
-static atomic_t kgdb8250_buf_in_cnt;
-static int kgdb8250_buf_out_inx;
-
-/* Old-style serial definitions, if existant, and a counter. */
-#ifdef CONFIG_KGDB_SIMPLE_SERIAL
-static int __initdata should_copy_rs_table = 1;
-static struct serial_state old_rs_table[] __initdata = {
-#ifdef SERIAL_PORT_DFNS
-	SERIAL_PORT_DFNS
-#endif
+#define KGD8250_MAX_CONFIG_STR	64
+static char config[KGD8250_MAX_CONFIG_STR];
+static struct kparam_string kps = {
+	.string = config,
+	.maxlen = KGD8250_MAX_CONFIG_STR,
 };
-#endif
 
-/* Our internal table of UARTS. */
-#define UART_NR	CONFIG_SERIAL_8250_NR_UARTS
-static struct uart_port kgdb8250_ports[UART_NR];
+static int kgdb8250_baud;
+static void *kgdb8250_addr;
+static int kgdb8250_irq = -1;
+static struct uart_port kgdb8250_port;
 
-static struct uart_port *current_port;
+/* UART port we might have stolen from the 8250 driver */
+static int hijacked_line;
 
-/* Base of the UART. */
-static void *kgdb8250_addr;
+static int late_init_passed;
+static int fully_initialized;
+static int buffered_char = -1;
+
+static struct kgdb_io kgdb8250_io_ops;	/* initialized later */
 
-/* Forward declarations. */
 static int kgdb8250_uart_init(void);
-static int __init kgdb_init_io(void);
-static int __init kgdb8250_opt(char *str);
 
-/* These are much shorter calls to ioread8/iowrite8 that take into
- * account our shifts, etc. */
-static inline unsigned int kgdb_ioread(u8 mask)
+static inline unsigned int kgdb8250_ioread(u8 mask)
 {
-	return ioread8(kgdb8250_addr + (mask << current_port->regshift));
+	return ioread8(kgdb8250_addr + (mask << kgdb8250_port.regshift));
 }
 
-static inline void kgdb_iowrite(u8 val, u8 mask)
+static inline void kgdb8250_iowrite(u8 val, u8 mask)
 {
-	iowrite8(val, kgdb8250_addr + (mask << current_port->regshift));
+	iowrite8(val, kgdb8250_addr + (mask << kgdb8250_port.regshift));
 }
 
 /*
  * Wait until the interface can accept a char, then write it.
  */
-static void kgdb_put_debug_char(u8 chr)
+static void kgdb8250_put_debug_char(u8 chr)
 {
-	while (!(kgdb_ioread(UART_LSR) & UART_LSR_THRE)) ;
+	while (!(kgdb8250_ioread(UART_LSR) & UART_LSR_THRE))
+		cpu_relax();
 
-	kgdb_iowrite(chr, UART_TX);
+	kgdb8250_iowrite(chr, UART_TX);
 }
 
 /*
- * Get a byte from the hardware data buffer and return it
+ * Get a byte from the hardware data buffer and return it.
  */
-static int read_data_bfr(void)
+static int kgdb8250_get_debug_char(void)
 {
-	char it = kgdb_ioread(UART_LSR);
+	unsigned int lsr;
 
-	if (it & UART_LSR_DR)
-		return kgdb_ioread(UART_RX);
+	while (1) {
+		/* Did the interrupt handler catch something before us? */
+		if (buffered_char >= 0)
+			return xchg(&buffered_char, -1);
 
-	/*
-	 * If we have a framing error assume somebody messed with
-	 * our uart.  Reprogram it and send '-' both ways...
-	 */
-	if (it & 0xc) {
-		kgdb8250_uart_init();
-		kgdb_put_debug_char('-');
-		return '-';
-	}
+		lsr = kgdb8250_ioread(UART_LSR);
+		if (lsr & UART_LSR_DR)
+			return kgdb8250_ioread(UART_RX);
 
-	return -1;
-}
-
-/*
- * Get a char if available, return -1 if nothing available.
- * Empty the receive buffer first, then look at the interface hardware.
- */
-static int kgdb_get_debug_char(void)
-{
-	int retchr;
+		/*
+		 * If we have a framing error assume somebody messed with
+		 * our uart.  Reprogram it and send '-' both ways...
+		 */
+		if (lsr & (UART_LSR_PE | UART_LSR_FE)) {
+			kgdb8250_uart_init();
+			kgdb8250_put_debug_char('-');
+			return '-';
+		}
 
-	/* intr routine has q'd chars */
-	if (atomic_read(&kgdb8250_buf_in_cnt) != 0) {
-		retchr = kgdb8250_buf[kgdb8250_buf_out_inx++];
-		kgdb8250_buf_out_inx &= (GDB_BUF_SIZE - 1);
-		atomic_dec(&kgdb8250_buf_in_cnt);
-		return retchr;
+		cpu_relax();
 	}
-
-	do {
-		retchr = read_data_bfr();
-	} while (retchr < 0);
-
-	return retchr;
 }
 
 /*
@@ -157,77 +114,71 @@ static int kgdb_get_debug_char(void)
  * line we're in charge of.  If this is true, schedule a breakpoint and
  * return.
  */
-static irqreturn_t
-kgdb8250_interrupt(int irq, void *dev_id)
+static irqreturn_t kgdb8250_interrupt(int irq, void *dev_id)
 {
-	if (!(kgdb_ioread(UART_IIR) & UART_IIR_RDI))
-		return IRQ_NONE;
+	unsigned int iir = kgdb8250_ioread(UART_IIR);
+	char c;
 
-	/* Throw away the data if another I/O routine is active. */
-	if (kgdb_io_ops.read_char != kgdb_get_debug_char &&
-	    (kgdb_ioread(UART_LSR) & UART_LSR_DR))
-		kgdb_ioread(UART_RX);
-	else
-		breakpoint();
+	if (iir & UART_IIR_NO_INT)
+		return IRQ_NONE;
 
+	if ((iir & UART_IIR_ID) == UART_IIR_RDI) {
+		c = kgdb8250_ioread(UART_RX);
+		if (c == 0x03)
+			breakpoint();
+		else
+			buffered_char = c;
+	}
 	return IRQ_HANDLED;
 }
 
 /*
  *  Initializes the UART.
  *  Returns:
- *	0 on success, 1 on failure.
+ *	0 on success, -errno on failure.
  */
 static int kgdb8250_uart_init(void)
 {
 	unsigned int ier;
-	unsigned int base_baud = current_port->uartclk ?
-		current_port->uartclk / 16 : BASE_BAUD;
+	unsigned int base_baud = kgdb8250_port.uartclk ?
+		kgdb8250_port.uartclk / 16 : BASE_BAUD;
 
-	/* test uart existance */
-	if (kgdb_ioread(UART_LSR) == 0xff)
-		return -1;
+	/* Test UART existance. */
+	if (kgdb8250_ioread(UART_LSR) == 0xff)
+		return -EIO;
 
-	/* disable interrupts */
-	kgdb_iowrite(0, UART_IER);
+	/* Disable interrupts. */
+	kgdb8250_iowrite(0, UART_IER);
 
-#if defined(CONFIG_ARCH_OMAP1510)
+#ifdef CONFIG_ARCH_OMAP1510
 	/* Workaround to enable 115200 baud on OMAP1510 internal ports */
 	if (cpu_is_omap1510() && is_omap_port((void *)kgdb8250_addr)) {
 		if (kgdb8250_baud == 115200) {
 			base_baud = 1;
 			kgdb8250_baud = 1;
-			kgdb_iowrite(1, UART_OMAP_OSC_12M_SEL);
+			kgdb8250_iowrite(1, UART_OMAP_OSC_12M_SEL);
 		} else
-			kgdb_iowrite(0, UART_OMAP_OSC_12M_SEL);
+			kgdb8250_iowrite(0, UART_OMAP_OSC_12M_SEL);
 	}
 #endif
-	/* set DLAB */
-	kgdb_iowrite(UART_LCR_DLAB, UART_LCR);
 
-	/* set baud */
-	kgdb_iowrite((base_baud / kgdb8250_baud) & 0xff, UART_DLL);
-	kgdb_iowrite((base_baud / kgdb8250_baud) >> 8, UART_DLM);
-
-	/* reset DLAB, set LCR */
-	kgdb_iowrite(UART_LCR_WLEN8, UART_LCR);
-
-	/* set DTR and RTS */
-	kgdb_iowrite(UART_MCR_OUT2 | UART_MCR_DTR | UART_MCR_RTS, UART_MCR);
-
-	/* setup fifo */
-	kgdb_iowrite(UART_FCR_ENABLE_FIFO | UART_FCR_CLEAR_RCVR
-		| UART_FCR_CLEAR_XMIT | UART_FCR_TRIGGER_8,
-		UART_FCR);
-
-	/* clear pending interrupts */
-	kgdb_ioread(UART_IIR);
-	kgdb_ioread(UART_RX);
-	kgdb_ioread(UART_LSR);
-	kgdb_ioread(UART_MSR);
-
-	/* turn on RX interrupt only */
-	kgdb_iowrite(UART_IER_RDI, UART_IER);
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
 
 	/*
 	 * Borrowed from the main 8250 driver.
@@ -238,344 +189,308 @@ static int kgdb8250_uart_init(void)
 	 * trying to write and read a 1 just to make sure it's not
 	 * already a 1 and maybe locked there before we even start start.
 	 */
-	ier = kgdb_ioread(UART_IER);
-	kgdb_iowrite(ier & ~UART_IER_UUE, UART_IER);
-	if (!(kgdb_ioread(UART_IER) & UART_IER_UUE)) {
+	ier = kgdb8250_ioread(UART_IER);
+	kgdb8250_iowrite(ier & ~UART_IER_UUE, UART_IER);
+	if (!(kgdb8250_ioread(UART_IER) & UART_IER_UUE)) {
 		/*
 		 * OK it's in a known zero state, try writing and reading
 		 * without disturbing the current state of the other bits.
 		 */
-		kgdb_iowrite(ier | UART_IER_UUE, UART_IER);
-		if (kgdb_ioread(UART_IER) & UART_IER_UUE)
-			/*
-			 * It's an Xscale.
-			 */
+		kgdb8250_iowrite(ier | UART_IER_UUE, UART_IER);
+		if (kgdb8250_ioread(UART_IER) & UART_IER_UUE)
+			/* It's an Xscale. */
 			ier |= UART_IER_UUE | UART_IER_RTOIE;
 	}
-	kgdb_iowrite(ier, UART_IER);
+	kgdb8250_iowrite(ier, UART_IER);
+
 	return 0;
 }
 
 /*
- * Copy the old serial_state table to our uart_port table if we haven't
- * had values specifically configured in.  We need to make sure this only
- * happens once.
+ * Syntax for this cmdline option is:
+ *   <io|mmio|mmap>,<address>[/<regshift>],<baud rate>,<irq> or
+ *   ttyS<n>,<baud rate>
  */
-static void __init kgdb8250_copy_rs_table(void)
+static int kgdb8250_parse_config(char *str)
 {
-#ifdef CONFIG_KGDB_SIMPLE_SERIAL
-	int i;
+	int line, err;
 
-	if (!should_copy_rs_table)
-		return;
+	/* Save the option string in case we fail and can retry later. */
+	strncpy(config, str, KGD8250_MAX_CONFIG_STR-1);
 
-	for (i = 0; i < ARRAY_SIZE(old_rs_table) && i < UART_NR; i++) {
-		if (kgdb8250_ports[i].iobase || kgdb8250_ports[i].irq ||
-			kgdb8250_ports[i].membase)
-			continue;
-		kgdb8250_ports[i].iobase = old_rs_table[i].port;
-		kgdb8250_ports[i].irq = irq_canonicalize(old_rs_table[i].irq);
-		kgdb8250_ports[i].uartclk = old_rs_table[i].baud_base * 16;
-		kgdb8250_ports[i].membase = old_rs_table[i].iomem_base;
-		kgdb8250_ports[i].iotype = old_rs_table[i].io_type;
-		kgdb8250_ports[i].regshift = old_rs_table[i].iomem_reg_shift;
-		kgdb8250_ports[i].line = i;
-	}
+	/* Empty config or leading white space (like LF) means "disabled" */
+	if (!strlen(config) || isspace(config[0]))
+		return 0;
 
-	should_copy_rs_table = 0;
-#endif
-}
+	if (!strncmp(str, "io", 2)) {
+		kgdb8250_port.iotype = UPIO_PORT;
+		str += 2;
+	} else if (!strncmp(str, "mmap", 4)) {
+		kgdb8250_port.iotype = UPIO_MEM;
+		kgdb8250_port.flags |= UPF_IOREMAP;
+		str += 4;
+	} else if (!strncmp(str, "mmio", 4)) {
+		kgdb8250_port.iotype = UPIO_MEM;
+		kgdb8250_port.flags &= ~UPF_IOREMAP;
+		str += 4;
+	} else if (!strncmp(str, "ttyS", 4)) {
+		str += 4;
+		if (*str < '0' || *str > '9')
+			return -EINVAL;
+		line = simple_strtoul(str, &str, 10);
+		if (line >= CONFIG_SERIAL_8250_NR_UARTS)
+			return -EINVAL;
 
-/*
- * Hookup our IRQ line now that it is safe to do so, after we grab any
- * memory regions we might need to.  If we haven't been initialized yet,
- * go ahead and copy the old_rs_table in.
- */
-static void __init kgdb8250_late_init(void)
-{
-	/* Setup the KGDB uart table if not already initialized */
-	kgdb8250_copy_rs_table();
+		err = serial8250_get_port_def(&kgdb8250_port, line);
+		if (err) {
+			if (late_init_passed)
+				return err;
+			printk(KERN_WARNING "kgdb8250: ttyS%d init delayed, "
+			       "use io|mmio|mmap syntax for early init.\n",
+			       line);
+			return 0;
+		}
 
-#if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
-	/* Take the port away from the main driver. */
-	serial8250_unregister_by_port(current_port);
+		if (*str != ',')
+			return -EINVAL;
+		str++;
 
-	/* Now reinit the port as the above has disabled things. */
-	kgdb8250_uart_init();
-#endif
-	/* We may need to call request_mem_region() first. */
-	if (kgdb8250_needs_request_mem_region)
-		request_mem_region(current_port->mapbase,
-				   8 << current_port->regshift, "kgdb");
-	if (request_irq(current_port->irq, kgdb8250_interrupt, IRQF_SHARED,
-			"GDB-stub", current_port) < 0)
-		printk(KERN_ERR "KGDB failed to request the serial IRQ (%d)\n",
-		       current_port->irq);
-}
-
-static __init int kgdb_init_io(void)
-{
-	/* Setup the KGDB uart table if not already initialized */
-	kgdb8250_copy_rs_table();
-
-	/* We're either a module and parse a config string, or we have a
-	 * semi-static config. */
-#ifdef CONFIG_KGDB_8250_MODULE
-	if (strlen(config)) {
-		if (kgdb8250_opt(config))
+		kgdb8250_baud = simple_strtoul(str, &str, 10);
+		if (!kgdb8250_baud)
 			return -EINVAL;
-	} else {
-		printk(KERN_ERR "kgdb8250: argument error, usage: "
-		       "kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>\n");
-		printk(KERN_ERR "kgdb8250: alt usage: "
-		       "kgdb8250=<line #>,<baud rate>\n");
+
+		if (*str == ',')
+			return -EINVAL;
+
+		goto finish;
+	} else
+		return -EINVAL;
+
+	if (*str != ',')
 		return -EINVAL;
+	str++;
+
+	if (kgdb8250_port.iotype == UPIO_PORT)
+		kgdb8250_port.iobase = simple_strtoul(str, &str, 16);
+	else {
+		if (kgdb8250_port.flags & UPF_IOREMAP)
+			kgdb8250_port.mapbase =
+				(unsigned long) simple_strtoul(str, &str, 16);
+		else
+			kgdb8250_port.membase =
+				(void *) simple_strtoul(str, &str, 16);
+	}
+
+	if (*str == '/') {
+		str++;
+		kgdb8250_port.regshift = simple_strtoul(str, &str, 10);
 	}
-#elif defined(CONFIG_KGDB_SIMPLE_SERIAL)
-	if (kgdb8250_line < 0)
+
+	if (*str != ',')
 		return -EINVAL;
-	/* Setup our pointer to the serial port now. */
-	current_port = &kgdb8250_ports[kgdb8250_line];
-	if (!current_port->membase && !current_port->iobase &&
-		!current_port->irq)
-		serial8250_get_port_def(current_port, kgdb8250_line);
-#elif defined(CONFIG_KGDB_8250_CONF_STRING)
-	if (kgdb8250_opt(CONFIG_KGDB_8250_CONF_STRING))
+	str++;
+
+	kgdb8250_baud = simple_strtoul(str, &str, 10);
+	if (!kgdb8250_baud)
 		return -EINVAL;
-#else
+
+	if (*str != ',')
 		return -EINVAL;
-#endif
+	str++;
+
+	kgdb8250_port.irq = simple_strtoul(str, &str, 10);
+
+finish:
+	err = kgdb_register_io_module(&kgdb8250_io_ops);
+	if (err)
+		kgdb8250_addr = 0;
 
+	return err;
+}
 
+static int kgdb8250_early_init(void)
+{
 	/* Internal driver setup. */
-	switch (current_port->iotype) {
+	switch (kgdb8250_port.iotype) {
 	case UPIO_MEM:
-		if (current_port->mapbase)
-			kgdb8250_needs_request_mem_region = 1;
-		if (current_port->flags & UPF_IOREMAP) {
-			current_port->membase = ioremap(current_port->mapbase,
-						8 << current_port->regshift);
-			if (!current_port->membase)
-				return -EIO;	/* Failed. */
-		}
-		kgdb8250_addr = current_port->membase;
+		if (kgdb8250_port.flags & UPF_IOREMAP)
+			kgdb8250_port.membase = ioremap(kgdb8250_port.mapbase,
+						8 << kgdb8250_port.regshift);
+		kgdb8250_addr = kgdb8250_port.membase;
 		break;
 	case UPIO_PORT:
 	default:
-		kgdb8250_addr = ioport_map(current_port->iobase,
-					   8 << current_port->regshift);
-		if (!kgdb8250_addr)
-			return -EIO;	/* Failed. */
+		kgdb8250_addr = ioport_map(kgdb8250_port.iobase,
+					   8 << kgdb8250_port.regshift);
 	}
+	if (!kgdb8250_addr)
+		return -EIO;
 
-	if (kgdb8250_uart_init() == -1) {
-		printk(KERN_ERR "kgdb8250: init failed\n");
+	if (kgdb8250_uart_init() < 0) {
+		printk(KERN_ERR "kgdb8250: UART initialization failed\n");
 		return -EIO;
 	}
-#ifdef CONFIG_KGDB_8250_MODULE
-	/* Attach the kgdb irq. When this is built into the kernel, it
-	 * is called as a part of late_init sequence.
-	 */
-	kgdb8250_late_init();
-	if (kgdb_register_io_module(&local_kgdb_io_ops))
-		return -EINVAL;
-
-	printk(KERN_INFO "kgdb8250: debugging enabled\n");
-#endif				/* CONFIG_KGD_8250_MODULE */
 
 	return 0;
 }
 
-#ifdef CONFIG_KGDB_8250_MODULE
-/* If it is a module the kgdb_io_ops should be a static which
- * is passed to the KGDB I/O initialization
- */
-static void kgdb8250_pre_exception_handler(void);
-static void kgdb8250_post_exception_handler(void);
+static int kgdb8250_late_init(void)
+{
+	int err;
 
-static struct kgdb_io local_kgdb_io_ops = {
-#else				/* ! CONFIG_KGDB_8250_MODULE */
-struct kgdb_io kgdb_io_ops = {
-#endif				/* ! CONFIG_KGD_8250_MODULE */
-	.read_char = kgdb_get_debug_char,
-	.write_char = kgdb_put_debug_char,
-	.init = kgdb_init_io,
-	.late_init = kgdb8250_late_init,
-#ifdef CONFIG_KGDB_8250_MODULE
-	.pre_exception = kgdb8250_pre_exception_handler,
-	.post_exception = kgdb8250_post_exception_handler,
-#endif
-};
+	if (fully_initialized)
+		return 0;
 
-/**
- * 	kgdb8250_add_port - Define a serial port for use with KGDB
- * 	@i: The index of the port being added
- * 	@serial_req: The &struct uart_port describing the port
- *
- * 	On platforms where we must register the serial device
- * 	dynamically, this is the best option if a platform also normally
- * 	calls early_serial_setup().
- */
-void kgdb8250_add_port(int i, struct uart_port *serial_req)
-{
-	if (i >= UART_NR) {
-		printk(KERN_ERR "KGDB dynamic uart registration failed"
-		   "NR_UARTS is too small");
-		return;
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
 	}
 
-	/* Copy the whole thing over. */
-	if (current_port != &kgdb8250_ports[i])
-		memcpy(&kgdb8250_ports[i], serial_req,
-		sizeof(struct uart_port));
-}
+	/* Take the port away from the main driver. */
+	hijacked_line = serial8250_find_port(&kgdb8250_port);
+	if (hijacked_line >= 0)
+		serial8250_unregister_port(hijacked_line);
 
-/**
- * 	kgdb8250_add_platform_port - Define a serial port for use with KGDB
- * 	@i: The index of the port being added
- * 	@p: The &struct plat_serial8250_port describing the port
- *
- * 	On platforms where we must register the serial device
- * 	dynamically, this is the best option if a platform normally
- * 	handles uart setup with an array of &struct plat_serial8250_port.
- */
-void __init kgdb8250_add_platform_port(int i, struct plat_serial8250_port *p)
-{
-	/* Make sure we've got the built-in data before we override. */
-	kgdb8250_copy_rs_table();
+	/* Now reinit the port as the above has disabled things. */
+	kgdb8250_uart_init();
 
-	if (i >= UART_NR) {
-		printk(KERN_ERR "KGDB dynamic uart registration failed"
-		   "NR_UARTS is too small");
-		return;
+	/* Request memory/io regions that we use. */
+	if (kgdb8250_port.flags & UPF_IOREMAP) {
+		if (!request_mem_region(kgdb8250_port.mapbase,
+					8 << kgdb8250_port.regshift, "kgdb"))
+			goto rollback;
+	} else if (kgdb8250_port.iotype == UPIO_PORT) {
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
 	}
 
-	kgdb8250_ports[i].iobase = p->iobase;
-	kgdb8250_ports[i].membase = p->membase;
-	kgdb8250_ports[i].irq = p->irq;
-	kgdb8250_ports[i].uartclk = p->uartclk;
-	kgdb8250_ports[i].regshift = p->regshift;
-	kgdb8250_ports[i].iotype = p->iotype;
-	kgdb8250_ports[i].flags = p->flags;
-	kgdb8250_ports[i].mapbase = p->mapbase;
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
 }
 
-/*
- * Syntax for this cmdline option is:
- * kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>"
- */
-static int __init kgdb8250_opt(char *str)
+static void kgdb8250_cleanup(void)
 {
-	/* We'll fill out and use the first slot. */
-	current_port = &kgdb8250_ports[0];
+	void *ioaddr = kgdb8250_addr;
 
-	if (!strncmp(str, "io", 2)) {
-		current_port->iotype = UPIO_PORT;
-		str += 2;
-	} else if (!strncmp(str, "mmap", 4)) {
-		current_port->iotype = UPIO_MEM;
-		current_port->flags |= UPF_IOREMAP;
-		str += 4;
-	} else if (!strncmp(str, "mmio", 4)) {
-		current_port->iotype = UPIO_MEM;
-		current_port->flags &= ~UPF_IOREMAP;
-		str += 4;
-	} else if (*str >= '0' || *str <= '9') {
-		kgdb8250_line = *str - '0';
-		/* UARTS in the list from 0 -> 9 */
-		if (kgdb8250_line >= UART_NR)
-			goto errout;
-		current_port = &kgdb8250_ports[kgdb8250_line];
-		if (serial8250_get_port_def(current_port, kgdb8250_line))
-			goto errout;
-		str++;
-		if (*str != ',')
-			goto errout;
-		str++;
-		kgdb8250_baud = simple_strtoul(str, &str, 10);
-		if (!kgdb8250_baud)
-			goto errout;
-		if (*str == ',')
-			goto errout;
-		goto finish;
-	} else
-		goto errout;
+	if (!kgdb8250_addr)
+		return;
 
-	if (*str != ',')
-		goto errout;
-	str++;
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
 
-	if (current_port->iotype == UPIO_PORT)
-		current_port->iobase = simple_strtoul(str, &str, 16);
-	else {
-		if (current_port->flags & UPF_IOREMAP)
-			current_port->mapbase =
-				(unsigned long) simple_strtoul(str, &str, 16);
-		else
-			current_port->membase =
-				(void *) simple_strtoul(str, &str, 16);
+	if (!fully_initialized)
+		return;
+
+	fully_initialized = 0;
+
+	if (kgdb8250_port.iotype == UPIO_PORT) {
+		ioport_unmap(ioaddr);
+		release_region(kgdb8250_port.iobase,
+			       8 << kgdb8250_port.regshift);
+	} else if (kgdb8250_port.flags & UPF_IOREMAP) {
+		iounmap(kgdb8250_port.membase);
+		release_mem_region(kgdb8250_port.mapbase,
+				   8 << kgdb8250_port.regshift);
 	}
 
-	if (*str != ',')
-		goto errout;
-	str++;
+	/* Give the port back to the 8250 driver. */
+	if (hijacked_line >= 0)
+		serial8250_register_port(&kgdb8250_port);
+}
 
-	kgdb8250_baud = simple_strtoul(str, &str, 10);
-	if (!kgdb8250_baud)
-		goto errout;
+static int kgdb8250_set_config(const char *kmessage, struct kernel_param *kp)
+{
+	int err;
 
-	if (*str != ',')
-		goto errout;
-	str++;
+	if (strlen(kmessage) >= KGD8250_MAX_CONFIG_STR) {
+		printk(KERN_ERR "%s: config string too long.\n", kp->name);
+		return -ENOSPC;
+	}
 
-	current_port->irq = simple_strtoul(str, &str, 10);
+	if (kgdb_connected) {
+		printk(KERN_ERR "kgd8250: Cannot reconfigure while KGDB is "
+				"connected.\n");
+		return -EBUSY;
+	}
 
-finish:
-#ifdef CONFIG_KGDB_SIMPLE_SERIAL
-	should_copy_rs_table = 0;
-#endif
+	if (kgdb8250_addr)
+		kgdb8250_cleanup();
 
-	return 0;
+	err = kgdb8250_parse_config((char *)kmessage);
+
+	if (err || !late_init_passed)
+		return err;
 
-errout:
-	printk(KERN_ERR "Invalid syntax for option kgdb8250=\n");
-	return 1;
+	/* Call the botton-half initialization as we are re-configuring. */
+	return kgdb8250_late_init();
 }
 
-#ifdef CONFIG_KGDB_8250_MODULE
 static void kgdb8250_pre_exception_handler(void)
 {
-	if (!module_refcount(THIS_MODULE))
+	if (!kgdb_connected)
 		try_module_get(THIS_MODULE);
 }
 
 static void kgdb8250_post_exception_handler(void)
 {
-	if (!kgdb_connected && module_refcount(THIS_MODULE))
+	if (!kgdb_connected)
 		module_put(THIS_MODULE);
 }
 
-static void cleanup_kgdb8250(void)
-{
-	kgdb_unregister_io_module(&local_kgdb_io_ops);
+static struct kgdb_io kgdb8250_io_ops = {
+	.name = "kgdb8250",
+	.read_char = kgdb8250_get_debug_char,
+	.write_char = kgdb8250_put_debug_char,
+	.init = kgdb8250_early_init,	.pre_exception = kgdb8250_pre_exception_handler,
+	.post_exception = kgdb8250_post_exception_handler,
+};
 
-	/* Clean up the irq and memory */
-	free_irq(current_port->irq, current_port);
+module_init(kgdb8250_late_init);
+module_exit(kgdb8250_cleanup);
 
-	if (kgdb8250_needs_request_mem_region)
-		release_mem_region(current_port->mapbase,
-				   8 << current_port->regshift);
-	/* Hook up the serial port back to what it was previously
-	 * hooked up to.
-	 */
-#if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
-	/* Give the port back to the 8250 driver. */
-	serial8250_register_port(current_port);
-#endif
-}
+module_param_call(kgdb8250, kgdb8250_set_config, param_get_string, &kps, 0644);
+MODULE_PARM_DESC(kgdb8250, "ttyS<n>,<baud rate>");
 
-module_init(kgdb_init_io);
-module_exit(cleanup_kgdb8250);
-#else				/* ! CONFIG_KGDB_8250_MODULE */
-early_param("kgdb8250", kgdb8250_opt);
-#endif				/* ! CONFIG_KGDB_8250_MODULE */
+#ifdef CONFIG_KGDB_8250
+early_param("kgdb8250", kgdb8250_parse_config);
+#endif
Index: b/drivers/serial/8250.c
===================================================================
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2639,6 +2639,7 @@ int serial8250_find_port(struct uart_por
 	}
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(serial8250_find_port);
 
 #define SERIAL8250_CONSOLE	&serial8250_console
 #else
@@ -2926,51 +2927,28 @@ EXPORT_SYMBOL(serial8250_unregister_port
  *  @line: specific serial line index
  *
  *  Return 0 if the port existed
- *  Return 1 on failure
+ *  Return -errno on failure
  */
-
 int serial8250_get_port_def(struct uart_port *port, int line)
 {
-	struct uart_8250_port *uart;
+	struct uart_port *port8250 = &serial8250_ports[line].port;
 
-	if (line < 0 || line >= UART_NR)
-		return 1;
-	uart = &serial8250_ports[line];
-	if (uart) {
-		port->iobase = uart->port.iobase;
-		port->membase = uart->port.membase;
-		port->irq = uart->port.irq;
-		port->uartclk = uart->port.uartclk;
-		port->fifosize = uart->port.fifosize;
-		port->regshift = uart->port.regshift;
-		port->iotype = uart->port.iotype;
-		port->flags = uart->port.flags;
-		port->mapbase = uart->port.mapbase;
-		port->dev =	uart->port.dev;
-		return 0;
-	}
-	return 1;
-}
-EXPORT_SYMBOL(serial8250_get_port_def);
-
-/**
- *	serial8250_unregister_by_port - remove a 16x50 serial port
- *	at runtime.
- *	@port: A &struct uart_port that describes the port to remove.
- *
- *	Remove one serial port.  This may not be called from interrupt
- *	context.  We hand the port back to the our control.
- */
-void serial8250_unregister_by_port(struct uart_port *port)
-{
-	struct uart_8250_port *uart;
-
-	uart = serial8250_find_match_or_unused(port);
+	if (!port8250->iobase && !port8250->membase)
+		return -ENODEV;
 
-	if (uart)
-		serial8250_unregister_port(uart->port.line);
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
 }
-EXPORT_SYMBOL(serial8250_unregister_by_port);
+EXPORT_SYMBOL_GPL(serial8250_get_port_def);
 
 static int __init serial8250_init(void)
 {
Index: b/drivers/serial/Kconfig
===================================================================
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -942,6 +942,9 @@ config SERIAL_CORE
 config SERIAL_CORE_CONSOLE
 	bool
 
+config SERIAL_POLL
+	bool
+
 config SERIAL_68328
 	bool "68328 serial support"
 	depends on M68328 || M68EZ328 || M68VZ328
Index: b/drivers/serial/serial_core.c
===================================================================
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2439,12 +2439,6 @@ int uart_add_one_port(struct uart_driver
 	 */
 	port->flags &= ~UPF_DEAD;
 
-#if defined(CONFIG_KGDB_8250)
-	/* Add any 8250-like ports we find later. */
-	if (port->type <= PORT_MAX_8250)
-		kgdb8250_add_port(port->line, port);
-#endif
-
  out:
 	mutex_unlock(&state->mutex);
 	mutex_unlock(&port_mutex);
Index: b/include/linux/kgdb.h
===================================================================
--- a/include/linux/kgdb.h
+++ b/include/linux/kgdb.h
@@ -233,6 +233,7 @@ struct kgdb_arch {
 
 /**
  * struct kgdb_io - Describe the interface for an I/O driver to talk with KGDB.
+ * @name: Name of the I/O driver.
  * @read_char: Pointer to a function that will return one char.
  * @write_char: Pointer to a function that will write one char.
  * @flush: Pointer to a function that will flush any pending writes.
@@ -255,25 +256,20 @@ struct kgdb_arch {
  * notified.
  */
 struct kgdb_io {
-	int	(*read_char) (void);
-	void	(*write_char) (u8);
-	void	(*flush) (void);
-	int	(*init) (void);
-	void	(*late_init) (void);
-	void	(*pre_exception) (void);
-	void	(*post_exception) (void);
+	const char	*name;
+	int		(*read_char) (void);
+	void		(*write_char) (u8);
+	void		(*flush) (void);
+	int		(*init) (void);
+	void		(*pre_exception) (void);
+	void		(*post_exception) (void);
 };
 
-extern struct kgdb_io		kgdb_io_ops;
 extern struct kgdb_arch		arch_kgdb_ops;
 
 int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
-void kgdb8250_add_port(int i, struct uart_port *serial_req);
-void __init
-kgdb8250_add_platform_port(int i, struct plat_serial8250_port *serial_req);
-
 int kgdb_hex2long(char **ptr, long *long_val);
 char *kgdb_mem2hex(char *mem, char *buf, int count);
 char *kgdb_hex2mem(char *buf, char *mem, int count);
Index: b/kernel/kgdb.c
===================================================================
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -53,8 +53,7 @@
 #include <asm/atomic.h>
 #include <asm/system.h>
 
-static int __initdata kgdb_internal_init_complete;
-static int __initdata kgdb_break_asap;
+static int kgdb_break_asap;
 
 struct kgdb_state {
 	int			all_cpus_synced;
@@ -89,30 +88,16 @@ int				kgdb_io_module_registered;
 /* Guard for recursive entry */
 static int			exception_level;
 
-#ifdef CONFIG_KGDB_ATTACH_WAIT
-static int			attachwait = 1;
-#else
-static int			attachwait;
-#endif
-
-module_param(attachwait, int, 0644);
-MODULE_PARM_DESC(attachwait, "Wait for remote debugger after an exception");
-
-/* We provide a kgdb_io_ops structure that may be overriden. */
-struct kgdb_io __weak		kgdb_io_ops;
-EXPORT_SYMBOL_GPL(kgdb_io_ops);
-
-static struct kgdb_io		kgdb_io_ops_prev[KGDB_MAX_IO_HANDLERS];
-
-static int			kgdb_io_handler_cnt;
+static struct kgdb_io		*kgdb_io_ops;
+static DEFINE_SPINLOCK(kgdb_registration_lock);
 
 /*
  * Holds information about breakpoints in a kernel. These breakpoints are
  * added and removed by gdb.
  */
-struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS];
-
-struct kgdb_arch		*kgdb_ops = &arch_kgdb_ops;
+struct kgdb_bkpt		kgdb_break[KGDB_MAX_BREAKPOINTS] = {
+	[0 ... KGDB_MAX_BREAKPOINTS-1] = { .state = BP_UNDEFINED }
+};
 
 /*
  * KGDB locking is really nasty at places - but we really can only
@@ -126,7 +111,9 @@ struct kgdb_arch		*kgdb_ops = &arch_kgdb
 #define ROUNDUP_WAIT		640000	/* Arbitrary, increase if needed. */
 #define BUF_THREAD_ID_SIZE	16
 
-static spinlock_t		slave_cpu_locks[NR_CPUS];
+static spinlock_t		slave_cpu_locks[NR_CPUS] = {
+	[0 ... NR_CPUS-1] = __SPIN_LOCK_UNLOCKED(slave_cpu_locks)
+};
 static atomic_t			cpu_in_debugger[NR_CPUS];
 atomic_t			kgdb_setting_breakpoint;
 
@@ -185,7 +172,7 @@ int __weak kgdb_arch_set_breakpoint(unsi
 	if (kgdb_get_mem((char *)addr, saved_instr, BREAK_INSTR_SIZE) != 0)
 		return -1;
 
-	if (kgdb_set_mem((char *)addr, kgdb_ops->gdb_bpt_instr,
+	if (kgdb_set_mem((char *)addr, arch_kgdb_ops.gdb_bpt_instr,
 						BREAK_INSTR_SIZE) != 0)
 		return -1;
 	return 0;
@@ -228,14 +215,12 @@ static void get_packet(char *buffer)
 	int count;
 	char ch;
 
-	if (!kgdb_io_ops.read_char)
-		return;
 	do {
 		/*
 		 * Spin and wait around for the start character, ignore all
 		 * other characters:
 		 */
-		while ((ch = (kgdb_io_ops.read_char())) != '$')
+		while ((ch = (kgdb_io_ops->read_char())) != '$')
 			/* nothing */;
 
 		kgdb_connected = 1;
@@ -248,7 +233,7 @@ static void get_packet(char *buffer)
 		 * now, read until a # or end of buffer is found:
 		 */
 		while (count < (BUFMAX - 1)) {
-			ch = kgdb_io_ops.read_char();
+			ch = kgdb_io_ops->read_char();
 			if (ch == '#')
 				break;
 			checksum = checksum + ch;
@@ -258,17 +243,17 @@ static void get_packet(char *buffer)
 		buffer[count] = 0;
 
 		if (ch == '#') {
-			xmitcsum = hex(kgdb_io_ops.read_char()) << 4;
-			xmitcsum += hex(kgdb_io_ops.read_char());
+			xmitcsum = hex(kgdb_io_ops->read_char()) << 4;
+			xmitcsum += hex(kgdb_io_ops->read_char());
 
 			if (checksum != xmitcsum)
 				/* failed checksum */
-				kgdb_io_ops.write_char('-');
+				kgdb_io_ops->write_char('-');
 			else
 				/* successful transfer */
-				kgdb_io_ops.write_char('+');
-			if (kgdb_io_ops.flush)
-				kgdb_io_ops.flush();
+				kgdb_io_ops->write_char('+');
+			if (kgdb_io_ops->flush)
+				kgdb_io_ops->flush();
 		}
 	} while (checksum != xmitcsum);
 }
@@ -283,34 +268,31 @@ static void put_packet(char *buffer)
 	int count;
 	char ch;
 
-	if (!kgdb_io_ops.write_char)
-		return;
-
 	/*
 	 * $<packet info>#<checksum>.
 	 */
 	while (1) {
-		kgdb_io_ops.write_char('$');
+		kgdb_io_ops->write_char('$');
 		checksum = 0;
 		count = 0;
 
 		while ((ch = buffer[count])) {
-			kgdb_io_ops.write_char(ch);
+			kgdb_io_ops->write_char(ch);
 			checksum += ch;
 			count++;
 		}
 
-		kgdb_io_ops.write_char('#');
-		kgdb_io_ops.write_char(hexchars[checksum >> 4]);
-		kgdb_io_ops.write_char(hexchars[checksum % 16]);
-		if (kgdb_io_ops.flush)
-			kgdb_io_ops.flush();
+		kgdb_io_ops->write_char('#');
+		kgdb_io_ops->write_char(hexchars[checksum >> 4]);
+		kgdb_io_ops->write_char(hexchars[checksum % 16]);
+		if (kgdb_io_ops->flush)
+			kgdb_io_ops->flush();
 
 		/* Now see what we get in reply. */
-		ch = kgdb_io_ops.read_char();
+		ch = kgdb_io_ops->read_char();
 
 		if (ch == 3)
-			ch = kgdb_io_ops.read_char();
+			ch = kgdb_io_ops->read_char();
 
 		/* If we get an ACK, we are done. */
 		if (ch == '+')
@@ -323,9 +305,9 @@ static void put_packet(char *buffer)
 		 * packet.
 		 */
 		if (ch == '$') {
-			kgdb_io_ops.write_char('-');
-			if (kgdb_io_ops.flush)
-				kgdb_io_ops.flush();
+			kgdb_io_ops->write_char('-');
+			if (kgdb_io_ops->flush)
+				kgdb_io_ops->flush();
 			return;
 		}
 	}
@@ -705,10 +687,10 @@ static struct task_struct *getthread(str
 		return current;
 
 	if (num_online_cpus() && (tid >= pid_max + num_online_cpus() +
-							kgdb_ops->shadowth))
+							arch_kgdb_ops.shadowth))
 		return NULL;
 
-	if (kgdb_ops->shadowth && (tid >= pid_max + num_online_cpus())) {
+	if (arch_kgdb_ops.shadowth && (tid >= pid_max + num_online_cpus())) {
 		return kgdb_get_shadow_thread(regs, tid - pid_max -
 					      num_online_cpus());
 	}
@@ -809,8 +791,8 @@ static void kgdb_wait(struct pt_regs *re
 	kgdb_info[cpu].task = NULL;
 
 	/* fix up hardware debug registers on local cpu */
-	if (kgdb_ops->correct_hw_break)
-		kgdb_ops->correct_hw_break();
+	if (arch_kgdb_ops.correct_hw_break)
+		arch_kgdb_ops.correct_hw_break();
 
 	/* Signal the master CPU that we are done: */
 	atomic_set(&cpu_in_debugger[cpu], 0);
@@ -1013,8 +995,8 @@ int remove_all_break(void)
 	}
 
 	/* Clear hardware breakpoints. */
-	if (kgdb_ops->remove_all_hw_break)
-		kgdb_ops->remove_all_hw_break();
+	if (arch_kgdb_ops.remove_all_hw_break)
+		arch_kgdb_ops.remove_all_hw_break();
 
 	return 0;
 }
@@ -1073,14 +1055,12 @@ static void kgdb_msg_write(const char *s
  */
 int kgdb_io_ready(int print_wait)
 {
-	if (!kgdb_io_ops.read_char)
+	if (!kgdb_io_ops)
 		return 0;
 	if (kgdb_connected)
 		return 1;
 	if (atomic_read(&kgdb_setting_breakpoint))
 		return 1;
-	if (!attachwait)
-		return 0;
 	if (print_wait)
 		printk(KERN_CRIT "KGDB: Waiting for remote debugger\n");
 	return 1;
@@ -1147,7 +1127,7 @@ static void gdb_cmd_getregs(struct kgdb_
 	 * in __schedule() sleeping, since all other CPUs
 	 * are in kgdb_wait, and thus have debuggerinfo.
 	 */
-	if (kgdb_ops->shadowth &&
+	if (arch_kgdb_ops.shadowth &&
 			ks->kgdb_usethreadid >= pid_max + num_online_cpus()) {
 
 		shadowregs = kgdb_shadow_regs(ks->linux_regs,
@@ -1279,7 +1259,7 @@ static int gdb_cmd_reboot(struct kgdb_st
 /* Handle the 'q' query packets */
 static void gdb_cmd_query(struct kgdb_state *ks)
 {
-	int numshadowth = num_online_cpus() + kgdb_ops->shadowth;
+	int numshadowth = num_online_cpus() + arch_kgdb_ops.shadowth;
 	struct task_struct *thread;
 	unsigned char thref[8];
 	char *ptr;
@@ -1430,7 +1410,7 @@ static void gdb_cmd_break(struct kgdb_st
 	unsigned long length;
 	int error = 0;
 
-	if (kgdb_ops->set_hw_breakpoint && *bpt_type >= '1') {
+	if (arch_kgdb_ops.set_hw_breakpoint && *bpt_type >= '1') {
 		/* Unsupported */
 		if (*bpt_type > '4')
 			return;
@@ -1444,7 +1424,7 @@ static void gdb_cmd_break(struct kgdb_st
 	 * Test if this is a hardware breakpoint, and
 	 * if we support it:
 	 */
-	if (*bpt_type == '1' && !(kgdb_ops->flags & KGDB_HW_BREAKPOINT))
+	if (*bpt_type == '1' && !(arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT))
 		/* Unsupported. */
 		return;
 
@@ -1469,10 +1449,10 @@ static void gdb_cmd_break(struct kgdb_st
 	else if (remcom_in_buffer[0] == 'z' && *bpt_type == '0')
 		error = kgdb_remove_sw_break(addr);
 	else if (remcom_in_buffer[0] == 'Z')
-		error = kgdb_ops->set_hw_breakpoint(addr,
+		error = arch_kgdb_ops.set_hw_breakpoint(addr,
 			(int)length, *bpt_type);
 	else if (remcom_in_buffer[0] == 'z')
-		error = kgdb_ops->remove_hw_breakpoint(addr,
+		error = arch_kgdb_ops.remove_hw_breakpoint(addr,
 			(int) length, *bpt_type);
 
 	if (error == 0)
@@ -1486,7 +1466,6 @@ static int gdb_cmd_exception_pass(struct
 {
 	/* C09 == pass exception
 	 * C15 == detach kgdb, pass exception
-	 * C30 == detach kgdb, stop attachwait, pass exception
 	 */
 	if (remcom_in_buffer[1] == '0' && remcom_in_buffer[2] == '9') {
 
@@ -1501,14 +1480,6 @@ static int gdb_cmd_exception_pass(struct
 		kgdb_connected = 0;
 		return 1;
 
-	} else if (remcom_in_buffer[1] == '3' && remcom_in_buffer[2] == '0') {
-
-		ks->pass_exception = 1;
-		attachwait = 0;
-		remcom_in_buffer[0] = 'D';
-		remove_all_break();
-		kgdb_connected = 0;
-		return 1;
 	} else {
 		error_packet(remcom_out_buffer, -EINVAL);
 		return 0;
@@ -1557,7 +1528,7 @@ static int gdb_serial_stub(struct kgdb_s
 	ks->kgdb_usethreadid = shadow_pid(kgdb_info[ks->cpu].task->pid);
 	ks->pass_exception = 0;
 
-	while (kgdb_io_ops.read_char) {
+	while (1) {
 		error = 0;
 
 		/* Clear the out buffer. */
@@ -1713,8 +1684,7 @@ kgdb_handle_exception(int evector, int s
 	struct kgdb_state *ks = &kgdb_var;
 	unsigned long flags;
 	int error = 0;
-	unsigned i;
-	int cpu;
+	int i, cpu;
 
 	ks->cpu			= raw_smp_processor_id();
 	ks->all_cpus_synced	= 0;
@@ -1788,8 +1758,8 @@ acquirelock:
 		goto kgdb_restore;
 
 	/* Call the I/O driver's pre_exception routine */
-	if (kgdb_io_ops.pre_exception)
-		kgdb_io_ops.pre_exception();
+	if (kgdb_io_ops->pre_exception)
+		kgdb_io_ops->pre_exception();
 
 	kgdb_info[ks->cpu].debuggerinfo = ks->linux_regs;
 	kgdb_info[ks->cpu].task = current;
@@ -1847,15 +1817,15 @@ acquirelock:
 	error = gdb_serial_stub(ks);
 
 	/* Call the I/O driver's post_exception routine */
-	if (kgdb_io_ops.post_exception)
-		kgdb_io_ops.post_exception();
+	if (kgdb_io_ops->post_exception)
+		kgdb_io_ops->post_exception();
 
 	kgdb_info[ks->cpu].debuggerinfo = NULL;
 	kgdb_info[ks->cpu].task = NULL;
 	atomic_set(&cpu_in_debugger[ks->cpu], 0);
 
 	if (!debugger_step || !kgdb_contthread) {
-		for (i = 0; i < NR_CPUS; i++)
+		for (i = NR_CPUS-1; i >= 0; i--)
 			spin_unlock(&slave_cpu_locks[i]);
 		/*
 		 * Wait till all the CPUs have quit
@@ -1968,32 +1938,10 @@ static struct console kgdbcons = {
 };
 #endif
 
-/*
- * Initialization that needs to be done in either of our entry points.
- */
-static void __init kgdb_internal_init(void)
-{
-	int i;
-
-	if (kgdb_internal_init_complete)
-		return;
-	/* Initialize our spinlocks. */
-	for (i = 0; i < NR_CPUS; i++)
-		spin_lock_init(&slave_cpu_locks[i]);
-
-	for (i = 0; i < KGDB_MAX_BREAKPOINTS; i++)
-		kgdb_break[i].state = BP_UNDEFINED;
-
-	/* Initialize the I/O handles */
-	memset(&kgdb_io_ops_prev, 0, sizeof(kgdb_io_ops_prev));
-
-	kgdb_internal_init_complete = 1;
-}
-
 #ifdef CONFIG_MAGIC_SYSRQ
 static void sysrq_handle_gdb(int key, struct tty_struct *tty)
 {
-	if (!kgdb_io_ops.read_char) {
+	if (!kgdb_io_ops) {
 		printk(KERN_CRIT "ERROR: No KGDB I/O module available\n");
 		return;
 	}
@@ -2061,180 +2009,74 @@ static void kgdb_unregister_hooks(void)
 	}
 }
 
-int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops)
+static void kgdb_initial_breakpoint(void)
 {
+	kgdb_break_asap = 0;
 
-	if (!local_kgdb_io_ops->init)
-		return -EINVAL;
-	if (kgdb_connected) {
-		printk(KERN_ERR "kgdb: Cannot load I/O module while KGDB "
-		       "connected.\n");
-		return -EINVAL;
-	}
+	printk(KERN_CRIT "kgdb: Waiting for connection from remote gdb...\n");
+	breakpoint();
+}
 
-	/* Save the old values so they can be restored */
-	if (kgdb_io_handler_cnt >= KGDB_MAX_IO_HANDLERS) {
-		printk(KERN_ERR "kgdb: No more I/O handles available.\n");
-		return -EINVAL;
-	}
+int kgdb_register_io_module(struct kgdb_io *new_kgdb_io_ops)
+{
+	int err;
 
-	/*
-	 * Check to see if there is an existing driver and if so save its
-	 * values.  Also check to make sure the same driver was not trying
-	 * to re-register.
-	 */
-	if (kgdb_io_ops.read_char != NULL &&
-		kgdb_io_ops.read_char != local_kgdb_io_ops->read_char) {
-		memcpy(&kgdb_io_ops_prev[kgdb_io_handler_cnt],
-		       &kgdb_io_ops, sizeof(struct kgdb_io));
-		kgdb_io_handler_cnt++;
-	}
+	spin_lock(&kgdb_registration_lock);
 
-	/* Initialize the io values for this module */
-	memcpy(&kgdb_io_ops, local_kgdb_io_ops, sizeof(struct kgdb_io));
+	if (kgdb_io_ops) {
+		spin_unlock(&kgdb_registration_lock);
 
-	/* Make the call to register kgdb if is not initialized */
-	kgdb_register_hooks();
+		printk(KERN_ERR "kgdb: Another I/O driver is already "
+				"registered with KGDB.\n");
+		return -EBUSY;
+	}
 
-	return 0;
-}
-EXPORT_SYMBOL_GPL(kgdb_register_io_module);
+	if (new_kgdb_io_ops->init) {
+		err = new_kgdb_io_ops->init();
+		if (err) {
+			spin_unlock(&kgdb_registration_lock);
+			return err;
+		}
+	}
 
-void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops)
-{
-	int i;
+	kgdb_io_ops = new_kgdb_io_ops;
 
-	/*
-	 * Unregister KGDB if there were no other prior io hooks, else
-	 * restore the io hooks.
-	 */
-	if (kgdb_io_handler_cnt > 0 && kgdb_io_ops_prev[0].read_char != NULL) {
-		/*
-		 * First check if the hook that is in use is the one being
-		 * removed:
-		 */
-		if (kgdb_io_ops.read_char == local_kgdb_io_ops->read_char) {
-			/*
-			 * Set 'i' to the value of where the list should be
-			 * shifed:
-			 */
-			i = kgdb_io_handler_cnt - 1;
-			memcpy(&kgdb_io_ops, &kgdb_io_ops_prev[i],
-			       sizeof(struct kgdb_io));
-		} else {
-			/*
-			 * Simple case to remove an entry for an I/O handler
-			 * that is not in use:
-			 */
-			for (i = 0; i < kgdb_io_handler_cnt; i++) {
-				if (kgdb_io_ops_prev[i].read_char ==
-				    local_kgdb_io_ops->read_char)
-					break;
-			}
-		}
+	spin_unlock(&kgdb_registration_lock);
 
-		/*
-		 * Shift all the entries in the handler array so it is
-		 * ordered from oldest to newest.
-		 */
-		kgdb_io_handler_cnt--;
-		for (; i < kgdb_io_handler_cnt; i++) {
-			memcpy(&kgdb_io_ops_prev[i], &kgdb_io_ops_prev[i + 1],
-			       sizeof(struct kgdb_io));
-		}
+	printk(KERN_INFO "kgdb: Registered I/O driver %s.\n",
+	       new_kgdb_io_ops->name);
 
-		/*
-		 * Handle the case if we are on the last element and set it
-		 * to NULL;
-		 */
-		memset(&kgdb_io_ops_prev[kgdb_io_handler_cnt], 0,
-				sizeof(struct kgdb_io));
+	/* Arm KGDB now. */
+	kgdb_register_hooks();
 
-		if (kgdb_connected) {
-			printk(KERN_ERR "kgdb: WARNING: I/O method changed "
-			       "while kgdb was connected state.\n");
-		}
-	} else {
-		/*
-		 * KGDB is no longer able to communicate out, so
-		 * unregister our hooks and reset state:
-		 */
-		kgdb_unregister_hooks();
-		if (kgdb_connected) {
-			printk(KERN_CRIT "kgdb: I/O module was unloaded while "
-					"a debugging session was running.  "
-					"KGDB will be reset.\n");
-			if (remove_all_break() < 0)
-				printk(KERN_CRIT "kgdb: Reset failed.\n");
-			kgdb_connected = 0;
-		}
-		memset(&kgdb_io_ops, 0, sizeof(struct kgdb_io));
-	}
-}
-EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
+	if (kgdb_break_asap)
+		kgdb_initial_breakpoint();
 
-static void __init kgdb_initial_breakpoint(void)
-{
-	printk(KERN_CRIT "kgdb: Waiting for connection from remote gdb...\n");
-	breakpoint();
+	return 0;
 }
+EXPORT_SYMBOL_GPL(kgdb_register_io_module);
 
-/*
- * This function can be called very early, either via early_param() or
- * an explicit breakpoint() early on.
- */
-static void __init kgdb_early_entry(void)
+void kgdb_unregister_io_module(struct kgdb_io *old_kgdb_io_ops)
 {
-	/*
-	 * Initialize the KGDB I/O module
-	 * For early entry kgdb_io_ops.init must be defined
-	 */
-	if (!kgdb_io_ops.init || kgdb_io_ops.init()) {
-		printk(KERN_INFO "kgdb: Defering I/O setup to late init.\n");
-		return;
-	}
-	kgdb_internal_init();
-	kgdb_register_io_module(&kgdb_io_ops);
-}
+	BUG_ON(kgdb_connected);
 
-/*
- * This function will always be invoked to make sure that KGDB will grab
- * what it needs to so that if something happens while the system is
- * running, KGDB will get involved.  If kgdb_early_entry() has already
- * been invoked, there is little we need to do.
- */
-static int __init kgdb_late_entry(void)
-{
 	/*
-	 * Late entry may be the first entry, so all initialization
-	 * routines must be called here as well as the early entry
+	 * KGDB is no longer able to communicate out, so
+	 * unregister our hooks and reset state.
 	 */
-	kgdb_internal_init();
+	kgdb_unregister_hooks();
 
-	if (!kgdb_io_module_registered &&
-		(!kgdb_io_ops.init || kgdb_io_ops.init())) {
-		/*
-		 * When KGDB allows I/O via modules and the core I/O init
-		 * fails KGDB must default to defering the I/O setup, and
-		 * appropriately print an error about it.
-		 */
-		printk(KERN_INFO "kgdb: Defering I/O setup to module.\n");
-		memset(&kgdb_io_ops, 0, sizeof(struct kgdb_io));
-		kgdb_break_asap = 0;
-		return 0;
-	}
-	kgdb_register_io_module(&kgdb_io_ops);
+	spin_lock(&kgdb_registration_lock);
 
-	/* Execute any late init I/O routines. */
-	if (kgdb_io_ops.late_init)
-		kgdb_io_ops.late_init();
+	WARN_ON(kgdb_io_ops != old_kgdb_io_ops);
+	kgdb_io_ops = NULL;
 
-	if (kgdb_break_asap)
-		kgdb_initial_breakpoint();
+	spin_unlock(&kgdb_registration_lock);
 
-	return 0;
+	printk(KERN_INFO "kgdb: Unregistered I/O driver %s, debugger "
+	                 "disabled.\n", old_kgdb_io_ops->name);
 }
-late_initcall(kgdb_late_entry);
+EXPORT_SYMBOL_GPL(kgdb_unregister_io_module);
 
 /*
  * This function will generate a breakpoint exception.  It is used at the
@@ -2264,38 +2106,23 @@ kgdb_notify_reboot(struct notifier_block
 	if (!kgdb_connected || atomic_read(&debugger_active) != 0)
 		return 0;
 
-	if ((code == SYS_RESTART) || (code == SYS_HALT) ||
-						(code == SYS_POWER_OFF)) {
+	if (code == SYS_RESTART || code == SYS_HALT || code == SYS_POWER_OFF) {
 		local_irq_save(flags);
 		put_packet("X00");
+		kgdb_connected = 0;
 		local_irq_restore(flags);
 	}
 	return NOTIFY_DONE;
 }
 
-static int __init opt_kgdb_attachwait(char *str)
-{
-	attachwait = 1;
-
-	return 0;
-}
-
-static int __init opt_kgdb_enter(char *str)
+static int __init opt_kgdb_wait(char *str)
 {
-	/* We've already done this by an explicit breakpoint() call. */
-	if  (kgdb_internal_init_complete)
-		return 0;
-
-	kgdb_early_entry();
-	attachwait = 1;
+	kgdb_break_asap = 1;
 
 	if (kgdb_io_module_registered)
 		kgdb_initial_breakpoint();
-	else
-		kgdb_break_asap = 1;
 
 	return 0;
 }
 
-early_param("kgdbwait", opt_kgdb_enter);
-early_param("attachwait", opt_kgdb_attachwait);
+early_param("kgdbwait", opt_kgdb_wait);
Index: b/lib/Kconfig.kgdb
===================================================================
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -15,126 +15,6 @@ config KGDB_ARCH_HAS_SHADOW_INFO
 	bool
 	depends on KGDB
 
-config SERIAL_POLL
-	bool
-
-choice
-	prompt "Method for KGDB communication"
-	depends on KGDB
-	default KGDBOC_NOMODULE
-	help
-	  There are a number of different ways in which you can communicate
-	  with KGDB.  The most common is via serial, with the 8250 driver
-	  (should your hardware have an 8250, or ns1655x style uart).
-	  You can elect to have one core I/O driver that is built into the
-	  kernel for debugging as the kernel is booting, or using only
-	  kernel modules.
-
-config KGDB_ONLY_MODULES
-	bool "KGDB: Use only kernel modules for I/O"
-	depends on MODULES
-	help
-	  Use only kernel modules to configure KGDB I/O after the
-	  kernel is booted.
-
-config KGDB_8250_NOMODULE
-	bool "KGDB: On generic serial port (8250)"
-	select KGDB_8250
-	help
-	  Uses generic serial port (8250) to communicate with the host
-	  GDB.  This is independent of the normal (SERIAL_8250) driver
-	  for this chipset.
-
-config KGDBOC_NOMODULE
-	bool "KGDB: On Console - in kernel"
-	select KGDBOC
-	select SERIAL_POLL
-	help
-	  Uses the SERIAL_POLL API to multiplex the console driver
-	  output with the debugger output when the debugger is active.
-	  To break into the debugger initially you must use the sysrq
-	  request with the "g" for gdb.
-
-endchoice
-
-config KGDBOC
-	tristate "KGDB: Share serial console and kgdb port" if !KGDBOC_NOMODULE
-	depends on m && KGDB
-	default m
-	select SERIAL_POLL
-	select MAGIC_SYSRQ
-	help
-	  Share a serial console with kgdb.  The sysrq-g must be used
-	  to break in initially.
-
-config KGDB_8250
-	tristate "KGDB: On generic serial port (8250)" if !KGDB_8250_NOMODULE
-	depends on m && KGDB_ONLY_MODULES
-	help
-	  Uses generic serial port (8250) to communicate with the host
-	  GDB.  This is independent of the normal (SERIAL_8250) driver
-	  for this chipset.
-
-config KGDB_SIMPLE_SERIAL
-	bool "Simple configuration of KGDB serial port"
-	depends on KGDB_8250_NOMODULE
-	default y
-	help
-	  If you say Y here, you will only have to pick the baud rate
-	  and port number that you wish to use for KGDB.  Note that this
-	  only works on architectures that register known serial ports
-	  early on.  If you say N, you will have to provide, either here
-	  or on the command line, the type (I/O or MMIO), IRQ and
-	  address to use.  If in doubt, say Y.
-
-config KGDB_SERIAL_STATIC
-	bool "Configure KGDB serial parameters statically"
-	depends on KGDB_8250
-	default n
-	help
-	  If you turn this on, you do not have to specify the kgdb
-	  serial paramters via kernel boot arguments.  It also means
-	  that kgdb will configure the serial port on boot.
-
-config KGDB_BAUDRATE
-	int "Debug serial port baud rate"
-	depends on KGDB_SERIAL_STATIC && KGDB_SIMPLE_SERIAL && KGDB_8250
-	default "115200"
-	help
-	  gdb and the kernel stub need to agree on the baud rate to be
-	  used.  Standard rates from 9600 to 115200 are allowed, and this
-	  may be overridden via the commandline.
-
-config KGDB_PORT_NUM
-	int "Serial port number for KGDB"
-	range 0 3
-	depends on KGDB_SERIAL_STATIC && KGDB_SIMPLE_SERIAL && KGDB_8250
-	default "0"
-	help
-	  Pick the port number (0 based) for KGDB to use.
-
-config KGDB_8250_CONF_STRING
-	string "Configuration string for KGDB"
-	depends on KGDB_SERIAL_STATIC && (KGDB_8250 = y) && \
-		!KGDB_SIMPLE_SERIAL && KGDB_8250
-	default "io,2f8,115200,3" if X86
-	help
-	  The format of this string should be <io or mmio>,
-	  <address>,<baud rate>,<irq>.  For example, on an i386 box,
-	  to use the serial port located at 0x2f8, IRQ 3, at 115200 baud
-	  use:  io,2f8,115200,3
-
-config KGDB_ATTACH_WAIT
-	bool "KGDB: Wait for debugger to attach on an unknown exception"
-	depends on KGDB
-	default (KGDB_8250 = y)
-	help
-	  If a panic occurs, or any kind of exception, the kgdb will
-	  stop and wait for a debugger to attach.  This sets the
-	  default behavior for waiting for the debugger to attach.  This
-	  value can also be changed at runtime through
-	  /sys/module/kgdb/parameters/attachwait
-
 config KGDB_CONSOLE
 	bool "KGDB: Console messages through gdb"
 	depends on KGDB
@@ -147,3 +27,36 @@ config KGDB_CONSOLE
 	  to crash, and typically reboot.  For this reason, it is preferable
 	  to use NETCONSOLE in conjunction with KGDBOE instead of
 	  KGDB_CONSOLE.
+
+comment "KGDB I/O drivers"
+	depends on KGDB
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
+	  <io|mmio|mmap>,<address>[/<regshift>],<baud rate>,<irq>
+	    or
+	  ttyS<n>,<baud rate>
+
+	  When built into the kernel, this driver allows debugging of
+	  the early boot process.  Note that, as long as the debugger is
+	  attached via this driver,  the configured serial port cannot be
+	  used by the standard 8250 driver or serial earlyprintk/earlycon.
+
+config KGDBOC
+	tristate "KGDB: Share serial console and kgdb port"
+	depends on KGDB
+	select SERIAL_POLL
+	select MAGIC_SYSRQ
+	help
+	  Share a serial console with kgdb.  The sysrq-g must be used
+	  to break in initially.
Index: b/drivers/serial/kgdboc.c
===================================================================
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -16,8 +16,8 @@
 #include <linux/kernel.h>
 #include <linux/kgdb.h>
 #include <linux/tty.h>
+#include <linux/ctype.h>
 
-#define NOT_CONFIGURED_STRING "not_configured"
 #define MAX_KGDBOC_CONFIG_STR 40
 
 static struct kgdb_io kgdboc_io_ops;
@@ -27,7 +27,7 @@ static int configured = -1;
 
 MODULE_DESCRIPTION("KGDB Console TTY Driver");
 MODULE_LICENSE("GPL");
-static char config[MAX_KGDBOC_CONFIG_STR] = NOT_CONFIGURED_STRING;
+static char config[MAX_KGDBOC_CONFIG_STR];
 static struct kparam_string kps = {
 	.string = config,
 	.maxlen = MAX_KGDBOC_CONFIG_STR,
@@ -40,13 +40,9 @@ static int kgdboc_option_setup(char *opt
 {
 	if (strlen(opt) > MAX_KGDBOC_CONFIG_STR) {
 		printk(KERN_ERR "kgdboc: config string too long\n");
-		strcpy(config, NOT_CONFIGURED_STRING);
-		return 1;
+		return -ENOSPC;
 	}
-
-	/* If we're being given a new configuration, copy it in. */
-	if (opt != config)
-		strcpy(config, opt);
+	strcpy(config, opt);
 	return 0;
 }
 __setup("kgdboc=", kgdboc_option_setup);
@@ -54,18 +50,21 @@ __setup("kgdboc=", kgdboc_option_setup);
 static int configure_kgdboc(void)
 {
 	struct tty_driver *p;
-	int ret = 1;
+	int err;
 	char *str;
 	int tty_line = 0;
 
-	kgdboc_option_setup(config);
-	if (strcmp(config, NOT_CONFIGURED_STRING) == 0)
-		goto err;
+	err = kgdboc_option_setup(config);
+	if (err || !strlen(config) || isspace(config[0]))
+		goto noconfig;
+
+	err = -ENODEV;
 
 	/* Search through the tty devices to look for a match */
+	// FIXME: API violation, at least missing lock protection
 	list_for_each_entry(p, &tty_drivers, tty_drivers) {
-		if (!(p->type == TTY_DRIVER_TYPE_SERIAL &&
-			  strncmp(config, p->name, strlen(p->name)) == 0))
+		if (p->type != TTY_DRIVER_TYPE_SERIAL ||
+		    strncmp(config, p->name, strlen(p->name)) != 0)
 			continue;
 		str = config + strlen(p->name);
 		tty_line = simple_strtoul(str, &str, 10);
@@ -78,29 +77,24 @@ static int configure_kgdboc(void)
 			p->poll_init && !p->poll_init(p, tty_line, str)) {
 			kgdb_tty_driver = p;
 			kgdb_tty_line = tty_line;
-			ret = 0;
+			err = 0;
 			break;
 		}
 	}
-	if (ret) {
-		printk(KERN_ERR "kgdboc: invalid parmater: %s\n", config);
-		printk(KERN_ERR "Usage kgdboc=<serial_device>[,baud]\n");
-		goto err;
-	}
+	if (err)
+		goto noconfig;
 
-	if (kgdb_register_io_module(&kgdboc_io_ops)) {
-		printk(KERN_ERR "KGDB IO registration failed\n");
-		goto err;
-	}
-	configured = 1;
+	err = kgdb_register_io_module(&kgdboc_io_ops);
+	if (err)
+		goto noconfig;
 
-	printk(KERN_INFO "kgdboc: Debugging enabled\n");
+	configured = 1;
 	return 0;
 
-err:
-	strcpy(config, NOT_CONFIGURED_STRING);
+noconfig:
+	config[0] = 0;
 	configured = 0;
-	return -EINVAL;
+	return err;
 
 }
 
@@ -110,16 +104,13 @@ static int init_kgdboc(void)
 	if (configured == 1)
 		return 0;
 
-	if (configure_kgdboc())
-		printk(KERN_INFO "kgdboc: Driver loaded in"
-		" not_configured state\n");
-
-	return 0;
+	return configure_kgdboc();
 }
 
 static void cleanup_kgdboc(void)
 {
-	kgdb_unregister_io_module(&kgdboc_io_ops);
+	if (configured == 1)
+		kgdb_unregister_io_module(&kgdboc_io_ops);
 }
 
 static int kgdboc_get_char(void)
@@ -137,67 +128,30 @@ static void kgdboc_put_char(u8 chr)
 static int param_set_kgdboc_var(const char *kmessage,
 		struct kernel_param *kp)
 {
-	char kmessage_save[MAX_KGDBOC_CONFIG_STR];
-	int msg_len = strlen(kmessage);
-
-	if (msg_len + 1 > MAX_KGDBOC_CONFIG_STR) {
-		printk(KERN_ERR "%s: string doesn't fit in %u chars.\n",
-		       kp->name, MAX_KGDBOC_CONFIG_STR - 1);
+	if (strlen(kmessage) >= MAX_KGDBOC_CONFIG_STR) {
+		printk(KERN_ERR "kgdboc: config string too long\n");
 		return -ENOSPC;
 	}
 
 	/* Only copy in the string if the init function has not run yet */
 	if (configured < 0) {
-		strncpy(config, kmessage, sizeof(config));
+		strcpy(config, kmessage);
 		return 0;
 	}
 
 	if (kgdb_connected) {
 		printk(KERN_ERR "kgdboc: Cannot reconfigure while KGDB is "
 				"connected.\n");
-		return 0;
+		return -EBUSY;
 	}
 
-	/* Start the reconfiguration process by saving the old string */
-	strncpy(kmessage_save, config, sizeof(kmessage_save));
-
-
-	/* Copy in the new param and strip out invalid characters so we
-	 * can optionally specify the MAC.
-	 */
-	strncpy(config, kmessage, sizeof(config));
-	msg_len--;
-	while (msg_len > 0 &&
-			(config[msg_len] < ',' || config[msg_len] > 'f')) {
-		config[msg_len] = '\0';
-		msg_len--;
-	}
-
-	/* Check to see if we are unconfiguring the io module and that it
-	 * was in a fully configured state, as this is the only time that
-	 * netpoll_cleanup should get called
-	 */
-	if (configured == 1 && strcmp(config, NOT_CONFIGURED_STRING) == 0) {
-		printk(KERN_INFO "kgdboc: reverting to unconfigured state\n");
-		cleanup_kgdboc();
-		return 0;
-	} else
-		/* Go and configure with the new params. */
-		configure_kgdboc();
+	strcpy(config, kmessage);
 
 	if (configured == 1)
-		return 0;
+		cleanup_kgdboc();
 
-	/* If the new string was invalid, revert to the previous state, which
-	 * is at a minimum not_configured. */
-	strncpy(config, kmessage_save, sizeof(config));
-	if (strcmp(kmessage_save, NOT_CONFIGURED_STRING) != 0) {
-		printk(KERN_INFO "kgdboc: reverting to prior configuration\n");
-		/* revert back to the original config */
-		strncpy(config, kmessage_save, sizeof(config));
-		configure_kgdboc();
-	}
-	return 0;
+	/* Go and configure with the new params. */
+	return configure_kgdboc();
 }
 
 static void kgdboc_pre_exp_handler(void)
@@ -215,9 +169,9 @@ static void kgdboc_post_exp_handler(void
 }
 
 static struct kgdb_io kgdboc_io_ops = {
+	.name = "kgdboc",
 	.read_char = kgdboc_get_char,
 	.write_char = kgdboc_put_char,
-	.init = init_kgdboc,
 	.pre_exception = kgdboc_pre_exp_handler,
 	.post_exception = kgdboc_post_exp_handler,
 };
@@ -225,4 +179,4 @@ static struct kgdb_io kgdboc_io_ops = {
 module_init(init_kgdboc);
 module_exit(cleanup_kgdboc);
 module_param_call(kgdboc, param_set_kgdboc_var, param_get_string, &kps, 0644);
-MODULE_PARM_DESC(kgdboc, " kgdboc=<serial_device>[,baud]\n");
+MODULE_PARM_DESC(kgdboc, "<serial_device>[,baud]");
