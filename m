Return-Path: <linux-kernel-owner+w=401wt.eu-S1762320AbXGCVrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762320AbXGCVrU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 17:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760502AbXGCVrD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 17:47:03 -0400
Received: from 195134058148.customer.alfanett.no ([195.134.58.148]:37755 "EHLO
	barebone.sourcepoet.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758196AbXGCVq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 17:46:59 -0400
X-Greylist: delayed 779 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Jul 2007 17:46:58 EDT
Message-ID: <468AC156.5040402@sourcepoet.org>
Date: Tue, 03 Jul 2007 23:36:22 +0200
From: Morten Helgesen <morten@sourcepoet.org>
User-Agent: Thunderbird 1.5.0.8 (X11/20061025)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH] genericserial: Remove bogus optimisation check and dead
 code paths
References: <20070703152021.6eb8013d@the-village.bc.nu>	<468A5F89.70900@sourcepoet.org> <20070703162655.6a001fdc@the-village.bc.nu>
In-Reply-To: <20070703162655.6a001fdc@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------040508020409010403020306"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040508020409010403020306
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Alan Cox wrote:
> On Tue, 03 Jul 2007 16:39:05 +0200
> Morten Helgesen <morten@sourcepoet.org> wrote:
>
>   
>> Alan Cox wrote:
>>
>> [...snip...]
>>     
>>> @@ -75,11 +64,11 @@
>>>  	if (! (port->flags & ASYNC_INITIALIZED)) return;
>>>  
>>>  	/* Take a lock on the serial tranmit buffer! */
>>> -	LOCKIT;
>>> +	mutex_lock(& port->port_write_mutex);
>>>   
>>>       
>> ^ Contains additional whitespace.
>>     
>
>
> Its an old driver, it doesn't follow the coding style too well at all -
> viz stuff like if (! ( the line above. Given its age and limited userbase
> I don't plan to go and make it conform either, but I will take patches
> for the formatting (and the spelling errors it is full of) from someone
> who wants to do the work.
>
> Alan
It's late.

Signed-off-by: Morten Helgesen <morten@sourcepoet.org>

== Morten

--------------040508020409010403020306
Content-Type: text/plain;
 name="generic_serial.c-cleanup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="generic_serial.c-cleanup.patch"

--- linux-2.6.22-rc6-mm1-ac-patched/drivers/char/generic_serial.c.orig	2007-07-03 20:55:46.000000000 +0200
+++ linux-2.6.22-rc6-mm1-ac-patched/drivers/char/generic_serial.c	2007-07-03 22:44:25.000000000 +0200
@@ -31,14 +31,14 @@
 #include <asm/semaphore.h>
 #include <asm/uaccess.h>
 
-#define DEBUG 
+#define DEBUG
 
 static int gs_debug;
 
 #ifdef DEBUG
 #define gs_dprintk(f, str...) if (gs_debug & f) printk (str)
 #else
-#define gs_dprintk(f, str...) /* nothing */
+#define gs_dprintk(f, str...)	/* nothing */
 #endif
 
 #define func_enter() gs_dprintk (GS_DEBUG_FLOW, "gs: enter %s\n", __FUNCTION__)
@@ -48,23 +48,25 @@
 
 module_param(gs_debug, int, 0644);
 
-
-void gs_put_char(struct tty_struct * tty, unsigned char ch)
+void gs_put_char(struct tty_struct *tty, unsigned char ch)
 {
 	struct gs_port *port;
 
-	func_enter (); 
+	func_enter();
 
-	if (!tty) return;
+	if (!tty)
+		return;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port)
+		return;
 
-	if (! (port->flags & ASYNC_INITIALIZED)) return;
+	if (!(port->flags & ASYNC_INITIALIZED))
+		return;
 
-	/* Take a lock on the serial tranmit buffer! */
-	mutex_lock(& port->port_write_mutex);
+	/* Take a lock on the serial transmit buffer! */
+	mutex_lock(&port->port_write_mutex);
 
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		/* Sorry, buffer is full, drop character. Update statistics???? -- REW */
@@ -74,129 +76,129 @@
 
 	port->xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= SERIAL_XMIT_SIZE - 1;
-	port->xmit_cnt++;  /* Characters in buffer */
+	port->xmit_cnt++;	/* Characters in buffer */
 
 	mutex_unlock(&port->port_write_mutex);
-	func_exit ();
+	func_exit();
 }
 
-
 /*
 > Problems to take into account are:
 >       -1- Interrupts that empty part of the buffer.
->       -2- page faults on the access to userspace. 
+>       -2- Page faults on access to userspace. 
 >       -3- Other processes that are also trying to do a "write". 
 */
 
-int gs_write(struct tty_struct * tty, 
-                    const unsigned char *buf, int count)
+int gs_write(struct tty_struct *tty, const unsigned char *buf, int count)
 {
 	struct gs_port *port;
 	int c, total = 0;
 	int t;
 
-	func_enter ();
+	func_enter();
 
-	if (!tty) return 0;
+	if (!tty)
+		return 0;
 
 	port = tty->driver_data;
 
-	if (!port) return 0;
+	if (!port)
+		return 0;
 
-	if (! (port->flags & ASYNC_INITIALIZED))
+	if (!(port->flags & ASYNC_INITIALIZED))
 		return 0;
 
-	/* get exclusive "write" access to this port (problem 3) */
+	/* Get exclusive "write" access to this port (problem 3) */
 	/* This is not a spinlock because we can have a disk access (page 
-		 fault) in copy_from_user */
-	mutex_lock(& port->port_write_mutex);
+	   fault) in copy_from_user */
+	mutex_lock(&port->port_write_mutex);
 
 	while (1) {
 
 		c = count;
- 
-		/* This is safe because we "OWN" the "head". Noone else can 
+
+		/* This is safe because we "own" the "head". No one else can 
 		   change the "head": we own the port_write_mutex. */
 		/* Don't overrun the end of the buffer */
 		t = SERIAL_XMIT_SIZE - port->xmit_head;
-		if (t < c) c = t;
- 
-		/* This is safe because the xmit_cnt can only decrease. This 
-		   would increase "t", so we might copy too little chars. */
+		if (t < c)
+			c = t;
+
+		/* This is safe because xmit_cnt can only decrease. This 
+		   would increase "t", so we might copy too few chars. */
 		/* Don't copy past the "head" of the buffer */
 		t = SERIAL_XMIT_SIZE - 1 - port->xmit_cnt;
-		if (t < c) c = t;
- 
-		/* Can't copy more? break out! */
-		if (c <= 0) break;
+		if (t < c)
+			c = t;
+
+		/* Can't copy more? Break out! */
+		if (c <= 0)
+			break;
 
-		memcpy (port->xmit_buf + port->xmit_head, buf, c);
+		memcpy(port->xmit_buf + port->xmit_head, buf, c);
 
-		port -> xmit_cnt += c;
-		port -> xmit_head = (port->xmit_head + c) & (SERIAL_XMIT_SIZE -1);
+		port->xmit_cnt += c;
+		port->xmit_head =
+		    (port->xmit_head + c) & (SERIAL_XMIT_SIZE - 1);
 		buf += c;
 		count -= c;
 		total += c;
 	}
-	mutex_unlock(& port->port_write_mutex);
+	mutex_unlock(&port->port_write_mutex);
 
-	gs_dprintk (GS_DEBUG_WRITE, "write: interrupts are %s\n", 
-	            (port->flags & GS_TX_INTEN)?"enabled": "disabled"); 
+	gs_dprintk(GS_DEBUG_WRITE, "write: interrupts are %s\n",
+		   (port->flags & GS_TX_INTEN) ? "enabled" : "disabled");
 
-	if (port->xmit_cnt && 
-	    !tty->stopped && 
-	    !tty->hw_stopped &&
-	    !(port->flags & GS_TX_INTEN)) {
+	if (port->xmit_cnt &&
+	    !tty->stopped && !tty->hw_stopped && !(port->flags & GS_TX_INTEN)) {
 		port->flags |= GS_TX_INTEN;
-		port->rd->enable_tx_interrupts (port);
+		port->rd->enable_tx_interrupts(port);
 	}
-	func_exit ();
+	func_exit();
 	return total;
 }
 
-
-
-int gs_write_room(struct tty_struct * tty)
+int gs_write_room(struct tty_struct *tty)
 {
 	struct gs_port *port = tty->driver_data;
 	int ret;
 
-	func_enter ();
+	func_enter();
 	ret = SERIAL_XMIT_SIZE - port->xmit_cnt - 1;
 	if (ret < 0)
 		ret = 0;
-	func_exit ();
+	func_exit();
 	return ret;
 }
 
-
 int gs_chars_in_buffer(struct tty_struct *tty)
 {
 	struct gs_port *port = tty->driver_data;
-	func_enter ();
+	func_enter();
 
-	func_exit ();
+	func_exit();
 	return port->xmit_cnt;
 }
 
-
 static int gs_real_chars_in_buffer(struct tty_struct *tty)
 {
 	struct gs_port *port;
-	func_enter ();
+	func_enter();
 
-	if (!tty) return 0;
+	if (!tty)
+		return 0;
 	port = tty->driver_data;
 
-	if (!port->rd) return 0;
-	if (!port->rd->chars_in_buffer) return 0;
+	if (!port->rd)
+		return 0;
+	if (!port->rd->chars_in_buffer)
+		return 0;
 
-	func_exit ();
-	return port->xmit_cnt + port->rd->chars_in_buffer (port);
+	func_exit();
+	return port->xmit_cnt + port->rd->chars_in_buffer(port);
 }
 
-
-static int gs_wait_tx_flushed (void * ptr, unsigned long timeout) 
+static int gs_wait_tx_flushed(void *ptr, unsigned long timeout)
 {
 	struct gs_port *port = ptr;
 	unsigned long end_jiffies;
@@ -205,180 +207,186 @@
 
 	func_enter();
 
-	gs_dprintk (GS_DEBUG_FLUSH, "port=%p.\n", port);
+	gs_dprintk(GS_DEBUG_FLUSH, "port=%p.\n", port);
 	if (port) {
-		gs_dprintk (GS_DEBUG_FLUSH, "xmit_cnt=%x, xmit_buf=%p, tty=%p.\n", 
-		port->xmit_cnt, port->xmit_buf, port->tty);
+		gs_dprintk(GS_DEBUG_FLUSH,
+			   "xmit_cnt=%x, xmit_buf=%p, tty=%p.\n",
+			   port->xmit_cnt, port->xmit_buf, port->tty);
 	}
 
 	if (!port || port->xmit_cnt < 0 || !port->xmit_buf) {
-		gs_dprintk (GS_DEBUG_FLUSH, "ERROR: !port, !port->xmit_buf or prot->xmit_cnt < 0.\n");
+		gs_dprintk(GS_DEBUG_FLUSH,
+			   "ERROR: !port, !port->xmit_buf or prot->xmit_cnt < 0.\n");
 		func_exit();
-		return -EINVAL;  /* This is an error which we don't know how to handle. */
+		return -EINVAL;	/* This is an error which we don't know how to handle. */
 	}
 
 	rcib = gs_real_chars_in_buffer(port->tty);
 
-	if(rcib <= 0) {
-		gs_dprintk (GS_DEBUG_FLUSH, "nothing to wait for.\n");
+	if (rcib <= 0) {
+		gs_dprintk(GS_DEBUG_FLUSH, "nothing to wait for.\n");
 		func_exit();
 		return rv;
 	}
-	/* stop trying: now + twice the time it would normally take +  seconds */
-	if (timeout == 0) timeout = MAX_SCHEDULE_TIMEOUT;
-	end_jiffies  = jiffies; 
-	if (timeout !=  MAX_SCHEDULE_TIMEOUT)
-		end_jiffies += port->baud?(2 * rcib * 10 * HZ / port->baud):0;
+	/* Stop trying: now + twice the time it would normally take +  seconds */
+	if (timeout == 0)
+		timeout = MAX_SCHEDULE_TIMEOUT;
+	end_jiffies = jiffies;
+	if (timeout != MAX_SCHEDULE_TIMEOUT)
+		end_jiffies +=
+		    port->baud ? (2 * rcib * 10 * HZ / port->baud) : 0;
 	end_jiffies += timeout;
 
-	gs_dprintk (GS_DEBUG_FLUSH, "now=%lx, end=%lx (%ld).\n", 
-		    jiffies, end_jiffies, end_jiffies-jiffies); 
+	gs_dprintk(GS_DEBUG_FLUSH, "now=%lx, end=%lx (%ld).\n",
+		   jiffies, end_jiffies, end_jiffies - jiffies);
 
-	/* the expression is actually jiffies < end_jiffies, but that won't
+	/* The expression is actually jiffies < end_jiffies, but that won't
 	   work around the wraparound. Tricky eh? */
-	while ((charsleft = gs_real_chars_in_buffer (port->tty)) &&
-	        time_after (end_jiffies, jiffies)) {
+	while ((charsleft = gs_real_chars_in_buffer(port->tty)) &&
+	       time_after(end_jiffies, jiffies)) {
 		/* Units check: 
 		   chars * (bits/char) * (jiffies /sec) / (bits/sec) = jiffies!
 		   check! */
 
-		charsleft += 16; /* Allow 16 chars more to be transmitted ... */
-		jiffies_to_transmit = port->baud?(1 + charsleft * 10 * HZ / port->baud):0;
+		charsleft += 16;	/* Allow 16 more chars to be transmitted ... */
+		jiffies_to_transmit =
+		    port->baud ? (1 + charsleft * 10 * HZ / port->baud) : 0;
 		/*                                ^^^ Round up.... */
-		if (jiffies_to_transmit <= 0) jiffies_to_transmit = 1;
+		if (jiffies_to_transmit <= 0)
+			jiffies_to_transmit = 1;
 
-		gs_dprintk (GS_DEBUG_FLUSH, "Expect to finish in %d jiffies "
-			    "(%d chars).\n", jiffies_to_transmit, charsleft); 
+		gs_dprintk(GS_DEBUG_FLUSH, "Expect to finish in %d jiffies "
+			   "(%d chars).\n", jiffies_to_transmit, charsleft);
 
 		msleep_interruptible(jiffies_to_msecs(jiffies_to_transmit));
-		if (signal_pending (current)) {
-			gs_dprintk (GS_DEBUG_FLUSH, "Signal pending. Bombing out: "); 
+		if (signal_pending(current)) {
+			gs_dprintk(GS_DEBUG_FLUSH,
+				   "Signal pending. Bombing out: ");
 			rv = -EINTR;
 			break;
 		}
 	}
 
-	gs_dprintk (GS_DEBUG_FLUSH, "charsleft = %d.\n", charsleft); 
-	set_current_state (TASK_RUNNING);
+	gs_dprintk(GS_DEBUG_FLUSH, "charsleft = %d.\n", charsleft);
+	set_current_state(TASK_RUNNING);
 
 	func_exit();
 	return rv;
 }
 
-
-
 void gs_flush_buffer(struct tty_struct *tty)
 {
 	struct gs_port *port;
 	unsigned long flags;
 
-	func_enter ();
+	func_enter();
 
-	if (!tty) return;
+	if (!tty)
+		return;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port)
+		return;
 
 	/* XXX Would the write semaphore do? */
-	spin_lock_irqsave (&port->driver_lock, flags);
+	spin_lock_irqsave(&port->driver_lock, flags);
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
-	spin_unlock_irqrestore (&port->driver_lock, flags);
+	spin_unlock_irqrestore(&port->driver_lock, flags);
 
 	tty_wakeup(tty);
-	func_exit ();
+	func_exit();
 }
 
-
-void gs_flush_chars(struct tty_struct * tty)
+void gs_flush_chars(struct tty_struct *tty)
 {
 	struct gs_port *port;
 
-	func_enter ();
+	func_enter();
 
-	if (!tty) return;
+	if (!tty)
+		return;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port)
+		return;
 
 	if (port->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
 	    !port->xmit_buf) {
-		func_exit ();
+		func_exit();
 		return;
 	}
 
 	/* Beats me -- REW */
 	port->flags |= GS_TX_INTEN;
-	port->rd->enable_tx_interrupts (port);
-	func_exit ();
+	port->rd->enable_tx_interrupts(port);
+	func_exit();
 }
 
-
-void gs_stop(struct tty_struct * tty)
+void gs_stop(struct tty_struct *tty)
 {
 	struct gs_port *port;
 
-	func_enter ();
+	func_enter();
 
-	if (!tty) return;
+	if (!tty)
+		return;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port)
+		return;
 
-	if (port->xmit_cnt && 
-	    port->xmit_buf && 
-	    (port->flags & GS_TX_INTEN) ) {
+	if (port->xmit_cnt && port->xmit_buf && (port->flags & GS_TX_INTEN)) {
 		port->flags &= ~GS_TX_INTEN;
-		port->rd->disable_tx_interrupts (port);
+		port->rd->disable_tx_interrupts(port);
 	}
-	func_exit ();
+	func_exit();
 }
 
-
-void gs_start(struct tty_struct * tty)
+void gs_start(struct tty_struct *tty)
 {
 	struct gs_port *port;
 
-	if (!tty) return;
+	if (!tty)
+		return;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port)
+		return;
 
-	if (port->xmit_cnt && 
-	    port->xmit_buf && 
-	    !(port->flags & GS_TX_INTEN) ) {
+	if (port->xmit_cnt && port->xmit_buf && !(port->flags & GS_TX_INTEN)) {
 		port->flags |= GS_TX_INTEN;
-		port->rd->enable_tx_interrupts (port);
+		port->rd->enable_tx_interrupts(port);
 	}
-	func_exit ();
+	func_exit();
 }
 
-
-static void gs_shutdown_port (struct gs_port *port)
+static void gs_shutdown_port(struct gs_port *port)
 {
 	unsigned long flags;
 
 	func_enter();
-	
-	if (!port) return;
-	
+
+	if (!port)
+		return;
+
 	if (!(port->flags & ASYNC_INITIALIZED))
 		return;
 
 	spin_lock_irqsave(&port->driver_lock, flags);
 
 	if (port->xmit_buf) {
-		free_page((unsigned long) port->xmit_buf);
+		free_page((unsigned long)port->xmit_buf);
 		port->xmit_buf = NULL;
 	}
 
 	if (port->tty)
 		set_bit(TTY_IO_ERROR, &port->tty->flags);
 
-	port->rd->shutdown_port (port);
+	port->rd->shutdown_port(port);
 
 	port->flags &= ~ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&port->driver_lock, flags);
@@ -386,51 +394,52 @@
 	func_exit();
 }
 
-
 void gs_hangup(struct tty_struct *tty)
 {
-	struct gs_port   *port;
+	struct gs_port *port;
 
-	func_enter ();
+	func_enter();
 
-	if (!tty) return;
+	if (!tty)
+		return;
 
 	port = tty->driver_data;
 	tty = port->tty;
-	if (!tty) 
+	if (!tty)
 		return;
 
-	gs_shutdown_port (port);
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE|GS_ACTIVE);
+	gs_shutdown_port(port);
+	port->flags &= ~(ASYNC_NORMAL_ACTIVE | GS_ACTIVE);
 	port->tty = NULL;
 	port->count = 0;
 
 	wake_up_interruptible(&port->open_wait);
-	func_exit ();
+	func_exit();
 }
 
