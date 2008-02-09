Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYBINiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYBINiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 08:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYBINfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 08:35:34 -0500
Received: from mail.windriver.com ([147.11.1.11]:60469 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757465AbYBINf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 08:35:28 -0500
From: jason.wessel@windriver.com
To: linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>, Jan Kiszka <jan.kiszka@web.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 8/8] kgdb: kgdboc 8250 I/O module
Date: Sat,  9 Feb 2008 07:35:14 -0600
Message-Id: <1202564114-18587-9-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <1202564114-18587-8-git-send-email-jason.wessel@windriver.com>
References: <1202564114-18587-1-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-2-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-3-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-4-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-5-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-6-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-7-git-send-email-jason.wessel@windriver.com>
 <1202564114-18587-8-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 09 Feb 2008 13:34:59.0571 (UTC) FILETIME=[90FD6430:01C86B20]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Wessel <jason.wessel@windriver.com>

Add a SERIAL_POLL API to the serial core for use with kgdboc (KGDB
over the console), the gdb serial adapter which can multiplex with a
console port.

The kgdboc module can be extended later to support all sorts of
different console types provided that there are hooks in the console
driver to allow for polled mode access while the system is halted.

If you build kgdboc into the kernel you could expect to use the
following kernel boot arguments assuming your console is ttyS0:
"kgdbwait kgdboc=ttyS0"

In case you do try this and don't end up attaching gdb to the console,
you will want to type the debugger detach command manually (NOTE: it
will not echo because the console is in polled debug mode).

$D#44+

kgdboc can also be loaded at runtime as a kernel module.  The easiest
way to use kgdboc is to use it with a proxy that splits the traffic to
gdb and to your favorite terminal application.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/DocBook/kgdb.tmpl     |    7 ++
 Documentation/kernel-parameters.txt |    5 +
 drivers/char/tty_io.c               |    8 ++
 drivers/serial/8250.c               |   61 ++++++++++++
 drivers/serial/Kconfig              |    3 +
 drivers/serial/Makefile             |    1 +
 drivers/serial/kgdboc.c             |  182 +++++++++++++++++++++++++++++++++++
 drivers/serial/serial_core.c        |   71 +++++++++++++-
 include/linux/serial_core.h         |    4 +
 include/linux/tty_driver.h          |   11 ++
 lib/Kconfig.kgdb                    |    9 ++
 11 files changed, 361 insertions(+), 1 deletions(-)
 create mode 100644 drivers/serial/kgdboc.c

diff --git a/Documentation/DocBook/kgdb.tmpl b/Documentation/DocBook/kgdb.tmpl
index 111a2a0..b334b44 100644
--- a/Documentation/DocBook/kgdb.tmpl
+++ b/Documentation/DocBook/kgdb.tmpl
@@ -136,6 +136,13 @@
     <constant>kgdb8250=ttyS0,115200</constant>
     </para>
     <para>
+    To configure the <symbol>CONFIG_KGDBOC</symbol> driver, just pass in
+    <constant>kgdboc=&lt;tty-device&gt;</constant>.  It will try to connect
+    to gdb over the given serial console.  Note that KGDBOC does not support
+    interrupting the target via the gdb remote protocol.  Instead you will
+    need to issue sysrq-g via the console or locally on the target.
+    </para>
+    <para>
     All drivers can be reconfigured at run time, if
     <symbol>CONFIG_SYSFS</symbol> and <symbol>CONFIG_MODULES</symbol> are
     enabled, by echo'ing a new config string to
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index a4fc7fc..fa9c774 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -930,6 +930,11 @@ and is between 256 and 4096 characters. It is defined in the file
 	kstack=N	[X86-32,X86-64] Print N words from the kernel stack
 			in oops dumps.
 
+	kgdboc=		[HW] gdbserial console driver to multiple gdb serial and
+			the console.  Requires the uart driver that supports
+			CONFIG_SERIAL_POLL
+			Format: <serial_device>[,baud]
+
 	l2cr=		[PPC]
 
 	lapic		[X86-32,APIC] Enable the local APIC even if BIOS
diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index 613ec81..e169008 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -129,6 +129,9 @@ EXPORT_SYMBOL(tty_std_termios);
    into this file */
 
 LIST_HEAD(tty_drivers);			/* linked list of tty drivers */
+#ifdef CONFIG_SERIAL_POLL
+EXPORT_SYMBOL_GPL(tty_drivers);
+#endif
 
 /* Mutex to protect creating and releasing a tty. This is shared with
    vt.c for deeply disgusting hack reasons */
@@ -3850,6 +3853,11 @@ void tty_set_operations(struct tty_driver *driver,
 	driver->write_proc = op->write_proc;
 	driver->tiocmget = op->tiocmget;
 	driver->tiocmset = op->tiocmset;
+#ifdef CONFIG_SERIAL_POLL
+	driver->poll_init = op->poll_init;
+	driver->poll_get_char = op->poll_get_char;
+	driver->poll_put_char = op->poll_put_char;
+#endif
 }
 
 
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 2b37370..f8eebaa 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1740,6 +1740,63 @@ static inline void wait_for_xmitr(struct uart_8250_port *up, int bits)
 	}
 }
 
