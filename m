Return-Path: <linux-kernel-owner+w=401wt.eu-S932234AbXDNMn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932234AbXDNMn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 08:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965336AbXDNMn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 08:43:58 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:41702 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932234AbXDNMn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 08:43:57 -0400
Message-id: <3018694794025219@wsc.cz>
In-reply-to: <20070414102528.GB20376@fi.muni.cz>
References: <20070414042725.GT20376@fi.muni.cz> <462079ED.2000605@gmail.com> <462079ED.2000605@gmail.com>
Subject: [RFC 1/1] Char: mxser_new, fix recursive locking
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Cc: <osv@javad.com>
Subject: Re: MOXA: mxser_new lockup
Date: Sat, 14 Apr 2007 14:43:55 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kasprzak wrote:
> Jiri Slaby wrote:
> : wrong. Could you please enable CONFIG_PROVE_LOCKING and CONFIG_DEBUG_LOCKDEP and
> 
> 	Looking at the code, maybe the &port->slock in mxser_interrupt()
> should be dropped before calling mxser_receive_chars() (and probably
> also befor calling other mxser_* functions too). A proof-of-concept
> patch attached - I am not able to reproduce the lockup with this patch.
> Another approach would be to use in_interrupt() all over the code to
> determine whether the lock should be re-aquired or not.

I would rather incline to the second variant as it is the original approach
from moxa driver and I have no idea, what might happen if we drop the lock
before calling all involved mxser_ routines.

Could you both (if possible) test the attached patch and drop a message,
please?

--

mxser_new, fix recursive locking

Acquire a port lock only if not in_interrupt, because ISR holds the lock
yet (and ldisc calls some of driver's routines which tries to acquire it
again due to tty->low_latency).

Thanks to Jan "Yenya" Kasprzak for revealing this issue.

Cc: Jan "Yenya" Kasprzak <kas@fi.muni.cz>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a00e6d6d5f44defe9c01be2c6a3fdf1c890917c8
tree c4f2698596ec7eeb3290da616b64c2fb36797032
parent 54f13ae12fa0a3e3fc02dda6225baa3436f1e93a
author Jiri Slaby <jirislaby@gmail.com> Sat, 14 Apr 2007 14:00:01 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 14 Apr 2007 14:00:01 +0200

 drivers/char/mxser_new.c |  132 +++++++++++++++++++++++++---------------------
 1 files changed, 71 insertions(+), 61 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index 6362e78..0086b73 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -85,6 +85,16 @@
 #define MXSER_HIGHBAUD	1
 #define MXSER_HAS2	2
 
