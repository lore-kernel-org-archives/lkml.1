Return-Path: <linux-kernel-owner+w=401wt.eu-S1753726AbXDRE73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbXDRE73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXDRE73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:59:29 -0400
Received: from mta18.mail.adelphia.net ([68.168.78.54]:33096 "EHLO
	mta18.adelphia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726AbXDRE71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:59:27 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 00:59:27 EDT
Date: Tue, 17 Apr 2007 23:54:23 -0500
From: Corey Minyard <minyard@acm.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] Provide better abstraction for the serial drivers to xmit buf and tty
Message-ID: <20070418045423.GA12136@localdomain>
Reply-To: minyard@acm.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm back working on the serial driver to try to get the necessary
changes so the IPMI driver can use it.  This patch is sort of asking
if this is the right direction to go for now.  I have all the drivers
that use serial_core.h converted over, and if this is accepted I can
send the whole set.

Subject: Provide better abstraction for the serial drivers

This patch is first in a set of patches that do some cleanup on the
various serial driver interfaces.  They do the following:

  * Remove UART_XMIT_SIZE from all the serial drivers and creates
    functions serial_core.h to do the equivalent.
  * Remove all references to the uart_port info member from the
    various serial drivers and creates functions in serial_core.h
    to do the equivalent.
  * Remove references to the tty from the serial drivers and
    creates functions in serial_core.h to do the equivalent.
  * Add a "port" field to several of the uart_circ_xxx macros to
    allow for different sized buffers in the future.
  * Convert all the macros into functions in serial_core.h.

These patch are in preparation for changes to allow things to do
direct access to the serial drivers, especially when system is not
operational or is only semi-operational.  These changes seem like a
good idea in general, though.  It seems unreasonable to me to have the
drivers directly reference the tty layer or have direct access to the
transmit buffer size.

The basic reason for all this is to eventually allow the low-level
serial drivers to function without a uart_info structure being
allocated.  This will allow the serial console, debuggers like kgdb,
and the IPMI serial driver to use one interface to the uart code and
not duplicate their own interfaces.  In particular, the console code
will be able to use the standard uart interfaces for writing with the
addition of a poll call in the uart.

This is the first patch with the base changes and changes to the 8250
driver.  It includes some changes to serial_core.h that are required
by other drivers later.

Signed-off-by: Corey Minyard <minyard@acm.org>
Cc: linux-serial@vger.kernel.org
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>

---
 drivers/serial/8250.c        |   21 +++----
 drivers/serial/serial_core.c |   20 +++----
 include/linux/serial_core.h  |  118 ++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 131 insertions(+), 28 deletions(-)

Index: linux-2.6.21-rc7/include/linux/serial_core.h
===================================================================
--- linux-2.6.21-rc7.orig/include/linux/serial_core.h	2007-04-17 20:44:48.000000000 -0500
+++ linux-2.6.21-rc7/include/linux/serial_core.h	2007-04-17 21:04:05.000000000 -0500
@@ -143,6 +143,7 @@
 #include <linux/spinlock.h>
 #include <linux/sched.h>
 #include <linux/tty.h>
+#include <linux/tty_flip.h>
 #include <linux/mutex.h>
 
 struct uart_port;
@@ -395,17 +396,98 @@
 int uart_suspend_port(struct uart_driver *reg, struct uart_port *port);
 int uart_resume_port(struct uart_driver *reg, struct uart_port *port);
 
+/*
+ * Old stuff, use the new inline functions for handling the circular
+ * buffer (uart_xmit_xxx).
+ */
 #define uart_circ_empty(circ)		((circ)->head == (circ)->tail)
 #define uart_circ_clear(circ)		((circ)->head = (circ)->tail = 0)
-
 #define uart_circ_chars_pending(circ)	\
 	(CIRC_CNT((circ)->head, (circ)->tail, UART_XMIT_SIZE))
-
 #define uart_circ_chars_free(circ)	\
 	(CIRC_SPACE((circ)->head, (circ)->tail, UART_XMIT_SIZE))
 
