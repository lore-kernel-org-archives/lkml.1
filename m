Return-Path: <linux-kernel-owner+w=401wt.eu-S1752679AbXCYUqX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679AbXCYUqX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 16:46:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752675AbXCYUqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 16:46:23 -0400
Received: from mxhost.fh-zwickau.de ([141.32.72.200]:13640 "EHLO
	mxhost.fh-zwickau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbXCYUqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 16:46:22 -0400
X-Greylist: delayed 616 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Mar 2007 16:46:21 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ao8CALx5BkaNINDK/2dsb2JhbACdOw
X-IronPort-AV: i="4.14,326,1170630000"; 
   d="scan'208"; a="17442008:sNHT47103472"
Date: Sun, 25 Mar 2007 22:36:02 +0200
From: Joerg Roedel <joro-lkml@zlug.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] riscom8: fix use of deprecated functions
Message-ID: <20070325203601.GA13788@zlug.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Joerg Roedel <joro-lkml@zlug.org>

This patch replaces the deprecated functions in drivers/char/riscom8.c
and fixes the compile warnings they produced.

Signed-off-by: Joerg Roedel <joro-lkml@zlug.org>


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="riscom8-cleanup.patch"

diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 7014525..54cb8cb 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -226,13 +226,13 @@ static void __init rc_init_CD180(struct riscom_board const * bp)
 {
 	unsigned long flags;
 	
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	rc_out(bp, RC_CTOUT, 0);     	           /* Clear timeout             */
 	rc_wait_CCR(bp);			   /* Wait for CCR ready        */
 	rc_out(bp, CD180_CCR, CCR_HARDRESET);      /* Reset CD180 chip          */
-	sti();
+	local_irq_enable();
 	rc_long_delay(HZ/20);                      /* Delay 0.05 sec            */
-	cli();
+	local_irq_disable();
 	rc_out(bp, CD180_GIVR, RC_ID);             /* Set ID for this chip      */
 	rc_out(bp, CD180_GICR, 0);                 /* Clear all bits            */
 	rc_out(bp, CD180_PILR1, RC_ACK_MINT);      /* Prio for modem intr       */
@@ -243,7 +243,7 @@ static void __init rc_init_CD180(struct riscom_board const * bp)
 	rc_out(bp, CD180_PPRH, (RC_OSCFREQ/(1000000/RISCOM_TPS)) >> 8);
 	rc_out(bp, CD180_PPRL, (RC_OSCFREQ/(1000000/RISCOM_TPS)) & 0xff);
 	
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 /* Main probing routine, also sets irq. */
@@ -826,7 +826,7 @@ static int rc_setup_port(struct riscom_board *bp, struct riscom_port *port)
 		port->xmit_buf = (unsigned char *) tmp;
 	}
 		
-	save_flags(flags); cli();
+	local_irq_save(flags);
 		
 	if (port->tty) 
 		clear_bit(TTY_IO_ERROR, &port->tty->flags);
@@ -838,7 +838,7 @@ static int rc_setup_port(struct riscom_board *bp, struct riscom_port *port)
 	rc_change_speed(bp, port);
 	port->flags |= ASYNC_INITIALIZED;
 		
-	restore_flags(flags);
+	local_irq_restore(flags);
 	return 0;
 }
 
@@ -949,19 +949,19 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	retval = 0;
 	add_wait_queue(&port->open_wait, &wait);
-	cli();
+	local_irq_disable();
 	if (!tty_hung_up_p(filp))
 		port->count--;
-	sti();
+	local_irq_enable();
 	port->blocked_open++;
 	while (1) {
-		cli();
+		local_irq_disable();
 		rc_out(bp, CD180_CAR, port_No(port));
 		CD = rc_in(bp, CD180_MSVR) & MSVR_CD;
 		rc_out(bp, CD180_MSVR, MSVR_RTS);
 		bp->DTR &= ~(1u << port_No(port));
 		rc_out(bp, RC_DTR, bp->DTR);
-		sti();
+		local_irq_enable();
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
 		    !(port->flags & ASYNC_INITIALIZED)) {
@@ -1034,7 +1034,7 @@ static void rc_close(struct tty_struct * tty, struct file * filp)
 	if (!port || rc_paranoia_check(port, tty->name, "close"))
 		return;
 	
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	if (tty_hung_up_p(filp))
 		goto out;
 	
@@ -1101,7 +1101,7 @@ static void rc_close(struct tty_struct * tty, struct file * filp)
 	}
 	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
 	wake_up_interruptible(&port->close_wait);