+/* if we are in interrupt, lock is held by ISR, don't acquire it again! */
+#define mx_lock(info, flags) do {				\
+	if (!in_interrupt())					\
+		spin_lock_irqsave(&(info)->slock, flags);	\
+} while (0)
+#define mx_unlock(info, flags) do {				\
+	if (!in_interrupt())					\
+		spin_unlock_irqrestore(&(info)->slock, flags);	\
+} while (0)
+
 /* This is only for PCI */
 static const struct {
 	int type;
@@ -415,16 +425,16 @@ static int mxser_block_til_ready(struct tty_struct *tty, struct file *filp,
 	retval = 0;
 	add_wait_queue(&port->open_wait, &wait);
 
-	spin_lock_irqsave(&port->slock, flags);
+	mx_lock(port, flags);
 	if (!tty_hung_up_p(filp))
 		port->count--;
-	spin_unlock_irqrestore(&port->slock, flags);
+	mx_unlock(port, flags);
 	port->blocked_open++;
 	while (1) {
-		spin_lock_irqsave(&port->slock, flags);
+		mx_lock(port, flags);
 		outb(inb(port->ioaddr + UART_MCR) |
 			UART_MCR_DTR | UART_MCR_RTS, port->ioaddr + UART_MCR);
-		spin_unlock_irqrestore(&port->slock, flags);
+		mx_unlock(port, flags);
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)) {
 			if (port->flags & ASYNC_HUP_NOTIFY)
@@ -765,11 +775,11 @@ static int mxser_startup(struct mxser_port *info)
 	if (!page)
 		return -ENOMEM;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 
 	if (info->flags & ASYNC_INITIALIZED) {
 		free_page(page);
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 		return 0;
 	}
 
@@ -777,7 +787,7 @@ static int mxser_startup(struct mxser_port *info)
 		if (info->tty)
 			set_bit(TTY_IO_ERROR, &info->tty->flags);
 		free_page(page);
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 		return 0;
 	}
 	if (info->xmit_buf)
@@ -803,7 +813,7 @@ static int mxser_startup(struct mxser_port *info)
 	 * here.
 	 */
 	if (inb(info->ioaddr + UART_LSR) == 0xff) {
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 		if (capable(CAP_SYS_ADMIN)) {
 			if (info->tty)
 				set_bit(TTY_IO_ERROR, &info->tty->flags);
@@ -853,7 +863,7 @@ static int mxser_startup(struct mxser_port *info)
 	 */
 	mxser_change_speed(info, NULL);
 	info->flags |= ASYNC_INITIALIZED;
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 
 	return 0;
 }
@@ -869,7 +879,7 @@ static void mxser_shutdown(struct mxser_port *info)
 	if (!(info->flags & ASYNC_INITIALIZED))
 		return;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 
 	/*
 	 * clear delta_msr_wait queue to avoid mem leaks: we may free the irq
@@ -912,7 +922,7 @@ static void mxser_shutdown(struct mxser_port *info)
 	if (info->board->chip_flag)
 		SET_MOXA_MUST_NO_SOFTWARE_FLOW_CONTROL(info->ioaddr);
 
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 /*
@@ -941,9 +951,9 @@ static int mxser_open(struct tty_struct *tty, struct file *filp)
 	/*
 	 * Start up serial port
 	 */
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	info->count++;
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	retval = mxser_startup(info);
 	if (retval)
 		return retval;
@@ -975,10 +985,10 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 	if (!info)
 		return;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 
 	if (tty_hung_up_p(filp)) {
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 		return;
 	}
 	if ((tty->count == 1) && (info->count != 1)) {
@@ -999,11 +1009,11 @@ static void mxser_close(struct tty_struct *tty, struct file *filp)
 		info->count = 0;
 	}
 	if (info->count) {
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 		return;
 	}
 	info->flags |= ASYNC_CLOSING;
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	/*
 	 * Save the termios structure, since this port may have
 	 * separate termios for callout and dialin.
@@ -1076,11 +1086,11 @@ static int mxser_write(struct tty_struct *tty, const unsigned char *buf, int cou
 			break;
 
 		memcpy(info->xmit_buf + info->xmit_head, buf, c);
-		spin_lock_irqsave(&info->slock, flags);
+		mx_lock(info, flags);
 		info->xmit_head = (info->xmit_head + c) &
 				  (SERIAL_XMIT_SIZE - 1);
 		info->xmit_cnt += c;
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 
 		buf += c;
 		count -= c;
@@ -1091,12 +1101,12 @@ static int mxser_write(struct tty_struct *tty, const unsigned char *buf, int cou
 		if (!tty->hw_stopped ||
 				(info->type == PORT_16550A) ||
 				(info->board->chip_flag)) {
-			spin_lock_irqsave(&info->slock, flags);
+			mx_lock(info, flags);
 			outb(info->IER & ~UART_IER_THRI, info->ioaddr +
 					UART_IER);
 			info->IER |= UART_IER_THRI;
 			outb(info->IER, info->ioaddr + UART_IER);
-			spin_unlock_irqrestore(&info->slock, flags);
+			mx_unlock(info, flags);
 		}
 	}
 	return total;
@@ -1113,20 +1123,20 @@ static void mxser_put_char(struct tty_struct *tty, unsigned char ch)
 	if (info->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
 		return;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	info->xmit_buf[info->xmit_head++] = ch;
 	info->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	info->xmit_cnt++;
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	if (!tty->stopped) {
 		if (!tty->hw_stopped ||
 				(info->type == PORT_16550A) ||
 				info->board->chip_flag) {
-			spin_lock_irqsave(&info->slock, flags);
+			mx_lock(info, flags);
 			outb(info->IER & ~UART_IER_THRI, info->ioaddr + UART_IER);
 			info->IER |= UART_IER_THRI;
 			outb(info->IER, info->ioaddr + UART_IER);
-			spin_unlock_irqrestore(&info->slock, flags);
+			mx_unlock(info, flags);
 		}
 	}
 }
@@ -1146,13 +1156,13 @@ static void mxser_flush_chars(struct tty_struct *tty)
 			))
 		return;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 
 	outb(info->IER & ~UART_IER_THRI, info->ioaddr + UART_IER);
 	info->IER |= UART_IER_THRI;
 	outb(info->IER, info->ioaddr + UART_IER);
 
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static int mxser_write_room(struct tty_struct *tty)
@@ -1179,7 +1189,7 @@ static void mxser_flush_buffer(struct tty_struct *tty)
 	unsigned long flags;
 
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	info->xmit_cnt = info->xmit_head = info->xmit_tail = 0;
 
 	fcr = inb(info->ioaddr + UART_FCR);
@@ -1187,7 +1197,7 @@ static void mxser_flush_buffer(struct tty_struct *tty)
 		info->ioaddr + UART_FCR);
 	outb(fcr, info->ioaddr + UART_FCR);
 
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 
 	tty_wakeup(tty);
 }
@@ -1268,9 +1278,9 @@ static int mxser_set_serial_info(struct mxser_port *info,
 
 	if (info->flags & ASYNC_INITIALIZED) {
 		if (flags != (info->flags & ASYNC_SPD_MASK)) {
-			spin_lock_irqsave(&info->slock, sl_flags);
+			mx_lock(info, sl_flags);
 			mxser_change_speed(info, NULL);
-			spin_unlock_irqrestore(&info->slock, sl_flags);
+			mx_unlock(info, sl_flags);
 		}
 	} else
 		retval = mxser_startup(info);
@@ -1295,9 +1305,9 @@ static int mxser_get_lsr_info(struct mxser_port *info,
 	unsigned int result;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	status = inb(info->ioaddr + UART_LSR);
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	result = ((status & UART_LSR_TEMT) ? TIOCSER_TEMT : 0);
 	return put_user(result, value);
 }
@@ -1312,15 +1322,15 @@ static void mxser_send_break(struct mxser_port *info, int duration)
 	if (!info->ioaddr)
 		return;
 	set_current_state(TASK_INTERRUPTIBLE);
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	outb(inb(info->ioaddr + UART_LCR) | UART_LCR_SBC,
 		info->ioaddr + UART_LCR);
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	schedule_timeout(duration);
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	outb(inb(info->ioaddr + UART_LCR) & ~UART_LCR_SBC,
 		info->ioaddr + UART_LCR);
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static int mxser_tiocmget(struct tty_struct *tty, struct file *file)
@@ -1337,11 +1347,11 @@ static int mxser_tiocmget(struct tty_struct *tty, struct file *file)
 
 	control = info->MCR;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	status = inb(info->ioaddr + UART_MSR);
 	if (status & UART_MSR_ANY_DELTA)
 		mxser_check_modem_status(info, status);
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	return ((control & UART_MCR_RTS) ? TIOCM_RTS : 0) |
 		    ((control & UART_MCR_DTR) ? TIOCM_DTR : 0) |
 		    ((status & UART_MSR_DCD) ? TIOCM_CAR : 0) |
@@ -1362,7 +1372,7 @@ static int mxser_tiocmset(struct tty_struct *tty, struct file *file,
 	if (test_bit(TTY_IO_ERROR, &tty->flags))
 		return -EIO;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 
 	if (set & TIOCM_RTS)
 		info->MCR |= UART_MCR_RTS;
@@ -1375,7 +1385,7 @@ static int mxser_tiocmset(struct tty_struct *tty, struct file *file,
 		info->MCR &= ~UART_MCR_DTR;
 
 	outb(info->MCR, info->ioaddr + UART_MCR);
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 	return 0;
 }
 
@@ -1706,9 +1716,9 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 			info->tty->termios->c_cflag |= mxvar_baud_table1[i];
 
 		info->speed = speed;
-		spin_lock_irqsave(&info->slock, flags);
+		mx_lock(info, flags);
 		mxser_change_speed(info, NULL);
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 
 		return 0;
 	} else if (cmd == MOXA_GET_SPECIAL_BAUD_RATE) {
@@ -1760,15 +1770,15 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 	case TIOCMIWAIT: {
 		DECLARE_WAITQUEUE(wait, current);
 		int ret;
-		spin_lock_irqsave(&info->slock, flags);
+		mx_lock(info, flags);
 		cprev = info->icount;	/* note the counters on entry */
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 
 		add_wait_queue(&info->delta_msr_wait, &wait);
 		while (1) {
-			spin_lock_irqsave(&info->slock, flags);
+			mx_lock(info, flags);
 			cnow = info->icount;	/* atomic copy */
-			spin_unlock_irqrestore(&info->slock, flags);
+			mx_unlock(info, flags);
 
 			set_current_state(TASK_INTERRUPTIBLE);
 			if (((arg & TIOCM_RNG) &&
@@ -1801,9 +1811,9 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 	 *     RI where only 0->1 is counted.
 	 */
 	case TIOCGICOUNT:
-		spin_lock_irqsave(&info->slock, flags);
+		mx_lock(info, flags);
 		cnow = info->icount;
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 		p_cuser = argp;
 		if (put_user(cnow.frame, &p_cuser->frame))
 			return -EFAULT;
@@ -1834,9 +1844,9 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		long baud;
 		if (get_user(baud, (long __user *)argp))
 			return -EFAULT;
-		spin_lock_irqsave(&info->slock, flags);
+		mx_lock(info, flags);
 		mxser_set_baud(info, baud);
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 		return 0;
 	}
 	case MOXA_ASPP_GETBAUD:
@@ -1983,12 +1993,12 @@ static void mxser_stop(struct tty_struct *tty)
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	if (info->IER & UART_IER_THRI) {
 		info->IER &= ~UART_IER_THRI;
 		outb(info->IER, info->ioaddr + UART_IER);
 	}
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static void mxser_start(struct tty_struct *tty)
@@ -1996,13 +2006,13 @@ static void mxser_start(struct tty_struct *tty)
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	if (info->xmit_cnt && info->xmit_buf) {
 		outb(info->IER & ~UART_IER_THRI, info->ioaddr + UART_IER);
 		info->IER |= UART_IER_THRI;
 		outb(info->IER, info->ioaddr + UART_IER);
 	}
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
@@ -2013,9 +2023,9 @@ static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termi
 	if ((tty->termios->c_cflag != old_termios->c_cflag) ||
 			(RELEVANT_IFLAG(tty->termios->c_iflag) != RELEVANT_IFLAG(old_termios->c_iflag))) {
 
-		spin_lock_irqsave(&info->slock, flags);
+		mx_lock(info, flags);
 		mxser_change_speed(info, old_termios);
-		spin_unlock_irqrestore(&info->slock, flags);
+		mx_unlock(info, flags);
 
 		if ((old_termios->c_cflag & CRTSCTS) &&
 				!(tty->termios->c_cflag & CRTSCTS)) {
@@ -2030,9 +2040,9 @@ static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termi
 		tty->stopped = 0;
 
 		if (info->board->chip_flag) {
-			spin_lock_irqsave(&info->slock, flags);
+			mx_lock(info, flags);
 			DISABLE_MOXA_MUST_RX_SOFTWARE_FLOW_CONTROL(info->ioaddr);
-			spin_unlock_irqrestore(&info->slock, flags);
+			mx_unlock(info, flags);
 		}
 
 		mxser_start(tty);
@@ -2126,14 +2136,14 @@ static void mxser_rs_break(struct tty_struct *tty, int break_state)
 	struct mxser_port *info = tty->driver_data;
 	unsigned long flags;
 
-	spin_lock_irqsave(&info->slock, flags);
+	mx_lock(info, flags);
 	if (break_state == -1)
 		outb(inb(info->ioaddr + UART_LCR) | UART_LCR_SBC,
 			info->ioaddr + UART_LCR);
 	else
 		outb(inb(info->ioaddr + UART_LCR) & ~UART_LCR_SBC,
 			info->ioaddr + UART_LCR);
-	spin_unlock_irqrestore(&info->slock, flags);
+	mx_unlock(info, flags);
 }
 
 static void mxser_receive_chars(struct mxser_port *port, int *status)