-#define uart_tx_stopped(port)		\
-	((port)->info->tty->stopped || (port)->info->tty->hw_stopped)
+/*
+ * Handling for the UART port's circular buffer.
+ */
+static inline int uart_xmit_empty(struct circ_buf *circ)
+{
+	return circ->head == circ->tail;
+}
+
+static inline void uart_xmit_clear(struct circ_buf *circ)
+{
+	circ->head = circ->tail = 0;
+}
+
+static inline struct circ_buf *uart_get_xmit_buf(struct uart_port *port)
+{
+	return &port->info->xmit;
+}
+
+static inline int uart_wrap_xmit_buf(int val, struct uart_port *port)
+{
+	return val & (UART_XMIT_SIZE - 1);
+}
+
+static inline int _uart_xmit_chars_pending(int head, int tail,
+					   struct uart_port *port)
+{
+	return CIRC_CNT(head, tail, UART_XMIT_SIZE);
+}
+
+static inline int uart_xmit_chars_pending(struct circ_buf *circ,
+					  struct uart_port *port)
+{
+	return CIRC_CNT(circ->head, circ->tail, UART_XMIT_SIZE);
+}
+
+static inline int uart_xmit_chars_pending_to_end(struct circ_buf *circ,
+						 struct uart_port *port)
+{
+	return CIRC_CNT_TO_END(circ->head, circ->tail, UART_XMIT_SIZE);
+}
+
+static inline int _uart_xmit_chars_free(int head, int tail,
+					struct uart_port *port)
+{
+	return CIRC_SPACE(head, tail, UART_XMIT_SIZE);
+}
+
+static inline int uart_xmit_chars_free(struct circ_buf *circ,
+				       struct uart_port *port)
+{
+	return CIRC_SPACE(circ->head, circ->tail, UART_XMIT_SIZE);
+}
+
+static inline int uart_xmit_chars_free_to_end(struct circ_buf *circ,
+					      struct uart_port *port)
+{
+	return CIRC_SPACE_TO_END(circ->head, circ->tail, UART_XMIT_SIZE);
+}
+
+/*
+ * Various settings for the port.
+ */
+static inline int uart_tx_stopped(struct uart_port *port)
+{
+	return port->info->tty->stopped || port->info->tty->hw_stopped;
+}
+
+static inline int uart_ready(struct uart_port *port)
+{
+	return (port->info) != NULL;
+}
+
+static inline void uart_set_low_latency(struct uart_port *port, int val)
+{
+	port->info->tty->low_latency = val;
+}
+
+static inline int uart_rx_buffer_room(struct uart_port *port, int req_room)
+{
+	return tty_buffer_request_room(port->info->tty, req_room);
+}
 
 /*
  * The following are helper functions for the low level drivers.
@@ -415,7 +497,7 @@
 {
 #ifdef SUPPORT_SYSRQ
 	if (port->sysrq) {
-		if (ch && time_before(jiffies, port->sysrq)) {
+		if (ch && time_before(jiffies, port->sysrq) && port->info) {
 			handle_sysrq(ch, port->info->tty);
 			port->sysrq = 0;
 			return 1;
@@ -509,7 +591,14 @@
 uart_insert_char(struct uart_port *port, unsigned int status,
 		 unsigned int overrun, unsigned int ch, unsigned int flag)
 {
-	struct tty_struct *tty = port->info->tty;
+	struct tty_struct *tty;
+
+	if (!port->info)
+		return;
+
+	tty = port->info->tty;
+	if (!tty)
+		return;
 
 	if ((status & port->ignore_status_mask & ~overrun) == 0)
 		tty_insert_flip_char(tty, ch, flag);
@@ -522,6 +611,23 @@
 		tty_insert_flip_char(tty, 0, TTY_OVERRUN);
 }
 
+static inline void
+uart_push(struct uart_port *port)
+{
+	if (!port->info)
+		return;
+	if (!port->info->tty)
+		return;
+
+	tty_flip_buffer_push(port->info->tty);
+}
+
+static inline void
+uart_msr_change(struct uart_port *port)
+{
+	wake_up_interruptible(&port->info->delta_msr_wait);
+}
+
 /*
  *	UART_ENABLE_MS - determine if port should enable modem status irqs
  */
