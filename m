Return-Path: <linux-kernel-owner+w=401wt.eu-S1764165AbXKIXqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764165AbXKIXqU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 18:46:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764284AbXKIXpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 18:45:34 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:57215 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764223AbXKIXpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 18:45:32 -0500
Message-id: <2351011721234832519.slaby@pripojeni.net>
In-reply-to: <10551261882075921134.slaby@pripojeni.net>
Subject: [RFC 4/13] Char: nozomi, tty index cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: <linux-kernel@vger.kernel.org>
Cc: Frank Seidel <fseidel@suse.de>
Date: Fri, 9 Nov 2007 18:45:32 -0500
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

nozomi, tty index cleanup

- don't store unneeded copy of tty->index into port structure, tty->index
  is available everywhere
- mod tty->index by MAX_PORT where expected (otherwise array index out of
  bounds)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 3afb47133874a0979f57928d7450612fa982a6c5
tree 8d9ea282ddbffed0d75c946b3ae046e3bdcc7456
parent 14e887763c076e45f4f768348361a37c10709902
author Jiri Slaby <jirislaby@gmail.com> Sun, 28 Oct 2007 22:15:22 +0100
committer Jiri Slaby <jirislaby@gmail.com> Fri, 09 Nov 2007 23:09:04 +0100

 drivers/char/nozomi.c |   47 +++++++++++++++++++----------------------------
 1 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index e33f21e..d19b5c5 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -411,7 +411,6 @@ struct port {
 	struct semaphore tty_sem;
 	wait_queue_head_t tty_wait;
 	struct async_icount tty_icount;
-	int tty_index;
 };
 
 /* Private data one for each card in the system */
@@ -1782,22 +1781,22 @@ static void __devexit nozomi_card_exit(struct pci_dev *pdev)
 static void set_rts(int index, int rts)
 {
 	struct nozomi *dc = get_dc_by_index(index);
-	int devindex = index % NTTY_TTY_MINORS;
+	struct port *port = &dc->port[index % MAX_PORT];
 
-	dc->port[devindex].ctrl_ul.RTS = rts;
-	dc->port[devindex].update_flow_control = 1;
+	port->ctrl_ul.RTS = rts;
+	port->update_flow_control = 1;
 	enable_transmit_ul(PORT_CTRL, dc);
 }
 
 static void set_dtr(int index, int dtr)
 {
 	struct nozomi *dc = get_dc_by_index(index);
-	int devindex = index % NTTY_TTY_MINORS;
+	struct port *port = &dc->port[index % MAX_PORT];
 
 	DBG1("SETTING DTR index: %d, dtr: %d", index, dtr);
 
-	dc->port[devindex].ctrl_ul.DTR = dtr;
-	dc->port[devindex].update_flow_control = 1;
+	port->ctrl_ul.DTR = dtr;
+	port->update_flow_control = 1;
 	enable_transmit_ul(PORT_CTRL, dc);
 }
 
@@ -1828,7 +1827,6 @@ static int ntty_open(struct tty_struct *tty, struct file *file)
 		tty->low_latency = 1;
 		tty->driver_data = port;
 		port->tty = tty;
-		port->tty_index = tty->index;
 		DBG1("open: %d", port->token_dl);
 		spin_lock_irqsave(&dc->spin_mutex, flags);
 		dc->last_ier =
