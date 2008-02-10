Return-Path: <linux-kernel-owner+w=401wt.eu-S1755260AbYBJHO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbYBJHO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 02:14:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757519AbYBJHOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 02:14:09 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39713 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757422AbYBJHN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 02:13:57 -0500
Date: Sun, 10 Feb 2008 08:13:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [4/6] consoles: polling support, kgdboc
Message-ID: <20080210071339.GD3851@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Kiszka <jan.kiszka@siemens.com>

polled console handling support, to access a console in an irq-less
way while in debug or irq context.

absolutely zero impact as long as CONFIG_CONSOLE_POLL is disabled.
(which is the default)

kgdb over consoles support from:

   Jason Wessel <jason.wessel@windriver.com>

[ mingo@elte.hu: redesign, splitups, cleanups. ]

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
---
 drivers/char/tty_io.c        |   47 ++++++++++++
 drivers/serial/8250.c        |   62 ++++++++++++++++
 drivers/serial/Kconfig       |    3 
 drivers/serial/Makefile      |    1 
 drivers/serial/kgdboc.c      |  164 +++++++++++++++++++++++++++++++++++++++++++
 drivers/serial/serial_core.c |   67 +++++++++++++++++
 include/linux/serial_core.h  |    4 +
 include/linux/tty_driver.h   |   12 +++
 8 files changed, 359 insertions(+), 1 deletion(-)

Index: linux-kgdb.q/drivers/char/tty_io.c
===================================================================
--- linux-kgdb.q.orig/drivers/char/tty_io.c
+++ linux-kgdb.q/drivers/char/tty_io.c
@@ -1155,6 +1155,48 @@ static struct tty_driver *get_tty_driver
 	return NULL;
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+
+/**
+ *	tty_find_polling_driver	-	find device of a polled tty
+ *	@name: name string to match
+ *	@line: pointer to resulting tty line nr
+ *
+ *	This routine returns a tty driver structure, given a name
+ *	and the condition that the tty driver is capable of polled
+ *	operation.
+ */
+struct tty_driver *tty_find_polling_driver(char *name, int *line)
+{
+	struct tty_driver *p, *res = NULL;
+	int tty_line = 0;
+	char *str;
+
+	mutex_lock(&tty_mutex);
+	/* Search through the tty devices to look for a match */
+	list_for_each_entry(p, &tty_drivers, tty_drivers) {
+		str = name + strlen(p->name);
+		tty_line = simple_strtoul(str, &str, 10);
+		if (*str == ',')
+			str++;
+		if (*str == '\0')
+			str = 0;
+
+		if (tty_line >= 0 && tty_line <= p->num && p->poll_init &&
+				!p->poll_init(p, tty_line, str)) {
+
+			res = p;
+			*line = tty_line;
+			break;
+		}
+	}
+	mutex_unlock(&tty_mutex);
+
+	return res;
+}
+EXPORT_SYMBOL_GPL(tty_find_polling_driver);
+#endif
+
 /**
  *	tty_check_change	-	check for POSIX terminal changes
  *	@tty: tty to check
@@ -3850,6 +3892,11 @@ void tty_set_operations(struct tty_drive
 	driver->write_proc = op->write_proc;
 	driver->tiocmget = op->tiocmget;
 	driver->tiocmset = op->tiocmset;
+#ifdef CONFIG_CONSOLE_POLL
+	driver->poll_init = op->poll_init;
+	driver->poll_get_char = op->poll_get_char;
+	driver->poll_put_char = op->poll_put_char;
+#endif
 }
 
 
Index: linux-kgdb.q/drivers/serial/8250.c
===================================================================
--- linux-kgdb.q.orig/drivers/serial/8250.c
+++ linux-kgdb.q/drivers/serial/8250.c
@@ -1740,6 +1740,64 @@ static inline void wait_for_xmitr(struct
 	}
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+/*
+ * Console polling routines for writing and reading from the uart while
+ * in an interrupt or debug context.
+ */
+
+static int serial8250_get_poll_char(struct uart_port *port)
+{
+	struct uart_8250_port *up = (struct uart_8250_port *)port;
+	unsigned char lsr = serial_inp(up, UART_LSR);
+
+	while (!(lsr & UART_LSR_DR))
+		lsr = serial_inp(up, UART_LSR);
+
+	return serial_inp(up, UART_RX);
+}
+
+
+static void serial8250_put_poll_char(struct uart_port *port,
+			 unsigned char c)
+{
+	unsigned int ier;
+	struct uart_8250_port *up = (struct uart_8250_port *)port;
+
+	/*
+	 *	First save the IER then disable the interrupts
+	 */
+	ier = serial_in(up, UART_IER);
+#ifdef UART_CAP_UUE
+	if (up->capabilities & UART_CAP_UUE)
+#else
+	if (up->port.type == PORT_XSCALE)
+#endif
+		serial_out(up, UART_IER, UART_IER_UUE);
+	else
+		serial_out(up, UART_IER, 0);
+
+	wait_for_xmitr(up, BOTH_EMPTY);
+	/*
+	 *	Send the character out.
+	 *	If a LF, also do CR...
+	 */
+	serial_out(up, UART_TX, c);
+	if (c == 10) {
+		wait_for_xmitr(up, BOTH_EMPTY);
+		serial_out(up, UART_TX, 13);
+	}
+
+	/*
+	 *	Finally, wait for transmitter to become empty
+	 *	and restore the IER
+	 */
+	wait_for_xmitr(up, BOTH_EMPTY);
+	serial_out(up, UART_IER, ier);
+}
+
+#endif /* CONFIG_CONSOLE_POLL */
+
 static int serial8250_startup(struct uart_port *port)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
