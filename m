Return-Path: <linux-kernel-owner+w=401wt.eu-S1764578AbXKIXqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764578AbXKIXqh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764298AbXKIXqO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:46:14 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57220 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764413AbXKIXqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:46:12 -0500
Message-id: <1390286880006050.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 5/13] Char: nozomi, ioctls cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:46:12 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, ioctls cleanup

- init tty_wait
- don't forget to wake up tiocmiwait waiters
- convert the whole tiocmiwait into wait_event_interruptible
- don't check for cmd == TIOCGICOUNT in ntty_ioctl_tiocgicount, as it's
  expected to be it when we call the function, also pass internal
  structures (port, argp) directly instead of ioctl params
- remove TIOCMGET, TIOCMSET, TIOCMBIC, TIOCMBIS as it is never invoked by
  tty layer this way, add ntty_tiocmget into tty ops instead

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 2470e477561f2577137d557aa4dcf92b0229a745
tree 3486f8adf936d56143d46b5b9e6ad7f55c7a88db
parent 3afb47133874a0979f57928d7450612fa982a6c5
author Jiri Slaby <jirislaby@gmail.com> Mon, 29 Oct 2007 12:28:57 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 23:12:06 +0100

 drivers/char/nozomi.c |  153 ++++++++++++++++---------------------------------
 1 files changed, 50 insertions(+), 103 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index d19b5c5..3f4ae3d 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1199,6 +1199,9 @@ static int receive_flow_control(struct nozomi *dc, struct irq *m)
 		dc->port[port].tty_icount.rng++;
 	if (old_ctrl.DCD != ctrl_dl.DCD)
 		dc->port[port].tty_icount.dcd++;
+
+	wake_up_interruptible(&dc->port[port].tty_wait);
+
 	DBG1("port: %d DCD(%d), CTS(%d), RI(%d), DSR(%d)",
 	   port,
 	   dc->port[port].tty_icount.dcd, dc->port[port].tty_icount.cts,
@@ -1494,6 +1497,7 @@ static void nozomi_get_card_type(struct nozomi *dc)
 static void nozomi_setup_private_data(struct nozomi *dc)
 {
 	void __iomem *offset = dc->base_addr + dc->card_type / 2;
+	unsigned int i;
 
 	dc->reg_fcr = (void __iomem *)(offset + R_FCR);
 	dc->reg_iir = (void __iomem *)(offset + R_IIR);
@@ -1505,6 +1509,9 @@ static void nozomi_setup_private_data(struct nozomi *dc)
 	dc->port[PORT_DIAG].token_dl = DIAG_DL;
 	dc->port[PORT_APP1].token_dl = APP1_DL;
 	dc->port[PORT_APP2].token_dl = APP2_DL;
+
+	for (i = 0; i < MAX_PORT; i++)
+		init_waitqueue_head(&dc->port[i].tty_wait);
 }
 
 static ssize_t card_type_show(struct device *dev, struct device_attribute *attr,
@@ -1965,12 +1972,12 @@ static int ntty_tiocmget(struct tty_struct *tty, struct file *file)
 	struct ctrl_dl *ctrl_dl = &port->ctrl_dl;
 	struct ctrl_ul *ctrl_ul = &port->ctrl_ul;
 
-	return 0 | (ctrl_ul->RTS ? TIOCM_RTS : 0)
-	    | (ctrl_ul->DTR ? TIOCM_DTR : 0)
-	    | (ctrl_dl->DCD ? TIOCM_CAR : 0)
-	    | (ctrl_dl->RI ? TIOCM_RNG : 0)
-	    | (ctrl_dl->DSR ? TIOCM_DSR : 0)
-	    | (ctrl_dl->CTS ? TIOCM_CTS : 0);
+	return	(ctrl_ul->RTS ? TIOCM_RTS : 0) |
+		(ctrl_ul->DTR ? TIOCM_DTR : 0) |
+		(ctrl_dl->DCD ? TIOCM_CAR : 0) |
+		(ctrl_dl->RI  ? TIOCM_RNG : 0) |
+		(ctrl_dl->DSR ? TIOCM_DSR : 0) |
+		(ctrl_dl->CTS ? TIOCM_CTS : 0);
 }
 
 /* Sets io controls parameters */
@@ -1990,121 +1997,60 @@ static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static int ntty_ioctl_tiocmiwait(struct tty_struct *tty, struct file *file,
-				 unsigned int cmd, unsigned long arg)
+static int ntty_cflags_changed(struct port *port, unsigned long flags,
+		struct async_icount *cprev)
 {
-	struct port *port = (struct port *)tty->driver_data;
+	struct async_icount cnow = port->tty_icount;
+	int ret;
 
-	if (cmd == TIOCMIWAIT) {
-		DECLARE_WAITQUEUE(wait, current);
-		struct async_icount cnow;
-		struct async_icount cprev;
-
-		cprev = port->tty_icount;
-		while (1) {
-			add_wait_queue(&port->tty_wait, &wait);
-			set_current_state(TASK_INTERRUPTIBLE);
-			schedule();
-			remove_wait_queue(&port->tty_wait, &wait);
-
-			/* see if a signal woke us up */
-			if (signal_pending(current))
-				return -ERESTARTSYS;
-
-			cnow = port->tty_icount;
-			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
-			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
-				return -EIO;	/* no change => error */
-			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-			    ((arg & TIOCM_CD) && (cnow.dcd != cprev.dcd)) ||
-			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts)))
-				return 0;
-
-			cprev = cnow;
-		}
+	ret =	((flags & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
+		((flags & TIOCM_DSR) && (cnow.dsr != cprev->dsr)) ||
+		((flags & TIOCM_CD)  && (cnow.dcd != cprev->dcd)) ||
+		((flags & TIOCM_CTS) && (cnow.cts != cprev->cts));
 
-	}
-	return -ENOIOCTLCMD;
+	*cprev = cnow;
+
+	return ret;
 }
 
