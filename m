Return-Path: <linux-kernel-owner+w=401wt.eu-S1757200AbZGCNur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757200AbZGCNur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 09:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754701AbZGCNuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 09:50:25 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58756 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944AbZGCNuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 09:50:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/2] vfs: new open(2) flag to open filesystem node
To: torvalds@osdl.org, hch@infradead.org, wang840925@gmail.com,
       viro@ZenIV.linux.org.uk
Cc: miklos@szeredi.hu, dhowells@redhat.com, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-afs@lists.infradead.org
Date: Fri, 03 Jul 2009 14:49:50 +0100
Message-ID: <20090703134950.31139.76720.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Miklos Szeredi <miklos@szeredi.hu>

This patch adds a new open flag, O_NODE.  This flag means: open just
the filesystem node instead of the object referenced by the node.

Opening a file will not call the driver's ->open() method and will not
have any side effect other than referencing the dentry/vfsmount from
the struct file pointer.

Currently O_NODE can only be used together with O_NOACCESS (value 3),
meaning that read(2) and write(2) will return EBADF and no permission
is necessary to open the file.  This is logical for device nodes and
fifos.  For directories we could allow O_RDONLY, and for regular files
any access mode, but this is not done yet.

O_NODE used together with O_NOFOLLOW will open a symlink node itself
instead of returning ELOOP.  O_NOFOLLOW will not prevent following
mountpoints if used together with O_NODE.  In theory we could allow
O_RDONLY for symlinks too and return the contents of the link on
read(2).

Filesystems which want to install special file operations for O_NODE
opens (e.g. ioctl) may set S_OPEN_NODE flag in the inode.  This will
cause dentry_open() to call inode->i_fop->open, and the filesystem is
responsible for handling the O_NODE flag and installing the right
filesystem operations in file->f_op.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: David Howells <dhowells@redhat.com>
---

 fs/file_table.c             |    6 +++-
 fs/locks.c                  |    3 ++
 fs/namei.c                  |   65 ++++++++++++++++++++++++++-----------------
 fs/open.c                   |   12 +++++++-
 include/asm-generic/fcntl.h |    4 +++
 include/linux/fs.h          |    1 +
 6 files changed, 62 insertions(+), 29 deletions(-)


diff --git a/fs/file_table.c b/fs/file_table.c
index 334ce39..2f40336 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -281,8 +281,10 @@ void __fput(struct file *file)
 		file->f_op->release(inode, file);
 	security_file_free(file);
 	ima_file_free(file);
-	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL))
-		cdev_put(inode->i_cdev);
+	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL)) {
+		if (!(file->f_flags & O_NODE))
+			cdev_put(inode->i_cdev);
+	}
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
 	file_kill(file);
diff --git a/fs/locks.c b/fs/locks.c
index b6440f5..8ab6e84 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1183,6 +1183,9 @@ int __break_lease(struct inode *inode, unsigned int mode)
 	unsigned long break_time;
 	int i_have_this_lease = 0;
 
+	if (!(mode & (FMODE_READ | FMODE_WRITE)))
+		return 0;
+
 	new_fl = lease_alloc(NULL, mode & FMODE_WRITE ? F_WRLCK : F_RDLCK);
 
 	lock_kernel();
