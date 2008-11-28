Return-Path: <linux-kernel-owner+w=401wt.eu-S1754791AbYK1LCJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791AbYK1LCJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 06:02:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752277AbYK1LBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 06:01:52 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52545 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYK1LBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 06:01:50 -0500
To: linux-fsdevel@vger.kernel.org
CC: jblunck@suse.de, dlezcano@fr.ibm.com, linux-kernel@vger.kernel.org,
       bharata@linux.vnet.ibm.com, viro@ZenIV.linux.org.uk
Subject: [rfc git patch] union directory
Message-Id: <E1L616K-0005v3-Uc@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 28 Nov 2008 12:01:32 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been doing some small fixing/cleanup work on the union directory
patches by Jan, and just noticed there's a thread about the union
mounts on LKML, so I thought publicizing won't hurt.

It's still a work in progress, notably the readdir code currently only
works on a few specific filesystem types.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git union-dir

Folded patch below.  Comments are welcome.

Thanks,
Miklos

commit bedcd5f45131e7d1fc77e5ce2f9064ef2b4b1abe
Author: Jan Blunck <jblunck@suse.de>
Date:   Fri Nov 28 11:40:25 2008 +0100

    union-mount: Simple union-mount readdir implementation
    
    This is a very simple union mount readdir implementation. It modifies the
    readdir routine to merge the entries of union mounted directories and
    eliminate duplicates while walking the union stack.
    
    FIXME:
      This patch needs to be reworked! At the moment this only works for ext2 and
      tmpfs. All kind of index directories that return d_off > i_size don't work
      with this.
    
    The directory entries are read starting from the top layer and they are
    maintained in a cache. Subsequently when the entries from the bottom layers
    of the union stack are read they are checked for duplicates (in the cache)
    before being passed out to the user space. There can be multiple calls
    to readdir/getdents routines for reading the entries of a single directory.
    But union directory cache is not maitained across these calls. Instead
    for every call, the previously read entries are re-read into the cache
    and newly read entires are compared against these for duplicates before
    being they are returned to user space.
    
    Signed-off-by: Jan Blunck <jblunck@suse.de>
    Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

commit 7faf4f68a430ba1d8ea16df2e2f9d479c7f25b49
Author: Jan Blunck <jblunck@suse.de>
Date:   Fri Nov 28 11:40:24 2008 +0100

    union-mount: Make lookup continue in overlayed directories
    
    This patch lets adds support for union-directory lookup to lookups from dentry
    cache and real lookups. On union-directories a lookup must continue on
    overlayed directories of the union. The lookup continues until the first
    no-negative dentry is found. Otherwise the topmost negative dentry is
    returned.
    
    Signed-off-by: Jan Blunck <jblunck@suse.de>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

commit d52101b28673a9e91eef28de7c0db87a200f46b0
Author: Jan Blunck <jblunck@suse.de>
Date:   Fri Nov 28 11:40:24 2008 +0100

    union-mount: Some checks during namespace changes
    
    Add some additional checks when mounting something into an union.
    
    Signed-off-by: Jan Blunck <jblunck@suse.de>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

commit c646cf2b5ff5e9e203d78c1f32e624f1dfac38b5
Author: Jan Blunck <jblunck@suse.de>
Date:   Fri Nov 28 11:40:24 2008 +0100

    union-mount: Support for traversing the layers of a union-directory
    
    This adds follow_union_up() to travers from one layer to the next overlayed
    mountpoint if given an union mounted mountpoint. This is basically the invert
    of what follow_mount() is doing.
    
    Signed-off-by: Jan Blunck <jblunck@suse.de>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

commit 8f306f09aa8745b95640fd6517de5f6d133128ee
Author: Jan Blunck <jblunck@suse.de>
Date:   Fri Nov 28 11:40:24 2008 +0100

    union-mount: Introduce MNT_UNION and MS_UNION flags
    
    Add per mountpoint flag for Union Mount support. You need additional patches
    to util-linux for that to work (ftp.suse.com/pub/people/jblunck/union-mount).
    
    Signed-off-by: Jan Blunck <jblunck@suse.de>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