+#ifdef CONFIG_SERIAL_POLL
+/* Serial polling routines for writing and reading from the uart while
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
+#endif /* CONFIG_SERIAL_POLL */
+
 static int serial8250_startup(struct uart_port *port)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)port;
@@ -2386,6 +2443,10 @@ static struct uart_ops serial8250_pops = {
 	.request_port	= serial8250_request_port,
 	.config_port	= serial8250_config_port,
 	.verify_port	= serial8250_verify_port,
+#ifdef CONFIG_SERIAL_POLL
+	.poll_get_char = serial8250_get_poll_char,
+	.poll_put_char = serial8250_put_poll_char,
+#endif
 };
 
 static struct uart_8250_port serial8250_ports[UART_NR];
diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
index 7ef9145..f5b691a 100644
--- a/drivers/serial/Kconfig
+++ b/drivers/serial/Kconfig
@@ -961,6 +961,9 @@ config SERIAL_CORE
 config SERIAL_CORE_CONSOLE
 	bool
 
+config SERIAL_POLL
+	bool
+
 config SERIAL_68328
 	bool "68328 serial support"
 	depends on M68328 || M68EZ328 || M68VZ328
diff --git a/drivers/serial/Makefile b/drivers/serial/Makefile
index 6ee1b36..82778d7 100644
--- a/drivers/serial/Makefile
+++ b/drivers/serial/Makefile
@@ -66,5 +66,6 @@ obj-$(CONFIG_SERIAL_UARTLITE) += uartlite.o
 obj-$(CONFIG_SERIAL_NETX) += netx-serial.o
 obj-$(CONFIG_SERIAL_OF_PLATFORM) += of_serial.o
 obj-$(CONFIG_SERIAL_KS8695) += serial_ks8695.o
+obj-$(CONFIG_KGDBOC) += kgdboc.o
 obj-$(CONFIG_KGDB_8250) += 8250_kgdb.o
 obj-$(CONFIG_SERIAL_QE) += ucc_uart.o
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
new file mode 100644
index 0000000..7848fca
--- /dev/null
+++ b/drivers/serial/kgdboc.c
@@ -0,0 +1,182 @@
+/*
+ * drivers/serial/kgdboc.c
+ *
+ * Based on the same principle as kgdboe using the NETPOLL api, this
+ * driver uses a serial polling api to implement a gdb serial inteface
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
+#include <linux/kgdb.h>
+#include <linux/tty.h>
+#include <linux/ctype.h>
+
+#define MAX_KGDBOC_CONFIG_STR 40
+
+static struct kgdb_io kgdboc_io_ops;
+
+/* -1 = init not run yet, 0 = unconfigured, 1 = configured. */
+static int configured = -1;
+
+MODULE_DESCRIPTION("KGDB Console TTY Driver");
+MODULE_LICENSE("GPL");
+static char config[MAX_KGDBOC_CONFIG_STR];
+static struct kparam_string kps = {
+	.string = config,
+	.maxlen = MAX_KGDBOC_CONFIG_STR,
+};
+
+static struct tty_driver *kgdb_tty_driver;
+static int kgdb_tty_line;
+
+static int kgdboc_option_setup(char *opt)
+{
+	if (strlen(opt) > MAX_KGDBOC_CONFIG_STR) {
+		printk(KERN_ERR "kgdboc: config string too long\n");
+		return -ENOSPC;
+	}
+	strcpy(config, opt);
+	return 0;
+}
+__setup("kgdboc=", kgdboc_option_setup);
+
+static int configure_kgdboc(void)
+{
+	struct tty_driver *p;
+	int err;
+	char *str;
+	int tty_line = 0;
+
+	err = kgdboc_option_setup(config);
+	if (err || !strlen(config) || isspace(config[0]))
+		goto noconfig;
+
+	err = -ENODEV;
+
+	/* Search through the tty devices to look for a match */
+	/* FIXME: API violation, at least missing lock protection */
+	list_for_each_entry(p, &tty_drivers, tty_drivers) {
+		if (p->type != TTY_DRIVER_TYPE_SERIAL ||
+		    strncmp(config, p->name, strlen(p->name)) != 0)
+			continue;
+		str = config + strlen(p->name);
+		tty_line = simple_strtoul(str, &str, 10);
+		if (*str == ',')
+			str++;
+		if (*str == '\0')
+			str = 0;
+
+		if (tty_line >= 0 && tty_line <= p->num &&
+			p->poll_init && !p->poll_init(p, tty_line, str)) {
+			kgdb_tty_driver = p;
+			kgdb_tty_line = tty_line;
+			err = 0;
+			break;
+		}
+	}
+	if (err)
+		goto noconfig;
+
+	err = kgdb_register_io_module(&kgdboc_io_ops);
+	if (err)
+		goto noconfig;
+
+	configured = 1;
+	return 0;
+
+noconfig:
+	config[0] = 0;
+	configured = 0;
+	return err;
+
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
+	return kgdb_tty_driver->poll_get_char(kgdb_tty_driver,
+			kgdb_tty_line);
+}
+
+static void kgdboc_put_char(u8 chr)
+{
+	kgdb_tty_driver->poll_put_char(kgdb_tty_driver,
+			kgdb_tty_line, chr);
+}
+
+static int param_set_kgdboc_var(const char *kmessage,
+		struct kernel_param *kp)
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
+		printk(KERN_ERR "kgdboc: Cannot reconfigure while KGDB is "
+				"connected.\n");
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
+	.name = "kgdboc",
+	.read_char = kgdboc_get_char,
+	.write_char = kgdboc_put_char,
+	.pre_exception = kgdboc_pre_exp_handler,
+	.post_exception = kgdboc_post_exp_handler,
+};
+
+module_init(init_kgdboc);
+module_exit(cleanup_kgdboc);
+module_param_call(kgdboc, param_set_kgdboc_var, param_get_string, &kps, 0644);
+MODULE_PARM_DESC(kgdboc, "<serial_device>[,baud]");
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index d333fc4..fdcbd42 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -1837,7 +1837,11 @@ uart_get_console(struct uart_port *ports, int nr, struct console *co)
  *	options.  The format of the string is <baud><parity><bits><flow>,
  *	eg: 115200n8r
  */
