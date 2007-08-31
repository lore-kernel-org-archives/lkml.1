Return-Path: <linux-kernel-owner+w=401wt.eu-S965457AbXHaNmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965457AbXHaNmW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 09:42:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964971AbXHaNmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 09:42:14 -0400
Received: from lug-owl.de ([195.71.106.12]:56899 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964939AbXHaNmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 09:42:13 -0400
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Aug 2007 09:42:13 EDT
Date: Fri, 31 Aug 2007 15:17:41 +0200
From: Michael Westermann <michael@dvmwest.de>
To: linux-kernel@vger.kernel.org
Subject: DTR/DSR Patch
Message-ID: <20070831131741.GA14569@dvmwest.dvmwest.de>
Mail-Followup-To: Michael Westermann <michael@dvmwest.de>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I make driver for Point of Sale Printer, a wide range of Printer use
only a DTR/DSR hardware-handshaking. When I use a handshaking in the
userspace, the Printr has a overrun problem and our customer has a
problem with the tax office.

my Patch relaize a simple DTR/DSR handhake with a small change of the
code. The change auf the userspace is very simple. e.g.


cflags |= CDTRDSR;

The change of the stty tool at 2 lines.

Michael


diff -Nur linux-2.6/drivers/serial/8250.c linux-2.6.dsr_test/drivers/serial/8250.c
--- linux-2.6/drivers/serial/8250.c	2007-08-28 11:31:48.000000000 +0200
+++ linux-2.6.dsr_test/drivers/serial/8250.c	2007-08-31 13:20:57.000000000 +0200
@@ -1400,12 +1400,15 @@
 	    up->port.info != NULL) {
 		if (status & UART_MSR_TERI)
 			up->port.icount.rng++;
-		if (status & UART_MSR_DDSR)
-			up->port.icount.dsr++;
 		if (status & UART_MSR_DDCD)
 			uart_handle_dcd_change(&up->port, status & UART_MSR_DCD);
-		if (status & UART_MSR_DCTS)
-			uart_handle_cts_change(&up->port, status & UART_MSR_CTS);
+		if (status & (UART_MSR_DCTS|UART_MSR_DDSR)) {
+			if (status & UART_MSR_DDSR) 	
+				up->port.icount.dsr++;
+			else
+				up->port.icount.cts++;
+			uart_handle_dsr_cts_change(&up->port, status & UART_MSR_CTS, status & UART_MSR_DSR);
+		}
 
 		wake_up_interruptible(&up->port.info->delta_msr_wait);
 	}
diff -Nur linux-2.6/drivers/serial/serial_core.c linux-2.6.dsr_test/drivers/serial/serial_core.c
--- linux-2.6/drivers/serial/serial_core.c	2007-08-28 11:31:48.000000000 +0200
+++ linux-2.6.dsr_test/drivers/serial/serial_core.c	2007-08-31 13:29:22.000000000 +0200
@@ -191,6 +191,13 @@
 				info->tty->hw_stopped = 1;
 			spin_unlock_irq(&port->lock);
 		}
+		
+		if (info->flags & UIF_DSR_FLOW) {
+			spin_lock_irq(&port->lock);
+			if (!(port->ops->get_mctrl(port) & TIOCM_DSR))
+				info->tty->hw_stopped = 1;
+			spin_unlock_irq(&port->lock);
+		}
 
 		info->flags |= UIF_INITIALIZED;
 
@@ -437,6 +444,11 @@
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
--- linux-2.6/include/asm-i386/termbits.h	2007-05-21 10:37:10.000000000 +0200
+++ linux-2.6.dsr_test/include/asm-i386/termbits.h	2007-08-28 11:58:43.000000000 +0200
@@ -157,6 +157,7 @@
 #define  B3500000 0010016
 #define  B4000000 0010017
 #define CIBAUD	  002003600000
+#define CDTRDSR	  004000000000		/* dtrdsr flow control */
 #define CMSPAR	  010000000000		/* mark or space (stick) parity */
 #define CRTSCTS	  020000000000		/* flow control */
 
diff -Nur linux-2.6/include/linux/serial_core.h linux-2.6.dsr_test/include/linux/serial_core.h
--- linux-2.6/include/linux/serial_core.h	2007-08-16 10:30:59.000000000 +0200
+++ linux-2.6.dsr_test/include/linux/serial_core.h	2007-08-30 16:09:55.000000000 +0200
@@ -334,6 +334,7 @@
  * Definitions for info->flags.  These are _private_ to serial_core, and
  * are specific to this structure.  They may be queried by low level drivers.
  */
+#define UIF_DSR_FLOW		((__force uif_t) (1 << 22))
 #define UIF_CHECK_CD		((__force uif_t) (1 << 25))
 #define UIF_CTS_FLOW		((__force uif_t) (1 << 26))
 #define UIF_NORMAL_ACTIVE	((__force uif_t) (1 << 29))
@@ -493,26 +494,27 @@
 
 /**
  *	uart_handle_cts_change - handle a change of clear-to-send state
+ *	when set DTR/DSR and RTS/CTS send only when both lines ok
  *	@port: uart_port structure for the open port
  *	@status: new clear to send status, nonzero if active
  */
 static inline void
-uart_handle_cts_change(struct uart_port *port, unsigned int status)
+uart_handle_dsr_cts_change(struct uart_port *port, unsigned int status_cts, unsigned int status_dsr)
 {
 	struct uart_info *info = port->info;
 	struct tty_struct *tty = info->tty;
+	int 	cts_stop = (info->flags & UIF_CTS_FLOW) && !status_cts;
+	int	dsr_stop = (info->flags & UIF_DSR_FLOW) && !status_dsr; 
 
-	port->icount.cts++;
-
-	if (info->flags & UIF_CTS_FLOW) {
+	if ((info->flags & UIF_CTS_FLOW) || (info->flags & UIF_DSR_FLOW)) {
 		if (tty->hw_stopped) {
-			if (status) {
+			if (!(cts_stop||dsr_stop)) {
 				tty->hw_stopped = 0;
 				port->ops->start_tx(port);
 				uart_write_wakeup(port);
 			}
 		} else {
-			if (!status) {
+			if (cts_stop||dsr_stop) {
 				tty->hw_stopped = 1;
 				port->ops->stop_tx(port);
 			}
@@ -543,7 +545,7 @@
  *	UART_ENABLE_MS - determine if port should enable modem status irqs
  */
 #define UART_ENABLE_MS(port,cflag)	((port)->flags & UPF_HARDPPS_CD || \
-					 (cflag) & CRTSCTS || \
+					 (cflag) & (CRTSCTS|CDTRDSR) || \
 					 !((cflag) & CLOCAL))
 
 #endif

