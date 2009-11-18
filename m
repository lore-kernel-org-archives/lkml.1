Return-Path: <linux-kernel-owner+w=401wt.eu-S1757335AbZKROcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335AbZKROcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:32:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757308AbZKROcP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:32:15 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40603 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757202AbZKROcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:32:10 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 06/12] moxa: Use more tty_port ops
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:15:46 +0000
Message-ID: <20091118141542.3346.73660.stgit@localhost.localdomain>
In-Reply-To: <20091118141354.3346.16910.stgit@localhost.localdomain>
References: <20091118141354.3346.16910.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rework a few bits of this into tty_port format

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/moxa.c |  139 ++++++++-------------------------------------------
 1 files changed, 22 insertions(+), 117 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index dd0083b..96b2985 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -206,8 +206,9 @@ static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 static void moxa_poll(unsigned long);
 static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
 static void moxa_setup_empty_event(struct tty_struct *);
-static void moxa_shut_down(struct tty_struct *);
+static void moxa_shutdown(struct tty_port *);
 static int moxa_carrier_raised(struct tty_port *);
+static void moxa_dtr_rts(struct tty_port *, int);
 /*
  * moxa board interface functions:
  */
@@ -409,6 +410,8 @@ static const struct tty_operations moxa_ops = {
 
 static const struct tty_port_operations moxa_port_ops = {
 	.carrier_raised = moxa_carrier_raised,
+	.dtr_rts = moxa_dtr_rts,
+	.shutdown = moxa_shutdown,
 };
 
 static struct tty_driver *moxaDriver;
@@ -1112,14 +1115,12 @@ static void __exit moxa_exit(void)
 module_init(moxa_init);
 module_exit(moxa_exit);
 
-static void moxa_close_port(struct tty_struct *tty)
+static void moxa_shutdown(struct tty_port *port)
 {
-	struct moxa_port *ch = tty->driver_data;
-	moxa_shut_down(tty);
+	struct moxa_port *ch = container_of(port, struct moxa_port, port);
+        MoxaPortDisable(ch);
 	MoxaPortFlushData(ch, 2);
-	ch->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	tty->driver_data = NULL;
-	tty_port_tty_set(&ch->port, NULL);
+	clear_bit(ASYNCB_NORMAL_ACTIVE, &port->flags);
 }
 
 static int moxa_carrier_raised(struct tty_port *port)
@@ -1133,39 +1134,13 @@ static int moxa_carrier_raised(struct tty_port *port)
 	return dcd;
 }
 
-static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
-			    struct moxa_port *ch)
+static void moxa_dtr_rts(struct tty_port *port, int onoff)
 {
-	struct tty_port *port = &ch->port;
-	DEFINE_WAIT(wait);
-	int retval = 0;
-	u8 dcd;
-
-	while (1) {
-		prepare_to_wait(&port->open_wait, &wait, TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp)) {
-#ifdef SERIAL_DO_RESTART
-			retval = -ERESTARTSYS;
-#else
-			retval = -EAGAIN;
-#endif
-			break;
-		}
-		dcd = tty_port_carrier_raised(port);
-		if (dcd)
-			break;
-
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			break;
-		}
-		schedule();
-	}
-	finish_wait(&port->open_wait, &wait);
-
-	return retval;
+	struct moxa_port *ch = container_of(port, struct moxa_port, port);
+	MoxaPortLineCtrl(ch, onoff, onoff);
 }
 
