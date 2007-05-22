Return-Path: <linux-kernel-owner+w=401wt.eu-S966661AbXEVSvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966661AbXEVSvV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 14:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758895AbXEVSvJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 14:51:09 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:43109 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757571AbXEVSvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 14:51:05 -0400
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
CC: akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       torvalds@linux-foundation.org
Subject: [RFC PATCH] file as directory
Message-Id: <E1HqZPd-0008Dh-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 22 May 2007 20:48:49 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Why do we want this?
--------------------

That depends on who you ask.  My answer is this:

  'foo.tar.gz/foo/bar' or
  'foo.tar.gz/contents/foo/bar'

or something similar.

Others might suggest accessing streams, resource forks or extended
attributes through such an interface.  However this patch only deals
with the non-directory case, so directories would be excluded from
that interface.

But otherwise this patch doesn't limit the uses of the "file as
directory" concept in any way.  It just adds the infrastructure to
support these whacky beasts.

How is it done?
---------------

(See this [1] thread for more discussion on the subject)

When a non-directory object is accessed without a trailing slash, then
path resolution returns the object itself as usual.

If a non-directory object is accessed with a trailing slash, then the
filesystem may opt to let the file be accessed as a directory.  In
this case "something" (as supplied by the filesystem) is mounted on
top of the non-directory object.

This mount will have special properties:

 - If there's no trailing slash is after the file name, the mount
   won't be followed, even if the path resolution would otherwise
   follow mounts.

 - The mount only stays there while it is referenced by some external
   object, like a pwd or an open file.  When it is no longer
   referenced, it is automatically unmounted.

 - Unlike "real" mounts, this won't block unlink(2) or rename(2) on
   the underlying object.


Compatibility with existing systems
-----------------------------------

Filesystems which enable "file as directory" semantics, might possibly
break existing applications.  For example an app could conceivably
check if an object is a directory by appending a slash to the name and
trying some filesystem operation.  This application might be confused
by allowing such operations to succeed on non-directory objects.

However in practice this sort of behavior seem to be rare.

The other question is, how well unmodified applications cope with
user-supplied paths which have a slash after the name of a
non-directory object.

Command line utilities seem to cope very well, since they don't have
too much path "sanitization".  Bash also seems perfectly capable of
dealing with such beasts, with filename completion and everything.

More complex apps like emacs and file browsers have more problems, but
in some cases they do actually work as expected.  Notably if the
supplied path has at least one additional component below the
non-directory object.

So while this doesn't work in emacs etc.:

  foo.tar.gz/

this usually does:

  foo.tar.gz/foo

It is probably trivial to teach these programs to not be too clever
with path names.  It should also be possible to make apps be aware and
explicitly support files as directories.

Implementation details
----------------------

See comments and Documentation/* in the patch.

The patch is careful not to touch the fastpaths in the path
resolution:

- Only check ->enter() if ->lookup() is not defined and there's a
  trailing slash.  This happens very infrequently, since most apps
  check the file type before trying to enter a directory

 - Since the "directory on file" mount is removed on leave, most files
   won't have anything mounted over them.  In these cases
   follow_mount() and friends will be just as fast as before this
   patch.  There's only a negligible slowdown for crossing a
   mountpoint and a very minor slowdown for accessing files, which
   currently have a "directory on file" mount over them.

How to try it out
-----------------

This needs quite a bit of fiddling.  First get the files from

  http://www.kernel.org/pub/linux/kernel/people/mszeredi/file-as-directory/

 - Get the CVS version of fuse, patch it with fuse-enter.patch.

 - Compile avfs-enter.c as instructed at the top of that file

 - Get the CVS version of AVFS and compile it, you should get a
   working avfsd daemon.  After mounting with "./avfsd /avfs", try

     ls -l /avfs/usr/src/linux-2.6.21.tar.gz#/

 - Patch a kernel with the below patch.  This is against
   2.6.22-rc1-mm1, but with some effort should apply to other recent
   kernels.

 - Reboot and look for "app/pid enter name/" lines in dmesg.  Those
   are when an app is attempting to access a non-directory with a
   slash, and failing of course, because no filesystem supports this
   yet.

 - Mount the avfs filesystem.  It is important to mount it on /avfs.

 - Mount the avfs-enter filesystem somewhere, e.g. /tmp/avfs

 - Try

     ls -l /tmp/avfs/usr/src/linux-2.6.21.tar.gz
     ls -l /tmp/avfs/usr/src/linux-2.6.21.tar.gz/
     cd /tmp/avfs/usr/src/linux-2.6.21.tar.gz/

[1] http://article.gmane.org/gmane.comp.file-systems.reiserfs.general/10861

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

 Documentation/filesystems/Locking |    7 +
 Documentation/filesystems/vfs.txt |   12 +-
 fs/dcache.c                       |    2
 fs/namei.c                        |  121 ++++++++++++++++----
 fs/namespace.c                    |  223 +++++++++++++++++++++++++++++++++-----
 include/linux/dcache.h            |   20 +++
 include/linux/fs.h                |    2
 include/linux/mount.h             |    4
 include/linux/namei.h             |    3
 9 files changed, 338 insertions(+), 56 deletions(-)

Index: linux/fs/namei.c
===================================================================
--- linux.orig/fs/namei.c	2007-05-22 18:06:24.000000000 +0200
+++ linux/fs/namei.c	2007-05-22 18:06:32.000000000 +0200
@@ -669,14 +669,22 @@ int follow_up(struct vfsmount **mnt, str
 	return 1;
 }
 
-/* no need for dcache_lock, as serialization is taken care in
+/*
+ * Follows mounts on the given struct path.  Assumes that no extra
+ * reference is held for the supplied vfsmount.
+ *
+ * If 'enter' is false, does not follow "directory on file" mounts.
+ *
+ * No need for dcache_lock, as serialization is taken care in
  * namespace.c
  */
