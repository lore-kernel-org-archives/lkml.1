Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYD0DKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYD0DKI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 23:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757499AbYD0DJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 23:09:55 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:44695 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413AbYD0DJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 23:09:53 -0400
Date: Sun, 27 Apr 2008 05:09:52 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [2/3] Re: Colored Kernel Output for 2.6.25
In-Reply-To: <alpine.LNX.1.10.0804270450031.20150@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LNX.1.10.0804270509330.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804270450031.20150@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 09f4590103d5ae8cd3e0a90e801b60cd1339cf12
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Sun Apr 27 03:50:25 2008 +0200

    Colored kernel message output (2/3)
    
    By popular request, this patch adds per-loglevel coloring. The user
    may set values using vt.printk_color= or by modifying the sysfs file
    in the running system.
    
    Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
---
 arch/x86/kernel/early_printk.c |   11 +++++++----
 drivers/char/Kconfig           |    4 +++-
 drivers/char/vt.c              |   28 ++++++++++++++++++++++------
 drivers/net/netconsole.c       |    3 ++-
 drivers/serial/8250.c          |    3 ++-
 drivers/serial/8250_early.c    |    3 ++-
 include/linux/console.h        |    3 ++-
 kernel/printk.c                |   12 +++++++-----
 8 files changed, 47 insertions(+), 20 deletions(-)

diff --git a/arch/x86/kernel/early_printk.c b/arch/x86/kernel/early_printk.c
index cff84cd..ba137a4 100644
--- a/arch/x86/kernel/early_printk.c
+++ b/arch/x86/kernel/early_printk.c
@@ -15,7 +15,8 @@
 static int max_ypos = 25, max_xpos = 80;
 static int current_ypos = 25, current_xpos = 0;
 
-static void early_vga_write(struct console *con, const char *str, unsigned n)
+static void early_vga_write(struct console *con, const char *str, unsigned n,
+			    unsigned int loglevel)
 {
 	char c;
 	int  i, k, j;
@@ -84,7 +85,8 @@ static int early_serial_putc(unsigned char ch)
 	return timeout ? 0 : -1;
 }
 
-static void early_serial_write(struct console *con, const char *s, unsigned n)
+static void early_serial_write(struct console *con, const char *s, unsigned n,
+			       unsigned int loglevel)
 {
 	while (*s && n-- > 0) {
 		if (*s == '\n')
@@ -180,7 +182,8 @@ static void __init simnow_init(char *str)
 	simnow_fd = simnow(XOPEN, (unsigned long)fn, O_WRONLY|O_APPEND|O_CREAT, 0644);
 }
 
-static void simnow_write(struct console *con, const char *s, unsigned n)
+static void simnow_write(struct console *con, const char *s, unsigned n,
+			 unsigned int loglevel)
 {
 	simnow(XWRITE, simnow_fd, (unsigned long)s, n);
 }
@@ -204,7 +207,7 @@ void early_printk(const char *fmt, ...)
 
 	va_start(ap,fmt);
 	n = vscnprintf(buf,512,fmt,ap);
-	early_console->write(early_console,buf,n);
+	early_console->write(early_console, buf, n, 0);
 	va_end(ap);
 }
 
diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index a55a1c9..3f5877e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -75,7 +75,9 @@ config VT_PRINTK_COLOR
 	default 0x07
 	---help---
 	This option defines with which color kernel messages will be
-	printed to the console.
+	printed to the console. This applies to all log levels.
+	You can change the colors at run-time, or set them at boot-time
+	using the "vt.printk_color" option.
 
 	The value you need to enter here is the value is composed
 	(OR-ed) of a foreground and a background color.
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index cf61236..75ca0cf 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -2394,8 +2394,17 @@ struct tty_driver *console_driver;
 #ifdef CONFIG_VT_CONSOLE
 
 #ifdef CONFIG_VT_CKO
