Return-Path: <linux-kernel-owner+w=401wt.eu-S1946776AbXBJAKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946776AbXBJAKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:10:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946779AbXBJAKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:10:16 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:38541 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946776AbXBJAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:10:13 -0500
Subject: Re: [PATCH 02/22] r/o bind mounts: add vfsmount writer counts
From: Dave Hansen <hansendc@us.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, hch@infradead.org,
       "David C. Hansen [imap]" <haveblue@us.ibm.com>
In-Reply-To: <45CD069C.20606@cosmosbay.com>
References: <20070209225329.27619A62@localhost.localdomain>
	 <20070209225330.42133693@localhost.localdomain>
	 <45CD069C.20606@cosmosbay.com>
Content-Type: text/plain
Date: Fri, 09 Feb 2007 16:10:07 -0800
Message-Id: <1171066207.24675.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-02-10 at 00:41 +0100, Eric Dumazet wrote:
> Dave, please read again this comment in struct vfsmount definition.
> 
> If I understand your infrastructure, mnt=5Fwriters is going to be frequently
> modified, so it should be placed at the end of struct vfsmount, in the same
> cache line than mnt_count.

That's an excellent point, thanks for catching it.  Here's an updated
patch.

-- Dave

This patch actually adds the mount and superblock writer
counts, and the mnt_want/drop_write() functions that use
them.

Before these can become useful, we must first cover each
place in the VFS where writes are performed with a
want/drop pair.  When that is complete, we can actually
introduce code that will safely check the counts before
allowing r/w<->r/o transitions to occur.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namespace.c        |   53 +++++++++++++++++++++++++++++++++++++++++
 lxc-dave/fs/super.c            |   18 ++++++++++---
 lxc-dave/include/linux/fs.h    |    2 +
 lxc-dave/include/linux/mount.h |   28 +++++++++++++++++++--
 4 files changed, 94 insertions(+), 7 deletions(-)

