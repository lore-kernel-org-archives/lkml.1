Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933944Ab0BYV13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:27:29 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:53394 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933904Ab0BYV1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:27:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: [PATCH -next] pktcdvd: improve BKL and compat_ioctl.c usage
Date: Thu, 25 Feb 2010 22:27:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
       Peter Osterlund <petero2@telia.com>, Jens Axboe <jens.axboe@oracle.com>,
       Akinobu Mita <akinobu.mita@gmail.com>
References: <20100225183523.80361261.sfr@canb.auug.org.au> <4B86B97D.6030208@oracle.com>
In-Reply-To: <4B86B97D.6030208@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002252227.11472.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/n9gRwKCl5Lw1xszVPFDIjStS2X8qyQmsUibC
 GjCongQIavMvVbqib/3XGhn2qONv+xBofv64soGS+35eGFRK+v
 CstlGHqo/WPceewlXAgIA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pktcdvd driver uses proper locking and does not need the
BKL in the ioctl and llseek functions of the character device,
so kill both. Moving the compat_ioctl handling from common code
into the driver itself fixes build problems when CONFIG_BLOCK is
disabled.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---
On Thursday 25 February 2010, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> fs/compat_ioctl.c should omit pktcdvd.h and its ioctl when CONFIG_BLOCK
> is not enabled.  This fixes these build errors:
> 
> In file included from fs/compat_ioctl.c:105:
> include/linux/pktcdvd.h:166: error: field 'read_queue' has incomplete type
> include/linux/pktcdvd.h:167: error: field 'write_queue' has incomplete type
> include/linux/pktcdvd.h:207: error: field 'orig_bios' has incomplete type
> make[2]: *** [fs/compat_ioctl.o] Error 1

How about this one instead, cleaning pktcdvd ioctl handling up for good?

diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 68b5957..f508015 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -48,6 +48,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/kernel.h>
+#include <linux/compat.h>
 #include <linux/kthread.h>
 #include <linux/errno.h>
 #include <linux/spinlock.h>
@@ -3024,7 +3025,7 @@ static void pkt_get_status(struct pkt_ctrl_command *ctrl_cmd)
 	mutex_unlock(&ctl_mutex);
 }
 
-static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long pkt_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct pkt_ctrl_command ctrl_cmd;
@@ -3061,10 +3062,20 @@ static int pkt_ctl_ioctl(struct inode *inode, struct file *file, unsigned int cm
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+static long pkt_ctl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	return pkt_ctl_ioctl(file, cmd, (unsigned long)compat_ptr(arg));
+}
+#endif
 
 static const struct file_operations pkt_ctl_fops = {
-	.ioctl	 = pkt_ctl_ioctl,
-	.owner	 = THIS_MODULE,
+	.open		= nonseekable_open,
+	.unlocked_ioctl	= pkt_ctl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= pkt_ctl_compat_ioctl,
+#endif
+	.owner		= THIS_MODULE,
 };
 
 static struct miscdevice pkt_misc = {
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 0ca9ec4..fa61262 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -102,7 +102,6 @@
 #include <linux/nbd.h>
 #include <linux/random.h>
 #include <linux/filter.h>
-#include <linux/pktcdvd.h>
 
 #include <linux/hiddev.h>
 
@@ -1126,8 +1125,6 @@ COMPATIBLE_IOCTL(PPGETMODE)
 COMPATIBLE_IOCTL(PPGETPHASE)
 COMPATIBLE_IOCTL(PPGETFLAGS)
 COMPATIBLE_IOCTL(PPSETFLAGS)
-/* pktcdvd */
-COMPATIBLE_IOCTL(PACKET_CTRL_CMD)
 /* Big A */
 /* sparc only */
 /* Big Q for sound/OSS */