@@ -1918,14 +1916,13 @@ static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
 	if (port == &(dc->port[PORT_MDM])) {
 		if (port->ctrl_dl.CTS) {
 			DBG4("Enable interrupt");
-			enable_transmit_ul(port->tty_index % NTTY_TTY_MINORS,
-									dc);
+			enable_transmit_ul(tty->index % MAX_PORT, dc);
 		} else {
 			dev_err(&dc->pdev->dev,
 				"CTS not active on modem port?\n");
 		}
 	} else {
-		enable_transmit_ul(port->tty_index % NTTY_TTY_MINORS, dc);
+		enable_transmit_ul(tty->index % MAX_PORT, dc);
 	}
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 
@@ -1980,17 +1977,15 @@ static int ntty_tiocmget(struct tty_struct *tty, struct file *file)
 static int ntty_tiocmset(struct tty_struct *tty, struct file *file,
 	unsigned int set, unsigned int clear)
 {
-	struct port *port = (struct port *)tty->driver_data;
-
 	if (set & TIOCM_RTS)
-		set_rts(port->tty_index, 1);
+		set_rts(tty->index, 1);
 	else if (clear & TIOCM_RTS)
-		set_rts(port->tty_index, 0);
+		set_rts(tty->index, 0);
 
 	if (set & TIOCM_DTR)
-		set_dtr(port->tty_index, 1);
+		set_dtr(tty->index, 1);
 	else if (clear & TIOCM_DTR)
-		set_dtr(port->tty_index, 0);
+		set_dtr(tty->index, 0);
 
 	return 0;
 }
@@ -2064,7 +2059,6 @@ static int ntty_ioctl_tiocgicount(struct tty_struct *tty, struct file *file,
 static int ntty_ioctl(struct tty_struct *tty, struct file *file,
 		      unsigned int cmd, unsigned long arg)
 {
-	struct port *port = tty->driver_data;
 	struct nozomi *dc = get_dc_by_tty(tty);
 	unsigned long flags;
 	int mask;
@@ -2094,9 +2088,9 @@ static int ntty_ioctl(struct tty_struct *tty, struct file *file,
 
 		spin_lock_irqsave(&dc->spin_mutex, flags);
 		if (mask & TIOCM_RTS)
-			set_rts(port->tty_index, 0);
+			set_rts(tty->index, 0);
 		if (mask & TIOCM_DTR)
-			set_dtr(port->tty_index, 0);
+			set_dtr(tty->index, 0);
 		spin_unlock_irqrestore(&dc->spin_mutex, flags);
 		rval = 0;
 		break;
@@ -2106,9 +2100,9 @@ static int ntty_ioctl(struct tty_struct *tty, struct file *file,
 
 		spin_lock_irqsave(&dc->spin_mutex, flags);
 		if (mask & TIOCM_RTS)
-			set_rts(port->tty_index, 1);
+			set_rts(tty->index, 1);
 		if (mask & TIOCM_DTR)
-			set_dtr(port->tty_index, 1);
+			set_dtr(tty->index, 1);
 		spin_unlock_irqrestore(&dc->spin_mutex, flags);
 		rval = 0;
 		break;
@@ -2126,15 +2120,13 @@ static int ntty_ioctl(struct tty_struct *tty, struct file *file,
  */
 static void ntty_unthrottle(struct tty_struct *tty)
 {
-	struct port *port = (struct port *)tty->driver_data;
 	struct nozomi *dc = get_dc_by_tty(tty);
 	unsigned long flags;
 
 	DBG1("UNTHROTTLE");
 	spin_lock_irqsave(&dc->spin_mutex, flags);
-	enable_transmit_dl(port->tty_index % NTTY_TTY_MINORS, dc);
-	set_rts(port->tty_index, 1);
-
+	enable_transmit_dl(tty->index % MAX_PORT, dc);
+	set_rts(tty->index, 1);
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 }
 
@@ -2144,13 +2136,12 @@ static void ntty_unthrottle(struct tty_struct *tty)
  */
 static void ntty_throttle(struct tty_struct *tty)
 {
-	struct port *port = (struct port *)tty->driver_data;
 	struct nozomi *dc = get_dc_by_tty(tty);
 	unsigned long flags;
 
 	DBG1("THROTTLE");
 	spin_lock_irqsave(&dc->spin_mutex, flags);
-	set_rts(port->tty_index, 0);
+	set_rts(tty->index, 0);
 	spin_unlock_irqrestore(&dc->spin_mutex, flags);
 }
 
