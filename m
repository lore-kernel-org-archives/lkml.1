Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZEUJXe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZEUJXe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 05:23:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbZEUJXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 05:23:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50306 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbZEUJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 05:23:04 -0400
Message-Id: <20090521092252.977049345@szeredi.hu>
References: <20090521092231.979256687@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Thu, 21 May 2009 11:22:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: jblunck@suse.de, bharata@in.ibm.com, vaurora@redhat.com,
       viro@zeniv.linux.org.uk, Bharata B Rao <bharata@linux.vnet.ibm.com>
Subject: [patch 5/5] union-directory: Simple union-mount readdir implementation
Content-Disposition: inline; filename=union-directory-readdir.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Blunck <jblunck@suse.de>

This is a very simple union mount readdir implementation. It modifies
the readdir routine to merge the entries of union mounted directories
and eliminate duplicates while walking the union stack.  All
filesystem types are supported.

There can be multiple calls to readdir/getdents routines for reading
the entries of a single directory, the union directory cache is
maitained across these calls.  The cache is stored in the struct file.
The cache is cleared on final fput() and when the file is rewound to
the zero position.

This implementation supports seeking in the directory.  A simple
counter is used as offset in the cached list of entries.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/file_table.c    |    1 
 fs/readdir.c       |   21 +++--
 fs/union.c         |  195 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/union.h         |    1 
 include/linux/fs.h |   17 ++++
 5 files changed, 227 insertions(+), 8 deletions(-)

Index: linux-2.6/fs/readdir.c
===================================================================
--- linux-2.6.orig/fs/readdir.c	2009-05-20 18:15:58.000000000 +0200
+++ linux-2.6/fs/readdir.c	2009-05-20 18:16:26.000000000 +0200
@@ -18,6 +18,7 @@
 #include <linux/unistd.h>
 
 #include <asm/uaccess.h>
