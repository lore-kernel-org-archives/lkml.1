Return-Path: <linux-kernel-owner+w=401wt.eu-S1762045AbYFTUV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762045AbYFTUV7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760186AbYFTURn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:17:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51979 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760154AbYFTURl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:17:41 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 17/70] stallion: use tty_port
To: linux-kernel@vger.kernel.org
Date: Fri, 20 Jun 2008 21:00:17 +0100
Message-ID: <20080620200015.1479.22948.stgit@localhost.localdomain>
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

Switch the stallion driver to use the tty_port structure

Signed-off-by: Alan Cox <alan@redhat.com>
---

 drivers/char/stallion.c  |  160 +++++++++++++++++++++++-----------------------
 include/linux/stallion.h |    6 --
 2 files changed, 81 insertions(+), 85 deletions(-)


diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index d17be10..0243efb 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -613,17 +613,17 @@ static void stl_cd_change(struct stlport *portp)
 {
 	unsigned int oldsigs = portp->sigs;
 
-	if (!portp->tty)
+	if (!portp->port.tty)
 		return;
 
 	portp->sigs = stl_getsignals(portp);
 
 	if ((portp->sigs & TIOCM_CD) && ((oldsigs & TIOCM_CD) == 0))
-		wake_up_interruptible(&portp->open_wait);
+		wake_up_interruptible(&portp->port.open_wait);
 
 	if ((oldsigs & TIOCM_CD) && ((portp->sigs & TIOCM_CD) == 0))
-		if (portp->flags & ASYNC_CHECK_CD)
-			tty_hangup(portp->tty);
+		if (portp->port.flags & ASYNC_CHECK_CD)
+			tty_hangup(portp->port.tty);
 }
 
 /*
@@ -734,11 +734,11 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
  *	On the first open of the device setup the port hardware, and
  *	initialize the per port data structure.
  */
-	portp->tty = tty;
+	portp->port.tty = tty;
 	tty->driver_data = portp;
-	portp->refcount++;
+	portp->port.count++;
 
