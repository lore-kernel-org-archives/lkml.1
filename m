Return-Path: <linux-kernel-owner+w=401wt.eu-S1761281AbYESPIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbYESPIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752044AbYESPEe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:04:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39745 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761356AbYESPEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:04:31 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 15/20] serial: use tty_port
To: linux-kernel@vger.kernel.org, akpm@osdl.org, greg@kroah.com
Date: Mon, 19 May 2008 15:51:32 +0100
Message-ID: <20080519145131.19326.64425.stgit@core>
In-Reply-To: <20080519144557.19326.74313.stgit@core>
References: <20080519144557.19326.74313.stgit@core>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Switch the serial_core based drivers to use the new tty_port structure. We
can't quite use all of it yet because of the dynamically allocated extras
in the serial_core layer.
---

 drivers/serial/8250.c        |    2 +
 drivers/serial/jsm/jsm_neo.c |    2 +
 drivers/serial/jsm/jsm_tty.c |    8 ++--
 drivers/serial/serial_core.c |   80 ++++++++++++++++++++++--------------------
 include/linux/serial_core.h  |   26 ++++++--------
 5 files changed, 60 insertions(+), 58 deletions(-)


diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
index a1ca9b7..56ca93a 100644
--- a/drivers/serial/8250.c
+++ b/drivers/serial/8250.c
@@ -1290,7 +1290,7 @@ static void serial8250_enable_ms(struct uart_port *port)
 static void
 receive_chars(struct uart_8250_port *up, unsigned int *status)
 {
-	struct tty_struct *tty = up->port.info->tty;
+	struct tty_struct *tty = up->port.info->port.tty;
 	unsigned char ch, lsr = *status;
 	int max_count = 256;
 	char flag;
diff --git a/drivers/serial/jsm/jsm_neo.c b/drivers/serial/jsm/jsm_neo.c
index b2d6f5b..b7584ca 100644
--- a/drivers/serial/jsm/jsm_neo.c
+++ b/drivers/serial/jsm/jsm_neo.c
@@ -998,7 +998,7 @@ static void neo_param(struct jsm_channel *ch)
 			{     50, B50     },
 		};
 
