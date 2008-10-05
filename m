Return-Path: <linux-kernel-owner+w=401wt.eu-S1758552AbYJEQTg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758552AbYJEQTg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:19:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757841AbYJEQO6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:14:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49612 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756903AbYJEQO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:14:56 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 41/76] mxser: Switch to kref tty
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:14:55 +0100
Message-ID: <20081005161336.1997.91961.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/mxser.c |  192 +++++++++++++++++++++++++++-----------------------
 1 files changed, 103 insertions(+), 89 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index b638403..308cb60 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -610,15 +610,16 @@ static int mxser_block_til_ready(struct tty_struct *tty, struct file *filp,
 	return 0;
 }
 
-static int mxser_set_baud(struct mxser_port *info, long newspd)
+static int mxser_set_baud(struct tty_struct *tty, long newspd)
 {
+	struct mxser_port *info = tty->driver_data;
 	int quot = 0, baud;
 	unsigned char cval;
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!tty->termios)
 		return -1;
 
-	if (!(info->ioaddr))
+	if (!info->ioaddr)
 		return -1;
 
 	if (newspd > info->max_baud)
@@ -626,13 +627,13 @@ static int mxser_set_baud(struct mxser_port *info, long newspd)
 
 	if (newspd == 134) {
 		quot = 2 * info->baud_base / 269;
-		tty_encode_baud_rate(info->port.tty, 134, 134);
+		tty_encode_baud_rate(tty, 134, 134);
 	} else if (newspd) {
 		quot = info->baud_base / newspd;
 		if (quot == 0)
 			quot = 1;
 		baud = info->baud_base/quot;
-		tty_encode_baud_rate(info->port.tty, baud, baud);
+		tty_encode_baud_rate(tty, baud, baud);
 	} else {
 		quot = 0;
 	}
@@ -658,7 +659,7 @@ static int mxser_set_baud(struct mxser_port *info, long newspd)
 	outb(cval, info->ioaddr + UART_LCR);	/* reset DLAB */
 
 #ifdef BOTHER
