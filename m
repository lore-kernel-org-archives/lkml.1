Return-Path: <linux-kernel-owner+w=401wt.eu-S933514AbXHVUuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933514AbXHVUuk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2007 16:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763078AbXHVUu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Aug 2007 16:50:29 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:37787 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756677AbXHVUu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2007 16:50:28 -0400
Message-id: <691626578543930699@wsc.cz>
In-reply-to: <2817865042758628064@wsc.cz>
Subject: [PATCH 2/3] Char: moxa, function names cleanup
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 22 Aug 2007 22:51:57 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

moxa, function names cleanup

prepend moxa_ to all moxa functions which laxes this

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit e55700b17d5769d01c935fe6ba54d9562b934591
tree e57b9e6740d250f53709dcc0a8d17925215185bd
parent 447cc94f68ae6cf1f5f7603e4dad518e2398b3d8
author Jiri Slaby <jirislaby@gmail.com> Sat, 18 Aug 2007 16:04:35 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 18 Aug 2007 16:04:35 +0200

 drivers/char/moxa.c |   62 ++++++++++++++++++++++++++-------------------------
 1 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 3bc8c68..40ac6de 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -206,13 +206,13 @@ static int moxa_tiocmget(struct tty_struct *tty, struct file *file);
 static int moxa_tiocmset(struct tty_struct *tty, struct file *file,
 			 unsigned int set, unsigned int clear);
 static void moxa_poll(unsigned long);
-static void set_tty_param(struct tty_struct *);
-static int block_till_ready(struct tty_struct *, struct file *,
+static void moxa_set_tty_param(struct tty_struct *);
+static int moxa_block_till_ready(struct tty_struct *, struct file *,
 			    struct moxa_port *);
-static void setup_empty_event(struct tty_struct *);
-static void check_xmit_empty(unsigned long);
-static void shut_down(struct moxa_port *);
-static void receive_data(struct moxa_port *);
+static void moxa_setup_empty_event(struct tty_struct *);
+static void moxa_check_xmit_empty(unsigned long);
+static void moxa_shut_down(struct moxa_port *);
+static void moxa_receive_data(struct moxa_port *);
 /*
  * moxa board interface functions:
  */
@@ -376,7 +376,7 @@ static int __init moxa_init(void)
 		init_waitqueue_head(&ch->open_wait);
 		init_waitqueue_head(&ch->close_wait);
 
-		setup_timer(&ch->emptyTimer, check_xmit_empty,
+		setup_timer(&ch->emptyTimer, moxa_check_xmit_empty,
 				(unsigned long)ch);
 	}
 
@@ -499,12 +499,12 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	ch->tty = tty;
 	if (!(ch->asyncflags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
-		set_tty_param(tty);
+		moxa_set_tty_param(tty);
 		MoxaPortLineCtrl(ch->port, 1, 1);
 		MoxaPortEnable(ch->port);
 		ch->asyncflags |= ASYNC_INITIALIZED;
 	}
-	retval = block_till_ready(tty, filp, ch);
+	retval = moxa_block_till_ready(tty, filp, ch);
 
 	moxa_unthrottle(tty);
 
@@ -556,11 +556,11 @@ static void moxa_close(struct tty_struct *tty, struct file *filp)
 
 	ch->cflag = tty->termios->c_cflag;
 	if (ch->asyncflags & ASYNC_INITIALIZED) {
-		setup_empty_event(tty);
+		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 30 * HZ);	/* 30 seconds timeout */
 		del_timer_sync(&moxa_ports[ch->port].emptyTimer);
 	}
-	shut_down(ch);
+	moxa_shut_down(ch);
 	MoxaPortFlushData(port, 2);
 
 	if (tty->driver->flush_buffer)
@@ -646,7 +646,7 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 		 * in tty_ioctl.c, etc.
 		 */
 		if (!(ch->statusflags & EMPTYWAIT))
-			setup_empty_event(tty);
+			moxa_setup_empty_event(tty);
 	}
 	return (chars);
 }
@@ -744,7 +744,7 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		retval = tty_check_change(tty);
 		if (retval)
 			return (retval);
-		setup_empty_event(tty);
+		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
 		if (!arg)
 			MoxaPortSendBreak(ch->port, 0);
