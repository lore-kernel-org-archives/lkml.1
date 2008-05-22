Return-Path: <linux-kernel-owner+w=401wt.eu-S932311AbYEVVqj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932311AbYEVVqj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:46:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbYEVVq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:46:29 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:59923 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756756AbYEVVq2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:46:28 -0400
Date: Thu, 22 May 2008 22:33:51 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: [PATCH] raw1394: Push the BKL down into the driver ioctls
Message-ID: <20080522223351.22e09d20@core>
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

Actually in this case wrap the function for now.

Signed-off-by: Alan Cox <alan@redhat.com>

diff --git a/drivers/ieee1394/raw1394.c b/drivers/ieee1394/raw1394.c
index ec2a0ad..8ec0278 100644
--- a/drivers/ieee1394/raw1394.c
+++ b/drivers/ieee1394/raw1394.c
@@ -2549,8 +2549,8 @@ static int raw1394_mmap(struct file *file, struct vm_area_struct *vma)
 }
 
 /* ioctl is only used for rawiso operations */
-static int raw1394_ioctl(struct inode *inode, struct file *file,
-			 unsigned int cmd, unsigned long arg)
+static long do_raw1394_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
 {
 	struct file_info *fi = file->private_data;
 	void __user *argp = (void __user *)arg;
@@ -2656,6 +2656,16 @@ static int raw1394_ioctl(struct inode *inode, struct file *file,
 	return -EINVAL;
 }
 
+static long raw1394_ioctl(struct file *file, unsigned int cmd,
+							unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = do_raw1394_ioctl(file, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 struct raw1394_iso_packets32 {
         __u32 n_packets;
@@ -2690,7 +2700,7 @@ static long raw1394_iso_xmit_recv_packets32(struct file *file, unsigned int cmd,
 	    !copy_from_user(&infos32, &arg->infos, sizeof infos32)) {
 		infos = compat_ptr(infos32);
 		if (!copy_to_user(&dst->infos, &infos, sizeof infos))
-			err = raw1394_ioctl(NULL, file, cmd, (unsigned long)dst);
+			err = do_raw1394_ioctl(file, cmd, (unsigned long)dst);
 	}
 	return err;
 }
@@ -2984,7 +2994,7 @@ static const struct file_operations raw1394_fops = {
 	.read = raw1394_read,
 	.write = raw1394_write,
 	.mmap = raw1394_mmap,
-	.ioctl = raw1394_ioctl,
+	.unlocked_ioctl = raw1394_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = raw1394_compat_ioctl,
 #endif
