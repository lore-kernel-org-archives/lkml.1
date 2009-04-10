Return-Path: <linux-kernel-owner+w=401wt.eu-S937094AbZDJHRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937094AbZDJHRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 03:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761476AbZDJHQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 03:16:44 -0400
Received: from mfbichi12.ns.itscom.net ([219.110.2.190]:35911 "EHLO
	mfbichi12.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759307AbZDJHQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 03:16:43 -0400
X-Greylist: delayed 815 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2009 03:16:43 EDT
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, linux-fsdevel@vger.kernel.org,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: [RFC Aufs2 #5 22/29] aufs branch for loopback block device
Date: Fri, 10 Apr 2009 16:02:36 +0900
Message-Id: <1239346963-30953-23-git-send-email-hooanon05@yahoo.co.jp>
X-Mailer: git-send-email 1.6.1.284.g5dc13
In-Reply-To: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
References: <1239346963-30953-1-git-send-email-hooanon05@yahoo.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

initial commit
support and test loopback block device as a branch

Signed-off-by: J. R. Okajima <hooanon05@yahoo.co.jp>
---
 fs/aufs/loop.c |   46 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/aufs/loop.h |   41 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 87 insertions(+), 0 deletions(-)
 create mode 100644 fs/aufs/loop.c
 create mode 100644 fs/aufs/loop.h

diff --git a/fs/aufs/loop.c b/fs/aufs/loop.c
new file mode 100644
index 0000000..84a940f
--- /dev/null
+++ b/fs/aufs/loop.c
@@ -0,0 +1,46 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * support for loopback block device as a branch
+ */
+
+#include <linux/loop.h>
+#include "aufs.h"
+
+/*
+ * test if two lower dentries have overlapping branches.
+ */
+int au_test_loopback_overlap(struct super_block *sb, struct dentry *h_d1,
+			     struct dentry *h_d2)
+{
+	struct inode *h_inode;
+	struct loop_device *l;
+
+	h_inode = h_d1->d_inode;
+	if (MAJOR(h_inode->i_sb->s_dev) != LOOP_MAJOR)
+		return 0;
+
+	l = h_inode->i_sb->s_bdev->bd_disk->private_data;
+	h_d1 = l->lo_backing_file->f_dentry;
+	/* h_d1 can be local NFS. in this case aufs cannot detect the loop */
+	if (unlikely(h_d1->d_sb == sb))
+		return 1;
+	return !!au_test_subdir(h_d1, h_d2);
+}
+
+/* true if a kernel thread named 'loop[0-9].*' accesses a file */
+int au_test_loopback_kthread(void)
+{
+	const char c = current->comm[4];
+
+	return current->mm == NULL
+	       && '0' <= c && c <= '9'
+	       && strncmp(current->comm, "loop", 4) == 0;
+}
diff --git a/fs/aufs/loop.h b/fs/aufs/loop.h
new file mode 100644
index 0000000..1c0ee40
--- /dev/null
+++ b/fs/aufs/loop.h
@@ -0,0 +1,41 @@
+/*
+ * Copyright (C) 2005-2009 Junjiro R. Okajima
+ *
+ * This program, aufs is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ */
+
+/*
+ * support for loopback mount as a branch
+ */
+
+#ifndef __AUFS_LOOP_H__
+#define __AUFS_LOOP_H__
+
+#ifdef __KERNEL__
+
+#include <linux/fs.h>
+
+#ifdef CONFIG_AUFS_BDEV_LOOP
+/* loop.c */
+int au_test_loopback_overlap(struct super_block *sb, struct dentry *h_d1,
+			     struct dentry *h_d2);
+int au_test_loopback_kthread(void);
+#else
+static inline
+int au_test_loopback_overlap(struct super_block *sb, struct dentry *h_d1,
+			     struct dentry *h_d2)
+{
+	return 0;
+}
+
+static inline int au_test_loopback_kthread(void)
+{
+	return 0;
+}
+#endif /* BLK_DEV_LOOP */
+
+#endif /* __KERNEL__ */
+#endif /* __AUFS_LOOP_H__ */
-- 
1.6.1.284.g5dc13

