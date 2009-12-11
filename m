Return-Path: <linux-kernel-owner+w=401wt.eu-S934392AbZLKXe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934392AbZLKXe5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:34:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934847AbZLKXeL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:34:11 -0500
Received: from kroah.org ([198.145.64.141]:50466 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934399AbZLKX3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:22 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 39/58] tty: stallion: Convert to the tty_port_open/close methods
Date: Fri, 11 Dec 2009 15:28:23 -0800
Message-Id: <1260574122-10676-39-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

The driver is already structured this way so just slice and dice

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/stallion.c |  116 ++++++++++++++---------------------------------
 1 files changed, 35 insertions(+), 81 deletions(-)

diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index b4ba5ed..0e511d6 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -702,6 +702,24 @@ static struct stlbrd *stl_allocbrd(void)
 
 /*****************************************************************************/
 
+static int stl_activate(struct tty_port *port, struct tty_struct *tty)
+{
+	struct stlport *portp = container_of(port, struct stlport, port);
+	if (!portp->tx.buf) {
+		portp->tx.buf = kmalloc(STL_TXBUFSIZE, GFP_KERNEL);
+		if (!portp->tx.buf)
+			return -ENOMEM;
+		portp->tx.head = portp->tx.buf;
+		portp->tx.tail = portp->tx.buf;
+	}
+	stl_setport(portp, tty->termios);
+	portp->sigs = stl_getsignals(portp);
+	stl_setsignals(portp, 1, 1);
+	stl_enablerxtx(portp, 1, 1);
+	stl_startrxtx(portp, 1, 0);
+	return 0;
+}
+
 static int stl_open(struct tty_struct *tty, struct file *filp)
 {
 	struct stlport	*portp;
@@ -737,32 +755,8 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
 	if (portp == NULL)
 		return -ENODEV;
 	port = &portp->port;
+	return tty_port_open(&portp->port, tty, filp);
 
-/*
- *	On the first open of the device setup the port hardware, and
- *	initialize the per port data structure.
- */
-	tty_port_tty_set(port, tty);
-	tty->driver_data = portp;
-	port->count++;
-
-	if ((port->flags & ASYNC_INITIALIZED) == 0) {
-		if (!portp->tx.buf) {
-			portp->tx.buf = kmalloc(STL_TXBUFSIZE, GFP_KERNEL);
-			if (!portp->tx.buf)
-				return -ENOMEM;
-			portp->tx.head = portp->tx.buf;
-			portp->tx.tail = portp->tx.buf;
-		}
-		stl_setport(portp, tty->termios);
-		portp->sigs = stl_getsignals(portp);
-		stl_setsignals(portp, 1, 1);
-		stl_enablerxtx(portp, 1, 1);
-		stl_startrxtx(portp, 1, 0);
-		clear_bit(TTY_IO_ERROR, &tty->flags);
-		port->flags |= ASYNC_INITIALIZED;
-	}
-	return tty_port_block_til_ready(port, tty, filp);
 }
 
 /*****************************************************************************/
@@ -826,38 +820,12 @@ static void stl_waituntilsent(struct tty_struct *tty, int timeout)
 
 /*****************************************************************************/
 
-static void stl_close(struct tty_struct *tty, struct file *filp)
+static void stl_shutdown(struct tty_port *port)
 {
-	struct stlport	*portp;
-	struct tty_port *port;
-	unsigned long	flags;
-
-	pr_debug("stl_close(tty=%p,filp=%p)\n", tty, filp);
-
-	portp = tty->driver_data;
-	BUG_ON(portp == NULL);
-
-	port = &portp->port;
-
-	if (tty_port_close_start(port, tty, filp) == 0)
-		return;
-/*
- *	May want to wait for any data to drain before closing. The BUSY
- *	flag keeps track of whether we are still sending or not - it is
- *	very accurate for the cd1400, not quite so for the sc26198.
- *	(The sc26198 has no "end-of-data" interrupt only empty FIFO)
- */
-	stl_waituntilsent(tty, (HZ / 2));
-
-	spin_lock_irqsave(&port->lock, flags);
-	portp->port.flags &= ~ASYNC_INITIALIZED;
-	spin_unlock_irqrestore(&port->lock, flags);
-
+	struct stlport *portp = container_of(port, struct stlport, port);
 	stl_disableintrs(portp);
-	if (tty->termios->c_cflag & HUPCL)
-		stl_setsignals(portp, 0, 0);
 	stl_enablerxtx(portp, 0, 0);
-	stl_flushbuffer(tty);
+	stl_flush(portp);
 	portp->istate = 0;
 	if (portp->tx.buf != NULL) {
 		kfree(portp->tx.buf);
@@ -865,9 +833,16 @@ static void stl_close(struct tty_struct *tty, struct file *filp)
 		portp->tx.head = NULL;
 		portp->tx.tail = NULL;
 	}
+}
+
+static void stl_close(struct tty_struct *tty, struct file *filp)
+{
+	struct stlport*portp;
+	pr_debug("stl_close(tty=%p,filp=%p)\n", tty, filp);
 
-	tty_port_close_end(port, tty);
-	tty_port_tty_set(port, NULL);
+	portp = tty->driver_data;
+	BUG_ON(portp == NULL);
+	tty_port_close(&portp->port, tty, filp);
 }
 
 /*****************************************************************************/
@@ -1314,35 +1289,12 @@ static void stl_stop(struct tty_struct *tty)
 
 static void stl_hangup(struct tty_struct *tty)
 {
-	struct stlport	*portp;
-	struct tty_port *port;
-	unsigned long flags;
-
+	struct stlport	*portp = tty->driver_data;
 	pr_debug("stl_hangup(tty=%p)\n", tty);
 
-	portp = tty->driver_data;
 	if (portp == NULL)
 		return;
-	port = &portp->port;
-
-	spin_lock_irqsave(&port->lock, flags);
-	port->flags &= ~ASYNC_INITIALIZED;
-	spin_unlock_irqrestore(&port->lock, flags);
-
-	stl_disableintrs(portp);
-	if (tty->termios->c_cflag & HUPCL)
-		stl_setsignals(portp, 0, 0);
-	stl_enablerxtx(portp, 0, 0);
-	stl_flushbuffer(tty);
-	portp->istate = 0;
-	set_bit(TTY_IO_ERROR, &tty->flags);
-	if (portp->tx.buf != NULL) {
-		kfree(portp->tx.buf);
-		portp->tx.buf = NULL;
-		portp->tx.head = NULL;
-		portp->tx.tail = NULL;
-	}
-	tty_port_hangup(port);
+	tty_port_hangup(&portp->port);
 }
 
 /*****************************************************************************/
@@ -2550,6 +2502,8 @@ static const struct tty_operations stl_ops = {
 static const struct tty_port_operations stl_port_ops = {
 	.carrier_raised = stl_carrier_raised,
 	.dtr_rts = stl_dtr_rts,
+	.activate = stl_activate,
+	.shutdown = stl_shutdown,
 };
 
 /*****************************************************************************/
-- 
1.6.5.5

