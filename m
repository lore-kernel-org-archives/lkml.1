Return-Path: <linux-kernel-owner+w=401wt.eu-S934565AbZLKXce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934565AbZLKXce (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934463AbZLKXca
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:32:30 -0500
Received: from kroah.org ([198.145.64.141]:50524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934458AbZLKX3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:32 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 49/58] tty: moxa: Locking clean up
Date: Fri, 11 Dec 2009 15:28:33 -0800
Message-Id: <1260574122-10676-49-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

- The open lock is needed to fix up the case of a board reset occuring during
  tty open but too early for a sane hangup response.
- The lock can however got for other cases
- Use the port mutex for get/setserial
- Fix up the confused lack of locking on the THROTTLE and other bits in the
  private flags. Just use set/test/clear bit and it covers the cases we need

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/moxa.c |   58 ++++++++++++++++++++++-----------------------------
 1 files changed, 25 insertions(+), 33 deletions(-)

diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 474d936..7ab720f 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -151,10 +151,10 @@ struct mon_str {
 };
 
 /* statusflags */
-#define TXSTOPPED	0x1
-#define LOWWAIT 	0x2
-#define EMPTYWAIT	0x4
-#define THROTTLE	0x8
+#define TXSTOPPED	1
+#define LOWWAIT 	2
+#define EMPTYWAIT	3
+#define THROTTLE	4
 
 #define SERIAL_DO_RESTART
 
@@ -235,6 +235,8 @@ static void MoxaSetFifo(struct moxa_port *port, int enable);
  * I/O functions
  */
 
+static DEFINE_SPINLOCK(moxafunc_lock);
+
 static void moxa_wait_finish(void __iomem *ofsAddr)
 {
 	unsigned long end = jiffies + moxaFuncTout;
@@ -381,14 +383,14 @@ copy:
 		break;
 	}
 	case TIOCGSERIAL:
-		mutex_lock(&moxa_openlock);
+	        mutex_lock(&ch->port.mutex);
 		ret = moxa_get_serial_info(ch, argp);
-		mutex_unlock(&moxa_openlock);
+		mutex_unlock(&ch->port.mutex);
 		break;
 	case TIOCSSERIAL:
-		mutex_lock(&moxa_openlock);
+	        mutex_lock(&ch->port.mutex);
 		ret = moxa_set_serial_info(ch, argp);
-		mutex_unlock(&moxa_openlock);
+		mutex_unlock(&ch->port.mutex);
 		break;
 	default:
 		ret = -ENOIOCTLCMD;
@@ -433,7 +435,6 @@ static const struct tty_port_operations moxa_port_ops = {
 static struct tty_driver *moxaDriver;
 static DEFINE_TIMER(moxaTimer, moxa_poll, 0, 0);
 static DEFINE_SPINLOCK(moxa_lock);
-static DEFINE_SPINLOCK(moxafunc_lock);
 
 /*
  * HW init
@@ -1208,9 +1209,7 @@ static void moxa_close(struct tty_struct *tty, struct file *filp)
 {
 	struct moxa_port *ch = tty->driver_data;
 	ch->cflag = tty->termios->c_cflag;
-	mutex_lock(&moxa_openlock);
 	tty_port_close(&ch->port, tty, filp);
-	mutex_unlock(&moxa_openlock);
 }
 
 static int moxa_write(struct tty_struct *tty,
@@ -1226,7 +1225,7 @@ static int moxa_write(struct tty_struct *tty,
 	len = MoxaPortWriteData(tty, buf, count);
 	spin_unlock_bh(&moxa_lock);
 
-	ch->statusflags |= LOWWAIT;
+	set_bit(LOWWAIT, &ch->statusflags);
 	return len;
 }
 
@@ -1264,7 +1263,7 @@ static int moxa_chars_in_buffer(struct tty_struct *tty)
 		 * Make it possible to wakeup anything waiting for output
 		 * in tty_ioctl.c, etc.
 		 */
-		if (!(ch->statusflags & EMPTYWAIT))
+		if (!test_bit(EMPTYWAIT, &ch->statusflags))
 			moxa_setup_empty_event(tty);
 	}
 	unlock_kernel();
@@ -1332,14 +1331,14 @@ static void moxa_throttle(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
 
-	ch->statusflags |= THROTTLE;
+	set_bit(THROTTLE, &ch->statusflags);
 }
 
 static void moxa_unthrottle(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
 
-	ch->statusflags &= ~THROTTLE;
+	clear_bit(THROTTLE, &ch->statusflags);
 }
 
 static void moxa_set_termios(struct tty_struct *tty,
@@ -1361,7 +1360,7 @@ static void moxa_stop(struct tty_struct *tty)
 	if (ch == NULL)
 		return;
 	MoxaPortTxDisable(ch);
-	ch->statusflags |= TXSTOPPED;
+	set_bit(TXSTOPPED, &ch->statusflags);
 }
 
 
@@ -1376,17 +1375,13 @@ static void moxa_start(struct tty_struct *tty)
 		return;
 
 	MoxaPortTxEnable(ch);
-	ch->statusflags &= ~TXSTOPPED;
+	clear_bit(TXSTOPPED, &ch->statusflags);
 }
 
 static void moxa_hangup(struct tty_struct *tty)
 {
-	struct moxa_port *ch;
-
-	mutex_lock(&moxa_openlock);
-	ch = tty->driver_data;
+	struct moxa_port *ch = tty->driver_data;
 	tty_port_hangup(&ch->port);
-	mutex_unlock(&moxa_openlock);
 }
 
 static void moxa_new_dcdstate(struct moxa_port *p, u8 dcd)
