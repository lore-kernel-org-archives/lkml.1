Return-Path: <linux-kernel-owner+w=401wt.eu-S1755674AbZDZKi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674AbZDZKi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 06:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbZDZKg2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 06:36:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:45755 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721AbZDZKgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 06:36:25 -0400
Message-Id: <20090426102953.580803703@suse.de>
User-Agent: quilt/0.46_cvs20080326-19.1
Date: Sun, 26 Apr 2009 20:25:56 +1000
From: npiggin@suse.de
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 4/5] fs: move mark_files_ro into file_table.c
References: <20090426102552.947523845@suse.de>
Content-Disposition: inline; filename=fs-move-mark_files_ro.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function walks the s_files lock, and operates primarily on the
files in a superblock, so it better belongs here (eg. see also
fs_may_remount_ro).

Signed-off-by: Nick Piggin <npiggin@suse.de>
---
 fs/file_table.c |   38 ++++++++++++++++++++++++++++++++++++++
 fs/super.c      |   39 ---------------------------------------
 2 files changed, 38 insertions(+), 39 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c
+++ linux-2.6/fs/file_table.c
@@ -399,6 +399,44 @@ too_bad:
 	return 0;
 }
 
+/**
+ *	mark_files_ro - mark all files read-only
+ *	@sb: superblock in question
+ *
+ *	All files are marked read-only.  We don't care about pending
+ *	delete files so this should be used in 'force' mode only.
+ */
+static void mark_files_ro(struct super_block *sb)
+{
+	struct file *f;
+
+retry:
+	file_list_lock();
+	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
+		struct vfsmount *mnt;
+		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
+		       continue;
+		if (!file_count(f))
+			continue;
+		if (!(f->f_mode & FMODE_WRITE))
+			continue;
+		f->f_mode &= ~FMODE_WRITE;
+		if (file_check_writeable(f) != 0)
+			continue;
+		file_release_write(f);
+		mnt = mntget(f->f_path.mnt);
+		file_list_unlock();
+		/*
+		 * This can sleep, so we can't hold
+		 * the file_list_lock() spinlock.
+		 */
+		mnt_drop_write(mnt);
+		mntput(mnt);
+		goto retry;
+	}
+	file_list_unlock();
+}
+
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c
+++ linux-2.6/fs/super.c
@@ -588,45 +588,6 @@ out:
 }
 
 /**
- *	mark_files_ro - mark all files read-only
- *	@sb: superblock in question
- *
- *	All files are marked read-only.  We don't care about pending
- *	delete files so this should be used in 'force' mode only.
- */
-
-static void mark_files_ro(struct super_block *sb)
-{
-	struct file *f;
-
-retry:
-	file_list_lock();
-	list_for_each_entry(f, &sb->s_files, f_u.fu_list) {
-		struct vfsmount *mnt;
-		if (!S_ISREG(f->f_path.dentry->d_inode->i_mode))
-		       continue;
-		if (!file_count(f))
-			continue;
-		if (!(f->f_mode & FMODE_WRITE))
-			continue;
-		f->f_mode &= ~FMODE_WRITE;
-		if (file_check_writeable(f) != 0)
-			continue;
-		file_release_write(f);
-		mnt = mntget(f->f_path.mnt);
-		file_list_unlock();
-		/*
-		 * This can sleep, so we can't hold
-		 * the file_list_lock() spinlock.
-		 */
-		mnt_drop_write(mnt);
-		mntput(mnt);
-		goto retry;
-	}
-	file_list_unlock();
-}
-
-/**
  *	do_remount_sb - asks filesystem to change mount options.
  *	@sb:	superblock in question
  *	@flags:	numeric part of options