-static int __follow_mount(struct path *path)
+static int __follow_mount(struct path *path, bool enter)
 {
 	int res = 0;
 	while (d_mountpoint(path->dentry)) {
-		struct vfsmount *mounted = lookup_mnt(path->mnt, path->dentry);
+		struct vfsmount *mounted =
+			lookup_mnt(path->mnt, path->dentry, enter);
+
 		if (!mounted)
 			break;
 		dput(path->dentry);
@@ -689,27 +697,37 @@ static int __follow_mount(struct path *p
 	return res;
 }
 
-static void follow_mount(struct vfsmount **mnt, struct dentry **dentry)
+/*
+ * Follows mounts on the given nameidata.
+ *
+ * Only follows "directory on file" mounts if LOOKUP_ENTER is set.
+ */
+void follow_mount(struct nameidata *nd)
 {
-	while (d_mountpoint(*dentry)) {
-		struct vfsmount *mounted = lookup_mnt(*mnt, *dentry);
+	while (d_mountpoint(nd->dentry)) {
+		bool enter = nd->flags & LOOKUP_ENTER;
+		struct vfsmount *mounted =
+			lookup_mnt(nd->mnt, nd->dentry, enter);
+
 		if (!mounted)
 			break;
-		dput(*dentry);
-		mntput(*mnt);
-		*mnt = mounted;
-		*dentry = dget(mounted->mnt_root);
+		dput(nd->dentry);
+		mntput(nd->mnt);
+		nd->mnt = mounted;
+		nd->dentry = dget(mounted->mnt_root);
 	}
 }
 
-/* no need for dcache_lock, as serialization is taken care in
- * namespace.c
+/*
+ * Follows mounts on the given vfsmount/dentry.
+ *
+ * Does not follow "directory on file" mounts.
  */
 int follow_down(struct vfsmount **mnt, struct dentry **dentry)
 {
 	struct vfsmount *mounted;
 
-	mounted = lookup_mnt(*mnt, *dentry);
+	mounted = lookup_mnt(*mnt, *dentry, false);
 	if (mounted) {
 		dput(*dentry);
 		mntput(*mnt);
@@ -756,7 +774,7 @@ static __always_inline void follow_dotdo
 		mntput(nd->mnt);
 		nd->mnt = parent;
 	}
-	follow_mount(&nd->mnt, &nd->dentry);
+	follow_mount(nd);
 }
 
 /*
@@ -777,7 +795,7 @@ static int do_lookup(struct nameidata *n
 done:
 	path->mnt = mnt;
 	path->dentry = dentry;
-	__follow_mount(path);
+	__follow_mount(path, nd->flags & LOOKUP_ENTER);
 	return 0;
 
 need_lookup:
@@ -799,6 +817,40 @@ fail:
 }
 
 /*
+ * Try to enter a non-directory object.
+ *
+ * This is called if the object has no ->lookup() defined, yet the
+ * path contains a slash after the object name.
+ *
+ * If the filesystem defines an ->enter() method, this will be called,
+ * and the filesystem shall fill the supplied struct path or return an
+ * error.
+ *
+ * The returned path will be bind mounted on top of the object with
+ * the MNT_DIRONFILE flag, and the nameidata will descend into the
+ * mount.
+ */
+static int enter_file(struct inode *inode, struct nameidata *nd)
+{
+	int err;
+	struct path newpath;
+
+	printk(KERN_DEBUG "%s/%d enter %s/\n", current->comm, current->pid,
+	       nd->dentry->d_name.name);
+	if (!inode->i_op->enter)
+		return -ENOTDIR;
+
+	newpath.mnt = NULL;
+	newpath.dentry = NULL;
+	err = inode->i_op->enter(nd, &newpath);
+	if (!err) {
+		err = mount_dironfile(nd, &newpath);
+		pathput(&newpath);
+	}
+	return err;
+}
+
+/*
  * Name resolution.
  * This is the basic name resolution function, turning a pathname into
  * the final dentry. We expect 'base' to be positive and a directory.
@@ -820,7 +872,8 @@ static fastcall int __link_path_walk(con
 
 	inode = nd->dentry->d_inode;
 	if (nd->depth)
-		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
+		lookup_flags = LOOKUP_FOLLOW |
+			(nd->flags & (LOOKUP_CONTINUE | LOOKUP_ENTER));
 
 	/* At this point we know we have a real path component. */
 	for(;;) {
@@ -828,7 +881,7 @@ static fastcall int __link_path_walk(con
 		struct qstr this;
 		unsigned int c;
 
-		nd->flags |= LOOKUP_CONTINUE;
+		nd->flags |= LOOKUP_CONTINUE | LOOKUP_ENTER;
 		err = exec_permission_lite(inode, nd);
 		if (err == -EAGAIN)
 			err = vfs_permission(nd, MAY_EXEC);
@@ -906,17 +959,22 @@ static fastcall int __link_path_walk(con
 				break;
 		} else
 			path_to_nameidata(&next, nd);
-		err = -ENOTDIR; 
-		if (!inode->i_op->lookup)
-			break;
+		if (unlikely(!inode->i_op->lookup)) {
+			err = enter_file(inode, nd);
+			if (err)
+				break;
+			inode = nd->dentry->d_inode;
+		}
 		continue;
 		/* here ends the main loop */
 
 last_with_slashes:
-		lookup_flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY;
+		lookup_flags |= LOOKUP_FOLLOW | LOOKUP_DIRECTORY |
+			LOOKUP_ENTER;
 last_component:
 		/* Clear LOOKUP_CONTINUE iff it was previously unset */
-		nd->flags &= lookup_flags | ~LOOKUP_CONTINUE;
+		nd->flags &= lookup_flags |
+			~(LOOKUP_CONTINUE | LOOKUP_ENTER);
 		if (lookup_flags & LOOKUP_PARENT)
 			goto lookup_parent;
 		if (this.name[0] == '.') switch (this.len) {
@@ -951,10 +1009,19 @@ last_component:
 		err = -ENOENT;
 		if (!inode)
 			break;
-		if (lookup_flags & LOOKUP_DIRECTORY) {
+		if (lookup_flags & (LOOKUP_DIRECTORY | LOOKUP_ENTER)) {
 			err = -ENOTDIR; 
-			if (!inode->i_op || !inode->i_op->lookup)
+			if (!inode->i_op)
 				break;
+
+			if (!inode->i_op->lookup) {
+				if (!(lookup_flags & LOOKUP_ENTER))
+					break;
+
+				err = enter_file(inode, nd);
+				if (err)
+					break;
+			}
 		}
 		goto return_base;
 lookup_parent:
@@ -1726,7 +1793,7 @@ do_last:
 	if (flag & O_EXCL)
 		goto exit_dput;
 
-	if (__follow_mount(&path)) {
+	if (__follow_mount(&path, false)) {
 		error = -ELOOP;
 		if (flag & O_NOFOLLOW)
 			goto exit_dput;
@@ -2114,7 +2181,7 @@ int vfs_unlink(struct inode *dir, struct
 	DQUOT_INIT(dir);
 
 	mutex_lock(&dentry->d_inode->i_mutex);
-	if (d_mountpoint(dentry))
+	if (d_real_mountpoint(dentry))
 		error = -EBUSY;
 	else {
 		error = security_inode_unlink(dir, dentry);
@@ -2449,7 +2516,7 @@ static int vfs_rename_other(struct inode
 	target = new_dentry->d_inode;
 	if (target)
 		mutex_lock(&target->i_mutex);
-	if (d_mountpoint(old_dentry)||d_mountpoint(new_dentry))
+	if (d_real_mountpoint(old_dentry)||d_real_mountpoint(new_dentry))
 		error = -EBUSY;
 	else
 		error = old_dir->i_op->rename(old_dir, old_dentry, new_dir, new_dentry);
Index: linux/fs/namespace.c
===================================================================
--- linux.orig/fs/namespace.c	2007-05-22 18:06:24.000000000 +0200
+++ linux/fs/namespace.c	2007-05-22 18:06:32.000000000 +0200
@@ -122,13 +122,21 @@ struct vfsmount *__lookup_mnt(struct vfs
 /*
  * lookup_mnt increments the ref count before returning
  * the vfsmount struct.
+ *
+ * If 'enter' is false, ignore "directory on file" mounts
  */
-struct vfsmount *lookup_mnt(struct vfsmount *mnt, struct dentry *dentry)
+struct vfsmount *lookup_mnt(struct vfsmount *mnt, struct dentry *dentry,
+			    bool enter)
 {
 	struct vfsmount *child_mnt;
 	spin_lock(&vfsmount_lock);
-	if ((child_mnt = __lookup_mnt(mnt, dentry, 1)))
-		mntget(child_mnt);
+	child_mnt = __lookup_mnt(mnt, dentry, 1);
+	if (child_mnt) {
+		if (IS_MNT_DIRONFILE(child_mnt) && !enter)
+			child_mnt = NULL;
+		else
+			mntget(child_mnt);
+	}
 	spin_unlock(&vfsmount_lock);
 	return child_mnt;
 }
@@ -156,6 +164,7 @@ static void __touch_mnt_namespace(struct
 
 static void detach_mnt(struct vfsmount *mnt, struct nameidata *old_nd)
 {
+	BUG_ON(IS_MNT_DIRONFILE(mnt));
 	old_nd->dentry = mnt->mnt_mountpoint;
 	old_nd->mnt = mnt->mnt_parent;
 	mnt->mnt_parent = mnt;
@@ -301,8 +310,8 @@ static struct vfsmount *clone_mnt(struct
 	mnt->mnt_mountpoint = mnt->mnt_root;
 	mnt->mnt_parent = mnt;
 
-	/* don't copy the MNT_USER flag */
-	mnt->mnt_flags &= ~MNT_USER;
+	/* don't copy some flags */
+	mnt->mnt_flags &= ~(MNT_USER | MNT_DIRONFILE);
 	if (flag & CL_SETUSER)
 		__set_mnt_user(mnt, owner);
 
@@ -339,6 +348,48 @@ static struct vfsmount *clone_mnt(struct
 	return ERR_PTR(-ENOMEM);
 }
 
+/*
+ * Automatically umount "directory on file" mounts when the last
+ * reference to the mount is released.
+ *
+ * This is tricky, because for namespace modification we must take the
+ * namespace semaphore.  But mntput() is called from various places,
+ * sometimes with namespace_sem held.  Fortunately in those places the
+ * mount cannot yet have MNT_DIRONFILE, or at least that's what I
+ * hope...
+ *
+ * The umounting is done in two stages, first the mount is removed
+ * from the hashes.  This is done atomically wrt other mount lookups,
+ * so it's not possible to acquire a new ref to this dead mount that
+ * way.
+ *
+ * Then after having locked namespace_sem and relocked vfsmount_lock,
+ * the mount is properly detached.
+ */
+static void umount_dironfile(struct vfsmount *mnt)
+	__releases(vfsmount_lock)
+{
+	struct nameidata nd;
+
+	printk(KERN_DEBUG "umount dir-on-file %p\n", mnt);
+	BUG_ON(!IS_MNT_DIRONFILE(mnt));
+	list_del_init(&mnt->mnt_hash);
+	spin_unlock(&vfsmount_lock);
+
+	down_write(&namespace_sem);
+	spin_lock(&vfsmount_lock);
+	mnt->mnt_flags &= ~MNT_DIRONFILE;
+	mnt->mnt_mountpoint->d_dironfile--;
+	detach_mnt(mnt, &nd);
+	list_del_init(&mnt->mnt_expire);
+	list_del_init(&mnt->mnt_list);
+	change_mnt_propagation(mnt, MS_PRIVATE);
+	spin_unlock(&vfsmount_lock);
+	up_write(&namespace_sem);
+
+	path_release(&nd);
+}
+
 static inline void __mntput(struct vfsmount *mnt)
 {
 	struct super_block *sb = mnt->mnt_sb;
@@ -348,12 +399,21 @@ static inline void __mntput(struct vfsmo
 	deactivate_super(sb);
 }
 
+/*
+ * Decrement mount refcount, without reseting the expiry flag
+ *
+ * On final mntput, pinned (process accounting) and still attached
+ * (directory on file) mounts require special treatment.
+ */
 void mntput_no_expire(struct vfsmount *mnt)
 {
 repeat:
 	if (atomic_dec_and_lock(&mnt->mnt_count, &vfsmount_lock)) {
 		if (likely(!mnt->mnt_pinned)) {
-			spin_unlock(&vfsmount_lock);
+			if (mnt->mnt_parent != mnt)
+				umount_dironfile(mnt);
+			else
+				spin_unlock(&vfsmount_lock);
 			__mntput(mnt);
 			return;
 		}
@@ -442,6 +502,7 @@ static int show_vfsmnt(struct seq_file *
 		{ MNT_NODIRATIME, ",nodiratime" },
 		{ MNT_RELATIME, ",relatime" },
 		{ MNT_NOMNT, ",nomnt" },
+		{ MNT_DIRONFILE, ",dironfile" },
 		{ 0, NULL }
 	};
 	struct proc_fs_info *fs_infop;
@@ -609,12 +670,33 @@ void umount_tree(struct vfsmount *mnt, i
 		__touch_mnt_namespace(p->mnt_ns);
 		p->mnt_ns = NULL;
 		list_del_init(&p->mnt_child);
+		/*
+		 * When a "directory on file" mount is detached, clear the
+		 * flag and acquire the missing attachment reference, which
+		 * will be dropped later during the umount.
+		 */
+		if (IS_MNT_DIRONFILE(p)) {
+			printk(KERN_DEBUG "detach dir-on-file %p\n", p);
+			mntget(p);
+			p->mnt_mountpoint->d_dironfile--;
+			p->mnt_flags &= ~MNT_DIRONFILE;
+		}
 		if (p->mnt_parent != p)
 			p->mnt_mountpoint->d_mounted--;
 		change_mnt_propagation(p, MS_PRIVATE);
 	}
 }
 
+void release_tree(struct vfsmount *mnt)
+{
+	LIST_HEAD(umount_list);
+
+	spin_lock(&vfsmount_lock);
+	umount_tree(mnt, 0, &umount_list);
+	spin_unlock(&vfsmount_lock);
+	release_mounts(&umount_list);
+}
+
 static int do_umount(struct vfsmount *mnt, int flags)
 {
 	struct super_block *sb = mnt->mnt_sb;
@@ -809,6 +891,12 @@ static int lives_below_in_same_fs(struct
 	}
 }
 
+/*
+ * Recursively clone a mount tree
+ *
+ * Unless CL_COPY_ALL clone flag is given, skip unbindable and
+ * "directory on file" mounts
+ */
 struct vfsmount *copy_tree(struct vfsmount *mnt, struct dentry *dentry,
 					int flag, uid_t owner)
 {
@@ -829,7 +917,8 @@ struct vfsmount *copy_tree(struct vfsmou
 			continue;
 
 		for (s = r; s; s = next_mnt(s, r)) {
-			if (!(flag & CL_COPY_ALL) && IS_MNT_UNBINDABLE(s)) {
+			if (!(flag & CL_COPY_ALL) &&
+			    (IS_MNT_UNBINDABLE(s) || IS_MNT_DIRONFILE(mnt))) {
 				s = skip_mnt_tree(s);
 				continue;
 			}
@@ -851,13 +940,8 @@ struct vfsmount *copy_tree(struct vfsmou
 	}
 	return res;
  error:
-	if (res) {
-		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
-		umount_tree(res, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
-		release_mounts(&umount_list);
-	}
+	if (res)
+		release_tree(res);
 	return q;
 }
 
@@ -1032,7 +1116,7 @@ static int do_loopback(struct nameidata 
 
 	down_write(&namespace_sem);
 	err = -EINVAL;
-	if (IS_MNT_UNBINDABLE(old_nd.mnt))
+	if (IS_MNT_UNBINDABLE(old_nd.mnt) || IS_MNT_DIRONFILE(old_nd.mnt))
  		goto out;
 
 	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
@@ -1053,14 +1137,8 @@ static int do_loopback(struct nameidata 
 		goto out;
 
 	err = graft_tree(mnt, nd);
-	if (err) {
-		LIST_HEAD(umount_list);
-		spin_lock(&vfsmount_lock);
-		umount_tree(mnt, 0, &umount_list);
-		spin_unlock(&vfsmount_lock);
-		release_mounts(&umount_list);
-	}
-
+	if (err)
+		release_tree(mnt);
 out:
 	up_write(&namespace_sem);
 	path_release(&old_nd);
@@ -1068,6 +1146,62 @@ out:
 }
 
 /*
+ * Bind mount the "old" path onto the supplied nameidata.  The new
+ * mount is created with the MNT_DIRONFILE flag.
+ *
+ * If successful, descend immediately into the newly created mount.
+ *
+ * No reference is retained for the attachment, so when the mount is
+ * released it will be automatically umounted.
+ */
+int mount_dironfile(struct nameidata *nd, struct path *old)
+{
+	int err;
+	struct vfsmount *mnt;
+
+	down_write(&namespace_sem);
+
+	err = -ENOMEM;
+	mnt = clone_mnt(old->mnt, old->dentry, 0, 0);
+	if (!mnt)
+		goto out;
+
+	change_mnt_propagation(mnt, MS_PRIVATE);
+	mnt->mnt_flags |= MNT_DIRONFILE;
+
+	mutex_lock(&nd->dentry->d_inode->i_mutex);
+	err = -EINVAL;
+	if (S_ISDIR(nd->dentry->d_inode->i_mode))
+		goto out_unlock;
+
+	err = -ENOENT;
+	if (d_unhashed(nd->dentry))
+		goto out_unlock;
+
+	err = 0;
+	spin_lock(&vfsmount_lock);
+	attach_mnt(mnt, nd);
+	mnt->mnt_mountpoint->d_dironfile++;
+	mnt->mnt_ns = mnt->mnt_parent->mnt_ns;
+	list_add_tail(&mnt->mnt_list, &mnt->mnt_ns->list);
+	printk(KERN_DEBUG "mount dir-on-file %p\n", mnt);
+	spin_unlock(&vfsmount_lock);
+
+out_unlock:
+	mutex_unlock(&nd->dentry->d_inode->i_mutex);
+out:
+	up_write(&namespace_sem);
+	if (err)
+		mnt->mnt_flags &= ~MNT_DIRONFILE;
+	else
+		follow_mount(nd);
+
+	mntput(mnt);
+
+	return err;
+}
+
+/*
  * change filesystem flags. dir should be a physical root of filesystem.
  * If you've mounted a non-root directory somewhere and want to do remount
  * on it - tough luck.
@@ -1125,8 +1259,7 @@ static int do_move_mount(struct nameidat
 		return err;
 
 	down_write(&namespace_sem);
-	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
-		;
+	follow_mount(nd);
 	err = -EINVAL;
 	if (!check_mnt(nd->mnt) || !check_mnt(old_nd.mnt))
 		goto out;
@@ -1146,6 +1279,9 @@ static int do_move_mount(struct nameidat
 	if (old_nd.mnt == old_nd.mnt->mnt_parent)
 		goto out1;
 
+	if (IS_MNT_DIRONFILE(old_nd.mnt))
+		goto out1;
+
 	if (S_ISDIR(nd->dentry->d_inode->i_mode) !=
 	      S_ISDIR(old_nd.dentry->d_inode->i_mode))
 		goto out1;
@@ -1240,8 +1376,7 @@ int do_add_mount(struct vfsmount *newmnt
 
 	down_write(&namespace_sem);
 	/* Something was mounted here while we slept */
-	while (d_mountpoint(nd->dentry) && follow_down(&nd->mnt, &nd->dentry))
-		;
+	follow_mount(nd);
 	err = -EINVAL;
 	if (!check_mnt(nd->mnt))
 		goto unlock;
@@ -1602,6 +1737,7 @@ static struct mnt_namespace *dup_mnt_ns(
 	struct mnt_namespace *new_ns;
 	struct vfsmount *rootmnt = NULL, *pwdmnt = NULL, *altrootmnt = NULL;
 	struct vfsmount *p, *q;
+	LIST_HEAD(dironfile_list);
 
 	new_ns = kmalloc(sizeof(struct mnt_namespace), GFP_KERNEL);
 	if (!new_ns)
@@ -1629,6 +1765,9 @@ static struct mnt_namespace *dup_mnt_ns(
 	 * Second pass: switch the tsk->fs->* elements and mark new vfsmounts
 	 * as belonging to new namespace.  We have already acquired a private
 	 * fs_struct, so tsk->fs->lock is not needed.
+	 *
+	 * Move "directory on file" mounts to a dedicated list for special
+	 * treatment.
 	 */
 	p = mnt_ns->root;
 	q = new_ns->root;
@@ -1648,6 +1787,9 @@ static struct mnt_namespace *dup_mnt_ns(
 				fs->altrootmnt = mntget(q);
 			}
 		}
+		if (IS_MNT_DIRONFILE(p))
+			list_move(&q->mnt_list, &dironfile_list);
+
 		p = next_mnt(p, mnt_ns->root);
 		q = next_mnt(q, new_ns->root);
 	}
@@ -1660,6 +1802,31 @@ static struct mnt_namespace *dup_mnt_ns(
 	if (altrootmnt)
 		mntput(altrootmnt);
 
+	/*
+	 * Mounts on dironfile_list were cloned from "directory on
+	 * file" mounts.  So mark the new ones as such and drop the
+	 * attachment reference.
+	 *
+	 * This will have the effect of immediately unmounting all
+	 * those which have not been claimed above by a root, altroot
+	 * or pwd pointer.
+	 *
+	 * No lock needs to be held, because only the brand new
+	 * mnt_namespace is touched.
+	 */
+	while (!list_empty(&dironfile_list)) {
+		struct vfsmount *q;
+
+		q = list_entry(dironfile_list.next, struct vfsmount, mnt_list);
+		q->mnt_flags |= MNT_DIRONFILE;
+		spin_lock(&vfsmount_lock);
+		q->mnt_mountpoint->d_dironfile++;
+		printk(KERN_DEBUG "clone dir-on-file %p\n", q);
+		spin_unlock(&vfsmount_lock);
+		list_move_tail(&q->mnt_list, &new_ns->list);
+		mntput(q);
+	}
+
 	return new_ns;
 }
 
@@ -1853,6 +2020,8 @@ asmlinkage long sys_pivot_root(const cha
 	down_write(&namespace_sem);
 	mutex_lock(&old_nd.dentry->d_inode->i_mutex);
 	error = -EINVAL;
+	if (IS_MNT_DIRONFILE(new_nd.mnt) || IS_MNT_DIRONFILE(user_nd.mnt))
+		goto out2;
 	if (IS_MNT_SHARED(old_nd.mnt) ||
 		IS_MNT_SHARED(new_nd.mnt->mnt_parent) ||
 		IS_MNT_SHARED(user_nd.mnt->mnt_parent))
Index: linux/include/linux/namei.h
===================================================================
--- linux.orig/include/linux/namei.h	2007-05-22 18:06:24.000000000 +0200
+++ linux/include/linux/namei.h	2007-05-22 18:06:32.000000000 +0200
@@ -55,6 +55,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LA
 #define LOOKUP_PARENT		16
 #define LOOKUP_NOALT		32
 #define LOOKUP_REVAL		64
+#define LOOKUP_ENTER		128
 /*
  * Intent data
  */
@@ -95,6 +96,8 @@ static inline struct dentry *lookup_one_
 extern int follow_down(struct vfsmount **, struct dentry **);
 extern int follow_up(struct vfsmount **, struct dentry **);
 
+extern void follow_mount(struct nameidata *nd);
+
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 extern int kernel_readlink(struct dentry *dentry, char **buffer, int *buflen);
Index: linux/include/linux/mount.h
===================================================================
--- linux.orig/include/linux/mount.h	2007-05-22 18:06:24.000000000 +0200
+++ linux/include/linux/mount.h	2007-05-22 18:06:32.000000000 +0200
@@ -37,6 +37,10 @@ struct mnt_namespace;
 #define MNT_UNBINDABLE	0x2000	/* if the vfsmount is a unbindable mount */
 #define MNT_PNODE_MASK	0x3000	/* propagation flag mask */
 
+#define MNT_DIRONFILE	0x10000
+
+#define IS_MNT_DIRONFILE(mnt) ((mnt)->mnt_flags & MNT_DIRONFILE)
+
 struct vfsmount {
 	struct list_head mnt_hash;
 	struct vfsmount *mnt_parent;	/* fs we are mounted on */
Index: linux/include/linux/fs.h
===================================================================
--- linux.orig/include/linux/fs.h	2007-05-22 18:06:24.000000000 +0200
+++ linux/include/linux/fs.h	2007-05-22 18:06:32.000000000 +0200
@@ -1149,6 +1149,7 @@ struct inode_operations {
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
 	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	int (*enter) (struct nameidata *, struct path *);
 };
 
 struct seq_file;
@@ -1319,6 +1320,7 @@ extern void release_mounts(struct list_h
 extern long do_mount(char *, char *, char *, unsigned long, void *);
 extern void mnt_set_mountpoint(struct vfsmount *, struct dentry *,
 				  struct vfsmount *);
+extern int mount_dironfile(struct nameidata *nd, struct path *old);
 
 extern int vfs_statfs(struct dentry *, struct kstatfs *);
 
Index: linux/include/linux/dcache.h
===================================================================
--- linux.orig/include/linux/dcache.h	2007-05-22 18:06:24.000000000 +0200
+++ linux/include/linux/dcache.h	2007-05-22 18:06:32.000000000 +0200
@@ -111,6 +111,7 @@ struct dentry {
 	struct dcookie_struct *d_cookie; /* cookie, if any */
 #endif
 	int d_mounted;
+	int d_dironfile;
 	unsigned char d_iname[DNAME_INLINE_LEN_MIN];	/* small names */
 };
 
@@ -351,12 +352,29 @@ static inline struct dentry *dget_parent
 
 extern void dput(struct dentry *);
 
+/**
+ * d_mountpoint - check if dentry is mounted
+ * @dentry: detnry to check
+ */
 static inline int d_mountpoint(struct dentry *dentry)
 {
 	return dentry->d_mounted;
 }
 
-extern struct vfsmount *lookup_mnt(struct vfsmount *, struct dentry *);
+/**
+ * d_real_mountpoint - check if dentry has real mounts over it
+ * @dentry: dentry to check
+ *
+ * Returns true if dentry is mounted and not all of those mounts are
+ * "directory on file" mounts
+ */
+static inline int d_real_mountpoint(struct dentry *dentry)
+{
+	BUG_ON(dentry->d_mounted < dentry->d_dironfile);
+	return dentry->d_mounted - dentry->d_dironfile;
+}
+
+extern struct vfsmount *lookup_mnt(struct vfsmount *, struct dentry *, bool);
 extern struct vfsmount *__lookup_mnt(struct vfsmount *, struct dentry *, int);
 extern struct dentry *lookup_create(struct nameidata *nd, int is_dir);
 
Index: linux/Documentation/filesystems/Locking
===================================================================
--- linux.orig/Documentation/filesystems/Locking	2007-05-22 18:06:24.000000000 +0200
+++ linux/Documentation/filesystems/Locking	2007-05-22 18:06:32.000000000 +0200
@@ -51,6 +51,8 @@ ata *);
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
+	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	int (*enter) (struct nameidata *, struct path *);
 
 locking rules:
 	all may block, none have BKL
@@ -74,6 +76,9 @@ setxattr:	yes
 getxattr:	no
 listxattr:	no
 removexattr:	yes
+truncate_range:	yes
+enter:		no
+
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
 	cross-directory ->rename() has (per-superblock) ->s_vfs_rename_sem.
@@ -82,6 +87,8 @@ method. It's called by vmtruncate() - li
 ->setattr(). Locking information above applies to that call (i.e. is
 inherited from ->setattr() - vmtruncate() is used when ATTR_SIZE had been
 passed).
+	->truncate_range() and ->setattr() with ATTR_SIZE also hold
+i_alloc_sem for write.
 
 See Documentation/filesystems/directory-locking for more detailed discussion
 of the locking scheme for directory operations.
Index: linux/Documentation/filesystems/vfs.txt
===================================================================
--- linux.orig/Documentation/filesystems/vfs.txt	2007-05-22 18:06:24.000000000 +0200
+++ linux/Documentation/filesystems/vfs.txt	2007-05-22 18:06:32.000000000 +0200
@@ -324,7 +324,7 @@ struct inode_operations
 -----------------------
 
 This describes how the VFS can manipulate an inode in your
-filesystem. As of kernel 2.6.13, the following members are defined:
+filesystem. As of kernel 2.6.21, the following members are defined:
 
 struct inode_operations {
 	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
@@ -348,6 +348,8 @@ struct inode_operations {
 	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
 	int (*removexattr) (struct dentry *, const char *);
+	void (*truncate_range)(struct inode *, loff_t, loff_t);
+	int (*enter) (struct nameidata *, struct path *);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -444,6 +446,14 @@ otherwise noted.
   removexattr: called by the VFS to remove an extended attribute from
   	a file. This method is called by removexattr(2) system call.
 
+  truncate_range: punch a hole in the middle of the file
+
+  enter: if a non-directory is suffixed with a slash, this method (if
+  	defined) will be called.  The filesystem shall return a
+  	vfsmount/dentry pair in the struct path argument which will be
+  	bind mounted mounted on the object.  The mount will be marked
+  	with a special "directory on file" flag, which will only be
+  	followed when the path contains a slash after the file name.
 
 The Address Space Object
 ========================
Index: linux/fs/dcache.c
===================================================================
--- linux.orig/fs/dcache.c	2007-05-22 18:06:24.000000000 +0200
+++ linux/fs/dcache.c	2007-05-22 18:06:32.000000000 +0200
@@ -87,6 +87,7 @@ static void d_callback(struct rcu_head *
  */
 static void d_free(struct dentry *dentry)
 {
+	BUG_ON(dentry->d_dironfile);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 	/* if dentry was never inserted into hash, immediate free is OK */
@@ -933,6 +934,7 @@ struct dentry *d_alloc(struct dentry * p
 	dentry->d_op = NULL;
 	dentry->d_fsdata = NULL;
 	dentry->d_mounted = 0;
+	dentry->d_dironfile = 0;
 #ifdef CONFIG_PROFILING
 	dentry->d_cookie = NULL;
 #endif
