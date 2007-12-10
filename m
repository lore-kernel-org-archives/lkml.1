Return-Path: <linux-kernel-owner+w=401wt.eu-S1751941AbXLJCsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbXLJCsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 21:48:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbXLJCnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 21:43:24 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:49794 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750AbXLJCnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 21:43:16 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: hch@infradead.org, viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 26/42] Unionfs: extended attributes operations
Date: Sun,  9 Dec 2007 21:41:59 -0500
Message-Id: <11972545511474-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
References: <11972545353262-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/xattr.c |  153 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 153 insertions(+), 0 deletions(-)
 create mode 100644 fs/unionfs/xattr.c

diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
new file mode 100644
index 0000000..00c6d0d
--- /dev/null
+++ b/fs/unionfs/xattr.c
@@ -0,0 +1,153 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2006 Charles P. Wright
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2005      Arun M. Krishnakumar
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
+ * Copyright (c) 2003      Puja Gupta
+ * Copyright (c) 2003      Harikesavan Krishnan
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
+#include "union.h"
+
+/* This is lifted from fs/xattr.c */
+void *unionfs_xattr_alloc(size_t size, size_t limit)
+{
+	void *ptr;
+
+	if (size > limit)
+		return ERR_PTR(-E2BIG);
+
+	if (!size)		/* size request, no buffer is needed */
+		return NULL;
+
+	ptr = kmalloc(size, GFP_KERNEL);
+	if (unlikely(!ptr))
+		return ERR_PTR(-ENOMEM);
+	return ptr;
+}
+
+/*
+ * BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+ssize_t unionfs_getxattr(struct dentry *dentry, const char *name, void *value,
+			 size_t size)
+{
+	struct dentry *lower_dentry = NULL;
+	int err = -EOPNOTSUPP;
+
+	unionfs_read_lock(dentry->d_sb);
+	unionfs_lock_dentry(dentry);
+
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
+		err = -ESTALE;
+		goto out;
+	}
+
+	lower_dentry = unionfs_lower_dentry(dentry);
+
+	err = vfs_getxattr(lower_dentry, (char *) name, value, size);
+
+out:
+	unionfs_check_dentry(dentry);
+	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
+	return err;
+}
+
+/*
+ * BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+int unionfs_setxattr(struct dentry *dentry, const char *name,
+		     const void *value, size_t size, int flags)
+{
+	struct dentry *lower_dentry = NULL;
+	int err = -EOPNOTSUPP;
+
+	unionfs_read_lock(dentry->d_sb);
+	unionfs_lock_dentry(dentry);
+
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
+		err = -ESTALE;
+		goto out;
+	}
+
+	lower_dentry = unionfs_lower_dentry(dentry);
+
+	err = vfs_setxattr(lower_dentry, (char *) name, (void *) value,
+			   size, flags);
+
+out:
+	unionfs_check_dentry(dentry);
+	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
+	return err;
+}
+
+/*
+ * BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+int unionfs_removexattr(struct dentry *dentry, const char *name)
+{
+	struct dentry *lower_dentry = NULL;
+	int err = -EOPNOTSUPP;
+
+	unionfs_read_lock(dentry->d_sb);
+	unionfs_lock_dentry(dentry);
+
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
+		err = -ESTALE;
+		goto out;
+	}
+
+	lower_dentry = unionfs_lower_dentry(dentry);
+
+	err = vfs_removexattr(lower_dentry, (char *) name);
+
+out:
+	unionfs_check_dentry(dentry);
+	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
+	return err;
+}
+
+/*
+ * BKL held by caller.
+ * dentry->d_inode->i_mutex locked
+ */
+ssize_t unionfs_listxattr(struct dentry *dentry, char *list, size_t size)
+{
+	struct dentry *lower_dentry = NULL;
+	int err = -EOPNOTSUPP;
+	char *encoded_list = NULL;
+
+	unionfs_read_lock(dentry->d_sb);
+	unionfs_lock_dentry(dentry);
+
+	if (unlikely(!__unionfs_d_revalidate_chain(dentry, NULL, false))) {
+		err = -ESTALE;
+		goto out;
+	}
+
+	lower_dentry = unionfs_lower_dentry(dentry);
+
+	encoded_list = list;
+	err = vfs_listxattr(lower_dentry, encoded_list, size);
+
+out:
+	unionfs_check_dentry(dentry);
+	unionfs_unlock_dentry(dentry);
+	unionfs_read_unlock(dentry->d_sb);
+	return err;
+}
-- 
1.5.2.2

