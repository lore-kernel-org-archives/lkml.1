Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbXESCCR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbXESCCR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 22:02:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbXESCCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 22:02:06 -0400
Received: from nwk-ea-fw-1.sun.com ([192.18.42.249]:26498 "EHLO
	nwk-ea-fw-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbXESCCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 22:02:05 -0400
Date: Fri, 18 May 2007 19:00:16 -0700
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH]serial: make early_uart to use early_prarm instead of
 console_initcall
To: Bjorn Helgaas <bjorn.helgaas@hp.com>, Gerd Hoffmann <kraxel@redhat.com>,
       Andi Kleen <ak@suse.de>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Reply-to: Yinghai Lu <Yinghai.Lu@Sun.COM>
Message-id: <200705181900.17101.yinghai.lu@sun.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.8.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH]serial: make early_uart to use early_prarm instead of console_initcall

Make early_uart to use early_param, so uart console can be used earlier.
Make it to be bootconsole with CON_BOOT flag, so can use console handover
feature. and it will switch to corresponding normal serial console automatically.
new command line will be

earlycon=uart,io,0x3f8,9600n8
earlycon=uart,io,0x3f8,9600n8 console=tty0

it will print in very early stage
Early serial console at I/O port 0x3f8 (options '9600n8')
later for console it will print
console handover: boot [uart0] -> real [ttyS0]

Signed-off-by: <yinghai.lu@sun.com>

diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index c84dab0..75459e8 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2367,6 +2367,7 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+	.find_port_for_earlycon = serial8250_find_port_for_earlycon,
 };
 
 static struct uart_8250_port serial8250_ports[UART_NR];
@@ -2533,7 +2534,7 @@ static int __init serial8250_console_init(void)
 }
 console_initcall(serial8250_console_init);
 
-static int __init find_port(struct uart_port *p)
+int __init find_port_serial8250(struct uart_port *p)
 {
 	int line;
 	struct uart_port *port;
@@ -2546,26 +2547,6 @@ static int __init find_port(struct uart_port *p)
 	return -ENODEV;
 }
 
-int __init serial8250_start_console(struct uart_port *port, char *options)
-{
-	int line;
-
-	line = find_port(port);
-	if (line < 0)
-		return -ENODEV;
-
-	add_preferred_console("ttyS", line, options);
-	printk("Adding console on ttyS%d at %s 0x%lx (options '%s')\n",
-		line, port->iotype == UPIO_MEM ? "MMIO" : "I/O port",
-		port->iotype == UPIO_MEM ? (unsigned long) port->mapbase :
-		    (unsigned long) port->iobase, options);
-	if (!(serial8250_console.flags & CON_ENABLED)) {
-		serial8250_console.flags &= ~CON_PRINTBUFFER;
-		register_console(&serial8250_console);
-	}
-	return line;
-}
-
 #define SERIAL8250_CONSOLE	&serial8250_console
 #else
 #define SERIAL8250_CONSOLE	NULL
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index 7e51119..42d4abe 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -17,13 +17,9 @@
  * we locate the device directly by its MMIO or I/O port address.
  *
  * The user can specify the device directly, e.g.,
- *	console=uart,io,0x3f8,9600n8
- *	console=uart,mmio,0xff5e0000,115200n8
- * or platform code can call early_uart_console_init() to set
- * the early UART device.
+ *	earlycon=uart,io,0x3f8,9600n8
+ *	earlycon=uart,mmio,0xff5e0000,115200n8
  *
- * After the normal serial driver starts, we try to locate the
- * matching ttyS device and start a console there.
  */
 
 #include <linux/tty.h>
@@ -32,6 +28,7 @@
 #include <linux/serial_core.h>
 #include <linux/serial_reg.h>
 #include <linux/serial.h>
+#include <linux/serial_8250.h>
 #include <asm/io.h>
 #include <asm/serial.h>
 
@@ -42,7 +39,6 @@ struct early_uart_device {
 };
 
 static struct early_uart_device early_device __initdata;
-static int early_uart_registered __initdata;
 
 static unsigned int __init serial_in(struct uart_port *port, int offset)
 {
@@ -175,6 +171,13 @@ static int __init parse_options(struct early_uart_device *device, char *options)
 	return 0;
 }
 
+static struct console early_uart_console __initdata = {
+	.name	= "uart",
+	.write	= early_uart_write,
+	.flags	= CON_PRINTBUFFER,
+	.index	= -1,
+};
+
 static int __init early_uart_setup(struct console *console, char *options)
 {
 	struct early_uart_device *device = &early_device;
@@ -190,61 +193,60 @@ static int __init early_uart_setup(struct console *console, char *options)
 	return 0;
 }
 
-static struct console early_uart_console __initdata = {
-	.name	= "uart",
-	.write	= early_uart_write,
-	.setup	= early_uart_setup,
-	.flags	= CON_PRINTBUFFER,
-	.index	= -1,
-};
-
-static int __init early_uart_console_init(void)
-{
-	if (!early_uart_registered) {
-		register_console(&early_uart_console);
-		early_uart_registered = 1;
-	}
-	return 0;
-}
-console_initcall(early_uart_console_init);
-
-int __init early_serial_console_init(char *cmdline)
+static int __init setup_early_serial_console(char *cmdline)
 {
 	char *options;
 	int err;
 
-	options = strstr(cmdline, "console=uart,");
+	options = strstr(cmdline, "uart,");
 	if (!options)
 		return -ENODEV;
 
 	options = strchr(cmdline, ',') + 1;
 	if ((err = early_uart_setup(NULL, options)) < 0)
 		return err;
-	return early_uart_console_init();
+
+	early_uart_console.flags |= CON_BOOT;
+	register_console(&early_uart_console);
+
+	/* add one dummy entry in console_cmdline*/ 
+	add_preferred_console("ttyS", 255, early_device.options);
+
+	return 0;
 }
 
