Return-Path: <linux-kernel-owner+w=401wt.eu-S1757276AbZKRO1W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276AbZKRO1W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:27:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbZKRO1V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:27:21 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46419 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757211AbZKRO1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:27:18 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 7/7] istallion: tty port open/close methods
To: greg@kroah.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:10:53 +0000
Message-ID: <20091118141052.2798.84055.stgit@localhost.localdomain>
In-Reply-To: <20091118140935.2798.32517.stgit@localhost.localdomain>
References: <20091118140935.2798.32517.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Slice/dice/repeat as with the stallion driver this is just code shuffling
and removal

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/istallion.c |  177 ++++++++++++++++------------------------------
 1 files changed, 60 insertions(+), 117 deletions(-)


diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index babfd44..4cd6c52 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -213,7 +213,6 @@ static int		stli_shared;
  *	with the slave. Most of them need to be updated atomically, so always
  *	use the bit setting operations (unless protected by cli/sti).
  */
-#define	ST_INITIALIZING	1
 #define	ST_OPENING	2
 #define	ST_CLOSING	3
 #define	ST_CMDING	4
@@ -783,13 +782,32 @@ static int stli_parsebrd(struct stlconf *confp, char **argp)
 
 /*****************************************************************************/
 
+/*
+ *	On the first open of the device setup the port hardware, and
+ *	initialize the per port data structure. Since initializing the port
+ *	requires several commands to the board we will need to wait for any
+ *	other open that is already initializing the port.
+ *
+ *	Locking: protected by the port mutex.
+ */
+
+static int stli_activate(struct tty_port *port, struct tty_struct *tty)
+{
+	struct stliport *portp = container_of(port, struct stliport, port);
+	struct stlibrd *brdp = stli_brds[portp->brdnr];
+	int rc;
+
+	if ((rc = stli_initopen(tty, brdp, portp)) >= 0)
+		clear_bit(TTY_IO_ERROR, &tty->flags);
+	wake_up_interruptible(&portp->raw_wait);
+	return rc;
+}
+
 static int stli_open(struct tty_struct *tty, struct file *filp)
 {
 	struct stlibrd *brdp;
 	struct stliport *portp;
-	struct tty_port *port;
 	unsigned int minordev, brdnr, portnr;
-	int rc;
 
 	minordev = tty->index;
 	brdnr = MINOR2BRD(minordev);
@@ -809,95 +827,56 @@ static int stli_open(struct tty_struct *tty, struct file *filp)
 		return -ENODEV;
 	if (portp->devnr < 1)
 		return -ENODEV;
-	port = &portp->port;
-
-/*
- *	On the first open of the device setup the port hardware, and
- *	initialize the per port data structure. Since initializing the port
- *	requires several commands to the board we will need to wait for any
- *	other open that is already initializing the port.
- *
- *	Review - locking
- */
-	tty_port_tty_set(port, tty);
-	tty->driver_data = portp;
-	port->count++;
-
-	wait_event_interruptible(portp->raw_wait,
-			!test_bit(ST_INITIALIZING, &portp->state));
-	if (signal_pending(current))
-		return -ERESTARTSYS;
-
-	if ((portp->port.flags & ASYNC_INITIALIZED) == 0) {
-		set_bit(ST_INITIALIZING, &portp->state);
-		if ((rc = stli_initopen(tty, brdp, portp)) >= 0) {
-			/* Locking */
-			port->flags |= ASYNC_INITIALIZED;
-			clear_bit(TTY_IO_ERROR, &tty->flags);
-		}
-		clear_bit(ST_INITIALIZING, &portp->state);
-		wake_up_interruptible(&portp->raw_wait);
-		if (rc < 0)
-			return rc;
-	}
-	return tty_port_block_til_ready(&portp->port, tty, filp);
+	return tty_port_open(&portp->port, tty, filp);
 }
 
+
 /*****************************************************************************/
 
