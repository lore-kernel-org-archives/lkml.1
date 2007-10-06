Return-Path: <linux-kernel-owner+w=401wt.eu-S1765583AbXJFVUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765583AbXJFVUA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 17:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757929AbXJFVTx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 17:19:53 -0400
Received: from rv-out-0910.google.com ([209.85.198.190]:36949 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755680AbXJFVTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 17:19:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o1z+7biMuUZOkaS7uSrCfYye34D7i98AquJujtYV7ZA62JJd/0RXOdx7MfrUGAxP0F2iar4DkEnujAz+m3tXZ2Ab7zmHzpvkgXJwCFtbT0vLbTqr1339Ew2+m+EshqWrGBH8ZOB8pEZELHIzGwBcMkQ3y8jR3Jbp2KXpYBlyyQ0=
Message-ID: <7d25b44a0710061419i287cb795se66954535adc0c1a@mail.gmail.com>
Date: Sat, 6 Oct 2007 23:19:51 +0200
From: "=?ISO-8859-1?Q?Miguel_Bot=F3n?=" <mboton@gmail.com>
To: "Jan Engelhardt" <jengelh@computergmbh.de>
Subject: Re: [PATCH] Cute feature: colored printk output
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0710052111340.13406@fbirervta.pbzchgretzou.qr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/07, Jan Engelhardt <jengelh@computergmbh.de> wrote:
>
> Colored kernel message output
>
> Let's work more on Linux's cuteness! [http://lkml.org/lkml/2007/10/4/431]
> The following patch makes it possible to give kernel messages a
> selectable color which helps to distinguish it from other noise,
> such as boot messages. NetBSD has it, OpenBSD has it, FreeBSD to some
> extent, so I think Linux should too.
>
> Inspired by cko (http://freshmeat.net/p/cko/), but independently
> written, later contributed forth and back.
>
> Already posted at: http://lkml.org/lkml/2007/4/1/162

Pretty interesting feature. I modified your lastest patch a little bit
so now you can set the message color for each log level in the kernel
config.

diff -ruN linux-2.6.23.orig/arch/x86_64/kernel/early_printk.c
linux-2.6.23/arch/x86_64/kernel/early_printk.c
--- linux-2.6.23.orig/arch/x86_64/kernel/early_printk.c	2007-10-02
05:24:52.000000000 +0200
+++ linux-2.6.23/arch/x86_64/kernel/early_printk.c	2007-10-06
23:00:39.000000000 +0200
@@ -20,7 +20,8 @@
 static int max_ypos = 25, max_xpos = 80;
 static int current_ypos = 25, current_xpos = 0;

-static void early_vga_write(struct console *con, const char *str, unsigned n)
+static void early_vga_write(struct console *con, const char *str, unsigned n,
+                            unsigned int loglevel)
 {
 	char c;
 	int  i, k, j;
@@ -89,7 +90,8 @@
 	return timeout ? 0 : -1;
 }

-static void early_serial_write(struct console *con, const char *s, unsigned n)
+static void early_serial_write(struct console *con, const char *s, unsigned n,
+                               unsigned int loglevel)
 {
 	while (*s && n-- > 0) {
 		if (*s == '\n')
@@ -185,7 +187,8 @@
 	simnow_fd = simnow(XOPEN, (unsigned long)fn, O_WRONLY|O_APPEND|O_CREAT, 0644);
 }

-static void simnow_write(struct console *con, const char *s, unsigned n)
+static void simnow_write(struct console *con, const char *s, unsigned n,
+                         unsigned int loglevel)
 {
 	simnow(XWRITE, simnow_fd, (unsigned long)s, n);
 }
@@ -209,7 +212,7 @@

 	va_start(ap,fmt);
 	n = vscnprintf(buf,512,fmt,ap);
-	early_console->write(early_console,buf,n);
+	early_console->write(early_console, buf, n, 0);
 	va_end(ap);
 }

diff -ruN linux-2.6.23.orig/drivers/char/Kconfig
linux-2.6.23/drivers/char/Kconfig
--- linux-2.6.23.orig/drivers/char/Kconfig	2007-10-02 05:24:52.000000000 +0200
+++ linux-2.6.23/drivers/char/Kconfig	2007-10-06 23:06:55.000000000 +0200
@@ -58,6 +58,111 @@

 	  If unsure, say Y.

+config VT_CKO
+	bool "Colored kernel message output"
+	depends on VT_CONSOLE
+	---help---
+	  This option enables kernel messages to be emitted in
+	  colors other than the default.
+
+	  The color value you need to enter is composed (OR-ed)
+	  of a foreground and a background color.
+
+	  Foreground:
+	  0x00 = black,   0x08 = dark gray,
+	  0x01 = red,     0x09 = light red,
+	  0x02 = green,   0x0A = light green,
+	  0x03 = brown,   0x0B = yellow,
+	  0x04 = blue,    0x0C = light blue,
+	  0x05 = magenta, 0x0D = light magenta,
+	  0x06 = cyan,    0x0E = light cyan,
+	  0x07 = gray,    0x0F = white,
+
+	  (Foreground colors 0x08 to 0x0F do not work when a VGA
+	  console font with 512 glyphs is used.)
+
+	  Background:
+	  0x00 = black,   0x40 = blue,
+	  0x10 = red,     0x50 = magenta,
+	  0x20 = green,   0x60 = cyan,
+	  0x30 = brown,   0x70 = gray,
+
+	  For example, 0x1F would yield white on red.
+
+	  If unsure, say N.
+
+config VT_PRINTK_EMERG_COLOR
+	hex "Emergency messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel emergency messages will
+	  be printed to the console.
+
+config VT_PRINTK_ALERT_COLOR
+	hex "Alert messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel alert messages will
+	  be printed to the console.
+
+config VT_PRINTK_CRIT_COLOR
+	hex "Critical messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel critical messages will
+	  be printed to the console.
+
+config VT_PRINTK_ERR_COLOR
+	hex "Error messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel error messages will
+	  be printed to the console.
+
+config VT_PRINTK_WARNING_COLOR
+	hex "Warning messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel warning messages will
+	  be printed to the console.
+
+config VT_PRINTK_NOTICE_COLOR
+	hex "Notice messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel notice messages will
+	  be printed to the console.
+
+config VT_PRINTK_INFO_COLOR
+	hex "Information messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel information messages will
+	  be printed to the console.
+
+config VT_PRINTK_DEBUG_COLOR
+	hex "Debug messages color"
+	range 0x00 0xFF
+	depends on VT_CKO
+	default 0x07
+	---help---
+	  This option defines with which color kernel debug messages will
+	  be printed to the console.
+
 config HW_CONSOLE
 	bool
 	depends on VT && !S390 && !UML
diff -ruN linux-2.6.23.orig/drivers/char/vt.c linux-2.6.23/drivers/char/vt.c
--- linux-2.6.23.orig/drivers/char/vt.c	2007-10-02 05:24:52.000000000 +0200
+++ linux-2.6.23/drivers/char/vt.c	2007-10-06 23:06:55.000000000 +0200
@@ -73,6 +73,7 @@
  */

 #include <linux/module.h>
+#include <linux/moduleparam.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
@@ -2344,16 +2345,44 @@

 #ifdef CONFIG_VT_CONSOLE

+#ifdef CONFIG_VT_CKO
+static unsigned int printk_color[8] __read_mostly = {
+	CONFIG_VT_PRINTK_EMERG_COLOR,	/* KERN_EMERG */
+	CONFIG_VT_PRINTK_ALERT_COLOR,	/* KERN_ALERT */
+	CONFIG_VT_PRINTK_CRIT_COLOR,	/* KERN_CRIT */
+	CONFIG_VT_PRINTK_ERR_COLOR,	/* KERN_ERR */
+	CONFIG_VT_PRINTK_WARNING_COLOR,	/* KERN_WARNING */
+	CONFIG_VT_PRINTK_NOTICE_COLOR,	/* KERN_NOTICE */
+	CONFIG_VT_PRINTK_INFO_COLOR,	/* KERN_INFO */
+	CONFIG_VT_PRINTK_DEBUG_COLOR,	/* KERN_DEBUG */
+};
+module_param_array(printk_color, uint, NULL, S_IRUGO | S_IWUSR);
+
+static inline void vc_set_color(struct vc_data *vc, unsigned char color)
+{
+	vc->vc_color = color_table[color & 0xF] |
+	               (color_table[(color >> 4) & 0x7] << 4) |
+	               (color & 0x80);
+	update_attr(vc);
+}
+#else
+static unsigned int printk_color[8];
+static inline void vc_set_color(const struct vc_data *vc, unsigned char c)
+{
+}
+#endif
+
 /*
  *	Console on virtual terminal
  *
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
@@ -2385,11 +2414,19 @@

 	start = (ushort *)vc->vc_pos;

+	/*
+	 * We always get a valid loglevel - <8> and "no level" is transformed
+	 * to <4> in the typical kernel.
+	 */
+	current_color = printk_color[loglevel];
+	vc_set_color(vc, current_color);
+
 	/* Contrived structure to try to emulate original need_wrap behaviour
 	 * Problems caused when we have need_wrap set on '\n' character */
 	while (count--) {
 		c = *b++;
 		if (c == 10 || c == 13 || c == 8 || vc->vc_need_wrap) {
+			vc_set_color(vc, vc->vc_def_color);
 			if (cnt > 0) {
 				if (CON_IS_VISIBLE(vc))
 					vc->vc_sw->con_putcs(vc, start, cnt, vc->vc_y, vc->vc_x);
@@ -2402,6 +2439,7 @@
 				bs(vc);
 				start = (ushort *)vc->vc_pos;
 				myx = vc->vc_x;
+				vc_set_color(vc, current_color);
 				continue;
 			}
 			if (c != 13)
@@ -2409,6 +2447,7 @@
 			cr(vc);
 			start = (ushort *)vc->vc_pos;
 			myx = vc->vc_x;
+			vc_set_color(vc, current_color);
 			if (c == 10 || c == 13)
 				continue;
 		}
@@ -2430,6 +2469,7 @@
 			vc->vc_need_wrap = 1;
 		}
 	}
+	vc_set_color(vc, vc->vc_def_color);
 	set_cursor(vc);

 quit:
diff -ruN linux-2.6.23.orig/drivers/net/netconsole.c
linux-2.6.23/drivers/net/netconsole.c
--- linux-2.6.23.orig/drivers/net/netconsole.c	2007-10-02
05:24:52.000000000 +0200
+++ linux-2.6.23/drivers/net/netconsole.c	2007-10-06 23:00:39.000000000 +0200
@@ -65,7 +65,8 @@

 #define MAX_PRINT_CHUNK 1000

-static void write_msg(struct console *con, const char *msg, unsigned int len)
+static void write_msg(struct console *con, const char *msg, unsigned int len,
+    unsigned int loglevel)
 {
 	int frag, left;
 	unsigned long flags;
diff -ruN linux-2.6.23.orig/drivers/serial/8250.c
linux-2.6.23/drivers/serial/8250.c
--- linux-2.6.23.orig/drivers/serial/8250.c	2007-10-02 05:24:52.000000000 +0200
+++ linux-2.6.23/drivers/serial/8250.c	2007-10-06 23:00:39.000000000 +0200
@@ -2464,7 +2464,8 @@
  *	The console_lock must be held when we get here.
  */
 static void
-serial8250_console_write(struct console *co, const char *s, unsigned int count)
+serial8250_console_write(struct console *co, const char *s, unsigned int count,
+                         unsigned int loglevel)
 {
 	struct uart_8250_port *up = &serial8250_ports[co->index];
 	unsigned long flags;
diff -ruN linux-2.6.23.orig/drivers/serial/8250_early.c
linux-2.6.23/drivers/serial/8250_early.c
--- linux-2.6.23.orig/drivers/serial/8250_early.c	2007-10-02
05:24:52.000000000 +0200
+++ linux-2.6.23/drivers/serial/8250_early.c	2007-10-06 23:00:39.000000000 +0200
@@ -82,7 +82,8 @@
 	serial_out(port, UART_TX, c);
 }

-static void __init early_serial8250_write(struct console *console,
const char *s, unsigned int count)
+static void __init early_serial8250_write(struct console *console,
+    const char *s, unsigned int count, unsigned int loglevel)
 {
 	struct uart_port *port = &early_device.port;
 	unsigned int ier;
diff -ruN linux-2.6.23.orig/include/linux/console.h
linux-2.6.23/include/linux/console.h
--- linux-2.6.23.orig/include/linux/console.h	2007-10-02
05:24:52.000000000 +0200
+++ linux-2.6.23/include/linux/console.h	2007-10-06 23:00:39.000000000 +0200
@@ -93,7 +93,7 @@

 struct console {
 	char	name[16];
-	void	(*write)(struct console *, const char *, unsigned);
+	void	(*write)(struct console *, const char *, unsigned, unsigned int);
 	int	(*read)(struct console *, char *, unsigned);
 	struct tty_driver *(*device)(struct console *, int *);
 	void	(*unblank)(void);
diff -ruN linux-2.6.23.orig/kernel/printk.c linux-2.6.23/kernel/printk.c
--- linux-2.6.23.orig/kernel/printk.c	2007-10-02 05:24:52.000000000 +0200
+++ linux-2.6.23/kernel/printk.c	2007-10-06 23:00:39.000000000 +0200
@@ -320,7 +320,8 @@
 /*
  * Call the console drivers on a range of log_buf
  */
-static void __call_console_drivers(unsigned long start, unsigned long end)
+static void __call_console_drivers(unsigned long start, unsigned long end,
+    unsigned int loglevel)
 {
 	struct console *con;

@@ -328,7 +329,7 @@
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
+			con->write(con, &LOG_BUF(start), end - start, loglevel);
 	}
 }

@@ -355,10 +356,11 @@
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