-
-int gs_block_til_ready(void *port_, struct file * filp)
+int gs_block_til_ready(void *port_, struct file *filp)
 {
 	struct gs_port *port = port_;
 	DECLARE_WAITQUEUE(wait, current);
-	int    retval;
-	int    do_clocal = 0;
-	int    CD;
+	int retval;
+	int do_clocal = 0;
+	int CD;
 	struct tty_struct *tty;
 	unsigned long flags;
 
-	func_enter ();
+	func_enter();
 
-	if (!port) return 0;
+	if (!port)
+		return 0;
 
 	tty = port->tty;
 
-	if (!tty) return 0;
+	if (!tty)
+		return 0;
 
-	gs_dprintk (GS_DEBUG_BTR, "Entering gs_block_till_ready.\n"); 
+	gs_dprintk(GS_DEBUG_BTR, "Entering gs_block_till_ready.\n");
 	/*
-	 * If the device is in the middle of being closed, then block
+	 * If the device is in the middle of being closed: block
 	 * until it's done, and then try again.
 	 */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
@@ -441,20 +450,19 @@
 			return -ERESTARTSYS;
 	}
 
-	gs_dprintk (GS_DEBUG_BTR, "after hung up\n"); 
+	gs_dprintk(GS_DEBUG_BTR, "after hung up\n");
 
 	/*
 	 * If non-blocking mode is set, or the port is not enabled,
-	 * then make the check up front and then exit.
+	 * then make the check up front and exit.
 	 */
