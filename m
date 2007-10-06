Return-Path: <linux-kernel-owner+w=401wt.eu-S1764837AbXJFS3V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764837AbXJFS3V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:29:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763500AbXJFS2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:28:45 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:55578 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763359AbXJFS2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:28:44 -0400
Message-Id: <20071006182343.208790435@arndb.de>
References: <20071006181902.141862534@arndb.de>
User-Agent: quilt/0.46-1
Date: Sat, 06 Oct 2007 20:19:07 +0200
From: Arnd Bergmann <arnd@arndb.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, hch@lst.de,
       Al Viro <viro@ftp.linux.org.uk>
Subject: [patch 5/9] compat_ioctl: move BLKPG handling to block/compat_ioctl.c
Content-Disposition: inline; filename=compat-blkpg.diff
X-Provags-ID: V01U2FsdGVkX19h/M+dvdGMPhKaACor5OjTpqIqb7qafN4lzvQ
 geBJHQ8vaO0/1JTFISPyIhYZNi1DJVkioajaLTrXCl2HjX5SWB
 TCFSI2mIzImlCBHrNLvrg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

BLKPG is common to all block devices, so it should be handled
by common code.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Index: linux-2.6/block/compat_ioctl.c
===================================================================
--- linux-2.6.orig/block/compat_ioctl.c
+++ linux-2.6/block/compat_ioctl.c
@@ -92,6 +92,35 @@ static int compat_hdio_ioctl(struct inod
 	return error;
 }
 
+struct compat_blkpg_ioctl_arg {
+	compat_int_t op;
+	compat_int_t flags;
+	compat_int_t datalen;
+	compat_caddr_t data;
+};
+
+static int compat_blkpg_ioctl(struct inode *inode, struct file *file,
+		unsigned int cmd, struct compat_blkpg_ioctl_arg __user *ua32)
+{
+	struct blkpg_ioctl_arg __user *a = compat_alloc_user_space(sizeof(*a));
+	compat_caddr_t udata;
+	compat_int_t n;
+	int err;
+
+	err = get_user(n, &ua32->op);
+	err |= put_user(n, &a->op);
+	err |= get_user(n, &ua32->flags);
+	err |= put_user(n, &a->flags);
+	err |= get_user(n, &ua32->datalen);
+	err |= put_user(n, &a->datalen);
+	err |= get_user(udata, &ua32->data);
+	err |= put_user(compat_ptr(udata), &a->data);
+	if (err)
+		return err;
+
+	return blkdev_ioctl(inode, file, cmd, (unsigned long)a);
+}
+
 #define BLKBSZGET_32		_IOR(0x12, 112, int)
 #define BLKBSZSET_32		_IOW(0x12, 113, int)
 #define BLKGETSIZE64_32		_IOR(0x12, 114, int)
@@ -350,6 +379,8 @@ long compat_blkdev_ioctl(struct file *fi
 	case BLKBSZSET_32:
 		return blkdev_ioctl(inode, file, BLKBSZSET,
 				(unsigned long)compat_ptr(arg));
+	case BLKPG:
+		return compat_blkpg_ioctl(inode, file, cmd, compat_ptr(arg));
 	}
 
 	lock_kernel();
Index: linux-2.6/fs/compat_ioctl.c
===================================================================
--- linux-2.6.orig/fs/compat_ioctl.c
+++ linux-2.6/fs/compat_ioctl.c
@@ -47,7 +47,6 @@
 #include <linux/netdevice.h>
 #include <linux/raw.h>
 #include <linux/smb_fs.h>
-#include <linux/blkpg.h>
 #include <linux/blkdev.h>
 #include <linux/elevator.h>
 #include <linux/rtc.h>
@@ -1487,37 +1486,6 @@ ret_einval(unsigned int fd, unsigned int
 	return -EINVAL;
 }
 
-#ifdef CONFIG_BLOCK
-struct blkpg_ioctl_arg32 {
-	compat_int_t op;
-	compat_int_t flags;
-	compat_int_t datalen;
-	compat_caddr_t data;
-};
-
-static int blkpg_ioctl_trans(unsigned int fd, unsigned int cmd, unsigned long arg)
-{
-	struct blkpg_ioctl_arg32 __user *ua32 = compat_ptr(arg);
-	struct blkpg_ioctl_arg __user *a = compat_alloc_user_space(sizeof(*a));
-	compat_caddr_t udata;
-	compat_int_t n;
-	int err;
-	
-	err = get_user(n, &ua32->op);
-	err |= put_user(n, &a->op);
-	err |= get_user(n, &ua32->flags);
-	err |= put_user(n, &a->flags);
-	err |= get_user(n, &ua32->datalen);
-	err |= put_user(n, &a->datalen);
-	err |= get_user(udata, &ua32->data);
-	err |= put_user(compat_ptr(udata), &a->data);
-	if (err)
-		return err;
-
-	return sys_ioctl(fd, cmd, (unsigned long)a);
-}
-#endif
-
 static int ioc_settimeout(unsigned int fd, unsigned int cmd, unsigned long arg)
 {
 	return rw_long(fd, AUTOFS_IOC_SETTIMEOUT, arg);
@@ -3160,7 +3128,6 @@ HANDLE_IOCTL(SIOCGSTAMP, do_siocgstamp)
 HANDLE_IOCTL(SIOCGSTAMPNS, do_siocgstampns)
 #endif
 #ifdef CONFIG_BLOCK
-HANDLE_IOCTL(BLKPG, blkpg_ioctl_trans)
 HANDLE_IOCTL(FDSETPRM32, fd_ioctl_trans)
 HANDLE_IOCTL(FDDEFPRM32, fd_ioctl_trans)
 HANDLE_IOCTL(FDGETPRM32, fd_ioctl_trans)

-- 

