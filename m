Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbZJaSs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbZJaSs0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 14:48:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933225AbZJaSsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 14:48:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46621 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933162AbZJaSsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 14:48:17 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 09/10] fanotify: fanotify_mark syscall implementation
To: linux-kernel@vger.kernel.org, linus-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
       eparis@redhat.com
Date: Sat, 31 Oct 2009 14:48:13 -0400
Message-ID: <20091031184812.17244.87006.stgit@paris.rdu.redhat.com>
In-Reply-To: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
References: <20091031184721.17244.16465.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAME
	fanotify_mark - add, remove, or modify an fanotify mark on a
filesystem object

SYNOPSIS
	int fanotify_mark(int fanotify_fd, unsigned int flags,
			int dfd, const char *pathname, u64 mask,
			u64 ignored_mask)

DESCRIPTION
	fanotify_mark() is used to add remove or modify a mark on a filesystem
	object.  Marks are used to indicate that the fanotify group is
	interested in events which occur on that object.  At this point in
	time marks may only be added to files and directories.

	fanotify_fd must be a file descriptor returned by fanotify_init()

	The flags field must contain exactly one of the following:

	FAN_MARK_ADD - or the bits in mask and ignored mask into the mark
	FAN_MARK_REMOVE - bitwise remove the bits in mask and ignored mark
		from the mark

	The following values can be OR'd into the flags field:

	FAN_MARK_DONT_FOLLOW - same meaning as O_NOFOLLOW as described in open(2)
	FAN_MARK_ONLYDIR - same meaning as O_DIRECTORY as described in open(2)

	dfd may be any other the following:
	AT_FDCWD: the object will be lookup up based on pathname similar
		to open(2)

	file descriptor of a directory: if pathname is not NULL the
		object to modify will be lookup up similar to openat(2)

	file descriptor of the final object: if pathname is NULL the
		object to modify will be the object referenced by dfd

	The mask is the bitwise OR of the set of events of interest such as:
	FAN_ACCESS		- object was accessed (read)
	FAN_MODIFY		- object was modified (write)
	FAN_CLOSE_WRITE		- object was writable and was closed
	FAN_CLOSE_NOWRITE	- object was read only and was closed
	FAN_OPEN		- object was opened
	FAN_EVENT_ON_CHILD	- interested in objected that happen to
				  children.  Only relavent when the object
				  is a directory
	FAN_Q_OVERFLOW		- event queue overflowed (not implemented)

	The ignored mask is the opposite of the mask as if applied after the
	mask.  If FAN_OPEN is specified in both the mask and the ignored_mask
	no event will be sent to userspace.  This is not persently used but
	will be used when more objects may be marked.  Assume you marked a
	mount point as something of interest.  You could then add an
	ignored_mask entry on individual inodes to get notification on
	everything in the mount point except for a select few inodes.


RETURN VALUE
	On success, this system call returns 0. On error, -1 is
	returned, and errno is set to indicate the error.

ERRORS
	EINVAL An invalid value was specified in flags.

	EINVAL An invalid value was specified in mask.

	EINVAL An invalid value was specified in ignored_mask.

	EINVAL fanotify_fd is not a file descriptor as returned by
	fanotify_init()

	EBADF fanotify_fd is not a valid file descriptor

	EBADF dfd is not a vlid file descriptor and path is NULL.

	ENOTDIR dfd is not a directory and path is not NULL

	EACCESS you do not have search permission on dfd

	EACCESS no search permissions on some part of the path

	ENENT file not found

	ENOMEM Insufficient kernel memory is available.

CONFORMING TO
	These system calls are Linux-specific.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/notify/fanotify/fanotify.h      |   18 +++
 fs/notify/fanotify/fanotify_user.c |  239 ++++++++++++++++++++++++++++++++++++
 include/linux/fanotify.h           |   13 ++
 3 files changed, 269 insertions(+), 1 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.h b/fs/notify/fanotify/fanotify.h
index dd656cf..59c3331 100644
--- a/fs/notify/fanotify/fanotify.h
+++ b/fs/notify/fanotify/fanotify.h
@@ -6,6 +6,24 @@
 
 extern const struct fsnotify_ops fanotify_fsnotify_ops;
 