-static int ntty_ioctl_tiocgicount(struct tty_struct *tty, struct file *file,
-				  unsigned int cmd, void __user *arg)
+static int ntty_ioctl_tiocgicount(struct port *port, void __user *argp)
 {
-	struct port *port = (struct port *)tty->driver_data;
-
-	if (cmd == TIOCGICOUNT) {
-		struct async_icount cnow = port->tty_icount;
-		struct serial_icounter_struct icount;
-
-		icount.cts = cnow.cts;
-		icount.dsr = cnow.dsr;
-		icount.rng = cnow.rng;
-		icount.dcd = cnow.dcd;
-		icount.rx = cnow.rx;
-		icount.tx = cnow.tx;
-		icount.frame = cnow.frame;
-		icount.overrun = cnow.overrun;
-		icount.parity = cnow.parity;
-		icount.brk = cnow.brk;
-		icount.buf_overrun = cnow.buf_overrun;
-
-		if (copy_to_user(arg, &icount, sizeof(icount)))
-			return -EFAULT;
-		return 0;
-	}
-	return -ENOIOCTLCMD;
+	struct async_icount cnow = port->tty_icount;
+	struct serial_icounter_struct icount;
+
+	icount.cts = cnow.cts;
+	icount.dsr = cnow.dsr;
+	icount.rng = cnow.rng;
+	icount.dcd = cnow.dcd;
+	icount.rx = cnow.rx;
+	icount.tx = cnow.tx;
+	icount.frame = cnow.frame;
+	icount.overrun = cnow.overrun;
+	icount.parity = cnow.parity;
+	icount.brk = cnow.brk;
+	icount.buf_overrun = cnow.buf_overrun;
+
+	return copy_to_user(argp, &icount, sizeof(icount));
 }
 
 static int ntty_ioctl(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
-	struct nozomi *dc = get_dc_by_tty(tty);
-	unsigned long flags;
-	int mask;
+	struct port *port = tty->driver_data;
+	void __user *argp = (void __user *)arg;
 	int rval = -ENOIOCTLCMD;
 
 	DBG1("******** IOCTL, cmd: %d", cmd);
 
 	switch (cmd) {
-	case TIOCMIWAIT:
-		rval = ntty_ioctl_tiocmiwait(tty, file, cmd, arg);
-		break;
-	case TIOCGICOUNT:
-		rval =
-		    ntty_ioctl_tiocgicount(tty, file, cmd, (void __user *)arg);
-		break;
-	case TIOCMGET:
-		spin_lock_irqsave(&dc->spin_mutex, flags);
-		rval = ntty_tiocmget(tty, file);
-		spin_unlock_irqrestore(&dc->spin_mutex, flags);
-		break;
-	case TIOCMSET:
-		rval = ntty_tiocmset(tty, file, arg, ~arg);
-		break;
-	case TIOCMBIC:
-		if (get_user(mask, (unsigned long __user *)arg))
-			return -EFAULT;
+	case TIOCMIWAIT: {
+		struct async_icount cprev = port->tty_icount;
 
-		spin_lock_irqsave(&dc->spin_mutex, flags);
-		if (mask & TIOCM_RTS)
-			set_rts(tty->index, 0);
-		if (mask & TIOCM_DTR)
-			set_dtr(tty->index, 0);
-		spin_unlock_irqrestore(&dc->spin_mutex, flags);
-		rval = 0;
+		rval = wait_event_interruptible(port->tty_wait,
+				ntty_cflags_changed(port, arg, &cprev));
 		break;
-	case TIOCMBIS:
-		if (get_user(mask, (unsigned long __user *)arg))
-			return -EFAULT;
-
-		spin_lock_irqsave(&dc->spin_mutex, flags);
-		if (mask & TIOCM_RTS)
-			set_rts(tty->index, 1);
-		if (mask & TIOCM_DTR)
-			set_dtr(tty->index, 1);
-		spin_unlock_irqrestore(&dc->spin_mutex, flags);
-		rval = 0;
+	} case TIOCGICOUNT:
+		rval = ntty_ioctl_tiocgicount(port, argp);
 		break;
 	default:
 		DBG1("ERR: 0x%08X, %d", cmd, cmd);
@@ -2186,6 +2132,7 @@ static struct tty_operations tty_ops = {
 	.throttle = ntty_throttle,
 	.chars_in_buffer = ntty_chars_in_buffer,
 	.put_char = ntty_put_char,
+	.tiocmget = ntty_tiocmget,
 	.tiocmset = ntty_tiocmset,
 };
 