Index: linux-2.6.21-rc7/drivers/serial/serial_core.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/serial/serial_core.c	2007-04-17 20:44:48.000000000 -0500
+++ linux-2.6.21-rc7/drivers/serial/serial_core.c	2007-04-17 21:03:41.000000000 -0500
@@ -100,7 +100,7 @@
 	struct uart_state *state = tty->driver_data;
 	struct uart_port *port = state->port;
 
-	if (!uart_circ_empty(&state->info->xmit) && state->info->xmit.buf &&
+	if (!uart_xmit_empty(&state->info->xmit) && state->info->xmit.buf &&
 	    !tty->stopped && !tty->hw_stopped)
 		port->ops->start_tx(port);
 }
@@ -173,7 +173,7 @@
 			return -ENOMEM;
 
 		info->xmit.buf = (unsigned char *) page;
-		uart_circ_clear(&info->xmit);
+		uart_xmit_clear(&info->xmit);
 	}
 
 	retval = port->ops->startup(port);
@@ -461,9 +461,9 @@
 		return;
 
 	spin_lock_irqsave(&port->lock, flags);
-	if (uart_circ_chars_free(circ) != 0) {
+	if (uart_xmit_chars_free(circ, port) != 0) {
 		circ->buf[circ->head] = c;
-		circ->head = (circ->head + 1) & (UART_XMIT_SIZE - 1);
+		circ->head = uart_wrap_xmit_buf(circ->head + 1, port);
 	}
 	spin_unlock_irqrestore(&port->lock, flags);
 }
@@ -506,13 +506,13 @@
 
 	spin_lock_irqsave(&port->lock, flags);
 	while (1) {
-		c = CIRC_SPACE_TO_END(circ->head, circ->tail, UART_XMIT_SIZE);
+		c = uart_xmit_chars_free_to_end(circ, port);
 		if (count < c)
 			c = count;
 		if (c <= 0)
 			break;
 		memcpy(circ->buf + circ->head, buf, c);
-		circ->head = (circ->head + c) & (UART_XMIT_SIZE - 1);
+		circ->head = uart_wrap_xmit_buf(circ->head + c, port);
 		buf += c;
 		count -= c;
 		ret += c;
@@ -527,14 +527,14 @@
 {
 	struct uart_state *state = tty->driver_data;
 
-	return uart_circ_chars_free(&state->info->xmit);
+	return uart_xmit_chars_free(&state->info->xmit, state->port);
 }
 
 static int uart_chars_in_buffer(struct tty_struct *tty)
 {
 	struct uart_state *state = tty->driver_data;
 
-	return uart_circ_chars_pending(&state->info->xmit);
+	return uart_xmit_chars_pending(&state->info->xmit, state->port);
 }
 
 static void uart_flush_buffer(struct tty_struct *tty)
@@ -555,7 +555,7 @@
 	DPRINTK("uart_flush_buffer(%d) called\n", tty->index);
 
 	spin_lock_irqsave(&port->lock, flags);
-	uart_circ_clear(&state->info->xmit);
+	uart_xmit_clear(&state->info->xmit);
 	spin_unlock_irqrestore(&port->lock, flags);
 	tty_wakeup(tty);
 }
