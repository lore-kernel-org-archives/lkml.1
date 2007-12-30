Return-Path: <linux-kernel-owner+w=401wt.eu-S1757661AbXL3N74@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757661AbXL3N74 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:59:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755650AbXL3N7L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:59:11 -0500
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:47435 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbXL3N7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:59:05 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 5/5] Char: mxser, ioctl cleanup
Date: Sun, 30 Dec 2007 14:58:58 +0100
Message-Id: <1199023138-27917-5-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
References: <1199023138-27917-1-git-send-email-jirislaby@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- remove dead MOXA_GET_CONF (always returned -ENXIO)
- remove useless MOXA_GET_CUMAJOR (unused)
- use get/put_user instead of copy_from/to_user for simple types
- cleanup TIOCMIWAIT -- return -ERESTARTSYS on signal, move condition into
  separate function

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 drivers/char/mxser.c |   74 +++++++++++++++++++++-----------------------------
 drivers/char/mxser.h |    2 -
 2 files changed, 31 insertions(+), 45 deletions(-)

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index c6651f3..dd1b0ab 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -175,7 +175,6 @@ MODULE_DEVICE_TABLE(pci, mxser_pcibrds);
 
 static int ioaddr[MXSER_BOARDS] = { 0, 0, 0, 0 };
 static int ttymajor = MXSERMAJOR;
-static int calloutmajor = MXSERCUMAJOR;
 
 /* Variables for insmod */
 
@@ -1454,21 +1453,8 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 	unsigned int i, j;
 
 	switch (cmd) {
-	case MOXA_GET_CONF:
-/*		if (copy_to_user(argp, mxsercfg,
-				sizeof(struct mxser_hwconf) * 4))
-			return -EFAULT;
-		return 0;*/
-		return -ENXIO;
 	case MOXA_GET_MAJOR:
-		if (copy_to_user(argp, &ttymajor, sizeof(int)))
-			return -EFAULT;
-		return 0;
-
-	case MOXA_GET_CUMAJOR:
-		if (copy_to_user(argp, &calloutmajor, sizeof(int)))
-			return -EFAULT;
-		return 0;
+		return put_user(ttymajor, (int __user *)argp);
 
 	case MOXA_CHKPORTENABLE:
 		result = 0;
@@ -1606,13 +1592,33 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 	return 0;
 }
 
+static int mxser_cflags_changed(struct mxser_port *info, unsigned long arg,
+		struct async_icount *cprev)
+{
+	struct async_icount cnow;
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&info->slock, flags);
+	cnow = info->icount;	/* atomic copy */
+	spin_unlock_irqrestore(&info->slock, flags);
+
+	ret =	((arg & TIOCM_RNG) && (cnow.rng != cprev->rng)) ||
+		((arg & TIOCM_DSR) && (cnow.dsr != cprev->dsr)) ||
+		((arg & TIOCM_CD)  && (cnow.dcd != cprev->dcd)) ||
+		((arg & TIOCM_CTS) && (cnow.cts != cprev->cts));
+
+	*cprev = cnow;
+
+	return ret;
+}
+
 static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		unsigned int cmd, unsigned long arg)
 {
 	struct mxser_port *info = tty->driver_data;
-	struct async_icount cprev, cnow;	/* kernel counter temps */
+	struct async_icount cnow;
 	struct serial_icounter_struct __user *p_cuser;
-	unsigned long templ;
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
 	int retval;
@@ -1646,7 +1652,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 			shiftbit = p * 2;
 			opmode = inb(info->opmode_ioaddr) >> shiftbit;
 			opmode &= OP_MODE_MASK;
-			if (copy_to_user(argp, &opmode, sizeof(int)))
+			if (put_user(opmode, (int __user *)argp))
 				return -EFAULT;
 		}
 		return 0;
@@ -1673,11 +1679,10 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		mxser_send_break(info, arg ? arg * (HZ / 10) : HZ / 4);
 		return 0;
 	case TIOCGSOFTCAR:
-		return put_user(C_CLOCAL(tty) ? 1 : 0, (unsigned long __user *)argp);
+		return put_user(!!C_CLOCAL(tty), (unsigned long __user *)argp);
 	case TIOCSSOFTCAR:
-		if (get_user(templ, (unsigned long __user *) argp))
+		if (get_user(arg, (unsigned long __user *)argp))
 			return -EFAULT;
-		arg = templ;
 		tty->termios->c_cflag = ((tty->termios->c_cflag & ~CLOCAL) | (arg ? CLOCAL : 0));
 		return 0;
 	case TIOCGSERIAL:
@@ -1697,18 +1702,8 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		cnow = info->icount;	/* note the counters on entry */
 		spin_unlock_irqrestore(&info->slock, flags);
 
-		wait_event_interruptible(info->delta_msr_wait, ({
-			cprev = cnow;
-			spin_lock_irqsave(&info->slock, flags);
-			cnow = info->icount;	/* atomic copy */
-			spin_unlock_irqrestore(&info->slock, flags);
-
-			((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
-			((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
-			((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
-			((arg & TIOCM_CTS) && (cnow.cts != cprev.cts));
-		}));
-		break;
+		return wait_event_interruptible(info->delta_msr_wait,
+				mxser_cflags_changed(info, arg, &cnow));
 	/*
 	 * Get counter of input serial line interrupts (DCD,RI,DSR,CTS)
 	 * Return: write counters to the user passed counter struct
@@ -1755,10 +1750,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 
 		len += (lsr ? 0 : 1);
 
-		if (copy_to_user(argp, &len, sizeof(int)))
-			return -EFAULT;
-
-		return 0;
+		return put_user(len, (int __user *)argp);
 	}
 	case MOXA_ASPP_MON: {
 		int mcr, status;
@@ -1789,8 +1781,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		return 0;
 	}
 	case MOXA_ASPP_LSTATUS: {
-		if (copy_to_user(argp, &info->err_shadow,
-				sizeof(unsigned char)))
+		if (put_user(info->err_shadow, (unsigned char __user *)argp))
 			return -EFAULT;
 
 		info->err_shadow = 0;
@@ -1802,10 +1793,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		if (get_user(method, (int __user *)argp))
 			return -EFAULT;
 		mxser_set_baud_method[tty->index] = method;
-		if (copy_to_user(argp, &method, sizeof(int)))
-			return -EFAULT;
-
-		return 0;
+		return put_user(method, (int __user *)argp);
 	}
 	default:
 		return -ENOIOCTLCMD;
diff --git a/drivers/char/mxser.h b/drivers/char/mxser.h
index 7f7b4a7..8441711 100644
--- a/drivers/char/mxser.h
+++ b/drivers/char/mxser.h
@@ -11,12 +11,10 @@
 
 #define MOXA			0x400
 #define MOXA_GETDATACOUNT	(MOXA + 23)
-#define	MOXA_GET_CONF		(MOXA + 35)
 #define MOXA_DIAGNOSE		(MOXA + 50)
 #define MOXA_CHKPORTENABLE	(MOXA + 60)
 #define MOXA_HighSpeedOn	(MOXA + 61)
 #define MOXA_GET_MAJOR		(MOXA + 63)
-#define MOXA_GET_CUMAJOR	(MOXA + 64)
 #define MOXA_GETMSTATUS		(MOXA + 65)
 #define MOXA_SET_OP_MODE	(MOXA + 66)
 #define MOXA_GET_OP_MODE	(MOXA + 67)
-- 
1.5.3.6

