Return-Path: <linux-kernel-owner+w=401wt.eu-S1762574AbYA2Xr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762574AbYA2Xr4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:47:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYA2Xrq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:47:46 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:40905 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbYA2Xrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:47:45 -0500
Message-ID: <479FBB1E.4000402@web.de>
Date: Wed, 30 Jan 2008 00:47:42 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH 5/5] KGDB-8250: more refactorings
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+1XP4iXML9b2/SN3vnLfpmP+syOn+6ON+Y1gIq
	TluyJXvgXsxLvl8ywGDckj9oqnxsZSKF1JKFbEQINpukkIbsLR
	RLan6hk0g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here comes the rest of 8250_kgdb refactorings (the root of the previous
patches - before I realized that there was more to do...). It
basically...

 - reorders functions to avoid prototypes (as far as possible)
 - removes a redundant module parameter help (=>modinfo)
 - fixes some minor style issues

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 drivers/serial/8250_kgdb.c |  452 +++++++++++++++++++++------------------------
 1 file changed, 219 insertions(+), 233 deletions(-)

Index: b/drivers/serial/8250_kgdb.c
===================================================================
--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -32,19 +32,27 @@
 
 MODULE_DESCRIPTION("KGDB driver for the 8250");
 MODULE_LICENSE("GPL");
-/* These will conflict with early_param otherwise. */
+
 #ifdef CONFIG_KGDB_8250_MODULE
-static char config[256];
-module_param_string(kgdb8250, config, 256, 0);
-MODULE_PARM_DESC(kgdb8250,
-		 " kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>\n");
-static struct kgdb_io local_kgdb_io_ops;
+/* If built-in, we use early_param instead. */
+static char config_string[256];
+module_param_string(kgdb8250, config_string, sizeof(config_string), 0);
+MODULE_PARM_DESC(kgdb8250, "<io or mmio>,<address>,<baud rate>,<irq> or "
+			   "<port #>,<baud rate>");
+
+static struct kgdb_io kgdb8250_io_ops;
+
 #else  /* !CONFIG_KGDB_8250_MODULE */
 static int params_evaluated;
 #endif /* !CONFIG_KGDB_8250_MODULE */
 
-/* Speed of the UART. */
-static int kgdb8250_baud;
+/* Our internal table of UARTS. */
+#define UART_NR	CONFIG_SERIAL_8250_NR_UARTS
+static struct uart_port kgdb8250_ports[UART_NR];
+static struct uart_port *current_port;
+
+static int kgdb8250_baud;	/* Speed of the UART. */
+static void *kgdb8250_addr;	/* Base of the UART. */
 
 /* Flag for if we need to call request_mem_region */
 static int kgdb8250_needs_request_mem_region;
@@ -53,19 +61,7 @@ static char kgdb8250_buf[GDB_BUF_SIZE];
 static atomic_t kgdb8250_buf_in_cnt;
 static int kgdb8250_buf_out_inx;
 
-/* Our internal table of UARTS. */
-#define UART_NR	CONFIG_SERIAL_8250_NR_UARTS
-static struct uart_port kgdb8250_ports[UART_NR];
-
-static struct uart_port *current_port;
-
-/* Base of the UART. */
-static void *kgdb8250_addr;
-
-/* Forward declarations. */
 static int kgdb8250_uart_init(void);
-static int __init kgdb_init_io(void);
-static int __init kgdb8250_opt(char *str);
 
 /* These are much shorter calls to ioread8/iowrite8 that take into
  * account our shifts, etc. */
@@ -141,8 +137,7 @@ static int kgdb_get_debug_char(void)
  * line we're in charge of.  If this is true, schedule a breakpoint and
  * return.
  */
