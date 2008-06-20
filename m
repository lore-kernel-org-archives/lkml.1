Return-Path: <linux-kernel-owner+w=401wt.eu-S1761231AbYFTUT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761231AbYFTUT4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756112AbYFTURF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:17:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51967 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759808AbYFTURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:17:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 11/70] isicom: use tty_port
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 20:59:36 +0100
Message-ID: <20080620195935.1479.58817.stgit@localhost.localdomain>
In-Reply-To: <20080620195406.1479.12620.stgit@localhost.localdomain>
References: <20080620195406.1479.12620.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@redhat.com>

Switch isicom to use a tty_port structure for some fields

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/isicom.c |  181 +++++++++++++++++++++----------------------------
 1 files changed, 79 insertions(+), 102 deletions(-)


diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 4f3cefa..20be56f 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -198,17 +198,12 @@ struct	isi_board {
 
 struct	isi_port {
 	unsigned short		magic;
-	unsigned int		flags;
-	int			count;
-	int			blocked_open;
+	struct tty_port		port;
 	int			close_delay;
 	u16			channel;
 	u16			status;
 	u16			closing_wait;
 	struct isi_board	*card;
-	struct tty_struct 	*tty;
-	wait_queue_head_t	close_wait;
-	wait_queue_head_t	open_wait;
 	unsigned char		*xmit_buf;
 	int			xmit_head;
 	int			xmit_tail;
@@ -430,11 +425,11 @@ static void isicom_tx(unsigned long _data)
 
 	for (; count > 0; count--, port++) {
 		/* port not active or tx disabled to force flow control */
-		if (!(port->flags & ASYNC_INITIALIZED) ||
+		if (!(port->port.flags & ASYNC_INITIALIZED) ||
 				!(port->status & ISI_TXOK))
 			continue;
 
-		tty = port->tty;
+		tty = port->port.tty;
 
 		if (tty == NULL)
 			continue;
@@ -458,7 +453,7 @@ static void isicom_tx(unsigned long _data)
 			if (residue == YES) {
 				residue = NO;
 				if (cnt > 0) {
-					wrd |= (port->xmit_buf[port->xmit_tail]
+					wrd |= (port->port.xmit_buf[port->xmit_tail]
 									<< 8);
 					port->xmit_tail = (port->xmit_tail + 1)
 						& (SERIAL_XMIT_SIZE - 1);
@@ -474,14 +469,14 @@ static void isicom_tx(unsigned long _data)
 			if (cnt <= 0)
 				break;
 			word_count = cnt >> 1;
-			outsw(base, port->xmit_buf+port->xmit_tail, word_count);
+			outsw(base, port->port.xmit_buf+port->xmit_tail, word_count);
 			port->xmit_tail = (port->xmit_tail
 				+ (word_count << 1)) & (SERIAL_XMIT_SIZE - 1);
 			txcount -= (word_count << 1);
 			port->xmit_cnt -= (word_count << 1);
 			if (cnt & 0x0001) {
 				residue = YES;
-				wrd = port->xmit_buf[port->xmit_tail];
+				wrd = port->port.xmit_buf[port->xmit_tail];
 				port->xmit_tail = (port->xmit_tail + 1)
 					& (SERIAL_XMIT_SIZE - 1);
 				port->xmit_cnt--;
@@ -548,13 +543,13 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 	port = card->ports + channel;
-	if (!(port->flags & ASYNC_INITIALIZED)) {
+	if (!(port->port.flags & ASYNC_INITIALIZED)) {
 		outw(0x0000, base+0x04); /* enable interrupts */
 		spin_unlock(&card->card_lock);
 		return IRQ_HANDLED;
 	}
 
-	tty = port->tty;
+	tty = port->port.tty;
 	if (tty == NULL) {
 		word_count = byte_count >> 1;
 		while (byte_count > 1) {
@@ -572,7 +567,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 		header = inw(base);
 		switch (header & 0xff) {
 		case 0:	/* Change in EIA signals */
-			if (port->flags & ASYNC_CHECK_CD) {
+			if (port->port.flags & ASYNC_CHECK_CD) {
 				if (port->status & ISI_DCD) {
 					if (!(header & ISI_DCD)) {
 					/* Carrier has been lost  */
@@ -585,7 +580,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 				/* Carrier has been detected */
 					pr_dbg("interrupt: DCD->high.\n");
 					port->status |= ISI_DCD;
-					wake_up_interruptible(&port->open_wait);
+					wake_up_interruptible(&port->port.open_wait);
 				}
 			} else {
 				if (header & ISI_DCD)
@@ -594,17 +589,17 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 					port->status &= ~ISI_DCD;
 			}
 
-			if (port->flags & ASYNC_CTS_FLOW) {
-				if (port->tty->hw_stopped) {
+			if (port->port.flags & ASYNC_CTS_FLOW) {
+				if (port->port.tty->hw_stopped) {
 					if (header & ISI_CTS) {
-						port->tty->hw_stopped = 0;
+						port->port.tty->hw_stopped = 0;
 						/* start tx ing */
 						port->status |= (ISI_TXOK
 							| ISI_CTS);
 						tty_wakeup(tty);
 					}
 				} else if (!(header & ISI_CTS)) {
-					port->tty->hw_stopped = 1;
+					port->port.tty->hw_stopped = 1;
 					/* stop tx ing */
 					port->status &= ~(ISI_TXOK | ISI_CTS);
 				}
@@ -629,7 +624,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 
 		case 1:	/* Received Break !!! */
 			tty_insert_flip_char(tty, 0, TTY_BREAK);
-			if (port->flags & ASYNC_SAK)
+			if (port->port.flags & ASYNC_SAK)
 				do_SAK(tty);
 			tty_flip_buffer_push(tty);
 			break;
@@ -681,7 +676,7 @@ static void isicom_config_port(struct isi_port *port)
 		shift_count = card->shift_count;
 	unsigned char flow_ctrl;
 
-	tty = port->tty;
+	tty = port->port.tty;
 
 	if (tty == NULL)
 		return;
@@ -697,7 +692,7 @@ static void isicom_config_port(struct isi_port *port)
 
 		/* 1,2,3,4 => 57.6, 115.2, 230, 460 kbps resp. */
 		if (baud < 1 || baud > 4)
-			port->tty->termios->c_cflag &= ~CBAUDEX;
+			port->port.tty->termios->c_cflag &= ~CBAUDEX;
 		else
 			baud += 15;
 	}
@@ -708,13 +703,13 @@ static void isicom_config_port(struct isi_port *port)
 		 *  the 'setserial' utility.
 		 */
 
-		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baud++; /*  57.6 Kbps */
-		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			baud += 2; /*  115  Kbps */
-		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			baud += 3; /* 230 kbps*/
-		if ((port->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		if ((port->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			baud += 4; /* 460 kbps*/
 	}
 	if (linuxb_to_isib[baud] == -1) {
@@ -754,15 +749,15 @@ static void isicom_config_port(struct isi_port *port)
 		InterruptTheCard(base);
 	}
 	if (C_CLOCAL(tty))
-		port->flags &= ~ASYNC_CHECK_CD;
+		port->port.flags &= ~ASYNC_CHECK_CD;
 	else
-		port->flags |= ASYNC_CHECK_CD;
+		port->port.flags |= ASYNC_CHECK_CD;
 
 	/* flow control settings ...*/
 	flow_ctrl = 0;
-	port->flags &= ~ASYNC_CTS_FLOW;
+	port->port.flags &= ~ASYNC_CTS_FLOW;
 	if (C_CRTSCTS(tty)) {
-		port->flags |= ASYNC_CTS_FLOW;
+		port->port.flags |= ASYNC_CTS_FLOW;
 		flow_ctrl |= ISICOM_CTSRTS;
 	}
 	if (I_IXON(tty))
@@ -809,23 +804,15 @@ static int isicom_setup_port(struct isi_port *port)
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
-	if (port->flags & ASYNC_INITIALIZED)
+	if (port->port.flags & ASYNC_INITIALIZED)
 		return 0;
-	if (!port->xmit_buf) {
-		/* Relies on BKL */
-		unsigned long page  = get_zeroed_page(GFP_KERNEL);
-		if (page == 0)
-			return -ENOMEM;
-		if (port->xmit_buf)
-			free_page(page);
-		else
-			port->xmit_buf = (unsigned char *) page;
-	}
+	if (tty_port_alloc_xmit_buf(&port->port) < 0)
+		return -ENOMEM;
 
 	spin_lock_irqsave(&card->card_lock, flags);
-	if (port->tty)
-		clear_bit(TTY_IO_ERROR, &port->tty->flags);
-	if (port->count == 1)
+	if (port->port.tty)
+		clear_bit(TTY_IO_ERROR, &port->port.tty->flags);
+	if (port->port.count == 1)
 		card->count++;
 
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
@@ -839,7 +826,7 @@ static int isicom_setup_port(struct isi_port *port)
 	}
 
 	isicom_config_port(port);
-	port->flags |= ASYNC_INITIALIZED;
+	port->port.flags |= ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
 	return 0;
@@ -855,10 +842,10 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 
 	/* block if port is in the process of being closed */
 
-	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
+	if (tty_hung_up_p(filp) || port->port.flags & ASYNC_CLOSING) {
 		pr_dbg("block_til_ready: close in progress.\n");
-		interruptible_sleep_on(&port->close_wait);
-		if (port->flags & ASYNC_HUP_NOTIFY)
+		interruptible_sleep_on(&port->port.close_wait);
+		if (port->port.flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		else
 			return -ERESTARTSYS;
@@ -869,7 +856,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	if ((filp->f_flags & O_NONBLOCK) ||
 			(tty->flags & (1 << TTY_IO_ERROR))) {
 		pr_dbg("block_til_ready: non-block mode.\n");
-		port->flags |= ASYNC_NORMAL_ACTIVE;
+		port->port.flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
 	}
 
@@ -879,26 +866,26 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	/* block waiting for DCD to be asserted, and while
 						callout dev is busy */
 	retval = 0;
-	add_wait_queue(&port->open_wait, &wait);
+	add_wait_queue(&port->port.open_wait, &wait);
 
 	spin_lock_irqsave(&card->card_lock, flags);
 	if (!tty_hung_up_p(filp))
-		port->count--;
-	port->blocked_open++;
+		port->port.count--;
+	port->port.blocked_open++;
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
 	while (1) {
 		raise_dtr_rts(port);
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (tty_hung_up_p(filp) || !(port->flags & ASYNC_INITIALIZED)) {
-			if (port->flags & ASYNC_HUP_NOTIFY)
+		if (tty_hung_up_p(filp) || !(port->port.flags & ASYNC_INITIALIZED)) {
+			if (port->port.flags & ASYNC_HUP_NOTIFY)
 				retval = -EAGAIN;
 			else
 				retval = -ERESTARTSYS;
 			break;
 		}
-		if (!(port->flags & ASYNC_CLOSING) &&
+		if (!(port->port.flags & ASYNC_CLOSING) &&
 				(do_clocal || (port->status & ISI_DCD))) {
 			break;
 		}
@@ -909,15 +896,15 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		schedule();
 	}
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&port->open_wait, &wait);
+	remove_wait_queue(&port->port.open_wait, &wait);
 	spin_lock_irqsave(&card->card_lock, flags);
 	if (!tty_hung_up_p(filp))
-		port->count++;
-	port->blocked_open--;
+		port->port.count++;
+	port->port.blocked_open--;
 	spin_unlock_irqrestore(&card->card_lock, flags);
 	if (retval)
 		return retval;
-	port->flags |= ASYNC_NORMAL_ACTIVE;
+	port->port.flags |= ASYNC_NORMAL_ACTIVE;
 	return 0;
 }
 
@@ -947,9 +934,9 @@ static int isicom_open(struct tty_struct *tty, struct file *filp)
 
 	isicom_setup_board(card);
 
-	port->count++;
+	port->port.count++;
 	tty->driver_data = port;
-	port->tty = tty;
+	port->port.tty = tty;
 	error = isicom_setup_port(port);
 	if (error == 0)
 		error = block_til_ready(tty, filp, port);
@@ -970,18 +957,15 @@ static void isicom_shutdown_port(struct isi_port *port)
 	struct isi_board *card = port->card;
 	struct tty_struct *tty;
 
-	tty = port->tty;
+	tty = port->port.tty;
 
-	if (!(port->flags & ASYNC_INITIALIZED))
+	if (!(port->port.flags & ASYNC_INITIALIZED))
 		return;
 
-	if (port->xmit_buf) {
-		free_page((unsigned long) port->xmit_buf);
-		port->xmit_buf = NULL;
-	}
-	port->flags &= ~ASYNC_INITIALIZED;
+	tty_port_free_xmit_buf(&port->port);
+	port->port.flags &= ~ASYNC_INITIALIZED;
 	/* 3rd October 2000 : Vinayak P Risbud */
-	port->tty = NULL;
+	port->port.tty = NULL;
 
 	/*Fix done by Anil .S on 30-04-2001
 	remote login through isi port has dtr toggle problem
@@ -1046,24 +1030,24 @@ static void isicom_close(struct tty_struct *tty, struct file *filp)
 		return;
 	}
 
-	if (tty->count == 1 && port->count != 1) {
+	if (tty->count == 1 && port->port.count != 1) {
 		printk(KERN_WARNING "ISICOM:(0x%lx) isicom_close: bad port "
 			"count tty->count = 1 port count = %d.\n",
-			card->base, port->count);
-		port->count = 1;
+			card->base, port->port.count);
+		port->port.count = 1;
 	}
-	if (--port->count < 0) {
+	if (--port->port.count < 0) {
 		printk(KERN_WARNING "ISICOM:(0x%lx) isicom_close: bad port "
 			"count for channel%d = %d", card->base, port->channel,
-			port->count);
-		port->count = 0;
+			port->port.count);
+		port->port.count = 0;
 	}
 
-	if (port->count) {
+	if (port->port.count) {
 		spin_unlock_irqrestore(&card->card_lock, flags);
 		return;
 	}
-	port->flags |= ASYNC_CLOSING;
+	port->port.flags |= ASYNC_CLOSING;
 	tty->closing = 1;
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
@@ -1072,7 +1056,7 @@ static void isicom_close(struct tty_struct *tty, struct file *filp)
 	/* indicate to the card that no more data can be received
 	   on this port */
 	spin_lock_irqsave(&card->card_lock, flags);
-	if (port->flags & ASYNC_INITIALIZED) {
+	if (port->port.flags & ASYNC_INITIALIZED) {
 		card->port_status &= ~(1 << port->channel);
 		outw(card->port_status, card->base + 0x02);
 	}
@@ -1085,7 +1069,7 @@ static void isicom_close(struct tty_struct *tty, struct file *filp)
 	spin_lock_irqsave(&card->card_lock, flags);
 	tty->closing = 0;
 
-	if (port->blocked_open) {
+	if (port->port.blocked_open) {
 		spin_unlock_irqrestore(&card->card_lock, flags);
 		if (port->close_delay) {
 			pr_dbg("scheduling until time out.\n");
@@ -1093,10 +1077,10 @@ static void isicom_close(struct tty_struct *tty, struct file *filp)
 				jiffies_to_msecs(port->close_delay));
 		}
 		spin_lock_irqsave(&card->card_lock, flags);
-		wake_up_interruptible(&port->open_wait);
+		wake_up_interruptible(&port->port.open_wait);
 	}
-	port->flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
-	wake_up_interruptible(&port->close_wait);
+	port->port.flags &= ~(ASYNC_NORMAL_ACTIVE | ASYNC_CLOSING);
+	wake_up_interruptible(&port->port.close_wait);
 	spin_unlock_irqrestore(&card->card_lock, flags);
 }
 
@@ -1112,9 +1096,6 @@ static int isicom_write(struct tty_struct *tty,	const unsigned char *buf,
 	if (isicom_paranoia_check(port, tty->name, "isicom_write"))
 		return 0;
 
-	if (!port->xmit_buf)
-		return 0;
-
 	spin_lock_irqsave(&card->card_lock, flags);
 
 	while (1) {
@@ -1123,7 +1104,7 @@ static int isicom_write(struct tty_struct *tty,	const unsigned char *buf,
 		if (cnt <= 0)
 			break;
 
-		memcpy(port->xmit_buf + port->xmit_head, buf, cnt);
+		memcpy(port->port.xmit_buf + port->xmit_head, buf, cnt);
 		port->xmit_head = (port->xmit_head + cnt) & (SERIAL_XMIT_SIZE
 			- 1);
 		port->xmit_cnt += cnt;
@@ -1147,16 +1128,13 @@ static int isicom_put_char(struct tty_struct *tty, unsigned char ch)
 	if (isicom_paranoia_check(port, tty->name, "isicom_put_char"))
 		return 0;
 
-	if (!port->xmit_buf)
-		return 0;
-
 	spin_lock_irqsave(&card->card_lock, flags);
 	if (port->xmit_cnt >= SERIAL_XMIT_SIZE - 1) {
 		spin_unlock_irqrestore(&card->card_lock, flags);
 		return 0;
 	}
 
-	port->xmit_buf[port->xmit_head++] = ch;
+	port->port.xmit_buf[port->xmit_head++] = ch;
 	port->xmit_head &= (SERIAL_XMIT_SIZE - 1);
 	port->xmit_cnt++;
 	spin_unlock_irqrestore(&card->card_lock, flags);
@@ -1172,7 +1150,7 @@ static void isicom_flush_chars(struct tty_struct *tty)
 		return;
 
 	if (port->xmit_cnt <= 0 || tty->stopped || tty->hw_stopped ||
-			!port->xmit_buf)
+			!port->port.xmit_buf)
 		return;
 
 	/* this tells the transmitter to consider this port for
@@ -1274,23 +1252,23 @@ static int isicom_set_serial_info(struct isi_port *port,
 
 	lock_kernel();
 
-	reconfig_port = ((port->flags & ASYNC_SPD_MASK) !=
+	reconfig_port = ((port->port.flags & ASYNC_SPD_MASK) !=
 		(newinfo.flags & ASYNC_SPD_MASK));
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if ((newinfo.close_delay != port->close_delay) ||
 				(newinfo.closing_wait != port->closing_wait) ||
 				((newinfo.flags & ~ASYNC_USR_MASK) !=
-				(port->flags & ~ASYNC_USR_MASK))) {
+				(port->port.flags & ~ASYNC_USR_MASK))) {
 			unlock_kernel();
 			return -EPERM;
 		}
-		port->flags = ((port->flags & ~ASYNC_USR_MASK) |
+		port->port.flags = ((port->port.flags & ~ASYNC_USR_MASK) |
 				(newinfo.flags & ASYNC_USR_MASK));
 	} else {
 		port->close_delay = newinfo.close_delay;
 		port->closing_wait = newinfo.closing_wait;
-		port->flags = ((port->flags & ~ASYNC_FLAGS) |
+		port->port.flags = ((port->port.flags & ~ASYNC_FLAGS) |
 				(newinfo.flags & ASYNC_FLAGS));
 	}
 	if (reconfig_port) {
@@ -1314,7 +1292,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 	out_info.line = port - isi_ports;
 	out_info.port = port->card->base;
 	out_info.irq = port->card->irq;
-	out_info.flags = port->flags;
+	out_info.flags = port->port.flags;
 /*	out_info.baud_base = ? */
 	out_info.close_delay = port->close_delay;
 	out_info.closing_wait = port->closing_wait;
@@ -1454,10 +1432,10 @@ static void isicom_hangup(struct tty_struct *tty)
 	isicom_shutdown_port(port);
 	spin_unlock_irqrestore(&port->card->card_lock, flags);
 
-	port->count = 0;
-	port->flags &= ~ASYNC_NORMAL_ACTIVE;
-	port->tty = NULL;
-	wake_up_interruptible(&port->open_wait);
+	port->port.count = 0;
+	port->port.flags &= ~ASYNC_NORMAL_ACTIVE;
+	port->port.tty = NULL;
+	wake_up_interruptible(&port->port.open_wait);
 }
 
 
@@ -1824,8 +1802,7 @@ static int __init isicom_init(void)
 			port->close_delay = 50 * HZ/100;
 			port->closing_wait = 3000 * HZ/100;
 			port->status = 0;
-			init_waitqueue_head(&port->open_wait);
-			init_waitqueue_head(&port->close_wait);
+			tty_port_init(&port->port);
 			/*  . . .  */
 		}
 		isi_card[idx].base = 0;

