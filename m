Return-Path: <linux-kernel-owner+w=401wt.eu-S1765294AbXJFTON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765294AbXJFTON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 15:14:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765196AbXJFTN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 15:13:58 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:58958 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765003AbXJFTN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 15:13:57 -0400
Date: Sat, 6 Oct 2007 21:13:55 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Dave Jones <davej@redhat.com>, Oleg Verych <olecom@flower.upol.cz>,
       Ingo Molnar <mingo@elte.hu>, Krzysztof Halasa <khc@pm.waw.pl>,
       Medve Emilian-EMMEDVE1 <Emilian.Medve@freescale.com>,
       Helge Deller <deller@gmx.de>
Subject: [PATCH 2/2] Colored kernel output (run2)
In-Reply-To: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0710062113420.5969@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710062005190.5969@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Colored kernel message output (2/2)

By popular request, this patch adds per-loglevel coloring.
The user may set values using vt.printk_color= or by modifying
the sysfs file in the running system.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 arch/x86_64/kernel/early_printk.c |   11 +++++++----
 drivers/char/Kconfig              |    4 +++-
 drivers/char/vt.c                 |   30 +++++++++++++++++++++++-------
 drivers/net/netconsole.c          |    3 ++-
 drivers/serial/8250.c             |    3 ++-
 drivers/serial/8250_early.c       |    3 ++-
 include/linux/console.h           |    2 +-
 kernel/printk.c                   |   12 +++++++-----
 8 files changed, 47 insertions(+), 21 deletions(-)

Index: linux-2.6.23/arch/x86_64/kernel/early_printk.c
===================================================================
--- linux-2.6.23.orig/arch/x86_64/kernel/early_printk.c
+++ linux-2.6.23/arch/x86_64/kernel/early_printk.c
@@ -20,7 +20,8 @@
 static int max_ypos = 25, max_xpos = 80;
 static int current_ypos = 25, current_xpos = 0;
 
