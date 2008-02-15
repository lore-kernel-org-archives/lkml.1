Return-Path: <linux-kernel-owner+w=401wt.eu-S933823AbYBOWqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933823AbYBOWqo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 17:46:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765578AbYBOWhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 17:37:54 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:48789 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763686AbYBOWhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 17:37:46 -0500
Subject: [PATCH 06/30] merge open_namei() and do_filp_open()
To: linux-kernel@vger.kernel.org
Cc: hch@lst.de, miklos@szeredi.hu, akpm@osdl.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Fri, 15 Feb 2008 14:37:28 -0800
References: <20080215223721.9E0A088A@kernel>
In-Reply-To: <20080215223721.9E0A088A@kernel>
Message-Id: <20080215223728.42A6D310@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


open_namei() will, in the future, need to take mount write counts
over its creation and truncation (via may_open()) operations.  It
needs to keep these write counts until any potential filp that is
created gets __fput()'d.

This gets complicated in the error handling and becomes very murky
as to how far open_namei() actually got, and whether or not that
mount write count was taken.  That makes it a bad interface.

All that the current do_filp_open() really does is allocate the
nameidata on the stack, then call open_namei().

So, this merges those two functions and moves filp_open() over
to namei.c so it can be close to its buddy: do_filp_open().  It
also gets a kerneldoc comment in the process.

Acked-by: Al Viro <viro@ZenIV.linux.org.uk>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namei.c         |  100 +++++++++++++++++++---------------
 linux-2.6.git-dave/fs/open.c          |   19 ------
 linux-2.6.git-dave/include/linux/fs.h |    3 -
 3 files changed, 59 insertions(+), 63 deletions(-)

diff -puN fs/namei.c~make-open_namei-return-a-filp fs/namei.c
--- linux-2.6.git/fs/namei.c~make-open_namei-return-a-filp	2008-02-15 13:25:44.000000000 -0800
+++ linux-2.6.git-dave/fs/namei.c	2008-02-15 13:25:44.000000000 -0800
@@ -1724,17 +1724,13 @@ static inline int open_to_namei_flags(in
 }
 
 /*
- *	open_namei()
- *
- * namei for open - this is in fact almost the whole open-routine.
- *
  * Note that the low bits of "flag" aren't the same as in the open
  * system call.  See open_to_namei_flags().
- * SMP-safe
  */
-int open_namei(int dfd, const char *pathname, int open_flag,
-		int mode, struct nameidata *nd)
+struct file *do_filp_open(int dfd, const char *pathname,
+		int open_flag, int mode)
 {
+	struct nameidata nd;
 	int acc_mode, error;
 	struct path path;
 	struct dentry *dir;
@@ -1757,18 +1753,19 @@ int open_namei(int dfd, const char *path
 	 */
 	if (!(flag & O_CREAT)) {
 		error = path_lookup_open(dfd, pathname, lookup_flags(flag),
-					 nd, flag);
+					 &nd, flag);
 		if (error)
-			return error;
+			return ERR_PTR(error);
 		goto ok;
 	}
 
 	/*
 	 * Create - we need to know the parent.
 	 */
-	error = path_lookup_create(dfd,pathname,LOOKUP_PARENT,nd,flag,mode);
+	error = path_lookup_create(dfd, pathname, LOOKUP_PARENT,
+				   &nd, flag, mode);
 	if (error)
-		return error;
+		return ERR_PTR(error);
 
 	/*
 	 * We have the parent and last component. First of all, check
@@ -1776,14 +1773,14 @@ int open_namei(int dfd, const char *path
 	 * will not do.
 	 */
 	error = -EISDIR;
-	if (nd->last_type != LAST_NORM || nd->last.name[nd->last.len])
+	if (nd.last_type != LAST_NORM || nd.last.name[nd.last.len])
 		goto exit;
 
-	dir = nd->path.dentry;
-	nd->flags &= ~LOOKUP_PARENT;
+	dir = nd.path.dentry;
+	nd.flags &= ~LOOKUP_PARENT;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->path.mnt;
+	path.dentry = lookup_hash(&nd);
+	path.mnt = nd.path.mnt;
 
 do_last:
 	error = PTR_ERR(path.dentry);
@@ -1792,18 +1789,18 @@ do_last:
 		goto exit;
 	}
 
