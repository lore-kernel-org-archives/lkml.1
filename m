Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbYBGTPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbYBGTPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 14:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759020AbYBGTON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 14:14:13 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:39214 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933121AbYBGTOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 14:14:10 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: "Oyvind Aabling" <Oyvind.Aabling@uni-c.dk>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>
Subject: [RFT 5/9] Char: moxa, little cleanup
Date: Thu,  7 Feb 2008 20:11:21 +0100
Message-Id: <1202411485-16022-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
References: <1202411485-16022-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup of
- whitespace
- macros
- useless casts
- return (sth); -> return sth;
- types
- superfluous parenthesis and braces
- init tmp directly in moxa_get_serial_info
- commented defunct code
- commented prototypes

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/moxa.c |  158 ++++++++++++++++++---------------------------------
 1 files changed, 55 insertions(+), 103 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 5a55b8c..d123827 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -54,7 +54,6 @@
 #define MOXA_FW_HDRLEN		32
 
 #define MOXAMAJOR		172
-#define MOXACUMAJOR		173
 
 #define MAX_BOARDS		4	/* Don't change this value */
 #define MAX_PORTS_PER_BOARD	32	/* Don't change this value */
@@ -246,7 +245,7 @@ static void moxa_wait_finish(void __iomem *ofsAddr)
 		printk(KERN_WARNING "moxa function expired\n");
 }
 
