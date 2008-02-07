Return-Path: <linux-kernel-owner+w=401wt.eu-S933246AbYBGTOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933246AbYBGTOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933012AbYBGTNc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:13:32 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:39208 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932999AbYBGTN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:13:29 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFT 4/9] Char: moxa, rework open/close
Date: Thu,  7 Feb 2008 20:11:20 +0100
Message-Id: <1202411485-16022-4-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
References: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- add locking to open/close/hangup
- add pci hot-un-plug support (hangup on board remove, wait for openers)
- cleanup block_till_ready
- move close code common to close/hangup into separate function to be
  able to call it from open when hangup occurs while block_till_ready
- let ldisc flush on tty layer, it will do it after we return

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |  239 +++++++++++++++++++++------------------------------
 1 files changed, 97 insertions(+), 142 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index eabb2e0..5a55b8c 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -42,7 +42,6 @@
 #include <linux/pci.h>
 #include <linux/init.h>
 #include <linux/bitops.h>
-#include <linux/completion.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -134,13 +133,11 @@ struct moxa_port {
 
 	int type;
 	int close_delay;
-	int count;
-	int blocked_open;
+	unsigned int count;
 	int asyncflags;
 	int cflag;
 	unsigned long statusflags;
 	wait_queue_head_t open_wait;
-	struct completion close_wait;
 
 	u8 DCDState;
 	u8 lineCtrl;
@@ -167,6 +164,7 @@ static int ttymajor = MOXAMAJOR;
 static struct mon_str moxaLog;
 static unsigned int moxaFuncTout = HZ / 2;
 static unsigned int moxaLowWaterChk;
+static DEFINE_MUTEX(moxa_openlock);
 /* Variables for insmod */
 #ifdef MODULE
 static unsigned long baseaddr[MAX_BOARDS];
@@ -209,8 +207,6 @@ static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
 static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
-static int moxa_block_till_ready(struct tty_struct *, struct file *,
-			    struct moxa_port *);
 static void moxa_setup_empty_event(struct tty_struct *);
 static void moxa_shut_down(struct moxa_port *);
 /*
@@ -817,7 +813,6 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 		p->close_delay = 5 * HZ / 10;
 		p->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
 		init_waitqueue_head(&p->open_wait);
-		init_completion(&p->close_wait);
 	}
 
 	switch (brd->boardType) {
@@ -861,9 +856,30 @@ err:
 
 static void moxa_board_deinit(struct moxa_board_conf *brd)
 {
+	unsigned int a, opened;
+
+	mutex_lock(&moxa_openlock);
 	spin_lock_bh(&moxa_lock);
 	brd->ready = 0;
 	spin_unlock_bh(&moxa_lock);
+
+	/* pci hot-un-plug support */
+	for (a = 0; a < brd->numPorts; a++)
+		if (brd->ports[a].asyncflags & ASYNC_NORMAL_ACTIVE)
+			tty_hangup(brd->ports[a].tty);
+	while (1) {
+		opened = 0;
+		for (a = 0; a < brd->numPorts; a++)
+			if (brd->ports[a].asyncflags & ASYNC_NORMAL_ACTIVE)
+				opened++;
+		mutex_unlock(&moxa_openlock);
+		if (!opened)
+			break;
+		set_task_state(current, TASK_UNINTERRUPTIBLE);
+		schedule_timeout(msecs_to_jiffies(50));
+		mutex_lock(&moxa_openlock);
+	}
+
 	iounmap(brd->basemem);
 	brd->basemem = NULL;
 	kfree(brd->ports);
@@ -1060,6 +1076,44 @@ static void __exit moxa_exit(void)
 module_init(moxa_init);
 module_exit(moxa_exit);
 
