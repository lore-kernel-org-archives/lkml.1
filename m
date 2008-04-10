Return-Path: <linux-kernel-owner+w=401wt.eu-S1760136AbYDJPRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760136AbYDJPRl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 11:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759226AbYDJPQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 11:16:24 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:40694 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759105AbYDJPQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 11:16:20 -0400
From: Rodolfo Giometti <giometti@linux.it>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, Dave Jones <davej@redhat.com>,
       Sam Ravnborg <sam@ravnborg.org>, Greg KH <greg@kroah.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>,
       Rodolfo Giometti <giometti@linux.it>
Date: Thu, 10 Apr 2008 17:15:58 +0200
Message-Id: <1207840560-24015-6-git-send-email-giometti@linux.it>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <1207840560-24015-5-git-send-email-giometti@linux.it>
References: <>
 <1207840560-24015-1-git-send-email-giometti@linux.it>
 <1207840560-24015-2-git-send-email-giometti@linux.it>
 <1207840560-24015-3-git-send-email-giometti@linux.it>
 <1207840560-24015-4-git-send-email-giometti@linux.it>
 <1207840560-24015-5-git-send-email-giometti@linux.it>
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: [PATCH 5/7] PPS: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds support for the PPS sources connected with the CD (Carrier
Detect) pin of a serial port.

Signed-off-by: Rodolfo Giometti <giometti@linux.it>
---
 drivers/pps/clients/Kconfig  |   10 +++
 drivers/serial/8250.c        |    2 +
 drivers/serial/serial_core.c |  131 ++++++++++++++++++++++++++++++++----------
 include/linux/serial_core.h  |   30 ++++++++--
 4 files changed, 136 insertions(+), 37 deletions(-)

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
index 77f7a7f..880cbeb 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -2119,6 +2119,8 @@ serial8250_set_termios(struct uart_port *port, struct ktermios *termios,
 		up->ier |= UART_IER_MSI;
 	if (up->capabilities & UART_CAP_UUE)
 		up->ier |= UART_IER_UUE | UART_IER_RTOIE;
+	if (up->port.flags & UPF_HARDPPS_CD)
+		up->ier |= UART_IER_MSI;	/* enable interrupts */
 
 	serial_out(up, UART_IER, up->ier);
 
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index 0f5a179..5a97e63 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -33,6 +33,7 @@
 #include <linux/serial.h> /* for serial_state and serial_icounter_struct */
 #include <linux/delay.h>
 #include <linux/mutex.h>
+#include <linux/pps.h>
 
 #include <asm/irq.h>
 #include <asm/uaccess.h>
@@ -58,8 +59,7 @@ static struct lock_class_key port_lock_key;
 #define uart_console(port)	(0)
 #endif
 
-static void uart_change_speed(struct uart_state *state,
-					struct ktermios *old_termios);
+static void uart_change_speed(struct uart_state *state, struct ktermios *old_termios);
 static void uart_wait_until_sent(struct tty_struct *tty, int timeout);
 static void uart_change_pm(struct uart_state *state, int pm_state);
 
@@ -130,8 +130,8 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 	spin_unlock_irqrestore(&port->lock, flags);
 }
 
-#define uart_set_mctrl(port, set)	uart_update_mctrl(port, set, 0)
-#define uart_clear_mctrl(port, clear)	uart_update_mctrl(port, 0, clear)
+#define uart_set_mctrl(port,set)	uart_update_mctrl(port,set,0)
+#define uart_clear_mctrl(port,clear)	uart_update_mctrl(port,0,clear)
 
 /*
  * Startup the port.  This will be called once per open.  All calls
@@ -291,7 +291,7 @@ uart_update_timeout(struct uart_port *port, unsigned int cflag,
 		break;
 	default:
 		bits = 10;
-		break; /* CS8 */
+		break; // CS8
 	}
 
 	if (cflag & CSTOPB)
