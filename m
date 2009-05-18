Return-Path: <linux-kernel-owner+w=401wt.eu-S1757359AbZERQLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359AbZERQLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZERQL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:11:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:41556 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756179AbZERQJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:09:37 -0400
From: Jan Blunck <jblunck@suse.de>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: viro@zeniv.linux.org.uk, bharata@in.ibm.com, dwmw2@infradead.org,
       mszeredi@suse.cz, vaurora@redhat.com
Subject: [PATCH 32/32] union-mount: Copy up directory entries on first readdir()
Date: Mon, 18 May 2009 18:09:28 +0200
Message-Id: <1242662968-11684-33-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1242662968-11684-1-git-send-email-jblunck@suse.de>
References: <1242662968-11684-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Valerie Aurora (Henson) <vaurora@redhat.com>

readdir() in union mounts is implemented by copying up all visible
directory entries from the lower level directories to the topmost
directory.  Directory entries that refer to lower level file system
objects are marked as "fallthru" in the topmost directory.

Signed-off-by: Valerie Aurora (Henson) <vaurora@redhat.com>
---
 fs/readdir.c          |   16 +++++
 fs/union.c            |  166 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/union.h |    2 +
 3 files changed, 184 insertions(+), 0 deletions(-)

diff --git a/fs/readdir.c b/fs/readdir.c
index 3a48491..903104a 100644
--- a/fs/readdir.c
+++ b/fs/readdir.c
@@ -16,6 +16,7 @@
 #include <linux/security.h>
 #include <linux/syscalls.h>
 #include <linux/unistd.h>
+#include <linux/union.h>
 
 #include <asm/uaccess.h>
 
@@ -36,9 +37,24 @@ int vfs_readdir(struct file *file, filldir_t filler, void *buf)
 
 	res = -ENOENT;
 	if (!IS_DEADDIR(inode)) {
+		/*
+		 * XXX Think harder about locking for
+		 * union_copyup_dir.  Currently we lock the topmost
+		 * directory and hold that lock while sequentially
+		 * acquiring and dropping locks for the directories
+		 * below this one in the union stack.
+		 */
+		if (is_unionized(file->f_path.dentry, file->f_path.mnt) &&
+		    !IS_OPAQUE(inode)) {
+			res = union_copyup_dir(&file->f_path);
+			if (res)
+				goto out_unlock;
+		}
+
 		res = file->f_op->readdir(file, buf, filler);
 		file_accessed(file);
 	}
+out_unlock:
 	mutex_unlock(&inode->i_mutex);
 out:
 	return res;
diff --git a/fs/union.c b/fs/union.c
index d21fe5f..0c3c000 100644
--- a/fs/union.c
+++ b/fs/union.c
@@ -5,6 +5,7 @@
  * Copyright (C) 2007-2009 Novell Inc.
  *
  *   Author(s): Jan Blunck (j.blunck@tu-harburg.de)
+ *              Valerie Aurora <vaurora@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms of the GNU General Public License as published by the Free
@@ -780,3 +781,168 @@ void detach_mnt_union(struct vfsmount *mnt)
 	union_put(um);
 	return;
 }
