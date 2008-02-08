Return-Path: <linux-kernel-owner+w=401wt.eu-S965008AbYBHSDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965008AbYBHSDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:03:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933477AbYBHR5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 12:57:51 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:38140 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933427AbYBHR5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 12:57:40 -0500
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Rodolfo Giometti <giometti@linux.it>
Date: Fri,  8 Feb 2008 19:00:42 +0100
Message-Id: <12024936441151-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <1202493644247-git-send-email-giometti@linux.it>
References: <1202493644764-git-send-email-giometti@linux.it>
 <120249364418-git-send-email-giometti@linux.it>
 <12024936442252-git-send-email-giometti@linux.it>
 <12024936441531-git-send-email-giometti@linux.it>
 <12024936442967-git-send-email-giometti@linux.it>
 <1202493644247-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 6/8] PPS: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the PPS sources connected with the CD (Carrier
Detect) pin of a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/clients/Kconfig  |   10 ++++++
 drivers/serial/8250.c        |    2 +
 drivers/serial/serial_core.c |   71 +++++++++++++++++++++++++++++++++++++++++-
 include/linux/serial_core.h  |   30 ++++++++++++++---
 4 files changed, 106 insertions(+), 7 deletions(-)

diff --git a/drivers/pps/clients/Kconfig b/drivers/pps/clients/Kconfig
index 60b83be..517c338 100644
--- a/drivers/pps/clients/Kconfig
+++ b/drivers/pps/clients/Kconfig
@@ -15,4 +15,14 @@ config PPS_CLIENT_KTIMER
 	  This driver can also be built as a module.  If so, the module
 	  will be called ktimer.ko.
 
+comment "UART serial support (forced off)"
+	depends on ! (SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y))
+
+config PPS_CLIENT_UART
+	bool "UART serial support"
+	depends on SERIAL_CORE != n && !(PPS = m && SERIAL_CORE = y)
+	help
+	  If you say yes here you get support for a PPS source connected
+	  with the CD (Carrier Detect) pin of your serial port.
+
 endif
diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index f94109c..a5e83f8 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2118,6 +2118,8 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		up->ier |= UART_IER_MSI;
 	if (up->capabilities & UART_CAP_UUE)
 		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
+	if (up->port.flags & UPF_HARDPPS_CD)
+		up->ier |= UART_IER_MSI;	/* enable interrupts */
 
 	serial_out(up, UART_IER, up->ier);
 
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 3bb5d24..ff6cdac 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/pps.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -633,6 +634,54 @@ static int uart_get_info(struct uart_state *state,
 	return 0;
 }
 