-out:	restore_flags(flags);
+out:	local_irq_restore(flags);
 }
 
 static int rc_write(struct tty_struct * tty, 
@@ -1120,34 +1120,34 @@ static int rc_write(struct tty_struct * tty,
 	if (!tty || !port->xmit_buf)
 		return 0;
 
-	save_flags(flags);
+	local_irq_save(flags);
 	while (1) {
-		cli();		
+		local_irq_disable();
 		c = min_t(int, count, min(SERIAL_XMIT_SIZE - port->xmit_cnt - 1,
 					  SERIAL_XMIT_SIZE - port->xmit_head));
 		if (c <= 0) {
-			restore_flags(flags);
+			local_irq_restore(flags);
 			break;
 		}
 
 		memcpy(port->xmit_buf + port->xmit_head, buf, c);
 		port->xmit_head = (port->xmit_head + c) & (SERIAL_XMIT_SIZE-1);
 		port->xmit_cnt += c;
-		restore_flags(flags);
+		local_irq_restore(flags);
 
 		buf += c;
 		count -= c;
 		total += c;
 	}
 
-	cli();
+	local_irq_disable();
 	if (port->xmit_cnt && !tty->stopped && !tty->hw_stopped &&
 	    !(port->IER & IER_TXRDY)) {
 		port->IER |= IER_TXRDY;
 		rc_out(bp, CD180_CAR, port_No(port));
 		rc_out(bp, CD180_IER, port->IER);
 	}
-	restore_flags(flags);
+	local_irq_restore(flags);
 
 	return total;
 }
@@ -1163,7 +1163,7 @@ static void rc_put_char(struct tty_struct * tty, unsigned char ch)
 	if (!tty || !port->xmit_buf)
 		return;
 
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1)
 		goto out;
@@ -1171,7 +1171,7 @@ static void rc_put_char(struct tty_struct * tty, unsigned char ch)
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
 	port->xmit_cnt++;
-out:	restore_flags(flags);
+out:	local_irq_restore(flags);
 }
 
 static void rc_flush_chars(struct tty_struct * tty)
@@ -1186,11 +1186,11 @@ static void rc_flush_chars(struct tty_struct * tty)
 	    !port->xmit_buf)
 		return;
 
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	port->IER |= IER_TXRDY;
 	rc_out(port_Board(port), CD180_CAR, port_No(port));
 	rc_out(port_Board(port), CD180_IER, port->IER);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 static int rc_write_room(struct tty_struct * tty)
@@ -1225,9 +1225,9 @@ static void rc_flush_buffer(struct tty_struct *tty)
 	if (rc_paranoia_check(port, tty->name, "rc_flush_buffer"))
 		return;
 
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	restore_flags(flags);
+	local_irq_restore(flags);
 	
 	tty_wakeup(tty);
 }
@@ -1244,11 +1244,11 @@ static int rc_tiocmget(struct tty_struct *tty, struct file *file)
 		return -ENODEV;
 
 	bp = port_Board(port);
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	rc_out(bp, CD180_CAR, port_No(port));
 	status = rc_in(bp, CD180_MSVR);
 	result = rc_in(bp, RC_RI) & (1u << port_No(port)) ? 0 : TIOCM_RNG;
-	restore_flags(flags);
+	local_irq_restore(flags);
 	result |= ((status & MSVR_RTS) ? TIOCM_RTS : 0)
 		| ((status & MSVR_DTR) ? TIOCM_DTR : 0)
 		| ((status & MSVR_CD)  ? TIOCM_CAR : 0)
