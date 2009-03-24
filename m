Return-Path: <linux-kernel-owner+w=401wt.eu-S1754262AbZCXVQk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262AbZCXVQk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:16:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753269AbZCXVN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:29 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:53122 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706AbZCXVNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=Xa+o/69NW2dWxG+jRsc0mmQQ384tJi7GbuPO5D2iX3lDAH7tZcVpoOgsBvTrPEp3/2
         IltBOV65oi/LBu7j268y6pKSKZnS3TfE3+JkBxA05nuoOwAhmGlD/b1mGYHi/BsxWEcw
         n56Y+o13vXgvTTC7jsGSgyUWpQImPlmcAnc88=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, clemens@ladisch.de
Subject: [PATCH 10/13] [drivers/char] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:45 -0500
Message-Id: <1237929168-15341-11-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/char/applicom.c |   16 +++++++++++-----
 drivers/char/hpet.c     |   12 +++++++-----
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 05674fe..3651e18 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -104,8 +104,7 @@ static unsigned int DeviceErrorCount;	/* number of device error     */
 
 static ssize_t ac_read (struct file *, char __user *, size_t, loff_t *);
 static ssize_t ac_write (struct file *, const char __user *, size_t, loff_t *);
-static int ac_ioctl(struct inode *, struct file *, unsigned int,
-		    unsigned long);
+static long ac_ioctl(struct file *, unsigned int, unsigned long);
 static irqreturn_t ac_interrupt(int, void *);
 
 static const struct file_operations ac_fops = {
@@ -113,7 +112,7 @@ static const struct file_operations ac_fops = {
 	.llseek = no_llseek,
 	.read = ac_read,
 	.write = ac_write,
-	.ioctl = ac_ioctl,
+	.unlocked_ioctl = ac_ioctl,
 };
 
 static struct miscdevice ac_miscdev = {
@@ -687,7 +686,7 @@ static irqreturn_t ac_interrupt(int vec, void *dev_instance)
 
 
 
-static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, unsigned long arg)
+static long ac_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
      
 {				/* @ ADG ou ATO selon le cas */
 	int i;
@@ -698,15 +697,20 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 	struct st_ram_io *adgl;
 	void __user *argp = (void __user *)arg;
 
+	lock_kernel();
+
 	/* In general, the device is only openable by root anyway, so we're not
 	   particularly concerned that bogus ioctls can flood the console. */
 
 	adgl = kmalloc(sizeof(struct st_ram_io), GFP_KERNEL);
-	if (!adgl)
+	if (!adgl) {
+		unlock_kernel();
 		return -ENOMEM;
+	}
 
 	if (copy_from_user(adgl, argp, sizeof(struct st_ram_io))) {
 		kfree(adgl);
+		unlock_kernel();
 		return -EFAULT;
 	}
 	
@@ -719,6 +723,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 			warncount--;
 		}
 		kfree(adgl);
+		unlock_kernel();
 		return -EINVAL;
 	}
 
@@ -836,6 +841,7 @@ static int ac_ioctl(struct inode *inode, struct file *file, unsigned int cmd, un
 	}
 	Dummy = readb(apbs[IndexCard].RamIO + VERS);
 	kfree(adgl);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/char/hpet.c b/drivers/char/hpet.c
index 32b8bbf..8be216b 100644
--- a/drivers/char/hpet.c
+++ b/drivers/char/hpet.c
@@ -433,14 +433,16 @@ static int hpet_release(struct inode *inode, struct file *file)
 
 static int hpet_ioctl_common(struct hpet_dev *, int, unsigned long, int);
 
-static int
-hpet_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
-	   unsigned long arg)
+static long
+hpet_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
+	lock_kernel();
 	struct hpet_dev *devp;
 
 	devp = file->private_data;
-	return hpet_ioctl_common(devp, cmd, arg, 0);
+	int ret = hpet_ioctl_common(devp, cmd, arg, 0);
+	unlock_kernel();
+	return ret;
 }
 
 static int hpet_ioctl_ieon(struct hpet_dev *devp)
@@ -652,7 +654,7 @@ static const struct file_operations hpet_fops = {
 	.llseek = no_llseek,
 	.read = hpet_read,
 	.poll = hpet_poll,
-	.ioctl = hpet_ioctl,
+	.unlocked_ioctl = hpet_ioctl,
 	.open = hpet_open,
 	.release = hpet_release,
 	.fasync = hpet_fasync,
-- 
1.6.2