+static inline bool fanotify_mark_flags_valid(unsigned int flags)
+{
+	/* must be either and add or a remove */
+	if (!(flags & (FAN_MARK_ADD | FAN_MARK_REMOVE)))
+		return false;
+
+	/* cannot be both add and remove */
+	if ((flags & FAN_MARK_ADD) &&
+	    (flags & FAN_MARK_REMOVE))
+		return false;
+
+	/* cannot have more flags than we know about */
+	if (flags & ~FAN_ALL_MARK_FLAGS)
+		return false;
+
+	return true;
+}
+
 static inline bool fanotify_mask_valid(__u32 mask)
 {
 	if (mask & ~((__u32)FAN_ALL_INCOMING_EVENTS))
diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index c93f56b..d415174 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -1,12 +1,18 @@
 #include <linux/fcntl.h>
+#include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/anon_inodes.h>
 #include <linux/fsnotify_backend.h>
+#include <linux/init.h>
+#include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/syscalls.h>
+#include <linux/types.h>
 
 #include "fanotify.h"
 
+static struct kmem_cache *fanotify_mark_cache __read_mostly;
+
 static int fanotify_release(struct inode *ignored, struct file *file)
 {
 	struct fsnotify_group *group = file->private_data;
@@ -28,6 +34,185 @@ static const struct file_operations fanotify_fops = {
 	.compat_ioctl	= NULL,
 };
 
+static void fanotify_free_mark(struct fsnotify_mark *fsn_mark)
+{
+	kmem_cache_free(fanotify_mark_cache, fsn_mark);
+}
+
+static int fanotify_find_path(int dfd, const char __user *filename,
+			      struct path *path, unsigned int flags)
+{
+	int ret;
+
+	pr_debug("%s: dfd=%d filename=%p flags=%x\n", __func__,
+		 dfd, filename, flags);
+
+	if (filename == NULL) {
+		struct file *file;
+		int fput_needed;
+
+		ret = -EBADF;
+		file = fget_light(dfd, &fput_needed);
+		if (!file)
+			goto out;
+
+		ret = -ENOTDIR;
+		if ((flags & FAN_MARK_ONLYDIR) &&
+		    !(S_ISDIR(file->f_path.dentry->d_inode->i_mode))) {
+			fput_light(file, fput_needed);
+			goto out;
+		}
+
+		*path = file->f_path;
+		path_get(path);
+		fput_light(file, fput_needed);
+	} else {
+		unsigned int lookup_flags = 0;
+
+		if (!(flags & FAN_MARK_DONT_FOLLOW))
+			lookup_flags |= LOOKUP_FOLLOW;
+		if (flags & FAN_MARK_ONLYDIR)
+			lookup_flags |= LOOKUP_DIRECTORY;
+
+		ret = user_path_at(dfd, filename, lookup_flags, path);
+		if (ret)
+			goto out;
+	}
+
+	/* you can only watch an inode if you have read permissions on it */
+	ret = inode_permission(path->dentry->d_inode, MAY_READ);
+	if (ret)
+		path_put(path);
+out:
+	return ret;
+}
+
+static int fanotify_remove_mark(struct fsnotify_group *group,
+				struct inode *inode,
+				__u32 mask)
+{
+	struct fsnotify_mark *fsn_mark;
+	__u32 new_mask;
+
+	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__,
+		 group, inode, mask);
+
+	fsn_mark = fsnotify_find_mark(group, inode);
+	if (!fsn_mark)
+		return -ENOENT;
+
+	spin_lock(&fsn_mark->lock);
+	fsn_mark->mask &= ~mask;
+	new_mask = fsn_mark->mask;
+	spin_unlock(&fsn_mark->lock);
+
+	if (!new_mask)
+		fsnotify_destroy_mark(fsn_mark);
+	else
+		fsnotify_recalc_inode_mask(inode);
+
+	fsnotify_recalc_group_mask(group);
+
+	/* matches the fsnotify_find_mark() */
+	fsnotify_put_mark(fsn_mark);
+
+	return 0;
+}
+
+static int fanotify_add_mark(struct fsnotify_group *group,
+			     struct inode *inode,
+			     __u32 mask)
+{
+	struct fsnotify_mark *fsn_mark;
+	__u32 old_mask, new_mask;
+	int ret;
+
+	pr_debug("%s: group=%p inode=%p mask=%x\n", __func__,
+		 group, inode, mask);
+
+	fsn_mark = fsnotify_find_mark(group, inode);
+	if (!fsn_mark) {
+		struct fsnotify_mark *new_fsn_mark;
+
+		ret = -ENOMEM;
+		new_fsn_mark = kmem_cache_alloc(fanotify_mark_cache, GFP_KERNEL);
+		if (!new_fsn_mark)
+			goto out;
+
+		fsnotify_init_mark(new_fsn_mark, fanotify_free_mark);
+		ret = fsnotify_add_mark(new_fsn_mark, group, inode, 0);
+		if (ret) {
+			fanotify_free_mark(new_fsn_mark);
+			goto out;
+		}
+
+		fsn_mark = new_fsn_mark;
+	}
+
+	ret = 0;
+
+	spin_lock(&fsn_mark->lock);
+	old_mask = fsn_mark->mask;
+	fsn_mark->mask |= mask;
+	new_mask = fsn_mark->mask;
+	spin_unlock(&fsn_mark->lock);
+
+	/* we made changes to a mask, update the group mask and the inode mask
+	 * so things happen quickly. */
+	if (old_mask != new_mask) {
+		/* more bits in old than in new? */
+		int dropped = (old_mask & ~new_mask);
+		/* more bits in this mark than the inode's mask? */
+		int do_inode = (new_mask & ~inode->i_fsnotify_mask);
+		/* more bits in this mark than the group? */
+		int do_group = (new_mask & ~group->mask);
+
+		/* update the inode with this new mark */
+		if (dropped || do_inode)
+			fsnotify_recalc_inode_mask(inode);
+
+		/* update the group mask with the new mask */
+		if (dropped || do_group)
+			fsnotify_recalc_group_mask(group);
+	}
+
+	/* match the init or the find.... */
+	fsnotify_put_mark(fsn_mark);
+out:
+	return ret;
+}
+
+static int fanotify_update_mark(struct fsnotify_group *group,
+				struct inode *inode, int flags,
+				__u32 mask)
+{
+	pr_debug("%s: group=%p inode=%p flags=%x mask=%x\n", __func__,
+		 group, inode, flags, mask);
+
+	if (flags & FAN_MARK_ADD)
+		fanotify_add_mark(group, inode, mask);
+	else if (flags & FAN_MARK_REMOVE)
+		fanotify_remove_mark(group, inode, mask);
+	else
+		BUG();
+
+	return 0;
+}
+
+static bool fanotify_mark_validate_input(int flags,
+					 __u32 mask)
+{
+	pr_debug("%s: flags=%x mask=%x\n", __func__, flags, mask);
+
+	/* are flags valid of this operation? */
+	if (!fanotify_mark_flags_valid(flags))
+		return false;
+	/* is the mask valid? */
+	if (!fanotify_mask_valid(mask))
+		return false;
+	return true;
+}
+
 /* fanotify syscalls */
 SYSCALL_DEFINE3(fanotify_init, unsigned int, flags, unsigned int, event_f_flags,
 		int, priority)
@@ -74,5 +259,57 @@ out_put_group:
 SYSCALL_DEFINE5(fanotify_mark, int, fanotify_fd, unsigned int, flags,
 		int, dfd, const char  __user *, pathname, __u64, mask)
 {
-	return -ENOSYS;
+	struct inode *inode;
+	struct fsnotify_group *group;
+	struct file *filp;
+	struct path path;
+	int ret, fput_needed;
+
+	pr_debug("%s: fanotify_fd=%d flags=%x dfd=%d pathname=%p mask=%llx\n",
+		 __func__, fanotify_fd, flags, dfd, pathname, mask);
+
+	/* we only use the lower 32 bits as of right now. */
+	if (mask & ((__u64)0xffffffff << 32))
+		return -EINVAL;
+
+	if (!fanotify_mark_validate_input(flags, mask))
+		return -EINVAL;
+
+	filp = fget_light(fanotify_fd, &fput_needed);
+	if (unlikely(!filp))
+		return -EBADF;
+
+	/* verify that this is indeed an fanotify instance */
+	ret = -EINVAL;
+	if (unlikely(filp->f_op != &fanotify_fops))
+		goto fput_and_out;
+
+	ret = fanotify_find_path(dfd, pathname, &path, flags);
+	if (ret)
+		goto fput_and_out;
+
+	/* inode held in place by reference to path; group by fget on fd */
+	inode = path.dentry->d_inode;
+	group = filp->private_data;
+
+	/* create/update an inode mark */
+	ret = fanotify_update_mark(group, inode, flags, mask);
+
+	path_put(&path);
+fput_and_out:
+	fput_light(filp, fput_needed);
+	return ret;
+}
+
+/*
+ * fanotify_user_setup - Our initialization function.  Note that we cannnot return
+ * error because we have compiled-in VFS hooks.  So an (unlikely) failure here
+ * must result in panic().
+ */
+static int __init fanotify_user_setup(void)
+{
+	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
+
+	return 0;
 }
+device_initcall(fanotify_user_setup);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 00bc6d4..95aeea2 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -18,10 +18,23 @@
 /* helper events */
 #define FAN_CLOSE		(FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE) /* close */
 
+/* flags used for fanotify_init() */
 #define FAN_CLOEXEC		0x00000001
 #define FAN_NONBLOCK		0x00000002
 
 #define FAN_ALL_INIT_FLAGS	(FAN_CLOEXEC | FAN_NONBLOCK)
+
+/* flags used for fanotify_modify_mark() */
+#define FAN_MARK_ADD		0x00000001
+#define FAN_MARK_REMOVE		0x00000002
+#define FAN_MARK_DONT_FOLLOW	0x00000004
+#define FAN_MARK_ONLYDIR	0x00000008
+
+#define FAN_ALL_MARK_FLAGS	(FAN_MARK_ADD |\
+				 FAN_MARK_REMOVE |\
+				 FAN_MARK_DONT_FOLLOW |\
+				 FAN_MARK_ONLYDIR)
+
 /*
  * All of the events - we build the list by hand so that we can add flags in
  * the future and not break backward compatibility.  Apps will get only the