+
+/**
+ * union_copyup_dir_one - copy up a single directory entry
+ *
+ * Individual directory entry copyup function for union_copyup_dir.
+ * We get the entries from higher level layers first.
+ */
+
+static int union_copyup_dir_one(void *buf, const char *name, int namlen,
+				loff_t offset, u64 ino, unsigned int d_type)
+{
+	struct dentry *topmost_dentry = (struct dentry *) buf;
+	struct dentry *dentry;
+	int err = 0;
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
+	/* Lookup this entry in the topmost directory */
+	dentry = lookup_one_len(name, topmost_dentry, namlen);
+
+	if (IS_ERR(dentry)) {
+		printk(KERN_INFO "error looking up %s\n", dentry->d_name.name);
+		goto out;
+	}
+
+	/*
+	 * If the entry already exists, one of the following is true:
+	 * it was already copied up (due to an earlier lookup), an
+	 * entry with the same name already exists on the topmost file
+	 * system, it is a whiteout, or it is a fallthru.  In each
+	 * case, the top level entry masks any entries from lower file
+	 * systems, so don't copy up this entry.
+	 */
+	if (dentry->d_inode || d_is_whiteout(dentry) ||
+	    d_is_fallthru(dentry)) {
+		printk(KERN_INFO "skipping copy of %s\n", dentry->d_name.name);
+		goto out_dput;
+	}
+
+	/*
+	 * If the entry doesn't exist, create a fallthru entry in the
+	 * topmost file system.  All possible directory types are
+	 * used, so each file system must implement its own way of
+	 * storing a fallthru entry.
+	 */
+	printk(KERN_INFO "creating fallthru for %s\n", dentry->d_name.name);
+	err = topmost_dentry->d_inode->i_op->fallthru(topmost_dentry->d_inode,
+						      dentry);
+	/* FIXME */
+	BUG_ON(err);
+	/*
+	 * At this point, we have a negative dentry marked as fallthru
+	 * in the cache.  We could potentially lookup the entry lower
+	 * level file system and turn this into a positive dentry
+	 * right now, but it is not clear that would be a performance
+	 * win and adds more opportunities to fail.
+	 */
+out_dput:
+	dput(dentry);
+out:
+	return 0;
+}
+
+/**
+ * union_copyup_dir - copy up low-level directory entries to topmost dir
+ *
+ * readdir() is difficult to support on union file systems for two
+ * reasons: We must eliminate duplicates and apply whiteouts, and we
+ * must return something in f_pos that lets us restart in the same
+ * place when we return.  Our solution is to, on first readdir() of
+ * the directory, copy up all visible entries from the low-level file
+ * systems and mark the entries that refer to low-level file system
+ * objects as "fallthru" entries.
+ */
+
+int union_copyup_dir(struct path *topmost_path)
+{
+	struct dentry *topmost_dentry = topmost_path->dentry;
+	struct path path = *topmost_path;
+	int res = 0;
+
+	/*
+	 * Skip opaque dirs.
+	 */
+	if (IS_OPAQUE(topmost_dentry->d_inode))
+		return 0;
+
+	/*
+	 * Mark this dir opaque to show that we have already copied up
+	 * the lower entries.  Only fallthru entries pass through to
+	 * the underlying file system.
+	 *
+	 * XXX Deal with the lower file system changing.  This could
+	 * be through running a tool over the top level file system to
+	 * make directories transparent again, or we could check the
+	 * mtime of the underlying directory.
+	 */
+
+	topmost_dentry->d_inode->i_flags |= S_OPAQUE;
+	mark_inode_dirty(topmost_dentry->d_inode);
+
+	/*
+	 * Loop through each dir on each level copying up the entries
+	 * to the topmost.
+	 */
+
+	/* Don't drop the caller's reference to the topmost path */
+	path_get(&path);
+	while (follow_union_down(&path.mnt, &path.dentry)) {
+		struct file * ftmp;
+		struct inode * inode;
+
+		/* XXX Permit fallthrus on lower-level? Would need to
+		 * pass in opaque flag to union_copyup_dir_one() and
+		 * only copy up fallthru entries there.  We allow
+		 * fallthrus in lower level opaque directories on
+		 * lookup, so for consistency we should do one or the
+		 * other in both places. */
+		if (IS_OPAQUE(path.dentry->d_inode))
+			break;
+
+		/* dentry_open() doesn't get a path reference itself */
+		path_get(&path);
+		ftmp = dentry_open(path.dentry, path.mnt,
+				   O_RDONLY | O_DIRECTORY | O_NOATIME,
+				   current_cred());
+		if (IS_ERR(ftmp)) {
+			printk (KERN_ERR "unable to open dir %s for "
+				"directory copyup: %ld\n",
+				path.dentry->d_name.name, PTR_ERR(ftmp));
+			continue;
+		}
+
+		inode = path.dentry->d_inode;
+		mutex_lock(&inode->i_mutex);
+
+		res = -ENOENT;
+		if (IS_DEADDIR(inode))
+			goto out_fput;
+		/*
+		 * Read the whole directory, calling our directory
+		 * entry copyup function on each entry.  Pass in the
+		 * topmost dentry as our private data so we can create
+		 * new entries in the topmost directory.
+		 */
+		res = ftmp->f_op->readdir(ftmp, topmost_dentry,
+					  union_copyup_dir_one);
+out_fput:
+		mutex_unlock(&inode->i_mutex);
+		fput(ftmp);
+
+		if (res)
+			break;
+	}
+	path_put(&path);
+	return res;
+}
diff --git a/include/linux/union.h b/include/linux/union.h
index 405baa9..a0656b3 100644
--- a/include/linux/union.h
+++ b/include/linux/union.h
@@ -57,6 +57,7 @@ extern struct dentry *union_create_topmost(struct nameidata *, struct qstr *,
 					   struct path *);
 extern int __union_copyup(struct path *, struct nameidata *, struct path *);
 extern int union_copyup(struct nameidata *, int);
+extern int union_copyup_dir(struct path *path);
 
 #else /* CONFIG_UNION_MOUNT */
 
@@ -74,6 +75,7 @@ extern int union_copyup(struct nameidata *, int);
 #define union_create_topmost(x, y, z)	({ BUG(); (NULL); })
 #define __union_copyup(x, y, z)		({ BUG(); (0); })
 #define union_copyup(x, y)		({ (0); })
+#define union_copyup_dir(x)		({ BUG(); (0); })
 
 #endif	/* CONFIG_UNION_MOUNT */
 #endif	/* __KERNEL__ */
-- 
1.6.1.3

