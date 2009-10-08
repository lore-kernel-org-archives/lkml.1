Return-Path: <linux-kernel-owner+w=401wt.eu-S1756081AbZJHI5o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbZJHI5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 04:57:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbZJHI5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 04:57:44 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43710 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755533AbZJHI5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 04:57:41 -0400
To: akpm@linux-foundation.org
CC: viro@ZenIV.linux.org.uk, dhowells@redhat.com, hch@infradead.org,
       adilger@sun.com, mtk.manpages@gmail.com, torvalds@linux-foundation.org,
       drepper@gmail.com, jamie@shareable.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] vfs: new O_NODE open flag
Message-Id: <E1MvonW-0004rO-4A@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 08 Oct 2009 10:56:30 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

Would you please consider adding this to -mm?

There's been a fair amount of interest in the concept, but less actual
review of the details.

Changes from the last posting:

 - make fchmod() fail on symlinks
 - add use cases to patch description

Thanks,
Miklos
----

From: Miklos Szeredi <mszeredi@suse.cz>

This patch adds a new open flag, O_NODE.  This flag means: open just
the filesystem node instead of the object referenced by the node.

This allows for a couple of new things:

 - opening a special file (device/socket/fifo) without side effects

 - opening a symlink

 - re-opening normally after checking file type (there's a debate
   whether this would have security issues, but currently we do allow
   re-opening with increased permissions thorugh /proc/*/fd)

 - opening any type of file without any permission is also possible
   (of course the resuling file descriptor may not be read or written)

The above allows fstat(), fchmod(), ioctl(), etc to be used for files
previously not possible.  AFS for example wanted a "pioctl()" syscall
for various things, but the same can be done without having to define
a new syscall:

     fd = open(path, O_NODE);
     ioctl(fd, ...);
     close(fd);

Another important use would be opening a directory without read
permission (see O_SEARCH from the POSIX draft for what this is useful
for).  O_NODE is not quite equivalent to O_SEARCH, but similar and
equally useful.

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
read(2).  Permissions on symlinks cannot be changed, so make fchmod()
fail with ELOOP on such a file descriptor.

Filesystems which want to install special file operations for O_NODE
opens (e.g. ioctl) may set S_OPEN_NODE flag in the inode.  This will
cause dentry_open() to call inode->i_fop->open, and the filesystem is
responsible for handling the O_NODE flag and installing the right
filesystem operations in file->f_op.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
Acked-by: David Howells <dhowells@redhat.com>
---
 fs/file_table.c             |    6 ++--
 fs/locks.c                  |    3 ++
 fs/namei.c                  |   65 ++++++++++++++++++++++++++------------------
 fs/open.c                   |   17 ++++++++++-
 include/asm-generic/fcntl.h |    4 ++
 include/linux/fs.h          |    1 
 6 files changed, 67 insertions(+), 29 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2009-09-24 20:10:58.000000000 +0200
+++ linux-2.6/fs/file_table.c	2009-10-08 09:47:05.000000000 +0200
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
Index: linux-2.6/fs/locks.c
===================================================================
--- linux-2.6.orig/fs/locks.c	2009-09-24 20:10:26.000000000 +0200
+++ linux-2.6/fs/locks.c	2009-10-08 09:47:05.000000000 +0200
@@ -1183,6 +1183,9 @@ int __break_lease(struct inode *inode, u
 	unsigned long break_time;
 	int i_have_this_lease = 0;
 
+	if (!(mode & (FMODE_READ | FMODE_WRITE)))
+		return 0;
+
 	new_fl = lease_alloc(NULL, mode & FMODE_WRITE ? F_WRLCK : F_RDLCK);
 
 	lock_kernel();
Index: linux-2.6/fs/namei.c
===================================================================
--- linux-2.6.orig/fs/namei.c	2009-09-24 20:10:26.000000000 +0200
+++ linux-2.6/fs/namei.c	2009-10-08 09:47:05.000000000 +0200
@@ -1160,7 +1160,9 @@ static int path_lookup_open(int dfd, con
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
@@ -1511,22 +1513,27 @@ int may_open(struct path *path, int acc_
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
@@ -1639,14 +1646,16 @@ out_unlock:
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
 
@@ -1734,7 +1743,9 @@ struct file *do_filp_open(int dfd, const
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
@@ -1793,19 +1804,24 @@ do_last:
 
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
@@ -1859,9 +1875,6 @@ exit_parent:
 	return ERR_PTR(error);
 
 do_link:
-	error = -ELOOP;
-	if (flag & O_NOFOLLOW)
-		goto exit_dput;
 	/*
 	 * This is subtle. Instead of calling do_follow_link() we do the
 	 * thing by hands. The reason is that this way we have zero link_count
Index: linux-2.6/fs/open.c
===================================================================
--- linux-2.6.orig/fs/open.c	2009-09-24 20:10:26.000000000 +0200
+++ linux-2.6/fs/open.c	2009-10-08 09:50:36.000000000 +0200
@@ -611,6 +611,11 @@ SYSCALL_DEFINE2(fchmod, unsigned int, fd
 	dentry = file->f_path.dentry;
 	inode = dentry->d_inode;
 
+	/* fchmod not allowed for symlinks opened with O_NODE */
+	err = -ELOOP;
+	if (S_ISLNK(inode->i_mode))
+		goto out_putf;
+
 	audit_inode(NULL, dentry);
 
 	err = mnt_want_write_file(file);
@@ -804,12 +809,17 @@ static inline int __get_file_write_acces
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
@@ -828,7 +838,12 @@ static struct file *__dentry_open(struct
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
Index: linux-2.6/include/asm-generic/fcntl.h
===================================================================
--- linux-2.6.orig/include/asm-generic/fcntl.h	2009-09-24 20:10:58.000000000 +0200
+++ linux-2.6/include/asm-generic/fcntl.h	2009-10-08 09:47:05.000000000 +0200
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
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2009-10-08 09:46:44.000000000 +0200
+++ linux-2.6/include/linux/fs.h	2009-10-08 09:47:05.000000000 +0200
@@ -231,6 +231,7 @@ struct inodes_stat_t {
 #define S_NOCMTIME	128	/* Do not update file c/mtime */
 #define S_SWAPFILE	256	/* Do not truncate: swapon got its bmaps */
 #define S_PRIVATE	512	/* Inode is fs-internal */
+#define S_OPEN_NODE	1024	/* Fs is prepared for O_NODE opens */
 
 /*
  * Note that nosuid etc flags are inode-specific: setting some file-system
