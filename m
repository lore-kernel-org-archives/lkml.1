Return-Path: <linux-kernel-owner+w=401wt.eu-S1423366AbXBIW6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423366AbXBIW6t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:58:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423378AbXBIWyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:11 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:47924 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423376AbXBIWxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:48 -0500
Subject: [PATCH 22/22] kill open files traverse on remount ro
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:45 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225345.D9BAC383@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that we have the sb writer count, and all of the
writers marked with mnt_want_write(), we don't need to
go looking at all of the individual open files.

Kill the open files walk, and use the sb writer count.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/file_table.c    |   25 -------------------------
 lxc-dave/fs/super.c         |   13 ++++++++++++-
 lxc-dave/include/linux/fs.h |    2 --
 3 files changed, 12 insertions(+), 28 deletions(-)

diff -puN fs/file_table.c~24-24-kill-open-files-traverse-on-remount-ro fs/file_table.c
--- lxc/fs/file_table.c~24-24-kill-open-files-traverse-on-remount-ro	2007-02-09 14:27:01.000000000 -0800
+++ lxc-dave/fs/file_table.c	2007-02-09 14:27:01.000000000 -0800
@@ -308,31 +308,6 @@ void file_kill(struct file *file)
 	}
 }
 
-int fs_may_remount_ro(struct super_block *sb)
-{
-	struct list_head *p;
-
-	/* Check that no files are currently opened for writing. */
-	file_list_lock();
-	list_for_each(p, &sb->s_files) {
-		struct file *file = list_entry(p, struct file, f_u.fu_list);
-		struct inode *inode = file->f_path.dentry->d_inode;
-
-		/* File with pending delete? */
-		if (inode->i_nlink == 0)
-			goto too_bad;
-
-		/* Writeable file? */
-		if (S_ISREG(inode->i_mode) && (file->f_mode & FMODE_WRITE))
-			goto too_bad;
-	}
-	file_list_unlock();
-	return 1; /* Tis' cool bro. */
-too_bad:
-	file_list_unlock();
-	return 0;
-}
-
 void __init files_init(unsigned long mempages)
 { 
 	int n; 
diff -puN fs/super.c~24-24-kill-open-files-traverse-on-remount-ro fs/super.c
--- lxc/fs/super.c~24-24-kill-open-files-traverse-on-remount-ro	2007-02-09 14:27:01.000000000 -0800
+++ lxc-dave/fs/super.c	2007-02-09 14:27:01.000000000 -0800
@@ -580,7 +580,18 @@ static void mark_files_ro(struct super_b
 
 static int sb_remount_ro(struct super_block *sb)
 {
-	return fs_may_remount_ro(sb);
+	int ret = 0;
+
+	/*
+	 * The r/o flag actually gets set
+	 * by the caller.
+	 */
+	spin_lock(&sb->s_mnt_writers_lock);
+	if (sb->s_writers)
+		ret = -EBUSY;
+	spin_unlock(&sb->s_mnt_writers_lock);
+
+	return ret;
 }
 
 /**
diff -puN include/linux/fs.h~24-24-kill-open-files-traverse-on-remount-ro include/linux/fs.h
--- lxc/include/linux/fs.h~24-24-kill-open-files-traverse-on-remount-ro	2007-02-09 14:27:01.000000000 -0800
+++ lxc-dave/include/linux/fs.h	2007-02-09 14:27:01.000000000 -0800
@@ -1657,8 +1657,6 @@ extern const struct file_operations read
 extern const struct file_operations write_fifo_fops;
 extern const struct file_operations rdwr_fifo_fops;
 
-extern int fs_may_remount_ro(struct super_block *);
-
 #ifdef CONFIG_BLOCK
 /*
  * return READ, READA, or WRITE
_
