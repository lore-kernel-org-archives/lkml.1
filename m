Return-Path: <linux-kernel-owner+w=401wt.eu-S1751415AbZGVJSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415AbZGVJSG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 05:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbZGVJSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 05:18:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47287 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbZGVJSE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 05:18:04 -0400
Date: Wed, 22 Jul 2009 05:17:02 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: esandeen@redhat.com, eteo@redhat.com, eparis@redhat.com,
       Amerigo Wang <amwang@redhat.com>, akpm@linux-foundation.org,
       stable@kernel.org, viro@zeniv.linux.org.uk
Message-Id: <20090722091920.6642.43943.sendpatchset@localhost.localdomain>
Subject: [RESEND Patch v2] allow file truncations when both suid and write permissions set
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


V1 -> V2:
Introduce dentry_remove_suid(), and use it in do_truncate().
Thanks to Eric Paris.


When suid is set and the non-owner user has write permission,
any writing into this file should be allowed and suid should be
removed after that.

However, current kernel only allows writing without truncations,
when we do truncations on that file, we get EPERM. This is a bug.

Steps to reproduce this bug:

% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h > rootdir/file1
zsh: operation not permitted: rootdir/file1
% ls -l rootdir/file1
-rwsrwsrwx 1 root root 3 Jun 25 15:42 rootdir/file1
% echo h >> rootdir/file1
% ls -l rootdir/file1
-rwxrwxrwx 1 root root 5 Jun 25 16:34 rootdir/file1

This patch fixes it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: stable@kernel.org
Cc: Eric Sandeen <esandeen@redhat.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Eugene Teo <eteo@redhat.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>

---
diff --git a/fs/open.c b/fs/open.c
index dd98e80..ed5cd45 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -213,11 +213,15 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 		newattrs.ia_valid |= ATTR_FILE;
 	}
 
+	mutex_lock(&dentry->d_inode->i_mutex);
 	/* Remove suid/sgid on truncate too */
-	newattrs.ia_valid |= should_remove_suid(dentry);
+	err = dentry_remove_suid(dentry);
+	if (err)
+		goto unlock;
 
-	mutex_lock(&dentry->d_inode->i_mutex);
 	err = notify_change(dentry, &newattrs);
+
+ unlock:
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	return err;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0872372..8baf558 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2166,6 +2166,7 @@ extern void destroy_inode(struct inode *);
 extern struct inode *new_inode(struct super_block *);
 extern int should_remove_suid(struct dentry *);
 extern int file_remove_suid(struct file *);
+extern int dentry_remove_suid(struct dentry *);
 
 extern void __insert_inode_hash(struct inode *, unsigned long hashval);
 extern void remove_inode_hash(struct inode *);
diff --git a/mm/filemap.c b/mm/filemap.c
index 2239671..b07f7d0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1839,9 +1839,11 @@ static int __remove_suid(struct dentry *dentry, int kill)
 	return notify_change(dentry, &newattrs);
 }
 
-int file_remove_suid(struct file *file)
+/*
+ * Note: you need to hold i_mutex before call this.
+ */
+int dentry_remove_suid(struct dentry *dentry)
 {
-	struct dentry *dentry = file->f_path.dentry;
 	int killsuid = should_remove_suid(dentry);
 	int killpriv = security_inode_need_killpriv(dentry);
 	int error = 0;
@@ -1855,6 +1857,12 @@ int file_remove_suid(struct file *file)
 
 	return error;
 }
+
+int file_remove_suid(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	return dentry_remove_suid(dentry);
+}
 EXPORT_SYMBOL(file_remove_suid);
 
 static size_t __iovec_copy_from_user_inatomic(char *vaddr,