-	if ((portp->flags & ASYNC_INITIALIZED) == 0) {
+	if ((portp->port.flags & ASYNC_INITIALIZED) == 0) {
 		if (!portp->tx.buf) {
 			portp->tx.buf = kmalloc(STL_TXBUFSIZE, GFP_KERNEL);
 			if (!portp->tx.buf)
@@ -752,7 +752,7 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
 		stl_enablerxtx(portp, 1, 1);
 		stl_startrxtx(portp, 1, 0);
 		clear_bit(TTY_IO_ERROR, &tty->flags);
-		portp->flags |= ASYNC_INITIALIZED;
+		portp->port.flags |= ASYNC_INITIALIZED;
 	}
 
 /*
@@ -761,9 +761,9 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
  *	The sleep here does not need interrupt protection since the wakeup
  *	for it is done with the same context.
  */
-	if (portp->flags & ASYNC_CLOSING) {
-		interruptible_sleep_on(&portp->close_wait);
-		if (portp->flags & ASYNC_HUP_NOTIFY)
+	if (portp->port.flags & ASYNC_CLOSING) {
+		interruptible_sleep_on(&portp->port.close_wait);
+		if (portp->port.flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
 		return -ERESTARTSYS;
 	}
@@ -777,7 +777,7 @@ static int stl_open(struct tty_struct *tty, struct file *filp)
 		if ((rc = stl_waitcarrier(portp, filp)) != 0)
 			return rc;
 
-	portp->flags |= ASYNC_NORMAL_ACTIVE;
+	portp->port.flags |= ASYNC_NORMAL_ACTIVE;
 
 	return 0;
 }
@@ -801,25 +801,25 @@ static int stl_waitcarrier(struct stlport *portp, struct file *filp)
 
 	spin_lock_irqsave(&stallion_lock, flags);
 
-	if (portp->tty->termios->c_cflag & CLOCAL)
+	if (portp->port.tty->termios->c_cflag & CLOCAL)
 		doclocal++;
 
 	portp->openwaitcnt++;
 	if (! tty_hung_up_p(filp))
-		portp->refcount--;
+		portp->port.count--;
 
 	for (;;) {
 		/* Takes brd_lock internally */
 		stl_setsignals(portp, 1, 1);
 		if (tty_hung_up_p(filp) ||
-		    ((portp->flags & ASYNC_INITIALIZED) == 0)) {
-			if (portp->flags & ASYNC_HUP_NOTIFY)
+		    ((portp->port.flags & ASYNC_INITIALIZED) == 0)) {
+			if (portp->port.flags & ASYNC_HUP_NOTIFY)
 				rc = -EBUSY;
 			else
 				rc = -ERESTARTSYS;
 			break;
 		}
-		if (((portp->flags & ASYNC_CLOSING) == 0) &&
+		if (((portp->port.flags & ASYNC_CLOSING) == 0) &&
 		    (doclocal || (portp->sigs & TIOCM_CD)))
 			break;
 		if (signal_pending(current)) {
@@ -827,11 +827,11 @@ static int stl_waitcarrier(struct stlport *portp, struct file *filp)
 			break;
 		}
 		/* FIXME */
-		interruptible_sleep_on(&portp->open_wait);
+		interruptible_sleep_on(&portp->port.open_wait);
 	}
 
 	if (! tty_hung_up_p(filp))
-		portp->refcount++;
+		portp->port.count++;
 	portp->openwaitcnt--;
 	spin_unlock_irqrestore(&stallion_lock, flags);
 
@@ -904,15 +904,15 @@ static void stl_close(struct tty_struct *tty, struct file *filp)
 		spin_unlock_irqrestore(&stallion_lock, flags);
 		return;
 	}
-	if ((tty->count == 1) && (portp->refcount != 1))
-		portp->refcount = 1;
-	if (portp->refcount-- > 1) {
+	if ((tty->count == 1) && (portp->port.count != 1))
+		portp->port.count = 1;
+	if (portp->port.count-- > 1) {
 		spin_unlock_irqrestore(&stallion_lock, flags);
 		return;
 	}
 
-	portp->refcount = 0;
-	portp->flags |= ASYNC_CLOSING;
+	portp->port.count = 0;
+	portp->port.flags |= ASYNC_CLOSING;
 
 /*
  *	May want to wait for any data to drain before closing. The BUSY
@@ -930,7 +930,7 @@ static void stl_close(struct tty_struct *tty, struct file *filp)
 
 
 	spin_lock_irqsave(&stallion_lock, flags);
-	portp->flags &= ~ASYNC_INITIALIZED;
+	portp->port.flags &= ~ASYNC_INITIALIZED;
 	spin_unlock_irqrestore(&stallion_lock, flags);
 
 	stl_disableintrs(portp);
@@ -949,16 +949,16 @@ static void stl_close(struct tty_struct *tty, struct file *filp)
 	tty_ldisc_flush(tty);
 
 	tty->closing = 0;
-	portp->tty = NULL;
+	portp->port.tty = NULL;
 
 	if (portp->openwaitcnt) {
 		if (portp->close_delay)
 			msleep_interruptible(jiffies_to_msecs(portp->close_delay));
-		wake_up_interruptible(&portp->open_wait);
+		wake_up_interruptible(&portp->port.open_wait);
 	}
 
-	portp->flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
-	wake_up_interruptible(&portp->close_wait);
+	portp->port.flags &= ~(ASYNC_NORMAL_ACTIVE|ASYNC_CLOSING);
+	wake_up_interruptible(&portp->port.close_wait);
 }
 
 /*****************************************************************************/
@@ -1153,7 +1153,7 @@ static int stl_getserial(struct stlport *portp, struct serial_struct __user *sp)
 	memset(&sio, 0, sizeof(struct serial_struct));
 	sio.line = portp->portnr;
 	sio.port = portp->ioaddr;
-	sio.flags = portp->flags;
+	sio.flags = portp->port.flags;
 	sio.baud_base = portp->baud_base;
 	sio.close_delay = portp->close_delay;
 	sio.closing_wait = portp->closing_wait;
@@ -1194,17 +1194,17 @@ static int stl_setserial(struct stlport *portp, struct serial_struct __user *sp)
 		if ((sio.baud_base != portp->baud_base) ||
 		    (sio.close_delay != portp->close_delay) ||
 		    ((sio.flags & ~ASYNC_USR_MASK) !=
-		    (portp->flags & ~ASYNC_USR_MASK)))
+		    (portp->port.flags & ~ASYNC_USR_MASK)))
 			return -EPERM;
 	} 
 
-	portp->flags = (portp->flags & ~ASYNC_USR_MASK) |
+	portp->port.flags = (portp->port.flags & ~ASYNC_USR_MASK) |
 		(sio.flags & ASYNC_USR_MASK);
 	portp->baud_base = sio.baud_base;
 	portp->close_delay = sio.close_delay;
 	portp->closing_wait = sio.closing_wait;
 	portp->custom_divisor = sio.custom_divisor;
-	stl_setport(portp, portp->tty->termios);
+	stl_setport(portp, portp->port.tty->termios);
 	return 0;
 }
 
