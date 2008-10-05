Return-Path: <linux-kernel-owner+w=401wt.eu-S1758268AbYJEQSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758268AbYJEQSd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 12:18:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbYJEQMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 12:12:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48540 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756413AbYJEQMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:12:05 -0400
From: Alan Cox <alan@redhat.com>
Subject: [PATCH 39/76] tty: kref usage for isicom and moxa
To: linux-kernel@vger.kernel.org
Date: Sun, 05 Oct 2008 17:12:05 +0100
Message-ID: <20081005161143.1997.1746.stgit@localhost.localdomain>
In-Reply-To: <20081005160231.1997.10462.stgit@localhost.localdomain>
References: <20081005160231.1997.10462.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rather than blindly keep taking krefs we reorder the code in a few places
to pass the tty down to the right place (which is important as from the user
side it is not the case that tty == port->tty in all situations). For the irq
and related paths use the krefs to stop the tty being freed under us.

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/isicom.c |   61 +++++++++++++++++++++++++------------------------
 drivers/char/moxa.c   |   61 +++++++++++++++++++++++++++++++------------------
 2 files changed, 69 insertions(+), 53 deletions(-)

diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 8f7cc19..7d30ee1 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -421,17 +421,16 @@ static void isicom_tx(unsigned long _data)
 	if (retries >= 100)
 		goto unlock;
 
+	tty = tty_port_tty_get(&port->port);
+	if (tty == NULL)
+		goto put_unlock;
+
 	for (; count > 0; count--, port++) {
 		/* port not active or tx disabled to force flow control */
 		if (!(port->port.flags & ASYNC_INITIALIZED) ||
 				!(port->status & ISI_TXOK))
 			continue;
 
-		tty = port->port.tty;
-
-		if (tty == NULL)
-			continue;
-
 		txcount = min_t(short, TX_SIZE, port->xmit_cnt);
 		if (txcount <= 0 || tty->stopped || tty->hw_stopped)
 			continue;
@@ -489,6 +488,8 @@ static void isicom_tx(unsigned long _data)
 			tty_wakeup(tty);
 	}
 
+put_unlock:
+	tty_kref_put(tty);
 unlock:
 	spin_unlock_irqrestore(&isi_card[card].card_lock, flags);
 	/*	schedule another tx for hopefully in about 10ms	*/
