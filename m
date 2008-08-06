Return-Path: <linux-kernel-owner+w=401wt.eu-S964846AbYHFVYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964846AbYHFVYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 17:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422941AbYHFVOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 17:14:52 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422834AbYHFVOt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 17:14:49 -0400
Date: Wed, 6 Aug 2008 17:14:38 -0400
From: Aristeu Rozanski <arozansk@redhat.com>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v1] 8250: add support for DTR/DSR hardware flow control
Message-ID: <20080806211438.GB20355@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for DTR/DSR hardware flow control on 8250 driver on x86
machines. It's done by adding a CDTRDSR flag to work just like CRTSCTS, which is
not done on other architectures on purpose (so each maintainer can allocate it).

This patch was tested with success with a serial printer configured with a small
buffer and DTR/DSR flow control.

This is based on the work of Michael Westermann (http://lkml.org/lkml/2007/8/31/133)

Comments more than welcome.

Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

---
 drivers/serial/8250.c        |   12 ++++++++--
 drivers/serial/serial_core.c |   42 ++++++++++++++++++++++++++++++++++-
 include/asm-x86/termbits.h   |    1 
 include/linux/serial_core.h  |   51 +++++++++++++++++++++++++++----------------
 include/linux/termios.h      |    5 ++++
 5 files changed, 90 insertions(+), 21 deletions(-)

--- linus-2.6.orig/drivers/serial/8250.c	2008-08-05 16:44:26.000000000 -0400
+++ linus-2.6/drivers/serial/8250.c	2008-08-05 18:45:01.000000000 -0400
@@ -1409,7 +1409,7 @@ static unsigned int check_modem_status(s
 		if (status & UART_MSR_TERI)
 			up->port.icount.rng++;
 		if (status & UART_MSR_DDSR)
-			up->port.icount.dsr++;
+			uart_handle_dsr_change(&up->port, status & UART_MSR_DSR);
 		if (status & UART_MSR_DDCD)
 			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
 		if (status & UART_MSR_DCTS)
@@ -1739,9 +1739,17 @@ static inline void wait_for_xmitr(struct
 		unsigned int tmout;
 		for (tmout = 1000000; tmout; tmout--) {
 			unsigned int msr = serial_in(up, UART_MSR);
+			struct uart_info *info = up->port.info;
+
 			up->msr_saved_flags |= msr & MSR_SAVE_FLAGS;
-			if (msr & UART_MSR_CTS)
+
+			if ((info->flags & UIF_CTS_FLOW) &&
+			    (msr & UART_MSR_CTS))
 				break;
+			else if ((info->flags & UIF_DSR_FLOW) &&
+				 (msr & UART_MSR_DSR))
+ 				break;
+
 			udelay(1);
 			touch_nmi_watchdog();
 		}
--- linus-2.6.orig/drivers/serial/serial_core.c	2008-08-05 16:44:26.000000000 -0400
+++ linus-2.6/drivers/serial/serial_core.c	2008-08-05 18:45:01.000000000 -0400
@@ -194,6 +194,13 @@ static int uart_startup(struct uart_stat
 			spin_unlock_irq(&port->lock);
 		}
 
+		if (info->flags & UIF_DSR_FLOW) {
+			spin_lock_irq(&port->lock);
+			if (!(port->ops->get_mctrl(port) & TIOCM_DSR))
+				info->port.tty->hw_stopped = 1;
+			spin_unlock_irq(&port->lock);
+		}
+
 		info->flags |= UIF_INITIALIZED;
 
 		clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
@@ -448,6 +455,11 @@ uart_change_speed(struct uart_state *sta
 	else
 		state->info->flags &= ~UIF_CTS_FLOW;
 
+	if (termios->c_cflag & CDTRDSR)
+		state->info->flags |= UIF_DSR_FLOW;
+	else
+		state->info->flags &= ~UIF_DSR_FLOW;
+
 	if (termios->c_cflag & CLOCAL)
 		state->info->flags &= ~UIF_CHECK_CD;
 	else
@@ -611,6 +623,8 @@ static void uart_throttle(struct tty_str
 
 	if (tty->termios->c_cflag & CRTSCTS)
 		uart_clear_mctrl(state->port, TIOCM_RTS);
+	if (tty->termios->c_cflag & CDTRDSR)
+		uart_clear_mctrl(state->port, TIOCM_DTR);
 }
 
 static void uart_unthrottle(struct tty_struct *tty)
@@ -627,6 +641,8 @@ static void uart_unthrottle(struct tty_s
 
 	if (tty->termios->c_cflag & CRTSCTS)
 		uart_set_mctrl(port, TIOCM_RTS);
+	if (tty->termios->c_cflag & CDTRDSR)
+		uart_set_mctrl(port, TIOCM_DTR);
 }
 
 static int uart_get_info(struct uart_state *state,
@@ -1212,6 +1228,9 @@ static void uart_set_termios(struct tty_
 		if (!(cflag & CRTSCTS) ||
 		    !test_bit(TTY_THROTTLED, &tty->flags))
 			mask |= TIOCM_RTS;
+		if (!(cflag & CDTRDSR) ||
+		    !test_bit(TTY_THROTTLED, &tty->flags))
+			mask &= ~TIOCM_DTR;
 		uart_set_mctrl(state->port, mask);
 	}
 
@@ -1232,6 +1251,24 @@ static void uart_set_termios(struct tty_
 		}
 		spin_unlock_irqrestore(&state->port->lock, flags);
 	}
+
+	/* Handle turning off CDTRDSR */
+	if ((old_termios->c_cflag & CDTRDSR) && !(cflag & CDTRDSR)) {
+		spin_lock_irqsave(&state->port->lock, flags);
+		tty->hw_stopped = 0;
+		__uart_start(tty);
+		spin_unlock_irqrestore(&state->port->lock, flags);
+	}
+
+	if (!(old_termios->c_cflag & CDTRDSR) && (cflag & CDTRDSR)) {
+		spin_lock_irqsave(&state->port->lock, flags);
+		if (!(state->port->ops->get_mctrl(state->port) & TIOCM_DSR)) {
+			tty->hw_stopped = 1;
+			state->port->ops->stop_tx(state->port);
+		}
+		spin_unlock_irqrestore(&state->port->lock, flags);
+	}
+
 #if 0
 	/*
 	 * No need to wake up processes in open wait, since they
@@ -1511,7 +1548,8 @@ uart_block_til_ready(struct file *filp, 
 		 * not set RTS here - we want to make sure we catch
 		 * the data from the modem.
 		 */
-		if (info->port.tty->termios->c_cflag & CBAUD)
+		if (info->port.tty->termios->c_cflag & CBAUD &&
+		    !(info->port.tty->termios->c_cflag & CDTRDSR))
 			uart_set_mctrl(port, TIOCM_DTR);
 
 		/*
@@ -1959,6 +1997,8 @@ uart_set_options(struct uart_port *port,
 
 	if (flow == 'r')
 		termios.c_cflag |= CRTSCTS;
+	if (flow == 'd')
+		termios.c_cflag |= CDTRDSR;
 
 	/*
 	 * some uarts on other side don't support no flow control.
--- linus-2.6.orig/include/asm-x86/termbits.h	2008-08-05 16:44:26.000000000 -0400
+++ linus-2.6/include/asm-x86/termbits.h	2008-08-06 13:33:57.000000000 -0400
@@ -157,6 +157,7 @@ struct ktermios {
 #define  B3500000 0010016
 #define  B4000000 0010017
 #define CIBAUD	  002003600000	/* input baud rate */
+#define CDTRDSR	  004000000000	/* DTR/DSR flow control */
 #define CMSPAR	  010000000000	/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000	/* flow control */
 
--- linus-2.6.orig/include/linux/serial_core.h	2008-08-05 16:44:26.000000000 -0400
+++ linus-2.6/include/linux/serial_core.h	2008-08-05 18:45:01.000000000 -0400
@@ -351,6 +351,7 @@ struct uart_info {
  *
  * FIXME: use the ASY_ definitions
  */
+#define UIF_DSR_FLOW		((__force uif_t) (1 << 24))
 #define UIF_CHECK_CD		((__force uif_t) (1 << 25))
 #define UIF_CTS_FLOW		((__force uif_t) (1 << 26))
 #define UIF_NORMAL_ACTIVE	((__force uif_t) (1 << 29))
@@ -505,34 +506,48 @@ uart_handle_dcd_change(struct uart_port 
 }
 
 /**
- *	uart_handle_cts_change - handle a change of clear-to-send state
+ *	uart_handle_flow_control_change - handle a change of CTS or DSR
  *	@port: uart_port structure for the open port
- *	@status: new clear to send status, nonzero if active
+ *	@status: new CTS/DTR status, nonzero if active
  */
 static inline void
-uart_handle_cts_change(struct uart_port *port, unsigned int status)
+uart_handle_flow_control_change(struct uart_port *port, unsigned int status)
 {
 	struct uart_info *info = port->info;
 	struct tty_struct *tty = info->port.tty;
 
-	port->icount.cts++;
-
-	if (info->flags & UIF_CTS_FLOW) {
-		if (tty->hw_stopped) {
-			if (status) {
-				tty->hw_stopped = 0;
-				port->ops->start_tx(port);
-				uart_write_wakeup(port);
-			}
-		} else {
-			if (!status) {
-				tty->hw_stopped = 1;
-				port->ops->stop_tx(port);
-			}
+	if (tty->hw_stopped) {
+		if (status) {
+			tty->hw_stopped = 0;
+			port->ops->start_tx(port);
+			uart_write_wakeup(port);
+		}
+	} else {
+		if (!status) {
+			tty->hw_stopped = 1;
+			port->ops->stop_tx(port);
 		}
 	}
 }
 
+static inline void
+uart_handle_cts_change(struct uart_port *port, unsigned int status)
+{
+	struct uart_info *info = port->info;
+	port->icount.cts++;
+	if (info->flags & UIF_CTS_FLOW)
+		uart_handle_flow_control_change(port, status);
+}
+
+static inline void
+uart_handle_dsr_change(struct uart_port *port, unsigned int status)
+{
+	struct uart_info *info = port->info;
+	port->icount.dsr++;
+	if (info->flags & UIF_DSR_FLOW)
+		uart_handle_flow_control_change(port, status);
+}
+
 #include <linux/tty_flip.h>
 
 static inline void
@@ -556,7 +571,7 @@ uart_insert_char(struct uart_port *port,
  *	UART_ENABLE_MS - determine if port should enable modem status irqs
  */
 #define UART_ENABLE_MS(port,cflag)	((port)->flags & UPF_HARDPPS_CD || \
-					 (cflag) & CRTSCTS || \
+					 (cflag) & (CRTSCTS | CDTRDSR) || \
 					 !((cflag) & CLOCAL))
 
 #endif
--- linus-2.6.orig/include/linux/termios.h	2008-08-05 16:44:26.000000000 -0400
+++ linus-2.6/include/linux/termios.h	2008-08-05 18:45:01.000000000 -0400
@@ -4,4 +4,9 @@
 #include <linux/types.h>
 #include <asm/termios.h>
 
+#ifndef CDTRDSR
+#warning This architecture should implement CDTRDSR
+#define CDTRDSR 0 /* remove this when all architectures have a definition */
+#endif
+
 #endif