-static void early_vga_write(struct console *con, const char *str, unsigned n)
+static void early_vga_write(struct console *con, const char *str, unsigned n,
+                            unsigned int loglevel)
 {
 	char c;
 	int  i, k, j;
@@ -89,7 +90,8 @@ static int early_serial_putc(unsigned ch
 	return timeout ? 0 : -1;
 }
 
-static void early_serial_write(struct console *con, const char *s, unsigned n)
+static void early_serial_write(struct console *con, const char *s, unsigned n,
+                               unsigned int loglevel)
 {
 	while (*s && n-- > 0) {
 		if (*s == '\n')
@@ -185,7 +187,8 @@ static void __init simnow_init(char *str
 	simnow_fd = simnow(XOPEN, (unsigned long)fn, O_WRONLY|O_APPEND|O_CREAT, 0644);
 }
 
-static void simnow_write(struct console *con, const char *s, unsigned n)
+static void simnow_write(struct console *con, const char *s, unsigned n,
+                         unsigned int loglevel)
 {
 	simnow(XWRITE, simnow_fd, (unsigned long)s, n);
 }
@@ -209,7 +212,7 @@ void early_printk(const char *fmt, ...)
 
 	va_start(ap,fmt);
 	n = vscnprintf(buf,512,fmt,ap);
-	early_console->write(early_console,buf,n);
+	early_console->write(early_console, buf, n, 0);
 	va_end(ap);
 }
 
Index: linux-2.6.23/drivers/char/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/char/Kconfig
+++ linux-2.6.23/drivers/char/Kconfig
@@ -65,7 +65,9 @@ config VT_PRINTK_COLOR
 	default 0x07
 	---help---
 	This option defines with which color kernel messages will be
-	printed to the console.
+	printed to the console. This applies to all log levels.
+	Colors for independent log levels can be set using the
+	vt.printk_color runtime option.
 
 	The value you need to enter here is the value is composed
 	(OR-ed) of a foreground and a background color.
Index: linux-2.6.23/drivers/char/vt.c
===================================================================
--- linux-2.6.23.orig/drivers/char/vt.c
+++ linux-2.6.23/drivers/char/vt.c
@@ -2345,8 +2345,17 @@ struct tty_driver *console_driver;
 
 #ifdef CONFIG_VT_CONSOLE
 
-static unsigned int printk_color __read_mostly = CONFIG_VT_PRINTK_COLOR;
-module_param(printk_color, uint, S_IRUGO | S_IWUSR);
+static unsigned int printk_color[] __read_mostly = {
+	CONFIG_VT_PRINTK_COLOR, /* KERN_EMERG */
+	CONFIG_VT_PRINTK_COLOR, /* KERN_ALERT */
+	CONFIG_VT_PRINTK_COLOR, /* KERN_CRIT */
+	CONFIG_VT_PRINTK_COLOR, /* KERN_ERR */
+	CONFIG_VT_PRINTK_COLOR, /* KERN_WARNING */
+	CONFIG_VT_PRINTK_COLOR, /* KERN_NOTICE */
+	CONFIG_VT_PRINTK_COLOR, /* KERN_INFO */
+	CONFIG_VT_PRINTK_COLOR, /* KERN_DEBUG */
+};
+module_param_array(printk_color, uint, NULL, S_IRUGO | S_IWUSR);
 
 static inline void vc_set_color(struct vc_data *vc, unsigned char color)
 {
@@ -2362,10 +2371,11 @@ static inline void vc_set_color(struct v
  * The console must be locked when we get here.
  */
 
-static void vt_console_print(struct console *co, const char *b, unsigned count)
+static void vt_console_print(struct console *co, const char *b, unsigned count,
+                             unsigned int loglevel)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
-	unsigned char c;
+	unsigned char current_color, c;
 	static unsigned long printing;
 	const ushort *start;
 	ushort cnt = 0;
@@ -2396,7 +2406,13 @@ static void vt_console_print(struct cons
 		hide_cursor(vc);
 
 	start = (ushort *)vc->vc_pos;
-	vc_set_color(vc, printk_color);
+
+	/*
+	 * We always get a valid loglevel - <8> and "no level" is transformed
+	 * to <4> in the typical kernel.
+	 */
+	current_color = printk_color[loglevel];
+	vc_set_color(vc, current_color);
 
 	/* Contrived structure to try to emulate original need_wrap behaviour
 	 * Problems caused when we have need_wrap set on '\n' character */
@@ -2416,7 +2432,7 @@ static void vt_console_print(struct cons
 				bs(vc);
 				start = (ushort *)vc->vc_pos;
 				myx = vc->vc_x;
-				vc_set_color(vc, printk_color);
+				vc_set_color(vc, current_color);
 				continue;
 			}
 			if (c != 13)
@@ -2424,7 +2440,7 @@ static void vt_console_print(struct cons
 			cr(vc);
 			start = (ushort *)vc->vc_pos;
 			myx = vc->vc_x;
-			vc_set_color(vc, printk_color);
+			vc_set_color(vc, current_color);
 			if (c == 10 || c == 13)
 				continue;
 		}
Index: linux-2.6.23/drivers/net/netconsole.c
===================================================================
--- linux-2.6.23.orig/drivers/net/netconsole.c
+++ linux-2.6.23/drivers/net/netconsole.c
@@ -65,7 +65,8 @@ static int configured = 0;
 
 #define MAX_PRINT_CHUNK 1000
 
-static void write_msg(struct console *con, const char *msg, unsigned int len)
+static void write_msg(struct console *con, const char *msg, unsigned int len,
+    unsigned int loglevel)
 {
 	int frag, left;
 	unsigned long flags;
Index: linux-2.6.23/drivers/serial/8250.c
===================================================================
--- linux-2.6.23.orig/drivers/serial/8250.c
+++ linux-2.6.23/drivers/serial/8250.c
@@ -2464,7 +2464,8 @@ static void serial8250_console_putchar(s
  *	The console_lock must be held when we get here.
  */
 static void
-serial8250_console_write(struct console *co, const char *s, unsigned int count)
+serial8250_console_write(struct console *co, const char *s, unsigned int count,
+                         unsigned int loglevel)
 {
 	struct uart_8250_port *up = &serial8250_ports[co->index];
 	unsigned long flags;
Index: linux-2.6.23/drivers/serial/8250_early.c
===================================================================
--- linux-2.6.23.orig/drivers/serial/8250_early.c
+++ linux-2.6.23/drivers/serial/8250_early.c
@@ -82,7 +82,8 @@ static void __init putc(struct uart_port
 	serial_out(port, UART_TX, c);
 }
 
-static void __init early_serial8250_write(struct console *console, const char *s, unsigned int count)
+static void __init early_serial8250_write(struct console *console,
+    const char *s, unsigned int count, unsigned int loglevel)
 {
 	struct uart_port *port = &early_device.port;
 	unsigned int ier;
Index: linux-2.6.23/include/linux/console.h
===================================================================
--- linux-2.6.23.orig/include/linux/console.h
+++ linux-2.6.23/include/linux/console.h
@@ -93,7 +93,7 @@ void give_up_console(const struct consw 
 
 struct console {
 	char	name[16];
-	void	(*write)(struct console *, const char *, unsigned);
+	void	(*write)(struct console *, const char *, unsigned, unsigned int);
 	int	(*read)(struct console *, char *, unsigned);
 	struct tty_driver *(*device)(struct console *, int *);
 	void	(*unblank)(void);
Index: linux-2.6.23/kernel/printk.c
===================================================================
--- linux-2.6.23.orig/kernel/printk.c
+++ linux-2.6.23/kernel/printk.c
@@ -320,7 +320,8 @@ asmlinkage long sys_syslog(int type, cha
 /*
  * Call the console drivers on a range of log_buf
  */
-static void __call_console_drivers(unsigned long start, unsigned long end)
+static void __call_console_drivers(unsigned long start, unsigned long end,
+    unsigned int loglevel)
 {
 	struct console *con;
 
@@ -328,7 +329,7 @@ static void __call_console_drivers(unsig
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
+			con->write(con, &LOG_BUF(start), end - start, loglevel);
 	}
 }
 
@@ -355,10 +356,11 @@ static void _call_console_drivers(unsign
 		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
 			/* wrapped write */
 			__call_console_drivers(start & LOG_BUF_MASK,
-						log_buf_len);
-			__call_console_drivers(0, end & LOG_BUF_MASK);
+						log_buf_len, msg_log_level);
+			__call_console_drivers(0, end & LOG_BUF_MASK,
+			                       msg_log_level);
 		} else {
-			__call_console_drivers(start, end);
+			__call_console_drivers(start, end, msg_log_level);
 		}
 	}
 }
