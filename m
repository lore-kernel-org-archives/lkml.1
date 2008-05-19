Return-Path: <linux-kernel-owner+w=401wt.eu-S932205AbYESPHy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932205AbYESPHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:07:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761379AbYESPEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:04:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39744 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761317AbYESPE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:04:27 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 14/20] gs: use tty_port
To: linux-kernel@vger.kernel.org, akpm@osdl.org, greg@kroah.com
Date: Mon, 19 May 2008 15:51:26 +0100
Message-ID: <20080519145125.19326.60580.stgit@core>
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

Switch drivers using the old "generic serial" driver to use the tty_port
structures
---

 drivers/char/generic_serial.c  |  158 ++++++++++++++++++++--------------------
 drivers/char/rio/rio_linux.c   |   20 +++--
 drivers/char/rio/riocmd.c      |   10 +--
 drivers/char/rio/riointr.c     |   10 +--
 drivers/char/rio/rioparam.c    |    2 -
 drivers/char/rio/riotty.c      |   16 ++--
 drivers/char/sx.c              |  115 ++++++++++++++---------------
 include/linux/generic_serial.h |    8 +-
 8 files changed, 166 insertions(+), 173 deletions(-)


diff --git a/drivers/char/generic_serial.c b/drivers/char/generic_serial.c
index 252f73e..4bde737 100644
--- a/drivers/char/generic_serial.c
+++ b/drivers/char/generic_serial.c
@@ -60,7 +60,7 @@ int gs_put_char(struct tty_struct * tty, unsigned char ch)
 
 	if (!port) return 0;
 
-	if (! (port->flags & ASYNC_INITIALIZED)) return 0;
+	if (! (port->port.flags & ASYNC_INITIALIZED)) return 0;
 
 	/* Take a lock on the serial tranmit buffer! */
 	mutex_lock(& port->port_write_mutex);
@@ -103,7 +103,7 @@ int gs_write(struct tty_struct * tty,
 
 	if (!port) return 0;
 
-	if (! (port->flags & ASYNC_INITIALIZED))
+	if (! (port->port.flags & ASYNC_INITIALIZED))
 		return 0;
 
 	/* get exclusive "write" access to this port (problem 3) */
@@ -141,13 +141,13 @@ int gs_write(struct tty_struct * tty,
 	mutex_unlock(& port->port_write_mutex);
 
 	gs_dprintk (GS_DEBUG_WRITE, "write: interrupts are %s\n", 
-	            (port->flags & GS_TX_INTEN)?"enabled": "disabled"); 
+	            (port->port.flags & GS_TX_INTEN)?"enabled": "disabled"); 
 
 	if (port->xmit_cnt && 
 	    !tty->stopped && 
 	    !tty->hw_stopped &&
-	    !(port->flags & GS_TX_INTEN)) {
-		port->flags |= GS_TX_INTEN;
+	    !(port->port.flags & GS_TX_INTEN)) {
+		port->port.flags |= GS_TX_INTEN;
 		port->rd->enable_tx_interrupts (port);
 	}
 	func_exit ();
@@ -208,7 +208,7 @@ static int gs_wait_tx_flushed (void * ptr, unsigned long timeout)
 	gs_dprintk (GS_DEBUG_FLUSH, "port=%p.\n", port);
 	if (port) {
 		gs_dprintk (GS_DEBUG_FLUSH, "xmit_cnt=%x, xmit_buf=%p, tty=%p.\n", 
-		port->xmit_cnt, port->xmit_buf, port->tty);
+		port->xmit_cnt, port->xmit_buf, port->port.tty);
 	}
 
 	if (!port || port->xmit_cnt < 0 || !port->xmit_buf) {
@@ -217,7 +217,7 @@ static int gs_wait_tx_flushed (void * ptr, unsigned long timeout)
 		return -EINVAL;  /* This is an error which we don't know how to handle. */
 	}
 
-	rcib = gs_real_chars_in_buffer(port->tty);
+	rcib = gs_real_chars_in_buffer(port->port.tty);
 
 	if(rcib <= 0) {
 		gs_dprintk (GS_DEBUG_FLUSH, "nothing to wait for.\n");
@@ -236,7 +236,7 @@ static int gs_wait_tx_flushed (void * ptr, unsigned long timeout)
 
 	/* the expression is actually jiffies < end_jiffies, but that won't
 	   work around the wraparound. Tricky eh? */
-	while ((charsleft = gs_real_chars_in_buffer (port->tty)) &&
+	while ((charsleft = gs_real_chars_in_buffer (port->port.tty)) &&
 	        time_after (end_jiffies, jiffies)) {
 		/* Units check: 
 		   chars * (bits/char) * (jiffies /sec) / (bits/sec) = jiffies!
@@ -309,7 +309,7 @@ void gs_flush_chars(struct tty_struct * tty)
 	}
 
 	/* Beats me -- REW */
-	port->flags |= GS_TX_INTEN;
+	port->port.flags |= GS_TX_INTEN;
 	port->rd->enable_tx_interrupts (port);
 	func_exit ();
 }
@@ -329,8 +329,8 @@ void gs_stop(struct tty_struct * tty)
 
 	if (port->xmit_cnt && 
 	    port->xmit_buf && 
-	    (port->flags & GS_TX_INTEN) ) {
-		port->flags &= ~GS_TX_INTEN;
+	    (port->port.flags & GS_TX_INTEN) ) {
+		port->port.flags &= ~GS_TX_INTEN;
 		port->rd->disable_tx_interrupts (port);
 	}
 	func_exit ();
@@ -349,8 +349,8 @@ void gs_start(struct tty_struct * tty)
 
 	if (port->xmit_cnt && 
 	    port->xmit_buf && 
-	    !(port->flags & GS_TX_INTEN) ) {
-		port->flags |= GS_TX_INTEN;
+	    !(port->port.flags & GS_TX_INTEN) ) {
+		port->port.flags |= GS_TX_INTEN;
 		port->rd->enable_tx_interrupts (port);
 	}
 	func_exit ();
@@ -365,7 +365,7 @@ static void gs_shutdown_port (struct gs_port *port)
 	
 	if (!port) return;
 	
-	if (!(port->flags & ASYNC_INITIALIZED))
+	if (!(port->port.flags & ASYNC_INITIALIZED))
 		return;
 
 	spin_lock_irqsave(&port->driver_lock, flags);
@@ -375,12 +375,12 @@ static void gs_shutdown_port (struct gs_port *port)
 		port->xmit_buf = NULL;
 	}
 
-	if (port->tty)
-		set_bit(TTY_IO_ERROR, &port->tty->flags);
+	if (port->port.tty)
+		set_bit(TTY_IO_ERROR, &port->port.tty->flags);
 
 	port->rd->shutdown_port (port);
 
-	port->flags &= ~ASYNC_INITIALIZED;
+	port->port.flags &= ~ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&port->driver_lock, flags);
 
 	func_exit();