-static void stli_close(struct tty_struct *tty, struct file *filp)
+static void stli_shutdown(struct tty_port *port)
 {
 	struct stlibrd *brdp;
-	struct stliport *portp;
-	struct tty_port *port;
+	unsigned long ftype;
 	unsigned long flags;
+	struct stliport *portp = container_of(port, struct stliport, port);
 
-	portp = tty->driver_data;
-	if (portp == NULL)
+	if (portp->brdnr >= stli_nrbrds)
 		return;
-	port = &portp->port;
-
-	if (tty_port_close_start(port, tty, filp) == 0)
+	brdp = stli_brds[portp->brdnr];
+	if (brdp == NULL)
 		return;
 
-/*
- *	May want to wait for data to drain before closing. The BUSY flag
- *	keeps track of whether we are still transmitting or not. It is
- *	updated by messages from the slave - indicating when all chars
- *	really have drained.
- */
- 	spin_lock_irqsave(&stli_lock, flags);
-	if (tty == stli_txcooktty)
-		stli_flushchars(tty);
-	spin_unlock_irqrestore(&stli_lock, flags);
-
-	/* We end up doing this twice for the moment. This needs looking at
-	   eventually. Note we still use portp->closing_wait as a result */
-	if (portp->closing_wait != ASYNC_CLOSING_WAIT_NONE)
-		tty_wait_until_sent(tty, portp->closing_wait);
+	/*
+	 *	May want to wait for data to drain before closing. The BUSY
+	 *	flag keeps track of whether we are still transmitting or not.
+	 *	It is updated by messages from the slave - indicating when all
+	 *	chars really have drained.
+	 */
 
-	/* FIXME: port locking here needs attending to */
-	port->flags &= ~ASYNC_INITIALIZED;
+	if (!test_bit(ST_CLOSING, &portp->state))
+		stli_rawclose(brdp, portp, 0, 0);
 
-	brdp = stli_brds[portp->brdnr];
-	stli_rawclose(brdp, portp, 0, 0);
-	if (tty->termios->c_cflag & HUPCL) {
-		stli_mkasysigs(&portp->asig, 0, 0);
-		if (test_bit(ST_CMDING, &portp->state))
-			set_bit(ST_DOSIGS, &portp->state);
-		else
-			stli_sendcmd(brdp, portp, A_SETSIGNALS, &portp->asig,
-				sizeof(asysigs_t), 0);
-	}
+ 	spin_lock_irqsave(&stli_lock, flags);
 	clear_bit(ST_TXBUSY, &portp->state);
 	clear_bit(ST_RXSTOP, &portp->state);
-	set_bit(TTY_IO_ERROR, &tty->flags);
-	tty_ldisc_flush(tty);
-	set_bit(ST_DOFLUSHRX, &portp->state);
-	stli_flushbuffer(tty);
+	spin_unlock_irqrestore(&stli_lock, flags);
 
-	tty_port_close_end(port, tty);
-	tty_port_tty_set(port, NULL);
+	ftype = FLUSHTX | FLUSHRX;
+	stli_cmdwait(brdp, portp, A_FLUSH, &ftype, sizeof(u32), 0);
+}
+
+static void stli_close(struct tty_struct *tty, struct file *filp)
+{
+	struct stliport *portp = tty->driver_data;
+	unsigned long flags;
+	if (portp == NULL)
+		return;
+ 	spin_lock_irqsave(&stli_lock, flags);
+	/*	Flush any internal buffering out first */
+	if (tty == stli_txcooktty)
+		stli_flushchars(tty);
+	spin_unlock_irqrestore(&stli_lock, flags);
+	tty_port_close(&portp->port, tty, filp);
 }
 
 /*****************************************************************************/
@@ -1724,6 +1703,7 @@ static void stli_start(struct tty_struct *tty)
 
 /*****************************************************************************/
 
+
 /*
  *	Hangup this port. This is pretty much like closing the port, only
  *	a little more brutal. No waiting for data to drain. Shutdown the
@@ -1733,47 +1713,8 @@ static void stli_start(struct tty_struct *tty)
 
 static void stli_hangup(struct tty_struct *tty)
 {
-	struct stliport *portp;
-	struct stlibrd *brdp;
-	struct tty_port *port;
-	unsigned long flags;
-
-	portp = tty->driver_data;
-	if (portp == NULL)
-		return;
-	if (portp->brdnr >= stli_nrbrds)
-		return;
-	brdp = stli_brds[portp->brdnr];
-	if (brdp == NULL)
-		return;
-	port = &portp->port;
-
-	spin_lock_irqsave(&port->lock, flags);
-	port->flags &= ~ASYNC_INITIALIZED;
-	spin_unlock_irqrestore(&port->lock, flags);
-
-	if (!test_bit(ST_CLOSING, &portp->state))
-		stli_rawclose(brdp, portp, 0, 0);
-
-	spin_lock_irqsave(&stli_lock, flags);
-	if (tty->termios->c_cflag & HUPCL) {
-		stli_mkasysigs(&portp->asig, 0, 0);
-		if (test_bit(ST_CMDING, &portp->state)) {
-			set_bit(ST_DOSIGS, &portp->state);
-			set_bit(ST_DOFLUSHTX, &portp->state);
-			set_bit(ST_DOFLUSHRX, &portp->state);
-		} else {
-			stli_sendcmd(brdp, portp, A_SETSIGNALSF,
-				&portp->asig, sizeof(asysigs_t), 0);
-		}
-	}
-
-	clear_bit(ST_TXBUSY, &portp->state);
-	clear_bit(ST_RXSTOP, &portp->state);
-	set_bit(TTY_IO_ERROR, &tty->flags);
-	spin_unlock_irqrestore(&stli_lock, flags);
-
-	tty_port_hangup(port);
+	struct stliport *portp = tty->driver_data;
+	tty_port_hangup(&portp->port);
 }
 
 /*****************************************************************************/
@@ -4420,6 +4361,8 @@ static const struct tty_operations stli_ops = {
 static const struct tty_port_operations stli_port_ops = {
 	.carrier_raised = stli_carrier_raised,
 	.dtr_rts = stli_dtr_rts,
+	.activate = stli_activate,
+	.shutdown = stli_shutdown,
 };
 
 /*****************************************************************************/

