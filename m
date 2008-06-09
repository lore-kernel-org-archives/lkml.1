Return-Path: <linux-kernel-owner+w=401wt.eu-S1761140AbYFILpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761140AbYFILpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 07:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758771AbYFILpE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 07:45:04 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:48614 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752461AbYFILpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 07:45:03 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH v2] Char: mxser, ioctl cleanup
Date: Mon,  9 Jun 2008 13:43:45 +0200
Message-Id: <1213011825-30185-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <20080609112742.420ff81b@core>
References: <20080609112742.420ff81b@core>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove break ctl from ioctl handler, it's never reached, since
  tty_ops->break_ctl is defined (mxser break handling is done in software)
- mark MOXA_GET_MAJOR as deprecated
- fix TIOCGICOUNT (some retval non-checks of put_user). Use copy_to_user
  to whole structure instead.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/mxser.c |   80 +++++++++++++------------------------------------
 1 files changed, 21 insertions(+), 59 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index 4b81a85..fa24445 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -16,7 +16,6 @@
  *	Fed through a cleanup, indent and remove of non 2.6 code by Alan Cox
  *	<alan@redhat.com>. The original 1.8 code is available on www.moxa.com.
  *	- Fixed x86_64 cleanness
- *	- Fixed sleep with spinlock held in mxser_send_break
  */
 
 #include <linux/module.h>
@@ -1473,27 +1472,6 @@ static int mxser_get_lsr_info(struct mxser_port *info,
 	return put_user(result, value);
 }
 
-/*
- * This routine sends a break character out the serial port.
- */
-static void mxser_send_break(struct mxser_port *info, int duration)
-{
-	unsigned long flags;
-
-	if (!info->ioaddr)
-		return;
-	set_current_state(TASK_INTERRUPTIBLE);
-	spin_lock_irqsave(&info->slock, flags);
-	outb(inb(info->ioaddr + UART_LCR) | UART_LCR_SBC,
-		info->ioaddr + UART_LCR);
-	spin_unlock_irqrestore(&info->slock, flags);
-	schedule_timeout(duration);
-	spin_lock_irqsave(&info->slock, flags);
-	outb(inb(info->ioaddr + UART_LCR) & ~UART_LCR_SBC,
-		info->ioaddr + UART_LCR);
-	spin_unlock_irqrestore(&info->slock, flags);
-}
-
 static int mxser_tiocmget(struct tty_struct *tty, struct file *file)
 {
 	struct mxser_port *info = tty->driver_data;
@@ -1662,6 +1640,10 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 
 	switch (cmd) {
 	case MOXA_GET_MAJOR:
+		if (printk_ratelimit())
+			printk(KERN_WARNING "mxser: '%s' uses deprecated "
+					"ioctl %x, fix your userspace\n",
+					current->comm, cmd);
 		return put_user(ttymajor, (int __user *)argp);
 
 	case MOXA_CHKPORTENABLE:
@@ -1832,7 +1814,6 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 {
 	struct mxser_port *info = tty->driver_data;
 	struct async_icount cnow;
-	struct serial_icounter_struct __user *p_cuser;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
 	int retval;
@@ -1881,21 +1862,6 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		return -EIO;
 
 	switch (cmd) {
-	case TCSBRK:		/* SVID version: non-zero arg --> no break */
-		retval = tty_check_change(tty);
-		if (retval)
-			return retval;
-		tty_wait_until_sent(tty, 0);
-		if (!arg)
-			mxser_send_break(info, HZ / 4);	/* 1/4 second */
-		return 0;
-	case TCSBRKP:		/* support for POSIX tcsendbreak() */
-		retval = tty_check_change(tty);
-		if (retval)
-			return retval;
-		tty_wait_until_sent(tty, 0);
-		mxser_send_break(info, arg ? arg * (HZ / 10) : HZ / 4);
-		return 0;
 	case TIOCGSERIAL:
 		lock_kernel();
 		retval = mxser_get_serial_info(info, argp);
@@ -1927,30 +1893,26 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 	 * NB: both 1->0 and 0->1 transitions are counted except for
 	 *     RI where only 0->1 is counted.
 	 */
-	case TIOCGICOUNT:
+	case TIOCGICOUNT: {
+		struct serial_icounter_struct icnt = { 0 };
 		spin_lock_irqsave(&info->slock, flags);
 		cnow = info->icount;
 		spin_unlock_irqrestore(&info->slock, flags);
-		p_cuser = argp;
-		if (put_user(cnow.frame, &p_cuser->frame))
-			return -EFAULT;
-		if (put_user(cnow.brk, &p_cuser->brk))
-			return -EFAULT;
-		if (put_user(cnow.overrun, &p_cuser->overrun))
-			return -EFAULT;
-		if (put_user(cnow.buf_overrun, &p_cuser->buf_overrun))
-			return -EFAULT;
-		if (put_user(cnow.parity, &p_cuser->parity))
-			return -EFAULT;
-		if (put_user(cnow.rx, &p_cuser->rx))
-			return -EFAULT;
-		if (put_user(cnow.tx, &p_cuser->tx))
-			return -EFAULT;
-		put_user(cnow.cts, &p_cuser->cts);
-		put_user(cnow.dsr, &p_cuser->dsr);
-		put_user(cnow.rng, &p_cuser->rng);
-		put_user(cnow.dcd, &p_cuser->dcd);
-		return 0;
+
+		icnt.frame = cnow.frame;
+		icnt.brk = cnow.brk;
+		icnt.overrun = cnow.overrun;
+		icnt.buf_overrun = cnow.buf_overrun;
+		icnt.parity = cnow.parity;
+		icnt.rx = cnow.rx;
+		icnt.tx = cnow.tx;
+		icnt.cts = cnow.cts;
+		icnt.dsr = cnow.dsr;
+		icnt.rng = cnow.rng;
+		icnt.dcd = cnow.dcd;
+
+		return copy_to_user(argp, &icnt, sizeof(icnt)) ? -EFAULT : 0;
+	}
 	case MOXA_HighSpeedOn:
 		return put_user(info->baud_base != 115200 ? 1 : 0, (int __user *)argp);
 	case MOXA_SDS_RSTICOUNTER:
-- 
1.5.4.5