@@ -547,7 +548,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 		return IRQ_HANDLED;
 	}
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 	if (tty == NULL) {
 		word_count = byte_count >> 1;
 		while (byte_count > 1) {
@@ -588,7 +589,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 			}
 
 			if (port->port.flags & ASYNC_CTS_FLOW) {
-				if (port->port.tty->hw_stopped) {
+				if (tty->hw_stopped) {
 					if (header & ISI_CTS) {
 						port->port.tty->hw_stopped = 0;
 						/* start tx ing */
@@ -597,7 +598,7 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 						tty_wakeup(tty);
 					}
 				} else if (!(header & ISI_CTS)) {
-					port->port.tty->hw_stopped = 1;
+					tty->hw_stopped = 1;
 					/* stop tx ing */
 					port->status &= ~(ISI_TXOK | ISI_CTS);
 				}
@@ -660,24 +661,21 @@ static irqreturn_t isicom_interrupt(int irq, void *dev_id)
 	}
 	outw(0x0000, base+0x04); /* enable interrupts */
 	spin_unlock(&card->card_lock);
+	tty_kref_put(tty);
 
 	return IRQ_HANDLED;
 }
 
-static void isicom_config_port(struct isi_port *port)
+static void isicom_config_port(struct tty_struct *tty)
 {
+	struct isi_port *port = tty->driver_data;
 	struct isi_board *card = port->card;
-	struct tty_struct *tty;
 	unsigned long baud;
 	unsigned long base = card->base;
 	u16 channel_setup, channel = port->channel,
 		shift_count = card->shift_count;
 	unsigned char flow_ctrl;
 
-	tty = port->port.tty;
-
-	if (tty == NULL)
-		return;
 	/* FIXME: Switch to new tty baud API */
 	baud = C_BAUD(tty);
 	if (baud & CBAUDEX) {
@@ -690,7 +688,7 @@ static void isicom_config_port(struct isi_port *port)
 
 		/* 1,2,3,4 => 57.6, 115.2, 230, 460 kbps resp. */
 		if (baud < 1 || baud > 4)
-			port->port.tty->termios->c_cflag &= ~CBAUDEX;
+			tty->termios->c_cflag &= ~CBAUDEX;
 		else
 			baud += 15;
 	}
@@ -797,8 +795,9 @@ static inline void isicom_setup_board(struct isi_board *bp)
 	spin_unlock_irqrestore(&bp->card_lock, flags);
 }
 
-static int isicom_setup_port(struct isi_port *port)
+static int isicom_setup_port(struct tty_struct *tty)
 {
+	struct isi_port *port = tty->driver_data;
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
@@ -808,8 +807,7 @@ static int isicom_setup_port(struct isi_port *port)
 		return -ENOMEM;
 
 	spin_lock_irqsave(&card->card_lock, flags);
-	if (port->port.tty)
-		clear_bit(TTY_IO_ERROR, &port->port.tty->flags);
+	clear_bit(TTY_IO_ERROR, &tty->flags);
 	if (port->port.count == 1)
 		card->count++;
 
@@ -823,7 +821,7 @@ static int isicom_setup_port(struct isi_port *port)
 		InterruptTheCard(card->base);
 	}
 
-	isicom_config_port(port);
+	isicom_config_port(tty);
 	port->port.flags |= ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
@@ -934,8 +932,8 @@ static int isicom_open(struct tty_struct *tty, struct file *filp)
 
 	port->port.count++;
 	tty->driver_data = port;
-	port->port.tty = tty;
-	error = isicom_setup_port(port);
+	tty_port_tty_set(&port->port, tty);
+	error = isicom_setup_port(tty);
 	if (error == 0)
 		error = block_til_ready(tty, filp, port);
 	return error;
@@ -955,15 +953,17 @@ static void isicom_shutdown_port(struct isi_port *port)
 	struct isi_board *card = port->card;
 	struct tty_struct *tty;
 
-	tty = port->port.tty;
+	tty = tty_port_tty_get(&port->port);
 
-	if (!(port->port.flags & ASYNC_INITIALIZED))
+	if (!(port->port.flags & ASYNC_INITIALIZED)) {
+		tty_kref_put(tty);
 		return;
+	}
 
 	tty_port_free_xmit_buf(&port->port);
 	port->port.flags &= ~ASYNC_INITIALIZED;
 	/* 3rd October 2000 : Vinayak P Risbud */
-	port->port.tty = NULL;
+	tty_port_tty_set(&port->port, NULL);
 
 	/*Fix done by Anil .S on 30-04-2001
 	remote login through isi port has dtr toggle problem
@@ -1243,9 +1243,10 @@ static int isicom_tiocmset(struct tty_struct *tty, struct file *file,
 	return 0;
 }
 
-static int isicom_set_serial_info(struct isi_port *port,
-	struct serial_struct __user *info)
+static int isicom_set_serial_info(struct tty_struct *tty,
+					struct serial_struct __user *info)
 {
+	struct isi_port *port = tty->driver_data;
 	struct serial_struct newinfo;
 	int reconfig_port;
 
@@ -1276,7 +1277,7 @@ static int isicom_set_serial_info(struct isi_port *port,
 	if (reconfig_port) {
 		unsigned long flags;
 		spin_lock_irqsave(&port->card->card_lock, flags);
-		isicom_config_port(port);
+		isicom_config_port(tty);
 		spin_unlock_irqrestore(&port->card->card_lock, flags);
 	}
 	unlock_kernel();
@@ -1318,7 +1319,7 @@ static int isicom_ioctl(struct tty_struct *tty, struct file *filp,
 		return isicom_get_serial_info(port, argp);
 
 	case TIOCSSERIAL:
-		return isicom_set_serial_info(port, argp);
+		return isicom_set_serial_info(tty, argp);
 
 	default:
 		return -ENOIOCTLCMD;
@@ -1341,7 +1342,7 @@ static void isicom_set_termios(struct tty_struct *tty,
 		return;
 
 	spin_lock_irqsave(&port->card->card_lock, flags);
-	isicom_config_port(port);
+	isicom_config_port(tty);
 	spin_unlock_irqrestore(&port->card->card_lock, flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
@@ -1419,7 +1420,7 @@ static void isicom_hangup(struct tty_struct *tty)
 
 	port->port.count = 0;
 	port->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	port->port.tty = NULL;
+	tty_port_tty_set(&port->port, NULL);
 	wake_up_interruptible(&port->port.open_wait);
 }
 
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index d3d7864..5df4003 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -205,7 +205,7 @@ static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 static void moxa_poll(unsigned long);
 static void moxa_set_tty_param(struct tty_struct *, struct ktermios *);
 static void moxa_setup_empty_event(struct tty_struct *);
-static void moxa_shut_down(struct moxa_port *);
+static void moxa_shut_down(struct tty_struct *);
 /*
  * moxa board interface functions:
  */
@@ -217,7 +217,7 @@ static void MoxaPortLineCtrl(struct moxa_port *, int, int);
 static void MoxaPortFlowCtrl(struct moxa_port *, int, int, int, int, int);
 static int MoxaPortLineStatus(struct moxa_port *);
 static void MoxaPortFlushData(struct moxa_port *, int);
-static int MoxaPortWriteData(struct moxa_port *, const unsigned char *, int);
+static int MoxaPortWriteData(struct tty_struct *, const unsigned char *, int);
 static int MoxaPortReadData(struct moxa_port *);
 static int MoxaPortTxQueue(struct moxa_port *);
 static int MoxaPortRxQueue(struct moxa_port *);
@@ -332,6 +332,7 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		for (i = 0; i < MAX_BOARDS; i++) {
 			p = moxa_boards[i].ports;
 			for (j = 0; j < MAX_PORTS_PER_BOARD; j++, p++, argm++) {
+				struct tty_struct *ttyp;
 				memset(&tmp, 0, sizeof(tmp));
 				if (!moxa_boards[i].ready)
 					goto copy;
@@ -344,10 +345,12 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 				if (status & 4)
 					tmp.dcd = 1;
 
-				if (!p->port.tty || !p->port.tty->termios)
+				ttyp = tty_port_tty_get(&p->port);
+				if (!ttyp || !ttyp->termios)
 					tmp.cflag = p->cflag;
 				else
-					tmp.cflag = p->port.tty->termios->c_cflag;
+					tmp.cflag = ttyp->termios->c_cflag;
+				tty_kref_put(tty);
 copy:
 				if (copy_to_user(argm, &tmp, sizeof(tmp))) {
 					mutex_unlock(&moxa_openlock);
@@ -880,8 +883,14 @@ static void moxa_board_deinit(struct moxa_board_conf *brd)
 
 	/* pci hot-un-plug support */
 	for (a = 0; a < brd->numPorts; a++)
-		if (brd->ports[a].port.flags & ASYNC_INITIALIZED)
-			tty_hangup(brd->ports[a].port.tty);
+		if (brd->ports[a].port.flags & ASYNC_INITIALIZED) {
+			struct tty_struct *tty = tty_port_tty_get(
+						&brd->ports[a].port);
+			if (tty) {
+				tty_hangup(tty);
+				tty_kref_put(tty);
+			}
+		}
 	while (1) {
 		opened = 0;
 		for (a = 0; a < brd->numPorts; a++)
@@ -1096,13 +1105,14 @@ static void __exit moxa_exit(void)
 module_init(moxa_init);
 module_exit(moxa_exit);
 
-static void moxa_close_port(struct moxa_port *ch)
+static void moxa_close_port(struct tty_struct *tty)
 {
-	moxa_shut_down(ch);
+	struct moxa_port *ch = tty->driver_data;
+	moxa_shut_down(tty);
 	MoxaPortFlushData(ch, 2);
 	ch->port.flags &= ~ASYNC_NORMAL_ACTIVE;
-	ch->port.tty->driver_data = NULL;
-	ch->port.tty = NULL;
+	tty->driver_data = NULL;
+	tty_port_tty_set(&ch->port, NULL);
 }
 
 static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
@@ -1161,7 +1171,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	ch = &brd->ports[port % MAX_PORTS_PER_BOARD];
 	ch->port.count++;
 	tty->driver_data = ch;
-	ch->port.tty = tty;
+	tty_port_tty_set(&ch->port, tty);
 	if (!(ch->port.flags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
 		moxa_set_tty_param(tty, tty->termios);
@@ -1179,7 +1189,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	if (retval) {
 		if (ch->port.count) /* 0 means already hung up... */
 			if (--ch->port.count == 0)
-				moxa_close_port(ch);
+				moxa_close_port(tty);
 	} else
 		ch->port.flags |= ASYNC_NORMAL_ACTIVE;
 	mutex_unlock(&moxa_openlock);
@@ -1219,7 +1229,7 @@ static void moxa_close(struct tty_struct *tty, struct file *filp)
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
 	}
 
-	moxa_close_port(ch);
+	moxa_close_port(tty);
 unlock:
 	mutex_unlock(&moxa_openlock);
 }
@@ -1234,7 +1244,7 @@ static int moxa_write(struct tty_struct *tty,
 		return 0;
 
 	spin_lock_bh(&moxa_lock);
-	len = MoxaPortWriteData(ch, buf, count);
+	len = MoxaPortWriteData(tty, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
 	ch->statusflags |= LOWWAIT;
@@ -1409,7 +1419,7 @@ static void moxa_hangup(struct tty_struct *tty)
 		return;
 	}
 	ch->port.count = 0;
-	moxa_close_port(ch);
+	moxa_close_port(tty);
 	mutex_unlock(&moxa_openlock);
 
 	wake_up_interruptible(&ch->port.open_wait);
@@ -1417,11 +1427,14 @@ static void moxa_hangup(struct tty_struct *tty)
 
 static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 {
+	struct tty_struct *tty;
 	dcd = !!dcd;
 
-	if (dcd != p->DCDState && p->port.tty && C_CLOCAL(p->port.tty)) {
-		if (!dcd)
-			tty_hangup(p->port.tty);
+	if (dcd != p->DCDState) {
+		tty = tty_port_tty_get(&p->port);
+		if (tty && C_CLOCAL(tty) && !dcd)
+			tty_hangup(tty);
+		tty_kref_put(tty);
 	}
 	p->DCDState = dcd;
 }
@@ -1429,7 +1442,7 @@ static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		u16 __iomem *ip)
 {
-	struct tty_struct *tty = p->port.tty;
+	struct tty_struct *tty = tty_port_tty_get(&p->port);
 	void __iomem *ofsAddr;
 	unsigned int inited = p->port.flags & ASYNC_INITIALIZED;
 	u16 intr;
@@ -1476,6 +1489,7 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 		tty_insert_flip_char(tty, 0, TTY_BREAK);
 		tty_schedule_flip(tty);
 	}
+	tty_kref_put(tty);
 
 	if (intr & IntrLine)
 		moxa_new_dcdstate(p, readb(ofsAddr + FlagStat) & DCD_state);
@@ -1560,9 +1574,9 @@ static void moxa_setup_empty_event(struct tty_struct *tty)
 	spin_unlock_bh(&moxa_lock);
 }
 
-static void moxa_shut_down(struct moxa_port *ch)
+static void moxa_shut_down(struct tty_struct *tty)
 {
-	struct tty_struct *tp = ch->port.tty;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (!(ch->port.flags & ASYNC_INITIALIZED))
 		return;
@@ -1572,7 +1586,7 @@ static void moxa_shut_down(struct moxa_port *ch)
 	/*
 	 * If we're a modem control device and HUPCL is on, drop RTS & DTR.
 	 */
-	if (C_HUPCL(tp))
+	if (C_HUPCL(tty))
 		MoxaPortLineCtrl(ch, 0, 0);
 
 	spin_lock_bh(&moxa_lock);
@@ -1953,9 +1967,10 @@ static int MoxaPortLineStatus(struct moxa_port *port)
 	return val;
 }
 
-static int MoxaPortWriteData(struct moxa_port *port,
+static int MoxaPortWriteData(struct tty_struct *tty,
 		const unsigned char *buffer, int len)
 {
+	struct moxa_port *port = tty->driver_data;
 	void __iomem *baseAddr, *ofsAddr, *ofs;
 	unsigned int c, total;
 	u16 head, tail, tx_mask, spage, epage;