@@ -1269,7 +1269,7 @@ static int rc_tiocmset(struct tty_struct *tty, struct file *file,
 
 	bp = port_Board(port);
 
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	if (set & TIOCM_RTS)
 		port->MSVR |= MSVR_RTS;
 	if (set & TIOCM_DTR)
@@ -1283,7 +1283,7 @@ static int rc_tiocmset(struct tty_struct *tty, struct file *file,
 	rc_out(bp, CD180_CAR, port_No(port));
 	rc_out(bp, CD180_MSVR, port->MSVR);
 	rc_out(bp, RC_DTR, bp->DTR);
-	restore_flags(flags);
+	local_irq_restore(flags);
 	return 0;
 }
 
@@ -1292,7 +1292,7 @@ static inline void rc_send_break(struct riscom_port * port, unsigned long length
 	struct riscom_board *bp = port_Board(port);
 	unsigned long flags;
 	
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	port->break_length = RISCOM_TPS / HZ * length;
 	port->COR2 |= COR2_ETC;
 	port->IER  |= IER_TXRDY;
@@ -1302,7 +1302,7 @@ static inline void rc_send_break(struct riscom_port * port, unsigned long length
 	rc_wait_CCR(bp);
 	rc_out(bp, CD180_CCR, CCR_CORCHG2);
 	rc_wait_CCR(bp);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 static inline int rc_set_serial_info(struct riscom_port * port,
@@ -1345,9 +1345,9 @@ static inline int rc_set_serial_info(struct riscom_port * port,
 		port->closing_wait = tmp.closing_wait;
 	}
 	if (change_speed)  {
-		save_flags(flags); cli();
+		local_irq_save(flags);
 		rc_change_speed(bp, port);
-		restore_flags(flags);
+		local_irq_restore(flags);
 	}
 	return 0;
 }
@@ -1428,7 +1428,7 @@ static void rc_throttle(struct tty_struct * tty)
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	port->MSVR &= ~MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
 	if (I_IXOFF(tty))  {
@@ -1437,7 +1437,7 @@ static void rc_throttle(struct tty_struct * tty)
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 static void rc_unthrottle(struct tty_struct * tty)
@@ -1451,7 +1451,7 @@ static void rc_unthrottle(struct tty_struct * tty)
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	port->MSVR |= MSVR_RTS;
 	rc_out(bp, CD180_CAR, port_No(port));
 	if (I_IXOFF(tty))  {
@@ -1460,7 +1460,7 @@ static void rc_unthrottle(struct tty_struct * tty)
 		rc_wait_CCR(bp);
 	}
 	rc_out(bp, CD180_MSVR, port->MSVR);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 static void rc_stop(struct tty_struct * tty)
@@ -1474,11 +1474,11 @@ static void rc_stop(struct tty_struct * tty)
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	port->IER &= ~IER_TXRDY;
 	rc_out(bp, CD180_CAR, port_No(port));
 	rc_out(bp, CD180_IER, port->IER);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 static void rc_start(struct tty_struct * tty)
@@ -1492,13 +1492,13 @@ static void rc_start(struct tty_struct * tty)
 	
 	bp = port_Board(port);
 	
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	if (port->xmit_cnt && port->xmit_buf && !(port->IER & IER_TXRDY))  {
 		port->IER |= IER_TXRDY;
 		rc_out(bp, CD180_CAR, port_No(port));
 		rc_out(bp, CD180_IER, port->IER);
 	}
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 /*
@@ -1550,9 +1550,9 @@ static void rc_set_termios(struct tty_struct * tty, struct ktermios * old_termio
 	    tty->termios->c_iflag == old_termios->c_iflag)
 		return;
 
-	save_flags(flags); cli();
+	local_irq_save(flags);
 	rc_change_speed(port_Board(port), port);
-	restore_flags(flags);
+	local_irq_restore(flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
 	    !(tty->termios->c_cflag & CRTSCTS)) {
@@ -1641,11 +1641,10 @@ static void rc_release_drivers(void)
 {
 	unsigned long flags;
 
-	save_flags(flags);
-	cli();
+	local_irq_save(flags);
 	tty_unregister_driver(riscom_driver);
 	put_tty_driver(riscom_driver);
-	restore_flags(flags);
+	local_irq_restore(flags);
 }
 
 #ifndef MODULE

--0OAP2g/MAC+5xKAE--
