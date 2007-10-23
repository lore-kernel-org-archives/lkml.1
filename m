Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXJWWiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXJWWiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 18:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbXJWWgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 18:36:41 -0400
Received: from havoc.gtf.org ([69.61.125.42]:40221 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbXJWWgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 18:36:39 -0400
To: LKML <linux-kernel@vger.kernel.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: akpm@linux-foundation.org
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org>
Subject: [PATCH 4/12] riscom8: fix SMP brokenness
Message-Id: <20071023223638.DD9FE1F81A8@havoc.gtf.org>
Date: Tue, 23 Oct 2007 18:36:38 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

After analyzing the elements that save_flags/cli/sti/restore_flags were
protecting, convert their usages to a global spinlock (the easiest and
most obvious next-step).  There were some usages of flags being
intentionally cached, because the code already knew the state of
interrupts.  These have been taken into account.

This allows us to remove CONFIG_BROKEN_ON_SMP.  Completely untested.

Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
---

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 6549110..27ab43e 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -276,7 +276,7 @@ config N_HDLC
 
 config RISCOM8
 	tristate "SDL RISCom/8 card support"
-	depends on SERIAL_NONSTANDARD && BROKEN_ON_SMP
+	depends on SERIAL_NONSTANDARD
 	help
 	  This is a driver for the SDL Communications RISCom/8 multiport card,
 	  which gives you many serial ports. You would need something like
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index b37e626..45d109c 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -47,6 +47,7 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/tty_flip.h>
+#include <linux/spinlock.h>
 
 #include <asm/uaccess.h>
 
@@ -82,6 +83,8 @@
 static struct riscom_board * IRQ_to_board[16];
 static struct tty_driver *riscom_driver;
 
+static spinlock_t riscom_lock = SPIN_LOCK_UNLOCKED;
+
 static struct riscom_board rc_board[RC_NBOARD] =  {
 	{
 		.base	= RC_IOBASE1,
@@ -218,13 +221,14 @@ static void __init rc_init_CD180(struct riscom_board const * bp)
 {
 	unsigned long flags;
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	rc_out(bp, RC_CTOUT, 0);     	           /* Clear timeout             */
 	rc_wait_CCR(bp);			   /* Wait for CCR ready        */
 	rc_out(bp, CD180_CCR, CCR_HARDRESET);      /* Reset CD180 chip          */
-	sti();
+	spin_unlock_irqrestore(&riscom_lock, flags);
 	msleep(50);				   /* Delay 0.05 sec            */
-	cli();
+	spin_lock_irqsave(&riscom_lock, flags);
 	rc_out(bp, CD180_GIVR, RC_ID);             /* Set ID for this chip      */
 	rc_out(bp, CD180_GICR, 0);                 /* Clear all bits            */
 	rc_out(bp, CD180_PILR1, RC_ACK_MINT);      /* Prio for modem intr       */
@@ -235,7 +239,7 @@ static void __init rc_init_CD180(struct riscom_board const * bp)
 	rc_out(bp, CD180_PPRH, (RC_OSCFREQ/(1000000/RISCOM_TPS)) >> 8);
 	rc_out(bp, CD180_PPRL, (RC_OSCFREQ/(1000000/RISCOM_TPS)) & 0xff);
 	
-	restore_flags(flags);
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 /* Main probing routine, also sets irq. */
@@ -817,9 +821,9 @@ static int rc_setup_port(struct riscom_board *bp, struct riscom_port *port)
 		}
 		port->xmit_buf = (unsigned char *) tmp;
 	}
-		
-	save_flags(flags); cli();
-		
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (port->tty) 
 		clear_bit(TTY_IO_ERROR, &port->tty->flags);
 		
@@ -830,7 +834,7 @@ static int rc_setup_port(struct riscom_board *bp, struct riscom_port *port)
 	rc_change_speed(bp, port);
 	port->flags |= ASYNC_INITIALIZED;
 		
-	restore_flags(flags);
+	spin_unlock_irqrestore(&riscom_lock, flags);
 	return 0;
 }
 
@@ -906,6 +910,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	int    retval;
 	int    do_clocal = 0;
 	int    CD;
+	unsigned long flags;
 
 	/*
 	 * If the device is in the middle of being closed, then block
@@ -941,19 +946,26 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	retval = 0;
 	add_wait_queue(&port->open_wait, &wait);
-	cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (!tty_hung_up_p(filp))
 		port->count--;
-	sti();
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+
 	port->blocked_open++;
 	while (1) {
-		cli();
+		spin_lock_irqsave(&riscom_lock, flags);
+
 		rc_out(bp, CD180_CAR, port_No(port));
 		CD = rc_in(bp, CD180_MSVR) & MSVR_CD;
 		rc_out(bp, CD180_MSVR, MSVR_RTS);
 		bp->DTR &= ~(1u << port_No(port));
 		rc_out(bp, RC_DTR, bp->DTR);
-		sti();
+
+		spin_unlock_irqrestore(&riscom_lock, flags);
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
 		    !(port->flags & ASYNC_INITIALIZED)) {
@@ -1025,8 +1037,9 @@ static void rc_close(struct tty_struct * tty, struct file * filp)
 	
 	if (!port || rc_paranoia_check(port, tty->name, "close"))
 		return;
-	
-	save_flags(flags); cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (tty_hung_up_p(filp))
 		goto out;
 	
@@ -1093,7 +1106,9 @@ static void rc_close(struct tty_struct * tty, struct file * filp)
 	}
 	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&port->close_wait);
-out:	restore_flags(flags);
+
+out:
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static int rc_write(struct tty_struct * tty, 
@@ -1112,34 +1127,33 @@ static int rc_write(struct tty_struct * tty,
 	if (!tty || !port->xmit_buf)
 		return 0;
 
-	save_flags(flags);
 	while (1) {
-		cli();		
+		spin_lock_irqsave(&riscom_lock, flags);
+
 		c = min_t(int, count, min(SERIAL_XMIT_SIZE - port->xmit_cnt - 1,
 					  SERIAL_XMIT_SIZE - port->xmit_head));
-		if (c <= 0) {
-			restore_flags(flags);
-			break;
-		}
+		if (c <= 0)
+			break;	/* lock continues to be held */
 
 		memcpy(port->xmit_buf + port->xmit_head, buf, c);
 		port->xmit_head = (port->xmit_head + c) & (SERIAL_XMIT_SIZE-1);
 		port->xmit_cnt += c;
-		restore_flags(flags);
+
+		spin_unlock_irqrestore(&riscom_lock, flags);
 
 		buf += c;
 		count -= c;
 		total += c;
 	}
 