@@ -1353,7 +1353,7 @@ static void stl_settermios(struct tty_struct *tty, struct ktermios *old)
 		stl_start(tty);
 	}
 	if (((old->c_cflag & CLOCAL) == 0) && (tiosp->c_cflag & CLOCAL))
-		wake_up_interruptible(&portp->open_wait);
+		wake_up_interruptible(&portp->port.open_wait);
 }
 
 /*****************************************************************************/
@@ -1438,7 +1438,7 @@ static void stl_hangup(struct tty_struct *tty)
 	if (portp == NULL)
 		return;
 
-	portp->flags &= ~ASYNC_INITIALIZED;
+	portp->port.flags &= ~ASYNC_INITIALIZED;
 	stl_disableintrs(portp);
 	if (tty->termios->c_cflag & HUPCL)
 		stl_setsignals(portp, 0, 0);
@@ -1452,10 +1452,10 @@ static void stl_hangup(struct tty_struct *tty)
 		portp->tx.head = NULL;
 		portp->tx.tail = NULL;
 	}
-	portp->tty = NULL;
-	portp->flags &= ~ASYNC_NORMAL_ACTIVE;
-	portp->refcount = 0;
-	wake_up_interruptible(&portp->open_wait);
+	portp->port.tty = NULL;
+	portp->port.flags &= ~ASYNC_NORMAL_ACTIVE;
+	portp->port.count = 0;
+	wake_up_interruptible(&portp->port.open_wait);
 }
 
 /*****************************************************************************/
@@ -1814,8 +1814,8 @@ static int __devinit stl_initports(struct stlbrd *brdp, struct stlpanel *panelp)
 		portp->baud_base = STL_BAUDBASE;
 		portp->close_delay = STL_CLOSEDELAY;
 		portp->closing_wait = 30 * HZ;
-		init_waitqueue_head(&portp->open_wait);
-		init_waitqueue_head(&portp->close_wait);
+		init_waitqueue_head(&portp->port.open_wait);
+		init_waitqueue_head(&portp->port.close_wait);
 		portp->stats.brd = portp->brdnr;
 		portp->stats.panel = portp->panelnr;
 		portp->stats.port = portp->portnr;
@@ -1840,8 +1840,8 @@ static void stl_cleanup_panels(struct stlbrd *brdp)
 			portp = panelp->ports[k];
 			if (portp == NULL)
 				continue;
-			if (portp->tty != NULL)
-				stl_hangup(portp->tty);
+			if (portp->port.tty != NULL)
+				stl_hangup(portp->port.tty);
 			kfree(portp->tx.buf);
 			kfree(portp);
 		}
@@ -2513,7 +2513,7 @@ static int stl_getportstats(struct stlport *portp, comstats_t __user *cp)
 	}
 
 	portp->stats.state = portp->istate;
-	portp->stats.flags = portp->flags;
+	portp->stats.flags = portp->port.flags;
 	portp->stats.hwid = portp->hwid;
 
 	portp->stats.ttystate = 0;
@@ -2524,16 +2524,16 @@ static int stl_getportstats(struct stlport *portp, comstats_t __user *cp)
 	portp->stats.rxbuffered = 0;
 
 	spin_lock_irqsave(&stallion_lock, flags);