-		cflag = C_BAUD(ch->uart_port.info->tty);
+		cflag = C_BAUD(ch->uart_port.info->port.tty);
 		baud = 9600;
 		for (i = 0; i < ARRAY_SIZE(baud_rates); i++) {
 			if (baud_rates[i].cflag == cflag) {
diff --git a/drivers/serial/jsm/jsm_tty.c b/drivers/serial/jsm/jsm_tty.c
index 94ec663..a697914 100644
--- a/drivers/serial/jsm/jsm_tty.c
+++ b/drivers/serial/jsm/jsm_tty.c
@@ -145,7 +145,7 @@ static void jsm_tty_send_xchar(struct uart_port *port, char ch)
 	struct ktermios *termios;
 
 	spin_lock_irqsave(&port->lock, lock_flags);
-	termios = port->info->tty->termios;
+	termios = port->info->port.tty->termios;
 	if (ch == termios->c_cc[VSTART])
 		channel->ch_bd->bd_ops->send_start_character(channel);
 
@@ -239,7 +239,7 @@ static int jsm_tty_open(struct uart_port *port)
 	channel->ch_cached_lsr = 0;
 	channel->ch_stops_sent = 0;
 
-	termios = port->info->tty->termios;
+	termios = port->info->port.tty->termios;
 	channel->ch_c_cflag	= termios->c_cflag;
 	channel->ch_c_iflag	= termios->c_iflag;
 	channel->ch_c_oflag	= termios->c_oflag;
@@ -272,7 +272,7 @@ static void jsm_tty_close(struct uart_port *port)
 	jsm_printk(CLOSE, INFO, &channel->ch_bd->pci_dev, "start\n");
 
 	bd = channel->ch_bd;
-	ts = channel->uart_port.info->tty->termios;
+	ts = channel->uart_port.info->port.tty->termios;
 
 	channel->ch_flags &= ~(CH_STOPI);
 
@@ -515,7 +515,7 @@ void jsm_input(struct jsm_channel *ch)
 	if (!ch)
 		return;
 
-	tp = ch->uart_port.info->tty;
+	tp = ch->uart_port.info->port.tty;
 
 	bd = ch->ch_bd;
 	if(!bd)
diff --git a/drivers/serial/serial_core.c b/drivers/serial/serial_core.c
index eab0327..1c4fe79 100644
--- a/drivers/serial/serial_core.c
+++ b/drivers/serial/serial_core.c
@@ -50,7 +50,7 @@ static struct lock_class_key port_lock_key;
 
 #define HIGH_BITS_OFFSET	((sizeof(long)-sizeof(int))*8)
 
-#define uart_users(state)	((state)->count + ((state)->info ? (state)->info->blocked_open : 0))
+#define uart_users(state)	((state)->count + ((state)->info ? (state)->info->port.blocked_open : 0))
 
 #ifdef CONFIG_SERIAL_CORE_CONSOLE
 #define uart_console(port)	((port)->cons && (port)->cons->index == (port)->line)
@@ -113,7 +113,7 @@ static void uart_start(struct tty_struct *tty)
 static void uart_tasklet_action(unsigned long data)
 {
 	struct uart_state *state = (struct uart_state *)data;
-	tty_wakeup(state->info->tty);
+	tty_wakeup(state->info->port.tty);
 }
 
 static inline void
@@ -135,7 +135,7 @@ uart_update_mctrl(struct uart_port *port, unsigned int set, unsigned int clear)
 
 /*
  * Startup the port.  This will be called once per open.  All calls
- * will be serialised by the per-port semaphore.
+ * will be serialised by the per-port mutex.
  */
 static int uart_startup(struct uart_state *state, int init_hw)
 {
@@ -152,7 +152,7 @@ static int uart_startup(struct uart_state *state, int init_hw)
 	 * once we have successfully opened the port.  Also set
 	 * up the tty->alt_speed kludge
 	 */
-	set_bit(TTY_IO_ERROR, &info->tty->flags);
+	set_bit(TTY_IO_ERROR, &info->port.tty->flags);
 
 	if (port->type == PORT_UNKNOWN)
 		return 0;
@@ -162,6 +162,7 @@ static int uart_startup(struct uart_state *state, int init_hw)
 	 * buffer.
 	 */
 	if (!info->xmit.buf) {
+		/* This is protected by the per port mutex */
 		page = get_zeroed_page(GFP_KERNEL);
 		if (!page)
 			return -ENOMEM;
@@ -182,20 +183,20 @@ static int uart_startup(struct uart_state *state, int init_hw)
 			 * Setup the RTS and DTR signals once the
 			 * port is open and ready to respond.
 			 */
-			if (info->tty->termios->c_cflag & CBAUD)
+			if (info->port.tty->termios->c_cflag & CBAUD)
 				uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
 		}
 
 		if (info->flags & UIF_CTS_FLOW) {
 			spin_lock_irq(&port->lock);
 			if (!(port->ops->get_mctrl(port) & TIOCM_CTS))
-				info->tty->hw_stopped = 1;
+				info->port.tty->hw_stopped = 1;
 			spin_unlock_irq(&port->lock);
 		}
 
 		info->flags |= UIF_INITIALIZED;
 
-		clear_bit(TTY_IO_ERROR, &info->tty->flags);
+		clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
 	}
 
 	if (retval && capable(CAP_SYS_ADMIN))
@@ -217,8 +218,8 @@ static void uart_shutdown(struct uart_state *state)
 	/*
 	 * Set the TTY IO error marker
 	 */
-	if (info->tty)
-		set_bit(TTY_IO_ERROR, &info->tty->flags);
+	if (info->port.tty)
+		set_bit(TTY_IO_ERROR, &info->port.tty->flags);
 
 	if (info->flags & UIF_INITIALIZED) {
 		info->flags &= ~UIF_INITIALIZED;
@@ -226,7 +227,7 @@ static void uart_shutdown(struct uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
-		if (!info->tty || (info->tty->termios->c_cflag & HUPCL))
+		if (!info->port.tty || (info->port.tty->termios->c_cflag & HUPCL))
 			uart_clear_mctrl(port, TIOCM_DTR | TIOCM_RTS);
 
 		/*
@@ -426,7 +427,7 @@ EXPORT_SYMBOL(uart_get_divisor);
 static void
 uart_change_speed(struct uart_state *state, struct ktermios *old_termios)
 {
-	struct tty_struct *tty = state->info->tty;
+	struct tty_struct *tty = state->info->port.tty;
 	struct uart_port *port = state->port;
 	struct ktermios *termios;
 
@@ -834,8 +835,8 @@ static int uart_set_info(struct uart_state *state,
 	state->closing_wait    = closing_wait;
 	if (new_serial.xmit_fifo_size)
 		port->fifosize = new_serial.xmit_fifo_size;
-	if (state->info->tty)
-		state->info->tty->low_latency =
+	if (state->info->port.tty)
+		state->info->port.tty->low_latency =
 			(port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 
  check_and_exit:
@@ -855,7 +856,7 @@ static int uart_set_info(struct uart_state *state,
 				printk(KERN_NOTICE
 				       "%s sets custom speed on %s. This "
 				       "is deprecated.\n", current->comm,
-				       tty_name(state->info->tty, buf));
+				       tty_name(state->info->port.tty, buf));
 			}
 			uart_change_speed(state, NULL);
 		}
@@ -887,7 +888,7 @@ static int uart_get_lsr_info(struct uart_state *state,
 	 */
 	if (port->x_char ||
 	    ((uart_circ_chars_pending(&state->info->xmit) > 0) &&
-	     !state->info->tty->stopped && !state->info->tty->hw_stopped))
+	     !state->info->port.tty->stopped && !state->info->port.tty->hw_stopped))
 		result &= ~TIOCSER_TEMT;
 
 	return put_user(result, value);
@@ -1228,7 +1229,7 @@ static void uart_set_termios(struct tty_struct *tty,
 	 */
 	if (!(old_termios->c_cflag & CLOCAL) &&
 	    (tty->termios->c_cflag & CLOCAL))
-		wake_up_interruptible(&state->info->open_wait);
+		wake_up_interruptible(&state->info->port.open_wait);
 #endif
 }
 
@@ -1309,9 +1310,9 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
-	state->info->tty = NULL;
+	state->info->port.tty = NULL;
 
-	if (state->info->blocked_open) {
+	if (state->info->port.blocked_open) {
 		if (state->close_delay)
 			msleep_interruptible(state->close_delay);
 	} else if (!uart_console(port)) {
@@ -1322,7 +1323,7 @@ static void uart_close(struct tty_struct *tty, struct file *filp)
 	 * Wake up anyone trying to open this port.
 	 */
 	state->info->flags &= ~UIF_NORMAL_ACTIVE;
-	wake_up_interruptible(&state->info->open_wait);
+	wake_up_interruptible(&state->info->port.open_wait);
 
  done:
 	mutex_unlock(&state->mutex);
@@ -1406,8 +1407,8 @@ static void uart_hangup(struct tty_struct *tty)
 		uart_shutdown(state);
 		state->count = 0;
 		state->info->flags &= ~UIF_NORMAL_ACTIVE;
-		state->info->tty = NULL;
-		wake_up_interruptible(&state->info->open_wait);
+		state->info->port.tty = NULL;
+		wake_up_interruptible(&state->info->port.open_wait);
 		wake_up_interruptible(&state->info->delta_msr_wait);
 	}
 	mutex_unlock(&state->mutex);
@@ -1421,7 +1422,7 @@ static void uart_hangup(struct tty_struct *tty)
  */
 static void uart_update_termios(struct uart_state *state)
 {
-	struct tty_struct *tty = state->info->tty;
+	struct tty_struct *tty = state->info->port.tty;
 	struct uart_port *port = state->port;
 
 	if (uart_console(port) && port->cons->cflag) {
@@ -1460,17 +1461,17 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 	struct uart_port *port = state->port;
 	unsigned int mctrl;
 
-	info->blocked_open++;
+	info->port.blocked_open++;
 	state->count--;
 
-	add_wait_queue(&info->open_wait, &wait);
+	add_wait_queue(&info->port.open_wait, &wait);
 	while (1) {
 		set_current_state(TASK_INTERRUPTIBLE);
 
 		/*
 		 * If we have been hung up, tell userspace/restart open.
 		 */
-		if (tty_hung_up_p(filp) || info->tty == NULL)
+		if (tty_hung_up_p(filp) || info->port.tty == NULL)
 			break;
 
 		/*
@@ -1489,8 +1490,8 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 		 * have set TTY_IO_ERROR for a non-existant port.
 		 */
 		if ((filp->f_flags & O_NONBLOCK) ||
-		    (info->tty->termios->c_cflag & CLOCAL) ||
-		    (info->tty->flags & (1 << TTY_IO_ERROR)))
+		    (info->port.tty->termios->c_cflag & CLOCAL) ||
+		    (info->port.tty->flags & (1 << TTY_IO_ERROR)))
 			break;
 
 		/*
@@ -1498,7 +1499,7 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 		 * not set RTS here - we want to make sure we catch
 		 * the data from the modem.
 		 */
-		if (info->tty->termios->c_cflag & CBAUD)
+		if (info->port.tty->termios->c_cflag & CBAUD)
 			uart_set_mctrl(port, TIOCM_DTR);
 
 		/*
@@ -1520,15 +1521,15 @@ uart_block_til_ready(struct file *filp, struct uart_state *state)
 			break;
 	}
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&info->open_wait, &wait);
+	remove_wait_queue(&info->port.open_wait, &wait);
 
 	state->count++;
-	info->blocked_open--;
+	info->port.blocked_open--;
 
 	if (signal_pending(current))
 		return -ERESTARTSYS;
 
-	if (!info->tty || tty_hung_up_p(filp))
+	if (!info->port.tty || tty_hung_up_p(filp))
 		return -EAGAIN;
 
 	return 0;
@@ -1551,10 +1552,13 @@ static struct uart_state *uart_get(struct uart_driver *drv, int line)
 		goto err_unlock;
 	}
 
+	/* BKL: RACE HERE - LEAK */
+	/* We should move this into the uart_state structure and kill off
+	   this whole complexity */
 	if (!state->info) {
 		state->info = kzalloc(sizeof(struct uart_info), GFP_KERNEL);
 		if (state->info) {
-			init_waitqueue_head(&state->info->open_wait);
+			init_waitqueue_head(&state->info->port.open_wait);
 			init_waitqueue_head(&state->info->delta_msr_wait);
 
 			/*
@@ -1611,7 +1615,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	 * be re-entered while allocating the info structure, or while we
 	 * request any IRQs that the driver may need.  This also has the nice
 	 * side-effect that it delays the action of uart_hangup, so we can
-	 * guarantee that info->tty will always contain something reasonable.
+	 * guarantee that info->port.tty will always contain something reasonable.
 	 */
 	state = uart_get(drv, line);
 	if (IS_ERR(state)) {
@@ -1627,7 +1631,7 @@ static int uart_open(struct tty_struct *tty, struct file *filp)
 	tty->driver_data = state;
 	tty->low_latency = (state->port->flags & UPF_LOW_LATENCY) ? 1 : 0;
 	tty->alt_speed = 0;
-	state->info->tty = tty;
+	state->info->port.tty = tty;
 
 	/*
 	 * If the port is in the middle of closing, bail out now.
@@ -2085,8 +2089,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *port)
 		/*
 		 * If that's unset, use the tty termios setting.
 		 */
-		if (state->info && state->info->tty && termios.c_cflag == 0)
-			termios = *state->info->tty->termios;
+		if (state->info && state->info->port.tty && termios.c_cflag == 0)
+			termios = *state->info->port.tty->termios;
 
 		uart_change_pm(state, 0);
 		port->ops->set_termios(port, &termios, NULL);
@@ -2504,8 +2508,8 @@ int uart_remove_one_port(struct uart_driver *drv, struct uart_port *port)
 	tty_unregister_device(drv->tty_driver, port->line);
 
 	info = state->info;
-	if (info && info->tty)
-		tty_vhangup(info->tty);
+	if (info && info->port.tty)
+		tty_vhangup(info->port.tty);
 
 	/*
 	 * All users of this port should now be disconnected from
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index d32123a..2fbe004 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -342,13 +342,15 @@ typedef unsigned int __bitwise__ uif_t;
  * stuff here.
  */
 struct uart_info {
-	struct tty_struct	*tty;
+	struct tty_port		port;
 	struct circ_buf		xmit;
 	uif_t			flags;
 
 /*
  * Definitions for info->flags.  These are _private_ to serial_core, and
  * are specific to this structure.  They may be queried by low level drivers.
+ *
+ * FIXME: use the ASY_ definitions
  */
 #define UIF_CHECK_CD		((__force uif_t) (1 << 25))
 #define UIF_CTS_FLOW		((__force uif_t) (1 << 26))
@@ -356,11 +358,7 @@ struct uart_info {
 #define UIF_INITIALIZED		((__force uif_t) (1 << 31))
 #define UIF_SUSPENDED		((__force uif_t) (1 << 30))
 
-	int			blocked_open;
-
 	struct tasklet_struct	tlet;
-
-	wait_queue_head_t	open_wait;
 	wait_queue_head_t	delta_msr_wait;
 };
 
@@ -437,8 +435,8 @@ int uart_resume_port(struct uart_driver *reg, struct uart_port *port);
 #define uart_circ_chars_free(circ)	\
 	(CIRC_SPACE((circ)->head, (circ)->tail, UART_XMIT_SIZE))
 
-#define uart_tx_stopped(port)		\
-	((port)->info->tty->stopped || (port)->info->tty->hw_stopped)
+#define uart_tx_stopped(portp)		\
+	((portp)->info->port.tty->stopped || (portp)->info->port.tty->hw_stopped)
 
 /*
  * The following are helper functions for the low level drivers.
@@ -449,7 +447,7 @@ uart_handle_sysrq_char(struct uart_port *port, unsigned int ch)
 #ifdef SUPPORT_SYSRQ
 	if (port->sysrq) {
 		if (ch && time_before(jiffies, port->sysrq)) {
-			handle_sysrq(ch, port->info ? port->info->tty : NULL);
+			handle_sysrq(ch, port->info ? port->info->port.tty : NULL);
 			port->sysrq = 0;
 			return 1;
 		}
@@ -478,7 +476,7 @@ static inline int uart_handle_break(struct uart_port *port)
 	}
 #endif
 	if (port->flags & UPF_SAK)
-		do_SAK(info->tty);
+		do_SAK(info->port.tty);
 	return 0;
 }
 
@@ -501,9 +499,9 @@ uart_handle_dcd_change(struct uart_port *port, unsigned int status)
 
 	if (info->flags & UIF_CHECK_CD) {
 		if (status)
-			wake_up_interruptible(&info->open_wait);
-		else if (info->tty)
-			tty_hangup(info->tty);
+			wake_up_interruptible(&info->port.open_wait);
+		else if (info->port.tty)
+			tty_hangup(info->port.tty);
 	}
 }
 
@@ -516,7 +514,7 @@ static inline void
 uart_handle_cts_change(struct uart_port *port, unsigned int status)
 {
 	struct uart_info *info = port->info;
-	struct tty_struct *tty = info->tty;
+	struct tty_struct *tty = info->port.tty;
 
 	port->icount.cts++;
 
@@ -542,7 +540,7 @@ static inline void
 uart_insert_char(struct uart_port *port, unsigned int status,
 		 unsigned int overrun, unsigned int ch, unsigned int flag)
 {
-	struct tty_struct *tty = port->info->tty;
+	struct tty_struct *tty = port->info->port.tty;
 
 	if ((status & port->ignore_status_mask & ~overrun) == 0)
 		tty_insert_flip_char(tty, ch, flag);