+#include "union.h"
 
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
@@ -30,16 +31,20 @@ int vfs_readdir(struct file *file, filld
 	if (res)
 		goto out;
 
-	res = mutex_lock_killable(&inode->i_mutex);
-	if (res)
-		goto out;
+	if (IS_MNT_UNION(file->f_path.mnt)) {
+		res = readdir_union(file, buf, filler);
+	} else {
+		res = mutex_lock_killable(&inode->i_mutex);
+		if (res)
+			goto out;
 
-	res = -ENOENT;
-	if (!IS_DEADDIR(inode)) {
-		res = file->f_op->readdir(file, buf, filler);
-		file_accessed(file);
+		res = -ENOENT;
+		if (!IS_DEADDIR(inode)) {
+			res = file->f_op->readdir(file, buf, filler);
+			file_accessed(file);
+		}
+		mutex_unlock(&inode->i_mutex);
 	}
-	mutex_unlock(&inode->i_mutex);
 out:
 	return res;
 }
Index: linux-2.6/fs/union.c
===================================================================
--- linux-2.6.orig/fs/union.c	2009-05-20 18:16:26.000000000 +0200
+++ linux-2.6/fs/union.c	2009-05-20 19:51:29.000000000 +0200
@@ -14,6 +14,9 @@
 
 #include <linux/fs.h>
 #include <linux/namei.h>
+#include <linux/module.h>
+#include <linux/file.h>
+#include <linux/sched.h>
 #include "union.h"
 
 /*
@@ -32,3 +35,195 @@ int follow_union_up(struct path *path)
 
 	return 0;
 }
+
+
+/*
+ * Union mounts support for readdir.
+ */
+
+/* The readdir union cache object */
+struct union_cache_entry {
+	struct union_cache_entry *next;
+	struct qstr name;
+	unsigned int type;
+	u64 ino;
+};
+
+struct union_cache_callback {
+	struct union_cache_entry *list;		/* head of list */
+	struct union_cache_entry **endp;	/* pointer to tail of list */
+	int count;
+};
+
+static int union_cache_add_entry(struct union_cache_callback *cb,
+				 const char *name, int namelen, u64 ino,
+				 unsigned int d_type)
+{
+	struct union_cache_entry *p;
+
+	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	if (!p)
+		return -ENOMEM;
+
+	p->name.name = kstrndup(name, namelen, GFP_KERNEL);
+	if (!p->name.name) {
+		kfree(p);
+		return -ENOMEM;
+	}
+	p->name.len = namelen;
+	p->name.hash = 0;
+	p->type = d_type;
+	p->ino = ino;
+	p->next = NULL;
+	*cb->endp = p;
+	cb->endp = &p->next;
+
+	return 0;
+}
+
+void __union_cache_free(struct union_cache_entry *p)
+{
+	while (p) {
+		struct union_cache_entry *next = p->next;
+
+		kfree(p->name.name);
+		kfree(p);
+		p = next;
+	}
+}
+
+static int union_cache_find_entry(struct union_cache_entry *start,
+				  const char *name, int namelen)
+{
+	struct union_cache_entry *p;
+	int ret = 0;
+
+	for (p = start; p; p = p->next) {
+		if (p->name.len != namelen)
+			continue;
+		if (strncmp(p->name.name, name, namelen) == 0) {
+			ret = 1;
+			break;
+		}
+	}
+
+	return ret;
+}
+
+static int union_filldir(void *buf, const char *name, int namlen,
+			 loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	cb->count++;
+	if (!union_cache_find_entry(cb->list, name, namlen))
+		union_cache_add_entry(cb, name, namlen, ino, d_type);
+
+	return 0;
+}
+
+static int read_union_cache(struct file *file, struct union_cache_callback *cb)
+{
+	struct inode *inode;
+	struct path path;
+	int res;
+
+	cb->list = NULL;
+	cb->endp = &cb->list;
+
+	path = file->f_path;
+	path_get(&path);
+	do {
+		struct file *ftmp;
+
+		path_get(&path);
+		ftmp = dentry_open(path.dentry, path.mnt,
+				   O_RDONLY | O_DIRECTORY, current_cred());
+		if (IS_ERR(ftmp)) {
+			res = PTR_ERR(ftmp);
+			break;
+		}
+
+		inode = path.dentry->d_inode;
+		mutex_lock(&inode->i_mutex);
+
+		res = -ENOENT;
+		if (!IS_DEADDIR(inode)) {
+			do {
+				cb->count = 0;
+				res = ftmp->f_op->readdir(ftmp, cb,
+							  union_filldir);
+			} while (res >= 0 && cb->count);
+			if (res > 0)
+				res = 0;
+
+			file_accessed(ftmp);
+		}
+
+		mutex_unlock(&inode->i_mutex);
+		fput(ftmp);
+	} while (!res && follow_union_up(&path));
+	path_put(&path);
+
+	return res;
+}
+
+/*
+ * readdir_union - A wrapper around ->readdir()
+ *
+ * This is a wrapper around the filesystems readdir(), which is walking
+ * the union stack and calls ->readdir() for every directory in the stack.
+ * The directory entries are read into the union mounts readdir cache to
+ * support duplicate removal.
+ */
+int readdir_union(struct file *file, void *buf, filldir_t filler)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct union_cache_entry *p;
+	loff_t off;
+	int res = 0;
+
+	mutex_lock(&inode->i_mutex);
+	if (!file->f_pos && file->f_union_cache) {
+		__union_cache_free(file->f_union_cache);
+		file->f_union_cache = NULL;
+	}
+
+	if (!file->f_union_cache) {
+		struct union_cache_callback cb;
+
+		mutex_unlock(&inode->i_mutex);
+
+		res = read_union_cache(file, &cb);
+		if (res)
+			return res;
+
+		mutex_lock(&inode->i_mutex);
+
+		if (file->f_union_cache) {
+			/* Somebody else managed to fill it before us */
+			__union_cache_free(cb.list);
+		} else {
+			file->f_union_cache = cb.list;
+		}
+	}
+
+	off = 0;
+	for (p = file->f_union_cache; p; p = p->next) {
+		int over;
+
+		off++;
+		if (off <= file->f_pos)
+			continue;
+
+		over = filler(buf, p->name.name, p->name.len, off - 1,
+			      p->ino, p->type);
+		if (over)
+			break;
+
+		file->f_pos = off;
+	}
+	mutex_unlock(&inode->i_mutex);
+
+	return res;
+}
Index: linux-2.6/fs/union.h
===================================================================
--- linux-2.6.orig/fs/union.h	2009-05-20 18:16:26.000000000 +0200
+++ linux-2.6/fs/union.h	2009-05-20 18:16:26.000000000 +0200
@@ -17,6 +17,7 @@
 struct path;
 
 extern int follow_union_up(struct path *path);
+extern int readdir_union(struct file *file, void *buf, filldir_t filler);
 
 #ifdef CONFIG_UNION_MOUNT
 #define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2009-05-20 14:11:58.000000000 +0200
+++ linux-2.6/fs/file_table.c	2009-05-20 19:17:09.000000000 +0200
@@ -280,6 +280,7 @@ void __fput(struct file *file)
 	if (file->f_op && file->f_op->release)
 		file->f_op->release(inode, file);
 	security_file_free(file);
+	union_cache_free(file);
 	ima_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
 		cdev_put(inode->i_cdev);
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-05-20 18:16:26.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-05-20 19:19:38.000000000 +0200
@@ -934,6 +934,9 @@ struct file {
 #ifdef CONFIG_DEBUG_WRITECOUNT
 	unsigned long f_mnt_write_state;
 #endif
+#ifdef CONFIG_UNION_MOUNT
+	struct union_cache_entry *f_union_cache;
+#endif
 };
 extern spinlock_t files_lock;
 #define file_list_lock() spin_lock(&files_lock);
@@ -985,6 +988,20 @@ static inline int file_check_writeable(s
 }
 #endif /* CONFIG_DEBUG_WRITECOUNT */
 
+#ifdef CONFIG_UNION_MOUNT
+extern void __union_cache_free(struct union_cache_entry *);
+
+static inline void union_cache_free(struct file *file)
+{
+	if (file->f_union_cache)
+		__union_cache_free(file->f_union_cache);
+}
+#else
+static inline void union_cache_free(struct file *file)
+{
+}
+#endif
+
 #define	MAX_NON_LFS	((1UL<<31) - 1)
 
 /* Page cache limit. The filesystems should put that into their s_maxbytes 

--
