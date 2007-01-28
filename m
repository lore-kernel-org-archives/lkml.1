Return-Path: <linux-kernel-owner+w=401wt.eu-S932546AbXA1N1k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932546AbXA1N1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 08:27:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932547AbXA1N1j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 08:27:39 -0500
Received: from amsfep16-int.chello.nl ([62.179.120.11]:43561 "EHLO
	amsfep16-int.chello.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbXA1N1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 08:27:39 -0500
X-Greylist: delayed 4610 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jan 2007 08:27:38 EST
Message-Id: <20070128120510.502963000@programming.kicks-ass.net>
References: <20070128115118.837777000@programming.kicks-ass.net>
User-Agent: quilt/0.45-1
Date: Sun, 28 Jan 2007 12:51:23 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@osdl.org>, linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/7] fs: restore previous sb->s_files iteration semantics
Content-Disposition: inline; filename=s_files-barrier.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure no new files will be added when we're inspecting 'all' files. Without
this, files could be added in front while we're iterating and we'd miss those.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/file_table.c              |    9 +++++++++
 fs/super.c                   |    3 +++
 include/linux/fs.h           |    2 ++
 security/selinux/selinuxfs.c |    7 ++++---
 4 files changed, 18 insertions(+), 3 deletions(-)

Index: linux-2.6/fs/file_table.c
===================================================================
--- linux-2.6.orig/fs/file_table.c	2007-01-27 21:07:44.000000000 +0100
+++ linux-2.6/fs/file_table.c	2007-01-27 21:11:12.000000000 +0100
@@ -354,6 +354,12 @@ EXPORT_SYMBOL_GPL(filevec_add_drain_all)
 
 void file_kill(struct file *file)
 {
+	if (file && file->f_mapping && file->f_mapping->host) {
+		struct super_block *sb = file->f_mapping->host->i_sb;
+		if (sb)
+			barrier_sync(&sb->s_barrier);
+	}
+
 	if (file_flag(file, F_SUPERBLOCK)) {
 		void **ptr;
 
@@ -412,6 +418,7 @@ int fs_may_remount_ro(struct super_block
 	struct file *file;
 
 	/* Check that no files are currently opened for writing. */
+	barrier_lock(&sb->s_barrier);
 	filevec_add_drain_all();
 	lock_list_for_each_entry(file, &sb->s_files, f_u.fu_llist) {
 		struct inode *inode = file->f_path.dentry->d_inode;
@@ -424,9 +431,11 @@ int fs_may_remount_ro(struct super_block
 		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
 			goto too_bad;
 	}
+	barrier_unlock(&sb->s_barrier);
 	return 1; /* Tis' cool bro. */
 too_bad:
 	lock_list_for_each_entry_stop(file, f_u.fu_llist);
+	barrier_unlock(&sb->s_barrier);
 	return 0;
 }
 
Index: linux-2.6/fs/super.c
===================================================================
--- linux-2.6.orig/fs/super.c	2007-01-27 21:07:44.000000000 +0100
+++ linux-2.6/fs/super.c	2007-01-27 21:11:12.000000000 +0100
@@ -68,6 +68,7 @@ static struct super_block *alloc_super(s
 		INIT_LIST_HEAD(&s->s_dirty);
 		INIT_LIST_HEAD(&s->s_io);
 		INIT_LOCK_LIST_HEAD(&s->s_files);
+		init_barrier(&s->s_barrier);
 		INIT_LIST_HEAD(&s->s_instances);
 		INIT_HLIST_HEAD(&s->s_anon);
 		INIT_LIST_HEAD(&s->s_inodes);
@@ -568,11 +569,13 @@ static void mark_files_ro(struct super_b
 {
 	struct file *f;
 
+	barrier_lock(&sb->s_barrier);
 	filevec_add_drain_all();
 	lock_list_for_each_entry(f, &sb->s_files, f_u.fu_llist) {
 		if (S_ISREG(f->f_path.dentry->d_inode->i_mode) && file_count(f))
 			f->f_mode &= ~FMODE_WRITE;
 	}
+	barrier_unlock(&sb->s_barrier);
 }
 
 /**
Index: linux-2.6/include/linux/fs.h
===================================================================
--- linux-2.6.orig/include/linux/fs.h	2007-01-27 21:07:44.000000000 +0100
+++ linux-2.6/include/linux/fs.h	2007-01-27 21:11:12.000000000 +0100
@@ -281,6 +281,7 @@ extern int dir_notify_enable;
 #include <linux/init.h>
 #include <linux/pid.h>
 #include <linux/mutex.h>
+#include <linux/barrier.h>
 
 #include <asm/atomic.h>
 #include <asm/semaphore.h>
@@ -950,6 +951,7 @@ struct super_block {
 	struct list_head	s_io;		/* parked for writeback */
 	struct hlist_head	s_anon;		/* anonymous dentries for (nfs) exporting */
 	struct lock_list_head	s_files;
+	struct barrier		s_barrier;
 
 	struct block_device	*s_bdev;
 	struct list_head	s_instances;
Index: linux-2.6/security/selinux/selinuxfs.c
===================================================================
--- linux-2.6.orig/security/selinux/selinuxfs.c	2007-01-27 21:10:48.000000000 +0100
+++ linux-2.6/security/selinux/selinuxfs.c	2007-01-27 21:11:40.000000000 +0100
@@ -963,6 +963,7 @@ static void sel_remove_bools(struct dent
 
 	spin_unlock(&dcache_lock);
 
+	barrier_lock(&sb->s_barrier);
 	filevec_add_drain_all();
 	lock_list_for_each_entry(filp, &sb->s_files, f_u.fu_llist) {
 		struct dentry * dentry = filp->f_path.dentry;
@@ -972,6 +973,7 @@ static void sel_remove_bools(struct dent
 		}
 		filp->f_op = NULL;
 	}
+	barrier_unlock(&sb->s_barrier);
 }
 
 #define BOOL_DIR_NAME "booleans"

--