+#ifdef CONFIG_SERIAL_POLL
+void
+#else
 void __init
+#endif
 uart_parse_options(char *options, int *baud, int *parity, int *bits, int *flow)
 {
 	char *s = options;
@@ -1882,7 +1886,11 @@ static const struct baud_rates baud_rates[] = {
  *	@bits: number of data bits
  *	@flow: flow control character - 'r' (rts)
  */
+#ifdef CONFIG_SERIAL_POLL
+int
+#else
 int __init
+#endif
 uart_set_options(struct uart_port *port, struct console *co,
 		 int baud, int parity, int bits, int flow)
 {
@@ -1934,7 +1942,8 @@ uart_set_options(struct uart_port *port, struct console *co,
 	port->mctrl |= TIOCM_DTR;
 
 	port->ops->set_termios(port, &termios, &dummy);
-	co->cflag = termios.c_cflag;
+	if (co)
+		co->cflag = termios.c_cflag;
 
 	return 0;
 }
@@ -2194,6 +2203,61 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 	}
 }
 
+#ifdef CONFIG_SERIAL_POLL
+static int uart_poll_init(struct tty_driver *driver,
+		int line, char *options)
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
+		return(uart_set_options(port, 0, baud, parity, bits, flow));
+	}
+
+	return 0;
+}
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
+static void uart_poll_put_char(struct tty_driver *driver,
+		int line, char ch)
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
@@ -2218,6 +2282,11 @@ static const struct tty_operations uart_ops = {
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
+#ifdef CONFIG_SERIAL_POLL
+	.poll_init	= uart_poll_init,
+	.poll_get_char	= uart_poll_get_char,
+	.poll_put_char	= uart_poll_put_char,
+#endif
 };
 
 /**
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 1a0b6cf..6e70866 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -211,6 +211,10 @@ struct uart_ops {
 	void		(*config_port)(struct uart_port *, int);
 	int		(*verify_port)(struct uart_port *, struct serial_struct *);
 	int		(*ioctl)(struct uart_port *, unsigned int, unsigned long);
+#ifdef CONFIG_SERIAL_POLL
+	void	(*poll_put_char)(struct uart_port *, unsigned char);
+	int		(*poll_get_char)(struct uart_port *);
+#endif
 };
 
 #define UART_CONFIG_TYPE	(1 << 0)
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 85c95cd..e4e590d 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
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
+#ifdef CONFIG_SERIAL_POLL
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
+#ifdef CONFIG_SERIAL_POLL
+	int (*poll_init)(struct tty_driver *driver, int line, char *options);
+	int (*poll_get_char)(struct tty_driver *driver, int line);
+	void (*poll_put_char)(struct tty_driver *driver, int line, char ch);
+#endif
 
 	struct list_head tty_drivers;
 };
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index 3d5c2f8..d81b502 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -51,3 +51,12 @@ config KGDB_8250
 	  the early boot process.  Note that, as long as the debugger is
 	  attached via this driver,  the configured serial port cannot be
 	  used by the standard 8250 driver or serial earlyprintk/earlycon.
+
+config KGDBOC
+	tristate "Shared serial console and kgdb port"
+	depends on KGDB
+	select SERIAL_POLL
+	select MAGIC_SYSRQ
+	help
+	  Share a serial console with kgdb.  The sysrq-g must be used
+	  to break in initially.
-- 
1.5.4