@@ -2386,6 +2444,10 @@ static struct uart_ops serial8250_pops =
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_get_char = serial8250_get_poll_char,
+	.poll_put_char = serial8250_put_poll_char,
+#endif
 };
 
 static struct uart_8250_port serial8250_ports[UART_NR];
Index: linux-kgdb.q/drivers/serial/Kconfig
===================================================================
--- linux-kgdb.q.orig/drivers/serial/Kconfig
+++ linux-kgdb.q/drivers/serial/Kconfig
@@ -961,6 +961,9 @@ config SERIAL_CORE
 config SERIAL_CORE_CONSOLE
 	bool
 
+config CONSOLE_POLL
+	bool
+
 config SERIAL_68328
 	bool "68328 serial support"
 	depends on M68328 || M68EZ328 || M68VZ328
Index: linux-kgdb.q/drivers/serial/Makefile
===================================================================
--- linux-kgdb.q.orig/drivers/serial/Makefile
+++ linux-kgdb.q/drivers/serial/Makefile
@@ -66,4 +66,5 @@ obj-$(CONFIG_SERIAL_UARTLITE) += uartlit
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
+obj-$(CONFIG_KGDBOC) += kgdboc.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
Index: linux-kgdb.q/drivers/serial/kgdboc.c
===================================================================
--- /dev/null
+++ linux-kgdb.q/drivers/serial/kgdboc.c
@@ -0,0 +1,164 @@
+/*
+ * drivers/serial/kgdboc.c
+ *
+ * Based on the same principle as kgdboe using the NETPOLL api, this
+ * driver uses a console polling api to implement a gdb serial inteface
+ * which is multiplexed on a console port.
+ *
+ * Maintainer: Jason Wessel <jason.wessel@windriver.com>
+ *
+ * 2007-2008 (c) Jason Wessel - Wind River Systems, Inc.
+ *
+ * This file is licensed under the terms of the GNU General Public
+ * License version 2. This program is licensed "as is" without any
+ * warranty of any kind, whether express or implied.
+ */
+#include <linux/kernel.h>
+#include <linux/ctype.h>
+#include <linux/kgdb.h>
+#include <linux/tty.h>
+
+#define MAX_KGDBOC_CONFIG_STR	40
+
+static struct kgdb_io		kgdboc_io_ops;
+
+/* -1 = init not run yet, 0 = unconfigured, 1 = configured. */
+static int configured = -1;
+
+MODULE_DESCRIPTION("KGDB Console TTY Driver");
+MODULE_LICENSE("GPL");
+static char config[MAX_KGDBOC_CONFIG_STR];
+static struct kparam_string kps = {
+	.string			= config,
+	.maxlen			= MAX_KGDBOC_CONFIG_STR,
+};
+
+static struct tty_driver	*kgdb_tty_driver;
+static int			kgdb_tty_line;
+
+static int kgdboc_option_setup(char *opt)
+{
+	if (strlen(opt) > MAX_KGDBOC_CONFIG_STR) {
+		printk(KERN_ERR "kgdboc: config string too long\n");
+		return -ENOSPC;
+	}
+	strcpy(config, opt);
+
+	return 0;
+}
+__setup("kgdboc=", kgdboc_option_setup);
+
+static int configure_kgdboc(void)
+{
+	struct tty_driver *p;
+	int tty_line = 0;
+	int err;
+
+	err = kgdboc_option_setup(config);
+	if (err || !strlen(config) || isspace(config[0]))
+		goto noconfig;
+
+	err = -ENODEV;
+
+	p = tty_find_polling_driver(config, &tty_line);
+	if (!p)
+		goto noconfig;
+
+	kgdb_tty_driver = p;
+	kgdb_tty_line = tty_line;
+
+	err = kgdb_register_io_module(&kgdboc_io_ops);
+	if (err)
+		goto noconfig;
+
+	configured = 1;
+
+	return 0;
+
+noconfig:
+	config[0] = 0;
+	configured = 0;
+
+	return err;
+}
+
+static int init_kgdboc(void)
+{
+	/* Already configured? */
+	if (configured == 1)
+		return 0;
+
+	return configure_kgdboc();
+}
+
+static void cleanup_kgdboc(void)
+{
+	if (configured == 1)
+		kgdb_unregister_io_module(&kgdboc_io_ops);
+}
+
+static int kgdboc_get_char(void)
+{
+	return kgdb_tty_driver->poll_get_char(kgdb_tty_driver, kgdb_tty_line);
+}
+
+static void kgdboc_put_char(u8 chr)
+{
+	kgdb_tty_driver->poll_put_char(kgdb_tty_driver, kgdb_tty_line, chr);
+}
+
+static int param_set_kgdboc_var(const char *kmessage, struct kernel_param *kp)
+{
+	if (strlen(kmessage) >= MAX_KGDBOC_CONFIG_STR) {
+		printk(KERN_ERR "kgdboc: config string too long\n");
+		return -ENOSPC;
+	}
+
+	/* Only copy in the string if the init function has not run yet */
+	if (configured < 0) {
+		strcpy(config, kmessage);
+		return 0;
+	}
+
+	if (kgdb_connected) {
+		printk(KERN_ERR
+		       "kgdboc: Cannot reconfigure while KGDB is connected.\n");
+
+		return -EBUSY;
+	}
+
+	strcpy(config, kmessage);
+
+	if (configured == 1)
+		cleanup_kgdboc();
+
+	/* Go and configure with the new params. */
+	return configure_kgdboc();
+}
+
+static void kgdboc_pre_exp_handler(void)
+{
+	/* Increment the module count when the debugger is active */
+	if (!kgdb_connected)
+		try_module_get(THIS_MODULE);
+}
+
+static void kgdboc_post_exp_handler(void)
+{
+	/* decrement the module count when the debugger detaches */
+	if (!kgdb_connected)
+		module_put(THIS_MODULE);
+}
+
+static struct kgdb_io kgdboc_io_ops = {
+	.name			= "kgdboc",
+	.read_char		= kgdboc_get_char,
+	.write_char		= kgdboc_put_char,
+	.pre_exception		= kgdboc_pre_exp_handler,
+	.post_exception		= kgdboc_post_exp_handler,
+};
+
+module_init(init_kgdboc);
+module_exit(cleanup_kgdboc);
+module_param_call(kgdboc, param_set_kgdboc_var, param_get_string, &kps, 0644);
+MODULE_PARM_DESC(kgdboc, "<serial_device>[,baud]");
Index: linux-kgdb.q/drivers/serial/serial_core.c
===================================================================
--- linux-kgdb.q.orig/drivers/serial/serial_core.c
+++ linux-kgdb.q/drivers/serial/serial_core.c
@@ -1924,7 +1924,12 @@ uart_set_options(struct uart_port *port,
 	port->mctrl |= TIOCM_DTR;
 
 	port->ops->set_termios(port, &termios, &dummy);
-	co->cflag = termios.c_cflag;
+	/*
+	 * Allow the setting of the UART parameters with a NULL console
+	 * too:
+	 */
+	if (co)
+		co->cflag = termios.c_cflag;
 
 	return 0;
 }