commit a868f86562583c2f3080cfc6a8f8d00548a67f74
Author: Jan Blunck <jblunck@suse.de>
Date:   Fri Nov 28 11:40:24 2008 +0100

    union-mount: Documentation
    
    Add simple documentation about union mounting in general and this
    implementation in specific.
    
    Signed-off-by: Jan Blunck <jblunck@suse.de>
    Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

---
 Documentation/filesystems/union-mounts.txt |  172 +++++++++++++
 fs/Kconfig                                 |    8 +
 fs/Makefile                                |    2 +
 fs/namei.c                                 |   49 ++++
 fs/namespace.c                             |   26 ++-
 fs/readdir.c                               |   22 +-
 fs/union.c                                 |  363 ++++++++++++++++++++++++++++
 fs/union.h                                 |   26 ++
 include/linux/fs.h                         |    1 +
 include/linux/mount.h                      |    1 +
 10 files changed, 658 insertions(+), 12 deletions(-)
 create mode 100644 Documentation/filesystems/union-mounts.txt
 create mode 100644 fs/union.c
 create mode 100644 fs/union.h

diff --git a/Documentation/filesystems/union-mounts.txt b/Documentation/filesystems/union-mounts.txt
new file mode 100644
index 0000000..0b270ea
--- /dev/null
+++ b/Documentation/filesystems/union-mounts.txt
@@ -0,0 +1,172 @@
+VFS based Union Mounts
+----------------------
+
+ 1. What are "Union Mounts"
+ 2. The Union Stack
+ 3. The White-out Filetype
+ 4. Renaming Unions
+ 5. Directory Reading
+ 6. Known Problems
+ 7. References
+
+-------------------------------------------------------------------------------
+
+1. What are "Union Mounts"
+==========================
+
+Please note: this is NOT about UnionFS and it is NOT derived work!
+
+Traditionally the mount operation is opaque, which means that the content of
+the mount point, the directory where the file system is mounted on, is hidden
+by the content of the mounted file system's root directory until the file
+system is unmounted again. Unlike the traditional UNIX mount mechanism, that
+hides the contents of the mount point, a union mount presents a view as if
+both filesystems are merged together. Although only the topmost layer of the
+mount stack can be altered, it appears as if transparent file system mounts
+allow any file to be created, modified or deleted.
+
+Most people know the concepts and features of union mounts from other
+operating systems like Sun's Translucent Filesystem, Plan9 or BSD.
+
+Here are the key features of this implementation:
+- completely VFS based
+- does not change the namespace stacking
+- directory listings have duplicate entries removed
+- writable unions: only the topmost file system layer may be writable
+- writable unions: new white-out filetype handled inside the kernel
+
+-------------------------------------------------------------------------------
+
+2. The Union Stack
+==================
+
+The mounted file systems are organized in the "file system hierarchy" (tree of
+vfsmount structures), which keeps track about the stacking of file systems
+upon each other. The per-directory view on the file system hierarchy is called
+"mount stack" and reflects the order of file systems, which are mounted on a
+specific directory.
+
+Union mounts present a single unified view of the contents of two or more file
+systems as if they are merged together. Since the information which file
+system objects are part of a unified view is not directly available from the
+file system hierachy there is a need for a new structure. The file system
+objects, which are part of a unified view are ordered in a so-called "union
+stack". Only directoties can be part of a unified view.
+
+The link between two layers of the union stack is maintained using the
+union_mount structure (#include <linux/union.h>):
+
+struct union_mount {
+       atomic_t u_count;               /* reference count */
+       struct mutex u_mutex;
+       struct list_head u_unions;      /* list head for d_unions */
+       struct hlist_node u_hash;       /* list head for seaching */
+       struct hlist_node u_rhash;      /* list head for reverse seaching */
+
+       struct path u_this;             /* this is me */
+       struct path u_next;             /* this is what I overlay */
+};
+
+The union_mount structure holds a reference (dget,mntget) to the next lower
+layer of the union stack. Since a dentry can be part of multiple unions
+(e.g. with bind mounts) they are tied together via the d_unions field of the
+dentry structure.
+
+All union_mount structures are cached in two hash tables, one for lookups of
+the next lower layer of the union stack and one for reverse lookups of the
+next upper layer of the union stack. The reverse lookup is necessary to
+resolve CWD relative path lookups. For calculation of the hash value, the
+(dentry,vfsmount) pair is used. The u_this field is used for the hash table
+which is used in forward lookups and the u_next field for the reverse lookups.
+
+During every new mount (or mount propagation), a new union_mount structure is
+allocated. A reference to the mountpoint's vfsmount and dentry is taken and
+stored in the u_next field.  In almost the same manner an union_mount
+structure is created during the first time lookup of a directory within a
+union mount point. In this case the lookup proceeds to all lower layers of the
+union. Therefore the complete union stack is constructed during lookups.
+
+The union_mount structures of a dentry are destroyed when the dentry itself is
+destroyed. Therefore the dentry cache is indirectly driving the union_mount
+cache like this is done for inodes too. Please note that lower layer
+union_mount structures are kept in memory until the topmost dentry is
+destroyed.
+
+-------------------------------------------------------------------------------
+
+3. Writable Unions: The White-out Filetype and Copy-On-Open
+===========================================================
+
+The white-out filetype isn't new. It has been there for quite some time now
+but Linux's VFS hasn't used it yet. With the availability of union mount code
+inside the VFS the white-out filetype is getting important to support writable
+union mounts. For read-only union mounts support neither white-outs nor
+copy-on-open is necessary.
+
+The white-out filetype has the same function as negative dentries: they
+describe a filename which isn't there. The creation of white-outs needs
+lowlevel filesystem support. At the time of writing this, there is white-out
+support for tmpfs, ext2 and ext3 available. The VFS is extended to make the
+white-out handling transparent to all its users. The white-outs are not
+visible by the user-space.
+
+-------------------------------------------------------------------------------
+
+4. Renaming Unions
+==================
+
+Rename on union mounts has been handled in a lazy way: it returned -EXDEV.
+This works well for dirctories but not for regular files. Even a kernel build
+doesn't handle rename errors appropriate. Therefore when renaming regular
+files from a lower layer of the union stack it is copied to the topmost
+layer. If the file already resides on the topmost layer, the traditional
+rename method is used.
+
+-------------------------------------------------------------------------------
+
+5. Directory Reading
+====================
+
+As mentioned, union mounts represent a single view of multiple directories as
+if they are merged together. This is achieved by reading the contents of every
+directory on the union stack and by merging the result. When the directory
+listing is read via readdir() or getdents() system call, the union stack is
+traversed from the topmost layer of the union stack to the lowermost.
+
+Likewise with regular files, directories are seekable and the position of the
+following read is marked by the file position filp->f_pos. When reading from
+multiple directories, it is possible that the file position exceeds the inode
+size of the first directory. Therefore the file position is rearranged to
+select the correct directory in the union stack. This is done by substractiong
+the inode size if the file position exceeds it and selecting the next member
+of the union stack next.
+
+This worked well with filesystems like ext2 that used flat file directories.
+The directory entry offsets are arranged linear and are always smaller than
+the inode size of the directory. Modern filesystems have implemented
+directories differently and just return special cookies as directory entry
+offsets which are unrelated to the position in the directory or the inode
+size.
+
+-------------------------------------------------------------------------------
+
+6. Known Problems
+=================
+
+- currently it doesn't support seeking/readdir when d_off > i_size is possible
+- readdir() is a file operation
+- copyup() for other filetypes that reg and dir (e.g. for chown() on devices)
+
+-------------------------------------------------------------------------------
+
+7. References
+=============
+
+[1] http://marc.info/?l=linux-fsdevel&m=96035682927821&w=2
+[2] http://marc.info/?l=linux-fsdevel&m=117681527820133&w=2
+[3] http://marc.info/?l=linux-fsdevel&m=117913503200362&w=2
+[4] http://marc.info/?l=linux-fsdevel&m=118231827024394&w=2
+
+Authors:
+Jan Blunck <jblunck@suse.de>
+Bharata B Rao <bharata@linux.vnet.ibm.com>
diff --git a/fs/Kconfig b/fs/Kconfig
index 522469a..b362e0a 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -309,6 +309,14 @@ config INOTIFY_USER
 
 	  If unsure, say Y.
 
+config UNION_MOUNT
+       bool "Union mount support (EXPERIMENTAL)"
+       depends on EXPERIMENTAL
+       ---help---
+         If you say Y here, you will be able to mount file systems as
+         union mount stacks. This is a VFS based implementation and
+         should work with all file systems. If unsure, say N.
+
 config QUOTA
 	bool "Quota support"
 	help
diff --git a/fs/Makefile b/fs/Makefile
index d9f8afe..7bc3377 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -52,6 +52,8 @@ obj-$(CONFIG_FS_POSIX_ACL)	+= posix_acl.o xattr_acl.o
 obj-$(CONFIG_NFS_COMMON)	+= nfs_common/
 obj-$(CONFIG_GENERIC_ACL)	+= generic_acl.o
 
+obj-$(CONFIG_UNION_MOUNT)	+= union.o
+
 obj-$(CONFIG_QUOTA)		+= dquot.o
 obj-$(CONFIG_QFMT_V1)		+= quota_v1.o
 obj-$(CONFIG_QFMT_V2)		+= quota_v2.o
diff --git a/fs/namei.c b/fs/namei.c
index d34e0f9..0458128 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -32,6 +32,7 @@
 #include <linux/fcntl.h>
 #include <linux/device_cgroup.h>
 #include <asm/uaccess.h>
+#include "union.h"
 
 #define ACC_MODE(x) ("\000\004\002\006"[(x)&O_ACCMODE])
 
@@ -787,6 +788,49 @@ static __always_inline void follow_dotdot(struct nameidata *nd)
 	follow_mount(&nd->path.mnt, &nd->path.dentry);
 }
 
