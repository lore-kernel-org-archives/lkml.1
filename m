Return-Path: <linux-kernel-owner+w=401wt.eu-S1763953AbXEXAm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763953AbXEXAm1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761853AbXEXAhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:37:09 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40257 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761637AbXEXAhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:37:00 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 10/21] Unionfs: Move unionfs_query_file to commonfops.c
Date: Wed, 23 May 2007 20:36:00 -0400
Message-Id: <11799669734102-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Moved unionfs_query_file closer to its one user in commonfops.c.
Additionally, it can now become static, and branchman.c can be removed as it
is empty.

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/Makefile     |    4 +-
 fs/unionfs/branchman.c  |   60 -----------------------------------------------
 fs/unionfs/commonfops.c |   41 ++++++++++++++++++++++++++++++++
 fs/unionfs/union.h      |    6 ----
 4 files changed, 43 insertions(+), 68 deletions(-)
 delete mode 100644 fs/unionfs/branchman.c

diff --git a/fs/unionfs/Makefile b/fs/unionfs/Makefile
index e6b2e0c..6986d79 100644
--- a/fs/unionfs/Makefile
+++ b/fs/unionfs/Makefile
@@ -1,7 +1,7 @@
 obj-$(CONFIG_UNION_FS) += unionfs.o
 
 unionfs-y := subr.o dentry.o file.o inode.o main.o super.o \
-	branchman.o rdstate.o copyup.o dirhelper.o rename.o \
-	unlink.o lookup.o commonfops.o dirfops.o sioq.o
+	rdstate.o copyup.o dirhelper.o rename.o unlink.o \
+	lookup.o commonfops.o dirfops.o sioq.o
 
 unionfs-$(CONFIG_UNION_FS_XATTR) += xattr.o
diff --git a/fs/unionfs/branchman.c b/fs/unionfs/branchman.c
deleted file mode 100644
index 4545e18..0000000
--- a/fs/unionfs/branchman.c
+++ /dev/null
@@ -1,60 +0,0 @@
-/*
- * Copyright (c) 2003-2007 Erez Zadok
- * Copyright (c) 2003-2006 Charles P. Wright
- * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
- * Copyright (c) 2005-2006 Junjiro Okajima
- * Copyright (c) 2005      Arun M. Krishnakumar
- * Copyright (c) 2004-2006 David P. Quigley
- * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
- * Copyright (c) 2003      Puja Gupta
- * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#include "union.h"
-
-/*
- * return to user-space the branch indices containing the file in question
- *
- * We use fd_set and therefore we are limited to the number of the branches
- * to FD_SETSIZE, which is currently 1024 - plenty for most people
- */
-int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
-			    unsigned long arg)
-{
-	int err = 0;
-	fd_set branchlist;
-
-	int bstart = 0, bend = 0, bindex = 0;
-	struct dentry *dentry, *hidden_dentry;
-
-	dentry = file->f_dentry;
-	unionfs_lock_dentry(dentry);
-	if ((err = unionfs_partial_lookup(dentry)))
-		goto out;
-	bstart = dbstart(dentry);
-	bend = dbend(dentry);
-
-	FD_ZERO(&branchlist);
-
-	for (bindex = bstart; bindex <= bend; bindex++) {
-		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
-		if (!hidden_dentry)
-			continue;
-		if (hidden_dentry->d_inode)
-			FD_SET(bindex, &branchlist);
-	}
-
-	err = copy_to_user((void __user *)arg, &branchlist, sizeof(fd_set));
-	if (err)
-		err = -EFAULT;
-
-out:
-	unionfs_unlock_dentry(dentry);
-	return err < 0 ? err : bend;
-}
diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index a57471e..69d9c87 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -632,6 +632,47 @@ out:
 	return err;
 }
 
+/*
+ * return to user-space the branch indices containing the file in question
+ *
+ * We use fd_set and therefore we are limited to the number of the branches
+ * to FD_SETSIZE, which is currently 1024 - plenty for most people
+ */
+static int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
+				   unsigned long arg)
+{
+	int err = 0;
+	fd_set branchlist;
+
+	int bstart = 0, bend = 0, bindex = 0;
+	struct dentry *dentry, *hidden_dentry;
+
+	dentry = file->f_dentry;
+	unionfs_lock_dentry(dentry);
+	if ((err = unionfs_partial_lookup(dentry)))
+		goto out;
+	bstart = dbstart(dentry);
+	bend = dbend(dentry);
+
+	FD_ZERO(&branchlist);
+
+	for (bindex = bstart; bindex <= bend; bindex++) {
+		hidden_dentry = unionfs_lower_dentry_idx(dentry, bindex);
+		if (!hidden_dentry)
+			continue;
+		if (hidden_dentry->d_inode)
+			FD_SET(bindex, &branchlist);
+	}
+
+	err = copy_to_user((void __user *)arg, &branchlist, sizeof(fd_set));
+	if (err)
+		err = -EFAULT;
+
+out:
+	unionfs_unlock_dentry(dentry);
+	return err < 0 ? err : bend;
+}
+
 long unionfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long err;
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index fee4f88..dab408f 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -319,12 +319,6 @@ int __unionfs_d_revalidate_chain(struct dentry *dentry, struct nameidata *nd);
 extern int unionfs_interpose(struct dentry *this_dentry,
 			     struct super_block *sb, int flag);
 
-/* Branch management ioctls. */
-int unionfs_ioctl_incgen(struct file *file, unsigned int cmd,
-			 unsigned long arg);
-int unionfs_ioctl_queryfile(struct file *file, unsigned int cmd,
-			    unsigned long arg);
-
 #ifdef CONFIG_UNION_FS_XATTR
 /* Extended attribute functions. */
 extern void *unionfs_xattr_alloc(size_t size, size_t limit);
-- 
1.5.2.rc1.165.gaf9b

