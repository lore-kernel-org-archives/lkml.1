Return-Path: <linux-kernel-owner+w=401wt.eu-S1765288AbYBTUkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765288AbYBTUkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 15:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755177AbYBTUkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 15:40:14 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41235 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765496AbYBTUkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 15:40:10 -0500
Date: Wed, 20 Feb 2008 20:31:01 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: paulkf@microgate.com, akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] synclink series: Prepare for BKL pushdown
Message-ID: <20080220203101.6239d624@core>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As these are quite complex I've simply pushed the BKL down into the ioctl
handler not tried to do anything neater. 

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/synclink.c linux-2.6.25-rc2-mm1/drivers/char/synclink.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/synclink.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/synclink.c	2008-02-20 11:49:03.000000000 +0000
@@ -2945,6 +2945,7 @@
 		    unsigned int cmd, unsigned long arg)
 {
 	struct mgsl_struct * info = (struct mgsl_struct *)tty->driver_data;
+	int ret;
 	
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgsl_ioctl %s cmd=%08X\n", __FILE__,__LINE__,
@@ -2959,7 +2960,10 @@
 		    return -EIO;
 	}
 
-	return mgsl_ioctl_common(info, cmd, arg);
+	lock_kernel();
+	ret = mgsl_ioctl_common(info, cmd, arg);
+	unlock_kernel();
+	return ret;
 }
 
 static int mgsl_ioctl_common(struct mgsl_struct *info, unsigned int cmd, unsigned long arg)
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/synclink_gt.c linux-2.6.25-rc2-mm1/drivers/char/synclink_gt.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/synclink_gt.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/synclink_gt.c	2008-02-20 11:49:09.000000000 +0000
@@ -1098,6 +1098,7 @@
 	struct serial_icounter_struct __user *p_cuser;	/* user space */
 	unsigned long flags;
 	void __user *argp = (void __user *)arg;
+	int ret;
 
 	if (sanity_check(info, tty->name, "ioctl"))
 		return -ENODEV;
@@ -1108,38 +1109,55 @@
 		if (tty->flags & (1 << TTY_IO_ERROR))
 		    return -EIO;
 	}
+	
+	lock_kernel();
 
 	switch (cmd) {
 	case MGSL_IOCGPARAMS:
-		return get_params(info, argp);
+		ret = get_params(info, argp);
+		break;
 	case MGSL_IOCSPARAMS:
-		return set_params(info, argp);
+		ret = set_params(info, argp);
+		break;
 	case MGSL_IOCGTXIDLE:
-		return get_txidle(info, argp);
+		ret = get_txidle(info, argp);
+		break;
 	case MGSL_IOCSTXIDLE:
-		return set_txidle(info, (int)arg);
+		ret = set_txidle(info, (int)arg);
+		break;
 	case MGSL_IOCTXENABLE:
-		return tx_enable(info, (int)arg);
+		ret = tx_enable(info, (int)arg);
+		break;
 	case MGSL_IOCRXENABLE:
-		return rx_enable(info, (int)arg);
+		ret = rx_enable(info, (int)arg);
+		break;
 	case MGSL_IOCTXABORT:
-		return tx_abort(info);
+		ret = tx_abort(info);
+		break;
 	case MGSL_IOCGSTATS:
-		return get_stats(info, argp);
+		ret = get_stats(info, argp);
+		break;
 	case MGSL_IOCWAITEVENT:
-		return wait_mgsl_event(info, argp);
+		ret = wait_mgsl_event(info, argp);
+		break;
 	case TIOCMIWAIT:
-		return modem_input_wait(info,(int)arg);
+		ret = modem_input_wait(info,(int)arg);
+		break;
 	case MGSL_IOCGIF:
-		return get_interface(info, argp);
+		ret = get_interface(info, argp);
+		break;
 	case MGSL_IOCSIF:
-		return set_interface(info,(int)arg);
+		ret = set_interface(info,(int)arg);
+		break;
 	case MGSL_IOCSGPIO:
-		return set_gpio(info, argp);
+		ret = set_gpio(info, argp);
+		break;
 	case MGSL_IOCGGPIO:
-		return get_gpio(info, argp);
+		ret = get_gpio(info, argp);
+		break;
 	case MGSL_IOCWAITGPIO:
-		return wait_gpio(info, argp);
+		ret = wait_gpio(info, argp);
+		break;
 	case TIOCGICOUNT:
 		spin_lock_irqsave(&info->lock,flags);
 		cnow = info->icount;
@@ -1156,12 +1174,14 @@
 		    put_user(cnow.parity, &p_cuser->parity) ||
 		    put_user(cnow.brk, &p_cuser->brk) ||
 		    put_user(cnow.buf_overrun, &p_cuser->buf_overrun))
-			return -EFAULT;
-		return 0;
+			ret = -EFAULT;
+		ret = 0;
+		break;
 	default:
-		return -ENOIOCTLCMD;
+		ret = -ENOIOCTLCMD;
 	}
-	return 0;
+	unlock_kernel();
+	return ret;
 }
 
 /*
diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/synclinkmp.c linux-2.6.25-rc2-mm1/drivers/char/synclinkmp.c
--- linux.vanilla-2.6.25-rc2-mm1/drivers/char/synclinkmp.c	2008-02-19 11:03:00.000000000 +0000
+++ linux-2.6.25-rc2-mm1/drivers/char/synclinkmp.c	2008-02-20 11:49:15.000000000 +0000
@@ -1303,7 +1303,7 @@
  *
  * Return Value:	0 if success, otherwise error code
  */
-static int ioctl(struct tty_struct *tty, struct file *file,
+static int do_ioctl(struct tty_struct *tty, struct file *file,
 		 unsigned int cmd, unsigned long arg)
 {
 	SLMP_INFO *info = (SLMP_INFO *)tty->driver_data;
@@ -1393,6 +1393,16 @@
 	return 0;
 }
 
+static int ioctl(struct tty_struct *tty, struct file *file,
+		 unsigned int cmd, unsigned long arg)
+{
+	int ret;
+	lock_kernel();
+	ret = do_ioctl(tty, file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 /*
  * /proc fs routines....
  */