-	if (portp->tty != NULL)
-		if (portp->tty->driver_data == portp) {
-			portp->stats.ttystate = portp->tty->flags;
+	if (portp->port.tty != NULL)
+		if (portp->port.tty->driver_data == portp) {
+			portp->stats.ttystate = portp->port.tty->flags;
 			/* No longer available as a statistic */
-			portp->stats.rxbuffered = 1; /*portp->tty->flip.count; */
-			if (portp->tty->termios != NULL) {
-				portp->stats.cflags = portp->tty->termios->c_cflag;
-				portp->stats.iflags = portp->tty->termios->c_iflag;
-				portp->stats.oflags = portp->tty->termios->c_oflag;
-				portp->stats.lflags = portp->tty->termios->c_lflag;
+			portp->stats.rxbuffered = 1; /*portp->port.tty->flip.count; */
+			if (portp->port.tty->termios != NULL) {
+				portp->stats.cflags = portp->port.tty->termios->c_cflag;
+				portp->stats.iflags = portp->port.tty->termios->c_iflag;
+				portp->stats.oflags = portp->port.tty->termios->c_oflag;
+				portp->stats.lflags = portp->port.tty->termios->c_lflag;
 			}
 		}
 	spin_unlock_irqrestore(&stallion_lock, flags);
@@ -2939,15 +2939,15 @@ static void stl_cd1400setport(struct stlport *portp, struct ktermios *tiosp)
 	}
 	baudrate = stl_baudrates[baudrate];
 	if ((tiosp->c_cflag & CBAUD) == B38400) {
-		if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baudrate = 57600;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			baudrate = 115200;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			baudrate = 230400;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			baudrate = 460800;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
 			baudrate = (portp->baud_base / portp->custom_divisor);
 	}
 	if (baudrate > STL_CD1400MAXBAUD)
@@ -2969,9 +2969,9 @@ static void stl_cd1400setport(struct stlport *portp, struct ktermios *tiosp)
 		mcor1 |= MCOR1_DCD;
 		mcor2 |= MCOR2_DCD;
 		sreron |= SRER_MODEM;
-		portp->flags |= ASYNC_CHECK_CD;
+		portp->port.flags |= ASYNC_CHECK_CD;
 	} else