@@ -1412,24 +1407,24 @@ static int moxa_poll_port(struct moxa_port *p, unsigned int handle,
 	u16 intr;
 
 	if (tty) {
-		if ((p->statusflags & EMPTYWAIT) &&
+		if (test_bit(EMPTYWAIT, &p->statusflags) &&
 				MoxaPortTxQueue(p) == 0) {
-			p->statusflags &= ~EMPTYWAIT;
+			clear_bit(EMPTYWAIT, &p->statusflags);
 			tty_wakeup(tty);
 		}
-		if ((p->statusflags & LOWWAIT) && !tty->stopped &&
+		if (test_bit(LOWWAIT, &p->statusflags) && !tty->stopped &&
 				MoxaPortTxQueue(p) <= WAKEUP_CHARS) {
-			p->statusflags &= ~LOWWAIT;
+			clear_bit(LOWWAIT, &p->statusflags);
 			tty_wakeup(tty);
 		}
 
-		if (inited && !(p->statusflags & THROTTLE) &&
+		if (inited && !test_bit(THROTTLE, &p->statusflags) &&
 				MoxaPortRxQueue(p) > 0) { /* RX */
 			MoxaPortReadData(p);
 			tty_schedule_flip(tty);
 		}
 	} else {
-		p->statusflags &= ~EMPTYWAIT;
+		clear_bit(EMPTYWAIT, &p->statusflags);
 		MoxaPortFlushData(p, 0); /* flush RX */
 	}
 
@@ -1533,10 +1528,7 @@ static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_term
 static void moxa_setup_empty_event(struct tty_struct *tty)
 {
 	struct moxa_port *ch = tty->driver_data;
-
-	spin_lock_bh(&moxa_lock);
-	ch->statusflags |= EMPTYWAIT;
-	spin_unlock_bh(&moxa_lock);
+	set_bit(EMPTYWAIT, &ch->statusflags);
 }
 
 /*****************************************************************************
@@ -1845,7 +1837,7 @@ static int MoxaPortSetTermio(struct moxa_port *port, struct ktermios *termio,
 		writeb(termio->c_cc[VSTOP], ofsAddr + FuncArg1);
 		writeb(FC_SetXonXoff, ofsAddr + FuncCode);
 		moxa_wait_finish(ofsAddr);
-		spin_unlock_irqrestore(&moxafunc_lock);
+		spin_unlock_irq(&moxafunc_lock);
 
 	}
 	return baud;
-- 
1.6.5.5