+static void moxa_close_port(struct moxa_port *ch)
+{
+	moxa_shut_down(ch);
+	MoxaPortFlushData(ch, 2);
+	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
+	ch->tty = NULL;
+}
+
+static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
+			    struct moxa_port *ch)
+{
+	DEFINE_WAIT(wait);
+	int retval = 0;
+
+	while (1) {
+		prepare_to_wait(&ch->open_wait, &wait, TASK_INTERRUPTIBLE);
+		if (tty_hung_up_p(filp)) {
+#ifdef SERIAL_DO_RESTART
+			retval = -ERESTARTSYS;
+#else
+			retval = -EAGAIN;
+#endif
+			break;
+		}
+		if (ch->DCDState)
+			break;
+
+		if (signal_pending(current)) {
+			retval = -ERESTARTSYS;
+			break;
+		}
+		schedule();
+	}
+	finish_wait(&ch->open_wait, &wait);
+
+	return retval;
+}
+
 static int moxa_open(struct tty_struct *tty, struct file *filp)
 {
 	struct moxa_board_conf *brd;
@@ -1071,9 +1125,13 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	if (port == MAX_PORTS) {
 		return capable(CAP_SYS_ADMIN) ? 0 : -EPERM;
 	}
+	if (mutex_lock_interruptible(&moxa_openlock))
+		return -ERESTARTSYS;
 	brd = &moxa_boards[port / MAX_PORTS_PER_BOARD];
-	if (!brd->ready)
+	if (!brd->ready) {
+		mutex_unlock(&moxa_openlock);
 		return -ENODEV;
+	}
 
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->count++;
@@ -1084,39 +1142,37 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 		moxa_set_tty_param(tty, tty->termios);
 		MoxaPortLineCtrl(ch, 1, 1);
 		MoxaPortEnable(ch);
+		MoxaSetFifo(ch, ch->type == PORT_16550A);
 		ch->asyncflags |= ASYNC_INITIALIZED;
 	}
-	retval = moxa_block_till_ready(tty, filp, ch);
-
-	moxa_unthrottle(tty);
+	mutex_unlock(&moxa_openlock);
 
-	if (ch->type == PORT_16550A) {
-		MoxaSetFifo(ch, 1);
-	} else {
-		MoxaSetFifo(ch, 0);
-	}
+	retval = 0;
+	if (!(filp->f_flags & O_NONBLOCK) && !C_CLOCAL(tty))
+		retval = moxa_block_till_ready(tty, filp, ch);
+	mutex_lock(&moxa_openlock);
+	if (retval) {
+		if (ch->count) /* 0 means already hung up... */
+			if (--ch->count == 0)
+				moxa_close_port(ch);
+	} else
+		ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
+	mutex_unlock(&moxa_openlock);
 
-	return (retval);
+	return retval;
 }
 
 static void moxa_close(struct tty_struct *tty, struct file *filp)
 {
-	struct moxa_port *ch;
+	struct moxa_port *ch = tty->driver_data;
 	int port;
 
 	port = tty->index;
-	if (port == MAX_PORTS) {
-		return;
-	}
-	if (tty->driver_data == NULL) {
+	if (port == MAX_PORTS || ch == NULL || tty_hung_up_p(filp))
 		return;
-	}
-	if (tty_hung_up_p(filp)) {
-		return;
-	}
-	ch = (struct moxa_port *) tty->driver_data;
 
-	if ((tty->count == 1) && (ch->count != 1)) {
+	mutex_lock(&moxa_openlock);
+	if (tty->count == 1 && ch->count != 1) {
 		printk(KERN_WARNING "moxa_close: bad serial port count; "
 			"tty->count is 1, ch->count is %d\n", ch->count);
 		ch->count = 1;
@@ -1127,32 +1183,18 @@ static void moxa_close(struct tty_struct *tty, struct file *filp)
 		ch->count = 0;
 	}
 	if (ch->count) {
+		mutex_unlock(&moxa_openlock);
 		return;
 	}
-	ch->asyncflags |= ASYNC_CLOSING;
 
 	ch->cflag = tty->termios->c_cflag;
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
 	}
-	moxa_shut_down(ch);
-	MoxaPortFlushData(ch, 2);
 
-	if (tty->driver->flush_buffer)
-		tty->driver->flush_buffer(tty);
-	tty_ldisc_flush(tty);
-			
-	tty->closing = 0;
-	ch->tty = NULL;
-	if (ch->blocked_open) {
-		if (ch->close_delay) {
-			msleep_interruptible(jiffies_to_msecs(ch->close_delay));
-		}
-		wake_up_interruptible(&ch->open_wait);
-	}
-	ch->asyncflags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	complete_all(&ch->close_wait);
+	moxa_close_port(ch);
+	mutex_unlock(&moxa_openlock);
 }
 
 static int moxa_write(struct tty_struct *tty,
@@ -1347,13 +1389,13 @@ static void moxa_start(struct tty_struct *tty)
 
 static void moxa_hangup(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
-	moxa_flush_buffer(tty);
-	moxa_shut_down(ch);
+	mutex_lock(&moxa_openlock);
 	ch->count = 0;
-	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-	ch->tty = NULL;
+	moxa_close_port(ch);
+	mutex_unlock(&moxa_openlock);
+
 	wake_up_interruptible(&ch->open_wait);
 }
 
@@ -1362,10 +1404,8 @@ static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 	dcd = !!dcd;
 
 	if ((dcd != p->DCDState) && p->tty && C_CLOCAL(p->tty)) {
-		if (!dcd) {
+		if (!dcd)
 			tty_hangup(p->tty);
-			p->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-		}
 		wake_up_interruptible(&p->open_wait);
 	}
 	p->DCDState = dcd;
@@ -1499,91 +1539,6 @@ static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_term
 	tty_encode_baud_rate(tty, baud, baud);
 }
 