-static irqreturn_t
-kgdb8250_interrupt(int irq, void *dev_id)
+static irqreturn_t kgdb8250_interrupt(int irq, void *dev_id)
 {
 	if (!(kgdb_ioread(UART_IIR) & UART_IIR_RDI))
 		return IRQ_NONE;
@@ -158,89 +153,6 @@ kgdb8250_interrupt(int irq, void *dev_id
 }
 
 /*
- *  Initializes the UART.
- *  Returns:
- *	0 on success, 1 on failure.
- */
-static int kgdb8250_uart_init(void)
-{
-	unsigned int ier;
-	unsigned int base_baud = current_port->uartclk ?
-		current_port->uartclk / 16 : BASE_BAUD;
-
-	/* test uart existance */
-	if (kgdb_ioread(UART_LSR) == 0xff)
-		return -1;
-
-	/* disable interrupts */
-	kgdb_iowrite(0, UART_IER);
-
-#if defined(CONFIG_ARCH_OMAP1510)
-	/* Workaround to enable 115200 baud on OMAP1510 internal ports */
-	if (cpu_is_omap1510() && is_omap_port((void *)kgdb8250_addr)) {
-		if (kgdb8250_baud == 115200) {
-			base_baud = 1;
-			kgdb8250_baud = 1;
-			kgdb_iowrite(1, UART_OMAP_OSC_12M_SEL);
-		} else
-			kgdb_iowrite(0, UART_OMAP_OSC_12M_SEL);
-	}
-#endif
-	/* set DLAB */
-	kgdb_iowrite(UART_LCR_DLAB, UART_LCR);
-
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
-
-	/*
-	 * Borrowed from the main 8250 driver.
-	 * Try writing and reading the UART_IER_UUE bit (b6).
-	 * If it works, this is probably one of the Xscale platform's
-	 * internal UARTs.
-	 * We're going to explicitly set the UUE bit to 0 before
-	 * trying to write and read a 1 just to make sure it's not
-	 * already a 1 and maybe locked there before we even start start.
-	 */
-	ier = kgdb_ioread(UART_IER);
-	kgdb_iowrite(ier & ~UART_IER_UUE, UART_IER);
-	if (!(kgdb_ioread(UART_IER) & UART_IER_UUE)) {
-		/*
-		 * OK it's in a known zero state, try writing and reading
-		 * without disturbing the current state of the other bits.
-		 */
-		kgdb_iowrite(ier | UART_IER_UUE, UART_IER);
-		if (kgdb_ioread(UART_IER) & UART_IER_UUE)
-			/*
-			 * It's an Xscale.
-			 */
-			ier |= UART_IER_UUE | UART_IER_RTOIE;
-	}
-	kgdb_iowrite(ier, UART_IER);
-	return 0;
-}
-
-/*
  * Copy the old serial_state table to our uart_port table if we haven't
  * had values specifically configured in.  We need to make sure this only
  * happens once.
@@ -274,6 +186,91 @@ static void kgdb8250_copy_rs_table(void)
 }
 
 /*
+ * Syntax for this cmdline option is:
+ *  kgdb8250=<io or mmio>,<address>,<baud rate>,<irq> or
+ *  kgdb8250=<port #>,<baud rate>
+ */
+static int __init kgdb8250_opt(char *str)
+{
+	/* Give us the basic table of uarts. */
+	kgdb8250_copy_rs_table();
+
+	/* If we overwrite, we'll fill out and use the first slot. */
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
+	} else if (*str >= '0' || *str <= '9') {
+		int line = *str - '0';
+		/* UARTS in the list from 0 -> 9 */
+		if (line >= UART_NR)
+			goto errout;
+		current_port = &kgdb8250_ports[line];
+		if (serial8250_get_port_def(current_port, line) < 0 &&
+		    !current_port->iobase && !current_port->membase)
+			goto errout;
+		str++;
+		if (*str != ',')
+			goto errout;
+		str++;
+		kgdb8250_baud = simple_strtoul(str, &str, 10);
+		if (!kgdb8250_baud)
+			goto errout;
+		if (*str == ',')
+			goto errout;
+		goto finish;
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
+finish:
+#ifdef CONFIG_KGDB_8250
+	params_evaluated = 1;
+#endif
+	return 0;
+
+errout:
+	return 1;
+}
+
+/*
  * Hookup our IRQ line now that it is safe to do so, after we grab any
  * memory regions we might need to.  If we haven't been initialized yet,
  * go ahead and copy the old_rs_table in.
@@ -286,7 +283,8 @@ static void __init kgdb8250_late_init(vo
 
 	/* Now reinit the port as the above has disabled things. */
 	kgdb8250_uart_init();
-#endif
+#endif /* CONFIG_SERIAL_8250 || CONFIG_SERIAL_8250_MODULE */
+
 	/* We may need to call request_mem_region() first. */
 	if (kgdb8250_needs_request_mem_region)
 		request_mem_region(current_port->mapbase,
@@ -302,16 +300,8 @@ static __init int kgdb_init_io(void)
 	/* We're either a module and parse a config string, or we have a
 	 * semi-static config. */
 #ifdef CONFIG_KGDB_8250_MODULE
-	if (strlen(config)) {
-		if (kgdb8250_opt(config))
-			return -EINVAL;
-	} else {
-		printk(KERN_ERR "kgdb8250: argument error, usage: "
-		       "kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>\n");
-		printk(KERN_ERR "kgdb8250: alt usage: "
-		       "kgdb8250=<line #>,<baud rate>\n");
+	if (strlen(config_string) || kgdb8250_opt(config_string))
 		return -EINVAL;
-	}
 #else  /* !CONFIG_KGDB_8250_MODULE */
 	if (!params_evaluated) {
 #ifdef CONFIG_KGDB_SIMPLE_SERIAL
@@ -356,49 +346,113 @@ static __init int kgdb_init_io(void)
 		printk(KERN_ERR "kgdb8250: init failed\n");
 		return -EIO;
 	}
+
 #ifdef CONFIG_KGDB_8250_MODULE
-	/* Attach the kgdb irq. When this is built into the kernel, it
+	/*
+	 * Attach the kgdb irq. When this is built into the kernel, it
 	 * is called as a part of late_init sequence.
 	 */
 	kgdb8250_late_init();
-	if (kgdb_register_io_module(&local_kgdb_io_ops))
+	if (kgdb_register_io_module(&kgdb8250_io_ops))
 		return -EINVAL;
 
 	printk(KERN_INFO "kgdb8250: debugging enabled\n");
-#endif				/* CONFIG_KGD_8250_MODULE */
+#endif 	/* CONFIG_KGD_8250_MODULE */
 
 	return 0;
 }
 
-#ifdef CONFIG_KGDB_8250_MODULE
-/* If it is a module the kgdb_io_ops should be a static which
- * is passed to the KGDB I/O initialization
+/*
+ *  Initializes the UART.
+ *  Returns:
+ *	0 on success, 1 on failure.
  */
-static void kgdb8250_pre_exception_handler(void);
-static void kgdb8250_post_exception_handler(void);
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
+#ifdef CONFIG_ARCH_OMAP1510
+	/* Workaround to enable 115200 baud on OMAP1510 internal ports */
+	if (cpu_is_omap1510() && is_omap_port((void *)kgdb8250_addr)) {
+		if (kgdb8250_baud == 115200) {
+			base_baud = 1;
+			kgdb8250_baud = 1;
+			kgdb_iowrite(1, UART_OMAP_OSC_12M_SEL);
+		} else
+			kgdb_iowrite(0, UART_OMAP_OSC_12M_SEL);
+	}
+#endif /* CONFIG_ARCH_OMAP1510 */
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
 
 /**
- * 	kgdb8250_add_platform_port - Define a serial port for use with KGDB
- * 	@i: The index of the port being added
- * 	@p: The &struct plat_serial8250_port describing the port
+ * kgdb8250_add_platform_port - Define a serial port for use with KGDB
+ * @i: The index of the port being added
+ * @p: The &struct plat_serial8250_port describing the port
  *
- * 	On platforms where we must register the serial device
- * 	dynamically, this is the best option if a platform normally
- * 	handles uart setup with an array of &struct plat_serial8250_port.
+ * On platforms where we must register the serial device
+ * dynamically, this is the best option if a platform normally
+ * handles uart setup with an array of &struct plat_serial8250_port.
  */
 void __init kgdb8250_add_platform_port(int i, struct plat_serial8250_port *p)
 {
@@ -415,90 +469,6 @@ void __init kgdb8250_add_platform_port(i
 	kgdb8250_ports[i].mapbase = p->mapbase;
 }
 
-/*
- * Syntax for this cmdline option is:
- * kgdb8250=<io or mmio>,<address>,<baud rate>,<irq>"
- */
-static int __init kgdb8250_opt(char *str)
-{
-	/* Give us the basic table of uarts. */
-	kgdb8250_copy_rs_table();
-
-	/* If we overwrite, we'll fill out and use the first slot. */
-	current_port = &kgdb8250_ports[0];
-
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
-		int line = *str - '0';
-		/* UARTS in the list from 0 -> 9 */
-		if (line >= UART_NR)
-			goto errout;
-		current_port = &kgdb8250_ports[line];
-		if (serial8250_get_port_def(current_port, line) < 0 &&
-		    !current_port->iobase && !current_port->membase)
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
-
-	if (*str != ',')
-		goto errout;
-	str++;
-
-	if (current_port->iotype == UPIO_PORT)
-		current_port->iobase = simple_strtoul(str, &str, 16);
-	else {
-		if (current_port->flags & UPF_IOREMAP)
-			current_port->mapbase =
-				(unsigned long) simple_strtoul(str, &str, 16);
-		else
-			current_port->membase =
-				(void *) simple_strtoul(str, &str, 16);
-	}
-
-	if (*str != ',')
-		goto errout;
-	str++;
-
-	kgdb8250_baud = simple_strtoul(str, &str, 10);
-	if (!kgdb8250_baud)
-		goto errout;
-
-	if (*str != ',')
-		goto errout;
-	str++;
-
-	current_port->irq = simple_strtoul(str, &str, 10);
-
-finish:
-#ifdef CONFIG_KGDB_8250
-	params_evaluated = 1;
-#endif
-	return 0;
-
-errout:
-	return 1;
-}
-
 #ifdef CONFIG_KGDB_8250_MODULE
 static void kgdb8250_pre_exception_handler(void)
 {
@@ -512,19 +482,25 @@ static void kgdb8250_post_exception_hand
 		module_put(THIS_MODULE);
 }
 
+static struct kgdb_io kgdb8250_io_ops = {
+	.read_char = kgdb_get_debug_char,
+	.write_char = kgdb_put_debug_char,
+	.init = kgdb_init_io,
+	.late_init = kgdb8250_late_init,
+	.pre_exception = kgdb8250_pre_exception_handler,
+	.post_exception = kgdb8250_post_exception_handler,
+};
+
 static void cleanup_kgdb8250(void)
 {
-	kgdb_unregister_io_module(&local_kgdb_io_ops);
+	kgdb_unregister_io_module(&kgdb8250_io_ops);
 
-	/* Clean up the irq and memory */
 	free_irq(current_port->irq, current_port);
 
 	if (kgdb8250_needs_request_mem_region)
 		release_mem_region(current_port->mapbase,
 				   8 << current_port->regshift);
-	/* Hook up the serial port back to what it was previously
-	 * hooked up to.
-	 */
+
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* Give the port back to the 8250 driver. */
 	serial8250_register_port(current_port);
@@ -533,6 +509,16 @@ static void cleanup_kgdb8250(void)
 
 module_init(kgdb_init_io);
 module_exit(cleanup_kgdb8250);
-#else				/* ! CONFIG_KGDB_8250_MODULE */
+
+#else  /* !CONFIG_KGDB_8250_MODULE */
+
+/* This is the only I/O driver, thus it defines the global kgdb_io_ops. */
+struct kgdb_io kgdb_io_ops = {
+	.read_char = kgdb_get_debug_char,
+	.write_char = kgdb_put_debug_char,
+	.init = kgdb_init_io,
+	.late_init = kgdb8250_late_init,
+};
+
 early_param("kgdb8250", kgdb8250_opt);
-#endif				/* ! CONFIG_KGDB_8250_MODULE */
+#endif /* !CONFIG_KGDB_8250_MODULE */