@@ -396,16 +396,16 @@ void gs_hangup(struct tty_struct *tty)
 	if (!tty) return;
 
 	port = tty->driver_data;
-	tty = port->tty;
+	tty = port->port.tty;
 	if (!tty) 
 		return;
 
 	gs_shutdown_port (port);
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE|GS_ACTIVE);
-	port->tty = NULL;
-	port->count = 0;
+	port->port.flags &= ~(ASYNC_NORMAL_ACTIVE|GS_ACTIVE);
+	port->port.tty = NULL;
+	port->port.count = 0;
 
-	wake_up_interruptible(&port->open_wait);
+	wake_up_interruptible(&port->port.open_wait);
 	func_exit ();
 }
 
@@ -424,7 +424,7 @@ int gs_block_til_ready(void *port_, struct file * filp)
 
 	if (!port) return 0;
 
-	tty = port->tty;
+	tty = port->port.tty;
 
 	if (!tty) return 0;
 
@@ -433,9 +433,9 @@ int gs_block_til_ready(void *port_, struct file * filp)
 	 * If the device is in the middle of being closed, then block
 	 * until it's done, and then try again.
 	 */
-	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
-		interruptible_sleep_on(&port->close_wait);
-		if (port->flags & ASYNC_HUP_NOTIFY)
+	if (tty_hung_up_p(filp) || port->port.flags & ASYNC_CLOSING) {
+		interruptible_sleep_on(&port->port.close_wait);
+		if (port->port.flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
 			return -ERESTARTSYS;
@@ -449,7 +449,7 @@ int gs_block_til_ready(void *port_, struct file * filp)
 	 */
 	if ((filp->f_flags & O_NONBLOCK) ||
 	    (tty->flags & (1 << TTY_IO_ERROR))) {
-		port->flags |= ASYNC_NORMAL_ACTIVE;
+		port->port.flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
@@ -461,34 +461,34 @@ int gs_block_til_ready(void *port_, struct file * filp)
 	/*
 	 * Block waiting for the carrier detect and the line to become
 	 * free (i.e., not in use by the callout).  While we are in
-	 * this loop, port->count is dropped by one, so that
+	 * this loop, port->port.count is dropped by one, so that
 	 * rs_close() knows when to free things.  We restore it upon
 	 * exit, either normal or abnormal.
 	 */
 	retval = 0;
 
-	add_wait_queue(&port->open_wait, &wait);
+	add_wait_queue(&port->port.open_wait, &wait);
 
 	gs_dprintk (GS_DEBUG_BTR, "after add waitq.\n"); 
 	spin_lock_irqsave(&port->driver_lock, flags);
 	if (!tty_hung_up_p(filp)) {
-		port->count--;
+		port->port.count--;
 	}
 	spin_unlock_irqrestore(&port->driver_lock, flags);
-	port->blocked_open++;
+	port->port.blocked_open++;
 	while (1) {
 		CD = port->rd->get_CD (port);
 		gs_dprintk (GS_DEBUG_BTR, "CD is now %d.\n", CD);
 		set_current_state (TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp) ||
-		    !(port->flags & ASYNC_INITIALIZED)) {
-			if (port->flags & ASYNC_HUP_NOTIFY)
+		    !(port->port.flags & ASYNC_INITIALIZED)) {
+			if (port->port.flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
 			break;
 		}
-		if (!(port->flags & ASYNC_CLOSING) &&
+		if (!(port->port.flags & ASYNC_CLOSING) &&
 		    (do_clocal || CD))
 			break;
 		gs_dprintk (GS_DEBUG_BTR, "signal_pending is now: %d (%lx)\n", 
@@ -500,17 +500,17 @@ int gs_block_til_ready(void *port_, struct file * filp)
 		schedule();
 	}
 	gs_dprintk (GS_DEBUG_BTR, "Got out of the loop. (%d)\n",
-		    port->blocked_open);
+		    port->port.blocked_open);
 	set_current_state (TASK_RUNNING);
-	remove_wait_queue(&port->open_wait, &wait);
+	remove_wait_queue(&port->port.open_wait, &wait);
 	if (!tty_hung_up_p(filp)) {
-		port->count++;
+		port->port.count++;
 	}
-	port->blocked_open--;
+	port->port.blocked_open--;
 	if (retval)
 		return retval;
 
-	port->flags |= ASYNC_NORMAL_ACTIVE;
+	port->port.flags |= ASYNC_NORMAL_ACTIVE;
 	func_exit ();
 	return 0;
 }			 
@@ -529,10 +529,10 @@ void gs_close(struct tty_struct * tty, struct file * filp)
 
 	if (!port) return;
 
-	if (!port->tty) {
+	if (!port->port.tty) {
 		/* This seems to happen when this is called from vhangup. */
-		gs_dprintk (GS_DEBUG_CLOSE, "gs: Odd: port->tty is NULL\n");
-		port->tty = tty;
+		gs_dprintk (GS_DEBUG_CLOSE, "gs: Odd: port->port.tty is NULL\n");
+		port->port.tty = tty;
 	}
 
 	spin_lock_irqsave(&port->driver_lock, flags);
@@ -545,23 +545,23 @@ void gs_close(struct tty_struct * tty, struct file * filp)
 		return;
 	}
 
-	if ((tty->count == 1) && (port->count != 1)) {
+	if ((tty->count == 1) && (port->port.count != 1)) {
 		printk(KERN_ERR "gs: gs_close port %p: bad port count;"
-		       " tty->count is 1, port count is %d\n", port, port->count);
-		port->count = 1;
+		       " tty->count is 1, port count is %d\n", port, port->port.count);
+		port->port.count = 1;
 	}
-	if (--port->count < 0) {
-		printk(KERN_ERR "gs: gs_close port %p: bad port count: %d\n", port, port->count);
-		port->count = 0;
+	if (--port->port.count < 0) {
+		printk(KERN_ERR "gs: gs_close port %p: bad port count: %d\n", port, port->port.count);
+		port->port.count = 0;
 	}
 
-	if (port->count) {
-		gs_dprintk(GS_DEBUG_CLOSE, "gs_close port %p: count: %d\n", port, port->count);
+	if (port->port.count) {
+		gs_dprintk(GS_DEBUG_CLOSE, "gs_close port %p: count: %d\n", port, port->port.count);
 		spin_unlock_irqrestore(&port->driver_lock, flags);
 		func_exit ();
 		return;
 	}
-	port->flags |= ASYNC_CLOSING;
+	port->port.flags |= ASYNC_CLOSING;
 
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify 
@@ -585,7 +585,7 @@ void gs_close(struct tty_struct * tty, struct file * filp)
 	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
 		gs_wait_tx_flushed (port, port->closing_wait);
 
-	port->flags &= ~GS_ACTIVE;
+	port->port.flags &= ~GS_ACTIVE;
 
 	gs_flush_buffer(tty);
 
@@ -595,18 +595,18 @@ void gs_close(struct tty_struct * tty, struct file * filp)
 	port->event = 0;
 	port->rd->close (port);
 	port->rd->shutdown_port (port);
-	port->tty = NULL;
+	port->port.tty = NULL;
 
-	if (port->blocked_open) {
+	if (port->port.blocked_open) {
 		if (port->close_delay) {
 			spin_unlock_irqrestore(&port->driver_lock, flags);
 			msleep_interruptible(jiffies_to_msecs(port->close_delay));
 			spin_lock_irqsave(&port->driver_lock, flags);
 		}
-		wake_up_interruptible(&port->open_wait);
+		wake_up_interruptible(&port->port.open_wait);
 	}
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING | ASYNC_INITIALIZED);
-	wake_up_interruptible(&port->close_wait);
+	port->port.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING | ASYNC_INITIALIZED);
+	wake_up_interruptible(&port->port.close_wait);
 
 	func_exit ();
 }
@@ -626,10 +626,10 @@ void gs_set_termios (struct tty_struct * tty,
 	port = tty->driver_data;
 
 	if (!port) return;
-	if (!port->tty) {
+	if (!port->port.tty) {
 		/* This seems to happen when this is called after gs_close. */
-		gs_dprintk (GS_DEBUG_TERMIOS, "gs: Odd: port->tty is NULL\n");
-		port->tty = tty;
+		gs_dprintk (GS_DEBUG_TERMIOS, "gs: Odd: port->port.tty is NULL\n");
+		port->port.tty = tty;
 	}
 
 
@@ -651,15 +651,15 @@ void gs_set_termios (struct tty_struct * tty,
 	baudrate = tty_get_baud_rate(tty);
 
 	if ((tiosp->c_cflag & CBAUD) == B38400) {
-		if (     (port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if (     (port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baudrate = 57600;
-		else if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		else if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			baudrate = 115200;
-		else if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		else if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			baudrate = 230400;
-		else if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		else if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			baudrate = 460800;
-		else if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
+		else if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
 			baudrate = (port->baud_base / port->custom_divisor);
 	}
 
@@ -715,7 +715,7 @@ int gs_init_port(struct gs_port *port)
 
 	func_enter ();
 
-	if (port->flags & ASYNC_INITIALIZED) {
+	if (port->port.flags & ASYNC_INITIALIZED) {
 		func_exit ();
 		return 0;
 	}
@@ -737,15 +737,15 @@ int gs_init_port(struct gs_port *port)
 	}
 
 	spin_lock_irqsave (&port->driver_lock, flags);
-	if (port->tty) 
-		clear_bit(TTY_IO_ERROR, &port->tty->flags);
+	if (port->port.tty) 
+		clear_bit(TTY_IO_ERROR, &port->port.tty->flags);
 	mutex_init(&port->port_write_mutex);
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
 	spin_unlock_irqrestore(&port->driver_lock, flags);
-	gs_set_termios(port->tty, NULL);
+	gs_set_termios(port->port.tty, NULL);
 	spin_lock_irqsave (&port->driver_lock, flags);
-	port->flags |= ASYNC_INITIALIZED;
-	port->flags &= ~GS_TX_INTEN;
+	port->port.flags |= ASYNC_INITIALIZED;
+	port->port.flags &= ~GS_TX_INTEN;
 
 	spin_unlock_irqrestore(&port->driver_lock, flags);
 	func_exit ();
@@ -764,11 +764,11 @@ int gs_setserial(struct gs_port *port, struct serial_struct __user *sp)
 		if ((sio.baud_base != port->baud_base) ||
 		    (sio.close_delay != port->close_delay) ||
 		    ((sio.flags & ~ASYNC_USR_MASK) !=
-		     (port->flags & ~ASYNC_USR_MASK)))
+		     (port->port.flags & ~ASYNC_USR_MASK)))
 			return(-EPERM);
 	} 
 
-	port->flags = (port->flags & ~ASYNC_USR_MASK) |
+	port->port.flags = (port->port.flags & ~ASYNC_USR_MASK) |
 		(sio.flags & ASYNC_USR_MASK);
   
 	port->baud_base = sio.baud_base;
@@ -776,7 +776,7 @@ int gs_setserial(struct gs_port *port, struct serial_struct __user *sp)
 	port->closing_wait = sio.closing_wait;
 	port->custom_divisor = sio.custom_divisor;
 
-	gs_set_termios (port->tty, NULL);
+	gs_set_termios (port->port.tty, NULL);
 
 	return 0;
 }
@@ -793,7 +793,7 @@ int gs_getserial(struct gs_port *port, struct serial_struct __user *sp)
 	struct serial_struct    sio;
 
 	memset(&sio, 0, sizeof(struct serial_struct));
-	sio.flags = port->flags;
+	sio.flags = port->port.flags;
 	sio.baud_base = port->baud_base;
 	sio.close_delay = port->close_delay;
 	sio.closing_wait = port->closing_wait;
@@ -821,10 +821,10 @@ void gs_got_break(struct gs_port *port)
 {
 	func_enter ();
 
-	tty_insert_flip_char(port->tty, 0, TTY_BREAK);
-	tty_schedule_flip(port->tty);
-	if (port->flags & ASYNC_SAK) {
-		do_SAK (port->tty);
+	tty_insert_flip_char(port->port.tty, 0, TTY_BREAK);
+	tty_schedule_flip(port->port.tty);
+	if (port->port.flags & ASYNC_SAK) {
+		do_SAK (port->port.tty);
 	}
 
 	func_exit ();
diff --git a/drivers/char/rio/rio_linux.c b/drivers/char/rio/rio_linux.c
index 412777c..6a828c2 100644
--- a/drivers/char/rio/rio_linux.c
+++ b/drivers/char/rio/rio_linux.c
@@ -436,7 +436,7 @@ static void rio_disable_tx_interrupts(void *ptr)
 {
 	func_enter();
 
-	/*  port->gs.flags &= ~GS_TX_INTEN; */
+	/*  port->gs.port.flags &= ~GS_TX_INTEN; */
 
 	func_exit();
 }
@@ -460,7 +460,7 @@ static void rio_enable_tx_interrupts(void *ptr)
 	 * In general we cannot count on "tx empty" interrupts, although
 	 * the interrupt routine seems to be able to tell the difference.
 	 */
-	PortP->gs.flags &= ~GS_TX_INTEN;
+	PortP->gs.port.flags &= ~GS_TX_INTEN;
 
 	func_exit();
 }
@@ -515,7 +515,7 @@ static void rio_shutdown_port(void *ptr)
 	func_enter();
 
 	PortP = (struct Port *) ptr;
-	PortP->gs.tty = NULL;
+	PortP->gs.port.tty = NULL;
 	func_exit();
 }
 
@@ -534,7 +534,7 @@ static void rio_hungup(void *ptr)
 	func_enter();
 
 	PortP = (struct Port *) ptr;
-	PortP->gs.tty = NULL;
+	PortP->gs.port.tty = NULL;
 
 	func_exit();
 }
@@ -554,12 +554,12 @@ static void rio_close(void *ptr)
 
 	riotclose(ptr);
 
-	if (PortP->gs.count) {
-		printk(KERN_ERR "WARNING port count:%d\n", PortP->gs.count);
-		PortP->gs.count = 0;
+	if (PortP->gs.port.count) {
+		printk(KERN_ERR "WARNING port count:%d\n", PortP->gs.port.count);
+		PortP->gs.port.count = 0;
 	}
 
-	PortP->gs.tty = NULL;
+	PortP->gs.port.tty = NULL;
 	func_exit();
 }
 
@@ -854,8 +854,8 @@ static int rio_init_datastructures(void)
 		/*
 		 * Initializing wait queue
 		 */
-		init_waitqueue_head(&port->gs.open_wait);
-		init_waitqueue_head(&port->gs.close_wait);
+		init_waitqueue_head(&port->gs.port.open_wait);
+		init_waitqueue_head(&port->gs.port.close_wait);
 	}
 #else
 	/* We could postpone initializing them to when they are configured. */
diff --git a/drivers/char/rio/riocmd.c b/drivers/char/rio/riocmd.c
index 7b96e08..d940f67 100644
--- a/drivers/char/rio/riocmd.c
+++ b/drivers/char/rio/riocmd.c
@@ -487,12 +487,12 @@ static int RIOCommandRup(struct rio_info *p, uint Rup, struct Host *HostP, struc
 				 ** If the device is a modem, then check the modem
 				 ** carrier.
 				 */
-				if (PortP->gs.tty == NULL)
+				if (PortP->gs.port.tty == NULL)
 					break;
-				if (PortP->gs.tty->termios == NULL)
+				if (PortP->gs.port.tty->termios == NULL)
 					break;
 
-				if (!(PortP->gs.tty->termios->c_cflag & CLOCAL) && ((PortP->State & (RIO_MOPEN | RIO_WOPEN)))) {
+				if (!(PortP->gs.port.tty->termios->c_cflag & CLOCAL) && ((PortP->State & (RIO_MOPEN | RIO_WOPEN)))) {
 
 					rio_dprintk(RIO_DEBUG_CMD, "Is there a Carrier?\n");
 					/*
@@ -509,7 +509,7 @@ static int RIOCommandRup(struct rio_info *p, uint Rup, struct Host *HostP, struc
 							 ** wakeup anyone in WOPEN
 							 */
 							if (PortP->State & (PORT_ISOPEN | RIO_WOPEN))
-								wake_up_interruptible(&PortP->gs.open_wait);
+								wake_up_interruptible(&PortP->gs.port.open_wait);
 						}
 					} else {
 						/*
@@ -517,7 +517,7 @@ static int RIOCommandRup(struct rio_info *p, uint Rup, struct Host *HostP, struc
 						 */
 						if (PortP->State & RIO_CARR_ON) {
 							if (PortP->State & (PORT_ISOPEN | RIO_WOPEN | RIO_MOPEN))
-								tty_hangup(PortP->gs.tty);
+								tty_hangup(PortP->gs.port.tty);
 							PortP->State &= ~RIO_CARR_ON;
 							rio_dprintk(RIO_DEBUG_CMD, "Carrirer just went down\n");
 						}
diff --git a/drivers/char/rio/riointr.c b/drivers/char/rio/riointr.c
index ea21686..e9f9db9 100644
--- a/drivers/char/rio/riointr.c
+++ b/drivers/char/rio/riointr.c
@@ -106,7 +106,7 @@ void RIOTxEnable(char *en)
 
 	PortP = (struct Port *) en;
 	p = (struct rio_info *) PortP->p;
-	tty = PortP->gs.tty;
+	tty = PortP->gs.port.tty;
 
 
 	rio_dprintk(RIO_DEBUG_INTR, "tx port %d: %d chars queued.\n", PortP->PortNum, PortP->gs.xmit_cnt);
@@ -162,7 +162,7 @@ void RIOTxEnable(char *en)
 	rio_spin_unlock_irqrestore(&PortP->portSem, flags);
 
 	if (PortP->gs.xmit_cnt <= (PortP->gs.wakeup_chars + 2 * PKT_MAX_DATA_LEN))
-		tty_wakeup(PortP->gs.tty);
+		tty_wakeup(PortP->gs.port.tty);
 
 }
 
@@ -245,7 +245,7 @@ void RIOServiceHost(struct rio_info *p, struct Host *HostP)
 			 ** find corresponding tty structure. The process of mapping
 			 ** the ports puts these here.
 			 */
-			ttyP = PortP->gs.tty;
+			ttyP = PortP->gs.port.tty;
 
 			/*
 			 ** Lock the port before we begin working on it.
@@ -339,7 +339,7 @@ void RIOServiceHost(struct rio_info *p, struct Host *HostP)
 			 ** find corresponding tty structure. The process of mapping
 			 ** the ports puts these here.
 			 */
-			ttyP = PortP->gs.tty;
+			ttyP = PortP->gs.port.tty;
 			/* If ttyP is NULL, the port is getting closed. Forget about it. */
 			if (!ttyP) {
 				rio_dprintk(RIO_DEBUG_INTR, "no tty, so skipping.\n");
@@ -546,7 +546,7 @@ static void RIOReceive(struct rio_info *p, struct Port *PortP)
 
 	intCount++;
 
-	TtyP = PortP->gs.tty;
+	TtyP = PortP->gs.port.tty;
 	if (!TtyP) {
 		rio_dprintk(RIO_DEBUG_INTR, "RIOReceive: tty is null. \n");
 		return;
diff --git a/drivers/char/rio/rioparam.c b/drivers/char/rio/rioparam.c
index 4810b84..908f764 100644
--- a/drivers/char/rio/rioparam.c
+++ b/drivers/char/rio/rioparam.c
@@ -164,7 +164,7 @@ int RIOParam(struct Port *PortP, int cmd, int Modem, int SleepFlag)
 
 	func_enter();
 
-	TtyP = PortP->gs.tty;
+	TtyP = PortP->gs.port.tty;
 
 	rio_dprintk(RIO_DEBUG_PARAM, "RIOParam: Port:%d cmd:%d Modem:%d SleepFlag:%d Mapped: %d, tty=%p\n", PortP->PortNum, cmd, Modem, SleepFlag, PortP->Mapped, TtyP);
 
diff --git a/drivers/char/rio/riotty.c b/drivers/char/rio/riotty.c
index c993548..76c7f4f 100644
--- a/drivers/char/rio/riotty.c
+++ b/drivers/char/rio/riotty.c
@@ -144,14 +144,14 @@ int riotopen(struct tty_struct *tty, struct file *filp)
 
 	tty->driver_data = PortP;
 
-	PortP->gs.tty = tty;
-	PortP->gs.count++;
+	PortP->gs.port.tty = tty;
+	PortP->gs.port.count++;
 
 	rio_dprintk(RIO_DEBUG_TTY, "%d bytes in tx buffer\n", PortP->gs.xmit_cnt);
 
 	retval = gs_init_port(&PortP->gs);
 	if (retval) {
-		PortP->gs.count--;
+		PortP->gs.port.count--;
 		return -ENXIO;
 	}
 	/*
@@ -297,7 +297,7 @@ int riotopen(struct tty_struct *tty, struct file *filp)
 	 ** insert test for carrier here. -- ???
 	 ** I already see that test here. What's the deal? -- REW
 	 */
-	if ((PortP->gs.tty->termios->c_cflag & CLOCAL) ||
+	if ((PortP->gs.port.tty->termios->c_cflag & CLOCAL) ||
 			(PortP->ModemState & RIOC_MSVR1_CD)) {
 		rio_dprintk(RIO_DEBUG_TTY, "open(%d) Modem carr on\n", SysPort);
 		/*
@@ -305,16 +305,16 @@ int riotopen(struct tty_struct *tty, struct file *filp)
 		   wakeup((caddr_t) &tp->tm.c_canq);
 		 */
 		PortP->State |= RIO_CARR_ON;
-		wake_up_interruptible(&PortP->gs.open_wait);
+		wake_up_interruptible(&PortP->gs.port.open_wait);
 	} else {	/* no carrier - wait for DCD */
 			/*
-		   while (!(PortP->gs.tty->termios->c_state & CARR_ON) &&
+		   while (!(PortP->gs.port.tty->termios->c_state & CARR_ON) &&
 		   !(filp->f_flags & O_NONBLOCK) && !p->RIOHalted )
 		 */
 		while (!(PortP->State & RIO_CARR_ON) && !(filp->f_flags & O_NONBLOCK) && !p->RIOHalted) {
 				rio_dprintk(RIO_DEBUG_TTY, "open(%d) sleeping for carr on\n", SysPort);
 			/*
-			   PortP->gs.tty->termios->c_state |= WOPEN;
+			   PortP->gs.port.tty->termios->c_state |= WOPEN;
 			 */
 			PortP->State |= RIO_WOPEN;
 			rio_spin_unlock_irqrestore(&PortP->portSem, flags);
@@ -384,7 +384,7 @@ int riotclose(void *ptr)
 	/* PortP = p->RIOPortp[SysPort]; */
 	rio_dprintk(RIO_DEBUG_TTY, "Port is at address %p\n", PortP);
 	/* tp = PortP->TtyP; *//* Get tty */
-	tty = PortP->gs.tty;
+	tty = PortP->gs.port.tty;
 	rio_dprintk(RIO_DEBUG_TTY, "TTY is at address %p\n", tty);
 
 	if (PortP->gs.closing_wait)
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index b1a7a8c..b1239ee 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1,4 +1,3 @@
-
 /* sx.c -- driver for the Specialix SX series cards. 
  *
  *  This driver will also support the older SI, and XIO cards.
@@ -930,7 +929,7 @@ static int sx_set_real_termios(void *ptr)
 
 	func_enter2();
 
-	if (!port->gs.tty)
+	if (!port->gs.port.tty)
 		return 0;
 
 	/* What is this doing here? -- REW
@@ -941,19 +940,19 @@ static int sx_set_real_termios(void *ptr)
 
 	sx_set_baud(port);
 
-#define CFLAG port->gs.tty->termios->c_cflag
+#define CFLAG port->gs.port.tty->termios->c_cflag
 	sx_write_channel_byte(port, hi_mr1,
-			(C_PARENB(port->gs.tty) ? MR1_WITH : MR1_NONE) |
-			(C_PARODD(port->gs.tty) ? MR1_ODD : MR1_EVEN) |
-			(C_CRTSCTS(port->gs.tty) ? MR1_RTS_RXFLOW : 0) |
+			(C_PARENB(port->gs.port.tty) ? MR1_WITH : MR1_NONE) |
+			(C_PARODD(port->gs.port.tty) ? MR1_ODD : MR1_EVEN) |
+			(C_CRTSCTS(port->gs.port.tty) ? MR1_RTS_RXFLOW : 0) |
 			(((CFLAG & CSIZE) == CS8) ? MR1_8_BITS : 0) |
 			(((CFLAG & CSIZE) == CS7) ? MR1_7_BITS : 0) |
 			(((CFLAG & CSIZE) == CS6) ? MR1_6_BITS : 0) |
 			(((CFLAG & CSIZE) == CS5) ? MR1_5_BITS : 0));
 
 	sx_write_channel_byte(port, hi_mr2,
-			(C_CRTSCTS(port->gs.tty) ? MR2_CTS_TXFLOW : 0) |
-			(C_CSTOPB(port->gs.tty) ? MR2_2_STOP :
+			(C_CRTSCTS(port->gs.port.tty) ? MR2_CTS_TXFLOW : 0) |
+			(C_CSTOPB(port->gs.port.tty) ? MR2_2_STOP :
 			MR2_1_STOP));
 
 	switch (CFLAG & CSIZE) {
@@ -976,44 +975,44 @@ static int sx_set_real_termios(void *ptr)
 	}
 
 	sx_write_channel_byte(port, hi_prtcl,
-			(I_IXON(port->gs.tty) ? SP_TXEN : 0) |
-			(I_IXOFF(port->gs.tty) ? SP_RXEN : 0) |
-			(I_IXANY(port->gs.tty) ? SP_TANY : 0) | SP_DCEN);
+			(I_IXON(port->gs.port.tty) ? SP_TXEN : 0) |
+			(I_IXOFF(port->gs.port.tty) ? SP_RXEN : 0) |
+			(I_IXANY(port->gs.port.tty) ? SP_TANY : 0) | SP_DCEN);
 
 	sx_write_channel_byte(port, hi_break,
-			(I_IGNBRK(port->gs.tty) ? BR_IGN : 0 |
-			I_BRKINT(port->gs.tty) ? BR_INT : 0));
+			(I_IGNBRK(port->gs.port.tty) ? BR_IGN : 0 |
+			I_BRKINT(port->gs.port.tty) ? BR_INT : 0));
 
-	sx_write_channel_byte(port, hi_txon, START_CHAR(port->gs.tty));
-	sx_write_channel_byte(port, hi_rxon, START_CHAR(port->gs.tty));
-	sx_write_channel_byte(port, hi_txoff, STOP_CHAR(port->gs.tty));
-	sx_write_channel_byte(port, hi_rxoff, STOP_CHAR(port->gs.tty));
+	sx_write_channel_byte(port, hi_txon, START_CHAR(port->gs.port.tty));
+	sx_write_channel_byte(port, hi_rxon, START_CHAR(port->gs.port.tty));
+	sx_write_channel_byte(port, hi_txoff, STOP_CHAR(port->gs.port.tty));
+	sx_write_channel_byte(port, hi_rxoff, STOP_CHAR(port->gs.port.tty));
 
 	sx_reconfigure_port(port);
 
 	/* Tell line discipline whether we will do input cooking */
-	if (I_OTHER(port->gs.tty)) {
-		clear_bit(TTY_HW_COOK_IN, &port->gs.tty->flags);
+	if (I_OTHER(port->gs.port.tty)) {
+		clear_bit(TTY_HW_COOK_IN, &port->gs.port.tty->flags);
 	} else {
-		set_bit(TTY_HW_COOK_IN, &port->gs.tty->flags);
+		set_bit(TTY_HW_COOK_IN, &port->gs.port.tty->flags);
 	}
 	sx_dprintk(SX_DEBUG_TERMIOS, "iflags: %x(%d) ",
-			(unsigned int)port->gs.tty->termios->c_iflag,
-			I_OTHER(port->gs.tty));
+			(unsigned int)port->gs.port.tty->termios->c_iflag,
+			I_OTHER(port->gs.port.tty));
 
 /* Tell line discipline whether we will do output cooking.
  * If OPOST is set and no other output flags are set then we can do output
  * processing.  Even if only *one* other flag in the O_OTHER group is set
  * we do cooking in software.
  */
-	if (O_OPOST(port->gs.tty) && !O_OTHER(port->gs.tty)) {
-		set_bit(TTY_HW_COOK_OUT, &port->gs.tty->flags);
+	if (O_OPOST(port->gs.port.tty) && !O_OTHER(port->gs.port.tty)) {
+		set_bit(TTY_HW_COOK_OUT, &port->gs.port.tty->flags);
 	} else {
-		clear_bit(TTY_HW_COOK_OUT, &port->gs.tty->flags);
+		clear_bit(TTY_HW_COOK_OUT, &port->gs.port.tty->flags);
 	}
 	sx_dprintk(SX_DEBUG_TERMIOS, "oflags: %x(%d)\n",
-			(unsigned int)port->gs.tty->termios->c_oflag,
-			O_OTHER(port->gs.tty));
+			(unsigned int)port->gs.port.tty->termios->c_oflag,
+			O_OTHER(port->gs.port.tty));
 	/* port->c_dcd = sx_get_CD (port); */
 	func_exit();
 	return 0;
@@ -1102,8 +1101,8 @@ static void sx_transmit_chars(struct sx_port *port)
 		sx_disable_tx_interrupts(port);
 	}
 
-	if ((port->gs.xmit_cnt <= port->gs.wakeup_chars) && port->gs.tty) {
-		tty_wakeup(port->gs.tty);
+	if ((port->gs.xmit_cnt <= port->gs.wakeup_chars) && port->gs.port.tty) {
+		tty_wakeup(port->gs.port.tty);
 		sx_dprintk(SX_DEBUG_TRANSMIT, "Waking up.... ldisc (%d)....\n",
 				port->gs.wakeup_chars);
 	}
@@ -1126,7 +1125,7 @@ static inline void sx_receive_chars(struct sx_port *port)
 	unsigned char *rp;
 
 	func_enter2();
-	tty = port->gs.tty;
+	tty = port->gs.port.tty;
 	while (1) {
 		rx_op = sx_read_channel_byte(port, hi_rxopos);
 		c = (sx_read_channel_byte(port, hi_rxipos) - rx_op) & 0xff;
@@ -1211,12 +1210,12 @@ static inline void sx_check_modem_signals(struct sx_port *port)
 				/* DCD went UP */
 				if ((sx_read_channel_byte(port, hi_hstat) !=
 						HS_IDLE_CLOSED) &&
-						!(port->gs.tty->termios->
+						!(port->gs.port.tty->termios->
 							c_cflag & CLOCAL)) {
 					/* Are we blocking in open? */
 					sx_dprintk(SX_DEBUG_MODEMSIGNALS, "DCD "
 						"active, unblocking open\n");
-					wake_up_interruptible(&port->gs.
+					wake_up_interruptible(&port->gs.port.
 							open_wait);
 				} else {
 					sx_dprintk(SX_DEBUG_MODEMSIGNALS, "DCD "
@@ -1224,10 +1223,10 @@ static inline void sx_check_modem_signals(struct sx_port *port)
 				}
 			} else {
 				/* DCD went down! */
-				if (!(port->gs.tty->termios->c_cflag & CLOCAL)){
+				if (!(port->gs.port.tty->termios->c_cflag & CLOCAL)){
 					sx_dprintk(SX_DEBUG_MODEMSIGNALS, "DCD "
 						"dropped. hanging up....\n");
-					tty_hangup(port->gs.tty);
+					tty_hangup(port->gs.port.tty);
 				} else {
 					sx_dprintk(SX_DEBUG_MODEMSIGNALS, "DCD "
 						"dropped. ignoring.\n");
@@ -1325,7 +1324,7 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 
 	for (i = 0; i < board->nports; i++) {
 		port = &board->ports[i];
-		if (port->gs.flags & GS_ACTIVE) {
+		if (port->gs.port.flags & GS_ACTIVE) {
 			if (sx_read_channel_byte(port, hi_state)) {
 				sx_dprintk(SX_DEBUG_INTERRUPTS, "Port %d: "
 						"modem signal change?... \n",i);
@@ -1334,7 +1333,7 @@ static irqreturn_t sx_interrupt(int irq, void *ptr)
 			if (port->gs.xmit_cnt) {
 				sx_transmit_chars(port);
 			}
-			if (!(port->gs.flags & SX_RX_THROTTLE)) {
+			if (!(port->gs.port.flags & SX_RX_THROTTLE)) {
 				sx_receive_chars(port);
 			}
 		}
@@ -1373,7 +1372,7 @@ static void sx_disable_tx_interrupts(void *ptr)
 	struct sx_port *port = ptr;
 	func_enter2();
 
-	port->gs.flags &= ~GS_TX_INTEN;
+	port->gs.port.flags &= ~GS_TX_INTEN;
 
 	func_exit();
 }
@@ -1394,7 +1393,7 @@ static void sx_enable_tx_interrupts(void *ptr)
 
 	/* XXX Must be "HIGH_WATER" for SI card according to doc. */
 	if (data_in_buffer < LOW_WATER)
-		port->gs.flags &= ~GS_TX_INTEN;
+		port->gs.port.flags &= ~GS_TX_INTEN;
 
 	func_exit();
 }
@@ -1442,8 +1441,8 @@ static void sx_shutdown_port(void *ptr)
 
 	func_enter();
 
-	port->gs.flags &= ~GS_ACTIVE;
-	if (port->gs.tty && (port->gs.tty->termios->c_cflag & HUPCL)) {
+	port->gs.port.flags &= ~GS_ACTIVE;
+	if (port->gs.port.tty && (port->gs.port.tty->termios->c_cflag & HUPCL)) {
 		sx_setsignals(port, 0, 0);
 		sx_reconfigure_port(port);
 	}
@@ -1485,8 +1484,8 @@ static int sx_open(struct tty_struct *tty, struct file *filp)
 	spin_lock_irqsave(&port->gs.driver_lock, flags);
 
 	tty->driver_data = port;
-	port->gs.tty = tty;
-	port->gs.count++;
+	port->gs.port.tty = tty;
+	port->gs.port.count++;
 	spin_unlock_irqrestore(&port->gs.driver_lock, flags);
 
 	sx_dprintk(SX_DEBUG_OPEN, "starting port\n");
@@ -1497,12 +1496,12 @@ static int sx_open(struct tty_struct *tty, struct file *filp)
 	retval = gs_init_port(&port->gs);
 	sx_dprintk(SX_DEBUG_OPEN, "done gs_init\n");
 	if (retval) {
-		port->gs.count--;
+		port->gs.port.count--;
 		return retval;
 	}
 
-	port->gs.flags |= GS_ACTIVE;
-	if (port->gs.count <= 1)
+	port->gs.port.flags |= GS_ACTIVE;
+	if (port->gs.port.count <= 1)
 		sx_setsignals(port, 1, 1);
 
 #if 0
@@ -1513,12 +1512,12 @@ static int sx_open(struct tty_struct *tty, struct file *filp)
 		my_hd_io(port->board->base + port->ch_base, sizeof(*port));
 #endif
 
-	if (port->gs.count <= 1) {
+	if (port->gs.port.count <= 1) {
 		if (sx_send_command(port, HS_LOPEN, -1, HS_IDLE_OPEN) != 1) {
 			printk(KERN_ERR "sx: Card didn't respond to LOPEN "
 					"command.\n");
 			spin_lock_irqsave(&port->gs.driver_lock, flags);
-			port->gs.count--;
+			port->gs.port.count--;
 			spin_unlock_irqrestore(&port->gs.driver_lock, flags);
 			return -EIO;
 		}
@@ -1526,11 +1525,11 @@ static int sx_open(struct tty_struct *tty, struct file *filp)
 
 	retval = gs_block_til_ready(port, filp);
 	sx_dprintk(SX_DEBUG_OPEN, "Block til ready returned %d. Count=%d\n",
-			retval, port->gs.count);
+			retval, port->gs.port.count);
 
 	if (retval) {
 /*
- * Don't lower gs.count here because sx_close() will be called later
+ * Don't lower gs.port.count here because sx_close() will be called later
  */
 
 		return retval;
@@ -1571,14 +1570,14 @@ static void sx_close(void *ptr)
 	}
 
 	sx_dprintk(SX_DEBUG_CLOSE, "waited %d jiffies for close. count=%d\n",
-			5 * HZ - to - 1, port->gs.count);
+			5 * HZ - to - 1, port->gs.port.count);
 
-	if (port->gs.count) {
+	if (port->gs.port.count) {
 		sx_dprintk(SX_DEBUG_CLOSE, "WARNING port count:%d\n",
-				port->gs.count);
+				port->gs.port.count);
 		/*printk("%s SETTING port count to zero: %p count: %d\n",
-				__func__, port, port->gs.count);
-		port->gs.count = 0;*/
+				__func__, port, port->gs.port.count);
+		port->gs.port.count = 0;*/
 	}
 
 	func_exit();
@@ -1939,7 +1938,7 @@ static void sx_throttle(struct tty_struct *tty)
 	 * control then throttle the port.
 	 */
 	if ((tty->termios->c_cflag & CRTSCTS) || (I_IXOFF(tty))) {
-		port->gs.flags |= SX_RX_THROTTLE;
+		port->gs.port.flags |= SX_RX_THROTTLE;
 	}
 	func_exit();
 }
@@ -1953,7 +1952,7 @@ static void sx_unthrottle(struct tty_struct *tty)
 	 * this port in case we disabled flow control while the port
 	 * was throttled
 	 */
-	port->gs.flags &= ~SX_RX_THROTTLE;
+	port->gs.port.flags &= ~SX_RX_THROTTLE;
 	func_exit();
 	return;
 }
@@ -2408,9 +2407,7 @@ static int sx_init_portstructs(int nboards, int nports)
 			/*
 			 * Initializing wait queue
 			 */
-			init_waitqueue_head(&port->gs.open_wait);
-			init_waitqueue_head(&port->gs.close_wait);
-
+			tty_port_init(&port->gs.port);
 			port++;
 		}
 	}
diff --git a/include/linux/generic_serial.h b/include/linux/generic_serial.h
index 1108336..4cc9139 100644
--- a/include/linux/generic_serial.h
+++ b/include/linux/generic_serial.h
@@ -14,6 +14,7 @@
 
 #ifdef __KERNEL__
 #include <linux/mutex.h>
+#include <linux/tty.h>
 
 struct real_driver {
   void                    (*disable_tx_interrupts) (void *);
@@ -33,17 +34,12 @@ struct real_driver {
 
 struct gs_port {
   int                     magic;
+  struct tty_port	  port;
   unsigned char           *xmit_buf; 
   int                     xmit_head;
   int                     xmit_tail;
   int                     xmit_cnt;
   struct mutex            port_write_mutex;
-  int                     flags;
-  wait_queue_head_t       open_wait;
-  wait_queue_head_t       close_wait;
-  int                     count;
-  int                     blocked_open;
-  struct tty_struct       *tty;
   unsigned long           event;
   unsigned short          closing_wait;
   int                     close_delay;

