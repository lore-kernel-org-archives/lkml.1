Return-Path: <linux-kernel-owner+w=401wt.eu-S1762922AbYEVWXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762922AbYEVWXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 18:23:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762099AbYEVWXM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 18:23:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34711 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760557AbYEVWXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 18:23:10 -0400
Date: Thu, 22 May 2008 23:10:41 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] lp: BKL push down
Message-ID: <20080522231041.27c10d69@core>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LP is quite complex and has a lot of ioctl logic. Just push the BKL down
into a driver wrapper for the moment.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/lp.c b/drivers/char/lp.c
index 60ac642..3a42f87 100644
--- a/drivers/char/lp.c
+++ b/drivers/char/lp.c
@@ -126,7 +126,7 @@
 #include <linux/device.h>
 #include <linux/wait.h>
 #include <linux/jiffies.h>
-
+#include <linux/smp_lock.h>
 #include <linux/parport.h>
 #undef LP_STATS
 #include <linux/lp.h>
@@ -557,10 +557,9 @@ static int lp_release(struct inode * inode, struct file * file)
 	return 0;
 }
 
-static int lp_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg)
+static long lp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	unsigned int minor = iminor(inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	int status;
 	int retval = 0;
 	void __user *argp = (void __user *)arg;
@@ -570,9 +569,13 @@ static int lp_ioctl(struct inode *inode, struct file *file,
 #endif
 	if (minor >= LP_NO)
 		return -ENODEV;
-	if ((LP_F(minor) & LP_EXIST) == 0)
+		
+	lock_kernel();
+	if ((LP_F(minor) & LP_EXIST) == 0) {
+		unlock_kernel();
 		return -ENODEV;
-	switch ( cmd ) {
+	}
+	switch (cmd ) {
 		struct timeval par_timeout;
 		long to_jiffies;
 
@@ -604,12 +607,12 @@ static int lp_ioctl(struct inode *inode, struct file *file,
 			LP_WAIT(minor) = arg;
 			break;
 		case LPSETIRQ: 
-			return -EINVAL;
+			retval = -EINVAL;
 			break;
 		case LPGETIRQ:
 			if (copy_to_user(argp, &LP_IRQ(minor),
 					sizeof(int)))
-				return -EFAULT;
+				retval = -EFAULT;
 			break;
 		case LPGETSTATUS:
 			lp_claim_parport_or_block (&lp_table[minor]);
@@ -617,7 +620,7 @@ static int lp_ioctl(struct inode *inode, struct file *file,
 			lp_release_parport (&lp_table[minor]);
 
 			if (copy_to_user(argp, &status, sizeof(int)))
-				return -EFAULT;
+				retval = -EFAULT;
 			break;
 		case LPRESET:
 			lp_reset(minor);
@@ -626,8 +629,8 @@ static int lp_ioctl(struct inode *inode, struct file *file,
 		case LPGETSTATS:
 			if (copy_to_user(argp, &LP_STAT(minor),
 					sizeof(struct lp_stats)))
-				return -EFAULT;
-			if (capable(CAP_SYS_ADMIN))
+				retval = -EFAULT;
+			else if (capable(CAP_SYS_ADMIN))
 				memset(&LP_STAT(minor), 0,
 						sizeof(struct lp_stats));
 			break;
@@ -635,37 +638,40 @@ static int lp_ioctl(struct inode *inode, struct file *file,
  		case LPGETFLAGS:
  			status = LP_F(minor);
 			if (copy_to_user(argp, &status, sizeof(int)))
-				return -EFAULT;
+				retval = -EFAULT;
 			break;
 
 		case LPSETTIMEOUT:
 			if (copy_from_user (&par_timeout, argp,
 					    sizeof (struct timeval))) {
-				return -EFAULT;
+				retval = -EFAULT;
+				break;
 			}
 			/* Convert to jiffies, place in lp_table */
 			if ((par_timeout.tv_sec < 0) ||
 			    (par_timeout.tv_usec < 0)) {
-				return -EINVAL;
+				retval = -EINVAL;
+				break;
 			}
 			to_jiffies = DIV_ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
 			to_jiffies += par_timeout.tv_sec * (long) HZ;
-			if (to_jiffies <= 0) {
-				return -EINVAL;
-			}
-			lp_table[minor].timeout = to_jiffies;
+			if (to_jiffies <= 0)
+				retval = -EINVAL;
+			else
+				lp_table[minor].timeout = to_jiffies;
 			break;
 
 		default:
-			retval = -EINVAL;
+			retval = -ENOTTY;
 	}
+	unlock_kernel();
 	return retval;
 }
 
 static const struct file_operations lp_fops = {
 	.owner		= THIS_MODULE,
 	.write		= lp_write,
-	.ioctl		= lp_ioctl,
+	.unlocked_ioctl	= lp_ioctl,
 	.open		= lp_open,
 	.release	= lp_release,
 #ifdef CONFIG_PARPORT_1284