-	if (IS_ERR(nd->intent.open.file)) {
+	if (IS_ERR(nd.intent.open.file)) {
 		mutex_unlock(&dir->d_inode->i_mutex);
-		error = PTR_ERR(nd->intent.open.file);
+		error = PTR_ERR(nd.intent.open.file);
 		goto exit_dput;
 	}
 
 	/* Negative dentry, just create the file */
 	if (!path.dentry->d_inode) {
-		error = __open_namei_create(nd, &path, flag, mode);
+		error = __open_namei_create(&nd, &path, flag, mode);
 		if (error)
 			goto exit;
-		return 0;
+		return nameidata_to_filp(&nd, open_flag);
 	}
 
 	/*
@@ -1828,23 +1825,23 @@ do_last:
 	if (path.dentry->d_inode->i_op && path.dentry->d_inode->i_op->follow_link)
 		goto do_link;
 
-	path_to_nameidata(&path, nd);
+	path_to_nameidata(&path, &nd);
 	error = -EISDIR;
 	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
-	error = may_open(nd, acc_mode, flag);
+	error = may_open(&nd, acc_mode, flag);
 	if (error)
 		goto exit;
-	return 0;
+	return nameidata_to_filp(&nd, open_flag);
 
 exit_dput:
-	path_put_conditional(&path, nd);
+	path_put_conditional(&path, &nd);
 exit:
-	if (!IS_ERR(nd->intent.open.file))
-		release_open_intent(nd);
-	path_put(&nd->path);
-	return error;
+	if (!IS_ERR(nd.intent.open.file))
+		release_open_intent(&nd);
+	path_put(&nd.path);
+	return ERR_PTR(error);
 
 do_link:
 	error = -ELOOP;
@@ -1860,43 +1857,60 @@ do_link:
 	 * stored in nd->last.name and we will have to putname() it when we
 	 * are done. Procfs-like symlinks just set LAST_BIND.
 	 */
-	nd->flags |= LOOKUP_PARENT;
-	error = security_inode_follow_link(path.dentry, nd);
+	nd.flags |= LOOKUP_PARENT;
+	error = security_inode_follow_link(path.dentry, &nd);
 	if (error)
 		goto exit_dput;
-	error = __do_follow_link(&path, nd);
+	error = __do_follow_link(&path, &nd);
 	if (error) {
 		/* Does someone understand code flow here? Or it is only
 		 * me so stupid? Anathema to whoever designed this non-sense
 		 * with "intent.open".
 		 */
-		release_open_intent(nd);
-		return error;
+		release_open_intent(&nd);
+		return ERR_PTR(error);
 	}
-	nd->flags &= ~LOOKUP_PARENT;
-	if (nd->last_type == LAST_BIND)
+	nd.flags &= ~LOOKUP_PARENT;
+	if (nd.last_type == LAST_BIND)
 		goto ok;
 	error = -EISDIR;
-	if (nd->last_type != LAST_NORM)
+	if (nd.last_type != LAST_NORM)
 		goto exit;
-	if (nd->last.name[nd->last.len]) {
-		__putname(nd->last.name);
+	if (nd.last.name[nd.last.len]) {
+		__putname(nd.last.name);
 		goto exit;
 	}
 	error = -ELOOP;
 	if (count++==32) {
-		__putname(nd->last.name);
+		__putname(nd.last.name);
 		goto exit;
 	}
-	dir = nd->path.dentry;
+	dir = nd.path.dentry;
 	mutex_lock(&dir->d_inode->i_mutex);
-	path.dentry = lookup_hash(nd);
-	path.mnt = nd->path.mnt;
-	__putname(nd->last.name);
+	path.dentry = lookup_hash(&nd);
+	path.mnt = nd.path.mnt;
+	__putname(nd.last.name);
 	goto do_last;
 }
 
 /**
+ * filp_open - open file and return file pointer
+ *
+ * @filename:	path to open
+ * @flags:	open flags as per the open(2) second argument
+ * @mode:	mode for the new file if O_CREAT is set, else ignored
+ *
+ * This is the helper to open a file from kernelspace if you really
+ * have to.  But in generally you should not do this, so please move
+ * along, nothing to see here..
+ */
+struct file *filp_open(const char *filename, int flags, int mode)
+{
+	return do_filp_open(AT_FDCWD, filename, flags, mode);
+}
+EXPORT_SYMBOL(filp_open);
+
+/**
  * lookup_create - lookup a dentry, creating it if it doesn't exist
  * @nd: nameidata info
  * @is_dir: directory flag
diff -puN fs/open.c~make-open_namei-return-a-filp fs/open.c
--- linux-2.6.git/fs/open.c~make-open_namei-return-a-filp	2008-02-15 13:25:44.000000000 -0800
+++ linux-2.6.git-dave/fs/open.c	2008-02-15 13:25:44.000000000 -0800
@@ -796,25 +796,6 @@ cleanup_file:
 	return ERR_PTR(error);
 }
 
-static struct file *do_filp_open(int dfd, const char *filename, int flags,
-				 int mode)
-{
-	int error;
-	struct nameidata nd;
-
-	error = open_namei(dfd, filename, flags, mode, &nd);
-	if (!error)
-		return nameidata_to_filp(&nd, flags);
-
-	return ERR_PTR(error);
-}
-
-struct file *filp_open(const char *filename, int flags, int mode)
-{
-	return do_filp_open(AT_FDCWD, filename, flags, mode);
-}
-EXPORT_SYMBOL(filp_open);
-
 /**
  * lookup_instantiate_filp - instantiates the open intent filp
  * @nd: pointer to nameidata
diff -puN include/linux/fs.h~make-open_namei-return-a-filp include/linux/fs.h
--- linux-2.6.git/include/linux/fs.h~make-open_namei-return-a-filp	2008-02-15 13:25:44.000000000 -0800
+++ linux-2.6.git-dave/include/linux/fs.h	2008-02-15 13:25:44.000000000 -0800
@@ -1736,7 +1736,8 @@ extern struct file *create_read_pipe(str
 extern struct file *create_write_pipe(void);
 extern void free_write_pipe(struct file *);
 
-extern int open_namei(int dfd, const char *, int, int, struct nameidata *);
+extern struct file *do_filp_open(int dfd, const char *pathname,
+		int open_flag, int mode);
 extern int may_open(struct nameidata *, int, int);
 
 extern int kernel_read(struct file *, unsigned long, char *, unsigned long);
_
