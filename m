Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYESPES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYESPES (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 11:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760552AbYESPDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 11:03:19 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39711 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760469AbYESPDS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 11:03:18 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/20] moxa: use tty_port
To: linux-kernel@vger.kernel.org, akpm@osdl.org, greg@kroah.com
Date: Mon, 19 May 2008 15:50:35 +0100
Message-ID: <20080519145035.19326.72810.stgit@core>
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

Switch MOXA to use the new tty_port structure
---

 drivers/char/moxa.c |   87 +++++++++++++++++++++++++--------------------------
 1 files changed, 42 insertions(+), 45 deletions(-)


diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index d57d3a6..bb9bcff 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -130,17 +130,14 @@ struct moxaq_str {
 };
 
 struct moxa_port {
+	struct tty_port port;
 	struct moxa_board_conf *board;
-	struct tty_struct *tty;
 	void __iomem *tableAddr;
 
 	int type;
 	int close_delay;
-	unsigned int count;
-	int asyncflags;
 	int cflag;
 	unsigned long statusflags;
-	wait_queue_head_t open_wait;
 
 	u8 DCDState;
 	u8 lineCtrl;
@@ -348,10 +345,10 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 				if (status & 4)
 					tmp.dcd = 1;
 
-				if (!p->tty || !p->tty->termios)
+				if (!p->port.tty || !p->port.tty->termios)
 					tmp.cflag = p->cflag;
 				else
-					tmp.cflag = p->tty->termios->c_cflag;
+					tmp.cflag = p->port.tty->termios->c_cflag;
 copy:
 				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
 					mutex_unlock(&moxa_openlock);
@@ -828,7 +825,7 @@ static int moxa_init_board(struct moxa_board_conf *brd, struct device *dev)
 		p->type = PORT_16550A;
 		p->close_delay = 5 * HZ / 10;
 		p->cflag = B9600 | CS8 | CREAD | CLOCAL | HUPCL;
-		init_waitqueue_head(&p->open_wait);
+		tty_port_init(&p->port);
 	}
 
 	switch (brd->boardType) {
@@ -884,12 +881,12 @@ static void moxa_board_deinit(struct moxa_board_conf *brd)
 
 	/* pci hot-un-plug support */
 	for (a = 0; a < brd->numPorts; a++)
-		if (brd->ports[a].asyncflags & ASYNC_INITIALIZED)
-			tty_hangup(brd->ports[a].tty);
+		if (brd->ports[a].port.flags & ASYNC_INITIALIZED)
+			tty_hangup(brd->ports[a].port.tty);
 	while (1) {
 		opened = 0;
 		for (a = 0; a < brd->numPorts; a++)
-			if (brd->ports[a].asyncflags & ASYNC_INITIALIZED)
+			if (brd->ports[a].port.flags & ASYNC_INITIALIZED)
 				opened++;
 		mutex_unlock(&moxa_openlock);
 		if (!opened)
@@ -1104,9 +1101,9 @@ static void moxa_close_port(struct moxa_port *ch)
 {
 	moxa_shut_down(ch);
 	MoxaPortFlushData(ch, 2);
-	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
-	ch->tty->driver_data = NULL;
-	ch->tty = NULL;
+	ch->port.flags &= ~ASYNC_NORMAL_ACTIVE;
+	ch->port.tty->driver_data = NULL;
+	ch->port.tty = NULL;
 }
 
 static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
@@ -1117,7 +1114,7 @@ static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
 	u8 dcd;
 
 	while (1) {
-		prepare_to_wait(&ch->open_wait, &wait, TASK_INTERRUPTIBLE);
+		prepare_to_wait(&ch->port.open_wait, &wait, TASK_INTERRUPTIBLE);
 		if (tty_hung_up_p(filp)) {
 #ifdef SERIAL_DO_RESTART
 			retval = -ERESTARTSYS;
@@ -1138,7 +1135,7 @@ static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
 		}
 		schedule();
 	}
-	finish_wait(&ch->open_wait, &wait);
+	finish_wait(&ch->port.open_wait, &wait);
 
 	return retval;
 }
@@ -1163,16 +1160,16 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	}
 
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
-	ch->count++;
+	ch->port.count++;
 	tty->driver_data = ch;