+
 static int moxa_open(struct tty_struct *tty, struct file *filp)
 {
 	struct moxa_board_conf *brd;
@@ -1194,6 +1169,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	ch->port.count++;
 	tty->driver_data = ch;
 	tty_port_tty_set(&ch->port, tty);
+	mutex_lock(&ch->port.mutex);
 	if (!(ch->port.flags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
 		moxa_set_tty_param(tty, tty->termios);
@@ -1202,57 +1178,21 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 		MoxaSetFifo(ch, ch->type == PORT_16550A);
 		ch->port.flags |= ASYNC_INITIALIZED;
 	}
+	mutex_unlock(&ch->port.mutex);
 	mutex_unlock(&moxa_openlock);
-
-	retval = 0;
-	if (!(filp->f_flags & O_NONBLOCK) && !C_CLOCAL(tty))
-		retval = moxa_block_till_ready(tty, filp, ch);
-	mutex_lock(&moxa_openlock);
-	if (retval) {
-		if (ch->port.count) /* 0 means already hung up... */
-			if (--ch->port.count == 0)
-				moxa_close_port(tty);
-	} else
-		ch->port.flags |= ASYNC_NORMAL_ACTIVE;
-	mutex_unlock(&moxa_openlock);
-
+	
+	retval = tty_port_block_til_ready(&ch->port, tty, filp);
+	if (retval == 0)
+	        set_bit(ASYNCB_NORMAL_ACTIVE, &ch->port.flags);
 	return retval;
 }
 
 static void moxa_close(struct tty_struct *tty, struct file *filp)
 {
-	struct moxa_port *ch;
-	int port;
-
-	port = tty->index;
-	if (port == MAX_PORTS || tty_hung_up_p(filp))
-		return;
-
-	mutex_lock(&moxa_openlock);
-	ch = tty->driver_data;
-	if (ch == NULL)
-		goto unlock;
-	if (tty->count == 1 && ch->port.count != 1) {
-		printk(KERN_WARNING "moxa_close: bad serial port count; "
-			"tty->count is 1, ch->port.count is %d\n", ch->port.count);
-		ch->port.count = 1;
-	}
-	if (--ch->port.count < 0) {
-		printk(KERN_WARNING "moxa_close: bad serial port count, "
-			"device=%s\n", tty->name);
-		ch->port.count = 0;
-	}
-	if (ch->port.count)
-		goto unlock;
-
+	struct moxa_port *ch = tty->driver_data;
 	ch->cflag = tty->termios->c_cflag;
-	if (ch->port.flags & ASYNC_INITIALIZED) {
-		moxa_setup_empty_event(tty);
-		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
-	}
-
-	moxa_close_port(tty);
-unlock:
+	mutex_lock(&moxa_openlock);
+	tty_port_close(&ch->port, tty, filp);
 	mutex_unlock(&moxa_openlock);
 }
 
@@ -1300,14 +1240,6 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 	struct moxa_port *ch = tty->driver_data;
 	int chars;
 
-	/*
-	 * Sigh...I have to check if driver_data is NULL here, because
-	 * if an open() fails, the TTY subsystem eventually calls
-	 * tty_wait_until_sent(), which calls the driver's chars_in_buffer()
-	 * routine.  And since the open() failed, we return 0 here.  TDJ
-	 */
-	if (ch == NULL)
-		return 0;
 	lock_kernel();
 	chars = MoxaPortTxQueue(ch);
 	if (chars) {
@@ -1436,15 +1368,8 @@ static void moxa_hangup(struct tty_struct *tty)
 
 	mutex_lock(&moxa_openlock);
 	ch = tty->driver_data;
-	if (ch == NULL) {
-		mutex_unlock(&moxa_openlock);
-		return;
-	}
-	ch->port.count = 0;
-	moxa_close_port(tty);
+	tty_port_hangup(&ch->port);
 	mutex_unlock(&moxa_openlock);
-
-	wake_up_interruptible(&ch->port.open_wait);
 }
 
 static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
@@ -1597,26 +1522,6 @@ static void moxa_setup_empty_event(struct tty_struct *tty)
 	spin_unlock_bh(&moxa_lock);
 }
 
-static void moxa_shut_down(struct tty_struct *tty)
-{
-	struct moxa_port *ch = tty->driver_data;
-
-	if (!(ch->port.flags & ASYNC_INITIALIZED))
-		return;
-
-	MoxaPortDisable(ch);
-
-	/*
-	 * If we're a modem control device and HUPCL is on, drop RTS & DTR.
-	 */
-	if (C_HUPCL(tty))
-		MoxaPortLineCtrl(ch, 0, 0);
-
-	spin_lock_bh(&moxa_lock);
-	ch->port.flags &= ~ASYNC_INITIALIZED;
-	spin_unlock_bh(&moxa_lock);
-}
-
 /*****************************************************************************
  *	Driver level functions: 					     *
  *****************************************************************************/