+static int do_lookup_union(struct nameidata *nd, struct qstr *name,
+			   struct path *path)
+{
+	int err;
+	struct path save;
+
+	save = nd->path;
+	path_get(&save);
+	while (follow_union_up(&nd->path)) {
+		struct dentry *dentry;
+
+		dentry = d_hash_and_lookup(nd->path.dentry, name);
+		if (dentry && dentry->d_op && dentry->d_op->d_revalidate) {
+			dentry = do_revalidate(dentry, nd);
+			err = PTR_ERR(dentry);
+			if (IS_ERR(dentry))
+				goto out;
+		}
+		if (!dentry) {
+			dentry = real_lookup(nd->path.dentry, name, nd);
+			err = PTR_ERR(dentry);
+			if (IS_ERR(dentry))
+				goto out;
+		}
+		if (dentry->d_inode) {
+			dput(path->dentry);
+			path->dentry = dentry;
+			path->mnt = mntget(nd->path.mnt);
+			follow_mount(&path->mnt, &path->dentry);
+			err = 0;
+			goto out;
+		}
+		dput(dentry);
+	}
+	__follow_mount(path);
+	err = 0;
+out:
+	path_put(&nd->path);
+	nd->path = save;
+
+	return err;
+}
+
 /*
  *  It's more convoluted than I'd like it to be, but... it's still fairly
  *  small and for now I'd prefer to have fast path as straight as possible.
@@ -805,6 +849,11 @@ static int do_lookup(struct nameidata *nd, struct qstr *name,
 done:
 	path->mnt = mnt;
 	path->dentry = dentry;
+	if (IS_MNT_UNION(mnt) && !dentry->d_inode &&
+	    nd->path.dentry == nd->path.mnt->mnt_root) {
+		return do_lookup_union(nd, name, path);
+	}
+
 	__follow_mount(path);
 	return 0;
 
diff --git a/fs/namespace.c b/fs/namespace.c
index 65b3dc8..eebcb4f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -31,6 +31,7 @@
 #include <asm/unistd.h>
 #include "pnode.h"
 #include "internal.h"
+#include "union.h"
 
 #define HASH_SHIFT ilog2(PAGE_SIZE / sizeof(struct list_head))
 #define HASH_SIZE (1UL << HASH_SHIFT)
@@ -778,6 +779,7 @@ static void show_mnt_opts(struct seq_file *m, struct vfsmount *mnt)
 		{ MNT_NOATIME, ",noatime" },
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
+		{ MNT_UNION, ",union" },
 		{ 0, NULL }
 	};
 	const struct proc_fs_info *fs_infop;
@@ -1439,6 +1441,10 @@ static int do_change_type(struct path *path, int flag)
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't change the type of union mounts */
+	if (IS_MNT_UNION(path->mnt))
+		return -EINVAL;
+
 	down_write(&namespace_sem);
 	if (type == MS_SHARED) {
 		err = invent_group_ids(mnt, recurse);
@@ -1460,7 +1466,7 @@ static int do_change_type(struct path *path, int flag)
  * do loopback mount.
  */
 static int do_loopback(struct path *path, char *old_name,
-				int recurse)
+				int recurse, int mnt_flags)
 {
 	struct path old_path;
 	struct vfsmount *mnt = NULL;
@@ -1490,6 +1496,9 @@ static int do_loopback(struct path *path, char *old_name,
 	if (!mnt)
 		goto out;
 
+	if (mnt_flags & MNT_UNION)
+		mnt->mnt_flags |= MNT_UNION;
+
 	err = graft_tree(mnt, path);
 	if (err) {
 		LIST_HEAD(umount_list);
@@ -1583,6 +1592,13 @@ static int do_move_mount(struct path *path, char *old_name)
 	if (err)
 		return err;
 
+	/* moving to or from a union mount is not supported */
+	err = -EINVAL;
+	if (IS_MNT_UNION(path->mnt))
+		goto exit;
+	if (IS_MNT_UNION(old_path.mnt))
+		goto exit;
+
 	down_write(&namespace_sem);
 	while (d_mountpoint(path->dentry) &&
 	       follow_down(&path->mnt, &path->dentry))
@@ -1640,6 +1656,7 @@ out:
 	up_write(&namespace_sem);
 	if (!err)
 		path_put(&parent_path);
+exit:
 	path_put(&old_path);
 	return err;
 }
@@ -1932,9 +1949,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		mnt_flags |= MNT_RELATIME;
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
+	if (flags & MS_UNION)
+		mnt_flags |= MNT_UNION;
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE |
-		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT);
+		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME | MS_KERNMOUNT |
+		   MS_UNION);
 
 	/* ... and get the mountpoint */
 	retval = kern_path(dir_name, LOOKUP_FOLLOW, &path);