-	cli();
 	if (port->xmit_cnt && !tty->stopped && !tty->hw_stopped &&
 	    !(port->IER & IER_TXRDY)) {
 		port->IER |= IER_TXRDY;
 		rc_out(bp, CD180_CAR, port_No(port));
 		rc_out(bp, CD180_IER, port->IER);
 	}
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 
 	return total;
 }
@@ -1155,7 +1169,7 @@ static void rc_put_char(struct tty_struct * tty, unsigned char ch)
 	if (!tty || !port->xmit_buf)
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
 	
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
 		goto out;
@@ -1163,7 +1177,9 @@ static void rc_put_char(struct tty_struct * tty, unsigned char ch)
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	port->xmit_cnt++;
-out:	restore_flags(flags);
+
+out:
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_flush_chars(struct tty_struct * tty)
@@ -1178,11 +1194,13 @@ static void rc_flush_chars(struct tty_struct * tty)
 	    !port->xmit_buf)
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->IER |= IER_TXRDY;
 	rc_out(port_Board(port), CD180_CAR, port_No(port));
 	rc_out(port_Board(port), CD180_IER, port->IER);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static int rc_write_room(struct tty_struct * tty)
@@ -1217,9 +1235,11 @@ static void rc_flush_buffer(struct tty_struct *tty)
 	if (rc_paranoia_check(port, tty->name, "rc_flush_buffer"))
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 	
 	tty_wakeup(tty);
 }
@@ -1236,11 +1256,15 @@ static int rc_tiocmget(struct tty_struct *tty, struct file *file)
 		return -ENODEV;
 
 	bp = port_Board(port);
-	save_flags(flags); cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	rc_out(bp, CD180_CAR, port_No(port));
 	status = rc_in(bp, CD180_MSVR);
 	result = rc_in(bp, RC_RI) & (1u << port_No(port)) ? 0 : TIOCM_RNG;
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+
 	result |= ((status & MSVR_RTS) ? TIOCM_RTS : 0)
 		| ((status & MSVR_DTR) ? TIOCM_DTR : 0)
 		| ((status & MSVR_CD)  ? TIOCM_CAR : 0)
