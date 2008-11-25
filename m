Return-Path: <linux-kernel-owner+w=401wt.eu-S1753392AbYKYVLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbYKYVLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 16:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbYKYVLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 16:11:19 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:52574 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280AbYKYVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 16:11:17 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Tue, 25 Nov 2008 22:11:10 +0100
Message-Id: <1227647470-4816-5-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1227647470-4816-4-git-send-email-giometti@linux.it>
References: <>
 <1227647470-4816-1-git-send-email-giometti@linux.it>
 <1227647470-4816-2-git-send-email-giometti@linux.it>
 <1227647470-4816-3-git-send-email-giometti@linux.it>
 <1227647470-4816-4-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.254
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH] PPS: UART PPS support replaced by new N_PPS line discipline.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Starting from now the PPS signal routed to the DCD pin of a serial
ports is managed by a dedicated line discipline.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/clients/Kconfig     |    9 +--
 drivers/pps/clients/Makefile    |    1 +
 drivers/pps/clients/pps-ldisc.c |  172 +++++++++++++++++++++++++++++++++++++++
 drivers/serial/serial_core.c    |   78 ------------------
 include/linux/serial_core.h     |   39 ++-------
 5 files changed, 184 insertions(+), 115 deletions(-)
 create mode 100644 drivers/pps/clients/pps-ldisc.c

diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 09ba5c3..b4054cd 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -15,12 +15,9 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called ktimer.ko.
 
-comment "UART serial support (forced off)"
-	depends on ! (SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y))
-
-config PPS_CLIENT_UART
-	bool "UART serial support"
-	depends on SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y)
+config PPS_CLIENT_LDISC
+	tristate "PPS line discipline"
+	depends on PPS
 	help
 	  If you say yes here you get support for a PPS source connected
 	  with the CD (Carrier Detect) pin of your serial port.
diff --git a/drivers/pps/clients/Makefile b/drivers/pps/clients/Makefile
index f3c1e39..9f5b988 100644
--- a/drivers/pps/clients/Makefile
+++ b/drivers/pps/clients/Makefile
@@ -3,6 +3,7 @@
 #
 
 obj-$(CONFIG_PPS_CLIENT_KTIMER)	+= ktimer.o
+obj-$(CONFIG_PPS_CLIENT_LDISC)	+= pps-ldisc.o
 
 ifeq ($(CONFIG_PPS_DEBUG),y)
 EXTRA_CFLAGS += -DDEBUG