-static unsigned int printk_color __read_mostly = CONFIG_VT_PRINTK_COLOR;
-module_param(printk_color, uint, S_IRUGO | S_IWUSR);
+static unsigned int printk_color[8] __read_mostly = {
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
 
 static void vc_set_color(struct vc_data *vc, unsigned char color)
 {
@@ -2405,7 +2414,7 @@ static void vc_set_color(struct vc_data *vc, unsigned char color)
 	update_attr(vc);
 }
 #else
-static const unsigned int printk_color;
+static const unsigned int printk_color[8];
 static inline void vc_set_color(const struct vc_data *vc, unsigned char c)
 {
 }
@@ -2417,10 +2426,11 @@ static inline void vc_set_color(const struct vc_data *vc, unsigned char c)
  * The console must be locked when we get here.
  */
 
-static void vt_console_print(struct console *co, const char *b, unsigned count)
+static void vt_console_print(struct console *co, const char *b,
+			     unsigned int count, unsigned int loglevel)
 {
 	struct vc_data *vc = vc_cons[fg_console].d;
-	unsigned char c;
+	unsigned char current_color, c;
 	static DEFINE_SPINLOCK(printing_lock);
 	const ushort *start;
 	ushort cnt = 0;
@@ -2453,7 +2463,13 @@ static void vt_console_print(struct console *co, const char *b, unsigned count)
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
diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
index 665341e..ae04e77 100644
--- a/drivers/net/netconsole.c
+++ b/drivers/net/netconsole.c
@@ -694,7 +694,8 @@ static struct notifier_block netconsole_netdev_notifier = {
 	.notifier_call  = netconsole_netdev_event,
 };
 
-static void write_msg(struct console *con, const char *msg, unsigned int len)
+static void write_msg(struct console *con, const char *msg, unsigned int len,
+		      unsigned int loglevel)
 {
 	int frag, left;
 	unsigned long flags;
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index 77f7a7f..21a0ebf 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2466,7 +2466,8 @@ static void serial8250_console_putchar(struct uart_port *port, int ch)
  *	The console_lock must be held when we get here.
  */
 static void
-serial8250_console_write(struct console *co, const char *s, unsigned int count)
+serial8250_console_write(struct console *co, const char *s, unsigned int count,
+			 unsigned int loglevel)
 {
 	struct uart_8250_port *up = &serial8250_ports[co->index];
 	unsigned long flags;
diff --git a/drivers/serial/8250_early.c b/drivers/serial/8250_early.c
index 38776e8..88aa01c 100644
--- a/drivers/serial/8250_early.c
+++ b/drivers/serial/8250_early.c
@@ -83,7 +83,8 @@ static void __init serial_putc(struct uart_port *port, int c)
 }
 
 static void __init early_serial8250_write(struct console *console,
-					const char *s, unsigned int count)
+					const char *s, unsigned int count,
+					unsigned int loglevel)
 {
 	struct uart_port *port = &early_device.port;
 	unsigned int ier;
diff --git a/include/linux/console.h b/include/linux/console.h
index a5f88a6..23626e6 100644
--- a/include/linux/console.h
+++ b/include/linux/console.h
@@ -94,7 +94,8 @@ void give_up_console(const struct consw *sw);
 
 struct console {
 	char	name[16];
-	void	(*write)(struct console *, const char *, unsigned);
+	void	(*write)(struct console *, const char *,
+		unsigned int, unsigned int);
 	int	(*read)(struct console *, char *, unsigned);
 	struct tty_driver *(*device)(struct console *, int *);
 	void	(*unblank)(void);
diff --git a/kernel/printk.c b/kernel/printk.c
index bdd4ea8..809ba4b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -435,7 +435,8 @@ asmlinkage long sys_syslog(int type, char __user *buf, int len)
 /*
  * Call the console drivers on a range of log_buf
  */
-static void __call_console_drivers(unsigned start, unsigned end)
+static void __call_console_drivers(unsigned int start, unsigned int end,
+				   unsigned int loglevel)
 {
 	struct console *con;
 
@@ -443,7 +444,7 @@ static void __call_console_drivers(unsigned start, unsigned end)
 		if ((con->flags & CON_ENABLED) && con->write &&
 				(cpu_online(smp_processor_id()) ||
 				(con->flags & CON_ANYTIME)))
-			con->write(con, &LOG_BUF(start), end - start);
+			con->write(con, &LOG_BUF(start), end - start, loglevel);
 	}
 }
 
@@ -470,10 +471,11 @@ static void _call_console_drivers(unsigned start,
 		if ((start & LOG_BUF_MASK) > (end & LOG_BUF_MASK)) {
 			/* wrapped write */
 			__call_console_drivers(start & LOG_BUF_MASK,
-						log_buf_len);
-			__call_console_drivers(0, end & LOG_BUF_MASK);
+						log_buf_len, msg_log_level);
+			__call_console_drivers(0, end & LOG_BUF_MASK,
+					       msg_log_level);
 		} else {
-			__call_console_drivers(start, end);
+			__call_console_drivers(start, end, msg_log_level);
 		}
 	}
 }