+#ifdef CONFIG_PPS_CLIENT_UART
+
+static int
+uart_register_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	struct tty_driver *drv = port->info->tty->driver;
+	int ret;
+
+	state->pps_info.owner = THIS_MODULE;
+	state->pps_info.dev = port->dev;
+	snprintf(state->pps_info.name, PPS_MAX_NAME_LEN, "%s%d",
+		drv->driver_name, port->line);
+	snprintf(state->pps_info.path, PPS_MAX_NAME_LEN, "/dev/%s%d",
+		drv->name, port->line);
+
+	state->pps_info.mode = PPS_CAPTUREBOTH | \
+			PPS_OFFSETASSERT | PPS_OFFSETCLEAR | \
+			PPS_CANWAIT | PPS_TSFMT_TSPEC;
+
+	ret = pps_register_source(&state->pps_info, PPS_CAPTUREBOTH | \
+				PPS_OFFSETASSERT | PPS_OFFSETCLEAR);
+	if (ret < 0) {
+		dev_err(port->dev, "cannot register PPS source \"%s\"\n",
+						state->pps_info.path);
+		return ret;
+	}
+	port->pps_source = ret;
+	dev_dbg(port->dev, "PPS source #%d \"%s\" added\n",
+		port->pps_source, state->pps_info.path);
+
+	return 0;
+}
+
+static void
+uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	pps_unregister_source(port->pps_source);
+	dev_dbg(port->dev, "PPS source #%d \"%s\" removed\n",
+				port->pps_source, state->pps_info.path);
+}
+
+#else
+
+#define uart_register_pps_port(state, port)	do { } while (0)
+#define uart_unregister_pps_port(state, port)	do { } while (0)
+
+#endif /* CONFIG_PPS_CLIENT_UART */
+
 static int uart_set_info(struct uart_state *state,
 			 struct serial_struct __user *newinfo)
 {
@@ -807,11 +856,19 @@ static int uart_set_info(struct uart_state *state,
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
+	/* PPS support enabled/disabled? */
+	if ((old_flags & UPF_HARDPPS_CD) != (new_flags & UPF_HARDPPS_CD)) {
+		if (new_flags & UPF_HARDPPS_CD)
+			uart_register_pps_port(state, port);
+		else
+			uart_unregister_pps_port(state, port);
+	}
+
 	retval = 0;
 	if (port->type == PORT_UNKNOWN)
 		goto exit;
 	if (state->info->flags & UIF_INITIALIZED) {
-		if (((old_flags ^ port->flags) & UPF_SPD_MASK) ||
+		if (((old_flags ^ port->flags) & (UPF_SPD_MASK|UPF_HARDPPS_CD)) ||
 		    old_custom_divisor != port->custom_divisor) {
 			/*
 			 * If they're setting up a custom divisor or speed,
@@ -2140,6 +2197,12 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 		port->ops->config_port(port, flags);
 	}
 
+	/*
+	 * Add the PPS support for the current port.
+	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_register_pps_port(state, port);
+
 	if (port->type != PORT_UNKNOWN) {
 		unsigned long flags;
 
@@ -2396,6 +2459,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
 	mutex_unlock(&state->mutex);
 
 	/*
+	 * Remove PPS support from the current port.
+	 */
+	if (port->flags & UPF_HARDPPS_CD)
+		uart_unregister_pps_port(state, port);
+
+	/*
 	 * Remove the devices from the tty layer
 	 */
 	tty_unregister_device(drv->tty_driver, port->line);
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index 9963f81..c8e4d92 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -160,6 +160,7 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
+#include <linux/pps.h>
 
 struct uart_port;
 struct uart_info;
@@ -239,6 +240,9 @@ struct uart_port {
 	unsigned char		regshift;		/* reg offset shift */
 	unsigned char		iotype;			/* io access style */
 	unsigned char		unused1;
+#ifdef CONFIG_PPS_CLIENT_UART
+	int			pps_source;		/* PPS source ID */
+#endif
 
 #define UPIO_PORT		(0)
 #define UPIO_HUB6		(1)
@@ -283,7 +287,8 @@ struct uart_port {
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
 #define UPF_CHANGE_MASK		((__force upf_t) (0x17fff))
-#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY))
+#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY\
+							|UPF_HARDPPS_CD))
 
 	unsigned int		mctrl;			/* current modem ctrl settings */
 	unsigned int		timeout;		/* character-based timeout */
@@ -316,6 +321,10 @@ struct uart_state {
 	struct uart_info	*info;
 	struct uart_port	*port;
 
+#ifdef CONFIG_PPS_CLIENT_UART
+	struct pps_source_info	pps_info;
+#endif
+
 	struct mutex		mutex;
 };
 
@@ -480,13 +489,22 @@ uart_handle_dcd_change(struct uart_port *port, unsigned int status)
 {
 	struct uart_info *info = port->info;
 
-	port->icount.dcd++;
-
-#ifdef CONFIG_HARD_PPS
-	if ((port->flags & UPF_HARDPPS_CD) && status)
-		hardpps();
+#ifdef CONFIG_PPS_CLIENT_UART
+	if (port->flags & UPF_HARDPPS_CD) {
+		if (status) {
+			pps_event(port->pps_source, PPS_CAPTUREASSERT, port);
+			dev_dbg(port->dev, "PPS assert at %lu on source #%d\n",
+				jiffies, port->pps_source);
+		} else {
+			pps_event(port->pps_source, PPS_CAPTURECLEAR, port);
+			dev_dbg(port->dev, "PPS clear at %lu on source #%d\n",
+				jiffies, port->pps_source);
+		}
+	}
 #endif
 
+	port->icount.dcd++;
+
 	if (info->flags & UIF_CHECK_CD) {
 		if (status)
 			wake_up_interruptible(&info->open_wait);
-- 
1.5.2.5

