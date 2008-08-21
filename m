Return-Path: <linux-kernel-owner+w=401wt.eu-S1756389AbYHUFrf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756389AbYHUFrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 01:47:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755722AbYHUFpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 01:45:38 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:25301 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755710AbYHUFpf (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 01:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:reply-to:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=g8Ho2rNpHbsMAlFQRiKjMEIDsW1TcPLPsfdG7HYQ3w4zGClAYP8WclUtDukAo3dmXQ
         rfI9268En8Cn657pSqAcU7aNbIgQJwu5HvDjpeq678T2NgBmx2/E8FiGCTMbS1vUwIvi
         CLswXm4bOQLvRPGn+Wc1XblGkQ259g0R9TWHg=
Message-ID: <48AD010B.6030209@gmail.com>
Date: Wed, 20 Aug 2008 22:45:47 -0700
From: Jared Hulbert <jaredeh@gmail.com>
Reply-To: jaredeh@gmail.com
User-Agent: Thunderbird 2.0.0.12 (Macintosh/20080213)
MIME-Version: 1.0
To: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?ISO-8859-1?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@AM.SONY.COM,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: [PATCH 07/10] AXFS: axfs_bdev.c
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All the block device code goes here.

Signed-off-by: Jared Hulbert <jaredeh@gmail.com>
---
diff --git a/fs/axfs/axfs_bdev.c b/fs/axfs/axfs_bdev.c
new file mode 100644
index 0000000..4c6f83c
--- /dev/null
+++ b/fs/axfs/axfs_bdev.c
@@ -0,0 +1,158 @@
+/*
+ * Advanced XIP File System for Linux - AXFS
+ *   Readonly, compressed, and XIP filesystem for Linux systems big and small
+ *
+ * Copyright(c) 2008 Numonyx
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * Authors:
+ *  Jared Hulbert <jaredeh@gmail.com>
+ *
+ * Project url: http://axfs.sourceforge.net
+ *
+ * axfs_bdev.c -
+ *   Allows axfs to use block devices or has dummy functions if block
+ *   device support is compiled out of the kernel.
+ *
+ */
+
+#include <linux/axfs.h>
+#include <linux/mount.h>
+#ifdef CONFIG_BLOCK
+#include <linux/buffer_head.h>
+#include <linux/namei.h>
+
+int axfs_fill_super(struct super_block *sb, void *data, int silent);
+
+int axfs_get_sb_bdev(struct file_system_type *fs_type, int flags,
+		     const char *dev_name, struct axfs_super *sbi,
+		     struct vfsmount *mnt, int *err)
+{
+	*err = get_sb_bdev(fs_type, flags, dev_name, sbi, axfs_fill_super, mnt);
+
+	if (*err)
+		return FALSE;
+	return TRUE;
+}
+
+void axfs_kill_block_super(struct super_block *sb)
+{
+	kill_block_super(sb);
+}
+
+/******************************************************************************
+ *
+ * axfs_copy_block_data
+ *
+ * Description: Helper function to read data from block device
+ *
+ * Parameters:
+ *    (IN) sb - pointer to super block structure.
+ *
+ *    (IN) dst_addr - pointer to buffer into which data is to be read.
+ *
+ *    (IN) boffset - offset within block device
+ *
+ *    (IN) len - length of data to be read
+ *
+ * Returns:
+ *     0 or error number
+ *
+ *****************************************************************************/
+int axfs_copy_block(struct super_block *sb, void *dst_addr, u64 fsoffset,
+		    u64 len)
+{
+	struct axfs_super *sbi = AXFS_SB(sb);
+	u64 boffset = AXFS_FSOFFSET_2_DEVOFFSET(sbi, fsoffset);
+	u64 blocks;
+	u64 blksize = sb->s_blocksize;
+	unsigned long dst;
+	unsigned long src;
+	sector_t block;
+	size_t bytes;
+	struct buffer_head *bh;
+	u64 copied = 0;
+
+	if (len == 0)
+		return 0;
+
+	blocks = len / blksize;
+	if ((len % blksize) > 0)
+		blocks += 1;
+
+	while (copied < len) {
+		/* Explicit casting for ARM linker errors. */
+		block = (sector_t) boffset + (sector_t) copied;
+		block /= (sector_t) blksize;
+		bh = sb_bread(sb, block);
+		src = (unsigned long)bh->b_data;
+		dst = (unsigned long)dst_addr;
+		if (copied == 0) {
+			/* Explicit casting for ARM linker errors. */
+			bytes = (size_t) blksize;
+			bytes -= (size_t) boffset % (size_t) blksize;
+			if (bytes > len)
+				bytes = len;
+			/* Explicit casting for ARM linker errors. */
+			src += (unsigned long)boffset % (unsigned long)blksize;
+		} else {
+			dst += copied;
+			if ((len - copied) < blksize) {
+				bytes = len - copied;
+			} else {
+				bytes = blksize;
+			}
+		}
+		memcpy((void *)dst, (void *)src, bytes);
+		copied += bytes;
+		brelse(bh);
+	}
+	return 0;
+}
+
+int axfs_is_dev_bdev(char *path)
+{
+	struct nameidata nd;
+	int ret = FALSE;
+
+	if (!path)
+		return FALSE;
+
+	if (path_lookup(path, LOOKUP_FOLLOW, &nd))
+		return FALSE;
+
+	if (S_ISBLK(nd.path.dentry->d_inode->i_mode))
+		ret = TRUE;
+
+	path_put(&nd.path);
+	return ret;
+}
+
+#else
+
+int axfs_get_sb_bdev(struct file_system_type *fs_type, int flags,
+		     const char *dev_name, struct axfs_super *sbi,
+		     struct vfsmount *mnt, int *err)
+{
+	return FALSE;
+}
+
+void axfs_kill_block_super(struct super_block *sb)
+{
+}
+
+int axfs_copy_block(struct super_block *sb, void *dst_addr, u64 fsoffset,
+		    u64 len)
+{
+	return -EINVAL;
+}
+
+int axfs_is_dev_bdev(char *path)
+{
+	return FALSE;
+}
+
+#endif /* CONFIG_BLOCK */