-	ch->tty = tty;
-	if (!(ch->asyncflags & ASYNC_INITIALIZED)) {
+	ch->port.tty = tty;
+	if (!(ch->port.flags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
 		moxa_set_tty_param(tty, tty->termios);
 		MoxaPortLineCtrl(ch, 1, 1);
 		MoxaPortEnable(ch);
 		MoxaSetFifo(ch, ch->type == PORT_16550A);
-		ch->asyncflags |= ASYNC_INITIALIZED;
+		ch->port.flags |= ASYNC_INITIALIZED;
 	}
 	mutex_unlock(&moxa_openlock);
 
@@ -1181,11 +1178,11 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 		retval = moxa_block_till_ready(tty, filp, ch);
 	mutex_lock(&moxa_openlock);
 	if (retval) {
-		if (ch->count) /* 0 means already hung up... */
-			if (--ch->count == 0)
+		if (ch->port.count) /* 0 means already hung up... */
+			if (--ch->port.count == 0)
 				moxa_close_port(ch);
 	} else
-		ch->asyncflags |= ASYNC_NORMAL_ACTIVE;
+		ch->port.flags |= ASYNC_NORMAL_ACTIVE;
 	mutex_unlock(&moxa_openlock);
 
 	return retval;
@@ -1204,21 +1201,21 @@ static void moxa_close(struct tty_struct *tty, struct file *filp)
 	ch = tty->driver_data;
 	if (ch == NULL)
 		goto unlock;
-	if (tty->count == 1 && ch->count != 1) {
+	if (tty->count == 1 && ch->port.count != 1) {
 		printk(KERN_WARNING "moxa_close: bad serial port count; "
-			"tty->count is 1, ch->count is %d\n", ch->count);
-		ch->count = 1;
+			"tty->count is 1, ch->port.count is %d\n", ch->port.count);
+		ch->port.count = 1;
 	}
-	if (--ch->count < 0) {
+	if (--ch->port.count < 0) {
 		printk(KERN_WARNING "moxa_close: bad serial port count, "
 			"device=%s\n", tty->name);
-		ch->count = 0;
+		ch->port.count = 0;
 	}
-	if (ch->count)
+	if (ch->port.count)
 		goto unlock;
 
 	ch->cflag = tty->termios->c_cflag;
-	if (ch->asyncflags & ASYNC_INITIALIZED) {
+	if (ch->port.flags & ASYNC_INITIALIZED) {
 		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
 	}
@@ -1374,7 +1371,7 @@ static void moxa_set_termios(struct tty_struct *tty,
 		return;
 	moxa_set_tty_param(tty, old_termios);
 	if (!(old_termios->c_cflag & CLOCAL) && C_CLOCAL(tty))
-		wake_up_interruptible(&ch->open_wait);
+		wake_up_interruptible(&ch->port.open_wait);
 }
 
 static void moxa_stop(struct tty_struct *tty)
@@ -1412,20 +1409,20 @@ static void moxa_hangup(struct tty_struct *tty)
 		mutex_unlock(&moxa_openlock);
 		return;
 	}
-	ch->count = 0;
+	ch->port.count = 0;
 	moxa_close_port(ch);
 	mutex_unlock(&moxa_openlock);
 
-	wake_up_interruptible(&ch->open_wait);
+	wake_up_interruptible(&ch->port.open_wait);
 }
 
 static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 {
 	dcd = !!dcd;
 
-	if (dcd != p->DCDState && p->tty && C_CLOCAL(p->tty)) {
+	if (dcd != p->DCDState && p->port.tty && C_CLOCAL(p->port.tty)) {
 		if (!dcd)
-			tty_hangup(p->tty);
+			tty_hangup(p->port.tty);
 	}
 	p->DCDState = dcd;
 }
@@ -1433,9 +1430,9 @@ static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		u16 __iomem *ip)
 {
-	struct tty_struct *tty = p->tty;
+	struct tty_struct *tty = p->port.tty;
 	void __iomem *ofsAddr;
-	unsigned int inited = p->asyncflags & ASYNC_INITIALIZED;
+	unsigned int inited = p->port.flags & ASYNC_INITIALIZED;
 	u16 intr;
 
 	if (tty) {
@@ -1566,9 +1563,9 @@ static void moxa_setup_empty_event(struct tty_struct *tty)
 
 static void moxa_shut_down(struct moxa_port *ch)
 {
-	struct tty_struct *tp = ch->tty;
+	struct tty_struct *tp = ch->port.tty;
 
-	if (!(ch->asyncflags & ASYNC_INITIALIZED))
+	if (!(ch->port.flags & ASYNC_INITIALIZED))
 		return;
 
 	MoxaPortDisable(ch);
@@ -1580,7 +1577,7 @@ static void moxa_shut_down(struct moxa_port *ch)
 		MoxaPortLineCtrl(ch, 0, 0);
 
 	spin_lock_bh(&moxa_lock);
-	ch->asyncflags &= ~ASYNC_INITIALIZED;
+	ch->port.flags &= ~ASYNC_INITIALIZED;
 	spin_unlock_bh(&moxa_lock);
 }
 
@@ -1975,7 +1972,7 @@ static int MoxaPortWriteData(struct moxa_port *port,
 	c = (head > tail) ? (head - tail - 1) : (head - tail + tx_mask);
 	if (c > len)
 		c = len;
-	moxaLog.txcnt[port->tty->index] += c;
+	moxaLog.txcnt[port->port.tty->index] += c;
 	total = c;
 	if (spage == epage) {
 		bufhead = readw(ofsAddr + Ofs_txb);
@@ -2017,7 +2014,7 @@ static int MoxaPortWriteData(struct moxa_port *port,
 
 static int MoxaPortReadData(struct moxa_port *port)
 {
-	struct tty_struct *tty = port->tty;
+	struct tty_struct *tty = port->port.tty;
 	unsigned char *dst;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
 	unsigned int count, len, total;
@@ -2124,8 +2121,8 @@ static int moxa_get_serial_info(struct moxa_port *info,
 {
 	struct serial_struct tmp = {
 		.type = info->type,
-		.line = info->tty->index,
-		.flags = info->asyncflags,
+		.line = info->port.tty->index,
+		.flags = info->port.flags,
 		.baud_base = 921600,
 		.close_delay = info->close_delay
 	};
@@ -2148,13 +2145,13 @@ static int moxa_set_serial_info(struct moxa_port *info,
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (((new_serial.flags & ~ASYNC_USR_MASK) !=
-		     (info->asyncflags & ~ASYNC_USR_MASK)))
+		     (info->port.flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
 	} else
 		info->close_delay = new_serial.close_delay * HZ / 100;
 
 	new_serial.flags = (new_serial.flags & ~ASYNC_FLAGS);
-	new_serial.flags |= (info->asyncflags & ASYNC_FLAGS);
+	new_serial.flags |= (info->port.flags & ASYNC_FLAGS);
 
 	MoxaSetFifo(info, new_serial.type == PORT_16550A);
 

