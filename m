Return-Path: <linux-kernel-owner+w=401wt.eu-S1761063AbXKAXKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761063AbXKAXKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 19:10:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756081AbXKAXIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 19:08:43 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:33807 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755508AbXKAXIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 19:08:41 -0400
Subject: [PATCH 06/27] r-o-bind-mounts-stub-functions
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Thu, 01 Nov 2007 16:08:34 -0700
References: <20071101230826.9A4F6E00@kernel>
In-Reply-To: <20071101230826.9A4F6E00@kernel>
Message-Id: <20071101230834.012D6939@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



This patch adds two function mnt_want_write() and mnt_drop_write().  These are
used like a lock pair around and fs operations that might cause a write to the
filesystem.

Before these can become useful, we must first cover each place in the VFS
where writes are performed with a want/drop pair.  When that is complete, we
can actually introduce code that will safely check the counts before allowing
r/w<->r/o transitions to occur.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---

 linux-2.6.git-dave/fs/namespace.c        |   54 +++++++++++++++++++++++++++++++
 linux-2.6.git-dave/include/linux/mount.h |    3 +
 2 files changed, 57 insertions(+)

diff -puN fs/namespace.c~r-o-bind-mounts-stub-functions fs/namespace.c
--- linux-2.6.git/fs/namespace.c~r-o-bind-mounts-stub-functions	2007-11-01 14:46:08.000000000 -0700
+++ linux-2.6.git-dave/fs/namespace.c	2007-11-01 14:46:08.000000000 -0700
@@ -77,6 +77,60 @@ struct vfsmount *alloc_vfsmnt(const char
 	return mnt;
 }
 
+/*
+ * Most r/o checks on a fs are for operations that take
+ * discrete amounts of time, like a write() or unlink().
+ * We must keep track of when those operations start
+ * (for permission checks) and when they end, so that
+ * we can determine when writes are able to occur to
+ * a filesystem.
+ */
+/**
+ * mnt_want_write - get write access to a mount
+ * @mnt: the mount on which to take a write
+ *
+ * This tells the low-level filesystem that a write is
+ * about to be performed to it, and makes sure that
+ * writes are allowed before returning success.  When
+ * the write operation is finished, mnt_drop_write()
+ * must be called.  This is effectively a refcount.
+ */
+int mnt_want_write(struct vfsmount *mnt)
+{
+	if (__mnt_is_readonly(mnt))
+		return -EROFS;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mnt_want_write);
+
+/**
+ * mnt_drop_write - give up write access to a mount
+ * @mnt: the mount on which to give up write access
+ *
+ * Tells the low-level filesystem that we are done
+ * performing writes to it.  Must be matched with
+ * mnt_want_write() call above.
+ */
+void mnt_drop_write(struct vfsmount *mnt)
+{
+}
+EXPORT_SYMBOL_GPL(mnt_drop_write);
+
+/*
+ * __mnt_is_readonly: check whether a mount is read-only
+ * @mnt: the mount to check for its write status
+ *
+ * This shouldn't be used directly ouside of the VFS.
+ * It does not guarantee that the filesystem will stay
+ * r/w, just that it is right *now*.  This can not and
+ * should not be used in place of IS_RDONLY(inode).
+ */
+int __mnt_is_readonly(struct vfsmount *mnt)
+{
+	return (mnt->mnt_sb->s_flags & MS_RDONLY);
+}
+EXPORT_SYMBOL_GPL(__mnt_is_readonly);
+
 int simple_set_mnt(struct vfsmount *mnt, struct super_block *sb)
 {
 	mnt->mnt_sb = sb;
diff -puN include/linux/mount.h~r-o-bind-mounts-stub-functions include/linux/mount.h
--- linux-2.6.git/include/linux/mount.h~r-o-bind-mounts-stub-functions	2007-11-01 14:46:08.000000000 -0700
+++ linux-2.6.git-dave/include/linux/mount.h	2007-11-01 14:46:08.000000000 -0700
@@ -70,9 +70,12 @@ static inline struct vfsmount *mntget(st
 	return mnt;
 }
 
+extern int mnt_want_write(struct vfsmount *mnt);
+extern void mnt_drop_write(struct vfsmount *mnt);
 extern void mntput_no_expire(struct vfsmount *mnt);
 extern void mnt_pin(struct vfsmount *mnt);
 extern void mnt_unpin(struct vfsmount *mnt);
+extern int __mnt_is_readonly(struct vfsmount *mnt);
 
 static inline void mntput(struct vfsmount *mnt)
 {
_