-	if ((filp->f_flags & O_NONBLOCK) ||
-	    (tty->flags & (1 << TTY_IO_ERROR))) {
+	if ((filp->f_flags & O_NONBLOCK) || (tty->flags & (1 << TTY_IO_ERROR))) {
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
-	gs_dprintk (GS_DEBUG_BTR, "after nonblock\n"); 
- 
+	gs_dprintk(GS_DEBUG_BTR, "after nonblock\n");
+
 	if (C_CLOCAL(tty))
 		do_clocal = 1;
 
@@ -469,7 +477,7 @@
 
 	add_wait_queue(&port->open_wait, &wait);
 
-	gs_dprintk (GS_DEBUG_BTR, "after add waitq.\n"); 
+	gs_dprintk(GS_DEBUG_BTR, "after add waitq.\n");
 	spin_lock_irqsave(&port->driver_lock, flags);
 	if (!tty_hung_up_p(filp)) {
 		port->count--;
@@ -477,31 +485,30 @@
 	spin_unlock_irqrestore(&port->driver_lock, flags);
 	port->blocked_open++;
 	while (1) {
-		CD = port->rd->get_CD (port);
-		gs_dprintk (GS_DEBUG_BTR, "CD is now %d.\n", CD);
-		set_current_state (TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp) ||
-		    !(port->flags & ASYNC_INITIALIZED)) {
+		CD = port->rd->get_CD(port);
+		gs_dprintk(GS_DEBUG_BTR, "CD is now %d.\n", CD);
+		set_current_state(TASK_INTERRUPTIBLE);
+		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)) {
 			if (port->flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
 			break;
 		}
-		if (!(port->flags & ASYNC_CLOSING) &&
-		    (do_clocal || CD))
+		if (!(port->flags & ASYNC_CLOSING) && (do_clocal || CD))
 			break;
-		gs_dprintk (GS_DEBUG_BTR, "signal_pending is now: %d (%lx)\n", 
-		(int)signal_pending (current), *(long*)(&current->blocked)); 
+		gs_dprintk(GS_DEBUG_BTR, "signal_pending is now: %d (%lx)\n",
+			   (int)signal_pending(current),
+			   *(long *)(&current->blocked));
 		if (signal_pending(current)) {
 			retval = -ERESTARTSYS;
 			break;
 		}
 		schedule();
 	}
-	gs_dprintk (GS_DEBUG_BTR, "Got out of the loop. (%d)\n",
-		    port->blocked_open);
-	set_current_state (TASK_RUNNING);
+	gs_dprintk(GS_DEBUG_BTR, "Got out of the loop. (%d)\n",
+		   port->blocked_open);
+	set_current_state(TASK_RUNNING);
 	remove_wait_queue(&port->open_wait, &wait);
 	if (!tty_hung_up_p(filp)) {
 		port->count++;
@@ -511,27 +518,28 @@
 		return retval;
 
 	port->flags |= ASYNC_NORMAL_ACTIVE;
-	func_exit ();
+	func_exit();
 	return 0;
-}			 
-
+}
 
-void gs_close(struct tty_struct * tty, struct file * filp)
+void gs_close(struct tty_struct *tty, struct file *filp)
 {
 	unsigned long flags;
 	struct gs_port *port;
-	
-	func_enter ();
 
-	if (!tty) return;
+	func_enter();
+
+	if (!tty)
+		return;
 
-	port = (struct gs_port *) tty->driver_data;
+	port = (struct gs_port *)tty->driver_data;
 
-	if (!port) return;
+	if (!port)
+		return;
 
 	if (!port->tty) {
 		/* This seems to happen when this is called from vhangup. */
-		gs_dprintk (GS_DEBUG_CLOSE, "gs: Odd: port->tty is NULL\n");
+		gs_dprintk(GS_DEBUG_CLOSE, "gs: Odd: port->tty is NULL\n");
 		port->tty = tty;
 	}
 
@@ -540,25 +548,28 @@
 	if (tty_hung_up_p(filp)) {
 		spin_unlock_irqrestore(&port->driver_lock, flags);
 		if (port->rd->hungup)
-			port->rd->hungup (port);
-		func_exit ();
+			port->rd->hungup(port);
+		func_exit();
 		return;
 	}
 
 	if ((tty->count == 1) && (port->count != 1)) {
 		printk(KERN_ERR "gs: gs_close port %p: bad port count;"
-		       " tty->count is 1, port count is %d\n", port, port->count);
+		       " tty->count is 1, port count is %d\n", port,
+		       port->count);
 		port->count = 1;
 	}
 	if (--port->count < 0) {
-		printk(KERN_ERR "gs: gs_close port %p: bad port count: %d\n", port, port->count);
+		printk(KERN_ERR "gs: gs_close port %p: bad port count: %d\n",
+		       port, port->count);
 		port->count = 0;
 	}
 
 	if (port->count) {
-		gs_dprintk(GS_DEBUG_CLOSE, "gs_close port %p: count: %d\n", port, port->count);
+		gs_dprintk(GS_DEBUG_CLOSE, "gs_close port %p: count: %d\n",
+			   port, port->count);
 		spin_unlock_irqrestore(&port->driver_lock, flags);
-		func_exit ();
+		func_exit();
 		return;
 	}
 	port->flags |= ASYNC_CLOSING;
@@ -577,13 +588,12 @@
 	 * interrupt driver to stop checking the data ready bit in the
 	 * line status register.
 	 */
-
-	port->rd->disable_rx_interrupts (port);
+	port->rd->disable_rx_interrupts(port);
 	spin_unlock_irqrestore(&port->driver_lock, flags);
 
 	/* close has no way of returning "EINTR", so discard return value */
 	if (port->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		gs_wait_tx_flushed (port, port->closing_wait);
+		gs_wait_tx_flushed(port, port->closing_wait);
 
 	port->flags &= ~GS_ACTIVE;
 
@@ -594,27 +604,27 @@
 	tty->closing = 0;
 
 	port->event = 0;
-	port->rd->close (port);
-	port->rd->shutdown_port (port);
+	port->rd->close(port);
+	port->rd->shutdown_port(port);
 	port->tty = NULL;
 
 	if (port->blocked_open) {
 		if (port->close_delay) {
 			spin_unlock_irqrestore(&port->driver_lock, flags);
-			msleep_interruptible(jiffies_to_msecs(port->close_delay));
+			msleep_interruptible(jiffies_to_msecs
+					     (port->close_delay));
 			spin_lock_irqsave(&port->driver_lock, flags);
 		}
 		wake_up_interruptible(&port->open_wait);
 	}
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING | ASYNC_INITIALIZED);
+	port->flags &=
+	    ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING | ASYNC_INITIALIZED);
 	wake_up_interruptible(&port->close_wait);
 
