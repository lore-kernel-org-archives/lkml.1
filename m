Return-Path: <linux-kernel-owner+w=401wt.eu-S1759648AbYC0MYq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759648AbYC0MYq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:24:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbYC0MYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:24:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33806 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394AbYC0MYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:24:08 -0400
Message-Id: <20080327122353.695395374@szeredi.hu>
References: <20080327120619.031944658@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 27 Mar 2008 13:06:21 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: akpm@linux-foundation.org, linuxram@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 2/7] vfs: mountinfo: add seq_file_root()
Content-Disposition: inline; filename=mountinfo_d_path_root.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Add a new function:

  seq_file_root()

This is similar to seq_path(), but calculates the path relative to the
given root, instead of current->fs->root.  If the path was unreachable
from root, then modify the root parameter to reflect this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c              |   24 ++++++++++++++++--------
 fs/seq_file.c            |   30 ++++++++++++++++++++++++++++++
 include/linux/dcache.h   |    1 +
 include/linux/seq_file.h |    2 ++
 4 files changed, 49 insertions(+), 8 deletions(-)

Index: vfs-2.6/fs/dcache.c
===================================================================
--- vfs-2.6.orig/fs/dcache.c	2008-03-27 12:06:04.000000000 +0100
+++ vfs-2.6/fs/dcache.c	2008-03-27 12:06:06.000000000 +0100
@@ -1759,10 +1759,8 @@ static int prepend(char **buffer, int *b
 
 /**
  * d_path - return the path of a dentry
- * @dentry: dentry to report
- * @vfsmnt: vfsmnt to which the dentry belongs
- * @root: root dentry
- * @rootmnt: vfsmnt to which the root dentry belongs
+ * @path: the dentry/vfsmount to report
+ * @root: root vfsmnt/dentry (may be modified by this function)
  * @buffer: buffer to return value in
  * @buflen: buffer length
  *
@@ -1772,10 +1770,15 @@ static int prepend(char **buffer, int *b
  * Returns the buffer or an error code if the path was too long.
  *
  * "buflen" should be positive. Caller holds the dcache_lock.
+ *
+ * If path is not reachable from the supplied root, then the value of
+ * root is changed (without modifying refcounts).
  */
-static char *__d_path(struct dentry *dentry, struct vfsmount *vfsmnt,
-		       struct path *root, char *buffer, int buflen)
+char *__d_path(const struct path *path, struct path *root,
+	       char *buffer, int buflen)
 {
+	struct dentry *dentry = path->dentry;
+	struct vfsmount *vfsmnt = path->mnt;
 	char * end = buffer+buflen;
 	char * retval;
 
@@ -1824,6 +1827,8 @@ global_root:
 	if (prepend(&retval, &buflen, dentry->d_name.name,
 		    dentry->d_name.len) != 0)
 		goto Elong;
+	root->mnt = vfsmnt;
+	root->dentry = dentry;
 	return retval;
 Elong:
 	return ERR_PTR(-ENAMETOOLONG);
@@ -1846,6 +1851,7 @@ char *d_path(struct path *path, char *bu
 {
 	char *res;
 	struct path root;
+	struct path tmp;
 
 	/*
 	 * We have various synthetic filesystems that never get mounted.  On
@@ -1862,7 +1868,8 @@ char *d_path(struct path *path, char *bu
 	path_get(&root);
 	read_unlock(&current->fs->lock);
 	spin_lock(&dcache_lock);
-	res = __d_path(path->dentry, path->mnt, &root, buf, buflen);
+	tmp = root;
+	res = __d_path(path, &tmp, buf, buflen);
 	spin_unlock(&dcache_lock);
 	path_put(&root);
 	return res;
@@ -1970,9 +1977,10 @@ asmlinkage long sys_getcwd(char __user *
 	spin_lock(&dcache_lock);
 	if (pwd.dentry->d_parent == pwd.dentry || !d_unhashed(pwd.dentry)) {
 		unsigned long len;
+		struct path tmp = root;
 		char * cwd;
 
-		cwd = __d_path(pwd.dentry, pwd.mnt, &root, page, PAGE_SIZE);
+		cwd = __d_path(&pwd, &tmp, page, PAGE_SIZE);
 		spin_unlock(&dcache_lock);
 
 		error = PTR_ERR(cwd);
Index: vfs-2.6/fs/seq_file.c
===================================================================
--- vfs-2.6.orig/fs/seq_file.c	2008-03-27 12:06:04.000000000 +0100
+++ vfs-2.6/fs/seq_file.c	2008-03-27 12:06:06.000000000 +0100
@@ -385,6 +385,36 @@ int seq_path(struct seq_file *m, struct 
 EXPORT_SYMBOL(seq_path);
 
 /*
+ * Same as seq_path, but relative to supplied root.
+ *
+ * root may be changed, see __d_path().
+ */
+int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
+		  char *esc)
+{
+	int err = -ENAMETOOLONG;
+	if (m->count < m->size) {
+		char *s = m->buf + m->count;
+		char *p;
+
+		spin_lock(&dcache_lock);
+		p = __d_path(path, root, s, m->size - m->count);
+		spin_unlock(&dcache_lock);
+		err = PTR_ERR(p);
+		if (!IS_ERR(p)) {
+			s = mangle_path(s, p, esc);
+			if (s) {
+				p = m->buf + m->count;
+				m->count = s - m->buf;
+				return 0;
+			}
+		}
+	}
+	m->count = m->size;
+	return err;
+}
+
+/*
  * returns the path of the 'dentry' from the root of its filesystem.
  */
 int seq_dentry(struct seq_file *m, struct dentry *dentry, char *esc)
Index: vfs-2.6/include/linux/dcache.h
===================================================================
--- vfs-2.6.orig/include/linux/dcache.h	2008-03-27 12:06:04.000000000 +0100
+++ vfs-2.6/include/linux/dcache.h	2008-03-27 12:06:06.000000000 +0100
@@ -301,6 +301,7 @@ extern int d_validate(struct dentry *, s
  */
 extern char *dynamic_dname(struct dentry *, char *, int, const char *, ...);
 
+extern char *__d_path(const struct path *path, struct path *root, char *, int);
 extern char *d_path(struct path *, char *, int);
 extern char *dentry_path(struct dentry *, char *, int);
 
Index: vfs-2.6/include/linux/seq_file.h
===================================================================
--- vfs-2.6.orig/include/linux/seq_file.h	2008-03-27 12:06:04.000000000 +0100
+++ vfs-2.6/include/linux/seq_file.h	2008-03-27 12:06:06.000000000 +0100
@@ -44,6 +44,8 @@ int seq_printf(struct seq_file *, const 
 
 int seq_path(struct seq_file *, struct path *, char *);
 int seq_dentry(struct seq_file *, struct dentry *, char *);
+int seq_path_root(struct seq_file *m, struct path *path, struct path *root,
+		  char *esc);
 
 int single_open(struct file *, int (*)(struct seq_file *, void *), void *);
 int single_release(struct inode *, struct file *);

--
