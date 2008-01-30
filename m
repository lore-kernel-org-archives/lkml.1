Return-Path: <linux-kernel-owner+w=401wt.eu-S1753813AbYA3AcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813AbYA3AcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 19:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750961AbYA3AcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 19:32:01 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:49802 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750758AbYA3Ab7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 19:31:59 -0500
Message-ID: <479FC57D.5030104@web.de>
Date: Wed, 30 Jan 2008 01:31:57 +0100
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kgdb-bugreport@lists.sourceforge.net
Subject: Re: [PATCH 4/5] KGDB-8250: refactor configuration
References: <479FBAE8.3070809@web.de>
In-Reply-To: <479FBAE8.3070809@web.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Provags-ID: V01U2FsdGVkX180N0IMQPml6ZLUO5asUao9TU1GjkhcjPlthCMq
	jZlUVsJKvOA/6W120Est4Y363E6yZy7iesZnWfJYFGKTMSNPU7
	/CJbHYo6Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, previous version was missing some __init[data] attributes which
were dropped in an intermediate stage. Here comes an updated patch:

<---snip--->

This major refactoring of the quite complex kgdb8250 configuration does
the following:

 - ensures that static configurations according to SERIAL_PORT_DFNS are
   always loaded first
 - tries to pull more accurate configuration via serial8250_get_port_def
   if simple-config is used
 - detects empty/invalid simple-configs
 - enforces KGDB_PORT_NUM <= SERIAL_8250_NR_UARTS at kconfig level
 - removes kgdb8250_add_port and its hook in serial_core (calling
   serial8250_get_port_def in demand should provide us the same
   information)

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>

---
 drivers/serial/8250.c        |   47 ++++++++++++----------------
 drivers/serial/8250_kgdb.c   |   70 +++++++++++++------------------------------
 drivers/serial/serial_core.c |    7 ----
 include/linux/kgdb.h         |    1 
 lib/Kconfig.kgdb             |   16 ++++-----
 5 files changed, 51 insertions(+), 90 deletions(-)

Index: b/drivers/serial/8250_kgdb.c
===================================================================
--- a/drivers/serial/8250_kgdb.c
+++ b/drivers/serial/8250_kgdb.c
@@ -53,16 +53,6 @@ static char kgdb8250_buf[GDB_BUF_SIZE];
 static atomic_t kgdb8250_buf_in_cnt;
 static int kgdb8250_buf_out_inx;
 
-/* Old-style serial definitions, if existant, and a counter. */
-#ifdef CONFIG_KGDB_SIMPLE_SERIAL
-static int should_copy_rs_table = 1;
-static struct serial_state old_rs_table[] __initdata = {
-#ifdef SERIAL_PORT_DFNS
-	SERIAL_PORT_DFNS
-#endif
-};
-#endif
-
 /* Our internal table of UARTS. */
 #define UART_NR	CONFIG_SERIAL_8250_NR_UARTS
 static struct uart_port kgdb8250_ports[UART_NR];