diff -puN fs/namespace.c~03-24-add-vfsmount-writer-count fs/namespace.c
--- lxc/fs/namespace.c~03-24-add-vfsmount-writer-count	2007-02-09 16:04:40.000000000 -0800
+++ lxc-dave/fs/namespace.c	2007-02-09 16:04:40.000000000 -0800
@@ -58,6 +58,7 @@ struct vfsmount *alloc_vfsmnt(const char
 	if (mnt) {
 		mnt->mnt_user_ns = get_user_ns(current->nsproxy->user_ns);
 		atomic_set(&mnt->mnt_count, 1);
+		mnt->mnt_writers = 0;
 		INIT_LIST_HEAD(&mnt->mnt_hash);
 		INIT_LIST_HEAD(&mnt->mnt_child);
 		INIT_LIST_HEAD(&mnt->mnt_mounts);
@@ -78,6 +79,56 @@ struct vfsmount *alloc_vfsmnt(const char
 	return mnt;
 }
 
+int mnt_make_readonly(struct vfsmount *mnt)
+{
+	int ret = 0;
+
+	WARN_ON(__mnt_is_readonly(mnt));
+
+	/*
+	 * This flag set is actually redundant with what
+	 * happens in do_remount(), but since we do this
+	 * under the lock, anyone attempting to get a write
+	 * on it after this will fail.
+	 */
+	spin_lock(&mnt->mnt_sb->s_mnt_writers_lock);
+	if (!mnt->mnt_writers)
+		mnt->mnt_flags |= MNT_READONLY;
+	else
+		ret = -EBUSY;
+	spin_unlock(&mnt->mnt_sb->s_mnt_writers_lock);
+	return ret;
+}
+
+int mnt_want_write(struct vfsmount *mnt)
+{
+	int ret = 0;
+
+	spin_lock(&mnt->mnt_sb->s_mnt_writers_lock);
+	if (mnt->mnt_writers)
+		goto out;
+
+	if (__mnt_is_readonly(mnt)) {
+		ret = -EROFS;
+		goto out;
+	}
+	mnt->mnt_sb->s_writers++;
+	mnt->mnt_writers++;
+out:
+	spin_unlock(&mnt->mnt_sb->s_mnt_writers_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(mnt_want_write);
+
+void mnt_drop_write(struct vfsmount *mnt)
+{
+	spin_lock(&mnt->mnt_sb->s_mnt_writers_lock);
+	mnt->mnt_sb->s_writers--;
+	mnt->mnt_writers--;
+	spin_unlock(&mnt->mnt_sb->s_mnt_writers_lock);
+}
+EXPORT_SYMBOL_GPL(mnt_drop_write);
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
@@ -1415,6 +1466,8 @@ long do_mount(char *dev_name, char *dir_
 		((char *)data_page)[PAGE_SIZE - 1] = 0;
 
 	/* Separate the per-mountpoint flags */
+	if (flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
 	if (flags & MS_NOSUID)
 		mnt_flags |= MNT_NOSUID;
 	if (flags & MS_NODEV)
diff -puN fs/super.c~03-24-add-vfsmount-writer-count fs/super.c
--- lxc/fs/super.c~03-24-add-vfsmount-writer-count	2007-02-09 16:04:40.000000000 -0800
+++ lxc-dave/fs/super.c	2007-02-09 16:04:40.000000000 -0800
@@ -93,6 +93,8 @@ static struct super_block *alloc_super(s
 		s->s_qcop = sb_quotactl_ops;
 		s->s_op = &default_op;
 		s->s_time_gran = 1000000000;
+		s->s_writers = 0;
+		spin_lock_init(&s->s_mnt_writers_lock);
 	}
 out:
 	return s;
@@ -576,6 +578,11 @@ static void mark_files_ro(struct super_b
 	file_list_unlock();
 }
 
+static int sb_remount_ro(struct super_block *sb)
+{
+	return fs_may_remount_ro(sb);
+}
+
 /**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
@@ -587,7 +594,8 @@ static void mark_files_ro(struct super_b
  */
 int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 {
-	int retval;
+	int retval = 0;
+	int sb_started_ro = (sb->s_flags & MS_RDONLY);
 	
 #ifdef CONFIG_BLOCK
 	if (!(flags & MS_RDONLY) && bdev_read_only(sb->s_bdev))
@@ -600,11 +608,13 @@ int do_remount_sb(struct super_block *sb
 
 	/* If we are remounting RDONLY and current sb is read/write,
 	   make sure there are no rw files opened */
-	if ((flags & MS_RDONLY) && !(sb->s_flags & MS_RDONLY)) {
+	if ((flags & MS_RDONLY) && !sb_started_ro) {
 		if (force)
 			mark_files_ro(sb);
-		else if (!fs_may_remount_ro(sb))
-			return -EBUSY;
+		else
+			retval = sb_remount_ro(sb);
+		if (retval)
+			return retval;
 	}
 
 	if (sb->s_op->remount_fs) {
diff -puN include/linux/fs.h~03-24-add-vfsmount-writer-count include/linux/fs.h
--- lxc/include/linux/fs.h~03-24-add-vfsmount-writer-count	2007-02-09 16:04:40.000000000 -0800
+++ lxc-dave/include/linux/fs.h	2007-02-09 16:04:40.000000000 -0800
@@ -972,6 +972,8 @@ struct super_block {
 	struct list_head	s_io;		/* parked for writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct list_head	s_files;
+	int			s_writers;	/* number of files open for write */
+	spinlock_t		s_mnt_writers_lock; /* taken when mounts change rw state */
 
 	struct block_device	*s_bdev;
 	struct list_head	s_instances;
diff -puN include/linux/mount.h~03-24-add-vfsmount-writer-count include/linux/mount.h
--- lxc/include/linux/mount.h~03-24-add-vfsmount-writer-count	2007-02-09 16:04:40.000000000 -0800
+++ lxc-dave/include/linux/mount.h	2007-02-09 16:07:28.000000000 -0800
@@ -29,6 +29,7 @@ struct user_namespace;
 #define MNT_NOATIME	0x08
 #define MNT_NODIRATIME	0x10
 #define MNT_RELATIME	0x20
+#define MNT_READONLY	0x40 /* does the user want this to be r/o? */
 
 #define MNT_SHRINKABLE	0x100
 
@@ -57,12 +58,14 @@ struct vfsmount {
 	struct mnt_namespace *mnt_ns;	/* containing namespace */
 	struct user_namespace *mnt_user_ns; /* namespace for uid interpretation */
 	/*
-	 * We put mnt_count & mnt_expiry_mark at the end of struct vfsmount
-	 * to let these frequently modified fields in a separate cache line
-	 * (so that reads of mnt_flags wont ping-pong on SMP machines)
+	 * We put mnt_count, mnt_expiry_mark, and mnt_writers at the end of
+	 * struct vfsmount to let these frequently modified fields in a
+	 * separate cache line (so that reads of mnt_flags wont ping-pong
+	 * on SMP machines)
 	 */
 	atomic_t mnt_count;
 	int mnt_expiry_mark;		/* true if marked for expiry */
+	int mnt_writers;		/* nr files open for write */
 	int mnt_pinned;
 };
 
@@ -72,7 +75,26 @@ static inline struct vfsmount *mntget(st
 		atomic_inc(&mnt->mnt_count);
 	return mnt;
 }
+/*
+ * This is temporary for now.  We also don't want to check
+ * the SB in because it is already checked in other
+ * code paths.  We'll have a better way to do this in
+ * the end of this series
+ */
+static inline int __mnt_is_readonly(struct vfsmount *mnt)
+{
+	return mnt->mnt_flags & MNT_READONLY;
+}
+
+static inline void __mnt_unmake_readonly(struct vfsmount *mnt)
+{
+	WARN_ON(!__mnt_is_readonly(mnt));
+	mnt->mnt_flags &= ~MNT_READONLY;
+}
 
+extern int mnt_make_readonly(struct vfsmount *mnt);
+extern int mnt_want_write(struct vfsmount *mnt);
+extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
_