@@ -2182,6 +2187,61 @@ uart_configure_port(struct uart_driver *
 	}
 }
 
+#ifdef CONFIG_CONSOLE_POLL
+
+static int uart_poll_init(struct tty_driver *driver, int line, char *options)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+	int baud = 9600;
+	int bits = 8;
+	int parity = 'n';
+	int flow = 'n';
+
+	if (!state || !state->port)
+		return -1;
+
+	port = state->port;
+	if (!(port->ops->poll_get_char &&
+		  port->ops->poll_put_char))
+		return -1;
+
+	if (options) {
+		uart_parse_options(options, &baud, &parity, &bits, &flow);
+		return uart_set_options(port, NULL, baud, parity, bits, flow);
+	}
+
+	return 0;
+}
+
+static int uart_poll_get_char(struct tty_driver *driver, int line)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->port)
+		return -1;
+
+	port = state->port;
+	return port->ops->poll_get_char(port);
+}
+
+static void uart_poll_put_char(struct tty_driver *driver, int line, char ch)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->port)
+		return;
+
+	port = state->port;
+	port->ops->poll_put_char(port, ch);
+}
+#endif
+
 static const struct tty_operations uart_ops = {
 	.open		= uart_open,
 	.close		= uart_close,
@@ -2206,6 +2266,11 @@ static const struct tty_operations uart_
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
+#ifdef CONFIG_CONSOLE_POLL
+	.poll_init	= uart_poll_init,
+	.poll_get_char	= uart_poll_get_char,
+	.poll_put_char	= uart_poll_put_char,
+#endif
 };
 
 /**
Index: linux-kgdb.q/include/linux/serial_core.h
===================================================================
--- linux-kgdb.q.orig/include/linux/serial_core.h
+++ linux-kgdb.q/include/linux/serial_core.h
@@ -211,6 +211,10 @@ struct uart_ops {
 	void		(*config_port)(struct uart_port *, int);
 	int		(*verify_port)(struct uart_port *, struct serial_struct *);
 	int		(*ioctl)(struct uart_port *, unsigned int, unsigned long);
+#ifdef CONFIG_CONSOLE_POLL
+	void	(*poll_put_char)(struct uart_port *, unsigned char);
+	int		(*poll_get_char)(struct uart_port *);
+#endif
 };
 
 #define UART_CONFIG_TYPE	(1 << 0)
Index: linux-kgdb.q/include/linux/tty_driver.h
===================================================================
--- linux-kgdb.q.orig/include/linux/tty_driver.h
+++ linux-kgdb.q/include/linux/tty_driver.h
@@ -125,6 +125,7 @@
 #include <linux/cdev.h>
 
 struct tty_struct;
+struct tty_driver;
 
 struct tty_operations {
 	int  (*open)(struct tty_struct * tty, struct file * filp);
@@ -157,6 +158,11 @@ struct tty_operations {
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
+#ifdef CONFIG_CONSOLE_POLL
+	int (*poll_init)(struct tty_driver *driver, int line, char *options);
+	int (*poll_get_char)(struct tty_driver *driver, int line);
+	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
+#endif
 };
 
 struct tty_driver {
@@ -220,6 +226,11 @@ struct tty_driver {
 	int (*tiocmget)(struct tty_struct *tty, struct file *file);
 	int (*tiocmset)(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
+#ifdef CONFIG_CONSOLE_POLL
+	int (*poll_init)(struct tty_driver *driver, int line, char *options);
+	int (*poll_get_char)(struct tty_driver *driver, int line);
+	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
+#endif
 
 	struct list_head tty_drivers;
 };
@@ -230,6 +241,7 @@ struct tty_driver *alloc_tty_driver(int 
 void put_tty_driver(struct tty_driver *driver);
 void tty_set_operations(struct tty_driver *driver,
 			const struct tty_operations *op);
+extern struct tty_driver *tty_find_polling_driver(char *name, int *line);
 
 /* tty driver magic number */
 #define TTY_DRIVER_MAGIC		0x5402