-static int __init early_uart_console_switch(void)
+int serial8250_find_port_for_earlycon(void)
 {
 	struct early_uart_device *device = &early_device;
 	struct uart_port *port = &device->port;
-	int mmio, line;
+	int line;
 
-	if (!(early_uart_console.flags & CON_ENABLED))
-		return 0;
+	line = find_port_serial8250(port);
 
-	/* Try to start the normal driver on a matching line.  */
-	mmio = (port->iotype == UPIO_MEM);
-	line = serial8250_start_console(port, device->options);
 	if (line < 0)
-		printk("No ttyS device at %s 0x%lx for console\n",
-			mmio ? "MMIO" : "I/O port",
-			mmio ? port->mapbase :
-			    (unsigned long) port->iobase);
+		return -ENODEV;
+	
+	/* update the dummy entry to what we want console type */
+	update_console_cmdline_console_index("ttyS", 255, line);
+
+	return 0;
+	
+}
+
+early_param("earlycon", setup_early_serial_console);
 
-	unregister_console(&early_uart_console);
-	if (mmio)
+static int __init early_uart_console_post(void)
+{
+	struct early_uart_device *device = &early_device;
+	struct uart_port *port = &device->port;
+
+	if (!(early_uart_console.flags & CON_ENABLED))
+		return 0;
+
+	if (port->iotype == UPIO_MEM)
 		iounmap(port->membase);
 
 	return 0;
 }
-late_initcall(early_uart_console_switch);
+
+late_initcall(early_uart_console_post);
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 315ea99..fc58473 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -62,6 +62,12 @@ config SERIAL_8250_CONSOLE
 	  kernel will automatically use the first serial line, /dev/ttyS0, as
 	  system console.
 
+	  you can set that using a kernel command line option such as
+	  "earlycon=uart,io,0x3f8,9600n8" or 
+	  "earlycon=uart,mem,0xfe000008,115200n8". 
+	  and it will switch to normal serial console when correponding port is 
+	  ready.
+
 	  If unsure, say N.
 
 config SERIAL_8250_GSC
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 326020f..956d435 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2303,8 +2303,11 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *port)
 	 * It may be that the port was not available.
 	 */
 	if (port->type != PORT_UNKNOWN &&
-	    port->cons && !(port->cons->flags & CON_ENABLED))
+	    port->cons && !(port->cons->flags & CON_ENABLED)) {
+		if(port->ops && port->ops->find_port_for_earlycon) 
+			port->ops->find_port_for_earlycon();
 		register_console(port->cons);
+	}
 
 	/*
 	 * Ensure UPF_DEAD is not set.
diff --git a/include/linux/console.h b/include/linux/console.h
index 62ef6e1..4cb7749 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -107,6 +107,7 @@ struct console {
 };
 
 extern int add_preferred_console(char *name, int idx, char *options);
+extern int update_console_cmdline_console_index(char *name, int idx_old, int idx_new);
 extern void register_console(struct console *);
 extern int unregister_console(struct console *);
 extern struct console *console_drivers;
diff --git a/include/linux/serial.h b/include/linux/serial.h
index 33fc8cb..deb7143 100644
--- a/include/linux/serial.h
+++ b/include/linux/serial.h
@@ -177,11 +177,5 @@ struct serial_icounter_struct {
 #ifdef __KERNEL__
 #include <linux/compiler.h>
 
-/* Allow architectures to override entries in serial8250_ports[] at run time: */
-struct uart_port;	/* forward declaration */
-extern int early_serial_setup(struct uart_port *port);
-extern int early_serial_console_init(char *options);
-extern int serial8250_start_console(struct uart_port *port, char *options);
-
 #endif /* __KERNEL__ */
 #endif /* _LINUX_SERIAL_H */
diff --git a/include/linux/serial_8250.h b/include/linux/serial_8250.h
index 71310d8..0d79fc5 100644
--- a/include/linux/serial_8250.h
+++ b/include/linux/serial_8250.h
@@ -60,4 +60,7 @@ void serial8250_unregister_port(int line);
 void serial8250_suspend_port(int line);
 void serial8250_resume_port(int line);
 
+extern int find_port_serial8250(struct uart_port *p);
+extern int serial8250_find_port_for_earlycon(void);
+
 #endif
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a3ac4c8..b74fa4a 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -199,6 +199,11 @@ struct uart_ops {
 	void		(*config_port)(struct uart_port *, int);
 	int		(*verify_port)(struct uart_port *, struct serial_struct *);
 	int		(*ioctl)(struct uart_port *, unsigned int, unsigned long);
+	
+	/*
+	 * for earlycon to console switch
+	 */
+	int		(*find_port_for_earlycon)(void);
 };
 
 #define UART_CONFIG_TYPE	(1 << 0)
diff --git a/init/main.c b/init/main.c
diff --git a/kernel/printk.c b/kernel/printk.c
index 0bbdeac..253c0f7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -726,6 +726,21 @@ int __init add_preferred_console(char *name, int idx, char *options)
 	return 0;
 }
 
+int __init update_console_cmdline_console_index(char *name, int idx_old, int idx_new)
+{
+	int i;
+
+	for(i = 0; i < MAX_CMDLINECONSOLES && console_cmdline[i].name[0]; i++)
+		if (strcmp(console_cmdline[i].name, name) == 0 &&
+			  console_cmdline[i].index == idx_old) {
+			  	console_cmdline[i].index = idx_new;
+				return 0;
+		}
+
+	return 0;
+}
+	
+
 #ifndef CONFIG_DISABLE_CONSOLE_SUSPEND
 /**
  * suspend_console - suspend the console subsystem
