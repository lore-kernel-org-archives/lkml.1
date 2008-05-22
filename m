Return-Path: <linux-kernel-owner+w=401wt.eu-S1763426AbYEVVcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763426AbYEVVcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757789AbYEVVcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:32:01 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33431 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754014AbYEVVcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:32:01 -0400
Date: Thu, 22 May 2008 22:18:42 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ppdev: Wrap ioctl handler in driver and push lock down
Message-ID: <20080522221842.4174c66a@core>
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

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/char/ppdev.c b/drivers/char/ppdev.c
index 3aab837..53788b5 100644
--- a/drivers/char/ppdev.c
+++ b/drivers/char/ppdev.c
@@ -66,7 +66,8 @@
 #include <linux/poll.h>
 #include <linux/major.h>
 #include <linux/ppdev.h>
-#include <asm/uaccess.h>
+#include <linux/smp_lock.h>
+#include <linux/uaccess.h>
 
 #define PP_VERSION "ppdev: user-space parallel port driver"
 #define CHRDEV "ppdev"
@@ -327,10 +328,9 @@ static enum ieee1284_phase init_phase (int mode)
 	return IEEE1284_PH_FWD_IDLE;
 }
 
-static int pp_ioctl(struct inode *inode, struct file *file,
-		    unsigned int cmd, unsigned long arg)
+static int pp_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
-	unsigned int minor = iminor(inode);
+	unsigned int minor = iminor(file->f_path.dentry->d_inode);
 	struct pp_struct *pp = file->private_data;
 	struct parport * port;
 	void __user *argp = (void __user *)arg;
@@ -633,6 +633,15 @@ static int pp_ioctl(struct inode *inode, struct file *file,
 	return 0;
 }
 
+static long pp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = pp_do_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 static int pp_open (struct inode * inode, struct file * file)
 {
 	unsigned int minor = iminor(inode);
@@ -743,7 +752,7 @@ static const struct file_operations pp_fops = {
 	.read		= pp_read,
 	.write		= pp_write,
 	.poll		= pp_poll,
-	.ioctl		= pp_ioctl,
+	.unlocked_ioctl	= pp_ioctl,
 	.open		= pp_open,
 	.release	= pp_release,
 };
