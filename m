Return-Path: <linux-kernel-owner+w=401wt.eu-S1753021AbZKPA1q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbZKPA1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 19:27:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbZKPA1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 19:27:45 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:52873 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787AbZKPA1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 19:27:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 09/12] lp: move compat_ioctl handling into lp.c
Date: Mon, 16 Nov 2009 00:27:04 +0000
Message-Id: <1258331227-1694-10-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1258331227-1694-1-git-send-email-arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18LsKQou2h6h1qPVd3Mhgxnl7TgWQQIjA/g4nt
 90SozHahCl4cJ2t8SlPaJBycb/m1M3cS38JYgQ0j8EElawldxw
 3mlVcGkAI1riFzZ0u4a4Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handling for LPSETTIMEOUT can easily be done in lp_ioctl, which
is the only user. As a positive side-effect, push the BKL
into the ioctl methods.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/lp.c |  115 +++++++++++++++++++++++++++++++++++++++++------------
 fs/compat_ioctl.c |   33 ---------------
 2 files changed, 89 insertions(+), 59 deletions(-)

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index e444c2d..938a3a2 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -127,6 +127,7 @@
 #include <linux/wait.h>
 #include <linux/jiffies.h>
 #include <linux/smp_lock.h>
+#include <linux/compat.h>
 
 #include <linux/parport.h>
 #undef LP_STATS
@@ -571,13 +572,11 @@ static int lp_release(struct inode * inode, struct file * file)
 	return 0;
 }
 
