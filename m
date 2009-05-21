Return-Path: <linux-kernel-owner+w=401wt.eu-S1757084AbZEUUCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084AbZEUUCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 16:02:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755701AbZEUUBR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 16:01:17 -0400
Received: from thunk.org ([69.25.196.29]:39200 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbZEUUBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 16:01:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 5/5] Dump the inode structure (for debugging purposes only)
Date: Thu, 21 May 2009 16:01:03 -0400
Message-Id: <1242936063-31689-6-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.6.3.1.1.g75fc.dirty
In-Reply-To: <1242936063-31689-5-git-send-email-tytso@mit.edu>
References: <1242936063-31689-1-git-send-email-tytso@mit.edu>
 <1242936063-31689-2-git-send-email-tytso@mit.edu>
 <1242936063-31689-3-git-send-email-tytso@mit.edu>
 <1242936063-31689-4-git-send-email-tytso@mit.edu>
 <1242936063-31689-5-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not intended for merging; but it's useful for determining how
much varous fields in the struct inode space, and whether there is any
padding leading to waste, especially on a 64-bit platforms.

For example:

Begin dump of struct inode (size 1144)
i_hash    : 0 16 0
i_list    : 16 16 0
i_sb_list : 32 16 0
i_dentry  : 48 16 0
i_ino     : 64 8 0
i_count   : 72 4 0
i_nlink   : 76 4 0
i_uid     : 80 4 0
i_gid     : 84 4 0
i_rdev    : 88 4 0
i_version : 96 8 4
i_size    : 104 8 0
i_atime   : 112 16 0
i_mtime   : 128 16 0
i_ctime   : 144 16 0
i_blocks  : 160 8 0
i_blkbits : 168 4 0
i_bytes   : 172 2 0
i_mode    : 174 2 0
i_lock    : 176 64 0
i_mutex   : 240 152 0
i_alloc_sem: 392 128 0
i_op      : 520 8 0
i_fop     : 528 8 0
i_sb      : 536 8 0
i_flock   : 544 8 0
i_mapping : 552 8 0
i_data    : 560 328 0
i_dquot   : 888 16 0
i_devices : 904 16 0
i_pipe    : 920 8 0
i_bdev    : 920 8 -8
i_cdev    : 920 8 -8
i_generation: 928 4 0
i_dnotify_mask: 932 4 0
i_dnotify : 936 8 0
inotify_watches: 944 16 0
inotify_mutex: 960 152 0
dirtied_when: 1112 8 0
i_state   : 1120 2 0
i_flags   : 1122 2 0
i_writecount: 1124 4 0
i_security: 1128 8 0
i_private : 1136 8 0

This shows us that i_data, an struct address_space data structure,
takes 328 bytes; i_mutex takes 152 bytes, the i_alloc_sem rw_semaphore
takes 128 bytes, and the i_lock spinlock takes 64 bytes.  A lot of
this space is due to varous LOCKDEP and spinlock debugging options.

(With all debugging turned off, the inode structure shrinks from 1144
bytes to 560 bytes, with i_data being 144 bytes, i_mutex being 32
bytes, i_alloc_sem being 24 bytes, and i_lock taking 4 bytes.)
---
 fs/Makefile              |    1 +
 fs/inode-struct-dumper.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 88 insertions(+), 0 deletions(-)
 create mode 100644 fs/inode-struct-dumper.c

diff --git a/fs/Makefile b/fs/Makefile
index af6d047..196f3f5 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_EVENTFD)		+= eventfd.o
 obj-$(CONFIG_AIO)               += aio.o
 obj-$(CONFIG_FILE_LOCKING)      += locks.o
 obj-$(CONFIG_COMPAT)		+= compat.o compat_ioctl.o
+obj-y				+= inode-struct-dumper.o	
 
 nfsd-$(CONFIG_NFSD)		:= nfsctl.o
 obj-y				+= $(nfsd-y) $(nfsd-m)
diff --git a/fs/inode-struct-dumper.c b/fs/inode-struct-dumper.c
new file mode 100644
index 0000000..c85d792
--- /dev/null
+++ b/fs/inode-struct-dumper.c
@@ -0,0 +1,87 @@
+/*
+ * inode struct dumper --- dump out the inode structure
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include <linux/kernel.h>
+#include <linux/fs.h>
+#include <linux/stddef.h>
+
+#define ELEMENT(xx) { \
+	offset=offsetof(struct inode, xx);		 \
+	size=sizeof(p->xx);					\
+	printk(KERN_NOTICE "%-10s: %d %d %d\n", #xx,		 \
+	       offset, size, offset-(last_offset+last_size));	\
+	last_offset=offset;					\
+	last_size = size;					\
+	}
+
+static int __init dumper_init(void)
+{
+	struct inode *p;
+	int offset, size, last_offset=0, last_size=0;
+
+	printk(KERN_NOTICE "Begin dump of struct inode (size %lu)\n",
+	       sizeof(struct inode));
+	ELEMENT(i_hash);
+	ELEMENT(i_list);
+	ELEMENT(i_sb_list);
+	ELEMENT(i_dentry);
+	ELEMENT(i_ino);
+	ELEMENT(i_count);
+	ELEMENT(i_nlink);
+	ELEMENT(i_uid);
+	ELEMENT(i_gid);
+	ELEMENT(i_rdev);
+	ELEMENT(i_version);
+	ELEMENT(i_size);
+#ifdef __NEED_I_SIZE_ORDERED
+	ELEMENT(i_size_seqcount);
+#endif
+	ELEMENT(i_atime);
+	ELEMENT(i_mtime);
+	ELEMENT(i_ctime);
+	ELEMENT(i_blocks);
+	ELEMENT(i_blkbits);
+	ELEMENT(i_bytes);
+	ELEMENT(i_mode);
+	ELEMENT(i_lock);
+	ELEMENT(i_mutex);
+	ELEMENT(i_alloc_sem);
+	ELEMENT(i_op);
+	ELEMENT(i_fop);
+	ELEMENT(i_sb);
+	ELEMENT(i_flock);
+	ELEMENT(i_mapping);
+	ELEMENT(i_data);
+#ifdef CONFIG_QUOTA
+	ELEMENT(i_dquot);
+#endif
+	ELEMENT(i_devices);
+	ELEMENT(i_pipe);
+	ELEMENT(i_bdev);
+	ELEMENT(i_cdev);
+	ELEMENT(i_generation);
+#ifdef CONFIG_DNOTIFY
+	ELEMENT(i_dnotify_mask);
+	ELEMENT(i_dnotify);
+#endif
+#ifdef CONFIG_INOTIFY
+	ELEMENT(inotify_watches);
+	ELEMENT(inotify_mutex);
+#endif
+	ELEMENT(dirtied_when);
+	ELEMENT(i_state);
+	ELEMENT(i_flags);
+	ELEMENT(i_writecount);
+#ifdef CONFIG_SECURITY
+	ELEMENT(i_security);
+#endif
+	ELEMENT(i_private);
+	return 0;
+}
+
+module_init(dumper_init);
+
-- 
1.6.3.1.1.g75fc.dirty