-		portp->flags &= ~ASYNC_CHECK_CD;
+		portp->port.flags &= ~ASYNC_CHECK_CD;
 
 /*
  *	Setup cd1400 enhanced modes if we can. In particular we want to
@@ -3242,7 +3242,7 @@ static void stl_cd1400flowctrl(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->tty;
+	tty = portp->port.tty;
 	if (tty == NULL)
 		return;
 
@@ -3304,7 +3304,7 @@ static void stl_cd1400sendflow(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->tty;
+	tty = portp->port.tty;
 	if (tty == NULL)
 		return;
 
@@ -3503,8 +3503,8 @@ static void stl_cd1400txisr(struct stlpanel *panelp, int ioaddr)
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		if (portp->tty)
-			tty_wakeup(portp->tty);
+		if (portp->port.tty)
+			tty_wakeup(portp->port.tty);
 	}
 
 	if (len == 0) {
@@ -3568,7 +3568,7 @@ static void stl_cd1400rxisr(struct stlpanel *panelp, int ioaddr)
 		return;
 	}
 	portp = panelp->ports[(ioack >> 3)];
-	tty = portp->tty;
+	tty = portp->port.tty;
 
 	if ((ioack & ACK_TYPMASK) == ACK_TYPRXGOOD) {
 		outb((RDCR + portp->uartaddr), ioaddr);
@@ -3613,7 +3613,7 @@ static void stl_cd1400rxisr(struct stlpanel *panelp, int ioaddr)
 			if (portp->rxmarkmsk & status) {
 				if (status & ST_BREAK) {
 					status = TTY_BREAK;
-					if (portp->flags & ASYNC_SAK) {
+					if (portp->port.flags & ASYNC_SAK) {
 						do_SAK(tty);
 						BRDENABLE(portp->brdnr, portp->pagenr);
 					}
@@ -3899,15 +3899,15 @@ static void stl_sc26198setport(struct stlport *portp, struct ktermios *tiosp)
 	}
 	baudrate = stl_baudrates[baudrate];
 	if ((tiosp->c_cflag & CBAUD) == B38400) {
-		if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
+		if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_HI)
 			baudrate = 57600;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_VHI)
 			baudrate = 115200;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_SHI)
 			baudrate = 230400;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_WARP)
 			baudrate = 460800;
-		else if ((portp->flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
+		else if ((portp->port.flags & ASYNC_SPD_MASK) == ASYNC_SPD_CUST)
 			baudrate = (portp->baud_base / portp->custom_divisor);
 	}
 	if (baudrate > STL_SC26198MAXBAUD)
@@ -3922,11 +3922,11 @@ static void stl_sc26198setport(struct stlport *portp, struct ktermios *tiosp)
  *	Check what form of modem signaling is required and set it up.
  */
 	if (tiosp->c_cflag & CLOCAL) {
-		portp->flags &= ~ASYNC_CHECK_CD;
+		portp->port.flags &= ~ASYNC_CHECK_CD;
 	} else {
 		iopr |= IOPR_DCDCOS;
 		imron |= IR_IOPORT;
-		portp->flags |= ASYNC_CHECK_CD;
+		portp->port.flags |= ASYNC_CHECK_CD;
 	}
 
 /*
@@ -4174,7 +4174,7 @@ static void stl_sc26198flowctrl(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->tty;
+	tty = portp->port.tty;
 	if (tty == NULL)
 		return;
 
@@ -4243,7 +4243,7 @@ static void stl_sc26198sendflow(struct stlport *portp, int state)
 
 	if (portp == NULL)
 		return;
-	tty = portp->tty;
+	tty = portp->port.tty;
 	if (tty == NULL)
 		return;
 
@@ -4421,8 +4421,8 @@ static void stl_sc26198txisr(struct stlport *portp)
 	if ((len == 0) || ((len < STL_TXBUFLOW) &&
 	    (test_bit(ASYI_TXLOW, &portp->istate) == 0))) {
 		set_bit(ASYI_TXLOW, &portp->istate);
-		if (portp->tty)
-			tty_wakeup(portp->tty);
+		if (portp->port.tty)
+			tty_wakeup(portp->port.tty);
 	}
 
 	if (len == 0) {
@@ -4475,7 +4475,7 @@ static void stl_sc26198rxisr(struct stlport *portp, unsigned int iack)
 
 	pr_debug("stl_sc26198rxisr(portp=%p,iack=%x)\n", portp, iack);
 
-	tty = portp->tty;
+	tty = portp->port.tty;
 	ioaddr = portp->ioaddr;
 	outb(GIBCR, (ioaddr + XP_ADDR));
 	len = inb(ioaddr + XP_DATA) + 1;
@@ -4527,7 +4527,7 @@ static void stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char
 	struct tty_struct	*tty;
 	unsigned int		ioaddr;
 
-	tty = portp->tty;
+	tty = portp->port.tty;
 	ioaddr = portp->ioaddr;
 
 	if (status & SR_RXPARITY)
@@ -4544,7 +4544,7 @@ static void stl_sc26198rxbadch(struct stlport *portp, unsigned char status, char
 		if (portp->rxmarkmsk & status) {
 			if (status & SR_RXBREAK) {
 				status = TTY_BREAK;
-				if (portp->flags & ASYNC_SAK) {
+				if (portp->port.flags & ASYNC_SAK) {
 					do_SAK(tty);
 					BRDENABLE(portp->brdnr, portp->pagenr);
 				}
diff --git a/include/linux/stallion.h b/include/linux/stallion.h
index 0424d75..336af33 100644
--- a/include/linux/stallion.h
+++ b/include/linux/stallion.h
@@ -69,6 +69,7 @@ struct stlrq {
  */
 struct stlport {
 	unsigned long		magic;
+	struct tty_port		port;
 	unsigned int		portnr;
 	unsigned int		panelnr;
 	unsigned int		brdnr;
@@ -76,12 +77,10 @@ struct stlport {
 	int			uartaddr;
 	unsigned int		pagenr;
 	unsigned long		istate;
-	int			flags;
 	int			baud_base;
 	int			custom_divisor;
 	int			close_delay;
 	int			closing_wait;
-	int			refcount;
 	int			openwaitcnt;
 	int			brklen;
 	unsigned int		sigs;
@@ -92,9 +91,6 @@ struct stlport {
 	unsigned long		clk;
 	unsigned long		hwid;
 	void			*uartp;
-	struct tty_struct	*tty;
-	wait_queue_head_t	open_wait;
-	wait_queue_head_t	close_wait;
 	comstats_t		stats;
 	struct stlrq		tx;
 };