-static int lp_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg)
+static int lp_do_ioctl(unsigned int minor, unsigned int cmd,
+	unsigned long arg, void __user *argp)
 {
-	unsigned int minor = iminor(inode);
 	int status;
 	int retval = 0;
-	void __user *argp = (void __user *)arg;
 
 #ifdef LP_DEBUG
 	printk(KERN_DEBUG "lp%d ioctl, cmd: 0x%x, arg: 0x%lx\n", minor, cmd, arg);
@@ -587,9 +586,6 @@ static int lp_ioctl(struct inode *inode, struct file *file,
 	if ((LP_F(minor) & LP_EXIST) == 0)
 		return -ENODEV;
 	switch ( cmd ) {
-		struct timeval par_timeout;
-		long to_jiffies;
-
 		case LPTIME:
 			LP_TIME(minor) = arg * HZ/100;
 			break;
@@ -652,34 +648,101 @@ static int lp_ioctl(struct inode *inode, struct file *file,
 				return -EFAULT;
 			break;
 
-		case LPSETTIMEOUT:
-			if (copy_from_user (&par_timeout, argp,
-					    sizeof (struct timeval))) {
-				return -EFAULT;
-			}
-			/* Convert to jiffies, place in lp_table */
-			if ((par_timeout.tv_sec < 0) ||
-			    (par_timeout.tv_usec < 0)) {
-				return -EINVAL;
-			}
-			to_jiffies = DIV_ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
-			to_jiffies += par_timeout.tv_sec * (long) HZ;
-			if (to_jiffies <= 0) {
-				return -EINVAL;
-			}
-			lp_table[minor].timeout = to_jiffies;
-			break;
-
 		default:
 			retval = -EINVAL;
 	}
 	return retval;
 }
 
+static int lp_set_timeout(unsigned int minor, struct timeval *par_timeout)
+{
+	long to_jiffies;
+
+	/* Convert to jiffies, place in lp_table */
+	if ((par_timeout->tv_sec < 0) ||
+	    (par_timeout->tv_usec < 0)) {
+		return -EINVAL;
+	}
+	to_jiffies = DIV_ROUND_UP(par_timeout->tv_usec, 1000000/HZ);
+	to_jiffies += par_timeout->tv_sec * (long) HZ;
+	if (to_jiffies <= 0) {
+		return -EINVAL;
+	}
+	lp_table[minor].timeout = to_jiffies;
+	return 0;
+}
+
+static long lp_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	unsigned int minor;
+	struct timeval par_timeout;
+	int ret;
+
+	minor = iminor(file->f_path.dentry->d_inode);
+	lock_kernel();
+	switch (cmd) {
+	case LPSETTIMEOUT:
+		if (copy_from_user(&par_timeout, (void __user *)arg,
+					sizeof (struct timeval))) {
+			ret = -EFAULT;
+			break;
+		}
+		ret = lp_set_timeout(minor, &par_timeout);
+		break;
+	default:
+		ret = lp_do_ioctl(minor, cmd, arg, (void __user *)arg);
+		break;
+	}
+	unlock_kernel();
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static long lp_compat_ioctl(struct file *file, unsigned int cmd,
+			unsigned long arg)
+{
+	unsigned int minor;
+	struct timeval par_timeout;
+	struct compat_timeval __user *tc;
+	int ret;
+
+	minor = iminor(file->f_path.dentry->d_inode);
+	lock_kernel();
+	switch (cmd) {
+	case LPSETTIMEOUT:
+		tc = compat_ptr(arg);
+		if (get_user(par_timeout.tv_sec, &tc->tv_sec) ||
+		    get_user(par_timeout.tv_usec, &tc->tv_usec)) {
+			ret = -EFAULT;
+			break;
+		}
+		ret = lp_set_timeout(minor, &par_timeout);
+		break;
+#ifdef LP_STATS
+	case LPGETSTATS:
+		/* FIXME: add an implementation if you set LP_STATS */
+		ret = -EINVAL;
+		break;
+#endif
+	default:
+		ret = lp_do_ioctl(minor, cmd, arg, compat_ptr(arg));
+		break;
+	}
+	unlock_kernel();
+
+	return ret;
+}
+#endif
+
 static const struct file_operations lp_fops = {
 	.owner		= THIS_MODULE,
 	.write		= lp_write,
-	.ioctl		= lp_ioctl,
+	.unlocked_ioctl	= lp_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= lp_compat_ioctl,
+#endif
 	.open		= lp_open,
 	.release	= lp_release,
 #ifdef CONFIG_PARPORT_1284
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 8adfc08..68929a2 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -709,20 +709,6 @@ static int rtc_ioctl(unsigned fd, unsigned cmd, void __user *argp)
 	return -ENOIOCTLCMD;
 }
 
-static int
-lp_timeout_trans(unsigned int fd, unsigned int cmd,
-			struct compat_timeval __user *tc)
-{
-	struct timeval __user *tn = compat_alloc_user_space(sizeof(struct timeval));
-	struct timeval ts;
-	if (get_user(ts.tv_sec, &tc->tv_sec) ||
-	    get_user(ts.tv_usec, &tc->tv_usec) ||
-	    put_user(ts.tv_sec, &tn->tv_sec) ||
-	    put_user(ts.tv_usec, &tn->tv_usec))
-		return -EFAULT;
-	return sys_ioctl(fd, cmd, (unsigned long)tn);
-}
-
 /* on ia32 l_start is on a 32-bit boundary */
 #if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
 struct space_resv_32 {
@@ -937,8 +923,6 @@ COMPATIBLE_IOCTL(PPPIOCGCHAN)
 /* PPPOX */
 COMPATIBLE_IOCTL(PPPOEIOCSFWD)
 COMPATIBLE_IOCTL(PPPOEIOCDFWD)
-/* LP */
-COMPATIBLE_IOCTL(LPGETSTATUS)
 /* ppdev */
 COMPATIBLE_IOCTL(PPSETMODE)
 COMPATIBLE_IOCTL(PPRSTATUS)
@@ -1326,19 +1310,6 @@ COMPATIBLE_IOCTL(TIOCSTOP)
 /* Usbdevfs */
 COMPATIBLE_IOCTL(USBDEVFS_IOCTL32)
 
-/* parport */
-COMPATIBLE_IOCTL(LPTIME)
-COMPATIBLE_IOCTL(LPCHAR)
-COMPATIBLE_IOCTL(LPABORTOPEN)
-COMPATIBLE_IOCTL(LPCAREFUL)
-COMPATIBLE_IOCTL(LPWAIT)
-COMPATIBLE_IOCTL(LPSETIRQ)
-COMPATIBLE_IOCTL(LPGETSTATUS)
-COMPATIBLE_IOCTL(LPGETSTATUS)
-COMPATIBLE_IOCTL(LPRESET)
-/*LPGETSTATS not implemented, but no kernels seem to compile it in anyways*/
-COMPATIBLE_IOCTL(LPGETFLAGS)
-
 /* fat 'r' ioctls. These are handled by fat with ->compat_ioctl,
    but we don't want warnings on other file systems. So declare
    them as compatible here. */
@@ -1417,10 +1388,6 @@ static long do_ioctl_trans(int fd, unsigned int cmd,
 		return do_video_stillpicture(fd, cmd, argp);
 	case VIDEO_SET_SPU_PALETTE:
 		return do_video_set_spu_palette(fd, cmd, argp);
-
-	/* lp */
-	case LPSETTIMEOUT:
-		return lp_timeout_trans(fd, cmd, argp);
 	}
 
 	/*
-- 
1.6.3.3

