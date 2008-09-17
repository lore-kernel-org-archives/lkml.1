Return-Path: <linux-kernel-owner+w=401wt.eu-S1754400AbYIQIeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400AbYIQIeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 04:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751634AbYIQIeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 04:34:04 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:58277 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbYIQIeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 04:34:01 -0400
X-IronPort-AV: E=Sophos;i="4.32,414,1217822400"; 
   d="scan'208";a="75282345"
Subject: [PATCH] [kgdb] Start kgdboc uart port to answer gdb break signal
	Ctrl+C without openning ttys.
From: sonic zhang <sonic.adi@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       kgdb mailing list <kgdb-bugreport@lists.sourceforge.net>
Content-Type: text/plain
Date: Wed, 17 Sep 2008 16:28:39 +0800
Message-Id: <1221640119.15380.22.camel@eight.analog.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Current kgdboc only configures the uart port in poll mode, which block
 any gdb break signal Ctrl+C from taking effect till a tty on the port is
 opened by an application. This patch introduces 2 hook functions in
 struct tty_operations and uart_operations. The kgdboc port can be start
 up without openning ttys after gdb is connected.

Signed-off-by: Sonic Zhang <sonic.adi@gmail.com>
---
 drivers/serial/kgdboc.c      |    8 +++++++-
 drivers/serial/serial_core.c |   38 ++++++++++++++++++++++++++++++++++++++
 include/linux/serial_core.h  |    9 +++++++++
 include/linux/tty_driver.h   |    5 +++++
 4 files changed, 59 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index eadc1ab..5d91f3d 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -70,6 +70,9 @@ static int configure_kgdboc(void)
 
 	configured = 1;
 
+	kgdb_tty_driver->ops->kgdboc_port_startup(kgdb_tty_driver,
+					kgdb_tty_line);
+
 	return 0;
 
 noconfig:
@@ -90,8 +93,11 @@ static int __init init_kgdboc(void)
 
 static void cleanup_kgdboc(void)
 {
-	if (configured == 1)
+	if (configured == 1) {
+		kgdb_tty_driver->ops->kgdboc_port_shutdown(kgdb_tty_driver,
+					kgdb_tty_line);
 		kgdb_unregister_io_module(&kgdboc_io_ops);
+	}
 }
 
 static int kgdboc_get_char(void)
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 73e9b8f..07f1b04 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -2244,6 +2244,39 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 	}
 }
 
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+static int uart_kgdboc_port_startup(struct tty_driver *driver, int line)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->port)
+		return -1;
+
+	port = state->port;
+	if (port->ops->kgdboc_port_startup)
+		return port->ops->kgdboc_port_startup(port);
+	else
+		return -1;
+}
+
+static void uart_kgdboc_port_shutdown(struct tty_driver *driver, int line)
+{
+	struct uart_driver *drv = driver->driver_state;
+	struct uart_state *state = drv->state + line;
+	struct uart_port *port;
+
+	if (!state || !state->port)
+		return;
+
+	port = state->port;
+	if (port->ops->kgdboc_port_shutdown)
+		port->ops->kgdboc_port_shutdown(port);
+}
+#endif
+
 #ifdef CONFIG_CONSOLE_POLL
 
 static int uart_poll_init(struct tty_driver *driver, int line, char *options)
@@ -2323,6 +2356,11 @@ static const struct tty_operations uart_ops = {
 #endif
 	.tiocmget	= uart_tiocmget,
 	.tiocmset	= uart_tiocmset,
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+	.kgdboc_port_startup	= uart_kgdboc_port_startup,
+	.kgdboc_port_shutdown	= uart_kgdboc_port_shutdown,
+#endif
 #ifdef CONFIG_CONSOLE_POLL
 	.poll_init	= uart_poll_init,
 	.poll_get_char	= uart_poll_get_char,
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 3b2f6c0..4a15311 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -214,6 +214,15 @@ struct uart_ops {
 	void		(*config_port)(struct uart_port *, int);
 	int		(*verify_port)(struct uart_port *, struct serial_struct *);
 	int		(*ioctl)(struct uart_port *, unsigned int, unsigned long);
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+	/*
+	 * Start up serial port earlier in kgdboc to support gdb break
+	 * signal Ctrl+C.
+	 */
+	int		(*kgdboc_port_startup)(struct uart_port *);
+	void		(*kgdboc_port_shutdown)(struct uart_port *);
+#endif
 #ifdef CONFIG_CONSOLE_POLL
 	void	(*poll_put_char)(struct uart_port *, unsigned char);
 	int		(*poll_get_char)(struct uart_port *);
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 16d2794..efd26cf 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -220,6 +220,11 @@ struct tty_operations {
 			unsigned int set, unsigned int clear);
 	int (*resize)(struct tty_struct *tty, struct tty_struct *real_tty,
 				struct winsize *ws);
+#if defined(CONFIG_KGDB_SERIAL_CONSOLE) || \
+	defined(CONFIG_KGDB_SERIAL_CONSOLE_MODULE)
+	int (*kgdboc_port_startup)(struct tty_driver *driver, int line);
+	int (*kgdboc_port_shutdown)(struct tty_driver *driver, int line);
+#endif
 #ifdef CONFIG_CONSOLE_POLL
 	int (*poll_init)(struct tty_driver *driver, int line, char *options);
 	int (*poll_get_char)(struct tty_driver *driver, int line);
-- 
1.6.0