diff --git a/drivers/pps/clients/pps-ldisc.c b/drivers/pps/clients/pps-ldisc.c
new file mode 100644
index 0000000..1a4c5cc
--- /dev/null
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -0,0 +1,172 @@
+/*
+ * pps-ldisc.c -- PPS line discipline
+ *
+ *
+ * Copyright (C) 2008	Rodolfo Giometti <giometti@linux.it>
+ *
+ *   This program is free software; you can redistribute it and/or modify
+ *   it under the terms of the GNU General Public License as published by
+ *   the Free Software Foundation; either version 2 of the License, or
+ *   (at your option) any later version.
+ *
+ *   This program is distributed in the hope that it will be useful,
+ *   but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *   GNU General Public License for more details.
+ *
+ *   You should have received a copy of the GNU General Public License
+ *   along with this program; if not, write to the Free Software
+ *   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#include <linux/module.h>
+#include <linux/serial_core.h>
+#include <linux/tty.h>
+#include <linux/pps.h>
+
+#define PPS_TTY_MAGIC		0x0001
+
+#ifdef CONFIG_PPS_IRQ_EVENTS
+
+static void pps_tty_dcd_change(struct uart_port *port, unsigned int status,
+				struct timespec *ts)
+{
+	int id = (int) port->info->tty->disc_data;
+
+	pps_event(id, &pps_irq_ts[port->irq],
+			status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR, port);
+
+	pr_debug("[IRQev] PPS %s at %lu on source #%d\n",
+			status ? "assert" : "clear", jiffies, id);
+}
+
+#else
+
+static void pps_tty_dcd_change(struct uart_port *port, unsigned int status,
+				struct timespec *ts)
+{
+	int id = (int) port->info->tty->disc_data;
+	struct timespec __ts;
+	struct pps_ktime pps_ts;
+
+	/* First of all we get the time stamp... */
+	getnstimeofday(&__ts);
+
+	/* Does caller give us a timestamp? */
+	if (ts) {	/* Yes. Let's use it! */
+		pps_ts.sec = ts->tv_sec;
+		pps_ts.nsec = ts->tv_nsec;
+	} else {	/* No. Do it ourself! */
+		pps_ts.sec = __ts.tv_sec;
+		pps_ts.nsec = __ts.tv_nsec;
+	}
+
+	/* Now do the PPS event report */
+	pps_event(id, &pps_ts, status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
+			port);
+
+	pr_debug("[STDev] PPS %s at %lu on source #%d\n",
+			status ? "assert" : "clear", jiffies, id);
+}
+
+#endif /* CONFIG_PPS_IRQ_EVENTS */
+
+static int pps_tty_open(struct tty_struct *tty)
+{
+	struct pps_source_info info;
+	struct tty_driver *drv = tty->driver;
+	int index = tty->index + drv->name_base;
+	int ret;
+
+	info.owner = THIS_MODULE;
+	info.dev = NULL;
+	snprintf(info.name, PPS_MAX_NAME_LEN, "%s%d", drv->driver_name, index);
+	snprintf(info.path, PPS_MAX_NAME_LEN, "/dev/%s%d", drv->name, index);
+	info.mode = PPS_CAPTUREBOTH | \
+			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+			PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+	ret = pps_register_source(&info, PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
+	if (ret < 0) {
+		pr_err("cannot register PPS source \"%s\"\n", info.path);
+		return ret;
+	}
+	tty->disc_data = (void *) ret;
+
+	/* Should open N_TTY ldisc too */
+	ret = n_tty_open(tty);
+	if (ret < 0)
+		pps_unregister_source((int) tty->disc_data);
+
+	pr_info("PPS source #%d \"%s\" added\n", ret, info.path);
+
+	return 0;
+}
+
+static void pps_tty_close(struct tty_struct *tty)
+{
+	int id = (int) tty->disc_data;
+
+	pps_unregister_source(id);
+	n_tty_close(tty);
+
+	pr_info("PPS source #%d removed\n", id);
+}
+
+struct tty_ldisc pps_ldisc = {
+	.magic		= PPS_TTY_MAGIC,
+	.name		= "pps_tty",
+	.dcd_change	= pps_tty_dcd_change,
+	.open		= pps_tty_open,
+	.close		= pps_tty_close,
+
+	/* Now we should use N_TTY ldisc methods in order to have
+	 * normal tty behaviour
+	 */
+	.flush_buffer	= n_tty_flush_buffer,
+	.chars_in_buffer = n_tty_chars_in_buffer,
+	.read		= n_tty_read,
+	.write		= n_tty_write,
+	.ioctl		= n_tty_ioctl,
+	.set_termios	= n_tty_set_termios,
+	.poll		= n_tty_poll,
+	.receive_buf	= n_tty_receive_buf,
+	.write_wakeup	= n_tty_write_wakeup
+};
+
+/*
+ * Module stuff
+ */
+
+static int __init pps_tty_init(void)
+{
+	int err;
+
+	err = tty_register_ldisc(N_PPS, &pps_ldisc);
+	if (err)
+		pr_err("can't register PPS line discipline\n");
+	else
+		pr_info("PPS line discipline registered\n");
+
+	return err;
+}
+
+static void __exit pps_tty_cleanup(void)
+{
+	int err;
+
+	err = tty_unregister_ldisc(N_PPS);
+	if (err)
+		pr_err("can't unregister PPS line discipline\n");
+	else
+		pr_info("PPS line discipline removed\n");
+}
+
+module_init(pps_tty_init);
+module_exit(pps_tty_cleanup);
+
+MODULE_ALIAS_LDISC(N_PPS);
+MODULE_AUTHOR("Rodolfo Giometti <giometti@linux.it>");
+MODULE_DESCRIPTION("PPS TTY device driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 4368a13..7e73c45 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -33,7 +33,6 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
-#include <linux/pps.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -634,63 +633,6 @@ static int uart_get_info(struct uart_state *state,
 	return 0;
 }
 
-#ifdef CONFIG_PPS_CLIENT_UART
-
-static int
-uart_register_pps_port(struct uart_state *state, struct uart_port *port)
-{
-	struct tty_driver *drv = port->info->tty->driver;
-	int ret;
-
-	state->pps_info.owner = THIS_MODULE;
-	state->pps_info.dev = port->dev;
-	snprintf(state->pps_info.name, PPS_MAX_NAME_LEN, "%s%d",
-		drv->driver_name, port->line);
-	snprintf(state->pps_info.path, PPS_MAX_NAME_LEN, "/dev/%s%d",
-		drv->name, port->line);
-
-	state->pps_info.mode = PPS_CAPTUREBOTH | \
-			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
-			PPS_CANWAIT | PPS_TSFMT_TSPEC;
-
-	ret = pps_register_source(&state->pps_info, PPS_CAPTUREBOTH | \
-				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
-	if (ret < 0) {
-		dev_err(port->dev, "cannot register PPS source \"%s\"\n",
-						state->pps_info.path);
-		return ret;
-	}
-	port->pps_source = ret;
-	dev_dbg(port->dev, "PPS source #%d \"%s\" added\n",
-		port->pps_source, state->pps_info.path);
-
-	return 0;
-}
-
-static void
-uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
-{
-	pps_unregister_source(port->pps_source);
-	dev_dbg(port->dev, "PPS source #%d \"%s\" removed\n",
-				port->pps_source, state->pps_info.path);
-}
-
-#else
-
-static inline int
-uart_register_pps_port(struct uart_state *state, struct uart_port *port)
-{
-	return 0;
-}
-
-static inline void
-uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
-{
-	/* Nop */
-}
-
-#endif /* CONFIG_PPS_CLIENT_UART */
-
 static int uart_set_info(struct uart_state *state,
 			 struct serial_struct __user *newinfo)
 {
@@ -865,14 +807,6 @@ static int uart_set_info(struct uart_state *state,
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
-	/* PPS support enabled/disabled? */
-	if ((old_flags & UPF_HARDPPS_CD) != (new_flags & UPF_HARDPPS_CD)) {
-		if (new_flags & UPF_HARDPPS_CD)
-			uart_register_pps_port(state, port);
-		else
-			uart_unregister_pps_port(state, port);
-	}
-
 	retval = 0;
 	if (port->type == PORT_UNKNOWN)
 		goto exit;
@@ -2206,12 +2140,6 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		port->ops->config_port(port, flags);
 	}
 
-	/*
-	 * Add the PPS support for the current port.
-	 */
-	if (port->flags & UPF_HARDPPS_CD)
-		uart_register_pps_port(state, port);
-
 	if (port->type != PORT_UNKNOWN) {
 		unsigned long flags;
 
@@ -2468,12 +2396,6 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
 	mutex_unlock(&state->mutex);
 
 	/*
-	 * Remove PPS support from the current port.
-	 */
-	if (port->flags & UPF_HARDPPS_CD)
-		uart_unregister_pps_port(state, port);
-
-	/*
 	 * Remove the devices from the tty layer
 	 */
 	tty_unregister_device(drv->tty_driver, port->line);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a80d1ea..80f85fc 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -240,9 +240,6 @@ struct uart_port {
 	unsigned char		regshift;		/* reg offset shift */
 	unsigned char		iotype;			/* io access style */
 	unsigned char		unused1;
-#ifdef CONFIG_PPS_CLIENT_UART
-	int			pps_source;		/* PPS source ID */
-#endif
 
 #define UPIO_PORT		(0)
 #define UPIO_HUB6		(1)
@@ -321,10 +318,6 @@ struct uart_state {
 	struct uart_info	*info;
 	struct uart_port	*port;
 
-#ifdef CONFIG_PPS_CLIENT_UART
-	struct pps_source_info	pps_info;
-#endif
-
 	struct mutex		mutex;
 };
 
@@ -488,31 +481,11 @@ static inline void
 uart_handle_dcd_change(struct uart_port *port, unsigned int status)
 {
 	struct uart_info *info = port->info;
+	struct tty_ldisc *ld = tty_ldisc_ref(info->tty);
+	struct timespec ts;
 
-#ifdef CONFIG_PPS_CLIENT_UART
-	struct timespec __ts;
-	struct pps_ktime ts;
-
-	/* First of all we get the time stamp... */
-	getnstimeofday(&__ts);
-
-	/* ... and translate it to PPS time data struct */
-	ts.sec = __ts.tv_sec;
-	ts.nsec = __ts.tv_nsec;
-
-	if (port->flags & UPF_HARDPPS_CD) {
-		pps_event(port->pps_source,
-#ifdef CONFIG_PPS_IRQ_EVENTS
-				&pps_irq_ts[port->irq],
-#else
-				&ts,
-#endif
-				status ? PPS_CAPTUREASSERT : PPS_CAPTURECLEAR,
-				port);
-		dev_dbg(port->dev, "PPS %s at %lu on source #%d\n",
-			status ? "assert" : "clear", jiffies, port->pps_source);
-	}
-#endif
+	if (ld->dcd_change)
+		getnstimeofday(&ts);
 
 	port->icount.dcd++;
 
@@ -522,6 +495,10 @@ uart_handle_dcd_change(struct uart_port *port, unsigned int status)
 		else if (info->tty)
 			tty_hangup(info->tty);
 	}
+
+	if (ld->dcd_change)
+		ld->dcd_change(port, status, &ts);
+	tty_ldisc_deref(ld);
 }
 
 /**
-- 
1.5.4.3