@@ -1950,7 +1970,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
 				    data_page);
 	else if (flags & MS_BIND)
-		retval = do_loopback(&path, dev_name, flags & MS_REC);
+		retval = do_loopback(&path, dev_name, flags & MS_REC, mnt_flags);
 	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
 		retval = do_change_type(&path, flags);
 	else if (flags & MS_MOVE)
diff --git a/fs/readdir.c b/fs/readdir.c
index b318d9b..bc2d979 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -16,8 +16,8 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
-
 #include <asm/uaccess.h>
+#include "union.h"
 
 int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 {
@@ -30,16 +30,20 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 	if (res)
 		goto out;
 
-	res = mutex_lock_killable(&inode->i_mutex);
-	if (res)
-		goto out;
-
-	res = -ENOENT;
-	if (!IS_DEADDIR(inode)) {
-		res = file->f_op->readdir(file, buf, filler);
-		file_accessed(file);
+	if (IS_MNT_UNION(file->f_path.mnt)) {
+		res = readdir_union(file, buf, filler);
+	} else {
+		res = mutex_lock_killable(&inode->i_mutex);
+		if (res)
+			goto out;
+
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
diff --git a/fs/union.c b/fs/union.c
new file mode 100644
index 0000000..6222186
--- /dev/null
+++ b/fs/union.c
@@ -0,0 +1,363 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
+ *
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ */
+
+#include <linux/fs.h>
+#include <linux/namei.h>
+#include <linux/module.h>
+#include <linux/file.h>
+#include "union.h"
+
+/*
+ * follow_union_up - follow the union stack one layer "up"
+ *
+ * This is called to traverse the union stack from one layer to the next
+ * overlayed one. follow_union_up() is called by various lookup functions
+ * that are aware of union mounts.
+ *
+ * Returns none zero if followed to the next layer, zero otherwise.
+ */
+int follow_union_up(struct path *path)
+{
+	if (IS_MNT_UNION(path->mnt) && path->dentry == path->mnt->mnt_root)
+		return follow_up(&path->mnt, &path->dentry);
+
+	return 0;
+}
+
+
+/*
+ * Union mounts support for readdir.
+ */
+
+/* The readdir union cache object */
+struct union_cache_entry {
+	struct list_head list;
+	struct qstr name;
+};
+
+static int union_cache_add_entry(struct list_head *list,
+				 const char *name, int namelen)
+{
+	struct union_cache_entry *this;
+	char *tmp_name;
+
+	this = kmalloc(sizeof(*this), GFP_KERNEL);
+	if (!this) {
+		printk(KERN_CRIT
+		       "union_cache_add_entry(): out of kernel memory\n");
+		return -ENOMEM;
+	}
+
+	tmp_name = kmalloc(namelen + 1, GFP_KERNEL);
+	if (!tmp_name) {
+		printk(KERN_CRIT
+		       "union_cache_add_entry(): out of kernel memory\n");
+		kfree(this);
+		return -ENOMEM;
+	}
+
+	this->name.name = tmp_name;
+	this->name.len = namelen;
+	this->name.hash = 0;
+	memcpy(tmp_name, name, namelen);
+	tmp_name[namelen] = 0;
+	INIT_LIST_HEAD(&this->list);
+	list_add(&this->list, list);
+	return 0;
+}
+
+static void union_cache_free(struct list_head *uc_list)
+{
+	struct list_head *p;
+	struct list_head *ptmp;
+	int count = 0;
+
+	list_for_each_safe(p, ptmp, uc_list) {
+		struct union_cache_entry *this;
+
+		this = list_entry(p, struct union_cache_entry, list);
+		list_del_init(&this->list);
+		kfree(this->name.name);
+		kfree(this);
+		count++;
+	}
+	return;
+}
+
+static int union_cache_find_entry(struct list_head *uc_list,
+				  const char *name, int namelen)
+{
+	struct union_cache_entry *p;
+	int ret = 0;
+
+	list_for_each_entry(p, uc_list, list) {
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
+/*
+ * There are four filldir() wrapper necessary for the union mount readdir
+ * implementation:
+ *
+ * - filldir_topmost(): fills the union's readdir cache and the user space
+ *			buffer. This is only used for the topmost directory
+ *			in the union stack.
+ * - filldir_topmost_cacheonly(): only fills the union's readdir cache.
+ *			This is only used for the topmost directory in the
+ *			union stack.
+ * - filldir_overlaid(): fills the union's readdir cache and the user space
+ *			buffer. This is only used for directories on the
+ *			stack's lower layers.
+ * - filldir_overlaid_cacheonly(): only fills the union's readdir cache.
+ *			This is only used for directories on the stack's
+ *			lower layers.
+ */
+
+struct union_cache_callback {
+	struct list_head list;		/* list of union cache entries */
+	void *orig_buf;			/* original getdents_callback */
+	filldir_t orig_filler;		/* the filldir() we should call */
+	loff_t offset;			/* base offset of our dirents */
+	loff_t count;			/* maximum number of bytes to "read" */
+};
+
+static int filldir_topmost(void *buf, const char *name, int namlen,
+			   loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return cb->orig_filler(cb->orig_buf, name, namlen, cb->offset + offset,
+			       ino, d_type);
+}
+
+static int filldir_topmost_cacheonly(void *buf, const char *name, int namlen,
+				     loff_t offset, u64 ino,
+				     unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	if (offset > cb->count)
+		return -EINVAL;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return 0;
+}
+
+static int filldir_overlaid(void *buf, const char *name, int namlen,
+			    loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (union_cache_find_entry(&cb->list, name, namlen))
+		return 0;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return cb->orig_filler(cb->orig_buf, name, namlen, cb->offset + offset,
+			       ino, d_type);
+}
+
+static int filldir_overlaid_cacheonly(void *buf, const char *name, int namlen,
+				      loff_t offset, u64 ino,
+				      unsigned int d_type)
+{
+	struct union_cache_callback *cb = buf;
+
+	if (offset > cb->count)
+		return -EINVAL;
+
+	switch (namlen) {
+	case 2:
+		if (name[1] != '.')
+			break;
+	case 1:
+		if (name[0] != '.')
+			break;
+		return 0;
+	}
+
+	if (union_cache_find_entry(&cb->list, name, namlen))
+		return 0;
+
+	union_cache_add_entry(&cb->list, name, namlen);
+	return 0;
+}
+
+/*
+ * readdir_union_cache - A helper to fill the readdir cache
+ */
+static int readdir_union_cache(struct file *file, void *_buf, filldir_t filler)
+{
+	struct union_cache_callback *cb = _buf;
+	int old_count;
+	loff_t old_pos;
+	int res;
+
+	old_count = cb->count;
+	cb->count = ((file->f_pos > i_size_read(file->f_path.dentry->d_inode)) ?
+		      i_size_read(file->f_path.dentry->d_inode) :
+		      file->f_pos) & INT_MAX;
+	old_pos = file->f_pos;
+	file->f_pos = 0;
+	res = file->f_op->readdir(file, _buf, filler);
+	file->f_pos = old_pos;
+	cb->count = old_count;
+	return res;
+}
+
+/*
+ * readdir_union - A wrapper around ->readdir()
+ *
+ * This is a wrapper around the filesystems readdir(), which is walking
+ * the union stack and calls ->readdir() for every directory in the stack.
+ * The directory entries are read into the union mounts readdir cache to
+ * support whiteout's and duplicate removal.
+ */
+int readdir_union(struct file *file, void *buf, filldir_t filler)
+{
+	struct inode *inode = file->f_path.dentry->d_inode;
+	struct union_cache_callback cb;
+	struct path path;
+	loff_t offset = 0;
+	int res;
+
+	/* FIXME: make it killable */
+	mutex_lock(&inode->i_mutex);
+	if (IS_DEADDIR(inode)) {
+		mutex_unlock(&inode->i_mutex);
+		return -ENOENT;
+	}
+
+	INIT_LIST_HEAD(&cb.list);
+	cb.orig_buf = buf;
+	cb.orig_filler = filler;
+	cb.offset = 0;
+	offset = i_size_read(file->f_path.dentry->d_inode);
+	cb.count = file->f_pos;
+
+	if (file->f_pos > 0) {
+		/*
+		 * We have already read from this dir, lets read that stuff to
+		 * our union-cache only
+		 */
+		res = readdir_union_cache(file, &cb,
+					  filldir_topmost_cacheonly);
+		if (res) {
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+	}
+
+	if (file->f_pos < offset) {
+		res = file->f_op->readdir(file, &cb, filldir_topmost);
+		file_accessed(file);
+		if (res) {
+			mutex_unlock(&inode->i_mutex);
+			goto out;
+		}
+		/* We read until EOF of this directory */
+		file->f_pos = offset;
+	}
+
+	mutex_unlock(&inode->i_mutex);
+
+	path = file->f_path;
+	path_get(&path);
+	while (follow_union_up(&path)) {
+		struct file *ftmp;
+
+		/* get path reference for filep */
+		path_get(&path);
+		ftmp = dentry_open(path.dentry, path.mnt,
+				   ((file->f_flags & ~(O_ACCMODE)) |
+				    O_RDONLY | O_DIRECTORY | O_NOATIME));
+		if (IS_ERR(ftmp)) {
+			res = PTR_ERR(ftmp);
+			break;
+		}
+
+		inode = path.dentry->d_inode;
+		mutex_lock(&inode->i_mutex);
+
+		/* rearrange the file position */
+		cb.offset += offset;
+		offset = i_size_read(inode);
+		ftmp->f_pos = file->f_pos - cb.offset;
+		cb.count = ftmp->f_pos;
+		if (ftmp->f_pos < 0) {
+			mutex_unlock(&inode->i_mutex);
+			fput(ftmp);
+			break;
+		}
+
+		res = -ENOENT;
+		if (IS_DEADDIR(inode))
+			goto out_fput;
+
+		if (ftmp->f_pos > 0) {
+			/*
+			 * We have already read from this dir, lets read that
+			 * stuff to our union-cache only
+			 */
+			res = readdir_union_cache(ftmp, &cb,
+						  filldir_overlaid_cacheonly);
+			if (res)
+				goto out_fput;
+		}
+
+		if (ftmp->f_pos < offset) {
+			res = ftmp->f_op->readdir(ftmp, &cb, filldir_overlaid);
+			file_accessed(ftmp);
+			if (res)
+				file->f_pos += ftmp->f_pos;
+			else
+				/*
+				 * We read until EOF of this directory, so lets
+				 * advance the f_pos by the maximum offset
+				 * (i_size) of this directory
+				 */
+				file->f_pos += offset;
+		}
+
+		file_accessed(ftmp);
+
+out_fput:
+		mutex_unlock(&inode->i_mutex);
+		fput(ftmp);
+
+		if (res)
+			break;
+	}
+	path_put(&path);
+out:
+	union_cache_free(&cb.list);
+	return res;
+}
diff --git a/fs/union.h b/fs/union.h
new file mode 100644
index 0000000..ddf5df8
--- /dev/null
+++ b/fs/union.h
@@ -0,0 +1,26 @@
+/*
+ * VFS based union mount for Linux
+ *
+ * Copyright (C) 2004-2007 IBM Corporation, IBM Deutschland Entwicklung GmbH.
+ * Copyright (C) 2007 Novell Inc.
+ *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; either version 2 of the License, or (at your option)
+ * any later version.
+ *
+ */
+
+#include <linux/mount.h>
+
+struct path;
+
+extern int follow_union_up(struct path *path);
+extern int readdir_union(struct file *file, void *buf, filldir_t filler);
+
+#ifdef CONFIG_UNION_MOUNT
+#define IS_MNT_UNION(mnt)	((mnt)->mnt_flags & MNT_UNION)
+#else
+#define IS_MNT_UNION(x)		(0)
+#endif
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0dcdd94..463172e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -119,6 +119,7 @@ extern int dir_notify_enable;
 #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
 #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
 #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
+#define MS_UNION	256
 #define MS_NOATIME	1024	/* Do not update access times. */
 #define MS_NODIRATIME	2048	/* Do not update directory access times */
 #define MS_BIND		4096
diff --git a/include/linux/mount.h b/include/linux/mount.h
index cab2a85..bd35fb8 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -34,6 +34,7 @@ struct mnt_namespace;
 #define MNT_SHARED	0x1000	/* if the vfsmount is a shared mount */
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
+#define MNT_UNION	0x4000	/* if the vfsmount is a union mount */
 
 struct vfsmount {
 	struct list_head mnt_hash;