@@ -372,8 +372,7 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		 */
 		termios->c_cflag &= ~CBAUD;
 		if (old) {
-			baud = tty_termios_baud_rate(old);
-			tty_termios_encode_baud_rate(termios, baud, baud);
+			termios->c_cflag |= old->c_cflag & CBAUD;
 			old = NULL;
 			continue;
 		}
@@ -382,7 +381,7 @@ uart_get_baud_rate(struct uart_port *port, struct ktermios *termios,
 		 * As a last resort, if the quotient is zero,
 		 * default to 9600 bps
 		 */
-		tty_termios_encode_baud_rate(termios, 9600, 9600);
+		termios->c_cflag |= B9600;
 	}
 
 	return 0;
@@ -635,6 +634,63 @@ static int uart_get_info(struct uart_state *state,
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
+static inline int
+uart_register_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	return 0;
+}
+
+static inline void
+uart_unregister_pps_port(struct uart_state *state, struct uart_port *port)
+{
+	/* Nop */
+}
+
+#endif /* CONFIG_PPS_CLIENT_UART */
+
 static int uart_set_info(struct uart_state *state,
 			 struct serial_struct __user *newinfo)
 {
@@ -789,8 +845,7 @@ static int uart_set_info(struct uart_state *state,
 			 * We failed anyway.
 			 */
 			retval = -EBUSY;
-			/* Added to return the correct error -Ram Gupta */
-			goto exit;
+			goto exit;  // Added to return the correct error -Ram Gupta
 		}
 	}
 
@@ -810,11 +865,19 @@ static int uart_set_info(struct uart_state *state,
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
@@ -1139,8 +1202,7 @@ uart_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd,
 	return ret;
 }
 
-static void uart_set_termios(struct tty_struct *tty,
-						struct ktermios *old_termios)
+static void uart_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct uart_state *state = tty->driver_data;
 	unsigned long flags;
@@ -1464,8 +1526,9 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 		 */
 		if ((filp->f_flags & O_NONBLOCK) ||
 		    (info->tty->termios->c_cflag & CLOCAL) ||
-		    (info->tty->flags & (1 << TTY_IO_ERROR)))
+		    (info->tty->flags & (1 << TTY_IO_ERROR))) {
 			break;
+		}
 
 		/*
 		 * Set DTR to allow modem to know we're waiting.  Do
@@ -1553,8 +1616,8 @@ static struct uart_state *uart_get(struct uart_driver *drv, int line)
 }
 
 /*
- * calls to uart_open are serialised by the BKL in
- *   fs/char_dev.c:chrdev_open()
+ * In 2.4.5, calls to uart_open are serialised by the BKL in
+ *   linux/fs/devices.c:chrdev_open()
  * Note that if this fails, then uart_close() _will_ be called.
  *
  * In time, we want to scrap the "opening nonpresent ports"
@@ -1684,7 +1747,8 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 		return ret + 1;
 	}
 
-	if (capable(CAP_SYS_ADMIN)) {
+	if(capable(CAP_SYS_ADMIN))
+	{
 		mutex_lock(&state->mutex);
 		pm_state = state->pm_state;
 		if (pm_state)
@@ -1711,11 +1775,11 @@ static int uart_line_info(char *buf, struct uart_driver *drv, int i)
 			ret += sprintf(buf + ret, " oe:%d",
 				port->icount.overrun);
 
-#define INFOBIT(bit, str) \
+#define INFOBIT(bit,str) \
 	if (port->mctrl & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 			strlen(stat_buf) - 2)
-#define STATBIT(bit, str) \
+#define STATBIT(bit,str) \
 	if (status & (bit)) \
 		strncat(stat_buf, (str), sizeof(stat_buf) - \
 		       strlen(stat_buf) - 2)
@@ -1979,7 +2043,6 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 
 	if (state->info && state->info->flags & UIF_INITIALIZED) {
 		const struct uart_ops *ops = port->ops;
-		int tries;
 
 		state->info->flags = (state->info->flags & ~UIF_INITIALIZED)
 				     | UIF_SUSPENDED;
@@ -1993,14 +2056,9 @@ int uart_suspend_port(struct uart_driver *drv, struct uart_port *port)
 		/*
 		 * Wait for the transmitter to empty.
 		 */
