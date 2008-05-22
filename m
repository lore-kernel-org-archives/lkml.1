Return-Path: <linux-kernel-owner+w=401wt.eu-S1763063AbYEVVOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763063AbYEVVOj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759473AbYEVVOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:14:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35130 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762698AbYEVVOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:14:24 -0400
Date: Thu, 22 May 2008 22:01:52 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ixj: Push BKL into driver and wrap ioctls
Message-ID: <20080522220152.4b805b6c@core>
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

diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index 49cd979..ec7aeb5 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -6095,15 +6095,15 @@ static int capabilities_check(IXJ *j, struct phone_capability *pcreq)
 	return retval;
 }
 
-static int ixj_ioctl(struct inode *inode, struct file *file_p, unsigned int cmd, unsigned long arg)
+static long do_ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg)
 {
 	IXJ_TONE ti;
 	IXJ_FILTER jf;
 	IXJ_FILTER_RAW jfr;
 	void __user *argp = (void __user *)arg;
-
-	unsigned int raise, mant;
+	struct inode *inode = file_p->f_path.dentry->d_inode;
 	unsigned int minor = iminor(inode);
+	unsigned int raise, mant;
 	int board = NUM(inode);
 
 	IXJ *j = get_ixj(NUM(inode));
@@ -6661,6 +6661,15 @@ static int ixj_ioctl(struct inode *inode, struct file *file_p, unsigned int cmd,
 	return retval;
 }
 
+static long ixj_ioctl(struct file *file_p, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	lock_kernel();
+	ret = do_ixj_ioctl(file_p, cmd, arg);
+	unlock_kernel();
+	return ret;
+}
+
 static int ixj_fasync(int fd, struct file *file_p, int mode)
 {
 	IXJ *j = get_ixj(NUM(file_p->f_path.dentry->d_inode));
@@ -6674,7 +6683,7 @@ static const struct file_operations ixj_fops =
         .read           = ixj_enhanced_read,
         .write          = ixj_enhanced_write,
         .poll           = ixj_poll,
-        .ioctl          = ixj_ioctl,
+        .unlocked_ioctl = ixj_ioctl,
         .release        = ixj_release,
         .fasync         = ixj_fasync
 };
