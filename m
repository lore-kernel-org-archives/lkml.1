Return-Path: <linux-kernel-owner+w=401wt.eu-S1754328AbXIQSck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754328AbXIQSck (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:32:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756273AbXIQS1t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:27:49 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:37918 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756248AbXIQS1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:27:47 -0400
Subject: [PATCH 04/24] r/o bind mounts: stub functions
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Dave Hansen <haveblue@us.ibm.com>
From: Dave Hansen <haveblue@us.ibm.com>
Date: Mon, 17 Sep 2007 11:27:23 -0700
References: <20070917182718.70494C9B@kernel>
In-Reply-To: <20070917182718.70494C9B@kernel>
Message-Id: <20070917182723.3DC633F9@kernel>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


This patch adds two function mnt_want_write() and
mnt_drop_write().  These are used like a lock pair around
and fs operations that might cause a write to the filesystem.

Before these can become useful, we must first cover each
place in the VFS where writes are performed with a
want/drop pair.  When that is complete, we can actually
introduce code that will safely check the counts before
allowing r/w<->r/o transitions to occur.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namespace.c        |   46 +++++++++++++++++++++++++++++++++++++++++
 lxc-dave/include/linux/mount.h |    3 ++
 2 files changed, 49 insertions(+)

diff -puN fs/namespace.c~add-vfsmount-writer-count fs/namespace.c
--- lxc/fs/namespace.c~add-vfsmount-writer-count	2007-09-17 09:43:57.000000000 -0700
+++ lxc-dave/fs/namespace.c	2007-09-17 09:43:57.000000000 -0700
@@ -80,6 +80,52 @@ struct vfsmount *alloc_vfsmnt(const char
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
+/*
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
+/*
+ * Tells the low-level filesystem that we are done
+ * performing a write to it.  Must be matched with
+ * mnt_want_write() call above.
+ */
+void mnt_drop_write(struct vfsmount *mnt)
+{
+}
+EXPORT_SYMBOL_GPL(mnt_drop_write);
+
+/*
+ * This shouldn't be used directly ouside of the VFS.
+ * It does not guarantee that the filesystem will stay
+ * r/w, just that it is right *now*e
+ * mnt_want/drop_write() will _keep_ the filesystem
+ * r/w.
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
diff -puN include/linux/mount.h~add-vfsmount-writer-count include/linux/mount.h
--- lxc/include/linux/mount.h~add-vfsmount-writer-count	2007-09-17 09:43:57.000000000 -0700
+++ lxc-dave/include/linux/mount.h	2007-09-17 09:43:57.000000000 -0700
@@ -74,9 +74,12 @@ static inline struct vfsmount *mntget(st
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