diff --git a/fs/namei.c b/fs/namei.c
index f3c5b27..c1d9f58 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1160,7 +1160,9 @@ static int path_lookup_open(int dfd, const char *name,
 	nd->intent.open.file = filp;
 	nd->intent.open.flags = open_flags;
 	nd->intent.open.create_mode = 0;
-	err = do_path_lookup(dfd, name, lookup_flags|LOOKUP_OPEN, nd);
+	if (!(open_flags & O_NODE))
+		lookup_flags |= LOOKUP_OPEN;
+	err = do_path_lookup(dfd, name, lookup_flags, nd);
 	if (IS_ERR(nd->intent.open.file)) {
 		if (err == 0) {
 			err = PTR_ERR(nd->intent.open.file);
@@ -1511,22 +1513,27 @@ int may_open(struct path *path, int acc_mode, int flag)
 	if (!inode)
 		return -ENOENT;
 
-	switch (inode->i_mode & S_IFMT) {
-	case S_IFLNK:
-		return -ELOOP;
-	case S_IFDIR:
-		if (acc_mode & MAY_WRITE)
-			return -EISDIR;
-		break;
-	case S_IFBLK:
-	case S_IFCHR:
-		if (path->mnt->mnt_flags & MNT_NODEV)
+	if ((flag & O_NODE)) {
+		if (acc_mode & (MAY_READ | MAY_WRITE))
 			return -EACCES;
-		/*FALLTHRU*/
-	case S_IFIFO:
-	case S_IFSOCK:
-		flag &= ~O_TRUNC;
-		break;
+	} else {
+		switch (inode->i_mode & S_IFMT) {
+		case S_IFLNK:
+			return -ELOOP;
+		case S_IFDIR:
+			if (acc_mode & MAY_WRITE)
+				return -EISDIR;
+			break;
+		case S_IFBLK:
+		case S_IFCHR:
+			if (path->mnt->mnt_flags & MNT_NODEV)
+				return -EACCES;
+			/*FALLTHRU*/
+		case S_IFIFO:
+		case S_IFSOCK:
+			flag &= ~O_TRUNC;
+			break;
+		}
 	}
 
 	error = inode_permission(inode, acc_mode);
@@ -1629,14 +1636,16 @@ out_unlock:
  *	11 - read-write
  * for the internal routines (ie open_namei()/follow_link() etc)
  * This is more logical, and also allows the 00 "no perm needed"
- * to be used for symlinks (where the permissions are checked
- * later).
+ * to be used for opening a symlink, pipe, socket or device with
+ * O_NODE.
  *
 */
 static inline int open_to_namei_flags(int flag)
 {
 	if ((flag+1) & O_ACCMODE)
 		flag++;
+	else if (flag & O_NODE)
+		flag &= ~O_ACCMODE;
 	return flag;
 }
 
@@ -1724,7 +1733,9 @@ struct file *do_filp_open(int dfd, const char *pathname,
 	nd.intent.open.create_mode = mode;
 	dir = nd.path.dentry;
 	nd.flags &= ~LOOKUP_PARENT;
-	nd.flags |= LOOKUP_CREATE | LOOKUP_OPEN;
+	nd.flags |= LOOKUP_CREATE;
+	if (!(open_flag & O_NODE))
+		nd.flags |= LOOKUP_OPEN;
 	if (flag & O_EXCL)
 		nd.flags |= LOOKUP_EXCL;
 	mutex_lock(&dir->d_inode->i_mutex);
@@ -1783,19 +1794,24 @@ do_last:
 
 	if (__follow_mount(&path)) {
 		error = -ELOOP;
-		if (flag & O_NOFOLLOW)
+		if ((flag & O_NOFOLLOW) & !(flag & O_NODE))
 			goto exit_dput;
 	}
 
 	error = -ENOENT;
 	if (!path.dentry->d_inode)
 		goto exit_dput;
-	if (path.dentry->d_inode->i_op->follow_link)
-		goto do_link;
+	if (path.dentry->d_inode->i_op->follow_link) {
+		if (!(flag & O_NOFOLLOW))
+			goto do_link;
+		error = -ELOOP;
+		if (!(flag & O_NODE))
+			goto exit_dput;
+	}
 
 	path_to_nameidata(&path, &nd);
 	error = -EISDIR;
-	if (path.dentry->d_inode && S_ISDIR(path.dentry->d_inode->i_mode))
+	if (S_ISDIR(path.dentry->d_inode->i_mode))
 		goto exit;
 ok:
 	/*
@@ -1849,9 +1865,6 @@ exit_parent:
 	return ERR_PTR(error);
 
 do_link:
-	error = -ELOOP;
-	if (flag & O_NOFOLLOW)
-		goto exit_dput;
 	/*
 	 * This is subtle. Instead of calling do_follow_link() we do the
 	 * thing by hands. The reason is that this way we have zero link_count
diff --git a/fs/open.c b/fs/open.c
index b1284bc..b9b7be8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -805,12 +805,17 @@ static inline int __get_file_write_access(struct inode *inode,
 	return error;
 }
 
+static const struct file_operations default_node_fops = {
+	.llseek = no_llseek,
+};
+
 static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 					int flags, struct file *f,
 					int (*open)(struct inode *, struct file *),
 					const struct cred *cred)
 {
 	struct inode *inode;
+	const struct file_operations *fops;
 	int error;
 
 	f->f_flags = flags;
@@ -829,7 +834,12 @@ static struct file *__dentry_open(struct dentry *dentry, struct vfsmount *mnt,
 	f->f_path.dentry = dentry;
 	f->f_path.mnt = mnt;
 	f->f_pos = 0;
-	f->f_op = fops_get(inode->i_fop);
+
+	fops = inode->i_fop;
+	if ((flags & O_NODE) && !(inode->i_flags & S_OPEN_NODE))
+		fops = &default_node_fops;
+	f->f_op = fops_get(fops);
+
 	file_move(f, &inode->i_sb->s_files);
 
 	error = security_dentry_open(f, cred);
diff --git a/include/asm-generic/fcntl.h b/include/asm-generic/fcntl.h
index 4d3e483..3cbd9b1 100644
--- a/include/asm-generic/fcntl.h
+++ b/include/asm-generic/fcntl.h
@@ -9,6 +9,7 @@
 #define O_RDONLY	00000000
 #define O_WRONLY	00000001
 #define O_RDWR		00000002
+#define O_NOACCESS	00000003
 #ifndef O_CREAT
 #define O_CREAT		00000100	/* not fcntl */
 #endif
@@ -51,6 +52,9 @@
 #ifndef O_CLOEXEC
 #define O_CLOEXEC	02000000	/* set close_on_exec */
 #endif
+#ifndef O_NODE
+#define O_NODE		04000000	/* open filesystem node, not device */
+#endif
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0a20392..22d344c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -231,6 +231,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_OPEN_NODE	1024	/* Fs is prepared for O_NODE opens */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system

