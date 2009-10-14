Return-Path: <linux-kernel-owner+w=401wt.eu-S934716AbZJNPu2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716AbZJNPu2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 11:50:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934706AbZJNPuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 11:50:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934677AbZJNPuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 11:50:21 -0400
Date: Wed, 14 Oct 2009 15:49:25 GMT
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       benh@kernel.crashing.org, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       benh@kernel.crashing.org, tglx@linutronix.de
In-Reply-To: <20091010153349.966159859@linutronix.de>
References: <20091010153349.966159859@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:bkl/drivers] macintosh: Remove BKL from ans-lcd
Message-ID: <tip-95fdac73725c15072d068ac7f131958cf5c324e4@git.kernel.org>
Git-Commit-ID: 95fdac73725c15072d068ac7f131958cf5c324e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 14 Oct 2009 15:49:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  95fdac73725c15072d068ac7f131958cf5c324e4
Gitweb:     http://git.kernel.org/tip/95fdac73725c15072d068ac7f131958cf5c324e4
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Sat, 10 Oct 2009 13:38:57 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 14 Oct 2009 17:36:50 +0200

macintosh: Remove BKL from ans-lcd

The ans-lcd driver got the cycle_kernel_lock() in anslcd_open() from
the BKL pushdown and it still uses the locked ioctl.

The BKL serialization in this driver is more than obscure and
definitely does not cover all possible corner cases. Protect the
access to the hardware with a local mutex and get rid of BKL and
locked ioctl.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
LKML-Reference: <20091010153349.966159859@linutronix.de>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 drivers/macintosh/ans-lcd.c |   45 ++++++++++++++++++++++++++----------------
 1 files changed, 28 insertions(+), 17 deletions(-)

diff --git a/drivers/macintosh/ans-lcd.c b/drivers/macintosh/ans-lcd.c
index 6a82218..a3d25da 100644
--- a/drivers/macintosh/ans-lcd.c
+++ b/drivers/macintosh/ans-lcd.c
@@ -3,7 +3,6 @@
  */
 
 #include <linux/types.h>
-#include <linux/smp_lock.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/miscdevice.h>
@@ -26,6 +25,7 @@
 static unsigned long anslcd_short_delay = 80;
 static unsigned long anslcd_long_delay = 3280;
 static volatile unsigned char __iomem *anslcd_ptr;
+static DEFINE_MUTEX(anslcd_mutex);
 
 #undef DEBUG
 
@@ -65,26 +65,31 @@ anslcd_write( struct file * file, const char __user * buf,
 
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
+
+	mutex_lock(&anslcd_mutex);
 	for ( i = *ppos; count > 0; ++i, ++p, --count ) 
 	{
 		char c;
 		__get_user(c, p);
 		anslcd_write_byte_data( c );
 	}
+	mutex_unlock(&anslcd_mutex);
 	*ppos = i;
 	return p - buf;
 }
 
-static int
-anslcd_ioctl( struct inode * inode, struct file * file,
-				unsigned int cmd, unsigned long arg )
+static long
+anslcd_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	char ch, __user *temp;
+	long ret = 0;
 
 #ifdef DEBUG
 	printk(KERN_DEBUG "LCD: ioctl(%d,%d)\n",cmd,arg);
 #endif
 
+	mutex_lock(&anslcd_mutex);
+
 	switch ( cmd )
 	{
 	case ANSLCD_CLEAR:
@@ -93,7 +98,7 @@ anslcd_ioctl( struct inode * inode, struct file * file,
 		anslcd_write_byte_ctrl ( 0x06 );
 		anslcd_write_byte_ctrl ( 0x01 );
 		anslcd_write_byte_ctrl ( 0x02 );
-		return 0;
+		break;
 	case ANSLCD_SENDCTRL:
 		temp = (char __user *) arg;
 		__get_user(ch, temp);
@@ -101,33 +106,37 @@ anslcd_ioctl( struct inode * inode, struct file * file,
 			anslcd_write_byte_ctrl ( ch );
 			__get_user(ch, temp);
 		}
-		return 0;
+		break;
 	case ANSLCD_SETSHORTDELAY:
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		anslcd_short_delay=arg;
-		return 0;
+			ret =-EACCES;
+		else
+			anslcd_short_delay=arg;
+		break;
 	case ANSLCD_SETLONGDELAY:
 		if (!capable(CAP_SYS_ADMIN))
-			return -EACCES;
-		anslcd_long_delay=arg;
-		return 0;
+			ret = -EACCES;
+		else
+			anslcd_long_delay=arg;
+		break;
 	default:
-		return -EINVAL;
+		ret = -EINVAL;
 	}
+
+	mutex_unlock(&anslcd_mutex);
+	return ret;
 }
 
 static int
 anslcd_open( struct inode * inode, struct file * file )
 {
-	cycle_kernel_lock();
 	return 0;
 }
 
 const struct file_operations anslcd_fops = {
-	.write	= anslcd_write,
-	.ioctl	= anslcd_ioctl,
-	.open	= anslcd_open,
+	.write		= anslcd_write,
+	.unlocked_ioctl	= anslcd_ioctl,
+	.open		= anslcd_open,
 };
 
 static struct miscdevice anslcd_dev = {
@@ -168,6 +177,7 @@ anslcd_init(void)
 	printk(KERN_DEBUG "LCD: init\n");
 #endif
 
+	mutex_lock(&anslcd_mutex);
 	anslcd_write_byte_ctrl ( 0x38 );
 	anslcd_write_byte_ctrl ( 0x0c );
 	anslcd_write_byte_ctrl ( 0x06 );
@@ -176,6 +186,7 @@ anslcd_init(void)
 	for(a=0;a<80;a++) {
 		anslcd_write_byte_data(anslcd_logo[a]);
 	}
+	mutex_unlock(&anslcd_mutex);
 	return 0;
 }
 