@@ -753,7 +753,7 @@ static int moxa_ioctl(struct tty_struct *tty, struct file *file,
 		retval = tty_check_change(tty);
 		if (retval)
 			return (retval);
-		setup_empty_event(tty);
+		moxa_setup_empty_event(tty);
 		tty_wait_until_sent(tty, 0);
 		MoxaPortSendBreak(ch->port, arg);
 		return (0);
@@ -802,7 +802,7 @@ static void moxa_set_termios(struct tty_struct *tty,
 
 	if (ch == NULL)
 		return;
-	set_tty_param(tty);
+	moxa_set_tty_param(tty);
 	if (!(old_termios->c_cflag & CLOCAL) &&
 	    (tty->termios->c_cflag & CLOCAL))
 		wake_up_interruptible(&ch->open_wait);
@@ -838,7 +838,7 @@ static void moxa_hangup(struct tty_struct *tty)
 	struct moxa_port *ch = (struct moxa_port *) tty->driver_data;
 
 	moxa_flush_buffer(tty);
-	shut_down(ch);
+	moxa_shut_down(ch);
 	ch->event = 0;
 	ch->count = 0;
 	ch->asyncflags &= ~ASYNC_NORMAL_ACTIVE;
@@ -868,7 +868,7 @@ static void moxa_poll(unsigned long ignored)
 				continue;
 			if (!(ch->statusflags & THROTTLE) &&
 			    (MoxaPortRxQueue(ch->port) > 0))
-				receive_data(ch);
+				moxa_receive_data(ch);
 			if ((tp = ch->tty) == 0)
 				continue;
 			if (ch->statusflags & LOWWAIT) {
@@ -902,7 +902,7 @@ static void moxa_poll(unsigned long ignored)
 
 /******************************************************************************/
 
-static void set_tty_param(struct tty_struct *tty)
+static void moxa_set_tty_param(struct tty_struct *tty)
 {
 	register struct ktermios *ts;
 	struct moxa_port *ch;
@@ -927,7 +927,7 @@ static void set_tty_param(struct tty_struct *tty)
 	MoxaPortSetTermio(ch->port, ts, tty_get_baud_rate(tty));
 }
 
-static int block_till_ready(struct tty_struct *tty, struct file *filp,
+static int moxa_block_till_ready(struct tty_struct *tty, struct file *filp,
 			    struct moxa_port *ch)
 {
 	DECLARE_WAITQUEUE(wait,current);
@@ -1013,7 +1013,7 @@ static int block_till_ready(struct tty_struct *tty, struct file *filp,
 	return 0;
 }
 
-static void setup_empty_event(struct tty_struct *tty)
+static void moxa_setup_empty_event(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
 	unsigned long flags;
@@ -1024,7 +1024,7 @@ static void setup_empty_event(struct tty_struct *tty)
 	spin_unlock_irqrestore(&moxa_lock, flags);
 }
 
-static void check_xmit_empty(unsigned long data)
+static void moxa_check_xmit_empty(unsigned long data)
 {
 	struct moxa_port *ch;
 
@@ -1041,7 +1041,7 @@ static void check_xmit_empty(unsigned long data)
 		ch->statusflags &= ~EMPTYWAIT;
 }
 
-static void shut_down(struct moxa_port *ch)
+static void moxa_shut_down(struct moxa_port *ch)
 {
 	struct tty_struct *tp;
 
@@ -1061,7 +1061,7 @@ static void shut_down(struct moxa_port *ch)
 	ch->asyncflags &= ~ASYNC_INITIALIZED;
 }
 
-static void receive_data(struct moxa_port *ch)
+static void moxa_receive_data(struct moxa_port *ch)
 {
 	struct tty_struct *tp;
 	struct ktermios *ts;
@@ -1395,8 +1395,8 @@ static struct mon_str moxaLog;
 static int moxaFuncTout = HZ / 2;
 
 static void moxafunc(void __iomem *, int, ushort);
-static void wait_finish(void __iomem *);
-static void low_water_check(void __iomem *);
+static void moxa_wait_finish(void __iomem *);
+static void moxa_low_water_check(void __iomem *);
 static int moxaloadbios(int, unsigned char __user *, int);
 static int moxafindcard(int);
 static int moxaload320b(int, unsigned char __user *, int);
@@ -1462,7 +1462,7 @@ void MoxaPortFlushData(int port, int mode)
 	moxafunc(ofsAddr, FC_FlushQueue, mode);
 	if (mode != 1) {
 		moxa_ports[port].lowChkFlag = 0;
-		low_water_check(ofsAddr);
+		moxa_low_water_check(ofsAddr);
 	}
 }
 
@@ -1643,7 +1643,7 @@ int MoxaDriverPoll(void)
 				if (moxa_ports[p].lowChkFlag) {
 					moxa_ports[p].lowChkFlag = 0;
 					ofsAddr = moxa_ports[p].tableAddr;
-					low_water_check(ofsAddr);
+					moxa_low_water_check(ofsAddr);
 				}
 			}
 		}
@@ -2070,7 +2070,7 @@ int MoxaPortSetTermio(int port, struct ktermios *termio, speed_t baud)
 		writeb(termio->c_cc[VSTART], ofsAddr + FuncArg);
 		writeb(termio->c_cc[VSTOP], ofsAddr + FuncArg1);
 		writeb(FC_SetXonXoff, ofsAddr + FuncCode);
-		wait_finish(ofsAddr);
+		moxa_wait_finish(ofsAddr);
 
 	}
 	return (0);
@@ -2469,10 +2469,10 @@ static void moxafunc(void __iomem *ofsAddr, int cmd, ushort arg)
 
 	writew(arg, ofsAddr + FuncArg);
 	writew(cmd, ofsAddr + FuncCode);
-	wait_finish(ofsAddr);
+	moxa_wait_finish(ofsAddr);
 }
 
-static void wait_finish(void __iomem *ofsAddr)
+static void moxa_wait_finish(void __iomem *ofsAddr)
 {
 	unsigned long i, j;
 
@@ -2485,7 +2485,7 @@ static void wait_finish(void __iomem *ofsAddr)
 	}
 }
 
-static void low_water_check(void __iomem *ofsAddr)
+static void moxa_low_water_check(void __iomem *ofsAddr)
 {
 	int len;
 	ushort rptr, wptr, mask;