-	if (C_BAUD(info->port.tty) == BOTHER) {
+	if (C_BAUD(tty) == BOTHER) {
 		quot = info->baud_base % newspd;
 		quot *= 8;
 		if (quot % newspd > newspd / 2) {
@@ -679,21 +680,22 @@ static int mxser_set_baud(struct mxser_port *info, long newspd)
  * This routine is called to set the UART divisor registers to match
  * the specified baud rate for a serial port.
  */
-static int mxser_change_speed(struct mxser_port *info,
-		struct ktermios *old_termios)
+static int mxser_change_speed(struct tty_struct *tty,
+					struct ktermios *old_termios)
 {
+	struct mxser_port *info = tty->driver_data;
 	unsigned cflag, cval, fcr;
 	int ret = 0;
 	unsigned char status;
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!tty->termios)
 		return ret;
-	cflag = info->port.tty->termios->c_cflag;
-	if (!(info->ioaddr))
+	cflag = tty->termios->c_cflag;
+	if (!info->ioaddr)
 		return ret;
 
-	if (mxser_set_baud_method[info->port.tty->index] == 0)
-		mxser_set_baud(info, tty_get_baud_rate(info->port.tty));
+	if (mxser_set_baud_method[tty->index] == 0)
+		mxser_set_baud(tty, tty_get_baud_rate(tty));
 
 	/* byte size and parity */
 	switch (cflag & CSIZE) {
@@ -762,9 +764,9 @@ static int mxser_change_speed(struct mxser_port *info,
 			info->MCR |= UART_MCR_AFE;
 		} else {
 			status = inb(info->ioaddr + UART_MSR);
-			if (info->port.tty->hw_stopped) {
+			if (tty->hw_stopped) {
 				if (status & UART_MSR_CTS) {
-					info->port.tty->hw_stopped = 0;
+					tty->hw_stopped = 0;
 					if (info->type != PORT_16550A &&
 							!info->board->chip_flag) {
 						outb(info->IER & ~UART_IER_THRI,
@@ -774,11 +776,11 @@ static int mxser_change_speed(struct mxser_port *info,
 						outb(info->IER, info->ioaddr +
 								UART_IER);
 					}
-					tty_wakeup(info->port.tty);
+					tty_wakeup(tty);
 				}
 			} else {
 				if (!(status & UART_MSR_CTS)) {
-					info->port.tty->hw_stopped = 1;
+					tty->hw_stopped = 1;
 					if ((info->type != PORT_16550A) &&
 							(!info->board->chip_flag)) {
 						info->IER &= ~UART_IER_THRI;
@@ -804,21 +806,21 @@ static int mxser_change_speed(struct mxser_port *info,
 	 * Set up parity check flag
 	 */
 	info->read_status_mask = UART_LSR_OE | UART_LSR_THRE | UART_LSR_DR;
-	if (I_INPCK(info->port.tty))
+	if (I_INPCK(tty))
 		info->read_status_mask |= UART_LSR_FE | UART_LSR_PE;
-	if (I_BRKINT(info->port.tty) || I_PARMRK(info->port.tty))
+	if (I_BRKINT(tty) || I_PARMRK(tty))
 		info->read_status_mask |= UART_LSR_BI;
 
 	info->ignore_status_mask = 0;
 
-	if (I_IGNBRK(info->port.tty)) {
+	if (I_IGNBRK(tty)) {
 		info->ignore_status_mask |= UART_LSR_BI;
 		info->read_status_mask |= UART_LSR_BI;
 		/*
 		 * If we're ignore parity and break indicators, ignore
 		 * overruns too.  (For real raw support).
 		 */
-		if (I_IGNPAR(info->port.tty)) {
+		if (I_IGNPAR(tty)) {
 			info->ignore_status_mask |=
 						UART_LSR_OE |
 						UART_LSR_PE |
@@ -830,16 +832,16 @@ static int mxser_change_speed(struct mxser_port *info,
 		}
 	}
 	if (info->board->chip_flag) {
-		mxser_set_must_xon1_value(info->ioaddr, START_CHAR(info->port.tty));
-		mxser_set_must_xoff1_value(info->ioaddr, STOP_CHAR(info->port.tty));
-		if (I_IXON(info->port.tty)) {
+		mxser_set_must_xon1_value(info->ioaddr, START_CHAR(tty));
+		mxser_set_must_xoff1_value(info->ioaddr, STOP_CHAR(tty));
+		if (I_IXON(tty)) {
 			mxser_enable_must_rx_software_flow_control(
 					info->ioaddr);
 		} else {
 			mxser_disable_must_rx_software_flow_control(
 					info->ioaddr);
 		}
-		if (I_IXOFF(info->port.tty)) {
+		if (I_IXOFF(tty)) {
 			mxser_enable_must_tx_software_flow_control(
 					info->ioaddr);
 		} else {
@@ -855,7 +857,8 @@ static int mxser_change_speed(struct mxser_port *info,
 	return ret;
 }
 
-static void mxser_check_modem_status(struct mxser_port *port, int status)
+static void mxser_check_modem_status(struct tty_struct *tty,
+				struct mxser_port *port, int status)
 {
 	/* update input line counters */
 	if (status & UART_MSR_TERI)
@@ -874,10 +877,11 @@ static void mxser_check_modem_status(struct mxser_port *port, int status)
 			wake_up_interruptible(&port->port.open_wait);
 	}
 
+	tty = tty_port_tty_get(&port->port);
 	if (port->port.flags & ASYNC_CTS_FLOW) {
-		if (port->port.tty->hw_stopped) {
+		if (tty->hw_stopped) {
 			if (status & UART_MSR_CTS) {
-				port->port.tty->hw_stopped = 0;
+				tty->hw_stopped = 0;
 
 				if ((port->type != PORT_16550A) &&
 						(!port->board->chip_flag)) {
@@ -887,11 +891,11 @@ static void mxser_check_modem_status(struct mxser_port *port, int status)
 					outb(port->IER, port->ioaddr +
 							UART_IER);
 				}
-				tty_wakeup(port->port.tty);
+				tty_wakeup(tty);
 			}
 		} else {
 			if (!(status & UART_MSR_CTS)) {
-				port->port.tty->hw_stopped = 1;
+				tty->hw_stopped = 1;
 				if (port->type != PORT_16550A &&
 						!port->board->chip_flag) {
 					port->IER &= ~UART_IER_THRI;
@@ -903,8 +907,9 @@ static void mxser_check_modem_status(struct mxser_port *port, int status)
 	}
 }
 
-static int mxser_startup(struct mxser_port *info)
+static int mxser_startup(struct tty_struct *tty)
 {
+	struct mxser_port *info = tty->driver_data;
 	unsigned long page;
 	unsigned long flags;
 
@@ -921,8 +926,7 @@ static int mxser_startup(struct mxser_port *info)
 	}
 
 	if (!info->ioaddr || !info->type) {
-		if (info->port.tty)
-			set_bit(TTY_IO_ERROR, &info->port.tty->flags);
+		set_bit(TTY_IO_ERROR, &tty->flags);
 		free_page(page);
 		spin_unlock_irqrestore(&info->slock, flags);
 		return 0;
@@ -952,8 +956,8 @@ static int mxser_startup(struct mxser_port *info)
 	if (inb(info->ioaddr + UART_LSR) == 0xff) {
 		spin_unlock_irqrestore(&info->slock, flags);
 		if (capable(CAP_SYS_ADMIN)) {
-			if (info->port.tty)
-				set_bit(TTY_IO_ERROR, &info->port.tty->flags);
+			if (tty)
+				set_bit(TTY_IO_ERROR, &tty->flags);
 			return 0;
 		} else
 			return -ENODEV;
@@ -991,14 +995,13 @@ static int mxser_startup(struct mxser_port *info)
 	(void) inb(info->ioaddr + UART_IIR);
 	(void) inb(info->ioaddr + UART_MSR);
 
-	if (info->port.tty)
-		clear_bit(TTY_IO_ERROR, &info->port.tty->flags);
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 
 	/*
 	 * and set the speed of the serial port
 	 */
-	mxser_change_speed(info, NULL);
+	mxser_change_speed(tty, NULL);
 	info->port.flags |= ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&info->slock, flags);
 
@@ -1009,8 +1012,9 @@ static int mxser_startup(struct mxser_port *info)
  * This routine will shutdown a serial port; interrupts maybe disabled, and
  * DTR is dropped if the hangup on close termio flag is on.
  */
-static void mxser_shutdown(struct mxser_port *info)
+static void mxser_shutdown(struct tty_struct *tty)
 {
+	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
 	if (!(info->port.flags & ASYNC_INITIALIZED))
@@ -1035,7 +1039,7 @@ static void mxser_shutdown(struct mxser_port *info)
 	info->IER = 0;
 	outb(0x00, info->ioaddr + UART_IER);
 
-	if (!info->port.tty || (info->port.tty->termios->c_cflag & HUPCL))
+	if (tty->termios->c_cflag & HUPCL)
 		info->MCR &= ~(UART_MCR_DTR | UART_MCR_RTS);
 	outb(info->MCR, info->ioaddr + UART_MCR);
 
@@ -1051,8 +1055,7 @@ static void mxser_shutdown(struct mxser_port *info)
 	/* read data port to reset things */
 	(void) inb(info->ioaddr + UART_RX);
 
-	if (info->port.tty)
-		set_bit(TTY_IO_ERROR, &info->port.tty->flags);
+	set_bit(TTY_IO_ERROR, &tty->flags);
 
 	info->port.flags &= ~ASYNC_INITIALIZED;
 
@@ -1084,14 +1087,14 @@ static int mxser_open(struct tty_struct *tty, struct file *filp)
 		return -ENODEV;
 
 	tty->driver_data = info;
-	info->port.tty = tty;
+	tty_port_tty_set(&info->port, tty);
 	/*
 	 * Start up serial port
 	 */
 	spin_lock_irqsave(&info->slock, flags);
 	info->port.count++;
 	spin_unlock_irqrestore(&info->slock, flags);
-	retval = mxser_startup(info);
+	retval = mxser_startup(tty);
 	if (retval)
 		return retval;
 
@@ -1209,13 +1212,13 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 				break;
 		}
 	}
-	mxser_shutdown(info);
+	mxser_shutdown(tty);
 
 	mxser_flush_buffer(tty);
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
-	info->port.tty = NULL;
+	tty_port_tty_set(&info->port, NULL);
 	if (info->port.blocked_open) {
 		if (info->port.close_delay)
 			schedule_timeout_interruptible(info->port.close_delay);
@@ -1337,12 +1340,13 @@ static int mxser_chars_in_buffer(struct tty_struct *tty)
  * friends of mxser_ioctl()
  * ------------------------------------------------------------
  */
-static int mxser_get_serial_info(struct mxser_port *info,
+static int mxser_get_serial_info(struct tty_struct *tty,
 		struct serial_struct __user *retinfo)
 {
+	struct mxser_port *info = tty->driver_data;
 	struct serial_struct tmp = {
 		.type = info->type,
-		.line = info->port.tty->index,
+		.line = tty->index,
 		.port = info->ioaddr,
 		.irq = info->board->irq,
 		.flags = info->port.flags,
@@ -1357,9 +1361,10 @@ static int mxser_get_serial_info(struct mxser_port *info,
 	return 0;
 }
 
-static int mxser_set_serial_info(struct mxser_port *info,
+static int mxser_set_serial_info(struct tty_struct *tty,
 		struct serial_struct __user *new_info)
 {
+	struct mxser_port *info = tty->driver_data;
 	struct serial_struct new_serial;
 	speed_t baud;
 	unsigned long sl_flags;
@@ -1393,14 +1398,14 @@ static int mxser_set_serial_info(struct mxser_port *info,
 				(new_serial.flags & ASYNC_FLAGS));
 		info->port.close_delay = new_serial.close_delay * HZ / 100;
 		info->port.closing_wait = new_serial.closing_wait * HZ / 100;
-		info->port.tty->low_latency =
-				(info->port.flags & ASYNC_LOW_LATENCY) ? 1 : 0;
+		tty->low_latency = (info->port.flags & ASYNC_LOW_LATENCY)
+								? 1 : 0;
 		if ((info->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST &&
 				(new_serial.baud_base != info->baud_base ||
 				new_serial.custom_divisor !=
 				info->custom_divisor)) {
 			baud = new_serial.baud_base / new_serial.custom_divisor;
-			tty_encode_baud_rate(info->port.tty, baud, baud);
+			tty_encode_baud_rate(tty, baud, baud);
 		}
 	}
 
@@ -1411,11 +1416,11 @@ static int mxser_set_serial_info(struct mxser_port *info,
 	if (info->port.flags & ASYNC_INITIALIZED) {
 		if (flags != (info->port.flags & ASYNC_SPD_MASK)) {
 			spin_lock_irqsave(&info->slock, sl_flags);
-			mxser_change_speed(info, NULL);
+			mxser_change_speed(tty, NULL);
 			spin_unlock_irqrestore(&info->slock, sl_flags);
 		}
 	} else
-		retval = mxser_startup(info);
+		retval = mxser_startup(tty);
 
 	return retval;
 }
@@ -1461,7 +1466,7 @@ static int mxser_tiocmget(struct tty_struct *tty, struct file *file)
 	spin_lock_irqsave(&info->slock, flags);
 	status = inb(info->ioaddr + UART_MSR);
 	if (status & UART_MSR_ANY_DELTA)
-		mxser_check_modem_status(info, status);
+		mxser_check_modem_status(tty, info, status);
 	spin_unlock_irqrestore(&info->slock, flags);
 	return ((control & UART_MCR_RTS) ? TIOCM_RTS : 0) |
 		    ((control & UART_MCR_DTR) ? TIOCM_DTR : 0) |
@@ -1606,6 +1611,7 @@ static int __init mxser_read_register(int port, unsigned short *regs)
 static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 {
 	struct mxser_port *port;
+	struct tty_struct *tty;
 	int result, status;
 	unsigned int i, j;
 	int ret = 0;
@@ -1643,12 +1649,14 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 
 				if (!port->ioaddr)
 					goto copy;
+				
+				tty = tty_port_tty_get(&port->port);
 
-				if (!port->port.tty || !port->port.tty->termios)
+				if (!tty || !tty->termios)
 					ms.cflag = port->normal_termios.c_cflag;
 				else
-					ms.cflag = port->port.tty->termios->c_cflag;
-
+					ms.cflag = tty->termios->c_cflag;
+				tty_kref_put(tty);
 				status = inb(port->ioaddr + UART_MSR);
 				if (status & UART_MSR_DCD)
 					ms.dcd = 1;
@@ -1704,15 +1712,18 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 				me->up_txcnt[p] = port->mon_data.up_txcnt;
 				me->modem_status[p] =
 					port->mon_data.modem_status;
-				me->baudrate[p] = tty_get_baud_rate(port->port.tty);
+				tty = tty_port_tty_get(&port->port);
 
-				if (!port->port.tty || !port->port.tty->termios) {
+				if (!tty || !tty->termios) {
 					cflag = port->normal_termios.c_cflag;
 					iflag = port->normal_termios.c_iflag;
+					me->baudrate[p] = tty_termios_baud_rate(&port->normal_termios);
 				} else {
-					cflag = port->port.tty->termios->c_cflag;
-					iflag = port->port.tty->termios->c_iflag;
+					cflag = tty->termios->c_cflag;
+					iflag = tty->termios->c_iflag;
+					me->baudrate[p] = tty_get_baud_rate(tty);
 				}
+				tty_kref_put(tty);
 
 				me->databits[p] = cflag & CSIZE;
 				me->stopbits[p] = cflag & CSTOPB;
@@ -1822,12 +1833,12 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 	switch (cmd) {
 	case TIOCGSERIAL:
 		lock_kernel();
-		retval = mxser_get_serial_info(info, argp);
+		retval = mxser_get_serial_info(tty, argp);
 		unlock_kernel();
 		return retval;
 	case TIOCSSERIAL:
 		lock_kernel();
-		retval = mxser_set_serial_info(info, argp);
+		retval = mxser_set_serial_info(tty, argp);
 		unlock_kernel();
 		return retval;
 	case TIOCSERGETLSR:	/* Get line status register */
@@ -1896,7 +1907,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 
 		lock_kernel();
 		status = mxser_get_msr(info->ioaddr, 1, tty->index);
-		mxser_check_modem_status(info, status);
+		mxser_check_modem_status(tty, info, status);
 
 		mcr = inb(info->ioaddr + UART_MCR);
 		if (mcr & MOXA_MUST_MCR_XON_FLAG)
@@ -1909,7 +1920,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		else
 			info->mon_data.hold_reason |= NPPI_NOTIFY_XOFFXENT;
 
-		if (info->port.tty->hw_stopped)
+		if (tty->hw_stopped)
 			info->mon_data.hold_reason |= NPPI_NOTIFY_CTSHOLD;
 		else
 			info->mon_data.hold_reason &= ~NPPI_NOTIFY_CTSHOLD;
@@ -1958,7 +1969,7 @@ static void mxser_stoprx(struct tty_struct *tty)
 		}
 	}
 
-	if (info->port.tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios->c_cflag & CRTSCTS) {
 		info->MCR &= ~UART_MCR_RTS;
 		outb(info->MCR, info->ioaddr + UART_MCR);
 	}
@@ -1995,7 +2006,7 @@ static void mxser_unthrottle(struct tty_struct *tty)
 		}
 	}
 
-	if (info->port.tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios->c_cflag & CRTSCTS) {
 		info->MCR |= UART_MCR_RTS;
 		outb(info->MCR, info->ioaddr + UART_MCR);
 	}
@@ -2040,7 +2051,7 @@ static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termi
 	unsigned long flags;
 
 	spin_lock_irqsave(&info->slock, flags);
-	mxser_change_speed(info, old_termios);
+	mxser_change_speed(tty, old_termios);
 	spin_unlock_irqrestore(&info->slock, flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
@@ -2138,10 +2149,10 @@ static void mxser_hangup(struct tty_struct *tty)
 	struct mxser_port *info = tty->driver_data;
 
 	mxser_flush_buffer(tty);
-	mxser_shutdown(info);
+	mxser_shutdown(tty);
 	info->port.count = 0;
 	info->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	info->port.tty = NULL;
+	tty_port_tty_set(&info->port, NULL);
 	wake_up_interruptible(&info->port.open_wait);
 }
 
@@ -2164,9 +2175,9 @@ static int mxser_rs_break(struct tty_struct *tty, int break_state)
 	return 0;
 }
 
-static void mxser_receive_chars(struct mxser_port *port, int *status)
+static void mxser_receive_chars(struct tty_struct *tty,
+				struct mxser_port *port, int *status)
 {
-	struct tty_struct *tty = port->port.tty;
 	unsigned char ch, gdl;
 	int ignored = 0;
 	int cnt = 0;
@@ -2174,9 +2185,8 @@ static void mxser_receive_chars(struct mxser_port *port, int *status)
 	int max = 256;
 
 	recv_room = tty->receive_room;
-	if ((recv_room == 0) && (!port->ldisc_stop_rx))
+	if (recv_room == 0 && !port->ldisc_stop_rx)
 		mxser_stoprx(tty);
-
 	if (port->board->chip_flag != MOXA_OTHER_UART) {
 
 		if (*status & UART_LSR_SPECIAL)
@@ -2253,7 +2263,7 @@ intr_old:
 	} while (*status & UART_LSR_DR);
 
 end_intr:
-	mxvar_log.rxcnt[port->port.tty->index] += cnt;
+	mxvar_log.rxcnt[tty->index] += cnt;
 	port->mon_data.rxcnt += cnt;
 	port->mon_data.up_rxcnt += cnt;
 
@@ -2267,14 +2277,14 @@ end_intr:
 	spin_lock(&port->slock);
 }
 
-static void mxser_transmit_chars(struct mxser_port *port)
+static void mxser_transmit_chars(struct tty_struct *tty, struct mxser_port *port)
 {
 	int count, cnt;
 
 	if (port->x_char) {
 		outb(port->x_char, port->ioaddr + UART_TX);
 		port->x_char = 0;
-		mxvar_log.txcnt[port->port.tty->index]++;
+		mxvar_log.txcnt[tty->index]++;
 		port->mon_data.txcnt++;
 		port->mon_data.up_txcnt++;
 		port->icount.tx++;
@@ -2284,8 +2294,8 @@ static void mxser_transmit_chars(struct mxser_port *port)
 	if (port->port.xmit_buf == NULL)
 		return;
 
-	if ((port->xmit_cnt <= 0) || port->port.tty->stopped ||
-			(port->port.tty->hw_stopped &&
+	if (port->xmit_cnt <= 0 || tty->stopped ||
+			(tty->hw_stopped &&
 			(port->type != PORT_16550A) &&
 			(!port->board->chip_flag))) {
 		port->IER &= ~UART_IER_THRI;
@@ -2302,14 +2312,14 @@ static void mxser_transmit_chars(struct mxser_port *port)
 		if (--port->xmit_cnt <= 0)
 			break;
 	} while (--count > 0);
-	mxvar_log.txcnt[port->port.tty->index] += (cnt - port->xmit_cnt);
+	mxvar_log.txcnt[tty->index] += (cnt - port->xmit_cnt);
 
 	port->mon_data.txcnt += (cnt - port->xmit_cnt);
 	port->mon_data.up_txcnt += (cnt - port->xmit_cnt);
 	port->icount.tx += (cnt - port->xmit_cnt);
 
-	if (port->xmit_cnt < WAKEUP_CHARS)
-		tty_wakeup(port->port.tty);
+	if (port->xmit_cnt < WAKEUP_CHARS && tty)
+		tty_wakeup(tty);
 
 	if (port->xmit_cnt <= 0) {
 		port->IER &= ~UART_IER_THRI;
@@ -2328,6 +2338,7 @@ static irqreturn_t mxser_interrupt(int irq, void *dev_id)
 	int max, irqbits, bits, msr;
 	unsigned int int_cnt, pass_counter = 0;
 	int handled = IRQ_NONE;
+	struct tty_struct *tty;
 
 	for (i = 0; i < MXSER_BOARDS; i++)
 		if (dev_id == &mxser_boards[i]) {
@@ -2360,13 +2371,15 @@ static irqreturn_t mxser_interrupt(int irq, void *dev_id)
 				if (iir & UART_IIR_NO_INT)
 					break;
 				iir &= MOXA_MUST_IIR_MASK;
-				if (!port->port.tty ||
+				tty = tty_port_tty_get(&port->port);
+				if (!tty ||
 						(port->port.flags & ASYNC_CLOSING) ||
 						!(port->port.flags &
 							ASYNC_INITIALIZED)) {
 					status = inb(port->ioaddr + UART_LSR);
 					outb(0x27, port->ioaddr + UART_FCR);
 					inb(port->ioaddr + UART_MSR);
+					tty_kref_put(tty);
 					break;
 				}
 
@@ -2387,27 +2400,28 @@ static irqreturn_t mxser_interrupt(int irq, void *dev_id)
 					    iir == MOXA_MUST_IIR_RDA ||
 					    iir == MOXA_MUST_IIR_RTO ||
 					    iir == MOXA_MUST_IIR_LSR)
-						mxser_receive_chars(port,
+						mxser_receive_chars(tty, port,
 								&status);
 
 				} else {
 					status &= port->read_status_mask;
 					if (status & UART_LSR_DR)
-						mxser_receive_chars(port,
+						mxser_receive_chars(tty, port,
 								&status);
 				}
 				msr = inb(port->ioaddr + UART_MSR);
 				if (msr & UART_MSR_ANY_DELTA)
-					mxser_check_modem_status(port, msr);
+					mxser_check_modem_status(tty, port, msr);
 
 				if (port->board->chip_flag) {
 					if (iir == 0x02 && (status &
 								UART_LSR_THRE))
-						mxser_transmit_chars(port);
+						mxser_transmit_chars(tty, port);
 				} else {
 					if (status & UART_LSR_THRE)
-						mxser_transmit_chars(port);
+						mxser_transmit_chars(tty, port);
 				}
+				tty_kref_put(tty);
 			} while (int_cnt++ < MXSER_ISR_PASS_LIMIT);
 			spin_unlock(&port->slock);
 		}

