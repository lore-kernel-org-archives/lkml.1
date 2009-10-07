Return-Path: <linux-kernel-owner+w=401wt.eu-S1759403AbZJGO51@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759403AbZJGO51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 10:57:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759388AbZJGO50
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 10:57:26 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:56331 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759386AbZJGO5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 10:57:24 -0400
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 2/4] isicom: switch to the new tty_port_open helper
To: linux-kernel@vger.kernel.org, strakh@ispras.ru, jirislaby@gmail.com
Date: Wed, 07 Oct 2009 15:46:29 +0100
Message-ID: <20091007144621.14550.62068.stgit@localhost.localdomain>
In-Reply-To: <20091007144455.14550.95003.stgit@localhost.localdomain>
References: <20091007144455.14550.95003.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial conversion in this case so might as well do it while testing the
port_open design is right

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/isicom.c |   88 ++++++++++++-------------------------------------
 1 files changed, 21 insertions(+), 67 deletions(-)


diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 426bfdd..e7be3ec 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -804,24 +804,21 @@ static inline void isicom_setup_board(struct isi_board *bp)
 	bp->status |= BOARD_ACTIVE;
 	for (channel = 0; channel < bp->port_count; channel++, port++)
 		drop_dtr_rts(port);
+	bp->count++;
 	spin_unlock_irqrestore(&bp->card_lock, flags);
 }
 
-static int isicom_setup_port(struct tty_struct *tty)
+static int isicom_activate(struct tty_port *tport, struct tty_struct *tty)
 {
-	struct isi_port *port = tty->driver_data;
+	struct isi_port *port = container_of(tport, struct isi_port, port);
 	struct isi_board *card = port->card;
 	unsigned long flags;
 
-	if (port->port.flags & ASYNC_INITIALIZED)
-		return 0;
-	if (tty_port_alloc_xmit_buf(&port->port) < 0)
+	if (tty_port_alloc_xmit_buf(tport) < 0)
 		return -ENOMEM;
 
 	spin_lock_irqsave(&card->card_lock, flags);
-	clear_bit(TTY_IO_ERROR, &tty->flags);
-	if (port->port.count == 1)
-		card->count++;
+	isicom_setup_board(card);
 
 	port->xmit_cnt = port->xmit_head = port->xmit_tail = 0;
 
@@ -832,9 +829,7 @@ static int isicom_setup_port(struct tty_struct *tty)
 		outw(((ISICOM_KILLTX | ISICOM_KILLRX) << 8) | 0x06, card->base);
 		InterruptTheCard(card->base);
 	}
-
 	isicom_config_port(tty);
-	port->port.flags |= ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&card->card_lock, flags);
 
 	return 0;
@@ -871,31 +866,20 @@ static struct tty_port *isicom_find_port(struct tty_struct *tty)
 
 	return &port->port;
 }
-	
+
 static int isicom_open(struct tty_struct *tty, struct file *filp)
 {
 	struct isi_port *port;
 	struct isi_board *card;
 	struct tty_port *tport;
-	int error = 0;
 
 	tport = isicom_find_port(tty);
 	if (tport == NULL)
 		return -ENODEV;
 	port = container_of(tport, struct isi_port, port);
 	card = &isi_card[BOARD(tty->index)];
-	isicom_setup_board(card);
 
-	/* FIXME: locking on port.count etc */
-	port->port.count++;
-	tty->driver_data = port;
-	tty_port_tty_set(&port->port, tty);
-	/* FIXME: Locking on Initialized flag */
-	if (!test_bit(ASYNCB_INITIALIZED, &tport->flags))
-		error = isicom_setup_port(tty);
-	if (error == 0)
-		error = tty_port_block_til_ready(&port->port, tty, filp);
-	return error;
+	return tty_port_open(tport, tty, filp);
 }
 
 /* close et all */
@@ -914,40 +898,21 @@ static void isicom_shutdown_port(struct isi_port *port)
 
 	tty = tty_port_tty_get(&port->port);
 
-	if (!(port->port.flags & ASYNC_INITIALIZED)) {
-		tty_kref_put(tty);
-		return;
-	}
-
 	tty_port_free_xmit_buf(&port->port);