@@ -258,9 +248,15 @@ static int kgdb8250_uart_init(void)
 static void __init kgdb8250_copy_rs_table(void)
 {
 #ifdef CONFIG_KGDB_SIMPLE_SERIAL
+	static struct serial_state old_rs_table[] __initdata = {
+#ifdef SERIAL_PORT_DFNS
+		SERIAL_PORT_DFNS
+#endif
+	};
+	static int rs_table_copied __initdata;
 	int i;
 
-	if (!should_copy_rs_table)
+	if (rs_table_copied)
 		return;
 
 	for (i = 0; i < ARRAY_SIZE(old_rs_table); i++) {
@@ -273,8 +269,8 @@ static void __init kgdb8250_copy_rs_tabl
 		kgdb8250_ports[i].line = i;
 	}
 
-	should_copy_rs_table = 0;
-#endif
+	rs_table_copied = 1;
+#endif /* CONFIG_KGDB_SIMPLE_SERIAL */
 }
 
 /*
@@ -284,9 +280,6 @@ static void __init kgdb8250_copy_rs_tabl
  */
 static void __init kgdb8250_late_init(void)
 {
-	/* Try and copy the old_rs_table. */
-	kgdb8250_copy_rs_table();
-
 #if defined(CONFIG_SERIAL_8250) || defined(CONFIG_SERIAL_8250_MODULE)
 	/* Take the port away from the main driver. */
 	serial8250_unregister_by_port(current_port);
@@ -306,9 +299,6 @@ static void __init kgdb8250_late_init(vo
 
 static __init int kgdb_init_io(void)
 {
-	/* Give us the basic table of uarts. */
-	kgdb8250_copy_rs_table();
-
 	/* We're either a module and parse a config string, or we have a
 	 * semi-static config. */
 #ifdef CONFIG_KGDB_8250_MODULE
@@ -325,8 +315,15 @@ static __init int kgdb_init_io(void)
 #else  /* !CONFIG_KGDB_8250_MODULE */
 	if (!params_evaluated) {
 #ifdef CONFIG_KGDB_SIMPLE_SERIAL
+		kgdb8250_copy_rs_table();
+
 		kgdb8250_baud = CONFIG_KGDB_BAUDRATE;
 		current_port = &kgdb8250_ports[CONFIG_KGDB_PORT_NUM];
+
+		if (serial8250_get_port_def(current_port,
+					    CONFIG_KGDB_PORT_NUM) < 0 &&
+		    !current_port->iobase && !current_port->membase)
+			return -EINVAL;
 #else /* !CONFIG_KGDB_SIMPLE_SERIAL */
 		if (kgdb8250_opt(CONFIG_KGDB_8250_CONF_STRING))
 			return -EINVAL;
@@ -395,29 +392,6 @@ struct kgdb_io kgdb_io_ops = {
 };
 
 /**
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
-#ifdef CONFIG_KGDB_SIMPLE_SERIAL
-	if (should_copy_rs_table)
-		printk(KERN_ERR "8250_kgdb: warning will over write serial"
-			   " port definitions at kgdb init time\n");
-#endif
-
-	/* Copy the whole thing over. */
-	if (current_port != &kgdb8250_ports[i])
-		memcpy(&kgdb8250_ports[i], serial_req,
-		sizeof(struct uart_port));
-}
-
-/**
  * 	kgdb8250_add_platform_port - Define a serial port for use with KGDB
  * 	@i: The index of the port being added
  * 	@p: The &struct plat_serial8250_port describing the port
@@ -447,7 +421,10 @@ void __init kgdb8250_add_platform_port(i
  */
 static int __init kgdb8250_opt(char *str)
 {
-	/* We'll fill out and use the first slot. */
+	/* Give us the basic table of uarts. */
+	kgdb8250_copy_rs_table();
+
+	/* If we overwrite, we'll fill out and use the first slot. */
 	current_port = &kgdb8250_ports[0];
 
 	if (!strncmp(str, "io", 2)) {
@@ -467,7 +444,8 @@ static int __init kgdb8250_opt(char *str
 		if (line >= UART_NR)
 			goto errout;
 		current_port = &kgdb8250_ports[line];
-		if (serial8250_get_port_def(current_port, line))
+		if (serial8250_get_port_def(current_port, line) < 0 &&
+		    !current_port->iobase && !current_port->membase)
 			goto errout;
 		str++;
 		if (*str != ',')
@@ -512,16 +490,12 @@ static int __init kgdb8250_opt(char *str
 	current_port->irq = simple_strtoul(str, &str, 10);
 
 finish:
-#ifdef CONFIG_KGDB_SIMPLE_SERIAL
-	should_copy_rs_table = 0;
-#endif
 #ifdef CONFIG_KGDB_8250
 	params_evaluated = 1;
 #endif
 	return 0;
 
 errout:
-	printk(KERN_ERR "Invalid syntax for option kgdb8250=\n");
 	return 1;
 }
 
Index: b/drivers/serial/8250.c
===================================================================
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2860,37 +2860,32 @@ void serial8250_unregister_port(int line
 EXPORT_SYMBOL(serial8250_unregister_port);
 
 /**
- *  serial8250_get_port_def - Get port definition for a specific line
- *  @port: generic uart_port output for a specific serial line
- *  @line: specific serial line index
+ *	serial8250_get_port_def - Get port definition for a specific line
+ *	@port: generic uart_port output for a specific serial line
+ *	@line: specific serial line index
  *
- *  Return 0 if the port existed
- *  Return 1 on failure
+ *	Returns 0 on success, -ENODEV if the port does not exist.
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
 }
-EXPORT_SYMBOL(serial8250_get_port_def);
+EXPORT_SYMBOL_GPL(serial8250_get_port_def);
 
 /**
  *	serial8250_unregister_by_port - remove a 16x50 serial port
@@ -2909,7 +2904,7 @@ void serial8250_unregister_by_port(struc
 	if (uart)
 		serial8250_unregister_port(uart->port.line);
 }
-EXPORT_SYMBOL(serial8250_unregister_by_port);
+EXPORT_SYMBOL_GPL(serial8250_unregister_by_port);
 
 static int __init serial8250_init(void)
 {
Index: b/drivers/serial/serial_core.c
===================================================================
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -33,7 +33,6 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
-#include <linux/kgdb.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -2370,12 +2369,6 @@ int uart_add_one_port(struct uart_driver
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
@@ -271,7 +271,6 @@ extern struct kgdb_arch arch_kgdb_ops;
 int kgdb_register_io_module(struct kgdb_io *local_kgdb_io_ops);
 void kgdb_unregister_io_module(struct kgdb_io *local_kgdb_io_ops);
 
-void kgdb8250_add_port(int i, struct uart_port *serial_req);
 void __init kgdb8250_add_platform_port(int i,
 	struct plat_serial8250_port *serial_req);
 
Index: b/lib/Kconfig.kgdb
===================================================================
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -36,6 +36,14 @@ config KGDB_SIMPLE_SERIAL
 	  or on the command line, the type (I/O or MMIO), IRQ and
 	  address to use.  If in doubt, say Y.
 
+config KGDB_PORT_NUM
+	int "Serial port number for KGDB"
+	range 0 SERIAL_8250_NR_UARTS
+	depends on KGDB_SIMPLE_SERIAL
+	default "1"
+	help
+	  Pick the port number (0 based) for KGDB to use.
+
 config KGDB_BAUDRATE
 	int "Debug serial port baud rate"
 	depends on KGDB_SIMPLE_SERIAL
@@ -45,14 +53,6 @@ config KGDB_BAUDRATE
 	  used.  Standard rates from 9600 to 115200 are allowed, and this
 	  may be overridden via the commandline.
 
-config KGDB_PORT_NUM
-	int "Serial port number for KGDB"
-	range 0 3
-	depends on KGDB_SIMPLE_SERIAL
-	default "1"
-	help
-	  Pick the port number (0 based) for KGDB to use.
-
 config KGDB_8250_CONF_STRING
 	string "Configuration string for KGDB"
 	depends on (KGDB_8250 = y) && !KGDB_SIMPLE_SERIAL