-static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
-			    struct moxa_port *ch)
-{
-	DECLARE_WAITQUEUE(wait,current);
-	int retval;
-	int do_clocal = C_CLOCAL(tty);
-
-	/*
-	 * If the device is in the middle of being closed, then block
-	 * until it's done, and then try again.
-	 */
-	if (tty_hung_up_p(filp) || (ch->asyncflags & ASYNC_CLOSING)) {
-		if (ch->asyncflags & ASYNC_CLOSING)
-			wait_for_completion_interruptible(&ch->close_wait);
-#ifdef SERIAL_DO_RESTART
-		if (ch->asyncflags & ASYNC_HUP_NOTIFY)
-			return (-EAGAIN);
-		else
-			return (-ERESTARTSYS);
-#else
-		return (-EAGAIN);
-#endif
-	}
-	/*
-	 * If non-blocking mode is set, then make the check up front
-	 * and then exit.
-	 */
-	if (filp->f_flags & O_NONBLOCK) {
-		ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
-		return (0);
-	}
-	/*
-	 * Block waiting for the carrier detect and the line to become free
-	 */
-	retval = 0;
-	add_wait_queue(&ch->open_wait, &wait);
-	pr_debug("block_til_ready before block: ttys%d, count = %d\n",
-		tty->index, ch->count);
-	spin_lock_bh(&moxa_lock);
-	if (!tty_hung_up_p(filp))
-		ch->count--;
-	ch->blocked_open++;
-	spin_unlock_bh(&moxa_lock);
-
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp) ||
-		    !(ch->asyncflags & ASYNC_INITIALIZED)) {
-#ifdef SERIAL_DO_RESTART
-			if (ch->asyncflags & ASYNC_HUP_NOTIFY)
-				retval = -EAGAIN;
-			else
-				retval = -ERESTARTSYS;
-#else
-			retval = -EAGAIN;
-#endif
-			break;
-		}
-		if (!(ch->asyncflags & ASYNC_CLOSING) && (do_clocal ||
-				ch->DCDState))
-			break;
-
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
-			break;
-		}
-		schedule();
-	}
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&ch->open_wait, &wait);
-
-	spin_lock_bh(&moxa_lock);
-	if (!tty_hung_up_p(filp))
-		ch->count++;
-	ch->blocked_open--;
-	spin_unlock_bh(&moxa_lock);
-	pr_debug("block_til_ready after blocking: ttys%d, count = %d\n",
-		tty->index, ch->count);
-	if (retval)
-		return (retval);
-	/* FIXME: review to see if we need to use set_bit on these */
-	ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
-	return 0;
-}
-
 static void moxa_setup_empty_event(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
@@ -1595,22 +1550,22 @@ static void moxa_setup_empty_event(struct tty_struct *tty)
 
 static void moxa_shut_down(struct moxa_port *ch)
 {
-	struct tty_struct *tp;
+	struct tty_struct *tp = ch->tty;
 
 	if (!(ch->asyncflags & ASYNC_INITIALIZED))
 		return;
 
-	tp = ch->tty;
-
 	MoxaPortDisable(ch);
 
 	/*
 	 * If we're a modem control device and HUPCL is on, drop RTS & DTR.
 	 */
-	if (tp->termios->c_cflag & HUPCL)
+	if (C_HUPCL(tp))
 		MoxaPortLineCtrl(ch, 0, 0);
 
+	spin_lock_bh(&moxa_lock);
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
+	spin_unlock_bh(&moxa_lock);
 }
 
 /*****************************************************************************
-- 
1.5.3.8