-	func_exit ();
+	func_exit();
 }
 
-
-void gs_set_termios (struct tty_struct * tty, 
-                     struct ktermios * old_termios)
+void gs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct gs_port *port;
 	int baudrate, tmp, rv;
@@ -622,37 +632,45 @@
 
 	func_enter();
 
-	if (!tty) return;
+	if (!tty)
+		return;
 
 	port = tty->driver_data;
 
-	if (!port) return;
+	if (!port)
+		return;
 	if (!port->tty) {
 		/* This seems to happen when this is called after gs_close. */
-		gs_dprintk (GS_DEBUG_TERMIOS, "gs: Odd: port->tty is NULL\n");
+		gs_dprintk(GS_DEBUG_TERMIOS, "gs: Odd: port->tty is NULL\n");
 		port->tty = tty;
 	}
 
-
 	tiosp = tty->termios;
 
 	if (gs_debug & GS_DEBUG_TERMIOS) {
-		gs_dprintk (GS_DEBUG_TERMIOS, "termios structure (%p):\n", tiosp);
+		gs_dprintk(GS_DEBUG_TERMIOS, "termios structure (%p):\n",
+			   tiosp);
 	}
 
-	if(old_termios && (gs_debug & GS_DEBUG_TERMIOS)) {
-		if(tiosp->c_iflag != old_termios->c_iflag)  printk("c_iflag changed\n");
-		if(tiosp->c_oflag != old_termios->c_oflag)  printk("c_oflag changed\n");
-		if(tiosp->c_cflag != old_termios->c_cflag)  printk("c_cflag changed\n");
-		if(tiosp->c_lflag != old_termios->c_lflag)  printk("c_lflag changed\n");
-		if(tiosp->c_line  != old_termios->c_line)   printk("c_line changed\n");
-		if(!memcmp(tiosp->c_cc, old_termios->c_cc, NCC)) printk("c_cc changed\n");
+	if (old_termios && (gs_debug & GS_DEBUG_TERMIOS)) {
+		if (tiosp->c_iflag != old_termios->c_iflag)
+			printk("c_iflag changed\n");
+		if (tiosp->c_oflag != old_termios->c_oflag)
+			printk("c_oflag changed\n");
+		if (tiosp->c_cflag != old_termios->c_cflag)
+			printk("c_cflag changed\n");
+		if (tiosp->c_lflag != old_termios->c_lflag)
+			printk("c_lflag changed\n");
+		if (tiosp->c_line != old_termios->c_line)
+			printk("c_line changed\n");
+		if (!memcmp(tiosp->c_cc, old_termios->c_cc, NCC))
+			printk("c_cc changed\n");
 	}
 
 	baudrate = tty_get_baud_rate(tty);
 
 	if ((tiosp->c_cflag & CBAUD) == B38400) {
-		if (     (port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baudrate = 57600;
 		else if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			baudrate = 115200;
@@ -673,30 +691,32 @@
 
 	/* Two timer ticks seems enough to wakeup something like SLIP driver */
 	/* Baudrate/10 is cps. Divide by HZ to get chars per tick. */
-	tmp = (baudrate / 10 / HZ) * 2;			 
+	tmp = (baudrate / 10 / HZ) * 2;
 
-	if (tmp <                 0) tmp = 0;
-	if (tmp >= SERIAL_XMIT_SIZE) tmp = SERIAL_XMIT_SIZE-1;
+	if (tmp < 0)
+		tmp = 0;
+	if (tmp >= SERIAL_XMIT_SIZE)
+		tmp = SERIAL_XMIT_SIZE - 1;
 
 	port->wakeup_chars = tmp;
 
 	/* We should really wait for the characters to be all sent before
 	   changing the settings. -- CAL */
-	rv = gs_wait_tx_flushed (port, MAX_SCHEDULE_TIMEOUT);
-	if (rv < 0) return /* rv */;
+	rv = gs_wait_tx_flushed(port, MAX_SCHEDULE_TIMEOUT);
+	if (rv < 0)
+		return /* rv */ ;
 
 	rv = port->rd->set_real_termios(port);
-	if (rv < 0) return /* rv */;
+	if (rv < 0)
+		return /* rv */ ;
 
-	if ((!old_termios || 
-	     (old_termios->c_cflag & CRTSCTS)) &&
-	    !(      tiosp->c_cflag & CRTSCTS)) {
+	if ((!old_termios ||
+	     (old_termios->c_cflag & CRTSCTS)) && !(tiosp->c_cflag & CRTSCTS)) {
 		tty->stopped = 0;
 		gs_start(tty);
 	}
-
 #ifdef tytso_patch_94Nov25_1726
-	/* This "makes sense", Why is it commented out? */
+	/* This "makes sense", why is it commented out? */
 
 	if (!(old_termios->c_cflag & CLOCAL) &&
 	    (tty->termios->c_cflag & CLOCAL))
@@ -704,20 +724,18 @@
 #endif
 
 	func_exit();
-	return /* 0 */;
+	return /* 0 */ ;
 }
 
-
-
 /* Must be called with interrupts enabled */
 int gs_init_port(struct gs_port *port)
 {
 	unsigned long flags;
 
-	func_enter ();
+	func_enter();
 
 	if (port->flags & ASYNC_INITIALIZED) {
-		func_exit ();
+		func_exit();
 		return 0;
 	}
 	if (!port->xmit_buf) {
@@ -725,64 +743,62 @@
 		unsigned long tmp;
 
 		tmp = get_zeroed_page(GFP_KERNEL);
-		spin_lock_irqsave (&port->driver_lock, flags);
-		if (port->xmit_buf) 
-			free_page (tmp);
+		spin_lock_irqsave(&port->driver_lock, flags);
+		if (port->xmit_buf)
+			free_page(tmp);
 		else
-			port->xmit_buf = (unsigned char *) tmp;
+			port->xmit_buf = (unsigned char *)tmp;
 		spin_unlock_irqrestore(&port->driver_lock, flags);
 		if (!port->xmit_buf) {
-			func_exit ();
+			func_exit();
 			return -ENOMEM;
 		}
 	}
 
-	spin_lock_irqsave (&port->driver_lock, flags);
-	if (port->tty) 
+	spin_lock_irqsave(&port->driver_lock, flags);
+	if (port->tty)
 		clear_bit(TTY_IO_ERROR, &port->tty->flags);
 	mutex_init(&port->port_write_mutex);
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
 	spin_unlock_irqrestore(&port->driver_lock, flags);
 	gs_set_termios(port->tty, NULL);
-	spin_lock_irqsave (&port->driver_lock, flags);
+	spin_lock_irqsave(&port->driver_lock, flags);
 	port->flags |= ASYNC_INITIALIZED;
 	port->flags &= ~GS_TX_INTEN;
 
 	spin_unlock_irqrestore(&port->driver_lock, flags);
-	func_exit ();
+	func_exit();
 	return 0;
 }
 
-
-int gs_setserial(struct gs_port *port, struct serial_struct __user *sp)
+int gs_setserial(struct gs_port *port, struct serial_struct __user * sp)
 {
 	struct serial_struct sio;
 
 	if (copy_from_user(&sio, sp, sizeof(struct serial_struct)))
-		return(-EFAULT);
+		return (-EFAULT);
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((sio.baud_base != port->baud_base) ||
 		    (sio.close_delay != port->close_delay) ||
 		    ((sio.flags & ~ASYNC_USR_MASK) !=
 		     (port->flags & ~ASYNC_USR_MASK)))
-			return(-EPERM);
-	} 
+			return (-EPERM);
+	}
 
 	port->flags = (port->flags & ~ASYNC_USR_MASK) |
-		(sio.flags & ASYNC_USR_MASK);
-  
+	    (sio.flags & ASYNC_USR_MASK);
+
 	port->baud_base = sio.baud_base;
 	port->close_delay = sio.close_delay;
 	port->closing_wait = sio.closing_wait;
 	port->custom_divisor = sio.custom_divisor;
 
-	gs_set_termios (port->tty, NULL);
+	gs_set_termios(port->tty, NULL);
 
 	return 0;
 }
 
-
 /*****************************************************************************/
 
 /*
@@ -791,7 +807,7 @@
 
 int gs_getserial(struct gs_port *port, struct serial_struct __user *sp)
 {
-	struct serial_struct    sio;
+	struct serial_struct sio;
 
 	memset(&sio, 0, sizeof(struct serial_struct));
 	sio.flags = port->flags;
@@ -809,7 +825,7 @@
 	sio.irq = -1;
 
 	if (port->rd->getserial)
-		port->rd->getserial (port, &sio);
+		port->rd->getserial(port, &sio);
 
 	if (copy_to_user(sp, &sio, sizeof(struct serial_struct)))
 		return -EFAULT;
@@ -817,21 +833,19 @@
 
 }
 
-
 void gs_got_break(struct gs_port *port)
 {
-	func_enter ();
+	func_enter();
 
 	tty_insert_flip_char(port->tty, 0, TTY_BREAK);
 	tty_schedule_flip(port->tty);
 	if (port->flags & ASYNC_SAK) {
-		do_SAK (port->tty);
+		do_SAK(port->tty);
 	}
 
-	func_exit ();
+	func_exit();
 }
 
-
 EXPORT_SYMBOL(gs_put_char);
 EXPORT_SYMBOL(gs_write);
 EXPORT_SYMBOL(gs_write_room);

--------------040508020409010403020306--