@@ -1261,7 +1285,8 @@ static int rc_tiocmset(struct tty_struct *tty, struct file *file,
 
 	bp = port_Board(port);
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (set & TIOCM_RTS)
 		port->MSVR |= MSVR_RTS;
 	if (set & TIOCM_DTR)
@@ -1275,7 +1300,9 @@ static int rc_tiocmset(struct tty_struct *tty, struct file *file,
 	rc_out(bp, CD180_CAR, port_No(port));
 	rc_out(bp, CD180_MSVR, port->MSVR);
 	rc_out(bp, RC_DTR, bp->DTR);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
+
 	return 0;
 }
 
@@ -1284,7 +1311,8 @@ static inline void rc_send_break(struct riscom_port * port, unsigned long length
 	struct riscom_board *bp = port_Board(port);
 	unsigned long flags;
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->break_length = RISCOM_TPS / HZ * length;
 	port->COR2 |= COR2_ETC;
 	port->IER  |= IER_TXRDY;
@@ -1294,7 +1322,8 @@ static inline void rc_send_break(struct riscom_port * port, unsigned long length
 	rc_wait_CCR(bp);
 	rc_out(bp, CD180_CCR, CCR_CORCHG2);
 	rc_wait_CCR(bp);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static inline int rc_set_serial_info(struct riscom_port * port,
@@ -1303,7 +1332,6 @@ static inline int rc_set_serial_info(struct riscom_port * port,
 	struct serial_struct tmp;
 	struct riscom_board *bp = port_Board(port);
 	int change_speed;
-	unsigned long flags;
 	
 	if (copy_from_user(&tmp, newinfo, sizeof(tmp)))
 		return -EFAULT;
@@ -1337,9 +1365,11 @@ static inline int rc_set_serial_info(struct riscom_port * port,
 		port->closing_wait = tmp.closing_wait;
 	}
 	if (change_speed)  {
-		save_flags(flags); cli();
+		unsigned long flags;
+
+		spin_lock_irqsave(&riscom_lock, flags);
 		rc_change_speed(bp, port);
-		restore_flags(flags);
+		spin_unlock_irqrestore(&riscom_lock, flags);
 	}
 	return 0;
 }
@@ -1419,17 +1449,19 @@ static void rc_throttle(struct tty_struct * tty)
 		return;
 	
 	bp = port_Board(port);
-	
-	save_flags(flags); cli();
+
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->MSVR &= ~MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
-	if (I_IXOFF(tty))  {
+	if (I_IXOFF(tty)) {
 		rc_wait_CCR(bp);
 		rc_out(bp, CD180_CCR, CCR_SSCH2);
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_unthrottle(struct tty_struct * tty)
@@ -1443,7 +1475,8 @@ static void rc_unthrottle(struct tty_struct * tty)
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->MSVR |= MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
 	if (I_IXOFF(tty))  {
@@ -1452,7 +1485,8 @@ static void rc_unthrottle(struct tty_struct * tty)
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_stop(struct tty_struct * tty)
@@ -1466,11 +1500,13 @@ static void rc_stop(struct tty_struct * tty)
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	port->IER &= ~IER_TXRDY;
 	rc_out(bp, CD180_CAR, port_No(port));
 	rc_out(bp, CD180_IER, port->IER);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 static void rc_start(struct tty_struct * tty)
@@ -1484,13 +1520,15 @@ static void rc_start(struct tty_struct * tty)
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	if (port->xmit_cnt && port->xmit_buf && !(port->IER & IER_TXRDY))  {
 		port->IER |= IER_TXRDY;
 		rc_out(bp, CD180_CAR, port_No(port));
 		rc_out(bp, CD180_IER, port->IER);
 	}
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 /*
@@ -1542,9 +1580,9 @@ static void rc_set_termios(struct tty_struct * tty, struct ktermios * old_termio
 	    tty->termios->c_iflag == old_termios->c_iflag)
 		return;
 
-	save_flags(flags); cli();
+	spin_lock_irqsave(&riscom_lock, flags);
 	rc_change_speed(port_Board(port), port);
-	restore_flags(flags);
+	spin_unlock_irqrestore(&riscom_lock, flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
@@ -1633,11 +1671,12 @@ static void rc_release_drivers(void)
 {
 	unsigned long flags;
 
-	save_flags(flags);
-	cli();
+	spin_lock_irqsave(&riscom_lock, flags);
+
 	tty_unregister_driver(riscom_driver);
 	put_tty_driver(riscom_driver);
-	restore_flags(flags);
+
+	spin_unlock_irqrestore(&riscom_lock, flags);
 }
 
 #ifndef MODULE