-		for (tries = 3; !ops->tx_empty(port) && tries; tries--)
+		while (!ops->tx_empty(port)) {
 			msleep(10);
-		if (!tries)
-			printk(KERN_ERR "%s%s%s%d: Unable to drain "
-					"transmitter\n",
-			       port->dev ? port->dev->bus_id : "",
-			       port->dev ? ": " : "",
-			       drv->dev_name, port->line);
+		}
 
 		ops->shutdown(port);
 	}
@@ -2037,6 +2095,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 	}
 	port->suspended = 0;
 
+	uart_change_pm(state, 0);
+
 	/*
 	 * Re-enable the console device after suspending.
 	 */
@@ -2055,7 +2115,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 		if (state->info && state->info->tty && termios.c_cflag == 0)
 			termios = *state->info->tty->termios;
 
-		uart_change_pm(state, 0);
 		port->ops->set_termios(port, &termios, NULL);
 		console_start(port->cons);
 	}
@@ -2064,7 +2123,6 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 		const struct uart_ops *ops = port->ops;
 		int ret;
 
-		uart_change_pm(state, 0);
 		ops->set_mctrl(port, 0);
 		ret = ops->startup(port);
 		if (ret == 0) {
@@ -2148,6 +2206,12 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
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
 
@@ -2158,11 +2222,10 @@ uart_configure_port(struct uart_driver *drv, struct uart_state *state,
 
 		/*
 		 * Ensure that the modem control lines are de-activated.
-		 * keep the DTR setting that is set in uart_set_options()
 		 * We probably don't need a spinlock around this, but
 		 */
 		spin_lock_irqsave(&port->lock, flags);
-		port->ops->set_mctrl(port, port->mctrl & TIOCM_DTR);
+		port->ops->set_mctrl(port, 0);
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
@@ -2405,6 +2468,12 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
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
index 289942f..0f8fbd4 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -166,6 +166,7 @@
 #include <linux/tty.h>
 #include <linux/mutex.h>
 #include <linux/sysrq.h>
+#include <linux/pps.h>
 
 struct uart_port;
 struct uart_info;
@@ -245,6 +246,9 @@ struct uart_port {
 	unsigned char		regshift;		/* reg offset shift */
 	unsigned char		iotype;			/* io access style */
 	unsigned char		unused1;
+#ifdef CONFIG_PPS_CLIENT_UART
+	int			pps_source;		/* PPS source ID */
+#endif
 
 #define UPIO_PORT		(0)
 #define UPIO_HUB6		(1)
@@ -289,7 +293,8 @@ struct uart_port {
 #define UPF_IOREMAP		((__force upf_t) (1 << 31))
 
 #define UPF_CHANGE_MASK		((__force upf_t) (0x17fff))
-#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY))
+#define UPF_USR_MASK		((__force upf_t) (UPF_SPD_MASK|UPF_LOW_LATENCY\
+							|UPF_HARDPPS_CD))
 
 	unsigned int		mctrl;			/* current modem ctrl settings */
 	unsigned int		timeout;		/* character-based timeout */
@@ -322,6 +327,10 @@ struct uart_state {
 	struct uart_info	*info;
 	struct uart_port	*port;
 
+#ifdef CONFIG_PPS_CLIENT_UART
+	struct pps_source_info	pps_info;
+#endif
+
 	struct mutex		mutex;
 };
 
@@ -486,13 +495,22 @@ uart_handle_dcd_change(struct uart_port *port, unsigned int status)
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
1.5.4.3

