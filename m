Return-Path: <linux-kernel-owner+w=401wt.eu-S1756965AbZDCAvG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965AbZDCAvG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 20:51:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbZDCAux
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 20:50:53 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:17692 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751047AbZDCAuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 20:50:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dM1HSqSD8RHEP529vMt9bEdNlJaZz3wFEVbBRZ2EgATVLWvf5Y+mfjl6s1Aa7/NBTB
         mh2wuucj0PRPMl8+DwkXbhHd6tsQ7Ulrd18Fg0lAfQK+XlQE5oPqLcBNfFBUQ9yclaoc
         9neu6pcSWurzgq1dn+xdAr9qtOyoqu4/aW8zc=
MIME-Version: 1.0
Date: Thu, 2 Apr 2009 17:50:49 -0700
Message-ID: <a95a62fe0904021750m7fd01695q3724be49b66a82d@mail.gmail.com>
Subject: [PATCHv5] MTD: New ioctl calls for >4GiB device support
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extend the MTD user ABI to access >4GiB devices using 64-bit offsets.

New ioctls: MEMERASE64 MEMWRITEOOB64 MEMREADOOB64 MEMLOCK64 MEMUNLOCK64

Delta from v4 @ http://tinyurl.com/d6g2ee :

1) Remove MEMGETINFO64, MEMGETREGIONINFO64, in the hopes that they can
be handled through sysfs instead.

2) Use __u64 to store the MEMREADOOB64/MEMWRITEOOB64 user pointer, so
that no compat_ioctl handler is needed.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>
---
 drivers/mtd/mtdchar.c  |  131 +++++++++++++++++++++++++++++++++++++++--------
 fs/compat_ioctl.c      |    5 ++
 include/mtd/mtd-abi.h  |   20 +++++++
 include/mtd/mtd-user.h |    2 +
 4 files changed, 135 insertions(+), 23 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 763d3f0..625dc3b 100644
--- a/drivers/mtd/mtdchar.c
+++ b/drivers/mtd/mtdchar.c
@@ -417,6 +417,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 		break;

 	case MEMERASE:
+	case MEMERASE64:
 	{
 		struct erase_info *erase;

@@ -427,20 +428,32 @@ static int mtd_ioctl(struct inode *inode, struct
file *file,
 		if (!erase)
 			ret = -ENOMEM;
 		else {
-			struct erase_info_user einfo;
-
 			wait_queue_head_t waitq;
 			DECLARE_WAITQUEUE(wait, current);

 			init_waitqueue_head(&waitq);

-			if (copy_from_user(&einfo, argp,
-				    sizeof(struct erase_info_user))) {
-				kfree(erase);
-				return -EFAULT;
+			if (cmd == MEMERASE64) {
+				struct erase_info_user64 einfo64;
+
+				if (copy_from_user(&einfo64, argp,
+					    sizeof(struct erase_info_user64))) {
+					kfree(erase);
+					return -EFAULT;
+				}
+				erase->addr = einfo64.start;
+				erase->len = einfo64.length;
+			} else {
+				struct erase_info_user einfo32;
+
+				if (copy_from_user(&einfo32, argp,
+					    sizeof(struct erase_info_user))) {
+					kfree(erase);
+					return -EFAULT;
+				}
+				erase->addr = einfo32.start;
+				erase->len = einfo32.length;
 			}
-			erase->addr = einfo.start;
-			erase->len = einfo.length;
 			erase->mtd = mtd;
 			erase->callback = mtdchar_erase_callback;
 			erase->priv = (unsigned long)&waitq;
@@ -472,17 +485,38 @@ static int mtd_ioctl(struct inode *inode, struct
file *file,
 	}

 	case MEMWRITEOOB:
+	case MEMWRITEOOB64:
 	{
-		struct mtd_oob_buf buf;
+		struct mtd_oob_buf64 buf;
 		struct mtd_oob_ops ops;
-		struct mtd_oob_buf __user *user_buf = argp;
 	        uint32_t retlen;
+		uint32_t __user *retp, *usr_ptr;

 		if(!(file->f_mode & FMODE_WRITE))
 			return -EPERM;

-		if (copy_from_user(&buf, argp, sizeof(struct mtd_oob_buf)))
-			return -EFAULT;
+		if (cmd == MEMWRITEOOB64) {
+			struct mtd_oob_buf64 __user *user_buf = argp;
+
+			if (copy_from_user(&buf, argp,
+				    sizeof(struct mtd_oob_buf64)))
+				return -EFAULT;
+			retp = &user_buf->length;
+			usr_ptr = (void __user *)(uintptr_t)buf.usr_ptr;
+		} else {
+			struct mtd_oob_buf __user *user_buf = argp;
+			struct mtd_oob_buf buf32;
+
+			if (copy_from_user(&buf32, argp,
+				    sizeof(struct mtd_oob_buf)))
+				return -EFAULT;
+
+			buf.start = buf32.start;
+			buf.length = buf32.length;
+
+			retp = &user_buf->length;
+			usr_ptr = (void __user *)buf32.ptr;
+		}

 		if (buf.length > 4096)
 			return -EINVAL;
@@ -490,7 +524,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 		if (!mtd->write_oob)
 			ret = -EOPNOTSUPP;
 		else
-			ret = access_ok(VERIFY_READ, buf.ptr,
+			ret = access_ok(VERIFY_READ, usr_ptr,
 					buf.length) ? 0 : EFAULT;

 		if (ret)
@@ -508,18 +542,18 @@ static int mtd_ioctl(struct inode *inode, struct
file *file,
 		if (!ops.oobbuf)
 			return -ENOMEM;

-		if (copy_from_user(ops.oobbuf, buf.ptr, buf.length)) {
+		if (copy_from_user(ops.oobbuf, usr_ptr, buf.length)) {
 			kfree(ops.oobbuf);
 			return -EFAULT;
 		}

-		buf.start &= ~(mtd->oobsize - 1);
+		buf.start &= ~((uint64_t)mtd->oobsize - 1);
 		ret = mtd->write_oob(mtd, buf.start, &ops);

 		if (ops.oobretlen > 0xFFFFFFFFU)
 			ret = -EOVERFLOW;
 		retlen = ops.oobretlen;
-		if (copy_to_user(&user_buf->length, &retlen, sizeof(buf.length)))
+		if (copy_to_user(retp, &retlen, sizeof(buf.length)))
 			ret = -EFAULT;

 		kfree(ops.oobbuf);
@@ -528,12 +562,35 @@ static int mtd_ioctl(struct inode *inode, struct
file *file,
 	}

 	case MEMREADOOB:
+	case MEMREADOOB64:
 	{
-		struct mtd_oob_buf buf;
+		struct mtd_oob_buf64 buf;
 		struct mtd_oob_ops ops;
+		uint32_t __user *retp, *usr_ptr;

-		if (copy_from_user(&buf, argp, sizeof(struct mtd_oob_buf)))
-			return -EFAULT;
+		if (cmd == MEMREADOOB64) {
+			struct mtd_oob_buf64 __user *user_buf = argp;
+
+			if (copy_from_user(&buf, user_buf,
+				    sizeof(struct mtd_oob_buf64)))
+				return -EFAULT;
+
+			retp = &user_buf->length;
+			usr_ptr = (void __user *)(uintptr_t)buf.usr_ptr;
+		} else {
+			struct mtd_oob_buf __user *user_buf = argp;
+			struct mtd_oob_buf buf32;
+
+			if (copy_from_user(&buf32, user_buf,
+				    sizeof(struct mtd_oob_buf)))
+				return -EFAULT;
+			buf.start = buf32.start;
+			buf.length = buf32.length;
+
+			/* MEMREADOOB returned length goes in "start" field */
+			retp = &user_buf->start;
+			usr_ptr = (void __user *)buf32.ptr;
+		}

 		if (buf.length > 4096)
 			return -EINVAL;
@@ -541,7 +598,7 @@ static int mtd_ioctl(struct inode *inode, struct file *file,
 		if (!mtd->read_oob)
 			ret = -EOPNOTSUPP;
 		else
-			ret = access_ok(VERIFY_WRITE, buf.ptr,
+			ret = access_ok(VERIFY_WRITE, usr_ptr,
 					buf.length) ? 0 : -EFAULT;
 		if (ret)
 			return ret;
@@ -558,12 +615,12 @@ static int mtd_ioctl(struct inode *inode, struct
file *file,
 		if (!ops.oobbuf)
 			return -ENOMEM;

-		buf.start &= ~(mtd->oobsize - 1);
+		buf.start &= ~((uint64_t)mtd->oobsize - 1);
 		ret = mtd->read_oob(mtd, buf.start, &ops);

-		if (put_user(ops.oobretlen, (uint32_t __user *)argp))
+		if (put_user(ops.oobretlen, retp))
 			ret = -EFAULT;
-		else if (ops.oobretlen && copy_to_user(buf.ptr, ops.oobbuf,
+		else if (ops.oobretlen && copy_to_user(usr_ptr, ops.oobbuf,
 						    ops.oobretlen))
 			ret = -EFAULT;

@@ -585,6 +642,20 @@ static int mtd_ioctl(struct inode *inode, struct
file *file,
 		break;
 	}

+	case MEMLOCK64:
+	{
+		struct erase_info_user64 einfo64;
+
+		if (copy_from_user(&einfo64, argp, sizeof(einfo64)))
+			return -EFAULT;
+
+		if (!mtd->lock)
+			ret = -EOPNOTSUPP;
+		else
+			ret = mtd->lock(mtd, einfo64.start, einfo64.length);
+		break;
+	}
+
 	case MEMUNLOCK:
 	{
 		struct erase_info_user einfo;
@@ -599,6 +670,20 @@ static int mtd_ioctl(struct inode *inode, struct
file *file,
 		break;
 	}

+	case MEMUNLOCK64:
+	{
+		struct erase_info_user64 einfo64;
+
+		if (copy_from_user(&einfo64, argp, sizeof(einfo64)))
+			return -EFAULT;
+
+		if (!mtd->unlock)
+			ret = -EOPNOTSUPP;
+		else
+			ret = mtd->unlock(mtd, einfo64.start, einfo64.length);
+		break;
+	}
+
 	/* Legacy interface */
 	case MEMGETOOBSEL:
 	{
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 45e59d3..d7be0ea 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2434,6 +2434,11 @@ COMPATIBLE_IOCTL(MEMGETREGIONCOUNT)
 COMPATIBLE_IOCTL(MEMGETREGIONINFO)
 COMPATIBLE_IOCTL(MEMGETBADBLOCK)
 COMPATIBLE_IOCTL(MEMSETBADBLOCK)
+COMPATIBLE_IOCTL(MEMERASE64)
+COMPATIBLE_IOCTL(MEMWRITEOOB64)
+COMPATIBLE_IOCTL(MEMREADOOB64)
+COMPATIBLE_IOCTL(MEMLOCK64)
+COMPATIBLE_IOCTL(MEMUNLOCK64)
 /* NBD */
 ULONG_IOCTL(NBD_SET_SOCK)
 ULONG_IOCTL(NBD_SET_BLKSIZE)
diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
index c6c61cd..6414dc6 100644
--- a/include/mtd/mtd-abi.h
+++ b/include/mtd/mtd-abi.h
@@ -5,17 +5,31 @@
 #ifndef __MTD_ABI_H__
 #define __MTD_ABI_H__

+#include <linux/types.h>
+
 struct erase_info_user {
 	uint32_t start;
 	uint32_t length;
 };

+struct erase_info_user64 {
+	__u64    start;
+	__u64    length;
+};
+
 struct mtd_oob_buf {
 	uint32_t start;
 	uint32_t length;
 	unsigned char __user *ptr;
 };

+struct mtd_oob_buf64 {
+	__u64    start;
+	__u32    res0;
+	__u32    length;
+	__u64    usr_ptr;
+};
+
 #define MTD_ABSENT		0
 #define MTD_RAM			1
 #define MTD_ROM			2
@@ -94,6 +108,12 @@ struct otp_info {
 #define ECCGETSTATS		_IOR('M', 18, struct mtd_ecc_stats)
 #define MTDFILEMODE		_IO('M', 19)

+#define MEMERASE64		_IOW('M', 20, struct erase_info_user64)
+#define MEMWRITEOOB64		_IOWR('M', 21, struct mtd_oob_buf64)
+#define MEMREADOOB64		_IOWR('M', 22, struct mtd_oob_buf64)
+#define MEMLOCK64		_IOW('M', 23, struct erase_info_user64)
+#define MEMUNLOCK64		_IOW('M', 24, struct erase_info_user64)
+
 /*
  * Obsolete legacy interface. Keep it in order not to break userspace
  * interfaces
diff --git a/include/mtd/mtd-user.h b/include/mtd/mtd-user.h
index 170ceca..a5ec18e 100644
--- a/include/mtd/mtd-user.h
+++ b/include/mtd/mtd-user.h
@@ -16,4 +16,6 @@ typedef struct region_info_user region_info_t;
 typedef struct nand_oobinfo nand_oobinfo_t;
 typedef struct nand_ecclayout nand_ecclayout_t;

+typedef struct erase_info_user64 erase_info64_t;
+
 #endif /* __MTD_USER_H__ */
-- 
1.5.6.3
