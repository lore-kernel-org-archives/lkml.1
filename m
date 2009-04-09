Return-Path: <linux-kernel-owner+w=401wt.eu-S1761802AbZDIFwm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761802AbZDIFwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 01:52:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZDIFwb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 01:52:31 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:45005 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753761AbZDIFw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 01:52:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=FL13UDu4lrkVGyk1d8vogJYWD77hYNNpgVe+fuIH2YhkIWUq7HgI0dO2M2/RxAPWkL
         xT2CoX3qesLcEjZVdzEIAvOF8N77Cxu6OBp/kFazSFF14JcjboZztMCpz5gHQBvJKEE/
         kiVqABPT6KeuHvnlW7YtNUuAWACqHl3//9lHE=
MIME-Version: 1.0
Date: Wed, 8 Apr 2009 22:52:28 -0700
Message-ID: <a95a62fe0904082252h41afa872j2ef6fb9d1d76dc27@mail.gmail.com>
Subject: [PATCH 2/4] [MTD] Add MEMERASE64 ioctl for >4GiB devices
From: Kevin Cernekee <kpc.mtd@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Linux MTD <linux-mtd@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

New MEMERASE/MEMREADOOB/MEMWRITEOOB ioctls are needed in order to support
64-bit offsets into large NAND flash devices.

Signed-off-by: Kevin Cernekee <kpc.mtd@gmail.com>

---
 drivers/mtd/mtdchar.c |   29 +++++++++++++++++++++--------
 fs/compat_ioctl.c     |    1 +
 include/mtd/mtd-abi.h |    6 ++++++
 3 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
index 763d3f0..ad4b861 100644
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
diff --git a/fs/compat_ioctl.c b/fs/compat_ioctl.c
index 3e87ce4..06d4e0c 100644
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -2441,6 +2441,7 @@ COMPATIBLE_IOCTL(MEMGETREGIONCOUNT)
 COMPATIBLE_IOCTL(MEMGETREGIONINFO)
 COMPATIBLE_IOCTL(MEMGETBADBLOCK)
 COMPATIBLE_IOCTL(MEMSETBADBLOCK)
+COMPATIBLE_IOCTL(MEMERASE64)
 /* NBD */
 ULONG_IOCTL(NBD_SET_SOCK)
 ULONG_IOCTL(NBD_SET_BLKSIZE)
diff --git a/include/mtd/mtd-abi.h b/include/mtd/mtd-abi.h
index b6595b3..2e32be1 100644
--- a/include/mtd/mtd-abi.h
+++ b/include/mtd/mtd-abi.h
@@ -12,6 +12,11 @@ struct erase_info_user {
 	__u32 length;
 };

+struct erase_info_user64 {
+	__u64 start;
+	__u64 length;
+};
+
 struct mtd_oob_buf {
 	__u32 start;
 	__u32 length;
@@ -95,6 +100,7 @@ struct otp_info {
 #define ECCGETLAYOUT		_IOR('M', 17, struct nand_ecclayout)
 #define ECCGETSTATS		_IOR('M', 18, struct mtd_ecc_stats)
 #define MTDFILEMODE		_IO('M', 19)
+#define MEMERASE64		_IOW('M', 20, struct erase_info_user64)

 /*
  * Obsolete legacy interface. Keep it in order not to break userspace
-- 
1.5.4.3