-	port->port.flags &= ~ASYNC_INITIALIZED;
-	/* 3rd October 2000 : Vinayak P Risbud */
-	tty_port_tty_set(&port->port, NULL);
-
-	/*Fix done by Anil .S on 30-04-2001
-	remote login through isi port has dtr toggle problem
-	due to which the carrier drops before the password prompt
-	appears on the remote end. Now we drop the dtr only if the
-	HUPCL(Hangup on close) flag is set for the tty*/
-
-	if (C_HUPCL(tty))
-		/* drop dtr on this port */
-		drop_dtr(port);
-
-	/* any other port uninits  */
-	if (tty)
-		set_bit(TTY_IO_ERROR, &tty->flags);
-
 	if (--card->count < 0) {
 		pr_dbg("isicom_shutdown_port: bad board(0x%lx) count %d.\n",
 			card->base, card->count);
 		card->count = 0;
 	}
 
-	/* last port was closed, shutdown that boad too */
-	if (C_HUPCL(tty)) {
-		if (!card->count)
-			isicom_shutdown_board(card);
+	/* last port was closed, shutdown that board too */
+	if (tty && C_HUPCL(tty)) {
+		/* FIXME: this logic is bogus - it's the old logic that was
+		   bogus before but it still wants fixing */
+		if (!card->count) {
+			if (card->status & BOARD_ACTIVE)
+				card->status &= ~BOARD_ACTIVE;
+		}
 	}
 	tty_kref_put(tty);
 }
@@ -968,7 +933,7 @@ static void isicom_flush_buffer(struct tty_struct *tty)
 	tty_wakeup(tty);
 }
 
-static void isicom_close_port(struct tty_port *port)
+static void isicom_shutdown(struct tty_port *port)
 {
 	struct isi_port *ip = container_of(port, struct isi_port, port);
 	struct isi_board *card = ip->card;
@@ -977,10 +942,8 @@ static void isicom_close_port(struct tty_port *port)
 	/* indicate to the card that no more data can be received
 	   on this port */
 	spin_lock_irqsave(&card->card_lock, flags);
-	if (port->flags & ASYNC_INITIALIZED) {
-		card->port_status &= ~(1 << ip->channel);
-		outw(card->port_status, card->base + 0x02);
-	}
+	card->port_status &= ~(1 << ip->channel);
+	outw(card->port_status, card->base + 0x02);
 	isicom_shutdown_port(ip);
 	spin_unlock_irqrestore(&card->card_lock, flags);
 }
@@ -991,12 +954,7 @@ static void isicom_close(struct tty_struct *tty, struct file *filp)
 	struct tty_port *port = &ip->port;
 	if (isicom_paranoia_check(ip, tty->name, "isicom_close"))
 		return;
-
-	if (tty_port_close_start(port, tty, filp) == 0)
-		return;
-	isicom_close_port(port);
-	isicom_flush_buffer(tty);
-	tty_port_close_end(port, tty);
+	tty_port_close(port, tty, filp);
 }
 
 /* write et all */
@@ -1326,15 +1284,9 @@ static void isicom_start(struct tty_struct *tty)
 static void isicom_hangup(struct tty_struct *tty)
 {
 	struct isi_port *port = tty->driver_data;
-	unsigned long flags;
 
 	if (isicom_paranoia_check(port, tty->name, "isicom_hangup"))
 		return;
-
-	spin_lock_irqsave(&port->card->card_lock, flags);
-	isicom_shutdown_port(port);
-	spin_unlock_irqrestore(&port->card->card_lock, flags);
-
 	tty_port_hangup(&port->port);
 }
 
@@ -1367,6 +1319,8 @@ static const struct tty_operations isicom_ops = {
 static const struct tty_port_operations isicom_port_ops = {
 	.carrier_raised		= isicom_carrier_raised,
 	.dtr_rts		= isicom_dtr_rts,
+	.activate		= isicom_activate,
+	.shutdown		= isicom_shutdown,
 };
 
 static int __devinit reset_card(struct pci_dev *pdev,