@@ -857,7 +857,7 @@
 	 * interrupt happens).
 	 */
 	if (port->x_char ||
-	    ((uart_circ_chars_pending(&state->info->xmit) > 0) &&
+	    ((uart_xmit_chars_pending(&state->info->xmit, port) > 0) &&
 	     !state->info->tty->stopped && !state->info->tty->hw_stopped))
 		result &= ~TIOCSER_TEMT;
 	
Index: linux-2.6.21-rc7/drivers/serial/8250.c
===================================================================
--- linux-2.6.21-rc7.orig/drivers/serial/8250.c	2007-04-17 20:44:48.000000000 -0500
+++ linux-2.6.21-rc7/drivers/serial/8250.c	2007-04-17 21:03:40.000000000 -0500
@@ -32,8 +32,6 @@
 #include <linux/sysrq.h>
 #include <linux/delay.h>
 #include <linux/platform_device.h>
-#include <linux/tty.h>
-#include <linux/tty_flip.h>
 #include <linux/serial_reg.h>
 #include <linux/serial_core.h>
 #include <linux/serial.h>
@@ -1198,7 +1196,6 @@
 static void
 receive_chars(struct uart_8250_port *up, unsigned int *status)
 {
-	struct tty_struct *tty = up->port.info->tty;
 	unsigned char ch, lsr = *status;
 	int max_count = 256;
 	char flag;
@@ -1263,14 +1260,14 @@
 		lsr = serial_inp(up, UART_LSR);
 	} while ((lsr & UART_LSR_DR) && (max_count-- > 0));
 	spin_unlock(&up->port.lock);
-	tty_flip_buffer_push(tty);
+	uart_push(&up->port);
 	spin_lock(&up->port.lock);
 	*status = lsr;
 }
 
 static void transmit_chars(struct uart_8250_port *up)
 {
-	struct circ_buf *xmit = &up->port.info->xmit;
+	struct circ_buf *xmit = uart_get_xmit_buf(&up->port);
 	int count;
 
 	if (up->port.x_char) {
@@ -1283,7 +1280,7 @@
 		serial8250_stop_tx(&up->port);
 		return;
 	}
-	if (uart_circ_empty(xmit)) {
+	if (uart_xmit_empty(xmit)) {
 		__stop_tx(up);
 		return;
 	}
@@ -1291,18 +1288,18 @@
 	count = up->tx_loadsz;
 	do {
 		serial_out(up, UART_TX, xmit->buf[xmit->tail]);
-		xmit->tail = (xmit->tail + 1) & (UART_XMIT_SIZE - 1);
+		xmit->tail = uart_wrap_xmit_buf(xmit->tail + 1, &up->port);
 		up->port.icount.tx++;
-		if (uart_circ_empty(xmit))
+		if (uart_xmit_empty(xmit))
 			break;
 	} while (--count > 0);
 
-	if (uart_circ_chars_pending(xmit) < WAKEUP_CHARS)
+	if (uart_xmit_chars_pending(xmit, &up->port) < WAKEUP_CHARS)
 		uart_write_wakeup(&up->port);
 
 	DEBUG_INTR("THRE...");
 
-	if (uart_circ_empty(xmit))
+	if (uart_xmit_empty(xmit))
 		__stop_tx(up);
 }
 
@@ -1320,7 +1317,7 @@
 		if (status & UART_MSR_DCTS)
 			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
 
-		wake_up_interruptible(&up->port.info->delta_msr_wait);
+		uart_msr_change(&up->port);
 	}
 
 	return status;
@@ -1494,6 +1491,7 @@
 static void serial8250_backup_timeout(unsigned long data)
 {
 	struct uart_8250_port *up = (struct uart_8250_port *)data;
+	struct circ_buf *xmit = uart_get_xmit_buf(&up->port);
 	unsigned int iir, ier = 0;
 
 	/*
@@ -1514,7 +1512,7 @@
 	 * ia64 and parisc boxes.
 	 */
 	if ((iir & UART_IIR_NO_INT) && (up->ier & UART_IER_THRI) &&
-	    (!uart_circ_empty(&up->port.info->xmit) || up->port.x_char) &&
+	    (!uart_xmit_empty(xmit) || up->port.x_char) &&
 	    (serial_in(up, UART_LSR) & UART_LSR_THRE)) {
 		iir &= ~(UART_IIR_ID | UART_IIR_NO_INT);
 		iir |= UART_IIR_THRI;