-static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
+static void moxafunc(void __iomem *ofsAddr, u16 cmd, u16 arg)
 {
 	writew(arg, ofsAddr + FuncArg);
 	writew(cmd, ofsAddr + FuncCode);
@@ -947,7 +946,7 @@ static int __devinit moxa_pci_probe(struct pci_dev *pdev,
 
 	pci_set_drvdata(pdev, board);
 
-	return (0);
+	return 0;
 err_base:
 	iounmap(board->basemem);
 	board->basemem = NULL;
@@ -998,10 +997,8 @@ static int __init moxa_init(void)
 	moxaDriver->flags = TTY_DRIVER_REAL_RAW;
 	tty_set_operations(moxaDriver, &moxa_ops);
 
-	pr_debug("Moxa tty devices major number = %d\n", ttymajor);
-
 	if (tty_register_driver(moxaDriver)) {
-		printk(KERN_ERR "Couldn't install MOXA Smartio family driver !\n");
+		printk(KERN_ERR "can't register MOXA Smartio tty driver!\n");
 		put_tty_driver(moxaDriver);
 		return -1;
 	}
@@ -1055,7 +1052,7 @@ static int __init moxa_init(void)
 
 static void __exit moxa_exit(void)
 {
-	int i;
+	unsigned int i;
 
 #ifdef CONFIG_PCI
 	pci_unregister_driver(&moxa_pci_driver);
@@ -1210,12 +1207,8 @@ static int moxa_write(struct tty_struct *tty,
 	len = MoxaPortWriteData(ch, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
-	/*********************************************
-	if ( !(ch->statusflags & LOWWAIT) &&
-	     ((len != count) || (MoxaPortTxFree(port) <= 100)) )
-	************************************************/
 	ch->statusflags |= LOWWAIT;
-	return (len);
+	return len;
 }
 
 static int moxa_write_room(struct tty_struct *tty)
@@ -1223,10 +1216,10 @@ static int moxa_write_room(struct tty_struct *tty)
 	struct moxa_port *ch;
 
 	if (tty->stopped)
-		return (0);
+		return 0;
 	ch = tty->driver_data;
 	if (ch == NULL)
-		return (0);
+		return 0;
 	return MoxaPortTxFree(ch);
 }
 
@@ -1252,7 +1245,7 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 	 * routine.  And since the open() failed, we return 0 here.  TDJ
 	 */
 	if (ch == NULL)
-		return (0);
+		return 0;
 	chars = MoxaPortTxQueue(ch);
 	if (chars) {
 		/*
@@ -1262,7 +1255,7 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 		if (!(ch->statusflags & EMPTYWAIT))
 			moxa_setup_empty_event(tty);
 	}
-	return (chars);
+	return chars;
 }
 
 static void moxa_flush_chars(struct tty_struct *tty)
@@ -1282,9 +1275,7 @@ static void moxa_put_char(struct tty_struct *tty, unsigned char c)
 	spin_lock_bh(&moxa_lock);
 	MoxaPortWriteData(ch, &c, 1);
 	spin_unlock_bh(&moxa_lock);
-	/************************************************
-	if ( !(ch->statusflags & LOWWAIT) && (MoxaPortTxFree(port) <= 100) )
-	*************************************************/
+
 	ch->statusflags |= LOWWAIT;
 }
 
@@ -1337,34 +1328,33 @@ static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 
 static void moxa_throttle(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	ch->statusflags |= THROTTLE;
 }
 
 static void moxa_unthrottle(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	ch->statusflags &= ~THROTTLE;
 }
 
 static void moxa_set_termios(struct tty_struct *tty,
-			     struct ktermios *old_termios)
+		struct ktermios *old_termios)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
 	moxa_set_tty_param(tty, old_termios);
-	if (!(old_termios->c_cflag & CLOCAL) &&
-	    (tty->termios->c_cflag & CLOCAL))
+	if (!(old_termios->c_cflag & CLOCAL) && C_CLOCAL(tty))
 		wake_up_interruptible(&ch->open_wait);
 }
 
 static void moxa_stop(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -1375,7 +1365,7 @@ static void moxa_stop(struct tty_struct *tty)
 
 static void moxa_start(struct tty_struct *tty)
 {
-	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 
 	if (ch == NULL)
 		return;
@@ -1403,7 +1393,7 @@ static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
 {
 	dcd = !!dcd;
 
-	if ((dcd != p->DCDState) && p->tty && C_CLOCAL(p->tty)) {
+	if (dcd != p->DCDState && p->tty && C_CLOCAL(p->tty)) {
 		if (!dcd)
 			tty_hangup(p->tty);
 		wake_up_interruptible(&p->open_wait);
@@ -1513,12 +1503,10 @@ static void moxa_poll(unsigned long ignored)
 
 static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	register struct ktermios *ts;
-	struct moxa_port *ch;
+	register struct ktermios *ts = tty->termios;
+	struct moxa_port *ch = tty->driver_data;
 	int rts, cts, txflow, rxflow, xany, baud;
 
-	ch = (struct moxa_port *) tty->driver_data;
-	ts = tty->termios;
 	rts = cts = txflow = rxflow = xany = 0;
 	if (ts->c_cflag & CRTSCTS)
 		rts = cts = 1;
@@ -1575,7 +1563,7 @@ static void moxa_shut_down(struct moxa_port *ch)
 static void MoxaPortFlushData(struct moxa_port *port, int mode)
 {
 	void __iomem *ofsAddr;
-	if ((mode < 0) || (mode > 2))
+	if (mode < 0 || mode > 2)
 		return;
 	ofsAddr = port->tableAddr;
 	moxafunc(ofsAddr, FC_FlushQueue, mode);
@@ -1585,27 +1573,6 @@ static void MoxaPortFlushData(struct moxa_port *port, int mode)
 	}
 }
 
-/*****************************************************************************
- *	Port level functions:						     *
- *	2.  MoxaPortEnable(int port);					     *
- *	3.  MoxaPortDisable(int port);					     *
- *	4.  MoxaPortGetMaxBaud(int port);				     *
- *	6.  MoxaPortSetBaud(int port, long baud);			     *
- *	8.  MoxaPortSetTermio(int port, unsigned char *termio); 	     *
- *	9.  MoxaPortGetLineOut(int port, int *dtrState, int *rtsState);      *
- *	10. MoxaPortLineCtrl(int port, int dtrState, int rtsState);	     *
- *	11. MoxaPortFlowCtrl(int port, int rts, int cts, int rx, int tx,int xany);    *
- *	12. MoxaPortLineStatus(int port);				     *
- *	15. MoxaPortFlushData(int port, int mode);	                     *
- *	16. MoxaPortWriteData(int port, unsigned char * buffer, int length); *
- *	17. MoxaPortReadData(int port, struct tty_struct *tty); 	     *
- *	20. MoxaPortTxQueue(int port);					     *
- *	21. MoxaPortTxFree(int port);					     *
- *	22. MoxaPortRxQueue(int port);					     *
- *	24. MoxaPortTxDisable(int port);				     *
- *	25. MoxaPortTxEnable(int port); 				     *
- *	27. MoxaPortResetBrkCnt(int port);				     *
- *****************************************************************************/
 /*
  *    Moxa Port Number Description:
  *
@@ -1810,16 +1777,16 @@ static void MoxaPortFlushData(struct moxa_port *port, int mode)
 static void MoxaPortEnable(struct moxa_port *port)
 {
 	void __iomem *ofsAddr;
-	short lowwater = 512;
+	u16 lowwater = 512;
 
 	ofsAddr = port->tableAddr;
 	writew(lowwater, ofsAddr + Low_water);
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
-	    port->board->boardType == MOXA_BOARD_C320_PCI) {
+			port->board->boardType == MOXA_BOARD_C320_PCI)
 		moxafunc(ofsAddr, FC_SetBreakIrq, 0);
-	} else {
-		writew(readw(ofsAddr + HostStat) | WakeupBreak, ofsAddr + HostStat);
-	}
+	else
+		writew(readw(ofsAddr + HostStat) | WakeupBreak,
+				ofsAddr + HostStat);
 
 	moxafunc(ofsAddr, FC_SetLineIrq, Magic_code);
 	moxafunc(ofsAddr, FC_FlushQueue, 2);
@@ -1842,9 +1809,9 @@ static long MoxaPortGetMaxBaud(struct moxa_port *port)
 {
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
 			port->board->boardType == MOXA_BOARD_C320_PCI)
-		return (460800L);
+		return 460800L;
 	else
-		return (921600L);
+		return 921600L;
 }
 
 
@@ -1854,8 +1821,8 @@ static long MoxaPortSetBaud(struct moxa_port *port, long baud)
 	long max, clock;
 	unsigned int val;
 
-	if ((baud < 50L) || ((max = MoxaPortGetMaxBaud(port)) == 0))
-		return (0);
+	if (baud < 50L || (max = MoxaPortGetMaxBaud(port)) == 0)
+		return 0;
 	ofsAddr = port->tableAddr;
 	if (baud > max)
 		baud = max;
@@ -1868,7 +1835,7 @@ static long MoxaPortSetBaud(struct moxa_port *port, long baud)
 	val = clock / baud;
 	moxafunc(ofsAddr, FC_SetBaud, val);
 	baud = clock / val;
-	return (baud);
+	return baud;
 }
 
 static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
@@ -1907,12 +1874,12 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 	} else
 		mode |= MX_PARNONE;
 
-	moxafunc(ofsAddr, FC_SetDataMode, (ushort) mode);
+	moxafunc(ofsAddr, FC_SetDataMode, (u16)mode);
 
 	if (port->board->boardType == MOXA_BOARD_C320_ISA ||
 			port->board->boardType == MOXA_BOARD_C320_PCI) {
 		if (baud >= 921600L)
-			return (-1);
+			return -1;
 	}
 	baud = MoxaPortSetBaud(port, baud);
 
@@ -1923,24 +1890,23 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 		moxa_wait_finish(ofsAddr);
 
 	}
-	return (baud);
+	return baud;
 }
 
 static int MoxaPortGetLineOut(struct moxa_port *port, int *dtrState,
 		int *rtsState)
 {
-
 	if (dtrState)
 		*dtrState = !!(port->lineCtrl & DTR_ON);
 	if (rtsState)
 		*rtsState = !!(port->lineCtrl & RTS_ON);
 
-	return (0);
+	return 0;
 }
 
 static void MoxaPortLineCtrl(struct moxa_port *port, int dtr, int rts)
 {
-	int mode = 0;
+	u8 mode = 0;
 
 	if (dtr)
 		mode |= DTR_ON;
@@ -2152,60 +2118,46 @@ static void MoxaPortTxEnable(struct moxa_port *port)
 }
 
 static int moxa_get_serial_info(struct moxa_port *info,
-				struct serial_struct __user *retinfo)
+		struct serial_struct __user *retinfo)
 {
-	struct serial_struct tmp;
-
-	memset(&tmp, 0, sizeof(tmp));
-	tmp.type = info->type;
-	tmp.line = info->tty->index;
-	tmp.port = 0;
-	tmp.irq = 0;
-	tmp.flags = info->asyncflags;
-	tmp.baud_base = 921600;
-	tmp.close_delay = info->close_delay;
-	tmp.custom_divisor = 0;
-	tmp.hub6 = 0;
-	if(copy_to_user(retinfo, &tmp, sizeof(*retinfo)))
-		return -EFAULT;
-	return (0);
+	struct serial_struct tmp = {
+		.type = info->type,
+		.line = info->tty->index,
+		.flags = info->asyncflags,
+		.baud_base = 921600,
+		.close_delay = info->close_delay
+	};
+	return copy_to_user(retinfo, &tmp, sizeof(*retinfo)) ? -EFAULT : 0;
 }
 
 
 static int moxa_set_serial_info(struct moxa_port *info,
-				struct serial_struct __user *new_info)
+		struct serial_struct __user *new_info)
 {
 	struct serial_struct new_serial;
 
-	if(copy_from_user(&new_serial, new_info, sizeof(new_serial)))
+	if (copy_from_user(&new_serial, new_info, sizeof(new_serial)))
 		return -EFAULT;
 
-	if ((new_serial.irq != 0) ||
-	    (new_serial.port != 0) ||
-//           (new_serial.type != info->type) ||
-	    (new_serial.custom_divisor != 0) ||
-	    (new_serial.baud_base != 921600))
-		return (-EPERM);
+	if (new_serial.irq != 0 || new_serial.port != 0 ||
+			new_serial.custom_divisor != 0 ||
+			new_serial.baud_base != 921600)
+		return -EPERM;
 
 	if (!capable(CAP_SYS_ADMIN)) {
 		if (((new_serial.flags & ~ASYNC_USR_MASK) !=
 		     (info->asyncflags & ~ASYNC_USR_MASK)))
-			return (-EPERM);
-	} else {
+			return -EPERM;
+	} else
 		info->close_delay = new_serial.close_delay * HZ / 100;
-	}
 
 	new_serial.flags = (new_serial.flags & ~ASYNC_FLAGS);
 	new_serial.flags |= (info->asyncflags & ASYNC_FLAGS);
 
-	if (new_serial.type == PORT_16550A) {
-		MoxaSetFifo(info, 1);
-	} else {
-		MoxaSetFifo(info, 0);
-	}
+	MoxaSetFifo(info, new_serial.type == PORT_16550A);
 
 	info->type = new_serial.type;
-	return (0);
+	return 0;
 }
 
 
-- 
1.5.3.8

